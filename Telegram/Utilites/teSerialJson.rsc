#---------------------------------------------------teSerialJson--------------------------------------------------------------

#   Function generates a value with the specified parameters using the www.random.com website API
#		and returns it in text format
#   Params for this function:

#   1.  fValueLen      -   value length
#   2.  fDigits 	     -   on/off digits
#   3.  fUpperAlpha    -   on/off upper case characters
#   3.  fLowerAlpha    -   on/off lowercase characters
#   3.  fUnique    		 -   on/off uniqueness

#   if the global variable fDBGteGenValue=true, then a debug event will be logged

#---------------------------------------------------teSerialJson--------------------------------------------------------------

#Convert Array Value To json
:global teSerialJson
		:if (!any $teSerialJson) do={ :global teSerialJson do={
		:local i [:len $1];
		:local j 0;
		:local q "\"";
		:local a false;

		:foreach n,v in=$1 do={
			:set $j ($j+1);
			:if ([:typeof $n]!="num") do={:set $s ($s.$q.$n.$q.":"); :set $a true}
			:if ([:typeof $v]="num") do={

				:if ($i=$j) do={
					:set $s ($s.$v)
				} else={ :set $s ($s.$v.",") }

			} else={
				:if ([:typeof $v]!="array") do={
					:if ($i=$j) do={
						:set $s  ($s.$q.$v.$q)
					} else={ :set $s ($s.$q.$v.$q.",") }
				} else={
					:if ($i=$j) do={
						:set $s ($s.[$teSerialJson $v])
					} else={ :set $s ($s.[$teSerialJson $v].",") }
		  	}
			}
		}
		:if ($a) do={
			:return ("{".$s."}")
		}
		:return ("[".$s."]")
		}

	}
}

#Convert Array Value To json
:global Json do={
:local i [:len $1];:local j 0;
:local q "\"";:local a false;
:foreach n,v in=$1 do={:set $j ($j+1);
:if ([:typeof $n]!="num") do={:set $s ($s.$q.$n.$q.":");:set $a true;}
:if ([:typeof $v]="num") do={:if ($i=$j) do={:set $s ($s.$v);} else={:set $s ($s.$v.",");}} else={
:if ([:typeof $v]!="array") do={:if ($i=$j) do={:set $s  ($s.$q.$v.$q)} else={:set $s ($s.$q.$v.$q.",");}} else={
:if ($i=$j) do={:set $s ($s.[$Json $v])} else={:set $s ($s.[$Json $v].",");}
}}}
:if ($a) do={:return ("{".$s."}");}
:return ("[".$s."]");
}
