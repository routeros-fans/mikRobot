#---------------------------------------------------teMessageResponse --------------------------------------------------------------

#		fMessage			-		current message from Telegram
#		fCommand			-		command "getusers" or "getifaces"
#		fDeleteReport	-		true or false, deletes the task completion report

#   Function return true or false

#   if the global variable fDBGteMessageResponse=true, then a debug event will be logged

#---------------------------------------------------teMessageResponse--------------------------------------------------------------

:global teMessageResponse
:if (!any $teMessageResponse) do={ :global teMessageResponse do={

	:global teDebugCheck
	:local fDBGteMessageResponse [$teDebugCheck fDebugVariableName="fDBGteMessageResponse"]

	:global dbaseVersion
	:local teMessageResponseVersion "2.07.9.22"
	:set ($dbaseVersion->"teMessageResponse") $teMessageResponseVersion

	:global dbaseBotSettings
	:local botID ($dbaseBotSettings->"botID")
	:local botName ($dbaseBotSettings->"botName")
	:local logPinGroup ($dbaseBotSettings->"logPinGroup")
	:local usersGroup ($dbaseBotSettings->"usersGroup")
	:local ifaceGroup ($dbaseBotSettings->"ifaceGroup")

	:global teUsersCard
	:global teIfaceCard
	:global teRootMenu
	:global teLeaseCard

	:global teSendMessage
	:global teEditMessage
	:global teDeleteMessage
	:global teBuildButton
	:global teBuildKeyboard
	:global teRightsControl
	:global tePinMessage

	:global teGetDate
	:global teGetTime
	:local dateM [$teGetDate]
	:local timeM [$teGetTime]

	:local pictAnswerMessage "\E2\9D\97"
	:local answerMessage []
	:local leaseInfo []

	:local userChatID [:tostr ($fMessage->"message"->"from"->"id")]
	:local queryChatID [:tostr ($fMessage->"message"->"chat"->"id")]
	:local queryChatTitle ($fMessage->"message"->"chat"->"title")
	:local userName [:tostr ($fMessage->"message"->"from"->"username")]
	:local messageText ($fMessage->"message"->"text")

	:local messageIP [:pick $messageText [find $messageText "IP - "] [:len $messageText]]
	:set messageIP [:pick $messageIP ([find $messageIP "IP - "] +5) [find $messageIP ";"]]
	:set messageIP [:toip $messageIP]
	:if ([:len $messageIP] = 0) do={ :set messageIP 0 }

	:if ($fCommand = "getusers" or $fCommand = "getifaces") do={:set messageText $fCommand}

	:local messageID []
	:local sendText []

	:if ($messageText~"start") do={
		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=root]) do={
			$teRootMenu fChatID=$userChatID
			:return true
		}
	}

	:if ($messageText~"chatid") do={
		:set messageID [$teSendMessage fChatID=$queryChatID fText=$queryChatID]
		:return true
	}

	:if (!($messageText ~ $botName)) do={
		:if ($fDBGteMessageResponse) do={:put "teMessageResponse - Message not for this bot"; :log info "teMessageResponse - Message not for this bot"}
		:return true
	}

	:if ($messageText~",leaseNote=") do={
		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=leasewrite]) do={
			:local leaseNoteID [:pick $messageText ([:find $messageText "ID="]+3) ([:find $messageText ",leaseNote="])]
			:local leaseNote [:pick $messageText ([:find $messageText ",leaseNote="]+11) [:len $messageText]]

			:if ([$tePinMessage fChatID=$queryChatID fMessageID=$leaseNoteID] = 0) do={
				:set answerMessage "$pictAnswerMessage error: Incorrect <b>message ID</b>"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}

			:local currentMessageID "MSG=$leaseNoteID"
			:local currentRecord []
			:local recordMessageID []

			:local recordsArray [/ip firewall address-list find comment~"$currentMessageID" and !disabled]
			:foreach i in=$recordsArray do={
				:set recordMessageID [:toarray [/ip firewall address-list get [find .id=$i] comment]]
				:if (($recordMessageID->9) = $currentMessageID) do={
					:set currentRecord $i
				}
			}
			:local commentArray [:toarray [/ip firewall address-list get number=$currentRecord comment]]
			:set ($commentArray->0) $leaseNote
			:set leaseInfo ($commentArray->1)

			:local commentArrayStr ""
			:foreach i in=$commentArray do={:set commentArrayStr ($commentArrayStr.",".[:tostr $i])}
			/ip firewall address-list set numbers=$currentRecord comment=[:pick $commentArrayStr 1 [:len $commentArrayStr]]
			[[:parse [system script get teCallbackLeaseCard source]] queryID=0 queryChatID=$queryChatID userChatID=$userChatID messageID=$leaseNoteID messageIP=$currentIP commandName="leaseInfo" commandValue=$leaseInfo]
			:return true
		}
		:return true
	}

	:if ($messageText~",leaseTime=") do={
		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=leasewrite]) do={
			:local leaseTimeID [:pick $messageText ([:find $messageText "ID="]+3) ([:find $messageText ",leaseTime="])]
			:local leaseTime [:pick $messageText ([:find $messageText ",leaseTime="]+11) [:len $messageText]]
			:if ([$tePinMessage fChatID=$queryChatID fMessageID=$leaseTimeID] = 0) do={
				:set answerMessage "$pictAnswerMessage error: Incorrect <b>message ID</b>"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}

			:if ([:len $leaseTime] = 0) do={
				:set leaseTime (00:00:00)
			}

			:local currentMessageID "MSG=$leaseTimeID"
			:local currentMAC []
			:local currentIP []
			:local currentRecord []
			:local recordMessageID []

			:local recordsArray [/ip firewall address-list find comment~"$currentMessageID" and !disabled]
			:foreach i in=$recordsArray do={
				:set recordMessageID [:toarray [/ip firewall address-list get [find .id=$i] comment]]
				:if (($recordMessageID->9) = $currentMessageID) do={
					:set currentRecord $i
					:set currentMAC ($recordMessageID->5)
					:set leaseInfo ($recordMessageID->1)
					:set currentIP [/ip firewall address-list get $i address]
				}
			}

			:do {
				/ip dhcp-server lease set [find mac-address=$currentMAC and !disabled and !dynamic and address=$currentIP] lease-time="$leaseTime"
				[[:parse [system script get teCallbackLeaseCard source]] queryID=0 queryChatID=$queryChatID userChatID=$userChatID messageID=$leaseTimeID messageIP=$currentIP commandName="leaseInfo" commandValue=$leaseInfo]

				:return true
			} on-error={
				:set answerMessage "$pictAnswerMessage error: Incorrect <b>leaseTime</b>"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}
		}
		:return true
	}

	:if ($messageText~",leaseBlock=") do={
		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=leasewrite]) do={
			:local leaseBlockID [:pick $messageText ([:find $messageText "ID="]+3) ([:find $messageText ",leaseBlock="])]
			:local leaseBlock [:pick $messageText ([:find $messageText ",leaseBlock="]+12) [:len $messageText]]

			:if ([$tePinMessage fChatID=$queryChatID fMessageID=$leaseBlockID] = 0) do={
				:set answerMessage "$pictAnswerMessage error: Incorrect <b>message ID</b>"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}

			:local currentMessageID "MSG=$leaseBlockID"
			:local currentMAC []
			:local currentIP []
			:local currentRecord []
			:local recordMessageID []

			:local recordsArray [/ip firewall address-list find comment~"$currentMessageID" and !disabled]
			:foreach i in=$recordsArray do={
				:set recordMessageID [:toarray [/ip firewall address-list get [find .id=$i] comment]]
				:if (($recordMessageID->9) = $currentMessageID) do={
					:set currentRecord $i
					:set currentMAC ($recordMessageID->5)
					:set leaseInfo ($recordMessageID->1)

					:set currentIP [/ip firewall address-list get [find comment~$currentMAC and !disabled] address]
				}
			}

			:do {
				/ip dhcp-server lease set [find mac-address=$currentMAC and !disabled and !dynamic and address=$currentIP] block-access="$leaseBlock"
				[[:parse [system script get teCallbackLeaseCard source]] queryID=0 queryChatID=$queryChatID userChatID=$userChatID messageID=$leaseBlockID commandName="leaseInfo" commandValue=$leaseInfo]

				:return true
			} on-error={
				:set answerMessage "$pictAnswerMessage error: Incorrect <b>leaseBlock</b>"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}
		}
		:return true
	}

	:if ($messageText~",leaseRate=") do={
		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=leasewrite]) do={
			:local leaseRateID [:pick $messageText ([:find $messageText "ID="]+3) ([:find $messageText ",leaseRate="])]
			:local leaseRate [:pick $messageText ([:find $messageText ",leaseRate="]+11) [:len $messageText]]

			:if ([$tePinMessage fChatID=$queryChatID fMessageID=$leaseRateID] = 0) do={
				:set answerMessage "$pictAnswerMessage error: Incorrect <b>message ID</b>"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}

			:local currentMessageID "MSG=$leaseRateID"
			:local currentMAC []
			:local currentIP []
			:local currentRecord []
			:local recordMessageID []

			:local recordsArray [/ip firewall address-list find comment~"$currentMessageID" and !disabled]
			:foreach i in=$recordsArray do={
				:set recordMessageID [:toarray [/ip firewall address-list get [find .id=$i] comment]]
				:if (($recordMessageID->9) = $currentMessageID) do={
					:set currentRecord $i
					:set currentMAC ($recordMessageID->5)
					:set leaseInfo ($recordMessageID->1)

					:set currentIP [/ip firewall address-list get [find comment~$currentMAC and !disabled] address]
				}
			}
			:do {
				/ip dhcp-server lease set [find mac-address=$currentMAC and !disabled and !dynamic and address=$currentIP] rate-limit="$leaseRate"
				[[:parse [system script get teCallbackLeaseCard source]] queryID=0 queryChatID=$queryChatID userChatID=$userChatID messageID=$leaseRateID commandName="leaseInfo" commandValue=$leaseInfo]

				:return true
			} on-error={
				:set answerMessage "$pictAnswerMessage error: Incorrect <b>leaseRate</b>"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}
		}
		:return true
	}

	:if ($messageText~",addVid=") do={
		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=ifacewrite]) do={
			:local ifaceMessageID [:pick $messageText ([:find $messageText "ID="]+3) ([:find $messageText ",addVid="])]
			:local vlanID [:pick $messageText ([:find $messageText ",addVid="]+8) ([:find $messageText ",addName="])]
			:local vlanName [:pick $messageText ([:find $messageText ",addName="]+9) [:len $messageText]]

			:if ($fDBGteMessageResponse = true) do={:log info "teMessageResponse ifaceMessageID=$ifaceMessageID, vlanID=$vlanID, vlanName=$vlanName"}

			:if ([$tePinMessage fChatID=$queryChatID fMessageID=$ifaceMessageID] = 0) do={
				:set answerMessage "$pictAnswerMessage error: Incorrect <b>message ID</b>"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}

			:local currentMessageID "MSG=$ifaceMessageID"
			:local ifaceName []
			:local recordMessageID []
			:local currentRecord []

			:if ($fDBGteMessageResponse = true) do={:log info "teMessageResponse currentMessageID=$currentMessageID"}

			:local recordsArray [/interface find comment~"$currentMessageID"]
			:foreach i in=$recordsArray do={
				:set recordMessageID [:toarray [/interface get [find .id=$i] comment]]
				:if (($recordMessageID->2) = $currentMessageID) do={
					:set currentRecord $i
					:set ifaceName [/interface get $currentRecord name]
				}
			}

			:if ($fDBGteMessageResponse = true) do={:log info "teMessageResponse ifaceName=$ifaceName"}

			:do {
				/interface vlan add name=$vlanName arp=enabled vlan-id=$vlanID interface=$ifaceName
				:return true
			} on-error={
				:set answerMessage "$pictAnswerMessage error: Command Incorrect"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}
		}
	}

	:if ($messageText~",setVid=") do={
		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=ifacewrite]) do={
			:local ifaceMessageID [:pick $messageText ([:find $messageText "ID="]+3) ([:find $messageText ",setVid="])]
			:local vlanID [:pick $messageText ([:find $messageText ",setVid="]+8) ([:find $messageText ",setIF="])]
			:local vlanIF [:pick $messageText ([:find $messageText ",setIF="]+7) ([:find $messageText ",setName="])]
			:local vlanName [:pick $messageText ([:find $messageText ",setName="]+9) [:len $messageText]]

			:if ($fDBGteMessageResponse = true) do={:log info "teMessageResponse ifaceMessageID=$ifaceMessageID, vlanIF=$vlanIF, vlanID=$vlanID, vlanName=$vlanName"}

			:if ([$tePinMessage fChatID=$queryChatID fMessageID=$ifaceMessageID] = 0) do={
				:set answerMessage "$pictAnswerMessage error: Incorrect <b>message ID</b>"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}

			:local currentMessageID "MSG=$ifaceMessageID"
			:local ifaceName []
			:local recordMessageID []
			:local currentRecord []
			:local currentIfaceInfo []
			:local currentIfaceNote []

			:if ($fDBGteMessageResponse = true) do={:log info "teMessageResponse currentMessageID=$currentMessageID"}

			:local recordsArray [/interface vlan find comment~"$currentMessageID"]
			:foreach i in=$recordsArray do={
				:set recordMessageID [:toarray [/interface vlan get [find .id=$i] comment]]
				:if (($recordMessageID->2) = $currentMessageID) do={
					:set currentRecord $i
					:set currentIfaceInfo ($recordMessageID->1)
					:set currentIfaceNote ($recordMessageID->0)
				}
			}

			:if ($fDBGteMessageResponse = true) do={:log info "teMessageResponse ifaceName=$vlanIF"}

			:do {
				/interface vlan set $currentRecord name=$vlanName arp=enabled vlan-id=$vlanID interface=$vlanIF
				:set messageID [$teIfaceCard fChatID=$ifaceGroup fMessageID=$ifaceMessageID fIfaceName=$vlanName fIfaceInfo=$currentIfaceInfo fIfaceNote=$currentIfaceNote]
				:return true
			} on-error={
				:set answerMessage "$pictAnswerMessage error: Command Incorrect"
				:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
				:delay 1000ms
				$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
				:return false
			}
		}
	}

	:if ($messageText~"users") do={

		:local usersArray [/user print as-value]
		:local currentMessageID []
		:local currentUserInfo []
		:local currentName []
		:local currentNumber []
		:local counter 0

		:foreach i in=$usersArray do={
			:set currentNumber ($i->".id")
			:if (($i->"comment")~"MSG=") do={
				:set currentUserInfo ([:toarray ($i->"comment")]->0)
				:set currentMessageID ([:toarray ($i->"comment")]->1)
				:set currentMessageID [:pick $currentMessageID ([find $currentMessageID "MSG="] + 4) [:len $currentMessageID]]
			} else={:set currentMessageID 0; :set currentUserInfo false}
			:set currentName ($i->"name")
			:if ([:len $usersArray] >= 20) do={ :delay 3 }
			:set messageID [$teUsersCard fChatID=$usersGroup fMessageID=$currentMessageID fUserName=$currentName fUserInfo=$currentUserInfo]
			:if ($messageID != 0) do={
				/user set number=$currentNumber comment="$currentUserInfo,MSG=$messageID"
			} else={:return [error message="teMessageResponse Error: teUsersCard return Error"]}
		}
		:set dateM [$teGetDate]; :set timeM [$teGetTime]
		:set answerMessage "<b>Users</b> update complite at <b>$dateM $timeM</b>"
		:set messageID [$teSendMessage fChatID=$usersGroup fText=$answerMessage]

		:if ($fDeleteReport = true) do={
			$teDeleteMessage fChatID=$usersGroup fMessageID=$messageID
		}
		:return true
	}

	:if ($messageText~"interfaces") do={

		:local ifacesArray [/interface print as-value where !dynamic and !(name~"GW")]
		:local currentMessageID []
		:local currentIfaceNote false
		:local currentIfaceInfo []
		:local currentName []
		:local currentNumber []
		:foreach i in=$ifacesArray do={
			:set currentNumber ($i->".id")
			:if (($i->"comment")~"MSG=") do={
				:set currentIfaceNote ([:toarray ($i->"comment")]->0)
				:set currentIfaceInfo ([:toarray ($i->"comment")]->1)
				:set currentMessageID ([:toarray ($i->"comment")]->2)
				:set currentMessageID [:pick $currentMessageID ([find $currentMessageID "MSG="] + 4) [:len $currentMessageID]]
			} else={:set currentMessageID 0; :set currentIfaceInfo false; :set currentIfaceNote false}
			:set currentName ($i->"name")
			:if ($fDBGteMessageResponse = true) do={:log info "teMessageResponse currentName = $currentName"}
			:if ([:len $ifacesArray] >= 20) do={ :delay 3 }
			:set messageID [$teIfaceCard fChatID=$ifaceGroup fMessageID=$currentMessageID fIfaceName=$currentName fIfaceInfo=$currentIfaceInfo fIfaceNote=$currentIfaceNote]
			:if ($messageID != 0) do={
				/interface set numbers=$currentNumber comment="$currentIfaceNote,$currentIfaceInfo,MSG=$messageID"
			} else={:return [error message="teMessageResponse Error: teIfaceCard return Error"]}
			:set currentIfaceNote false; :set currentIfaceInfo []; :set currentName []; :set currentNumber []
		}
		:set dateM [$teGetDate]; :set timeM [$teGetTime]
		:set answerMessage "<b>Interfaces</b> update complite at <b>$dateM $timeM</b>"
		:set messageID [$teSendMessage fChatID=$ifaceGroup fText=$answerMessage]

		:if ($fDeleteReport = true) do={
			$teDeleteMessage fChatID=$ifaceGroup fMessageID=$messageID
		}
		:return true
	}

	:set answerMessage "$pictAnswerMessage Error: Command <b>$messageText</b> not found."
	:set messageID [$teSendMessage fChatID=$queryChatID fText=$answerMessage]
	:delay 1000ms
	$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID

	:if ($fDBGteMessageResponse = true) do={:log info "teMessageResponse Error: command $messageText not found"}
	:return false
 }
}
