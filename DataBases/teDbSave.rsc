#---------------------------------------------------teDbSave--------------------------------------------------------------

#   Deploying the bot into scripts

#   1. fDBSave    -   name of the array to be saved
#   1. fDBSize    -   dimension of the array (1 or 2)



#---------------------------------------------------teDbSave--------------------------------------------------------------

:global teDbSave
:if (!any $teDbSave) do={ :global teDbSave do={

  :global dbaseVersion
  :local teDbSaveVersion "2.19.9.22"
  :set ($dbaseVersion->"teDbSave") $teDbSaveVersion

  :local dbase do={

    :local quotes "\""
    :local newArray [:toarray ""]

    :foreach newK,newV in=$currentDBSave do={
      :if ($newK != 0) do={

        :local newKey []
        :local newValue []

        :if ([:typeof $newK] != "num") do={
          :set newKey ($quotes . [:tostr ($newK)] . $quotes)
        } else={ :set newKey $newK }

        :if ([:typeof $newV] != "str") do={
          :set newValue [:tostr ($newV)]
        } else={ :set newValue ($quotes . [:tostr ($newV)] . $quotes) }

        :set ($newArray->$newKey) $newValue
      } else={
        :if ($fDBSize = 1 or [:len $fDBSize] = 0) do={
          :set ($newArray->0) ($quotes . [:tostr ($newV)] . $quotes)
        }
      }
    }
    :local stringArray [:tostr $newArray]
    :if ([:len $stringArray] != 0) do={ :return "{$stringArray}" } else={ :return "" }
  }

  :local quotes "\""
  :local dbName ($fDBSave->0)

  :if ($fDBSize = 1 or [:len $fDBSize] = 0) do={
    :local stringArray [$dbase currentDBSave=$fDBSave]
    :if ([:len $stringArray] != 0) do={
      :local newSource " :global $dbName [:toarray $quotes$quotes];$newStr :local dbName $quotes$dbName$quotes;$newStr :set $dbName ($stringArray)"
      /system script remove [find name=($dbName. ".db")]
      /system script add name=($dbName. ".db") policy=read,write,test,ftp,policy source=$newSource
      :return true
    }
  }

    :if ($fDBSize = 2) do={
      :local semicolon ";";
      :local newStr "\r\n"; :local equal "=";
      :local startArray "({"; :local endArray "})"

      :local newArray [:toarray ""]
      :local buildString []
      :foreach k,v in=$fDBSave do={
        :if ($k != 0) do={
          :local currentKey $k
          :local currentVal [:toarray $v]
          :set currentVal [$dbase currentDBSave=$currentVal]
          :set buildString ($buildString . $currentKey. $equal . $currentVal . $semicolon . $newStr)
        } else={ :set buildString ("$quotes$dbName$quotes" . $semicolon . $newStr) }
      }
      /system script remove [find name=($dbName. ".db")]
      /system script add name=($dbName. ".db") policy=read,write,test,ftp,policy source=" :global $dbName [:toarray $quotes$quotes];$newStr  :local dbName $quotes$dbName$quotes;$newStr :set $dbName $startArray\r\n$buildString\r\n$endArray"
    }
  }
}
