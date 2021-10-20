#SingleInstance, Force
StickyNotesFolder := "C:\Users\" . A_UserName "\AppData\Local\EPBHs Creations\Sticky Notes"
StickyNotesIni := StickyNotesFolder . "\Sticky Notes.ini"
if !FileExist(StickyNotesIni)
{
	Settings := "
(
[StickyNotes]

[Settings]
EditColor=0xFFFFFF
TextColor=0x000000
AutomaticTextColor=1
ShowOnStartup=1
AutoSave=1
DarkMode=0
Password=0
Passcode=
HotkeyShow=F4
Color1=0
Color2=0
Color3=0
Color4=0
Color5=0
Color6=0
Color7=0
Color8=0
Color9=0
Color10=0
Color11=0
Color12=0
Color13=0
Color14=0
Color15=0
Color16=0

[LockedNotes]
LockedNotes=
)"
	
	FileCreateDir, %StickyNotesFolder%
	FileAppend, %Settings%, %StickyNotesIni%
}
IniRead, EditC, %StickyNotesIni%, Settings, EditColor
IniRead, TextC, %StickyNotesIni%, Settings, TextColor
IniRead, ATC, %StickyNotesIni%, Settings, AutomaticTextColor
IniRead, StartupShow, %StickyNotesIni%, Settings, ShowOnStartup
IniRead, AutoS, %StickyNotesIni%, Settings, AutoSave
IniRead, DarkMode, %StickyNotesIni%, Settings, DarkMode
IniRead, Password, %StickyNotesIni%, Settings, Password
IniRead, Passcode, %StickyNotesIni%, Settings, Passcode
IniRead, HotkeyShow, %StickyNotesIni%, Settings, HotkeyShow
IniRead, TabCheckRead, %StickyNotesIni%, StickyNotes, TabNames
Hotkey, %HotkeyShow%, PasscodeCheckEnter
if (TabCheckRead == "ERROR")
{
	TNames := "Untitled"
	Menu, SubSettings, Add, %TNames%, LockSN
	Gui, Add, Tab3, hwndtab vcurrentTab gTab, %TNames% 
	Gui, Add, Edit, w300 h200 gAutoSave c%TextC%
}
else
{
	IniRead, TNames, %StickyNotesIni%, StickyNotes, TabNames
	Gui, Add, Tab3, hwndtab vcurrentTab gTab, %TNames%
	tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
	StringTrimRight, TNames, TNames, 1
	Loop, Parse, TNames, |
	{
		Menu, SubSettings, Add, %A_LoopField%, LockSN
		IniRead, NotesCheck, %StickyNotesIni%, LockedNotes, %A_LoopField%
		if (NotesCheck == "ERROR")
			Goto, Continue
		Menu, SubSettings, ToggleCheck, %A_LoopField%
		Continue:
		Gui, Tab, %A_Index%
		IniRead, EditVar, %StickyNotesIni%, StickyNotes, %A_LoopField%
		StringTrimRight, EditVar, EditVar, 1
		Loop, Parse, EditVar, \
			EditPut .= A_LoopField "`n"
		StringTrimRight, EditPut, Editput, 1
		Gui, Add, Edit, w300 h200 gAutoSave c%TextC%, %EditPut%
		EditPut := EditVar := ""
	}
}


Menu, Edit, Add, Search with Browser, Search
Menu, Edit, Add
Menu, Edit, Add, Time/Date`tF5, TimeDate
Menu, StickyNotes, Add, Lock Sticky Note, :SubSettings
Menu, StickyNotes, Add, Edit, :Edit
Gui, Menu, StickyNotes
Gui, Color, , %EditC%
Gui, Tab
Gui, Add, Button, gSave, Save
Gui, Add, Button, gNew x+5, New
Gui, Add, Button, gDelete x+5, Delete
Gui, Add, Button, gChangeName x+5, Change Name
Gui, Add, Button, gAddFiles x+5, 🔺
Gui, Add, Button, gSettings x+5, ⚙
Gui, Add, CheckBox, gAOT x+5 y272, AOT
if (StartupShow = 1)
	GoSub, PasscodeCheckEnter
Gui, +HwndSN
Gui, New, , Settings
Gui, Settings:Add, Text, x10 y10 w50 h20, Edit Color
Gui, Settings:Add, Edit, x10 y30 w80 h20 gEditColor vEditColor, %EditC%
Gui, Settings:Add, Button, x+5 y29 w20 gChooseColorEdit, 🖌
Gui, Settings:Add, ListView, x120 y30 w20 h20 +Background%EditC%
Gui, Settings:Add, Text, x10 y60 w50 h20, Text Color
Gui, Settings:Add, Edit, x10 y80 w80 h20 gTextColor vTextColor Disabled%ATC%, %TextC%
Gui, Settings:Add, Button, x+5 y79 w20 gChooseColorText Disabled%ATC%, 🖌
Gui, Settings:Add, ListView, x120 y80 w20 h20 +Background%TextC%
Gui, Settings:Add, CheckBox, x10 +Checked%ATC% gATColor vATColor, Automatic Text Color
Gui, Settings:Add, CheckBox, +Checked%StartupShow% vSoS, Show on Startup
Gui, Settings:Add, CheckBox, +Checked%AutoS% vAS, AutoSave
Gui, Settings:Add, CheckBox, +Checked%DarkMode% gDM vDM, Dark Mode
Gui, Settings:Add, CheckBox, +Checked%Password% gPW vPW w200, Password
Gui, Settings:Add, Edit, Password w120 vPC, %Passcode%
GuiControl, Settings:Enable%Password%, Edit3
Gui, Settings:Add, Text, , Hotkey to show Sticky Notes
Gui, Settings:Add, Hotkey, vHotkey, %HotkeyShow%
Gui, Settings:Add, Button, gApply, Apply
Gui, Settings:+ToolWindow +Owner
Col:=0xFF0000
CColors:=Object()
Loop 16
{
	IniRead, Color%A_Index%, %StickyNotesIni%, Settings, Color%A_Index%
	CColors.Insert(Color%A_Index%)
}
return

Search:
Gst := Gst()
if (Gst = "")
	return
else
	Run, http://www.google.com/search?q=%Gst%
return

TimeDate:
Gui, Submit, NoHide
ControlGet, CurrentTabName, Tab, , SysTabControl321, A
GuiControlGet, Edit, , Edit%CurrentTabName%
GuiControl, Text, Edit%CurrentTabName%, % Edit . LTrim((A_Hour > 12 ? A_Hour-12 ":" A_Min " PM" : A_Hour ":" A_Min " AM"), 0) " "LTrim(A_Mon, 0) "/"A_DD "/"A_YYYY
return

LockSN:
IniRead, NotesCheck, %StickyNotesIni%, LockedNotes, %A_ThisMenuItem%
if (NotesCheck == "ERROR")
{
	InputBox, NotePasscode, Password, Input a password for %A_ThisMenuItem%, , 150, 140
	if (ErrorLevel = 1)
		return
	else
	{
		Menu, SubSettings, ToggleCheck, %A_ThisMenuItem%
		IniWrite, %NotePasscode%, %StickyNotesIni%, LockedNotes, %A_ThisMenuItem%
	}
}
else
{
	InputBox, NotesPasscode, Password, Input your password (Case Sensitive), HIDE, 150, 140
	if (ErrorLevel = 1)
		return
	else
	{
		if (NotesPasscode == NotesCheck)
		{
			Menu, SubSettings, ToggleCheck, %A_ThisMenuItem%
			IniDelete, %StickyNotesIni%, LockedNotes, %A_ThisMenuItem%
		}
	}
}
return

Tab:
Gui, Submit, NoHide
IniRead, TabChecking, %StickyNotesIni%, LockedNotes, %currentTab%
if (TabChecking == "ERROR")
	TabBackupName := currentTab
else
{
	Gui, Hide
	InputBoxLabel:
	InputBox, NotesCheck, %currentTab%, Input your password for %currentTab% (Case Sensitive), HIDE, 150, 140
	if (ErrorLevel = 1)
	{
		Gui, Show
		GuiControl, ChooseString, SysTabControl321, %TabBackupName%
	}
	else
	{
		if (NotesCheck == TabChecking)
			Gui, Show
		else
			Goto, InputBoxLabel
	}
}
return

Apply:
Gui, Settings:Submit, NoHide
if (PW = 1)
{
	InputBox, PasscodeCheck, Password, Input your password (Case Sensitive), ,150, 140
	if (PasscodeCheck == PC)
		Goto, WriteApply
	else
		ToolTipTimer("Password was not the same, try again", 2000)
}
else
	Goto, WriteApply
return

WriteApply:
Gui, Settings:Submit
Gui, 1:Default
tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
Loop, %tcount%
{
	Gui, Tab, %A_Index%
	Gui, Color, , %EditColor%
	GuiControl, +c%TextColor%, Edit%A_Index%
}
IniWrite, %EditColor%, %StickyNotesIni%, Settings, EditColor
IniWrite, %TextColor%, %StickyNotesIni%, Settings, TextColor
IniWrite, %ATColor%, %StickyNotesIni%, Settings, AutomaticTextColor
IniWrite, %SoS%, %StickyNotesIni%, Settings, ShowOnStartup
IniWrite, %SoS%, %StickyNotesIni%, Settings, ShowOnStartup
IniWrite, %DM%, %StickyNotesIni%, Settings, DarkMode
IniWrite, %PW%, %StickyNotesIni%, Settings, Password
IniWrite, %PC%, %StickyNotesIni%, Settings, Passcode
IniWrite, %Hotkey%, %StickyNotesIni%, Settings, HotkeyShow
Hotkey, %HotkeyShow%, PasscodeCheckEnter
Password := PW = 0 ? 0 : 1
return

PW:
Gui, Submit, NoHide
if (PW = 1)
{
	GuiControl, Enable, Edit3
	ToolTipTimer("Remember this password", 2000)
}
if (PW = 0)
{
	if (Passcode = "")
	{
		GuiControl, Settings:Disable, Edit3
		GuiControl, Settings:Text, Edit3
	}
	else
	{
		InputBox, PasswordCheck, Password, Input your password (Case Sensitive), HIDE, 150, 140
		if (PasswordCheck == Passcode)
		{
			GuiControl, Settings:Disable, Edit3
			GuiControl, Settings:Text, Edit3
		}
		else
		{
			GuiControl, Settings:, Button7, 1
			GuiControl, Settings:Text, Button7, Password is incorrect
			Sleep, 1000
			GuiControl, Settings:Text, Button7, Password
		}
	}
	
	
}
return

DM:
Gui, Submit, NoHide
GuiControl, Settings:Disable%DM%, Edit1
GuiControl, Settings:Disable%DM%, Button1
GuiControl, Settings:Disable%DM%, Edit2
GuiControl, Settings:Disable%DM%, Button2
GuiControl, Settings:Disable%DM%, Button3
GuiControl, Settings:Text, Edit1, % DM = 1 ? 0x1A1A1B : 0xFFFFFF
Goto, ATColor
return

ATColor:
Gui, Submit, NoHide
GuiControl, Settings:Disable%ATColor%, Edit2
GuiControl, Settings:Disable%ATColor%, Button2
if (ATColor = 1)
	TextColor := HexDec(EditColor) < 8355711 ? 0xFFFFFF : 0x000000
GuiControl, Settings:Text, Edit2, %TextColor%
GuiControl, Settings:+Background%TextColor%, SysListView322
return

ChooseColorEdit:
ChooseColorText:
if (ChooseColor(Col,CColors)=1)
{
	Loop, 16
		IniWrite, % CColors[A_Index], %StickyNotesIni%, Settings, Color%A_Index%
	SetFormat, Integer, H
	Color := BGRtoRGB(Col)
	SetFormat, Integer, D
	GuiControl, Settings:+Background%Color%, SysListView321
	GuiControl, Settings:Text, % A_ThisLabel = "ChooseColorEdit" ? "Edit1" : "Edit2", %Color%
}
if (A_ThisLabel = "ChooseColorEdit")
	Goto, ATColor
else
{
	GuiControlGet, colorcheck, Settings: , Edit1
	GuiControl, Settings:+Background%colorcheck%, SysListView321
}
return

EditColor:
TextColor:
Gui, Submit, NoHide
tempvar := %A_ThisLabel%
GuiControl, Settings:+Background%tempvar%, % A_ThisLabel = "EditColor" ? "SysListView321" : "SysListView322"
if (A_ThisLabel = "EditColor")
	Goto, ATColor
return

Settings:
GuiControlGet, CheckifAOT, , Button7
Gui, Settings:Show, , Settings
if CheckifAOT
	Gui, Settings:+AlwaysOnTop
return

AOT:
Winset, AlwaysOnTop, Toggle
return

AutoSave:
ControlGet, CurrentTabName, Tab, , SysTabControl321, A
GuiControlGet, EditCheck, , Edit%CurrentTabName%
if InStr(EditCheck, "\")
	GuiControl, Text, Edit%CurrentTabName%, % StrReplace(EditCheck, "\")
else
{
	Gui, Show, , *Sticky Notes
	if (AutoS = 1)
		SetTimer, Save, -60000
}
return

~^s::
if (WinActive("ahk_id" SN))
	Goto, Save
return

Save:
ControlGet, CurrentTabName, Tab, , SysTabControl321, A
tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
Loop, %tcount%
{
	GuiControl, Choose, SysTabControl321, %A_Index%
	Gui, Submit, NoHide
	GuiControlGet, Edit, , Edit%A_Index%
	Loop, Parse, Edit, `n
		SaveText .= A_LoopField "\" 
	TabNames .= currentTab "|" 
	IniWrite, %SaveText%, %StickyNotesIni%, StickyNotes, %currentTab%
	SaveText := ""
}
IniWrite, %TabNames%, %StickyNotesIni%, StickyNotes, TabNames
TabNames := ""
GuiControl, Choose, SysTabControl321, %CurrentTabName%
Gui, Show, NoActivate, Sticky Notes
return

New:
GuiControl, , SysTabControl321, Untitled
tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
Gui, Tab, %tcount%
Gui, Add, Edit, w300 h200 gAutoSave c%TextC%
Menu, SubSettings, Add, Untitled, LockSN
Gui, Show, , Sticky Notes
return

Delete:
Gui, +OwnDialogs
tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
if (tcount = 1)
	MsgBox, 48, Sorry, You are not allowed to delete the last tab remaining
else 
{
	MsgBox, 308, Wait, Are you sure you want to delete the last sticky note?
	IfMsgBox, No
		return
	IfMsgBox, Yes
	{
		MsgBox, 308, Wait!, Are you sure?, 0
		IfMsgBox, No
			return
		IfMsgBox, Yes
		{
			ControlGet, CurrentTabName, Tab, , SysTabControl321, A
			tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
			Loop, % tcount-1
			{
				GuiControl, Choose, SysTabControl321, %A_Index%
				Gui, Submit, NoHide
				names .= "|" currentTab
			}
			GuiControl, Choose, SysTabControl321, %tcount%
			Gui, Submit, NoHide
			IniDelete, %StickyNotesIni%, StickyNotes, %currentTab%
			Menu, SubSettings, Delete, %currentTab%
			GuiControl, Text, Edit%tcount%
			GuiControl, , SysTabControl321, %names%
			GoSub, Save
			GuiControl, Choose, SysTabControl321, %CurrentTabName%
			names := ""
		}
	}
}
return

ChangeName:
Gui, +OwnDialogs
ControlGet, CurrentTabName, Tab, , SysTabControl321, A
InputBox, NewName, Change Name, Put the new name, , 130, 125
if (NewName = "TabNames")
	MsgBox, 8208, Error, Sorry but you can't use that name, it would interfere with the saving system!
else
	if (ErrorLevel = 0)
	{
		tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
		Loop, %tcount%
		{
			GuiControl, Choose, SysTabControl321, %A_Index%
			Gui, Submit, NoHide
			names .= A_Index=CurrentTabName ? "|" NewName : "|" currentTab
		}
		GuiControl, , SysTabControl321, %names%
		Menu, SubSettings, Rename, %CurrentTabName%&, %NewName%
		GuiControl, Choose, SysTabControl321, %CurrentTabName%
		names := ""
	}
return

AddFiles:
Gui, +OwnDialogs
FileSelectFile, File, 3, C:\Users\%A_UserName%\Downloads, Open a file, ONLY TEXT YOU- (*.txt; *.ahk; *.doc)
GuiDropFiles:
if (A_ThisLabel = "GuiDropFiles")
	File := A_GuiEvent
if (File = "")
	return
else
{
	GoSub, New
	tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
	GuiControl, Choose, SysTabControl321, %tcount%
	FileRead, FileInput, %File%
	Gui, Tab, %tcount%
	GuiControl, Text, Edit%tcount%, %FileInput%
	Loop, %tcount%
	{
		GuiControl, Choose, SysTabControl321, %A_Index%
		Gui, Submit, NoHide
		names .= A_Index=tcount ? "|" LTrim(SubStr(File, InStr(File, "\", , , StrAmt(File, "\"))), "\") : "|" currentTab
	}
	GuiControl, , SysTabControl321, %names%
}
return

PasscodeCheckEnter:
if (Password = 1)
{
	InputBox, PasswordCheck, Login, Input your password (Case Sensitive), HIDE, 150, 140
	if (ErrorLevel = 1)
		return
	else
	{
		if (PasswordCheck == Passcode)
			Gui, Show, , Sticky Notes
		else
			Goto, PasscodeCheckEnter
	}
}
else
	Gui, Show, , Sticky Notes
return

StrAmt(haystack, needle, casesense := false) {
	StringCaseSense % casesense
	StrReplace(haystack, needle, , Count)
	return Count
}
ChooseColor(ByRef Color, ByRef CustColors, hWnd=0x0, Flags=0x103) { ;DISCLAIMER: This function is not mine, all the credit for this goes to Elgin on the forums, thank you for "borrowing" it to me :) Link: https://autohotkey.com/board/topic/8617-how-to-call-the-standard-choose-color-dialog/
	VarSetCapacity(CC,36+64,0)
	NumPut(36,CC)
	NumPut(hWnd,CC,4)
	NumPut(Color,CC,12)
	Loop 16
		NumPut(CustColors[A_Index],CC,32+A_Index*4)
	NumPut(&CC+36,CC,16)
	NumPut(Flags,CC,20)
	RVal:=DllCall( "comdlg32\ChooseColorW", Str,CC )
	Color:=NumGet(CC,12,"UInt")
	CustColors:=
	CustColors:=Object()
	Loop 16
	{
		CustColors.Insert(A_Index,Numget(CC,32+A_Index*4,"UInt"))
	}
	return RVal
}
BGRtoRGB(oldValue) { ;DISCLAIMER: This function is not mine, all the credit for this goes to Micha on the forums, thanks for letting me "borrow" it, Link: https://autohotkey.com/board/topic/8617-how-to-call-the-standard-choose-color-dialog/
	Value := (oldValue & 0x00ff00)
	Value += ((oldValue & 0xff0000) >> 16)
	Value += ((oldValue & 0x0000ff) << 16)  
	return Value
}
HexDec(DX) {
	DH := InStr(DX, "0x") > 0 ? "D" : "H"
	SetFormat Integer, %DH%
	return DX + 0
}
ToolTipTimer(Text, Timeout, x:="x", y:="y", WhichToolTip:=1) {
	If (x = "x")
		MouseGetPos, X
	If (y = "y")
		MouseGetPos, , Y
	ToolTip, %Text%, %X%, %Y%, %WhichToolTip%
	SetTimer, RemoveToolTip, -%Timeout%
	return
	
	RemoveToolTip:
	ToolTip
	return
}
Gst() {   ; GetSelectedText by Learning one 
	IsClipEmpty := (Clipboard = "") ? 1 : 0
	if !IsClipEmpty  {
		ClipboardBackup := ClipboardAll
		While !(Clipboard = "")  {
			Clipboard =
			Sleep, 10
		}
	}
	Send, ^c
	ClipWait, 0.1
	ToReturn := Clipboard, Clipboard := ClipboardBackup
	if !IsClipEmpty
		ClipWait, 0.5, 1
	return ToReturn
}
