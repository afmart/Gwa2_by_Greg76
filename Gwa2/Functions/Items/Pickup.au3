#Region PickupLoot
Func EventPickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If EventCanPickUp($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
 EndFunc   ;==>PickUpLoot

; Checks if should pick up the given Item. Returns True or False
Func EventCanPickUp($aItem)
   $CurGold = GetGoldCharacter()
   GUICtrlSetData($Goldies, "Current Gold: " & $CurGold)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $aExtraID = DllStructGetData($aItem, "ExtraID")
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	$CurGold = GetGoldCharacter()
	If (($lModelID == 2511) And (GetGoldCharacter() < 99000)) Then
		Return True	; Gold coins (only pick if Character has less than 99k in inventory)
	 ElseIf ($lModelID == 21797) Then ; Mesmer Tomes
		If GUICtrlRead($Tomes) = 1 Then
			Return True
	    Else
			Return False
	    EndIf
	ElseIf ($lModelID == $Dye) Then	; if dye
		If (($aExtraID == $Black_Dye_ExtraID) Or ($aExtraID == $White_Dye_ExtraID))Then ; only pick white and black ones
			Return True
		EndIf
	  ElseIf($lModelID == $Lockpick)Then
		Return True ; Lockpicks
	ElseIf($lModelID == $ITEM_ID_Glacial_Stone)Then
		Return True ; glacial stones
	ElseIf CheckArrayPscon($lModelID)Then ; ==== Pcons ==== or all event Items
		Return True
    ElseIf (($lModelID == 24629) Or ($lModelID == 24630) Or ($lModelID == 24631) Or ($lModelID == 24632))Then ; Map pieces
		If GUICtrlRead($MapPieces) = 1 Then
			Return True
	    Else
			Return False
	    EndIf
    ElseIf ($lRarity == $Rarity_Gold) Then ; Gold Items
		Return False
	ElseIf ($lRarity == $Rarity_Purple) Then ; purple Items
		Return false
	ElseIf ($lRarity == $Rarity_White) Then ; White Items
		If GUICtrlRead($White_Pickup) = 1 Then
			Return True
	    Else
			Return False
	    EndIf
    ElseIf ($lRarity == $Rarity_Blue) Then ; Blue Items
		Return false
    Else
		Return False
	EndIf
EndFunc   ;==>CanPickUp

;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID
Func PickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
		If CountSlots() < 1 Then Return ;full inventory dont try to pick up
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickUp($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
EndFunc   ;==>PickUpLoot

; Checks if should pick up the given item. Returns True or False
Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelId')
	Local $aExtraID = DllStructGetData($aItem, 'ExtraId')
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	If ($lModelID == 2511) Then
		If (GetGoldCharacter() < 99000) Then
			Return True	; gold coins (only pick if character has less than 99k in inventory)
		Else
			Return False
		EndIf
	ElseIf ($lModelID == $Dye) Then	; if dye
		If (($aExtraID == $Black_Dye_ExtraID) Or ($aExtraID == $White_Dye_ExtraID)) Then ; only pick white and black ones
			Return True
		EndIf
	ElseIf ($lRarity == $RARITY_Gold) Then ; gold items
		Return True

	ElseIf($lModelID == $Lockpick) Then
		Return True ; Lockpicks
	ElseIf($lModelID == $ITEM_ID_Glacial_Stone) Then
		Return True ; glacial stones
	ElseIf CheckArrayPscon($lModelID) Then ; ==== Pcons ==== or all event items
		Return True
	ElseIf CheckArrayMapPieces($lModelID) Then ; ==== Map Pieces ====
		Return $PickUpMapPieces
	ElseIf ($lRarity == $RARITY_White) And $PickUpAll Then ; White items
		Return False
	Else
		Return False
	EndIf
EndFunc   ;==>CanPickUp
#EndRegion PickupLoot