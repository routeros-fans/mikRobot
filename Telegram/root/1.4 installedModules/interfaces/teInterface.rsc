# 2023-09-22 17:17:14 by RouterOS 7.11.2
# software id =
#
/system script
:if ([:len [find name=teBuildButton]] != 0) do={ remove teBuildButton }
add dont-require-permissions=no name=teBuildButton owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teBuildButton------------------------------------------------\
    --------------\r\
    \n\r\
    \n#   Function build button and returns it in text format\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   1.  fPictButton     \t\t\t-   picture for the button from Emoji Unic\
    ode Tables\r\
    \n#   2.  fTextButton     \t\t\t-   text for the button\r\
    \n#   3.  fUrlButton\t   \t\t\t  -   URL for the button\r\
    \n#   4.  fSwitchCurrentChat\t  -   URL for the button\r\
    \n#   5.  fTextCallBack    \t\t\t-   callback for the button\r\
    \n\r\
    \n#---------------------------------------------------teBuildButton-------\
    -------------------------------------------------------\r\
    \n\r\
    \n:global teBuildButton\r\
    \n:if (!any \$teBuildButton) do={ :global teBuildButton do={\r\
    \n\r\
    \n\t:local startButton \"\\7B\\22text\\22: \\22 \"\r\
    \n\t:local startUrl \"\\22,\\22url\\22: \\22\"\r\
    \n\t:local startCallBack \" \\22,\\22callback_data\\22: \\22\"\r\
    \n\t:local startSwitchCurrentChat \" \\22,\\22switch_inline_query_current_\
    chat\\22: \\22\"\r\
    \n\t:local endButton \"\\22\\7D\"\r\
    \n\t:local button []\r\
    \n\r\
    \n\t:set button \"\$startButton\$fPictButton\$fTextButton\$startCallBack\$\
    fTextCallBack\$endButton\"\r\
    \n\r\
    \n\t:if ([:len \$fUrlButton] != 0) do={\r\
    \n\t\t:set button \"\$startButton\$fPictButton\$fTextButton\$startUrl\$fUr\
    lButton\$startCallBack\$fTextCallBack\$endButton\"\r\
    \n\t}\r\
    \n\t:if ([:len \$fSwitchCurrentChat] != 0) do={\r\
    \n\t\t:set button \"\$startButton\$fPictButton\$fTextButton\$startSwitchCu\
    rrentChat\$fSwitchCurrentChat\$endButton\"\r\
    \n\t}\r\
    \n\t:return \$button\r\
    \n\t}\r\
    \n}\r\
    \n"

:if ([:len [find name=teBuildKeyboard]] != 0) do={ remove teBuildKeyboard }
add dont-require-permissions=no name=teBuildKeyboard owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teBuildKeyboard----------------------------------------------\
    ----------------\r\
    \n\r\
    \n#   Function builds a keyboard from an array of buttons\r\
    \n#   and return keyBoard in text format\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   1.  fButtonsKeyBoard      -   an array of buttons formed by a functi\
    on teBuildButton\r\
    \n#   2.  fReplyKeyboard        -   keyboard type, reply or inline (true o\
    r false)\r\
    \n#   3.  fReplyOneTime         -   Requests clients to hide the keyboard \
    as soon as it's been used (true or false)\r\
    \n#   4.  fReplyResize          -   Requests clients to resize the keyboar\
    d vertically for optimal fit (true or false)\r\
    \n#   5.  fPlaceholder          -   The placeholder to be shown in the inp\
    ut field when the keyboard is active; 1-64 characters (hint in the input f\
    ield)\r\
    \n#   6.  fReplySelective       -   Use this parameter if you want to show\
    \_the keyboard to specific users only (true or false)\r\
    \n\r\
    \n#---------------------------------------------------teBuildKeyboard-----\
    ---------------------------------------------------------\r\
    \n\r\
    \n:global teBuildKeyboard\r\
    \n:if (!any \$teBuildKeyboard) do={ :global teBuildKeyboard do={\r\
    \n\r\
    \n  :local keyBoard []\r\
    \n  :local startKeyBoard []\r\
    \n  :local resizeKeyboard []\r\
    \n  :local ontimeKeyboard []\r\
    \n  :local inputFieldPlaceholder []\r\
    \n  :local selectiveKeyboard []\r\
    \n\r\
    \n  :if ([:len \$fReplyResize] = 0) do={ :set \$fReplyResize false }\r\
    \n\r\
    \n  :if (\$fReplyResize = false) do={\r\
    \n    :set resizeKeyboard \"\\5D\\5D,\\22resize_keyboard\\22:false\"\r\
    \n  }\r\
    \n  :if (\$fReplyResize = true) do={\r\
    \n    :set resizeKeyboard \"\\5D\\5D,\\22resize_keyboard\\22:true\"\r\
    \n  }\r\
    \n\r\
    \n  :if (\$fReplyOneTime = false or [:len \$fReplyOneTime] = 0) do={\r\
    \n    :set ontimeKeyboard \",\\22one_time_keyboard\\22:false\"\r\
    \n  } else={\r\
    \n    :set ontimeKeyboard \",\\22one_time_keyboard\\22:true\"\r\
    \n  }\r\
    \n\r\
    \n  :if (\$fReplySelective = false  or [:len \$fReplySelective] = 0) do={\
    \r\
    \n    :set selectiveKeyboard \",\\22selective\\22:false\"\r\
    \n  } else={\r\
    \n    :set selectiveKeyboard \",\\22selective\\22:true\"\r\
    \n  }\r\
    \n\r\
    \n  :if ([:len \$fPlaceholder] != 0) do={\r\
    \n    :if ([:len \$fPlaceholder] > 64) do={:set \$fPlaceholder [:pick \$fP\
    laceholder 0 63]}\r\
    \n    :set inputFieldPlaceholder \",\\22input_field_placeholder\\22:\\22\$\
    fPlaceholder\\22\"\r\
    \n  } else={\r\
    \n    :set inputFieldPlaceholder \"\"\r\
    \n  }\r\
    \n\r\
    \n  :local endReplyKeyBoard \"\\7D\"\r\
    \n  :local endKeyBoard \"\\5D\\5D\\7D\"\r\
    \n\r\
    \n\t:if (\$fReplyKeyboard = true) do={\r\
    \n\t\t:set startKeyBoard \"\\7B\\22keyboard\\22: \\5B\\5B\"\r\
    \n    :set keyBoard \"\$startKeyBoard\$fButtonsKeyBoard\$resizeKeyboard\$o\
    ntimeKeyboard\$inputFieldPlaceholder\$selectiveKeyboard\$endReplyKeyBoard\
    \"\r\
    \n\t} else={\r\
    \n\t\t:set startKeyBoard \"\\7B\\22inline_keyboard\\22: \\5B\\5B\"\r\
    \n\t\t:set keyBoard \"\$startKeyBoard\$fButtonsKeyBoard\$endKeyBoard\"\r\
    \n\t}\r\
    \n\t:return \$keyBoard\r\
    \n\t}\r\
    \n}\r\
    \n"

:if ([:len [find name=teBuildReplyButton]] != 0) do={ remove teBuildReplyButton }
add dont-require-permissions=no name=teBuildReplyButton owner=xenon007 policy=\
    ftp,read,write,policy,test source="#--------------------------------------\
    -------------teBuildReplyButton-------------------------------------------\
    -------------------\r\
    \n\r\
    \n#   Function build reply button and returns it in text format\r\
    \n#   Params for this function:\r\
    \n\r\
    \n#   1.  fPictButton      -   picture for the button from Emoji Unicode T\
    ables\r\
    \n#   2.  fTextButton      -   text for the button\r\
    \n#   3.  fRequestLocation -   request current location true or false\r\
    \n\r\
    \n#---------------------------------------------------teBuildReplyButton--\
    ------------------------------------------------------------\r\
    \n\r\
    \n:global teBuildReplyButton\r\
    \n:if (!any \$teBuildReplyButton) do={ :global teBuildReplyButton do={\r\
    \n\r\
    \n\t:local requestLocation \$fRequestLocation\r\
    \n\t:local startButton \"{\\22text\\22:\\22\"\r\
    \n\t:if (\$requestLocation = true) do={\r\
    \n\t\t:set requestLocation \",\\22request_location\\22:true}\"\r\
    \n\t} else={\r\
    \n\t\t:set requestLocation \"}\"\r\
    \n\t}\r\
    \n\t:local endButton \"\\22\"\r\
    \n\t:local button \"\$startButton\$fPictButton\$fTextButton\$endButton\$re\
    questLocation\"\r\
    \n\r\
    \n\t:return \$button\r\
    \n\t}\r\
    \n}\r\
    \n"
