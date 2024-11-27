#---------------------------------------------------teCallbackLeaseCard--------------------------------------------------------------
#		Click event handler for DHCP

#		queryChatID		-		chat id
#		userChatID		-		user id
#		messageID			-		message id
#		queryID				-		query id
#		messageIP			-		message IP

#		commandName		-		command name
#		commandValue	-		command value

#---------------------------------------------------teCallbackLeaseCard--------------------------------------------------------------

	:global teDebugCheck
	:local fDBGteCallbackLeaseCard [$teDebugCheck fDebugVariableName="fDBGteCallbackLeaseCard"]

	:global dbaseBotSettings
	:local firewallAddressListTimeout ($dbaseBotSettings->"firewallAddressListTimeout")
	:local firewallAddressListDeleteTimeout ($dbaseBotSettings->"firewallAddressListDeleteTimeout")

	:global dbaseVersion
	:local teCallbackLeaseCardVersion "2.19.9.22"
	:set ($dbaseVersion->"teCallbackLeaseCard") $teCallbackLeaseCardVersion

	:global teEditMessageReplyMarkup
	:global teAnswerCallbackQuery
	:global teDeleteMessage
	:global teSendMessage
	:global teBuildKeyboard
	:global teBuildButton

	:global teRightsControl
	:global teLeaseCard
	:global dbaseDynLease

	:global teGetDate
	:global teGetTime
	:local dateM [$teGetDate]
	:local timeM [$teGetTime]

	:local pingCount ""

	:local allowList "AllowList"
	:local blockList "BlockList"

	:local currentRecord []
	:local currentAddressList ""
	:local commentArray [:toarray ""]
	:local currentMessageID []
	:set currentMessageID "MSG=$messageID"

	:local currentTimestat "$dateM $timeM"
	:local pictAnswerCallback "\E2\9D\97"
	:local accessDeniedMessage "$pictAnswerCallback For user $userName - Access denied "
	:local answer []

	do {

		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="leaseread"] = false) do={
			$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
			:return false
		}

		:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard currentMessageID = $currentMessageID"; :log info "teCallbackLeaseCard currentMessageID = $currentMessageID"}

		:local recordsArray []
		:set recordsArray [/ip firewall address-list find comment~"$currentMessageID" and !disabled]
		:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard recordsArray = $([:len $recordsArray])"; :log info "teCallbackLeaseCard recordsArray = $([:len $recordsArray])"}
		:if ([:len $recordsArray] != 0) do={
			:foreach i in=$recordsArray do={
				:local recordMessageID [:toarray [/ip firewall address-list get [find .id=$i] comment]]
				:if (($recordMessageID->9) = $currentMessageID) do={:set currentRecord $i}
			}
		}

		:if ([:len $currentRecord] != 0) do={
			:set commentArray [:toarray [/ip firewall address-list get number=$currentRecord comment]]

			:if ($fDBGteCallbackLeaseCard = true) do={
				:foreach i in=$commentArray do={:log info "$i - type of item:$([:typeof $i])"}
				:put $commentArray; :log info $commentArray
			}

			:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard currentRecord = $currentRecord"; :log info "teCallbackLeaseCard currentRecord = $currentRecord"}

			:local leaseActIP [/ip firewall address-list get $currentRecord address]
			:local leaseNote ($commentArray->0)
			:local leaseInfo ($commentArray->1)
			:local isBlocked ($commentArray->2)
			:local leaseActMAC ($commentArray->5)
			:local leaseHostname ($commentArray->6)
			:local leaseParams ($commentArray->7)
			:local leaseRateShow ($commentArray->8)

			:if ($commandName = "static") do={

					:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="leasewrite"] = false) do={
						$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
						:return false
					}

					:set answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \""
					:execute script=$answer

					:local staticRequest $commandValue
					:local NB ","
					:local NL "\5D,\5B"

					:local pictStatic "\F0\9F\93\8C"
					:local buttonStaticCallBackText "teCallbackLeaseCard,static,request"
					:local buttonStatic [$teBuildButton fPictButton=$pictStatic fTextButton="  Make static?" fTextCallBack=$buttonStaticCallBackText]

					:local pictYes "\E2\9C\85"
					:local buttonYesCallBackText "teCallbackLeaseCard,static,true"
					:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

					:local pictNo "\E2\9D\8C"
					:local buttonNoCallBackText "teCallbackLeaseCard,static,false"
					:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

					:if ($staticRequest = "request") do={

						:local lineButtons "$buttonStatic$NL$buttonYes$NB$buttonNo"
						:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]

						$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup

						:return true
					}

					:if ($staticRequest = "true") do={
						/ip dhcp-server lease make-static [find mac-address=$leaseActMAC and !disabled and address=$leaseActIP]

						do {
							:foreach k,v in=$dbaseDynLease do={
								:if ($k = $messageID) do={
										:set ($dbaseDynLease->$k)
										:error message="Record found in leaseArray"
								}
							}
						} on-error={:if ($fDBGteLease = true) do={:put "teCallbackLeaseCard Record delete from leaseArray"; :log warning "teCallbackLeaseCard Record delete from leaseArray"}}

					}
			}

			:if ($commandName = "delete" or $commandName = "waiting") do={
						:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard commandName=$commandName"; :log info "teCallbackLeaseCard commandName=$commandName"}

						:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="leasedelete"] = false) do={
							$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
							:return false
						}

						:set answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \""
						:execute script=$answer

						:local deleteRequest $commandValue
						:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard deleteRequest=$deleteRequest"; :log info "teCallbackLeaseCard deleteRequest=$deleteRequest"}

						:local NB ","
						:local NL "\5D,\5B"

						:local pictDelete "\F0\9F\97\91"
						:local buttonDeleteCallBackText "teCallbackLeaseCard,delete,request"
						:local buttonDelete [$teBuildButton fPictButton=$pictDelete fTextButton="  Delete?" fTextCallBack=$buttonDeleteCallBackText]

						:local pictYes "\E2\9C\85"
						:local buttonYesCallBackText "teCallbackLeaseCard,delete,true"
						:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

						:local pictNo "\E2\9D\8C"
						:local buttonNoCallBackText "teCallbackLeaseCard,delete,false"
						:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

						:if ($deleteRequest = "request") do={
							:local lineButtons "$buttonDelete$NL$buttonYes$NB$buttonNo"
							:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
							$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
							:return true
						}

						:if ($deleteRequest = "true") do={
							:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard deleteting MSG=$messageID"; :log info "teCallbackLeaseCard  deleteting MSG=$messageID"}
							/ip firewall address-list remove numbers=$currentRecord
							/ip dhcp-server lease remove [find mac-address=$leaseActMAC and !disabled and address=$leaseActIP]

							do {
		            :foreach k,v in=$dbaseDynLease do={
		              :if ($k = $messageID) do={
		                  :set ($dbaseDynLease->$k)
		                  :error message="Record found in leaseArray"
		              }
		            }
		          } on-error={:if ($fDBGteLease = true) do={:put "teCallbackLeaseCard Record delete from leaseArray"; :log warning "teCallbackLeaseCard Record delete from leaseArray"}}

							$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID fUserName=$userName
							:return true
						}

						:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard deleteRequest=$deleteRequest"; :log info "teCallbackLeaseCard deleteRequest=$deleteRequest"}
			}

			:if ($commandName = "leaseInfo") do={
						:set leaseInfo $commandValue
						:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard leaseInfo=$leaseInfo"; :log info "teCallbackLeaseCard leaseInfo=$leaseInfo"}
			}

			:if ($commandName = "params") do={
						:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="leasewrite"] = false) do={
							$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
							:return false
						}
						:set leaseParams $commandValue
						:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard leaseParams=$leaseParams"; :log info "teCallbackLeaseCard leaseParams=$leaseParams"}
			}

			:if ($commandName = "isBlocked") do={
						:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="leasewrite"] = false) do={
							$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
							:return false
						}

						:set isBlocked $commandValue
						:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard isBlocked=$isBlocked"; :log info "teCallbackLeaseCard isBlocked=$isBlocked"}
			}

			:if ($commandName = "ping") do={
				:set pingCount [ping $leaseActIP count=$commandValue]
			}

			:set answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \""
			:execute script=$answer

			$teLeaseCard fChatID=$queryChatID fQueryID=$queryID fLeaseHostname=$leaseHostname fLeaseActMAC=$leaseActMAC fLeaseActIP=$leaseActIP isBlocked=$isBlocked leaseInfo=$leaseInfo leaseNote=$leaseNote pingCount=$pingCount leaseParams=$leaseParams leaseRateShow=$leaseRateShow fMessageID=$messageID
			:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard teLeaseCard"; :log info "teCallbackLeaseCard teLeaseCard"}

			:if ($isBlocked = true) do={:set currentAddressList $blockList}
			:if ($isBlocked = false) do={:set currentAddressList $allowList}

			:local findingMessage [/ip firewall address-list get number=$currentRecord]
			:if ([:len $findingMessage] != 0) do={
				:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard deleting leaseActIP = $leaseActIP"; :log info "teCallbackLeaseCard deleting leaseActIP = $leaseActIP"}
				/ip firewall address-list remove number=$currentRecord
			}

			:if ([:len [/ip dhcp-server lease find mac-address=$leaseActMAC and !disabled and !dynamic and address=$leaseActIP]] != 0) do={
				/ip firewall address-list add list=$currentAddressList address=$leaseActIP comment="$leaseNote,$leaseInfo,$isBlocked,Updated,$dateM $timeM,$leaseActMAC,$leaseHostname,$leaseParams,$leaseRateShow,$currentMessageID"
			} else={
				/ip firewall address-list add list=$currentAddressList address=$leaseActIP timeout=$firewallAddressListTimeout comment="$leaseNote,$leaseInfo,$isBlocked,Updated,$dateM $timeM,$leaseActMAC,$leaseHostname,$leaseParams,$leaseRateShow,$currentMessageID"
			}
			:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard return from $currentAddressList"; :log info "teCallbackLeaseCard return from $currentAddressList"}

			:return true
		} else={
			:local inArray false
			do {
				:foreach k,v in=$dbaseDynLease do={
					:if ($k = $messageID) do={
						:set inArray true
						:error message="Record found in leaseArray"
					}
				}
			} on-error={:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard Record found in leaseArray"; :log warning "teCallbackLeaseCard Record found in leaseArray"}}

			:if ($inArray) do={
				:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard commandName=$commandName"; :log info "teCallbackLeaseCard commandName=$commandName"}

				:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName="leasedelete"] = false) do={
					$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$accessDeniedMessage fAlert=true
					:return false
				}

				:set answer "\$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=\" \""
				:execute script=$answer

				:local deleteRequest $commandValue
				:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard deleteRequest=$deleteRequest"; :log info "teCallbackLeaseCard deleteRequest=$deleteRequest"}

				:local NB ","
				:local NL "\5D,\5B"

				:local pictDelete "\F0\9F\97\91"
				:local buttonDeleteCallBackText "teCallbackLeaseCard,delete,request"
				:local buttonDelete [$teBuildButton fPictButton=$pictDelete fTextButton="  Delete?" fTextCallBack=$buttonDeleteCallBackText]

				:local pictYes "\E2\9C\85"
				:local buttonYesCallBackText "teCallbackLeaseCard,delete,true"
				:local buttonYes [$teBuildButton fPictButton=$pictYes fTextButton="  Yes" fTextCallBack=$buttonYesCallBackText]

				:local pictNo "\E2\9D\8C"
				:local buttonNoCallBackText "teCallbackLeaseCard,delete,false"
				:local buttonNo [$teBuildButton fPictButton=$pictNo fTextButton="  No" fTextCallBack=$buttonNoCallBackText]

				:if ($deleteRequest = "request") do={
					:local lineButtons "$buttonDelete$NL$buttonYes$NB$buttonNo"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}

				:if ($deleteRequest = "true") do={
					:if ($fDBGteCallbackLeaseCard = true) do={:put "teCallbackLeaseCard deleteting MSG=$messageID"; :log info "teCallbackLeaseCard  deleteting MSG=$messageID"}

					:set ($dbaseDynLease->$messageID)
					$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID fUserName=$userName
					:return true
				}

				:if ($deleteRequest = "false") do={
					:local pictWaiting "\F0\9F\95\93"
					:local buttonWaitingCallBackText "teCallbackLeaseCard,waiting,request"
					:local buttonWaiting [$teBuildButton fPictButton=$pictWaiting fTextButton="  Waiting..." fTextCallBack=$buttonWaitingCallBackText]

					:local lineButtons "$buttonWaiting"
					:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]

					$teEditMessageReplyMarkup fChatID=$queryChatID fMessageID=$messageID fReplyMarkup=$replyMarkup
					:return true
				}


			} else={
				:local errorMessage "$pictAnswerCallback Record not found in the Address Lists, deleting..."
				$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$errorMessage fAlert=true
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID fUserName=$userName
				:return true
			}
		}
	} on-error={
		:put "teCallbackLeaseCard return ERROR"; :log info "teCallbackLeaseCard return ERROR"
		:return false
	}
