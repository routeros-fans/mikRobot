#---------------------------------------------------teCallbackIfaceCard--------------------------------------------------------------
#		Click event handler for Interfaces

#		queryChatID		-		chat id
#		userChatID		-		user id
#		messageID			-		message id
#		queryID				-		query id
#		userName			-		telegram user name

#		commandName		-		command name
#		commandValue	-		command value

#---------------------------------------------------teCallbackIfaceCard--------------------------------------------------------------

	:global teDebugCheck
	:local fDBGteCallbackIfaceCard [$teDebugCheck fDebugVariableName="fDBGteCallbackIfaceCard"]

	:global dbaseVersion
	:local teCallbackIfaceCardVersion "2.24.8.22"
	:set ($dbaseVersion->"teCallbackIfaceCard") $teCallbackIfaceCardVersion

	:global teEditMessageReplyMarkup
	:global teAnswerCallbackQuery
	:global teDeleteMessage
	:global teBuildKeyboard
	:global teBuildButton

	:global teRightsControl
	:global teIfaceCard
	:global teGenValue

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
	:local answer []
	:local newKey []

	:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard begin...."; :log info "teCallbackIfaceCard begin...."}

	do {

		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="ifaceread"] = false) do={
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
			:return false
		}

		:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard currentMessageID=$currentMessageID"; :log info "teCallbackIfaceCard currentMessageID=$currentMessageID"}

		:local recordsArray [/interface find comment~"$currentMessageID"]
		:foreach i in=$recordsArray do={
			:local recordMessageID [:toarray [/interface get [find .id=$i] comment]]
			:if (($recordMessageID->2) = $currentMessageID) do={:set currentRecord $i}
		}

		:if ([:len $currentRecord] = 0) do={:return [error message="teCallbackIfaceCard: record not found"]}

		:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard currentRecord=$currentRecord"; :log info "teCallbackIfaceCard currentRecord=$currentRecord"}

		:if ([:len $currentRecord] != 0) do={
			:set commentArray [:toarray [interface get number=$currentRecord comment]]

			:if ($fDBGteCallbackIfaceCard = true) do={
				:foreach i in=$commentArray do={:log info "$i - type of item:$([:typeof $i])"}
				:put $commentArray; :log info $commentArray
			}

			:local ifaceNote ($commentArray->0)
			:local ifaceInfo ($commentArray->1)
			:set currentMessageID ($commentArray->2)
			:local ifaceName [/interface get number=$currentRecord name]

			:if ($commandName = "ifaceInfo") do={
				:set ifaceInfo $commandValue
				:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard ifaceInfo=$ifaceInfo"; :log info "teCallbackIfaceCard ifaceInfo=$ifaceInfo"}
			}

			:if ($commandName = "ifaceDisable") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="ifacewrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:if ($commandValue = true) do={	/interface set number=$currentRecord disabled=yes	}
				:if ($commandValue = false) do={ /interface set number=$currentRecord disabled=no	}
			}

			:if ($commandName = "virtualAdd") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="ifacewrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:local ifaceArray [interface wireless print as-value where name=$commandValue]
				:local ifaceCount [interface wireless print as-value count-only]
				:local newMtu ($ifaceArray->0->"mtu")
				:local newL2Mtu ($ifaceArray->0->"l2mtu")
				:local newArp ($ifaceArray->0->"arp")
				:local newMode ($ifaceArray->0->"mode")
				:local newSsid ($commandValue . "Virtual" . ($ifaceCount + 1))
				:local newName $newSsid
				:local masterIface $commandValue
				:local newSecurityProfile ($ifaceArray->0->"security-profile")
				:local newVlanMode ($ifaceArray->0->"vlan-mode")
				:local newVlanID ($ifaceArray->0->"vlan-id")
				:local newDefaultAuth ($ifaceArray->0->"default-authentication")
				:local newDefaultForward ($ifaceArray->0->"default-forwarding")
				:local newHideSsid ($ifaceArray->0->"hide-ssid")
				:local newWdsMode ($ifaceArray->0->"wds-mode")
				:local newWdsBridge ($ifaceArray->0->"wds-default-bridge")

				:local newVirtualResult [/interface wireless add name=$newName mtu=$newMtu l2mtu=$newL2Mtu arp=$newArp mode=$newMode ssid=$newSsid master-interface=$masterIface	security-profile=$newSecurityProfile vlan-mode=$newVlanMode vlan-id=$newVlanID default-authentication=$newDefaultAuth default-forwarding=$newDefaultForward hide-ssid=$newHideSsid wds-mode=$newWdsMode wds-default-bridge=$newWdsBridge disabled=no]

				:if ([:len $newVirtualResult] != 0) do={
					:local answerSucces "$newName added succesfully"
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$answerSucces fAlert=true
					:return true
				} else={
					:local answerFail "$pictAnswerCallback Adding failed"
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$answerFail fAlert=true
					:error message="Adding failed"
				}
			}

			:if ($commandName = "vlanDelete") do={

				:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard commandName=$commandName"; :log info "teCallbackIfaceCard commandName=$commandName"}

				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="ifacedelete"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:set answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \""
				:execute script=$answer

				:local deleteRequest $commandValue

				:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard deleteRequest=$deleteRequest"; :log info "teCallbackIfaceCard deleteRequest=$deleteRequest"}

				:local NB ","
				:local NL "\5D,\5B"

				:local pictDelete "\F0\9F\97\91"
				:local buttonDeleteCallBackText "teCallbackIfaceCard,vlanDelete,request"
				:local buttonDelete [$teBuildButton fPictButton=$pictDelete fTextButton="  Delete?" fTextCallBack=$buttonDeleteCallBackText]

				:local pictYes "\E2\9C\85"
				:local buttonYesCallBackText "teCallbackIfaceCard,vlanDelete,true"
				:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

				:local pictNo "\E2\9D\8C"
				:local buttonNoCallBackText "teCallbackIfaceCard,vlanDelete,false"
				:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

				:if ($deleteRequest = "request") do={

					:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard deleteRequest=$deleteRequest"; :log info "teCallbackIfaceCard deleteRequest=$deleteRequest"}

					:local lineButtons "$buttonDelete$NL$buttonYes$NB$buttonNo"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}

				:if ($deleteRequest = "true") do={
						/interface vlan remove $ifaceName
						$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID fUserName=$userName
						:return true
				}
			}

			:if ($commandName = "virtualDelete") do={

				:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard commandName=$commandName"; :log info "teCallbackIfaceCard commandName=$commandName"}

				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="ifacedelete"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:set answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \""
				:execute script=$answer

				:local deleteRequest $commandValue

				:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard deleteRequest=$deleteRequest"; :log info "teCallbackIfaceCard deleteRequest=$deleteRequest"}

				:local NB ","
				:local NL "\5D,\5B"

				:local pictDelete "\F0\9F\97\91"
				:local buttonDeleteCallBackText "teCallbackIfaceCard,virtualDelete,request"
				:local buttonDelete [$teBuildButton fPictButton=$pictDelete fTextButton="  Delete?" fTextCallBack=$buttonDeleteCallBackText]

				:local pictYes "\E2\9C\85"
				:local buttonYesCallBackText "teCallbackIfaceCard,virtualDelete,true"
				:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

				:local pictNo "\E2\9D\8C"
				:local buttonNoCallBackText "teCallbackIfaceCard,virtualDelete,false"
				:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

				:if ($deleteRequest = "request") do={

					:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard deleteRequest=$deleteRequest"; :log info "teCallbackIfaceCard deleteRequest=$deleteRequest"}

					:local lineButtons "$buttonDelete$NL$buttonYes$NB$buttonNo"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}

				:if ($deleteRequest = "true") do={
						/interface wireless remove $ifaceName
						$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID fUserName=$userName
						:return true
				}
			}

			:if ($commandName = "changeKey") do={

				:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard commandName=$commandName"; :log info "teCallbackIfaceCard commandName=$commandName"}

				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="ifacewrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:set answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \""
				:execute script=$answer

				:local changeRequest $commandValue

				:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard changeRequest=$changeRequest"; :log info "teCallbackIfaceCard changeRequest=$changeRequest"}

				:local NB ","
				:local NL "\5D,\5B"

				:local pictChangeKey "\F0\9F\94\91"
				:local buttonChangeKeyCallBackText "teCallbackIfaceCard,changeKey,request"
				:local buttonChangeKey [$teBuildButton fPictButton=$pictChangeKey fTextButton=" Change Wi-Fi key?" fTextCallBack=$buttonChangeKeyCallBackText]

				:local pictYes "\E2\9C\85"
				:local buttonYesCallBackText "teCallbackIfaceCard,changeKey,true"
				:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

				:local pictNo "\E2\9D\8C"
				:local buttonNoCallBackText "teCallbackIfaceCard,changeKey,false"
				:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

				:if ($changeRequest = "request") do={

					:if ($fDBGteCallbackIfaceCard = true) do={:put "teCallbackIfaceCard changeRequest=$changeRequest"; :log info "teCallbackIfaceCard changeRequest=$changeRequest"}

					:local lineButtons "$buttonChangeKey$NL$buttonYes$NB$buttonNo"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}

				:if ($changeRequest = "true") do={

					:local securityProfile [interface wireless get $ifaceName security-profile]
					:set newKey [$teGenValue fValueLen=20 fDigits=on fUpperAlpha=on fLowerAlpha=on fUnique=on]
					:local currentKey [interface wireless security-profiles get $securityProfile wpa2-pre-shared-key]
					:if ([:len $currentKey] = 0) do={
						:set currentKey [interface wireless security-profiles get $securityProfile wpa-pre-shared-key]
						interface wireless security-profiles set $securityProfile wpa-pre-shared-key=$newKey
					} else={
						interface wireless security-profiles set $securityProfile wpa2-pre-shared-key=$newKey
					}
				}
			}

			:if ($commandName = "changeBridge") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="ifacewrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:local currentIfacePortsNumber [interface bridge port find interface=$commandValue and !disabled]
				:local currentIfaceBridge [interface bridge port get value-name=interface number=$currentIfacePortsNumber bridge]
				:local allBridges [interface bridge print as-value where !disabled]
				:local allBridgesCount [interface bridge print as-value count-only where !disabled]

				:local counter 1
				:local newBridgeID []
				:foreach i in=$allBridges do={
					:local currentBridgeName ($i->"name")
					:if ($currentBridgeName = $currentIfaceBridge) do={
						:set newBridgeID $counter
						:if ($counter = $allBridgesCount) do={:set $newBridgeID 0}
					}
					:set $counter ($counter + 1)
				}

				:local newBridgeName (($allBridges->$newBridgeID)->"name")
				/interface bridge port set numbers=$currentIfacePortsNumber bridge=$newBridgeName
			}

			:if ($commandName = "changeProf") do={
				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="ifacewrite"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:local currentIfaceProf [interface wireless get number=$currentRecord security-profile]
				:local allProfiles [interface wireless security-profiles print as-value]
				:local allProfilesCount [interface wireless security-profiles print as-value count-only]

				:local counter 1
				:local newProfileID []
				:foreach i in=$allProfiles do={
					:local currentIfaceName ($i->"name")
					:if ($currentIfaceName = $currentIfaceProf) do={
						:set newProfileID $counter
						:if ($counter = $allProfilesCount) do={:set $newProfileID 0}
					}
					:set $counter ($counter + 1)
				}
				:local newIfaceName (($allProfiles->$newProfileID)->"name")
				/interface wireless set numbers=$currentRecord security-profile=$newIfaceName
			}


			:set answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \""
			:execute script=$answer

			:set $messageID [$teIfaceCard fChatID=$queryChatID fMessageID=$messageID fIfaceName=$ifaceName fIfaceInfo=$ifaceInfo fIfaceNote=$ifaceNote fNewKey=$newKey]
			:if ($messageID != 0) do={
				/interface set number=$currentRecord comment="$ifaceNote,$ifaceInfo,MSG=$messageID"
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
		:put "teCallbackIfaceCard return ERROR"; :log info "teCallbackIfaceCard return ERROR"
		:return false
	}
