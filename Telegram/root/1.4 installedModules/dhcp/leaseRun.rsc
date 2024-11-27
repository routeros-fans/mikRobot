#---------------------------------------------------teLeaseRun--------------------------------------------------------------

# https://wiki.mikrotik.com/wiki/Manual:IP/DHCP_Server#Lease_Store_Configuration

# Script that will be executed after lease is assigned or de-assigned. Internal "global" variables that can be used in the script:
# leaseBound - set to "1" if bound, otherwise set to "0"
# leaseServerName - dhcp server name
# leaseActMAC - active mac address
# leaseActIP - active IP address
# lease-hostname - client hostname
# lease-options - array of received options

#---------------------------------------------------teLeaseRun--------------------------------------------------------------

:local allowList "AllowList"
:local blockList "BlockList"

:global teSendMessage
:global dbaseBotSettings
:local showLease ($dbaseBotSettings->"showLease")
:local logSendGroup ($dbaseBotSettings->"logSendGroup")
:local devicePicture ($dbaseBotSettings->"devicePicture")

:local defaultList ($dbaseBotSettings->"defaultList")
#:local defaultList $allowList
#:local defaultList $blockList

:local leaseName $"lease-hostname"

:if ([:len $leaseName] = 0) do={
  :set leaseName "No name"
}

:if ([:len $leaseName] > 25) do={
  :set leaseName [:pick $leaseName 0 24]
}

:if ($showLease=true) do={
  $teLease leaseBound=$leaseBound leaseServerName=$leaseServerName leaseActMAC=$leaseActMAC leaseActIP=$leaseActIP leaseHostname=$leaseName fDefaultList=$defaultList
}

:if (leaseBound = 1) do={
    :local sendText "$devicePicture Device <b>$leaseName</b> IP - <code>$leaseActIP</code> is connected"
    $teSendMessage fChatID=$logSendGroup fText=$sendText
}
