#---------------------------------------------------teInlineQueryResultCachedVoice--------------------------------------------------------------

#   Represents a link to a voice message stored on the Telegram servers. By default, this voice message will be sent by the user.
#		Alternatively, you can use input_message_content to send a message with the specified content instead of the voice message.

#   Params for this function:

#   1.  fType  				   			-   type of the result, must be photo
#   2.  fInlineQueryID     		-   Unique identifier for this result, 1-64 bytes
#   3.  fVoiceFileID    			-   A valid file identifier for the voice message

#   4.  fTitle	  						-   Optional. Title for the result
#   6.  fCaption  						-   Optional. Caption of the photo to be sent, 0-1024 characters after entities parsing
#   7.  fInputMessageContent	-   Optional. Content of the message to be sent instead of the photo
#   8.  fReplyMarkup    			-   Optional. Inline keyboard attached to the message

#   if the global variable fDBGteInlineQueryResultCachedVoice=true, then a debug event will be logged

#---------------------------------------------------teInlineQueryResultCachedVoice--------------------------------------------------------------

:global teInlineQueryResultCachedVoice
:if (!any $teInlineQueryResultCachedVoice) do={ :global teInlineQueryResultCachedVoice do={

	:global teDebugCheck
	:local fDBGteInlineQueryResultCachedVoice [$teDebugCheck fDebugVariableName="fDBGteInlineQueryResultCachedVoice"]

	:global dbaseVersion
	:local teInlineQueryResultCachedVoiceVersion "2.07.9.22"
	:set ($dbaseVersion->"teInlineQueryResultCachedVoice") $teInlineQueryResultCachedVoiceVersion

	:local parseMode "HTML"
	:if ([:len $fCaption] >= 1024) do={:return [error message="lengthCaptionError"]}

	:local strStart "\7B"
	:local strType "\22type\22:\22$fType\22"
	:local strQueryID ",\22id\22:\22$fInlineQueryID\22"
	:local strVoiceFileID ",\22voice_file_id\22:\22$fVoiceFileID\22"

	:local strTitle []; :if ([:len $fTitle] != 0) do={ :set strTitle ",\22title\22:\22$fTitle\22"	}
	:local strCaption []; :if ([:len $fCaption] != 0) do={ :set strCaption ",\22caption\22:\22$fCaption\22" }
	:local strParseMode ",\22parse_mode\22:\22$parseMode\22"
	:local inputMessageContent []; :if ([:len $fInputMessageContent] != 0) do={ :set inputMessageContent ",\22input_message_content\22:$fInputMessageContent"	}
	:local strReplyMarkup []; :if ([:len $fReplyMarkup] != 0) do={ :set strReplyMarkup ",\22reply_markup\22:$fReplyMarkup" }
	:local strEnd "\7D"

	:local inlineQueryResultCachedVoice "$strStart$strType$strQueryID$strVoiceFileID$strTitle$strCaption$strParseMode$inputMessageContent$strReplyMarkup$strEnd"

	:if ($fDBGteInlineQueryResultCachedVoice = true) do={:put "teInlineQueryResultCachedVoice = $inlineQueryResultCachedVoice"; :log info "teInlineQueryResultCachedVoice = $inlineQueryResultCachedVoice"}
	:return $inlineQueryResultCachedVoice
	}
}
