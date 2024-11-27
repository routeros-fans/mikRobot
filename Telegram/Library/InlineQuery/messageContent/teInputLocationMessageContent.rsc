#---------------------------------------------------teInputLocationMessageContent--------------------------------------------------------------

#   FRepresents the content of a location message to be sent as the result of an inline query.

#   Params for this function:

#   1.  fLatitude 	 	-   Float	- Latitude of the location in degrees
#   2.  fLongitude 	 	-   Float	- Longitude of the location in degrees

#   3.  fHorizontalAccuracy 	 	-   Float	- Optional. The radius of uncertainty for the location, measured in meters; 0-1500
#   4.  fLivePeriod 					 	-   Integer	Optional. Period in seconds for which the location can be updated, should be between 60 and 86400.
#   5.  fHeading 							 	-   Integer	Optional. For live locations, a direction in which the user is moving, in degrees. Must be between 1 and 360 if specified.
#   6.  fProximityAlertRadius	 	-   Integer	Optional. For live locations, a maximum distance for proximity alerts about approaching
#																											another chat member, in meters. Must be between 1 and 100000 if specified.

#   if the global variable fDBGteInputLocationMessageContent=true, then a debug event will be logged

#---------------------------------------------------teInputLocationMessageContent--------------------------------------------------------------

:global teInputLocationMessageContent
:if (!any $teInputLocationMessageContent) do={ :global teInputLocationMessageContent do={

	:global teDebugCheck
	:local fDBGteInputLocationMessageContent [$teDebugCheck fDebugVariableName="fDBGteInputLocationMessageContent"]

	:global dbaseVersion
	:local teInputLocationMessageContentVersion "2.07.9.22"
	:set ($dbaseVersion->"teInputLocationMessageContent") $teInputLocationMessageContentVersion

	:local strStart "\7B"
	:local strEnd "\7D"

	:local strLatitude "\22latitude\22:$fLatitude"
	:local strLongitude ",\22longitude\22:$fLongitude"

	:local strHorizontalAccuracy []; :if ([:len $fHorizontalAccuracy] != 0) do={ :set strHorizontalAccuracy ",\22horizontal_accuracy\22:$fHorizontalAccuracy" }
	:local strLivePeriod []; :if ([:len $fLivePeriod] != 0) do={ :set strLivePeriod ",\22live_period\22:$fLivePeriod" }
	:local strHeading []; :if ([:len $fHeading] != 0) do={ :set strHeading ",\22heading\22:$fHeading"	}
	:local strProximityAlertRadius []; :if ([:len $fProximityAlertRadius] != 0) do={ :set strProximityAlertRadius ",\22proximity_alert_radius\22:$fProximityAlertRadius"	}

	:local inputLocationMessageContent "$strStart$strLatitude$strLongitude$strHorizontalAccuracy$strLivePeriod$strHeading$strProximityAlertRadius$strEnd"

	:if ($fDBGteInputLocationMessageContent = true) do={:put "teInputLocationMessageContent = $inputLocationMessageContent"; :log info "teInputLocationMessageContent = $inputLocationMessageContent"}
	:return $inputLocationMessageContent
	}
}
