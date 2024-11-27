#---------------------------------------------------teInlineQueryResultCachedDocument--------------------------------------------------------------

#   Represents a link to a video file stored on the Telegram servers. By default, this video file will be sent by the user with an optional
#		caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the video.

#   Params for this function:

#   1.  fType  				   			-   type of the result, must be photo
#   2.  fInlineQueryID     		-   Unique identifier for this result, 1-64 bytes
#   3.  fDocumentFileID  			-   A valid file identifier for the file
#   4.  fTitle	  						-   Title for the result

#   5.  fDescription	  			-   Optional. Short description of the result
#   6.  fCaption  						-   Optional. Caption of the photo to be sent, 0-1024 characters after entities parsing
#   7.  fInputMessageContent	-   Optional. Content of the message to be sent instead of the photo
#   8.  fReplyMarkup    			-   Optional. Inline keyboard attached to the message

#   if the global variable fDBGteInlineQueryResultCachedDocument=true, then a debug event will be logged

#---------------------------------------------------teInlineQueryResultCachedDocument--------------------------------------------------------------

:global teInlineQueryResultCachedDocument
:if (!any $teInlineQueryResultCachedDocument) do={ :global teInlineQueryResultCachedDocument do={

	:global teDebugCheck
	:local fDBGteInlineQueryResultCachedDocument [$teDebugCheck fDebugVariableName="fDBGteInlineQueryResultCachedDocument"]

	:global dbaseVersion
	:local teInlineQueryResultCachedDocumentVersion "2.07.9.22"
	:set ($dbaseVersion->"teInlineQueryResultCachedDocument") $teInlineQueryResultCachedDocumentVersion

	:local parseMode "HTML"
	:if ([:len $fCaption] >= 1024) do={:return [error message="lengthCaptionError"]}

	:local strStart "\7B"
	:local strType "\22type\22:\22$fType\22"
	:local strQueryID ",\22id\22:\22$fInlineQueryID\22"
	:local strDocumentFileID ",\22document_file_id\22:\22$fDocumentFileID\22"

	:local strTitle []; :if ([:len $fTitle] != 0) do={ :set strTitle ",\22title\22:\22$fTitle\22"	}
	:local strDescription []; :if ([:len $fDescription] != 0) do={ :set strDescription ",\22description\22:\22$fDescription\22"	}
	:local strCaption []; :if ([:len $fCaption] != 0) do={ :set strCaption ",\22caption\22:\22$fCaption\22" }
	:local strParseMode ",\22parse_mode\22:\22$parseMode\22"
	:local inputMessageContent []; :if ([:len $fInputMessageContent] != 0) do={ :set inputMessageContent ",\22input_message_content\22:$fInputMessageContent"	}
	:local strReplyMarkup []; :if ([:len $fReplyMarkup] != 0) do={ :set strReplyMarkup ",\22reply_markup\22:$fReplyMarkup" }
	:local strEnd "\7D"

	:local inlineQueryResultDocument "$strStart$strType$strQueryID$strVideoFileID$strTitle$strDescription$strCaption$strParseMode$inputMessageContent$strReplyMarkup$strEnd"

	:if ($fDBGteInlineQueryResultCachedDocument = true) do={:put "teInlineQueryResultCachedDocument = $inlineQueryResultDocument"; :log info "teInlineQueryResultCachedDocument = $inlineQueryResultDocument"}
	:return $inlineQueryResultDocument
	}
}
