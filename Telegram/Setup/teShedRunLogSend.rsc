# aug/01/2022 14:55:12 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=logSendShedul.rsc]] != 0) do={ remove logSendShedul.rsc }
add dont-require-permissions=no name=logSendShedul.rsc owner=admin policy=\
    read,write,policy,test source="\r\
    \n:global teLogSend\r\
    \n\r\
    \n:global dbaseBotSettings\r\
    \n:local logSendGroup (\$dbaseBotSettings->\"logSendGroup\")\r\
    \n\r\
    \n:local logWirePicture \"\\E2\\9A\\99\"\r\
    \n\$teLogSend fLogPicture=\$logWirePicture fLogName=logWireless fLogTopic=\
    wireless fLogChatID=\$logSendGroup\r\
    \n\r\
    \n:local logErrorPicture \"\\E2\\9D\\97\"\r\
    \n\$teLogSend fLogPicture=\$logErrorPicture fLogName=logError fLogTopic=er\
    ror fLogChatID=\$logSendGroup\r\
    \n\r\
    \n#:local logMessagePicture \"\\E2\\9C\\B3\"\r\
    \n#\$teLogSend fLogName=logMessage fLogTopic=info fLogMessage=\"klsdfjnvlk\
    sdjfnvlkjsdnfvlkjsndfv\" fLogChatID=\$myLogSend\r\
    \n"
