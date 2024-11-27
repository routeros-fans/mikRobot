/system script
:if ([:len [find name=teCallbackUsersCard]] != 0) do={ remove teCallbackUsersCard }
add dont-require-permissions=no name=teCallbackUsersCard owner=admin policy=\
    ftp,read,write,policy,test,password source="#-----------------------------\
    ----------------------teCallbackUsersCard---------------------------------\
    -----------------------------\r\
    \n#\t\tClick event handler for Users\r\
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
    \n#---------------------------------------------------teCallbackUsersCard-\
    -------------------------------------------------------------\r\
    \n\r\
    \n\t:global teDebugCheck\r\
    \n\t:local fDBGteCallbackUserCard [\$teDebugCheck fDebugVariableName=\"fDB\
    GteCallbackUserCard\"]\r\
    \n\r\
    \n\t:global dbaseVersion\r\
    \n\t:local teCallbackUsersCardVersion \"2.9.7.22\"\r\
    \n\t:set (\$dbaseVersion->\"teCallbackUsersCard\") \$teCallbackUsersCardVe\
    rsion\r\
    \n\r\
    \n\t:global teEditMessageReplyMarkup\r\
    \n\t:global teAnswerCallbackQuery\r\
    \n\t:global teDeleteMessage\r\
    \n\t:global teBuildKeyboard\r\
    \n\t:global teBuildButton\r\
    \n\r\
    \n\t:global teGenValue\r\
    \n\t:global teRightsControl\r\
    \n\t:global teUsersCard\r\
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
    \n\r\
    \n\t:if (\$fDBGteCallbackUserCard = true) do={:put \"teCallbackUsersCard b\
    egin....\"; :log info \"teCallbackUsersCard begin....\"}\r\
    \n\r\
    \n\tdo {\r\
    \n\r\
    \n\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRightName\
    =\"usersread\"] = false) do={\r\
    \n\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$accessDen\
    iedMessage fAlert=true\r\
    \n\t\t\t:return false\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackUserCard = true) do={:put \"teCallbackUsersCard\
    \_currentMessageID=\$currentMessageID\"; :log info \"teCallbackUsersCard c\
    urrentMessageID=\$currentMessageID\"}\r\
    \n\r\
    \n\t\t:local recordsArray [/user find comment~\"\$currentMessageID\"]\r\
    \n\t\t:foreach i in=\$recordsArray do={\r\
    \n\t\t\t:local recordMessageID [:toarray [/user get [find .id=\$i] comment\
    ]]\r\
    \n\t\t\t:if ((\$recordMessageID->1) = \$currentMessageID) do={:set current\
    Record \$i}\r\
    \n\t\t}\r\
    \n\r\
    \n\t\t:if ([:len \$currentRecord] = 0) do={:return [error message=\"teCall\
    backUserCard: record not found\"]}\r\
    \n\r\
    \n\t\t:if (\$fDBGteCallbackUserCard = true) do={:put \"teCallbackUsersCard\
    \_currentRecord=\$currentRecord\"; :log info \"teCallbackUsersCard current\
    Record=\$currentRecord\"}\r\
    \n\r\
    \n\t\t:if ([:len \$currentRecord] != 0) do={\r\
    \n\t\t\t:set commentArray [:toarray [user get number=\$currentRecord comme\
    nt]]\r\
    \n\r\
    \n\t\t\t:if (\$fDBGteCallbackUserCard = true) do={\r\
    \n\t\t\t\t:foreach i in=\$commentArray do={:log info \"\$i - type of item:\
    \$([:typeof \$i])\"}\r\
    \n\t\t\t\t:put \$commentArray; :log info \$commentArray\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:local userInfo (\$commentArray->0)\r\
    \n\r\
    \n\t\t\t:set currentMessageID (\$commentArray->1)\r\
    \n\t\t\t:local boardUserName [/user get number=\$currentRecord name]\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"userInfo\") do={\r\
    \n\t\t\t\t:set userInfo \$commandValue\r\
    \n\t\t\t\t:if (\$fDBGteCallbackUserCard = true) do={:put \"teCallbackUsers\
    Card userInfo=\$userInfo\"; :log info \"teCallbackUsersCard userInfo=\$use\
    rInfo\"}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"userDisable\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"userswrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (\$commandValue = true) do={\t/user set number=\$currentReco\
    rd disabled=yes\t}\r\
    \n\t\t\t\t:if (\$commandValue = false) do={ /user set number=\$currentReco\
    rd disabled=no\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"chngGroup\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"userswrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local currentUserGroup [/user get number=\$currentRecord group]\
    \r\
    \n\t\t\t\t:local allGroups [/user group print as-value]\r\
    \n\t\t\t\t:local allGroupsCount [/user group print as-value count-only]\r\
    \n\r\
    \n\t\t\t\t:local counter 1\r\
    \n\t\t\t\t:local newGroupId []\r\
    \n\t\t\t\t:foreach i in=\$allGroups do={\r\
    \n\t\t\t\t\t:local currentGroupName (\$i->\"name\")\r\
    \n\t\t\t\t\t:if (\$currentGroupName = \$currentUserGroup) do={\r\
    \n\t\t\t\t\t\t:set newGroupId \$counter\r\
    \n\t\t\t\t\t\t:if (\$counter = \$allGroupsCount) do={:set \$newGroupId 0}\
    \r\
    \n\t\t\t\t\t}\r\
    \n\t\t\t\t\t:set \$counter (\$counter + 1)\r\
    \n\t\t\t\t\t:log info \"counter = \$counter\"\r\
    \n\t\t\t\t\t:log info \"currentGroupName = \$currentGroupName\"\r\
    \n\t\t\t\t}\r\
    \n\t\t\t\t:local newGroupName ((\$allGroups->\$newGroupId)->\"name\")\r\
    \n\t\t\t\t/user set number=\$currentRecord group=\$newGroupName\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"delete\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"usersdelete\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=true\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local deleteRequest \$commandValue\r\
    \n\r\
    \n\t\t\t\t:local pictDelete \"\\F0\\9F\\97\\91\"\r\
    \n\t\t\t\t:local buttonDeleteCallBackText \"teCallbackUsersCard,delete,req\
    uest\"\r\
    \n\t\t\t\t:local buttonDelete [\$teBuildButton fPictButton=\$pictDelete fT\
    extButton=\"  Delete user\?\" fTextCallBack=\$buttonDeleteCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t:local buttonYesCallBackText \"teCallbackUsersCard,delete,true\"\
    \r\
    \n\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextBut\
    ton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t:local buttonNoCallBackText \"teCallbackUsersCard,delete,false\"\
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
    \n\t\t\t\t\t/user remove number=\$currentRecord\r\
    \n\t\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$messageID\
    \_fUserName=\$userName\r\
    \n\t\t\t\t\t:if (\$fDBGteCallbackUserCard = true) do={:put \"teCallbackUse\
    rsCard message \$messageID is deleted\"; :log info \"teCallbackUsersCard m\
    essage \$messageID is deleted\"}\r\
    \n\t\t\t\t\t:return true\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$commandName = \"chngPass\") do={\r\
    \n\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRight\
    Name=\"userswrite\"] = false) do={\r\
    \n\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$acces\
    sDeniedMessage fAlert=True\r\
    \n\t\t\t\t\t:return false\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:local changePassRequest \$commandValue\r\
    \n\r\
    \n\t\t\t\t:if (\$fDBGteCallbackUserCard = true) do={:put \"teCallbackUsers\
    Card command=\$commandName\"; :log info \"teCallbackUsersCard command=\$co\
    mmandName\"}\r\
    \n\r\
    \n\t\t\t\t:local pictChangePass \"\\F0\\9F\\8E\\B2\"\r\
    \n\t\t\t\t:local buttonChangePassCallBackText \"teCallbackUsersCard,chngPa\
    ss,request\"\r\
    \n\t\t\t\t:local buttonChangePass [\$teBuildButton fPictButton=\$pictChang\
    ePass fTextButton=\"  Change password\?\" fTextCallBack=\$buttonChangePass\
    CallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictYes \"\\E2\\9C\\85\"\r\
    \n\t\t\t\t:local buttonYesCallBackText \"teCallbackUsersCard,chngPass,true\
    \"\r\
    \n\t\t\t\t:local buttonYes [\$teBuildButton fPictButton=\$pictYes fTextBut\
    ton=\"  Yes\" fTextCallBack=\$buttonYesCallBackText]\r\
    \n\r\
    \n\t\t\t\t:local pictNo \"\\E2\\9D\\8C\"\r\
    \n\t\t\t\t:local buttonNoCallBackText \"teCallbackUsersCard,chngPass,false\
    \"\r\
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
    \n\t\t\t\t\t:if (\$fDBGteCallbackUserCard = true) do={:put \"teCallbackUse\
    rsCard new password is set for \$currentMessageID\"; :log info \"teCallbac\
    kUsersCard new password is set for \$currentMessageID\"}\r\
    \n\t\t\t\t\t/user set number=\$currentRecord password=\$newSecret\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:local answer \"\\\$teAnswerCallbackQuery fQueryID=\$queryID fAnsw\
    erText=\\\" \\\" fAlert=false\"\r\
    \n\t\t\t:execute script=\$answer\r\
    \n\r\
    \n\t\t\t:set \$messageID [\$teUsersCard fChatID=\$queryChatID fMessageID=\
    \$messageID fUserName=\$boardUserName fUserInfo=\$userInfo fNewPass=\$newS\
    ecret]\r\
    \n\t\t\t:if (\$messageID != 0) do={\r\
    \n\t\t\t\t/user set number=\$currentRecord comment=\"\$userInfo,MSG=\$mess\
    ageID\"\r\
    \n\t\t\t\t:return true\r\
    \n\t\t\t} else={:return false}\r\
    \n\t\t} else={\r\
    \n\t\t\t:local errorMessage \"\$pictAnswerCallback Record not found in use\
    rs, deleting...\"\r\
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
    \n\t\t:put \"teCallbackUsersCard return ERROR\"; :log info \"teCallbackUse\
    rsCard return ERROR\"\r\
    \n\t\t:return false\r\
    \n\t}\r\
    \n"
