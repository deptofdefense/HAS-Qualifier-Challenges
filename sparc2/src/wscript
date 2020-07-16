# Copyright 2013 Chris Johns (chrisj@rtems.org)
#
# This file's license is 2-clause BSD as in this distribution's LICENSE.2 file.
#

from __future__ import print_function

# See README.waf for building instructions.

rtems_version = "5"

try:
    import rtems_waf.rtems as rtems
    import rtems_waf.rtems_bsd as rtems_bsd
except:
    print('error: no rtems_waf git submodule; see README.waf')
    import sys
    sys.exit(1)

def init(ctx):
    rtems.init(ctx, version = rtems_version, long_commands = True)

def bsp_configure(conf, arch_bsp):
    rtems_bsd.bsp_configure(conf, arch_bsp, mandatory = False)
    conf.recurse('lvgl')

def options(opt):
    rtems.options(opt)
    rtems_bsd.options(opt)

def configure(conf):
    rtems.configure(conf, bsp_configure = bsp_configure)

def build(bld):
    rtems.build(bld)
    bld.env.CFLAGS += ['-O2','-g']
    bld.recurse('hello')
    bld.recurse('gdb')
    bld.recurse('filesystem/fat_ramdisk')
    bld.recurse('classic_api')
    bld.recurse('file_io')
    bld.recurse('ticker')
    bld.recurse('uboot')
    bld.recurse('led')
    bld.recurse('misc')
    bld.recurse('benchmarks')
    bld.recurse('micromonitor')
    bld.recurse('posix_api')
    bld.recurse('cxx')
    bld.recurse('c11')
    bld.recurse('lvgl')

def rebuild(ctx):
    import waflib.Options
    waflib.Options.commands.extend(['clean', 'build'])

def tags(ctx):
    ctx.exec_command('etags $(find . -name \*.[sSch])', shell = True)
