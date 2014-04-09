#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
SetBatchLines, -1

IniFileName := "config.ini"
MapList := ReadIniFile(IniFileName)

RemapInfo := {}
; Add needed hotkey to RemapInfo
For modifier, map in MapList
{
	For key, value in map
	{
		HKDownStr := modifier . " & " . key
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
	
	; Add Single modifier keyevent map
	modifier_up := modifier . " Up"
	RemapInfo[modifier] := "{Blind}{" . modifier . " DownTemp}"
	RemapInfo[modifier_up] := "{Blind}{" . modifier . " Up}"
}

; Set hotkey
For key in RemapInfo
{
	Hotkey, %key%,  ReMapKeySub
}

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

ReMapKeySub:
	SetKeyDelay -1
	target := RemapInfo[A_ThisHotkey]
	if target !=
		Send, %target%
	return
	
	
/*
	Return map_list: map from modifier to remaplist
	Example, modifer is ESC and TAB. and ESC+j maps to KEY "Down", ESC+u maps to RAW STRING "test".
		modifier_list = {
							"Esc":{"j":"\Down" , "k":"\Up", "u":"test" } , 
							"Tab":{ }
						}
*/
ReadIniFile(INI_name)
{	
	map_list := {}
	
	; Get modifier list
	IniRead, modifier_list, %INI_name%, Modifier, Modifier, ""
	
	Loop, Parse, modifier_list, |
	{
		modifier := Trim(A_LoopField)
		IniRead, map_read, %INI_name%, %modifier%
		map_list[modifier] := ParseIniSection(map_read)
	}
	
	return map_list
}


; Return key:value map
ParseIniSection(ByRef section_str)
{
	kv_map := {}
	Loop, Parse, section_str, `n, `r ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
	{
		StringSplit, key_value, A_LoopField, "="
		if key_value0 > 0
		{
			kv_map[key_value1] := key_value2
		}
	}
	
	return kv_map
}



