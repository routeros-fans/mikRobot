#---------------------------------------------------teModules--------------------------------------------------------------

#   Function sends or edits a message to the recipient.
#   Params for this function:

#   1.  fChatID   		-   Recipient id
#   2.  fMessageID 		-   Recipient message id (may be empty). if empty then the message will be sent, otherwise it will be edited
#   2.  fCommand	 		-   Recipient message id (may be empty). if empty then the message will be sent, otherwise it will be edited

#   Function return 1 or 0

#   if the global variable fDBGteModules=true, then a debug event will be logged

#---------------------------------------------------teModules--------------------------------------------------------------

:global teModules
:if (!any $teModules) do={ :global teModules do={

		:global dbaseVersion
		:local teModulesVersion "2.8.8.22"
		:set ($dbaseVersion->"teModules") $teModulesVersion

		:global dbaseBotSettings
		:local pppGroup ($dbaseBotSettings->"pppGroup")
		:local leaseGroup ($dbaseBotSettings->"leaseGroup")
		:local usersGroup ($dbaseBotSettings->"usersGroup")
		:local ifaceGroup ($dbaseBotSettings->"ifaceGroup")
		:local devicePicture ($dbaseBotSettings->"devicePicture")
		:local deviceName ("$devicePicture" . " " . ($dbaseBotSettings->"deviceName"))
		:local imageRoot ($dbaseBotSettings->"imageRoot")

		:global teDebugCheck
		:local fDBGteModules [$teDebugCheck fDebugVariableName="fDBGteModules"]

		:global teSendPhoto
		:global teSendMessage
		:global teEditCaption
		:global teEditMessageReplyMarkup
		:global teEditMedia
		:global teBuildKeyboard
		:global teBuildButton
		:global teBuildReplyButton
		:global teSetMyCommands

		:local result []

		:if ($fDBGteModules = true) do={:put "teModules building..."; :log info "teModules building..."}

		:local NB ","
		:local NL "\5D,\5B"

		:local oneFeed "%0D%0A"
		:local doubleFeed "%0D%0A%0D%0A"

		:local pictUsers "\F0\9F\91\BD"
		:local buttonUsers [$teBuildButton fPictButton=$pictUsers fTextButton="  Users" fTextCallBack="teCallbackRootMenu,modules,users"]

		:local pictUsersPrint "\F0\9F\96\A8 \F0\9F\91\BD"
		:local buttonUsersPrint [$teBuildButton fPictButton=$pictUsersPrint fTextButton="  Users" fTextCallBack="teCallbackRootMenu,modules,usersPrint"]

		:local pictUsersList "\F0\9F\93\84"
		:local usersLink [:pick $usersGroup 4 [:len $usersGroup]]
		:local buttonUrlUsers "https://t.me/c/$usersLink/123"
		:local buttonUsersList [$teBuildButton fPictButton=$pictUsersList fUrlButton=$buttonUrlUsers fTextButton="   list" fTextCallBack="teCallbackRootMenu,modules,usersList"]

		:local pictPppServers "\F0\9F\94\90"
		:local buttonPppServers [$teBuildButton fPictButton=$pictPppServers fTextButton="  PPP SRV" fTextCallBack="teCallbackRootMenu,modules,pppServers"]

		:local pictPppPrintServers "\F0\9F\96\A8 \F0\9F\94\90"
		:local buttonPppPrintServers [$teBuildButton fPictButton=$pictPppPrintServers fTextButton="  PPP" fTextCallBack="teCallbackRootMenu,modules,pppPrintServers"]

		:local pictPppPrintClients "\F0\9F\96\A8 \F0\9F\93\B1"
		:local buttonPppPrintClients [$teBuildButton fPictButton=$pictPppPrintClients fTextButton="  PPP" fTextCallBack="teCallbackRootMenu,modules,pppPrintClients"]

		:local pictPPP "\F0\9F\93\B1"
		:local pppLink [:pick $pppGroup 4 [:len $pppGroup]]
		:local buttonUrlPpp "https://t.me/c/$pppLink/123"
		:local buttonPPP [$teBuildButton fPictButton=$pictPPP fUrlButton=$buttonUrlPpp fTextButton="  clients" fTextCallBack="teCallbackRootMenu,modules,pppClients"]

		:local pictDhcpServers "\F0\9F\95\B0"
		:local buttonDHCPServers [$teBuildButton fPictButton=$pictDhcpServers fUrlButton=$buttonUrl fTextButton="   DHCP SRV" fTextCallBack="teCallbackRootMenu,modules,dhcpServers"]

		:local pictDhcpServersPrint "\F0\9F\96\A8 \F0\9F\95\B0"
		:local buttonDHCPServersPrint [$teBuildButton fPictButton=$pictDhcpServersPrint fTextButton="   DHCP" fTextCallBack="teCallbackRootMenu,modules,dhcpServersPrint"]

		:local pictDhcpClientsPrint "\F0\9F\96\A8 \F0\9F\95\91"
		:local buttonDHCPClientsPrint [$teBuildButton fPictButton=$pictDhcpClientsPrint fTextButton="   DHCP" fTextCallBack="teCallbackRootMenu,modules,dhcpClientsPrint"]

		:local pictDhcpLease "\F0\9F\95\91"
		:local dhcpLink [:pick $leaseGroup 4 [:len $leaseGroup]]
		:local buttonUrlDhcp "https://t.me/c/$dhcpLink/123"
		:local buttonDhcpLease [$teBuildButton fPictButton=$pictDhcpLease fUrlButton=$buttonUrlDhcp fTextButton="   leases" fTextCallBack="teCallbackRootMenu,modules,dhcpLease"]

		:local pictInerfaces "\F0\9F\94\97"
		:local buttonInerfaces [$teBuildButton fPictButton=$pictInerfaces fTextButton="  Interfaces control" fTextCallBack="teCallbackRootMenu,modules,inerfaces"]

		:local pictInerfacesPrint "\F0\9F\96\A8 \F0\9F\94\97"
		:local buttonInerfacesPrint [$teBuildButton fPictButton=$pictInerfacesPrint fTextButton="  Interfaces" fTextCallBack="teCallbackRootMenu,modules,inerfacesPrint"]

		:local pictInerfacesList "\F0\9F\93\84"
		:local interfacesLink [:pick $ifaceGroup 4 [:len $ifaceGroup]]
		:local buttonUrlInterfaces "https://t.me/c/$interfacesLink/123"
		:local buttonInerfacesList [$teBuildButton fPictButton=$pictInerfacesList fUrlButton=$buttonUrlInterfaces fTextButton="   list" fTextCallBack="teCallbackRootMenu,modules,inerfacesList"]

		:local pictBackward "\E2\AC\85"
		:local buttonBackward [$teBuildButton fPictButton=$pictBackward fTextButton="   Back" fTextCallBack="teCallbackRootMenu,backward,teRootMenu"]

		:local currentButtons ""
		:local currentInfo ""
		:local currentHead ""
		:local currentModule ""
		:if ([:len $fCommand] = 0) do={
			:set currentButtons "$buttonUsers$NL$buttonPppServers$NL$buttonDHCPServers$NL$buttonInerfaces$NL$buttonBackward"
		} else={

			:local usersPressed false
			:if ($fCommand = "users" or $fCommand = "usersPrint") do={
				:set usersPressed true
				:set currentHead "<i> - users:</i>$doubleFeed"

				:if ($fCommand = "users") do={
					:set currentButtons ($currentButtons . "$buttonUsersPrint$NB$buttonUsersList")
				}

				:local usersInfo ""
				:if ($fCommand = "usersPrint") do={
					:set currentButtons ($currentButtons . "$buttonUsersPrint$NB$buttonUsersList")

					:local usersEnabled ("<b>Enabled:</b>\t\t" . [:len [/user print as-value where !disabled]] . "$oneFeed")
					:local usersDisabled ("Disabled:\t" . [:len [/user print as-value where disabled]] . "$oneFeed-------------------------$oneFeed")
					:local usersTotal ("<b>Total:\t\t\t" . [:len [/user print as-value]] . "</b>$doubleFeed")
					:set currentInfo ($usersEnabled . $usersDisabled . $usersTotal)

					:local usersAllEnabled [/user print detail as-value where !disabled]
					:foreach k,v in=$usersAllEnabled do={

						:local userMessageID ([:toarray [/user get [find name=($v->"name")] comment]]->1)
						:local currentUserName ($v->"name")
						:set userMessageID [:pick $userMessageID 4 [:len $userMessageID]]
						:set currentUserName "<a href=\"https://t.me/c/$usersLink/$userMessageID\">$currentUserName</a>"

						:set usersInfo ""
						:local userName ("<b>Name:</b>\t\t" . $currentUserName . ";\t\t")
						:local userGroup ("<b>Group:</b>\t" . ($v->"group") . "$oneFeed")

						:local userAllowedAddress ($v->"address")
						:if ([:len $userAllowedAddress] != 0) do={
							:set userAllowedAddress ("Allowed address:\t" . [:tostr ($v->"address")] . "$oneFeed")
						} else={:set userAllowedAddress ""}

						:local userLastLoginTime ($v->"last-logged-in")
						:if ([:len $userLastLoginTime] = 0) do={:set userLastLoginTime "newer"}
						:local userLastLogin ("<b>Last login:</b>\t" . $userLastLoginTime . "$oneFeed")

						:local userActive [/user active find name=($v->"name")]
						:if ([:len $userActive] != 0) do={
							:set userActive ("<b>Active:\t" . [:len $userActive] . "</b> sessions$doubleFeed")
						} else={:set userActive "$oneFeed"}

						:set $usersInfo ($userName . $userGroup . $userAllowedAddress . $userLastLogin . $userActive)
						:set currentInfo ($currentInfo . $usersInfo)
					}
					:if ([:len $currentInfo] >= 924) do={:set currentInfo ($usersEnabled . $usersDisabled . $usersTotal)}
				}
			}
			:if ($usersPressed = false) do={
				:set currentButtons ($currentButtons . "$NL$buttonUsers")
			}

			:local pppServersPressed false
			:if ($fCommand = "pppServers" or $fCommand = "pppPrintServers"  or $fCommand = "pppPrintClients") do={
				:set pppServersPressed true
				:set currentHead "<i> - ppp:</i>$doubleFeed"

				:if ($fCommand = "pppServers") do={:set currentButtons ($currentButtons . "$NL$buttonPppPrintClients$NB$buttonPPP")}

				:if ($fCommand = "pppPrintClients") do={
					:set currentButtons ($currentButtons . "$NL$buttonPppPrintServers$NB$buttonPPP")
					:set currentHead "<i> - ppp Clients:</i>$doubleFeed"

					:local pppActiveClientsInfo ""
					:local pppActiveClients [/ppp active print detail as-value]
					:if ([:len $pppActiveClients] != 0 and [:len $pppActiveClients] <= 5) do={

						:foreach k,v in=$pppActiveClients do={
							:set pppActiveClientsInfo ""

							:local callerIdLink ([:toarray [/ppp active get [find name=($v->"name")] comment]]->1)
							:local currentCallerID ($v->"caller-id")
							:set callerIdLink [:pick $callerIdLink 4 [:len $callerIdLink]]
							:set callerIdLink "<a href=\"https://t.me/c/$pppLink/$callerIdLink\">$currentCallerID</a>"
							:local pppActiveService (";\t<b>" . ($v->"service") . "</b>")
							:local pppActiveName ("<b>Name:</b>\t\t\t\t\t" . ($v->"name") . "$pppActiveService$oneFeed")
							:local pppActiveCallerId ("<b>Caller:</b>\t\t\t\t\t" . $callerIdLink . "$oneFeed")
							:local pppActiveUpTime ("<b>Uptime:</b>\t\t\t" . ($v->"uptime") . "$doubleFeed")

							:set pppActiveClientsInfo ($pppActiveName . $pppActiveCallerId . $pppActiveAddress . $pppActiveUpTime)
							:set currentInfo ($currentInfo . $pppActiveClientsInfo)
						}
					}

					:if ([:len $pppActiveClients] > 5 and [:len $pppActiveClients] <= 15) do={
						:local counter 1
						:foreach k,v in=$pppActiveClients do={
							:set pppActiveClientsInfo ""

							:local callerNameLink ([:toarray [/ppp active get [find name=($v->"name")] comment]]->1)
							:local currentCallerName ($v->"name")
							:set callerNameLink [:pick $callerNameLink 4 [:len $callerNameLink]]
							:set callerNameLink "<a href=\"https://t.me/c/$pppLink/$callerNameLink\">$currentCallerName</a>"
							:local pppActiveService (";\t<b>" . ($v->"service") . "</b>")
							:local pppActiveName ("<b>Name:</b>\t\t\t\t\t" . $callerNameLink . "$pppActiveService$oneFeed")
							:if ($counter = 3) do={
								:set pppActiveName ($pppActiveName . "$oneFeed")
								:set counter 0
							}
							:set pppActiveClientsInfo $pppActiveName
							:set currentInfo ($currentInfo . $pppActiveClientsInfo)
							:set counter ($counter + 1)
						}
					}
					:if ([:len $currentInfo] = 0) do={:set currentInfo "<b>No active clients</b>"}
					:if ([:len $currentInfo] > 1000) do={
						:local pppActiveClientsCount ("<b>Active clients:</b>\t\t\t" . [:len $pppActiveClients] . "\t units$doubleFeed")
						:set currentInfo $pppActiveClientsCount
					}
				}
				:if ($fCommand = "pppPrintServers") do={
					:set currentButtons ($currentButtons . "$NL$buttonPppPrintClients$NB$buttonPPP")
					:set currentHead "<i> - ppp Servers:</i>$doubleFeed"

					:local pptpServerInfo []
					:local pptpServer [/interface pptp-server server print as-value]
					:local pptpServerEnabled ($pptpServer->"enabled")
					:if ($pptpServerEnabled = true) do={
						:set pptpServerEnabled ("<b>PPTP:</b>\t\t\ttrue" . "$oneFeed")
						:local pptpServerAuth ("Auth:\t\t\t\t" . [:tostr ($pptpServer->"authentication")] . "$oneFeed")
						:local pptpServerProfile ("Profile:\t" . ($pptpServer->"default-profile") . "$doubleFeed")

						:set pptpServerInfo ($pptpServerInfo . $pptpServerEnabled . $pptpServerAuth . $pptpServerProfile)
						:set currentInfo $pptpServerInfo
					}

					:local sstpServerInfo []
					:local sstpServer [/interface sstp-server server print as-value]
					:local sstpServerEnabled ($sstpServer->"enabled")
					:if ($sstpServerEnabled = true) do={
						:local sstpServerPort ($sstpServer->"port")
						:set sstpServerEnabled ("<b>SSTP:\t\t\t</b>true" . ";\t\t<b>port:</b> $sstpServerPort$oneFeed")
						:local sstpServerCert ("<b>Sert:</b>\t\t\t\t " . ($sstpServer->"certificate") . ";\t\t<b>TLS:</b> " . ($sstpServer->"tls-version") . "$oneFeed")
						:local sstpServerAuth ("Auth:\t\t\t\t" . [:tostr ($sstpServer->"authentication")] . "$oneFeed")
						:local sstpServerProfile ("Profile:\t" . ($sstpServer->"default-profile") . "$doubleFeed")

						:set sstpServerInfo ($sstpServerInfo . $sstpServerEnabled . $sstpServerCert . $sstpServerAuth . $sstpServerProfile)
						:set currentInfo ($currentInfo . $sstpServerInfo)
					}

					:local lltpServerInfo []
					:local lltpServer [/interface l2tp-server server print as-value]
					:local lltpServerEnabled ($lltpServer->"enabled")
					:if ($lltpServerEnabled = true) do={

						:local keepAlive (";\t<b>KeAl:</b> " . ($lltpServer->"keepalive-timeout"))
						:if ($keepAlive = "disabled") do={:set keepAlive ""}

						:local maxSessions ($lltpServer->"max-sessions")
						:if ($maxSessions = 0) do={
							:set maxSessions ""
						}	else={
							:set maxSessions ";\t<b>MaxS:</b>\t$maxSessions"
						}

						:local useIPsec ($lltpServer->"use-ipsec")
						:if ($useIPsec != "no") do={
							:local ipSecSecret ($lltpServer->"ipsec-secret")
							:set useIPsec "$useIPsec;\t<b>Sec:</b> $ipSecSecret"
						}
						:set lltpServerEnabled ("<b>L2TP:\t\t\t\t</b>true" . "$keepAlive$maxSessions$oneFeed")
						:local lltpUseIPsec "<b>IPSec:</b>\t\t $useIPsec$oneFeed"
						:local lltpServerProfile ("Profile:\t\t" . ($lltpServer->"default-profile") . "$oneFeed")
						:local lltpCallerId ("<b>CID:</b>\t\t\t\t\t\t\t" . ($lltpServer->"caller-id-type") . "$oneFeed")
						:local lltpServerAuth ("Auth:\t\t\t\t\t" . [:tostr ($lltpServer->"authentication")] . "$doubleFeed")

						:set lltpServerInfo ($lltpServerInfo . $lltpServerEnabled . $lltpUseIPsec . $lltpServerProfile . $lltpCallerId . $lltpServerAuth)
						:set currentInfo ($currentInfo . $lltpServerInfo)
					}

					:local ovpnServerInfo []
					:local ovpnServer [/interface ovpn-server server print as-value]
					:local ovpnServerEnabled ($ovpnServer->"enabled")
					:if ($ovpnServerEnabled = true) do={

						:local ovpnPort (";\t<b>Port:</b> " . ($ovpnServer->"port"))

						:local ovpnRequireClientCert ($ovpnServer->"require-client-certificate")
						:if ($ovpnRequireClientCert) do={
						 :set ovpnRequireClientCert ";\t<b>Require Client Cert</b>"
						} else={:set ovpnRequireClientCert ""}

						:local keepAlive (";\t<b>KeAl:</b> " . ($ovpnServer->"keepalive-timeout"))
						:if ($keepAlive = "disabled") do={:set keepAlive ""}

						:set ovpnServerEnabled ("<b>OVPN:\t\t\t</b>true" . "$ovpnPort$keepAlive$oneFeed")
						:local ovpnMode ("Mode:\t\t\t\t" . ($ovpnServer->"mode") . ";\t<b>Mask:</b> " . ($ovpnServer->"netmask") . "$oneFeed")
						:local ovpnMAC ("<b>MAC:</b>\t\t\t\t\t" . ($ovpnServer->"mac-address") . "$oneFeed")
						:local ovpnServerProfile ("Profile:\t\t " . ($ovpnServer->"default-profile") . "$oneFeed")
						:local ovpnServerCert ("<b>Sert:</b>\t\t\t\t\t\t\t" . ($ovpnServer->"certificate") . "$ovpnRequireClientCert" . "$oneFeed")
						:local ovpnServerAuth ("Auth:\t\t\t\t\t\t" . [:tostr ($ovpnServer->"auth")] . "$oneFeed")
						:local ovpnServerCipher ("<b>Cipher:</b>\t\t\t" . [:tostr ($ovpnServer->"cipher")] . "$doubleFeed")

						:set ovpnServerInfo ($ovpnServerInfo . $ovpnServerEnabled . $ovpnMode . $ovpnMAC . $ovpnServerProfile . $ovpnServerCert . $ovpnServerAuth . $ovpnServerCipher)
						:set currentInfo ($currentInfo . $ovpnServerInfo)
					}

					:local poeServerInfo []
					:local poeServers [/interface pppoe-server server print detail as-value where !disabled]
					:if ([:len $poeServers] != 0) do={
						:local poeServerCount ("<b>PPPoE:\t\t" . [:len $poeServers] . "</b> services is configured$oneFeed")
						:set currentInfo ($currentInfo . $poeServerCount)
					}

					:if ([:len $currentInfo] = 0) do={:set currentInfo "<b>No servers are configured</b>"}
				}
			}
			:if ($pppServersPressed = false) do={
				:set currentButtons ($currentButtons . "$NL$buttonPppServers")
			}
			:local dhcpServersPressed false
			:if ($fCommand = "dhcpServers" or $fCommand = "dhcpServersPrint" or $fCommand = "dhcpClientsPrint") do={
				:set dhcpServersPressed true
				:set currentHead "<i> - dhcp:</i>$doubleFeed"
				:if ($fCommand = "dhcpServers") do={ :set currentButtons ($currentButtons . "$NL$buttonDHCPClientsPrint$NB$buttonDhcpLease") }
				:if ($fCommand = "dhcpClientsPrint") do={
					:set currentButtons ($currentButtons . "$NL$buttonDHCPServersPrint$NB$buttonDhcpLease")
					:set currentHead "<i> - dhcp Leases:</i>$doubleFeed"
					:local dhcpClientsInfo ""
					:local leaseDynamicCount [:len [/ip dhcp-server lease print as-value where dynamic and !disabled]]
					:local leaseStaticCount [:len [/ip dhcp-server lease print as-value where !dynamic and !disabled]]
					:local leaseDisabledCount [:len [/ip dhcp-server lease print as-value where disabled]]
					:local leaseBlockedCount [:len [/ip dhcp-server lease print as-value where block-access and !disabled]]
					:local leaseRadiusCount [:len [/ip dhcp-server lease print as-value where radius and !disabled]]
					:local leaseTotalCount [:len [/ip dhcp-server lease print as-value]]
					:local leaseBoundCount [:len [/ip dhcp-server lease print as-value where status=bound and !disabled]]
					:local leaseWaitingCount [:len [/ip dhcp-server lease print as-value where status=waiting and !disabled]]
					:local leaseOfferedCount [:len [/ip dhcp-server lease print as-value where status=offered and !disabled]]
					:local leaseStatic ("<b>Static:</b>\t\t\t\t\t\t\t\t\t$leaseStaticCount" . "$oneFeed")
					:local leaseDynamic ("Dynamic:\t\t\t $leaseDynamicCount" . "$oneFeed")
					:local leaseDisabled ("<b>Disabled:</b>\t\t\t\t$leaseDisabledCount" . "$oneFeed-------------------------$oneFeed")
					:local leaseTotal ("<b>Total:\t\t\t\t\t\t\t\t\t\t$leaseTotalCount</b>" . "$doubleFeed")
					:local leaseBound ("<b>Lease bound:</b>\t\t\t\t$leaseBoundCount" . "$oneFeed")
					:local leaseWaiting ("Lease waiting:\t\t$leaseWaitingCount" . "$oneFeed")
					:local leaseOffered ("<b>Lease offered:</b>\t\t$leaseOfferedCount" . "$doubleFeed")
					:local leaseBlocked ("Blocked:\t\t\t\t$leaseBlockedCount" . "$oneFeed")
					:local leaseRadius ("<b>Radius:</b>\t\t\t\t\t\t$leaseRadiusCount" . "$oneFeed")
					:set dhcpClientsInfo ($dhcpClientsInfo . $leaseStatic . $leaseDynamic . $leaseDisabled . $leaseTotal . $leaseBound . $leaseWaiting . $leaseOffered . $leaseBlocked . $leaseRadius)
					:set currentInfo $dhcpClientsInfo
				}

				:if ($fCommand = "dhcpServersPrint") do={
					:set currentButtons ($currentButtons . "$NL$buttonDHCPClientsPrint$NB$buttonDhcpLease")
					:set currentHead "<i> - dhcp Servers:</i>$doubleFeed"

					:local dhcpServerInfo ""; :local dhcpServerName ""
					:local dhcpServerInterface ""; :local dhcpServerLiaseTime ""
					:local dhcpServerAddressPool ""; :local dhcpServerScript ""
					:local dhcpServerRadius ""

					:local dhcpServers [/ip dhcp-server print detail as-value where !disabled]
					:if ([:len $dhcpServers] != 0 and [:len $dhcpServers] <= 5) do={

						:foreach k,v in=$dhcpServers do={
							:set dhcpServerName ("<b>Name:</b> " . ($v->"name") . "$oneFeed")
							:set dhcpServerInterface ("Interface: " . ($v->"interface") . "$oneFeed")
							:set dhcpServerLiaseTime ("<b>Lease-time:</b> " . ($v->"lease-time") . "$oneFeed")
							:set dhcpServerAddressPool ("Address pool: " . ($v->"address-pool") . "$oneFeed")
							:if (($v->"use-radius") != "no") do={
								:set dhcpServerRadius ("<b>Use radius:</b>\t" . ($v->"use-radius") . "$oneFeed")
							}
							:local leaseScriptLen ($v->"lease-script")
							:if ([:len $leaseScriptLen] != 0) do={
								:set dhcpServerScript ("<b>Lease-script:</b> exists" . "$oneFeed")
							} else={ :set dhcpServerScript "" }
							:set dhcpServerInfo ($dhcpServerInfo . $dhcpServerName . $dhcpServerInterface . $dhcpServerLiaseTime . $dhcpServerAddressPool . $dhcpServerRadius . $dhcpServerScript . $oneFeed)
							:set currentInfo $dhcpServerInfo
						}
					}
					:if ([:len $dhcpServers] != 0 and [:len $dhcpServers] > 5) do={
						:local counter 1
						:foreach k,v in=$dhcpServers do={
							:set dhcpServerName ("<b>Name:</b> " . ($v->"name") . "; ")
							:set dhcpServerInterface ("<b>Iface:</b> " . ($v->"interface") . "$oneFeed")
							:if ($counter = 3) do={
								:set dhcpServerInterface ($dhcpServerInterface . "$oneFeed")
								:set counter 0
							}
							:set dhcpServerInfo ($dhcpServerInfo . $dhcpServerName . $dhcpServerInterface)
							:set currentInfo $dhcpServerInfo
							:set counter ($counter + 1)
						}
					}
					:if ([:len $currentInfo] >= 1000) do={:set currentInfo ("<b>DHCP servers count:</b>\t\t" . [:len $dhcpServers] . "$doubleFeed")}
				}
			}
			:if ($dhcpServersPressed = false) do={
				:set currentButtons ($currentButtons . "$NL$buttonDHCPServers")
			}

			:local inerfacesPressed false
			:if ($fCommand = "inerfaces" or $fCommand = "inerfacesPrint") do={
				:set currentButtons ($currentButtons . "$NL$buttonInerfacesPrint$NB$buttonInerfacesList")
				:set inerfacesPressed true
				:set currentHead "<i> - inerfaces:</i>$doubleFeed"
				:local ifaceInfo ""
				:if ($fCommand = "inerfacesPrint") do={
					:local ifaceEther [/interface print detail as-value where type=ether]
					:local ifaceEtherDisabled [/interface print detail as-value where disabled and type=ether]
					:local ifaceEtherRuning [/interface print detail as-value where running and type=ether]
					:local ifaceWlan [/interface print detail as-value where type=wlan]
					:local ifaceWlanRuning [/interface print detail as-value where running and type=wlan]
					:local ifaceWlanDisabled [/interface print detail as-value where disabled and type=wlan]

					:local ifaceBrige [/interface print detail as-value where type=bridge]
					:local ifaceBrigeDisabled [/interface print detail as-value where type=bridge and disabled]
					:local ifaceBrigeRuning [/interface print detail as-value where running and type=bridge]

					:local ifaceVlan [/interface print detail as-value where type=vlan]
					:local ifaceVlanDisabled [/interface print detail as-value where type=vlan and disabled]
					:local ifaceVlanRuning [/interface print detail as-value where running and type=vlan]

					:local ifaceOther [/interface print detail as-value where type!=ether and type!=wlan and type!=bridge and type!=vlan]
					:local ifaceOtherDisabled [/interface print detail as-value where disabled and type!=ether and type!=wlan and type!=bridge and type!=vlan]
					:local ifaceOtherRuning [/interface print detail as-value where running and type!=ether and type!=wlan and type!=bridge and type!=vlan]
					:local ifaceOtherDynamic [/interface print detail as-value where dynamic and type!=ether and type!=wlan and type!=bridge and type!=vlan]

					:local ifaceTotal [/interface print detail as-value]
					:local ifaceTotalEnabled [/interface print detail as-value where !disabled]
					:local ifaceTotalDisabled [/interface print detail as-value where disabled]

					:local ifaceEtherHeader ""
					:set ifaceEther ($ifaceEtherHeader . "<b>Ether:</b>\t" . [:len $ifaceEther] . ";\t<b>Disabled:</b>\t" . [:len $ifaceEtherDisabled] . ";\t<b>Run:</b>\t" . [:len $ifaceEtherRuning] . "$oneFeed")
					:set ifaceBrige ("<b>Bridge:</b>\t" . [:len $ifaceBrige] . ";\t<b>Disabled:</b>\t" . [:len $ifaceBrigeDisabled] . ";\t<b>Run:</b>\t" . [:len $ifaceBrigeRuning] . "$doubleFeed")

					:set ifaceVlan ("<b>vLAN:</b>\t\t\t" . [:len $ifaceVlan] . ";\t<b>Disabled:</b>\t" . [:len $ifaceVlanDisabled] . ";\t<b>Run:</b>\t" . [:len $ifaceVlanRuning] . "$oneFeed")
					:set ifaceWlan ("<b>WLAN: </b>\t" . [:len $ifaceWlan] . ";\t<b>Disabled:</b>\t" . [:len $ifaceWlanDisabled] . ";\t<b>Run:</b>\t" . [:len $ifaceWlanRuning] . "$doubleFeed")

					:local ifaceOtherHeader "<b>Other interfaces:</b>$oneFeed"
					:set ifaceOther ($ifaceOtherHeader . "<b>Other:</b>\t" . [:len $ifaceOther] . ";\t<b>Disabled:</b>\t" . [:len $ifaceOtherDisabled] . ";\t<b>Run:</b>\t" . [:len $ifaceOtherRuning] . "$oneFeed")
					:set ifaceOtherDynamic ("<b>Dynamic interfaces:</b>\t" . [:len $ifaceOtherDynamic] . "$doubleFeed")

					:local ifaceTotalHeader "<b>Total interfaces:</b>$oneFeed"
					:set ifaceTotalEnabled ($ifaceTotalHeader . "<b>Enabled:</b>\t\t" . [:len $ifaceTotalEnabled] . "$oneFeed")
					:set ifaceTotalDisabled ("<b>Disabled:</b>\t" . [:len $ifaceTotalDisabled] . "$oneFeed-------------------------$oneFeed")
					:set ifaceTotal ("<b>Total:</b>\t" . [:len $ifaceTotal] . "$oneFeed")

					:set ifaceInfo ($ifaceEther . $ifaceBrige . $ifaceVlan . $ifaceWlan . $ifaceOther . $ifaceOtherDynamic . $ifaceTotalEnabled . $ifaceTotalDisabled . $ifaceTotal)
					:set currentInfo $ifaceInfo
				}
			}
			:if ($inerfacesPressed = false) do={
				:set currentButtons ($currentButtons . "$NL$buttonInerfaces")
			}
			:set currentButtons ($currentButtons . "$NL$buttonBackward")
		}
		:local replyMarkup [$teBuildKeyboard fButtonsKeyBoard=$currentButtons fReplyKeyboard=false]
		:local sendText ("<b>$deviceName</b>$oneFeed-------------------------$oneFeed"."root - <b>modules</b>$currentHead$currentInfo")
		:if ($fMessageID > 0) do={
			:if ([$teEditCaption fChatID=$fChatID fMessageID=$fMessageID fText=$sendText fReplyMarkup=$replyMarkup] > 0) do={
				:set result 1
				:if ($fDBGteModules = true) do={:put "teModules Command Edit - OK"; :log info "teModules Commands Edit - OK"}
			} else={
					:set result 0
					:if ($fDBGteModules = true) do={:put "teModules Command Edit - ERROR"; :log info "teModules Commands Edit - ERROR"}
			}
		} else={
			:if ([$teSendPhoto fChatID=$fChatID fPhoto=$imageRoot fText=$sendText fReplyMarkup=$replyMarkup] > 0) do={
				:set result 1
				:if ($fDBGteModules = true) do={:put "teModules Command Send - OK"; :log info "teModules Commands Send - OK"}
			} else={
					:set result 0
					:if ($fDBGteModules = true) do={:put "teModules Command Send - ERROR"; :log info "teModules Commands Send - ERROR"}
			}
		}
		:if ($fDBGteModules = true) do={:put "teModules = $result"; :log info "teModules = $result"}

		:return $result
		}
	}
