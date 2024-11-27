# aug/01/2022 14:55:12 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=saveDbShedul.rsc]] != 0) do={ remove saveDbShedul.rsc }
add dont-require-permissions=no name=saveDynLeaseShedul owner=admin policy=\
    ftp,read,write,policy,test source=":global teDbSave\r\
    \n:global dbaseDynLease\r\
    \n\r\
    \n:local dbName \$dbaseDynLease\r\
    \n:local dbSize 2\r\
    \n\r\
    \n\$teDbSave fDBSave=\$dbName fDBSize=\$dbSize\r\
    \n"
