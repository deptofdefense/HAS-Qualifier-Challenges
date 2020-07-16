/* Definitions to support options processing.
   Copyright 2001 Brian R. Gaeke.

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

#ifndef _OPTIONS_H_
#define _OPTIONS_H_

#include "types.h"
#include <map>
#include <string>

/* This defines the name of the system default configuration file. */
#define SYSTEM_CONFIG_FILE SYSCONFDIR"/vmipsrc"

/* option types */
enum {
	FLAG = 1,
	NUM,
	STR
};

union OptionValue {
	char *str;
	bool flag;
	uint32 num;
};

typedef struct {
	const char *name;
	int type;
	union OptionValue value;
} Option; 

/* The total number of options must not be greater than TABLESIZE, and
 * TABLESIZE should be the smallest power of 2 greater than the number
 * of options that allows the hash function to perform well.
 */
#define TABLESIZE 256

class Options {
protected:
    typedef std::map<std::string, Option> OptionMap;
    OptionMap table;

	void process_defaults(void);
	void process_one_option(const char *const option);
	int process_first_option(char **bufptr, int lineno = 0,
			const char *fn = NULL);
	int process_options_from_file(const char *filename);
	int tilde_expand(char *filename);
	virtual void usage(char *argv0);
	void set_str_option(const char *key, const char *value);
	void set_num_option(const char *key, uint32 value);
	void set_flag_option(const char *key, bool value);
	const char *strprefix(const char *crack_smoker, const char *crack);
	int find_option_type(const char *option);
	Option *optstruct(const char *name, bool install = false);
	void print_package_version(const char *toolname, const char *version);
	void print_config_info(void);
public:
	Options () { }
	virtual ~Options () { }
	virtual void process_options(int argc, char **argv);
	union OptionValue *option(const char *name);
};

#endif /* _OPTIONS_H_ */
