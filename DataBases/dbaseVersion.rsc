#---------------------------------------------------dbaseVersion--------------------------------------------------------------

#   The script sets the version for the modules

#---------------------------------------------------dbaseVersion--------------------------------------------------------------

:global dbaseVersion [:toarray ""]
:local dbName "dbaseVersion"

:local currentTime [/system clock get time]
:local deviceName [/system identity get name]

:local currentVersion "2.1.1.23"

:set dbaseVersion ({$dbName;
                   "mainBot"=$currentVersion;
                   "teAbout"=$currentVersion;
                   "teRootMenu"=$currentVersion;
                   "teCallbackRootMenu"=$currentVersion;
                   "teTerminal"=$currentVersion;
                   "teTerminalResponse"=$currentVersion;
                   "teSystemMenu"=$currentVersion;
                   "teCallbackSystemMenu"=$currentVersion;
                   "teModules"=$currentVersion;
                   "teScripts"=$currentVersion;
                   "teUsersCard"=$currentVersion;
                   "teCallbackUsersCard"=$currentVersion;
                   "tePppCard"=$currentVersion;
                   "teCallbackPppCard"=$currentVersion;
                   "tePppRun"=$currentVersion;
                   "teLease"=$currentVersion;
                   "teLeaseCard"=$currentVersion;
                   "teCallbackLeaseCard"=$currentVersion;
                   "teLeaseRun"=$currentVersion;
                   "teIfaceCard"=$currentVersion;
                   "teCallbackIfaceCard"=$currentVersion;
                   "teScritps"=$currentVersion;
                   "teCallbackScripts"=$currentVersion;
                   "teCallbackResponse"=$currentVersion;
                   "teMessageResponse"=$currentVersion;
                   "teBuildButton"=$currentVersion;
                   "teBuildKeyboard"=$currentVersion;
                   "teBuildReplyButton"=$currentVersion;
                   "teAnswerCallbackQuery"=$currentVersion;
                   "teDeleteMessage"=$currentVersion;
                   "teEditCaption"=$currentVersion;
                   "teEditMedia"=$currentVersion;
                   "teEditMessage"=$currentVersion;
                   "teEditMessageReplyMarkup"=$currentVersion;
                   "tePinMessage"=$currentVersion;
                   "teSendAnimation"=$currentVersion;
                   "teSendMessage"=$currentVersion;
                   "teSendPhoto"=$currentVersion;
                   "teSetMyCommands"=$currentVersion;
                   "teLogSend"=$currentVersion;
                   "teDebugCheck"=$currentVersion;
                   "fDBGteGenValue"=$currentVersion;
                   "teRightsControl"=$currentVersion;
                   "teDbSave"=$currentVersion;
                   "teAnswerInlineQuery"=$currentVersion;
                   "teBuilQueryResult"=$currentVersion;
                   "teInlineQueryResultArticle"=$currentVersion;
                   "teInputTextMessageContent"=$currentVersion;
                   })
