GCD(x, y) {
    Return y=0 ? Abs(x) : GCD(y,mod(x,y))
}
LCM(x, y) {
    Return Floor(x*y/GCD(x,y))
}
IsPrime(n,k=2) {
    d := k+(k<7 ? 1+(k>2) : SubStr("6-----4---2-4---2-4---6-----2",Mod(k,30),1)) 
    Return n < 3 ? n>1 : Mod(n,k) ? (d*d <= n ? IsPrime(n,d) : 1) : 0 
}
Fac(x) {
    var := 1
    Loop, %x%
        var *= A_Index
    return var
}
Per(x, y) {
    Per :=(x/100)*y
    return Per
}
TMet(x, y, d) {
    return ZTrim(d/(x+y))
}
TRch(x, y, d) {
    return ZTrim(d/(x>y ? x-y : y-x))
}
Dis(v0:=0, vf:=10, t:=10) {
    return ((v0+vf)/2)*t
}
Area(shape, x) {
    if (shape = 1)
        return 3.1415926535*(x**2)
    else
        return ((x/(2*Tan((180/shape)*0.01745329252)))*(shape*x))/2
}
CheckItemSelected() {
    global CheckItem
    TotalSelectedItems := % LV_GetCount("S")
    CheckItem := LV_GetNext()
    if (TotalSelectedItems >= 1)
        return true
    else
        return false
}
ZTrim(x) {
    return (InStr(x, ".") > 0) ? RTrim(RTrim(x, 0), ".") : x
}
StrAmt(Haystack, Needle, casesense := false) {
    StringCaseSense % casesense
    StrReplace(Haystack, Needle, , Count)
    return Count
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
Dice() {
    Random, dice, 1, 6
    return dice
}
Avg(numbers*) {
    for index,number in numbers
        sum += number
    return sum/numbers.MaxIndex()
}
AvgArr(Array) {
    Loop, % Array.MaxIndex()
        sum += Array[A_Index]
    return sum/Array.MaxIndex()
}
Rand(x:=-2147483648, y:=2147483647) {
    Random, OutputVar, %x%, %y%
    return OutputVar
}
RandArr(Array) {
    Random, ArrRand, 1, % Array.MaxIndex()
    return Array[ArrRand]
}
RandChance(Per) {
    Random, OutputVar, 1, 100
    if (OutputVar <= Per)
        return true
    else
        return false
}
RandPassword(Amount := 8) {
    Alphabet := ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    Numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
    Symbols := ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"]
    Choose := ["Alphabet", "Numbers", "Symbols"]
    Loop, %Amount%
    {
        Random, ArrRand, 1, % Choose.MaxIndex()
        Thing := Choose[ArrRand]
        Random, ArrRand, 1, % %Thing%.MaxIndex()
        Send, % %Thing%[ArrRand]
    }
}
Caesar(string, n, decode := false) {
    Loop Parse, string
    {
        If (Asc(A_LoopField) >= 65 and Asc(A_LoopField) <= 90)
            out .= Chr(Mod(Asc(A_LoopField)-(decode = true ? 97+n : 97-n),26)+65)
        Else If (Asc(A_LoopField) >= 97 and Asc(A_LoopField) <= 122)
            out .= Chr(Mod(Asc(A_LoopField)-(decode = true ? 97+n : 97-n),26)+97)
        Else out .= A_LoopField
    }
    return out
}
LCSQ(a, b) {
    while pos := RegExMatch(a "`n" b, "(.+)(?=.*\R.*\1)", m, pos?pos+StrLen(m):1)
        res := StrLen(res) > StrLen(m1) ? res : m1
    return res
}
LCST(a, b) {
    Loop % StrLen(a)+2  {
        i := A_Index-1
        Loop % StrLen(b)+2
            j := A_Index-1, len%i%_%j% := 0
    }
    Loop Parse, a
     {
        i := A_Index, i1 := i+1, x := A_LoopField
        Loop Parse, b
         {
            j := A_Index, j1 := j+1, y := A_LoopField
            len%i1%_%j1% := x=y ? len%i%_%j% + 1
            : (u:=len%i1%_%j%) > (v:=len%i%_%j1%) ? u : v
        }
    }
    x := StrLen(a)+1, y := StrLen(b)+1
    While x*y  {
        x1 := x-1, y1 := y-1
        If (len%x%_%y% = len%x1%_%y%)
            x := x1
        Else If  (len%x%_%y% = len%x%_%y1%)
            y := y1
        Else
            x := x1, y := y1, t := SubStr(a,x,1) t
    }
    Return t
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
ToolTipFont(Options := "", Name := "", hwnd := "") {
    static hfont := 0
    if (hwnd = "")
        hfont := Options="Default" ? 0 : _TTG("Font", Options, Name), _TTHook()
    else
        DllCall("SendMessage", "ptr", hwnd, "uint", 0x30, "ptr", hfont, "ptr", 0)
}
ToolTipColor(Background := "", Text := "", hwnd := "") {
    static bc := "", tc := ""
    if (hwnd = "") {
        if (Background != "")
            bc := Background="Default" ? "" : _TTG("Color", Background)
        if (Text != "")
            tc := Text="Default" ? "" : _TTG("Color", Text)
        _TTHook()
    }
    else {
        VarSetCapacity(empty, 2, 0)
        DllCall("UxTheme.dll\SetWindowTheme", "ptr", hwnd, "ptr", 0
            , "ptr", (bc != "" && tc != "") ? &empty : 0)
        if (bc != "")
            DllCall("SendMessage", "ptr", hwnd, "uint", 1043, "ptr", bc, "ptr", 0)
        if (tc != "")
            DllCall("SendMessage", "ptr", hwnd, "uint", 1044, "ptr", tc, "ptr", 0)
    }
}
_TTHook() {
    static hook := 0
    if !hook
        hook := DllCall("SetWindowsHookExW", "int", 4
            , "ptr", RegisterCallback("_TTWndProc"), "ptr", 0
            , "uint", DllCall("GetCurrentThreadId"), "ptr")
}
_TTWndProc(nCode, _wp, _lp) {
    Critical 999
   ;lParam  := NumGet(_lp+0*A_PtrSize)
   ;wParam  := NumGet(_lp+1*A_PtrSize)
    uMsg    := NumGet(_lp+2*A_PtrSize, "uint")
    hwnd    := NumGet(_lp+3*A_PtrSize)
    if (nCode >= 0 && (uMsg = 1081 || uMsg = 1036)) {
        _hack_ = ahk_id %hwnd%
        WinGetClass wclass, %_hack_%
        if (wclass = "tooltips_class32") {
            ToolTipColor(,, hwnd)
            ToolTipFont(,, hwnd)
        }
    }
    return DllCall("CallNextHookEx", "ptr", 0, "int", nCode, "ptr", _wp, "ptr", _lp, "ptr")
}
_TTG(Cmd, Arg1, Arg2 := "") {
    static htext := 0, hgui := 0
    if !htext {
        Gui _TTG: Add, Text, +hwndhtext
        Gui _TTG: +hwndhgui +0x40000000
    }
    Gui _TTG: %Cmd%, %Arg1%, %Arg2%
    if (Cmd = "Font") {
        GuiControl _TTG: Font, %htext%
        SendMessage 0x31, 0, 0,, ahk_id %htext%
        return ErrorLevel
    }
    if (Cmd = "Color") {
        hdc := DllCall("GetDC", "ptr", htext, "ptr")
        SendMessage 0x138, hdc, htext,, ahk_id %hgui%
        clr := DllCall("GetBkColor", "ptr", hdc, "uint")
        DllCall("ReleaseDC", "ptr", htext, "ptr", hdc)
        return clr
    }
}
BraceExp(string, del:="`n") {
    Loop, Parse, string
        if (A_LoopField = "{")
            break
        else
        substring .= A_LoopField
    substr := SubStr(string, InStr(string, "{")+1, InStr(string, "}")-InStr(string, "{")-1)
    Loop, Parse, substr, `,
        toreturn .= substring . A_LoopField . del
    return toreturn
}
CbAutoComplete() {
    If ((GetKeyState("Delete", "P")) || (GetKeyState("Backspace", "P")))
        Return
    GuiControlGet, lHwnd, Hwnd, %A_GuiControl%
    SendMessage, 0x0140, 0, 0,, ahk_id %lHwnd%
    MakeShort(ErrorLevel, Start, End)
    GuiControlGet, CurContent,, %lHwnd%
    GuiControl, ChooseString, %A_GuiControl%, %CurContent%
    If (ErrorLevel) {
        ControlSetText,, %CurContent%, ahk_id %lHwnd%
        PostMessage, 0x0142, 0, MakeLong(Start, End),, ahk_id %lHwnd%
        Return
    }
    GuiControlGet, CurContent,, %lHwnd%
    PostMessage, 0x0142, 0, MakeLong(Start, StrLen(CurContent)),, ahk_id %lHwnd%
}
MakeLong(LoWord, HiWord) {
    Return, (HiWord << 16) | (LoWord & 0xffff)
}
MakeShort(Long, ByRef LoWord, ByRef HiWord) {
    LoWord := Long & 0xffff, HiWord := Long >> 16
}
ChooseColor( Color=0x0, hWnd=0x0, Flags=0x2 ) {
    VarSetCapacity(CC,36+64,0), NumPut(36,CC), NumPut(hWnd,CC,4), NumPut(Color,CC,12)
    NumPut(&CC+36,CC,16), NumPut(Flags,CC,20), DllCall( "comdlg32\ChooseColorA", Str,CC ) 
    Hex:="123456789ABCDEF0",   RGB:=&CC+11 
    Loop 3  
        HexColorCode .=  SubStr(Hex, (*++RGB >> 4), 1) . SubStr(Hex, (*RGB & 15), 1) 
    Return HexColorCode  
}
HexDec(DX) {
    DH := InStr(DX, "0x") > 0 ? "D" : "H"
    SetFormat Integer, %DH%
    Return DX + 0
}
UniversalVar(variable, value := "") {
    if (value = "")
        IniRead, univar, C:\Program Files\AutoHotkey\Custom.ini, UniversalVariables, %variable%
    else
        IniWrite, %value%, C:\Program Files\AutoHotkey\Custom.ini, UniversalVariables, %variable%
    return univar
}
ConvertBase(InputBase, OutputBase, number) {
    static u := A_IsUnicode ? "_wcstoui64" : "_strtoui64"
    static v := A_IsUnicode ? "_i64tow"    : "_i64toa"
    VarSetCapacity(s, 65, 0)
    value := DllCall("msvcrt.dll\" u, "Str", number, "UInt", 0, "UInt", InputBase, "CDECL Int64")
    DllCall("msvcrt.dll\" v, "Int64", value, "Str", s, "UInt", OutputBase, "CDECL")
    return s
}
NumberToBinary(InputNumber) {
    While, InputNumber
        Result := (InputNumber & 1) . Result, InputNumber >>= 1
    Return, Result
}
MorseBeep(passedString) {
    StringLower, passedString, passedString
    Loop, Parse, passedString
        morse .= A_LoopField = " " ?  "     " 
        : A_LoopField = "a" ? ".- " 
        : A_LoopField = "b" ? "-... " 
        : A_LoopField = "c" ? "-.-. " 
        : A_LoopField = "d" ? "-.. " 
        : A_LoopField = "e" ? ". " 
        : A_LoopField = "f" ? "..-. " 
        : A_LoopField = "g" ? "--. " 
        : A_LoopField = "h" ? ".... " 
        : A_LoopField = "i" ? ".. " 
        : A_LoopField = "j" ? ".--- " 
        : A_LoopField = "k" ? "-.- " 
        : A_LoopField = "l" ? ".-.. " 
        : A_LoopField = "m" ? "-- " 
        : A_LoopField = "n" ? "-. " 
        : A_LoopField = "o" ? "--- " 
        : A_LoopField = "p" ? ".--. " 
        : A_LoopField = "q" ? "--.- " 
        : A_LoopField = "r" ? ".-. " 
        : A_LoopField = "s" ? "... " 
        : A_LoopField = "t" ? "- " 
        : A_LoopField = "u" ? "..- " 
        : A_LoopField = "v" ? "...- " 
        : A_LoopField = "w" ? ".-- " 
        : A_LoopField = "x" ? "-..- " 
        : A_LoopField = "y" ? "-.-- " 
        : A_LoopField = "z" ? "--.. " 
        : A_LoopField = "!" ? "---. " 
        : A_LoopField = "\" ? ".-..-. " 
        : A_LoopField = "$" ? "...-..- " 
        : A_LoopField = "'" ? ".----. " 
        : A_LoopField = "(" ? "-.--. " 
        : A_LoopField = ")" ? "-.--.- " 
        : A_LoopField = "+" ? ".-.-. " 
        : A_LoopField = "," ? "--..-- " 
        : A_LoopField = "-" ? "-....- " 
        : A_LoopField = "." ? ".-.-.- " 
        : A_LoopField = "/" ? "-..-. " 
        : A_LoopField = "0" ? "----- " 
        : A_LoopField = "1" ? ".---- " 
        : A_LoopField = "2" ? "..--- " 
        : A_LoopField = "3" ? "...-- " 
        : A_LoopField = "4" ? "....- " 
        : A_LoopField = "5" ? "..... " 
        : A_LoopField = "6" ? "-.... " 
        : A_LoopField = "7" ? "--... " 
        : A_LoopField = "8" ? "---.. " 
        : A_LoopField = "9" ? "----. " 
        : A_LoopField = ":" ? "---... " 
        : A_LoopField = ";" ? "-.-.-. " 
        : A_LoopField = "=" ? "-...- " 
        : A_LoopField = "?" ? "..--.. " 
        : A_LoopField = "@" ? ".--.-. " 
        : A_LoopField = "[" ? "-.--. " 
        : A_LoopField = "]" ? "-.--.- " 
        : A_LoopField = "_" ? "..--.- " 
        : "ERROR"
    Loop, Parse, morse
    {
        morsebeep := 120
        if (A_LoopField = ".")
            SoundBeep, 10*morsebeep, morsebeep
        If (A_LoopField = "-")
            SoundBeep, 10*morsebeep, 3*morsebeep
        If (A_LoopField = " ")
            Sleep, morsebeep
    }
    return morse
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
SendInstant(text) { 
    clipbackup := clipboard
    clipboard := text
    Send, ^v
    clipboard := clipbackup
}
MsgBox(Text := "Press Ok to Continue.", Options := 0, Title := "", Time := "", B1 := "", B2 := "", B3 := "", B4 := "") {
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
IsEven(number) {
    if (Mod(number, 2) = 0)
        return true
    else
        return false
}
CueBanner(Hwnd, Text := "Search") {
    SendMessage 0x1501, 0, &Text,, ahk_id %Hwnd%
}
UrlToVar(url) {
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", url, true)
    whr.Send()
    whr.WaitForResponse()
    return whr.ResponseText
}
SetWallpaper(BMPpath) {
    SPI_SETDESKWALLPAPER := 20
    SPIF_SENDWININICHANGE := 2  
    Return DllCall("SystemParametersInfo", UINT, SPI_SETDESKWALLPAPER, UINT, uiParam, STR, BMPpath, UINT, SPIF_SENDWININICHANGE)
}
Alarm(24h, label) {
    alarmhour := 24h*3600
    realhour := A_Hour*3600
    realminute := A_Min*60
    alarm := alarmhour-(realhour+realminute)
    Sleep, % alarm*1000
    Gosub, %label%
}
TV_GetTextAll(TreeViewName := "SysTreeView321") {
    Gui, TreeView, %TreeViewName%
    ItemID := 0  ; Causes the loop's first iteration to start the search at the top of the tree.
    Loop
    {
        ItemID := TV_GetNext(ItemID, "Full")  ; Replace "Full" with "Checked" to find all checkmarked items.
        if not ItemID  ; No more items in tree.
            break
        if not TV_GetParent(ItemID)  ; Checks if the item is a parent, if so it stores the text in %ParentText% for later (only works with the top level however).
            TV_GetText(ParentText, ItemID)
        else  ; Checks if the item is a child, if so it stores the text in %ChildText% for later.
        {
            TV_GetText(Child, ItemID)
            ChildText .= Child "|"
            TempItemID := TV_GetNext(ItemID, "Full")
            if not TV_GetParent(TempItemID)
                List .= ParentText "="ChildText "`n"
        }
    }
    return RTrim(List, "`n" "|")
}
TV_AddFile(FileName) {
    Loop, Read, %FileName%
    {
        StringSplit, Items, A_LoopReadLine, =
        Parent := TV_Add(Items1, , "Expand")
        Loop, Parse, Items2, |
            TV_Add(A_LoopField, Parent)
    }
    return ErrorLevel
}
TV_MakeTree(List, Del := "`n") {
    ID0 := 0
    Loop, Parse, List, %Del%
    {
        if InStr(A_LoopField, "TV_Add")
        {
            StringSplit, TVAdd, A_LoopField, =
            AssignLevel := StrReplace(TVAdd1, " :")
            TV := SubStrInBtw(TVAdd2, "(", ")")
            Loop, Parse, TV, CSV
            {
                if (A_Index = 1)
                    Name := A_LoopField
                if (A_Index = 2)
                    Level := StrReplace(A_LoopField, " ")
                if (A_Index = 3)
                    Options := A_LoopField
            }
            Options .= " Expand"
            %AssignLevel% := TV_Add(Name, %Level%, Options)
        }
    }
}
TV_GetTree(ItemID := 0, Level := 0) { ; uses the default TreeView of the default Gui ;just me THANK YOU SO MUCH *hug*
   Text := ""
   If (ItemID = 0) {
      ItemID := TV_GetNext()
      Text := "ID0 := 0`r`n"
   }
   While (ItemID){
      TV_GetText(ItemText, ItemID)
      Text .= "ID" . (Level + 1) . " := TV_Add(""" . ItemText . """, ID" . Level . ")`r`n"
      If ChildID := TV_GetChild(ItemID)
         Text .= TV_GetTree(ChildID, Level + 1)
      ItemID := TV_GetNext(ItemID)
   }
   Return (Level = 0 ? RTrim(Text, "`r`n") : Text)
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
GuiControls(Command := "", Value := "", ControlIDs*) {
    for Index,Control in ControlIDs
        GuiControl, %Command%, %Control%, %Value%
}
Join(Delimiter, Items*) {
    for Index,Item in Items
        Output .= Item . Delimiter
    return RTrim(Output, Delimiter)
}
SubStrInBtw(String, StartingChar, EndingChar, OccurStartChar := 1, OccurEndChar := 1) {
    StartingPos := InStr(String, StartingChar, , , OccurStartChar)+1
    Length := InStr(String, EndingChar, , , OccurEndChar)-InStr(String, StartingChar, , , OccurStartChar)-1
    return SubStr(String, StartingPos, Length)
}
Levenshtein(s, t) {
    If s =
        return StrLen(t)
    If t =
        return strLen(s)
    If SubStr(s, 1, 1) = SubStr(t, 1, 1)
        return levenshtein(SubStr(s, 2), SubStr(t, 2))
    a := Levenshtein(SubStr(s, 2), SubStr(t, 2))
    b := Levenshtein(s,            SubStr(t, 2))
    c := Levenshtein(SubStr(s, 2), t           )
    If (a > b)
        a := b
    if (a > c)
        a := c
    return a + 1
}
RandomBezier( X0, Y0, Xf, Yf, O="" ) { 
    Time := RegExMatch(O,"i)T(\d+)",M)&&(M1>0)? M1: 200
    RO := InStr(O,"RO",0) , RD := InStr(O,"RD",0)
    N:=!RegExMatch(O,"i)P(\d+)(-(\d+))?",M)||(M1<2)? 2: (M1>19)? 19: M1
    If ((M:=(M3!="")? ((M3<2)? 2: ((M3>19)? 19: M3)): ((M1=="")? 5: ""))!="")
        Random, N, %N%, %M%
    OfT:=RegExMatch(O,"i)OT(-?\d+)",M)? M1: 100, OfB:=RegExMatch(O,"i)OB(-?\d+)",M)? M1: 100
    OfL:=RegExMatch(O,"i)OL(-?\d+)",M)? M1: 100, OfR:=RegExMatch(O,"i)OR(-?\d+)",M)? M1: 100
    MouseGetPos, XM, YM
    If ( RO )
        X0 += XM, Y0 += YM
    If ( RD )
        Xf += XM, Yf += YM
    If ( X0 < Xf )
        sX := X0-OfL, bX := Xf+OfR
    Else
        sX := Xf-OfL, bX := X0+OfR
    If ( Y0 < Yf )
        sY := Y0-OfT, bY := Yf+OfB
    Else
        sY := Yf-OfT, bY := Y0+OfB
    Loop, % (--N)-1 {
        Random, X%A_Index%, %sX%, %bX%
        Random, Y%A_Index%, %sY%, %bY%
    }
    X%N% := Xf, Y%N% := Yf, E := ( I := A_TickCount ) + Time
    While ( A_TickCount < E ) {
        U := 1 - (T := (A_TickCount-I)/Time)
        Loop, % N + 1 + (X := Y := 0) {
            Loop, % Idx := A_Index - (F1 := F2 := F3 := 1)
                F2 *= A_Index, F1 *= A_Index
            Loop, % D := N-Idx
                F3 *= A_Index, F1 *= A_Index+Idx
            M:=(F1/(F2*F3))*((T+0.000001)**Idx)*((U-0.000001)**D), X+=M*X%Idx%, Y+=M*Y%Idx%
        }
        MouseMove, %X%, %Y%, 0
        Sleep, 1
    }
    MouseMove, X%N%, Y%N%, 0
    Return N+1
    /*
    # "Tx" (where x is a positive number)
    > The time of the mouse movement, in miliseconds
    > Defaults to 200 if not present
    # "RO"
    > Consider the origin coordinates (X0,Y0) as relative
    > Defaults to "not relative" if not present
    # "RD"
    > Consider the destination coordinates (Xf,Yf) as relative
    > Defaults to "not relative" if not present
    # "Px" or "Py-z" (where x, y and z are positive numbers)
    > "Px" uses exactly 'x' control points
    > "Py-z" uses a random number of points (from 'y' to 'z', inclusive)
    > Specifying 1 anywhere will be replaced by 2 instead
    > Specifying a number greater than 19 anywhere will be replaced by 19
    > Defaults to "P2-5"
    # "OTx" (where x is a number) means Offset Top
    # "OBx" (where x is a number) means Offset Bottom
    # "OLx" (where x is a number) means Offset Left
    # "ORx" (where x is a number) means Offset Right
    > These offsets, specified in pixels, are actually boundaries that
     apply to the [X0,Y0,Xf,Yf] rectangle, making it wider or narrower
    > It is possible to use multiple offsets at the same time
    > When not specified, an offset defaults to 100
     - This means that, if none are specified, the random Bézier control
    points will be generated within a box that is wider by 100 pixels
    in all directions, and the trajectory will never go beyond that
    */
}
HailStone(n) {
    List := n
    while (n > 1)
        List .= "," n := (Mod(n, 2) ? (n*3)+1 : n//2)
    return List
}
Collatz(n) {
    while (n > 1)
        {
            count++
            n := !(Mod(n, 2)) ? n//2 : (n*3)+1
        }
    return count+1
}
