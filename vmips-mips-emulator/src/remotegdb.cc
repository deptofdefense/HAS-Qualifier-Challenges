/* remotegdb.cc - GNU Debugger glue for VMIPS remote debugger interface.
    Based on
   gdb/remote.c - Remote target communications for serial-line targets
     in custom GDB protocol.

   Copyright 1988, 1991, 1992, 1993, 1994, 1995, 1996, 1997 Free Software
     Foundation, Inc.
   Copyright 2001, 2002, 2003 Brian R. Gaeke.

This file is part of GDB and VMIPS.

VMIPS is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

VMIPS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */

/* This file consists almost entirely of code taken from the GNU debugger
   (gdb) version 4.17, from file gdb/remote.c.  Additions by me (brg) have
   been tagged with my initials.

   See the GDB User Guide for the definitive details of the GDB remote
   protocol.  The following notes correspond to the protocol for GDB
   version 4.17.

   Remote communication protocol.

   A debug packet whose contents are <data>
   is encapsulated for transmission in the form:

	$ <data> # CSUM1 CSUM2

	<data> must be ASCII alphanumeric and cannot include characters
	'$' or '#'.  If <data> starts with two characters followed by
	':', then the existing stubs interpret this as a sequence number.

	CSUM1 and CSUM2 are ascii hex representation of an 8-bit 
	checksum of <data>, the most significant nibble is sent first.
	the hex digits 0-9,a-f are used.

   Receiver responds with:

	+	- if CSUM is correct and ready for next packet
	-	- if CSUM is incorrect

   <data> is as follows:
   Most values are encoded in ascii hex digits.  Signal numbers are according
   to the numbering in target.h.

	Request		Packet

	set thread	Hct...		Set thread for subsequent operations.
					c = 'c' for thread used in step and 
					continue; t... can be -1 for all
					threads.
					c = 'g' for thread used in other
					operations.  If zero, pick a thread,
					any thread.
	reply		OK		for success
			ENN		for an error.

	read registers  g
	reply		XX....X		Each byte of register data
					is described by two hex digits.
					Registers are in the internal order
					for GDB, and the bytes in a register
					are in the same order the machine uses.
			or ENN		for an error.

	write regs	GXX..XX		Each byte of register data
					is described by two hex digits.
	reply		OK		for success
			ENN		for an error

        write reg	Pn...=r...	Write register n... with value r...,
					which contains two hex digits for each
					byte in the register (target byte
					order).
	reply		OK		for success
			ENN		for an error
	(not supported by all stubs).

	read mem	mAA..AA,LLLL	AA..AA is address, LLLL is length.
	reply		XX..XX		XX..XX is mem contents
					Can be fewer bytes than requested
					if able to read only part of the data.
			or ENN		NN is errno

	write mem	MAA..AA,LLLL:XX..XX
					AA..AA is address,
					LLLL is number of bytes,
					XX..XX is data
	reply		OK		for success
			ENN		for an error (this includes the case
					where only part of the data was
					written).

	continue	cAA..AA		AA..AA is address to resume
					If AA..AA is omitted,
					resume at same address.

	step		sAA..AA		AA..AA is address to resume
					If AA..AA is omitted,
					resume at same address.

	continue with	Csig;AA..AA	Continue with signal sig (hex signal
	signal				number).  If ;AA..AA is omitted, resume
					at same address.

	step with	Ssig;AA..AA	Like 'C' but step not continue.
	signal

	last signal     ?               Reply the current reason for stopping.
                                        This is the same reply as is generated
					for step or cont : SAA where AA is the
					signal number.

	detach          D               Reply OK.

	There is no immediate reply to step or cont.
	The reply comes when the machine stops.
	It is		SAA		AA is the signal number.

	or...		TAAn...:r...;n...:r...;n...:r...;
					AA = signal number
					n... = register number (hex)
					  r... = register contents
					n... = `thread'
					  r... = thread process ID.  This is
						 a hex integer.
					n... = other string not starting 
					    with valid hex digit.
					  gdb should ignore this n,r pair
					  and go on to the next.  This way
					  we can extend the protocol.
	or...		WAA		The process exited, and AA is
					the exit status.  This is only
					applicable for certains sorts of
					targets.
	or...		XAA		The process terminated with signal
					AA.
        or...           OXX..XX	XX..XX  is hex encoding of ASCII data. This
					can happen at any time while the program is
					running and the debugger should
					continue to wait for 'W', 'T', etc.

	thread alive	TXX		Find out if the thread XX is alive.
	reply		OK		thread is still alive
			ENN		thread is dead
	
	remote restart	RXX		Restart the remote server

	extended ops 	!		Use the extended remote protocol.
					Sticky -- only needs to be set once.

	kill request	k

	toggle debug	d		toggle debug flag (see 386 & 68k stubs)
	reset		r		reset -- see sparc stub.
	reserved	<other>		On other requests, the stub should
					ignore the request and send an empty
					response ($#<checksum>).  This way
					we can extend the protocol and GDB
					can tell whether the stub it is
					talking to uses the old or the new.
	search		tAA:PP,MM	Search backwards starting at address
					AA for a match with pattern PP and
					mask MM.  PP and MM are 4 bytes.
					Not supported by all stubs.

	general query	qXXXX		Request info about XXXX.
	general set	QXXXX=yyyy	Set value of XXXX to yyyy.
	query sect offs	qOffsets	Get section offsets.  Reply is
					Text=xxx;Data=yyy;Bss=zzz

	Responses can be run-length encoded to save space.  A '*' means that
	the next character is an ASCII encoding giving a repeat count which
	stands for that many repititions of the character preceding the '*'.
	The encoding is n+29, yielding a printable character where n >=3 
	(which is where rle starts to win).  Don't use an n > 126.

	So 
	"0* " means the same as "0000".  */

/* brg - I have tried to minimize changes to the original gdb source,
 * with the exception of changes necessary to compile the file with a
 * C++ compiler (e.g., function declarations have been revised to use
 * new-style prototypes instead of K&R 1st edition prototypes.)
 * 
 * A comment with an ellipse, such as the following, means
 * stuff which was in gdb/remote.c has been omitted. */

/* ... */

/* brg - added glue */
#include <cstdarg>
#include <cstdio>
#include <cerrno>
#include <cstring>
#include <cstdlib>
#include <unistd.h>
#include <sys/time.h>
#include "remotegdb.h"
int remote_debug = 0;
int remote_desc;
int remote_timeout = 2;

int
serial_readchar(int fd, int timeout)
{
	int rv = 0, errcode;
	char buf[2];
	struct timeval tv_timeout;
	fd_set readfds;

	FD_ZERO(&readfds);
	FD_SET(fd, &readfds);

	tv_timeout.tv_sec = timeout;
	tv_timeout.tv_usec = 0;

	errcode = select(fd + 1, &readfds, NULL, NULL,
		(timeout<0) ? NULL : &tv_timeout);
	if (errcode < 0) {
		rv = SERIAL_ERROR;
	} else if (errcode == 0) {
		rv = SERIAL_TIMEOUT;
	} else if (errcode > 0) {
		if (FD_ISSET(fd, &readfds))
		{
			errcode = read(fd, &buf, 1);
			if (errcode < 0) {
				rv = SERIAL_ERROR;
			} else if (errcode == 0) {
				rv = SERIAL_EOF;
			} else if (errcode > 0) {
				rv = buf[0];
			}
		} else {
			rv = SERIAL_ERROR;
		}
	}
	return rv;

}

int
serial_write(int fd, const char *buf, int len)
{
	return ((write(fd, buf, len) == len) ? 0 : -1);
}
static FILE *gdb_stdout = stderr;
int remotegdb_backend_error = 0;
static inline int gdb_flush(FILE *f) { return fflush(f); }
static inline int max(int i, int j) { return ((i>j) ? i : j); }
static inline void perror_with_name(const char *str) {
  fprintf(gdb_stdout, "%s: %s\n", str, strerror(errno));
  remotegdb_backend_error++;
}
static inline void puts_filtered(const char *str) {
  fputs(str, gdb_stdout); fputc('\n', gdb_stdout);
}
static inline int putchar_unfiltered(int c) { return fputc(c, gdb_stdout); }
#define printf_filtered printf_unfiltered
static inline int fprintf_unfiltered(FILE *f, const char *fmt, ...) {
  va_list ap;
  int rv;
  va_start(ap, fmt);
  rv = vfprintf(f, fmt, ap);
  va_end(ap);
  return rv;
}
static inline int printf_unfiltered(const char *fmt, ...) {
  va_list ap;
  int rv;
  va_start(ap, fmt);
  rv = vfprintf(gdb_stdout, fmt, ap);
  va_end(ap);
  return rv;
}
/* This should not cause an abort, but it will cause a halt. */
/* Someday we will try to support disconnect/reconnect. */
static inline void error(const char *fmt, ...) {
  va_list ap;
  int rv;
  va_start(ap, fmt);
  rv = vfprintf(gdb_stdout, fmt, ap);
  va_end(ap);
  fprintf(gdb_stdout, "Debugger halting simulation.\n");
  remotegdb_backend_error++;
}
/* brg - end added glue */

/* This was 5 seconds, which is a long time to sit and wait.
   Unless this is going though some terminal server or multiplexer or
   other form of hairy serial connection, I would think 2 seconds would
   be plenty.  */

/* Changed to allow option to set timeout value.
   was static int remote_timeout = 2; */
extern int remote_timeout;

/* Descriptor for I/O to remote machine.  Initialize it to NULL so that
   remote_open knows that we don't have a file open when the program
   starts.  */
/* brg - This is specified by the backend now; use an extern variable. */
extern int remote_desc;

/* ... */

/* Convert hex digit A to a number.  */

int fromhex (int a)
{
  if (a >= '0' && a <= '9')
    return a - '0';
  else if (a >= 'a' && a <= 'f')
    return a - 'a' + 10;
  else if (a >= 'A' && a <= 'F')
    return a - 'A' + 10;
  else {
    error ("Reply contains invalid hex digit %d", a);
    return a;
  }
}

/* Convert number NIB to a hex digit.  */

int tohex (int nib)
{
  if (nib < 10)
    return '0'+nib;
  else
    return 'a'+nib-10;
}

/* ... */

/* Return the number of hex digits in num.  */

int hexnumlen (ULONGEST num)
{
  int i;

  for (i = 0; num != 0; i++)
    num >>= 4;

  return max (i, 1);
}

/* ... */

/* Read a single character from the remote end, masking it down to 7 bits. */

int readchar (int timeout)
{
  int ch;

  ch = SERIAL_READCHAR (remote_desc, timeout);

  switch (ch)
    {
    case SERIAL_EOF:
      error ("Debugger disconnected.\n");
      return ch;
    case SERIAL_ERROR:
      perror_with_name ("Debugger communication error");
      return ch;
    case SERIAL_TIMEOUT:
      return ch;
    default:
      return ch & 0x7f;
    }
}

/* Send the command in BUF to the remote machine,
   and read the reply into BUF.
   Report an error if we get an error reply.  */

void remote_send (char *buf)
{
  putpkt (buf);
  getpkt (buf, 0);

  if (buf[0] == 'E')
    error ("Remote failure reply: %s", buf);
}

/* Send a packet to the remote machine, with error checking.
   The data of the packet is in BUF.  */

int putpkt (char *buf)
{
  int i;
  unsigned char csum = 0;
  char buf2[PBUFSIZ];
  int cnt = strlen (buf);
  int ch;
  int tcount = 0;
  char *p;

  /* Copy the packet into buffer BUF2, encapsulating it
     and giving it a checksum.  */

  if (cnt > (int) sizeof (buf2) - 5)		/* Prosanity check */
    abort();

  p = buf2;
  *p++ = '$';

  for (i = 0; i < cnt; i++)
    {
      csum += buf[i];
      *p++ = buf[i];
    }
  *p++ = '#';
  *p++ = tohex ((csum >> 4) & 0xf);
  *p++ = tohex (csum & 0xf);

  /* Send it over and over until we get a positive ack.  */

  while (1)
    {
      int started_error_output = 0;

      if (remote_debug)
	{
	  *p = '\0';
	  printf_unfiltered ("Sending packet: %s...", buf2);
	  gdb_flush(gdb_stdout);
	}
      if (SERIAL_WRITE (remote_desc, buf2, p - buf2))
	perror_with_name ("putpkt: write failed");

      /* read until either a timeout occurs (-2) or '+' is read */
      while (1)
	{
	  ch = readchar (remote_timeout);

 	  if (remote_debug)
	    {
	      switch (ch)
		{
	    case SERIAL_EOF:
		return 0;
		case '+':
		case SERIAL_TIMEOUT:
		case '$':
		  if (started_error_output)
		    {
		      putchar_unfiltered ('\n');
		      started_error_output = 0;
		    }
		}
	    }

	  switch (ch)
	    {
	    case '+':
	      if (remote_debug)
		printf_unfiltered("Ack\n");
	      return 1;
	    case SERIAL_EOF:
		return 0;
	    case SERIAL_TIMEOUT:
	      tcount ++;
	      if (tcount > 3)
		return 0;
	      break;		/* Retransmit buffer */
	    case '$':
	      {
		char junkbuf[PBUFSIZ];

	      /* It's probably an old response, and we're out of sync.  Just
		 gobble up the packet and ignore it.  */
		getpkt (junkbuf, 0);
		continue;		/* Now, go look for + */
	      }
	    default:
	      if (remote_debug)
		{
		  if (!started_error_output)
		    {
		      started_error_output = 1;
		      printf_unfiltered ("putpkt: Junk: ");
		    }
		  putchar_unfiltered (ch & 0177);
		}
	      continue;
	    }
	  break;		/* Here to retransmit */
	}

#if 0
      /* This is wrong.  If doing a long backtrace, the user should be
	 able to get out next time we call QUIT, without anything as violent
	 as interrupt_query.  If we want to provide a way out of here
	 without getting to the next QUIT, it should be based on hitting
	 ^C twice as in remote_wait.  */
      if (quit_flag)
	{
	  quit_flag = 0;
	  interrupt_query ();
	}
#endif
    }
}

/* Come here after finding the start of the frame.  Collect the rest into BUF,
   verifying the checksum, length, and handling run-length compression.
   Returns 0 on any error, 1 on success.  */

int read_frame (char *buf)
{
  unsigned char csum;
  char *bp;
  int c;

  csum = 0;
  bp = buf;

  while (1)
    {
      c = readchar (remote_timeout);

      switch (c)
	{
	case SERIAL_TIMEOUT:
	  if (remote_debug)
	    puts_filtered ("Timeout in mid-packet, retrying\n");
	  return 0;
	case '$':
	  if (remote_debug)
	    puts_filtered ("Saw new packet start in middle of old one\n");
	  return 0;		/* Start a new packet, count retries */
	case '#':
	  {
	    unsigned char pktcsum;

	    *bp = '\000';

	    pktcsum = fromhex (readchar (remote_timeout)) << 4;
	    pktcsum |= fromhex (readchar (remote_timeout));

	    if (csum == pktcsum)
	      return 1;

	    if (remote_debug) 
	      {
		printf_filtered ("Bad checksum, sentsum=0x%x, csum=0x%x, buf=",
				 pktcsum, csum);
		puts_filtered (buf);
		puts_filtered ("\n");
	      }
	    return 0;
	  }
	case '*':		/* Run length encoding */
	  csum += c;
	  c = readchar (remote_timeout);
	  csum += c;
	  c = c - ' ' + 3;	/* Compute repeat count */


	  if (c > 0 && c < 255 && bp + c - 1 < buf + PBUFSIZ - 1)
	    {
	      memset (bp, *(bp - 1), c);
	      bp += c;
	      continue;
	    }

	  *bp = '\0';
	  printf_filtered ("Repeat count %d too large for buffer: ", c);
	  puts_filtered (buf);
	  puts_filtered ("\n");
	  return 0;

	default:
	  if (bp < buf + PBUFSIZ - 1)
	    {
	      *bp++ = c;
	      csum += c;
	      continue;
	    }

	  *bp = '\0';
	  puts_filtered ("Remote packet too long: ");
	  puts_filtered (buf);
	  puts_filtered ("\n");

	  return 0;
	}
    }
}

/* Read a packet from the remote machine, with error checking,
   and store it in BUF.  BUF is expected to be of size PBUFSIZ.
   If FOREVER, wait forever rather than timing out; this is used
   while the target is executing user code.  */

void getpkt (char *buf, int forever)
{
  int c;
  int tries;
  int timeout;
  int val;

  strcpy (buf,"timeout");

  if (forever)
    {
#ifdef MAINTENANCE_CMDS
      timeout = watchdog > 0 ? watchdog : -1;
#else
      timeout = -1;
#endif
    }

  else
    timeout = remote_timeout;

#define MAX_TRIES 3

  for (tries = 1; tries <= MAX_TRIES; tries++)
    {
      /* This can loop forever if the remote side sends us characters
	 continuously, but if it pauses, we'll get a zero from readchar
	 because of timeout.  Then we'll count that as a retry.  */

      /* Note that we will only wait forever prior to the start of a packet.
	 After that, we expect characters to arrive at a brisk pace.  They
	 should show up within remote_timeout intervals.  */

      do
	{
	  c = readchar (timeout);

	  if (c == SERIAL_TIMEOUT)
	    {
#ifdef MAINTENANCE_CMDS
	      if (forever)	/* Watchdog went off.  Kill the target. */
		{
		  target_mourn_inferior ();
		  error ("Watchdog has expired.  Target detached.\n");
		}
#endif
	      if (remote_debug)
		puts_filtered ("Timed out.\n");
	      goto retry;
	    }
	  if (c == SERIAL_EOF)
	    {
	      return;
	    }
	}
      while (c != '$');

      /* We've found the start of a packet, now collect the data.  */

      val = read_frame (buf);

      if (val == 1)
	{
	  if (remote_debug)
	    fprintf_unfiltered (gdb_stdout, "Packet received: %s\n", buf);
	  SERIAL_WRITE (remote_desc, "+", 1);
	  return;
	}

      /* Try the whole thing again.  */
    retry:
      SERIAL_WRITE (remote_desc, "-", 1);
    }

  /* We have tried hard enough, and just can't receive the packet.  Give up. */

  printf_unfiltered ("Ignoring packet error, continuing...\n");
  SERIAL_WRITE (remote_desc, "+", 1);
}

/* ... */
