#---------------------------------------------------teEditMessageReplyMarkup--------------------------------------------------------------

#   Function edits the specified message reply_markup
#   Params for this function:

#   1.  fChatID       -   Recipient id
#   2.  fMessageID    -   id for edited message
#   3.  fReplyMarkup  -   Reply markup

#   Function return message ID or 0

#   if the global variable fDBGteEditMessageReplyMarkup=true, then a debug event will be logged

#---------------------------------------------------teEditMessageReplyMarkup--------------------------------------------------------------

:global teEditMessageReplyMarkup
:if (!any $teEditMessageReplyMarkup) do={ :global teEditMessageReplyMarkup do={

  :global teDebugCheck
	:local fDBGteEditMessageReplyMarkup [$teDebugCheck fDebugVariableName="fDBGteEditMessageReplyMarkup"]

  :global dbaseVersion
  :local teEditMessageReplyMarkupVersion "2.9.7.22"
  :set ($dbaseVersion->"teEditMessageReplyMarkup") $teEditMessageReplyMarkupVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

  :local disableWebPagePreview true
	:local parseMode "html"

	:local tgUrl []; :local result []; :local content []

	:if ($fDBGteEditMessageReplyMarkup = true) do={:put "teEditMessageReplyMarkup started..."; :log info "teEditMessageReplyMarkup started..."}

	:if ([:len $fReplyMarkup] != 0) do={
    :set tgUrl "https://api.telegram.org/$botID/editMessageReplyMarkup\?chat_id=$fChatID&message_id=$fMessageID&reply_markup=$fReplyMarkup"
	} else={
    :if ($fDBGteEditMessageReplyMarkup = true) do={:put "teEditMessageReplyMarkup ERROR"; :log info "teEditMessageReplyMarkup ERROR"}
    :return 0
  }

	:if ($fDBGteEditMessageReplyMarkup = true) do={:put "teEditMessageReplyMarkup tgUrl = $tgUrl"; :log info "teEditMessageReplyMarkup tgUrl = $tgUrl"}

  do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]
  } on-error={
      :if ($fDBGteEditMessageReplyMarkup = true) do={:put "teEditMessageReplyMarkup ERROR"; :log info "teEditMessageReplyMarkup ERROR"}
      :return 0
  }

  	:if ($content->"status" = "finished")	do={

      :local tmpStr [:pick ($content->"data") ([:find ($content->"data") "message_id"]) ([:find ($content->"data") "_id"]+20)]
      :local messageID [:pick $tmpStr ([:find $tmpStr "message_id"]+12) ([:find $tmpStr ","])]
      :if ($fDBGteEditMessageReplyMarkup = true) do={:put "teEditMessageReplyMarkup messageID = $messageID"; :log info "teEditMessageReplyMarkup messageID = $messageID"}
  		:set result $messageID
  		:return $result

  	} else={ :return 0 }

 }
}
