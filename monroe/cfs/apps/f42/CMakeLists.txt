cmake_minimum_required(VERSION 2.6.4)
project(CFS_F42 C)

include_directories(fsw/mission_inc)
include_directories(fsw/platform_inc)
include_directories(${osk_app_fw_MISSION_DIR}/fsw/platform_inc)
include_directories(${osk_app_fw_MISSION_DIR}/fsw/mission_inc)

#JRL - adding here so that F42 can find libmath
if(("${CMAKE_SYSTEM_NAME}" STREQUAL "RTEMS") AND ("${RTEMS_BSP}" STREQUAL "leon3"))
    if(SOFT_FLOAT)
        link_directories("${RTEMS_TARGET_PATH}/lib/soft/${RTEMS_BSP}")
    else()
        link_directories("${RTEMS_TARGET_PATH}/lib/${RTEMS_BSP}")
    endif()
else()
    # i386
    link_directories("${RTEMS_TARGET_PATH}/lib")
endif()

aux_source_directory(fsw/src APP_SRC_FILES)

# Create the app module
add_cfe_app(f42 ${APP_SRC_FILES})
target_link_libraries (f42 m)


