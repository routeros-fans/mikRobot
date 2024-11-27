#---------------------------------------------------teCallbackRootMenu--------------------------------------------------------------

#		queryChatID		-		chat id
#		userChatID		-		user id
#		messageID			-		message id
#		queryID				-		query id
#		userName			-		telegram user name
#		userLang			-		telegram user language

#		commandName		-		command name
#		commandValue	-		command value

#---------------------------------------------------teCallbackRootMenu--------------------------------------------------------------

	:global teDebugCheck
	:local fDBGteCallbackRootMenu [$teDebugCheck fDebugVariableName="fDBGteCallbackRootMenu"]

	:global dbaseBotSettings
	:global dbaseVersion
	:local teCallbackRootMenuVersion "2.15.9.22"
	:set ($dbaseVersion->"teCallbackRootMenu") $teCallbackRootMenuVersion

	:global teEditMessageReplyMarkup
	:global teAnswerCallbackQuery

	:global teSendMessage
	:global teSendPhoto
	:global teEditCaption
	:global teDeleteMessage

	:global teRightsControl

	:global teRootMenu
	:global teTerminal
	:global teSystemMenu
	:global teModules
	:global teScripts

	:global teGetDate
	:global teGetTime
	:local dateM [$teGetDate]
	:local timeM [$teGetTime]

	:local oneFeed "%0D%0A"
	:local doubleFeed "%0D%0A%0D%0A"
	:local currentTimestat "$dateM $timeM"
	:local pictAnswerCallback "\E2\9D\97"
	:local accessDeniedMessage "$pictAnswerCallback For user $userName - Access denied "

	do {

		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="root"] = false) do={
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
			:return false
		}

		:local answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \" fAlert=\"False\""
		:execute script=$answer

		:if ($commandName = "about") do={

			:local eulaLink []
			:local helpLink []
			:if ($userLang = "ru") do={
				:set eulaLink "<a href=\"https://telegra.ph/Licenzionnoe-soglashenie-07-19\">EULA</a>"
				:set helpLink "<a href=\"https://telegra.ph/Spravka-07-19-2\">Help</a>"
			}
			:local versionInfo ("<b>Version:</b>\t\t" . "<code>" . ($dbaseVersion->"teRootMenu") . "</code>")
			:local eulaInfo ("$doubleFeed" . "<b>License agreement:</b>\t\t" . "$eulaLink")
			:local helpInfo ("$doubleFeed" . "<b>User's guide:</b>\t\t" . "$helpLink")
			:local footerInfo ("$doubleFeed" . "----------------------------")

			:local aboutInfo ("$versionInfo" . "$eulaInfo" . "$helpInfo" . "$footerInfo")

			$teRootMenu fChatID=$userChatID fMessageID=$messageID fAboutInfo=$aboutInfo
		}

		:if ($commandName = "terminal") do={
			$teTerminal fChatID=$queryChatID fMessageID=$messageID fCommand=$commandValue
			:set ($dbaseBotSettings->$queryChatID) ({"rootMessageID"=$messageID})
			:return true
		}

		:if ($commandName = "systemInfo") do={
			$teSystemMenu fChatID=$queryChatID fMessageID=$messageID fCommand=$commandValue
		}
		:if ($commandName = "modules") do={
			$teModules fChatID=$queryChatID fMessageID=$messageID fCommand=$commandValue
			:return true
		}
		:if ($commandName = "scripts") do={
			$teScripts fChatID=$queryChatID fMessageID=$messageID fCommand=$commandValue
			:return true
		}

		:if ($commandName = "backward") do={
			[:parse ":global $commandValue; \$$commandValue fChatID=$queryChatID fMessageID=$messageID"]
			:return true
		}
		:return true
		}
	} on-error={
		:put "teCallbackRootMenu return ERROR"; :log info "teCallbackRootMenu return ERROR"
		:return false
	}
