#---------------------------------------------------teBuilQueryResult--------------------------------------------------------------
#   Function build result and returns it in text format
#   Params for this function:

#   1.  fResults 			    		-   A JSON-serialized array of results for the inline query

#   if the global variable fDBGteBuilQueryResult=true, then a debug event will be logged

#---------------------------------------------------teBuilQueryResult--------------------------------------------------------------

:global teBuilQueryResult
:if (!any $teBuilQueryResult) do={ :global teBuilQueryResult do={

	:global teDebugCheck
	:local fDBGteBuilQueryResult [$teDebugCheck fDebugVariableName="fDBGteBuilQueryResult"]

	:global dbaseVersion
	:local teBuilQueryResultVersion "2.07.9.22"
	:set ($dbaseVersion->"teBuilQueryResult") $teBuilQueryResultVersion

	:local strStart "\5B"
	:local strEnd "\5D"

	:local InlineQueryResult "$strStart$fResults$strEnd"

	:if ($fDBGteBuilQueryResult = true) do={:put "teBuilQueryResult = $InlineQueryResult"; :log info "teBuilQueryResult = $InlineQueryResult"}
	:return $InlineQueryResult
	}
}
