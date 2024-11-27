#---------------------------------------------------teCallbackPppCard--------------------------------------------------------------
#		Click event handler for PPP

#		queryChatID		-		chat id
#		userChatID		-		user id
#		messageID			-		message id
#		queryID				-		query id
#		userName			-		telegram user name
#		fpppName			-		ppp user name


#		commandName		-		command name
#		commandValue	-		command value
#   fromRun       -   OK

#---------------------------------------------------teCallbackPppCard--------------------------------------------------------------

	:global teDebugCheck
	:local fDBGteCallbackPppCard [$teDebugCheck fDebugVariableName="fDBGteCallbackPppCard"]

	:global dbaseVersion
	:local teCallbackPppCardVersion "2.15.9.22"
	:set ($dbaseVersion->"teCallbackPppCard") $teCallbackPppCardVersion

	:global teEditMessageReplyMarkup
	:global teAnswerCallbackQuery
	:global teDeleteMessage
	:global teBuildKeyboard
	:global teBuildButton

	:global teGenValue
	:global teRightsControl
	:global tePppCard

	:global teGetDate
	:global teGetTime
	:local dateM [$teGetDate]
	:local timeM [$teGetTime]

	:local newSecret []
	:local newSecretLen 10

	:local NB ","
	:local NL "\5D,\5B"
	:local currentRecord []
	:local currentTimestat "$dateM $timeM"
	:local commentArray []
	:local pictAnswerCallback "\E2\9D\97"
	:local accessDeniedMessage "$pictAnswerCallback For user $userName - Access denied "

	:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard begin...."; :log info "teCallbackPppCard begin...."}

	do {

		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="pppread"] = false) do={
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
			:return false
		}

		:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard fromRun=$fromRun"; :log info "teCallbackPppCard fromRun=$fromRun"}
		:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard fpppName=$fpppName"; :log info "teCallbackPppCard fpppName=$fpppName"}

		:local currentMessageID "MSG=$messageID"

		:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard currentMessageID=$currentMessageID"; :log info "teCallbackPppCard currentMessageID=$currentMessageID"}

		:local recordsArray [/ppp secret find comment~"$currentMessageID"]
		:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard recordsArray=$recordsArray"; :log info "teCallbackPppCard recordsArray=$recordsArray"}

		:local pppName []
		:if ([:len $recordsArray] != 0) do={
			:foreach i in=$recordsArray do={
				:local recordMessageID [:toarray [/ppp secret get [find .id=$i] comment]]
				:if (($recordMessageID->1) = $currentMessageID) do={:set currentRecord $i}
			}
			:set pppName [/ppp secret get [find .id=$currentRecord] name]
		} else={
			:set pppName $fpppName
			:set currentRecord [/ppp secret find name=$fpppName]
			:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard currentRecord=$currentRecord"; :log info "teCallbackPppCard currentRecord=$currentRecord"}
		}

		:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard pppName=$pppName"; :log info "teCallbackPppCard pppName=$pppName"}

		:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard currentRecord=$currentRecord"; :log info "teCallbackPppCard currentRecord=$currentRecord"}
		:if ([:len $currentRecord] = 0) do={:return [error message="teCallbackPppCard: record not found"]}


		:if ([:len $currentRecord] != 0) do={

			:local pppInfo []
			:set commentArray [:toarray [ppp secret get number=$currentRecord comment]]

			:if ([:len $commentArray] != 0) do={
				:set pppInfo ($commentArray->0)
				:set currentMessageID ($commentArray->1)

				:if ($fDBGteCallbackPppCard = true) do={
					:foreach i in=$commentArray do={:log info "$i - type of item:$([:typeof $i])"}
					:put $commentArray; :log info $commentArray
				}
			} else={ :set pppInfo false }

			:if ($commandName = "pppInfo") do={
				:set pppInfo $commandValue
				:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard pppInfo=$pppInfo"; :log info "teCallbackPppCard pppInfo=$pppInfo"}
			}

			:if ($commandName = "pppDisable") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="pppwrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:if ($commandValue = true) do={	/ppp secret set number=$currentRecord disabled=yes	}
				:if ($commandValue = false) do={ /ppp secret set number=$currentRecord disabled=no	}
			}

			:if ($commandName = "delete") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="pppdelete"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:local answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \" fAlert=false"
				:execute script=$answer

				:local deleteRequest $commandValue

				:local pictDelete "\F0\9F\97\91"
				:local buttonDeleteCallBackText "teCallbackPppCard,delete,request"
				:local buttonDelete [$teBuildButton fPictButton=$pictDelete fTextButton="  Delete?" fTextCallBack=$buttonDeleteCallBackText]

				:local pictYes "\E2\9C\85"
				:local buttonYesCallBackText "teCallbackPppCard,delete,true"
				:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

				:local pictNo "\E2\9D\8C"
				:local buttonNoCallBackText "teCallbackPppCard,delete,false"
				:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

				:if ($deleteRequest = "request") do={
					:local lineButtons "$buttonDelete$NL$buttonYes$NB$buttonNo"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}

				:if ($deleteRequest = "true") do={
					:if ([/ppp active find name="$pppName"]) do={	/ppp active remove [find name="$pppName"]	}
					/ppp secret remove number=$currentRecord
					$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID fUserName=$userName
					:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard message $messageID is deleted"; :log info "teCallbackPppCard message $messageID is deleted"}
					:return true
				}
			}

			:if ($commandName = "disconnect") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="pppwrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=True
					:return false
				}

				:local answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \" fAlert=false"
				:execute script=$answer

				:local disconnectRequest $commandValue

				:local pictDisconnect "\F0\9F\94\98"
				:local buttonDisconnectCallBackText "teCallbackPppCard,disconnect,request"
				:local buttonDisconnect [$teBuildButton fPictButton=$pictDisconnect fTextButton="  Disconnect and disable?" fTextCallBack=$buttonDisconnectCallBackText]

				:local pictYes "\E2\9C\85"
				:local buttonYesCallBackText "teCallbackPppCard,disconnect,true"
				:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

				:local pictNo "\E2\9D\8C"
				:local buttonNoCallBackText "teCallbackPppCard,disconnect,false"
				:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

				:if ($disconnectRequest = "request") do={
					:local lineButtons "$buttonDisconnect$NL$buttonYes$NB$buttonNo"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}

				:if ($disconnectRequest = "true") do={
					/ppp secret set number=$currentRecord disabled=yes
					/ppp active remove [find name="$pppName"]
					:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard $pppName is disconnected"; :log info "teCallbackPppCard $pppName is disconnected"}
				}
			}

			:if ($commandName = "chngPass") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="pppwrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=True
					:return false
				}

				:local answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \" fAlert=false"
				:execute script=$answer

				:local changePassRequest $commandValue

				:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard command=$commandName"; :log info "teCallbackPppCard command=$commandName"}

				:local pictChangePass "\F0\9F\8E\B2"
				:local buttonChangePassCallBackText "teCallbackPppCard,chngPass,request"
				:local buttonChangePass [$teBuildButton fPictButton=$pictChangePass fTextButton="  Change password?" fTextCallBack=$buttonChangePassCallBackText]

				:local pictYes "\E2\9C\85"
				:local buttonYesCallBackText "teCallbackPppCard,chngPass,true"
				:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

				:local pictNo "\E2\9D\8C"
				:local buttonNoCallBackText "teCallbackPppCard,chngPass,false"
				:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

				:if ($changePassRequest = "request") do={
					:local lineButtons "$buttonChangePass$NL$buttonYes$NB$buttonNo"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}

				:if ($changePassRequest = "true") do={
					:set newSecret [$teGenValue fValueLen=$newSecretLen fDigits=on fUpperAlpha=on fLowerAlpha=on fUnique=on]
					/ppp secret set number=$currentRecord password=$newSecret
					:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard new password is set for $currentMessageID"; :log info "teCallbackPppCard new password is set for $currentMessageID"}
				}
			}

			:local answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \" fAlert=false"
			:execute script=$answer

			:if ($fDBGteCallbackPppCard = true) do={:put "teCallbackPppCard messageID=$messageID"; :log info "teCallbackPppCard messageID=$messageID"}
			:set $messageID [$tePppCard fChatID=$queryChatID fMessageID=$messageID fpppName=$pppName fpppInfo=$pppInfo fnewSecret=$newSecret]
			:if ($messageID != 0) do={
				/ppp secret set number=$currentRecord comment="$pppInfo,MSG=$messageID"
				:return true
			} else={:return false}
		} else={
			:local errorMessage "$pictAnswerCallback Record not found in Secrets, deleting..."
			:if ([$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID fUserName=$userName] = 0) do={
				:set errorMessage "$pictAnswerCallback Successful. Message is to old, delete manually."
			}
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$errorMessage fAlert=True
			:return true
		}
	} on-error={
		:put "teCallbackPppCard return ERROR"; :log info "teCallbackPppCard return ERROR"
		:return false
	}
