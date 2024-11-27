#---------------------------------------------------dbaseUsers--------------------------------------------------------------

#   User database, contains information about current user rights and usage statistics

#---------------------------------------------------dbaseUsers--------------------------------------------------------------

:global dbaseUsers [:toarray ""]
:local dbName "dbaseUsers"

:set dbaseUsers ({$dbName;
                  1234567890={root=true;leaseread=true;leasewrite=false;leasedelete=true;pppread=true;pppwrite=true;pppdelete=true;usersread=true;userswrite=true;usersdelete=true;ifaceread=true;ifacewrite=true;ifacedelete=true;systemread=true;systembackup=true;systemupdate=true;scriptrun=true;terminal=true};
                  1234567890={root=true;leaseread=true;leasewrite=true;leasedelete=true;pppread=true;pppwrite=true;pppdelete=true;usersread=true;userswrite=true;usersdelete=true;ifaceread=true;ifacewrite=false;ifacedelete=false};
               })
