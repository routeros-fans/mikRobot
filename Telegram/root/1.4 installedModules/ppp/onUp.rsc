
#---------------------------------------------------onUp--------------------------------------------------------------

:global teGetDate
:global teGetTime
:global teSendMessage
:local dateM [$teGetDate]
:local timeM [$teGetTime]
:local oneFeed "%0D%0A"

:global dbaseBotSettings
:local pppLogGroup ($dbaseBotSettings->"pppLogGroup")
:local devicePicture ($dbaseBotSettings->"devicePicture")
:local deviceName ("$devicePicture " . ($dbaseBotSettings->"deviceName"))

:local callerID $"caller-id"
:local calledID $"called-id"
:local remoteAddress $"remote-address"
:local localAddress $"local-address"

:local connectInfo ("Caller ID:\t\t$callerID$oneFeed" . "Called ID:\t\t$calledID$oneFeed" . "Remote addr:\t\t$remoteAddress$oneFeed" . "Local addr:\t\t$localAddress$oneFeed")

:local pictConnect "\F0\9F\9F\A2"
:local pictDisconnect "\F0\9F\94\98"

:local sendText ("$pictConnect <b>$dateM $timeM</b>$oneFeed$oneFeed" . "User <b>$user</b>$oneFeed" . "has connected to the <b>$deviceName</b>" . "$oneFeed$connectInfo ")

$teSendMessage fChatID=$pppLogGroup fText=$sendText
