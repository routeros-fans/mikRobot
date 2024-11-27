#---------------------------------------------------teLogSend--------------------------------------------------------------

#   Function sends the specified events to the chat or group

#   Params for this function:
#   1. fLogTopic    -  name of topics
#   2. fLogChatID   -  log Chat ID
#   4. fLogName     -  name of log
#   5. fLogMessage  -  text from log message
#   6. fLogPicture  -  Picture for log message

#---------------------------------------------------teLogSend--------------------------------------------------------------

:global teLogSend
:if (!any $teLogSend) do={ :global teLogSend do={

    :global dbaseVersion
    :local teLogSendVersion "2.9.7.22"
    :set ($dbaseVersion->"teLogSend") $teLogSendVersion

    :global dbaseBotSettings
    :local deviceName ($dbaseBotSettings->"deviceName")

    :global teGetDate
    :global teSendMessage

    :local oneFeed "%0D%0A"

    :local logDefaultPicture "\F0\9F\93\84"
    :if ([:len $fLogPicture]!=0) do={ :set logDefaultPicture [$fLogPicture]}

    :local dateM [$teGetDate]
    :local timeGmtOffset [/system clock get gmt-offset]

    :local currentTime [:totime [/system clock get time]]
    :if ($currentTime<([$timeGmtOffset + 30])) do={:set ($dbaseBotSettings->$fLogName) 0; :return 0}

    :local currentValue ($dbaseBotSettings->$fLogName)
    :if ([:len $currentValue] = 0) do={:set $currentValue 0; :put "currentValue = $currentValue"}

    :local eventLog [:toarray ""]
    :if ([:len $fLogMessage] != 0) do={
      :set eventLog [/log print as-value where time>$currentValue and topics~"$fLogTopic" and message~"$fLogMessage"]
    } else={
      :set eventLog [/log print as-value where time>$currentValue and topics~"$fLogTopic"]
    }

    :local messageText ""
    :if ([:len $eventLog] > 0) do={
      :foreach data in=$eventLog do={
        :local logTime ($data->"time")
        :local logTopic ($data->"topics")
        :local logMessage ($data->"message")
        :set messageText "$oneFeed<b>$dateM $logTime</b> <b><i>$logTopic</i></b> - $logMessage $oneFeed"
        :local sendText "$logDefaultPicture <b>$deviceName: $fLogName</b>$oneFeed$messageText"
        $teSendMessage fChatID=$fLogChatID fText=$sendText
      }
    } else={
      :set ($dbaseBotSettings->$fLogName) $currentTime
      :return 0
    }
    :set ($dbaseBotSettings->$fLogName) $currentTime
  }
}
