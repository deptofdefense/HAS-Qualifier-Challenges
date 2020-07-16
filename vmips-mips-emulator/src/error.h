/* Definitions for error and warning reporting utilities.
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

#include "gccattr.h"

#ifndef _ERROR_H_
#define _ERROR_H_

/* Use to report all program errors. MSG is a printf(3) style format
 * specification for the remaining arguments. error() will always output
 * a newline after MSG.
 */
__ATTRIBUTE_FORMAT__(printf, 1, 2)
void error(const char *msg, ...);

/* As with error(), but calls exit() with an error code of 1 afterwards.
 */
__ATTRIBUTE_NORETURN__
__ATTRIBUTE_FORMAT__(printf, 1, 2)
void error_exit(const char *msg, ...);

/* Use to report all fatal program errors. Calls abort(3) after printing
 * a message. MSG is a printf(3) style format specification for the remaining
 * arguments. fatal_error() will always output a newline after MSG.
 */
__ATTRIBUTE_NORETURN__
__ATTRIBUTE_FORMAT__(printf, 1, 2)
void fatal_error(const char *msg, ...);

/* Use to report warning conditions for the program. MSG is a printf(3) style
 * format specification for the remaining arguments. warning() will always
 * output a newline after MSG.
 */
__ATTRIBUTE_FORMAT__(printf, 1, 2)
void warning(const char *msg, ...);

#endif /* _ERROR_H_ */
