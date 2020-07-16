#include "cpu.h"
#include "mapper.h"
#include "vmips.h"
#include <stdint.h>
#include "testdev.h"

TestDev::TestDev() : DeviceMap()
{
	extent = 0x100;
	words = new uint32_t[extent/4];
	init();
}

void
TestDev::init()
{
	for (int i = 0; i < extent/4; ++i) {
	    words[i] = 0;
	}
}

uint32
TestDev::fetch_word(uint32 offset, int mode, DeviceExc *client)
{
	uint32 rv = words[offset/4];
	uint32 srv = machine->physmem->mips_to_host_word(rv);
	fprintf(stderr,"TestDev Fetch(0x%08x) found 0x%08x, returning 0x%08x\n",
		offset,rv,srv);
	return srv;
}

void
TestDev::store_word(uint32 offset, uint32 odata, DeviceExc *client)
{
	uint32 data = machine->physmem->host_to_mips_word(odata);
	fprintf(stderr,"TestDev Store(0x%08x) got 0x%08x, storing 0x%08x\n",
		offset,odata,data);
	words[offset/4] = data;
}
