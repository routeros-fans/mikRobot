#---------------------------------------------------teScripts--------------------------------------------------------------

#   Function sends or edits a message to the recipient.
#   Params for this function:

#   1.  fChatID   		      -   Recipient id
#   2.  fMessageID 		      -   Recipient message id (may be empty). if empty then the message will be sent, otherwise it will be edited
#   2.  fCallbackMsg 				-   the result of the script
#   2.  fCalledScript 			-   name of called script

#   Function return 1 or 0

#   if the global variable fDBGteScripts=true, then a debug event will be logged

#---------------------------------------------------teScripts--------------------------------------------------------------

:global teScripts
:if (!any $teScripts) do={ :global teScripts do={

		:global teDebugCheck
		:local fDBGteScripts [$teDebugCheck fDebugVariableName="fDBGteScripts"]

		:global dbaseVersion
		:local teScriptsVersion "2.9.7.22"
		:set ($dbaseVersion->"teScripts") $teScriptsVersion

		:global dbaseBotSettings
		:local devicePicture ($dbaseBotSettings->"devicePicture")
		:local deviceName ("$devicePicture" . " " . ($dbaseBotSettings->"deviceName"))

		:global teSendPhoto
		:global teEditCaption
		:global teBuildKeyboard
		:global teBuildButton

    :global teRootMenu

    :global teGetDate
    :global teGetTime
    :local dateM [$teGetDate]
    :local timeM [$teGetTime]

    :local result []
		:set $fMessageID [:tonum $fMessageID]

		:if ($fDBGteScripts = true) do={:put "teScripts building..."; :log info "teScripts building..."}
		:if ($fDBGteScripts = true) do={:put "teScripts fChatID = $fChatID"; :log info "teScripts fChatID = $fChatID"}
		:if ($fDBGteScripts = true) do={:put "teScripts fMessageID = $fMessageID"; :log info "teScripts fMessageID = $fMessageID"}

		:local imageRootHeader "https://habrastorage.org/webt/sb/f6/kz/sbf6kz9v7lbjqz9rihx1hfmjska.jpeg"
    :local imageRoot "https://habrastorage.org/webt/kz/uh/xm/kzuhxmsrjq7mrzqin8aznrrhclw.jpeg"

		:local NB ","
		:local NL "\5D,\5B"

		:local oneFeed "%0D%0A"
		:local doubleFeed "%0D%0A%0D%0A"

		:local pictScript "\F0\9F\93\9D "

    :local pictBackward "\E2\AC\85"
		:local buttonBackward [$teBuildButton fPictButton=$pictBackward fTextButton="   Back" fTextCallBack="teCallbackRootMenu,backward,teRootMenu"]

    :local allButtonsScripts []
    :local scriptsArray [/system script print as-value brief where name~"isBot"]
    :foreach i in=$scriptsArray do={
      :local scriptName ($i->"name")
      :set scriptName [:pick $scriptName 5 [:len $scriptName]]
      :local textCallBack "teCallbackScripts,$scriptName,request"
      :local buttonScript [$teBuildButton fPictButton=$pictScript fTextButton=$scriptName fTextCallBack=$textCallBack]
      :set allButtonsScripts "$buttonScript$NL$allButtonsScripts"
    }
    :local replyButtons "$allButtonsScripts$NL$buttonBackward"

		:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$replyButtons fReplyKeyboard=false]

    :local currentInfo []
    :local allScriptsCount [/system script print count-only as-value]
    :local allScriptsCountInfo ("$doubleFeed" . "<b>All scripts count:</b>\t\t\t\t$allScriptsCount")

    :local scriptsCount [/system script print count-only as-value where name~"isBot"]
    :local scriptsCountInfo ("$oneFeed" . "<b>Scripts presented:</b>\t\t$scriptsCount")

    :set currentInfo ($allScriptsCountInfo . $scriptsCountInfo)

    :local callBackMessage []
    :local calledScript []
    :if ([:len $fCallbackMsg] != 0) do={
      :set calledScript ("$doubleFeed" . "<b>Called scritp:</b>" . "$oneFeed<code>$fCalledScript</code>")
      :set callBackMessage ("$doubleFeed" . "<b>Result:</b>" . "$oneFeed<code>$fCallbackMsg</code>")
    }

    :local footerText ("$doubleFeed" . "<b>Updated </b> $dateM $timeM")
    :local sendText ("<b>$deviceName</b>$oneFeed-------------------------$oneFeed" . "root - <b>scripts</b>$currentInfo" . "$calledScript" . "$callBackMessage" . "$footerText")

		:if ($fMessageID > 0) do={

			:if ([$teEditCaption fChatID=$fChatID fMessageID=$fMessageID fText=$sendText fReplyMarkup=$replyMarkup] > 0) do={
				:set result 1
				:if ($fDBGteScripts = true) do={:put "teScripts Command Edit - OK"; :log info "teScripts Commands Edit - OK"}
			} else={
					:set result 0
					:if ($fDBGteScripts = true) do={:put "teScripts Command Edit - ERROR"; :log info "teScripts Commands Edit - ERROR"}
			}
		} else={
			:if ([$teSendPhoto fChatID=$fChatID fPhoto=$imageRootHeader fText="" fReplyMarkup=""] > 0) do={
				$teSendPhoto fChatID=$fChatID fPhoto=$imageRoot fText=$sendText fReplyMarkup=$replyMarkup
				:set result 1
				:if ($fDBGteScripts = true) do={:put "teScripts Command Send - OK"; :log info "teScripts Commands Send - OK"}
			} else={
					:set result 0
					:if ($fDBGteScripts = true) do={:put "teScripts Command Send - ERROR"; :log info "teScripts Commands Send - ERROR"}
			}
		}

		:if ($fDBGteScripts = true) do={:put "teScripts = $result"; :log info "teScripts = $result"}

		:return $result
		}
	}
