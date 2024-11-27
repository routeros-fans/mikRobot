#---------------------------------------------------teRootMenu--------------------------------------------------------------

#   Function sends or edits a message to the recipient.
#   Params for this function:

#   1.  fChatID   		-   Recipient id
#   2.  fMessageID 		-   Recipient message id (may be empty). if empty then the message will be sent, otherwise it will be edited
#   3.  fAboutInfo 		-   information about the program

#   Function return 1 or 0

#   if the global variable fDBGteRootMenu=true, then a debug event will be logged

#---------------------------------------------------teRootMenu--------------------------------------------------------------

:global teRootMenu
:if (!any $teRootMenu) do={ :global teRootMenu do={
	:if ($fDBGteRootMenu = true) do={:put "teRootMenu building..."; :log info "teRootMenu building..."}

		:global teDebugCheck
		:local fDBGteRootMenu [$teDebugCheck fDebugVariableName="fDBGteRootMenu"]

		:global dbaseVersion
		:local teRootMenuVersion "2.07.9.22"
		:set ($dbaseVersion->"teRootMenu") $teRootMenuVersion

		:global dbaseBotSettings
		:local devicePicture ($dbaseBotSettings->"devicePicture")
		:local deviceName ("$devicePicture" . " " . ($dbaseBotSettings->"deviceName"))
		:local imageRootHeader ($dbaseBotSettings->"imageRootHeader")
		:local imageRoot ($dbaseBotSettings->"imageRoot")


		:global teSendPhoto
		:global teEditCaption
		:global teBuildKeyboard
		:global teBuildButton

		:local result []
		:set $fMessageID [:tonum $fMessageID]

		:if ($fDBGteRootMenu = true) do={:put "teRootMenu fChatID = $fChatID"; :log info "teRootMenu fChatID = $fChatID"}
		:if ($fDBGteRootMenu = true) do={:put "teRootMenu fMessageID = $fMessageID"; :log info "teRootMenu fMessageID = $([:typeof $fMessageID])"}

		:local NB ","
		:local NL "\5D,\5B"

		:local oneFeed "%0D%0A"
		:local doubleFeed "%0D%0A%0D%0A"

		:local pictAbout "\C2\A9"
		:local buttonAbout [$teBuildButton fPictButton=$pictAbout fTextButton=" About" fTextCallBack="teCallbackRootMenu,about"]

		:local pictTerminal "\F0\9F\95\B6"
		:local buttonTerminal [$teBuildButton fPictButton=$pictTerminal fTextButton="  Terminal" fTextCallBack="teCallbackRootMenu,terminal"]

		:local pictSystem "\F0\9F\94\A7"
		:local buttonSystem [$teBuildButton fPictButton=$pictSystem fTextButton="   System menu" fTextCallBack="teCallbackRootMenu,systemInfo"]

		:local pictModules "\F0\9F\A7\B1"
		:local buttonModules [$teBuildButton fPictButton=$pictModules fTextButton="  Installed modules" fTextCallBack="teCallbackRootMenu,modules"]

		:local pictScripts "\F0\9F\93\9A"
		:local buttonScripts [$teBuildButton fPictButton=$pictScripts fTextButton="  List of available scripts" fTextCallBack="teCallbackRootMenu,scripts"]

		:local line1 "$buttonAbout"
		:local line2 "$NL$buttonTerminal"
		:local line3 "$NL$buttonSystem"
		:local line4 "$NL$buttonModules"
		:local line5 "$NL$buttonScripts"

		:local line "$line1$line2$line3$line4$line5"
		:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$line fReplyKeyboard=false]

		:local sendText ("<b>$deviceName</b>$oneFeed----------------------------$oneFeed" . "<b>root</b>$doubleFeed" . "$fAboutInfo")
		:if ($fMessageID > 0) do={
			:local editResult [$teEditCaption fChatID=$fChatID fMessageID=$fMessageID fText=$sendText fReplyMarkup=$replyMarkup]
			:if ($editResult > 0) do={
				:set ($dbaseBotSettings->$fChatID) ({"rootMessageID"=$editResult})
				:if ($fDBGteRootMenu = true) do={:put "teRootMenu Command Edit - OK"; :log info "teRootMenu Commands Edit - OK"}
				:set result 1
			} else={
				:if ($fDBGteRootMenu = true) do={:put "teRootMenu Command Edit - ERROR"; :log info "teRootMenu Commands Edit - ERROR"}
				:set result 0
			}
		} else={
			:if ([$teSendPhoto fChatID=$fChatID fPhoto=$imageRootHeader fText="" fReplyMarkup=""] > 0) do={
				:local rootMessageID [$teSendPhoto fChatID=$fChatID fPhoto=$imageRoot fText=$sendText fReplyMarkup=$replyMarkup]
				:set ($dbaseBotSettings->$fChatID) ({"rootMessageID"=$rootMessageID})
				:set result 1
				:if ($fDBGteRootMenu = true) do={:put "teRootMenu Command Send - OK"; :log info "teRootMenu Commands Send - OK"}
			} else={
					:set result 0
					:if ($fDBGteRootMenu = true) do={:put "teRootMenu Command Send - ERROR"; :log info "teRootMenu Commands Send - ERROR"}
			}
		}
		:if ($fDBGteRootMenu = true) do={:put "teRootMenu = $result"; :log info "teRootMenu = $result"}
		:return $result
		}
	}
