#---------------------------------------------------teGenValue--------------------------------------------------------------

#   Function generates a value with the specified parameters using the www.random.com website API
#		and returns it in text format
#   Params for this function:

#   1.  fValueLen      -   value length
#   2.  fDigits 	     -   on/off digits
#   3.  fUpperAlpha    -   on/off upper case characters
#   3.  fLowerAlpha    -   on/off lowercase characters
#   3.  fUnique    		 -   on/off uniqueness

#   if the global variable fDBGteGenValue=true, then a debug event will be logged

#---------------------------------------------------teGenValue--------------------------------------------------------------

:global teGenValue
:if (!any $teGenValue) do={ :global teGenValue do={

	:global teDebugCheck
	:local teGenValue [$teDebugCheck fDebugVariableName="teGenValue"]

	:global dbaseVersion
	:local teGenValueVersion "2.9.7.22"
	:set ($dbaseVersion->"teGenerateNewValue") $teGenValueVersion

	:if ([:len $fValueLen] = 0) do={ :set $fValueLen 8 }
	:if ([:len $fDigits] = 0) do={ :set $fDigits "on" }
	:if ([:len $fUpperAlpha] = 0) do={ :set $fUpperAlpha "on" }
	:if ([:len $fLowerAlpha] = 0) do={ :set $fLowerAlpha "on" }
	:if ([:len $fUnique] = 0) do={ :set $fUnique "on" }

	:local valueURL "https://www.random.org/strings/?num=1&len=$fValueLen&digits=$fDigits&upperalpha=$fUpperAlpha&loweralpha=$fLowerAlpha&unique=$fUnique&format=plain&rnd=new"

	:local newValue [:tool fetch ascii=yes url=$valueURL as-value output=user]

	:if ($newValue->"status" = "finished")	do={
		:set newValue ($newValue->"data")
		:set newValue ($newValue [:pick $newValue 0 $fValueLen])
		:if ($fDbgTeGenNewValue = true) do={:put "teGenerateNewValue = $newValue"; :log info "teGenerateNewValue = $newValue"}
	} else={
		:set newValue false
		:if ($fDbgTeGenNewValue = true) do={:put "teGenerateNewValue fetch ERROR = $newValue"; :log info "teGenerateNewValue fetch ERROR = $newValue"}
	}
	:return $newValue
 }
}
