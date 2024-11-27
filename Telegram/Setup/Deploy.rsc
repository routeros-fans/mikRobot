#---------------------------------------------------Deploy--------------------------------------------------------------

#   Expands libraries and arrays necessary for work.
#   The functions of processing button clicks and databases are deployed in scripts.

#   In order for the bot to start automatically, uncomment the last line of code.

#---------------------------------------------------Deploy--------------------------------------------------------------

:local fJParseFunctions [file find name~"mikRobot/.*/JParse.rsc"]
:local JParseName [file get value-name=name number=$fJParseFunctions]
import file-name="$JParseName"

:foreach fScript in=[file find name~"mikRobot/.*/te.*"] do={
  :local fileName [file get value-name=name number=$fScript]
  :import file-name="$fileName"
}

:foreach fdbase in=[file find name~"mikRobot/.*/dbase.*"] do={
  :local baseName [file get value-name=name number=$fdbase]
  :local shortName [:pick $baseName [:find $baseName "dbase"] [:len $baseName]]
  :if ([:len [/system script find name=$shortName]] = 0) do={
    :local newContent [/file get value-name=name number=$fdbase contents]
    /system script add name="$shortName" policy=read,write,test,policy,ftp source=$newContent
  }
  /system script run [find name="$shortName"]
}

#:delay 3; /system script run [find name=mainBot]
