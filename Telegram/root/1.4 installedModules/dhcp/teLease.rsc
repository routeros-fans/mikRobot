#---------------------------------------------------teLease--------------------------------------------------------------

# https://wiki.mikrotik.com/wiki/Manual:IP/DHCP_Server#Lease_Store_Configuration

#   Script that will be executed after lease is assigned or de-assigned. Internal "global" variables that can be used in the script:

#   Params for this function:
#   1. leaseBound      -   set to "1" if bound, otherwise set to "0"
#   2. leaseServerName -   dhcp server name
#   3. leaseActMAC     -   active mac address
#   4. leaseActIP      -   active IP address
#   5. leaseHostname   -   client hostname
#   6. messageID       -   if called from the DHCP server - 0 or empty, otherwise - message ID
#   7. fDefaultList    -

#   The comment is converted to an array
#   commentArray->0    -   leaseNote, text
#   commentArray->1    -   leaseInfo, true or false
#   commentArray->2    -   blocked, true or false
#   commentArray->3    -   record status Updated or Created
#   commentArray->4    -   record date and time
#   commentArray->5    -   record MAC address
#   commentArray->6    -   record hostname
#   commentArray->7    -   params show, true or false
#   commentArray->8    -   rate show, true or false (not used in this version)
#   commentArray->9    -   messageID

#   if the global variable fDBGteLease=true, then a debug event will be logged

#---------------------------------------------------teLease--------------------------------------------------------------

:global teLease
:if (!any $teLease) do={ :global teLease do={

    :global teDebugCheck
    :local fDBGteLease [$teDebugCheck fDebugVariableName="fDBGteLease"]

    :global dbaseVersion
    :local teLeaseVersion "2.13.9.22"
    :set ($dbaseVersion->"teLease") $teLeaseVersion

    :global dbaseBotSettings
  	:local firewallAddressListTimeout ($dbaseBotSettings->"firewallAddressListTimeout")
  	:local leaseGroup ($dbaseBotSettings->"leaseGroup")
    :local logSendGroup ($dbaseBotSettings->"logSendGroup")
  	:local defaultPingCount ($dbaseBotSettings->"defaultPingCount")
    :local devicePicture ($dbaseBotSettings->"devicePicture")
    :local deviceName ("$devicePicture " . ($dbaseBotSettings->"deviceName"))

    :if (!any $dbaseDynLease) do={:global dbaseDynLease [:toarray ""]}

    :local defaultList []
    :if ([:len $fDefaultList] = 0) do={
      :set defaultList ($dbaseBotSettings->"defaultList")
    } else={ :set defaultList $fDefaultList }

    :global teBuildKeyboard
    :global teBuildButton
    :global teEditMessageReplyMarkup
    :global teLeaseCard
    :global teSendMessage

    :global dbaseDynLease

    :global teGetDate
    :global teGetTime
    :local dateM [$teGetDate]
    :local timeM [$teGetTime]

    :local commentArray [:toarray ""]

    :local allowList "AllowList"
    :local blockList "BlockList"
    :local pictAnswer "\E2\9D\97"

    :local isBlocked []
    :local leaseInfo []

    :if ($fDBGteLease = true) do={:put "$messageID $leaseBound $leaseServerName $leaseActMAC $leaseActIP $leaseHostname"; :log info "$messageID $leaseBound $leaseServerName $leaseActMAC $leaseActIP $leaseHostname"}

    :if ($leaseBound = 1) do={
      do {

        :local currentFindAddress []
        :local recordsArray [/ip firewall address-list find comment~"$leaseActMAC" and !disabled]
        :if ([:len $recordsArray] != 0) do={
          do {
            :foreach i in=$recordsArray do={
              :local currentAddress [/ip firewall address-list get [find .id=$i] address]
              :local currentAddressSubNet ($currentAddress&255.255.255.0)
              :local leaseActIpSubNet ($leaseActIP&255.255.255.0)
              :if ($currentAddressSubNet = $leaseActIpSubNet) do={
                :set currentFindAddress $currentAddress
                :error message="address found..."
              } else={ :set currentFindAddress $leaseActIP }
            }
          } on-error={ :if ($fDBGteLease = true) do={:put "$currentFindAddress address found..."; :log warning "$currentFindAddress address found..."} }
        }

        :if ([/ip firewall address-list find comment~"$leaseActMAC" and !disabled and address=$currentFindAddress]) do={
          :set commentArray [:toarray [/ip firewall address-list get [find comment~"$leaseActMAC" and !disabled and address=$currentFindAddress] comment]]

          :if ($fDBGteLease = true) do={
            :put $commentArray; :log info $commentArray
#            :foreach i in=$commentArray do={:log info "$i - type of item:$([:typeof $i])"}
          }

          :set $leaseNote ($commentArray->0)
          :set $leaseInfo ($commentArray->1)
          :set $isBlocked ($commentArray->2)
          :set $leaseParams ($commentArray->7)
          :set $leaseRateShow ($commentArray->8)
          :set $messageID ($commentArray->9)
          :set $messageID [:pick $messageID ([:find $messageID "MSG="]+4) [:len $messageID]]

          :if ($isBlocked = true) do={
            :set $messageID [$teLeaseCard fChatID=$leaseGroup fLeaseHostname=$leaseHostname fLeaseActMAC=$leaseActMAC fLeaseActIP=$leaseActIP isBlocked=$isBlocked leaseInfo=$leaseInfo leaseNote=$leaseNote pingCount="" leaseParams=$leaseParams leaseRateShow=$leaseRateShow fMessageID=$messageID]
            :if ($messageID = 0) do={ :return true }
            :if ([/ip firewall address-list find comment~"$leaseActMAC" and !disabled and address=$currentFindAddress]) do={
              /ip firewall address-list remove [find where comment~"$leaseActMAC" and !disabled and address=$currentFindAddress]
            }
            :if ([:len [/ip dhcp-server lease find mac-address=$leaseActMAC and !disabled and !dynamic and address=$leaseActIP]] != 0) do={
              /ip firewall address-list add list=$blockList address=$leaseActIP comment="$leaseNote,$leaseInfo,$isBlocked,Updated,$dateM $timeM,$leaseActMAC,$leaseHostname,$leaseParams,$leaseRateShow,MSG=$messageID"
            } else={
              /ip firewall address-list add list=$blockList address=$leaseActIP timeout=$firewallAddressListTimeout comment="$leaseNote,$leaseInfo,$isBlocked,Updated,$dateM $timeM,$leaseActMAC,$leaseHostname,$leaseParams,$leaseRateShow,MSG=$messageID"
            }
            :if ($fDBGteLease = true) do={:put "teLease return from $blockList"; :log info "teLease return from $blockList"}
            :return true
          }
          :if ($isBlocked = false) do={
            :set $messageID [$teLeaseCard fChatID=$leaseGroup fLeaseHostname=$leaseHostname fLeaseActMAC=$leaseActMAC fLeaseActIP=$leaseActIP isBlocked=$isBlocked leaseInfo=$leaseInfo leaseNote=$leaseNote pingCount="" leaseParams=$leaseParams leaseRateShow=$leaseRateShow fMessageID=$messageID]
            :if ($messageID = 0) do={ :return true }
            :if ([/ip firewall address-list find comment~"$leaseActMAC" and !disabled and address=$currentFindAddress]) do={
              /ip firewall address-list remove [find where comment~"$leaseActMAC" and !disabled and address=$currentFindAddress]
            }
            :if ([:len [/ip dhcp-server lease find mac-address=$leaseActMAC and !disabled and !dynamic and address=$leaseActIP]] != 0) do={
              /ip firewall address-list add list=$allowList address=$leaseActIP comment="$leaseNote,$leaseInfo,$isBlocked,Updated,$dateM $timeM,$leaseActMAC,$leaseHostname,$leaseParams,$leaseRateShow,MSG=$messageID"
            } else={
              /ip firewall address-list add list=$allowList address=$leaseActIP timeout=$firewallAddressListTimeout comment="$leaseNote,$leaseInfo,$isBlocked,Updated,$dateM $timeM,$leaseActMAC,$leaseHostname,$leaseParams,$leaseRateShow,MSG=$messageID"
            }

            :if ($fDBGteLease = true) do={:put "teLease return from $allowList"; :log info "teLease return from $allowList"}
            :return true
          }
        } else={

          :if ($defaultList~$allowList) do={ :set isBlocked false}
          :if ($defaultList~$blockList) do={ :set isBlocked true}

          :set $leaseNote false; :set $leaseInfo false; :set $leaseParams false; :set $leaseRateShow false; :set $messageID 0

          do {
            :foreach k,v in=$dbaseDynLease do={
              :if (($v->5) = $leaseActMAC) do={
                :local currentAddressSubNet (($v->10)&255.255.255.0)
                :local leaseActIpSubNet ($leaseActIP&255.255.255.0)
                :if ($currentAddressSubNet = $leaseActIpSubNet) do={
                  :set $leaseNote ($v->0)
                  :set $leaseInfo ($v->1)
                  :set $isBlocked ($v->2)
                  :set $leaseParams ($v->7)
                  :set $leaseRateShow ($v->8)
                  :set $messageID $k
                  :set ($dbaseDynLease->$k)
                  :error message="Record found in leaseArray"
                }
              }
            }
          } on-error={:if ($fDBGteLease = true) do={:put "teLease Record found in leaseArray"; :log warning "teLease Record found in leaseArray"}}

          :if ($fDBGteLease = true) do={:log info "teLease defaultList=$defaultList fChatID=$leaseGroup fLeaseHostname=$leaseHostname fLeaseActMAC=$leaseActMAC fLeaseActIP=$leaseActIP isBlocked=$isBlocked leaseInfo=$leaseInfo leaseNote=$leaseNote pingCount=$defaultPingCount leaseParams=$leaseParams leaseRateShow=$leaseRateShow fMessageID=$messageID"}

          :set $messageID [$teLeaseCard fChatID=$leaseGroup fLeaseHostname=$leaseHostname fLeaseActMAC=$leaseActMAC fLeaseActIP=$leaseActIP isBlocked=$isBlocked leaseInfo=$leaseInfo leaseNote=$leaseNote pingCount="" leaseParams=$leaseParams leaseRateShow=$leaseRateShow fMessageID=$messageID]
          :if ($messageID = 0) do={
            :if ($fDBGteLease = true) do={:put "teLease NEW message Error messageID = $messageID"; :log info "teLease NEW message Error messageID = $messageID"}
            :local sendText "$pictAnswer <b>$deviceName: $dateM $timeM</b>%0D%0A%0D%0A<b>Error:</b>Card for <b>DHCP lease</b> <code>$leaseActIP</code> not send.%0D%0AThe name <b>must not contain Russian characters</b>."
            $teSendMessage fChatID=$logSendGroup fText=$sendText
          }
          :if ($fDBGteLease = true) do={:put "teLease NEW messageID = $messageID"; :log info "teLease  NEW messageID = $messageID"}
          /ip firewall address-list add list=$defaultList address=$leaseActIP timeout=$firewallAddressListTimeout comment="$leaseNote,$leaseInfo,$isBlocked,Created,$dateM $timeM,$leaseActMAC,$leaseHostname,$leaseParams,$leaseRateShow,MSG=$messageID"

          :if ($fDBGteLease = true) do={:put "teLease return from newDevice"; :log info "teLease return from newDevice"}
          :return true
        }
      } on-error={:put "teLease leaseBound 1 dinamic ERROR"; :log info "teLease leaseBound 1 dinamic ERROR"}

    }
#   End leaseBound = 1

#---------------------------------------------------------------------------------------------------------------------------------------------

#   leaseBound = 0

    :if ($leaseBound = 0) do={

      do {
        :if ($fDBGteLease = true) do={:put "leaseBound 0"; :log info "leaseBound 0"}

        :if ([/ip firewall address-list find comment~"$leaseActMAC" and !disabled and address=$leaseActIP]) do={

            :set commentArray [:toarray [/ip firewall address-list get [find comment~"$leaseActMAC" and !disabled and address=$leaseActIP] comment]]

            :if ($fDBGteLease = true) do={
              :foreach i in=$commentArray do={:log info "$i - type of item:$([:typeof $i])"}
              :put $commentArray; :log info $commentArray
            }

            :set $messageID ($commentArray->9)
            :set $messageID [:pick $messageID ([:find $messageID "MSG="]+4) [:len $messageID]]
            :if ($fDBGteLease = true) do={:put "teLease leaseBound 0 messageID = $messageID"; :log info "teLease leaseBound 0 messageID = $messageID"}

            :if ($messageID = 0) do={
              :if ($fDBGteLease = true) do={:put "teLease bound 0 message Error messageID = $messageID"; :log info "teLease bound 0 message Error messageID = $messageID"}
              :local sendText "$pictAnswer <b>$deviceName: $dateM $timeM</b>%0D%0A%0D%0A<b>Error:</bCard for <b>DHCP lease</b> <code>$leaseActIP</code> not edit.%0D%0AThe name <b>must not contain Russian characters</b>."
              $teSendMessage fChatID=$logSendGroup fText=$sendText
              :error message="null pointer"
            }

            :if ([:len [/ip firewall address-list get [find comment~"$leaseActMAC" and !disabled and address=$leaseActIP] timeout]] != 0) do={
              :set ($dbaseDynLease->0) "dbaseDynLease"
              :set ($dbaseDynLease->$messageID) ({($commentArray->0);($commentArray->1);($commentArray->2);($commentArray->3);($commentArray->4);($commentArray->5);($commentArray->6);($commentArray->7);($commentArray->8);($commentArray->9);$leaseActIP})
              /ip firewall address-list remove [find where comment~"$leaseActMAC" and !disabled and address=$leaseActIP]
            }

            :local pictWaiting "\F0\9F\95\93"
            :local buttonWaitingCallBackText "teCallbackLeaseCard,waiting,request"
            :local buttonWaiting [$teBuildButton fPictButton=$pictWaiting fTextButton="  Waiting..." fTextCallBack=$buttonWaitingCallBackText]

            :local lineButtons "$buttonWaiting"
            :local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$lineButtons fReplyKeyboard=false]

            $teEditMessageReplyMarkup fChatID=$leaseGroup fMessageID=$messageID fReplyMarkup=$replyMarkup
            :return true
        }
      } on-error={:put "teLease leaseBound 0 ERROR"; :log info "teLease leaseBound 0 ERROR"}
    }
#   End leaseBound = 0
 }
}
