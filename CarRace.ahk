Gui, Add, Button, y110, Car1
Gui, Add, Button, , Car2
Gui, Add, Button, , Car3
Gui, Add, Button, x10 y10, Go
Gui, Add, Progress, y+9 w25 Vertical
Gui, Add, Progress, x370 y110 h82 Vertical, 200
Gui, Add, ListView, x40 y10 h96 w345, Name                                |Score
Loop, 3
	LV_Add(, "Car"A_Index, 0)
Gui, Show, w400 h200, Car Race
return

ButtonGo:
GuiControl, Text, msctls_progress321, 33
GuiControl, +cRed, msctls_progress321
Sleep, 1000
GuiControl, Text, msctls_progress321, 66
GuiControl, +cYellow, msctls_progress321
Sleep, 1000
GuiControl, Text, msctls_progress321, 100
GuiControl, +cLime, msctls_progress321
Sleep, 1000
SetTimer, ColorBar, 50
SetTimer, MoveCars, 50
return

ColorBar:
GuiControl, +cRed, msctls_progress321
GuiControl, +cRed, msctls_progress322
Sleep, 50
GuiControl, +cEB8235, msctls_progress321
GuiControl, +cEB8235, msctls_progress322
Sleep, 50
GuiControl, +cYellow, msctls_progress321
GuiControl, +cYellow, msctls_progress322
Sleep, 50
GuiControl, +cLime, msctls_progress321
GuiControl, +cLime, msctls_progress322
Sleep, 50
GuiControl, +cGreen, msctls_progress321
GuiControl, +cGreen, msctls_progress322
Sleep, 50
GuiControl, +cBlue, msctls_progress321
GuiControl, +cBlue, msctls_progress322
Sleep, 50
GuiControl, +cNavy, msctls_progress321
GuiControl, +cNavy, msctls_progress322
Sleep, 50
GuiControl, +cFuchsia, msctls_progress321
GuiControl, +cFuchsia, msctls_progress322
return

MoveCars:
GuiControlGet, Car1, Pos, Button1
GuiControlGet, Car2, Pos, Button2
GuiControlGet, Car3, Pos, Button3
Loop, 3
	if (Car%A_Index%X >= 342)
	{
		IndexBackup := A_Index
		Goto, Win
	}
Loop, 3
{
	Random, Cars, 1, 10
	GuiControl, Move, Button%A_Index%, % "x"Cars+Car%A_Index%X
}
return


Win:
%IndexBackup%Car++
LV_Modify(IndexBackup, , , %IndexBackup%Car)
Msgbox, Car%IndexBackup% has won!
SetTimer, ColorBar, Off
SetTimer, MoveCars, Off
Loop, 3
	GuiControl, Move, Button%A_Index%, x10
Exit
return
