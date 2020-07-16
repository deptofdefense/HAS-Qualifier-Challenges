#ifndef _TESTDEV_H_
#define _TESTDEV_H_

#include "devicemap.h"

#define TEST_BASE 0x02010000

class TestDev : public DeviceMap {
public:
        uint32 *words;
	TestDev ();
	virtual ~TestDev() { }
	void init();
	uint32 fetch_word (uint32 offset, int mode, DeviceExc *client);
	void store_word (uint32 offset, uint32 data, DeviceExc *client);
	const char *descriptor_str () const { return "Test Device"; }
};

#endif /* _TESTDEV_H_ */
