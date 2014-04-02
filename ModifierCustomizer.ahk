Modifer := "Esc"
RemapDic:= {}
RemapDic["h"] := "Left"
RemapDic["j"] := "Down"
RemapDic["k"] := "Up"
RemapDic["l"] := "Right"
RemapDic["'"] := "'"


;===========================================================================================================
#SingleInstance, force
SendMode, Input
SetBatchLines, -1
RemapInfo := {}

; Add needed hotkey to RemapInfo
For key, value in RemapDic
{
    HKDownStr := Modifer . " & " . key
	HKUpStr := HKDownStr . " Up"
	RemapInfo[HKDownStr] := "{" . value . " DownTemp}"
	RemapInfo[HKUpStr] := "{" . value . " Up}"
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
		Send, {Blind}%target%
	return
	
	