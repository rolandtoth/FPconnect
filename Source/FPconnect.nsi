; ----disable UAC prompt----
RequestExecutionLevel user

; ----Compressor----
SetCompressor /SOLID lzma

;---Definitions----
!define SNAME "FPconnect"

;----Includes----
!include "FileFunc.nsh"
!insertmacro "GetParameters"
!include "LogicLib.nsh"
!define StrReplaceV4 `!insertmacro StrReplaceV4`
!define StrContains '!insertmacro "_StrContainsConstructor"'

;-----Runtime switches----
CRCCheck off
AutoCloseWindow True
SilentInstall silent
WindowIcon off
XPSTYLE on 

;-----Set basic information-----
Name "${SNAME}"
Icon "${SNAME}.ico"
Caption "${SNAME}"
OutFile "..\${SNAME}.exe"

;-----Version Information------
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"

VIProductVersion "0.1.0.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${SNAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "©rolandtoth 2014"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${SNAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "0.1"

!macro StrReplaceV4 Var Replace With In
 Push ${Var1}
 Push ${Var2}
 Push `${Replace}`
 Push `${With}`
 Push `${In}`
 Call StrReplaceV4
 Pop `${Var}`
 Pop ${Var2}
 Pop ${Var1}
!macroend

!define Var0 $R0
!define Var1 $R1
!define Var2 $R2
!define Var3 $R3
!define Var4 $R4
!define Var5 $R5
!define Var6 $R6
!define Var7 $R7
!define Var8 $R8

!macro _StrContainsConstructor OUT NEEDLE HAYSTACK
  Push "${HAYSTACK}"
  Push "${NEEDLE}"
  Call StrContains
  Pop "${OUT}"
!macroend

Var params
Var app_path
Var commandline
Var path

Section "Main"
	
	${GetParameters} $params
	
	ReadINIStr $app_path "$EXEDIR\${SNAME}.ini" "Options" "AppPath"
	ReadINIStr $commandline "$EXEDIR\${SNAME}.ini" "Options" "Commandline"

	; expand environment variables
	ExpandEnvStrings $app_path $app_path

	; check if there are any passed params
	StrCmp $params "" ErrorMsg-NoParams
	StrCmp $app_path "" ErrorMsg-AppNotFound

	; get path from commandline
	${StrReplaceV4} $path "/O" "" $params
	${StrReplaceV4} $path "/T" "" $path
	${StrReplaceV4} $path "/S" "" $path
	${StrReplaceV4} $path "/N" "" $path
	${StrReplaceV4} $path "/L=" "" $path
	${StrReplaceV4} $path '"' '' $path

	; remove whitespace
	Push $path
	Call Trim
	Pop $path

	; expand environment variables
	ExpandEnvStrings $path $path

	; add double quotes around path if it contains spaces
	${StrContains} $1 " " $path
	StrCmp $1 " " 0 +2
	StrCpy $path '"$path"'

	; replace %path% in commandline from the ini
	${StrReplaceV4} $commandline "%path%" $path $commandline
	
	IfFileExists "$app_path" 0 CheckRelativePath
		Exec '"$app_path" $commandline'
		Abort
	
	CheckRelativePath:
		IfFileExists "$EXEDIR\$app_path" 0 ErrorMsg-AppNotFound
			Exec '"$EXEDIR\$app_path" $commandline'
			Abort

	ErrorMsg-AppNotFound:
		MessageBox MB_OK "Application not found!$\nPlease check ${SNAME}.ini."
		Abort

	ErrorMsg-NoParams:
		MessageBox MB_OK "${SNAME} should only be used by Folders Popup internally."
		Abort

SectionEnd


Function StrReplaceV4
Exch ${Var0} #in
Exch 1
Exch ${Var1} #with
Exch 2
Exch ${Var2} #replace
Push ${Var3}
Push ${Var4}
Push ${Var5}
Push ${Var6}
Push ${Var7}
Push ${Var8}
 
 StrCpy ${Var3} -1
 StrLen ${Var5} ${Var0}
 StrLen ${Var6} ${Var1}
 StrLen ${Var7} ${Var2}
 Loop:
  IntOp ${Var3} ${Var3} + 1
  StrCpy ${Var4} ${Var0} ${Var7} ${Var3}
  StrCmp ${Var3} ${Var5} End
  StrCmp ${Var4} ${Var2} 0 Loop
 
   StrCpy ${Var4} ${Var0} ${Var3}
   IntOp ${Var8} ${Var3} + ${Var7}
   StrCpy ${Var8} ${Var0} "" ${Var8}
   StrCpy ${Var0} ${Var4}${Var1}${Var8}
   IntOp ${Var3} ${Var3} + ${Var6}
   IntOp ${Var3} ${Var3} - 1
   IntOp ${Var5} ${Var5} - ${Var7}
   IntOp ${Var5} ${Var5} + ${Var6}
 
 Goto Loop
 End:
 
Pop ${Var8}
Pop ${Var7}
Pop ${Var6}
Pop ${Var5}
Pop ${Var4}
Pop ${Var3}
Pop ${Var2}
Pop ${Var1}
Exch ${Var0} #out
FunctionEnd


Function Trim
	Exch $R1 ; Original string
	Push $R2
 
Loop:
	StrCpy $R2 "$R1" 1
	StrCmp "$R2" " " TrimLeft
	StrCmp "$R2" "$\r" TrimLeft
	StrCmp "$R2" "$\n" TrimLeft
	StrCmp "$R2" "$\t" TrimLeft
	GoTo Loop2
TrimLeft:	
	StrCpy $R1 "$R1" "" 1
	Goto Loop
 
Loop2:
	StrCpy $R2 "$R1" 1 -1
	StrCmp "$R2" " " TrimRight
	StrCmp "$R2" "$\r" TrimRight
	StrCmp "$R2" "$\n" TrimRight
	StrCmp "$R2" "$\t" TrimRight
	GoTo Done
TrimRight:	
	StrCpy $R1 "$R1" -1
	Goto Loop2
 
Done:
	Pop $R2
	Exch $R1
FunctionEnd


; StrContains
; This function does a case sensitive searches for an occurrence of a substring in a string. 
; It returns the substring if it is found. 
; Otherwise it returns null(""). 
; Written by kenglish_hi
; Adapted from StrReplace written by dandaman32
 
Var STR_HAYSTACK
Var STR_NEEDLE
Var STR_CONTAINS_VAR_1
Var STR_CONTAINS_VAR_2
Var STR_CONTAINS_VAR_3
Var STR_CONTAINS_VAR_4
Var STR_RETURN_VAR
 
Function StrContains
  Exch $STR_NEEDLE
  Exch 1
  Exch $STR_HAYSTACK
  ; Uncomment to debug
  ;MessageBox MB_OK 'STR_NEEDLE = $STR_NEEDLE STR_HAYSTACK = $STR_HAYSTACK '
    StrCpy $STR_RETURN_VAR ""
    StrCpy $STR_CONTAINS_VAR_1 -1
    StrLen $STR_CONTAINS_VAR_2 $STR_NEEDLE
    StrLen $STR_CONTAINS_VAR_4 $STR_HAYSTACK
    loop:
      IntOp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_1 + 1
      StrCpy $STR_CONTAINS_VAR_3 $STR_HAYSTACK $STR_CONTAINS_VAR_2 $STR_CONTAINS_VAR_1
      StrCmp $STR_CONTAINS_VAR_3 $STR_NEEDLE found
      StrCmp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_4 done
      Goto loop
    found:
      StrCpy $STR_RETURN_VAR $STR_NEEDLE
      Goto done
    done:
   Pop $STR_NEEDLE ;Prevent "invalid opcode" errors and keep the
   Exch $STR_RETURN_VAR  
FunctionEnd