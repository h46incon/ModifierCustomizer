#SingleInstance, force
SendMode, Input
SetBatchLines, -1

RemapDic:= {}
RemapDic["h"] := "Left"
RemapDic["j"] := "Down"
RemapDic["k"] := "Up"
RemapDic["l"] := "Right"

RemapDownInfo := {}
RemapUpInfo := {}

For key, value in RemapDic
{
    HKDownStr := "Esc" . " & " . key
	HKUpStr := "Esc" . " & " . key . " Up"
	RemapDownInfo[HKDownStr] := value
	RemapUpInfo[HKUpStr] := value
	
	Hotkey, %HKDownStr%, MapKeyDown
	Hotkey, %HKUpStr%, MapKeyUp
}	

Esc::Esc

return

MapKeyDown:
	SetKeyDelay -1   ; If the destination key is a mouse button, SetMouseDelay is used instead.
	target := RemapDownInfo[A_ThisHotkey]
	if target !=
		Send {Blind}{%target% DownTemp}
	return
	
MapKeyUp:
	SetKeyDelay -1   ; If the destination key is a mouse button, SetMouseDelay is used instead.
	target := RemapUpInfo[A_ThisHotkey]
	if target !=
		Send {Blind}{%target% Up}
	return