# sep/15/2022 13:47:04 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=teCallbackLeaseCard]] != 0) do={ remove teCallbackLeaseCard }
add dont-require-permissions=no name=teCallbackLeaseCard owner=xenon007 policy=\
    ftp,reboot,read,write,policy,test source="#-------------------------------\
    --------------------teCallbackLeaseCard-----------------------------------\
    ---------------------------\r\
    \n#\t\tClick event handler for DHCP\r\
    \n\r\
    \n#\t\tqueryChatID\t\t-\t\tchat id\r\
    \n#\t\tuserChatID\t\t-\t\tuser id\r\
    \n#\t\tmessageID\t\t\t-\t\tmessage id\r\
    \n#\t\tqueryID\t\t\t\t-\t\tquery id\r\
    \n#\t\tmessageIP\t\t\t-\t\tmessage IP\r\
    \n\r\
    \n#\t\tcommandName\t\t-\t\tcommand name\r\
    \n#\t\tcommandValue\t-\t\tcommand value\r\
    \n\r\
    \n#---------------------------------------------------teCallbackLeaseCard-\
    -------------------------------------------------------------\r\
    \n\r\
    \n\t:global teDebugCheck\r\
    \n\t:local fDBGteCallbackLeaseCard [\$teDebugCheck fDebugVariableName=\"fD\
    BGteCallbackLeaseCard\"]\r\
    \n\r\
    \n\t:global dbaseBotSettings\r\
    \n\t:local firewallAddressListTimeout (\$dbaseBotSettings->\"firewallAddre\
    ssListTimeout\")\r\
    \n\t:local firewallAddressListDeleteTimeout (\$dbaseBotSettings->\"firewal\
    lAddressListDeleteTimeout\")\r\
    \n\r\
    \n\t:global dbaseVersion\r\
    \n\t:local teCallbackLeaseCardVersion \"2.19.9.22\"\r\
    \n\t:set (\$dbaseVersion->\"teCallbackLeaseCard\") \$teCallbackLeaseCardVe\
    rsion\r\
    \n\r\
    \n\t:global teEditMessageReplyMarkup\r\
    \n\t:global teAnswerCallbackQuery\r\
    \n\t:global teDeleteMessage\r\
    \n\t:global teSendMessage\r\
    \n\t:global teBuildKeyboard\r\
    \n\t:global teBuildButton\r\
    \n\r\
    \n\t:global teRightsControl\r\
    \n\t:global teLeaseCard\r\
    \n\t:global dbaseDynLease\r\
    \n\r\
    \n\t:global teGetDate\r\
    \n\t:global teGetTime\r\
    \n\t:local dateM [\$teGetDate]\r\
    \n\t:local timeM [\$teGetTime]\r\
    \n\r\
    \n\t:local pingCount \"\"\r\
    \n\r\
    \n\t:local allowList \"AllowList\"\r\
    \n\t:local blockList \"BlockList\"\r\
    \n\r\
    \n\t:local currentRecord []\r\
    \n\t:local currentAddressList \"\"\r\
    \n\t:local commentArray [:toarray \"\"]\r\
    \n\t:local currentMessageID []\r\
    \n\t:set currentMessageID \"MSG=\$messageID\"\r\
    \n\r\
    \n\t:local currentTimestat \"\$dateM \$timeM\"\r\
    \n\t:local pictAnswerCallback \"\\E2\\9D\\97\"\r\
    \n\t:local accessDeniedMessage \"\$pictAnswerCallback For user \$userName \
    - Access denied \"\r\
    \n\t:local answer []\r\
    \n\r\
    \n\tdo {\r\
    \n\r\
    \n\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRightName\
    =\"leaseread\"] = false) do={\r\
    \n\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$accessDen\
    iedMessage fAlert=true\r\
    \n\t\t\t:return false\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallbackLeaseCar\
    d currentMessageID = \$currentMessageID\"; :log info \"teCallbackLeaseCard\
    \_currentMessageID = \$currentMessageID\"}\r\
    \n\r\
    \n\t\t:local recordsArray []\r\
    \n\t\t:set recordsArray [/ip firewall address-list find comment~\"\$curren\
    tMessageID\" and !disabled]\r\
    \n\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallbackLeaseCar\
    d recordsArray = \$([:len \$recordsArray])\"; :log info \"teCallbackLeaseC\
    ard recordsArray = \$([:len \$recordsArray])\"}\r\
    \n\t\t:if ([:len \$recordsArray] != 0) do={\r\
    \n\t\t\t:foreach i in=\$recordsArray do={\r\
    \n\t\t\t\t:local recordMessageID [:toarray [/ip firewall address-list get \
    [find .id=\$i] comment]]\r\
    \n\t\t\t\t:if ((\$recordMessageID->9) = \$currentMessageID) do={:set curre\
    ntRecord \$i}\r\
    \n\t\t\t}\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if ([:len \$currentRecord] != 0) do={\r\
    \n\t\t\t:set commentArray [:toarray [/ip firewall address-list get number=\
    \$currentRecord comment]]\r\
    \n\r\
    \n\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={\r\
    \n\t\t\t\t:foreach i in=\$commentArray do={:log info \"\$i - type of item:\
    \$([:typeof \$i])\"}\r\
    \n\t\t\t\t:put \$commentArray; :log info \$commentArray\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallbackLeaseC\
    ard currentRecord = \$currentRecord\"; :log info \"teCallbackLeaseCard cur\
    rentRecord = \$currentRecord\"}\r\
    \n\r\
    \n\t\t\t:local leaseActIP [/ip firewall address-list get \$currentRecord a\
    ddress]\r\
    \n\t\t\t:local leaseNote (\$commentArray->0)\r\
    \n\t\t\t:local leaseInfo (\$commentArray->1)\r\
    \n\t\t\t:local isBlocked (\$commentArray->2)\r\
    \n\t\t\t:local leaseActMAC (\$commentArray->5)\r\
    \n\t\t\t:local leaseHostname (\$commentArray->6)\r\
    \n\t\t\t:local leaseParams (\$commentArray->7)\r\
    \n\t\t\t:local leaseRateShow (\$commentArray->8)\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"static\") do={\r\
    \n\r\
    \n\t\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRig\
    htName=\"leasewrite\"] = false) do={\r\
    \n\t\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acc\
    essDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t\t:return false\r\
    \n\t\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t\t:set answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAn\
    swerText=\\\" \\\"\"\r\
    \n\t\t\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t\t\t:local staticRequest \$commandValue\r\
    \n\t\t\t\t\t:local NB \",\"\r\
    \n\t\t\t\t\t:local NL \"\\5D,\\5B\"\r\
    \n\r\
    \n\t\t\t\t\t:local pictStatic \"\\F0\\9F\\93\\8C\"\r\
    \n\t\t\t\t\t:local buttonStaticCallBackText \"teCallbackLeaseCard,static,r\
    equest\"\r\
    \n\t\t\t\t\t:local buttonStatic [\$teBuildButton fPictButton=\$pictStatic \
    fTextButton=\"  Make static\?\" fTextCallBack=\$buttonStaticCallBackText]\
    \r\
    \n\r\
    \n\t\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t\t:local buttonYesCallBackText \"teCallbackLeaseCard,static,true\
    \"\r\
    \n\t\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextB\
    utton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t\t:local buttonNoCallBackText \"teCallbackLeaseCard,static,false\
    \"\r\
    \n\t\t\t\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextBut\
    ton=\"  No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t\t\t\t:if (\$staticRequest = \"request\") do={\r\
    \n\r\
    \n\t\t\t\t\t\t:local lineButtons \"\$buttonStatic\$NL\$buttonYes\$NB\$butt\
    onNo\"\r\
    \n\t\t\t\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$lin\
    eButtons fReplyKeyboard=false]\r\
    \n\r\
    \n\t\t\t\t\t\t\$teEditMessageReplyMarkup fChatID=\$queryChatID fMessageID=\
    \$messageID fReplyMarkup=\$replyMarkup\r\
    \n\r\
    \n\t\t\t\t\t\t:return true\r\
    \n\t\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t\t:if (\$staticRequest = \"true\") do={\r\
    \n\t\t\t\t\t\t/ip dhcp-server lease make-static [find mac-address=\$leaseA\
    ctMAC and !disabled and address=\$leaseActIP]\r\
    \n\r\
    \n\t\t\t\t\t\tdo {\r\
    \n\t\t\t\t\t\t\t:foreach k,v in=\$dbaseDynLease do={\r\
    \n\t\t\t\t\t\t\t\t:if (\$k = \$messageID) do={\r\
    \n\t\t\t\t\t\t\t\t\t\t:set (\$dbaseDynLease->\$k)\r\
    \n\t\t\t\t\t\t\t\t\t\t:error message=\"Record found in leaseArray\"\r\
    \n\t\t\t\t\t\t\t\t}\r\
    \n\t\t\t\t\t\t\t}\r\
    \n\t\t\t\t\t\t} on-error={:if (\$fDBGteLease = true) do={:put \"teCallback\
    LeaseCard Record delete from leaseArray\"; :log warning \"teCallbackLeaseC\
    ard Record delete from leaseArray\"}}\r\
    \n\r\
    \n\t\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"delete\" or \$commandName = \"waiting\") do\
    ={\r\
    \n\t\t\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallback\
    LeaseCard commandName=\$commandName\"; :log info \"teCallbackLeaseCard com\
    mandName=\$commandName\"}\r\
    \n\r\
    \n\t\t\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fR\
    ightName=\"leasedelete\"] = false) do={\r\
    \n\t\t\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$a\
    ccessDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t\t\t:return false\r\
    \n\t\t\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t\t\t:set answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID f\
    AnswerText=\\\" \\\"\"\r\
    \n\t\t\t\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t\t\t\t:local deleteRequest \$commandValue\r\
    \n\t\t\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallback\
    LeaseCard deleteRequest=\$deleteRequest\"; :log info \"teCallbackLeaseCard\
    \_deleteRequest=\$deleteRequest\"}\r\
    \n\r\
    \n\t\t\t\t\t\t:local NB \",\"\r\
    \n\t\t\t\t\t\t:local NL \"\\5D,\\5B\"\r\
    \n\r\
    \n\t\t\t\t\t\t:local pictDelete \"\\F0\\9F\\97\\91\"\r\
    \n\t\t\t\t\t\t:local buttonDeleteCallBackText \"teCallbackLeaseCard,delete\
    ,request\"\r\
    \n\t\t\t\t\t\t:local buttonDelete [\$teBuildButton fPictButton=\$pictDelet\
    e fTextButton=\"  Delete\?\" fTextCallBack=\$buttonDeleteCallBackText]\r\
    \n\r\
    \n\t\t\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t\t\t:local buttonYesCallBackText \"teCallbackLeaseCard,delete,tr\
    ue\"\r\
    \n\t\t\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTex\
    tButton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t\t\t:local buttonNoCallBackText \"teCallbackLeaseCard,delete,fal\
    se\"\r\
    \n\t\t\t\t\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextB\
    utton=\"  No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t\t\t\t\t:if (\$deleteRequest = \"request\") do={\r\
    \n\t\t\t\t\t\t\t:local lineButtons \"\$buttonDelete\$NL\$buttonYes\$NB\$bu\
    ttonNo\"\r\
    \n\t\t\t\t\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$l\
    ineButtons fReplyKeyboard=false]\r\
    \n\t\t\t\t\t\t\t\$teEditMessageReplyMarkup fChatID=\$queryChatID fMessageI\
    D=\$messageID fReplyMarkup=\$replyMarkup\r\
    \n\t\t\t\t\t\t\t:return true\r\
    \n\t\t\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t\t\t:if (\$deleteRequest = \"true\") do={\r\
    \n\t\t\t\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallba\
    ckLeaseCard deleteting MSG=\$messageID\"; :log info \"teCallbackLeaseCard \
    \_deleteting MSG=\$messageID\"}\r\
    \n\t\t\t\t\t\t\t/ip firewall address-list remove numbers=\$currentRecord\r\
    \n\t\t\t\t\t\t\t/ip dhcp-server lease remove [find mac-address=\$leaseActM\
    AC and !disabled and address=\$leaseActIP]\r\
    \n\r\
    \n\t\t\t\t\t\t\tdo {\r\
    \n\t\t            :foreach k,v in=\$dbaseDynLease do={\r\
    \n\t\t              :if (\$k = \$messageID) do={\r\
    \n\t\t                  :set (\$dbaseDynLease->\$k)\r\
    \n\t\t                  :error message=\"Record found in leaseArray\"\r\
    \n\t\t              }\r\
    \n\t\t            }\r\
    \n\t\t          } on-error={:if (\$fDBGteLease = true) do={:put \"teCallba\
    ckLeaseCard Record delete from leaseArray\"; :log warning \"teCallbackLeas\
    eCard Record delete from leaseArray\"}}\r\
    \n\r\
    \n\t\t\t\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$messa\
    geID fUserName=\$userName\r\
    \n\t\t\t\t\t\t\t:return true\r\
    \n\t\t\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallback\
    LeaseCard deleteRequest=\$deleteRequest\"; :log info \"teCallbackLeaseCard\
    \_deleteRequest=\$deleteRequest\"}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"leaseInfo\") do={\r\
    \n\t\t\t\t\t\t:set leaseInfo \$commandValue\r\
    \n\t\t\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallback\
    LeaseCard leaseInfo=\$leaseInfo\"; :log info \"teCallbackLeaseCard leaseIn\
    fo=\$leaseInfo\"}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"params\") do={\r\
    \n\t\t\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fR\
    ightName=\"leasewrite\"] = false) do={\r\
    \n\t\t\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$a\
    ccessDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t\t\t:return false\r\
    \n\t\t\t\t\t\t}\r\
    \n\t\t\t\t\t\t:set leaseParams \$commandValue\r\
    \n\t\t\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallback\
    LeaseCard leaseParams=\$leaseParams\"; :log info \"teCallbackLeaseCard lea\
    seParams=\$leaseParams\"}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"isBlocked\") do={\r\
    \n\t\t\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fR\
    ightName=\"leasewrite\"] = false) do={\r\
    \n\t\t\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$a\
    ccessDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t\t\t:return false\r\
    \n\t\t\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t\t\t:set isBlocked \$commandValue\r\
    \n\t\t\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallback\
    LeaseCard isBlocked=\$isBlocked\"; :log info \"teCallbackLeaseCard isBlock\
    ed=\$isBlocked\"}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"ping\") do={\r\
    \n\t\t\t\t:set pingCount [ping \$leaseActIP count=\$commandValue]\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:set answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAnswer\
    Text=\\\" \\\"\"\r\
    \n\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t\$teLeaseCard fChatID=\$queryChatID fQueryID=\$queryID fLeaseHostn\
    ame=\$leaseHostname fLeaseActMAC=\$leaseActMAC fLeaseActIP=\$leaseActIP is\
    Blocked=\$isBlocked leaseInfo=\$leaseInfo leaseNote=\$leaseNote pingCount=\
    \$pingCount leaseParams=\$leaseParams leaseRateShow=\$leaseRateShow fMessa\
    geID=\$messageID\r\
    \n\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallbackLeaseC\
    ard teLeaseCard\"; :log info \"teCallbackLeaseCard teLeaseCard\"}\r\
    \n\r\
    \n\t\t\t:if (\$isBlocked = true) do={:set currentAddressList \$blockList}\
    \r\
    \n\t\t\t:if (\$isBlocked = false) do={:set currentAddressList \$allowList}\
    \r\
    \n\r\
    \n\t\t\t:local findingMessage [/ip firewall address-list get number=\$curr\
    entRecord]\r\
    \n\t\t\t:if ([:len \$findingMessage] != 0) do={\r\
    \n\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallbackLeas\
    eCard deleting leaseActIP = \$leaseActIP\"; :log info \"teCallbackLeaseCar\
    d deleting leaseActIP = \$leaseActIP\"}\r\
    \n\t\t\t\t/ip firewall address-list remove number=\$currentRecord\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if ([:len [/ip dhcp-server lease find mac-address=\$leaseActMAC a\
    nd !disabled and !dynamic and address=\$leaseActIP]] != 0) do={\r\
    \n\t\t\t\t/ip firewall address-list add list=\$currentAddressList address=\
    \$leaseActIP comment=\"\$leaseNote,\$leaseInfo,\$isBlocked,Updated,\$dateM\
    \_\$timeM,\$leaseActMAC,\$leaseHostname,\$leaseParams,\$leaseRateShow,\$cu\
    rrentMessageID\"\r\
    \n\t\t\t} else={\r\
    \n\t\t\t\t/ip firewall address-list add list=\$currentAddressList address=\
    \$leaseActIP timeout=\$firewallAddressListTimeout comment=\"\$leaseNote,\$\
    leaseInfo,\$isBlocked,Updated,\$dateM \$timeM,\$leaseActMAC,\$leaseHostnam\
    e,\$leaseParams,\$leaseRateShow,\$currentMessageID\"\r\
    \n\t\t\t}\r\
    \n\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallbackLeaseC\
    ard return from \$currentAddressList\"; :log info \"teCallbackLeaseCard re\
    turn from \$currentAddressList\"}\r\
    \n\r\
    \n\t\t\t:return true\r\
    \n\t\t} else={\r\
    \n\t\t\t:local inArray false\r\
    \n\t\t\tdo {\r\
    \n\t\t\t\t:foreach k,v in=\$dbaseDynLease do={\r\
    \n\t\t\t\t\t:if (\$k = \$messageID) do={\r\
    \n\t\t\t\t\t\t:set inArray true\r\
    \n\t\t\t\t\t\t:error message=\"Record found in leaseArray\"\r\
    \n\t\t\t\t\t}\r\
    \n\t\t\t\t}\r\
    \n\t\t\t} on-error={:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCa\
    llbackLeaseCard Record found in leaseArray\"; :log warning \"teCallbackLea\
    seCard Record found in leaseArray\"}}\r\
    \n\r\
    \n\t\t\t:if (\$inArray) do={\r\
    \n\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallbackLeas\
    eCard commandName=\$commandName\"; :log info \"teCallbackLeaseCard command\
    Name=\$commandName\"}\r\
    \n\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"leasedelete\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:set answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAnsw\
    erText=\\\" \\\"\"\r\
    \n\t\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t\t:local deleteRequest \$commandValue\r\
    \n\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallbackLeas\
    eCard deleteRequest=\$deleteRequest\"; :log info \"teCallbackLeaseCard del\
    eteRequest=\$deleteRequest\"}\r\
    \n\r\
    \n\t\t\t\t:local NB \",\"\r\
    \n\t\t\t\t:local NL \"\\5D,\\5B\"\r\
    \n\r\
    \n\t\t\t\t:local pictDelete \"\\F0\\9F\\97\\91\"\r\
    \n\t\t\t\t:local buttonDeleteCallBackText \"teCallbackLeaseCard,delete,req\
    uest\"\r\
    \n\t\t\t\t:local buttonDelete [\$teBuildButton fPictButton=\$pictDelete fT\
    extButton=\"  Delete\?\" fTextCallBack=\$buttonDeleteCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t:local buttonYesCallBackText \"teCallbackLeaseCard,delete,true\"\
    \r\
    \n\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextBut\
    ton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t:local buttonNoCallBackText \"teCallbackLeaseCard,delete,false\"\
    \r\
    \n\t\t\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextButto\
    n=\"  No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t\t\t:if (\$deleteRequest = \"request\") do={\r\
    \n\t\t\t\t\t:local lineButtons \"\$buttonDelete\$NL\$buttonYes\$NB\$button\
    No\"\r\
    \n\t\t\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$lineB\
    uttons fReplyKeyboard=false]\r\
    \n\t\t\t\t\t\$teEditMessageReplyMarkup fChatID=\$queryChatID fMessageID=\$\
    messageID fReplyMarkup=\$replyMarkup\r\
    \n\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (\$deleteRequest = \"true\") do={\r\
    \n\t\t\t\t\t:if (\$fDBGteCallbackLeaseCard = true) do={:put \"teCallbackLe\
    aseCard deleteting MSG=\$messageID\"; :log info \"teCallbackLeaseCard  del\
    eteting MSG=\$messageID\"}\r\
    \n\r\
    \n\t\t\t\t\t:set (\$dbaseDynLease->\$messageID)\r\
    \n\t\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$messageID\
    \_fUserName=\$userName\r\
    \n\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (\$deleteRequest = \"false\") do={\r\
    \n\t\t\t\t\t:local pictWaiting \"\\F0\\9F\\95\\93\"\r\
    \n\t\t\t\t\t:local buttonWaitingCallBackText \"teCallbackLeaseCard,waiting\
    ,request\"\r\
    \n\t\t\t\t\t:local buttonWaiting [\$teBuildButton fPictButton=\$pictWaitin\
    g fTextButton=\"  Waiting...\" fTextCallBack=\$buttonWaitingCallBackText]\
    \r\
    \n\r\
    \n\t\t\t\t\t:local lineButtons \"\$buttonWaiting\"\r\
    \n\t\t\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$lineB\
    uttons fReplyKeyboard=false]\r\
    \n\r\
    \n\t\t\t\t\t\$teEditMessageReplyMarkup fChatID=\$queryChatID fMessageID=\$\
    messageID fReplyMarkup=\$replyMarkup\r\
    \n\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\r\
    \n\t\t\t} else={\r\
    \n\t\t\t\t:local errorMessage \"\$pictAnswerCallback Record not found in t\
    he Address Lists, deleting...\"\r\
    \n\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$errorMe\
    ssage fAlert=true\r\
    \n\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$messageID f\
    UserName=\$userName\r\
    \n\t\t\t\t:return true\r\
    \n\t\t\t}\r\
    \n\t\t}\r\
    \n\t} on-error={\r\
    \n\t\t:put \"teCallbackLeaseCard return ERROR\"; :log info \"teCallbackLea\
    seCard return ERROR\"\r\
    \n\t\t:return false\r\
    \n\t}\r\
    \n"
