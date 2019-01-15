#AutoIt3Wrapper_Run_Tidy=Y
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Change2CUI=Y

#NoTrayIcon
#Include <WinAPI.au3>
#include <WinAPIConv.au3>

If $CmdLine[0] < 2 Then Exit

If $CmdLine[1] = '-file' Then
	If Not FileExists($CmdLine[2]) Then Exit
	$encoding = FileGetEncoding($CmdLine[2])
	If $encoding = 256 Then Exit
	$open = FileOpen($CmdLine[2], $encoding)
	$read = FileRead($open)
	FileClose($open)
	$open = FileOpen($CmdLine[2], 2 + 256)
	FileWrite($open, $read)
	FileClose($open)
EndIf

If $CmdLine[1] = '-string' Then
	$CmdLine[2] = _WinAPI_WideCharToMultiByte($CmdLine[2], $CP_UTF8)
	ConsoleWrite($CmdLine[2])
EndIf
