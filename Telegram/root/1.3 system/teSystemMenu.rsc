#---------------------------------------------------teSystemMenu--------------------------------------------------------------

#   Function sends or edits a message to the recipient.
#   Params for this function:

#   1.  fChatID   		-   Recipient id
#   2.  fMessageID 		-   Recipient message id (may be empty). if empty then the message will be sent, otherwise it will be edited
#   3.  fCheckUpdate 	-   true or false
#		4.	fQueryID
#		5.	fDownloadStatus

#   Function return 1 or 0

#   if the global variable fDBGteSystemMenu=true, then a debug event will be logged

#---------------------------------------------------teSystemMenu--------------------------------------------------------------

:global teSystemMenu
:if (!any $teSystemMenu) do={ :global teSystemMenu do={

		:global teDebugCheck
		:local fDBGteSystemMenu [$teDebugCheck fDebugVariableName="fDBGteSystemMenu"]

		:global dbaseVersion
		:local teSystemMenuVersion "2.4.8.22"
		:set ($dbaseVersion->"teSystemMenu") $teSystemMenuVersion

		:global dbaseBotSettings
		:local devicePicture ($dbaseBotSettings->"devicePicture")
		:local deviceName ("$devicePicture" . " " . ($dbaseBotSettings->"deviceName"))

		:global teSendPhoto
		:global teEditCaption
		:global teAnswerCallbackQuery
		:global teBuildKeyboard
		:global teBuildButton

		:global teRootMenu

		:global teGetDate
		:global teGetTime
		:local dateM [$teGetDate]
		:local timeM [$teGetTime]

		:local pictAnswerCallback "\E2\9D\97"
		:local answerMessage "$pictAnswerCallback No update available..."

		:local result []
		:set $fMessageID [:tonum $fMessageID]

		:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu building..."; :log info "teSystemMenu building..."}
		:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu fChatID = $fChatID"; :log info "teSystemMenu fChatID = $fChatID"}
		:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu fMessageID = $fMessageID"; :log info "teSystemMenu fMessageID = $fMessageID"}

		:local imageRootHeader "https://habrastorage.org/webt/sb/f6/kz/sbf6kz9v7lbjqz9rihx1hfmjska.jpeg"
    :local imageRoot "https://habrastorage.org/webt/kz/uh/xm/kzuhxmsrjq7mrzqin8aznrrhclw.jpeg"

		:local NB ","
		:local NL "\5D,\5B"

		:local oneFeed "%0D%0A"
		:local doubleFeed "%0D%0A%0D%0A"

		:local pictBackup "\F0\9F\97\84"
		:local buttonBackup [$teBuildButton fPictButton=$pictBackup fTextButton="  Backup on the disk" fTextCallBack="teCallbackSystemMenu,backup,true"]

		:local pictUpdate "\F0\9F\93\A6"
		:local buttonUpdate [$teBuildButton fPictButton=$pictUpdate fTextButton=" Download update" fTextCallBack="teCallbackSystemMenu,update,true"]
		:local buttonCheckUpdate [$teBuildButton fPictButton=$pictUpdate fTextButton="  Check for update" fTextCallBack="teCallbackSystemMenu,checkUpdate,true"]

		:local pictRefresh "\E2\99\BB"
		:local buttonRefresh [$teBuildButton fPictButton=$pictRefresh fTextButton="  Refresh info" fTextCallBack="teCallbackSystemMenu,refresh,true"]

		:local pictRestart "\E2\9D\97"
		:local buttonRestart [$teBuildButton fPictButton=$pictRestart fTextButton=" Restart for update" fTextCallBack="teCallbackSystemMenu,restart,request"]

		:local pictBackward "\E2\AC\85"
		:local buttonBackward [$teBuildButton fPictButton=$pictBackward fTextButton="   Back" fTextCallBack="teCallbackRootMenu,backward,teRootMenu"]

		:local checkUpdate []; :local installedVersion "0"; :local latestVersion "0"

		:local infoUpdate []

		:if ($fCheckUpdate = true) do={
			:set checkUpdate [/system package update check-for-updates as-value]
			:set installedVersion ($checkUpdate->"installed-version")
			:set latestVersion ($checkUpdate->"latest-version")

			:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu checkUpdate $installedVersion $latestVersion"; :log info "teSystemMenu checkUpdate $installedVersion $latestVersion"}

			:if ($installedVersion=$latestVersion) do={
				:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu checkUpdate $installedVersion $latestVersion"; :log info "teSystemMenu checkUpdate $installedVersion $latestVersion"}
				:set infoUpdate ("$doubleFeed" . "<b>Update:</b>\t\tnot available")
			}
		}

		:local boardName [:system resource get board-name]
		:local uptimeDevice [:system resource get uptime]
		:local currentVersion [:system resource get version]

		:local loadCPU [:system resource get cpu-load]
		:local freeMemory (([:system resource get free-memory]/1024)/1024)
		:local totalHddSpace (([:system resource get total-hdd-space]/1024)/1024)
		:local freeHddSpace (([:system resource get free-hdd-space]/1024)/1024)

		:local flashDiskSize []
		:local flashDiskFreeSize []
		:local infoFlashDisk []
		:local flashDisk [disk find]
		:if ([:len $flashDisk] != 0) do={
			:set flashDiskSize (([disk get [find] size]/1024)/1024)
			:set flashDiskFreeSize (([disk get [find] free]/1024)/1024)
			:set infoFlashDisk ("$doubleFeed" . "<b>Flash disk:</b>\t\t\t\t$flashDiskSize Mb;$oneFeed<b>Free space:</b>\t\t\t$flashDiskFreeSize Mb")
		}

		:local infoModel ("$doubleFeed" . "<b>Model:</b>\t\t\t\t\t\t\t$boardName")
		:local infoUpTime ("$oneFeed" . "<b>UpTime:</b>\t\t\t\t$uptimeDevice")
		:local infoVersion ("$oneFeed" . "<b>Version:</b>\t\t\t\t$currentVersion")
		:local infoUpdateAvailable ("$oneFeed" . "<b>Available</b>\t\t$latestVersion")

		:local infoLoadCPU ("$doubleFeed" . "<b>CPU-load: </b>\t\t\t\t$loadCPU %")
		:local infofreeMemory ("$oneFeed" . "<b>Free-Mem:</b>\t\t\t$freeMemory Mb")
		:local infoHddSpace ("$doubleFeed" . "<b>Total-HDD:</b>\t\t$totalHddSpace Mb" . "$oneFeed<b>Free-HDD:</b>\t\t\t\t$freeHddSpace Mb")

		:local line1 "$buttonBackup"
		:local line2 "$NL$buttonCheckUpdate"
		:if ($fDownloadStatus ~ "downloaded") do={ :set line2 "$NL$buttonRestart"	}
		:local line3 "$NL$buttonUpdate"
		:local line4 "$NL$buttonRefresh"
		:local line5 "$NL$buttonBackward"
		:local line ""

		:local currentInfo  []
		:if ($installedVersion ~ $latestVersion) do={
			:set currentInfo ($infoModel . $infoUpTime . $infoVersion . $infoLoadCPU . $infofreeMemory . $infoHddSpace . $infoFlashDisk . $infoUpdate)
			:set line "$line1$line2$line4$line5"
		} else={
			:set currentInfo ($infoModel . $infoUpTime . $infoVersion . $infoUpdateAvailable . $infoLoadCPU . $infofreeMemory . $infoHddSpace . $infoFlashDisk . $infoUpdate)
			:set line "$line1$line3$line4$line5"
		}

		:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$line fReplyKeyboard=false]

		:local footerText ("$doubleFeed" . "<b>Updated </b> $dateM $timeM")
		:local sendText ("<b>$deviceName</b>$oneFeed-------------------------$oneFeed" . "root - <b>system</b>$currentInfo" . "$footerText")

		:if ($fMessageID > 0) do={
			:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu fMessageID = $fMessageID"; :log info "teSystemMenu fMessageID = $fMessageID"}

			:if ([$teEditCaption fChatID=$fChatID fMessageID=$fMessageID fText=$sendText fReplyMarkup=$replyMarkup] > 0) do={
				:set result 1
				:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu Command Edit - OK"; :log info "teSystemMenu Commands Edit - OK"}
			} else={
					:set result 0
					:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu Command Edit - ERROR"; :log info "teSystemMenu Commands Edit - ERROR"}
			}
		} else={
			:if ([$teSendPhoto fChatID=$fChatID fPhoto=$imageRootHeader fText="" fReplyMarkup=""] > 0) do={
				$teSendPhoto fChatID=$fChatID fPhoto=$imageRoot fText=$sendText fReplyMarkup=$replyMarkup
				:set result 1
				:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu Command Send - OK"; :log info "teSystemMenu Commands Send - OK"}
			} else={
					:set result 0
					:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu Command Send - ERROR"; :log info "teSystemMenu Commands Send - ERROR"}
			}
		}

		:if ($fDBGteSystemMenu = true) do={:put "teSystemMenu = $result"; :log info "teSystemMenu = $result"}

		:return $result
		}
	}
