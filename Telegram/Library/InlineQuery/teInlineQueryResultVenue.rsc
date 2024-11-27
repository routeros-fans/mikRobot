#---------------------------------------------------teInlineQueryResultVenue--------------------------------------------------------------

#   Represents a venue. By default, the venue will be sent by the user. Alternatively, you can use input_message_content to send a message
#		with the specified content instead of the venue.

#   Params for this function:

#   1.  fType  				   			-   type of the result, must be venue
#   2.  fInlineQueryID     		-   Unique identifier for this result, 1-64 bytes
#   3.  fLatitude  						-   Latitude of the venue location in degrees
#   4.  fLongitude 						-   Longitude of the venue location in degrees
#   5.  fTitle	  						-   Title of the venue
#   6.  fAddress `	 				  -   Address of the venue

#   7.  fFoursquareID	 			  -   Optional. Foursquare identifier of the venue if known
#   8.  fFoursquareType			  -   Optional. Foursquare type of the venue, if known. (For example, “arts_entertainment/default”, “arts_entertainment/aquarium” or “food/icecream”.)
#   9.  fGooglePlaceID  			-   Optional. Google Places identifier of the venue
#   10  fGooglePlaceType 			-   Optional. Google Places type of the venue.
#   11. fThumbUrl  						-   Optional. Url of the thumbnail for the result
#   12. fThumbWidth 					-   Optional. Thumbnail width
#   12. fThumbHeight					-   Optional. Thumbnail height
#   14. fInputMessageContent	-   Content of the message to be sent
#   15. fReplyMarkup    			-   Optional. Thumbnail height

#   if the global variable fDBGteInlineQueryResultVenue=true, then a debug event will be logged

#---------------------------------------------------teInlineQueryResultVenue--------------------------------------------------------------

:global teInlineQueryResultVenue
:if (!any $teInlineQueryResultVenue) do={ :global teInlineQueryResultVenue do={

	:global teDebugCheck
	:local fDBGteInlineQueryResultVenue [$teDebugCheck fDebugVariableName="fDBGteInlineQueryResultVenue"]

	:global dbaseVersion
	:local teInlineQueryResultVenueVersion "2.07.9.22"
	:set ($dbaseVersion->"teInlineQueryResultVenue") $teInlineQueryResultVenueVersion

	:local strStart "\7B"
	:local strType "\22type\22:\22venue\22"
	:local strQueryID ",\22id\22:\22$fInlineQueryID\22"
	:local strLatitude ",\22latitude\22:$fLatitude"
	:local strLongitude ",\22longitude\22:$fLongitude"
	:local strTitle ",\22title\22:\22$fTitle\22"
	:local strAddress ",\22address\22:\22$fAddress\22"

	:local strFoursquareID []; :if ([:len $fFoursquareID] != 0) do={ :set strFoursquareID ",\22foursquare_id\22:\22$fFoursquareID\22" }
	:local strFoursquareType []; :if ([:len $fFoursquareType] != 0) do={ :set strFoursquareType ",\22foursquare_type\22:\22$fFoursquareType\22" }
	:local strGooglePlaceID []; :if ([:len $fGooglePlaceID] != 0) do={ :set strGooglePlaceID ",\22google_place_id\22:\22$fGooglePlaceID\22"	}
	:local strGooglePlaceType []; :if ([:len $fGooglePlaceType] != 0) do={ :set strGooglePlaceType ",\22google_place_type\22:\22$fGooglePlaceType\22"	}
	:local strThumbUrl []; :if ([:len $fThumbUrl] != 0) do={ :set strThumbUrl ",\22thumb_url\22:\22$fThumbUrl\22" }
	:local strThumbWidth []; :if ([:len $fThumbWidth] != 0) do={ :set strThumbWidth ",\22thumb_width\22:$fThumbWidth"	}
	:local strThumbHeight []; :if ([:len $fThumbHeight] != 0) do={ :set strThumbHeight ",\22thumb_height\22:$fThumbHeight" }
	:local inputMessageContent []; :if ([:len $fInputMessageContent] != 0) do={ :set inputMessageContent ",\22input_message_content\22:$fInputMessageContent"	}
	:local strReplyMarkup []; :if ([:len $fReplyMarkup] != 0) do={ :set strReplyMarkup ",\22reply_markup\22:$fReplyMarkup" }
	:local strEnd "\7D"

	:local InlineQueryResultVenue "$strStart$strType$strQueryID$strLatitude$strLongitude$strTitle$strAddress$strFoursquareID$strFoursquareType\
															   $strGooglePlaceID$strGooglePlaceType$strThumbUrl$strThumbWidth$strThumbHeight$inputMessageContent$strReplyMarkup$strEnd"

	:if ($fDBGteInlineQueryResultVenue = true) do={:put "teInlineQueryResultVenue = $InlineQueryResultVenue"; :log info "teInlineQueryResultVenue = $InlineQueryResultVenue"}
	:return $InlineQueryResultVenue
	}
}
