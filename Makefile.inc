INSTGRP 	?= "root"
MANGRP 		?= "man"
INSTUSR 	?= "root"

ZAURUS 		= @zaurus@

PCAPLNK 	= -lpcap

THREADL 	= 

BLDHOME		= .
CXX			= g++-uc
CC			= mips-openwrt-linux-uclibc-gcc
LD			= g++-uc
LDFLAGS		= -L/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/target-mips_34kc_uClibc-0.9.33.2/usr/lib -L/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/target-mips_34kc_uClibc-0.9.33.2/lib -L/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/toolchain-mips_34kc_gcc-4.6-linaro_uClibc-0.9.33.2/usr/lib -L/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/toolchain-mips_34kc_gcc-4.6-linaro_uClibc-0.9.33.2/lib  -rdynamic
INSTALL		= /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_PROGRAM = ${INSTALL}
INSTALL_SCRIPT = ${INSTALL}
INSTALL_STRIP_PROGRAM = @INSTALL_STRIP_PROGRAM@
LIBS		= -lcap -lm -ldl -lpcre
CLIBS   	= 
CXXLIBS		=  -luClibc++
KSLIBS		= 
CFLAGS		= -I/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/target-mips_34kc_uClibc-0.9.33.2/usr/include -I/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/target-mips_34kc_uClibc-0.9.33.2/include -I/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/toolchain-mips_34kc_gcc-4.6-linaro_uClibc-0.9.33.2/usr/include -I/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/toolchain-mips_34kc_gcc-4.6-linaro_uClibc-0.9.33.2/include 
CLIENTLIBS 	= -lm -ldl -lncurses -lpanel
CAPLIBS		= -lcap
CLIENTFLAGS = 
CXXFLAGS 	= -Wall -Os -pipe -mno-branch-likely -mips32r2 -mtune=34kc -fno-caller-saves -fhonour-copts -Wno-error=unused-but-set-variable -msoft-float  -fno-rtti
CPPFLAGS 	= -I/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/target-mips_34kc_uClibc-0.9.33.2/usr/include -I/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/target-mips_34kc_uClibc-0.9.33.2/include -I/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/toolchain-mips_34kc_gcc-4.6-linaro_uClibc-0.9.33.2/usr/include -I/home/msafin/openwrt_svn/tl-mr3220/trunk/staging_dir/toolchain-mips_34kc_gcc-4.6-linaro_uClibc-0.9.33.2/include 
SUIDGROUP 	= kismet

prefix 		= /usr
exec_prefix = /usr
ETC			= ${DESTDIR}/etc/kismet
BIN			= ${DESTDIR}/usr/bin
SHARE 		= ${DESTDIR}/usr/share/kismet/
MAN 		= ${DESTDIR}/usr/man
WAV 		= ${SHARE}/wav/

PLUGINLDFLAGS = 

