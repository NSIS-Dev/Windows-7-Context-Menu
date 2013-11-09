; Scaffolding by https://github.com/idleberg/NSIS-Sublime-Text

; Settings ---------------------------------
Name "NSIS Context Menu for Windows 7"
OutFile "Context_Menu.exe"
RequestExecutionLevel admin
 
InstallDir $PROGRAMFILES\NSIS
InstallDirRegKey HKLM Software\NSIS ""

!include LogicLib.nsh

; Pages ------------------------------------
Page directory
Page instfiles

; Sections ---------------------------------
Section -pre

	ReadRegStr $0 HKCR "NSIS.Script\shell\compile" ""
	ReadRegStr $1 HKCR "NSIS.Script\shell\ucompile" ""
	${If} $0 == "Compile NSIS Script"
	${OrIf} $0 == "Compile ANSI NSIS Script"
	${OrIf} $0 == "Compile Unicode NSIS Script"
	${OrIf} $1 == "Compile Unicode NSIS Script"
		MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 "Remove existing context menu entries? (recommended)" IDNO +2
		DeleteRegKey HKCR  "NSIS.Script\shell\compile"
		DeleteRegKey HKCR  "NSIS.Script\shell\compile-compressor"
		DeleteRegKey HKCR  "NSIS.Script\shell\ucompile"
		DeleteRegKey HKCR  "NSIS.Script\shell\ucompile-compressor"
	${EndIf}

	Var /GLOBAL Counter
	StrCpy $Counter 0

SectionEnd

Section "NSIS ANSI"
	
	${If} ${FileExists} "$INSTDIR\ANSI\makensisw.exe"
		Call createMenu
		WriteRegStr	HKCR "NSIS.Script\shell\NSIS.W7Menu" "Icon" "$INSTDIR\ANSI\makensisw.exe,1" 

		;compile ansi
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\acompile" "MUIVerb" "Compile ANSI NSIS Script"				
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\acompile\command" "" '"$INSTDIR\ANSI\makensisw.exe" "%1"' 
		
		;compile ansi (choose compressor)
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\acompile-compressor" "MUIVerb" "Compile ANSI NSIS Script (Choose Compressor)"				
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\acompile-compressor\command" "" '"$INSTDIR\ANSI\makensisw.exe" /ChooseCompressor "%1"' 

		IntOp $Counter $Counter + 1
	${EndIf}

SectionEnd

Section "Official NSIS"
	
	${If} ${FileExists} "$INSTDIR\makensisw.exe"
		${If} $Counter == 0
			Call createMenu
			WriteRegStr	HKCR "NSIS.Script\shell\NSIS.W7Menu" "Icon" "$INSTDIR\makensisw.exe,1" 
		${Else}
			;add separator above the next entry
			WriteRegDWORD HKCR "NSIS.Script\W7Menu\shell\compile"  "CommandFlags" "32" 
		${EndIf}
		
		;compile
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\compile" "MUIVerb" "Compile NSIS Script"				
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\compile\command" "" '"$INSTDIR\makensisw.exe" "%1"' 
		
		;compile (choose compressor)
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\compile-compressor" "MUIVerb" "Compile NSIS Script (Choose Compressor)"				
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\compile-compressor\command" "" '"$INSTDIR\makensisw.exe" /ChooseCompressor "%1"'

		IntOp $Counter $Counter + 1
	${EndIf}

SectionEnd

Section "NSIS Unicode"
	
	${If} ${FileExists} "$INSTDIR\Unicode\makensisw.exe"
		${If} $Counter == 0
			Call createMenu
			WriteRegStr	HKCR "NSIS.Script\shell\NSIS.W7Menu" "Icon" "$INSTDIR\Unicode\makensisw.exe,1" 
		${Else}
			;add separator above the next entry
			WriteRegDWORD HKCR "NSIS.Script\W7Menu\shell\ucompile"  "CommandFlags" "32" 
		${EndIf}

		;compile unicode
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\ucompile" "MUIVerb" "Compile Unicode NSIS Script"				
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\ucompile\command" "" '"$INSTDIR\Unicode\makensisw.exe" "%1"' 
		
		;compile unicode (choose compressor)
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\ucompile-compressor" "MUIVerb" "Compile Unicode NSIS Script (Choose Compressor)"				
		WriteRegStr	HKCR "NSIS.Script\W7Menu\shell\ucompile-compressor\command" "" '"$INSTDIR\Unicode\makensisw.exe" /ChooseCompressor "%1"' 

		IntOp $Counter $Counter + 1
	${EndIf}

SectionEnd

Section -post
	Quit
SectionEnd

; Functions --------------------------------
Function .onInit
	SetRegView 32
FunctionEnd

Function createMenu
	WriteRegStr HKCR ".nsi" "" "NSIS.Script"
 
	;menu-name,submenu,icon
	WriteRegStr	HKCR "NSIS.Script\shell\NSIS.W7Menu" "MUIVerb" "NSIS"
	WriteRegStr	HKCR "NSIS.Script\shell\NSIS.W7Menu" "ExtendedSubCommandsKey" "NSIS.Script\W7Menu"
FunctionEnd
