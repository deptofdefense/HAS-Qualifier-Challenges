/* Configuration file for LEON2, GRLIB-LEON2 and LEON3 systems 
 * 
 * Defines driver resources in separate files,
 *  - LEON3         - leon3_drv_config.c
 *  - LEON2         - leon2_drv_config.c
 *  - LEON2-GRLIB   - leon2_grlib_drv_config.c
 *
 * Initializes,
 *   - Driver manager
 *   - Networking if ENABLE_NETWORK is set
 * 
 */

/* Define for GRLIB LEON2 systems, when a AMBA PnP bus is available */
/*#define LEON2_GRLIB*/

/* Configure Network if enabled */
#ifdef ENABLE_NETWORK
#include <grlib/network_interface_add.h>
#include "networkconfig.h"
#else
#undef ENABLE_NETWORK_SMC_LEON2
#undef ENABLE_NETWORK_SMC_LEON3
#endif

/* Include the Driver resource configuration for the different systems */
#if defined(LEON3)
  /* GRLIB-LEON3 */
  #include "config_leon3_drvmgr.h"
#elif defined(LEON2)
  #ifdef LEON2_GRLIB
    /* GRLIB-LEON2 */
    #include "config_leon2_grlib_drvmgr.c"
  #else
    /* Standard LEON2 */
    #include "config_leon2_drvmgr.c"
  #endif
#endif

/* Include PCI Bus configuration only if PCI bus available
 */
#ifdef RTEMS_PCI_CONFIG_LIB
#include "config_pci.c"
#endif

/* Include the GR-RASTA-IO configuration only if the GR-RASTA-IO driver is 
 * included.
 */
#ifdef CONFIGURE_DRIVER_PCI_GR_RASTA_IO
#include "config_gr_rasta_io.c"
#endif

/* Include the GR-CPCI-LEON4-N2X PCI Peripheral configuration only if the
 * GR-CPCI-LEON4-N2X driver is included in the project.
 */
#ifdef CONFIGURE_DRIVER_PCI_GR_LEON4_N2X
#include "config_leon4_n2x.c"
#endif

/* Include the SpW Bus configuration only if the SpW bus driver is 
 * included.
 */
#ifdef CONFIGURE_DRIVER_SPW_RMAP_AMBAPP
#include "config_spw_bus.c"
#endif


#include <stdlib.h>

#if defined(ENABLE_NETWORK_SMC_LEON3) || defined(ENABLE_NETWORK_SMC_LEON2)
struct rtems_bsdnet_ifconfig smcconfig;
#endif

void system_init(void)
{

// #ifdef CONFIGURE_DRIVER_PCI_GR_RASTA_IO
// 	/* Register GR-RASTA-IO driver resources for the AMBA PnP bus available
// 	 * on the GR-RASTA-IO board.
// 	 */
// 	system_init_rastaio();
// #endif

// #if (defined(ENABLE_NETWORK_SMC_LEON2) && defined(LEON2)) || (defined(ENABLE_NETWORK_SMC_LEON3) && defined(LEON3))
// 	/* Registering SMC driver first, this way the first entry in
// 	 * interface_configs will reflect the SMC network settings.
// 	 */
// 	smcconfig.name = "smc1";
// 	smcconfig.drv_ctrl = NULL;
// 	smcconfig.attach = (void *)RTEMS_BSP_NETWORK_DRIVER_ATTACH_SMC91111;
// 	network_interface_add(&smcconfig);
// #endif

	/* CPU/SYSTEM specific Init */
	system_init2();

#ifndef RTEMS_DRVMGR_STARTUP
	/* Initializing Driver Manager if not alread performed by BSP */
	printf("Initializing manager\n");
	if ( drvmgr_init() ) {
		printf("Driver manager Failed to initialize\n");
		exit(-1);
	}
#endif

	/* Print Driver manager drivers and their assigned devices
	 * drvmgr_summary();
	 * drvmgr_info_drvs(OPTION_INFO_ALL);
	 */

#ifdef ENABLE_NETWORK
	/* Init network */
	printf("Initializing network\n");
	rtems_bsdnet_initialize_network ();
	printf("Initializing network DONE\n\n");
	rtems_bsdnet_show_inet_routes();
	printf("\n");
	rtems_bsdnet_show_if_stats();
	printf("\n\n");
#endif

}
