#---------------------------------------------------teLeaseCard--------------------------------------------------------------

#   The script creates a device card in the Telegram.

#   Params for this function:
#   1. fLeaseHostname   -   name from dhcp lease
#   2. fLeaseServerName -   dhcp server name
#   3. fLeaseActIP      -   active IP address from dhcp lease
#   4. fLeaseActMAC     -   active mac address from dhcp lease
#   5. fLeaseStatus     -   status from dhcp lease
#   6. fLeaseLastSeen   -   last appearance on the net from dhcp lease
#   7. fMessageID       -   ID message
#   7. fChatID          -   chat ID
#   7. fQueryID         -   query ID
#   8. isBlocked        -   if device is blocked - true, else - false
#   9. leaseParams      -   if button "Params" pressed - true, else - false
#   10. leaseRateShow    -   if button "Rate" pressed - true, else - false
#   11. leaseNote        -   description for the card
#   12. pingCount        -   description for the card
#   13. leaseInfo       -   if button "Info" pressed - true, else - false
#   14. fClientMode     -   If the client is static - true, otherwise - false

#   Function return message ID if message sending, 1 if message edited and 0 if error

#   if the global variable fDBGteLeaseCard=true, then a debug event will be logged

#---------------------------------------------------teLeaseCard--------------------------------------------------------------

:global teLeaseCard
:if (!any $teLeaseCard) do={ :global teLeaseCard do={

    :global teDebugCheck
    :local fDBGteLeaseCard [$teDebugCheck fDebugVariableName="fDBGteLeaseCard"]

    :global dbaseVersion
    :local teLeaseCardVersion "2.30.7.22"
    :set ($dbaseVersion->"teLeaseCard") $teLeaseCardVersion

    :global dbaseBotSettings
  	:local ifaceGroup ($dbaseBotSettings->"ifaceGroup")
    :local devicePicture ($dbaseBotSettings->"devicePicture")
    :local deviceName ("$devicePicture " . ($dbaseBotSettings->"deviceName"))
    :local defaultPingCount []
    :if ([:len $defaultPingCount] = 0) do={
      :set defaultPingCount ($dbaseBotSettings->"defaultPingCount")
    } else={ :set $defaultPingCount 0 }

    :global teLease
    :global teAnswerCallbackQuery
    :global teSendMessage
    :global teSendPhoto
    :global teEditMessage
    :global teBuildKeyboard
    :global teBuildButton

    :global teGetDate; :local dateM [$teGetDate]
    :global teGetTime; :local timeM [$teGetTime]

    :local currentPict []
    :local currentInfoButton []
    :local newPict "\E2\9D\97"
    :local pictAnswerCallback "\E2\9D\97"

    :local headerText []
    :local bodyText []
    :local footerText []
    :local infoText []
    :local sendText []
    :local oneFeed "%0D%0A"
    :local doubleFeed "%0D%0A%0D%0A"

    :local NB ","; :local NL "\5D,\5B"
    :local lineButtons []
    :local replyMarkup []

    :local currentBlockAccess []
    :local currentRateLimit []
    :local currentLeaseTime []

    :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard is start building..."; :log info "teLeaseCard is start building"}

    :if ([:len [/ip dhcp-server lease find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP]] = 0) do={
      :local errorMessage "$pictAnswerCallback DHCP Lease not found, wating..."
      $teAnswerCallbackQuery fQueryID=$queryID fAnswerText=$errorMessage fAlert=true
      :return [$teLease leaseBound=0 leaseActMAC=$fLeaseActMAC leaseActIP=$fLeaseActIP]
    }

    :local pictDeny "\E2\9B\94"
    :local buttonDenyCallBackText "teCallbackLeaseCard,isBlocked,true"
    :local buttonDeny [$teBuildButton fPictButton=$pictDeny fTextButton="  Deny" fTextCallBack=$buttonDenyCallBackText]

    :local pictAllow "\E2\9C\85"
    :local buttonAllowCallBackText "teCallbackLeaseCard,isBlocked,false"
    :local buttonAllow [$teBuildButton fPictButton=$pictAllow fTextButton="  Allow" fTextCallBack=$buttonAllowCallBackText]

    :local pictInfOpen "\F0\9F\94\BD"
    :local buttonInfOpenCallBackText "teCallbackLeaseCard,leaseInfo,true"
    :local buttonInfOpen [$teBuildButton fPictButton=$pictInfOpen fTextButton=" Info" fTextCallBack=$buttonInfOpenCallBackText]

    :local pictInfClose "\F0\9F\94\BC"
    :local buttonInfCloseCallBackText "teCallbackLeaseCard,leaseInfo,false"
    :local buttonInfClose [$teBuildButton fPictButton=$pictInfClose fTextButton="  Info" fTextCallBack=$buttonInfCloseCallBackText]

    :local pictDelete "\F0\9F\97\91"
    :local buttonDeleteCallBackText "teCallbackLeaseCard,delete,request"
    :local buttonDelete [$teBuildButton fPictButton=$pictDelete fTextButton="  Del" fTextCallBack=$buttonDeleteCallBackText]

    :local pictStatic "\F0\9F\93\8C"
    :local buttonStaticCallBackText "teCallbackLeaseCard,static,request"
    :local buttonStatic [$teBuildButton fPictButton=$pictStatic fTextButton=" Static" fTextCallBack=$buttonStaticCallBackText]

    :local pictParamsOpen "\E2\9A\99"
    :local buttonParamsOpenCallBackText "teCallbackLeaseCard,params,true"
    :local buttonParamsOpen [$teBuildButton fPictButton=$pictParamsOpen fTextButton=" Params" fTextCallBack=$buttonParamsOpenCallBackText]

    :local pictParamsClose "\E2\97\80 \E2\9A\99"
    :local buttonParamsCloseCallBackText "teCallbackLeaseCard,params,false"
    :local buttonParamsClose [$teBuildButton fPictButton=$pictParamsClose fTextButton=" " fTextCallBack=$buttonParamsCloseCallBackText]

    :local pictPing "\F0\9F\94\AD"
    :local buttonPingCallBackText "teCallbackLeaseCard,ping,$defaultPingCount"
    :local buttonPing [$teBuildButton fPictButton=$pictPing fTextButton="  Ping" fTextCallBack=$buttonPingCallBackText]

    :local pictNote "\F0\9F\97\93"
    :local switchCurrentChatValue "ID=$fMessageID,leaseNote=$leaseNote"
    :local buttonNote [$teBuildButton fPictButton=$pictNote fTextButton=" " fSwitchCurrentChat=$switchCurrentChatValue]

    :local pictHeaderStatus ""

    :local leaseDinamic [/ip dhcp-server lease find mac-address=$fLeaseActMAC and !disabled and dynamic and address=$fLeaseActIP]
    :if ([:len $leaseDinamic] = 0) do={
      :set leaseDinamic false
    } else={:set leaseDinamic true}
    :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard leaseDinamic = $leaseDinamic"; :log info "teLeaseCard leaseDinamic = $leaseDinamic"}

    :local headerStatus ""
    :if ($leaseDinamic=true) do={
      :set currentInfoButton "$buttonStatic$NB$buttonDelete$NB$buttonPing$NL$buttonInfClose"
      :set headerStatus "<b> D: </b>"
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard currentInfoButton = $currentInfoButton"; :log info "teLeaseCard currentInfoButton = $currentInfoButton"}
    }

    :local ifaceInfo []
    :local currentIfaceName []
    :local ifaceMessageID []
    :local interfacesLink []

    :local leaseIfaceArp [/ip arp find mac-address=$fLeaseActMAC and address=$fLeaseActIP and !disabled]
    :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard leaseIfaceArp = $leaseIfaceArp"; :log info "teLeaseCard leaseIfaceArp = $leaseIfaceArp"}

    :if ([:len $leaseIfaceArp] != 0) do={
      :set leaseIfaceArp [/ip arp get $leaseIfaceArp interface]
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard leaseIfaceArp = $leaseIfaceArp"; :log info "teLeaseCard leaseIfaceArp = $leaseIfaceArp"}

      :set ifaceMessageID ([:toarray [/interface get [find name=$leaseIfaceArp] comment]]->2)
      :set ifaceMessageID [:pick $ifaceMessageID 4 [:len $ifaceMessageID]]
      :set interfacesLink [:pick $ifaceGroup 4 [:len $ifaceGroup]]
      :set currentIfaceName "<a href=\"https://t.me/c/$interfacesLink/$ifaceMessageID\">$leaseIfaceArp</a>"
      :set ifaceInfo ("$oneFeed" . "Iface - $currentIfaceName;")
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard leaseIfaceArp = $leaseIfaceArp"; :log info "teLeaseCard leaseIfaceArp = $leaseIfaceArp"}
    }

    :local leaseIfaceBrige [/interface bridge host find mac-address=$fLeaseActMAC and !disabled]
    :if ([:len $leaseIfaceBrige] != 0) do={
      :set leaseIfaceBrige [/interface bridge host get [find mac-address=$fLeaseActMAC and !disabled] on-interface]
      :set ifaceMessageID ([:toarray [/interface get [find name=$leaseIfaceBrige] comment]]->2)
      :set ifaceMessageID [:pick $ifaceMessageID 4 [:len $ifaceMessageID]]
      :set interfacesLink [:pick $ifaceGroup 4 [:len $ifaceGroup]]
      :set currentIfaceName "<a href=\"https://t.me/c/$interfacesLink/$ifaceMessageID\">$leaseIfaceBrige</a>"
      :set ifaceInfo ("$oneFeed" . "Iface - $currentIfaceName;")
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard leaseIfaceBrige = $leaseIfaceBrige"; :log info "teLeaseCard leaseIfaceBrige = $leaseIfaceBrige"}
    }


    :if ($leaseInfo=true) do={
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard leaseInfo = $leaseInfo"; :log info "teLeaseCard leaseInfo = $leaseInfo"}

      :set $fLeaseServerName [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] server]
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard fLeaseServerName = $fLeaseServerName"; :log info "teLeaseCard fLeaseServerName = $fLeaseServerName"}

      :set $fLeaseStatus [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] status]
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard fLeaseStatus = $fLeaseStatus"; :log info "teLeaseCard fLeaseStatus = $fLeaseSefLeaseStatusrverName"}

      :set $fLeaseLastSeen [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] last-seen]
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard fLeaseLastSeen = $fLeaseLastSeen"; :log info "teLeaseCard fLeaseLastSeen = $fLeaseLastSeen"}

      :local currentArpStatus [/ip arp find mac-address=$fLeaseActMAC and address=$fLeaseActIP and !disabled complete]
      :if ([:len $currentArpStatus] = 0) do={
        :set $fLeaseStatus ("$fLeaseStatus, " . "<i>offline</i>")
      } else={:set $fLeaseStatus ("$fLeaseStatus, " . "<b>online</b>")}

      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard currentArpStatus = $currentArpStatus"; :log info "teLeaseCard currentArpStatus = $currentArpStatus"}

      :local addressListInfo []
      :local rateLimitInfo []
      :local leaseTimeInfo []
      :local blockAccessInfo []
      :local currentFeed []

      :if ($leaseDinamic=false) do={

        :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard leaseDinamic = $leaseDinamic"; :log info "teLeaseCard leaseDinamic = $leaseDinamic"}

        :local addressLists [:toarray ""]
        :set addressLists [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] address-lists]
        :if ([:len [:tostr $addressLists]] != 0) do={
          :set addressLists [:tostr $addressLists]
          :set addressListInfo ("$oneFeed" . "Address lists - <i>$addressLists</i>;")
          :set currentFeed "$oneFeed"
        } else={ :set addressLists ""}
        :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard addressLists = $addressLists"; :log info "teLeaseCard addressLists = $addressLists"}

        :set currentBlockAccess [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] block-access]
        :if ([:len $currentBlockAccess] != 0) do={
          :set blockAccessInfo ("$oneFeed"."Block Access  - <b>$currentBlockAccess</b>;")
          :set currentFeed "$oneFeed"
          :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard currentBlockAccess = $currentBlockAccess"; :log info "teLeaseCard currentBlockAccess = $currentBlockAccess"}
        }

        :set currentLeaseTime [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] lease-time]
        :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard currentLeaseTime = $currentLeaseTime"; :log info "teLeaseCard currentLeaseTime = $currentLeaseTime"}

        :if ([:len $currentLeaseTime] != 0) do={
          :set leaseTimeInfo ("$oneFeed"."Lease time  - <b>$currentLeaseTime</b>;")
          :set currentFeed "$oneFeed"
        }

        :set currentRateLimit [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] rate-limit]
        :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard currentRateLimit = $currentRateLimit"; :log info "teLeaseCard currentRateLimit = $currentRateLimit"}

        :if ([:len $currentRateLimit] != 0) do={
          :set rateLimitInfo ("$oneFeed"."Rate limit (up/down)  - <b>$currentRateLimit</b>;")
          :set currentFeed "$oneFeed"
        }

        :if ($leaseParams=true) do={
          :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard leaseParams = $leaseParams"; :log info "teLeaseCard leaseParams = $leaseParams"}

          :local pictRateYes "\F0\9F\9A\A6"
          :local pictRateNo "\F0\9F\9A\A5"

          :local buttonRateUnPressed ""
          :local buttonRateUnPressedCallBackText "teCallbackLeaseCard,rate,false"

          :local buttonRatePressed ""
          :local switchCurrentChatValue ""
          :local buttonRatePressedCallBackText "teCallbackLeaseCard,rate,true"

          :set currentInfoButton "$buttonNote$NL$buttonDelete$NB$buttonPing$NB$buttonParamsClose$NL$buttonInfClose"
          :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard currentInfoButton = $currentInfoButton"; :log info "teLeaseCard currentInfoButton = $currentInfoButton"}


          :if ([:len $currentRateLimit] != 0) do={
            :set switchCurrentChatValue "ID=$fMessageID,leaseRate=$currentRateLimit"
            :local buttonRatePressed [$teBuildButton fPictButton=$pictRateYes fTextButton=" " fSwitchCurrentChat=$switchCurrentChatValue]
            :set currentInfoButton ("$buttonRatePressed$NB" . "$currentInfoButton")
          }

          :if ([:len $currentRateLimit] = 0) do={
            :set switchCurrentChatValue "ID=$fMessageID,leaseRate=5M/5M"
            :local buttonRatePressed [$teBuildButton fPictButton=$pictRateNo fTextButton=" " fSwitchCurrentChat=$switchCurrentChatValue]
            :set currentInfoButton ("$buttonRatePressed$NB" . "$currentInfoButton")
          }

          :if ($currentBlockAccess = true) do={:set switchCurrentChatValue "ID=$fMessageID,leaseBlock=no"}
          :if ([:len $currentBlockAccess] = 0) do={:set switchCurrentChatValue "ID=$fMessageID,leaseBlock=yes"}
          :local pictBlock "\F0\9F\93\B5"
          :local buttonBlockAccess [$teBuildButton fPictButton=$pictBlock fTextButton=" " fSwitchCurrentChat=$switchCurrentChatValue]
          :set currentInfoButton ("$buttonBlockAccess$NB" . "$currentInfoButton")

          :local defaultLeaseTime (00:05:00)
          :if ([:typeof $currentLeaseTime] = nil) do={:set switchCurrentChatValue "ID=$fMessageID,leaseTime=$defaultLeaseTime"}
          :if ([:typeof $currentLeaseTime] != nil) do={:set switchCurrentChatValue "ID=$fMessageID,leaseTime=$currentLeaseTime"}
          :local pictTime "\E2\8C\9A"
          :local buttonTime [$teBuildButton fPictButton=$pictTime fTextButton=" " fSwitchCurrentChat=$switchCurrentChatValue]
          :set currentInfoButton ("$buttonTime$NB" . "$currentInfoButton")
        }

        :if ($leaseParams=false) do={:set currentInfoButton "$buttonParamsOpen$NL$buttonInfClose"}
      }

      :set infoText ("$oneFeed" . "SRV - $fLeaseServerName;$oneFeed" . "Last seen - $fLeaseLastSeen;$oneFeed" . "Status - $fLeaseStatus;$oneFeed"  . "$blockAccessInfo" . "$leaseTimeInfo" . "$addressListInfo" . "$rateLimitInfo$oneFeed" . "$currentFeed")
      :if ($fDBGteLeaseCard = true) do={:put " leaseInfo - $leaseInfo"; :log info "leaseInfo - $leaseInfo"}
    } else={
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard leaseInfo = $leaseInfo"; :log info "teLeaseCard leaseInfo = $leaseInfo"}

      :set currentBlockAccess [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] block-access]
      :if ([:len $currentBlockAccess] != 0) do={
       :set pictHeaderStatus " \F0\9F\93\B5 "
      }
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard currentBlockAccess = $currentBlockAccess"; :log info "teLeaseCard currentBlockAccess = $currentBlockAccess"}

      :set currentRateLimit [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] rate-limit]
      :if ([:len $currentRateLimit] != 0) do={
        :set pictHeaderStatus ($pictHeaderStatus . "\F0\9F\9A\A6")
      }
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard currentRateLimit = $currentRateLimit"; :log info "teLeaseCard currentRateLimit = $currentRateLimit"}

      :set currentLeaseTime [/ip dhcp-server lease get [find mac-address=$fLeaseActMAC and !disabled and address=$fLeaseActIP] lease-time]
      :if ([:len $currentLeaseTime] != 0) do={
        :set pictHeaderStatus ($pictHeaderStatus . "\E2\8C\9A")
      }
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard currentLeaseTime = $currentLeaseTime"; :log info "teLeaseCard currentLeaseTime = $currentLeaseTime"}

      :set infoText "$oneFeed"
      :set currentInfoButton $buttonInfOpen
      :if ($fDBGteLeaseCard = true) do={:put " leaseInfo - $leaseInfo"; :log info "leaseInfo - $leaseInfo"}
    }

    :if ($isBlocked=true) do={
      :set currentPict $pictDeny
      :set lineButtons "$currentInfoButton$NB$buttonAllow"
      :if ($fDBGteLeaseCard = true) do={:put " isBlocked - $isBlocked"; :log info "isBlocked - $isBlocked"}
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard isBlocked=$isBlocked lineButtons = $lineButtons"; :log info "teLeaseCard isBlocked=$isBlocked lineButtons = $lineButtons"}

    }
    :if ($isBlocked=false) do={
      :set currentPict $pictAllow
      :set lineButtons "$currentInfoButton$NB$buttonDeny"
      :if ($fDBGteLeaseCard = true) do={:put " isBlocked - $isBlocked"; :log info "isBlocked - $isBlocked"}
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard isBlocked=$isBlocked lineButtons = $lineButtons"; :log info "teLeaseCard isBlocked=$isBlocked lineButtons = $lineButtons"}
    }

    :local leaseNoteText ""
    :if ($leaseNote != false) do={:set leaseNoteText ("$oneFeed" . "Note: <b>$leaseNote</b>")}

    :local pingCountText ""
    :if ($pingCount != 0) do={:set pingCountText "Ping status:\t<b>OK $pingCount/$defaultPingCount</b>$doubleFeed"}
    :if ($pingCount = 0) do={:set pingCountText "Ping status:\t<b>no ping $pingCount/$defaultPingCount</b>$doubleFeed"}
    :if ([:len $pingCount] = 0) do={:set pingCountText ""}

    :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard lineButtons - $lineButtons"; :log info "teLeaseCard lineButtons - $lineButtons"}

    :set replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]

    :set $fMessageID [:tonum $fMessageID]
    :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard fMessageID - $fMessageID"; :log info "teLeaseCard fMessageID - $fMessageID"}

    :set headerText "$currentPict$pictHeaderStatus$headerStatus  <b>$deviceName</b> $oneFeed----------------------------------------------------$doubleFeed"

    :if ($fMessageID > 0) do={
      :set bodyText ("Device: <b>$fLeaseHostname</b> is reconnected$leaseNoteText" . "$doubleFeed" . "MAC - <code>$fLeaseActMAC</code>;$oneFeed" . "IP - <code>$fLeaseActIP</code>;$ifaceInfo$oneFeed$infoText")
      :set footerText "$pingCountText<b>Updated </b> $dateM $timeM"
      :set sendText "$headerText$bodyText$footerText"

      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard Editing fMessageID - $fMessageID"; :log info "teLeaseCard Editing fMessageID - $fMessageID"}
      :set $fMessageID [$teEditMessage fChatID=$fChatID fMessageID=$fMessageID fText=$sendText fReplyMarkup=$replyMarkup]
      :if ($fMessageID = 0) do={
        :set $fMessageID [$teSendMessage fChatID=$fChatID fText=$sendText fReplyMarkup=$replyMarkup]
      }
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard Editing fMessageID - $fMessageID"; :log info "teLeaseCard Editing fMessageID - $fMessageID"}
    } else={

      :set bodyText ("Device: <b>$fLeaseHostname</b> is connected $doubleFeed" . "MAC - <code>$fLeaseActMAC</code>; $oneFeed" . "IP - <code>$fLeaseActIP</code>;$ifaceInfo$doubleFeed")
      :set footerText "$pingCountText<b>Connected </b> $dateM $timeM"
      :set sendText "$newPict $headerText$bodyText$footerText"

      :set $fMessageID [$teSendMessage fChatID=$fChatID fText=$sendText fReplyMarkup=$replyMarkup]
      :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard Sending fMessageID - $fMessageID"; :log info "teLeaseCard Sending fMessageID - $fMessageID"}
    }

    :if ($fDBGteLeaseCard = true) do={:put " teLeaseCard return fMessageID = $fMessageID"; :log info "teLeaseCard return fMessageID = $fMessageID"}
    :put "fMessageID = $fMessageID"
    :return $fMessageID
  }
}
