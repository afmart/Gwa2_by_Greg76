#Region Chat
;~ Description: Write a message in chat (can only be seen by botter).
Func WriteChat($aMessage, $aSender = 'Gwa2')
	Local $lMessage, $lSender
	Local $lAddress = 256 * $mQueueCounter + $mQueueBase

	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf

	If StringLen($aSender) > 19 Then
		$lSender = StringLeft($aSender, 19)
	Else
		$lSender = $aSender
	EndIf

	MemoryWrite($lAddress + 4, $lSender, 'wchar[20]')

	If StringLen($aMessage) > 100 Then
		$lMessage = StringLeft($aMessage, 100)
	Else
		$lMessage = $aMessage
	EndIf

	MemoryWrite($lAddress + 44, $lMessage, 'wchar[101]')
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lAddress, 'ptr', $mWriteChatPtr, 'int', 4, 'int', '')

	If StringLen($aMessage) > 100 Then WriteChat(StringTrimLeft($aMessage, 100), $aSender)
EndFunc   ;==>WriteChat

;~ Description: Send a whisper to another player.
Func SendWhisper($aReceiver, $aMessage)
	Local $lTotal = 'whisper ' & $aReceiver & ',' & $aMessage
	Local $lMessage

	If StringLen($lTotal) > 120 Then
		$lMessage = StringLeft($lTotal, 120)
	Else
		$lMessage = $lTotal
	EndIf

	SendChat($lMessage, '/')

	If StringLen($lTotal) > 120 Then SendWhisper($aReceiver, StringTrimLeft($lTotal, 120))
EndFunc   ;==>SendWhisper

;~ Description: Send a message to chat.
Func SendChat($aMessage, $aChannel = '!')
	Local $lMessage
	Local $lAddress = 256 * $mQueueCounter + $mQueueBase

	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf

	If StringLen($aMessage) > 120 Then
		$lMessage = StringLeft($aMessage, 120)
	Else
		$lMessage = $aMessage
	EndIf

	MemoryWrite($lAddress + 12, $aChannel & $lMessage, 'wchar[122]')
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lAddress, 'ptr', $mSendChatPtr, 'int', 8, 'int', '')
EndFunc   ;==>SendChat
#EndRegion Chat

