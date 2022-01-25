#SingleInstance, Force
Fol := "C:\Users\" . A_UserName "\AppData\Local\EPBHs Creations\Sticky Notes"
Ini := Fol . "\Config.ini"
URLFile := Fol . "\Update.epbh"
if !FileExist(Ini)
{
	Settings := " ;Settings
	(
[Settings]
EditColor=0xFFFFFF
TextColor=0x000000
AutomaticTextColor=1
ShowOnStartup=1
AutoSave=1
DarkMode=0
Password=0
Passcode=
TabNames=Untitled
	)"
	FileCreateDir, %Fol%
	FileAppend, %Settings%, %Ini%
	FileAppend, , %URLFile%
}
IniRead, EditC, %Ini%, Settings, EditColor
IniRead, TextC, %Ini%, Settings, TextColor
IniRead, ATC, %Ini%, Settings, AutomaticTextColor
IniRead, StartupShow, %Ini%, Settings, ShowOnStartup
IniRead, AutoS, %Ini%, Settings, AutoSave
IniRead, DarkMode, %Ini%, Settings, DarkMode
IniRead, Password, %Ini%, Settings, Password
IniRead, Passcode, %Ini%, Settings, Passcode
IniRead, TNames, %Ini%, Settings, TabNames
URL := "https://raw.githubusercontent.com/EntropicBlackhole/Projects/main/Sticky%20Notes%202.1.ahk" ;This will only work if the script isnt compiled
Gui, Add, Tab3, hwndtab vcurrentTab gTab, %TNames%
if (TNames = "Untitled")
	Gui, Add, Edit, w300 h200 gAutoSave c%TextC%
else
{
	tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
	Loop, Parse, TNames, |
	{
		Gui, Tab, %A_Index%
		FileRead, EditVar, %Fol%\%A_LoopField%.txt
		Gui, Add, Edit, w300 h200 gAutoSave c%TextC%, %EditVar%
	}
}
Gui, Color, , %EditC%
Gui, Tab
Gui, Add, Button, gSave, Save
Gui, Add, Button, gNew x+5, New
Gui, Add, Button, gDelete x+5, Delete
Gui, Add, Button, gChangeName x+5, Change Name
Gui, Add, Button, gAddFiles x+5, 🔺
Gui, Add, Button, gSettings x+5, ⚙
Gui, Add, CheckBox, gAOT x+5 yp+4, AOT
if (StartupShow = 1)
	GoSub, PasscodeCheckEnter
Gui, +HwndSN
Gui, New, , Settings
Gui, Settings:Add, Text, x10 y10 w50 h20, Edit Color
Gui, Settings:Add, Edit, y+0 w80 h20 gEditColor vEditColor, %EditC%
Gui, Settings:Add, ListView, x+10 w20 h20 +Background%EditC%
Gui, Settings:Add, Text, x10 y60 w50 h20, Text Color
Gui, Settings:Add, Edit, y+0 w80 h20 gTextColor vTextColor Disabled%ATC%, %TextC%
Gui, Settings:Add, ListView, x+10 w20 h20 +Background%TextC%
Gui, Settings:Add, CheckBox, x10 +Checked%ATC% gATColor vATColor, Automatic Text Color
Gui, Settings:Add, CheckBox, +Checked%StartupShow% vSoS, Show on Startup
Gui, Settings:Add, CheckBox, +Checked%AutoS% vAS, AutoSave
Gui, Settings:Add, CheckBox, +Checked%DarkMode% gDM vDM, Dark Mode
Gui, Settings:Add, CheckBox, +Checked%Password% gPW vPW w200, Password
Gui, Settings:Add, Edit, Password w120 vPC, %Passcode%
GuiControl, Settings:Enable%Password%, PC
Gui, Settings:Add, Button, gApply, Apply
Gui, Settings:+ToolWindow +Owner
if !(A_IsCompiled)
{
	Gui, Settings:Add, Button, gUpdate vUpdate xm+150 ym Disabled, Update
	URLDownloadToFile, %URL%, %URLFile%
	FileRead, UpdateCheck, %URlFile%
	if !(UpdateCheck = "404: Not Found")
		GuiControl, Settings:Enable, Update
}
if FileExist(Fol "\Sticky Notes.ini")
{
	IniRead, OldTNames, %Fol%\Sticky Notes.ini, StickyNotes, TabNames
	Loop, Parse, % RTrim(OldTNames, "|"), |
	{
		IniRead, Stuff, %Fol%\Sticky Notes.ini, StickyNotes, %A_LoopField%
		NewTNames .= A_LoopField "|"
		Stuff := StrReplace(Stuff, "\", "`n")
		FileAppend, %Stuff%, %Fol%\%A_LoopField%.txt
	}
	TNames := RTrim(NewTNames, "|")
	IniWrite, %TNames%, %Ini%, Settings, TabNames
	IniRead, OldSettings, %Fol%\Sticky Notes.ini, Settings
	Loop, Parse, OldSettings, `n
	{
		StringSplit, OutSet, A_LoopField, =
		if (OutSet1 = "HotkeyShow")
			break
		IniWrite, %OutSet2%, %Ini%, Settings, %OutSet1%
	}
	FileDelete, %Fol%\Sticky Notes.ini
	Reload
}
return

Update:
MsgBox 0x24, Sticky Notes, There's an update pending. Update?
IfMsgBox, Yes
{
	GoSub, Save
	URLDownloadToFile, %URL%, %URLFile%
	FileRead, NewCode, %URLFile%
	Script := A_ScriptFullPath
	FileDelete, %Script%
	FileAppend, %NewCode%, %Script%
	Reload
}
return

Apply:
Gui, Settings:Submit, NoHide
if (PW = 1)
{
	InputBox, PasscodeCheck, Input your password, Input the password to confirm
	if (PasscodeCheck == PC)
		Goto, ApplyFinal
	else
		ToolTipTimer("Password was not the same, try again", 2000)
}
else
	Goto, ApplyFinal
return

ApplyFinal:
Gui, Settings:Submit
Gui, 1:Default
tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
Gui, Color, , %EditColor%
Loop, %tcount%
	GuiControl, +c%TextColor%, Edit%A_Index%
IniWrite, %EditColor%, %Ini%, Settings, EditColor
IniWrite, %TextColor%, %Ini%, Settings, TextColor
IniWrite, %ATColor%, %Ini%, Settings, AutomaticTextColor
IniWrite, %SoS%, %Ini%, Settings, ShowOnStartup
IniWrite, %DM%, %Ini%, Settings, DarkMode
IniWrite, %PW%, %Ini%, Settings, Password
IniWrite, %PC%, %Ini%, Settings, Passcode
Password := PW
Passcode := PC
return

PW:
Gui, Settings:Submit, NoHide
if (PW = 1)
{
	GuiControl, Settings:Enable, PC
	ToolTipTimer("Remember this password", 2000)
}
if (PW = 0)
{
	if (Passcode = "")
	{
		GuiControl, Settings:Disable, PC
		GuiControl, Settings:Text, PC
	}
	else
	{
		InputBox, PasswordCheck, Input your password, You must input your password first (Case Sensitive)
		if (PasswordCheck == Passcode)
		{
			GuiControl, Settings:Disable, PC
			GuiControl, Settings:Text, PC
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
Gui, Settings:Submit, NoHide
GuiControl, Settings:Disable%DM%, EditColor
GuiControl, Settings:Disable%DM%, TextColor
GuiControl, Settings:Disable%DM%, ATColor
GuiControl, Settings:Text, EditColor, % (DM = 1) ? 0x1A1A1B : 0xFFFFFF
Goto, ATColor
return

ATColor:
Gui, Settings:Submit, NoHide
GuiControl, Settings:Disable%ATColor%, TextColor
if (ATColor = 1)
	TextColor := HexDec(EditColor) < 8355711 ? 0xFFFFFF : 0x000000
GuiControl, Settings:Text, TextColor, %TextColor%
GuiControl, Settings:+Background%TextColor%, SysListView322
return

EditColor:
TextColor:
Gui, Settings:Submit, NoHide
tempvar := %A_ThisLabel%
GuiControl, Settings:+Background%tempvar%, % (A_ThisLabel = "EditColor") ? "SysListView321" : "SysListView322"
if (A_ThisLabel = "EditColor")
	Goto, ATColor
return

Settings:
GuiControlGet, CheckifAOT, , Button7
WinGetPos, SnX, SnY, , , ahk_id %SN%
SnX += 70, SnY += 15
Gui, Settings:Show, x%SnX% y%SnY%, Settings
if CheckifAOT
	Gui, Settings:+AlwaysOnTop
return

AOT:
Winset, AlwaysOnTop, Toggle
return

Tab:
ControlGet, TabNum, Tab, , SysTabControl321, A
return

AutoSave:
Gui, Show, , *Sticky Notes
if (AutoS = 1)
	SetTimer, Save, -1000
return

^s::
if WinActive("ahk_id " SN)
	Goto, Save
return

Save:
Loop, Parse, TNames, |
{
	GuiControlGet, Edit, 1:, Edit%A_Index%
	FileDelete, %Fol%/%A_LoopField%.txt
	FileAppend, %Edit%, %Fol%/%A_LoopField%.txt
}
Gui, 1:Show, NoActivate, Sticky Notes
return

New:
GuiControl, , SysTabControl321, Untitled
tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
Gui, Tab, %tcount%
Gui, Add, Edit, w300 h200 gAutoSave
GuiControl, Choose, SysTabControl321, %tcount%
TNames .= "|Untitled"
IniWrite, %TNames%, %Ini%, Settings, TabNames
FileAppend, , %Fol%\Untitled.txt
return

Delete:
Gui, +OwnDialogs
tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
if (tcount = 1)
	MsgBox, 48, Sorry, You are not allowed to delete the last tab remaining
else 
{
	MsgBox, 308, Wait, Are you sure you want to delete this sticky note?
	IfMsgBox, Yes
	{
		ControlGet, TabNum, Tab, , SysTabControl321, ahk_id %SN%
		Gui, Submit, NoHide
		Loop, Parse, TNames, |
		{
			if !(A_LoopField = currentTab)
				newNames .= A_LoopField "|"
		}
		TNames := RTrim(newNames, "|")
		newNames := ""
		Loop, %tcount%
			if (A_Index >= TabNum)
			{
				GuiControlGet, DelEdit, , % "Edit" A_Index+1
				GuiControl, , Edit%A_Index%, %DelEdit%
			}
		FileDelete, %Fol%\%currentTab%.txt
		GuiControl, , SysTabControl321, |%TNames%
		IniWrite, %TNames%, %Ini%, Settings, TabNames
		GuiControl, , Edit%tcount%
	}
	IfMsgBox, No
		return
}
return

ChangeName:
Gui, Submit, NoHide
Gui, +OwnDialogs
ControlGet, TabNum, Tab, , SysTabControl321, ahk_id %SN%
InputBox, NewName, Sticky Notes, Insert a new name, , 130, 125
if (ErrorLevel = 0)
{
	Loop, Parse, TNames, |
		if (A_LoopField = NewName)
		{
			MsgBox, 0x30, Sticky Notes, You already have a file with this name
			return
		}
	Loop, Parse, TNames, |
		newNames .= (A_Index = TabNum) ? "|" NewName : "|" A_LoopField
	GuiControl, , SysTabControl321, %newNames%
	GuiControl, Choose, SysTabControl321, %TabNum%
	TNames := LTrim(newNames, "|")
	newNames := ""
	FileRead, tempvar, %Fol%\%currentTab%.txt
	FileAppend, %tempvar%, %Fol%\%NewName%.txt
	FileDelete, %Fol%\%currentTab%.txt
	IniWrite, %TNames%, %Ini%, Settings, TabNames
}
return

AddFiles:
Gui, +OwnDialogs
FileSelectFile, File, 3, C:\Users\%A_UserName%\Downloads, Open a file, Only text (*.txt)
GuiDropFiles:
if (A_ThisLabel = "GuiDropFiles")
	File := A_GuiEvent
if (File = "")
	return
else
{
	tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
	SplitPath, File, , , , OutNameNoExt
	GuiControl, , SysTabControl321, %OutNameNoExt%
	FileRead, FileInput, %File%
	Gui, Tab, %tcount%
	Gui, Add, Edit, w300 h200 gAutoSave, %FileInput%
	TNames .= "|" OutNameNoExt
	IniWrite, %TNames%, Ini, Settings, TabNames
}
return

PasscodeCheckEnter:
F4::
if (Password = 1)
{
	InputBox, PasswordCheck, Input your password, Input your password (Case Sensitive)
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
