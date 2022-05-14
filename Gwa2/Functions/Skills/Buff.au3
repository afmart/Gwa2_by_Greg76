#Region Buff
;~ Description: Returns current number of buffs being maintained.
Func GetBuffCount($aHeroNumber = 0)
	Local $lOffset[4]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x2C
	$lOffset[3] = 0x510
	Local $lCount = MemoryReadPtr($mBasePointer, $lOffset)
	ReDim $lOffset[5]
	$lOffset[3] = 0x508
	Local $lBuffer
	For $i = 0 To $lCount[1] - 1
		$lOffset[4] = 0x24 * $i
		$lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
		If $lBuffer[1] == GetHeroID($aHeroNumber) Then
			Return MemoryRead($lBuffer[0] + 0xC)
		EndIf
	Next
	Return 0
EndFunc   ;==>GetBuffCount

;~ Description: Tests if you are currently maintaining buff on target.
Func GetIsTargetBuffed($aSkillID, $aAgentID, $aHeroNumber = 0)
	Local $lBuffStruct = DllStructCreate('long SkillId;byte unknown1[4];long BuffId;long TargetId')
	Local $lBuffCount = GetBuffCount($aHeroNumber)
	Local $lBuffStructAddress
	Local $lOffset[4]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x2C
	$lOffset[3] = 0x510
	Local $lCount = MemoryReadPtr($mBasePointer, $lOffset)
	ReDim $lOffset[5]
	$lOffset[3] = 0x508
	Local $lBuffer
	For $i = 0 To $lCount[1] - 1
		$lOffset[4] = 0x24 * $i
		$lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
		If $lBuffer[1] == GetHeroID($aHeroNumber) Then
			$lOffset[4] = 0x4 + 0x24 * $i
			ReDim $lOffset[6]
			For $j = 0 To $lBuffCount - 1
				$lOffset[5] = 0 + 0x10 * $j
				$lBuffStructAddress = MemoryReadPtr($mBasePointer, $lOffset)
				DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lBuffStructAddress[0], 'ptr', DllStructGetPtr($lBuffStruct), 'int', DllStructGetSize($lBuffStruct), 'int', '')
				If (DllStructGetData($lBuffStruct, 'SkillID') == $aSkillID) And (DllStructGetData($lBuffStruct, 'TargetId') == ConvertID($aAgentID)) Then
					Return $j + 1
				EndIf
			Next
		EndIf
	Next
	Return 0
EndFunc   ;==>GetIsTargetBuffed

;~ Description: Returns buff struct.
Func GetBuffByIndex($aBuffNumber, $aHeroNumber = 0)
	Local $lBuffStruct = DllStructCreate('long SkillId;byte unknown1[4];long BuffId;long TargetId')
	Local $lOffset[4]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x2C
	$lOffset[3] = 0x510
	Local $lCount = MemoryReadPtr($mBasePointer, $lOffset)
	ReDim $lOffset[5]
	$lOffset[3] = 0x508
	Local $lBuffer
	For $i = 0 To $lCount[1] - 1
		$lOffset[4] = 0x24 * $i
		$lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
		If $lBuffer[1] == GetHeroID($aHeroNumber) Then
			$lOffset[4] = 0x4 + 0x24 * $i
			ReDim $lOffset[6]
			$lOffset[5] = 0 + 0x10 * ($aBuffNumber - 1)
			$lBuffStructAddress = MemoryReadPtr($mBasePointer, $lOffset)
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lBuffStructAddress[0], 'ptr', DllStructGetPtr($lBuffStruct), 'int', DllStructGetSize($lBuffStruct), 'int', '')
			Return $lBuffStruct
		EndIf
	Next
	Return 0
EndFunc   ;==>GetBuffByIndex

;~ Description: Stop maintaining enchantment on target.
Func DropBuff($aSkillID, $aAgentID, $aHeroNumber = 0)
	Local $lBuffStruct = DllStructCreate('long SkillId;byte unknown1[4];long BuffId;long TargetId')
	Local $lBuffCount = GetBuffCount($aHeroNumber)
	Local $lBuffStructAddress
	Local $lOffset[4]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x2C
	$lOffset[3] = 0x510
	Local $lCount = MemoryReadPtr($mBasePointer, $lOffset)
	ReDim $lOffset[5]
	$lOffset[3] = 0x508
	Local $lBuffer
	For $i = 0 To $lCount[1] - 1
		$lOffset[4] = 0x24 * $i
		$lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
		If $lBuffer[1] == GetHeroID($aHeroNumber) Then
			$lOffset[4] = 0x4 + 0x24 * $i
			ReDim $lOffset[6]
			For $j = 0 To $lBuffCount - 1
				$lOffset[5] = 0 + 0x10 * $j
				$lBuffStructAddress = MemoryReadPtr($mBasePointer, $lOffset)
				DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lBuffStructAddress[0], 'ptr', DllStructGetPtr($lBuffStruct), 'int', DllStructGetSize($lBuffStruct), 'int', '')
				If (DllStructGetData($lBuffStruct, 'SkillID') == $aSkillID) And (DllStructGetData($lBuffStruct, 'TargetId') == ConvertID($aAgentID)) Then
					out(DllStructGetData($lBuffStruct, 'BuffId'))
					Return SendPacket(0x8, $HEADER_STOP_MAINTAIN_ENCH, DllStructGetData($lBuffStruct, 'BuffId'))
					ExitLoop 2
				EndIf
			Next
		EndIf
	Next
EndFunc   ;==>DropBuff

#EndRegion Buff

