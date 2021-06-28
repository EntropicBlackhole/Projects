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
		Loop, Parse, EditVar, |
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
Gui, Add, CheckBox, gAOT x+5 y255, AOT
Gui, Show, , Sticky Notes
Gui, +HwndSN
return

AOT:
Winset, AlwaysOnTop, Toggle
return

AutoSave:
Gui, Show, , *Sticky Notes
SetTimer, Save, -60000
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
		SaveText .= A_LoopField "|" 
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

F4::Gui, Show