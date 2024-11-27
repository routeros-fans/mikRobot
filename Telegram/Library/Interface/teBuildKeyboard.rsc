#---------------------------------------------------teBuildKeyboard--------------------------------------------------------------

#   Function builds a keyboard from an array of buttons
#   and return keyBoard in text format
#   Params for this function:

#   1.  fButtonsKeyBoard      -   an array of buttons formed by a function teBuildButton
#   2.  fReplyKeyboard        -   keyboard type, reply or inline (true or false)
#   3.  fReplyOneTime         -   Requests clients to hide the keyboard as soon as it's been used (true or false)
#   4.  fReplyResize          -   Requests clients to resize the keyboard vertically for optimal fit (true or false)
#   5.  fPlaceholder          -   The placeholder to be shown in the input field when the keyboard is active; 1-64 characters (hint in the input field)
#   6.  fReplySelective       -   Use this parameter if you want to show the keyboard to specific users only (true or false)

#---------------------------------------------------teBuildKeyboard--------------------------------------------------------------

:global teBuildKeyboard
:if (!any $teBuildKeyboard) do={ :global teBuildKeyboard do={

  :global teDebugCheck
	:local fDBGteBuildKeyboard [$teDebugCheck fDebugVariableName="fDBGteBuildKeyboard"]

  :global dbaseVersion
  :local teBuildKeyboardVersion "2.9.7.22"
  :set ($dbaseVersion->"teBuildKeyboard") $teBuildKeyboardVersion

  :local keyBoard []
  :local startKeyBoard []
  :local resizeKeyboard []
  :local ontimeKeyboard []
  :local inputFieldPlaceholder []
  :local selectiveKeyboard []

  :if ([:len $fReplyResize] = 0) do={ :set $fReplyResize false }

  :if ($fReplyResize = false) do={
    :set resizeKeyboard "\5D\5D,\22resize_keyboard\22:false"
  }
  :if ($fReplyResize = true) do={
    :set resizeKeyboard "\5D\5D,\22resize_keyboard\22:true"
  }

  :if ($fReplyOneTime = false or [:len $fReplyOneTime] = 0) do={
    :set ontimeKeyboard ",\22one_time_keyboard\22:false"
  } else={
    :set ontimeKeyboard ",\22one_time_keyboard\22:true"
  }

  :if ($fReplySelective = false  or [:len $fReplySelective] = 0) do={
    :set selectiveKeyboard ",\22selective\22:false"
  } else={
    :set selectiveKeyboard ",\22selective\22:true"
  }

  :if ([:len $fPlaceholder] != 0) do={
    :if ([:len $fPlaceholder] > 64) do={:set $fPlaceholder [:pick $fPlaceholder 0 63]}
    :set inputFieldPlaceholder ",\22input_field_placeholder\22:\22$fPlaceholder\22"
  } else={
    :set inputFieldPlaceholder ""
  }

  :local endReplyKeyBoard "\7D"
  :local endKeyBoard "\5D\5D\7D"

	:if ($fReplyKeyboard = true) do={
		:set startKeyBoard "\7B\22keyboard\22: \5B\5B"

    :set keyBoard "$startKeyBoard$fButtonsKeyBoard$resizeKeyboard$ontimeKeyboard$inputFieldPlaceholder$selectiveKeyboard$endReplyKeyBoard"

		:if ($fDBGteBuildKeyboard = true) do={:log info "teBuildKeyboard = $startKeyBoard"}
	} else={
		:set startKeyBoard "\7B\22inline_keyboard\22: \5B\5B"

		:set keyBoard "$startKeyBoard$fButtonsKeyBoard$endKeyBoard"

		:if ($fDBGteBuildKeyboard = true) do={:put "teBuildKeyboard = $startKeyBoard"; :log info "teBuildKeyboard = $startKeyBoard"}
	}
	:if ($fDBGteBuildKeyboard = true) do={:put "teBuildKeyboard = $keyBoard"; :log info "teBuildKeyboard = $keyBoard"}
	:return $keyBoard
	}
}
