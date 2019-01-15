#AutoIt3Wrapper_Run_Tidy=Y
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Change2CUI=Y

#NoTrayIcon
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
	ConsoleWrite(Unicode2Utf8($UniString))
EndIf

Func Unicode2Utf8($UniString)
    If Not IsBinaryString($UniString) Then
        SetError(1)
        Return $UniString
    EndIf

    Local $UniStringLen = StringLen($UniString)
    Local $BufferLen = $UniStringLen * 2
    Local $Input = DllStructCreate("byte[" & $BufferLen & "]")
    Local $Output = DllStructCreate("char[" & $BufferLen & "]")
    DllStructSetData($Input, 1, $UniString)
    Local $Return = DllCall("kernel32.dll", "int", "WideCharToMultiByte", _
        "int", 65001, _
        "int", 0, _
        "ptr", DllStructGetPtr($Input), _
        "int", $UniStringLen / 2, _
        "ptr", DllStructGetPtr($Output), _
        "int", $BufferLen, _
        "int", 0, _
        "int", 0)
    Local $Utf8String = DllStructGetData($Output, 1)
    $Output = 0
    $Input = 0
    Return $Utf8String
EndFunc