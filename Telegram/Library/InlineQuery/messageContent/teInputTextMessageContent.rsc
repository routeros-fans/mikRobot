#---------------------------------------------------teInputTextMessageContent--------------------------------------------------------------

#   Function build result and returns it in text format
#   Params for this function:

#   1.  fMessageText 	    		-   Text of the message to be sent, 1-4096 characters

#   if the global variable fDBGteInputTextMessageContent=true, then a debug event will be logged

#---------------------------------------------------teInputTextMessageContent--------------------------------------------------------------

:global teInputTextMessageContent
:if (!any $teInputTextMessageContent) do={ :global teInputTextMessageContent do={

	:global teDebugCheck
	:local fDBGteInputTextMessageContent [$teDebugCheck fDebugVariableName="fDBGteInputTextMessageContent"]

	:global dbaseVersion
	:local teInputTextMessageContentContentVersion "2.07.9.22"
	:set ($dbaseVersion->"teInputTextMessageContent") $teInputTextMessageContentContentVersion

	:if ([:len $fMessageText] >= 4096) do={:return [error message="lengthCaptionError"]}

	:local strStart "\7B"
	:local strEnd "\7D"
	:local strMessageText "\22message_text\22:\22$fMessageText\22,\22parse_mode\22:\22HTML\22"

	:local inputTextMessageContent "$strStart$strMessageText$strEnd"

	:if ($fDBGteInputTextMessageContent = true) do={:put "teInputTextMessageContent = $inputTextMessageContent"; :log info "teInputTextMessageContent = $inputTextMessageContent"}
	:return $inputTextMessageContent
	}
}
