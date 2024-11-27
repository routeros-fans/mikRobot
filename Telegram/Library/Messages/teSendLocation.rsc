#---------------------------------------------------teSendLocation--------------------------------------------------------------

#   Params for this function:

#   1.  fChatID                 -   Recipient id
#   2.  fLatitude               -   Latitude of the location
#   3.  fLongitude              -   Longitude of the location
#   4.  fHorizontalAccuracy     -   The radius of uncertainty for the location, measured in meters; 0-1500
#   5.  fLivePeriod             -   Period in seconds for which the location will be updated (see Live Locations, should be between 60 and 86400.
#   6.  fProximityAlertRadius   -   For live locations, a maximum distance for proximity alerts about approaching another chat member, in meters. Must be between 1 and 100000 if specified.
#   7.  fProtectContent         -   Protects the contents of the sent message from forwarding and saving
#
#   8.  fReplyMarkup            -   Reply markup (may be empty)

#   Function return message ID or 0

#   if the global variable fDBGteSendLocation=true, then a debug event will be logged

#---------------------------------------------------teSendLocation--------------------------------------------------------------

:global teSendLocation
:if (!any $teSendLocation) do={ :global teSendLocation do={

  :global teDebugCheck
	:local fDBGteSendLocation [$teDebugCheck fDebugVariableName="fDBGteSendLocation"]

  :global dbaseVersion
	:local teSendLocationVersion "2.07.9.22"
	:set ($dbaseVersion->"teSendLocation") $teSendLocationVersion

  :global dbaseBotSettings
  :local botID ($dbaseBotSettings->"botID")

  :local disableWebPagePreview true
	:local parseMode "html"

	:local tgUrl []; :local result []; :local content []

  :if ($fDBGteSendLocation = true) do={:put "teSendLocation started..."; :log info "teSendLocation started..."}

  :if ([:len $fReplyMarkup] != 0) do={
    :set tgUrl "https://api.telegram.org/$botID/sendLocation\?chat_id=$fChatID&latitude=$fLatitude&longitude=$fLongitude\
                                                            &horizontal_accuracy=$fHorizontalAccuracy&live_period=$fLivePeriod\
                                                            &proximity_alert_radius=$fProximityAlertRadius&protect_content=$fProtectContent\
                                                            &reply_markup=$fReplyMarkup"
  } else={
    :set tgUrl "https://api.telegram.org/$botID/sendLocation\?chat_id=$fChatID&latitude=$fLatitude&longitude=$fLongitude\
                                                            &horizontal_accuracy=$fHorizontalAccuracy&live_period=$fLivePeriod\
                                                            &proximity_alert_radius=$fProximityAlertRadius&protect_content=$fProtectContent"
  }

	:if ($fDBGteSendLocation = true) do={:put "teSendLocation tgUrl = $tgUrl"; :log info "teSendLocation tgUrl = $tgUrl"}

  do {
    :set content [:tool fetch ascii=yes url=$tgUrl as-value output=user]

  	:if ($content->"status" = "finished")	do={
      :local tmpStr [:pick ($content->"data") ([:find ($content->"data") "message_id"]) ([:find ($content->"data") "_id"]+20)]
      :local messageID [:pick $tmpStr ([:find $tmpStr "message_id"]+12) ([:find $tmpStr ","])]
      :if ($fDBGteSendLocation = true) do={:put "teSendLocation messageID = $messageID"; :log info "teSendLocation messageID = $messageID"}
  		:set result $messageID
  		:return $result
  	} else={ :return 0	}
  } on-error={
    :if ($fDBGteSendLocation = true) do={:put "teSendLocation ERROR"; :log info "teSendLocation ERROR"}
    :return 0
  }
 }
}
