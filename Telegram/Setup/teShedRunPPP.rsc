# aug/01/2022 14:55:12 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=pppRunProfile.rsc]] != 0) do={ remove pppRunProfile.rsc }
add dont-require-permissions=no name=pppRunProfile.rsc owner=xenon007 policy=\
    read,write,policy,test source="#------------------------------------------\
    ---------tePppRunProfile--------------------------------------------------\
    ------------\r\
    \n\r\
    \n# https://wiki.mikrotik.com/wiki/Manual:PPP_AAA#Properties\r\
    \n\r\
    \n# Execute script on user login-event. These are available variables that\
    \_are accessible for the event script:\r\
    \n# user            - contains the user name\r\
    \n# local-address   - local address of the mikrotik\r\
    \n# remote-address  - the internal address received by the client from the\
    \_mikrotik\r\
    \n# caller-id       - client's address\r\
    \n# called-id       - client hostname\r\
    \n# interface       - interface number\r\
    \n\r\
    \n# !!!!!! The \"fromRun\" parameter should be different in triggers\r\
    \n\r\
    \n#---------------------------------------------------tePppRunProfile-----\
    ---------------------------------------------------------\r\
    \n\r\
    \n:delay 3\r\
    \n:local answer \"\\\$tePppRun fUser=\$user fFromRun=1\"\r\
    \n\r\
    \n#:delay 1\r\
    \n#:local answer \"\\\$tePppRun fUser=\$user fFromRun=0\"\r\
    \n\r\
    \n:execute script=\$answer\r\
    \n"
