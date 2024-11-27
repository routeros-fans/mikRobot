#---------------------------------------------------teIfaceCard--------------------------------------------------------------

#   The script creates a ppp user card in the Telegram.

#   Params for this function:
#   1. fMessageID         -   ID message
#   2. fChatID            -   chat ID
#   3. fIfaceNote         -   note for Interface
#   4. fIfaceName         -   name of Interface
#   5. fIfaceInfo         -   if button "Info" pressed - true, else - false
#   5. fNewKey            -   new key for Wi-Fi

#   Function return message ID if message sending, 1 if message edited and 0 if error

#   if the global variable fDBGteIfaceCard=true, then a debug event will be logged

#---------------------------------------------------teIfaceCard--------------------------------------------------------------

:global teIfaceCard
:if (!any $teIfaceCard) do={ :global teIfaceCard do={

    :global teDebugCheck
    :local fDBGteIfaceCard [$teDebugCheck fDebugVariableName="fDBGteIfaceCard"]

    :global dbaseVersion
    :local teIfaceCardVersion "2.07.9.22"
    :set ($dbaseVersion->"teIfaceCard") $teIfaceCardVersion

    :global dbaseBotSettings
    :local devicePicture ($dbaseBotSettings->"devicePicture")
    :local deviceName ("$devicePicture " . ($dbaseBotSettings->"deviceName"))

    :global teSendMessage
    :global teEditMessage
    :global teBuildKeyboard
    :global teBuildButton

    :global teGetDate
    :global teGetTime
    :local dateM [$teGetDate]
    :local timeM [$teGetTime]

    :local currentPict []
    :local pictHeaderStatus []
    :local currentInfoButton []
    :local newPict "\E2\9D\97"
    :local pictAnswerCallback "\E2\9D\97"

    :local infoText []
    :local headerText []
    :local bodyText []
    :local footerText []
    :local sendText []
    :local oneFeed "%0D%0A"
    :local doubleFeed "%0D%0A%0D%0A"

    :local NB ","
    :local NL "\5D,\5B"
    :local lineButtons []
    :local replyMarkup []

    :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard is start building..."; :log info "teIfaceCard is start building"}

    :local pictDisable "\E2\98\91"
    :local buttonDisableCallBackText "teCallbackIfaceCard,ifaceDisable,true"
    :local buttonDisable [$teBuildButton fPictButton=$pictDisable fTextButton="  Disable" fTextCallBack=$buttonDisableCallBackText]

    :local pictEnable "\E2\9C\85"
    :local buttonEnableCallBackText "teCallbackIfaceCard,ifaceDisable,false"
    :local buttonEnable [$teBuildButton fPictButton=$pictEnable fTextButton="  Enable" fTextCallBack=$buttonEnableCallBackText]

    :local pictInfOpen "\F0\9F\94\BD"
    :local buttonInfOpenCallBackText "teCallbackIfaceCard,ifaceInfo,true"
    :local buttonInfOpen [$teBuildButton fPictButton=$pictInfOpen fTextButton="  Info" fTextCallBack=$buttonInfOpenCallBackText]

    :local pictInfClose "\F0\9F\94\BC"
    :local buttonInfCloseCallBackText "teCallbackIfaceCard,ifaceInfo,false"
    :local buttonInfClose [$teBuildButton fPictButton=$pictInfClose fTextButton="  Info" fTextCallBack=$buttonInfCloseCallBackText]

    :local pictActive "\F0\9F\9F\A2 "
    :local pictNotActive "\F0\9F\94\98 "

    :local currentIfaceInfo []
    :local wlanInfoText []
    :local currentActiveStatus [interface get $fIfaceName running]
    :local currentDisabledStatus [interface get $fIfaceName disabled]
    :local ifaceType [interface get $fIfaceName type]
    :local ifaceMacAddress [interface get $fIfaceName mac-address]
    :local ifaceLinkDowns [interface get $fIfaceName link-downs]
    :local ifaceLastLinkUp [interface get $fIfaceName last-link-up-time]
    :if ([:len $ifaceLastLinkUp] = 0) do={
      :set ifaceLastLinkUp "<b>newer</b>"
    }
    :local ifaceLastLinkDown [interface get $fIfaceName last-link-down-time]
    :if ([:len $ifaceLastLinkDown] = 0) do={
      :set ifaceLastLinkDown "<b>newer</b>"
    }
    :local wlanMaster [interface wireless get $fIfaceName master-interface]

    :local bridgeInfo []
    :local currentBridge []
    :if (![interface get $fIfaceName dynamic]) do={
      :if ([interface bridge port find interface=$fIfaceName and !disabled]) do={
        :set currentBridge [interface bridge port get [find interface=$fIfaceName and !disabled] bridge]
      }
      :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard currentBridge = $currentBridge"; :log info "teIfaceCard currentBridge = $currentBridge"}

      :if ([:len $currentBridge] != 0) do={
        :set bridgeInfo ("bridge:\t<b>$currentBridge</b>" . "$oneFeed")
        } else={:set bridgeInfo ""}
    }
    :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard bridgeInfo = $bridgeInfo"; :log info "teIfaceCard bridgeInfo = $bridgeInfo"}

    :local vLanInfo []
    :local ifaceVlan []
    :local ifaceVlanId []
    :if ($ifaceType = "vlan") do={

      :set ifaceVlan [interface vlan get $fIfaceName value-name=interface]
      :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard ifaceVlan = $ifaceVlan"; :log info "teIfaceCard ifaceVlan = $ifaceVlan"}
      :set ifaceVlanId [:tostr [interface vlan get $fIfaceName value-name=vlan-id]]
      :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard ifaceVlanId = $ifaceVlanId"; :log info "teIfaceCard ifaceVlanId = $ifaceVlanId"}

      :set vLanInfo (";\tIF:\t<b>$ifaceVlan</b>;\tID:\t<b>$ifaceVlanId</b>")
      :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard vLanInfo = $vLanInfo"; :log info "teIfaceCard vLanInfo = $vLanInfo"}
    } else={ :set vLanInfo "" }

    :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard currentActiveStatus - $currentActiveStatus"; :log info "teIfaceCard currentActiveStatus - $currentActiveStatus"}

    :if ($currentActiveStatus = true) do={
      :set pictHeaderStatus $pictActive
    } else {
      :set pictHeaderStatus $pictNotActive
    }

    :if ($fIfaceInfo=true) do={

      :local bondInfo []
      :if ($ifaceType = "bond") do={
        :local ifaceSlaves [:tostr [interface bonding get $fIfaceName slaves]]
        :local bondMode [:tostr [interface bonding get $fIfaceName mode]]
        :set bondInfo ("$oneFeed<b>Slaves:</b>\t$ifaceSlaves" . "$oneFeed<b>Mode:</b>\t$bondMode")
      } else={:set bondInfo ""}

      :if ($ifaceType = "wlan") do={
        :local wlanSSID [interface wireless get $fIfaceName ssid]
        :local wlanProfile [interface wireless get $fIfaceName security-profile]
        :local wlanMode [interface wireless get $fIfaceName mode]

        :set wlanInfoText ("<b>SSID:</b>\t<code>$wlanSSID</code>" . "$oneFeed" . "<b>Mode:</b>\t$wlanMode" . "$oneFeed" . "<b>Profile:</b>\t$wlanProfile")

        :local pictChangeKey "\F0\9F\94\91"
        :local buttonChangeKeyCallBackText "teCallbackIfaceCard,changeKey,request"
        :local buttonChangeKey [$teBuildButton fPictButton=$pictChangeKey fTextButton=" Change key" fTextCallBack=$buttonChangeKeyCallBackText]
        :set currentInfoButton "$buttonChangeKey"

        :if ([:len $wlanMaster] != 0) do={
          :set wlanInfoText ($wlanInfoText . "$oneFeed" . "<b>Master:</b>\t$wlanMaster" . "$doubleFeed")

          :local pictDelVirtual "\F0\9F\97\91"
          :local buttonDelVirtualCallBackText "teCallbackIfaceCard,virtualDelete,request"
          :local buttonDelVirtual [$teBuildButton fPictButton=$pictDelVirtual fTextButton="  Delete" fTextCallBack=$buttonDelVirtualCallBackText]

          :set currentInfoButton "$currentInfoButton$NB$buttonDelVirtual"
        } else={
          :set wlanInfoText ($wlanInfoText . "$doubleFeed")

          :local pictAddVirtual "\F0\9F\92\B0"
          :local buttonAddVirtualCallBackText "teCallbackIfaceCard,virtualAdd,$fIfaceName"
          :local buttonAddVirtual [$teBuildButton fPictButton=$pictAddVirtual fTextButton=" Add Virtual" fTextCallBack=$buttonAddVirtualCallBackText]

          :set currentInfoButton "$currentInfoButton$NB$buttonAddVirtual"
        }

        :local pictChangeProfile "\F0\9F\9B\A1"
        :local buttonChangeProfileCallBackText "teCallbackIfaceCard,changeProf,true"
        :local buttonChangeProfile [$teBuildButton fPictButton=$pictChangeProfile fTextButton=" Profile" fTextCallBack=$buttonChangeProfileCallBackText]

        :local pictChangeBridge "\F0\9F\8C\89"
        :local buttonChangeBridgeCallBackText "teCallbackIfaceCard,changeBridge,$fIfaceName"
        :local buttonChangeBridge [$teBuildButton fPictButton=$pictChangeBridge fTextButton=" Bridge" fTextCallBack=$buttonChangeBridgeCallBackText]

        :local pictNote "\F0\9F\97\93"
        :local switchCurrentChatValue "ID=$fMessageID,ifaceNote=$fIfaceNote"
        :local buttonNote [$teBuildButton fPictButton=$pictNote fTextButton=" Note" fSwitchCurrentChat=$switchCurrentChatValue]

        :local currentIfacePortsNumber [interface bridge port find interface=$fIfaceName and !disabled]

        :set currentInfoButton "$currentInfoButton$NL$buttonChangeProfile$NB$buttonChangeBridge"

        :if ([:len $currentIfacePortsNumber] = 0 and [:len $wlanMaster] = 0) do={
          :set currentInfoButton "$currentInfoButton$NL$buttonChangeProfile"
        }

        :set infoText $wlanInfoText
      }

      :if ([:len $ifaceMacAddress] != 0) do={
        :set infoText ($infoText . "<b>MAC:</b>\t<code>$ifaceMacAddress</code>$bondInfo" . "$doubleFeed")
      }

      :if ([:len $fNewKey] != 0) do={
        :set infoText ($infoText . "<b>Key:</b>\t<code>$fNewKey</code>" . "$doubleFeed")
      }

      :if ($currentActiveStatus = true) do={
        :set infoText ($infoText . "<b>Up:</b>\t$ifaceLastLinkUp")
        :set infoText ($infoText . "$oneFeed" . "<b>Down:</b>\t$ifaceLastLinkDown")
        :set infoText ($infoText . "$oneFeed" . "<b>Link Downs:</b>\t$ifaceLinkDowns" . "$doubleFeed")
      }

      :local switchCurrentChatValue []
      :if ($ifaceType = "ether" or $ifaceType = "bridge" or $ifaceType = "bond") do={

        :local pictAddVlan "\E2\9E\95"
        :set switchCurrentChatValue "ID=$fMessageID,addVid=00,addName=vLan"
        :local buttonAddVlan [$teBuildButton fPictButton=$pictAddVlan fTextButton=" Add vLan" fSwitchCurrentChat=$switchCurrentChatValue]

        :local pictChangeBridge "\F0\9F\8C\89"
        :local buttonChangeBridgeCallBackText "teCallbackIfaceCard,changeBridge,$fIfaceName"
        :local buttonChangeBridge [$teBuildButton fPictButton=$pictChangeBridge fTextButton=" Bridge" fTextCallBack=$buttonChangeBridgeCallBackText]

        :set currentInfoButton "$buttonAddVlan"

        :local currentIfacePortsNumber [interface bridge port find interface=$fIfaceName and !disabled]

        :if ($ifaceType != "bridge" and ([:len $currentIfacePortsNumber] != 0)) do={
          :set currentInfoButton "$buttonChangeBridge$NB$buttonAddVlan"
        }
      }

      :if ($ifaceType = "vlan") do={

        :local pictEditVlan "\F0\9F\96\8A"
        :set switchCurrentChatValue "ID=$fMessageID,setVid=$ifaceVlanId,setIF=$ifaceVlan,setName=$fIfaceName"
        :local buttonEditVlan [$teBuildButton fPictButton=$pictEditVlan fTextButton="  Edit" fSwitchCurrentChat=$switchCurrentChatValue]

        :local pictDelVlan "\F0\9F\97\91"
        :local buttonDelVlanCallBackText "teCallbackIfaceCard,vlanDelete,request"
        :local buttonDelVlan [$teBuildButton fPictButton=$pictDelVlan fTextButton=" Delete" fTextCallBack=$buttonDelVlanCallBackText]

        :local pictChangeBridge "\F0\9F\8C\89"
        :local buttonChangeBridgeCallBackText "teCallbackIfaceCard,changeBridge,$fIfaceName"
        :local buttonChangeBridge [$teBuildButton fPictButton=$pictChangeBridge fTextButton=" Change bridge" fTextCallBack=$buttonChangeBridgeCallBackText]

        :set currentInfoButton "$buttonDelVlan$NB$buttonEditVlan"

        :local currentIfacePortsNumber [interface bridge port find interface=$fIfaceName and !disabled]

        :if ([:len $currentIfacePortsNumber] != 0) do={
          :set currentInfoButton "$buttonDelVlan$NB$buttonEditVlan$NL$buttonChangeBridge"
        }
      }

      :set currentInfoButton "$currentInfoButton$NL$buttonInfClose"
    } else={
      :set infoText ""
      :set currentInfoButton $buttonInfOpen
    }

    :if ($currentDisabledStatus=true) do={
      :set pictHeaderStatus ($pictHeaderStatus . $pictDisable)
      :set lineButtons "$currentInfoButton$NB$buttonEnable"
    }

    :if ($currentDisabledStatus=false) do={
      :set pictHeaderStatus ($pictHeaderStatus . $pictEnable)
      :set lineButtons "$currentInfoButton$NB$buttonDisable"
    }

    :local ifaceNoteInfo []
    :if ($fIfaceNote != false) do={
      :set ifaceNoteInfo ("Note:\t<b>$fIfaceNote</b>" . "$oneFeed")
    } else={ :set ifaceNoteInfo "" }
    :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard ifaceNoteInfo - $ifaceNoteInfo"; :log info "teIfaceCard ifaceNoteInfo - $ifaceNoteInfo"}

    :if ([:len $wlanMaster] != 0) do={
      :set ifaceType "virtual"
    }

    :set replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]

    :set $fMessageID [:tonum $fMessageID]

    :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard fMessageID - $fMessageID"; :log info "teIfaceCard fMessageID - $fMessageID"}

    :set headerText "$pictHeaderStatus  <b>$deviceName</b> $oneFeed----------------------------------------------------$doubleFeed"

    :if ($fMessageID > 0) do={
      :set bodyText ("$ifaceNoteInfo" . "Interface:\t\t<b>$fIfaceName</b>$oneFeed" . "$bridgeInfo" . "type:\t<b>$ifaceType</b>$vLanInfo$doubleFeed" . "$infoText")
      :set footerText "<b>Updated </b> $dateM $timeM"
      :set sendText "$headerText$bodyText$footerText"

      :set $fMessageID [$teEditMessage fChatID=$fChatID fMessageID=$fMessageID fText=$sendText fReplyMarkup=$replyMarkup]
      :if ($fMessageID = 0) do={
        :set $fMessageID [$teSendMessage fChatID=$fChatID fText=$sendText fReplyMarkup=$replyMarkup]
      }
      :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard Editing fMessageID - $fMessageID"; :log info "teIfaceCard Editing fMessageID - $fMessageID"}
    } else={

      :set bodyText ("Interface:\t\t<b>$fIfaceName</b>$oneFeed" . "$bridgeInfo" . "type:\t<b>$ifaceType</b>" . "$vLanInfo$doubleFeed" . "$infoText")
      :set footerText "<b>Connected </b> $dateM $timeM"
      :set sendText "$newPict$headerText$bodyText$footerText"
      :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard sendText - $sendText"; :log info "teIfaceCard sendText - $sendText"}

      :set $fMessageID [$teSendMessage fChatID=$fChatID fText=$sendText fReplyMarkup=$replyMarkup]
      :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard Sending fMessageID - $fMessageID"; :log info "teIfaceCard Sending fMessageID - $fMessageID"}
    }

    :if ($fDBGteIfaceCard = true) do={:put " teIfaceCard return fMessageID = $fMessageID"; :log info "teIfaceCard return fMessageID = $fMessageID"}
    :put "fMessageID = $fMessageID"
    :return $fMessageID
  }
}
