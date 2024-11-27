#---------------------------------------------------teInputContactMessageContent--------------------------------------------------------------

#   Represents the content of a contact message to be sent as the result of an inline query.

#   Params for this function:

#   1.  fPhoneNumber 	 	-  String	Contact's phone number
#   2.  fFirstName 	 		-   String	Contact's first name

#   3.  fLastName 	 		-   String	Optional. Contact's last name

#   if the global variable fDBGteInputContactMessageContent=true, then a debug event will be logged

#---------------------------------------------------teInputContactMessageContent--------------------------------------------------------------

:global teInputContactMessageContent
:if (!any $teInputContactMessageContent) do={ :global teInputContactMessageContent do={

	:global teDebugCheck
	:local fDBGteInputContactMessageContent [$teDebugCheck fDebugVariableName="fDBGteInputContactMessageContent"]

	:global dbaseVersion
	:local teInputContactMessageContentVersion "2.07.9.22"
	:set ($dbaseVersion->"teInputContactMessageContent") $teInputContactMessageContentVersion

	:local strStart "\7B"
	:local strPhoneNumber "\22phone_number\22:\22$fPhoneNumber\22"
	:local strFirstName ",\22first_name\22:\22$fFirstName\22"
	:local strEnd "\7D"

	:local strLastName []; :if ([:len $fLastName] != 0) do={ :set strLastName ",\22last_name\22:$fLastName" }

	:local inputContactMessageContent "$strStart$strPhoneNumber$strFirstName$strLastName$strEnd"

	:if ($fDBGteInputContactMessageContent = true) do={:put "teInputContactMessageContent = $inputContactMessageContent"; :log info "teInputContactMessageContent = $inputContactMessageContent"}
	:return $inputContactMessageContent
	}
}
