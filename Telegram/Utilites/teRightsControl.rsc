#---------------------------------------------------teRightsControl--------------------------------------------------------------

#   The function checks the user's permissions
#   Params for this function:

#   1. fGroupID       -   chat or group ID
#   2. fRightName     -   name of permission
#   2. fRightValue    -   value of permission, true or false
#   3. fMethod        -   get or put

#   Usage examples:
#   $teRightsControl fMethod=print    -   returns all rights in the form of an array

#   $teRightsControl fMethod=get fGroupID=$GroupID    -   returns all user rights as an array
#   $teRightsControl fMethod=get fGroupID=$GroupID fRightName=$dhcpLease   -    returns the value of the specified right

#   $teRightsControl fMethod=set fGroupID=$GroupID fRightName=$dhcpLease fRightValue=true   -   returns the set value $fRightValue
#   $teRightsControl fMethod=set fGroupID=$GroupID fRightName=$dhcpLease   -   will remove the permission $dhcpLease

#---------------------------------------------------teRightsControl--------------------------------------------------------------

:global teRightsControl
:if (!any $teRightsControl) do={ :global teRightsControl do={

  :global dbaseVersion
  :local teRightsControlVersion "2.9.7.22"
  :set ($dbaseVersion->"teRightsControl") $teRightsControlVersion

  :global dbaseUsers
    do {
      :if ([:len $dbaseUsers] = 0) do={:put "dbaseUsers array is empty"; :return false}

      :if ($fMethod = "print") do={
        :put "------------------------"
        :foreach k,v in=$dbaseUsers do={
          :if ($k !=0) do={
            :put "GroupID = $k"
            :if ([:typeof $v] = "array") do={
              :foreach nm,vl in=$v do={
                :if ($nm~"stat") do={
                  } else={:put "$nm = $vl"}
                }
                :put "------------------------"
              }
          }
        }
        :return $dbaseUsers
      }

      :if ([:len $fGroupID] = 0) do={:put "fGroupID not specified"; :return false}

      :if ($fMethod = "get") do={
        :if ([:len $fRightName] = 0) do={
          :if ([:len ($dbaseUsers->$fGroupID)] = 0) do={:put "fGroupID not found"; :return false}
          :return ($dbaseUsers->$fGroupID)
        } else={
          :if ([:len ($dbaseUsers->$fGroupID->$fRightName)] = 0) do={:put "fRightName not found"; :return false}
          :return ($dbaseUsers->$fGroupID->$fRightName)
        }
      }

      :if ($fMethod = "set") do={
        :if ([:len $fRightName] = 0) do={:put "fRightName not specified"; :return false}
        :if ([:len $fRightValue] = 0) do={
          :set ($dbaseUsers->$fGroupID->$fRightName)
          :put "$fRightName is deleted";
          :return true
        }

        :if ($fRightValue!=true and $fRightValue!=false) do={
          :put "fRightValue may be true or false only - $fRightValue";
          :return false
        }
        :set ($dbaseUsers->$fGroupID->$fRightName) $fRightValue; :put "$fRightName = $fRightValue"
        :return ($dbaseUsers->$fGroupID->$fRightName)
      }

      :put "no method selected"
    } on-error={:put "teRightsControl return ERROR"; :return "teRightsControlError"}
  }
}
