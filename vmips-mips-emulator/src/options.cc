/* Command-line and preferences-file options processing.
   Copyright 2001, 2003, 2004, 2009 Brian R. Gaeke.

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

#include "error.h"
#include "fileutils.h"
#include "options.h"
#include "optiontbl.h"
#include <cassert>
#include <cctype>
#include <cerrno>
#include <climits>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <pwd.h>
#include <string>
#include <unistd.h>
#include <vector>

#define OPTBUFSIZ 1024

int
Options::tilde_expand(char *filename)
{
	struct passwd *pw;
	char buf[PATH_MAX], *trailer = NULL;

	if (filename[0] != '~') {
		return 0;
	}
	filename[0] = '\0';
	trailer = strchr(&filename[1],'/');
	if (trailer) {
		*trailer++ = '\0';
	}
	/* &filename[1] now consists of mumble\0 where mumble = zero or more chars
	 * representing a username
	 */
	if (strlen(&filename[1]) == 0) {
		pw = getpwuid(getuid());
	} else {
		pw = getpwnam(&filename[1]);
	}
	if (!pw) {
		return -1;
	}
	if (trailer) {
		sprintf(buf,"%s/%s",pw->pw_dir,trailer);
	} else {
		strcpy(buf,pw->pw_dir);
	}
	strcpy(filename, buf);
	return 0;
}

void
Options::process_defaults(void)
{
	const char **opt;

	for (opt = defaults_table; *opt; opt++) {
		process_one_option(*opt);
	}
	/* ttydev gets a special default, if the OS understands ttyname(0). */
	char *ttydev_default = ttyname(0);
	if (ttydev_default != NULL) {
		set_str_option("ttydev", ttydev_default);
	}
	for (Option *o = nametable; o->type; o++) {
		if (option(o->name) == NULL) {
			fprintf(stderr, "Bug: Option `%s' has no compiled-in default.\n",
				o->name);
		}
	}
}

void
Options::set_str_option(const char *key, const char *value)
{
    int type = STR;

	assert (find_option_type(key) == type &&
		    "unknown string variable in set_str_option");
	Option *o = optstruct(key, true);
	assert (o);
	o->name = strdup(key);
	o->type = type;
	o->value.str = strdup(value);
}

void
Options::set_num_option(const char *key, uint32 value)
{
    int type = NUM;

	assert (find_option_type(key) == type
            && "unknown numeric variable in set_num_option");
	Option *o = optstruct(key, true);
	assert (o);
	o->name = strdup(key);
	o->type = type;
	o->value.num = value;
}

void
Options::set_flag_option(const char *key, bool value)
{
    int type = FLAG;

	assert (find_option_type(key) == type
            && "unknown Boolean variable in set_flag_option");
	Option *o = optstruct(key, true);
	assert (o);
	o->name = strdup(key);
	o->type = type;
	o->value.flag = value;
}


/* Returns NULL if the string pointed to by CRACK_SMOKER
 * does not start with CRACK, or a pointer into CRACK_SMOKER
 * after the prefix if it does.
 */
const char *
Options::strprefix(const char *crack_smoker, const char *crack)
{
	while (*crack_smoker++ == *crack++);
	return (*--crack ? NULL : --crack_smoker);
}

int
Options::find_option_type(const char *option)
{
	Option *o;

	for (o = nametable; o->type; o++)
		if (strcmp(option, o->name) == 0)
			return o->type;
	return 0;
}

void
Options::process_one_option(const char *const option)
{
	char *copy = strdup(option), *equals = NULL;
	uint32 num;

	if ((equals = strchr(copy, '=')) == NULL) {
		/* FLAG option */
        const char *trailer = NULL;
        const char *name;
		bool value;
		if ((trailer = strprefix(copy, "no")) == NULL) {
			/* FLAG set to TRUE */
			name = copy;
			value = true;
		} else {
			/* FLAG set to FALSE */
			name = trailer;
			value = false;
		}
        if (find_option_type(name) == FLAG)
			set_flag_option(name, value);
		else
			error("Unknown option: %s\n", name);
	} else {
		/* STR or NUM option */
		*equals++ = '\0';
                if (*equals == '\0') {
                    error ("Option value missing for %s", copy);
                    free(copy);
                    return;
                }
		switch(find_option_type(copy)) {
			case STR:
				set_str_option(copy, equals);
				break;
			case NUM:
				{
					char *endptr;
					num = strtoul(equals, &endptr, 0);
					switch (*endptr) {
						case 'k':
						case 'K':
							num *= 1024;
							break;
						case 'm':
						case 'M':
							num *= 1024 * 1024;
							break;
						case 'g':
						case 'G':
							num *= 1024 * 1024 * 1024;
							break;
						case '\0':
							break;
						default:
							error("bogus suffix on numeric option\n");
							break;
					}
					set_num_option(copy, num);
				}
				break;
			default:
				*--equals = '=';
				error("Unknown option: %s\n", copy);
				break;
		}
	}
	free(copy);
}

/* This could probably be improved upon. Perhaps it should
 * be replaced with a Lex rule-set or something...
 */
int
Options::process_first_option(char **bufptr, int lineno, const char *filename)
{
	char *out, *in, copybuf[OPTBUFSIZ], char_seen;
	bool quoting, quotenext, done, string_done;
	
	out = *bufptr;
	in = copybuf;
	done = string_done = quoting = quotenext = false;

	while (isspace(*out)) {
		out++;
	}
	while (!done) {
		char_seen = *out++;
		if (char_seen == '\0') {
			done = true;
			string_done = true;
		} else {
			if (quoting) {
				if (char_seen == '\'') {
					quoting = false;
				} else {
					*in++ = char_seen;
				}
			} else if (quotenext) {
				*in++ = char_seen;
				quotenext = false;
			} else {
				if (char_seen == '\'') {
					quoting = true;
				} else if (char_seen == '\\') {
					quotenext = true;
				} else if (char_seen == '#') {
					done = true;
					string_done = true;
				} else if (!isspace(char_seen)) {
					*in++ = char_seen;
				} else {
					done = true;
					string_done = (out[0] == '\0');
				}
			}
		}
	}
	*in++ = '\0';
	*bufptr = out;
	if (quoting) {
		fprintf(stderr,
			"warning: unterminated quote in config file %s, line %d\n",
			filename, lineno);
	}
	if (strlen(copybuf) > 0) {
		process_one_option(copybuf);
	}
	return string_done ? 0 : 1;
}

int
Options::process_options_from_file(const char *filename)
{
	char *buf = new char[OPTBUFSIZ];
	if (!buf) {
		fatal_error("Can't allocate %u bytes for I/O buffer; aborting!\n",
		            OPTBUFSIZ);
	}
	FILE *f = fopen(filename, "r");
	if (!f) {
		if (errno != ENOENT) {
		    error ("Can't open config file '%s': %s\n", filename,
		           strerror(errno));
		}
		return -1;
	}
	char *p = buf;
	int rc, lineno = 1;
    for (char *ptr = fgets(buf, OPTBUFSIZ, f); ptr;
         ++lineno, p = buf, ptr = fgets(buf, OPTBUFSIZ, f))
		do
			rc = process_first_option(&p, lineno, filename);
		while (rc == 1);
	fclose(f);
	delete [] buf;
	return 0;
}

void
Options::usage(char *argv0)
{
	printf(
"Usage: %s [OPTION]... [ROM-FILE]\n"
"Start the %s virtual machine, using the ROM-FILE as the boot ROM.\n"
"\n"
"  -o OPTION                  behave as if OPTION were specified in .vmipsrc\n"
"                               (see manual for details)\n"
"  -F FILE                    read options from FILE instead of .vmipsrc\n"
"  -n                         do not read the system-wide configuration file\n"
"  --version                  display version information and exit\n"
"  --help                     display this help message and exit\n"
"  --print-config             display compile-time variables and exit\n"
"\n"
"By default, `romfile.rom' is used if no ROM-FILE is specified.\n"
"\n"
"Report bugs to <vmips@dgate.org>.\n",
	PACKAGE, PACKAGE);
}

void
Options::process_options(int argc, char **argv)
{
    /* Get options from defaults. */
    process_defaults();

	/* Get default name of user's config file */
	char user_config_filename[PATH_MAX] = "~/.vmipsrc";
	
	/* Process command line */
	bool read_system_config_file = true;
	std::vector<std::string> command_line_options;
	for (int i = 1; i < argc; ++i) {
		if (strcmp (argv[i], "--version") == 0) {
			print_package_version (PACKAGE, VERSION);
			exit (0);
		} else if (strcmp (argv[i], "--help") == 0) {
			usage (argv[0]);
			exit (0);
		} else if (strcmp (argv[i], "--print-config") == 0) {
			print_config_info ();
			exit (0);
		} else if (strcmp (argv[i], "-o") == 0) {
			if (argc <= i + 1)
				error_exit ("The -o flag requires an argument. Try %s --help",
                            argv[0]);
			command_line_options.push_back (argv[i + 1]);
			++i;
		} else if (strcmp (argv[i], "-F") == 0) {
			if (argc <= i + 1)
				error_exit ("The -F flag requires an argument. Try %s --help",
                            argv[0]);
			strcpy (user_config_filename, argv[i + 1]);
			++i;
		} else if (strcmp (argv[i], "-n") == 0) {
			read_system_config_file = false;
		} else if (i == argc - 1) {
            if (!can_read_file (argv[i]) && argv[i][0] == '-') {
			    error_exit ("Unrecognized option %s. Try %s --help", argv[i],
                            argv[0]);
            }
			set_str_option("romfile", argv[i]);
		} else {
			error_exit ("Unrecognized option %s. Try %s --help", argv[i],
                        argv[0]);
		}
	}
	
	/* Get options from system configuration file */
	if (read_system_config_file)
		process_options_from_file (SYSTEM_CONFIG_FILE);
	
	/* Get options from user configuration file */
	tilde_expand (user_config_filename);
	process_options_from_file (user_config_filename);
	
	/* Process -o options saved from command line, above. */
	for (std::vector<std::string>::iterator i = command_line_options.begin (),
		 e = command_line_options.end (); i != e; ++i)
		process_one_option (i->c_str ());
}

Option *
Options::optstruct(const char *name, bool install)
{
    OptionMap::iterator i = table.find (name);
    if (i == table.end ()) {
        if (install) {
            table[name] = Option ();
            return &table[name];
        } else {
            return 0;
        }
    }
	return &table[name];
}

union OptionValue *
Options::option(const char *name)
{
	Option *o = optstruct(name);

	if (o)
		return &o->value;
    fatal_error ("Attempt to get the value of unknown option '%s'", name);
	return NULL;
}

void
Options::print_config_info(void)
{
#ifdef INTENTIONAL_CONFUSION
    puts("Registers initialized to random values instead of zero");
#else
    puts("Registers initialized to zero");
#endif

#ifdef HAVE_LONG_LONG
    puts("Host compiler has native support for 8-byte integers");
#else
    puts("Host compiler does not natively support 8-byte integers");
#endif
}

void
Options::print_package_version(const char *toolname, const char *version)
{
	printf(
"%s %s\n"
"Copyright (C) 2001, 2002, 2003, 2004, 2009, 2012, 2013 by Brian R. Gaeke\n"
"and others. (See the files `AUTHORS' and `THANKS' in the %s source\n"
"distribution for a complete list.)\n"
"\n"
"%s is free software; you can redistribute it and/or modify it\n"
"under the terms of the GNU General Public License as published by the\n"
"Free Software Foundation; either version 2 of the License, or (at your\n"
"option) any later version.\n"
"\n"
"%s is distributed in the hope that it will be useful, but\n"
"WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY\n"
"or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License\n"
"for more details.\n"
"\n"
"You should have received a copy of the GNU General Public License along\n"
"with %s; if not, write to the Free Software Foundation, Inc.,\n"
"51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.\n",
	toolname, version, toolname, toolname, toolname, toolname);
}

