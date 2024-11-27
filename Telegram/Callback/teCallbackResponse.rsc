#---------------------------------------------------teCallbackResponse --------------------------------------------------------------

#		fCallback		-		current callback from Telegram

#   if the global variable fDBGteCallbackResponse=true, then a debug event will be logged

#---------------------------------------------------teCallbackResponse--------------------------------------------------------------

:global teCallbackResponse
:if (!any $teCallbackResponse) do={ :global teCallbackResponse do={

	:global dbaseVersion
	:local teCallbackResponseVersion "2.9.7.22"
	:set ($dbaseVersion->"teCallbackResponse") $teCallbackResponseVersion

	:global teDebugCheck
	:global teAnswerCallbackQuery

	:local fDBGteCallbackResponse [$teDebugCheck fDebugVariableName="fDBGteCallbackResponse"]

	:local queryChatID [:tostr ($fCallback->"callback_query"->"message"->"chat"->"id")]
	:local userChatID [:tostr ($fCallback->"callback_query"->"from"->"id")]
	:local userName [:tostr ($fCallback->"callback_query"->"from"->"username")]
	:local userFirstName [:tostr ($fCallback->"callback_query"->"from"->"first_name")]
	:local userLang [:tostr ($fCallback->"callback_query"->"from"->"language_code")]
	:local messageID ($fCallback->"callback_query"->"message"->"message_id")
	:local queryData ($fCallback->"callback_query"->"data")
	:local queryID ($fCallback->"callback_query"->"id")
	:local messageText ($fCallback->"callback_query"->"message"->"text")

	:local messageIP [:pick $messageText [find $messageText "IP - "] [:len $messageText]]
	:set messageIP [:pick $messageIP ([find $messageIP "IP - "] +5) [find $messageIP ";"]]
	:set messageIP [:toip $messageIP]
	:if ([:len $messageIP] = 0) do={ :set messageIP 0 }

	:if ($fDBGteCallbackResponse = true) do={:log info "teCallbackResponse userName = $userName"}

	:set queryData [:toarray $queryData]

	:if ($fDBGteCallbackResponse = true) do={
		:put $queryData; :log info $queryData
		:foreach i in=$queryData do={:put "$i - type of item:$([:typeof $i])"; :log info "$i - type of item:$([:typeof $i])"}
	}

	:local calledFunctionName ($queryData->0)
	:local commandName ($queryData->1)
	:local commandValue ($queryData->2)

	:if ([:len [system script find name=$calledFunctionName]] = 0) do={
		:return false
	}

	:if ([:len $userName] = 0) do={
			:set userName $userFirstName
	}

	:if ([:len $userFirstName] = 0) do={
			:set userName "noName"
	}

	:local result []
	:if ([:len $commandValue] = 0) do={
		:set result "[[:parse [system script get $calledFunctionName source]] queryID=$queryID queryChatID=$queryChatID userChatID=$userChatID userName=$userName userLang=$userLang messageID=$messageID messageIP=$messageIP commandName=$commandName]"
	} else={
		:set result "[[:parse [system script get $calledFunctionName source]] queryID=$queryID queryChatID=$queryChatID userChatID=$userChatID userName=$userName userLang=$userLang messageID=$messageID messageIP=$messageIP commandName=$commandName commandValue=$commandValue]"
	}
	:execute script=$result
	:if ($fDBGteCallbackResponse = true) do={:log info "teCallbackResponse result = $result"}

	:set $result true
	:return $result
 }
}
