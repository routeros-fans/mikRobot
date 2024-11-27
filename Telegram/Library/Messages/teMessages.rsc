# 2023-09-22 17:05:37 by RouterOS 7.11.2
# software id =
#
/system script

:if ([:len [find name=teAnswerCallbackQuery]] != 0) do={ remove teAnswerCallbackQuery }
add dont-require-permissions=no name=teAnswerCallbackQuery owner=xenon007 \
    policy=ftp,read,write,policy,test source="#-------------------------------\
    --------------------teAnswerCallbackQuery---------------------------------\
    -----------------------------\r\
    \n\r\
    \n#   Function sends a response to a button click\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID        -   botID\r\
    \n#   1.  fQueryID      -   query id\r\
    \n#   2.  fAnswerText   -   text for answer\r\
    \n#   3.  fAlert        -   alert type (true or false) may be  empty\r\
    \n\r\
    \n#---------------------------------------------------teAnswerCallbackQuer\
    y--------------------------------------------------------------\r\
    \n\r\
    \n:global teAnswerCallbackQuery\r\
    \n:if (!any \$teAnswerCallbackQuery) do={ :global teAnswerCallbackQuery do\
    ={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teAnswerCallbackQuery botID not set\"; :log error \"teAnswerC\
    allbackQuery botID not set\"\r\
    \n    :return false\r\
    \n  }\r\
    \n\r\
    \n\t:local tgUrl []\r\
    \n\t:local content []\r\
    \n\r\
    \n  :if ([:len \$fAlert] = 0) do={ :set \$fAlert false }\r\
    \n\r\
    \n  :set tgUrl \"https://api.telegram.org/\$botID/answerCallbackQuery\\\?c\
    allback_query_id=\$fQueryID&text=\$fAnswerText&show_alert=fAlert\"\r\
    \n\r\
    \n  do {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n  } on-error={ :return false }\r\
    \n\r\
    \n  :if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n\t\t:return true\r\
    \n\t} else={ :return false }\r\
    \n }\r\
    \n}\r\
    \n"

:if ([:len [find name=teAnswerInlineQuery]] != 0) do={ remove teAnswerInlineQuery }
add dont-require-permissions=no name=teAnswerInlineQuery owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teAnswerInlineQuery------------------------------------------\
    --------------------\r\
    \n#   Use this method to send answers to an inline query. On success, True\
    \_is returned. No more than 50 results per query are allowed.\r\
    \n\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID                  -   botID\r\
    \n#   1.  fInlineQueryId          -   Unique identifier for the answered q\
    uery\r\
    \n#   2.  fResults                -   A JSON-serialized array of results f\
    or the inline query\r\
    \n#   3.  fCacheTime              -   The maximum amount of time in second\
    s that the result of the inline query may be cached on the server. Default\
    s to 300.\r\
    \n#   4.  fIsPersonal             -   Pass True if results may be cached o\
    n the server side only for the user that sent the query. By default, resul\
    ts may be returned to any user who sends the same query\r\
    \n#   5.  fNextOffset             -   Pass the offset that a client should\
    \_send in the next query with the same text to receive more results. Pass \
    an empty string if there are no more results or if you don't support pagin\
    ation. Offset length can't exceed 64 bytes.\r\
    \n#   6.  fSwitchPmText           -   If passed, clients will display a bu\
    tton with specified text that switches the user to a private chat with the\
    \_bot and sends the bot a start message with the parameter switch_pm_param\
    eter\r\
    \n#   7.  fSwitchPmParameter      -   Deep-linking parameter for the /star\
    t message sent to the bot when user presses the switch button. 1-64 charac\
    ters, only A-Z, a-z, 0-9, _ and - are allowed.\r\
    \n#\r\
    \n#   Function return 1 or 0\r\
    \n#---------------------------------------------------teAnswerInlineQuery-\
    -------------------------------------------------------------\r\
    \n\r\
    \n:global teAnswerInlineQuery\r\
    \n:if (!any \$teAnswerInlineQuery) do={ :global teAnswerInlineQuery do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teAnswerInlineQuery botID not set\"; :log error \"teAnswerInl\
    ineQuery botID not set\"\r\
    \n    :return false\r\
    \n  }\r\
    \n\r\
    \n\t:local tgUrl []; :local result []; :local content []\r\
    \n\r\
    \n  :if (\$fDBGteAnswerInlineQuery = true) do={:put \"teAnswerInlineQuery \
    started...\"; :log info \"teAnswerInlineQuery started...\"}\r\
    \n\r\
    \n  :set \$fInlineQueryId \"&inline_query_id=\$fInlineQueryId\"\r\
    \n  :set \$fResults \"&results=\$fResults\"\r\
    \n\r\
    \n  :if ([:len \$fCacheTime] != 0) do={ :set \$fCacheTime \"&cache_time=\$\
    fCacheTime\" } else={ :set \$fCacheTime \"\" }\r\
    \n  :if ([:len \$fIsPersonal] != 0) do={ :set \$fIsPersonal \"&is_personal\
    =\$fIsPersonal\" } else={ :set \$fIsPersonal \"\" }\r\
    \n  :if ([:len \$fNextOffset] != 0) do={ :set \$fNextOffset \"&next_offset\
    =\$fNextOffset\" } else={ :set \$fNextOffset \"\" }\r\
    \n  :if ([:len \$fSwitchPmText] != 0) do={ :set \$fSwitchPmText \"&switch_\
    pm_text=\$fSwitchPmText\" } else={ :set \$fSwitchPmText \"\" }\r\
    \n  :if ([:len \$fSwitchPmParameter] != 0) do={ :set \$fSwitchPmParameter \
    \"&switch_pm_parameter=\$fSwitchPmParameter\" } else={ :set \$fSwitchPmPar\
    ameter \"\" }\r\
    \n\r\
    \n  :set tgUrl \"https://api.telegram.org/\$botID/answerInlineQuery\\\?\$f\
    InlineQueryId\$fResults\$fCacheTime\$fIsPersonal\$fNextOffset\$fSwitchPmTe\
    xt\$fSwitchPmParameter\"\r\
    \n\r\
    \n  do {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n  } on-error={\r\
    \n    :put \"teAnswerInlineQuery ERROR\"; :log error \"teAnswerInlineQuery\
    \_ERROR\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n    :set result 1\r\
    \n    :return \$result\r\
    \n  } else={ :return 0\t}\r\
    \n }\r\
    \n}\r\
    \n"

:if ([:len [find name=teDeleteMessage]] != 0) do={ remove teDeleteMessage }
add dont-require-permissions=no name=teDeleteMessage owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teDeleteMessage----------------------------------------------\
    ----------------\r\
    \n\r\
    \n#   Function delete the specified message\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID       -   botID\r\
    \n#   1.  fChatID      -   Recipient id\r\
    \n#   2.  fMessageID   -   id for edited message\r\
    \n\r\
    \n#---------------------------------------------------teDeleteMessage-----\
    ---------------------------------------------------------\r\
    \n\r\
    \n:global teDeleteMessage\r\
    \n:if (!any \$teDeleteMessage) do={ :global teDeleteMessage do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teDeleteMessage botID not set\"; :log error \"teDeleteMessage\
    \_botID not set\"\r\
    \n    :return false\r\
    \n  }\r\
    \n\t:local tgUrl []; :local content []\r\
    \n\t:set tgUrl \"https://api.telegram.org/\$botID/deletemessage\\\?chat_id\
    =\$fChatID&message_id=\$fMessageID\"\r\
    \n\r\
    \n  do { :set content [:tool fetch url=\$tgUrl as-value output=user]\r\
    \n  } on-error={\r\
    \n    :put \"teDeleteMessage. The bot cannot delete messages older than 48\
    \_hours\"; :log error \"teDeleteMessage. The bot cannot delete messages ol\
    der than 48 hours\"\r\
    \n    :return false\r\
    \n  }\r\
    \n\r\
    \n  :if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n\t\t:if (\$fDBGteDeleteMessage = true) do={:put \"teDeleteMessage finish\
    ed\"; :log info \"teDeleteMessage finished\"}\r\
    \n\t\t:return true\r\
    \n\t} else={ :return false }\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=teEditCaption]] != 0) do={ remove teEditCaption }
add dont-require-permissions=no name=teEditCaption owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teEditCaption------------------------------------------------\
    --------------\r\
    \n\r\
    \n#   Function edits the specified message caption\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   1.  fBotID       -   botID\r\
    \n#   2.  fChatID       -   Recipient id\r\
    \n#   3.  fMessageID    -   id for edited message\r\
    \n#   4.  fText         -   Message text\r\
    \n#   5.  fReplyMarkup  -   Reply markup (may be empty)\r\
    \n\r\
    \n#   Function return message ID or 0\r\
    \n#---------------------------------------------------teEditCaption-------\
    -------------------------------------------------------\r\
    \n\r\
    \n:global teEditCaption\r\
    \n:if (!any \$teEditCaption) do={ :global teEditCaption do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teEditCaption botID not set\"; :log error \"teEditCaption bot\
    ID not set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :local disableWebPagePreview true\r\
    \n\t:local parseMode \"html\"\r\
    \n\r\
    \n\t:local tgUrl []; :local result []; :local content []\r\
    \n\r\
    \n  :if ([:len \$fText] = 0) do={:set \$fText \"\"}\r\
    \n  :if ([:len \$fText] >= 1024) do={ :return [error message=\"lengthCapti\
    onError\"] }\r\
    \n\r\
    \n\t:if ([:len \$fReplyMarkup] != 0) do={\r\
    \n    :set tgUrl \"https://api.telegram.org/\$botID/editMessageCaption\\\?\
    chat_id=\$fChatID&message_id=\$fMessageID&caption=\$fText&parse_mode=\$par\
    seMode&reply_markup=\$fReplyMarkup\"\r\
    \n\t} else={\r\
    \n    :set tgUrl \"https://api.telegram.org/\$botID/editMessageCaption\\\?\
    chat_id=\$fChatID&message_id=\$fMessageID&caption=\$fText&parse_mode=\$par\
    seMode\"\r\
    \n\t}\r\
    \n\r\
    \n  do {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n  \t:if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n      :local tmpStr [:pick (\$content->\"data\") ([:find (\$content->\"d\
    ata\") \"message_id\"]) ([:find (\$content->\"data\") \"_id\"]+20)]\r\
    \n      :local messageID [:pick \$tmpStr ([:find \$tmpStr \"message_id\"]+\
    12) ([:find \$tmpStr \",\"])]\r\
    \n  \t\t:set result \$messageID\r\
    \n  \t\t:return \$result\r\
    \n  \t} else={:return 0 }\r\
    \n  } on-error={\r\
    \n    :put \"teEditCaption ERROR\"; :log error \"teEditCaption ERROR\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=teEditMedia]] != 0) do={ remove teEditMedia }
add dont-require-permissions=no name=teEditMedia owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teEditMedia--------------------------------------------------\
    ------------\r\
    \n\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID        -   botID\r\
    \n#   1.  fChatID       -   Recipient id\r\
    \n#   2.  fMessageID    -   id for edited message\r\
    \n\r\
    \n#   3.  fMediaType    -   This object represents the content of a media \
    message to be edit. It should be one of:\r\
    \n#                         Animation, Document, Audio, Photo, Video\r\
    \n\r\
    \n#   4.  fMediaLink    -   Message media,\r\
    \n#   5.  fMediaCaption -   Message caption\r\
    \n#   6.  fReplyMarkup  -   Reply markup (may be empty)\r\
    \n\r\
    \n#   photo (media, caption)\r\
    \n\r\
    \n#   Function return message ID or 0\r\
    \n#---------------------------------------------------teEditMedia---------\
    -----------------------------------------------------\r\
    \n\r\
    \n:global teEditMedia\r\
    \n:if (!any \$teEditMedia) do={ :global teEditMedia do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teEditMedia botID not set\"; :log error \"teEditMedia botID n\
    ot set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :local disableWebPagePreview true\r\
    \n\t:local parseMode \"html\"\r\
    \n\r\
    \n\t:local tgUrl []; :local result []; :local content []\r\
    \n  :local newMedia []\r\
    \n\r\
    \n  :if ([:len \$fMediaCaption] >= 1024) do={:return [error message=\"leng\
    thCaptionError\"]}\r\
    \n\r\
    \n  :local inputMediaType \"\\7B\\22type\\22:\\22\$fMediaType\"\r\
    \n  :local inputMediaLink \"\\22,\\22media\\22:\\22\"\r\
    \n  :local inputMediaCaption \"\\22,\\22caption\\22:\\22\"\r\
    \n  :local endMedia \"\\22\\7D\"\r\
    \n\r\
    \n  :if ([:len \$fMediaCaption] = 0) do={\r\
    \n    :set newMedia \"\$inputMediaType\$inputMediaLink\$fMediaLink\$endMed\
    ia\"\r\
    \n  } else={\r\
    \n    :set newMedia \"\$inputMediaType\$inputMediaLink\$fMediaLink\$inputM\
    ediaCaption\$fMediaCaption\$endMedia\"\r\
    \n  }\r\
    \n\r\
    \n\t:if ([:len \$fReplyMarkup] != 0) do={\r\
    \n    :set tgUrl \"https://api.telegram.org/\$botID/editMessageMedia\\\?ch\
    at_id=\$fChatID&message_id=\$fMessageID&media=\$newMedia&parse_mode=\$pars\
    eMode&reply_markup=\$fReplyMarkup\"\r\
    \n\t} else={\r\
    \n    :set tgUrl \"https://api.telegram.org/\$botID/editMessageMedia\\\?ch\
    at_id=\$fChatID&message_id=\$fMessageID&media=\$newMedia&parse_mode=\$pars\
    eMode\"\r\
    \n\t}\r\
    \n\r\
    \n  do {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n\r\
    \n  \t:if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n      :local tmpStr [:pick (\$content->\"data\") ([:find (\$content->\"d\
    ata\") \"message_id\"]) ([:find (\$content->\"data\") \"_id\"]+20)]\r\
    \n      :local messageID [:pick \$tmpStr ([:find \$tmpStr \"message_id\"]+\
    12) ([:find \$tmpStr \",\"])]\r\
    \n  \t\t:set result \$messageID\r\
    \n  \t\t:return \$result\r\
    \n  \t} else={ :return 0\t}\r\
    \n  } on-error={\r\
    \n    :put \"teEditMedia ERROR\"; :log error \"teEditMedia ERROR\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=teEditMessage]] != 0) do={ remove teEditMessage }
add dont-require-permissions=no name=teEditMessage owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teEditMessage------------------------------------------------\
    --------------\r\
    \n\r\
    \n#   Function edits the specified message\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID        -   botID\r\
    \n#   1.  fChatID       -   Recipient id\r\
    \n#   2.  fMessageID    -   id for edited message\r\
    \n#   3.  fText         -   Message text\r\
    \n#   4.  fReplyMarkup  -   Reply markup (may be empty)\r\
    \n\r\
    \n#   Function return message ID or 0\r\
    \n#---------------------------------------------------teEditMessage-------\
    -------------------------------------------------------\r\
    \n\r\
    \n:global teEditMessage\r\
    \n:if (!any \$teEditMessage) do={ :global teEditMessage do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teEditMessage botID not set\"; :log error \"teEditMessage bot\
    ID not set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :local disableWebPagePreview true\r\
    \n\t:local parseMode \"html\"\r\
    \n\r\
    \n\t:local tgUrl []; :local result []; :local content []\r\
    \n\r\
    \n  :if ([:len \$fText] = 0) do={:set \$fText \"\"}\r\
    \n  :if ([:len \$fText] >= 4096) do={:return [error message=\"lengthCaptio\
    nError\"]}\r\
    \n\r\
    \n\t:if ([:len \$fReplyMarkup] != 0) do={\r\
    \n    :set tgUrl \"https://api.telegram.org/\$botID/editMessageText\\\?cha\
    t_id=\$fChatID&message_id=\$fMessageID&text=\$fText&parse_mode=\$parseMode\
    &disable_web_page_preview=\$disableWebPagePreview&reply_markup=\$fReplyMar\
    kup\"\r\
    \n\t} else={\r\
    \n    :set tgUrl \"https://api.telegram.org/\$botID/editMessageText\\\?cha\
    t_id=\$fChatID&message_id=\$fMessageID&text=\$fText&parse_mode=\$parseMode\
    &disable_web_page_preview=\$disableWebPagePreview\"\r\
    \n\t}\r\
    \n\r\
    \n  do {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n\r\
    \n  \t:if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n      :local tmpStr [:pick (\$content->\"data\") ([:find (\$content->\"d\
    ata\") \"message_id\"]) ([:find (\$content->\"data\") \"_id\"]+20)]\r\
    \n      :local messageID [:pick \$tmpStr ([:find \$tmpStr \"message_id\"]+\
    12) ([:find \$tmpStr \",\"])]\r\
    \n  \t\t:set result \$messageID\r\
    \n  \t\t:return \$result\r\
    \n  \t} else={ :return 0\t}\r\
    \n  } on-error={\r\
    \n    :put \"teEditMessage ERROR\"; :log error \"teEditMessage ERROR\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=teEditMessageReplyMarkup]] != 0) do={ remove teEditMessageReplyMarkup }
add dont-require-permissions=no name=teEditMessageReplyMarkup owner=xenon007 \
    policy=ftp,read,write,policy,test source="#-------------------------------\
    --------------------teEditMessageReplyMarkup------------------------------\
    --------------------------------\r\
    \n\r\
    \n#   Function edits the specified message reply_markup\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID        -   botID\r\
    \n#   1.  fChatID       -   Recipient id\r\
    \n#   2.  fMessageID    -   id for edited message\r\
    \n#   3.  fReplyMarkup  -   Reply markup\r\
    \n\r\
    \n#   Function return message ID or 0\r\
    \n#---------------------------------------------------teEditMessageReplyMa\
    rkup--------------------------------------------------------------\r\
    \n\r\
    \n:global teEditMessageReplyMarkup\r\
    \n:if (!any \$teEditMessageReplyMarkup) do={ :global teEditMessageReplyMar\
    kup do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teEditMessageReplyMarkup botID not set\"; :log error \"teEdit\
    MessageReplyMarkup botID not set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :local disableWebPagePreview true\r\
    \n\t:local parseMode \"html\"\r\
    \n\r\
    \n\t:local tgUrl []; :local result []; :local content []\r\
    \n\r\
    \n\t:if ([:len \$fReplyMarkup] != 0) do={\r\
    \n    :set tgUrl \"https://api.telegram.org/\$botID/editMessageReplyMarkup\
    \\\?chat_id=\$fChatID&message_id=\$fMessageID&reply_markup=\$fReplyMarkup\
    \"\r\
    \n\t} else={\r\
    \n    :put \"teEditMessageReplyMarkup is not set\"; :log error \"teEditMes\
    sageReplyMarkup is not set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n\t:if (\$fDBGteEditMessageReplyMarkup = true) do={:put \"teEditMessageRe\
    plyMarkup tgUrl = \$tgUrl\"; :log info \"teEditMessageReplyMarkup tgUrl = \
    \$tgUrl\"}\r\
    \n\r\
    \n  do {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n  } on-error={\r\
    \n      :put \"teEditMessageReplyMarkup ERROR\"; :log error \"teEditMessag\
    eReplyMarkup ERROR\"\r\
    \n      :return 0\r\
    \n  }\r\
    \n\r\
    \n  \t:if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n      :local tmpStr [:pick (\$content->\"data\") ([:find (\$content->\"d\
    ata\") \"message_id\"]) ([:find (\$content->\"data\") \"_id\"]+20)]\r\
    \n      :local messageID [:pick \$tmpStr ([:find \$tmpStr \"message_id\"]+\
    12) ([:find \$tmpStr \",\"])]\r\
    \n  \t\t:set result \$messageID\r\
    \n  \t\t:return \$result\r\
    \n  \t} else={ :return 0 }\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=tePinMessage]] != 0) do={ remove tePinMessage }
add dont-require-permissions=no name=tePinMessage owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------tePinMessage-------------------------------------------------\
    -------------\r\
    \n\r\
    \n#   Use this method to add a message to the list of pinned messages in a\
    \_chat.\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID        -   botID\r\
    \n#   1.  fChatID       -   Recipient id\r\
    \n#   2.  fMessageID    -   Message Id\r\
    \n\r\
    \n#   Function return \$messageID or 0\r\
    \n#---------------------------------------------------tePinMessage--------\
    ------------------------------------------------------\r\
    \n\r\
    \n:global tePinMessage\r\
    \n:if (!any \$tePinMessage) do={ :global tePinMessage do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"tePinMessage botID not set\"; :log error \"tePinMessage botID\
    \_not set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n\t:local tgUrl []; :local content []\r\
    \n\t:set tgUrl \"https://api.telegram.org/\$botID/pinchatmessage\\\?chat_i\
    d=\$fChatID&message_id=\$fMessageID\"\r\
    \n\r\
    \n\tdo {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n\r\
    \n    :if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n      :local tmpStr [:pick (\$content->\"data\") ([:find (\$content->\"d\
    ata\") \"message_id\"]) ([:find (\$content->\"data\") \"_id\"]+20)]\r\
    \n      :local messageID [:pick \$tmpStr ([:find \$tmpStr \"message_id\"]+\
    12) ([:find \$tmpStr \",\"])]\r\
    \n      :return \$messageID\r\
    \n    }\r\
    \n  } on-error={\r\
    \n    :put \"tePinMessage ERROR\"; :log error \"tePinMessage ERROR\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=teSendAnimation]] != 0) do={ remove teSendAnimation }
add dont-require-permissions=no name=teSendAnimation owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teSendAnimation----------------------------------------------\
    ----------------\r\
    \n\r\
    \n#   Function sends a message to the recipient.\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID        -   botID\r\
    \n#   1.  fChatID       -   Recipient id\r\
    \n#   2.  fMedia        -   Message Photo\r\
    \n#   3.  fText         -   Message text\r\
    \n#   4.  fReplyMarkup  -   Reply markup (may be empty)\r\
    \n\r\
    \n#   Function return \$messageID or 0\r\
    \n#---------------------------------------------------teSendAnimation-----\
    ---------------------------------------------------------\r\
    \n\r\
    \n:global teSendAnimation\r\
    \n:if (!any \$teSendAnimation) do={ :global teSendAnimation do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teSendAnimation botID not set\"; :log error \"teSendAnimation\
    \_botID not set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n\t:local parseMode \"html\"\r\
    \n\t:local tgUrl []; :local result []; :local content []\r\
    \n\r\
    \n  :if ([:len \$fText] = 0) do={:set \$fText \"\"}\r\
    \n  :if ([:len \$fText] >= 1024) do={:return [error message=\"lengthCaptio\
    nError\"]}\r\
    \n\r\
    \n\t:if ([:len \$fReplyMarkup] != 0) do={\r\
    \n\t\t:set tgUrl \"https://api.telegram.org/\$botID/sendanimation\\\?chat_\
    id=\$fChatID&animation=\$fMedia&caption=\$fText&parse_mode=\$parseMode&rep\
    ly_markup=\$fReplyMarkup\"\r\
    \n\t}\r\
    \n\t:if ([:len \$fReplyMarkup] = 0) do={\r\
    \n\t\t:set tgUrl \"https://api.telegram.org/\$botID/sendanimation\\\?chat_\
    id=\$fChatID&animation=\$fMedia&caption=\$fText&parse_mode=\$parseMode\"\r\
    \n\t}\r\
    \n\r\
    \n\tdo {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n  } on-error={\r\
    \n    :put \"teSendAnimation ERROR\"; :log error \"teSendAnimation ERROR\"\
    \r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n    :if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n      :local tmpStr [:pick (\$content->\"data\") ([:find (\$content->\"d\
    ata\") \"message_id\"]) ([:find (\$content->\"data\") \"_id\"]+20)]\r\
    \n      :local messageID [:pick \$tmpStr ([:find \$tmpStr \"message_id\"]+\
    12) ([:find \$tmpStr \",\"])]\r\
    \n      :if (\$fDBGteSendAnimation = true) do={:put (\$content->\"data\");\
    \_:log info (\$content->\"data\")}\r\
    \n      :set result \$messageID\r\
    \n      :return \$result\r\
    \n    } else={ :return 0 }\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=teSendLocation]] != 0) do={ remove teSendLocation }
add dont-require-permissions=no name=teSendLocation owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teSendLocation-----------------------------------------------\
    ---------------\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID                  -   botID\r\
    \n#   1.  fChatID                 -   Recipient id\r\
    \n#   2.  fLatitude               -   Latitude of the location\r\
    \n#   3.  fLongitude              -   Longitude of the location\r\
    \n#   4.  fHorizontalAccuracy     -   The radius of uncertainty for the lo\
    cation, measured in meters; 0-1500\r\
    \n#   5.  fLivePeriod             -   Period in seconds for which the loca\
    tion will be updated (see Live Locations, should be between 60 and 86400.\
    \r\
    \n#   6.  fProximityAlertRadius   -   For live locations, a maximum distan\
    ce for proximity alerts about approaching another chat member, in meters. \
    Must be between 1 and 100000 if specified.\r\
    \n#   7.  fProtectContent         -   Protects the contents of the sent me\
    ssage from forwarding and saving\r\
    \n#\r\
    \n#   8.  fReplyMarkup            -   Reply markup (may be empty)\r\
    \n\r\
    \n#   Function return message ID or 0\r\
    \n#---------------------------------------------------teSendLocation------\
    --------------------------------------------------------\r\
    \n\r\
    \n:global teSendLocation\r\
    \n:if (!any \$teSendLocation) do={ :global teSendLocation do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teSendLocation botID not set\"; :log error \"teSendLocation b\
    otID not set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :local disableWebPagePreview true\r\
    \n\t:local parseMode \"html\"\r\
    \n\t:local tgUrl []; :local result []; :local content []\r\
    \n\r\
    \n  :if ([:len \$fReplyMarkup] != 0) do={\r\
    \n    :set tgUrl \"https://api.telegram.org/\$botID/sendLocation\\\?chat_i\
    d=\$fChatID&latitude=\$fLatitude&longitude=\$fLongitude\\\r\
    \n                                                            &horizontal_\
    accuracy=\$fHorizontalAccuracy&live_period=\$fLivePeriod\\\r\
    \n                                                            &proximity_a\
    lert_radius=\$fProximityAlertRadius&protect_content=\$fProtectContent\\\r\
    \n                                                            &reply_marku\
    p=\$fReplyMarkup\"\r\
    \n  } else={\r\
    \n    :set tgUrl \"https://api.telegram.org/\$botID/sendLocation\\\?chat_i\
    d=\$fChatID&latitude=\$fLatitude&longitude=\$fLongitude\\\r\
    \n                                                            &horizontal_\
    accuracy=\$fHorizontalAccuracy&live_period=\$fLivePeriod\\\r\
    \n                                                            &proximity_a\
    lert_radius=\$fProximityAlertRadius&protect_content=\$fProtectContent\"\r\
    \n  }\r\
    \n\r\
    \n  do {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n\r\
    \n  \t:if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n      :local tmpStr [:pick (\$content->\"data\") ([:find (\$content->\"d\
    ata\") \"message_id\"]) ([:find (\$content->\"data\") \"_id\"]+20)]\r\
    \n      :local messageID [:pick \$tmpStr ([:find \$tmpStr \"message_id\"]+\
    12) ([:find \$tmpStr \",\"])]\r\
    \n  \t\t:set result \$messageID\r\
    \n  \t\t:return \$result\r\
    \n  \t} else={ :return 0\t}\r\
    \n  } on-error={\r\
    \n    :put \"teSendLocation ERROR\"; :log info \"teSendLocation ERROR\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=teSendMessage]] != 0) do={ remove teSendMessage }
add dont-require-permissions=no name=teSendMessage owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teSendMessage------------------------------------------------\
    --------------\r\
    \n\r\
    \n#   Function sends a message to the recipient.\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID        -   botID\r\
    \n#   1.  fChatID       -   Recipient id\r\
    \n#   2.  fText         -   Message text\r\
    \n#   3.  fReplyMarkup  -   Reply markup (may be empty)\r\
    \n\r\
    \n#   Function return \$messageID or 0\r\
    \n#---------------------------------------------------teSendMessage-------\
    -------------------------------------------------------\r\
    \n\r\
    \n:global teSendMessage\r\
    \n:if (!any \$teSendMessage) do={ :global teSendMessage do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teSendMessage botID not set\"; :log error \"teSendMessage bot\
    ID not set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n\t:local disableWebPagePreview true\r\
    \n\t:local parseMode \"html\"\r\
    \n\r\
    \n  :local lenText [:len \$fText]\r\
    \n\t:local tgUrl []; :local result []; :local content []\r\
    \n\r\
    \n  :if ([:len \$fText] >= 4096) do={:return [error message=\"lengthCaptio\
    nError\"]}\r\
    \n\r\
    \n\t:if ([:len \$fReplyMarkup] != 0) do={\r\
    \n\t\t:set tgUrl \"https://api.telegram.org/\$botID/sendmessage\\\?chat_id\
    =\$fChatID&text=\$fText&parse_mode=\$parseMode&disable_web_page_preview=\$\
    disableWebPagePreview&reply_markup=\$fReplyMarkup\"\r\
    \n\t}\r\
    \n\t:if ([:len \$fReplyMarkup] = 0) do={\r\
    \n\t\t:set tgUrl \"https://api.telegram.org/\$botID/sendmessage\\\?chat_id\
    =\$fChatID&text=\$fText&parse_mode=\$parseMode&disable_web_page_preview=\$\
    disableWebPagePreview\"\r\
    \n\t}\r\
    \n\r\
    \n\tdo {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n  } on-error={\r\
    \n    :put \"teSendMessage ERROR\"; :log error \"teSendMessage ERROR\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n    :local tmpStr [:pick (\$content->\"data\") ([:find (\$content->\"dat\
    a\") \"message_id\"]) ([:find (\$content->\"data\") \"_id\"]+20)]\r\
    \n    :local messageID [:pick \$tmpStr ([:find \$tmpStr \"message_id\"]+12\
    ) ([:find \$tmpStr \",\"])]\r\
    \n    :set result \$messageID\r\
    \n    :return \$result\r\
    \n  } else={ :return 0 }\r\
    \n\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=teSendPhoto]] != 0) do={ remove teSendPhoto }
add dont-require-permissions=no name=teSendPhoto owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teSendPhoto--------------------------------------------------\
    ------------\r\
    \n\r\
    \n#   Function sends a message to the recipient.\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID        -   botID\r\
    \n#   1.  fChatID       -   Recipient id\r\
    \n#   2.  fPhoto        -   Photo\r\
    \n#   3.  fText         -   Message text\r\
    \n#   4.  fReplyMarkup  -   Reply markup (may be empty)\r\
    \n\r\
    \n#   Function return \$messageID or 0\r\
    \n#---------------------------------------------------teSendPhoto---------\
    -----------------------------------------------------\r\
    \n\r\
    \n:global teSendPhoto\r\
    \n:if (!any \$teSendPhoto) do={ :global teSendPhoto do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teSendPhoto botID not set\"; :log error \"teSendPhoto botID n\
    ot set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :local disableWebPagePreview true\r\
    \n\t:local parseMode \"html\"\r\
    \n\r\
    \n\t:local tgUrl []; :local result []; :local content []\r\
    \n\r\
    \n  :if ([:len \$fText] = 0) do={:set \$fText \"\"}\r\
    \n  :if ([:len \$fText] >= 1024) do={:return [error message=\"lengthCaptio\
    nError\"]}\r\
    \n\r\
    \n\t:if ([:len \$fReplyMarkup] != 0) do={\r\
    \n\t\t:set tgUrl \"https://api.telegram.org/\$botID/sendphoto\\\?chat_id=\
    \$fChatID&photo=\$fPhoto&caption=\$fText&parse_mode=\$parseMode&reply_mark\
    up=\$fReplyMarkup\"\r\
    \n\t}\r\
    \n\t:if ([:len \$fReplyMarkup] = 0) do={\r\
    \n\t\t:set tgUrl \"https://api.telegram.org/\$botID/sendphoto\\\?chat_id=\
    \$fChatID&photo=\$fPhoto&caption=\$fText&parse_mode=\$parseMode\"\r\
    \n\t}\r\
    \n\r\
    \n\tdo {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n  } on-error={\r\
    \n    :put \"teSendPhoto ERROR\"; :log error \"teSendPhoto ERROR\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :if (\$content->\"status\" = \"finished\")\tdo={\r\
    \n    :local tmpStr [:pick (\$content->\"data\") ([:find (\$content->\"dat\
    a\") \"message_id\"]) ([:find (\$content->\"data\") \"_id\"]+20)]\r\
    \n    :local messageID [:pick \$tmpStr ([:find \$tmpStr \"message_id\"]+12\
    ) ([:find \$tmpStr \",\"])]\r\
    \n    :set result \$messageID\r\
    \n    :return \$result\r\
    \n  } else={ :return 0 }\r\
    \n\r\
    \n }\r\
    \n}\r\
    \n"
:if ([:len [find name=teSetMyCommands]] != 0) do={ remove teSetMyCommands }
add dont-require-permissions=no name=teSetMyCommands owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teSetMyCommands----------------------------------------------\
    ----------------\r\
    \n\r\
    \n#   Function sends a message to the recipient.\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   0.  fBotID          -   botID\r\
    \n#   1.  fCommands       -   array of commands with descriptions\r\
    \n\r\
    \n#   command         -   text of the command; 1-32 characters. Can contai\
    n only lowercase English letters, digits and underscores.\r\
    \n#   description     -   description of the command; 1-256 characters\r\
    \n\r\
    \n#   Usage example:\r\
    \n\r\
    \n#   \$teSetMyCommands fCommands=\"command;description\"\r\
    \n#   \$teSetMyCommands fCommands=\"command;description,command;descriptio\
    n\"\r\
    \n\r\
    \n#   \$teSetMyCommands fCommands=\"getifaces;Get interfaces list,getusers\
    ;Get users list\"\r\
    \n\r\
    \n#   Function return 1 or 0\r\
    \n#---------------------------------------------------teSetMyCommands-----\
    ---------------------------------------------------------\r\
    \n\r\
    \n:global teSetMyCommands\r\
    \n:if (!any \$teSetMyCommands) do={ :global teSetMyCommands do={\r\
    \n\r\
    \n  :local botID \$fBotID\r\
    \n  :if ([:len \$botID] = 0) do={\r\
    \n    :put \"teSetMyCommands botID not set\"; :log error \"teSetMyCommands\
    \_botID not set\"\r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n  :local tgUrl []; :local content []\r\
    \n  :local commandsList [:toarray \$fCommands]\r\
    \n  :local cmdItems []\r\
    \n  :local command []\r\
    \n\r\
    \n  :foreach i in=\$commandsList do={\r\
    \n    :local command [:pick \$i 0 [find \$i \";\"]]\r\
    \n    :local description [:pick \$i ([find \$i \";\"] + 1) [:len \$i]]\r\
    \n    :local startCommand \"\\7B\\22command\\22:\\22\$command\\22\"\r\
    \n    :local commandDescription \",\\22description\\22:\\22\$description\\\
    22\\7D,\"\r\
    \n    :set command \"\$startCommand\$commandDescription\$endCommand\"\r\
    \n    :set \$cmdItems (\$cmdItems . \$command)\r\
    \n  }\r\
    \n  :set cmdItems [:pick \$cmdItems 0 ([:len \$cmdItems] - 1)]\r\
    \n\r\
    \n  :local start \"\\5B\"\r\
    \n  :local end \"\\5D\"\r\
    \n  :set commandsList \"\$start\$cmdItems\$end\"\r\
    \n\r\
    \n  :set tgUrl \"https://api.telegram.org/\$botID/setMyCommands\\\?command\
    s=\$commandsList\"\r\
    \n  :if (\$fDBGteSetMyCommands = true) do={:put \"teSetMyCommands tgUrl = \
    \$tgUrl\"; :log info \"teSetMyCommands tgUrl = \$tgUrl\"}\r\
    \n\r\
    \n\tdo {\r\
    \n    :set content [:tool fetch ascii=yes url=\$tgUrl as-value output=user\
    ]\r\
    \n    :if (\$content->\"status\" = \"finished\")\tdo={:return 1}\r\
    \n  } on-error={\r\
    \n    :put \"teSetMyCommands ERROR\"; :log error \"teSetMyCommands ERROR\"\
    \r\
    \n    :return 0\r\
    \n  }\r\
    \n\r\
    \n }\r\
    \n}\r\
    \n"
