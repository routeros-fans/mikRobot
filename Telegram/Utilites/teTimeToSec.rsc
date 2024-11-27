#---------------------------------------------------teTimeToSec--------------------------------------------------------------

#   Function convert time to seconds

#   Params for this function:
#   1. fTime   -   the value to be converted

#---------------------------------------------------teTimeToSec--------------------------------------------------------------

:global teTimeToSec
:if (!any $teTimeToSec) do={ :global teTimeToSec do={
    do {
      :local currentTime [$fTime]
      :local currentHoMin [:pick $currentTime 0 5]
      :local currentSec [:pick $currentTime 6 8]

      :local dstDelta [/system clock manual get dst-delta]
      /system clock manual set dst-delta="$currentHoMin"
      :local timeInSec [/system clock manual get dst-delta]
      /system clock manual set dst-delta=(($dstDelta/60)/60)

      :local timeInSecFull [($timeInSec + $currentSec)]
      :put "timeInSecFull = $timeInSecFull"
      :return $timeInSecFull

    } on-error={
      :log info "Function teTimeToSec return ERROR"; :put "Function teTimeToSec return ERROR"
      :return 0
    }
  }
}
