Modifer := "Esc"
RemapDic:= {}
RemapDic["h"] := "\Left"
RemapDic["j"] := "\Down"
RemapDic["k"] := "\Up"
RemapDic["l"] := "\Right"
RemapDic["n"] := "\Enter"
RemapDic["'"] := "\'"
RemapDic["u"] := "`{"
RemapDic["i"] := "`}"

;===========================================================================================================
#SingleInstance, force
SendMode, Input
SetBatchLines, -1
RemapInfo := {}

; Add needed hotkey to RemapInfo
For key, value in RemapDic
{
	HKDownStr := Modifer . " & " . key
	if (SubStr(value, 1, 1) = "\")
	{
		; It a key
		value := SubStr(value, 2)
		HKUpStr := HKDownStr . " Up"
		RemapInfo[HKDownStr] := "{Blind}{" . value . " DownTemp}"
		RemapInfo[HKUpStr] := "{Blind}{" . value . " Up}"
	}
	else{
		RemapInfo[HKDownStr] := "{Raw}" . value
	}

}

; Set hotkey
For key, calue in RemapInfo
{
	Hotkey, %key%,  ReMapKey
}
Esc::Esc

;Key ' for backspace
'::
	if GetKeyState("!") or GetKeyState("#") or GetKeyState("+") of GetKeyState("^")
		Send {Blind}{'}
	else
		Send {Blind}{BS}
	return
	

;======================================================================================================
; Label
return

ReMapKey:
	SetKeyDelay -1
	target := RemapInfo[A_ThisHotkey]
	if target !=
		Send, %target%
	return
	
	