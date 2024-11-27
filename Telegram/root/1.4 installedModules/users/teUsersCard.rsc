#---------------------------------------------------teUsersCard--------------------------------------------------------------

#   The script creates a ppp user card in the Telegram.

#   Params for this function:
#   1. fMessageID         -   ID message
#   2. fChatID            -   chat ID
#   5. fUserInfo          -   if button "Info" pressed - true, else - false
#   6. fUserName          -   name of User
#   6. fNewPass           -   new password for User

#   Function return message ID if message sending, 1 if message edited and 0 if error

#   if the global variable fDBGteUsersCard=true, then a debug event will be logged

#---------------------------------------------------teUsersCard--------------------------------------------------------------

:global teUsersCard
:if (!any $teUsersCard) do={ :global teUsersCard do={

    :global teDebugCheck
    :local fDBGteUsersCard [$teDebugCheck fDebugVariableName="fDBGteUsersCard"]

    :global dbaseVersion
    :local teUsersCardVersion "2.9.7.22"
    :set ($dbaseVersion->"teUsersCard") $teUsersCardVersion

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

    :if ($fDBGteUsersCard = true) do={:put " teUsersCard is start building..."; :log info "teUsersCard is start building"}

    :local pictDisable "\E2\98\91"
    :local buttonDisableCallBackText "teCallbackUsersCard,userDisable,true"
    :local buttonDisable [$teBuildButton fPictButton=$pictDisable fTextButton="  Disable" fTextCallBack=$buttonDisableCallBackText]

    :local pictEnable "\E2\9C\85"
    :local buttonEnableCallBackText "teCallbackUsersCard,userDisable,false"
    :local buttonEnable [$teBuildButton fPictButton=$pictEnable fTextButton="  Enable" fTextCallBack=$buttonEnableCallBackText]

    :local pictInfOpen "\F0\9F\94\BD"
    :local buttonInfOpenCallBackText "teCallbackUsersCard,userInfo,true"
    :local buttonInfOpen [$teBuildButton fPictButton=$pictInfOpen fTextButton=" Info" fTextCallBack=$buttonInfOpenCallBackText]

    :local pictInfClose "\F0\9F\94\BC"
    :local buttonInfCloseCallBackText "teCallbackUsersCard,userInfo,false"
    :local buttonInfClose [$teBuildButton fPictButton=$pictInfClose fTextButton="  Info" fTextCallBack=$buttonInfCloseCallBackText]

    :local pictDelete "\F0\9F\97\91"
    :local buttonDeleteCallBackText "teCallbackUsersCard,delete,request"
    :local buttonDelete [$teBuildButton fPictButton=$pictDelete fTextButton="  Del" fTextCallBack=$buttonDeleteCallBackText]

    :local pictChangePass "\F0\9F\8E\B2"
    :local buttonChangePassCallBackText "teCallbackUsersCard,chngPass,request"
    :local buttonChangePass [$teBuildButton fPictButton=$pictChangePass fTextButton="  Pass" fTextCallBack=$buttonChangePassCallBackText]

    :local pictChangeGroup "\F0\9F\97\82"
    :local buttonChangeGroupCallBackText "teCallbackUsersCard,chngGroup,true"
    :local buttonChangeGroup [$teBuildButton fPictButton=$pictChangeGroup fTextButton=" Group" fTextCallBack=$buttonChangeGroupCallBackText]

    :local pictActive "\F0\9F\9F\A2 "
    :local pictNotActive "\F0\9F\94\98 "

    :local currentActiveStatus [user active print as-value detail where name=$fUserName]
    :local currentActiveSessions $currentActiveStatus
    :local currentSessionsInfo []

    :if ([:len $currentActiveStatus] != 0) do={
      :set currentActiveStatus true
      :set pictHeaderStatus $pictActive

      :foreach i in=$currentActiveSessions do={
        :set $activeWhen ($i->"when")
        :set $activeVia ($i->"via")
        :set $activeFrom ($i->"address")
        :set currentSessionsInfo ($currentSessionsInfo . "<b>Via:\t\t\t$activeVia</b>$oneFeed" . "From:\t\t$activeFrom$oneFeed" . "At:\t\t\t$activeWhen$doubleFeed")
      }
    } else {
      :set currentActiveStatus false
      :set pictHeaderStatus $pictNotActive
      :set $fUserLastLogIn [user get [find name=$fUserName] last-logged-in]
      :if ([:len $fUserLastLogIn] = 0) do={:set $fUserLastLogIn "<b>newer</b>"}
    }

    :set $fUserGroup [user get [find name=$fUserName] group]
    :local currentDisabledStatus [user get [find name=$fUserName] disabled]
    :local userAllowedAddress [:tostr [user get [find name=$fUserName] address]]

    :if ($fUserInfo=true) do={

      :if ([:len $userAllowedAddress] != 0) do={
        :set infoText ("$oneFeed" . "<b>Allowed address:</b>\t$userAllowedAddress" . "$oneFeed")
      }

      :if ($currentActiveStatus = true) do={
        :set infoText ($infoText . $currentSessionsInfo)
      }

      :if ($currentActiveStatus = false) do={
        :set infoText ($infoText . "Last login:\t\t$fUserLastLogIn$doubleFeed")
      }

      :set currentInfoButton "$buttonDelete$NB$buttonChangeGroup$NB$buttonChangePass$NL$buttonInfClose"
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

    :set replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]
    :set $fMessageID [:tonum $fMessageID]

    :if ($fDBGteUsersCard = true) do={:put " teUsersCard fMessageID - $fMessageID"; :log info "teUsersCard fMessageID - $fMessageID"}

    :local newPasswordInfo []
    :if ([:len $fNewPass] != 0) do={
      :set newPasswordInfo "<b>Password is set:</b>\t\t\t<code>$fNewPass</code>$doubleFeed"
    } else={:set newPasswordInfo []}

    :set headerText "$pictHeaderStatus  <b>$deviceName</b> $oneFeed----------------------------------------------------$doubleFeed"

    :if ($fMessageID > 0) do={
      :set bodyText ("User:\t\t<b>$fUserName</b>$oneFeed" . "Group:\t\t<b>$fUserGroup</b>$doubleFeed" . "$infoText")
      :set footerText "$newPasswordInfo<b>Updated </b> $dateM $timeM"
      :set sendText "$headerText$bodyText$footerText"

      :set $fMessageID [$teEditMessage fChatID=$fChatID fMessageID=$fMessageID fText=$sendText fReplyMarkup=$replyMarkup]
      :if ($fMessageID = 0) do={
        :set $fMessageID [$teSendMessage fChatID=$fChatID fText=$sendText fReplyMarkup=$replyMarkup]
      }
      :if ($fDBGteUsersCard = true) do={:put " teUsersCard Editing fMessageID - $fMessageID"; :log info "teUsersCard Editing fMessageID - $fMessageID"}
    } else={

      :set bodyText ("User:\t\t<b>$fUserName</b>$oneFeed" . "Group:\t\t<b>$fUserGroup</b>$doubleFeed" . "$infoText")
      :set footerText "<b>Connected </b> $dateM $timeM"
      :set sendText "$newPict$headerText$bodyText$footerText"

      :set $fMessageID [$teSendMessage fChatID=$fChatID fText=$sendText fReplyMarkup=$replyMarkup]
      :if ($fDBGteUsersCard = true) do={:put " teUsersCard Sending fMessageID - $fMessageID"; :log info "teUsersCard Sending fMessageID - $fMessageID"}
    }

    :if ($fDBGteUsersCard = true) do={:put " teUsersCard return fMessageID = $fMessageID"; :log info "teUsersCard return fMessageID = $fMessageID"}
    :put "fMessageID = $fMessageID"
    :return $fMessageID
  }
}
