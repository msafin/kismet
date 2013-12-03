/*
    This file is part of Kismet

    Kismet is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Kismet is distributed in the hope that it will be useful,
      but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Kismet; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include "config.h"
#include "gpscore.h"
#include "gpsserial.h"
#include "gpsdclient.h"
#include "gpsdlibgps.h"
#include "gpswrapper.h"
#include "configfile.h"

GpsWrapper::GpsWrapper(GlobalRegistry *globalreg) {
	string gpsopt;

	if (globalreg->kismet_config == NULL) {
		fprintf(stderr, "FATAL OOPS:  GpsWrapper() called before kismet_config\n");
		exit(1);
	}

	if (globalreg->kismet_config->FetchOpt("gps") != "true") {
		_MSG("GPS support disabled in kismet.conf", MSGFLAG_INFO);
		GPSNull *gn;
		gn = new GPSNull(globalreg);
		return;
	}

	gpsopt = globalreg->kismet_config->FetchOpt("gpstype");

	if (gpsopt == "serial") {
		GPSSerial *gs;
		gs = new GPSSerial(globalreg);
	} else if (gpsopt == "gpsd") {
#ifdef HAVE_LIBGPS
		GPSLibGPS *lgps;
		lgps = new GPSLibGPS(globalreg);
#else
		GPSDClient *gc;
		gc = new GPSDClient(globalreg);
#endif
	} else if (gpsopt == "") {
		_MSG("GPS enabled but gpstype missing from kismet.conf", MSGFLAG_FATAL);
		globalreg->fatal_condition = 1;
	} else {
		_MSG("GPS unknown gpstype " + gpsopt + ", continuing on blindly and hoping "
			 "we get something useful.  Unless you have loaded GPS plugins that "
			 "handle this GPS type, Kismet is not going to be able to use the GPS",
			 MSGFLAG_ERROR);
	}
}

