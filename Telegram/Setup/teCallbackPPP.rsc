# sep/15/2022 13:47:04 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=teCallbackPppCard]] != 0) do={ remove teCallbackPppCard }
add dont-require-permissions=no name=teCallbackPppCard owner=xenon007 policy=\
    ftp,read,write,policy,test,sensitive source="#----------------------------\
    -----------------------teCallbackPppCard----------------------------------\
    ----------------------------\r\
    \n#\t\tClick event handler for PPP\r\
    \n\r\
    \n#\t\tqueryChatID\t\t-\t\tchat id\r\
    \n#\t\tuserChatID\t\t-\t\tuser id\r\
    \n#\t\tmessageID\t\t\t-\t\tmessage id\r\
    \n#\t\tqueryID\t\t\t\t-\t\tquery id\r\
    \n#\t\tuserName\t\t\t-\t\ttelegram user name\r\
    \n#\t\tfpppName\t\t\t-\t\tppp user name\r\
    \n\r\
    \n\r\
    \n#\t\tcommandName\t\t-\t\tcommand name\r\
    \n#\t\tcommandValue\t-\t\tcommand value\r\
    \n#   fromRun       -   OK\r\
    \n\r\
    \n#---------------------------------------------------teCallbackPppCard---\
    -----------------------------------------------------------\r\
    \n\r\
    \n\t:global teDebugCheck\r\
    \n\t:local fDBGteCallbackPppCard [\$teDebugCheck fDebugVariableName=\"fDBG\
    teCallbackPppCard\"]\r\
    \n\r\
    \n\t:global dbaseVersion\r\
    \n\t:local teCallbackPppCardVersion \"2.15.9.22\"\r\
    \n\t:set (\$dbaseVersion->\"teCallbackPppCard\") \$teCallbackPppCardVersio\
    n\r\
    \n\r\
    \n\t:global teEditMessageReplyMarkup\r\
    \n\t:global teAnswerCallbackQuery\r\
    \n\t:global teDeleteMessage\r\
    \n\t:global teBuildKeyboard\r\
    \n\t:global teBuildButton\r\
    \n\r\
    \n\t:global teGenValue\r\
    \n\t:global teRightsControl\r\
    \n\t:global tePppCard\r\
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
    \n\t:local currentRecord []\r\
    \n\t:local currentTimestat \"\$dateM \$timeM\"\r\
    \n\t:local commentArray []\r\
    \n\t:local pictAnswerCallback \"\\E2\\9D\\97\"\r\
    \n\t:local accessDeniedMessage \"\$pictAnswerCallback For user \$userName \
    - Access denied \"\r\
    \n\r\
    \n\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCard begi\
    n....\"; :log info \"teCallbackPppCard begin....\"}\r\
    \n\r\
    \n\tdo {\r\
    \n\r\
    \n\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRightName\
    =\"pppread\"] = false) do={\r\
    \n\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$accessDen\
    iedMessage fAlert=true\r\
    \n\t\t\t:return false\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCard fr\
    omRun=\$fromRun\"; :log info \"teCallbackPppCard fromRun=\$fromRun\"}\r\
    \n\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCard fp\
    ppName=\$fpppName\"; :log info \"teCallbackPppCard fpppName=\$fpppName\"}\
    \r\
    \n\r\
    \n\t\t:local currentMessageID \"MSG=\$messageID\"\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCard cu\
    rrentMessageID=\$currentMessageID\"; :log info \"teCallbackPppCard current\
    MessageID=\$currentMessageID\"}\r\
    \n\r\
    \n\t\t:local recordsArray [/ppp secret find comment~\"\$currentMessageID\"\
    ]\r\
    \n\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCard re\
    cordsArray=\$recordsArray\"; :log info \"teCallbackPppCard recordsArray=\$\
    recordsArray\"}\r\
    \n\r\
    \n\t\t:local pppName []\r\
    \n\t\t:if ([:len \$recordsArray] != 0) do={\r\
    \n\t\t\t:foreach i in=\$recordsArray do={\r\
    \n\t\t\t\t:local recordMessageID [:toarray [/ppp secret get [find .id=\$i]\
    \_comment]]\r\
    \n\t\t\t\t:if ((\$recordMessageID->1) = \$currentMessageID) do={:set curre\
    ntRecord \$i}\r\
    \n\t\t\t}\r\
    \n\t\t\t:set pppName [/ppp secret get [find .id=\$currentRecord] name]\r\
    \n\t\t} else={\r\
    \n\t\t\t:set pppName \$fpppName\r\
    \n\t\t\t:set currentRecord [/ppp secret find name=\$fpppName]\r\
    \n\t\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCard \
    currentRecord=\$currentRecord\"; :log info \"teCallbackPppCard currentReco\
    rd=\$currentRecord\"}\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCard pp\
    pName=\$pppName\"; :log info \"teCallbackPppCard pppName=\$pppName\"}\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCard cu\
    rrentRecord=\$currentRecord\"; :log info \"teCallbackPppCard currentRecord\
    =\$currentRecord\"}\r\
    \n\t\t:if ([:len \$currentRecord] = 0) do={:return [error message=\"teCall\
    backPppCard: record not found\"]}\r\
    \n\r\
    \n\r\
    \n\t\t:if ([:len \$currentRecord] != 0) do={\r\
    \n\r\
    \n\t\t\t:local pppInfo []\r\
    \n\t\t\t:set commentArray [:toarray [ppp secret get number=\$currentRecord\
    \_comment]]\r\
    \n\r\
    \n\t\t\t:if ([:len \$commentArray] != 0) do={\r\
    \n\t\t\t\t:set pppInfo (\$commentArray->0)\r\
    \n\t\t\t\t:set currentMessageID (\$commentArray->1)\r\
    \n\r\
    \n\t\t\t\t:if (\$fDBGteCallbackPppCard = true) do={\r\
    \n\t\t\t\t\t:foreach i in=\$commentArray do={:log info \"\$i - type of ite\
    m:\$([:typeof \$i])\"}\r\
    \n\t\t\t\t\t:put \$commentArray; :log info \$commentArray\r\
    \n\t\t\t\t}\r\
    \n\t\t\t} else={ :set pppInfo false }\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"pppInfo\") do={\r\
    \n\t\t\t\t:set pppInfo \$commandValue\r\
    \n\t\t\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCar\
    d pppInfo=\$pppInfo\"; :log info \"teCallbackPppCard pppInfo=\$pppInfo\"}\
    \r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"pppDisable\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"pppwrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (\$commandValue = true) do={\t/ppp secret set number=\$curre\
    ntRecord disabled=yes\t}\r\
    \n\t\t\t\t:if (\$commandValue = false) do={ /ppp secret set number=\$curre\
    ntRecord disabled=no\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"delete\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"pppdelete\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAn\
    swerText=\\\" \\\" fAlert=false\"\r\
    \n\t\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t\t:local deleteRequest \$commandValue\r\
    \n\r\
    \n\t\t\t\t:local pictDelete \"\\F0\\9F\\97\\91\"\r\
    \n\t\t\t\t:local buttonDeleteCallBackText \"teCallbackPppCard,delete,reque\
    st\"\r\
    \n\t\t\t\t:local buttonDelete [\$teBuildButton fPictButton=\$pictDelete fT\
    extButton=\"  Delete\?\" fTextCallBack=\$buttonDeleteCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t:local buttonYesCallBackText \"teCallbackPppCard,delete,true\"\r\
    \n\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextBut\
    ton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t:local buttonNoCallBackText \"teCallbackPppCard,delete,false\"\r\
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
    \n\t\t\t\t\t:if ([/ppp active find name=\"\$pppName\"]) do={\t/ppp active \
    remove [find name=\"\$pppName\"]\t}\r\
    \n\t\t\t\t\t/ppp secret remove number=\$currentRecord\r\
    \n\t\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$messageID\
    \_fUserName=\$userName\r\
    \n\t\t\t\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppC\
    ard message \$messageID is deleted\"; :log info \"teCallbackPppCard messag\
    e \$messageID is deleted\"}\r\
    \n\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"disconnect\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"pppwrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=True\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAn\
    swerText=\\\" \\\" fAlert=false\"\r\
    \n\t\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t\t:local disconnectRequest \$commandValue\r\
    \n\r\
    \n\t\t\t\t:local pictDisconnect \"\\F0\\9F\\94\\98\"\r\
    \n\t\t\t\t:local buttonDisconnectCallBackText \"teCallbackPppCard,disconne\
    ct,request\"\r\
    \n\t\t\t\t:local buttonDisconnect [\$teBuildButton fPictButton=\$pictDisco\
    nnect fTextButton=\"  Disconnect and disable\?\" fTextCallBack=\$buttonDis\
    connectCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t:local buttonYesCallBackText \"teCallbackPppCard,disconnect,true\
    \"\r\
    \n\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextBut\
    ton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t:local buttonNoCallBackText \"teCallbackPppCard,disconnect,false\
    \"\r\
    \n\t\t\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextButto\
    n=\"  No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t\t\t:if (\$disconnectRequest = \"request\") do={\r\
    \n\t\t\t\t\t:local lineButtons \"\$buttonDisconnect\$NL\$buttonYes\$NB\$bu\
    ttonNo\"\r\
    \n\t\t\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$lineB\
    uttons fReplyKeyboard=false]\r\
    \n\t\t\t\t\t\$teEditMessageReplyMarkup fChatID=\$queryChatID fMessageID=\$\
    messageID fReplyMarkup=\$replyMarkup\r\
    \n\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (\$disconnectRequest = \"true\") do={\r\
    \n\t\t\t\t\t/ppp secret set number=\$currentRecord disabled=yes\r\
    \n\t\t\t\t\t/ppp active remove [find name=\"\$pppName\"]\r\
    \n\t\t\t\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppC\
    ard \$pppName is disconnected\"; :log info \"teCallbackPppCard \$pppName i\
    s disconnected\"}\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"chngPass\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"pppwrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=True\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAn\
    swerText=\\\" \\\" fAlert=false\"\r\
    \n\t\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t\t:local changePassRequest \$commandValue\r\
    \n\r\
    \n\t\t\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCar\
    d command=\$commandName\"; :log info \"teCallbackPppCard command=\$command\
    Name\"}\r\
    \n\r\
    \n\t\t\t\t:local pictChangePass \"\\F0\\9F\\8E\\B2\"\r\
    \n\t\t\t\t:local buttonChangePassCallBackText \"teCallbackPppCard,chngPass\
    ,request\"\r\
    \n\t\t\t\t:local buttonChangePass [\$teBuildButton fPictButton=\$pictChang\
    ePass fTextButton=\"  Change password\?\" fTextCallBack=\$buttonChangePass\
    CallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t:local buttonYesCallBackText \"teCallbackPppCard,chngPass,true\"\
    \r\
    \n\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextBut\
    ton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t:local buttonNoCallBackText \"teCallbackPppCard,chngPass,false\"\
    \r\
    \n\t\t\t\t:local buttonNo [\$teBuildButton fPictButton=\$pictNo fTextButto\
    n=\"  No\" fTextCallBack=\$buttonNoCallBackText]\r\
    \n\r\
    \n\t\t\t\t:if (\$changePassRequest = \"request\") do={\r\
    \n\t\t\t\t\t:local lineButtons \"\$buttonChangePass\$NL\$buttonYes\$NB\$bu\
    ttonNo\"\r\
    \n\t\t\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$lineB\
    uttons fReplyKeyboard=false]\r\
    \n\t\t\t\t\t\$teEditMessageReplyMarkup fChatID=\$queryChatID fMessageID=\$\
    messageID fReplyMarkup=\$replyMarkup\r\
    \n\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (\$changePassRequest = \"true\") do={\r\
    \n\t\t\t\t\t:set newSecret [\$teGenValue fValueLen=\$newSecretLen fDigits=\
    on fUpperAlpha=on fLowerAlpha=on fUnique=on]\r\
    \n\t\t\t\t\t/ppp secret set number=\$currentRecord password=\$newSecret\r\
    \n\t\t\t\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppC\
    ard new password is set for \$currentMessageID\"; :log info \"teCallbackPp\
    pCard new password is set for \$currentMessageID\"}\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:local answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAnsw\
    erText=\\\" \\\" fAlert=false\"\r\
    \n\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t:if (\$fDBGteCallbackPppCard = true) do={:put \"teCallbackPppCard \
    messageID=\$messageID\"; :log info \"teCallbackPppCard messageID=\$message\
    ID\"}\r\
    \n\t\t\t:set \$messageID [\$tePppCard fChatID=\$queryChatID fMessageID=\$m\
    essageID fpppName=\$pppName fpppInfo=\$pppInfo fnewSecret=\$newSecret]\r\
    \n\t\t\t:if (\$messageID != 0) do={\r\
    \n\t\t\t\t/ppp secret set number=\$currentRecord comment=\"\$pppInfo,MSG=\
    \$messageID\"\r\
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
    \n\t\t:put \"teCallbackPppCard return ERROR\"; :log info \"teCallbackPppCa\
    rd return ERROR\"\r\
    \n\t\t:return false\r\
    \n\t}\r\
    \n"
