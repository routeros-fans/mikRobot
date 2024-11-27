#---------------------------------------------------dbaseCommands--------------------------------------------------------------

#   Script the array contains commands for the terminal

#---------------------------------------------------dbaseCommands--------------------------------------------------------------

:global dbaseCommands [:toarray ""]
:local dbName "dbaseCommands"

:set dbaseCommands ({$dbName;
                "prefix"="=> ";
                "my cmd"="teTerminal";
                "add sstp"="=> :set \$n user01; :set \$pr SstpProfile; :set \$src sstp; :global teGenValue; set \$p [\$teGenValue]; :set \$s :; ppp secret add name=\$n password=\$p profile=\$pr service=\$src; :return (\$n.\$s.\$p) ";
                "add user"="=> :set \$n user01; :set \$g read; :set \$d yes; :global teGenValue; set \$p [\$teGenValue]; :set \$s :; user add name=\$n group=\$g password=\$p disabled=\$d; :return (\$n.\$s.\$p) ";
                })
