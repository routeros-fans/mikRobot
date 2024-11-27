#---------------------------------------------------tePppCard--------------------------------------------------------------

#   The script creates a ppp user card in the Telegram.

#   Params for this function:
#   1. fMessageID         -   ID message
#   2. fChatID            -   chat ID
#   3. fQueryID           -   query ID
#   4. fpppInfo           -   if button "Info" pressed - true, else - false
#   5. fpppName           -   name of User from ppp Secrets
#   6. fnewSecret         -   new password for User

#   Function return message ID if message sending, 1 if message edited and 0 if error

#   if the global variable fDBGtePppCard=true, then a debug event will be logged

#---------------------------------------------------tePppCard--------------------------------------------------------------

:global tePppCard
:if (!any $tePppCard) do={ :global tePppCard do={

    :global teDebugCheck
    :local fDBGtePppCard [$teDebugCheck fDebugVariableName="fDBGtePppCard"]

    :global dbaseVersion
    :local tePppCardVersion "2.9.7.22"
    :set ($dbaseVersion->"tePppCard") $tePppCardVersion

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

    :if ($fDBGtePppCard = true) do={:put " tePppCard is start building..."; :log info "tePppCard is start building"}

    :local pictDisable "\E2\98\91"
    :local buttonDisableCallBackText "teCallbackPppCard,pppDisable,true"
    :local buttonDisable [$teBuildButton fPictButton=$pictDisable fTextButton="  Disable" fTextCallBack=$buttonDisableCallBackText]

    :local pictEnable "\E2\9C\85"
    :local buttonEnableCallBackText "teCallbackPppCard,pppDisable,false"
    :local buttonEnable [$teBuildButton fPictButton=$pictEnable fTextButton="  Enable" fTextCallBack=$buttonEnableCallBackText]

    :local pictInfOpen "\F0\9F\94\BD"
    :local buttonInfOpenCallBackText "teCallbackPppCard,pppInfo,true"
    :local buttonInfOpen [$teBuildButton fPictButton=$pictInfOpen fTextButton=" Info" fTextCallBack=$buttonInfOpenCallBackText]

    :local pictInfClose "\F0\9F\94\BC"
    :local buttonInfCloseCallBackText "teCallbackPppCard,pppInfo,false"
    :local buttonInfClose [$teBuildButton fPictButton=$pictInfClose fTextButton="  Info" fTextCallBack=$buttonInfCloseCallBackText]

    :local pictDelete "\F0\9F\97\91"
    :local buttonDeleteCallBackText "teCallbackPppCard,delete,request"
    :local buttonDelete [$teBuildButton fPictButton=$pictDelete fTextButton="  Delete" fTextCallBack=$buttonDeleteCallBackText]
    :local buttonDel [$teBuildButton fPictButton=$pictDelete fTextButton="  Del" fTextCallBack=$buttonDeleteCallBackText]

    :local pictDisconnect "\F0\9F\94\98"
    :local buttonDisconnectCallBackText "teCallbackPppCard,disconnect,request"
    :local buttonDisconnect [$teBuildButton fPictButton=$pictDisconnect fTextButton=" Break" fTextCallBack=$buttonDisconnectCallBackText]

    :local pictChangePass "\F0\9F\8E\B2"
    :local buttonChangePassCallBackText "teCallbackPppCard,chngPass,request"
    :local buttonChangePass [$teBuildButton fPictButton=$pictChangePass fTextButton="  Pass" fTextCallBack=$buttonChangePassCallBackText]
    :local buttonChangePassword [$teBuildButton fPictButton=$pictChangePass fTextButton="  Password" fTextCallBack=$buttonChangePassCallBackText]

    :local pictActive "\F0\9F\9F\A2 "
    :local pictNotActive "\F0\9F\94\98 "

    :local currentActiveStatus [ppp active find name=$fpppName]
    :if ($fDBGtePppCard = true) do={:put " tePppCard currentActiveStatus = $currentActiveStatus"; :log info "tePppCard currentActiveStatus = $currentActiveStatus"}
    :if ([:len $currentActiveStatus] != 0) do={
      :set currentActiveStatus true
      :set pictHeaderStatus $pictActive

      :set $fpppUserName [ppp active get [find name=$fpppName] name]
      :set $fpppCallerID [ppp active get [find name=$fpppName] caller-id]
      :set $fpppEncoding [ppp active get [find name=$fpppName] encoding]
      :set $fpppAddress [ppp active get [find name=$fpppName] address]
      :set $fpppUptime [ppp active get [find name=$fpppName] uptime]
    } else {
      :set currentActiveStatus false
      :set pictHeaderStatus $pictNotActive

      :set $fpppUserName [ppp secret get [find name=$fpppName] name]
      :set $fpppLastLogOut [ppp secret get [find name=$fpppName] last-logged-out]
      :set $fpppCallerID [ppp secret get [find name=$fpppName] last-caller-id]
      :set $fpppLastDisconnectReason [ppp secret get [find name=$fpppName] last-disconnect-reason]
    }

    :set $fpppUserService [ppp secret get [find name=$fpppUserName] service]
    :set $fpppUserProfile [ppp secret get [find name=$fpppUserName] profile]

    :if ($fDBGtePppCard = true) do={:put " tePppCard currentActiveStatus = $currentActiveStatus"; :log info "tePppCard currentActiveStatus = $currentActiveStatus"}

    :local currentDisabledStatus [ppp secret get [find name=$fpppName] disabled]

    :if ($fDBGtePppCard = true) do={:put " tePppCard currentDisabledStatus = $currentDisabledStatus"; :log info "tePppCard currentDisabledStatus = $currentDisabledStatus"}

    :if ($fpppInfo=true) do={

      :if ($currentActiveStatus = true) do={
        :set infoText ("$doubleFeed" . "Encoding:\t$fpppEncoding$oneFeed" . "Address:\t\t\t<code>$fpppAddress</code>$oneFeed"  . "Uptime:\t\t\t\t\t$fpppUptime$oneFeed")
        :set currentInfoButton "$buttonDel$NB$buttonDisconnect$NB$buttonChangePass$NL$buttonInfClose"
        :if ($fDBGtePppCard = true) do={:put " tePppCard pppInfo - $fpppInfo"; :log info "tePppCard pppInfo - $fpppInfo"}
      }

      :if ($currentActiveStatus = false) do={
        :set infoText ("$doubleFeed" . "Logout:\t\t$fpppLastLogOut$oneFeed" . "Reason:\t$fpppLastDisconnectReason$oneFeed")
        :set currentInfoButton "$buttonDelete$NB$buttonChangePassword$NL$buttonInfClose"
        :if ($fDBGtePppCard = true) do={:put " tePppCard pppInfo - $fpppInfo"; :log info "tePppCard pppInfo - $fpppInfo"}
      }


      :if ($fDBGtePppCard = true) do={:put " tePppCard fpppInfo - $fpppInfo"; :log info "tePppCard fpppInfo - $fpppInfo"}
    } else={
      :set infoText "$oneFeed"
      :set currentInfoButton $buttonInfOpen
      :if ($fDBGtePppCard = true) do={:put " tePppCard fpppInfo - $fpppInfo"; :log info "tePppCard fpppInfo - $fpppInfo"}
    }

    :if ($currentDisabledStatus=true) do={
      :set pictHeaderStatus ($pictHeaderStatus . $pictDisable)
      :set lineButtons "$currentInfoButton$NB$buttonEnable"
      :if ($fDBGtePppCard = true) do={:put " tePppCard fpppDisable - $currentDisabledStatus"; :log info "tePppCard fpppDisable - $currentDisabledStatus"}
    }
    :if ($currentDisabledStatus=false) do={
      :set pictHeaderStatus ($pictHeaderStatus . $pictEnable)
      :set lineButtons "$currentInfoButton$NB$buttonDisable"
      :if ($fDBGtePppCard = true) do={:put " tePppCard fpppDisable - $currentDisabledStatus"; :log info "tePppCard fpppDisable - $currentDisabledStatus"}
    }

    :if ($fDBGtePppCard = true) do={:put " tePppCard lineButtons - $lineButtons"; :log info "tePppCard lineButtons - $lineButtons"}
    :set replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]

    :local newSecretInfo []
    :if ([:len $fnewSecret] != 0) do={
      :set newSecretInfo "<b>Secret is set:</b>\t\t\t<code>$fnewSecret</code>$doubleFeed"
    } else={:set newSecretInfo []}

    :set $fMessageID [:tonum $fMessageID]
    :if ($fDBGtePppCard = true) do={:put " tePppCard fMessageID - $fMessageID"; :log info "tePppCard fMessageID - $fMessageID"}

    :set headerText "$pictHeaderStatus  <b>$deviceName</b> $oneFeed----------------------------------------------------$doubleFeed"

    :if ($fMessageID > 0) do={
      :set bodyText ("User: <b>$fpppUserName</b>" . "$doubleFeed" . "Caller ID:\t\t<code>$fpppCallerID</code>$oneFeed" . "Profile:\t\t\t\t\t$fpppUserProfile$oneFeed" . "<b>Service:</b>\t\t\t$fpppUserService$infoText$oneFeed")
      :set footerText "$newSecretInfo<b>Updated </b> $dateM $timeM"
      :set sendText "$headerText$bodyText$footerText"

      :if ($fDBGtePppCard = true) do={:put " tePppCard Editing fMessageID - $fMessageID"; :log info "tePppCard Editing fMessageID - $fMessageID"}
      :set $fMessageID [$teEditMessage fChatID=$fChatID fMessageID=$fMessageID fText=$sendText fReplyMarkup=$replyMarkup]
      :if ($fDBGtePppCard = true) do={:put " tePppCard after Editing fMessageID - $fMessageID"; :log info "tePppCard after Editing fMessageID - $fMessageID"}
      :if ($fMessageID = 0) do={
        :set $fMessageID [$teSendMessage fChatID=$fChatID fText=$sendText fReplyMarkup=$replyMarkup]
        :if ($fDBGtePppCard = true) do={:put " tePppCard Sending fMessageID - $fMessageID"; :log info "tePppCard Sending fMessageID - $fMessageID"}
      }
    } else={

      :set bodyText ("User: <b>$fpppUserName</b>$doubleFeed" . "Caller ID:\t\t<code>$fpppCallerID</code>$oneFeed" . "Profile:\t\t\t\t\t$fpppUserProfile$oneFeed" ."<b>Service:</b>\t\t\t$fpppUserService$doubleFeed")
      :set footerText "<b>Connected </b> $dateM $timeM"
      :set sendText "$newPict$headerText$bodyText$footerText"

      :set $fMessageID [$teSendMessage fChatID=$fChatID fText=$sendText fReplyMarkup=$replyMarkup]
      :if ($fDBGtePppCard = true) do={:put " tePppCard Sending fMessageID - $fMessageID"; :log info "tePppCard Sending fMessageID - $fMessageID"}
    }

    :if ($fDBGtePppCard = true) do={:put " tePppCard return fMessageID = $fMessageID"; :log info "tePppCard return fMessageID = $fMessageID"}
    :put "fMessageID = $fMessageID"
    :return $fMessageID
  }
}
