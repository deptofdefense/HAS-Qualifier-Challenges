#include "common.h"

uint32_t ReadTimerValue( void )
{
        uint32_t readAddress = IOBASE+CLOCK_CONTROL;
        readAddress = 0xa1010000+4;

        return *((uint32_t*)(readAddress));
}

CTimeFrame::CTimeFrame( )
	: m_startTime( 0 )
{
	m_startTime = ReadTimerValue();
}

CTimeFrame::~CTimeFrame()
{

}

uint32_t CTimeFrame::GetStartTime( void )
{
	return (m_startTime);
}

void CTimeFrame::SetStartTime( uint64_t val )
{
	m_startTime = val;
}

uint32_t CTimeFrame::GetFrameNumber( void )
{
	uint32_t curTime = ReadTimerValue();
	return (uint32_t)((curTime - m_startTime) & 0xFFFFFFFF);
}
