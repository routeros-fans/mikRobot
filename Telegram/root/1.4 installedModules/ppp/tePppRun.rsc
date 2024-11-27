#---------------------------------------------------tePppRun--------------------------------------------------------------

# https://wiki.mikrotik.com/wiki/Manual:PPP_AAA#Properties

# Execute script on user login-event. These are available variables that are accessible for the event script:
# user            - contains the user name
# local-address   - local address of the mikrotik
# remote-address  - the internal address received by the client from the mikrotik
# caller-id       - client's address
# called-id       - client hostname
# interface       - interface number

#   Params for this function:

# fUser           - user Name
# fFromRun        - user Name

#---------------------------------------------------tePppRun--------------------------------------------------------------

:global tePppRun
:if (!any $tePppRun) do={ :global tePppRun do={

    :global teSendMessage
    :global teBuildKeyboard
    :global teBuildButton

    :global teGetDate
    :global teGetTime
    :local dateM [$teGetDate]
    :local timeM [$teGetTime]
    :local oneFeed "%0D%0A"

    :global dbaseBotSettings
    :local botID ($dbaseBotSettings->"botID")
    :local pppGroup ($dbaseBotSettings->"pppGroup")
    :local pppLogGroup ($dbaseBotSettings->"pppLogGroup")
    :local devicePicture ($dbaseBotSettings->"devicePicture")
    :local deviceName ("$devicePicture " . ($dbaseBotSettings->"deviceName"))

    :local messageID []
    :local userChatID [:pick $botID 3 [find $botID ":"]]

    :set messageID ([:toarray [ppp secret get $fUser comment]]->1)
    :if ([:len $messageID] = 0) do={
      :set messageID 0
    } else={
      :set messageID [:pick $messageID ([find $messageID "MSG="] + 4) [:len $messageID]]
    }

    :local pictJump "\E2\96\B6"
    :local logChat [:pick $pppGroup 4 [:len $pppGroup]]
    :local buttonJumpUrl "https://t.me/c/$logChat/$messageID"
    :local buttonJump [$teBuildButton fPictButton=$pictJump fTextButton="  Jump to message" fUrlButton=$buttonJumpUrl]

    :local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$buttonJump fReplyKeyboard=false]
    :local firstConnect []
    :if ($messageID = 0) do={ :set replyMarkup []; :set $firstConnect "first time"}

    :local pictConnect "\F0\9F\9F\A2"
    :local pictDisconnect "\F0\9F\94\98"
    :local sendText []
    :if ($fFromRun = 1) do={
      :set sendText ("$pictConnect <b>$dateM $timeM</b>$oneFeed$oneFeed" . "User <b>$fUser</b>$oneFeed" . "$firstConnect " . "has connected to the <b>$deviceName</b>")
    } else={
      :set sendText ("$pictDisconnect <b>$dateM $timeM</b>$oneFeed$oneFeed" . "User <b>$fUser</b>$oneFeed" . "disconnected from <b>$deviceName</b>")
    }
    $teSendMessage fChatID=$pppLogGroup fText=$sendText fReplyMarkup=$replyMarkup

    [[:parse [/system script get teCallbackPppCard source]] userChatID=$userChatID messageID=$messageID queryChatID=$pppGroup fpppName=$fUser]
  }
}
