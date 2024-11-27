#---------------------------------------------------dbaseInlineCommands--------------------------------------------------------------

#   Script the array contains commands for the terminal

#---------------------------------------------------dbaseInlineCommands--------------------------------------------------------------

:global dbaseInlineCommands [:toarray ""]
:local dbName "dbaseInlineCommands"

:set dbaseInlineCommands ({$dbName;
                "teTerminal,Jobs count,=> :set \$jobCount [system script job print as-value count-only]; :return \$jobCount";
                "teTerminal,Active lease count,=> :set \$leaseCount [ip dhcp-server lease print as-value count-only where !disabled]; :return \$leaseCount";
                "teTerminal,Wi-Fi clients count,=> :set \$wirelessCount [interface wireless registration-table print as-value count-only]; :return \$wirelessCount";
                })
