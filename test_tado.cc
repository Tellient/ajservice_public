// test calling the Tellient device object directly, rather than 
// remotely through alljoyn.

#include "TellientAnalytics.h"
#include "stdio.h"

using namespace ajn ;

int main(int argc, char **argv)
{

    QStatus status ;

    TellientAnalyticsDeviceObject tado ;

    tado.SetVendorData(1337, "http://localhost/teupdate", "bassomatic") ;
    MsgArg args[20] ;

    args[0].Set("{ss}", "modelVer", "1024") ;
    args[1].Set("{ss}", "dogname", "Jasper") ;

    const char *err ;
    status = tado.SetDeviceData(&err,  2, args) ;
    if (status != ER_OK) {
	fprintf(stderr, "error %d writing device data '%s'\n", status, err) ;
	exit(1) ;
    }

    args[0].Set("{ss}", "description", "shiny") ;
    args[1].Set("{si}", "temp", 98) ;
    args[2].Set("{si}", "volume", 40) ;
    tado.SubmitEvent(&err, "fakeevent", 3, args, 0) ;
    if (status != ER_OK) {
	fprintf(stderr, "error %d writing event data '%s'\n", status, err) ;
	exit(1) ;
    }

    tado.SequestDelivery() ;
    exit(0) ;
}
