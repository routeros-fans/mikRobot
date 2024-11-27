# aug/12/2022 17:32:51 by RouterOS 6.49.6
# software id =
#
#
#
/system script
:if ([:len [find name=mainBot]] != 0) do={ remove mainBot }
add dont-require-permissions=no name=mainBot owner=admin policy=\
    ftp,read,write,policy,test source="\r\
    \n:global dbaseBotSettings\r\
    \n:local botID (\$dbaseBotSettings->\"botID\")\r\
    \n:local logSendGroup (\$dbaseBotSettings->\"logSendGroup\")\r\
    \n:local logPinGroup (\$dbaseBotSettings->\"logPinGroup\")\r\
    \n:local botName (\$dbaseBotSettings->\"botName\")\r\
    \n\r\
    \n:global dbaseVersion\r\
    \n:local mainBotVersion \"2.07.9.22\"\r\
    \n:set (\$dbaseVersion->\"mainBot\") \$mainBotVersion\r\
    \n\r\
    \n:global teSendMessage\r\
    \n:global teRightsControl\r\
    \n:global teDeleteMessage\r\
    \n:global teCallbackResponse\r\
    \n:global teAnswerCallbackQuery\r\
    \n:global teMessageResponse\r\
    \n:global teInlineResponse\r\
    \n:global teTerminalResponse\r\
    \n:global teSetMyCommands\r\
    \n:global teDebugCheck\r\
    \n:global teBuildButton\r\
    \n:global teBuildKeyboard\r\
    \n\r\
    \n:global fJParse\r\
    \n:global Jtoffset\r\
    \n:global JSONIn []\r\
    \n:global JParseOut []\r\
    \n:global Jdebug false\r\
    \n\r\
    \n:global teGetDate\r\
    \n:global teGetTime\r\
    \n:local dateM [\$teGetDate]\r\
    \n:local timeM [\$teGetTime]\r\
    \n\r\
    \n:local queryID []\r\
    \n:local userChatID []\r\
    \n:local queryChatID []\r\
    \n:local userName []\r\
    \n:local messageID []\r\
    \n:local messageText []\r\
    \n:local sendText []\r\
    \n:local callbackMessage []\r\
    \n:local oneFeed \"%0D%0A\"\r\
    \n:local pictAnswerCallback \"\\E2\\9D\\97\"\r\
    \n\r\
    \n\$teSetMyCommands fCommands=\"interfaces;Get interfaces list,users;Get u\
    sers list,chatid;Get ID of current chat\"\r\
    \n\r\
    \n:while (true) do={\r\
    \n\t:local fDBGmainBot [\$teDebugCheck fDebugVariableName=\"fDBGmainBot\"]\
    \r\
    \n\t\t:do {\r\
    \n\t\t\t:if ([:typeof \$Jtoffset] != \"num\") do={:set Jtoffset [:tonum \$\
    Jtoffset]}\r\
    \n\t\t\t:local tgUrl \"https://api.telegram.org/\$botID/getUpdates\\\?&all\
    owed_updates=[%22inline_query%22,%22channel_post%22,%22message%22,%22callb\
    ack_query%22]&offset=\$Jtoffset&timeout=15\"\r\
    \n\t\t\t:local fetchData [/tool fetch ascii=yes url=\$tgUrl as-value outpu\
    t=user]\r\
    \n\t\t\t:if ([:len [:tostr (\$fetchData->\"data\")]] != 0) do={\r\
    \n\t\t\t\t:set fetchData (\$fetchData->\"data\")\r\
    \n\t\t\t\t:set JSONIn \$fetchData\r\
    \n\t\t\t\t:set JParseOut [\$fJParse]\r\
    \n\t\t\t\t:if ([:len (\$JParseOut->\"result\")] != 0) do={\r\
    \n\t\t\t\t\t:set JParseOut (\$JParseOut->\"result\")\r\
    \n\t\t\t\t} else={ :error message=\"no data...\" }\r\
    \n\t\t\t}\r\
    \n\r\
    \n\t\t\t:if (\$fDBGmainBot) do={:log info \"teBot result loaded\"}\r\
    \n\r\
    \n\t\t\t:foreach k,v in=\$JParseOut do={\r\
    \n\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)\r\
    \n\r\
    \n\t\t\t\t:if (any (\$v->\"inline_query\")) do={\r\
    \n\t\t\t\t\t:if (\$fDBGmainBot) do={:put \"mainBot - get inline_query\"; :\
    log info \"mainBot - get inline_query\"}\r\
    \n\t\t\t\t\t:local userChatID [:tostr (\$v->\"inline_query\"->\"from\"->\"\
    id\")]\r\
    \n\t\t\t\t\t:local queryText [:tostr (\$v->\"inline_query\"->\"query\")]\r\
    \n\r\
    \n\t\t\t\t\t:if ([:len \$queryText] = 0) do={\r\
    \n\t\t\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)\r\
    \n\t\t\t\t\t\t:error message=\"empty query...\"\r\
    \n\t\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRig\
    htName=root]) do={\r\
    \n\t\t\t\t\t\t:if ([\$teInlineResponse fMessage=\$v] = true) do={\r\
    \n\t\t\t\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)\r\
    \n\t\t\t\t\t\t\t:if (\$fDBGmainBot) do={:put \"mainBot - get inline_query\
    \"; :log info \"mainBot - get inline_query\"}\r\
    \n\t\t\t\t\t\t} else={\r\
    \n\t\t\t\t\t\t\t:if (\$fDBGmainBot) do={:put \"teInlineResponse - return f\
    alse\"; :log info \"teInlineResponse - return false\"}\r\
    \n\t\t\t\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)\r\
    \n\t\t\t\t\t\t}\r\
    \n\t\t\t\t\t} else={\r\
    \n\t\t\t\t\t\t:if (\$fDBGmainBot) do={:put \"\$userChatID - Access denied\
    \"; :log info \"\$userChatID - Access denied\"}\r\
    \n\t\t\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)\r\
    \n\t\t\t\t\t}\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (any (\$v->\"callback_query\")) do={\r\
    \n\t\t\t\t\t:set queryID (\$v->\"callback_query\"->\"id\")\r\
    \n\t\t\t\t\t:set userName (\$v->\"callback_query\"->\"from\"->\"username\"\
    )\r\
    \n\t\t\t\t\t:set userChatID [:tostr (\$v->\"callback_query\"->\"from\"->\"\
    id\")]\r\
    \n\t\t\t\t\t:set queryChatID [:tostr (\$v->\"callback_query\"->\"message\"\
    ->\"chat\"->\"id\")]\r\
    \n\t\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRig\
    htName=root]) do={\r\
    \n\t\t\t\t\t\t:if ([\$teCallbackResponse fCallback=\$v] = true) do={\r\
    \n\t\t\t\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)\r\
    \n\t\t\t\t\t\t} else={\r\
    \n\t\t\t\t\t\t\t:set callbackMessage \"\$pictAnswerCallback Module is not \
    installed\"\r\
    \n\t\t\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$c\
    allbackMessage fAlert=\"True\"\r\
    \n\t\t\t\t\t\t\t:if (\$fDBGmainBot) do={:put \"teCallbackResponse - return\
    \_false\"; :log info \"teCallbackResponse - return false\"}\r\
    \n\t\t\t\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)\r\
    \n\t\t\t\t\t\t}\r\
    \n\t\t\t\t\t} else={\r\
    \n\t\t\t\t\t\t:set callbackMessage \"\$pictAnswerCallback For user \$userN\
    ame - Access denied \"\r\
    \n\t\t\t\t\t\t\$teAnswerCallbackQuery fQueryID=\$queryID fAnswerText=\$cal\
    lbackMessage fAlert=\"True\"\r\
    \n\t\t\t\t\t\t:if (\$fDBGmainBot) do={:put \"\$userChatID - Access denied\
    \"; :log info \"\$userChatID - Access denied\"}\r\
    \n\t\t\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)\r\
    \n\t\t\t\t\t}\r\
    \n\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t:if (any (\$v->\"message\")) do={\r\
    \n\t\t\t\t\t:local userChatID [:tostr (\$v->\"message\"->\"from\"->\"id\")\
    ]\r\
    \n\t\t\t\t\t:local queryChatID [:tostr (\$v->\"message\"->\"chat\"->\"id\"\
    )]\r\
    \n\t\t\t\t\t:local userName [:tostr (\$v->\"message\"->\"chat\"->\"usernam\
    e\")]\r\
    \n\t\t\t\t\t:local messageID (\$v->\"message\"->\"message_id\")\r\
    \n\t\t\t\t\t:local messageText (\$v->\"message\"->\"text\")\r\
    \n\r\
    \n\t\t\t\t\t:if (any (\$v->\"message\"->\"pinned_message\")) do={\r\
    \n\t\t\t\t\t\t:local queryChatTitle (\$v->\"message\"->\"chat\"->\"title\"\
    )\r\
    \n\t\t\t\t\t\t:local pinnedMessageID (\$v->\"message\"->\"pinned_message\"\
    ->\"message_id\")\r\
    \n\t\t\t\t\t\t:local pinnedMessageText (\$v->\"message\"->\"pinned_message\
    \"->\"text\")\r\
    \n\t\t\t\t\t\t:local pinnedMessageFromID (\$v->\"message\"->\"pinned_messa\
    ge\"->\"from\"->\"id\")\r\
    \n\t\t\t\t\t\t:local pinUserName (\$v->\"message\"->\"from\"->\"username\"\
    )\r\
    \n\t\t\t\t\t\t:if (\$fDBGmainBot) do={:put \"teBot - pinnedMessageID \$pin\
    nedMessageID\"; :log info \"teBot - pinnedMessageID \$pinnedMessageID\"}\r\
    \n\t\t\t\t\t\t:if (\$botID ~ [:tostr \$pinnedMessageFromID]) do={\r\
    \n\t\t\t\t\t\t\t:local pinMessageChat [:pick \$queryChatID 4 [:len \$query\
    ChatID]]\r\
    \n\r\
    \n\t\t\t\t\t\t\t:local pictJump \"\\E2\\96\\B6\"\r\
    \n\t\t\t\t\t\t\t:local buttonJumpUrl \"https://t.me/c/\$pinMessageChat/\$p\
    innedMessageID\"\r\
    \n\t\t\t\t\t\t\t:local buttonJump [\$teBuildButton fPictButton=\$pictJump \
    fTextButton=\"  Jump to message\" fUrlButton=\$buttonJumpUrl]\r\
    \n\r\
    \n\t\t\t\t\t\t\t:local replyMarkup [\$teBuildKeyboard fButtonsKeyBoard=\$b\
    uttonJump fReplyKeyboard=false]\r\
    \n\t\t\t\t\t\t\t:if (\$fDBGmainBot) do={:put \"teBot - replyMarkup \$reply\
    Markup\"; :log info \"teBot - replyMarkup \$replyMarkup\"}\r\
    \n\r\
    \n\t\t\t\t\t\t\t:local pictStatic \"\\F0\\9F\\96\\87\"\r\
    \n\t\t\t\t\t\t\t:set sendText \"\$pictStatic <b>\$dateM \$timeM</b> User <\
    b>\$pinUserName</b> pin message in chat <b>\$queryChatTitle</b>\"\r\
    \n\t\t\t\t\t\t\t\$teSendMessage fChatID=\$logPinGroup fText=\$sendText fRe\
    plyMarkup=\$replyMarkup\r\
    \n\t\t\t\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$messa\
    geID\r\
    \n\t\t\t\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)\r\
    \n\t\t\t\t\t\t\t:error message=\"empty query...\"\r\
    \n\t\t\t\t\t\t}\r\
    \n\t\t\t\t\t}\r\
    \n\r\
    \n\t\t\t\t\t:if (\$fDBGmainBot) do={:put \"teBot - messageText \$messageTe\
    xt\"; :log info \"teBot - messageText \$messageText\"}\r\
    \n\t\t\t\t\t:if ([\$teRightsControl fMethod=get fGroupID=\$userChatID fRig\
    htName=root]) do={\r\
    \n\t\t\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$message\
    ID\r\
    \n\t\t\t\t\t\t:if ((\$v->\"message\"->\"text\") ~ \"=>\") do={\r\
    \n\t\t\t\t\t\t\t:if ([\$teTerminalResponse fMessage=\$v] = true) do={:set \
    \$Jtoffset (\$v->\"update_id\" + 1)}\r\
    \n\t\t\t\t\t\t} else={\r\
    \n\t\t\t\t\t\t\t:if ([\$teMessageResponse fMessage=\$v] = true) do={\r\
    \n\t\t\t\t\t\t\t\t:set \$Jtoffset (\$v->\"update_id\" + 1)}\r\
    \n\t\t\t\t\t\t\t}\r\
    \n\t\t\t\t\t} else={\r\
    \n\t\t\t\t\t\t:set sendText (\"\$pictAnswerCallback <b>\$userName</b> this\
    \_is private bot! \$oneFeed\" . \"You are not allowed to use!\")\r\
    \n\t\t\t\t\t\t\$teSendMessage fChatID=\$userChatID fText=\$sendText\r\
    \n\t\t\t\t\t\t:set sendText \"\$pictAnswerCallback User <b>\$userName</b> \
    id = \$userChatID send text to bot - <b>\$messageText</b>\"\r\
    \n\t\t\t\t\t\t\$teSendMessage fChatID=\$logSendGroup fText=\$sendText\r\
    \n\t\t\t\t\t\t\$teDeleteMessage fChatID=\$queryChatID fMessageID=\$message\
    ID\r\
    \n\t\t\t\t\t}\r\
    \n\t\t\t\t}\r\
    \n\t\t\t}\r\
    \n\t\t} on-error={ :if (\$fDBGmainBot) do={:log info \"no data...\"}}\r\
    \n}\r\
    \n"
