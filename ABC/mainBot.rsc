
:global dbaseBotSettings
:local botID ($dbaseBotSettings->"botID")
:local logSendGroup ($dbaseBotSettings->"logSendGroup")
:local logPinGroup ($dbaseBotSettings->"logPinGroup")
:local botName ($dbaseBotSettings->"botName")

:global dbaseVersion
:local mainBotVersion "2.07.9.22"
:set ($dbaseVersion->"mainBot") $mainBotVersion

:global teSendMessage
:global teRightsControl
:global teDeleteMessage
:global teCallbackResponse
:global teAnswerCallbackQuery
:global teMessageResponse
:global teInlineResponse
:global teTerminalResponse
:global teSetMyCommands
:global teDebugCheck
:global teBuildButton
:global teBuildKeyboard

:global fJParse
:global Jtoffset
:global JSONIn []
:global JParseOut []
:global Jdebug false

:global teGetDate
:global teGetTime
:local dateM [$teGetDate]
:local timeM [$teGetTime]

:local queryID []
:local userChatID []
:local queryChatID []
:local userName []
:local messageID []
:local messageText []
:local sendText []
:local callbackMessage []
:local oneFeed "%0D%0A"
:local pictAnswerCallback "\E2\9D\97"

$teSetMyCommands fCommands="interfaces;Get interfaces list,users;Get users list,chatid;Get ID of current chat"

:while (true) do={
	:local fDBGmainBot [$teDebugCheck fDebugVariableName="fDBGmainBot"]
		:do {
			:if ([:typeof $Jtoffset] != "num") do={:set Jtoffset [:tonum $Jtoffset]}
			:local tgUrl "https://api.telegram.org/$botID/getUpdates\?&allowed_updates=[%22inline_query%22,%22channel_post%22,%22message%22,%22callback_query%22]&offset=$Jtoffset&timeout=15"
			:local fetchData [/tool fetch ascii=yes url=$tgUrl as-value output=user]
			:if ([:len [:tostr ($fetchData->"data")]] != 0) do={
				:set fetchData ($fetchData->"data")
				:set JSONIn $fetchData
				:set JParseOut [$fJParse]
				:if ([:len ($JParseOut->"result")] != 0) do={
					:set JParseOut ($JParseOut->"result")
				} else={ :error message="no data..." }
			}

			:if ($fDBGmainBot) do={:log info "teBot result loaded"}

			:foreach k,v in=$JParseOut do={
				:set $Jtoffset ($v->"update_id" + 1)

				:if (any ($v->"inline_query")) do={
					:if ($fDBGmainBot) do={:put "mainBot - get inline_query"; :log info "mainBot - get inline_query"}
					:local userChatID [:tostr ($v->"inline_query"->"from"->"id")]
					:local queryText [:tostr ($v->"inline_query"->"query")]

					:if ([:len $queryText] = 0) do={
						:set $Jtoffset ($v->"update_id" + 1)
						:error message="empty query..."
					}

					:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=root]) do={
						:if ([$teInlineResponse fMessage=$v] = true) do={
							:set $Jtoffset ($v->"update_id" + 1)
							:if ($fDBGmainBot) do={:put "mainBot - get inline_query"; :log info "mainBot - get inline_query"}
						} else={
							:if ($fDBGmainBot) do={:put "teInlineResponse - return false"; :log info "teInlineResponse - return false"}
							:set $Jtoffset ($v->"update_id" + 1)
						}
					} else={
						:if ($fDBGmainBot) do={:put "$userChatID - Access denied"; :log info "$userChatID - Access denied"}
						:set $Jtoffset ($v->"update_id" + 1)
					}
				}

				:if (any ($v->"callback_query")) do={
					:set queryID ($v->"callback_query"->"id")
					:set userName ($v->"callback_query"->"from"->"username")
					:set userChatID [:tostr ($v->"callback_query"->"from"->"id")]
					:set queryChatID [:tostr ($v->"callback_query"->"message"->"chat"->"id")]
					:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=root]) do={
						:if ([$teCallbackResponse fCallback=$v] = true) do={
							:set $Jtoffset ($v->"update_id" + 1)
						} else={
							:set callbackMessage "$pictAnswerCallback Module is not installed"
							$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$callbackMessage fAlert="True"
							:if ($fDBGmainBot) do={:put "teCallbackResponse - return false"; :log info "teCallbackResponse - return false"}
							:set $Jtoffset ($v->"update_id" + 1)
						}
					} else={
						:set callbackMessage "$pictAnswerCallback For user $userName - Access denied "
						$teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$callbackMessage fAlert="True"
						:if ($fDBGmainBot) do={:put "$userChatID - Access denied"; :log info "$userChatID - Access denied"}
						:set $Jtoffset ($v->"update_id" + 1)
					}
				}

				:if (any ($v->"message")) do={
					:local userChatID [:tostr ($v->"message"->"from"->"id")]
					:local queryChatID [:tostr ($v->"message"->"chat"->"id")]
					:local userName [:tostr ($v->"message"->"chat"->"username")]
					:local messageID ($v->"message"->"message_id")
					:local messageText ($v->"message"->"text")

					:if (any ($v->"message"->"pinned_message")) do={
						:local queryChatTitle ($v->"message"->"chat"->"title")
						:local pinnedMessageID ($v->"message"->"pinned_message"->"message_id")
						:local pinnedMessageText ($v->"message"->"pinned_message"->"text")
						:local pinnedMessageFromID ($v->"message"->"pinned_message"->"from"->"id")
						:local pinUserName ($v->"message"->"from"->"username")
						:if ($fDBGmainBot) do={:put "teBot - pinnedMessageID $pinnedMessageID"; :log info "teBot - pinnedMessageID $pinnedMessageID"}
						:if ($botID ~ [:tostr $pinnedMessageFromID]) do={
							:local pinMessageChat [:pick $queryChatID 4 [:len $queryChatID]]

							:local pictJump "\E2\96\B6"
							:local buttonJumpUrl "https://t.me/c/$pinMessageChat/$pinnedMessageID"
							:local buttonJump [$teBuildButton fPictButton=$pictJump fTextButton="  Jump to message" fUrlButton=$buttonJumpUrl]

							:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$buttonJump fReplyKeyboard=false]
							:if ($fDBGmainBot) do={:put "teBot - replyMarkup $replyMarkup"; :log info "teBot - replyMarkup $replyMarkup"}

							:local pictStatic "\F0\9F\96\87"
							:set sendText "$pictStatic <b>$dateM $timeM</b> User <b>$pinUserName</b> pin message in chat <b>$queryChatTitle</b>"
							$teSendMessage fChatID=$logPinGroup fText=$sendText fReplyMarkup=$replyMarkup
							$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
							:set $Jtoffset ($v->"update_id" + 1)
							:error message="empty query..."
						}
					}

					:if ($fDBGmainBot) do={:put "teBot - messageText $messageText"; :log info "teBot - messageText $messageText"}
					:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=root]) do={
						$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
						:if (($v->"message"->"text") ~ "=>") do={
							:if ([$teTerminalResponse fMessage=$v] = true) do={:set $Jtoffset ($v->"update_id" + 1)}
						} else={
							:if ([$teMessageResponse fMessage=$v] = true) do={
								:set $Jtoffset ($v->"update_id" + 1)}
							}
					} else={
						:set sendText ("$pictAnswerCallback <b>$userName</b> this is private bot! $oneFeed" . "You are not allowed to use!")
						$teSendMessage fChatID=$userChatID fText=$sendText
						:set sendText "$pictAnswerCallback User <b>$userName</b> id = $userChatID send text to bot - <b>$messageText</b>"
						$teSendMessage fChatID=$logSendGroup fText=$sendText
						$teDeleteMessage fChatID=$queryChatID fMessageID=$messageID
					}
				}
			}
		} on-error={ :if ($fDBGmainBot) do={:log info "no data..."}}
}
