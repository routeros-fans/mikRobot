#---------------------------------------------------teAnswerCallbackQuery--------------------------------------------------------------

#   Function sends a response to a button click
#   Params for this function:

#   1.  fQueryID      -   query id
#   2.  fAnswerText   -   text for answer
#   3.  fAlert        -   alert type (true or false) may be  empty

#   if the global variable fDBGteAnswerCallbackQuery=true, then a debug event will be logged

#---------------------------------------------------teAnswerCallbackQuery--------------------------------------------------------------

:global teAnswerCallbackQuery
:if (!any $teAnswerCallbackQuery) do={ :global teAnswerCallbackQuery do={

  :global dbaseVersion
  :local teAnswerCallbackQueryVersion "2.9.7.22"
  :set ($dbaseVersion->"teAnswerCallbackQuery") $teAnswerCallbackQueryVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

	:local tgUrl []
	:local content []

  :if ([:len $fAlert] = 0) do={ :set $fAlert false }

  :set tgUrl "https://api.telegram.org/$botID/answerCallbackQuery\?callback_query_id=$fQueryID&text=$fAnswerText&show_alert=fAlert"

  do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]
  } on-error={ :return false }

  :if ($content->"status" = "finished")	do={
		:return true
	} else={ :return false }
 }
}
