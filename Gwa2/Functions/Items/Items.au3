#Region Item
;~ Description: Starts a salvaging session of an item.
Func StartSalvage($aItem)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x690]
	Local $lSalvageSessionID = MemoryReadPtr($mBasePointer, $lOffset)

	If IsDllStruct($aItem) = 0 Then
		Local $lItemID = $aItem
	Else
		Local $lItemID = DllStructGetData($aItem, 'ID')
	EndIf

	Local $lSalvageKit = FindSalvageKit()
	If $lSalvageKit = 0 Then Return

	DllStructSetData($mSalvage, 2, $lItemID)
	DllStructSetData($mSalvage, 3, FindSalvageKit())
	DllStructSetData($mSalvage, 4, $lSalvageSessionID[1])

	Enqueue($mSalvagePtr, 16)
EndFunc   ;==>StartSalvage

;~ Description: Salvage the materials out of an item.
Func SalvageMaterials()
	Return SendPacket(0x4, $HEADER_SALVAGE_MATS)
EndFunc   ;==>SalvageMaterials

;~ Description: Salvages a mod out of an item.
Func SalvageMod($aModIndex)
	Return SendPacket(0x8, $HEADER_SALVAGE_MODS, $aModIndex)
EndFunc   ;==>SalvageMod

;~ Description: Identifies an item.
Func IdentifyItem($aItem)
	If GetIsIDed($aItem) Then Return

	Local $lItemID
	If IsDllStruct($aItem) = 0 Then
		$lItemID = $aItem
	Else
		$lItemID = DllStructGetData($aItem, 'ID')
	EndIf

	Local $lIDKit = FindIDKit()
	If $lIDKit == 0 Then Return

	SendPacket(0xC, $HEADER_ITEM_ID, $lIDKit, $lItemID)

	Local $lDeadlock = TimerInit()
	Do
		Sleep(20)
	Until GetIsIDed($lItemID) Or TimerDiff($lDeadlock) > 5000
	If Not GetIsIDed($lItemID) Then IdentifyItem($aItem)
EndFunc   ;==>IdentifyItem

;~ Description: Identifies all items in a bag.
Func IdentifyBag($aBag, $aWhites = False, $aGolds = True)
	Local $lItem
	If Not IsDllStruct($aBag) Then $aBag = GetBag($aBag)
	For $i = 1 To DllStructGetData($aBag, 'Slots')
		$lItem = GetItemBySlot($aBag, $i)
		If DllStructGetData($lItem, 'ID') == 0 Then ContinueLoop
		If GetRarity($lItem) == 2621 And $aWhites == False Then ContinueLoop
		If GetRarity($lItem) == 2624 And $aGolds == False Then ContinueLoop
		IdentifyItem($lItem)
		Sleep(GetPing())
	Next
EndFunc   ;==>IdentifyBag

;~ Description: Equips an item.
Func EquipItem($aItem)
	Local $lItemID

	If IsDllStruct($aItem) = 0 Then
		$lItemID = $aItem
	Else
		$lItemID = DllStructGetData($aItem, 'ID')
	EndIf

	Return SendPacket(0x8, $HEADER_ITEM_EQUIP, $lItemID)
EndFunc   ;==>EquipItem

;~ Description: Uses an item.
Func UseItem($aItem)
	Local $lItemID

	If IsDllStruct($aItem) = 0 Then
		$lItemID = $aItem
	Else
		$lItemID = DllStructGetData($aItem, 'ID')
	EndIf

	Return SendPacket(0x8, $HEADER_ITEM_USE, $lItemID)
EndFunc   ;==>UseItem

;~ Description: Picks up an item.
Func PickUpItem($aItem)
	Local $lAgentID

	If IsDllStruct($aItem) = 0 Then
		$lAgentID = $aItem
	ElseIf DllStructGetSize($aItem) < 400 Then
		$lAgentID = DllStructGetData($aItem, 'AgentID')
	Else
		$lAgentID = DllStructGetData($aItem, 'ID')
	EndIf

	Return SendPacket(0xC, $HEADER_ITEM_PICKUP, $lAgentID, 0)
EndFunc   ;==>PickUpItem

;~ Description: Drops an item.
Func DropItem($aItem, $aAmount = 0)
	Local $lItemID, $lAmount

	If IsDllStruct($aItem) = 0 Then
		$lItemID = $aItem
		If $aAmount > 0 Then
			$lAmount = $aAmount
		Else
			$lAmount = DllStructGetData(GetItemByItemID($aItem), 'Quantity')
		EndIf
	Else
		$lItemID = DllStructGetData($aItem, 'ID')
		If $aAmount > 0 Then
			$lAmount = $aAmount
		Else
			$lAmount = DllStructGetData($aItem, 'Quantity')
		EndIf
	EndIf

	Return SendPacket(0xC, $HEADER_ITEM_DROP, $lItemID, $lAmount)
EndFunc   ;==>DropItem

;~ Description: Moves an item.
Func MoveItem($aItem, $aBag, $aSlot)
	Local $lItemID, $lBagID

	If IsDllStruct($aItem) = 0 Then
		$lItemID = $aItem
	Else
		$lItemID = DllStructGetData($aItem, 'ID')
	EndIf

	If IsDllStruct($aBag) = 0 Then
		$lBagID = DllStructGetData(GetBag($aBag), 'ID')
	Else
		$lBagID = DllStructGetData($aBag, 'ID')
	EndIf

	Return SendPacket(0x10, $HEADER_ITEM_MOVE, $lItemID, $lBagID, $aSlot - 1)
EndFunc   ;==>MoveItem

;~ Description: Accepts unclaimed items after a mission.
Func AcceptAllItems()
	Return SendPacket(0x8, $HEADER_ITEMS_ACCEPT_UNCLAIMED, DllStructGetData(GetBag(7), 'ID'))
EndFunc   ;==>AcceptAllItems

;~ Description: Sells an item.
Func SellItem($aItem, $aQuantity = 0)
	If IsDllStruct($aItem) = 0 Then $aItem = GetItemByItemID($aItem)
	If $aQuantity = 0 Or $aQuantity > DllStructGetData($aItem, 'Quantity') Then $aQuantity = DllStructGetData($aItem, 'Quantity')

	DllStructSetData($mSellItem, 2, $aQuantity * DllStructGetData($aItem, 'Value'))
	DllStructSetData($mSellItem, 3, DllStructGetData($aItem, 'ID'))
	DllStructSetData($mSellItem, 4, MemoryRead(GetScannedAddress('ScanBuyItemBase', 15)))
	Enqueue($mSellItemPtr, 16)
EndFunc   ;==>SellItem

;~ Description: Buys an item.
Func BuyItem($aItem, $aQuantity, $aValue)
	Local $lMerchantItemsBase = GetMerchantItemsBase()

	If Not $lMerchantItemsBase Then Return
	If $aItem < 1 Or $aItem > GetMerchantItemsSize() Then Return

	DllStructSetData($mBuyItem, 2, $aQuantity)
	DllStructSetData($mBuyItem, 3, MemoryRead($lMerchantItemsBase + 4 * ($aItem - 1)))
	DllStructSetData($mBuyItem, 4, $aQuantity * $aValue)
	DllStructSetData($mBuyItem, 5, MemoryRead(GetScannedAddress('ScanBuyItemBase', 15)))
	Enqueue($mBuyItemPtr, 20)
EndFunc   ;==>BuyItem

;~ Description: Buys an ID kit.
Func BuyIDKit()
	BuyItem(5, 1, 100)
EndFunc   ;==>BuyIDKit

;~ Description: Buys a superior ID kit.
Func BuySuperiorIDKit()
	BuyItem(6, 1, 500)
EndFunc   ;==>BuySuperiorIDKit

Func CraftItemEx($aModelID, $aQuantity, $aGold, ByRef $aMatsArray)
	Local $pSrcItem = GetInventoryItemPtrByModelId($aMatsArray[0][0])
	If ((Not $pSrcItem) Or (MemoryRead($pSrcItem + 0x4B) < $aMatsArray[0][1])) Then Return 0
	Local $pDstItem = MemoryRead(GetMerchantItemPtrByModelId($aModelID))
	If (Not $pDstItem) Then Return 0
	Local $lMatString = ''
	Local $lMatCount = 0
	If IsArray($aMatsArray) = 0 Then Return 0 ; mats are not in an array
	Local $lMatsArraySize = UBound($aMatsArray) - 1
	For $i = $lMatsArraySize To 0 Step -1
		$lCheckQuantity = CountItemInBagsByModelID($aMatsArray[$i][0])
		If $aMatsArray[$i][1] * $aQuantity > $lCheckQuantity Then ; not enough mats in inventory
			Return SetExtended($aMatsArray[$i][1] * $aQuantity - $lCheckQuantity, $aMatsArray[$i][0]) ; amount of missing mats in @extended
		EndIf
	Next
	$lCheckGold = GetGoldCharacter()
;~ 	out($lMatsArraySize)

	For $i = 0 To $lMatsArraySize
		$lMatString &= GetItemIDfromMobelID($aMatsArray[$i][0]) & ';';GetCraftMatsString($aMatsArray[$i][0], $aQuantity * $aMatsArray[$i][1])
		out($lMatString)
		$lMatCount += 1 ;@extended
;~ 		out($lMatCount)
	Next

	$CraftMatsType = 'dword'
	For $i = 1 To $lMatCount - 1
		$CraftMatsType &= ';dword'
	Next
	$CraftMatsBuffer = DllStructCreate($CraftMatsType)
	$CraftMatsPointer = DllStructGetPtr($CraftMatsBuffer)
	For $i = 1 To $lMatCount
		$lSize = StringInStr($lMatString, ';')
;~ 		out("Mat: " & StringLeft($lMatString, $lSize - 1))
		DllStructSetData($CraftMatsBuffer, $i, StringLeft($lMatString, $lSize - 1))
		$lMatString = StringTrimLeft($lMatString, $lSize)
	Next
	Local $lMemSize = $lMatCount * 4
	Local $lBufferMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $lMemSize, 'dword', 0x1000, 'dword', 0x40)
	If $lBufferMemory = 0 Then Return 0 ; couldnt allocate enough memory
	Local $lBuffer = DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lBufferMemory[0], 'ptr', $CraftMatsPointer, 'int', $lMemSize, 'int', '')
	If $lBuffer = 0 Then Return
;~ 	Out($lBuffer[0] & " " & $lBuffer[1] & " " & $lBuffer[2] & " " & $lBuffer[3] & " " & $lBuffer[4] & " " & $lBuffer[5])
	DllStructSetData($mCraftItemEx, 1, GetValue('CommandCraftItemEx'))
	DllStructSetData($mCraftItemEx, 2, $aQuantity)
;~ 	Out($aQuantity)
;~     Sleep(3000)
	DllStructSetData($mCraftItemEx, 3, $pDstItem)
;~ 	Out($pDstItem)
;~     Sleep(3000)
	DllStructSetData($mCraftItemEx, 4, $lBufferMemory[0])
	Out($lBufferMemory[0])
;~     Sleep(3000)
	DllStructSetData($mCraftItemEx, 5, $lMatCount)
	Out($lMatCount)
;~     Sleep(3000)
	DllStructSetData($mCraftItemEx, 6, $aQuantity * $aGold)
	Out($aQuantity * $aGold)
;~     Sleep(3000)
	Enqueue($mCraftItemExPtr, 24)
	$lDeadlock = TimerInit()
	Do
		Sleep(250)
		$lCurrentQuantity = CountItemInBagsByModelID($aMatsArray[0][0])
	Until $lCurrentQuantity <> $lCheckQuantity Or $lCheckGold <> GetGoldCharacter() Or TimerDiff($lDeadlock) > 5000
	DllCall($mKernelHandle, 'ptr', 'VirtualFreeEx', 'handle', $mGWProcHandle, 'ptr', $lBufferMemory[0], 'int', 0, 'dword', 0x8000)
	Return SetExtended($lCheckQuantity - $lCurrentQuantity - $aMatsArray[0][1] * $aQuantity, True) ; should be zero if items were successfully crafter
EndFunc   ;==>CraftItemEx

Func GetCraftMatsString($aModelID, $aAmount)
	Local $lCount = 0
	Local $lQuantity = 0
	Local $lMatString = ''
	For $bag = 1 To 4
		$lBagPtr = GetBagPtr($bag)
		If $lBagPtr = 0 Then ContinueLoop ; no valid bag
		For $slot = 1 To MemoryRead($lBagPtr + 32, 'long')
			$lSlotPtr = GetItemPtrBySlot($lBagPtr, $slot)
			If $lSlotPtr = 0 Then ContinueLoop ; empty slot
			If MemoryRead($lSlotPtr + 44, 'long') = $aModelID Then
				$lMatString &= MemoryRead($lSlotPtr, 'long') & ';'
				$lCount += 1
				$lQuantity += MemoryRead($lSlotPtr + 75, 'byte')
				If $lQuantity >= $aAmount Then
					Return SetExtended($lCount, $lMatString)
				EndIf
			EndIf
		Next
	Next
EndFunc   ;==>GetCraftMatsString

Func GetItemIDfromMobelID($aModelID)
	For $i = 1 To 4
		For $j = 1 To DllStructGetData(GetBag($i), 'slots')
			Local $item = GetItemBySlot($i, $j)
			If DllStructGetData($item, 'ModelId') == $aModelID Then Return DllStructGetData($item, 'Id')
		Next
	Next
EndFunc   ;==>GetItemIDfromMobelID

Func GetMerchantItemPtrByModelId($nModelId)
	Local $aOffsets[5] = [0, 0x18, 0x40, 0xB8]
	Local $pMerchantBase = GetMerchantItemsBase()
	Local $nItemId = 0
	Local $nItemPtr = 0

	For $i = 0 To GetMerchantItemsSize() -1
		$nItemId = MemoryRead($pMerchantBase + 4 * $i)

		If ($nItemId) Then
			$aOffsets[4] = 4 * $nItemId
			$nItemPtr = MemoryReadPtr($mBasePointer, $aOffsets)[1]

			If (MemoryRead($nItemPtr + 0x2C) = $nModelId) Then
				Return Ptr($nItemPtr)
			EndIf
		EndIf
	Next
EndFunc   ;==>GetMerchantItemPtrByModelId

Func GetInventoryItemPtrByModelId($nModelId)
	Local $aOffsets[5] = [0, 0x18, 0x40, 0xF8]
	Local $pItemArray = 0
	Local $pBagStruct = 0
	Local $pItemStruct = 0

	For $i = 1 To 4
		$aOffsets[4] = 4 * $i
		$pBagStruct = MemoryReadPtr($mBasePointer, $aOffsets)[1]
		$pItemArray = MemoryRead($pBagStruct + 0x18)

		For $j = 0 To MemoryRead($pBagStruct + 0x20) - 1
			$pItemStruct = MemoryRead($pItemArray + 4 * $j)

			If (($pItemStruct) And (MemoryRead($pItemStruct + 0x2C) = $nModelId)) Then
				Return Ptr($pItemStruct)
			EndIf
		Next
	Next
EndFunc   ;==>GetInventoryItemPtrByModelId

;~ Description: Request a quote to buy an item from a trader. Returns true if successful.
Func TraderRequest($aModelID, $aExtraID = -1)
	Local $lItemStruct = DllStructCreate('long Id;long AgentId;byte Unknown1[4];ptr Bag;ptr ModStruct;long ModStructSize;ptr Customized;byte unknown2[4];byte Type;byte unknown4;short ExtraId;short Value;byte unknown4[2];short Interaction;long ModelId;ptr ModString;byte unknown5[4];ptr NameString;ptr SingleItemName;byte Unknown4[10];byte IsSalvageable;byte Unknown6;byte Quantity;byte Equiped;byte Profession;byte Type2;byte Slot')

	Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
	Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
	Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0]
	Local $lItemPtr, $lItemID
	Local $lFound = False
	Local $lQuoteID = MemoryRead($mTraderQuoteID)

	For $lItemID = 1 To $lItemArraySize[1]
		$lOffset[4] = 0x4 * $lItemID
		$lItemPtr = MemoryReadPtr($mBasePointer, $lOffset)
		If $lItemPtr[1] = 0 Then ContinueLoop

		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lItemPtr[1], 'ptr', DllStructGetPtr($lItemStruct), 'int', DllStructGetSize($lItemStruct), 'int', '')
		If DllStructGetData($lItemStruct, 'ModelID') = $aModelID And DllStructGetData($lItemStruct, 'bag') = 0 And DllStructGetData($lItemStruct, 'AgentID') == 0 Then
			If $aExtraID = -1 Or DllStructGetData($lItemStruct, 'ExtraID') = $aExtraID Then
				$lFound = True
				ExitLoop
			EndIf
		EndIf
	Next
	If Not $lFound Then Return False

	DllStructSetData($mRequestQuote, 2, DllStructGetData($lItemStruct, 'ID'))
	Enqueue($mRequestQuotePtr, 8)

	Local $lDeadlock = TimerInit()
	$lFound = False
	Do
		Sleep(20)
		$lFound = MemoryRead($mTraderQuoteID) <> $lQuoteID
	Until $lFound Or TimerDiff($lDeadlock) > GetPing() + 5000
	Return $lFound
EndFunc   ;==>TraderRequest

;~ Description: Buy the requested item.
Func TraderBuy()
	If Not GetTraderCostID() Or Not GetTraderCostValue() Then Return False
	Enqueue($mTraderBuyPtr, 4)
	Return True
EndFunc   ;==>TraderBuy

;~ Description: Request a quote to sell an item to the trader.
Func TraderRequestSell($aItem)
	Local $lItemID
	Local $lFound = False
	Local $lQuoteID = MemoryRead($mTraderQuoteID)

	If IsDllStruct($aItem) = 0 Then
		$lItemID = $aItem
	Else
		$lItemID = DllStructGetData($aItem, 'ID')
	EndIf

	DllStructSetData($mRequestQuoteSell, 2, $lItemID)
	Enqueue($mRequestQuoteSellPtr, 8)

	Local $lDeadlock = TimerInit()
	Do
		Sleep(20)
		$lFound = MemoryRead($mTraderQuoteID) <> $lQuoteID
	Until $lFound Or TimerDiff($lDeadlock) > GetPing() + 5000
	Return $lFound
EndFunc   ;==>TraderRequestSell

;~ Description: ID of the item item being sold.
Func TraderSell()
	If Not GetTraderCostID() Or Not GetTraderCostValue() Then Return False
	Enqueue($mTraderSellPtr, 4)
	Return True
EndFunc   ;==>TraderSell

;~ Description: Drop gold on the ground.
Func DropGold($aAmount = 0)
	Local $lAmount

	If $aAmount > 0 Then
		$lAmount = $aAmount
	Else
		$lAmount = GetGoldCharacter()
	EndIf

	Return SendPacket(0x8, $HEADER_GOLD_DROP, $lAmount)
EndFunc   ;==>DropGold

;~ Description: Deposit gold into storage.
Func DepositGold($aAmount = 0)
	Local $lAmount
	Local $lStorage = GetGoldStorage()
	Local $lCharacter = GetGoldCharacter()

	If $aAmount > 0 And $lCharacter >= $aAmount Then
		$lAmount = $aAmount
	Else
		$lAmount = $lCharacter
	EndIf

	If $lStorage + $lAmount > 1000000 Then $lAmount = 1000000 - $lStorage

	ChangeGold($lCharacter - $lAmount, $lStorage + $lAmount)
EndFunc   ;==>DepositGold

;~ Description: Withdraw gold from storage.
Func WithdrawGold($aAmount = 0)
	Local $lAmount
	Local $lStorage = GetGoldStorage()
	Local $lCharacter = GetGoldCharacter()

	If $aAmount > 0 And $lStorage >= $aAmount Then
		$lAmount = $aAmount
	Else
		$lAmount = $lStorage
	EndIf

	If $lCharacter + $lAmount > 100000 Then $lAmount = 100000 - $lCharacter

	ChangeGold($lCharacter + $lAmount, $lStorage - $lAmount)
EndFunc   ;==>WithdrawGold

;~ Description: Internal use for moving gold.
Func ChangeGold($aCharacter, $aStorage)
	Return SendPacket(0xC, $HEADER_CHANGE_GOLD, $aCharacter, $aStorage) ;0x75
 EndFunc   ;==>ChangeGold
#EndRegion Item

#Region Item
;~ Description: Returns rarity (name color) of an item.
Func GetRarity($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lPtr = DllStructGetData($aItem, 'NameString')
	If $lPtr == 0 Then Return
	Return MemoryRead($lPtr, 'ushort')
EndFunc   ;==>GetRarity

;~ Description: Tests if an item is identified.
Func GetIsIDed($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Return BitAND(DllStructGetData($aItem, 'interaction'), 1) > 0
EndFunc   ;==>GetIsIDed

;~ Description: Returns a weapon or shield's minimum required attribute.
Func GetItemReq($aItem)
	Local $lMod = GetModByIdentifier($aItem, "9827")
	Return $lMod[0]
EndFunc   ;==>GetItemReq

;~ Description: Returns a weapon or shield's required attribute.
Func GetItemAttribute($aItem)
	Local $lMod = GetModByIdentifier($aItem, "9827")
	Return $lMod[1]
EndFunc   ;==>GetItemAttribute

;~ Description: Returns an array of a the requested mod.
Func GetModByIdentifier($aItem, $aIdentifier)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lReturn[2]
	Local $lString = StringTrimLeft(GetModStruct($aItem), 2)
	For $i = 0 To StringLen($lString) / 8 - 2
		If StringMid($lString, 8 * $i + 5, 4) == $aIdentifier Then
			$lReturn[0] = Int("0x" & StringMid($lString, 8 * $i + 1, 2))
			$lReturn[1] = Int("0x" & StringMid($lString, 8 * $i + 3, 2))
			ExitLoop
		EndIf
	Next
	Return $lReturn
EndFunc   ;==>GetModByIdentifier

;~ Description: Returns modstruct of an item.
Func GetModStruct($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	If DllStructGetData($aItem, 'modstruct') = 0 Then Return
	Return MemoryRead(DllStructGetData($aItem, 'modstruct'), 'Byte[' & DllStructGetData($aItem, 'modstructsize') * 4 & ']')
EndFunc   ;==>GetModStruct

;~ Description: Tests if an item is assigned to you.
Func GetAssignedToMe($aAgent)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return (DllStructGetData($aAgent, 'Owner') = GetMyID())
EndFunc   ;==>GetAssignedToMe

;~ Description: Tests if you can pick up an item.
Func GetCanPickUp($aAgent)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	If GetAssignedToMe($aAgent) Or DllStructGetData($aAgent, 'Owner') = 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>GetCanPickUp

;~ Description: Returns struct of an inventory bag.
Func GetBag($aBag)
	Local $lOffset[5] = [0, 0x18, 0x40, 0xF8, 0x4 * $aBag]
	Local $lBagStruct = DllStructCreate('byte unknown1[4];long index;long id;ptr containerItem;long ItemsCount;ptr bagArray;ptr itemArray;long fakeSlots;long slots')
	Local $lBagPtr = MemoryReadPtr($mBasePointer, $lOffset)
	If $lBagPtr[1] = 0 Then Return
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lBagPtr[1], 'ptr', DllStructGetPtr($lBagStruct), 'int', DllStructGetSize($lBagStruct), 'int', '')
	Return $lBagStruct
EndFunc   ;==>GetBag

;~ Description: Returns item by slot.
Func GetItemBySlot($aBag, $aSlot)
	Local $lBag

	If IsDllStruct($aBag) = 0 Then
		$lBag = GetBag($aBag)
	Else
		$lBag = $aBag
	EndIf

	Local $lItemPtr = DllStructGetData($lBag, 'ItemArray')
	Local $lBuffer = DllStructCreate('ptr')
	Local $lItemStruct = DllStructCreate('long Id;long AgentId;byte Unknown1[4];ptr Bag;ptr ModStruct;long ModStructSize;ptr Customized;byte unknown2[4];byte Type;byte unknown4;short ExtraId;short Value;byte unknown4[2];short Interaction;long ModelId;ptr ModString;byte unknown5[4];ptr NameString;ptr SingleItemName;byte Unknown4[10];byte IsSalvageable;byte Unknown6;byte Quantity;byte Equiped;byte Profession;byte Type2;byte Slot')
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', DllStructGetData($lBag, 'ItemArray') + 4 * ($aSlot - 1), 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', DllStructGetData($lBuffer, 1), 'ptr', DllStructGetPtr($lItemStruct), 'int', DllStructGetSize($lItemStruct), 'int', '')
	Return $lItemStruct
EndFunc   ;==>GetItemBySlot

;~ Description: Returns item struct.
Func GetItemByItemID($aItemID)
;~ 	Local $lItemStruct = DllStructCreate('long id;long agentId;byte unknown1[4];ptr bag;ptr modstruct;long modstructsize;ptr customized;byte unknown2[4];byte type;byte unknown3;short extraId;short value;byte unknown4[2];short interaction;long modelId;ptr modString;byte unknown5[4];ptr NameString;byte unknown6[15];byte quantity;byte equipped;byte unknown7[1];byte slot')
	Local $lItemStruct = DllStructCreate('long Id;long AgentId;byte Unknown1[4];ptr Bag;ptr ModStruct;long ModStructSize;ptr Customized;byte unknown2[4];byte Type;byte unknown4;short ExtraId;short Value;byte unknown4[2];short Interaction;long ModelId;ptr ModString;byte unknown5[4];ptr NameString;ptr SingleItemName;byte Unknown4[10];byte IsSalvageable;byte Unknown6;byte Quantity;byte Equiped;byte Profession;byte Type2;byte Slot')
	Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0x4 * $aItemID]
	Local $lItemPtr = MemoryReadPtr($mBasePointer, $lOffset)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lItemPtr[1], 'ptr', DllStructGetPtr($lItemStruct), 'int', DllStructGetSize($lItemStruct), 'int', '')
	Return $lItemStruct
EndFunc   ;==>GetItemByItemID

;~ Description: Returns item by agent ID.
Func GetItemByAgentID($aAgentID)
;~ 	Local $lItemStruct = DllStructCreate('long id;long agentId;byte unknown1[4];ptr bag;ptr modstruct;long modstructsize;ptr customized;byte unknown2[4];byte type;byte unknown3;short extraId;short value;byte unknown4[2];short interaction;long modelId;ptr modString;byte unknown5[4];ptr NameString;byte unknown6[15];byte quantity;byte equipped;byte unknown7[1];byte slot')
	Local $lItemStruct = DllStructCreate('long Id;long AgentId;byte Unknown1[4];ptr Bag;ptr ModStruct;long ModStructSize;ptr Customized;byte unknown2[4];byte Type;byte unknown4;short ExtraId;short Value;byte unknown4[2];short Interaction;long ModelId;ptr ModString;byte unknown5[4];ptr NameString;ptr SingleItemName;byte Unknown4[10];byte IsSalvageable;byte Unknown6;byte Quantity;byte Equiped;byte Profession;byte Type2;byte Slot')
	Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
	Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
	Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0]
	Local $lItemPtr, $lItemID
	Local $lAgentID = ConvertID($aAgentID)

	For $lItemID = 1 To $lItemArraySize[1]
		$lOffset[4] = 0x4 * $lItemID
		$lItemPtr = MemoryReadPtr($mBasePointer, $lOffset)
		If $lItemPtr[1] = 0 Then ContinueLoop

		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lItemPtr[1], 'ptr', DllStructGetPtr($lItemStruct), 'int', DllStructGetSize($lItemStruct), 'int', '')
		If DllStructGetData($lItemStruct, 'AgentID') = $lAgentID Then Return $lItemStruct
	Next
EndFunc   ;==>GetItemByAgentID

;~ Description: Returns item by model ID.
Func GetItemByModelID($aModelID)
;~ 	Local $lItemStruct = DllStructCreate('long id;long agentId;byte unknown1[4];ptr bag;ptr modstruct;long modstructsize;ptr customized;byte unknown2[4];byte type;byte unknown3;short extraId;short value;byte unknown4[2];short interaction;long modelId;ptr modString;byte unknown5[4];ptr NameString;byte unknown6[15];byte quantity;byte equipped;byte unknown7[1];byte slot')
	Local $lItemStruct = DllStructCreate('long Id;long AgentId;byte Unknown1[4];ptr Bag;ptr ModStruct;long ModStructSize;ptr Customized;byte unknown2[4];byte Type;byte unknown4;short ExtraId;short Value;byte unknown4[2];short Interaction;long ModelId;ptr ModString;byte unknown5[4];ptr NameString;ptr SingleItemName;byte Unknown4[10];byte IsSalvageable;byte Unknown6;byte Quantity;byte Equiped;byte Profession;byte Type2;byte Slot')
	Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
	Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
	Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0]
	Local $lItemPtr, $lItemID

	For $lItemID = 1 To $lItemArraySize[1]
		$lOffset[4] = 0x4 * $lItemID
		$lItemPtr = MemoryReadPtr($mBasePointer, $lOffset)
		If $lItemPtr[1] = 0 Then ContinueLoop

		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lItemPtr[1], 'ptr', DllStructGetPtr($lItemStruct), 'int', DllStructGetSize($lItemStruct), 'int', '')
		If DllStructGetData($lItemStruct, 'ModelID') = $aModelID Then Return $lItemStruct
	Next
EndFunc   ;==>GetItemByModelID

;~ Description: Returns amount of gold in storage.
Func GetGoldStorage()
	Local $lOffset[5] = [0, 0x18, 0x40, 0xF8, 0x94]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetGoldStorage

;~ Description: Returns amount of gold being carried.
Func GetGoldCharacter()
	Local $lOffset[5] = [0, 0x18, 0x40, 0xF8, 0x90]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetGoldCharacter

;~ Description: Returns item ID of salvage kit in inventory.
Func FindSalvageKit()
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 16
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2991
					If DllStructGetData($lItem, 'Value') / 8 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 8
					EndIf
				Case 5900
					If DllStructGetData($lItem, 'Value') / 10 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 10
					EndIf
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return $lKit
EndFunc   ;==>FindSalvageKit

;~ Description: Returns item ID of ID kit in inventory.
Func FindIDKit()
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 16
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2989
					If DllStructGetData($lItem, 'Value') / 2 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2
					EndIf
				Case 5899
					If DllStructGetData($lItem, 'Value') / 2.5 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2.5
					EndIf
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return $lKit
EndFunc   ;==>FindIDKit

;~ Description: Returns the item ID of the quoted item.
Func GetTraderCostID()
	Return MemoryRead($mTraderCostID)
EndFunc   ;==>GetTraderCostID

;~ Description: Returns the cost of the requested item.
Func GetTraderCostValue()
	Return MemoryRead($mTraderCostValue)
EndFunc   ;==>GetTraderCostValue

;~ Description: Internal use for BuyItem()
Func GetMerchantItemsBase()
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x24]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetMerchantItemsBase

;~ Description: Internal use for BuyItem()
Func GetMerchantItemsSize()
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x28]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetMerchantItemsSize
#EndRegion Item
