# aug/01/2022 14:55:12 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=leaseRun.rsc]] != 0) do={ remove leaseRun.rsc }
add dont-require-permissions=no name=leaseRun.rsc owner=admin policy=\
    ftp,read,write,policy,test,password,sensitive source="#-------------------\
    --------------------------------teLeaseRun--------------------------------\
    ------------------------------\r\
    \n\r\
    \n# https://wiki.mikrotik.com/wiki/Manual:IP/DHCP_Server#Lease_Store_Confi\
    guration\r\
    \n\r\
    \n# Script that will be executed after lease is assigned or de-assigned. I\
    nternal \"global\" variables that can be used in the script:\r\
    \n# leaseBound - set to \"1\" if bound, otherwise set to \"0\"\r\
    \n# leaseServerName - dhcp server name\r\
    \n# leaseActMAC - active mac address\r\
    \n# leaseActIP - active IP address\r\
    \n# lease-hostname - client hostname\r\
    \n# lease-options - array of received options\r\
    \n\r\
    \n#---------------------------------------------------teLeaseRun----------\
    ----------------------------------------------------\r\
    \n\r\
    \n:local allowList \"AllowList\"\r\
    \n:local blockList \"BlockList\"\r\
    \n\r\
    \n:global dbaseBotSettings\r\
    \n:local showLease (\$dbaseBotSettings->\"showLease\")\r\
    \n\r\
    \n:local defaultList (\$dbaseBotSettings->\"defaultList\")\r\
    \n#:local defaultList \$allowList\r\
    \n#:local defaultList \$blockList\r\
    \n\r\
    \n:local leaseName \$\"lease-hostname\"\r\
    \n\r\
    \n:if ([:len \$leaseName] = 0) do={\r\
    \n  :set leaseName \"No name\"\r\
    \n}\r\
    \n\r\
    \n:if ([:len \$leaseName] > 25) do={\r\
    \n  :set leaseName [:pick \$leaseName 0 24]\r\
    \n}\r\
    \n\r\
    \n:if (\$showLease=true) do={\r\
    \n  \$teLease leaseBound=\$leaseBound leaseServerName=\$leaseServerName le\
    aseActMAC=\$leaseActMAC leaseActIP=\$leaseActIP leaseHostname=\$leaseName \
    fDefaultList=\$defaultList\r\
    \n}\r\
    \n"
