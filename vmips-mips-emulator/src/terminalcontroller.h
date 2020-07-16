/* Implementation of an abstract terminal controller.
   Copyright 2002 Paul Twohey.

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

#ifndef _TERMINALCONTROLLER_H_
#define _TERMINALCONTROLLER_H_

#include "devreg.h"
#include "task.h"
#include <new>
#include <sys/types.h>
#include <termios.h>
class Clock;

// XXX Maximum number of terminals the controller supports.
#define	MAX_TERMINALS	16

/* A keyboard can be in one of two states: READY or UNREADY. The state READY
   corresponds to when the keyboard has new data the simulated program hasn't
   yet read. In the READY state the keyboard will check for new data every
   keyboard_repoll_ns nanoseconds and replace the old data with the new data.
   The keyboard transitions to the UNREADY state when the simulated program
   reads the keyboard data. In the UNREADY state the keyboard will poll for
   new data every keyboard_poll_ns nanoseconds. When the keyboard detects
   data it will transition to the READY state. The keyboard is initially in
   the UNREADY state.

   A display can be in one of two states: READY or UNREADY. The state READY
   corresponds to when the display is able to accept a new character to
   write out. The display transitions to the UNREADY state when a character
   is written to the display data register. In the UNREADY state the display
   ignores rights. The display transitions to the READY state after
   display_ready_delay_ns nanoseconds. The display is initially in the READY
   state.
*/

class TerminalController
{
public:
	/* Create a new TerminalController which uses CLOCK as its time base.
	   KEYBOARD_POLL_NS is the positive time in nanoseconds that the
	   keyboards are polled for input. KEYBOARD_REPOLL_NS is the positive
	   time in nanoseconds that a READY keyboard will wait to repoll for
	   data. DISPLAY_READY_DELAY_NS is the positive time in nanoseconds
	   that a display will wait to transition from the UNREADY to the
	   READY state. */
	TerminalController( Clock *clock, long keyboard_poll_ns,
			    long keyboard_repoll_ns,
			    long display_ready_delay_ns );

	/* Reset and close all the terminal file descriptors. */
	virtual ~TerminalController();

	/* Connect the terminal with file descriptor TTY_FD to the simulated
	   terminal line LINE. Save the initial terminal state, then configure
	   the terminal for use as a simulated terminal. The controller now 
	   owns the file descriptor and is responsible for restoring its
	   state and closing it. Returns true if the terminal was connected
	   sucessfully, otherwise closes FD and returns false. */
	virtual bool connect_terminal( int tty_fd, int line );

	/* Remove the terminal on line LINE. Has no effect if there is no
	   terminal on line LINE. Restore the original terminal settings
	   for the line and then close its associated file descriptor. */
	virtual void remove_terminal( int line );

	/* Reinitialize terminals to the state they were in when VMIPS started.
	   This is the opposite of reinitialize_terminals(). */
	virtual void suspend ();

	/* Return true if line LINE is connected, false otherwise. */
	bool line_connected (const int line) const {
      return line >= 0 && line < MAX_TERMINALS && lines[line].tty_fd != -1;
    }

	/* Reinitialize terminals to a state suitable for use as part of a
	   vmips simulation. Useful for restoring tty settings when vmips
	   is moved to the forground after being backgrounded. */
	virtual void reinitialize_terminals();

	/* Poll all the keyboards for new data to read. If data is available
	   read it in and adjust the keyboard state accordingly. For each
	   keyboard with data available, schedule a KeyboardWait object to
	   enforce the simulated delay between data checks. */
	virtual void poll_keyboards();

	/* Helper routine to repoll the keyboard. */
	virtual void repoll_keyboard( int line );

	/* Write characater DATA to the terminal on line LINE and transition
	   the display from the READY and UNREADY states to the UNREADY state.
	   This should only be called for connected lines. */
	virtual void unready_display( int line, char data );

	/* Transition the display on line LINE from the UNREADY state into
	   the READY state. Should only be called for connected lines in the
	   UNREADY state. */
	virtual void ready_display( int line );

	/* Transition the keyboard on line LINE from the READY state into
	   the UNREADY state. Should only be called for connected lines in
	   the the READY state. */ 
	virtual void unready_keyboard( int line );

protected:
	/* Transition the keyboard from the READY or UNREADY states to the
	   READY state. Read data from the keyboard on line LINE. Should only
	   be called on connected lines. */
	virtual void ready_keyboard( int line );

	/* Take connected (or partially connected) line LINE and prepare it
	   for use as part of a simulated console device. Returns true if the
	   preparation was sucessful, false otherwise. */
	virtual bool prepare_tty( int line );

protected:
	class DisplayDelay : public CancelableTask
	{
	public:
		DisplayDelay(TerminalController *controller, int line);
		~DisplayDelay();

	protected:
		/* Make READY display on line LINE on controller CONTROLLER. */
		virtual void real_task();

	protected:
		TerminalController	*controller;
		int			line;
	};

	class KeyboardRepoll : public CancelableTask
	{
	public:
		KeyboardRepoll(TerminalController *controller,int line);
		virtual ~KeyboardRepoll();

	protected:
		/* Repoll keyboard on line LINE of controller CONTROLLER. */
		virtual void real_task();

	protected:
		TerminalController	*controller;
		int			line;
	};

	class KeyboardPoll : public CancelableTask
	{
	public:
		KeyboardPoll(TerminalController *controller);
		virtual ~KeyboardPoll();

	protected:
		/* Poll all unready keyboards for new data. */
		virtual void real_task();

	protected:
		TerminalController	*controller;
	};
	
protected:
	const long	keyboard_poll_ns;	// UNREADY->READY keyboard poll
	const long	keyboard_repoll_ns;	// READY keyboard repoll
	const long	display_ready_delay_ns;	// display READY->UNREADY delay
	
	KeyboardPoll	*keyboard_poll;		// current keyboard poll
	Clock		*clock;
	int		max_fd;			// cache of largest fd + 1
	fd_set		unready_keyboards;	// unready keyboard descriptors

	/* Make a copy of unready_keyboards in SET. */
	void copy_unready_keyboards (fd_set *set) {
		*set = unready_keyboards;
	}
	
	enum State {
		UNREADY	= 0,
		READY	= CTL_RDY,
	};
	
	struct LineState {
		termios		tty_state;
		int		tty_fd;
		KeyboardRepoll	*keyboard_repoll;
		DisplayDelay	*display_delay;
		char		keyboard_char;
		State		keyboard_state;
		State		display_state;
	};

	LineState	lines[ MAX_TERMINALS ];
};

#endif /* _TERMINALCONTROLLER_H_ */
