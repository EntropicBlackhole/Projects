if !(FileExist(A_Desktop "\StickyNotes.ini"))
{
	TNames := "Untitled"
	Gui, Add, Tab3, hwndtab vcurrentTab, %TNames% 
	Gui, Add, Edit, w300 h200 gAutoSave
}
else
{
	IniRead, TNames, %A_Desktop%\StickyNotes.ini, StickyNotes, TabNames
	Gui, Add, Tab3, hwndtab vcurrentTab, %TNames%
	tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
	StringTrimRight, TNames, TNames, 1
	Loop, Parse, TNames, |
	{
		Gui, Tab, %A_Index%
		IniRead, EditVar, %A_Desktop%\StickyNotes.ini, StickyNotes, %A_LoopField%
		StringTrimRight, EditVar, EditVar, 1
		Loop, Parse, EditVar, \
		{
			EditPut .= A_LoopField "`n"
		}
		StringTrimRight, EditPut, Editput, 1
		Gui, Add, Edit, w300 h200 gAutoSave, %EditPut%
		EditPut := ""
		EditVar := ""
	}
}
Gui, Tab
Gui, Add, Button, gSave, Save
Gui, Add, Button, gNew x+5, New
Gui, Add, Button, gDelete x+5, Delete Last
Gui, Add, Button, gChangeName x+5, Change Name
Gui, Add, Button, gAddFiles x+5, 🔺
Gui, Add, CheckBox, gAOT x+5 y255, AOT
Gui, Show, , Sticky Notes
Gui, +HwndSN
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
	SetTimer, Save, -60000
}
return


~^s::
if (WinActive("ahk_id" SN))
	Goto, Save
return

Save:
FileDelete, %A_Desktop%\StickyNotes.ini
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
	IniWrite, %SaveText%, %A_Desktop%\StickyNotes.ini, StickyNotes, %currentTab%
	SaveText := ""
}
IniWrite, %TabNames%, %A_Desktop%\StickyNotes.ini, StickyNotes, TabNames
TabNames := ""
GuiControl, Choose, SysTabControl321, %CurrentTabName%
Gui, Show, NoActivate, Sticky Notes
return

New:
GuiControl, , SysTabControl321, Untitled
tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
Gui, Tab, %tcount%
Gui, Add, Edit, w300 h200 gAutoSave
return

Delete:
Gui, +OwnDialogs
tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
if (tcount = 1)
	MsgBox, 48, Sorry, You are not allowed to delete the last tab remaining, 0
else 
{
	MsgBox, 308, Wait, Are you sure you want to delete the last sticky note?, 0
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
			GuiControl, Text, Edit%tcount%
			GuiControl, , SysTabControl321, %names%
			GuiControl, Choose, SysTabControl321, %CurrentTabName%
			names := ""
		}
	}
}
return

ChangeName:
Gui, +OwnDialogs
ControlGet, CurrentTabName, Tab, , SysTabControl321, A
InputBox, NewName, Sticky Notes, Put the new name, , 130, 125
if (NewName = "TabNames")
	MsgBox, 8501, Error, Sorry but you can't use that name, it would interfere with the saving system!, 0
else
	if (ErrorLevel = 0)
	{
		tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
		Loop, %tcount%
		{
			GuiControl, Choose, SysTabControl321, %A_Index%
			Gui, Submit, NoHide
			if (A_Index = CurrentTabName)
				names .= "|" NewName
			else
				names .= "|" currentTab
		}
		GuiControl, , SysTabControl321, %names%
		GuiControl, Choose, SysTabControl321, %CurrentTabName%
		names := ""
}
return

GuiDropFiles:
if (A_GuiEvent = "")
	return
else
{
	GoSub, New
	tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
	GuiControl, Choose, SysTabControl321, %tcount%
	FileRead, FileInput, %A_GuiEvent%
	Gui, Tab, %tcount%
	GuiControl, Text, Edit%tcount%, %FileInput%
	Loop, %tcount%
	{
		GuiControl, Choose, SysTabControl321, %A_Index%
		Gui, Submit, NoHide
		if (A_Index = tcount)
			names .= "|" LTrim(SubStr(A_GuiEvent, InStr(A_GuiEvent, "\", , , StrAmt(A_GuiEvent, "\"))), "\")
		else
			names .= "|" currentTab
	}
	GuiControl, , SysTabControl321, %names%
}
return

AddFiles:
Gui, +OwnDialogs
FileSelectFile, File, 3, C:\Users\%A_UserName%\Downloads, Open a file, ONLY TEXT YOU- (*.txt; *.ahk; *.doc)
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
		if (A_Index = tcount)
			names .= "|" LTrim(SubStr(File, InStr(File, "\", , , StrAmt(File, "\"))), "\")
		else
			names .= "|" currentTab
	}
	GuiControl, , SysTabControl321, %names%
}
return

F4::Gui, Show

StrAmt(haystack, needle, casesense := false) {
	StringCaseSense % casesense
	StrReplace(haystack, needle, , Count)
	return Count
}
