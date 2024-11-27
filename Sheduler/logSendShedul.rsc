
:global teLogSend

:global dbaseBotSettings
:local logSendGroup ($dbaseBotSettings->"logSendGroup")

:local logWirePicture "\E2\9A\99"
$teLogSend fLogPicture=$logWirePicture fLogName=logWireless fLogTopic=wireless fLogChatID=$logSendGroup

:local logErrorPicture "\E2\9D\97"
$teLogSend fLogPicture=$logErrorPicture fLogName=logError fLogTopic=error fLogChatID=$logSendGroup

#:local logMessagePicture "\E2\9C\B3"
#$teLogSend fLogName=logMessage fLogTopic=info fLogMessage="klsdfjnvlksdjfnvlkjsdnfvlkjsndfv" fLogChatID=$myLogSend
