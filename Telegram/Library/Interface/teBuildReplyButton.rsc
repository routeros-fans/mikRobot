#---------------------------------------------------teBuildReplyButton--------------------------------------------------------------

#   Function build reply button and returns it in text format
#   Params for this function:

#   1.  fPictButton      -   picture for the button from Emoji Unicode Tables
#   2.  fTextButton      -   text for the button
#   3.  fRequestContact  -   request current location true or false

#---------------------------------------------------teBuildReplyButton--------------------------------------------------------------

:global teBuildReplyButton
:if (!any $teBuildReplyButton) do={ :global teBuildReplyButton do={

	:global teDebugCheck
	:local fDBGteBuildReplyButton [$teDebugCheck fDebugVariableName="fDBGteBuildReplyButton"]

	:global dbaseVersion
	:local teBuildReplyButtonVersion "2.9.7.22"
	:set ($dbaseVersion->"teBuildReplyButton") $teBuildReplyButtonVersion

	:local startButton "\22"
	:local endButton "\22"

	:local button "$startButton$fPictButton$fTextButton$endButton"

	:if ($fDBGteBuildReplyButton = true) do={:put "teBuildReplyButton = $button"; :log info "teBuildReplyButton = $button"}
	:return $button
	}
}
