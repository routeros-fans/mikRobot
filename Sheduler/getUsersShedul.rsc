
:global teMessageResponse

:global dbaseBotSettings
:local botName ($dbaseBotSettings->"botName")

:local commandUsers "getusers$botName"
$teMessageResponse fCommand=$commandUsers fDeleteReport=true
