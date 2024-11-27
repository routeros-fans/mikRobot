#---------------------------------------------------teTerminalResponse --------------------------------------------------------------

#		fMessage		-		current message from Telegram

#---------------------------------------------------teTerminalResponse--------------------------------------------------------------

:global teTerminalResponse
:if (!any $teTerminalResponse) do={ :global teTerminalResponse do={

	:global teDebugCheck
	:local fDBGteTerminalResponse [$teDebugCheck fDebugVariableName="fDBGteTerminalResponse"]

	:global dbaseVersion
	:local teTerminalResponseVersion "2.25.9.22"
	:set ($dbaseVersion->"teTerminalResponse") $teTerminalResponseVersion

	:global dbaseBotSettings
	:local devicePicture ($dbaseBotSettings->"devicePicture")
	:local deviceName ("$devicePicture " . ($dbaseBotSettings->"deviceName"))
	:local logSendGroup ($dbaseBotSettings->"logSendGroup")

	:global teTerminal
	:global teRightsControl
	:global teSendMessage
	:global teDeleteMessage

	:global teGetDate
	:global teGetTime
	:local dateM [$teGetDate]
	:local timeM [$teGetTime]
	:local oneFeed "%0D%0A"

	:local pictAnswer "\E2\9D\97"

	:local userChatID [:tostr ($fMessage->"message"->"from"->"id")]
	:local queryChatID [:tostr ($fMessage->"message"->"chat"->"id")]
	:local queryChatTitle ($fMessage->"message"->"chat"->"title")
	:local userName [:tostr ($fMessage->"message"->"from"->"username")]
	:local messageText ($fMessage->"message"->"text")

	:local rootMessageID ($dbaseBotSettings->$userChatID->"rootMessageID")

	:if ([:len $rootMessageID] = 0) do={
		:local sendText "<b>$pictAnswer$deviceName: $dateM $timeM</b>%0D%0A%0D%0A<b>Error:</b> Root messageID  not found.%0D%0A<b>Clear chat and try again</b>."
		$teSendMessage fChatID=$logSendGroup fText=$sendText
		:return true
	}

	:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=terminal] = false) do={
		:local sendText ("$pictAnswer" . "For user <b>$userName</b> - Access denied")
		:local answerMessageID [$teSendMessage fChatID=$userChatID fText=$sendText]
		:delay 2000ms
		$teDeleteMessage fChatID=$queryChatID fMessageID=$answerMessageID
		:return true
	}

	:local commandFromText [:pick $messageText ([find $messageText "=>"] + 2) [:len $messageText]]
	:if ($fDBGteTerminalResponse = true) do={ :put " teTerminalResponse commandFromText = $commandFromText"; :log info "teTerminalResponse commandFromText = $commandFromText"}

	:local result []
	:if ($commandFromText ~ "ping" and !($commandFromText~"count=")) do={
		:local pingAnswer "$pictAnswer Count parameter is not specified"
		:set result [$teTerminal fChatID=$queryChatID  fMessageID=$rootMessageID fCommandInfo=$commandFromText fCallbackMsg=$pingAnswer]
		:return true
	}

	do {
		:set result [[:parse "$commandFromText"]]
	} on-error={ :set result "$pictAnswer Command Error" }

	:set result [:tostr $result]
	:if ([:len $result] = 0) do={ :set result "Command is executed" }
	:if ([:len $result] > 500) do={
		:local textToLogSend "<b>command:</b><code>$commandFromText</code>$oneFeed$oneFeed<b>result:</b><code>$result</code>"
		:if ([:len $textToLogSend] >= 4096) do={ :set textToLogSend [:pick $textToLogSend 0 4095] }
		$teSendMessage fChatID=$logSendGroup fText=$textToLogSend
		:set result [:pick $result 0 500]
	}

	:set result [$teTerminal fChatID=$userChatID fMessageID=$rootMessageID fCommandInfo=$messageText fCallbackMsg=$result]

	:if ($fDBGteTerminalResponse = true) do={:log info "teCallbackResponse result = $result"}

	:return $result
 }
}
