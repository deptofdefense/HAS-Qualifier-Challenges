/* Definitions of functions for managing simulated time.
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

#ifndef _CLOCK_H_
#define _CLOCK_H_

#include "task.h"
#include "types.h"
#include <list>
#include <sys/time.h>
class Task;

/* The Clock class manages virtual time. */
class Clock
{
public:
	/* Create a new simulation clock with starting time START_TIME, which
	   should be a positive starting time. */
	Clock( const timespec &start_time );

	/* Destroy the clock object and delete all queued tasks. */
	virtual ~Clock();

	/* Move simulated time forward NANOSECONDS nanoseconds and execute
	   any deferred tasks that have their expiration date before the
	   new time. */
	virtual void increment_time( long nanoseconds );

	/* Increment the simulated clock by the difference from the last
	   call to pass_realtime() and the current time (as determined by
	   gettimeofday(2)) divided by timeratio. */
	virtual void pass_realtime( uint32 timeratio );

	/* Queue task TASK to be executed in NANOSECONDS nanoseconds from the
	   present time. TASK's task() function will be called and then it
	   will be delete'd (possibly after other task's task() functions
	   have been called). */
	virtual void add_deferred_task( Task *task, long nanoseconds );

	/* Return the simulated time as a timespec. */
	virtual timespec get_time();

	/* Set the simulated time to TIME. All components of TIME should be
	   non-negative. */
	virtual void set_time( const timespec &time );

protected:
	/* Each DeferredTasks object is responsible for maintaining a list of
	   tasks to execute in the future. */
	class DeferredTasks
	{
	public:
		/* Create a new DeferredTasks that will come due in
		   NANOSECONDS_LEFT nanoseconds from when it starts
		   pass_time(). Will execute task TASK and any other tasks
		   added later via add_task() in a fifo manner when it comes
		   due. */
		DeferredTasks( long nanoseconds_left, Task *task );

		/* Destory deferred tasks by delete'ing each managed task. */
		virtual ~DeferredTasks();

		/* Add task TASK to the list of tasks to complete when the
		   deferred tasks come due. TASK will be delete'd after it is
		   run. */
		virtual void add_task( Task *task );
	
		/* Mark the passage of NANOSECONDS nanoseconds. If the
		   deferred tasks come due then execute the tasks in the order
		   in which they where added. Returns a number of nanoseconds
		   that, if positive, is the number of nanoseconds left until
		   the deferred tasks come due and if negative, is the number
		   of nanoseconds remaining after the deferred tasks object
		   has used NANOSECONDS. */
		virtual long pass_time( long nanoseconds );

		/* Return the number of nanoseconds of simulated time left
		   before the the deferred tasks will come due. */
		inline virtual long get_nanoseconds_left();

	protected:
		long			nanoseconds_left;
		std::list< Task* >	tasks;
	};

protected:
	timespec			time;	// current simulated time
	timespec			then;	// last gettimeofday(2) time
	long				spill_ns;	// realtime slop
	std::list< DeferredTasks* >	deferred_tasks;
};


/*
 * Define some useful macros for manipulating timespec and timeval
 * structures, if the host operating system doesn't provide them.
 */
#ifndef timespecclear
#define timespecclear(tvp)	((tvp)->tv_sec = (tvp)->tv_nsec = 0)
#endif

#ifndef timespecisset
#define timespecisset(tvp)	((tvp)->tv_sec || (tvp)->tv_nsec)
#endif

#ifndef timespeccmp
#define timespeccmp(tvp, uvp, cmp)					\
	(((tvp)->tv_sec == (uvp)->tv_sec) ?				\
		((tvp)->tv_nsec cmp (uvp)->tv_nsec) :			\
		((tvp)->tv_sec cmp (uvp)->tv_sec))
#endif

#ifdef timespecadd
#undef timespecadd
#endif
#define timespecadd(vvp, uvp)						\
	do {								\
		(vvp)->tv_sec += (uvp)->tv_sec;				\
		(vvp)->tv_nsec += (uvp)->tv_nsec;			\
		if ((vvp)->tv_nsec >= 1000000000) {			\
			(vvp)->tv_sec++;				\
			(vvp)->tv_nsec -= 1000000000;			\
		}							\
	} while (0)

#ifdef timespecsub
#undef timespecsub
#endif
#define timespecsub(vvp, uvp)						\
	do {								\
		(vvp)->tv_sec -= (uvp)->tv_sec;				\
		(vvp)->tv_nsec -= (uvp)->tv_nsec;			\
		if ((vvp)->tv_nsec < 0) {				\
			(vvp)->tv_sec--;				\
			(vvp)->tv_nsec += 1000000000;			\
		}							\
	} while (0)

#ifndef	TIMEVAL_TO_TIMESPEC
#define	TIMEVAL_TO_TIMESPEC(tv, ts)		\
do {						\
	(ts)->tv_sec = (tv)->tv_sec;		\
	(ts)->tv_nsec = (tv)->tv_usec * 1000;	\
} while(0)
#endif

#endif /* _CLOCK_H_ */
