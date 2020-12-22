#############################################
# Defcon.tcl 0.1                  #22/12/20 #
#############################################
#Author  ComputerTech                       #
#IRC     irc.darenet.org  #ComputerTech     #
#Email   ComputerTech312@Gmail.com          #
#GitHub  https://github.com/computertech312 #
#################################################################################################################################################################
# Start Of Configuration #
##########################

#Set trigger of the commands.

set defcon(trig) "!"


##################
#Set Flag's for usage of commands

set flag "o|o"


##################
#Set flag to be protected from Harm of this Script's Tools

set defcon(flag) "fom|fom"


##################
#Set Ban hostmask Type
##
#0 *!user@host
#1 *!*user@host
#2 *!*@host
#3 *!*user@*.host
#4 *!*@*.host
#5 nick!user@host
#6 nick!*user@host
#7 nick!*@host
#8 nick!*user@*.host
#9 nick!*@*.host

set defcon(btype) "2"


##################

#Set maximum amount of Clones allowed

set pol "3"


##################
#Set to allow Defcon to reset after X Time, 0 = No 1 = Yes

set defcon(xdec) "1"


##################
#Amount of time before Defcon is reset to Normal, If above setting is set to 1 (in minutes)

set defcon(time) "30" 


##################
#Punishment of found Clones, 1 = Kick 0 = Notice

set flg "0"


##################
#Set Kick Reason Of MassKick

set defcon(reason) "MassKicking All Non Accessed Users"


##################
#Set channel lockdown password
#Set Password for Channel +k

set defpass "passwo3d"


########################
# End Of Configuration #
#################################################################################################################################################################

set defcon(author) "ComputerTech"
set defcon(ver) "0.1"
set defcon(logo) "\00302Defcon\002" 

bind pub $defcon(flag) $defcon(trig)clones defcon:clones
bind pub $defcon(flag) $defcon(trig)defcon defcon:lock
bind pub $defcon(flag) $defcon(trig)masskick defcon:masskick

proc defcon:lock {nick host hand chan text} {
global defcon
set def [lindex [split $text] 0]
	if {($def == "5")} {putquick "mode $chan -Rimk $defcon(pass)" ;putserv "NOTICE $chan :Channel Reset Back To Defcon 5 and Channel is no longer Locked Down, Sorry for any Inconvenience" }
	if {($def == "4")} {putquick "mode $chan +m" ;putserv "NOTICE $chan :ATTENTION: $chan Is Currrently Locked Down at Defcon Level 4"} 
	if {($def == "3")} {putquick "mode $chan +Rim" ;putserv "NOTICE $chan :ATTENTION: $chan Is Currrently Locked Down at Defcon Level 3"}
	if {($def == "2")} {putquick "mode $chan +Rim" ;putserv "NOTICE $chan :ATTENTION: $chan Is Currrently Locked Down at Defcon Level 2"}
	if {($def == "1")} {putquick "mode $chan +Rimk $defcon(pass)" ;putserv "NOTICE $chan :ATTENTION: $chan Is Currrently Locked Down at Defcon Level 1"}
    if {($defcon(xdec) == "1")} {timer defcon(time) {putquick "MODE $chan : -Rimk $defcon(pass)" }}
  }
proc defcon:clones {nick uhost hand chan text} {
			global defcon flg pol
            puthelp "NOTICE $nick :Starting clonescan for $chan..."
			set start [clock clicks]
			foreach user [chanlist $chan] {
				set host [lindex [split [getchanhost $user $chan] @] 1]
				lappend clones($host) $user
			}
			set total 0
			set count 0
			foreach host [array names clones] {
				set len [llength $clones($host)]
				if {$len > $pol} {
					set nickList [join [join $clones($host)] ", "]
					if {$flg} {
						foreach cloneXz $nickList {putquick "kick $chan $cloneXz" ;putquick "MODE $chan : +Rimk $defcon(pass)" }
					} else {
						putserv "NOTICE $nick :\($host\) Nick list: $nickList - Clones: "
					}
					incr count $len
				}
				incr total $len
			}
		}
	proc defcon:masskick {nick host hand chan var} {
		global botnick defcon
		if {$var != ""} { set reason $var } else { set reason "Masskicking all Currently Non Accessed Users of $chan" }
		if {[isop $botnick $chan]} {
			putquick "MODE $chan +im"
			timer $defcon(time) {"puthelp \"MODE $chan -im\""}
			foreach user [chanlist $chan] {
				if { ![isop $nick $chan] && ![ishalfop $nick $chan] && ![isvoice $nick $chan] } { return }
					putnow "KICK $chan $user $defcon(reason)"
				}
 }
}
proc defcon:putlog {nick host hand chan text} {
global defcon
putlog "\00302$defcon(logo) $defcon(ver) By $defcon(author) Loaded\002"
}
#################################################################################################################################################################
