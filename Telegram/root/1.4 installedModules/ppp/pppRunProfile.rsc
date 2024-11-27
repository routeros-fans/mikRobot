#---------------------------------------------------tePppRunProfile--------------------------------------------------------------

# https://wiki.mikrotik.com/wiki/Manual:PPP_AAA#Properties

# Execute script on user login-event. These are available variables that are accessible for the event script:
# user            - contains the user name
# local-address   - local address of the mikrotik
# remote-address  - the internal address received by the client from the mikrotik
# caller-id       - client's address
# called-id       - client hostname
# interface       - interface number

# !!!!!! The "fromRun" parameter should be different in triggers

#---------------------------------------------------tePppRunProfile--------------------------------------------------------------

#--------------- on UP

:delay 3
:local answer "\$tePppRun fUser=$user fFromRun=1"
:execute script=$answer


#-------------- on Down

#:delay 1
#:local answer "\$tePppRun fUser=$user fFromRun=0"
#:execute script=$answer
