#---------------------------------------------------teCallbackSystemMenu--------------------------------------------------------------
#		Click event handler for SystemMenu

#		queryChatID		-		chat id
#		userChatID		-		user id
#		messageID			-		message id
#		queryID				-		query id
#		userName			-		telegram user name

#		commandName		-		command name
#		commandValue	-		command value

#---------------------------------------------------teCallbackSystemMenu--------------------------------------------------------------

	:global teDebugCheck
	:local fDBGteCallbackSystemMenu [$teDebugCheck fDebugVariableName="fDBGteCallbackSystemMenu"]

	:global dbaseBotSettings
	:local deviceName ($dbaseBotSettings->"deviceName")
	:local bkpPassword ($dbaseBotSettings->"bkpPassword")

	:global dbaseVersion
	:local teCallbackSystemMenuVersion "2.9.7.22"
	:set ($dbaseVersion->"teCallbackSystemMenu") $teCallbackSystemMenuVersion

	:global teEditMessageReplyMarkup
	:global teAnswerCallbackQuery
	:global teBuildKeyboard
	:global teBuildButton

	:global teRightsControl
	:global teSystemMenu

	:global teGetDate
	:global teGetTime
	:local dateM [$teGetDate]
	:local timeM [$teGetTime]

	:local NB ","
	:local NL "\5D,\5B"
	:local checkUpdate false

	:local pictAnswerCallback "\E2\9D\97"
	:local accessDeniedMessage "$pictAnswerCallback For user $userName - Access denied "

	:if ($fDBGteCallbackSystemMenu = true) do={:put "teCallbackSystemMenu begin...."; :log info "teCallbackSystemMenu begin...."}

	do {

		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="systemread"] = false) do={
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage
			:return false
		}

		:if ($commandName = "restart") do={
			:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="systemupdate"] = false) do={
				$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert="True"
				:return false
			}
			:if ($fDBGteCallbackSystemMenu = true) do={:put "teCallbackSystemMenu backup = $commandName"; :log info "teCallbackSystemMenu backup = $commandName"}

			:local restartRequest $commandValue

			:local pictRestart "\E2\9D\97"
			:local buttonRestartCallBackText "teCallbackSystemMenu,restart,request"
			:local buttonRestart [$teBuildButton fPictButton=$pictRestart fTextButton=" Restart system?" fTextCallBack=$buttonRestartCallBackText]

			:local pictYes "\E2\9C\85"
			:local buttonYesCallBackText "teCallbackSystemMenu,restart,true"
			:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

			:local pictNo "\E2\9D\8C"
			:local buttonNoCallBackText "teCallbackSystemMenu,restart,false"
			:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

			:if ($restartRequest = "request") do={

				:local lineButtons "$buttonRestart$NL$buttonYes$NB$buttonNo"
				:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]

				$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
				:return true
			}

			:if ($restartRequest = "true") do={
				:local answerMessage "$pictAnswerCallback Router is rebooting..."
				$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$answerMessage fAlert="True"
				/system reboot
				:return true
			}
		}

		:if ($commandName = "backup") do={
			:if ($fDBGteCallbackSystemMenu = true) do={:put "teCallbackSystemMenu backup = $commandName"; :log info "teCallbackSystemMenu backup = $commandName"}
			/system backup save name="/$deviceName_$dateM_$timeM" password=$bkpPassword
			:local backupMessage "$pictAnswerCallback Backup completed successfully "
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$backupMessage fAlert="True"
		}

		:if ($commandName = "checkUpdate") do={
			:set checkUpdate $commandValue
			:if ($fDBGteCallbackSystemMenu = true) do={:put "teCallbackSystemMenu checkUpdate = $checkUpdate"; :log info "teCallbackSystemMenu checkUpdate = $checkUpdate"}
		}

		:local statusUpdate false
		:if ($commandName = "update") do={
			:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="systemupdate"] = false) do={
				$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert="True"
				:return false
			}
			:set statusUpdate ([/system package update download as-value]->"status")
			:if ($statusUpdate~"Downloaded") do={ :set statusUpdate "downloaded" }
		}

		:local answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \" fAlert=false"
		:execute script=$answer

		:if ([$teSystemMenu fChatID=$queryChatID fMessageID=$messageID fCheckUpdate=$checkUpdate fQueryID=$queryID fDownloadStatus=$statusUpdate] != 0) do={
			:if ($fDBGteCallbackSystemMenu = true) do={:put "teCallbackSystemMenu teSystemMenu return 1"; :log info "teCallbackSystemMenu teSystemMenu return 1"}
			:return true
		} else={:return false}

	} on-error={
		:put "teCallbackSystemMenu return ERROR"; :log info "teCallbackSystemMenu return ERROR"
		:return false
	}
