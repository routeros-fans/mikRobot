#---------------------------------------------------teBuildButton--------------------------------------------------------------

#   Function build button and returns it in text format
#   Params for this function:

#   1.  fPictButton     			-   picture for the button from Emoji Unicode Tables
#   2.  fTextButton     			-   text for the button
#   3.  fUrlButton	   			  -   URL for the button
#   4.  fSwitchCurrentChat	  -   URL for the button
#   5.  fTextCallBack    			-   callback for the button

#---------------------------------------------------teBuildButton--------------------------------------------------------------

:global teBuildButton
:if (!any $teBuildButton) do={ :global teBuildButton do={

	:global teDebugCheck
	:local fDBGteBuildButton [$teDebugCheck fDebugVariableName="fDBGteBuildButton"]

	:global dbaseVersion
	:local teBuildButtonVersion "2.9.7.22"
	:set ($dbaseVersion->"teBuildButton") $teBuildButtonVersion

	:local startButton "\7B\22text\22: \22 "
	:local startUrl "\22,\22url\22: \22"
	:local startCallBack " \22,\22callback_data\22: \22"
	:local startSwitchCurrentChat " \22,\22switch_inline_query_current_chat\22: \22"
	:local endButton "\22\7D"
	:local button []

	:set button "$startButton$fPictButton$fTextButton$startCallBack$fTextCallBack$endButton"

	:if ([:len $fUrlButton] != 0) do={
		:set button "$startButton$fPictButton$fTextButton$startUrl$fUrlButton$startCallBack$fTextCallBack$endButton"
	}
	:if ([:len $fSwitchCurrentChat] != 0) do={
		:set button "$startButton$fPictButton$fTextButton$startSwitchCurrentChat$fSwitchCurrentChat$endButton"
	}

	:if ($fDBGteBuildButton = true) do={:put "teBuildButton = $button"; :log info "teBuildButton = $button"}
	:return $button
	}
}
