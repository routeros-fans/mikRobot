# aug/01/2022 14:55:12 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=getIfacesShedul.rsc]] != 0) do={ remove getIfacesShedul.rsc }
add dont-require-permissions=no name=getIfacesShedul.rsc owner=admin policy=\
    read,write,policy,test source="\r\
    \n:global teMessageResponse\r\
    \n\r\
    \n:global dbaseBotSettings\r\
    \n:local botName (\$dbaseBotSettings->\"botName\")\r\
    \n\r\
    \n:local commandIfaces \"getifaces\$botName\"\r\
    \n\$teMessageResponse fCommand=\$commandIfaces fDeleteReport=true\r\
    \n"
