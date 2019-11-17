#!/usr/bin/tclsh
# Script found at https://homematic-forum.de/forum/viewtopic.php?f=26&t=36741#p356849
# and adpted the output
#
# Auslesen von Parametern aus einer Gruenbeck SC/MC 
# Wasserenthärtungsanlage
# =================================================
# Frank Kuypers im April 2017
#
# Aufruf mit
# tclsh get_gruenbeck.tcl <IP> <CookieID> <Wert> <SYSVAR> <CODE>
#
# Mehrere Werte durch Komma trennen: D_Y_2_1,D_Y_2_2,D_Y_2_3
# Code ist optional
#
# Diese werden dann durch Komma getrennt abgespeichert (mit extra Komma am Ende): 232, 222, 203,
#
# Version 0.1: Initlial Release
# Version 0.2: Fehlerbehandlung:
#		Rückgabe von 0 Byte gibt "Antwort 0 Byte" zurück in die SV
#		Wrong Code - gibt "wrong" in die SV zurück
#		Bei ok gibt es die Werte in Reihenfolge von <WERT> zurück
# 
# =================================================

#        load tclrpc.so
#        load tclrega.so
	

#Alle Übergabeparameter aus CMD holen
        set item1 [lindex $argv 0]
        set item2 [lindex $argv 1]
	set item3 [lindex $argv 2]
	set item4 [lindex $argv 3]
	set item5 [lindex $argv 4]

	set callcode ""
	if { $argc == 5} {
	  append callcode "&code="
	  append callcode $item5 
#puts "in if: $callcode"
	}
	
# Daten von der Gruenbeck holen, in Datei leiten und diese Datei wieder einlesen.
# Meiner Meinung nach geht das mit Curl nicht anders, da sonst der Progressindikator
# angezeigt wird - für Inputs, wie man direkt in eine Variable schreibt, wäre ich 
# offen
	set item3pipe [string map -nocase {"," "|"} $item3]
	exec  /usr/bin/curl --data "id=$item2&show=$item3pipe$callcode~" --header "application/x-www-form-urlencoded" --url http://$item1/mux_http --silent --output /tmp/curlout.txt
	set fp [open "/tmp/curlout.txt" r]
	set file_data [read $fp]
	close $fp 
# puts $file_data

	set output ""	

# Rückgabe prüfen, ob Code OK oder Daten angenommen wurden

	if [expr [string length $file_data] == 0] {
	  append output "Antwort 0 Byte"
	}
	
# Nach <code> suchen
	
	set xmlopenc "<code>"
	set xmlclosec "</code>"
	set leftc [ expr [string first $xmlopenc $file_data] + [string length $xmlopenc]]
  	set rightc [expr [string first $xmlclosec $file_data] -1]
	set valuec [string range $file_data $leftc $rightc] 
	
	if {$valuec == "ok"} {
	
# Rückgabewert war OK - also erst einmal die anderen Parameter durchgehen
# 
# Durch die Parameter durchgehen und die einzelnen Werte durch Spaces getrennt 
# abspeichern
	
	    set items [split $item3 ","]
	    foreach item $items {
# puts $item
	  	set xmlopen ""
	  	set xmlclose ""
	  	append xmlopen "<" $item ">"
	  	append xmlclose "</" $item ">"
	  	set left [ expr [string first $xmlopen $file_data] + [string length $xmlopen]]
#puts $left
	  	set right [expr [string first $xmlclose $file_data] -1]
	  	set value [string range $file_data $left $right] 
# puts "Success - $item : $value"
	  	append output $value " "		
	    }		 	
	} else {
	    append output $valuec
	}		
# Werte in die Systemvariable rauschreiben
#	set rega_cmd ""
#	append rega_cmd "dom.GetObject('$item4').State('$output');"
#           rega_script $rega_cmd
         puts "$output"	
	

