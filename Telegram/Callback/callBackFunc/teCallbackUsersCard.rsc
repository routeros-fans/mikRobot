#---------------------------------------------------teCallbackUsersCard--------------------------------------------------------------
#		Click event handler for Users

#		queryChatID		-		chat id
#		userChatID		-		user id
#		messageID			-		message id
#		queryID				-		query id
#		userName			-		telegram user name

#		commandName		-		command name
#		commandValue	-		command value

#---------------------------------------------------teCallbackUsersCard--------------------------------------------------------------

	:global teDebugCheck
	:local fDBGteCallbackUserCard [$teDebugCheck fDebugVariableName="fDBGteCallbackUserCard"]

	:global dbaseVersion
	:local teCallbackUsersCardVersion "2.9.7.22"
	:set ($dbaseVersion->"teCallbackUsersCard") $teCallbackUsersCardVersion

	:global teEditMessageReplyMarkup
	:global teAnswerCallbackQuery
	:global teDeleteMessage
	:global teBuildKeyboard
	:global teBuildButton

	:global teGenValue
	:global teRightsControl
	:global teUsersCard

	:global teGetDate
	:global teGetTime
	:local dateM [$teGetDate]
	:local timeM [$teGetTime]

	:local newSecret []
	:local newSecretLen 10

	:local NB ","
	:local NL "\5D,\5B"
	:local currentMessageID "MSG=$messageID"
	:local currentRecord []
	:local currentTimestat "$dateM $timeM"
	:local commentArray []
	:local pictAnswerCallback "\E2\9D\97"
	:local accessDeniedMessage "$pictAnswerCallback For user $userName - Access denied "

	:if ($fDBGteCallbackUserCard = true) do={:put "teCallbackUsersCard begin...."; :log info "teCallbackUsersCard begin...."}

	do {

		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="usersread"] = false) do={
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
			:return false
		}

		:if ($fDBGteCallbackUserCard = true) do={:put "teCallbackUsersCard currentMessageID=$currentMessageID"; :log info "teCallbackUsersCard currentMessageID=$currentMessageID"}

		:local recordsArray [/user find comment~"$currentMessageID"]
		:foreach i in=$recordsArray do={
			:local recordMessageID [:toarray [/user get [find .id=$i] comment]]
			:if (($recordMessageID->1) = $currentMessageID) do={:set currentRecord $i}
		}

		:if ([:len $currentRecord] = 0) do={:return [error message="teCallbackUserCard: record not found"]}

		:if ($fDBGteCallbackUserCard = true) do={:put "teCallbackUsersCard currentRecord=$currentRecord"; :log info "teCallbackUsersCard currentRecord=$currentRecord"}

		:if ([:len $currentRecord] != 0) do={
			:set commentArray [:toarray [user get number=$currentRecord comment]]

			:if ($fDBGteCallbackUserCard = true) do={
				:foreach i in=$commentArray do={:log info "$i - type of item:$([:typeof $i])"}
				:put $commentArray; :log info $commentArray
			}

			:local userInfo ($commentArray->0)

			:set currentMessageID ($commentArray->1)
			:local boardUserName [/user get number=$currentRecord name]

			:if ($commandName = "userInfo") do={
				:set userInfo $commandValue
				:if ($fDBGteCallbackUserCard = true) do={:put "teCallbackUsersCard userInfo=$userInfo"; :log info "teCallbackUsersCard userInfo=$userInfo"}
			}

			:if ($commandName = "userDisable") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="userswrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:if ($commandValue = true) do={	/user set number=$currentRecord disabled=yes	}
				:if ($commandValue = false) do={ /user set number=$currentRecord disabled=no	}
			}

			:if ($commandName = "chngGroup") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="userswrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:local currentUserGroup [/user get number=$currentRecord group]
				:local allGroups [/user group print as-value]
				:local allGroupsCount [/user group print as-value count-only]

				:local counter 1
				:local newGroupId []
				:foreach i in=$allGroups do={
					:local currentGroupName ($i->"name")
					:if ($currentGroupName = $currentUserGroup) do={
						:set newGroupId $counter
						:if ($counter = $allGroupsCount) do={:set $newGroupId 0}
					}
					:set $counter ($counter + 1)
					:log info "counter = $counter"
					:log info "currentGroupName = $currentGroupName"
				}
				:local newGroupName (($allGroups->$newGroupId)->"name")
				/user set number=$currentRecord group=$newGroupName
			}

			:if ($commandName = "delete") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="usersdelete"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:local deleteRequest $commandValue

				:local pictDelete "\F0\9F\97\91"
				:local buttonDeleteCallBackText "teCallbackUsersCard,delete,request"
				:local buttonDelete [$teBuildButton fPictButton=$pictDelete fTextButton="  Delete user?" fTextCallBack=$buttonDeleteCallBackText]

				:local pictYes "\E2\9C\85"
				:local buttonYesCallBackText "teCallbackUsersCard,delete,true"
				:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

				:local pictNo "\E2\9D\8C"
				:local buttonNoCallBackText "teCallbackUsersCard,delete,false"
				:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

				:if ($deleteRequest = "request") do={
					:local lineButtons "$buttonDelete$NL$buttonYes$NB$buttonNo"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}

				:if ($deleteRequest = "true") do={
					/user remove number=$currentRecord
					$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID fUserName=$userName
					:if ($fDBGteCallbackUserCard = true) do={:put "teCallbackUsersCard message $messageID is deleted"; :log info "teCallbackUsersCard message $messageID is deleted"}
					:return true
				}
			}

			:if ($commandName = "chngPass") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="userswrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=True
					:return false
				}

				:local changePassRequest $commandValue

				:if ($fDBGteCallbackUserCard = true) do={:put "teCallbackUsersCard command=$commandName"; :log info "teCallbackUsersCard command=$commandName"}

				:local pictChangePass "\F0\9F\8E\B2"
				:local buttonChangePassCallBackText "teCallbackUsersCard,chngPass,request"
				:local buttonChangePass [$teBuildButton fPictButton=$pictChangePass fTextButton="  Change password?" fTextCallBack=$buttonChangePassCallBackText]

				:local pictYes "\E2\9C\85"
				:local buttonYesCallBackText "teCallbackUsersCard,chngPass,true"
				:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

				:local pictNo "\E2\9D\8C"
				:local buttonNoCallBackText "teCallbackUsersCard,chngPass,false"
				:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

				:if ($changePassRequest = "request") do={
					:local lineButtons "$buttonChangePass$NL$buttonYes$NB$buttonNo"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}

				:if ($changePassRequest = "true") do={
					:set newSecret [$teGenValue fValueLen=$newSecretLen fDigits=on fUpperAlpha=on fLowerAlpha=on fUnique=on]
					:if ($fDBGteCallbackUserCard = true) do={:put "teCallbackUsersCard new password is set for $currentMessageID"; :log info "teCallbackUsersCard new password is set for $currentMessageID"}
					/user set number=$currentRecord password=$newSecret
				}
			}

			:local answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \" fAlert=false"
			:execute script=$answer

			:set $messageID [$teUsersCard fChatID=$queryChatID fMessageID=$messageID fUserName=$boardUserName fUserInfo=$userInfo fNewPass=$newSecret]
			:if ($messageID != 0) do={
				/user set number=$currentRecord comment="$userInfo,MSG=$messageID"
				:return true
			} else={:return false}
		} else={
			:local errorMessage "$pictAnswerCallback Record not found in users, deleting..."
			:if ([$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID fUserName=$userName] = 0) do={
				:set errorMessage "$pictAnswerCallback Successful. Message is to old, delete manually."
			}
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$errorMessage fAlert=True
			:return true
		}

	} on-error={
		:put "teCallbackUsersCard return ERROR"; :log info "teCallbackUsersCard return ERROR"
		:return false
	}
