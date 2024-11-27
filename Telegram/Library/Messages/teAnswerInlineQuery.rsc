#---------------------------------------------------teAnswerInlineQuery--------------------------------------------------------------
#   Use this method to send answers to an inline query. On success, True is returned. No more than 50 results per query are allowed.

#   Params for this function:

#   1.  fInlineQueryId          -   Unique identifier for the answered query
#   2.  fResults                -   A JSON-serialized array of results for the inline query
#   3.  fCacheTime              -   The maximum amount of time in seconds that the result of the inline query may be cached on the server. Defaults to 300.
#   4.  fIsPersonal             -   Pass True if results may be cached on the server side only for the user that sent the query. By default, results may be returned to any user who sends the same query
#   5.  fNextOffset             -   Pass the offset that a client should send in the next query with the same text to receive more results. Pass an empty string if there are no more results or if you don't support pagination. Offset length can't exceed 64 bytes.
#   6.  fSwitchPmText           -   If passed, clients will display a button with specified text that switches the user to a private chat with the bot and sends the bot a start message with the parameter switch_pm_parameter
#   7.  fSwitchPmParameter      -   Deep-linking parameter for the /start message sent to the bot when user presses the switch button. 1-64 characters, only A-Z, a-z, 0-9, _ and - are allowed.
#
#   Function return message ID or 0

#   if the global variable fDBGteAnswerInlineQuery=true, then a debug event will be logged

#---------------------------------------------------teAnswerInlineQuery--------------------------------------------------------------

:global teAnswerInlineQuery
:if (!any $teAnswerInlineQuery) do={ :global teAnswerInlineQuery do={

  :global teDebugCheck
	:local fDBGteAnswerInlineQuery [$teDebugCheck fDebugVariableName="fDBGteAnswerInlineQuery"]

  :global dbaseVersion
	:local teAnswerInlineQueryVersion "2.07.9.22"
	:set ($dbaseVersion->"teAnswerInlineQuery") $teAnswerInlineQueryVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

	:local tgUrl []; :local result []; :local content []

  :if ($fDBGteAnswerInlineQuery = true) do={:put "teAnswerInlineQuery started..."; :log info "teAnswerInlineQuery started..."}

  :set $fInlineQueryId "&inline_query_id=$fInlineQueryId"
  :set $fResults "&results=$fResults"

  :if ([:len $fCacheTime] != 0) do={ :set $fCacheTime "&cache_time=$fCacheTime" } else={ :set $fCacheTime "" }
  :if ([:len $fIsPersonal] != 0) do={ :set $fIsPersonal "&is_personal=$fIsPersonal" } else={ :set $fIsPersonal "" }
  :if ([:len $fNextOffset] != 0) do={ :set $fNextOffset "&next_offset=$fNextOffset" } else={ :set $fNextOffset "" }
  :if ([:len $fSwitchPmText] != 0) do={ :set $fSwitchPmText "&switch_pm_text=$fSwitchPmText" } else={ :set $fSwitchPmText "" }
  :if ([:len $fSwitchPmParameter] != 0) do={ :set $fSwitchPmParameter "&switch_pm_parameter=$fSwitchPmParameter" } else={ :set $fSwitchPmParameter "" }

  :set tgUrl "https://api.telegram.org/$botID/answerInlineQuery\?$fInlineQueryId$fResults$fCacheTime$fIsPersonal$fNextOffset$fSwitchPmText$fSwitchPmParameter"

	:if ($fDBGteAnswerInlineQuery = true) do={:put "teAnswerInlineQuery tgUrl = $tgUrl"; :log info "teAnswerInlineQuery tgUrl = $tgUrl"}

  do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]
  } on-error={
    :if ($fDBGteAnswerInlineQuery = true) do={:put "teAnswerInlineQuery ERROR"; :log info "teAnswerInlineQuery ERROR"}
    :return 0
  }

  :if ($content->"status" = "finished")	do={
    :if ($fDBGteAnswerInlineQuery = true) do={:put "teAnswerInlineQuery status = finished"; :log info "teAnswerInlineQuery status = finished"}
    :set result 1
    :return $result
  } else={ :return 0	}
 }
}
