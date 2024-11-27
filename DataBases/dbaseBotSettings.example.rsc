#---------------------------------------------------dbaseBotSettings--------------------------------------------------------------

#   Script sets settings for bot.

#---------------------------------------------------dbaseBotSettings--------------------------------------------------------------

:global dbaseBotSettings [:toarray ""]
:local dbName "dbaseBotSettings"
:local currentTime [/system clock get time]
:local deviceName [/system identity get name]
:local devicePicture "\F0\9F\8F\AC"
:local botID "bot######:REDACTED"
:local botName "REDACTED"
:local imageRootHeader "https://habrastorage.org/webt/sb/f6/kz/sbf6kz9v7lbjqz9rihx1hfmjska.jpeg"
:local imageRoot "https://habrastorage.org/webt/kz/uh/xm/kzuhxmsrjq7mrzqin8aznrrhclw.jpeg"
:local bkpPassword "REDACTED"

:set dbaseBotSettings ({
$dbName;
"botID"=$botID;
"botName"=$botName;
"deviceName"=$deviceName;
"devicePicture"=$devicePicture;
"imageRoot"=$imageRoot;
"imageRootHeader"=$imageRootHeader;
"ifaceGroup"=REDACTED;
"logSendGroup"REDACTED;
"logPinGroup"=REDACTED;
"usersGroup"=REDACTED;
"pppGroup"=-REDACTED;
"pppLogGroup"=REDACTED;
"leaseGroup"=REDACTED;
"logError"=$currentTime;
"logMessage"=$currentTime;
"logWireless"=$currentTime;
"showLease"=true;
"defaultPingCount"=4;
"defaultList"="AllowList";
"firewallAddressListTimeout"=4w2d00:00:00;
"firewallAddressListDeleteTimeout"=23:59:59;
"bkpPassword"=$bkpPassword;
})
