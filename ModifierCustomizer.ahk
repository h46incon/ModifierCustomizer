#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
#NoTrayIcon
Process Priority,,High
SetBatchLines, -1

; Global Setting
IniFileName := "config.ini"
IconFileName := "Icon.ico"
;======================================================================================

IniOption := ReadIniFile(IniFileName)

; Set tray icon 
If not IniOption.NoTrayIcon
{
  Menu TRAY, Icon
  IfExist %IconFileName%
    Menu TRAY, Icon, %IconFileName%
}
; Add reload button in tray
Menu, tray, add, Reload, ReloadLab

MapList := IniOption.MapList
SingleMap := IniOption.SingleMap

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
	w_modifier := "*" . modifier
	AddKeyEventToRemapInfo(w_modifier, modifier, RemapInfo)
}
; Add to SingleRemapInfo
For hk_from, map_to in SingleMap
{
	AddKeyMapToRemapInfo(hk_from, map_to, RemapInfo)
}

; Set hotkey
SetHotKey(RemapInfo, "ReMapKeySub")

return

;============================ Tray item sub ==========================================================
ReloadLab:
    Reload
    Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
    MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
    IfMsgBox, Yes, Edit
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


SetHotKey(ByRef remapInfo, hotkey_handle)
{
	For hot_key in remapInfo
	{
		Hotkey, %hot_key%,  %hotkey_handle%
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
ReadIniFile(INI_name)
{	
	INI_option := {}
	
	; Read Global option
	IniRead, no_tray, %INI_name%, Global, NoTrayIcon, ""
	if no_tray != 1
		no_tray = 0
	INI_option.NoTrayIcon := no_tray

	; Get modifier list
	MapList := {}
	IniRead, modifier_list, %INI_name%, Modifier, Modifier, %A_Space%
	
	Loop, Parse, modifier_list, |
	{
		modifier := Trim(A_LoopField)
		MapList[modifier] := ParseIniSection(INI_name, modifier)
	}
	INI_option.MapList := MapList
	
	; Get Single Map
	INI_option.SingleMap := ParseIniSection(INI_name, "SingleMap")
	
	return INI_option
}

; Return key:value map
ParseIniSection(INI_name, section_name)
{
	IniRead, section_str, %INI_name%, %section_name%
	
	kv_map := {}
	Loop, Parse, section_str, `n, `r ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
	{
		items := StrSplit(A_LoopField, "=")
		if items.Length() > 0
		{
			map_key := items[1]
			IniRead, map_val, %INI_name%, %section_name%, %map_key%, %A_Space%
			if (map_val != "")
			{
				kv_map[map_key] := map_val
			}
		}
	}
	
	return kv_map
}