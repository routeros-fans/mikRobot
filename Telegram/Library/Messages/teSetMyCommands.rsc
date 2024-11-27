#---------------------------------------------------teSetMyCommands--------------------------------------------------------------

#   Function sends a message to the recipient.
#   Params for this function:

#   1.  fCommands       -   array of commands with descriptions

#   command         -   text of the command; 1-32 characters. Can contain only lowercase English letters, digits and underscores.
#   description     -   description of the command; 1-256 characters

#   Usage example:

#   $teSetMyCommands fCommands="command;description"
#   $teSetMyCommands fCommands="command;description,command;description"

#   $teSetMyCommands fCommands="getifaces;Get interfaces list,getusers;Get users list"

#   Function return 1 or 0

#   if the global variable fDBGteSetMyCommands=true, then a debug event will be logged

#---------------------------------------------------teSetMyCommands--------------------------------------------------------------

:global teSetMyCommands
:if (!any $teSetMyCommands) do={ :global teSetMyCommands do={

  :global teDebugCheck
	:local fDBGteSetMyCommands [$teDebugCheck fDebugVariableName="fDBGteSetMyCommands"]

  :global dbaseVersion
  :local teSetMyCommandsVersion "2.9.7.22"
  :set ($dbaseVersion->"teSetMyCommands") $teSetMyCommandsVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

  :local tgUrl []; :local content []

  :local commandsList [:toarray $fCommands]
  :local cmdItems []
  :local command []

  :foreach i in=$commandsList do={
    :local command [:pick $i 0 [find $i ";"]]
    :local description [:pick $i ([find $i ";"] + 1) [:len $i]]
    :local startCommand "\7B\22command\22:\22$command\22"
    :local commandDescription ",\22description\22:\22$description\22\7D,"
    :set command "$startCommand$commandDescription$endCommand"
    :set $cmdItems ($cmdItems . $command)
  }
  :set cmdItems [:pick $cmdItems 0 ([:len $cmdItems] - 1)]

  :local start "\5B"
  :local end "\5D"
  :set commandsList "$start$cmdItems$end"

  :set tgUrl "https://api.telegram.org/$botID/setMyCommands\?commands=$commandsList"
  :if ($fDBGteSetMyCommands = true) do={:put "teSetMyCommands tgUrl = $tgUrl"; :log info "teSetMyCommands tgUrl = $tgUrl"}

	do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]
    :if ($content->"status" = "finished")	do={:return 1}
  } on-error={
    :if ($fDBGteSetMyCommands = true) do={:put "teSetMyCommands ERROR"; :log info "teSetMyCommands ERROR"}
    :return 0
  }

 }
}
