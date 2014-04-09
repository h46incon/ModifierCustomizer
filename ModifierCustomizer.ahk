#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
SetBatchLines, -1

IniFileName := "config.ini"
ReadIniFile(IniFileName, MapList)

RemapInfo := {}
; Add needed hotkey to RemapInfo
For modifier, map in MapList
{
	For hk_from, map_to in map
	{
		hot_key := modifier . " & " . hk_from
		AddKeyMapToRemapInfo(hot_key, map_to, RemapInfo)
	}
	
	; Add Single modifier keyevent map
	AddKeyEventToRemapInfo(modifier, modifier, RemapInfo)
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
	
	
AddKeyEventToRemapInfo(hk_from, hk_to, ByRef remapInfo)
{
	key_down_str := hk_from
	key_up_str := key_down_str . " Up"
	
	remapInfo[key_down_str] := "{Blind}{" . hk_to . " DownTemp}"
	remapInfo[key_up_str] := "{Blind}{" . hk_to . " Up}"
}
	
	
AddKeyMapToRemapInfo(hot_key, map_to, ByRef remapInfo)
{
	if (SubStr(map_to, 1, 1) = "\")
	{
		; It a key
		map_to := SubStr(map_to, 2)
		AddKeyEventToRemapInfo(hot_key, map_to, remapInfo)
	}
	else{
		remapInfo[hot_key] := "{Raw}" . map_to
	}
}

/*
	Return map_list: map from modifier to remaplist
	Example, modifer is ESC and TAB. and ESC+j maps to KEY "Down", ESC+u maps to RAW STRING "test".
		modifier_list = {
							"Esc":{"j":"\Down" , "k":"\Up", "u":"test" } , 
							"Tab":{ }
						}
*/
ReadIniFile(INI_name, ByRef MapList)
{	
	MapList := {}
	
	; Get modifier list
	IniRead, modifier_list, %INI_name%, Modifier, Modifier, ""
	
	Loop, Parse, modifier_list, |
	{
		modifier := Trim(A_LoopField)
		IniRead, map_read, %INI_name%, %modifier%
		MapList[modifier] := ParseIniSection(map_read)
	}
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



