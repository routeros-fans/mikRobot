#---------------------------------------------------teDebugCheck--------------------------------------------------------------

#   The function checks for the presence of a variable in the array and returns its value
#   if the variable is not found false is returned

#   Params for this function:

#   1. fDebugVariableName   -   chat or group ID

#   Usage examples:
#   $teDebugCheck fDebugVariableName="fDBGteSendMessage"    -   returns true or false

#---------------------------------------------------teDebugCheck--------------------------------------------------------------

:global teDebugCheck
:if (!any $teDebugCheck) do={ :global teDebugCheck do={

  :global dbaseVersion
  :local teDebugCheckVersion "2.9.7.22"
  :set ($dbaseVersion->"teDebugCheck") $teDebugCheckVersion

  :global dbaseDebug

  :if ([:len $dbaseDebug]=0) do={:put "dbaseDebug array is empty"; :log info "dbaseDebug array is empty"; :return false}
  :if ([:len $dbaseDebug]=0) do={:put "fDebugVariableName not specified"; :log info "fDebugVariableName not specified"; :return false}

  :if (($dbaseDebug->"$fDebugVariableName")=true) do={
    :return true
  } else={
    :return false
  }
 }
}
