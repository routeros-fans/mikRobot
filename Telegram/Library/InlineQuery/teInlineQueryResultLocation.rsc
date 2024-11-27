#---------------------------------------------------teInlineQueryResultLocation--------------------------------------------------------------

#   Represents a location on a map. By default, the location will be sent by the user. Alternatively, you can use input_message_content to
#		send a message with the specified content instead of the location.

#   Params for this function:

#   1.  fType  				   			-   type of the result, must be location
#   2.  fInlineQueryID     		-   Unique identifier for this result, 1-64 bytes
#   3.  fLatitude  						-   Latitude of the venue location in degrees
#   4.  fLongitude 						-   Longitude of the venue location in degrees
#   5.  fTitle	  						-   Title of the venue

#   6.  fHorizontalAccuracy 	-   Optional. The radius of uncertainty for the location, measured in meters; 0-1500
#   7.  fLivePeriod		 			  -   Optional. Period in seconds for which the location can be updated, should be between 60 and 86400.
#   8.  fHeading						  -   Optional. For live locations, a direction in which the user is moving, in degrees. Must be between 1 and 360 if specified.
#   9.  fProximityAlertRadius	-   Optional. For live locations, a maximum distance for proximity alerts about approaching another chat member, in meters. Must be between 1 and 100000 if specified.
#   10. fThumbUrl  						-   Optional. Url of the thumbnail for the result
#   11. fThumbWidth 					-   Optional. Thumbnail width
#   12. fThumbHeight					-   Optional. Thumbnail height
#   13. fInputMessageContent	-   Content of the message to be sent
#   14. fReplyMarkup    			-   Optional. Thumbnail height

#   if the global variable fDBGteInlineQueryResultLocation=true, then a debug event will be logged

#---------------------------------------------------teInlineQueryResultLocation--------------------------------------------------------------

:global teInlineQueryResultLocation
:if (!any $teInlineQueryResultLocation) do={ :global teInlineQueryResultLocation do={

	:global teDebugCheck
	:local fDBGteInlineQueryResultLocation [$teDebugCheck fDebugVariableName="fDBGteInlineQueryResultLocation"]

	:global dbaseVersion
	:local teInlineQueryResultLocationVersion "2.07.9.22"
	:set ($dbaseVersion->"teInlineQueryResultLocation") $teInlineQueryResultLocationVersion

	:local strStart "\7B"
	:local strType "\22type\22:\22location\22"
	:local strQueryID ",\22id\22:\22$fInlineQueryID\22"
	:local strLatitude ",\22latitude\22:$fLatitude"
	:local strLongitude ",\22longitude\22:$fLongitude"
	:local strTitle ",\22title\22:\22$fTitle\22"

	:local strHorizontalAccuracy []; :if ([:len $fHorizontalAccuracy] != 0) do={ :set strHorizontalAccuracy ",\22horizontal_accuracy\22:$fHorizontalAccuracy" }
	:local strLivePeriod []; :if ([:len $fLivePeriod] != 0) do={ :set strLivePeriod ",\22live_period\22:$fLivePeriod" }
	:local strHeading []; :if ([:len $fHeading] != 0) do={ :set strHeading ",\22heading\22:$fHeading"	}
	:local strProximityAlertRadius []; :if ([:len $fProximityAlertRadius] != 0) do={ :set strProximityAlertRadius ",\22proximity_alert_radius\22:$fProximityAlertRadius"	}
	:local strThumbUrl []; :if ([:len $fThumbUrl] != 0) do={ :set strThumbUrl ",\22thumb_url\22:\22$fThumbUrl\22" }
	:local strThumbWidth []; :if ([:len $fThumbWidth] != 0) do={ :set strThumbWidth ",\22thumb_width\22:$fThumbWidth"	}
	:local strThumbHeight []; :if ([:len $fThumbHeight] != 0) do={ :set strThumbHeight ",\22thumb_height\22:$fThumbHeight" }
	:local inputMessageContent []; :if ([:len $fInputMessageContent] != 0) do={ :set inputMessageContent ",\22input_message_content\22:$fInputMessageContent"	}
	:local strReplyMarkup []; :if ([:len $fReplyMarkup] != 0) do={ :set strReplyMarkup ",\22reply_markup\22:$fReplyMarkup" }
	:local strEnd "\7D"

	:local InlineQueryResultLocation "$strStart$strType$strQueryID$strLatitude$strLongitude$strTitle$strHorizontalAccuracy$strLivePeriod\
															      $strHeading$strProximityAlertRadius$strThumbUrl$strThumbWidth$strThumbHeight$inputMessageContent$strReplyMarkup$strEnd"

	:if ($fDBGteInlineQueryResultLocation = true) do={:put "teInlineQueryResultLocation = $InlineQueryResultLocation"; :log info "teInlineQueryResultLocation = $InlineQueryResultLocation"}
	:return $InlineQueryResultLocation
	}
}
