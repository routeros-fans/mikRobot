#---------------------------------------------------teInlineQueryResultPhoto--------------------------------------------------------------

#   Represents a link to a photo. By default, this photo will be sent by the user with optional caption. Alternatively,
#		you can use input_message_content to send a message with the specified content instead of the photo.

#   Params for this function:

#   1.  fType  				   			-   ype of the result, must be photo
#   2.  fInlineQueryID     		-   Unique identifier for this result, 1-64 bytes
#   3.  fPhotoUrl	 `	 			  -   A valid URL of the photo. Photo must be in JPEG format. Photo size must not exceed 5MB
#   4.  fThumbUrl	 `	 			  -   URL of the thumbnail for the photo

#   5.  fTitle	  						-   Optional. Title for the result
#   6.  fDescription	  			-   Optional. Short description of the result
#   7.  fCaption  						-   Optional. Caption of the photo to be sent, 0-1024 characters after entities parsing
#   8.  fInputMessageContent	-   Optional. Content of the message to be sent instead of the photo
#   9.  fReplyMarkup    			-   Optional. Inline keyboard attached to the message

#   if the global variable fDBGteInlineQueryResultPhoto=true, then a debug event will be logged


#---------------------------------------------------teInlineQueryResultPhoto--------------------------------------------------------------

:global teInlineQueryResultPhoto
:if (!any $teInlineQueryResultPhoto) do={ :global teInlineQueryResultPhoto do={

	:global teDebugCheck
	:local fDBGteInlineQueryResultPhoto [$teDebugCheck fDebugVariableName="fDBGteInlineQueryResultPhoto"]

	:global dbaseVersion
	:local teInlineQueryResultPhotoVersion "2.07.9.22"
	:set ($dbaseVersion->"teInlineQueryResultPhoto") $teInlineQueryResultPhotoVersion

	:local parseMode "HTML"

	:if ([:len $fCaption] >= 1024) do={:return [error message="lengthCaptionError"]}

	:local strStart "\7B"
	:local strType "\22type\22:\22$fType\22"
	:local strQueryID ",\22id\22:\22$fInlineQueryID\22"
	:local strPhotoUrl ",\22photo_url\22:\22$fPhotoUrl\22"
	:local strThumbUrl ",\22thumb_url\22:\22$fThumbUrl\22"

	:local strTitle []; :if ([:len $fTitle] != 0) do={ :set strTitle ",\22title\22: \22$fTitle\22" }
	:local strDescription []; :if ([:len $fDescription] != 0) do={ :set strDescription ",\22description\22: \22$fDescription\22" }
	:local strCaption []; :if ([:len $fCaption] !=0) do={ :set strCaption ",\22caption\22:\22$fCaption\22" }
	:local strParseMode ",\22parse_mode\22:\22$parseMode\22"
	:local inputMessageContent []; :if ([:len $fInputMessageContent] != 0) do={ :set inputMessageContent ",\22input_message_content\22:$fInputMessageContent"	}
	:local strReplyMarkup []; :if ([:len $fReplyMarkup] !=0) do={ :set strReplyMarkup ",\22reply_markup\22:$fReplyMarkup"	}
	:local strEnd "\7D"

	:local InlineQueryResultPhoto "$strStart$strType$strQueryID$strPhotoUrl$strThumbUrl$strTitle$strDescription$strCaption$strParseMode$inputMessageContent$strReplyMarkup$strEnd"

	:if ($fDBGteInlineQueryResultPhoto = true) do={:put "teInlineQueryResultPhoto = $InlineQueryResultPhoto"; :log info "teInlineQueryResultPhoto = $InlineQueryResultPhoto"}
	:return $InlineQueryResultPhoto
	}
}
