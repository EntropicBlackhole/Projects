;Calculator v1.0: initial release
;Calculator v1.1.1: operations like 1+1.5 would give 2.5000000 with all the 0's, (fixed)
;Calculator v1.1.2: bug with division where if 20/6 was put 3 would come out, rounded (fixed)
;Calculator v1.2: taken out the "Back" button used to eliminate the last digit, backspace can also do this, in replacement, an UpDown system was added for rounding, place in how many decimals you'd like to have e.g: place 4 in the up down edit thing and the answer will have 4 decimal spaces if given the need for decimals
;Calculator v1.2.1: replaced the "Exit" button with "n! (factorial)" as no need for use of "Exit" when you can close the window, several bug fixes were also fixed like Power, Square Root and Divide not working correctly and giving "0" as an output no matter the input (fixed), "C" button might be removed due to being unused, but I have no ideas with what to replace it
;Calculator v1.2.2: replaced the "C" button with two other buttons, say hello to sort and sort reverse! Insert a set of numbers in this manner: "25,635,53" (without spaces at all) and click on either of the new sort buttons, it automatically sorts it numerically with the tiny + button, and in reverse with the tiny - one, so clicking the tiny + outputs 25,53,635, while the tiny - outputs 635,53,25
;Calculator v1.2.3: huge bug that didn't let you even run the script, now fixed, and another bug where after multiplying it wouldn't let you subtract whole integers, also fixed, was just a variable typo
;Calculator v1.2.4: now after pressing any button or enter, it moves the focus directly to the end, this way as u/SpiritSeal had mentioned, you can now do many operations without having to click again the edit control
;Calculator v1.3: huge update!! Replaced form of operating, now you can do 3+4+1 and get 8, before you could only do one operation (3+4), more would display a 0 (keep in mind you still cannot do 4+3-1, as it would display 0 not 6), negatives are now supported, 5+-1 would be 4, shorter script = less kb, the result is automatically copied to the clipboard, ctrl + backspace is supported, before it would display a box symbol, replaced -> with IsPr, just put in a number that you wanna find out if its prime or not, it will say yes or no depending on if that number is prime or not, IsPrime from RosettaCode (https rosettacode.org /wiki/Primality_by_trial_division#AutoHotkey),  Broken Link for safety factorial was fixed, and now uses a function that I made, ZTrim() will just trim all 0 and the decimal point, because when dividing, you can either floor it or divide normally, but when normal, it appears like 4.00000000, I could use SetFormat yes, but several problems with it, like when you do want decimals what do you do, so I created Z(ero)Trim(), and one last thing, the ctrl backspace thing, yeah it works on all ahk gui's with this code, not just the calculator, but if you only want it for the calculator just replace ahk_class AutoHotkeyGUI with Calculator v(current version)
;Calculator v1.3.1: Posted to the forums and minor text fixes
;Calculator v1.4: yup jumping directly to 1.4 because huge change again lmao, so new form of operating with a pratt parser and HUGE THANKS TO u/CloakerSmoker I LOVE YOU XD, added statusbar displaying your last calculation and for displaying your result without pressing enter before, added menu items to the calculator which are Type (yes i'll add more calculator types meaning i'll start using pastebin instead of posting directly to reddit) Clear which uh, clears the edit? and History which is still in development (I actually don't know how to store at least 10 previous calculations, but then have them overwrite in order, might be using an array), also I have a question, if I do 30+5-5+3+3+3+3+3+3+3+3+3+3, it displays 0, as if it was doing 30+5-(5+3+3+3+3+3+3+3+3+3+3), can this be fixed? thanks, minor text fixes, and name change inspired by u/neunmalelf, thanks
;Calculator v1.4.1: minor bug and text fixes, and History is now available, also uploaded to GitHub
name := "MicroCalculator v1.4a"
Gui, mCalc:New,+ToolWindow                       ;Allow movable window
Gui, Add, Edit, x12 y9 w120 h70 vEdit hwndHandle gEdit,
Gui, Add, Button, x12 y79 w30 h20 gKey, n!
Gui, Add, CheckBox, x42 y79 w30 h20 gAOT, #
Gui, Add, Button, x102 y79 w30 h20 gIsPrime, IsPr
ba:=["`%","x^y","√","/","7","8","9","x","4","5","6","-","1","2","3","+","","0","."]
Loop 19{                                         ;Create a 2D button array
  If (A_Index=17)
    Continue
  bx:=12+(Mod(A_Index-1,4)*30),by:=99+(Floor((A_Index-1)/4)*20)
  Gui, Add, Button, x%bx% y%by% w30 h20 gKey, % ba[A_Index]
}
Gui, Add, Button, x102 y179 w30 h20 gEqual, =
Gui, Add, Button, x12 y179 w15 h20 gKey, <
Gui, Add, Button, x27 y179 w15 h20 gKey, >
Gui, Add, Edit, x72 y79 w30 h20 vRound,
Gui, Add, UpDown, x82 y79 w20 h20 gEdit, 2
Gui, Add, StatusBar, gSB vSB, Welcome!
SB_SetParts(73)
Menu, Menu, Add, CType
Menu, Menu, Add, Clear
Loop 10                                          ;History on a Loop
	Menu, History, Add, % A_Index, History
Menu, Menu, Add, History, :History
Gui, Menu, Menu
return

F3::Gui, mCalc:Show, h222 w146, %name%

Key:                                             ;Combined all labels into one
Gui, Submit, NoHide
switch A_GuiControl{
  case "n!": numsym := Edit "!"
  case "x^y": numsym := Edit "^"
  case "x": numsym := Edit "*"
  case "√": numsym := "√" Edit
  case "<":
    Sort, Edit, N D,
    numsym := Edit
  case ">":
    Sort, Edit, N R D,
    numsym := Edit
  default: numsym := Edit A_GuiControl
}

FocusBack:                                       ;Placing 'Key:' above runs this
history++
Menu, History, Rename, %history%&, %Edit%=%numsym%
if (history = 10)
	history := 0
GuiControl, mCalc:Text, Edit1, %numsym%
GuiControl, mCalc:Focus, Edit1
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
numsym := 9
return

Edit:
Gui, Submit, NoHide
if InStr(Edit, "!") > 0
	numsym := ZTrim(Fac(RTrim(Edit, "!")))
if InStr(Edit, "!") = 0
	numsym := Mather.Evaluate(Edit)
SB_SetText(numsym, 2)
return

AOT:
Winset, Alwaysontop, , A
Return

SB:
Gui, Submit, NoHide
GuiControl, Text, Edit1, %SB%
SB_SetText(Edit)
Goto, Edit
return

History:
GuiControl, Text, Edit1, % StrReplace(SubStr(A_ThisMenuItem, 1, InStr(A_ThisMenuItem, "=")), "=")
GuiControl, Focus, Edit1 
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
Goto, Edit
return

CType:
Gui, +OwnDialogs
MsgBox, 262192, Dev Note, This is still a WIP!! ;here I plan on making several calculators
return

Clear:
GuiControl, Text, Edit1
return

IsPrime:
Gui, Submit, NoHide
GuiControl, Text, Button3, % IsPrime(Edit)
Sleep, 1000
GuiControl, Text, Button3, IsPr
return

#If WinActive(name "ahk_class AutoHotkeyGUI")    ;Only use these hotkeys if active
Equal:
Enter::
NumpadEnter::
Gui, Submit, NoHide
SB_SetText(Edit)
if InStr(Edit, "!") > 0
	numsym := ZTrim(Fac(RTrim(Edit, "!")))
if InStr(Edit, "!") = 0
	numsym := Mather.Evaluate(Edit)
GoSub, FocusBack
GuiControlGet, clipboard, , Edit1, 
return

$^Backspace::Send ^+{Left}{Backspace}
#If                                              ;Close the #If block

ZTrim(x) {
  global Round
  x := Round(x, Round)
  If InStr(x,".00")
    x := % Floor(x)
  return x
}

IsPrime(n,k=2) {
  d := k+(k<7 ? 1+(k>2) : SubStr("6-----4---2-4---2-4---6-----2",Mod(k,30),1)) 
  Return n < 3 ? n>1 : Mod(n,k) ? (d*d <= n ? IsPrime(n,d) : "Yes") : "No"
}

Fac(x) {
  var := 1
  Loop, %x%
    var *= A_Index
  return var
}

class Mather {
	Tokenize(Source) {
		Tokens := []
		while (RegexMatch(Source, "Ox)(?<Number>\d+\.\d+|\d+)|(?<Operator>[\+\-\~\!\*\^\/\√\%\&])|(?<Punctuation>[\(\)])", Match)) {
			loop, % Match.Count() {
				Name := Match.Name(A_Index)
				Value := Match[Name]
				if (Match.Len(A_Index))
					Tokens.Push({"Type": Name, "Value": Value})
			}
			Source := SubStr(Source, Match.Pos(0) + Match.Len(0))
		}
		return Tokens
	}
	static BinaryPrecedence := {"+": 1, "-": 1, "&": 1, "*": 2, "^": 2, "/": 2, "√": 1, "%": 2}
	static UnaryPrecedence := 5
	EvaluateExpressionOperand(Tokens) {
		NextToken := Tokens.RemoveAt(1)
		if (NextToken.Type = "Punctuation" && NextToken.Value = "(") {
			Value := this.EvaluateExpression(Tokens)
			NextToken := Tokens.RemoveAt(1)
			return Value
		}
		else if (NextToken.Type = "Operator") {
			Value := this.EvaluateExpression(Tokens, this.UnaryPrecedence)
			switch (NextToken.Value) {
				case "+": return Value
				case "-": return -Value
				case "~": return -Value + 1
				case "√": return ZTrim(Sqrt(Value))
				case "&": {
					GuiControl, Text, Button3, % IsPrime(Value)
					Sleep, 1000
					GuiControl, Text, Button3, IsPr
					return Value
				}
			}
			Throw "Unary operator " NextToken.Value " is not implemented"
		}
		else if (NextToken.Type = "Number")
			return NextToken.Value * 1
	}
	EvaluateExpression(Tokens, Precedence := 0) {
		LeftValue := this.EvaluateExpressionOperand(Tokens)
		OperatorToken := Tokens.RemoveAt(1)
		while (OperatorToken.Type = "Operator" && this.BinaryPrecedence[OperatorToken.Value] >= Precedence) {
			RightValue := this.EvaluateExpression(Tokens, this.BinaryPrecedence[OperatorToken.Value])
			switch (OperatorToken.Value) {
				case "+": LeftValue += RightValue
				case "-": LeftValue -= RightValue
				case "*": LeftValue *= RightValue
				case "/": LeftValue := LeftValue/RightValue
				case "%": LeftValue := (LeftValue/100)*RightValue
				case "^": LeftValue := LeftValue**RightValue
			}
			OperatorToken := Tokens.RemoveAt(1)
		}
		if (OperatorToken)
			Tokens.InsertAt(1, OperatorToken)
		return ZTrim(LeftValue)
	}
	Evaluate(Source) {
		return this.EvaluateExpression(this.Tokenize(Source))
	}
}
