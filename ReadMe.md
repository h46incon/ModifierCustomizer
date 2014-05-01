# Modifier Customizer

Modifier Customizer is a tool made by AutoHotKey_H, it could:


## Make an ordinary key becomes a modifier key
You can define a hotkey with this modifier. The hotkey can be mapped to a key or a raw string.

For example, If define *CapsLock* become a new modifier, then can mapped:

- `CapsLock + J` to key `Down`
- `CapsLock + U` to raw string "**{**"


## Mapped a key only if no modifier key pressed

For example, If mapped `quotes` key to `BackSpace`, it will send a **DoubleQutes** when press `Shift + quotes`. 

Note: the custom modifier is *NOT* under consideration. If need send `quotes` itself, you can map `CapsLock + quotes` to `quotes`.


## Usage
0. Install **AutoHotKey** first. The version of AutoHotKey used to develop this tool is v1.1.14.
0. Edit *config.ini*. The default context in *config.ini* is a template.
0. Run *ModifierCustomizer.ahk*.