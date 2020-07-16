/* Declarations and macros for managing simulated time.
   Copyright 2002, 2004 Paul Twohey and Brian Gaeke.

This file is part of VMIPS.

VMIPS is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

VMIPS is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along
with VMIPS; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */

#include "clock.h"
#include "task.h"
#include "error.h"
#include "wipe.h"

#include <algorithm>
#include <cassert>
#include <functional>

using namespace std;


Clock::Clock( const timespec &start_time )
	: time( start_time ), spill_ns(0)
{
	assert( time.tv_sec >= 0 );
	assert( time.tv_nsec >=0 );

	then.tv_sec = -1;
	then.tv_nsec = 0;
}

Clock::~Clock()
{
	for_each( deferred_tasks.begin(), deferred_tasks.end(),
		  wipe< DeferredTasks * > );
}

void Clock::increment_time( long nanoseconds )
{
	assert( nanoseconds > 0 );
	
	timespec increment = { 0, nanoseconds };
	timespecadd( &this->time, &increment );

	if( deferred_tasks.empty() )
		return;

	for( DeferredTasks *tasks = deferred_tasks.front();
	     !deferred_tasks.empty(); tasks = deferred_tasks.front() ) {
		nanoseconds = tasks->pass_time( nanoseconds );
		if( nanoseconds <= 0 ) {
			deferred_tasks.pop_front();
			delete tasks;
		}

		if( nanoseconds >= 0 )
			break;

		nanoseconds = -nanoseconds;
	}
}

void Clock::pass_realtime( uint32 timeratio )
{
	assert( timeratio > 0 );
	
	timeval current;

	// first time pass_realtime() has been called
	if( then.tv_sec == -1 ) {
		gettimeofday( &current, NULL );
		TIMEVAL_TO_TIMESPEC( &current, &then );
	}

	gettimeofday( &current, NULL );
	timespec now;
	TIMEVAL_TO_TIMESPEC( &current, &now );

	timespecsub( &now , &then );
	while( now.tv_sec > 0 ) {
		increment_time( 1000000000 / timeratio );
		now.tv_sec--;
	}

	long increase = (now.tv_nsec + spill_ns) / timeratio;
	if( increase == 0 )
		spill_ns = now.tv_nsec + spill_ns;
	else {
		spill_ns = 0;
		increment_time( increase );
	}

	TIMEVAL_TO_TIMESPEC( &current, &then );
}

void Clock::add_deferred_task( Task *task, long nanoseconds )
{
	assert( task );
	assert( nanoseconds > 0 );
	
	if( deferred_tasks.empty() ) {
		DeferredTasks *t = new DeferredTasks( nanoseconds, task );
		deferred_tasks.push_front( t );
		return;
	}

	long wait_time = nanoseconds;
	for( list< DeferredTasks*>::iterator i = deferred_tasks.begin();
	     i != deferred_tasks.end(); i++ ) {
		wait_time = nanoseconds;
		nanoseconds -= (*i)->get_nanoseconds_left();
		
		// insert a new set of deferred tasks before i
		if( nanoseconds < 0 ) {
			DeferredTasks *tasks=new DeferredTasks(wait_time,task);
			deferred_tasks.insert( i, tasks );

			// decrement the waiting time for the next task by
			// wait_time so the task executes at the right time
			(*i)->pass_time( wait_time );

			return;
		}
		// the wait time for TASK is the same as these tasks
		else if( nanoseconds == 0 ) {
			(*i)->add_task( task );
			return;
		}
	}
	
	DeferredTasks *tasks = new DeferredTasks( nanoseconds, task );
	deferred_tasks.push_back( tasks );
}

timespec Clock::get_time()
{
	return time;
}

void Clock::set_time( const timespec& new_time )
{
	assert( new_time.tv_sec >= 0 && new_time.tv_nsec >= 0 );

	time = new_time;
}


Clock::DeferredTasks::DeferredTasks( long nanoseconds_left, Task *task)
	: nanoseconds_left( nanoseconds_left )
{
	assert( nanoseconds_left > 0 );
	add_task( task );
}

Clock::DeferredTasks::~DeferredTasks()
{
	for_each( tasks.begin(), tasks.end(), wipe< Task * > );
}

void Clock::DeferredTasks::add_task( Task *task )
{
	assert( task );
	tasks.push_back( task );
}

long Clock::DeferredTasks::pass_time( long nanoseconds )
{
	assert( nanoseconds > 0 );
	assert( nanoseconds_left > 0 );
	nanoseconds_left -= nanoseconds;
	
	if( nanoseconds_left <= 0 )
		for_each( tasks.begin(), tasks.end(), mem_fun( &Task::task) );

	return nanoseconds_left;
}

inline long Clock::DeferredTasks::get_nanoseconds_left()
{
	return nanoseconds_left;
}
