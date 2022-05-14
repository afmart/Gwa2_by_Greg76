#Region H&H
;~ Description: Adds a hero to the party.
Func AddHero($aHeroId)
	Return SendPacket(0x8, $HEADER_HERO_ADD, $aHeroId)
EndFunc   ;==>AddHero

;~ Description: Kicks a hero from the party.
Func KickHero($aHeroId)
	Return SendPacket(0x8, $HEADER_HERO_KICK, $aHeroId)
EndFunc   ;==>KickHero

;~ Description: Kicks all heroes from the party.
Func KickAllHeroes()
	Return SendPacket(0x8, $HEADER_HEROES_KICK, 0x26)
EndFunc   ;==>KickAllHeroes

;~ Description: Add a henchman to the party.
Func AddNpc($aNpcId)
	Return SendPacket(0x8, $HEADER_HENCHMAN_ADD, $aNpcId)
EndFunc   ;==>AddNpc

;~ Description: Kick a henchman from the party.
Func KickNpc($aNpcId)
	Return SendPacket(0x8, $HEADER_HENCHMAN_KICK, $aNpcId)
EndFunc   ;==>KickNpc

;~ Description: Clear the position flag from a hero.
Func CancelHero($aHeroNumber)
	Local $lAgentID = GetHeroID($aHeroNumber)
	Return SendPacket(0x14, $HEADER_HERO_CLEAR_FLAG, $lAgentID, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelHero

;~ Description: Clear the position flag from all heroes.
Func CancelAll()
	Return SendPacket(0x10, $HEADER_PARTY_CLEAR_FLAG, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelAll

;~ Description: Place a hero's position flag.
Func CommandHero($aHeroNumber, $aX, $aY)
	Return SendPacket(0x14, $HEADER_HERO_PLACE_FLAG, GetHeroID($aHeroNumber), FloatToInt($aX), FloatToInt($aY), 0)
EndFunc   ;==>CommandHero

;~ Description: Place the full-party position flag.
Func CommandAll($aX, $aY)
	Return SendPacket(0x10, $HEADER_PARTY_PLACE_FLAG, FloatToInt($aX), FloatToInt($aY), 0)
EndFunc   ;==>CommandAll

;~ Description: Lock a hero onto a target.
Func LockHeroTarget($aHeroNumber, $aAgentID = 0) ;$aAgentID=0 Cancels Lock
	Local $lHeroID = GetHeroID($aHeroNumber)
	Return SendPacket(0xC, $HEADER_HERO_LOCK, $lHeroID, $aAgentID)
EndFunc   ;==>LockHeroTarget

;~ Description: Change a hero's aggression level.
Func SetHeroAggression($aHeroNumber, $aAggression) ;0=Fight, 1=Guard, 2=Avoid
	Local $lHeroID = GetHeroID($aHeroNumber)
	Return SendPacket(0xC, $HEADER_HERO_AGGRESSION, $lHeroID, $aAggression)
EndFunc   ;==>SetHeroAggression

;~ Description: Disable a skill on a hero's skill bar.
Func DisableHeroSkillSlot($aHeroNumber, $aSkillSlot)
	If Not GetIsHeroSkillSlotDisabled($aHeroNumber, $aSkillSlot) Then ChangeHeroSkillSlotState($aHeroNumber, $aSkillSlot)
EndFunc   ;==>DisableHeroSkillSlot

;~ Description: Enable a skill on a hero's skill bar.
Func EnableHeroSkillSlot($aHeroNumber, $aSkillSlot)
	If GetIsHeroSkillSlotDisabled($aHeroNumber, $aSkillSlot) Then ChangeHeroSkillSlotState($aHeroNumber, $aSkillSlot)
EndFunc   ;==>EnableHeroSkillSlot

;~ Description: Internal use for enabling or disabling hero skills
Func ChangeHeroSkillSlotState($aHeroNumber, $aSkillSlot)
	Return SendPacket(0xC, $HEADER_HERO_TOGGLE_SKILL, GetHeroID($aHeroNumber), $aSkillSlot - 1)
EndFunc   ;==>ChangeHeroSkillSlotState

;~ Description: Order a hero to use a skill.
Func UseHeroSkill($aHero, $aSkillSlot, $aTarget = 0)
	Local $lTargetID

	If IsDllStruct($aTarget) = 0 Then
		$lTargetID = ConvertID($aTarget)
	Else
		$lTargetID = DllStructGetData($aTarget, 'ID')
	EndIf

	DllStructSetData($mUseHeroSkill, 2, GetHeroID($aHero))
	DllStructSetData($mUseHeroSkill, 3, $lTargetID)
	DllStructSetData($mUseHeroSkill, 4, $aSkillSlot - 1)
	Enqueue($mUseHeroSkillPtr, 16)
EndFunc   ;==>UseHeroSkill
#EndRegion H&H

#Region H&H
;~ Description: Returns number of heroes you control.
Func GetHeroCount()
	Local $lOffset[5]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x4C
	$lOffset[3] = 0x54
	$lOffset[4] = 0x2C
	Local $lHeroCount = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lHeroCount[1]
EndFunc   ;==>GetHeroCount

;~ Description: Returns agent ID of a hero.
Func GetHeroID($aHeroNumber)
	If $aHeroNumber == 0 Then Return GetMyID()
	Local $lOffset[6]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x4C
	$lOffset[3] = 0x54
	$lOffset[4] = 0x24
	$lOffset[5] = 0x18 * ($aHeroNumber - 1)
	Local $lAgentID = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lAgentID[1]
EndFunc   ;==>GetHeroID

;~ Description: Returns hero number by agent ID.
Func GetHeroNumberByAgentID($aAgentID)
	Local $lAgentID
	Local $lOffset[6]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x4C
	$lOffset[3] = 0x54
	$lOffset[4] = 0x24
	For $i = 1 To GetHeroCount()
		$lOffset[5] = 0x18 * ($i - 1)
		$lAgentID = MemoryReadPtr($mBasePointer, $lOffset)
		If $lAgentID[1] == ConvertID($aAgentID) Then Return $i
	Next
	Return 0
EndFunc   ;==>GetHeroNumberByAgentID

;~ Description: Returns hero number by hero ID.
Func GetHeroNumberByHeroID($aHeroId)
	Local $lAgentID
	Local $lOffset[6]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x4C
	$lOffset[3] = 0x54
	$lOffset[4] = 0x24
	For $i = 1 To GetHeroCount()
		$lOffset[5] = 8 + 0x18 * ($i - 1)
		$lAgentID = MemoryReadPtr($mBasePointer, $lOffset)
		If $lAgentID[1] == ConvertID($aHeroId) Then Return $i
	Next
	Return 0
EndFunc   ;==>GetHeroNumberByHeroID

;~ Description: Returns hero's profession ID (when it can't be found by other means)
Func GetHeroProfession($aHeroNumber, $aSecondary = False)
	Local $lOffset[5] = [0, 0x18, 0x2C, 0x6BC, 0]
	Local $lBuffer
	$aHeroNumber = GetHeroID($aHeroNumber)
	For $i = 0 To GetHeroCount()
		$lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
		If $lBuffer[1] = $aHeroNumber Then
			$lOffset[4] += 4
			If $aSecondary Then $lOffset[4] += 4
			$lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
			Return $lBuffer[1]
		EndIf
		$lOffset[4] += 0x14
	Next
EndFunc   ;==>GetHeroProfession

;~ Description: Tests if a hero's skill slot is disabled.
Func GetIsHeroSkillSlotDisabled($aHeroNumber, $aSkillSlot)
	Return BitAND(2 ^ ($aSkillSlot - 1), DllStructGetData(GetSkillbar($aHeroNumber), 'Disabled')) > 0
EndFunc   ;==>GetIsHeroSkillSlotDisabled
#EndRegion H&H
