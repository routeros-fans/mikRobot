#---------------------------------------------------dbaseDebug--------------------------------------------------------------

#   Script sets settings for function debugging mode.
#   Parameters for each function can be configured separately.
#   Debug information will be output to the event log and to the console, if the function is run through it

#---------------------------------------------------dbaseDebug--------------------------------------------------------------

:global dbaseDebug [:toarray ""]
:local dbName "dbaseDebug"

:set dbaseDebug ({$dbName;
                "fDBGmainBot"=false;
                "fDBGteRootMenu"=false;
                "fDBGteTerminal"=false;
                "fDBGteModules"=false;
                "fDBGteSystemMenu"=false;
                "fDBGteScripts"=false;
                "fDBGteSendPhoto"=false;
                "fDBGteSendAnimation"=false;
                "fDBGteSendMessage"=false;
                "fDBGteSetMyCommands"=false;
                "fDBGteEditMessage"=false;
                "fDBGteEditCaption"=false;
                "fDBGteEditMedia"=false;
                "fDBGteEditMessageReplyMarkup"=false;
                "fDBGteDeleteMessage"=false;
                "fDBGtePinMessage"=false;
                "fDBGteAnswerCallbackQuery"=false;
                "fDBGteBuildButton"=false;
                "fDBGteBuildReplyButton"=false;
                "fDBGteBuildKeyboard"=false;
                "fDBGteGenNewValue"=false;
                "fDBGteLease"=false;
                "fDBGteLeaseCard"=false;
                "fDBGtePppCard"=false;
                "fDBGteUsersCard"=false;
                "fDBGteIfaceCard"=false;
                "fDBGteCallbackUserCard"=false;
                "fDBGteCallbackPppCard"=false;
                "fDBGteCallbackLeaseCard"=false;
                "fDBGteCallbackIfaceCard"=false;
                "fDBGteCallbackRootMenu"=false;
                "fDBGteCallbackSystemMenu"=false;
                "fDBGteCallbackScripts"=false;
                "fDBGteCallbackResponse"=false;
                "fDBGteMessageResponse"=false;
                "fDBGteTerminalResponse"=false;
                "fDBGteInlineResponse"=false;
                "fDBGteBuilQueryResult"=false;
                "fDBGteAnswerInlineQuery"=false;
                "fDBGteInputTextMessageContent"=false;
                })
