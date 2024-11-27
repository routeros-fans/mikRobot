#---------------------------------------------------dbaseVersion--------------------------------------------------------------

#   The script sets the version for the modules

#---------------------------------------------------dbaseVersion--------------------------------------------------------------

:global dbaseVersion [:toarray ""]
:local dbName "dbaseVersion"

:local currentTime [/system clock get time]
:local deviceName [/system identity get name]

:local currentVersion "2.9.7.22"

:set dbaseVersion ({$dbName;
                   "mainBot"=$currentVersion;
                   "teRootMenu"=$currentVersion;
                   "teCallbackRootMenu"=$currentVersion;
                   "teTerminal"=$currentVersion;
                   "teTerminalResponse"=$currentVersion;
                   "teSystemMenu"=$currentVersion;
                   "teCallbackSystemMenu"=$currentVersion;
                   "teModules"=$currentVersion;
                   "teScripts"=$currentVersion;
                   "teIfaceCard"=$currentVersion;
                   "teCallbackLeaseCard"=$currentVersion;
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
                   "teSendMessage"=$currentVersion;
                   "teSendPhoto"=$currentVersion;
                   "teSetMyCommands"=$currentVersion;
                   "teLogSend"=$currentVersion;
                   "teDebugCheck"=$currentVersion;
                   "fDBGteGenValue"=$currentVersion;
                   "teRightsControl"=$currentVersion;
                   "teAnswerInlineQuery"=$currentVersion;
                   "teBuilQueryResult"=$currentVersion;
                   "teInlineQueryResultArticle"=$currentVersion;
                   "teInputTextMessageContent"=$currentVersion;
                   })
