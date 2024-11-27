#---------------------------------------------------teGetTime--------------------------------------------------------------

#   Function returns the current time format hh:mm:ss

#   No params.

#---------------------------------------------------teGetTime--------------------------------------------------------------

:global teGetTime
:if (!any $teGetTime) do={ :global teGetTime do={
	:local timeM [/system clock get time]
	:return $timeM
  }
}
