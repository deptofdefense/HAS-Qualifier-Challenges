#include "common.h"
#include "xcorr.h"

#include <sys/select.h>
#include <unistd.h>

typedef int16_t *tSampleArray;
typedef int16_t tSampleType;

void RecvUntil( uint8_t *pBuffer, uint32_t count )
{
	uint32_t pos = 0;

	for ( pos = 0; pos < count; pos++ )
	{
		if ( fread( pBuffer+pos, 1, 1, stdin ) != 1 )
		{
			fprintf(stderr, "Recv error.\n" );
			exit(-1);
			// Exit
		}
	}
}

uint32_t ReadUint32( void )
{
	uint32_t value;

	RecvUntil( (uint8_t*)&value, sizeof(value) );

	return (value);
}

int8_t ReadInt8( void )
{
	int8_t value;

	RecvUntil( (uint8_t*)&value, sizeof(value) );

	return (value);
}

uint8_t ReadUint8( void )
{
	uint8_t value;

	RecvUntil( (uint8_t*)&value, sizeof(value) );

	return (value);
}

void ReadDevURandomSeed( void )
{
        FILE *pFile;
        uint32_t rngInitData[16];

        pFile = fopen( "/dev/urandom", "rb" );

        if ( !pFile )
        {
                fprintf(stderr, "Couldn't open /dev/urandom reverting to seed.\n" );
		srand( time(NULL) ^ getpid());

		for ( uint32_t i = 0; i < 16; i++ )
			rngInitData[i] = rand();

		InitWELLRNG512a( rngInitData );
		
		return;
        }

        if ( fread( rngInitData, sizeof(uint32_t), 16, pFile ) != 16 )
        {
                fprintf(stderr, "Couldn't get enough entropy.  Reverting to seed.\n" );
		for ( uint32_t i = 0; i < 16; i++ )
			rngInitData[i] = rand();

		InitWELLRNG512a( rngInitData );

		return;
        }

        fclose( pFile );
		
	InitWELLRNG512a( rngInitData );
}

tSampleType AddAWGNToSample( tSampleType sample, uint32_t noisePower )
{
	double S, V1, V2;

	do
	{
		double U1 = WELLRNG512a();
		double U2 = WELLRNG512a();

		V1 = (2 * U1) - 1.0;
		V2 = (2 * U2) - 1.0;

		S = (V1 * V1) + (V2 * V2);
	} while ( S >= 1.0 );	

	double X = sqrt( -2.0 * log(S) / S ) * V1;
	// double Y = sqrt( -2.0 * log(S) / S ) * V2;

	int16_t sample_noise = (int16_t)(X * sqrt( (double)noisePower ));

	int16_t test_sample_value = sample;
	test_sample_value += sample_noise;

	return test_sample_value;
}

void AddChannelNoise( tSampleType *pInputSamples, uint32_t sampleCount, uint32_t noisePower )
{	
	// Apply channel noise
	for ( uint32_t i = 0; i < sampleCount; i++ )
		pInputSamples[i] = AddAWGNToSample( pInputSamples[i], (noisePower * noisePower) ); 
}

void write_le32( uint32_t val, FILE *pFile )
{
        fwrite( &val, 1, sizeof(val), pFile );
}

void write_le16( uint16_t val, FILE *pFile )
{
        fwrite( &val, 1, sizeof(val), pFile );
}

void write_le_sample( void *pSampleData, uint8_t sampleSize, FILE *pFile )
{
        fwrite( pSampleData, 1, sampleSize, pFile );
}

void write_wav_file( const char *pFilename, uint32_t numSamples, tSampleArray oInputSamples )
{
        FILE* pWavFile;
        uint32_t sampleRate = SAMPLE_FS;
        uint32_t numChannels = 1;
        uint32_t bytesPerSample = sizeof(tSampleType);
        uint32_t byteRate;

        byteRate = sampleRate * numChannels * bytesPerSample;

        pWavFile = fopen( pFilename, "w" );

        if ( !pWavFile )
        {
                fprintf(stderr, "Failed to open wav file: %s\n", pFilename );
                return;
        }

        // write RIFF header
        fwrite( "RIFF", 1, 4, pWavFile );
        write_le32( (36 + (bytesPerSample * numSamples * numChannels)), pWavFile );

        fwrite( "WAVE", 1, 4, pWavFile );

        // write fmt  subchunk
        fwrite( "fmt ", 1, 4, pWavFile );
        write_le32( 16, pWavFile );   // SubChunk1Size is 16
        write_le16( 1, pWavFile );    // PCM is format 1
        write_le16( numChannels, pWavFile );
        write_le32( sampleRate, pWavFile );
        write_le32( byteRate, pWavFile );
        write_le16( numChannels*bytesPerSample, pWavFile );  // block align
        write_le16( 8*bytesPerSample, pWavFile );  // bits/sample

        // write data subchunk
        fwrite( "data", 1, 4, pWavFile);

        // Write out sample data
        write_le32( (bytesPerSample * numSamples * numChannels), pWavFile );
        for ( int i = 0; i < numSamples; i++ )
        {
                write_le_sample( &(oInputSamples[i]), bytesPerSample, pWavFile );
        }

        fclose( pWavFile );

        return;
}

int32_t read_wav_file( const char *pFilename, uint32_t maxSamples, uint32_t *pSampleRate, tSampleType *pInputSamples )
{
        FILE* pWavFile;

	uint8_t header[4];
	uint32_t bytesTotal;

        pWavFile = fopen( pFilename, "rb" );

        if ( !pWavFile )
        {
                fprintf(stderr, "Failed to open wav file: %s\n", pFilename );
                return (-1);
        }

	// Read RIFF header
        // write RIFF header
        // fwrite( "RIFF", 1, 4, pWavFile );
        // write_le32( (36 + (bytesPerSample * numSamples * numChannels)), pWavFile );
	if ( fread( (void *)header, sizeof(header), 1, pWavFile ) != 1 )
	{
		fprintf(stderr, "Failed to read RIFF header for wav file\n" );
		fclose( pWavFile );

		return (-1);
	}

	if ( header[0] != 'R' || header[1] != 'I' || header[2] != 'F' || header[3] != 'F' )
	{
		fprintf(stderr, "RIFF header missing magic!\n" );
		fclose( pWavFile );

		return (-1);
	}

	if ( fread( (void *)&bytesTotal, sizeof(bytesTotal), 1, pWavFile ) != 1 )
	{
		fprintf(stderr, "Failed to read bytes total in RIFF header\n" );
		fclose( pWavFile );

		return (-1);
	}

	// TODO: Parse bytesTotal
	if ( fread( (void *)header, sizeof(header), 1, pWavFile ) != 1 )
	{
		fprintf(stderr, "WAVE header missing magic!\n" );
		fclose( pWavFile );

		return (-1);
	}

	if ( header[0] != 'W' || header[1] != 'A' || header[2] != 'V' || header[3] != 'E' )
	{
		fprintf(stderr, "WAVE header invalid magic!\n" );
		fclose( pWavFile );

		return (-1);
	}

	if ( fread( (void *)header, sizeof(header), 1, pWavFile ) != 1 )
	{
		fprintf(stderr, "fmt header header missing magic!\n" );
		fclose( pWavFile );

		return (-1);
	}

	if ( header[0] != 'f' || header[1] != 'm' || header[2] != 't' || header[3] != ' ' )
	{
		fprintf(stderr, "fmt header invalid magic!\n" );
		fclose( pWavFile );

		return (-1);
	}

        
	/*	
	write_le32( 16, pWavFile );   // SubChunk1Size is 16
        write_le16( 1, pWavFile );    // PCM is format 1
        write_le16( numChannels, pWavFile );
        write_le32( sampleRate, pWavFile );
        write_le32( byteRate, pWavFile );
        write_le16( numChannels*bytesPerSample, pWavFile );  // block align
        write_le16( 8*bytesPerSample, pWavFile );  // bits/sample
	*/
#pragma pack(push, 4)
	struct waveHdr
	{
		uint32_t subChunkSize;
		uint16_t pcmFormat;
		uint16_t numChannels;
		uint32_t sampleRate;
		uint32_t byteRate;
		uint16_t blockAlign;
		uint16_t bitsPerSample;
	};
#pragma pack(pop)

	struct waveHdr oHdr;

	if ( fread( (void *)&oHdr, sizeof(oHdr), 1, pWavFile ) != 1 )
	{
		fprintf(stderr, "Failed to read wave header!\n" );
		fclose( pWavFile );

		return (-1);
	}	

	if ( oHdr.subChunkSize != 16 )
	{
		fprintf(stderr, "Error subChunkSize is not == 16 (%d)\n", oHdr.subChunkSize );
		fclose( pWavFile );

		return (-1);
	}

	if ( oHdr.pcmFormat != 1 )
	{
		fprintf(stderr, "Error pcmFormat is not == 1 (%d)\n", oHdr.pcmFormat );
		fclose( pWavFile );

		return (-1);
	}

	if ( oHdr.numChannels != 1 )
	{
		fprintf(stderr, "Error numChannels is not == 1 (%d)\n", oHdr.numChannels );
		fclose( pWavFile );

		return (-1);
	}

	(*pSampleRate) = oHdr.sampleRate;
#if 0
	if ( oHdr.sampleRate != 44100 )
	{
		fprintf(stderr, "Error sampleRate is not == 44100 (%d)\n", oHdr.sampleRate );
		fclose( pWavFile );

		return (-1);
	}
#endif

	/*
        // write data subchunk
        fwrite( "data", 1, 4, pWavFile);
	*/

	if ( fread( (void *)header, sizeof(header), 1, pWavFile ) != 1 )
	{
		fprintf(stderr, "data header header missing magic!\n" );
		fclose( pWavFile );

		return (-1);
	}

	if ( header[0] != 'd' || header[1] != 'a' || header[2] != 't' || header[3] != 'a' )
	{
		fprintf(stderr, "data header invalid magic!\n" );
		fclose( pWavFile );

		return (-1);
	}

	uint32_t sampleTotalBytes;

	if ( fread( (void *)&sampleTotalBytes, sizeof(sampleTotalBytes), 1, pWavFile ) != 1 )
	{
		fprintf(stderr, "error reading sampleTotalbytes! possible EOF?\n" );
		fclose( pWavFile );

		return (-1);
	}

	
#if 0 
        // Write out sample data
        write_le32( (bytesPerSample * numSamples * numChannels), pWavFile );
        for ( int i = 0; i < numSamples; i++ )
        {
                write_le_sample( &(oInputSamples[i]), bytesPerSample, pWavFile );
        }
#endif

	uint32_t sampleTotal = sampleTotalBytes / (oHdr.subChunkSize / 8);

	fprintf(stderr, "SampleTotal: %d, SampleTotalBytes: %d\n", sampleTotal, sampleTotalBytes );

	for ( uint32_t i = 0; i < sampleTotal; i++ )
	{
		if ( fread( (void *)&(pInputSamples[i]), sizeof(tSampleType), 1, pWavFile ) != 1 )
		{
			fprintf(stderr, "error reading samples... failed at sample # %d! possible EOF?\n", i );
			fclose( pWavFile );

			return (-1);
		}
	}

        fclose( pWavFile );

        return sampleTotal;
}

typedef struct CORRELATE_SAMPLE_STRUCT
{
	tSampleType samples[MAX_SAMPLE_POINTS];
	uint32_t sampleCount;
} tCorrelateSamples;


void Correlate( tCorrelateSamples *pReferenceSample, tCorrelateSamples *pCorrelateSamples, uint32_t correlateCount, uint32_t skipAmount, uint32_t scanAmount )
{
	uint32_t correlateScanCount = (scanAmount);

	uint32_t correlateWindowSize = (2*correlateScanCount)+1;

	double *pCorrelateResults = new double[correlateWindowSize];

	// Skip amount
	for ( uint32_t iCorrelateNum = 0; iCorrelateNum < correlateCount; iCorrelateNum++ )
	{
		for ( uint32_t i = 0, j = skipAmount; j < pCorrelateSamples[iCorrelateNum].sampleCount; i++, j++ )
			pCorrelateSamples[iCorrelateNum].samples[i] = pCorrelateSamples[iCorrelateNum].samples[j];

		pCorrelateSamples[iCorrelateNum].sampleCount -= skipAmount;
	}

	pReferenceSample->sampleCount -= skipAmount;

	fprintf(stderr, "Scanning from samples %u -> %u\n", skipAmount, scanAmount );

	uint32_t waveform_size = (100000000 / NS_PER_SAMPLE);

	for ( uint32_t iCorrelateNum = 0; iCorrelateNum < correlateCount; iCorrelateNum++ )
	{
		fprintf(stderr, "Correlating %d\n", iCorrelateNum );
		//xcorr( pReferenceSample->samples, pCorrelateSamples[iCorrelateNum].samples, pCorrelateResults, correlateScanCount, 0, 1, 1, pReferenceSample->sampleCount, pCorrelateSamples[iCorrelateNum].sampleCount );
		xcorr( pReferenceSample->samples, pCorrelateSamples[iCorrelateNum].samples, pCorrelateResults, correlateScanCount, 0, 1, 1, waveform_size, pCorrelateSamples[iCorrelateNum].sampleCount );

		double cmax = 0;
		uint32_t correlate_max_sample = 0;

		for ( uint32_t windowCur = 0; windowCur < correlateWindowSize; windowCur++ )
		{
			if ( fabs(pCorrelateResults[windowCur]) > cmax )
			{
				cmax = fabs(pCorrelateResults[windowCur]);
				correlate_max_sample = windowCur;
			}
		}
#if 0
		fprintf(stderr, "Correlate[%d] position[%d] time_offset[%d ns]\n", iCorrelateNum, ((correlateScanCount-correlate_max_sample)+skipAmount), (NS_PER_SAMPLE * ((correlateScanCount-correlate_max_sample)+skipAmount)) );
		printf("%d\n", (NS_PER_SAMPLE * ((correlateScanCount-correlate_max_sample)+skipAmount)) );
#endif
		fprintf(stderr, "Correlate[%d] position[%d] time_offset[%d ns]\n", iCorrelateNum, ((correlate_max_sample)+skipAmount), (NS_PER_SAMPLE * ((correlate_max_sample)+skipAmount)) );
		printf("%d\n", (NS_PER_SAMPLE * ((correlate_max_sample)+skipAmount)) );


	}

	//write_wav_file( "output.wav", pSummedSamples->sampleCount, pSummedSamples->samples );

	delete []pCorrelateResults;
}



int main( int argc, char **argv )
{
	const char *pInputFilename;
	uint32_t correlateCount = 0;
	if ( argc < 4 )
	{
		fprintf(stderr, "Usage: <scan start ns> <scan end ns> <reference recording file> <compare file 1> <compare file 2> ...\n" );

		return (0);
	}

	uint32_t scanStartNS = atoi(argv[1]);
	uint32_t scanEndNS = atoi(argv[2]);

	if ( scanEndNS < scanStartNS )
	{
		fprintf(stderr, "Error, end time must be greater than start time!\n" );

		return (0);
	}

	if ( (scanEndNS - scanStartNS) / 1000000000 > MAX_TIME )
	{
		fprintf(stderr, "Error, scan window exceeding capture size!\n" );

		return (0);
	}

	uint32_t sampleStart = (scanStartNS / NS_PER_SAMPLE);
	uint32_t sampleWindowSize = ((scanEndNS - scanStartNS) / NS_PER_SAMPLE);

	pInputFilename = argv[3];

	// Set it to the number of input files
	correlateCount = argc-4;

	// Setup WELL RNG
	ReadDevURandomSeed();

	// Print banner
	fprintf(stderr, "Provide RF capture in wav format %d samples per second and 16-bit signed integer samples:\n", SAMPLE_FS );
	fprintf(stderr, "Format is [number of samples][capture data ...]\n" );
	fprintf(stderr, "Max capture size is %d seconds: %d samples.\n", MAX_TIME, MAX_SAMPLE_POINTS );
	fprintf(stderr, "Scanning for correlation from time %u to time %u (in nanoseconds)\n", scanStartNS, scanEndNS );

	srand( time(NULL) );

	tCorrelateSamples *pReferenceSamples = new tCorrelateSamples;

	// Read in samples
	int32_t sampleCount;
	
	uint32_t sampleRate;

	sampleCount = read_wav_file( pInputFilename, MAX_SAMPLE_POINTS, &sampleRate, pReferenceSamples->samples );

	if ( sampleCount <= 0 )
	{
		fprintf(stderr, "Failed to read samples! (%d)\n", sampleCount );

		return 0;
	}

	pReferenceSamples->sampleCount = sampleCount;

	// Read in the wav files for the correlation samples
	tCorrelateSamples *pCorrelateSamples = new tCorrelateSamples[correlateCount];

	for ( uint32_t i = 0; i < correlateCount; i++ )
	{
		pInputFilename = argv[i+4];

		sampleCount = read_wav_file( pInputFilename, MAX_SAMPLE_POINTS, &sampleRate, pCorrelateSamples[i].samples );

		if ( sampleCount <= 0 )
		{
			fprintf(stderr, "Failed to read samples! (%d)\n", sampleCount );

			return 0;
		}

		pCorrelateSamples[i].sampleCount = sampleCount;
	}

	// Demodulate
	Correlate( pReferenceSamples, pCorrelateSamples, correlateCount, sampleStart, sampleWindowSize );

	delete []pCorrelateSamples;	
	delete pReferenceSamples;

	return 0;
}
