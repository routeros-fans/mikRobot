#---------------------------------------------------teDeleteMessage--------------------------------------------------------------

#   Function delete the specified message
#   Params for this function:

#   1.  fChatID      -   Recipient id
#   2.  fMessageID   -   id for edited message
#   3.  fUserName    -   user Name

#   if the global variable fDBGteDeleteMessage=true, then a debug event will be logged

#---------------------------------------------------teDeleteMessage--------------------------------------------------------------

:global teDeleteMessage
:if (!any $teDeleteMessage) do={ :global teDeleteMessage do={

  :global dbaseVersion
  :local teDeleteMessageVersion "2.9.7.22"
  :set ($dbaseVersion->"teDeleteMessage") $teDeleteMessageVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")
  :local deviceName ($dbaseBotSettings->"deviceName")

  :global teDebugCheck
	:local fDBGteDeleteMessage [$teDebugCheck fDebugVariableName="fDBGteDeleteMessage"]

  :global teEditMessage

  :local oneFeed "%0D%0A"
  :local doubleFeed "%0D%0A%0D%0A"

	:local tgUrl []; :local content []

	:if ($fDBGteDeleteMessage = true) do={:put "teDeleteMessage started..."; :log info "teDeleteMessage started..."}

	:set tgUrl "https://api.telegram.org/$botID/deletemessage\?chat_id=$fChatID&message_id=$fMessageID"

	:if ($fDBGteDeleteMessage = true) do={:put "teDeleteMessage tgUrl = $tgUrl"; :log info "teDeleteMessage tgUrl = $tgUrl"}

  do {
    :set content [:tool fetch url=$tgUrl as-value output=user]
  } on-error={

    :local headerText "\F0\9F\97\91  <b>$deviceName</b> $oneFeed----------------------------------------------------$doubleFeed"
    :local bodyText ("<b>$fUserName,</b> the bot cannot delete messages older than 48 hours. $doubleFeed" )
    :local footerText ("<b>The function on the device worked normally.</b> $doubleFeed"."You can delete this message manually.$oneFeed")
    :local sendText "$headerText$bodyText$footerText"

    :if ([$teEditMessage fChatID=$fChatID fMessageID=$fMessageID fText=$sendText] != 0) do={
      :return true
    } else={ :return false }

  }
  :if ($content->"status" = "finished")	do={
		:if ($fDBGteDeleteMessage = true) do={:put "teDeleteMessage finished"; :log info "teDeleteMessage finished"}
		:return true
	} else={ :return false }
 }
}
