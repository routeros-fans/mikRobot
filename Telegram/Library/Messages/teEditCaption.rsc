#---------------------------------------------------teEditCaption--------------------------------------------------------------

#   Function edits the specified message caption
#   Params for this function:

#   1.  fChatID       -   Recipient id
#   2.  fMessageID    -   id for edited message
#   3.  fText         -   Message text
#   4.  fReplyMarkup  -   Reply markup (may be empty)

#   Function return message ID or 0

#   if the global variable fDBGteEditCaption=true, then a debug event will be logged

#---------------------------------------------------teEditCaption--------------------------------------------------------------

:global teEditCaption
:if (!any $teEditCaption) do={ :global teEditCaption do={

  :global teDebugCheck
	:local fDBGteEditCaption [$teDebugCheck fDebugVariableName="fDBGteEditCaption"]

  :global dbaseVersion
  :local teEditCaptionVersion "2.9.7.22"
  :set ($dbaseVersion->"teEditCaption") $teEditCaptionVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

  :local disableWebPagePreview true
	:local parseMode "html"

	:local tgUrl []; :local result []; :local content []

	:if ($fDBGteEditCaption = true) do={:put "teEditCaption started..."; :log info "teEditCaption started..."}

  :if ([:len $fText] = 0) do={:set $fText ""}
  :if ([:len $fText] >= 1024) do={:return [error message="lengthCaptionError"]}

	:if ([:len $fReplyMarkup] != 0) do={
    :set tgUrl "https://api.telegram.org/$botID/editMessageCaption\?chat_id=$fChatID&message_id=$fMessageID&caption=$fText&parse_mode=$parseMode&reply_markup=$fReplyMarkup"
	} else={
    :set tgUrl "https://api.telegram.org/$botID/editMessageCaption\?chat_id=$fChatID&message_id=$fMessageID&caption=$fText&parse_mode=$parseMode"
	}

	:if ($fDBGteEditCaption = true) do={:put "teEditCaption tgUrl = $tgUrl"; :log info "teEditCaption tgUrl = $tgUrl"}

  do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]
  	:if ($content->"status" = "finished")	do={
      :local tmpStr [:pick ($content->"data") ([:find ($content->"data") "message_id"]) ([:find ($content->"data") "_id"]+20)]
      :local messageID [:pick $tmpStr ([:find $tmpStr "message_id"]+12) ([:find $tmpStr ","])]
      :if ($fDBGteEditCaption = true) do={:put "teEditCaption messageID = $messageID"; :log info "teEditCaption messageID = $messageID"}
  		:set result $messageID
  		:return $result
  	} else={:return 0 }
  } on-error={
    :if ($fDBGteEditCaption = true) do={:put "teEditCaption ERROR"; :log info "teEditCaption ERROR"}
    :return 0
  }

 }
}
