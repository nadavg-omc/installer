#!/bin/bash

if [ -f "$CWMCONFIGFILE" ];
then

CONFIG=`cat $CWMCONFIGFILE`

IFS=$'\n'

for d in $CONFIG; 
do

    export `echo $d | cut -f 1 -d"="`="`echo $d | cut -f 2 -d"="`"

done

ADMINPASSWORD=$password
ADMINEMAIL=$email
ZONE=$zone
VMNAME=$name

WANNICIDS=`cat $CWMCONFIGFILE | grep ^vlan.*=wan-.* | cut -f 1 -d"=" | cut -f 2 -d"n"`
LANNICIDS=`cat $CWMCONFIGFILE | grep ^vlan.*=lan-.* | cut -f 1 -d"=" | cut -f 2 -d"n"`
DISKS=`cat $CWMCONFIGFILE | grep ^disk.*size=.* | wc -l`

UUID=`cat /sys/class/dmi/id/product_uuid | tr '[:upper:]' '[:lower:]'`

fi

# Function: updateServerDescription
# Purpose: Update CWM Server's Overview->Descriptoin text field.
# Usage: updateServerDescription "Some kind of description"

function updateServerDescription() {

    if [ ! -z "$cwmSite" ];
    then

	CWMSITE=$cwmSite

    fi

    if [[ ! -z "$apiClientId" && ! -z "$apiSecret" ]];
    then

        curl -f -X PUT -H "AuthClientId: ${apiClientId}" -H "AuthSecret: ${apiSecret}"  "https://$CWMSITE/svc/server/$UUID/description" -d $'description='"$1"
        errorCode=$?

        if [ $errorCode != '0' ]; 
        then
		echo "Erorr updating server description" | log

	else 

	    echo "Updated Overview->Description data for $UUID" | log
        fi

    else

	echo "No API Client ID or Secret is set, description not set" | log

    fi

}
