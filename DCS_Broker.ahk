#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
#Persistent
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

OnExit("ExitFunc")

if not A_IsAdmin {
	MsgBox, You Should run this as Administrator
	ExitApp
}

; GLOBALS

um_desktop := "C:\Users\David\AppData\Roaming\Realtime Soft\UltraMon\3.4.1\Profiles\um_desktop.umprofile"
um_flight := "C:\Users\David\AppData\Roaming\Realtime Soft\UltraMon\3.4.1\Profiles\um_flight.umprofile"

target_base := "C:\Program Files (x86)\Thrustmaster\TARGET\x64\TARGETGUI.exe"
prof_A_10 := "C:\Games\WT_profiles\Warthog a10clight\Combined A-10c 4.6.tmc"
prof_F_18 := "C:\Games\WT_profiles\Warthog fa-18c\Combined FA-18C 1.7.tmc"
prof_M_2000 := "C:\Games\WT_profiles\Warthog m2000light\Combined M-2000C 9.8.tmc"
prof_SU_25 := "C:\Games\WT_profiles\Warthog Su-25T\Combined Su-25T 0.6.tmc"
prof_SU_27 := "C:\Games\WT_profiles\Warthog Su27-33-J11\Combined Su27-33 2.8.tmc"
prof_F_14 := "C:\Games\WT_profiles\Warthog F14\Combined F-14 0.1.tmc"

trackir := "C:\Program Files (x86)\NaturalPoint\TrackIR5\TrackIR5.exe"
diview := "C:\Users\David\Documents\DIView\DIView.exe"
joycpl := "C:\Windows\System32\joy.cpl"
vatack := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VoiceAttack\VoiceAttack.lnk"
srs := "C:\Games\DCS-SimpleRadioStandalone-1.6.1.0\SR-ClientRadio.exe"

dcs_updater := "D:\Games\DCS World OpenBeta\bin\DCS_updater.exe"

; VJoy interface
#include CvJoyInterface.ahk
vJoyInterface := new CvJoyInterface()
; Was vJoy installed and the DLL Loaded?
if (!vJoyInterface.vJoyEnabled()){
	; Show log of what happened
	Msgbox % vJoyInterface.LoadLibraryLog
	ExitApp
}
myStick := vJoyInterface.Devices[1]


Index :=50
State :=16000
Actual :=16000
Zoomin := 2200
Zoomout := 5000
ZoominVal := 3200
ZoomoutVal := 19000
Protec := 0
SetTimer, Zoom1, 15
SetTimer, MouseLock, 300

; IniRead, ZoominVal, Dcs_Broker.ini, VJoy, ZoominVal , 3200
; IniRead, ZoomoutVal, Dcs_Broker.ini, VJoy, ZoomoutVal , 19000

; GUI
Gui, Add, Text,, Display configuraitons
Gui, Add, Button, Default w250, Flight
Gui, Add, Button, Default w250, Desktop

Gui, Add, Text,, TM WH profiles
Gui, Add, Button, Default w250, A_10
Gui, Add, Button, Default w250, F_18
Gui, Add, Button, Default w250, F_14
Gui, Add, Button, Default w250, M_2000
Gui, Add, Button, Default w250, SU_25
Gui, Add, Button, Default w250, SU_27

Gui, Add, Text,, Programs
Gui, Add, Button, Default w250, Trackir
Gui, Add, Button, Default w250, VoiceAttack
Gui, Add, Button, Default w250, DIView
Gui, Add, Button, Default w250, Joycpl
Gui, Add, Button, Default w250, SimpleRadio

Gui, Add, Text,, Sim
Gui, Add, Button, Default w250, DCS

SplitPath A_ScriptName,,,,$ScriptTitle
gui Show,x1400 y150,%$ScriptTitle%
return

GuiClose:
ExitApp
return

ButtonFlight:
Run, %um_flight%
Sleep, 500
gui Show,x1400 y150
return

ButtonDesktop:
Run, %um_desktop%
Sleep, 3000
gui Show,x1400 y150
return

ButtonA_10:
Run, %target_base% -r "%prof_A_10%"
return
ButtonF_18:
Run, %target_base% -r "%prof_F_18%"
return
ButtonM_2000:
Run, %target_base% -r "%prof_M_2000%"
return
ButtonSU_25:
Run, %target_base% -r "%prof_SU_25%"
return
ButtonSU_27:
Run, %target_base% -r "%prof_SU_27%"
return
ButtonF_14:
Run, %target_base% -r "%prof_F_14%"
return

ButtonTrackir:
Run, %trackir%
return
ButtonDIView:
Run, %diview%
return
ButtonJoycpl:
Run, %joycpl%
return
ButtonVoiceAttack:
Run, %vatack%
return
ButtonSimpleRadio:
Run, %srs%
return

ButtonDCS:
Run, %dcs_updater%
return

ExitFunc() {
    ; MsgBox, 4, , Are you sure you want to exit?
    ; IniWrite, %ZoominVal%, Dcs_Broker.ini, VJoy, ZoominVal
    ; IniWrite, %ZoomoutVal%, Dcs_Broker.ini, VJoy, ZoomoutVal
}

MouseLock:
	if (WinActive("Digital Combat Simulator"))
  	{
  		LockMouseToWindow("Digital Combat Simulator")
    } else {
		LockMouseToWindow()
	}
return

LockMouseToWindow(llwindowname="")
{
  VarSetCapacity(llrectA, 16)
  WinGetPos, llX, llY, llWidth, llHeight, %llwindowname%
  If (!llWidth AND !llHeight) {
    DllCall("ClipCursor")
    Return, False
  }
  Loop, 4 { 
    DllCall("RtlFillMemory", UInt,&llrectA+0+A_Index-1, UInt,1, UChar,llX >> 8*A_Index-8) 
    DllCall("RtlFillMemory", UInt,&llrectA+4+A_Index-1, UInt,1, UChar,llY >> 8*A_Index-8) 
    DllCall("RtlFillMemory", UInt,&llrectA+8+A_Index-1, UInt,1, UChar,(llWidth + llX)>> 8*A_Index-8) 
    DllCall("RtlFillMemory", UInt,&llrectA+12+A_Index-1, UInt,1, UChar,(llHeight + llY) >> 8*A_Index-8) 
  } 
  DllCall("ClipCursor", "UInt", &llrectA)
Return, True
}

Zoom1:
	if(Actual<State) 
	{
		Actual:=Actual+Zoomout
	}
	if(Actual>State) 
	{
		Actual:=Actual-Zoomin
	}
	
	if(Actual<ZoominVal) 
	{
		Actual:=ZoominVal
	}
	if(Actual>ZoomoutVal) 
	{
		Actual:=ZoomoutVal
	}
	
	;myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(Actual),1)
	myStick.SetAxisByIndex(Actual,1)
	
return

; using joy, of uncombined tm throttle at the same time as combined tm device in operation
;2Joy1::
~Numpad5::
	;debug beep
	;SoundBeep
	KeyWait, Numpad5, T0.5 ;this is bugged, was wayting for 2joy1
	if ErrorLevel {
		;SendInput !^{F11}
		Sleep 30
		Protec:=1
		;return
	} else {
		if(Protec ==1) {
			Protec := 0
			return
		} else {
		
			;cycle zoom
			if (Index == 1) {
				;zoomout
				;70
				State:=22000	
				
				Index:=2
			} else {
				;zoomin
				;10
				State:=3200
				
				
				Index:=1
			}
			;toggle precision
			;Send ^+{F11}
			return
		}
	}
return
