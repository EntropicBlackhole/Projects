#Persistent
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
#IfWinNotActive, Adventure
:*:(::(){left}
:*:{::{{}{}}{left}}
:*:[::[]{left}
#If
*^+d::Run, C:\Users\%A_UserName%\Downloads
^!m::ToolTipTimer(Morse(Gst(), "t"), 5000)
!WheelUp::GoSub, GeometricVolumeUp
!WheelDown::GoSub, GeometricVolumeDown
!MButton::Send, {Media_Play_Pause}
!RButton::Send, !r
!LButton::Send, ^s
;^+c::Goto, SearchGoogle
;^+x::Goto, SearchGoogle
^!c::Goto, Copy+
^!x::Goto, Copy+
Numpad1::SetWallpaper("C:\Users\" A_UserName "\OneDrive\Pictures\Saved Pictures\pic1.jpg")
Numpad2::SetWallpaper("C:\Users\" A_UserName "\OneDrive\Pictures\Saved Pictures\pic2.jpg")
Numpad3::SetWallpaper("C:\Users\" A_UserName "\OneDrive\Pictures\Saved Pictures\pic3.jpg")
Numpad4::SetWallpaper("C:\Users\" A_UserName "\OneDrive\Pictures\Saved Pictures\pic4.jpg")
Numpad5::SetWallpaper("C:\Users\" A_UserName "\OneDrive\Pictures\Saved Pictures\pic5.jpg")
#IfWinNotActive ahk_exe javaw.exe
MButton::Send, {Browser_Back}
#If
^+Space:: Winset, Alwaysontop, , A
>!0::Send, ∞
>!1::Send, ∆
>!2::Send, ≤
>!3::Send, ≥
>!4::Send, √
>!5::Send, π
>!6::Send, α
>!7::Send, β
>!8::Send, θ
>!9::Send, °
<!1::Send, ¹
<!2::Send, ²
<!3::Send, ³
<!4::Send, ⁴
<!5::Send, ⁵
<!6::Send, ⁶
<!7::Send, ⁷
<!8::Send, ⁸
<!9::Send, ⁹
<!0::Send, ⁰
return

~LButton::
MouseGetPos,,, winID
if (winID = WinExist("ahk_class tooltips_class32"))
	WinClose, ahk_id %winID%
return

GeometricVolumeUp:
SoundGet, current_volume
volume_change := current_volume//10
SoundSet, +%volume_change%
Send {Volume_Up}
return

GeometricVolumeDown:
SoundGet, current_volume
volume_change := current_volume//10
SoundSet, -%volume_change%
Send {Volume_Down}
return

Pause:: 
gLC := getLinearCoords(x_start, x_end, y_start, y_end)
ToolTip, %gLC%
clipboard := gLC
SetTimer, RemoveToolTip, -5000
return

+Pause::
gSC := getSelectionCoords(x_start, x_end, y_start, y_end)
ToolTip, %gSC%
clipboard := gSC
SetTimer, RemoveToolTip, -5000
return
	
#IfWinNotActive, ahk_exe javaw.exe
+WheelUp::
+WheelDown::
#If
NumpadAdd::
NumpadSub::
MouseGetPos,,, currentWindow
if not (%currentWindow%)
	GoSub GetTransparent
if InStr(A_ThisHotkey, "Up") || InStr(A_ThisHotkey, "Add")
	if (%currentWindow% < 255)
		%currentWindow% += 25
if InStr(A_ThisHotkey, "Down") || InStr(A_ThisHotkey, "Sub")
	if (%currentWindow% > 5) || 
		%currentWindow% -= 25
WinSet, Transparent, % %currentWindow%, ahk_id %currentWindow%
return


GetTransparent:
WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
if (ExStyle & 0x80000)
{
	WinGet, TransLevel, Transparent, ahk_id %currentWindow%
	%currentWindow% := TransLevel
}
else
	%currentWindow% := 255
Return

SearchGoogle:
backupclip := clipboard
Send, % StrReplace(A_ThisHotkey, "+")
if (clipboard = backupclip)
	Goto, SearchGoogle
Sleep 50
Msgbox, % WinActive("Chrome")
if WinActive("Chrome")
{
	Send, ^t
	Send, ^v
	Send, {Enter}
}
else
	Run, http://www.google.com/search?q=%clipboard%
return

Copy+:
clipbackup := clipboard
Send, % StrReplace(A_ThisHotkey, "!")
clipboard := clipbackup "`n" clipboard
KeyWait, %A_ThisHotkey%
return

getSelectionCoords(ByRef x_start, ByRef x_end, ByRef y_start, ByRef y_end) {
	SetSystemCursor("IDC_Cross")
	Gui, Color, FFFFFF
	Gui +LastFound
	WinSet, Transparent, 50
	Gui, -Caption 
	Gui, +AlwaysOnTop
	Gui, Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%,"AutoHotkeySnapshotApp"     
	CoordMode, Mouse, Screen
	CoordMode, Tooltip, Screen
	WinGet, hw_frame_m,ID,"AutoHotkeySnapshotApp"
	hdc_frame_m := DllCall( "GetDC", "uint", hw_frame_m)
	KeyWait, LButton, D
	MouseGetPos, scan_x_start, scan_y_start 
	Loop
	{
		Sleep, 10   
		KeyIsDown := GetKeyState("LButton")
		if (KeyIsDown = 1)
		{
			MouseGetPos, scan_x, scan_y 
			DllCall( "gdi32.dll\Rectangle", "uint", hdc_frame_m, "int", 0,"int",0,"int", A_ScreenWidth,"int",A_ScreenWidth)
			DllCall( "gdi32.dll\Rectangle", "uint", hdc_frame_m, "int", scan_x_start,"int",scan_y_start,"int", scan_x,"int",scan_y)
		} else {
			break
		}
	}
	MouseGetPos, scan_x_end, scan_y_end
	Gui, Destroy
	RestoreCursors()
	return scan_x_start ", "scan_y_start ", "scan_x_end ", "scan_y_end
}
getLinearCoords(ByRef x_start, ByRef x_end, ByRef y_start, ByRef y_end) { 
	SetSystemCursor("IDC_Cross")
	Gui, Color, FFFFFF
	Gui +LastFound
	WinSet, Transparent, 50
	Gui, -Caption 
	Gui, +AlwaysOnTop +ToolWindow
	Gui, Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%,"AutoHotkeySnapshotApp"   
	GuiHwnd := WinExist()
	CoordMode, Mouse, Screen
	CoordMode, Tooltip, Screen
	WinGet, hw_frame_m,ID,"AutoHotkeySnapshotApp"
	hdc_frame_m := DllCall( "GetDC", "uint", hw_frame_m)
	KeyWait, LButton, D 
	MouseGetPos, scan_x_start, scan_y_start 
	Loop
	{
		KeyIsDown := GetKeyState("LButton")
		if (KeyIsDown = 1)
		{
			MouseGetPos, M_x, M_y
			If (M_x != Old_M_x or M_y != Old_M_y)
				WinSet, Redraw,, ahk_id %GuiHwnd%
			Canvas_DrawLine(GuihWnd, scan_x_start, scan_y_start, M_x, M_y, 2)
			
			Old_M_x := M_x
			Old_M_y := M_y
		} else {
			break
		}
	}
	MouseGetPos, scan_x_end, scan_y_end
	Gui, Destroy
	RestoreCursors()
	X := Abs(scan_x_end-scan_x_start)
	Y := Abs(scan_y_end-scan_y_start)
	return X ", " Y
}
Canvas_DrawLine(hWnd, p_x1, p_y1, p_x2, p_y2, p_w) {
	p_x1 -= 1, p_y1 -= 1, p_x2 -= 1, p_y2 -= 1
	hDC := DllCall("GetDC", UInt, hWnd)
	DllCall("gdi32.dll\MoveToEx", UInt, hdc, Uint,p_x1, Uint, p_y1, Uint, 0 )
	DllCall("gdi32.dll\LineTo", UInt, hdc, Uint, p_x2, Uint, p_y2 )
}
RestoreCursors() {
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 ) ;*[General Hotkeys]
}
SetSystemCursor( Cursor = "", cx = 0, cy = 0 ) {
	BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
	
	SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
	,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
	,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
	,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
	
	If Cursor = ; empty, so create blank cursor 
	{
		VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
		BlankCursor = 1 ; flag for later
	}
	Else If SubStr( Cursor,1,4 ) = "IDC_" ; load system cursor
	{
		Loop, Parse, SystemCursors, `,
		{
			CursorName := SubStr( A_Loopfield, 6, 15 ) ; get the cursor name, no trailing space with substr
			CursorID := SubStr( A_Loopfield, 1, 5 ) ; get the cursor id
			SystemCursor = 1
			If ( CursorName = Cursor )
			{
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
				Break               
			}
		}   
		If CursorHandle = ; invalid cursor name given
		{
			Msgbox,, SetCursor, Error: Invalid cursor name
			CursorHandle = Error
		}
	}   
	Else If FileExist( Cursor )
	{
		SplitPath, Cursor,,, Ext ; auto-detect type
		If Ext = ico 
			uType := 0x1   
		Else If Ext in cur,ani
			uType := 0x2      
		Else ; invalid file ext
		{
			Msgbox,, SetCursor, Error: Invalid file type
			CursorHandle = Error
		}      
		FileCursor = 1
	}
	Else
	{   
		Msgbox,, SetCursor, Error: Invalid file path or cursor name
		CursorHandle = Error ; raise for later
	}
	If CursorHandle != Error 
	{
		Loop, Parse, SystemCursors, `,
		{
			If BlankCursor = 1 
			{
				Type = BlankCursor
				%Type%%A_Index% := DllCall( "CreateCursor"
				, Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}         
			Else If SystemCursor = 1
			{
				Type = SystemCursor
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
				%Type%%A_Index% := DllCall( "CopyImage"
				, Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )      
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}
			Else If FileCursor = 1
			{
				Type = FileCursor
				%Type%%A_Index% := DllCall( "LoadImageA"
				, UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 ) 
				DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )         
			}          
		}
	}   
}
SetWallpaper(BMPpath) {
	SPI_SETDESKWALLPAPER := 20
	SPIF_SENDWININICHANGE := 2  
	Return DllCall("SystemParametersInfo", UINT, SPI_SETDESKWALLPAPER, UINT, uiParam, STR, BMPpath, UINT, SPIF_SENDWININICHANGE)
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
Morse(string, to := "morse") {
	MorseArrayM2T := {".-" : "A", "-..." : "B", "-.-." : "C", "-.." : "D", "." : "E"
	, "..-." : "F", "--." : "G", "...." : "H", ".." : "I", ".---" : "J", "-.-" : "K"
	, ".-.." : "L", "--" : "M", "-." : "N", "---" : "O", ".--." : "P", "--.-" : "Q"
	, ".-." : "R", "..." : "S", "-" : "T", "..-" : "U", "...-" : "V", ".--" : "W"
	, "-..-" : "X", "-.--" : "Y", "--.." : "Z", "-----" : 0, ".----" : 1, "..---" : 2
	, "...--" : 3, "....-" : 4, "....." : 5, "-...." : 6, "--..." : 7, "---.." : 8, "----." : 9}
	MorseArrayT2M := {"A" : ".-", "B" : "-...", "C" : "-.-.", "D" : "-..", "E" : "."
	, "F" : "..-.", "G" : "--.", "H" : "....", "I" : "..", "J" : ".---", "K" : "-.-"
	, "L" : ".-..", "M" : "--", "N" : "-.", "O" : "---", "P" : ".--.", "Q" : "--.-"
	, "R" : ".-.", "S" : "...", "T" : "-", "U" : "..-", "V" : "...-", "W" : ".--"
	, "X" : "-..-", "Y" : "-.--", "Z" : "--..", 0 : "-----", 1 : ".----", 2 : "..---"
	, 3 : "...--", 4 : "....-", 5 : ".....", 6 : "-....", 7 : "--...", 8 : "---..", 9 : "----."}
	if (to = "morse" || to = "m")
		Loop, Parse, string, %A_Space%
		{
			Loop, Parse, A_LoopField
				text .= MorseArrayT2M[A_LoopField] . A_Space
			text .= A_Space "/" A_Space
		}
	if (to = "text" || to = "t")
	{
		Loop, Parse, string, /
		{
			Loop, Parse, A_LoopField, %A_Space%
				text .= MorseArrayM2T[A_LoopField]
			text .= A_Space
		}
	}
	return RTrim(text, "/"" ")
}
ToolTipTimer(Text, Timeout := 2000, x := "", y := "", WhichToolTip := 1) {
	if not x
		MouseGetPos, X
	if not y
		MouseGetPos, , Y
	ToolTip, %Text%, %X%, %Y%, %WhichToolTip%
	SetTimer, RemoveToolTip, -%Timeout%
	return
	
	RemoveToolTip:
	ToolTip
	return
} 
IsInternetConnected() {
	static sz := A_IsUnicode ? 408 : 204, addrToStr := "Ws2_32\WSAAddressToString" (A_IsUnicode ? "W" : "A")
	VarSetCapacity(wsaData, 408)
	if DllCall("Ws2_32\WSAStartup", "UShort", 0x0202, "Ptr", &wsaData)
		return false
	if DllCall("Ws2_32\GetAddrInfoW", "wstr", "dns.msftncsi.com", "wstr", "http", "ptr", 0, "ptr*", results)
	{
		DllCall("Ws2_32\WSACleanup")
		return false
	}
	ai_family := NumGet(results+4, 0, "int")    ;address family (ipv4 or ipv6)
	ai_addr := Numget(results+16, 2*A_PtrSize, "ptr")   ;binary ip address
	ai_addrlen := Numget(results+16, 0, "ptr")   ;length of ip
	DllCall(addrToStr, "ptr", ai_addr, "uint", ai_addrlen, "ptr", 0, "str", wsaData, "uint*", 204)
	DllCall("Ws2_32\FreeAddrInfoW", "ptr", results)
	DllCall("Ws2_32\WSACleanup")
	http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if (ai_family = 2 && wsaData = "131.107.255.255:80")
		http.Open("GET", "http://www.msftncsi.com/ncsi.txt")
	else if (ai_family = 23 && wsaData = "[fd3e:4f5a:5b81::1]:80")
		http.Open("GET", "http://ipv6.msftncsi.com/ncsi.txt")
	else
		return false
	http.Send()
	return (http.ResponseText = "Microsoft NCSI") ;ncsi.txt will contain exactly this text
}
