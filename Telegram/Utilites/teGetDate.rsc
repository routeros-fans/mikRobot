#---------------------------------------------------teGetDate--------------------------------------------------------------

#   Function returns the current date converted to the format dd.mm.yyyy
#		and returns it in text format

#   No params.

#---------------------------------------------------teGetDate--------------------------------------------------------------

:global teGetDate
:if (!any $teGetDate) do={ :global teGetDate do={
	  :local date
	  :local tmpdate [/system clock get date]
	  :local dateformat [:pick $tmpdate 4]
	  :if ($dateformat != "-") do={
	    :local months {"jan"=1; "feb"=2; "mar"=3; "apr"=4; "may"=5; "jun"=6; "jul"=7; "aug"=8; "sep"=9; "oct"=10; "nov"=11; "dec"=12}
	    :local tmpm ($months -> [:pick $tmpdate 0 3])
	    :if ($tmpm < 10) do={:set tmpm ("0".$tmpm) }
	    :return (([:pick $tmpdate 7 11]).".".$tmpm.".".([:pick $tmpdate 4 6]))
	  } else={
			:return ([:pick $tmpdate 8 10].".".[:pick $tmpdate 5 7].".".[:pick $tmpdate 0 4])
		}
	}
}
