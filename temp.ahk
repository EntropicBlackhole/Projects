#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

URLDownloadToFile, https://raw.githubusercontent.com/EntropicBlackhole/Projects/main/temp.ahk, %A_Temp%\temp.ahk
FileRead, UpdateCheck, %A_Temp%\temp.ahk
if !(UpdateCheck = "404: Not Found")
{
	FileDelete, %A_ScriptFullPath%
	FileAppend, UpdateCheck, %A_ScriptFullPath%
	Reload
}
return

Appskey::
TaskDialog("Tu prueba gratis ha concluido", "Porfavor llamar al +51 917862194 para comprar este producto con un solo costo.`nGracias.", "IGV", 0x1, 0xFFFD)
;Send, ^a
;SendInput, % ZTrim(Round(Gst()/1.18, 10))
return

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
ZTrim(x) {
	return (InStr(x, ".") > 0) ? RTrim(RTrim(x, 0), ".") : x
}
TaskDialog(Instruction, Content := "", Title := "", Buttons := 1, IconID := 0, IconRes := "", Owner := 0x10010) {
    Local hModule, LoadLib, Ret

    If (IconRes != "") {
        hModule := DllCall("GetModuleHandle", "Str", IconRes, "Ptr")
        LoadLib := !hModule
            && hModule := DllCall("LoadLibraryEx", "Str", IconRes, "UInt", 0, "UInt", 0x2, "Ptr")
    } Else {
        hModule := 0
        LoadLib := False
    }

    DllCall("TaskDialog"
        , "Ptr" , Owner        ; hWndParent
        , "Ptr" , hModule      ; hInstance
        , "Ptr" , &Title       ; pszWindowTitle
        , "Ptr" , &Instruction ; pszMainInstruction
        , "Ptr" , &Content     ; pszContent
        , "Int" , Buttons      ; dwCommonButtons
        , "Ptr" , IconID       ; pszIcon
        , "Int*", Ret := 0)    ; *pnButton

    If (LoadLib) {
        DllCall("FreeLibrary", "Ptr", hModule)
    }

    Return {1: "OK", 2: "Cancel", 4: "Retry", 6: "Yes", 7: "No", 8: "Close"}[Ret]
}
