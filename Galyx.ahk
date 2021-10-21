#Include %A_ScriptDir%\TTS.ahk
#SingleInstance, Force
#Persistent
GalyxFolder := "C:\Users\" . A_UserName "\AppData\Local\EPBHs Creations\Galyx"
GalyxIco := GalyxFolder . "\Galyx_logo.ico"
GalyxWeather := GalyxFolder . "\Galyx_Wea.txt"
GalyxReminder := GalyxFolder . "\Galyx_Rem.txt"
GalxyIni := GalyxFolder . "\Galyx_OtherStuff.ini"
FileCreateDir, %GalyxFolder%
if !(FileExist(GalyxIco))
{
	if IsInternetConnected()
	{
		SplashTextOn, 200, 20, Downloading…, Downloading icon just one sec
		UrlDownloadToFile, https://i.imgur.com/Q8A89b1.png, %GalyxFolder%\Galyx_logo.png
		SplashTextOn, 200, 40, Converting…, Converting from .png to .ico just hold on
		Png2Icon(GalyxFolder . "\Galyx_logo.png", GalyxIco)
		FileDelete, %GalyxFolder%\Galyx_logo.png
		Sleep, 1000
		SplashTextOff
	}
}
if !FileExist(GalyxWeather)
	FileAppend, , %GalyxWeather%
if !FileExist(GalyxReminder)
	FileAppend, , %GalyxReminder%
if !FileExist(GalyxIni)
	FileAppend, , %GalyxIni%
Gui, Add, Edit, vReminder
Gui, Add, Button, x+5 gApplyRem, Apply
if FileExist(GalyxIco)
	Menu, Tray, Icon, %GalyxIco%
Menu, Tray, Add
Menu, Tray, Add, Start Listening, GalyxMenu
Menu, Tray, Disable, Start Listening
SetTitleMatchMode, 2
SendtoRem := false
Loop, Read, %GalyxReminder%
{
	StringSplit, Items, A_LoopReadLine, |
	if (Items2 = A_WDay)
	{
		ListOfRem .= Items1 "|"
		SendtoRem := true
	}
	else
		ListToKeep .= A_LoopReadLine "`n"
}
FileDelete, %GalyxReminder%
FileAppend, %ListToKeep%, %GalyxReminder%
if (SendtoRem = true)
{
	List := StrReplace(RTrim(ListOfRem, "|"), "|", ", ")
	ListOfRem := ""
	GoSub, Reminder
}
Val := Array("Hey Galyx", "Hi", "How's the weather?", "Set an alarm for", "Tell me a joke", "Stop listening", "Close app", "May I change your name?", "Can I change your name?", "How Galyx name change", "Open Window Spy", "Open Startup", "Play song", "Cancel", "Speech to text", "Control computer", "Set a reminder", "Edit reminders", "Open your folder")
Alarm := Array("Cancel", "5 seconds", "10 seconds", "20 seconds", "30 seconds", "40 seconds", "50 seconds" "1 minute", "2 minutes", "5 minutes", "10 minutes", "15 minutes", "20 minutes", "30 minutes", "40 minutes", "50 minutes", "1 hour", "2 hours", "3 hours", "4 hours", "6 hours", "8 hours", "10 hours", "12 hours")
Apps := Array("Paint", "File Explorer", "Chrome", "Discord", "Sticky Notes", "Task Manager", "Cancel")
CommonPhrases := Array("Yes", "No", "Why", "Please", "Cancel", "Don't", "Repeat")
CompComm := Array("Cancel", "Click", "Left click", "Right click", "Middle click", "Scroll up", "Scroll down", "Enter", "Backspace", "Left", "Right", "Up", "Down", "Mouse left", "Mouse right", "Mouse up", "Mouse down")
Reminder := Array("Tomorrow", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
DaysOfWeek := {"Sunday": 1, "Monday": 2, "Tuesday": 3, "Wednesday": 4, "Thursday": 5, "Friday": 6, "Saturday": 7}
Numbers := []
Loop, 100
	Numbers.Push(A_Index)
return

Hear:
Loop,
{
	HG := Recognize(Val)
	if (HG = Val[1]) ;Hey Galyx
	{
		SoundPlay, *-1
		Rec := Recognize(Val)
		if (Rec = Val[2]) ;Hi
			Speak("Hi")
		if (Rec = Val[3]) ;How's the weather?
		{
			if IsInternetConnected()
			{
				Weather := CheckWeather()
				Speak("The weather is: " Weather)
			}
			else
			{
				FileReadLine, Weather, %GalyxWeather%, 9
				Speak("We're currently offline, last time I checked the weather was " SubStr(Weather, -125, 4))
			}
		}
		if (Rec = Val[4]) ;Set an alarm for % Alarm[]
		{
			Output := (Recognize(Alarm))
			if (Output = Alarm[1]) ;Cancel
			{
				Speak("Canceling")
				continue
			}
			StringSplit, Time, Output, %A_Space%
			TimetoWait := (Time2 = "second" || Time2 = "seconds") ? Time1 : (Time2 = "minute" || Time2 = "minutes") ? Time1*60 : Time1*3600
			TimetoWait *= 1000
			Speak("Set an alarm for: " Output " in")
			SetTimer, Alarm, -%TimetoWait%
		}
		if (Rec = Val[5]) ;Tell me a joke
			Speak("No")
		if (Rec = Val[7]) ;CLose app
		{
			CloseApp:
			Speak("Okay, what app should I close?")
			CloseWin := Recognize(Apps)
			if (CloseWin = Apps[8]) ;Cancel
			{
				SoundPlay, *16
				continue
			}
			if WinExist(CloseWin)
			{
				WinKill, %CloseWin%
				Speak("Closed " CloseWin)
			}
			else
			{
				Speak("App not found, try again")
				GoSub, CloseApp
			}
			continue
		}
		if (Rec = Val[8] || Rec = Val[9] || Rec = Val[10]) ;May I change your name? ;Can I change your name? ;How Galyx name change
			Speak("I am afraid you cannot change my name")
		if (Rec = Val[11]) ;Open Window Spy (AHK WindowSpy)
			Run, C:\Program Files\AutoHotkey\WindowSpy.ahk
		if (Rec = Val[12]) ;Open Startup
			Run, %A_Startup%
		if (Rec = Val[13]) ;Play song
		{
			Files := GrabAllFilesFromFolder("C:\Users\" . A_UserName . "\Music\*.mp3")
			Songs := []
			Loop, Parse, Files, |
				Songs.Push(A_LoopField)
			Loop, Files, C:\Users\%A_UserName%\Music\*.mp3, R  ; Recurse into subfolders.
				ListPaths .= A_LoopFileFullPath "|"
			Speak("The songs you have are: " StrReplace(Files, "|", ", "))
			Speak("Which one do you choose?")
			SongRec := Recognize(Songs)
			Loop, Parse, ListPaths, |
			{
				SplitPath, A_LoopField, , , , MusicName
				if (MusicName = SongRec)
				{
					Music := A_LoopField
					break
				}
			}
			Speak("Playing: " SongRec)
			SoundPlay, %Music%
		}
		if (Rec = Val[14]) ;Cancel
			SoundPlay, Nonexistent.avi ;Speech to text (very bad)
		if (Rec = Val[15])
		{
			WordList := []
			Loop, Read, %A_Desktop%\test.txt
				WordList.Push(A_LoopReadLine)
			Speak("Writing everything you say, say Cancel to stop")
			Loop, 
			{
				StT := Recognize(WordList)
				if (StT = "Cancel")
					break
				Send, %StT%{enter}
			}
			SoundPlay, *16
		}
		if (Rec = Val[16]) ;Control Computer
		{
			Speak("Alright, just tell me what to do")
			Loop,
			{
				CC := Recognize(CompComm)
				if (CC = "Click" || CC = "Left click")
					MouseClick, Left
				if (CC = "Right Click")
					MouseClick, Right
				if (CC = "Middle click")
					MouseClick, Middle
				if (CC = "Scroll up")
				{
					Num := Recognize(Numbers)
					Loop, %Num%
						MouseClick, WheelUp
				}
				if (CC = "Scroll down")
				{
					Num := Recognize(Numbers)
					Loop, %Num%
						MouseClick, WheelDown
				}
				if (CC = "Enter" || CC = "Backspace" || CC = "Left" || CC = "Right" || CC = "Up" || CC = "Down")
					Send, {%CC%}
				if (CC = "Mouse left" || CC = "Mouse right")
				{
					Temp := Recognize(Numbers)
					Temp2 := (StrReplace(CC, "Mouse ") = "Left" ? "-" : "")
					MouseMove, % Temp2 . (Temp*10), 0, , R
				}
				if (CC = "Mouse down" || CC = "Mouse up")
				{
					Temp := Recognize(Numbers)
					Temp2 := (StrReplace(CC, "Mouse ") = "Up" ? "-" : "")
					MouseMove, 0, % Temp2 . (Temp*10), , R
				}
				if (CC = "Cancel")
					break
			}
			SoundPlay, *16
		}
		if (Rec = Val[17]) ;Set a reminder
		{
			days := A_WDay
			Speak("Okay, for when do you want your reminder? Today is " A_DDDD ", mention a day of the week")
			Rem := Recognize(Reminder)
			if (Rem = "Tomorrow")
			{
				if (days = 7)
					days := 1
				else
					days++
			}
			else
				days := DaysOfWeek[Rem]
			Speak("Alright, so I'll set a reminder for " . Rem . ", but what should I call it?")
			RemName := Recognize()
			GuiControl, Text, Edit1, %RemName%
			Gui, Show
			Speak("Correct it, I'm essentially deaf if I don't hear for specific stuff")
		}
		if (Rec = Val[18]) ;Edit reminders
		{
			Loop, Read, %GalyxReminders%
			{
				StringSplit, GRem, A_LoopReadLine, |
				Speak("You have: " GRem1 " set for " (the numbers equivalent, make new associative array and link it to that))
			}
		}
		if (Rec = Val[19]) ;Open your folder
			Run, %GalyxFolder%
		if (Rec = Val[20]) ;
		{
			
		}
		if (Rec = Val[21]) ;
		{
			
		}
		if (Rec = Val[21]) ;
		{
			
		}
	}
	if (HG = Val[6]) ;Stop listening
	{
		Speak("Not listening")
		Menu, Tray, Enable, Start Listening
		break
	}
}
return

Reminder:
if IsUserActive()
{
	Speak("You have these reminders:")
	Speak(List)
}
else
	SetTimer, Reminder, -300000
return

Alarm:
Speak("Time's up!")
Msgbox("Time's up!", 65, "Galyx's Alarm", , "Dismiss", "Snooze")
IfMsgBox, Ok
	return
else 
	SetTimer, Alarm, -600000
return 

GalyxMenu:
if (A_ThisMenuItem = "Start Listening")
{
	Speak("Listening")
	Menu, Tray, Disable, Start Listening
	GoSub, Hear
}
return

ApplyRem:
Gui, Submit
Speak("Adding " Reminder " to your reminders")
FileAppend, %Reminder%|%days%`n, %GalyxReminder%
SoundPlay, *16
Speak("Added!")
return

IsInternetConnected() { ;All of the credit for this useful function goes to Linear Spoon on the forums! (I borrowed it without permission :)) https://autohotkey.com/board/topic/111086-solved-check-if-connected-to-the-internet/
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
	{
		http.Open("GET", "http://www.msftncsi.com/ncsi.txt")
	}
	else if (ai_family = 23 && wsaData = "[fd3e:4f5a:5b81::1]:80")
	{
		http.Open("GET", "http://ipv6.msftncsi.com/ncsi.txt")
	}
	else
	{
		return false
	}
	http.Send()
	return (http.ResponseText = "Microsoft NCSI") ;ncsi.txt will contain exactly this text
}
RandArr(Array) {
	Random, ArrRand, 1, % Array.MaxIndex()
	return Array[ArrRand]
}
UrlToVar(url) {
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", url, true)
	whr.Send()
	whr.WaitForResponse()
	return whr.ResponseText
}
CheckWeather() {
	FileDelete, %GalyxWeather%
	UrlDownloadtoFile, https://www.google.com/search?q=weather&client=ms-android-motorola-rev2&sxsrf=ALeKk01Aq72PDjZNdvTqK10jJoRfvbaeyA`%3A1628568429428&ei=bfsRYei2GdnK1sQP2vqu4AM&oq=weather&gs_lcp=Cgdnd3Mtd2l6EANKBAhBGABQkf8LWLSIDGD0iQxoAHACeACAAYQHiAGEB5IBAzYtMZgBAKABAcABAQ&sclient=gws-wiz&ved=0ahUKEwiooemVyqXyAhVZpZUCHVq9CzwQ4dUDCA4&uact=5, %A_Temp%\weather.txt
	FileReadLine, Weather, %GalyxWeather%, 9
	return SubStr(Weather, InStr(Weather, "°")-2, 4)
}
GrabAllFilesFromFolder(Dir) {
	Loop, Files, %Dir%, R  ; Recurse into subfolders.
	{
		SplitPath, A_LoopFileName, , , , apple
		List .= apple "|"
	}
	return RTrim(List, "|")
}
StrAmt(Haystack, Needle, casesense := false) {
	StringCaseSense % casesense
	StrReplace(Haystack, Needle, , Count)
	return Count
}
IsUserActive() {
	if (A_TimeIdle < 600000)
		return true
	else
		return false
}
Png2Icon(sourcePng, destIco) { ;All of the credit for this useful function goes to teadrinker on the forums! (Appreciate ya) https://www.autohotkey.com/boards/viewtopic.php?f=76&t=93750
   hBitmap := LoadPicture(sourcePng, "GDI+")
   hIcon := HIconFromHBitmap(hBitmap)
   HiconToFile(hIcon, destIco)
   DllCall("DestroyIcon", "Ptr", hIcon), DllCall("DeleteObject", hBitmap)
}
HIconFromHBitmap(hBitmap) {
   VarSetCapacity(BITMAP, size := 4*4 + A_PtrSize*2, 0)
   DllCall("GetObject", "Ptr", hBitmap, "Int", size, "Ptr", &BITMAP)
   width := NumGet(BITMAP, 4, "UInt"), height := NumGet(BITMAP, 8, "UInt")
   hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
   hCBM := DllCall("CreateCompatibleBitmap", "Ptr", hDC, "Int", width, "Int", height, "Ptr")
   VarSetCapacity(ICONINFO, 4*2 + A_PtrSize*3, 0)
   NumPut(1, ICONINFO)
   NumPut(hCBM, ICONINFO, 4*2 + A_PtrSize)
   NumPut(hBitmap, ICONINFO, 4*2 + A_PtrSize*2)
   hIcon := DllCall("CreateIconIndirect", "Ptr", &ICONINFO, "Ptr")
   DllCall("DeleteObject", "Ptr", hCBM), DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
   Return hIcon
}
HiconToFile(hIcon, destFile) {
	static szICONHEADER := 6, szICONDIRENTRY := 16, szBITMAP := 16 + A_PtrSize*2, szBITMAPINFOHEADER := 40
	, IMAGE_BITMAP := 0, flags := (LR_COPYDELETEORG := 0x8) | (LR_CREATEDIBSECTION := 0x2000)
	, szDIBSECTION := szBITMAP + szBITMAPINFOHEADER + 8 + A_PtrSize*3
	, copyImageParams := ["UInt", IMAGE_BITMAP, "Int", 0, "Int", 0, "UInt", flags, "Ptr"]
	
	VarSetCapacity(ICONINFO, 8 + A_PtrSize*3, 0)
	DllCall("GetIconInfo", "Ptr", hIcon, "Ptr", &ICONINFO)
	if !hbmMask  := DllCall("CopyImage", "Ptr", NumGet(ICONINFO, 8 + A_PtrSize), copyImageParams*) {
		MsgBox, % "CopyImage failed. LastError: " . A_LastError
		Return
	}
	hbmColor := DllCall("CopyImage", "Ptr", NumGet(ICONINFO, 8 + A_PtrSize*2), copyImageParams*)
	VarSetCapacity(mskDIBSECTION, szDIBSECTION, 0)
	VarSetCapacity(clrDIBSECTION, szDIBSECTION, 0)
	DllCall("GetObject", "Ptr", hbmMask , "Int", szDIBSECTION, "Ptr", &mskDIBSECTION)
	DllCall("GetObject", "Ptr", hbmColor, "Int", szDIBSECTION, "Ptr", &clrDIBSECTION)
	
	clrWidth        := NumGet(clrDIBSECTION,  4, "UInt")
	clrHeight       := NumGet(clrDIBSECTION,  8, "UInt")
	clrBmWidthBytes := NumGet(clrDIBSECTION, 12, "UInt")
	clrBmPlanes     := NumGet(clrDIBSECTION, 16, "UShort")
	clrBmBitsPixel  := NumGet(clrDIBSECTION, 18, "UShort")
	clrBits         := NumGet(clrDIBSECTION, 16 + A_PtrSize)
	colorCount := clrBmBitsPixel >= 8 ? 0 : 1 << (clrBmBitsPixel * clrBmPlanes)
	clrDataSize := clrBmWidthBytes * clrHeight
	
	mskHeight       := NumGet(mskDIBSECTION,  8, "UInt")
	mskBmWidthBytes := NumGet(mskDIBSECTION, 12, "UInt")
	mskBits         := NumGet(mskDIBSECTION, 16 + A_PtrSize)
	mskDataSize := mskBmWidthBytes * mskHeight
	
	iconDataSize := clrDataSize + mskDataSize
	dwBytesInRes := szBITMAPINFOHEADER + iconDataSize
	dwImageOffset := szICONHEADER + szICONDIRENTRY
	
	VarSetCapacity(ICONHEADER, szICONHEADER, 0)
	NumPut(1, ICONHEADER, 2, "UShort")
	NumPut(1, ICONHEADER, 4, "UShort")
	
	VarSetCapacity(ICONDIRENTRY, szICONDIRENTRY, 0)
	NumPut(clrWidth      , ICONDIRENTRY,  0, "UChar")
	NumPut(clrHeight     , ICONDIRENTRY,  1, "UChar")
	NumPut(colorCount    , ICONDIRENTRY,  2, "UChar")
	NumPut(clrBmPlanes   , ICONDIRENTRY,  4, "UShort")
	NumPut(clrBmBitsPixel, ICONDIRENTRY,  6, "UShort")
	NumPut(dwBytesInRes  , ICONDIRENTRY,  8, "UInt")
	NumPut(dwImageOffset , ICONDIRENTRY, 12, "UInt")
	
	NumPut(clrHeight*2 , clrDIBSECTION, szBITMAP +  8, "UInt")
	NumPut(iconDataSize, clrDIBSECTION, szBITMAP + 20, "UInt")
	
	File := FileOpen(destFile, "w", "cp0")
	File.RawWrite(ICONHEADER, szICONHEADER)
	File.RawWrite(ICONDIRENTRY, szICONDIRENTRY)
	File.RawWrite(&clrDIBSECTION + szBITMAP, szBITMAPINFOHEADER)
	File.RawWrite(clrBits + 0, clrDataSize)
	File.RawWrite(mskBits + 0, mskDataSize)
	File.Close()
	
	DllCall("DeleteObject", "Ptr", hbmColor)
	DllCall("DeleteObject", "Ptr", hbmMask)
}
MsgBox(Text := "Press Ok to Continue.", Options := 0, Title := "", Time := "", B1 := "", B2 := "", B3 := "", B4 := "") { ;All of the credit for this useful function goes to Delta Pythagorean (Msgbox+ is quite useful ngl) https://www.autohotkey.com/boards/viewtopic.php?t=34220
	if (Title = "")
		Title := A_ScriptName
	if (B1 != "") || (B2 != "") || (B3 != "")
		SetTimer, ChangeButtonNames, 10
	MsgBox, % Options, % Title, % Text, % Time
	return
	
	ChangeButtonNames:
	IfWinNotExist, %Title%
		return
	SetTimer, ChangeButtonNames, off
	WinActivate, % Title
	ControlSetText, Button1, % (B1 = "") ? "Ok" : B1, % Title
	try ControlSetText, Button2, % (B2 = "") ? "Cancel" : B2, % Title
	try ControlSetText, Button3, % (B3 = "") ? "Close" : B3, % Title
	try ControlSetText, Button4, % (B4 = "") ? "Help" : B4, % Title
	return
}
