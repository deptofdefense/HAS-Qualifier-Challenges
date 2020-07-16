/* A sensible interface to MIPS cross compilation tools.
   Copyright 2001, 2003, 2004 Brian R. Gaeke.

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

/* For later: ways to get page size:
long sysconf(_SC_PAGE_SIZE);
or 
long sysconf(_SC_PAGESIZE);
or
int getpagesize(void);
*/

#include "endiantest.h"
#include "fileutils.h"
#include "stub-dis.h"
#include "error.h"
#include "options.h"
#include <cerrno>
#include <cstdarg>
#include <climits>
#include <cstdlib>
#include <cstring>
#include <cstdio>
#include <iostream>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>

const unsigned int MAXARGV = 500;
const unsigned int TMPFNAMESIZE = 26;

int verbose = 0;
int dryrun = 0;

char pkgdatadir[PATH_MAX];
char ccname[PATH_MAX];
char ldname[PATH_MAX];
char objcopyname[PATH_MAX];
char objdumpname[PATH_MAX];
char endianflag[4];

bool program_available (const char *execname) {
  struct stat st;
  if (stat (execname, &st) < 0)
    return false;
  if (!(st.st_mode & S_IXUSR))
    return false;
  return true;
}

int config_error (const char *programname, const char *execname) {
	fprintf (stderr, "vmipstool: Couldn't find MIPS tool '%s' in '%s' "
		"(installation error?)\n", programname, execname);
	return 1;
}

void setup_paths (bool bigendian, const char *mipstoolprefix) {
	strcpy (pkgdatadir, PKGDATADIR);
    // Allow user (or a shell script) to override the path from which the
    // linker script is read. This allows vmipstool to be executed from the
    // source tree without vmips being installed.
    char *user_supplied_pkgdatadir;
    user_supplied_pkgdatadir = getenv ("VMIPS_PKGDATADIR");
    if (user_supplied_pkgdatadir) {
      strncpy (pkgdatadir, user_supplied_pkgdatadir, PATH_MAX);
      if (strlen (user_supplied_pkgdatadir) >= PATH_MAX)
        pkgdatadir[PATH_MAX - 1] = '\0';
    }

	strcpy (ccname, mipstoolprefix);
	strcat (ccname, "gcc");
	strcpy (ldname, mipstoolprefix);
	strcat (ldname, "ld");
	strcpy (objcopyname, mipstoolprefix);
	strcat (objcopyname, "objcopy");
	strcpy (objdumpname, mipstoolprefix);
	strcat (objdumpname, "objdump");

    // Decide which flag should be used to force the endianness of an
    // object file.
    if (bigendian) {
		strcpy (endianflag, "-EB");
    } else {
		strcpy (endianflag, "-EL");
    }
}

/* ROMs are padded to a multiple of this many bytes. I don't think this
   is strictly necessary and will probably go away eventually. */
long pagesz = 4096;

/********************************* Various utils ******************************/

void usage(void) {
	puts("usage:");
	puts(" vmipstool [ VT-FLAGS ] --compile [ FLAGS ] FILE.c -o FILE.o");
	puts(" vmipstool [ VT-FLAGS ] --preprocess [ FLAGS ] FILE");
	puts(" vmipstool [ VT-FLAGS ] --assemble [ FLAGS ] FILE.s -o FILE.o");
	puts
		(" vmipstool [ VT-FLAGS ] --link [ FLAGS ] FILE1.o ... FILEn.o -o PROG");
	puts(" vmipstool [ VT-FLAGS ] --make-rom PROG PROG.rom");
	puts(" vmipstool [ VT-FLAGS ] --disassemble-rom PROG.rom");
	puts(" vmipstool [ VT-FLAGS ] --disassemble PROG (or FILE.o)");
	puts(" vmipstool [ VT-FLAGS ] --swap-words INPUT OUTPUT");
	puts("");
	puts("VT-FLAGS may include:");
	puts(" --help         Display this help message and exit.");
	puts(" --version      Display the version of vmipstool and exit.");
	puts(" --verbose      Echo commands as they are run.");
	puts
		(" --dry-run      Don't actually run anything; use with --verbose.");
	puts(" --ld-script=T  Use T as ld script (instead of default script);");
	puts("                use with --link.");
	puts("");
	puts("Report bugs to <vmips@dgate.org>.");
}

void maybe_echo(char **newargv) {
	int i;
	if (verbose) {
		for (i = 0; newargv[i] != NULL; i++)
			fprintf(stderr, "%s ", newargv[i]);
		fprintf(stderr, "\n");
	}
}

int maybe_run(char **newargv) {
	pid_t pid;
	int status, error = 0;

	if (!dryrun) {
		if ((pid = fork()) == 0) {
			execv(newargv[0], newargv);
			perror (newargv[0]);
			exit (255);
		} else {
			waitpid(pid, &status, 0);
			if (WIFEXITED(status))
				error = (WEXITSTATUS(status) != 0);
			else
				error = 1;
		}
	}
	return error;
}

int echo_and_run_l(char *c, ...) {
	va_list ap;
	char *newargv[MAXARGV];
	int newargc = 0;

	va_start(ap, c);
	newargv[newargc++] = c;
	while (c != NULL) {
		c = va_arg(ap, char *);
		newargv[newargc++] = c;
	}
	va_end(ap);

	maybe_echo(newargv);
	return maybe_run(newargv);
}

int echo_and_run_lv(char *c, ...) {
	va_list ap;
	char *newargv[MAXARGV];
	char **originalargv;
	int newargc = 0;
	int i;

	va_start(ap, c);
	newargv[newargc++] = c;
	while (c != NULL) {
		c = va_arg(ap, char *);
		newargv[newargc++] = c;
	}
	newargc--;
	originalargv = va_arg(ap, char **);
	for (i = 0; originalargv[i] != NULL; i++)
		newargv[newargc++] = originalargv[i];
	newargv[newargc++] = NULL;
	va_end(ap);

	maybe_echo(newargv);
	return maybe_run(newargv);
}

/* Search colon-separated PATH for file named TARGET. Copy found file's
   full pathname into RESULT and return true if found. Returns false and
   leaves result untouched if not found. */
bool search_path(char *result, char *path, const char *target) {
	const char *delims = ":";
	char *dir = strtok (path, delims);
	while (dir != NULL) {
		char trypath[PATH_MAX];
		sprintf (trypath, "%s/%s", dir, target);
		if (can_read_file (trypath)) {
			strcpy (result, trypath);
			return true;
		} else {
			dir = strtok (NULL, delims);
		}
	}
	return false;
}

/********************************* Linking ******************************/

char ldscript_full_path[PATH_MAX];
bool ldscript_error = false;

int can_read_default_ldscript () {
	/* Build the search path */
	char *ldscript_search_path;

	/* so that it can work without being installed */
	char rest_of_path[] =
		":.:..:./sample_code:../sample_code:../../sample_code";
	const char ldscript_name[] = "ld.script";

	ldscript_search_path =
		new char[strlen(rest_of_path) + strlen(pkgdatadir) + 2];
	strcpy(ldscript_search_path, pkgdatadir);
	strcat(ldscript_search_path, rest_of_path);

	/* Look for the ld.script */
	return search_path(ldscript_full_path, ldscript_search_path,
					   ldscript_name);
}

int do_link (int argc, char **argv) {
	if (ldscript_error) {
		fprintf(stderr, "vmipstool: can't access linker script\n");
		return 1;
	} 
	if (!program_available (ldname))
		return config_error ("ld", ldname);
	return echo_and_run_lv (ldname, endianflag, "-T", ldscript_full_path, NULL,
                            argv, NULL);
}

/********************************* ROM-making ******************************/

int copy_with_padded_blocks (char *in, char *out, long size) {
	char *buff = new char[size];
	FILE *f = fopen(in, "rb");
	if (!f) {
		perror(in);
		return -1;
	}
	FILE *g = fopen(out, "wb");
	if (!g) {
		perror(out);
		return -1;
	}
	errno = 0;
	int readcount;
	while ((readcount = fread(buff, 1, size, f)) != 0) {
		if (readcount < size) {
			if (errno) {
				perror(in);
				fclose(f);
				fclose(g);
				return -1;
			} else {
				for (int i = readcount; i < size; i++)
					buff[i] = '\0';
			}
		}
		int writecount = fwrite(buff, 1, size, g);
		if (writecount < size) {
			perror(out);
			fclose(f);
			fclose(g);
			return -1;
		}
	}
	fclose(f);
	fclose(g);
	delete [] buff;
	return 0;
}

int make_rom (int argc, char **argv) {
	char tmp[TMPFNAMESIZE];
	char *inputfile;
	char *outputfile;
	if (argc != 2) {
		fprintf(stderr, "vmipstool: --make-rom takes 2 arguments\n");
		usage();
		return 1;
	}
	sprintf (tmp, "/tmp/vmipstool-%d-1", (int) getpid ());
	inputfile = argv[0];
	outputfile = argv[1];
	if (!program_available (objcopyname))
		return config_error ("objcopy", objcopyname);
	if (echo_and_run_l (objcopyname, "-O", "binary", inputfile, tmp, NULL) != 0) {
		fprintf(stderr, "vmipstool: Error creating binary image of program.  Aborting.\n");
		return 1;
	}
	if (verbose)
		printf ("dd if=%s of=%s bs=%ld conv=sync > /dev/null 2>&1\n",
				tmp, outputfile, pagesz);
	if (copy_with_padded_blocks(tmp, outputfile, pagesz) != 0) {
		fprintf(stderr,
				"vmipstool: Error copying program image to ROM file.  Aborting.\n");
		return 1;
	}
	if (verbose)
		printf("rm %s\n", tmp);
	unlink(tmp);
	return 0;
}

/********************************* Byte-swapping ******************************/

int swap_words (int argc, char **argv) {
	char *inputfname = argv[0];
	char *outputfname = argv[1];
	FILE *inputfp = fopen(inputfname, "rb");
	if (!inputfp) {
		perror(inputfname);
		return -1;
	}
	FILE *outputfp = fopen(outputfname, "wb");
	if (!outputfp) {
		perror(outputfname);
		return -1;
	}
	char buff[4], buff2[4];
	int readcount, writecount;
	while ((readcount = fread(buff, 1, 4, inputfp)) > 0) {
		if (readcount < 4) {
			fprintf(stderr,
					"%s: warning: file does not end on a word boundary\n",
					inputfname);
			for (int i = readcount; i < 3; i++)
				buff[i] = 0;
		}
		buff2[0] = buff[3];
		buff2[1] = buff[2];
		buff2[2] = buff[1];
		buff2[3] = buff[0];
		if ((writecount = fwrite(buff2, 1, 4, outputfp)) != 4) {
			perror(outputfname);
			break;
		}
	}
	fclose(inputfp);
	fclose(outputfp);
	return 0;
}

/******************************** Everything else *****************************/

int compile (int argc, char **argv) {
	if (!program_available (ccname)) return config_error ("gcc", ccname);
	return echo_and_run_lv (ccname, endianflag, "-mno-abicalls",
				"-fno-pic", NULL, argv, NULL);
}

int assemble (int argc, char **argv) {
	if (!program_available (ccname)) return config_error ("gcc", ccname);
	return echo_and_run_lv (ccname, "-c", "-x", "assembler-with-cpp",
				endianflag, "-fno-pic", NULL, argv, NULL);
}

int preprocess (int argc, char **argv) {
	if (!program_available (ccname)) return config_error ("gcc", ccname);
	return echo_and_run_lv(ccname, "-E", NULL, argv, NULL);
}

int disassemble (int argc, char **argv) {
	char *inputfile = argv[0];
	if (!program_available (objdumpname))
		return config_error ("objdump", objdumpname);
	return echo_and_run_l (objdumpname, "--disassemble", endianflag,
                           inputfile, NULL);
}

int disassemble_rom (int argc, char **argv) {
	char *inputfile = argv[0];
	if (!program_available (objdumpname))
		return config_error ("objdump", objdumpname);
	return echo_and_run_l (objdumpname, "--disassemble-all", "--target=binary",
                           endianflag, "-m", "mips", inputfile, NULL);
}

int disassemble_word (int argc, char **argv) {
  EndianSelfTester est;
  Disassembler d (est.host_is_big_endian(), stdout);
  if (argc != 2) {
    fprintf (stderr, "Error: must supply PC and INSTR\n");
    return 1;
  }
  uint32 pc = strtoul(argv[0], NULL, 0);
  uint32 instr = strtoul(argv[1], NULL, 0);
  d.disassemble (pc, instr);
  return 0;
}

int version (int argc, char **argv) {
	printf("vmipstool (VMIPS) %s\n", VERSION);
	return 0;
}

int help (int argc, char **argv) {
	usage();
	return 0;
}

/******************************** Options handling ****************************/

int (*handler) (int argc, char **argv);
char **handler_argv = 0;
int handler_argc = -1;

class VmipstoolOptions : public Options {
public:
  VmipstoolOptions () : Options () {
  }
  virtual ~VmipstoolOptions () { }

  virtual void usage (char *argv0)
  {
    printf ("usage:\n"
            " %s [ VT-FLAGS ] MODE MODE-ARGS\n"
            "Each MODE takes its own MODE-ARGS:\n"
            "  MODE:              MODE-ARGS:\n"
            "  --compile          [ FLAGS ] FILE.c -o FILE.o\n"
            "  --preprocess       [ FLAGS ] FILE\n"
            "  --assemble         [ FLAGS ] FILE.s -o FILE.o\n"
            "  --link             [ FLAGS ] FILE1.o ... FILEn.o -o PROG\n"
            "  --make-rom         PROG PROG.rom\n"
            "  --disassemble-rom  PROG.rom\n"
            "  --disassemble-word PC INSTR\n"
            "  --disassemble      PROG (or FILE.o)\n"
            "  --swap-words       INPUT OUTPUT\n"
            "\n"
            "VT-FLAGS may include:\n"
            " --help         Display this help message and exit.\n"
            " --version      Display the version of vmipstool and exit.\n"
            " --verbose      Echo commands as they are run.\n"
            " --dry-run      Don't actually run anything; use with --verbose.\n"
            " --ld-script=T  Use T as ld script (instead of default script);\n"
            "                use with --link.\n"
            "\n" "Report bugs to <vmips@dgate.org>.\n", argv0);
  }

  virtual void process_options (int argc, char **argv)
  {
    /* Get options from defaults. */
    process_defaults ();

    /* Get default name of user's config file */
    char user_config_filename[PATH_MAX] = "~/.vmipsrc";

    /* Process command line */
    bool read_system_config_file = true;
    std::vector<std::string> command_line_options;

    int i;
    for (i = 1; (!handler) && (i < argc); ++i)
      {
        if (strcmp (argv[i], "--version") == 0)
          {
            print_package_version ("vmipstool", VERSION);
            exit (0);
          }
        else if (strcmp (argv[i], "--help") == 0)
          {
            usage (argv[0]);
            exit (0);
          }
        else if (strcmp (argv[i], "-o") == 0)
          {
            if (argc <= i + 1)
              error_exit ("The -o flag requires an argument. Try %s --help",
                           argv[0]);
            command_line_options.push_back (argv[i + 1]);
            ++i;
          }
        else if (strcmp (argv[i], "-F") == 0)
          {
            if (argc <= i + 1)
              error_exit ("The -F flag requires an argument. Try %s --help",
                           argv[0]);
            strcpy (user_config_filename, argv[i + 1]);
            ++i;
          }
        else if (strcmp (argv[i], "-n") == 0)
          {
            read_system_config_file = false;
          }
        else if (strcmp (argv[i], "--verbose") == 0)
          {
            verbose = 1;
          }
        else if (strcmp (argv[i], "--dry-run") == 0)
          {
            dryrun = 1;
          }
        else if (strncmp (argv[i], "--ld-script=", 12) == 0)
          {
            strcpy (ldscript_full_path, &argv[i][12]);
            ldscript_error = !can_read_file (ldscript_full_path);
          }
        else if (strcmp (argv[i], "--compile") == 0)
          {
            handler = compile;
          }
        else if (strcmp (argv[i], "--assemble") == 0)
          {
            handler = assemble;
          }
        else if (strcmp (argv[i], "--preprocess") == 0)
          {
            handler = preprocess;
          }
        else if (strcmp (argv[i], "--link") == 0)
          {
            handler = do_link;
          }
        else if (strcmp (argv[i], "--make-rom") == 0)
          {
            handler = make_rom;
          }
        else if (strcmp (argv[i], "--disassemble-rom") == 0)
          {
            handler = disassemble_rom;
          }
        else if (strcmp (argv[i], "--disassemble-word") == 0)
          {
            handler = disassemble_word;
          }
        else if (strcmp (argv[i], "--disassemble") == 0)
          {
            handler = disassemble;
          }
        else if (strcmp (argv[i], "--swap-words") == 0)
          {
            handler = swap_words;
          }
        else                    /* Unrecognized arg. */
          {
            std::cerr << "Unrecognized arg: " << argv[i] << "\n";
            usage (argv[0]);
            exit (1);
          }
      }
    if (!handler)
      {
        std::cerr << "Error: Missing mode arg.\n";
        usage (argv[0]);        /* Arg list was incomplete somehow. */
        exit (1);
      }
    handler_argc = argc - i;
    handler_argv = argv + i;

    /* Get options from system configuration file */
    if (read_system_config_file)
      process_options_from_file (SYSTEM_CONFIG_FILE);

    /* Get options from user configuration file */
    tilde_expand (user_config_filename);
    process_options_from_file (user_config_filename);

    /* Process -o options saved from command line, above. */
    for (std::vector<std::string>::iterator i =
         command_line_options.begin (), e = command_line_options.end ();
         i != e; ++i)
      process_one_option (i->c_str ());
  }
};

int
main (int argc, char **argv)
{
  /* Find the default ld script. */
  ldscript_error = !can_read_default_ldscript ();

  /* Get the command line options. */
  VmipstoolOptions *opt = new VmipstoolOptions;
  opt->process_options (argc, argv);
  setup_paths (opt->option ("bigendian")->flag,
               opt->option ("mipstoolprefix")->str);

  /* Run the appropriate handler. */
  if (!handler)
    fatal_error ("handler was not set");
  if (handler_argc == -1)
    fatal_error ("handler_argc was not set");
  if (!handler_argv)
    fatal_error ("handler_argv was not set");
  return handler (handler_argc, handler_argv);
}
