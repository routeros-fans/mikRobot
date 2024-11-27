#---------------------------------------------------teEditMessage--------------------------------------------------------------

#   Function edits the specified message
#   Params for this function:

#   1.  fChatID       -   Recipient id
#   2.  fMessageID    -   id for edited message
#   3.  fText         -   Message text
#   4.  fReplyMarkup  -   Reply markup (may be empty)

#   Function return message ID or 0

#   if the global variable fDBGteEditMessage=true, then a debug event will be logged

#---------------------------------------------------teEditMessage--------------------------------------------------------------

:global teEditMessage
:if (!any $teEditMessage) do={ :global teEditMessage do={

  :global teDebugCheck
	:local fDBGteEditMessage [$teDebugCheck fDebugVariableName="fDBGteEditMessage"]

  :global dbaseVersion
  :local teEditMessageVersion "2.9.7.22"
  :set ($dbaseVersion->"teEditMessage") $teEditMessageVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

  :local disableWebPagePreview true
	:local parseMode "html"

	:local tgUrl []; :local result []; :local content []

  :if ([:len $fText] = 0) do={:set $fText ""}
  :if ([:len $fText] >= 4096) do={:return [error message="lengthCaptionError"]}

	:if ($fDBGteEditMessage = true) do={:put "teEditMessage started..."; :log info "teEditMessage started..."}

	:if ([:len $fReplyMarkup] != 0) do={
    :set tgUrl "https://api.telegram.org/$botID/editMessageText\?chat_id=$fChatID&message_id=$fMessageID&text=$fText&parse_mode=$parseMode&disable_web_page_preview=$disableWebPagePreview&reply_markup=$fReplyMarkup"
	} else={
    :set tgUrl "https://api.telegram.org/$botID/editMessageText\?chat_id=$fChatID&message_id=$fMessageID&text=$fText&parse_mode=$parseMode&disable_web_page_preview=$disableWebPagePreview"
	}

	:if ($fDBGteEditMessage = true) do={:put "teEditMessage tgUrl = $tgUrl"; :log info "teEditMessage tgUrl = $tgUrl"}

  do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]

  	:if ($content->"status" = "finished")	do={
      :local tmpStr [:pick ($content->"data") ([:find ($content->"data") "message_id"]) ([:find ($content->"data") "_id"]+20)]
      :local messageID [:pick $tmpStr ([:find $tmpStr "message_id"]+12) ([:find $tmpStr ","])]
  		:set result $messageID
      :if ($fDBGteEditMessage = true) do={:put "teEditMessage result = $result"; :log info "teEditMessage result = $result"}
  		:return $result
  	} else={ :return 0	}
  } on-error={
    :if ($fDBGteEditMessage = true) do={:put "teEditMessage ERROR"; :log info "teEditMessage ERROR"}
    :return 0
  }
 }
}
