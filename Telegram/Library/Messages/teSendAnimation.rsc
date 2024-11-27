#---------------------------------------------------teSendAnimation--------------------------------------------------------------

#   Function sends a message to the recipient.
#   Params for this function:

#   1.  fChatID       -   Recipient id
#   2.  fMedia        -   Message Photo
#   3.  fText         -   Message text
#   4.  fReplyMarkup  -   Reply markup (may be empty)

#   Function return $messageID or 0

#   if the global variable fDBGteSendAnimation=true, then a debug event will be logged

#---------------------------------------------------teSendAnimation--------------------------------------------------------------

:global teSendAnimation
:if (!any $teSendAnimation) do={ :global teSendAnimation do={

  :global teDebugCheck
	:local fDBGteSendAnimation [$teDebugCheck fDebugVariableName="fDBGteSendAnimation"]

  :global dbaseVersion
  :local teSendAnimationVersion "2.9.7.22"
  :set ($dbaseVersion->"teSendAnimation") $teSendAnimationVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

	:local parseMode "html"

	:local tgUrl []; :local result []; :local content []

	:if ($fDBGteSendAnimation = true) do={:put "teSendAnimation started..."; :log info "teSendAnimation started..."}

  :if ([:len $fText] = 0) do={:set $fText ""}
  :if ([:len $fText] >= 1024) do={:return [error message="lengthCaptionError"]}

	:if ([:len $fReplyMarkup] != 0) do={
		:set tgUrl "https://api.telegram.org/$botID/sendanimation\?chat_id=$fChatID&animation=$fMedia&caption=$fText&parse_mode=$parseMode&reply_markup=$fReplyMarkup"
	}
	:if ([:len $fReplyMarkup] = 0) do={
		:set tgUrl "https://api.telegram.org/$botID/sendanimation\?chat_id=$fChatID&animation=$fMedia&caption=$fText&parse_mode=$parseMode"
	}

  :if ($fDBGteSendAnimation = true) do={:put "teSendAnimation tgUrl = $tgUrl"; :log info "teSendAnimation tgUrl = $tgUrl"}

	do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]
  } on-error={
    :if ($fDBGteSendAnimation = true) do={:put "teSendAnimation ERROR"; :log info "teSendAnimation ERROR"}
    :return 0
  }

    :if ($content->"status" = "finished")	do={
      :local tmpStr [:pick ($content->"data") ([:find ($content->"data") "message_id"]) ([:find ($content->"data") "_id"]+20)]
      :local messageID [:pick $tmpStr ([:find $tmpStr "message_id"]+12) ([:find $tmpStr ","])]
      :if ($fDBGteSendAnimation = true) do={:put ($content->"data"); :log info ($content->"data")}

      :set result $messageID
      :if ($fDBGteSendAnimation = true) do={:put "teSendAnimation result = $result"; :log info "teSendAnimation result = $result"}
      :return $result
    } else={ :return 0 }
 }
}
