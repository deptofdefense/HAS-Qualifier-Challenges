#include <vector>
#include <map>
#include <string>
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <cerrno>
#include <climits>
#include "interactor.h"
#include "cpu.h"
#include "vmips.h"

/*----------------------------------------------------------------------------*/

class SimpleInteractor;

typedef void (*func_t) (SimpleInteractor *, int, char **);
typedef std::map<const char *, func_t> command_table_t;

#define DEFAULT_PROMPT "vmips=> "

class SimpleInteractor: public Interactor {
    const char *prompt;
    command_table_t commands;
    int interacting;
public:
    SimpleInteractor() : prompt(DEFAULT_PROMPT), interacting(0) { }
    virtual ~SimpleInteractor() { }
    void interact();
    virtual void stop_interacting();
    func_t find_function(const char *cmd);
    void do_one_command(char *buf);
    std::vector<char *> parse_string(char *buf);
    void register_command(func_t func, const char *name);
};

/*----------------------------------------------------------------------------*/

void go_fn (SimpleInteractor *in, int argc, char **argv)
{
    machine->state = vmips::RUN;
    in->stop_interacting();
}

void step_fn (SimpleInteractor *in, int argc, char **argv)
{
    machine->step();
    printf("PC is now 0x%x\n", machine->cpu->debug_get_pc());
}

void regs_fn (SimpleInteractor *in, int argc, char **argv)
{
    machine->cpu->dump_regs (stdout);
}

void cp0_fn (SimpleInteractor *in, int argc, char **argv)
{
    machine->cpu->cpzero_dump_regs_and_tlb (stdout);
}

void stack_fn (SimpleInteractor *in, int argc, char **argv)
{
    machine->cpu->dump_stack (stdout);
}

static int parse_address (const char *cmd, const char *addr_str, uint32 *result)
{
    unsigned long addr;
    char *endptr = NULL;
    errno = 0;
    addr = strtoul(addr_str, &endptr, 0);
    if ((addr == 0) && (endptr == addr_str)) {
	printf("%s: Can't parse address.\n", cmd);
	return -1;
    }
    if (((errno == ERANGE) && (addr == ULONG_MAX))
#if (SIZEOF_LONG > 4)
	|| (addr > 0xffffffffUL)
#endif
	)
    {
	printf("%s: Address out of range.\n", cmd);
	return -1;
    }
    *result = (uint32) addr;
    return 0;
}

void mem_fn (SimpleInteractor *in, int argc, char **argv)
{
    uint32 addr;
    char *endptr = NULL;
    if (argc != 2) {
        printf("mem: usage: mem <addr>\n");
        return;
    }
    if (parse_address("mem", argv[1], &addr) < 0) {
	return;
    }
    if (addr & 3) {
	printf("mem: Address not word-aligned.\n");
	return;
    }
    uint32 nwords = 8;
    while (nwords--) {
        machine->cpu->dump_mem (stdout, addr);
        addr += 4;
    }
}

void dis_fn (SimpleInteractor *in, int argc, char **argv)
{
    uint32 addr;
    char *endptr = NULL;
    if (argc != 2) {
        printf("dis: usage: dis <addr>\n");
        return;
    }
    if (parse_address("dis", argv[1], &addr) < 0) {
	return;
    }
    if (addr & 3) {
	printf("dis: Address not word-aligned.\n");
	return;
    }
    uint32 nwords = 8;
    while (nwords--) {
	// FIXME: disasm can only go to stderr! Lame.
        machine->cpu->dis_mem (stderr, addr);
        addr += 4;
    }
}

void halt_fn (SimpleInteractor *in, int argc, char **argv)
{
    machine->halt ();
    in->stop_interacting();
}

void help_fn (SimpleInteractor *in, int argc, char **argv)
{
    printf
    ("You are in the VMIPS interactive inspector.\n"
     "Commands marked with (*) will exit the interactive inspector.\n"
     "go     - continue execution (*)\n"
     "step   - attempt to step one instruction\n"
     "halt   - halt machine and quit VMIPS (*)\n"
     "quit   - same as halt (*)\n"
     "regs   - print CPU registers\n"
     "cp0    - print CP0 registers and TLB\n"
     "mem A  - print first few words of memory at word address A\n"
     "dis A  - disassemble first few words of memory at word address A\n"
     "stack  - print first few words of stack\n"
     "help   - print this command list\n");
}

/*----------------------------------------------------------------------------*/

std::vector<char *> SimpleInteractor::parse_string(char *buf)
{
    std::vector<char *> rv;
    int len = strlen(buf);
    char *first, *last, *end = &buf[len], *p = &buf[0];
    while (p < end) {
	while ((p < end) && (isspace(*p))) {
	    ++p;
	}
	first = p;
	while ((p < end) && (!isspace(*p))) {
	    ++p;
	}
	last = p;
	if (last < end) {
	    *last = '\0';
	}
	if (*first != '\0') {
	    rv.push_back(first);
	}
	++p;
    }
    rv.push_back(NULL);
    return rv;
}

func_t SimpleInteractor::find_function(const char *cmd)
{
    for (command_table_t::iterator i = commands.begin();
        i != commands.end(); ++i) {
        if (strcmp(i->first, cmd) == 0) {
            return i->second;
        }
    }
    return NULL;
}

void SimpleInteractor::do_one_command(char *buf)
{
    std::vector<char *> argvec = parse_string(buf);
    int argc = argvec.size() - 1;
    char **argv = &argvec[0];
    if (argc != 0) {
	func_t f = find_function(argv[0]);
	if (f) {
	    f(this, argc, argv);
	} else {
	    printf("Unknown command \"%s\"\n", argv[0]);
	}
    }
}

void SimpleInteractor::interact()
{
    interacting++;
    while (interacting) {
	char buf[256];
	fputs(prompt, stdout);
	if (fgets(buf, 256, stdin)) {
            do_one_command(buf);
	} else {
	    interacting--;
	}
    }
}

void SimpleInteractor::stop_interacting()
{
    interacting--;
}

void SimpleInteractor::register_command(func_t func, const char *name)
{
    commands[name] = func;
}

Interactor *create_interactor()
{
    SimpleInteractor *in = new SimpleInteractor;
    in->register_command(go_fn, "go");
    in->register_command(step_fn, "step");
    in->register_command(regs_fn, "regs");
    in->register_command(cp0_fn, "cp0");
    in->register_command(mem_fn, "mem");
    in->register_command(dis_fn, "dis");
    in->register_command(stack_fn, "stack");
    in->register_command(halt_fn, "halt");
    in->register_command(halt_fn, "quit");
    in->register_command(help_fn, "help");
    return in;
}
