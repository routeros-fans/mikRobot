
:global teMessageResponse

:global dbaseBotSettings
:local botName ($dbaseBotSettings->"botName")

:local commandIfaces "getifaces$botName"
$teMessageResponse fCommand=$commandIfaces fDeleteReport=true
