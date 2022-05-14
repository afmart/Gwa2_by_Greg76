;~ Description: Returns array with itemIDs of Items in Bags with correct ModelID.
Func GetBagItemIDByModelID($aModelID)
	Local $lRetArr[291][3]
	Local $lCount = 0
	For $bag = 1 To 17
		Local $lBagPtr = GetBagPtr($bag)
		Local $lSlots = MemoryRead($lBagPtr + 32, 'long')
		For $slot = 1 To $lSlots
			Local $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
			Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
			If $lItemMID = $aModelID Then
				Local $lItemID = MemoryRead($lItemPtr, 'long')
				$lRetArr[$lCount][0] = $lItemID
				$lRetArr[$lCount][1] = $bag
				$lRetArr[$lCount][2] = $slot
				$lCount += 1
			EndIf
		Next
	Next
	ReDim $lRetArr[$lCount][3]
	Return $lItemID
EndFunc   ;==>GetBagItemIDByModelID

Func GetBagPtr($aBagNumber)
	Local $lOffset[5] = [0, 0x18, 0x40, 0xF8, 0x4 * $aBagNumber]
	Local $lItemStructAddress = MemoryReadPtr($mBasePointer, $lOffset, 'ptr')
	Return $lItemStructAddress[1]
EndFunc   ;==>GetBagPtr

Func GetItemPtrBySlot($aBag, $aSlot)
	If IsPtr($aBag) Then
		$lBagPtr = $aBag
	Else
		If $aBag < 1 Or $aBag > 17 Then Return 0
		If $aSlot < 1 Or $aSlot > GetMaxSlots($aBag) Then Return 0
		Local $lBagPtr = GetBagPtr($aBag)
	EndIf
	Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	Return MemoryRead($lItemArrayPtr + 4 * ($aSlot - 1), 'ptr')
EndFunc   ;==>GetItemPtrBySlot

;~ Description: Returns amount of slots of bag.
Func GetMaxSlots($aBag)
	If IsPtr($aBag) Then
		Return MemoryRead($aBag + 32, 'long')
	Else
		Return MemoryRead(GetBagPtr($aBag) + 32, 'long')
	EndIf
EndFunc   ;==>GetMaxSlots

Func CountItemInBagsByModelID($ItemModelID)
	Local Enum $BAG_Backpack = 1, $BAG_BeltPouch, $BAG_Bag1, $BAG_Bag2, $BAG_EquipmentPack, $BAG_UnclaimedItems = 7, $BAG_Storage1, $BAG_Storage2, _
			$BAG_Storage3, $BAG_Storage4, $BAG_Storage5, $BAG_Storage6, $BAG_Storage7, $BAG_Storage8, $BAG_StorageAnniversary
	$Count = 0
	For $i = $BAG_Backpack To $BAG_Bag2
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItemInfo = GetItemBySlot($i, $j)
			If DllStructGetData($lItemInfo, 'ModelID') = $ItemModelID Then $Count += DllStructGetData($lItemInfo, 'quantity')
		Next
	Next
	Return $Count
EndFunc   ;==>CountItemInBagsByModelID
