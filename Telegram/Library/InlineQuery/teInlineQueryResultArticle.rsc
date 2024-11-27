#---------------------------------------------------teInlineQueryResultArticle--------------------------------------------------------------

#   Represents a link to an article or web page.
#   Params for this function:

#   1.  fType  				   			-   ype of the result, must be article
#   2.  fInlineQueryID     		-   Unique identifier for this result, 1-64 bytes
#   3.  fTitle	  						-   Title for the result
#   4.  fInputMessageContent	-   Content of the message to be sent

#   5.  fArticleUrl 	 			  -   Optional. URL of the result
#   6.  fHideUrl	  	 			  -   Optional. Pass True if you don't want the URL to be shown in the message
#   7.  fDescription	  			-   Optional. Short description of the result
#   8.  fThumbUrl  						-   Optional. Url of the thumbnail for the result
#   9.  fThumbWidth 					-   Optional. Thumbnail width
#   10. fThumbHeight					-   Optional. Thumbnail height
#   11. fReplyMarkup    			-   Optional. Thumbnail height

#   if the global variable fDBGteInlineQueryResultArticle=true, then a debug event will be logged
#
#---------------------------------------------------teInlineQueryResultArticle--------------------------------------------------------------

:global teInlineQueryResultArticle
:if (!any $teInlineQueryResultArticle) do={ :global teInlineQueryResultArticle do={

	:global teDebugCheck
	:local fDBGteInlineQueryResultArticle [$teDebugCheck fDebugVariableName="fDBGteInlineQueryResultArticle"]

	:global dbaseVersion
	:local teInlineQueryResultArticleVersion "2.07.9.22"
	:set ($dbaseVersion->"teInlineQueryResultArticle") $teInlineQueryResultArticleVersion

	:local strStart "\7B"
	:local strType "\22type\22:\22article\22"
	:local strQueryID ",\22id\22:\22$fInlineQueryID\22"
	:local strTitle ",\22title\22:\22$fTitle\22"
	:local strInputMessageContent ",\22input_message_content\22:$fInputMessageContent"

	:local strArticleUrl []; :if ([:len $fArticleUrl] != 0) do={ :set strArticleUrl ",\22url\22:\22$fArticleUrl\22" }
	:local strHideUrl []; :if ([:len $fHideUrl] != 0) do={ :set strHideUrl ",\22hide_url\22:$fHideUrl" }
	:local strDescription []; :if ([:len $fDescription] != 0) do={ :set strDescription ",\22description\22:\22$fDescription\22"	}
	:local strThumbUrl []; :if ([:len $fThumbUrl] != 0) do={ :set strThumbUrl ",\22thumb_url\22:\22$fThumbUrl\22" }
	:local strThumbWidth []; :if ([:len $fThumbWidth] != 0) do={ :set strThumbWidth ",\22thumb_width\22:$fThumbWidth"	}
	:local strThumbHeight []; :if ([:len $fThumbHeight] != 0) do={ :set strThumbHeight ",\22thumb_height\22:$fThumbHeight" }
	:local strReplyMarkup []; :if ([:len $fReplyMarkup] != 0) do={ :set strReplyMarkup ",\22reply_markup\22:$fReplyMarkup" }
	:local strEnd "\7D"

	:local inlineQueryResultArticle "$strStart$strType$strQueryID$strTitle$strArticleUrl$strHideUrl$strDescription$strThumbUrl$strThumbWidth\
																   $strThumbHeight$strInputMessageContent$strReplyMarkup$strEnd"

	:if ($fDBGteInlineQueryResultArticle = true) do={:put "teInlineQueryResultArticle = $inlineQueryResultArticle"; :log info "teInlineQueryResultArticle = $inlineQueryResultArticle"}
	:return $inlineQueryResultArticle
	}
}
