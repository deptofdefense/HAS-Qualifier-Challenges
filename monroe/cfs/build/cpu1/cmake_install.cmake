# Install script for directory: /home/cliff/work/challenges/patch/challenge/cfs/cfe

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/exe")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/cpu1/cf" TYPE FILE RENAME "cfe_es_startup.scr" FILES "/home/cliff/work/challenges/patch/challenge/cfs/osk_defs/cpu1_cfe_es_startup.scr")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/cpu1/cf" TYPE FILE RENAME "kit_to_pkt_tbl.json" FILES "/home/cliff/work/challenges/patch/challenge/cfs/osk_defs/cpu1_kit_to_pkt_tbl.json")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/cpu1/cf" TYPE FILE RENAME "kit_sch_msg_tbl.json" FILES "/home/cliff/work/challenges/patch/challenge/cfs/osk_defs/cpu1_kit_sch_msg_tbl.json")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/cpu1/cf" TYPE FILE RENAME "kit_sch_sch_tbl.json" FILES "/home/cliff/work/challenges/patch/challenge/cfs/osk_defs/cpu1_kit_sch_sch_tbl.json")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/osal/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/psp/pc-linux/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/apps/osk_app_fw/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/apps/cfs_lib/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/apps/expat_lib/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/apps/kit_ci/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/apps/kit_sch/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/apps/kit_to/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/apps/mm/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/cfe_core_default_cpu1/cmake_install.cmake")
  include("/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/cpu1/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/cliff/work/challenges/patch/challenge/cfs/build/cpu1/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
