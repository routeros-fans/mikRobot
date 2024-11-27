#---------------------------------------------------teTerminal--------------------------------------------------------------

#   Function sends or edits a message to the recipient.
#   Params for this function:

#   1.  fChatID   		      -   Recipient id
#   2.  fMessageID 		      -   Recipient message id (may be empty). if empty then the message will be sent, otherwise it will be edited
#   2.  fCallbackMsg 				-   name of the running script
#   2.  fCommandInfo 				-   name of the running script

#   Function return 1 or 0

#   if the global variable fDBGteTerminal=true, then a debug event will be logged

#---------------------------------------------------teTerminal--------------------------------------------------------------

:global teTerminal
:if (!any $teTerminal) do={ :global teTerminal do={

		:global teDebugCheck
		:local fDBGteTerminal [$teDebugCheck fDebugVariableName="fDBGteTerminal"]

		:global dbaseVersion
		:local teTerminalVersion "2.07.9.22"
		:set ($dbaseVersion->"teTerminal") $teTerminalVersion

		:global dbaseCommands

		:global dbaseBotSettings
		:local devicePicture ($dbaseBotSettings->"devicePicture")
		:local deviceName ("$devicePicture" . " " . ($dbaseBotSettings->"deviceName"))

		:global teSendPhoto
		:global teEditCaption
		:global teBuildKeyboard
		:global teBuildButton

    :global teGetDate
    :global teGetTime
    :local dateM [$teGetDate]
    :local timeM [$teGetTime]

    :local result []
		:set $fMessageID [:tonum $fMessageID]

		:if ($fDBGteTerminal = true) do={:put "teTerminal building..."; :log info "teTerminal building..."}
		:if ($fDBGteTerminal = true) do={:put "teTerminal fChatID = $fChatID"; :log info "teTerminal fChatID = $fChatID"}
		:if ($fDBGteTerminal = true) do={:put "teTerminal fMessageID = $fMessageID"; :log info "teTerminal fMessageID = $fMessageID"}

		:local imageRootHeader "https://habrastorage.org/webt/sb/f6/kz/sbf6kz9v7lbjqz9rihx1hfmjska.jpeg"
    :local imageRoot "https://habrastorage.org/webt/kz/uh/xm/kzuhxmsrjq7mrzqin8aznrrhclw.jpeg"

		:local NB ","
		:local NL "\5D,\5B"

		:local oneFeed "%0D%0A"
		:local doubleFeed "%0D%0A%0D%0A"

		:local pictTerminal "\F0\9F\95\B6  "
    :local pictBackward "\E2\AC\85"
		:local buttonBackward [$teBuildButton fPictButton=$pictBackward fTextButton="   Back" fTextCallBack="teCallbackRootMenu,backward,teRootMenu"]

    :local allButtonsCommands []
		:local switchCurrentChatValue []
		:local buttonCommand []
		:local counterButton 0
		:local counter 1
		:local errorMessage []
    :foreach k,v in=$dbaseCommands do={
			:do {
				:if ($k = 0) do={ :set errorMessage "skip $v"; :error }
				:if ([:typeof $k] = "num") do={ :set errorMessage "skip Inline button"; :error }

				:local buttonText [:tostr $k]
				:set switchCurrentChatValue [:tostr $v]
				:if ($buttonText = "my cmd") do={ :set pictTerminal "\F0\9F\98\8E  "} else={:set pictTerminal "\F0\9F\95\B6  "}
				:set buttonCommand [$teBuildButton fPictButton=$pictTerminal fTextButton=$buttonText fSwitchCurrentChat=$switchCurrentChatValue]

				:if ($counterButton = 1) do={
					:if ([:len $allButtonsCommands] = 0) do={
						:set allButtonsCommands "$buttonCommand$NB"
						} else={ :set allButtonsCommands "$allButtonsCommands$NB$buttonCommand$NB" }
					}
					:if ($counterButton = 2) do={ :set allButtonsCommands "$allButtonsCommands$buttonCommand$NL" }
					:if ($counterButton = 3) do={
						:if ($counter != [:len $dbaseCommands]) do={
							:set allButtonsCommands "$allButtonsCommands$buttonCommand$NB"
							:set counterButton 1
							} else={ :set allButtonsCommands "$allButtonsCommands$buttonCommand" }
						}
			} on-error={ :if ($fDBGteTerminal = true) do={:put "teTerminal $errorMessage"; :log info "teTerminal $errorMessage"} }

			:set counter ($counter + 1)
			:set counterButton ($counterButton + 1)
    }

    :local replyButtons "$allButtonsCommands$NL$buttonBackward"
		:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$replyButtons fReplyKeyboard=false]

		:local commandInfo []
		:if ([:len $fCommandInfo] != 0) do={
			:set commandInfo ("$doubleFeed" . "<b>Command:$oneFeed</b><code>$fCommandInfo</code>")
		}

		:local callBackMessage []
		:if ([:len $fCallbackMsg] != 0) do={
			:set callBackMessage ("$doubleFeed" . "<b>Result:$oneFeed</b><code>$fCallbackMsg</code>")
		}

    :local footerText ("$doubleFeed" . "<b>Updated </b> $dateM $timeM")
    :local sendText ("<b>$deviceName</b>$oneFeed-------------------------$oneFeed" . "root - <b>terminal</b>" . "$commandInfo" . "$callBackMessage" . "$footerText")

		:if ($fDBGteTerminal = true) do={:put "teTerminal sendText = $sendText"; :log info "teTerminal sendText = $sendText"}

		:if ($fMessageID > 0) do={

			:if ([$teEditCaption fChatID=$fChatID fMessageID=$fMessageID fText=$sendText fReplyMarkup=$replyMarkup] > 0) do={
				:set result 1
				:if ($fDBGteTerminal = true) do={:put "teTerminal Command Edit - OK"; :log info "teTerminal Commands Edit - OK"}
			} else={
				:set result 0
				:if ($fDBGteTerminal = true) do={:put "teTerminal Command Edit - ERROR"; :log info "teTerminal Commands Edit - ERROR"}
			}
		} else={
			:if ([$teSendPhoto fChatID=$fChatID fPhoto=$imageRootHeader fText="" fReplyMarkup=""] > 0) do={
				$teSendPhoto fChatID=$fChatID fPhoto=$imageRoot fText=$sendText fReplyMarkup=$replyMarkup
				:set result 1
				:if ($fDBGteTerminal = true) do={:put "teTerminal Command Send - OK"; :log info "teTerminal Commands Send - OK"}
			} else={
					:set result 0
					:if ($fDBGteTerminal = true) do={:put "teTerminal Command Send - ERROR"; :log info "teTerminal Commands Send - ERROR"}
			}
		}

		:if ($fDBGteTerminal = true) do={:put "teTerminal = $result"; :log info "teTerminal = $result"}

		:return $result
		}
	}
