#ifndef __TIME_FRAME_H__
#define __TIME_FRAME_H__

class CTimeFrame
{
public:
	CTimeFrame();
	~CTimeFrame();

	uint32_t GetStartTime( void );
	void SetStartTime( uint64_t );

	uint32_t GetFrameNumber( void );

private:
	uint64_t m_startTime;
};

#endif // TIME_FRAME_H__
