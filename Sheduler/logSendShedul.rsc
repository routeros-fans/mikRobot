
:global teLogSend

:global dbaseBotSettings
:local logSendGroup ($dbaseBotSettings->"logSendGroup")

:local logWirelessPicture "\E2\9A\99"
:local logNameWireless "logWireless"
$teLogSend fLogPicture=$logWirelessPicture fLogName=$logNameWireless fLogTopic=wireless fLogChatID=$logSendGroup

:local logErrorPicture "\E2\9D\97"
:local logErrorName "logError"
$teLogSend fLogPicture=$logErrorPicture fLogName=$logErrorName fLogTopic=error fLogChatID=$logSendGroup

:local logMessagePicture "\E2\9C\B3"
:local logMessageName "logMessage"
$teLogSend fLogPicture=$logMessagePicture fLogName=$logMessageName fLogTopic=info fLogMessage="youre message" fLogChatID=$logSendGroup
