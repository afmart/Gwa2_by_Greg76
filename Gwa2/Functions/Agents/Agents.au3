#Region Agent
;~ Description: Returns number of agents currently loaded.
Func GetMaxAgents()
	Return MemoryRead($mMaxAgents)
EndFunc   ;==>GetMaxAgents

;~ Description: Returns your agent ID.
Func GetMyID()
	Return MemoryRead($mMyID)
EndFunc   ;==>GetMyID

;~ Description: Returns current target.
Func GetCurrentTarget()
	Return GetAgentByID(GetCurrentTargetID())
EndFunc   ;==>GetCurrentTarget

;~ Description: Returns current target ID.
Func GetCurrentTargetID()
	Return MemoryRead($mCurrentTarget)
EndFunc   ;==>GetCurrentTargetID

;~ Description: Returns an agent struct.
Func GetAgentByID($aAgentID = -2)
	;returns dll struct if successful
	Local $lAgentPtr = GetAgentPtr($aAgentID)
	If $lAgentPtr = 0 Then Return 0
	;Offsets: 0x2C=AgentID 0x9C=Type 0xF4=PlayerNumber 0114=Energy Pips
	Local $lAgentStruct = DllStructCreate('ptr vtable;byte unknown1[24];byte unknown2[4];ptr NextAgent;byte unknown3[8];long Id;float Z;byte unknown4[8];float BoxHoverWidth;float BoxHoverHeight;byte unknown5[8];float Rotation;byte unknown6[8];long NameProperties;byte unknown7[24];float X;float Y;byte unknown8[8];float NameTagX;float NameTagY;float NameTagZ;byte unknown9[12];long Type;float MoveX;float MoveY;byte unknown10[28];long Owner;byte unknown30[8];long ExtraType;byte unknown11[24];float AttackSpeed;float AttackSpeedModifier;word PlayerNumber;byte unknown12[6];ptr Equip;byte unknown13[10];byte Primary;byte Secondary;byte Level;byte Team;byte unknown14[6];float EnergyPips;byte unknown[4];float EnergyPercent;long MaxEnergy;byte unknown15[4];float HPPips;byte unknown16[4];float HP;long MaxHP;long Effects;byte unknown17[4];byte Hex;byte unknown18[18];long ModelState;long TypeMap;byte unknown19[16];long InSpiritRange;byte unknown20[16];long LoginNumber;float ModelMode;byte unknown21[4];long ModelAnimation;byte unknown22[32];byte LastStrike;byte Allegiance;word WeaponType;word Skill;byte unknown23[4];word WeaponItemId;word OffhandItemId')
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lAgentPtr, 'ptr', DllStructGetPtr($lAgentStruct), 'int', DllStructGetSize($lAgentStruct), 'int', '')
	Return $lAgentStruct
EndFunc   ;==>GetAgentByID

;~ Description: Internal use for GetAgentByID()
Func GetAgentPtr($aAgentID = -2)
	Local $lOffset[3] = [0, 4 * ConvertID($aAgentID), 0]
	Local $lAgentStructAddress = MemoryReadPtr($mAgentBase, $lOffset)
	Return $lAgentStructAddress[0]
EndFunc   ;==>GetAgentPtr

;~ Description: Test if an agent exists.
Func GetAgentExists($aAgentID = -2)
	Return (GetAgentPtr($aAgentID) > 0 And $aAgentID < GetMaxAgents())
EndFunc   ;==>GetAgentExists

;~ Description: Returns the target of an agent.
Func GetTarget($aAgent = -2)
	Local $lAgentID

	If IsDllStruct($aAgent) = 0 Then
		$lAgentID = ConvertID($aAgent)
	Else
		$lAgentID = DllStructGetData($aAgent, 'ID')
	EndIf

	Return MemoryRead(GetValue('TargetLogBase') + 4 * $lAgentID)
EndFunc   ;==>GetTarget

;~ Description: Returns agent by player name.
Func GetAgentByPlayerName($aPlayerName = -2)
	For $i = 1 To GetMaxAgents()
		If GetPlayerName($i) = $aPlayerName Then
			Return GetAgentByID($i)
		EndIf
	Next
EndFunc   ;==>GetAgentByPlayerName

;~ Description: Returns agent by name.
Func GetAgentByName($aName = -2)
	If $mUseStringLog = False Then Return

	Local $lName, $lAddress

	For $i = 1 To GetMaxAgents()
		$lAddress = $mStringLogBase + 256 * $i
		$lName = MemoryRead($lAddress, 'wchar [128]')
		$lName = StringRegExpReplace($lName, '[<]{1}([^>]+)[>]{1}', '')
		If StringInStr($lName, $aName) > 0 Then Return GetAgentByID($i)
	Next

	DisplayAll(True)
	Sleep(100)
	DisplayAll(False)
	DisplayAll(True)
	Sleep(100)
	DisplayAll(False)

	For $i = 1 To GetMaxAgents()
		$lAddress = $mStringLogBase + 256 * $i
		$lName = MemoryRead($lAddress, 'wchar [128]')
		$lName = StringRegExpReplace($lName, '[<]{1}([^>]+)[>]{1}', '')
		If StringInStr($lName, $aName) > 0 Then Return GetAgentByID($i)
	Next
EndFunc   ;==>GetAgentByName

;~ Description: Returns the nearest agent to an agent.
Func GetNearestAgentToAgent($aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray()

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]
		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2

		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestAgentToAgent

;~ Description: Returns the nearest enemy to an agent.
Func GetNearestEnemyToAgent($aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0xDB)

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]
		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop

		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestEnemyToAgent

;~ Description: Returns the nearest agent to a set of coordinates.
Func GetNearestAgentToCoords($aX, $aY)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray()

	For $i = 1 To $lAgentArray[0]
		$lDistance = ($aX - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + ($aY - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestAgentToCoords

Func GetAgentByPlayerNumber($aPlayerNumber = -2)
	Local $lAgentArray = GetAgentArray()
	If IsDllStruct($aPlayerNumber) Then Return DllStructGetData($aPlayerNumber, "PlayerNumber")
	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "PlayerNumber") == $aPlayerNumber Then Return $lAgentArray[$i]
	Next
EndFunc   ;==>GetAgentByPlayerNumber


;~ Description: Returns the nearest signpost to an agent.
Func GetNearestSignpostToAgent($aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0x200)

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]
		$lDistance = (DllStructGetData($lAgentArray[$i], 'Y') - DllStructGetData($aAgent, 'Y')) ^ 2 + (DllStructGetData($lAgentArray[$i], 'X') - DllStructGetData($aAgent, 'X')) ^ 2
		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestSignpostToAgent

;~ Description: Returns the nearest signpost to a set of coordinates.
Func GetNearestSignpostToCoords($aX, $aY)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0x200)

	For $i = 1 To $lAgentArray[0]
		$lDistance = ($aX - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + ($aY - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2

		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestSignpostToCoords

;~ Description: Returns the nearest NPC to an agent.
Func GetNearestNPCToAgent($aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0xDB)

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 6 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop

		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestNPCToAgent

;~ Description: Returns the nearest NPC to a set of coordinates.
Func GetNearestNPCToCoords($aX, $aY)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0xDB)

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 6 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop

		$lDistance = ($aX - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + ($aY - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2

		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestNPCToCoords

;~ Description: Returns the nearest item to an agent.
Func GetNearestItemToAgent($aAgent = -2, $aCanPickUp = True)
	Local $lNearestAgent, $lNearestDistance = 1000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0x400)

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]

		If $aCanPickUp And Not GetCanPickUp($lAgentArray[$i]) Then ContinueLoop
		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestItemToAgent

;~ Description: Returns array of party members
;~ Param: an array returned by GetAgentArray. This is totally optional, but can greatly improve script speed.
Func GetParty($aAgentArray = 0)
	Local $lReturnArray[1] = [0]
	If $aAgentArray == 0 Then $aAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $aAgentArray[0]
		If DllStructGetData($aAgentArray[$i], 'Allegiance') == 1 Then
			If BitAND(DllStructGetData($aAgentArray[$i], 'TypeMap'), 131072) Then
				$lReturnArray[0] += 1
				ReDim $lReturnArray[$lReturnArray[0] + 1]
				$lReturnArray[$lReturnArray[0]] = $aAgentArray[$i]
			EndIf
		EndIf
	Next
	Return $lReturnArray
EndFunc   ;==>GetParty

;~ Description: Quickly creates an array of agents of a given type
Func GetAgentArray($aType = 0)
	Local $lStruct
	Local $lCount
	Local $lBuffer = ''
	DllStructSetData($mMakeAgentArray, 2, $aType)
	MemoryWrite($mAgentCopyCount, -1, 'long')
	Enqueue($mMakeAgentArrayPtr, 8)
	Local $lDeadlock = TimerInit()
	Do
		Sleep(1)
		$lCount = MemoryRead($mAgentCopyCount, 'long')
	Until $lCount >= 0 Or TimerDiff($lDeadlock) > 5000
	If $lCount < 0 Then $lCount = 0
	For $i = 1 To $lCount
		$lBuffer &= 'Byte[448];'
	Next
	$lBuffer = DllStructCreate($lBuffer)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $mAgentCopyBase, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Local $lReturnArray[$lCount + 1] = [$lCount]
	For $i = 1 To $lCount
		$lReturnArray[$i] = DllStructCreate('ptr vtable;byte unknown1[24];byte unknown2[4];ptr NextAgent;byte unknown3[8];long Id;float Z;byte unknown4[8];float BoxHoverWidth;float BoxHoverHeight;byte unknown5[8];float Rotation;byte unknown6[8];long NameProperties;byte unknown7[24];float X;float Y;byte unknown8[8];float NameTagX;float NameTagY;float NameTagZ;byte unknown9[12];long Type;float MoveX;float MoveY;byte unknown10[28];long Owner;byte unknown30[8];long ExtraType;byte unknown11[24];float AttackSpeed;float AttackSpeedModifier;word PlayerNumber;byte unknown12[6];ptr Equip;byte unknown13[10];byte Primary;byte Secondary;byte Level;byte Team;byte unknown14[6];float EnergyPips;byte unknown[4];float EnergyPercent;long MaxEnergy;byte unknown15[4];float HPPips;byte unknown16[4];float HP;long MaxHP;long Effects;byte unknown17[4];byte Hex;byte unknown18[18];long ModelState;long TypeMap;byte unknown19[16];long InSpiritRange;byte unknown20[16];long LoginNumber;float ModelMode;byte unknown21[4];long ModelAnimation;byte unknown22[32];byte LastStrike;byte Allegiance;word WeaponType;word Skill;byte unknown23[4];word WeaponItemId;word OffhandItemId')
		$lStruct = DllStructCreate('byte[448]', DllStructGetPtr($lReturnArray[$i]))
		DllStructSetData($lStruct, 1, DllStructGetData($lBuffer, $i))
	Next
	Return $lReturnArray
EndFunc   ;==>GetAgentArray

;~ Description Returns the "danger level" of each party member
;~ Param1: an array returned by GetAgentArray(). This is totally optional, but can greatly improve script speed.
;~ Param2: an array returned by GetParty() This is totally optional, but can greatly improve script speed.
Func GetPartyDanger($aAgentArray = 0, $aParty = 0)
	If $aAgentArray == 0 Then $aAgentArray = GetAgentArray(0xDB)
	If $aParty == 0 Then $aParty = GetParty($aAgentArray)

	Local $lReturnArray[$aParty[0] + 1]
	$lReturnArray[0] = $aParty[0]
	For $i = 1 To $lReturnArray[0]
		$lReturnArray[$i] = 0
	Next

	For $i = 1 To $aAgentArray[0]
		If BitAND(DllStructGetData($aAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop
		If DllStructGetData($aAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If Not GetIsLiving($aAgentArray[$i]) Then ContinueLoop
		If DllStructGetData($aAgentArray[$i], "Allegiance") > 3 Then ContinueLoop ; ignore NPCs, spirits, minions, pets

		For $j = 1 To $aParty[0]
			If GetTarget(DllStructGetData($aAgentArray[$i], "ID")) == DllStructGetData($aParty[$j], "ID") Then
				If GetDistance($aAgentArray[$i], $aParty[$j]) < 5000 Then
					If DllStructGetData($aAgentArray[$i], "Team") <> 0 Then
						If DllStructGetData($aAgentArray[$i], "Team") <> DllStructGetData($aParty[$j], "Team") Then
							$lReturnArray[$j] += 1
						EndIf
					ElseIf DllStructGetData($aAgentArray[$i], "Allegiance") <> DllStructGetData($aParty[$j], "Allegiance") Then
						$lReturnArray[$j] += 1
					EndIf
				EndIf
			EndIf
		Next
	Next
	Return $lReturnArray
EndFunc   ;==>GetPartyDanger
;~ Description: Return the number of enemy agents targeting the given agent.
Func GetAgentDanger($aAgent = -2, $aAgentArray = 0)
	If IsDllStruct($aAgent) = 0 Then
		$aAgent = GetAgentByID($aAgent)
	EndIf

	Local $lCount = 0

	If $aAgentArray == 0 Then $aAgentArray = GetAgentArray(0xDB)

	For $i = 1 To $aAgentArray[0]
		If BitAND(DllStructGetData($aAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop
		If DllStructGetData($aAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If Not GetIsLiving($aAgentArray[$i]) Then ContinueLoop
		If DllStructGetData($aAgentArray[$i], "Allegiance") > 3 Then ContinueLoop ; ignore NPCs, spirits, minions, pets
		If GetTarget(DllStructGetData($aAgentArray[$i], "ID")) == DllStructGetData($aAgent, "ID") Then
			If GetDistance($aAgentArray[$i], $aAgent) < 5000 Then
				If DllStructGetData($aAgentArray[$i], "Team") <> 0 Then
					If DllStructGetData($aAgentArray[$i], "Team") <> DllStructGetData($aAgent, "Team") Then
						$lCount += 1
					EndIf
				ElseIf DllStructGetData($aAgentArray[$i], "Allegiance") <> DllStructGetData($aAgent, "Allegiance") Then
					$lCount += 1
				EndIf
			EndIf
		EndIf
	Next
	Return $lCount
EndFunc   ;==>GetAgentDanger
#EndRegion Agent

#Region AgentInfo
;~ Description: Tests if an agent is living.
Func GetIsLiving($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'Type') = 0xDB
EndFunc   ;==>GetIsLiving

;~ Description: Tests if an agent is a signpost/chest/etc.
Func GetIsStatic($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'Type') = 0x200
EndFunc   ;==>GetIsStatic

;~ Description: Tests if an agent is an item.
Func GetIsMovable($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'Type') = 0x400
EndFunc   ;==>GetIsMovable

;~ Description: Returns energy of an agent. (Only self/heroes)
Func GetEnergy($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'EnergyPercent') * DllStructGetData($aAgent, 'MaxEnergy')
EndFunc   ;==>GetEnergy

;~ Description: Returns health of an agent. (Must have caused numerical change in health)
Func GetHealth($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'HP') * DllStructGetData($aAgent, 'MaxHP')
EndFunc   ;==>GetHealth

;~ Description: Tests if an agent is moving.
Func GetIsMoving($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	If DllStructGetData($aAgent, 'MoveX') <> 0 Or DllStructGetData($aAgent, 'MoveY') <> 0 Then Return True
	Return False
EndFunc   ;==>GetIsMoving

;~ Description: Tests if an agent is knocked down.
Func GetIsKnocked($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'ModelState') = 0x450
EndFunc   ;==>GetIsKnocked

;~ Description: Tests if an agent is attacking.
Func GetIsAttacking($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Switch DllStructGetData($aAgent, 'ModelState')
		Case 0x60 ; Is Attacking
			Return True
		Case 0x440 ; Is Attacking
			Return True
		Case 0x460 ; Is Attacking
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>GetIsAttacking

;~ Description: Tests if an agent is casting.
Func GetIsCasting($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return DllStructGetData($aAgent, 'Skill') <> 0
EndFunc   ;==>GetIsCasting

;~ Description: Tests if an agent is bleeding.
Func GetIsBleeding($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'Effects'), 0x0001) > 0
EndFunc   ;==>GetIsBleeding

;~ Description: Tests if an agent has a condition.
Func GetHasCondition($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'Effects'), 0x0002) > 0
EndFunc   ;==>GetHasCondition

;~ Description: Tests if an agent is dead.
Func GetIsDead($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'Effects'), 0x0010) > 0
EndFunc   ;==>GetIsDead

;~ Description: Tests if an agent has a deep wound.
Func GetHasDeepWound($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'Effects'), 0x0020) > 0
EndFunc   ;==>GetHasDeepWound

;~ Description: Tests if an agent is poisoned.
Func GetIsPoisoned($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'Effects'), 0x0040) > 0
EndFunc   ;==>GetIsPoisoned

;~ Description: Tests if an agent is enchanted.
Func GetIsEnchanted($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'Effects'), 0x0080) > 0
EndFunc   ;==>GetIsEnchanted

;~ Description: Tests if an agent has a degen hex.
Func GetHasDegenHex($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'Effects'), 0x0400) > 0
EndFunc   ;==>GetHasDegenHex

;~ Description: Tests if an agent is hexed.
Func GetHasHex($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'Effects'), 0x0800) > 0
EndFunc   ;==>GetHasHex

;~ Description: Tests if an agent has a weapon spell.
Func GetHasWeaponSpell($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'Effects'), 0x8000) > 0
EndFunc   ;==>GetHasWeaponSpell

;~ Description: Tests if an agent is a boss.
Func GetIsBoss($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'TypeMap'), 1024) > 0
EndFunc   ;==>GetIsBoss

;~ Description: Returns a player's name.
Func GetPlayerName($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Local $lLogin = DllStructGetData($aAgent, 'LoginNumber')
	Local $lOffset[6] = [0, 0x18, 0x2C, 0x80C, 76 * $lLogin + 0x28, 0]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset, 'wchar[30]')
	Return $lReturn[1]
EndFunc   ;==>GetPlayerName

;~ Description: Returns the name of an agent.
Func GetAgentName($aAgent = -2)
	If $mUseStringLog = False Then Return

	If IsDllStruct($aAgent) = 0 Then
		Local $lAgentID = ConvertID($aAgent)
		If $lAgentID = 0 Then Return ''
	Else
		Local $lAgentID = DllStructGetData($aAgent, 'ID')
	EndIf

	Local $lAddress = $mStringLogBase + 256 * $lAgentID
	Local $lName = MemoryRead($lAddress, 'wchar [128]')

	If $lName = '' Then
		DisplayAll(True)
		Sleep(100)
		DisplayAll(False)
	EndIf

	Local $lName = MemoryRead($lAddress, 'wchar [128]')
	$lName = StringRegExpReplace($lName, '[<]{1}([^>]+)[>]{1}', '')
	Return $lName
EndFunc   ;==>GetAgentName

;~ Description: Returns the distance between two coordinate pairs.
Func ComputeDistance($aX1, $aY1, $aX2, $aY2)
	Return Sqrt(($aX1 - $aX2) ^ 2 + ($aY1 - $aY2) ^ 2)
EndFunc   ;==>ComputeDistance

;~ Description: Returns the distance between two agents.
Func GetDistance($aAgent1 = -1, $aAgent2 = -2)
	If IsDllStruct($aAgent1) = 0 Then $aAgent1 = GetAgentByID($aAgent1)
	If IsDllStruct($aAgent2) = 0 Then $aAgent2 = GetAgentByID($aAgent2)
	Return Sqrt((DllStructGetData($aAgent1, 'X') - DllStructGetData($aAgent2, 'X')) ^ 2 + (DllStructGetData($aAgent1, 'Y') - DllStructGetData($aAgent2, 'Y')) ^ 2)
EndFunc   ;==>GetDistance

;~ Description: Return the square of the distance between two agents.
Func GetPseudoDistance($aAgent1, $aAgent2)
	Return (DllStructGetData($aAgent1, 'X') - DllStructGetData($aAgent2, 'X')) ^ 2 + (DllStructGetData($aAgent1, 'Y') - DllStructGetData($aAgent2, 'Y')) ^ 2
EndFunc   ;==>GetPseudoDistance

;~ Description: Checks if a point is within a polygon defined by an array
Func GetIsPointInPolygon($aAreaCoords, $aPosX = 0, $aPosY = 0)
	Local $lPosition
	Local $lEdges = UBound($aAreaCoords)
	Local $lOddNodes = False
	If $lEdges < 3 Then Return False
	If $aPosX = 0 Then
		Local $lAgent = GetAgentByID(-2)
		$aPosX = DllStructGetData($lAgent, 'X')
		$aPosY = DllStructGetData($lAgent, 'Y')
	EndIf
	$j = $lEdges - 1
	For $i = 0 To $lEdges - 1
		If (($aAreaCoords[$i][1] < $aPosY And $aAreaCoords[$j][1] >= $aPosY) _
				Or ($aAreaCoords[$j][1] < $aPosY And $aAreaCoords[$i][1] >= $aPosY)) _
				And ($aAreaCoords[$i][0] <= $aPosX Or $aAreaCoords[$j][0] <= $aPosX) Then
			If ($aAreaCoords[$i][0] + ($aPosY - $aAreaCoords[$i][1]) / ($aAreaCoords[$j][1] - $aAreaCoords[$i][1]) * ($aAreaCoords[$j][0] - $aAreaCoords[$i][0]) < $aPosX) Then
				$lOddNodes = Not $lOddNodes
			EndIf
		EndIf
		$j = $i
	Next
	Return $lOddNodes
EndFunc   ;==>GetIsPointInPolygon
#EndRegion AgentInfo

