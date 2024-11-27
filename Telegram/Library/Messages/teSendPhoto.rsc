#---------------------------------------------------teSendPhoto--------------------------------------------------------------

#   Function sends a message to the recipient.
#   Params for this function:

#   1.  fChatID       -   Recipient id
#   2.  fPhoto        -   Photo
#   3.  fText         -   Message text
#   4.  fReplyMarkup  -   Reply markup (may be empty)

#   Function return $messageID or 0

#   if the global variable fDBGteSendPhoto=true, then a debug event will be logged

#---------------------------------------------------teSendPhoto--------------------------------------------------------------

:global teSendPhoto
:if (!any $teSendPhoto) do={ :global teSendPhoto do={

  :global teDebugCheck
	:local fDBGteSendPhoto [$teDebugCheck fDebugVariableName="fDBGteSendPhoto"]

  :global dbaseVersion
  :local teSendPhotoVersion "2.9.7.22"
  :set ($dbaseVersion->"teSendPhoto") $teSendPhotoVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

  :local disableWebPagePreview true
	:local parseMode "html"

	:local tgUrl []; :local result []; :local content []

	:if ($fDBGteSendPhoto = true) do={:put "teSendPhoto started..."; :log info "teSendPhoto started..."}

  :if ([:len $fText] = 0) do={:set $fText ""}
  :if ([:len $fText] >= 1024) do={:return [error message="lengthCaptionError"]}

	:if ([:len $fReplyMarkup] != 0) do={
		:set tgUrl "https://api.telegram.org/$botID/sendphoto\?chat_id=$fChatID&photo=$fPhoto&caption=$fText&parse_mode=$parseMode&reply_markup=$fReplyMarkup"
	}
	:if ([:len $fReplyMarkup] = 0) do={
		:set tgUrl "https://api.telegram.org/$botID/sendphoto\?chat_id=$fChatID&photo=$fPhoto&caption=$fText&parse_mode=$parseMode"
	}

  :if ($fDBGteSendPhoto = true) do={:put "teSendPhoto tgUrl = $tgUrl"; :log info "teSendPhoto tgUrl = $tgUrl"}

	do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]
  } on-error={
    :if ($fDBGteSendPhoto = true) do={:put "teSendPhoto ERROR"; :log info "teSendPhoto ERROR"}
    :return 0
  }

  :if ($content->"status" = "finished")	do={
    :local tmpStr [:pick ($content->"data") ([:find ($content->"data") "message_id"]) ([:find ($content->"data") "_id"]+20)]
    :local messageID [:pick $tmpStr ([:find $tmpStr "message_id"]+12) ([:find $tmpStr ","])]
    :if ($fDBGteSendPhoto = true) do={:put ($content->"data"); :log info ($content->"data")}
    :set result $messageID
    :if ($fDBGteSendPhoto = true) do={:put "teSendPhoto result = $result"; :log info "teSendPhoto result = $result"}
    :return $result
  } else={ :return 0 }

 }
}
