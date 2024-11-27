#---------------------------------------------------teSendMessage--------------------------------------------------------------

#   Function sends a message to the recipient.
#   Params for this function:

#   1.  fChatID       -   Recipient id
#   2.  fText         -   Message text
#   3.  fReplyMarkup  -   Reply markup (may be empty)

#   Function return $messageID or 0

#   if the global variable fDBGteSendMessage=true, then a debug event will be logged

#---------------------------------------------------teSendMessage--------------------------------------------------------------

:global teSendMessage
:if (!any $teSendMessage) do={ :global teSendMessage do={

  :global teDebugCheck
	:local fDBGteSendMessage [$teDebugCheck fDebugVariableName="fDBGteSendMessage"]

  :global dbaseVersion
  :local teSendMessageVersion "2.9.7.22"
  :set ($dbaseVersion->"teSendMessage") $teSendMessageVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

	:local disableWebPagePreview true
	:local parseMode "html"

  :local lenText [:len $fText]
  :if ($fDBGteSendMessage = true) do={:put "teSendMessage lenText=$lenText"; :log info "teSendMessage lenText=$lenText"}

	:local tgUrl []; :local result []; :local content []
  :if ([:len $fText] >= 4096) do={:return [error message="lengthCaptionError"]}

	:if ($fDBGteSendMessage = true) do={:put "teSendMessage started..."; :log info "teSendMessage started..."}

	:if ([:len $fReplyMarkup] != 0) do={
		:set tgUrl "https://api.telegram.org/$botID/sendmessage\?chat_id=$fChatID&text=$fText&parse_mode=$parseMode&disable_web_page_preview=$disableWebPagePreview&reply_markup=$fReplyMarkup"
	}
	:if ([:len $fReplyMarkup] = 0) do={
		:set tgUrl "https://api.telegram.org/$botID/sendmessage\?chat_id=$fChatID&text=$fText&parse_mode=$parseMode&disable_web_page_preview=$disableWebPagePreview"
	}

  :if ($fDBGteSendMessage = true) do={:put "teSendMessage tgUrl = $tgUrl"; :log info "teSendMessage tgUrl = $tgUrl"}

	do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]
  } on-error={
    :if ($fDBGteSendMessage = true) do={:put "teSendMessage ERROR"; :log info "teSendMessage ERROR"}
    :return 0
  }

  :if ($content->"status" = "finished")	do={
    :local tmpStr [:pick ($content->"data") ([:find ($content->"data") "message_id"]) ([:find ($content->"data") "_id"]+20)]
    :local messageID [:pick $tmpStr ([:find $tmpStr "message_id"]+12) ([:find $tmpStr ","])]
    :if ($fDBGteSendMessage = true) do={:put ($content->"data"); :log info ($content->"data")}
    :set result $messageID
    :if ($fDBGteSendMessage = true) do={:put "teSendMessage result = $result"; :log info "teSendMessage result = $result"}
    :return $result
  } else={ :return 0 }

 }
}
