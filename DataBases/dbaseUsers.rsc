#---------------------------------------------------dbaseUsers--------------------------------------------------------------

#   User database, contains information about current user rights and usage statistics

#---------------------------------------------------dbaseUsers--------------------------------------------------------------

:global dbaseUsers [:toarray ""]
:local dbName "dbaseUsers"

:set dbaseUsers ({$dbName;
                  77621983={root=true;leaseread=true;leasewrite=true;leasedelete=true;pppread=true;pppwrite=true;pppdelete=true;usersread=true;userswrite=true;usersdelete=true;ifaceread=true;ifacewrite=true;ifacedelete=true;systemread=true;systembackup=true;systemupdate=true;scriptrun=true;terminal=true};
                  2125568110={root=true;leaseread=true;leasewrite=false;leasedelete=false;pppread=true;pppwrite=false;pppdelete=false;usersread=true;userswrite=false;usersdelete=false;ifaceread=true;ifacewrite=false;ifacedelete=false;systemread=true};
                  6480329736={root=true;leaseread=true;leasewrite=false;leasedelete=false;pppread=true;pppwrite=false;pppdelete=false;usersread=true;userswrite=false;usersdelete=false;ifaceread=true;ifacewrite=false;ifacedelete=false;systemread=true};
               })
