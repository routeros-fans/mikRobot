#---------------------------------------------------teCallbackScripts--------------------------------------------------------------
#		Click event handler for Scripts

#		queryChatID		-		chat id
#		userChatID		-		user id
#		messageID			-		message id
#		queryID				-		query id
#		userName			-		telegram user name

#		commandName		-		command name
#		commandValue	-		command value

#---------------------------------------------------teCallbackScripts--------------------------------------------------------------

	:global teDebugCheck
	:local fDBGteCallbackScripts [$teDebugCheck fDebugVariableName="fDBGteCallbackScripts"]

	:global dbaseVersion
	:local teCallbackScriptsVersion "2.9.7.22"
	:set ($dbaseVersion->"teCallbackScripts") $teCallbackScriptsVersion

	:global teEditMessageReplyMarkup
	:global teAnswerCallbackQuery
	:global teBuildKeyboard
	:global teBuildButton

	:global teRightsControl
	:global teScripts

	:global teGetDate
	:global teGetTime
	:local dateM [$teGetDate]
	:local timeM [$teGetTime]

	:local NB ","
	:local NL "\5D,\5B"

	:local pictAnswerCallback "\E2\9D\97"
	:local accessDeniedMessage "$pictAnswerCallback For user $userName - Access denied "

	do {

		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="scriptrun"] = false) do={
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
			:return false
		}

		:local answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \" fAlert=false"
		:execute script=$answer

		:if ($fDBGteCallbackScripts = true) do={:put "teCallbackScripts commandName = $commandName"; :log info "teCallbackScripts commandName = $commandName"}

		:local pictRunScript "\F0\9F\93\9D"
		:local buttonRunScriptCallBackText "teCallbackScripts,$commandName,request"
		:local textButton " Run $commandName?"
		:local buttonRunScript [$teBuildButton fPictButton=$pictRunScript fTextButton=$textButton fTextCallBack=$buttonRunScriptCallBackText]

		:local pictYes "\E2\9C\85"
		:local buttonYesCallBackText "teCallbackScripts,$commandName,true"
		:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

		:local pictNo "\E2\9D\8C"
		:local buttonNoCallBackText "teCallbackScripts,$commandName,false"
		:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

		:if ($commandValue = "request") do={
			:if ($fDBGteCallbackScripts = true) do={:put "teCallbackScripts commandValue = $commandValue"; :log info "teCallbackScripts commandValue = $commandValue"}

			:local lineButtons "$buttonRunScript$NL$buttonYes$NB$buttonNo"
			:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]

			$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
			:return true
		}

		:local scriptName []
		:local scriptMessage []
		:if ($commandValue = true) do={
			:set scriptName ("isBot" . "$commandName")
			:local scriptResult [[:parse "/system script run [find name=$scriptName]"]]

			:if ([:len $scriptResult] != 0) do={
				$teScripts fChatID=$queryChatID fMessageID=$messageID fCalledScript=$commandName fCallbackMsg=$scriptResult
			} else={
				:set scriptMessage "script is Runing"
				$teScripts fChatID=$queryChatID fMessageID=$messageID fCalledScript=$commandName fCallbackMsg=$scriptMessage
			}

			:return true
		}

		:if ($commandValue = false) do={
			:set scriptName ("isBot" . "$commandName")
			:set scriptMessage "launch Canceled"
			:if ([$teScripts fChatID=$queryChatID fMessageID=$messageID fCalledScript=$commandName fCallbackMsg=$scriptMessage] = 1) do={
				:return true
			} else={ :return false }
		}

	} on-error={
		:local scriptMessage "launch Error!"
		$teScripts fChatID=$queryChatID fMessageID=$messageID fCalledScript=$commandName fCallbackMsg=$scriptMessage
		:put "teCallbackScripts return ERROR"; :log info "teCallbackScripts return ERROR"
		:return false
	}
