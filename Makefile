include Makefile.inc

DEPEND		= .depend

OBJC_CONTROL_O = darwin_control_wrapper.mo darwin_wificontrol.mo
OBJC_LINK = 

CAPSOURCES = \
	packetsource_pcap.o packetsource_wext.o packetsource_bsdrt.o \
	packetsource_drone.o packetsource_ipwlive.o packetsource_airpcap.o \
	packetsource_darwin.o packetsource_macusb.o

PSO	= util.o cygwin_utils.o ringbuf.o messagebus.o configfile.o getopt.o \
	filtercore.o ifcontrol.o iwcontrol.o madwifing_control.o nl80211_control.o \
	$(OBJC_LINK) \
	psutils.o ipc_remote.o soundcontrol.o battery.o kismet_json.o \
	netframework.o clinetframework.o tcpserver.o tcpclient.o \
	unixdomainserver.o serialclient.o packetsourcetracker.o $(CAPSOURCES) \
	kis_netframe.o kis_droneframe.o \
	gpswrapper.o gpscore.o gpsdclient.o gpsserial.o gpsdlibgps.o \
	packetchain.o \
	plugintracker.o alertracker.o timetracker.o \
	packetdissectors.o netracker.o channeltracker.o \
	manuf.o \
	dumpfile.o dumpfile_pcap.o dumpfile_gpsxml.o \
	dumpfile_tuntap.o dumpfile_netxml.o dumpfile_nettxt.o dumpfile_string.o \
	dumpfile_alert.o statealert.o \
	kismet_server.o

PS	= kismet_server

DRONEO = util.o cygwin_utils.o ringbuf.o messagebus.o configfile.o getopt.o \
		 ifcontrol.o iwcontrol.o madwifing_control.o nl80211_control.o $(OBJC_LINK) \
		 psutils.o ipc_remote.o soundcontrol.o kismet_json.o \
		 netframework.o clinetframework.o tcpserver.o tcpclient.o serialclient.o \
		 drone_kisnetframe.o kis_droneframe.o \
		 gpswrapper.o gpscore.o gpsdclient.o gpsserial.o gpsdlibgps.o \
		 packetchain.o \
		 $(CAPSOURCES) \
		 plugintracker.o packetsourcetracker.o timetracker.o \
		 kismet_drone.o

CSO = util.o cygwin_utils.o ringbuf.o messagebus.o configfile.o getopt.o \
	filtercore.o ifcontrol.o iwcontrol.o madwifing_control.o nl80211_control.o \
	$(OBJC_LINK) \
	psutils.o ipc_remote.o netframework.o clinetframework.o tcpserver.o tcpclient.o \
	timetracker.o drone_kisnetframe.o \
	packetsourcetracker.o packetchain.o $(CAPSOURCES) \
	dumpfile.o dumpfile_tuntap.o \
	kismet_capture.o
CS	= kismet_capture

DRONE = kismet_drone

NCO	= util.o ringbuf.o messagebus.o configfile.o getopt.o \
	  soundcontrol.o timetracker.o ipc_remote.o \
	  clinetframework.o tcpclient.o popenclient.o kis_clinetframe.o \
	  text_cliframe.o \
	  kis_panel_widgets.o kis_panel_network.o \
	  kis_panel_windows.o kis_panel_details.o \
	  kis_panel_preferences.o \
	  kis_panel_frontend.o \
	  kismet_client.o
NC	= kismet_client

# HOPPERO = util.o configfile.o getopt.o kismet_hopper.o
# HOPPER = kismet_hopper

BUILDCLIENT=yes

ALL	= Makefile $(DEPEND) $(PS) $(CS) $(DRONE)
INSTBINS = $(PS) $(CS) $(DRONE)
ifeq ($(BUILDCLIENT), yes)
ALL += $(NC)
INSTBINS += $(NC)
endif

all:	$(ALL)

all-with-plugins:
	@make plugins-clean
	@make all
	@make plugins

$(PS):	$(PSO) $(CS)
	$(LD) $(LDFLAGS) -o $(PS) $(PSO) $(LIBS) $(CXXLIBS) $(PCAPLNK) $(KSLIBS) -luci

$(CS):	$(CSO)
	$(LD) $(LDFLAGS) -o $(CS) $(CSO) $(LIBS) $(CXXLIBS) $(PCAPLNK) $(CAPLIBS) -luci

$(DRONE):	$(DRONEO) $(CS)
	$(LD) $(LDFLAGS) -o $(DRONE) $(DRONEO) $(LIBS) $(CXXLIBS) $(PCAPLNK) $(KSLIBS) -luci

$(NC):	$(NCO)
	$(LD) $(LDFLAGS) -o $(NC) $(NCO) $(CXXLIBS) $(CLIENTLIBS) -luci

#$(HOPPER):	$(HOPPERO)
#	$(LD) $(LDFLAGS) -o $(HOPPER) $(HOPPERO)

Makefile: Makefile.in configure
	@-echo "'Makefile.in' or 'configure' are more current than this Makefile.  You should re-run 'configure'."

binsuidinstall:
	$(INSTALL) -o $(INSTUSR) -g $(SUIDGROUP) -m 4550 $(CS) $(BIN)/$(CS); 
	
commoninstall:
	mkdir -p $(ETC)
	mkdir -p $(BIN)

	if test -e $(NC); then \
		echo "Installing client"; \
		$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 555 scripts/kismet $(BIN)/kismet; \
		$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 555 $(NC) $(BIN)/$(NC); \
	fi;
	$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 555 $(PS) $(BIN)/$(PS); 
	$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 555 $(DRONE) $(BIN)/$(DRONE);

	mkdir -p $(MAN)/man1
	$(INSTALL) -o $(INSTUSR) -g $(MANGRP) -m 644 man/kismet.1 $(MAN)/man1/kismet.1
	$(INSTALL) -o $(INSTUSR) -g $(MANGRP) -m 644 man/kismet_drone.1 $(MAN)/man1/kismet_drone.1

	mkdir -p $(MAN)/man5
	$(INSTALL) -o $(INSTUSR) -g $(MANGRP) -m 644 man/kismet.conf.5 $(MAN)/man5/kismet.conf.5
	$(INSTALL) -o $(INSTUSR) -g $(MANGRP) -m 644 man/kismet_drone.conf.5 $(MAN)/man5/kismet_drone.conf.5

	mkdir -p $(WAV)
	$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 644 wav/new.wav $(WAV)/new.wav
	$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 644 wav/packet.wav $(WAV)/packet.wav
	$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 644 wav/alert.wav $(WAV)/alert.wav
	$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 644 wav/gpslost.wav $(WAV)/gpslost.wav
	$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 644 wav/gpslock.wav $(WAV)/gpslock.wav

suidinstall: $(CS)
	-groupadd -f $(SUIDGROUP)
	$(MAKE) -e commoninstall
	$(MAKE) -e binsuidinstall
	@if test -f $(ETC)/kismet.conf; then \
		echo "$(ETC)/kismet.conf already installed, not replacing it.  HOWEVER"; \
		echo "if there have been any changes to the base config you will need"; \
		echo "to add them to your config file."; \
    else \
		$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 644 conf/kismet.conf $(ETC)/kismet.conf;  \
		echo install -o $(INSTUSR) -g $(INSTGRP) -m 644 conf/kismet.conf $(ETC)/kismet.conf;  \
		echo "Installed config into $(ETC)/kismet.conf."; \
	fi
	@if test -f $(ETC)/kismet_drone.conf; then \
		echo "$(ETC)/kismet_drone.conf already installed, not replacing it.  HOWEVER"; \
		echo "if there have been any changes to the base config you will need"; \
		echo "to add them to your config file."; \
    else \
		$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 644 conf/kismet_drone.conf $(ETC)/kismet_drone.conf;  \
		echo install -o $(INSTUSR) -g $(INSTGRP) -m 644 conf/kismet_drone.conf $(ETC)/kismet_drone.conf;  \
		echo "Installed drone config into $(ETC)/kismet_drone.conf."; \
	fi

	@echo "Installed kismet into $(BIN)/."
	@echo "If you have not done so already, read the README file and the FAQ file.  Additional"
	@echo "documentation is in the docs/ directory.  You MUST edit $(ETC)/kismet.conf "
	@echo "and configure Kismet for your system, or it will NOT run properly!"
	@echo
	@echo "Kismet has been installed with a SUID ROOT CAPTURE HELPER executeable by "
	@echo "users in the group '" $(SUIDGROUP) "'.  This WILL ALLOW USERS IN THIS GROUP "
	@echo "TO ALTER YOUR NETWORK INTERACE STATES, but is more secure than running "
	@echo "all of Kismet as root.  ONLY users in this group will be able to "
	@echo "run Kismet and capture from physical network devices."

install: $(INSTBINS)
	$(MAKE) -e commoninstall
	@if test -f $(ETC)/kismet.conf; then \
		echo "$(ETC)/kismet.conf already installed, not replacing it.  HOWEVER"; \
		echo "if there have been any changes to the base config you will need"; \
		echo "to add them to your config file."; \
    else \
		$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 644 conf/kismet.conf $(ETC)/kismet.conf;  \
		echo install -o $(INSTUSR) -g $(INSTGRP) -m 644 conf/kismet.conf $(ETC)/kismet.conf;  \
		echo "Installed config into $(ETC)/kismet.conf."; \
	fi
	@if test -f $(ETC)/kismet_drone.conf; then \
		echo "$(ETC)/kismet_drone.conf already installed, not replacing it.  HOWEVER"; \
		echo "if there have been any changes to the base config you will need"; \
		echo "to add them to your config file."; \
    else \
		$(INSTALL) -o $(INSTUSR) -g $(INSTGRP) -m 644 conf/kismet_drone.conf $(ETC)/kismet_drone.conf;  \
		echo install -o $(INSTUSR) -g $(INSTGRP) -m 644 conf/kismet_drone.conf $(ETC)/kismet_drone.conf;  \
		echo "Installed drone config into $(ETC)/kismet_drone.conf."; \
	fi
	@echo "Installed kismet into $(BIN)/."
	@echo "If you have not done so already, read the README file and the FAQ file.  Additional"
	@echo "documentation is in the docs/ directory.  You MUST edit $(ETC)/kismet.conf "
	@echo "and configure Kismet for your system, or it will NOT run properly!"
	@echo
	@echo "Kismet has NOT been installed suid-root.  This means you will need to start "
	@echo "it as root.  If you add your user to the $(SUIDGROUP) group and install "
	@echo "Kismet with 'make suidinstall', users in that group will be able to "
	@echo "run Kismet directly."
	@echo
	@echo "READ THE KISMET DOCUMENTATION ABOUT THE KISMET SECURITY MODEL TO"
	@echo "DECIDE IF YOU WANT TO INSTALL IT SUID-ROOT"
	@echo
	@echo "It is generally  more secure to install Kismet with the suid-root helper "
	@echo "option."
                
rpm:
	@echo "Disabling SUID installation (RPM will handle setting the SUID bit.)"
	@( export SUID="no"; export INSTGRP=`id -g`; export MANGRP=`id -g`; \
		export INSTUSR=`id -u`; $(MAKE) -e install )

clean:
	@-rm -f *.o *.mo
	@-rm -f $(PS)
	@-rm -f $(CS)
	@-rm -f $(DRONE)
	@-rm -f $(NC)

distclean:
	@-$(MAKE) clean
	@-rm -f *~
	@-rm -f $(DEPEND)
	@-rm -f config.status
	@-rm -f config.h
	@-rm -f config.log
	@-rm -rf packaging/ipkg/usr 
	@-rm -rf packaging/pak
	@-rm -rf *.ipk
	@-rm -f scripts/kismet
	@-( cd extra/; $(MAKE) distclean )
	@-rm -f Makefile

arm: $(PS) $(NC) $(ZBUILD)
	@echo "ARM toolset built."

ipkg: $(PS) $(NC) 
	@if test "`whoami`" != "root"; then echo "Warning:  You are not root.  The ipkg will probably not be what you want."; fi
	@mkdir -p packaging/ipkg/$(ETC)
	@mkdir -p packaging/ipkg/$(BIN)
	@arm-linux-strip $(PS)
	@arm-linux-strip $(NC)
	# @arm-linux-strip $(HOPPER)
	@cp $(PS) packaging/ipkg/$(BIN)/$(PS)
	@cp $(NC) packaging/ipkg/$(BIN)/$(NC)
	# @cp $(HOPPER) packaging/ipkg/$(BIN)/$(HOPPER)
	@cp scripts/kismet packaging/ipkg/$(BIN)/kismet
	@cp conf/kismet.conf packaging/ipkg/$(ETC)/kismet.conf
	@chmod a+x packaging/ipkg/$(BIN)/*
	@chown root.root packaging/ipkg -R
	@echo "Making ipkg..."
	@rm -rf packaging/pak
	@mkdir -p packaging/pak
	@( cd packaging/ipkg/CONTROL; tar cf ../../pak/control.tar ./control; )
	@( cd packaging/ipkg/; tar cf ../pak/data.tar ./usr; )
	@( cd packaging/pak; gzip control.tar; gzip data.tar; tar cf ../../kismet_arm.tar ./control.tar.gz ./data.tar.gz; )
	@( gzip -c kismet_arm.tar > kismet_$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_TINY)_arm.ipk; rm kismet_arm.tar; )


dep:
	@$(MAKE) depend

depend: Makefile
	@$(MAKE) $(DEPEND)

$(DEPEND): Makefile
	@-rm -f $(DEPEND)
	@echo "Generating dependencies... "
	@echo > $(DEPEND)
	@$(CXX) $(CFLAGS) -MM \
		`echo $(PSO) $(DRONEO) $(NCO) | \
		sed -e "s/\.o/\.cc/g" | sed -e "s/\.mo/\.m/g"` >> $(DEPEND)

plugins: Makefile
	@( export KIS_SRC_DIR=`pwd`; for x in plugin-*/; do echo "PLUGIN: $$x"; ( cd "$$x"; make; ); done )

plugins-clean: Makefile
	@( export KIS_SRC_DIR=`pwd`; for x in plugin-*/; do echo "PLUGIN-CLEAN: $$x"; ( cd "$$x"; make clean; ); done )

plugins-install: Makefile
	@( export KIS_SRC_DIR=`pwd`; for x in plugin-*/; do echo "PLUGIN-INSTALL: $$x"; ( cd "$$x"; make install; ); done )

plugins-userinstall: Makefile
	@( export KIS_SRC_DIR=`pwd`; for x in plugin-*/; do echo "PLUGIN-USERINSTALL: $$x"; ( cd "$$x"; make userinstall; ); done )

include $(DEPEND)

.c.o:	$(DEPEND)
	$(CC) $(CFLAGS) -c $*.c -o $@ 

.cc.o:	$(DEPEND)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $*.cc -o $@ 

.m.mo:	$(DEPEND)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $*.m -o $@ 
	

.SUFFIXES: .c .cc .o .m .mo
