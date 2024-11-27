#---------------------------------------------------tePinMessage--------------------------------------------------------------

#   Use this method to add a message to the list of pinned messages in a chat.
#   Params for this function:

#   1.  fChatID       -   Recipient id
#   2.  fMessageID    -   Message Id

#   Function return $messageID or 0

#   if the global variable fDBGtePinMessage=true, then a debug event will be logged

#---------------------------------------------------tePinMessage--------------------------------------------------------------

:global tePinMessage
:if (!any $tePinMessage) do={ :global tePinMessage do={

  :global teDebugCheck
	:local fDBGtePinMessage [$teDebugCheck fDebugVariableName="fDBGtePinMessage"]

  :global dbaseVersion
  :local tePinMessageVersion "2.9.7.22"
  :set ($dbaseVersion->"tePinMessage") $tePinMessageVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

	:local tgUrl []; :local content []

	:if ($fDBGtePinMessage = true) do={:put "tePinMessage started..."; :log info "tePinMessage started..."}

	:set tgUrl "https://api.telegram.org/$botID/pinchatmessage\?chat_id=$fChatID&message_id=$fMessageID"

  :if ($fDBGtePinMessage = true) do={:put "tePinMessage tgUrl = $tgUrl"; :log info "tePinMessage tgUrl = $tgUrl"}

	do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]

    :if ($content->"status" = "finished")	do={
      :local tmpStr [:pick ($content->"data") ([:find ($content->"data") "message_id"]) ([:find ($content->"data") "_id"]+20)]
      :local messageID [:pick $tmpStr ([:find $tmpStr "message_id"]+12) ([:find $tmpStr ","])]

      :if ($fDBGtePinMessage = true) do={:put "tePinMessage = $fMessageID"; :log info "tePinMessage = $fMessageID"}
      :return $messageID
    }
  } on-error={
    :if ($fDBGtePinMessage = true) do={:put "tePinMessage ERROR"; :log info "tePinMessage ERROR"}
    :return 0
  }
 }
}
