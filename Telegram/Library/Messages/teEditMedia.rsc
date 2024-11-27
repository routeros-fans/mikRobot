#---------------------------------------------------teEditMedia--------------------------------------------------------------

#   Params for this function:

#   1.  fChatID       -   Recipient id
#   2.  fMessageID    -   id for edited message

#   3.  fMediaType    -   This object represents the content of a media message to be edit. It should be one of:
#                         Animation, Document, Audio, Photo, Video

#   4.  fMediaLink    -   Message media,
#   5.  fMediaCaption -   Message caption
#   6.  fReplyMarkup  -   Reply markup (may be empty)

#   photo (media, caption)

#   Function return message ID or 0

#   if the global variable fDBGteEditMedia=true, then a debug event will be logged

#---------------------------------------------------teEditMedia--------------------------------------------------------------

:global teEditMedia
:if (!any $teEditMedia) do={ :global teEditMedia do={

  :global teDebugCheck
	:local fDBGteEditMedia [$teDebugCheck fDebugVariableName="fDBGteEditMedia"]

  :global dbaseVersion
  :local teEditMediaVersion "2.9.7.22"
  :set ($dbaseVersion->"teEditMedia") $teEditMediaVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

  :local disableWebPagePreview true
	:local parseMode "html"

	:local tgUrl []; :local result []; :local content []
  :local newMedia []

  :if ([:len $fMediaCaption] >= 1024) do={:return [error message="lengthCaptionError"]}

  :local inputMediaType "\7B\22type\22:\22$fMediaType"
  :local inputMediaLink "\22,\22media\22:\22"
  :local inputMediaCaption "\22,\22caption\22:\22"
  :local endMedia "\22\7D"

  :if ($fDBGteEditMedia = true) do={:put "teEditMedia started..."; :log info "teEditMedia started..."}

  :if ([:len $fMediaCaption] = 0) do={
    :set newMedia "$inputMediaType$inputMediaLink$fMediaLink$endMedia"
  } else={
    :set newMedia "$inputMediaType$inputMediaLink$fMediaLink$inputMediaCaption$fMediaCaption$endMedia"
  }

  :if ($fDBGteEditMedia = true) do={:put "teEditMedia media = $newMedia"; :log info "teEditMedia media = $newMedia"}

	:if ([:len $fReplyMarkup] != 0) do={
    :set tgUrl "https://api.telegram.org/$botID/editMessageMedia\?chat_id=$fChatID&message_id=$fMessageID&media=$newMedia&parse_mode=$parseMode&reply_markup=$fReplyMarkup"
	} else={
    :set tgUrl "https://api.telegram.org/$botID/editMessageMedia\?chat_id=$fChatID&message_id=$fMessageID&media=$newMedia&parse_mode=$parseMode"
	}

	:if ($fDBGteEditMedia = true) do={:put "teEditCaption tgUrl = $tgUrl"; :log info "teEditCaption tgUrl = $tgUrl"}

  do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]

  	:if ($content->"status" = "finished")	do={
      :local tmpStr [:pick ($content->"data") ([:find ($content->"data") "message_id"]) ([:find ($content->"data") "_id"]+20)]
      :local messageID [:pick $tmpStr ([:find $tmpStr "message_id"]+12) ([:find $tmpStr ","])]
      :if ($fDBGteEditMedia = true) do={:put "teEditMedia messageID = $messageID"; :log info "teEditMedia messageID = $messageID"}
  		:set result $messageID
  		:return $result
  	} else={ :return 0	}
  } on-error={
    :if ($fDBGteEditMedia = true) do={:put "teEditMedia ERROR"; :log info "teEditMedia ERROR"}
    :return 0
  }
 }
}
