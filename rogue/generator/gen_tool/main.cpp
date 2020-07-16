#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include "well_rng.h"
#include "sha512.h"

static const uint8_t PACKET_FRAGMENT_BIT                = (1<<7);
static const uint8_t PACKET_LAST_FRAGMENT_BIT   = (1<<6);
static const uint8_t PACKET_PARITY_BIT                  = (1<<5);
static const uint8_t PACKET_PARITY_BIT_POS              = 5;
static const uint8_t PACKET_HEADER_SIGNATURE    = 0x19;
static const uint8_t PACKET_HEADER_MASK                 = 0x1F;
static const uint8_t PACKET_PARITY_MASK                 = 0xDF;

#define SAMPLE_FS			(5000000)	// 2MS/s samples per second
#define MAX_TIME			(1)
#define MAX_SAMPLE_POINTS		(MAX_TIME * SAMPLE_FS)
#define MAX_SAMPLES			(MAX_SAMPLE_POINTS)

#define SYMBOL_RATE			(2400)	// 2400 symbols per second

#define CLOCKS_PER_SYMBOL		(SAMPLE_FS / SYMBOL_RATE)

#define SAMPLE_ZERO_OFFSET		(0.0)	// Set this to the 0 offset if using unsigned samples

#define AMPLITUDE_VALUE			(24000.0)
#define MAX_AMPLITUDE_VALUE		(32000.0)

#define SYMBOL_1_FREQUENCY		(24000)
#define SYMBOL_0_FREQUENCY		(SYMBOL_1_FREQUENCY+SYMBOL_RATE)

#define PREAMBLE_BIT_COUNT		(32)

#define PI_VALUE                        3.1415926535897932384626433832795

#define AMPLITUDE_MAX_VALUE		(32767.0)

typedef int16_t *tSampleArray;
typedef int16_t tSampleType;

void ReadDevURandomSeed( void )
{
        FILE *pFile;
        uint32_t rngInitData[16];

        pFile = fopen( "/dev/urandom", "rb" );

        if ( !pFile )
        {
                printf( "Couldn't open /dev/urandom reverting to seed.\n" );
                srand( time(NULL) ^ getpid());

                for ( uint32_t i = 0; i < 16; i++ )
                        rngInitData[i] = rand();

                InitWELLRNG512a( rngInitData );

                return;
        }

        if ( fread( rngInitData, sizeof(uint32_t), 16, pFile ) != 16 )
        {
                printf( "Couldn't get enough entropy.  Reverting to seed.\n" );
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
	{
                pInputSamples[i] = AddAWGNToSample( pInputSamples[i], (noisePower * noisePower) );

		if ( i%1000 == 0 )
			printf( "." );
	}
	printf( "\n" );
}

#define ALPHA (0.1)

#define GAUSSIAN_THETA (0.4)

// Gaussian filter the waveform to reduce out of band spectral noise during frequency transitions
// We could precompute the kernel and store it as an array instead of computing it each time... or just be lazy and do it this way
double GaussianFilter( unsigned int clocks_per_symbol, unsigned int idx )
{
        double mean = ((clocks_per_symbol-1) / 2.0);
        double theta = (GAUSSIAN_THETA * mean);

        double x = (double)idx;

        return ( exp( -(((x - mean) / theta) * ((x - mean) / theta)) * 0.5 ) / (theta * sqrt( 2 * M_PI )) ) * mean;
}

void GenerateSubTone( tSampleArray oInputSamples, uint32_t sample_count, double amplitude, uint32_t frequency )
{
	uint32_t i;

	double dPhi = 2.0 * PI_VALUE * (double)frequency / ((double)SAMPLE_FS);

	double dPhaseAccumulator = 0;

	for ( i = 0; i < sample_count; i++ )
	{
		oInputSamples[i] = (oInputSamples[i] + (amplitude * sin( dPhaseAccumulator ))); //  * GaussianFilter( sample_count, i )));

		dPhaseAccumulator += dPhi;
	}
}

double WriteSymbol( tSampleArray oInputSamples, double amplitude, uint8_t symbol, uint32_t sample_num, double &dPhaseAccumulator, double dPhi_S0, double dPhi_S1, uint8_t &lastSymbol )
{
	uint32_t i;
	double dPhi;

	lastSymbol = 3;

	// Calculate a single phase increment for the symbol
	if ( symbol == 0 )
		dPhi = dPhi_S0;
	else
	{
		dPhi = dPhi_S1;
		//amplitude = 0; 
		//amplitude = amplitude * 2.0;
	}

	// printf( "=========== %d ==========\n", symbol );

	// Maintain phase compensation when transitioning between symbols with the phase accumulator (dPhaseAccumulator)
	for ( i = 0; i < CLOCKS_PER_SYMBOL; i++ )
	{
		dPhaseAccumulator += dPhi;

		if ( lastSymbol != symbol )
			oInputSamples[sample_num++] = (tSampleType)(amplitude * sin( dPhaseAccumulator ) * GaussianFilter( CLOCKS_PER_SYMBOL, i ));
		else
			oInputSamples[sample_num++] = (tSampleType)(amplitude * sin( dPhaseAccumulator ));

		// printf( "[%08d]Sample = %d\n", sample_num, oInputSamples[sample_num-1] );
	}


	// Unwrap the phase accumulator (this may cause subtle)
	uint32_t nWraps = (uint32_t)(dPhaseAccumulator / (2.0 * PI_VALUE));
	dPhaseAccumulator -= ((double)nWraps * 2.0 * PI_VALUE);
	
	// printf( "dPh = %f\n", dPhaseAccumulator );

	lastSymbol = symbol;

	return (i);
}

uint32_t GeneratePacket( double amplitude, double phaseStart, tSampleArray oInputSamples, uint32_t sample_pos, uint8_t *pPacketData, uint32_t packetLen, bool bFragmented, bool bLastFragment, uint16_t sequenceNumber, uint8_t fragmentNumber, bool bBadPacket = false )
{
	uint8_t packetDataTemp[256];
	uint16_t packetCRC;
	uint32_t sample_num = sample_pos;
	uint8_t dataVal = 0;
	double dPhaseAccumulator = phaseStart; // 0.0;
	double dPhi_S0, dPhi_S1;	// Phase increment for symbol 0 and symbol 1

	// Precalculate phase increments for each symbol
	dPhi_S0 = 2.0 * PI_VALUE * SYMBOL_0_FREQUENCY / ((double)SAMPLE_FS);
	dPhi_S1 = 2.0 * PI_VALUE * SYMBOL_1_FREQUENCY / ((double)SAMPLE_FS);

	// Calculate CRC
	const uint16_t POLY = 0x8408;

	/*
	//                                      16   12   5
	// this is the CCITT CRC 16 polynomial X  + X  + X  + 1.
	// This works out to be 0x1021, but the way the algorithm works
	// lets us use 0x8408 (the reverse of the bit pattern).  The high
	// bit is always assumed to be set, thus we only use 16 bits to
	// represent the 17 bit value.
	*/
	uint8_t i;
	uint8_t *pData;
	uint32_t length;

	uint8_t lastSymbol = 2;

	if ( bFragmented )
	{
		*((uint16_t*)packetDataTemp) = (((sequenceNumber & 0xFFF) << 4) | (fragmentNumber & 0xF));

		memcpy( packetDataTemp+2, pPacketData, packetLen );
		length = packetLen + 2;
	}
	else
	{
		memcpy( packetDataTemp, pPacketData, packetLen );
		length = packetLen;
	}
	
	pData = packetDataTemp;
	uint32_t data = 0;
	uint32_t crc = 0xffff;

	do
	{
		for ( i=0, data=(unsigned int)0xff & *pData++; i < 8; i++, data >>= 1 )
		{
			if ((crc & 0x0001) ^ (data & 0x0001))
				crc = (crc >> 1) ^ POLY;
			else  
				crc >>= 1;
		}
	} while (--length);

	crc = ~crc;
	data = crc;
	crc = (crc << 8) | (data >> 8 & 0xff);

	packetCRC = (uint16_t)(crc);

	// DONE CRC Calculation

	// Preamble... 32
	{
		uint32_t preambleBitCount = 0;
		for ( ;; )
		{
			sample_num += WriteSymbol( oInputSamples, amplitude, preambleBitCount % 2, sample_num, dPhaseAccumulator, dPhi_S0, dPhi_S1, lastSymbol );
			
			preambleBitCount++;

			if ( preambleBitCount == PREAMBLE_BIT_COUNT )
				break;
		}
	}

	// Byte sync
	{
		uint32_t byteSyncCount = 0;

		for ( ;; )
		{
			dataVal = ((0xC3AC >> (15-(byteSyncCount))) & 0x1);

			sample_num += WriteSymbol( oInputSamples, amplitude, dataVal, sample_num, dPhaseAccumulator, dPhi_S0, dPhi_S1, lastSymbol );
			
			byteSyncCount++;

			if ( byteSyncCount == 16 )
				break;
		}
	}

	// Header
	{
		uint32_t headerBitCount = 0;
		uint8_t headerVal = PACKET_HEADER_SIGNATURE;

		if ( bFragmented )
			headerVal |= PACKET_FRAGMENT_BIT;

		if ( bLastFragment )
			headerVal |= PACKET_LAST_FRAGMENT_BIT;

		// Calculate parity bit
		// Check parity
		uint8_t parity_value = 0;

		for ( uint8_t bitpos = 0; bitpos < 8; bitpos++ )
		{
			if ( (1 << bitpos) & PACKET_PARITY_MASK )
				parity_value += (((headerVal & (1 << bitpos)) >> bitpos) & 0x1);
		}

		// Even or odd
		parity_value = parity_value % 2;

		headerVal |= (parity_value << PACKET_PARITY_BIT_POS);

		for ( ;; )
		{
			dataVal = ((headerVal >> (7-headerBitCount)) & 0x1);

			sample_num += WriteSymbol( oInputSamples, amplitude, dataVal, sample_num, dPhaseAccumulator, dPhi_S0, dPhi_S1, lastSymbol );
			
			headerBitCount++;

			if ( headerBitCount == 8 )
				break;
		}
	}

	// Now write length...
	{
		uint32_t lengthBitCount = 0;
		uint8_t writePacketLength = packetLen;

		if ( bFragmented )
			writePacketLength += 2;

		if ( bBadPacket )
			writePacketLength = 1;

		for ( ;; )
		{
			dataVal = ((writePacketLength >> (7-lengthBitCount)) & 0x1);

			sample_num += WriteSymbol( oInputSamples, amplitude, dataVal, sample_num, dPhaseAccumulator, dPhi_S0, dPhi_S1, lastSymbol );

			lengthBitCount++;

			if ( lengthBitCount == 8 )
				break;
		}
	}

	// If it is fragmented send fragment number and sequence number...
	if ( bFragmented )
	{
		uint16_t fragmentHeaderValue = (((sequenceNumber & 0xFFF) << 4) | (fragmentNumber & 0xF));

		uint8_t fragmentHeaderLSB = (fragmentHeaderValue & 0xFF);
		uint8_t fragmentHeaderMSB = ((fragmentHeaderValue >> 8) & 0xFF);

		uint32_t fragmentHeaderBitCount = 0;

		for ( ;;  )
		{
			dataVal = ((fragmentHeaderLSB >> (7-fragmentHeaderBitCount)) & 0x1);

			sample_num += WriteSymbol( oInputSamples, amplitude, dataVal, sample_num, dPhaseAccumulator, dPhi_S0, dPhi_S1, lastSymbol );

			fragmentHeaderBitCount++;

			if ( fragmentHeaderBitCount == 8 )
				break;
		}

		fragmentHeaderBitCount = 0;
		for ( ;;  )
		{
			dataVal = ((fragmentHeaderMSB >> (7-fragmentHeaderBitCount)) & 0x1);

			sample_num += WriteSymbol( oInputSamples, amplitude, dataVal, sample_num, dPhaseAccumulator, dPhi_S0, dPhi_S1, lastSymbol );

			fragmentHeaderBitCount++;

			if ( fragmentHeaderBitCount == 8 )
				break;
		}
	}

	// Now write packet data
	uint32_t packetBytePos = 0;

	for ( packetBytePos = 0; packetBytePos < packetLen; packetBytePos++ )
	{
		uint8_t packetBitPos = 0;
		
		for ( ;; )
		{
			dataVal = ((pPacketData[packetBytePos] >> (7-packetBitPos)) & 0x1);

			sample_num += WriteSymbol( oInputSamples, amplitude, dataVal, sample_num, dPhaseAccumulator, dPhi_S0, dPhi_S1, lastSymbol );

			packetBitPos++;

			if ( packetBitPos == 8 )
				break;
		}
	}

	// Last -- write CRC
	{
		uint32_t crcBitCount = 0;

		for ( ;; )
		{
			dataVal = ((packetCRC >> (15-crcBitCount)) & 0x1);

			sample_num += WriteSymbol( oInputSamples, amplitude, dataVal, sample_num, dPhaseAccumulator, dPhi_S0, dPhi_S1, lastSymbol );

			crcBitCount++;

			if ( crcBitCount == 16 )
				break;
		}
	}

	return (sample_num);
}

uint32_t GenerateSampleData( tSampleArray oInputSamples, const char *pszString, uint32_t signalPower, double phaseStart )
{
	uint32_t sampleCount = 0;

	uint8_t packetData[256];
	uint8_t packetLen;
	
	memset( packetData, 0x0, 256 );

	*((uint8_t*)(packetData+0)) = 0x90;	// TLVDisplayString
	*((uint16_t*)(packetData+1)) = strlen(pszString);
	
	memcpy( packetData+3, pszString, strlen(pszString) );

	packetLen = (3+strlen(pszString));

	sampleCount = GeneratePacket( (double)signalPower, phaseStart, oInputSamples, sampleCount, packetData, packetLen, false, false, 2, 1 );

	return (sampleCount);
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
		printf( "Failed to open wav file: %s\n", pFilename );
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

int main( int argc, char **argv )
{
	const char *pOutputFilename;
	const char *pSendString;
	int i;
	uint32_t noisePower;
	uint32_t signalPower;

	// Init RNG, TODO: Change this to use SEED environment variable
	//ReadDevURandomSeed();

	if ( argc < 8 )
	{
		printf( "Usage: <output wav file> <string to send> <first packet start time (ns)> <delay between packets (ns)> <number of packets> <signal power> <noise power> <seed string>\n" );
		return 0;
	}



	pOutputFilename = argv[1];
	pSendString = argv[2];

	int packetStartNS = atoi( argv[3] );
	int packetDelayNS = atoi( argv[4] );
	int repeatCount = atoi( argv[5] );

	signalPower = AMPLITUDE_VALUE;
	if ( argc > 6 )
		signalPower = atoi( argv[6] );

	// Prevent clipping -- max value
	if ( signalPower > MAX_AMPLITUDE_VALUE )
	{

		printf( "Warning! Signal Power (%d) too large for digital representation -- clipped to %d\n", signalPower, MAX_AMPLITUDE_VALUE );
		
		signalPower = MAX_AMPLITUDE_VALUE;
	}

	noisePower = 0;
	if ( argc > 7 )
		noisePower = atoi( argv[7] );

	// Make sure there is always noise	
	if ( noisePower == 0 )
		noisePower = 1;

	if ( packetDelayNS > 10000000 )
	{
		printf( "Packet delay too large -- aborting!\n" );
		return (0);
	}

	// Initialize well rng off of SHA-512
	uint32_t rng_init[16];
	SHA512( (uint8_t*)argv[8], strlen(argv[8]), (uint8_t*)rng_init );

	InitWELLRNG512a( rng_init );
	

	// Calculate SNR
	double SNR = 20.0 * (log10( (((double)signalPower) ) / (double)noisePower ));

	double noisePowerDB = 20.0 * (log10( (double)noisePower / (double)AMPLITUDE_MAX_VALUE) );
	double signalPowerDB = 20.0 * (log10( (double)signalPower / (double)AMPLITUDE_MAX_VALUE) );

	printf( "Output file: %s\n", pOutputFilename );
	printf( "Send string (len=%d): %s\n", strlen(pSendString), pSendString );
	printf( "Signal Power:  %5d (%3.2f dB)  Noise Power: %5d (%3.2f dB)  SNR: %3.2f dB\n", signalPower, signalPowerDB, noisePower, noisePowerDB, SNR );

	tSampleType *pOutputSamples = new tSampleType[MAX_SAMPLES];

	memset( pOutputSamples, 0, sizeof(tSampleType)*MAX_SAMPLES );
	
	uint32_t samplePos = (uint32_t)((double)SAMPLE_FS * ((double)packetStartNS/1000000000.0));

	uint32_t sampleDeltaNS = (packetStartNS % (uint32_t)((double)(1.0/SAMPLE_FS) * 1000000000.0));

	double nsPerSample = (1000000000.0/SAMPLE_FS);

	printf( "samplePos: %u\n", samplePos );
	printf( "sampleDeltaNS: %u\n", sampleDeltaNS );

	if ( sampleDeltaNS > 0 )
		samplePos++;

	// Always start with symbol 0
	double phaseStart = (2.0 * PI_VALUE * SYMBOL_0_FREQUENCY / ((double)SAMPLE_FS)) * ((double)(nsPerSample-sampleDeltaNS) / nsPerSample);

	printf( "Phase Offset: %f\n", phaseStart );

	//phaseStart = 0.0;
	//double phaseStart = 0.0;

	for ( i = 0; i < repeatCount; i++ )
	{
		printf( "Sample Offset for Signal: %u (time=%uns)\n", samplePos, packetStartNS );
		samplePos += GenerateSampleData( (pOutputSamples+samplePos), pSendString, signalPower, phaseStart );

		if ( samplePos >= MAX_SAMPLES )
		{
			printf( "Error writing out sample data, possible overflow!\n" );
			break;
		}
		
		samplePos += (uint32_t)((double)SAMPLE_FS * ((double)packetDelayNS/1000000000.0));
	}

	printf( "Adding channel noise (AWGN)\n" );

	// Now add in channel noise -- if they specified it
	AddChannelNoise( pOutputSamples, MAX_SAMPLES, noisePower );

	printf( "Writing wav file\n" );

	// Write out wav file
	write_wav_file( pOutputFilename, MAX_SAMPLES, pOutputSamples );

	printf( "WAV File created.\n" );

	delete [] pOutputSamples;

	return 0;
}
