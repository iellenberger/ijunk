#!/usr/bin/osascript

# --- script to open 2 terminal windows specific locations ---
# Instructions on how to assign a keyboard shortcut to this here:
#    http://computers.tutsplus.com/tutorials/how-to-launch-any-app-with-a-keyboard-shortcut--mac-31463

tell application "Terminal"
	do script ""
	activate
	set position of window 1 to {0,0}
end tell

tell application "Terminal"
	do script ""
	activate
	set position of window 1 to {731,0}
end tell
