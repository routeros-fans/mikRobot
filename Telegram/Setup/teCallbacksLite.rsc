# aug/01/2022 14:21:02 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=teCallbackIfaceCard]] != 0) do={ remove teCallbackIfaceCard }
add dont-require-permissions=no name=teCallbackIfaceCard owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teCallbackIfaceCard------------------------------------------\
    --------------------\r\
    \n#\t\tClick event handler for Interfaces\r\
    \n\r\
    \n#\t\tqueryChatID\t\t-\t\tchat id\r\
    \n#\t\tuserChatID\t\t-\t\tuser id\r\
    \n#\t\tmessageID\t\t\t-\t\tmessage id\r\
    \n#\t\tqueryID\t\t\t\t-\t\tquery id\r\
    \n#\t\tuserName\t\t\t-\t\ttelegram user name\r\
    \n\r\
    \n#\t\tcommandName\t\t-\t\tcommand name\r\
    \n#\t\tcommandValue\t-\t\tcommand value\r\
    \n\r\
    \n#---------------------------------------------------teCallbackIfaceCard-\
    -------------------------------------------------------------\r\
    \n\r\
    \n\t:global teDebugCheck\r\
    \n\t:local fDBGteCallbackIfaceCard [\$teDebugCheck fDebugVariableName=\"fD\
    BGteCallbackIfaceCard\"]\r\
    \n\r\
    \n\t:global dbaseVersion\r\
    \n\t:local teCallbackIfaceCardVersion \"2.24.8.22\"\r\
    \n\t:set (\$dbaseVersion->\"teCallbackIfaceCard\") \$teCallbackIfaceCardVe\
    rsion\r\
    \n\r\
    \n\t:global teEditMessageReplyMarkup\r\
    \n\t:global teAnswerCallbackQuery\r\
    \n\t:global teDeleteMessage\r\
    \n\t:global teBuildKeyboard\r\
    \n\t:global teBuildButton\r\
    \n\r\
    \n\t:global teRightsControl\r\
    \n\t:global teIfaceCard\r\
    \n\t:global teGenValue\r\
    \n\r\
    \n\t:global teGetDate\r\
    \n\t:global teGetTime\r\
    \n\t:local dateM [\$teGetDate]\r\
    \n\t:local timeM [\$teGetTime]\r\
    \n\r\
    \n\t:local newSecret []\r\
    \n\t:local newSecretLen 10\r\
    \n\r\
    \n\t:local NB \",\"\r\
    \n\t:local NL \"\\5D,\\5B\"\r\
    \n\t:local currentMessageID \"MSG=\$messageID\"\r\
    \n\t:local currentRecord []\r\
    \n\t:local currentTimestat \"\$dateM \$timeM\"\r\
    \n\t:local commentArray []\r\
    \n\t:local pictAnswerCallback \"\\E2\\9D\\97\"\r\
    \n\t:local accessDeniedMessage \"\$pictAnswerCallback For user \$userName \
    - Access denied \"\r\
    \n\t:local answer []\r\
    \n\t:local newKey []\r\
    \n\r\
    \n\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfaceCard \
    begin....\"; :log info \"teCallbackIfaceCard begin....\"}\r\
    \n\r\
    \n\tdo {\r\
    \n\r\
    \n\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRightName\
    =\"ifaceread\"] = false) do={\r\
    \n\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$accessDen\
    iedMessage fAlert=true\r\
    \n\t\t\t:return false\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfaceCar\
    d currentMessageID=\$currentMessageID\"; :log info \"teCallbackIfaceCard c\
    urrentMessageID=\$currentMessageID\"}\r\
    \n\r\
    \n\t\t:local recordsArray [/interface find comment~\"\$currentMessageID\"]\
    \r\
    \n\t\t:foreach i in=\$recordsArray do={\r\
    \n\t\t\t:local recordMessageID [:toarray [/interface get [find .id=\$i] co\
    mment]]\r\
    \n\t\t\t:if ((\$recordMessageID->2) = \$currentMessageID) do={:set current\
    Record \$i}\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if ([:len \$currentRecord] = 0) do={:return [error message=\"teCall\
    backIfaceCard: record not found\"]}\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfaceCar\
    d currentRecord=\$currentRecord\"; :log info \"teCallbackIfaceCard current\
    Record=\$currentRecord\"}\r\
    \n\r\
    \n\t\t:if ([:len \$currentRecord] != 0) do={\r\
    \n\t\t\t:set commentArray [:toarray [interface get number=\$currentRecord \
    comment]]\r\
    \n\r\
    \n\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={\r\
    \n\t\t\t\t:foreach i in=\$commentArray do={:log info \"\$i - type of item:\
    \$([:typeof \$i])\"}\r\
    \n\t\t\t\t:put \$commentArray; :log info \$commentArray\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:local ifaceNote (\$commentArray->0)\r\
    \n\t\t\t:local ifaceInfo (\$commentArray->1)\r\
    \n\t\t\t:set currentMessageID (\$commentArray->2)\r\
    \n\t\t\t:local ifaceName [/interface get number=\$currentRecord name]\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"ifaceInfo\") do={\r\
    \n\t\t\t\t:set ifaceInfo \$commandValue\r\
    \n\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfac\
    eCard ifaceInfo=\$ifaceInfo\"; :log info \"teCallbackIfaceCard ifaceInfo=\
    \$ifaceInfo\"}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"ifaceDisable\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"ifacewrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (\$commandValue = true) do={\t/interface set number=\$curren\
    tRecord disabled=yes\t}\r\
    \n\t\t\t\t:if (\$commandValue = false) do={ /interface set number=\$curren\
    tRecord disabled=no\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"virtualAdd\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"ifacewrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local ifaceArray [interface wireless print as-value where name=\
    \$commandValue]\r\
    \n\t\t\t\t:local ifaceCount [interface wireless print as-value count-only]\
    \r\
    \n\t\t\t\t:local newMtu (\$ifaceArray->0->\"mtu\")\r\
    \n\t\t\t\t:local newL2Mtu (\$ifaceArray->0->\"l2mtu\")\r\
    \n\t\t\t\t:local newArp (\$ifaceArray->0->\"arp\")\r\
    \n\t\t\t\t:local newMode (\$ifaceArray->0->\"mode\")\r\
    \n\t\t\t\t:local newSsid (\$commandValue . \"Virtual\" . (\$ifaceCount + 1\
    ))\r\
    \n\t\t\t\t:local newName \$newSsid\r\
    \n\t\t\t\t:local masterIface \$commandValue\r\
    \n\t\t\t\t:local newSecurityProfile (\$ifaceArray->0->\"security-profile\"\
    )\r\
    \n\t\t\t\t:local newVlanMode (\$ifaceArray->0->\"vlan-mode\")\r\
    \n\t\t\t\t:local newVlanID (\$ifaceArray->0->\"vlan-id\")\r\
    \n\t\t\t\t:local newDefaultAuth (\$ifaceArray->0->\"default-authentication\
    \")\r\
    \n\t\t\t\t:local newDefaultForward (\$ifaceArray->0->\"default-forwarding\
    \")\r\
    \n\t\t\t\t:local newHideSsid (\$ifaceArray->0->\"hide-ssid\")\r\
    \n\t\t\t\t:local newWdsMode (\$ifaceArray->0->\"wds-mode\")\r\
    \n\t\t\t\t:local newWdsBridge (\$ifaceArray->0->\"wds-default-bridge\")\r\
    \n\r\
    \n\t\t\t\t:local newVirtualResult [/interface wireless add name=\$newName \
    mtu=\$newMtu l2mtu=\$newL2Mtu arp=\$newArp mode=\$newMode ssid=\$newSsid m\
    aster-interface=\$masterIface\tsecurity-profile=\$newSecurityProfile vlan-\
    mode=\$newVlanMode vlan-id=\$newVlanID default-authentication=\$newDefault\
    Auth default-forwarding=\$newDefaultForward hide-ssid=\$newHideSsid wds-mo\
    de=\$newWdsMode wds-default-bridge=\$newWdsBridge disabled=no]\r\
    \n\r\
    \n\t\t\t\t:if ([:len \$newVirtualResult] != 0) do={\r\
    \n\t\t\t\t\t:local answerSucces \"\$newName added succesfully\"\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$answe\
    rSucces fAlert=true\r\
    \n\t\t\t\t\t:return true\r\
    \n\t\t\t\t} else={\r\
    \n\t\t\t\t\t:local answerFail \"\$pictAnswerCallback Adding failed\"\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$answe\
    rFail fAlert=true\r\
    \n\t\t\t\t\t:error message=\"Adding failed\"\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"vlanDelete\") do={\r\
    \n\r\
    \n\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfac\
    eCard commandName=\$commandName\"; :log info \"teCallbackIfaceCard command\
    Name=\$commandName\"}\r\
    \n\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"ifacedelete\"] = false) do={\r\
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
    \n\r\
    \n\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfac\
    eCard deleteRequest=\$deleteRequest\"; :log info \"teCallbackIfaceCard del\
    eteRequest=\$deleteRequest\"}\r\
    \n\r\
    \n\t\t\t\t:local NB \",\"\r\
    \n\t\t\t\t:local NL \"\\5D,\\5B\"\r\
    \n\r\
    \n\t\t\t\t:local pictDelete \"\\F0\\9F\\97\\91\"\r\
    \n\t\t\t\t:local buttonDeleteCallBackText \"teCallbackIfaceCard,vlanDelete\
    ,request\"\r\
    \n\t\t\t\t:local buttonDelete [\$teBuildButton fPictButton=\$pictDelete fT\
    extButton=\"  Delete\?\" fTextCallBack=\$buttonDeleteCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t:local buttonYesCallBackText \"teCallbackIfaceCard,vlanDelete,tr\
    ue\"\r\
    \n\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextBut\
    ton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t:local buttonNoCallBackText \"teCallbackIfaceCard,vlanDelete,fal\
    se\"\r\
    \n\t\t\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextButto\
    n=\"  No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t\t\t:if (\$deleteRequest = \"request\") do={\r\
    \n\r\
    \n\t\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIf\
    aceCard deleteRequest=\$deleteRequest\"; :log info \"teCallbackIfaceCard d\
    eleteRequest=\$deleteRequest\"}\r\
    \n\r\
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
    \n\t\t\t\t\t\t/interface vlan remove \$ifaceName\r\
    \n\t\t\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$message\
    ID fUserName=\$userName\r\
    \n\t\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"virtualDelete\") do={\r\
    \n\r\
    \n\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfac\
    eCard commandName=\$commandName\"; :log info \"teCallbackIfaceCard command\
    Name=\$commandName\"}\r\
    \n\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"ifacedelete\"] = false) do={\r\
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
    \n\r\
    \n\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfac\
    eCard deleteRequest=\$deleteRequest\"; :log info \"teCallbackIfaceCard del\
    eteRequest=\$deleteRequest\"}\r\
    \n\r\
    \n\t\t\t\t:local NB \",\"\r\
    \n\t\t\t\t:local NL \"\\5D,\\5B\"\r\
    \n\r\
    \n\t\t\t\t:local pictDelete \"\\F0\\9F\\97\\91\"\r\
    \n\t\t\t\t:local buttonDeleteCallBackText \"teCallbackIfaceCard,virtualDel\
    ete,request\"\r\
    \n\t\t\t\t:local buttonDelete [\$teBuildButton fPictButton=\$pictDelete fT\
    extButton=\"  Delete\?\" fTextCallBack=\$buttonDeleteCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t:local buttonYesCallBackText \"teCallbackIfaceCard,virtualDelete\
    ,true\"\r\
    \n\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextBut\
    ton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t:local buttonNoCallBackText \"teCallbackIfaceCard,virtualDelete,\
    false\"\r\
    \n\t\t\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextButto\
    n=\"  No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t\t\t:if (\$deleteRequest = \"request\") do={\r\
    \n\r\
    \n\t\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIf\
    aceCard deleteRequest=\$deleteRequest\"; :log info \"teCallbackIfaceCard d\
    eleteRequest=\$deleteRequest\"}\r\
    \n\r\
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
    \n\t\t\t\t\t\t/interface wireless remove \$ifaceName\r\
    \n\t\t\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$message\
    ID fUserName=\$userName\r\
    \n\t\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"changeKey\") do={\r\
    \n\r\
    \n\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfac\
    eCard commandName=\$commandName\"; :log info \"teCallbackIfaceCard command\
    Name=\$commandName\"}\r\
    \n\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"ifacewrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:set answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAnsw\
    erText=\\\" \\\"\"\r\
    \n\t\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t\t:local changeRequest \$commandValue\r\
    \n\r\
    \n\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIfac\
    eCard changeRequest=\$changeRequest\"; :log info \"teCallbackIfaceCard cha\
    ngeRequest=\$changeRequest\"}\r\
    \n\r\
    \n\t\t\t\t:local NB \",\"\r\
    \n\t\t\t\t:local NL \"\\5D,\\5B\"\r\
    \n\r\
    \n\t\t\t\t:local pictChangeKey \"\\F0\\9F\\94\\91\"\r\
    \n\t\t\t\t:local buttonChangeKeyCallBackText \"teCallbackIfaceCard,changeK\
    ey,request\"\r\
    \n\t\t\t\t:local buttonChangeKey [\$teBuildButton fPictButton=\$pictChange\
    Key fTextButton=\" Change Wi-Fi key\?\" fTextCallBack=\$buttonChangeKeyCal\
    lBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t:local buttonYesCallBackText \"teCallbackIfaceCard,changeKey,tru\
    e\"\r\
    \n\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextBut\
    ton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t:local buttonNoCallBackText \"teCallbackIfaceCard,changeKey,fals\
    e\"\r\
    \n\t\t\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextButto\
    n=\"  No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t\t\t:if (\$changeRequest = \"request\") do={\r\
    \n\r\
    \n\t\t\t\t\t:if (\$fDBGteCallbackIfaceCard = true) do={:put \"teCallbackIf\
    aceCard changeRequest=\$changeRequest\"; :log info \"teCallbackIfaceCard c\
    hangeRequest=\$changeRequest\"}\r\
    \n\r\
    \n\t\t\t\t\t:local lineButtons \"\$buttonChangeKey\$NL\$buttonYes\$NB\$but\
    tonNo\"\r\
    \n\t\t\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$lineB\
    uttons fReplyKeyboard=false]\r\
    \n\t\t\t\t\t\$teEditMessageReplyMarkup fChatID=\$queryChatID fMessageID=\$\
    messageID fReplyMarkup=\$replyMarkup\r\
    \n\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (\$changeRequest = \"true\") do={\r\
    \n\r\
    \n\t\t\t\t\t:local securityProfile [interface wireless get \$ifaceName sec\
    urity-profile]\r\
    \n\t\t\t\t\t:set newKey [\$teGenValue fValueLen=20 fDigits=on fUpperAlpha=\
    on fLowerAlpha=on fUnique=on]\r\
    \n\t\t\t\t\t:local currentKey [interface wireless security-profiles get \$\
    securityProfile wpa2-pre-shared-key]\r\
    \n\t\t\t\t\t:if ([:len \$currentKey] = 0) do={\r\
    \n\t\t\t\t\t\t:set currentKey [interface wireless security-profiles get \$\
    securityProfile wpa-pre-shared-key]\r\
    \n\t\t\t\t\t\tinterface wireless security-profiles set \$securityProfile w\
    pa-pre-shared-key=\$newKey\r\
    \n\t\t\t\t\t} else={\r\
    \n\t\t\t\t\t\tinterface wireless security-profiles set \$securityProfile w\
    pa2-pre-shared-key=\$newKey\r\
    \n\t\t\t\t\t}\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"changeBridge\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"ifacewrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local currentIfacePortsNumber [interface bridge port find inter\
    face=\$commandValue and !disabled]\r\
    \n\t\t\t\t:local currentIfaceBridge [interface bridge port get value-name=\
    interface number=\$currentIfacePortsNumber bridge]\r\
    \n\t\t\t\t:local allBridges [interface bridge print as-value where !disabl\
    ed]\r\
    \n\t\t\t\t:local allBridgesCount [interface bridge print as-value count-on\
    ly where !disabled]\r\
    \n\r\
    \n\t\t\t\t:local counter 1\r\
    \n\t\t\t\t:local newBridgeID []\r\
    \n\t\t\t\t:foreach i in=\$allBridges do={\r\
    \n\t\t\t\t\t:local currentBridgeName (\$i->\"name\")\r\
    \n\t\t\t\t\t:if (\$currentBridgeName = \$currentIfaceBridge) do={\r\
    \n\t\t\t\t\t\t:set newBridgeID \$counter\r\
    \n\t\t\t\t\t\t:if (\$counter = \$allBridgesCount) do={:set \$newBridgeID 0\
    }\r\
    \n\t\t\t\t\t}\r\
    \n\t\t\t\t\t:set \$counter (\$counter + 1)\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local newBridgeName ((\$allBridges->\$newBridgeID)->\"name\")\r\
    \n\t\t\t\t/interface bridge port set numbers=\$currentIfacePortsNumber bri\
    dge=\$newBridgeName\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"changeProf\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"ifacewrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local currentIfaceProf [interface wireless get number=\$current\
    Record security-profile]\r\
    \n\t\t\t\t:local allProfiles [interface wireless security-profiles print a\
    s-value]\r\
    \n\t\t\t\t:local allProfilesCount [interface wireless security-profiles pr\
    int as-value count-only]\r\
    \n\r\
    \n\t\t\t\t:local counter 1\r\
    \n\t\t\t\t:local newProfileID []\r\
    \n\t\t\t\t:foreach i in=\$allProfiles do={\r\
    \n\t\t\t\t\t:local currentIfaceName (\$i->\"name\")\r\
    \n\t\t\t\t\t:if (\$currentIfaceName = \$currentIfaceProf) do={\r\
    \n\t\t\t\t\t\t:set newProfileID \$counter\r\
    \n\t\t\t\t\t\t:if (\$counter = \$allProfilesCount) do={:set \$newProfileID\
    \_0}\r\
    \n\t\t\t\t\t}\r\
    \n\t\t\t\t\t:set \$counter (\$counter + 1)\r\
    \n\t\t\t\t}\r\
    \n\t\t\t\t:local newIfaceName ((\$allProfiles->\$newProfileID)->\"name\")\
    \r\
    \n\t\t\t\t/interface wireless set numbers=\$currentRecord security-profile\
    =\$newIfaceName\r\
    \n\t\t\t}\r\
    \n\r\
    \n\r\
    \n\t\t\t:set answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAnswer\
    Text=\\\" \\\"\"\r\
    \n\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t:set \$messageID [\$teIfaceCard fChatID=\$queryChatID fMessageID=\
    \$messageID fIfaceName=\$ifaceName fIfaceInfo=\$ifaceInfo fIfaceNote=\$ifa\
    ceNote fNewKey=\$newKey]\r\
    \n\t\t\t:if (\$messageID != 0) do={\r\
    \n\t\t\t\t/interface set number=\$currentRecord comment=\"\$ifaceNote,\$if\
    aceInfo,MSG=\$messageID\"\r\
    \n\t\t\t\t:return true\r\
    \n\t\t\t} else={:return false}\r\
    \n\t\t} else={\r\
    \n\t\t\t:local errorMessage \"\$pictAnswerCallback Record not found in Sec\
    rets, deleting...\"\r\
    \n\t\t\t:if ([\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$message\
    ID fUserName=\$userName] = 0) do={\r\
    \n\t\t\t\t:set errorMessage \"\$pictAnswerCallback Successful. Message is \
    to old, delete manually.\"\r\
    \n\t\t\t}\r\
    \n\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$errorMess\
    age fAlert=True\r\
    \n\t\t\t:return true\r\
    \n\t\t}\r\
    \n\r\
    \n\t} on-error={\r\
    \n\t\t:put \"teCallbackIfaceCard return ERROR\"; :log info \"teCallbackIfa\
    ceCard return ERROR\"\r\
    \n\t\t:return false\r\
    \n\t}\r\
    \n"
:if ([:len [find name=teCallbackRootMenu]] != 0) do={ remove teCallbackRootMenu }
add dont-require-permissions=no name=teCallbackRootMenu owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teCallbackRootMenu-------------------------------------------\
    -------------------\r\
    \n\r\
    \n#\t\tqueryChatID\t\t-\t\tchat id\r\
    \n#\t\tuserChatID\t\t-\t\tuser id\r\
    \n#\t\tmessageID\t\t\t-\t\tmessage id\r\
    \n#\t\tqueryID\t\t\t\t-\t\tquery id\r\
    \n#\t\tuserName\t\t\t-\t\ttelegram user name\r\
    \n#\t\tuserLang\t\t\t-\t\ttelegram user language\r\
    \n\r\
    \n#\t\tcommandName\t\t-\t\tcommand name\r\
    \n#\t\tcommandValue\t-\t\tcommand value\r\
    \n\r\
    \n#---------------------------------------------------teCallbackRootMenu--\
    ------------------------------------------------------------\r\
    \n\r\
    \n\t:global teDebugCheck\r\
    \n\t:local fDBGteCallbackRootMenu [\$teDebugCheck fDebugVariableName=\"fDB\
    GteCallbackRootMenu\"]\r\
    \n\r\
    \n\t:global dbaseBotSettings\r\
    \n\t:global dbaseVersion\r\
    \n\t:local teCallbackRootMenuVersion \"2.30.7.22\"\r\
    \n\t:set (\$dbaseVersion->\"teCallbackRootMenu\") \$teCallbackRootMenuVers\
    ion\r\
    \n\r\
    \n\t:global teEditMessageReplyMarkup\r\
    \n\t:global teAnswerCallbackQuery\r\
    \n\r\
    \n\t:global teSendMessage\r\
    \n\t:global teSendPhoto\r\
    \n\t:global teEditCaption\r\
    \n\t:global teDeleteMessage\r\
    \n\r\
    \n\t:global teRightsControl\r\
    \n\r\
    \n\t:global teRootMenu\r\
    \n\t:global teTerminal\r\
    \n\t:global teSystemMenu\r\
    \n\t:global teModules\r\
    \n\t:global teScripts\r\
    \n\r\
    \n\t:global teGetDate\r\
    \n\t:global teGetTime\r\
    \n\t:local dateM [\$teGetDate]\r\
    \n\t:local timeM [\$teGetTime]\r\
    \n\r\
    \n\t:local oneFeed \"%0D%0A\"\r\
    \n\t:local doubleFeed \"%0D%0A%0D%0A\"\r\
    \n\t:local currentTimestat \"\$dateM \$timeM\"\r\
    \n\t:local pictAnswerCallback \"\\E2\\9D\\97\"\r\
    \n\t:local accessDeniedMessage \"\$pictAnswerCallback For user \$userName \
    - Access denied \"\r\
    \n\r\
    \n\tdo {\r\
    \n\r\
    \n\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRightName\
    =\"root\"] = false) do={\r\
    \n\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$accessDen\
    iedMessage fAlert=true\r\
    \n\t\t\t:return false\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:local answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAnswer\
    Text=\\\" \\\" fAlert=\\\"False\\\"\"\r\
    \n\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t:if (\$commandName = \"about\") do={\r\
    \n\r\
    \n\t\t\t:local eulaLink []\r\
    \n\t\t\t:local helpLink []\r\
    \n\t\t\t:if (\$userLang = \"ru\") do={\r\
    \n\t\t\t\t:set eulaLink \"<a href=\\\"https://telegra.ph/Licenzionnoe-sogl\
    ashenie-07-19\\\">EULA</a>\"\r\
    \n\t\t\t\t:set helpLink \"<a href=\\\"https://telegra.ph/Spravka-07-19-2\\\
    \">Help</a>\"\r\
    \n\t\t\t}\r\
    \n\t\t\t:local versionInfo (\"<b>Version:</b>\\t\\t\" . \"<code>\" . (\$db\
    aseVersion->\"teRootMenu\") . \"</code>\")\r\
    \n\t\t\t:local eulaInfo (\"\$doubleFeed\" . \"<b>License agreement:</b>\\t\
    \\t\" . \"\$eulaLink\")\r\
    \n\t\t\t:local helpInfo (\"\$doubleFeed\" . \"<b>User's guide:</b>\\t\\t\"\
    \_. \"\$helpLink\")\r\
    \n\t\t\t:local footerInfo (\"\$doubleFeed\" . \"--------------------------\
    --\")\r\
    \n\r\
    \n\t\t\t:local aboutInfo (\"\$versionInfo\" . \"\$eulaInfo\" . \"\$helpInf\
    o\" . \"\$footerInfo\")\r\
    \n\r\
    \n\t\t\t\$teRootMenu fChatID=\$userChatID fMessageID=\$messageID fAboutInf\
    o=\$aboutInfo\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$commandName = \"terminal\") do={\r\
    \n\t\t\t\$teTerminal fChatID=\$queryChatID fMessageID=\$messageID fCommand\
    =\$commandValue\r\
    \n\t\t\t:set (\$dbaseBotSettings->\$queryChatID) ({\"rootMessageID\"=\$mes\
    sageID})\r\
    \n\t\t\t:return true\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$commandName = \"systemInfo\") do={\r\
    \n\t\t\t\$teSystemMenu fChatID=\$queryChatID fMessageID=\$messageID fComma\
    nd=\$commandValue\r\
    \n\t\t}\r\
    \n\t\t:if (\$commandName = \"modules\") do={\r\
    \n\t\t\t\$teModules fChatID=\$queryChatID fMessageID=\$messageID fCommand=\
    \$commandValue\r\
    \n\t\t\t:return true\r\
    \n\t\t}\r\
    \n\t\t:if (\$commandName = \"scripts\") do={\r\
    \n\t\t\t\$teScripts fChatID=\$queryChatID fMessageID=\$messageID fCommand=\
    \$commandValue\r\
    \n\t\t\t:return true\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$commandName = \"backward\") do={\r\
    \n\t\t\t[:parse \":global \$commandValue; \\\$\$commandValue fChatID=\$que\
    ryChatID fMessageID=\$messageID\"]\r\
    \n\t\t\t:return true\r\
    \n\t\t}\r\
    \n\t\t:return true\r\
    \n\t\t}\r\
    \n\t} on-error={\r\
    \n\t\t:put \"teCallbackRootMenu return ERROR\"; :log info \"teCallbackRoot\
    Menu return ERROR\"\r\
    \n\t\t:return false\r\
    \n\t}\r\
    \n"
:if ([:len [find name=teCallbackScripts]] != 0) do={ remove teCallbackScripts }
add dont-require-permissions=no name=teCallbackScripts owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teCallbackScripts--------------------------------------------\
    ------------------\r\
    \n#\t\tClick event handler for Scripts\r\
    \n\r\
    \n#\t\tqueryChatID\t\t-\t\tchat id\r\
    \n#\t\tuserChatID\t\t-\t\tuser id\r\
    \n#\t\tmessageID\t\t\t-\t\tmessage id\r\
    \n#\t\tqueryID\t\t\t\t-\t\tquery id\r\
    \n#\t\tuserName\t\t\t-\t\ttelegram user name\r\
    \n\r\
    \n#\t\tcommandName\t\t-\t\tcommand name\r\
    \n#\t\tcommandValue\t-\t\tcommand value\r\
    \n\r\
    \n#---------------------------------------------------teCallbackScripts---\
    -----------------------------------------------------------\r\
    \n\r\
    \n\t:global teDebugCheck\r\
    \n\t:local fDBGteCallbackScripts [\$teDebugCheck fDebugVariableName=\"fDBG\
    teCallbackScripts\"]\r\
    \n\r\
    \n\t:global dbaseVersion\r\
    \n\t:local teCallbackScriptsVersion \"2.9.7.22\"\r\
    \n\t:set (\$dbaseVersion->\"teCallbackScripts\") \$teCallbackScriptsVersio\
    n\r\
    \n\r\
    \n\t:global teEditMessageReplyMarkup\r\
    \n\t:global teAnswerCallbackQuery\r\
    \n\t:global teBuildKeyboard\r\
    \n\t:global teBuildButton\r\
    \n\r\
    \n\t:global teRightsControl\r\
    \n\t:global teScripts\r\
    \n\r\
    \n\t:global teGetDate\r\
    \n\t:global teGetTime\r\
    \n\t:local dateM [\$teGetDate]\r\
    \n\t:local timeM [\$teGetTime]\r\
    \n\r\
    \n\t:local NB \",\"\r\
    \n\t:local NL \"\\5D,\\5B\"\r\
    \n\r\
    \n\t:local pictAnswerCallback \"\\E2\\9D\\97\"\r\
    \n\t:local accessDeniedMessage \"\$pictAnswerCallback For user \$userName \
    - Access denied \"\r\
    \n\r\
    \n\tdo {\r\
    \n\r\
    \n\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRightName\
    =\"scriptrun\"] = false) do={\r\
    \n\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$accessDen\
    iedMessage fAlert=true\r\
    \n\t\t\t:return false\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:local answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAnswer\
    Text=\\\" \\\" fAlert=false\"\r\
    \n\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackScripts = true) do={:put \"teCallbackScripts co\
    mmandName = \$commandName\"; :log info \"teCallbackScripts commandName = \
    \$commandName\"}\r\
    \n\r\
    \n\t\t:local pictRunScript \"\\F0\\9F\\93\\9D\"\r\
    \n\t\t:local buttonRunScriptCallBackText \"teCallbackScripts,\$commandName\
    ,request\"\r\
    \n\t\t:local textButton \" Run \$commandName\?\"\r\
    \n\t\t:local buttonRunScript [\$teBuildButton fPictButton=\$pictRunScript \
    fTextButton=\$textButton fTextCallBack=\$buttonRunScriptCallBackText]\r\
    \n\r\
    \n\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t:local buttonYesCallBackText \"teCallbackScripts,\$commandName,true\
    \"\r\
    \n\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextButton=\
    \"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t:local buttonNoCallBackText \"teCallbackScripts,\$commandName,false\
    \"\r\
    \n\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextButton=\"\
    \_ No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t:if (\$commandValue = \"request\") do={\r\
    \n\t\t\t:if (\$fDBGteCallbackScripts = true) do={:put \"teCallbackScripts \
    commandValue = \$commandValue\"; :log info \"teCallbackScripts commandValu\
    e = \$commandValue\"}\r\
    \n\r\
    \n\t\t\t:local lineButtons \"\$buttonRunScript\$NL\$buttonYes\$NB\$buttonN\
    o\"\r\
    \n\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$lineButto\
    ns fReplyKeyboard=false]\r\
    \n\r\
    \n\t\t\t\$teEditMessageReplyMarkup fChatID=\$queryChatID fMessageID=\$mess\
    ageID fReplyMarkup=\$replyMarkup\r\
    \n\t\t\t:return true\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:local scriptName []\r\
    \n\t\t:local scriptMessage []\r\
    \n\t\t:if (\$commandValue = true) do={\r\
    \n\t\t\t:set scriptName (\"isBot\" . \"\$commandName\")\r\
    \n\t\t\t:local scriptResult [[:parse \"/system script run [find name=\$scr\
    iptName]\"]]\r\
    \n\r\
    \n\t\t\t:if ([:len \$scriptResult] != 0) do={\r\
    \n\t\t\t\t\$teScripts fChatID=\$queryChatID fMessageID=\$messageID fCalled\
    Script=\$commandName fCallbackMsg=\$scriptResult\r\
    \n\t\t\t} else={\r\
    \n\t\t\t\t:set scriptMessage \"script is Runing\"\r\
    \n\t\t\t\t\$teScripts fChatID=\$queryChatID fMessageID=\$messageID fCalled\
    Script=\$commandName fCallbackMsg=\$scriptMessage\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:return true\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$commandValue = false) do={\r\
    \n\t\t\t:set scriptName (\"isBot\" . \"\$commandName\")\r\
    \n\t\t\t:set scriptMessage \"launch Canceled\"\r\
    \n\t\t\t:if ([\$teScripts fChatID=\$queryChatID fMessageID=\$messageID fCa\
    lledScript=\$commandName fCallbackMsg=\$scriptMessage] = 1) do={\r\
    \n\t\t\t\t:return true\r\
    \n\t\t\t} else={ :return false }\r\
    \n\t\t}\r\
    \n\r\
    \n\t} on-error={\r\
    \n\t\t:local scriptMessage \"launch Error!\"\r\
    \n\t\t\$teScripts fChatID=\$queryChatID fMessageID=\$messageID fCalledScri\
    pt=\$commandName fCallbackMsg=\$scriptMessage\r\
    \n\t\t:put \"teCallbackScripts return ERROR\"; :log info \"teCallbackScrip\
    ts return ERROR\"\r\
    \n\t\t:return false\r\
    \n\t}\r\
    \n"
:if ([:len [find name=teCallbackSystemMenu]] != 0) do={ remove teCallbackSystemMenu }
add dont-require-permissions=no name=teCallbackSystemMenu owner=xenon007 policy=\
    ftp,reboot,read,write,policy,test source="#-------------------------------\
    --------------------teCallbackSystemMenu----------------------------------\
    ----------------------------\r\
    \n#\t\tClick event handler for SystemMenu\r\
    \n\r\
    \n#\t\tqueryChatID\t\t-\t\tchat id\r\
    \n#\t\tuserChatID\t\t-\t\tuser id\r\
    \n#\t\tmessageID\t\t\t-\t\tmessage id\r\
    \n#\t\tqueryID\t\t\t\t-\t\tquery id\r\
    \n#\t\tuserName\t\t\t-\t\ttelegram user name\r\
    \n\r\
    \n#\t\tcommandName\t\t-\t\tcommand name\r\
    \n#\t\tcommandValue\t-\t\tcommand value\r\
    \n\r\
    \n#---------------------------------------------------teCallbackSystemMenu\
    --------------------------------------------------------------\r\
    \n\r\
    \n\t:global teDebugCheck\r\
    \n\t:local fDBGteCallbackSystemMenu [\$teDebugCheck fDebugVariableName=\"f\
    DBGteCallbackSystemMenu\"]\r\
    \n\r\
    \n\t:global dbaseBotSettings\r\
    \n\t:local deviceName (\$dbaseBotSettings->\"deviceName\")\r\
    \n\r\
    \n\t:global dbaseVersion\r\
    \n\t:local teCallbackSystemMenuVersion \"2.9.7.22\"\r\
    \n\t:set (\$dbaseVersion->\"teCallbackSystemMenu\") \$teCallbackSystemMenu\
    Version\r\
    \n\r\
    \n\t:global teEditMessageReplyMarkup\r\
    \n\t:global teAnswerCallbackQuery\r\
    \n\t:global teBuildKeyboard\r\
    \n\t:global teBuildButton\r\
    \n\r\
    \n\t:global teRightsControl\r\
    \n\t:global teSystemMenu\r\
    \n\r\
    \n\t:global teGetDate\r\
    \n\t:global teGetTime\r\
    \n\t:local dateM [\$teGetDate]\r\
    \n\t:local timeM [\$teGetTime]\r\
    \n\r\
    \n\t:local NB \",\"\r\
    \n\t:local NL \"\\5D,\\5B\"\r\
    \n\t:local checkUpdate false\r\
    \n\r\
    \n\t:local pictAnswerCallback \"\\E2\\9D\\97\"\r\
    \n\t:local accessDeniedMessage \"\$pictAnswerCallback For user \$userName \
    - Access denied \"\r\
    \n\r\
    \n\t:if (\$fDBGteCallbackSystemMenu = true) do={:put \"teCallbackSystemMen\
    u begin....\"; :log info \"teCallbackSystemMenu begin....\"}\r\
    \n\r\
    \n\tdo {\r\
    \n\r\
    \n\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRightName\
    =\"systemread\"] = false) do={\r\
    \n\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$accessDen\
    iedMessage\r\
    \n\t\t\t:return false\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$commandName = \"restart\") do={\r\
    \n\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRightNa\
    me=\"systemupdate\"] = false) do={\r\
    \n\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$accessD\
    eniedMessage fAlert=\"True\"\r\
    \n\t\t\t\t:return false\r\
    \n\t\t\t}\r\
    \n\t\t\t:if (\$fDBGteCallbackSystemMenu = true) do={:put \"teCallbackSyste\
    mMenu backup = \$commandName\"; :log info \"teCallbackSystemMenu backup = \
    \$commandName\"}\r\
    \n\r\
    \n\t\t\t:local restartRequest \$commandValue\r\
    \n\r\
    \n\t\t\t:local pictRestart \"\\E2\\9D\\97\"\r\
    \n\t\t\t:local buttonRestartCallBackText \"teCallbackSystemMenu,restart,re\
    quest\"\r\
    \n\t\t\t:local buttonRestart [\$teBuildButton fPictButton=\$pictRestart fT\
    extButton=\" Restart system\?\" fTextCallBack=\$buttonRestartCallBackText]\
    \r\
    \n\r\
    \n\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t:local buttonYesCallBackText \"teCallbackSystemMenu,restart,true\"\
    \r\
    \n\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextButto\
    n=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t:local buttonNoCallBackText \"teCallbackSystemMenu,restart,false\"\
    \r\
    \n\t\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextButton=\
    \"  No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t\t:if (\$restartRequest = \"request\") do={\r\
    \n\r\
    \n\t\t\t\t:local lineButtons \"\$buttonRestart\$NL\$buttonYes\$NB\$buttonN\
    o\"\r\
    \n\t\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$lineBut\
    tons fReplyKeyboard=false]\r\
    \n\r\
    \n\t\t\t\t\$teEditMessageReplyMarkup fChatID=\$queryChatID fMessageID=\$me\
    ssageID fReplyMarkup=\$replyMarkup\r\
    \n\t\t\t\t:return true\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$restartRequest = \"true\") do={\r\
    \n\t\t\t\t:local answerMessage \"\$pictAnswerCallback Router is rebooting.\
    ..\"\r\
    \n\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$answerM\
    essage fAlert=\"True\"\r\
    \n\t\t\t\t/system reboot\r\
    \n\t\t\t\t:return true\r\
    \n\t\t\t}\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$commandName = \"backup\") do={\r\
    \n\t\t\t:if (\$fDBGteCallbackSystemMenu = true) do={:put \"teCallbackSyste\
    mMenu backup = \$commandName\"; :log info \"teCallbackSystemMenu backup = \
    \$commandName\"}\r\
    \n\t\t\t/system backup save name=\"/\$deviceName_\$dateM_\$timeM\" passwor\
    d=1213123Qp\r\
    \n\t\t\t:local backupMessage \"\$pictAnswerCallback Backup completed succe\
    ssfully \"\r\
    \n\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$backupMes\
    sage fAlert=\"True\"\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$commandName = \"checkUpdate\") do={\r\
    \n\t\t\t:set checkUpdate \$commandValue\r\
    \n\t\t\t:if (\$fDBGteCallbackSystemMenu = true) do={:put \"teCallbackSyste\
    mMenu checkUpdate = \$checkUpdate\"; :log info \"teCallbackSystemMenu chec\
    kUpdate = \$checkUpdate\"}\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:local statusUpdate false\r\
    \n\t\t:if (\$commandName = \"update\") do={\r\
    \n\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRightNa\
    me=\"systemupdate\"] = false) do={\r\
    \n\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$accessD\
    eniedMessage fAlert=\"True\"\r\
    \n\t\t\t\t:return false\r\
    \n\t\t\t}\r\
    \n\t\t\t:set statusUpdate ([/system package update download as-value]->\"s\
    tatus\")\r\
    \n\t\t\t:if (\$statusUpdate~\"Downloaded\") do={ :set statusUpdate \"downl\
    oaded\" }\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:local answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAnswer\
    Text=\\\" \\\" fAlert=false\"\r\
    \n\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t:if ([\$teSystemMenu fChatID=\$queryChatID fMessageID=\$messageID fC\
    heckUpdate=\$checkUpdate fQueryID=\$queryID fDownloadStatus=\$statusUpdate\
    ] != 0) do={\r\
    \n\t\t\t:if (\$fDBGteCallbackSystemMenu = true) do={:put \"teCallbackSyste\
    mMenu teSystemMenu return 1\"; :log info \"teCallbackSystemMenu teSystemMe\
    nu return 1\"}\r\
    \n\t\t\t:return true\r\
    \n\t\t} else={:return false}\r\
    \n\r\
    \n\t} on-error={\r\
    \n\t\t:put \"teCallbackSystemMenu return ERROR\"; :log info \"teCallbackSy\
    stemMenu return ERROR\"\r\
    \n\t\t:return false\r\
    \n\t}\r\
    \n"
