#---------------------------------------------------teInlineResponse --------------------------------------------------------------

#		fMessage		-		current message from Telegram

#---------------------------------------------------teInlineResponse--------------------------------------------------------------

:global teInlineResponse
:if (!any $teInlineResponse) do={ :global teInlineResponse do={

	:global teDebugCheck
	:local fDBGteInlineResponse [$teDebugCheck fDebugVariableName="fDBGteInlineResponse"]

	:global dbaseVersion
	:local teInleneResponseVersion "2.07.9.22"
	:set ($dbaseVersion->"teInlineResponse") $teInleneResponseVersion

	:global dbaseBotSettings
	:local devicePicture ($dbaseBotSettings->"devicePicture")
	:local deviceName ("$devicePicture " . ($dbaseBotSettings->"deviceName"))
	:local logSendGroup ($dbaseBotSettings->"logSendGroup")

	:global dbaseInlineCommands

	:global teInlineQueryResultArticle
	:global teInputTextMessageContent
	:global teAnswerInlineQuery
	:global teBuilQueryResult
	:global teRightsControl
	:global teSendMessage
	:global teDeleteMessage

	:if ($fDBGteInlineResponse = true) do={:put "teInlineResponse begin..."; :log info "teInlineResponse begin..."}

	:global teGetDate
	:global teGetTime
	:local dateM [$teGetDate]
	:local timeM [$teGetTime]

	:local pictAnswer "\E2\9D\97"

	:local queryID [:tostr ($fMessage->"inline_query"->"id")]
	:local userChatID [:tostr ($fMessage->"inline_query"->"from"->"id")]
	:local queryText [:tostr ($fMessage->"inline_query"->"query")]
	:local queryOffset [:tostr ($fMessage->"inline_query"->"offset")]

	:if ($fDBGteInlineResponse = true) do={:put "teInlineResponse queryID = $queryID"; :log info "teInlineResponse queryID = $queryID"}
	:if ($fDBGteInlineResponse = true) do={:put "teInlineResponse queryText = $queryText"; :log info "teInlineResponse queryText = $queryText"}

	:local rootMessageID ($dbaseBotSettings->$userChatID->"rootMessageID")

#	:if ([:len $rootMessageID] = 0) do={
#		:local sendText "<b>$pictAnswer$deviceName: $dateM $timeM</b>%0D%0A%0D%0A<b>Error:</b> Root messageID  not found.%0D%0A<b>Clear chat and try again</b>."
#		$teSendMessage fChatID=$logSendGroup fText=$sendText
#		:return true
#	}

	:if ($fDBGteInlineResponse = true) do={:put "teInlineResponse query = $queryText"; :log info "teInlineResponse query = $queryText"}

	:if ($queryText = "teTerminal") do={

		:local prevOffset ($dbaseBotSettings->$userChatID->"terminalQueryOffset")
		:if ($fDBGteInlineResponse = true) do={:put "prevOffset = $prevOffset"; :log info "prevOffset = $prevOffset"}

		:if ([$teRightsControl fMethod=get fGroupID=$userChatID fRightName=terminal] = false) do={
			:local sendText ("$pictAnswer" . "For user <b>$userName</b> - Access denied")
			:local answerMessageID [$teSendMessage fChatID=$userChatID fText=$sendText]
			:delay 2000ms
			$teDeleteMessage fChatID=$queryChatID fMessageID=$answerMessageID
			:return true
		}
		:local lenArray ([:len $dbaseInlineCommands] - 1); :if ($lenArray = 0) do={ :return true }
		:if ($fDBGteInlineResponse = true) do={:log info "teInlineResponse lenArray = $lenArray"}

		:local terminalCommands []
		:local errorMessage []
		:local paramOffset []
		:local currentOffset $queryOffset
		:if ($fDBGteInlineResponse = true) do={:put "teInlineResponse queryOffset = $queryOffset"; :log info "teInlineResponse queryOffset = $queryOffset"}

		:local offset []
		:if ([:len $currentOffset] = 0) do={ :set $currentOffset 1
			:if ($lenArray > 5) do={ :set offset 4; :set paramOffset 6 } else={ :set offset ($lenArray - 1); :set paramOffset ""}
		} else={
			:if (($lenArray - $currentOffset) < 5) do={
				:set offset ($lenArray - $currentOffset)
				:if ($offset <= 0) do={ :set offset 0 }
				:set paramOffset ""
			} else={ :set offset 4; :set paramOffset ($currentOffset + 5) }
		}

		:if ($lenArray > 5) do={
			:set ($dbaseBotSettings->$userChatID->"terminalQueryOffset") ($currentOffset + $offset)
		} else={ :set ($dbaseBotSettings->$userChatID->"terminalQueryOffset") "" }

		:if ($prevOffset = ($currentOffset + $offset)) do={
			:if ($fDBGteInlineResponse = true) do={:log info "teInlineResponse error offset"}
				:return true
		}

		:if ($fDBGteInlineResponse = true) do={:log info "teInlineResponse currentOffset = $currentOffset"}
		:if ($fDBGteInlineResponse = true) do={:log info "teInlineResponse offset = $offset"}

		:for i from=$currentOffset to=($currentOffset + $offset) do={
			:do {
					:if ($fDBGteInlineResponse = true) do={:put "teInlineResponse i = $i"; :log info "teInlineResponse i = $i"}

					:local currentDbItem ($dbaseInlineCommands->$i)

					:local itemCommand [:toarray $currentDbItem]
					:local title ($itemCommand->1)
					:local description ($itemCommand->2)
					:local messageContent [$teInputTextMessageContent fMessageText=$description]

					:local inlineID ([certificate scep-server otp generate minutes-valid=0 as-value]->"password")
					:local currentItem [$teInlineQueryResultArticle fInputMessageContent=$messageContent fArticleUrl="" fInlineQueryID=$inlineID fTitle=$title fDescription=$description fThumbUrl="https://habrastorage.org/webt/17/cb/ji/17cbjiuymsuhgx1iba95rkpcijw.jpeg" ]

					:if ($fDBGteInlineResponse = true) do={:put "teInlineResponse currentItem = $currentItem"; :log info "teInlineResponse currentItem = $currentItem"}

					:local separator ""; :if ([:len $terminalCommands] != 0) do={ :set separator "," }
					:set terminalCommands ($terminalCommands . $separator . $currentItem)

			} on-error={ :if ($fDBGteInlineResponse = true) do={:put "teInlineResponse $errorMessage"; :log info "teInlineResponse $errorMessage"} }

    }

		:if ($fDBGteInlineResponse = true) do={:log info "teInlineResponse paramOffset = $paramOffset"}
		:local resultQuery [$teBuilQueryResult fResults=$terminalCommands]
		:if ([$teAnswerInlineQuery fInlineQueryId=$queryID fNextOffset=$paramOffset fResults=$resultQuery fCacheTime=0 fIsPersonal=true] = 0) do={
			:set ($dbaseBotSettings->$userChatID->"terminalQueryOffset") ""
			:if ($fDBGteInlineResponse = true) do={:log info "teInlineResponse teAnswerInlineQuery return 0"}
			:return false
		}
		:return true
	}
	:return true

 }
}
