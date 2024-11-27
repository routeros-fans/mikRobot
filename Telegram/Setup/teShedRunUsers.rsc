# aug/01/2022 14:55:12 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=getUsersShedul.rsc]] != 0) do={ remove getUsersShedul.rsc }
add dont-require-permissions=no name=getUsersShedul.rsc owner=xenon007 policy=\
    read,write,policy,test source="\r\
    \n:global teMessageResponse\r\
    \n\r\
    \n:global dbaseBotSettings\r\
    \n:local botName (\$dbaseBotSettings->\"botName\")\r\
    \n\r\
    \n:local commandUsers \"getusers\$botName\"\r\
    \n\$teMessageResponse fCommand=\$commandUsers fDeleteReport=true\r\
    \n"
