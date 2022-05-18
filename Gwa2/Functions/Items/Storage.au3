Func Storedust($aBags = 4)
    If dustcounter() > 250 Then
	     Storeduste(1, 20)
		 Storeduste(2, 10)
		 Storeduste(3, 15)
		 Storeduste(4, 15)
	EndIf
EndFunc

Func Storegranit($aBags = 4)
    If granitcounter() > 250 Then
	     Storegranite(1, 20)
		 Storegranite(2, 10)
		 Storegranite(3, 15)
		 Storegranite(4, 15)
	EndIf
EndFunc

Func Eisenlagern($aBags = 4)
    If Ironcounter() > 250 Then
	     StoreIron(1, 20)
		 StoreIron(2, 10)
		 StoreIron(3, 15)
		 StoreIron(4, 15)
	EndIf
EndFunc

Func Storestoness($aBags = 4)
    If Stonecounter() > 250 Then
	     StoreStones(1, 20)
		 StoreStones(2, 10)
		 StoreStones(3, 15)
		 StoreStones(4, 15)
	EndIf
EndFunc

Func StoreStones($BAGINDEX, $NUMOFSLOTS)
    Local $R_GOLD = 2624
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	Local	$m = DllStructGetData($AITEM, "ModelID")
	Local	$Q = DllStructGetData($AITEM, "quantity")
	Local	$t = DllStructGetData($AITEM, "Type")
	Local	$r = GetRarity($aItem)
	 Local   $a = DllStructGetData($aItem, "Quantity")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		$t = DllStructGetData($AITEM, "Type")
		$r = GetRarity($aItem)
	    $a = DllStructGetData($aItem, "Quantity")

	  If $m = 27047 and $a = 250 Then
		   Do
				For $BAG = 8 To 16
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func StoreIron($BAGINDEX, $NUMOFSLOTS)
    Local $R_GOLD = 2624
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	Local	$m = DllStructGetData($AITEM, "ModelID")
	Local	$Q = DllStructGetData($AITEM, "quantity")
	Local	$t = DllStructGetData($AITEM, "Type")
	Local	$r = GetRarity($aItem)
	 Local   $a = DllStructGetData($aItem, "Quantity")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		$t = DllStructGetData($AITEM, "Type")
		$r = GetRarity($aItem)
	    $a = DllStructGetData($aItem, "Quantity")

	  If $m = 948 and $a = 250 Then
		   Do
				For $BAG = 8 To 16
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Storegranite($BAGINDEX, $NUMOFSLOTS)
    Local $R_GOLD = 2624
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	Local	$m = DllStructGetData($AITEM, "ModelID")
	Local	$Q = DllStructGetData($AITEM, "quantity")
	Local	$t = DllStructGetData($AITEM, "Type")
	Local	$r = GetRarity($aItem)
	 Local   $a = DllStructGetData($aItem, "Quantity")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		$t = DllStructGetData($AITEM, "Type")
		$r = GetRarity($aItem)
	    $a = DllStructGetData($aItem, "Quantity")

	  If $m = 955 and $a = 250 Then
		   Do
				For $BAG = 8 To 16
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Storeduste($BAGINDEX, $NUMOFSLOTS)
    Local $R_GOLD = 2624
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	Local	$m = DllStructGetData($AITEM, "ModelID")
	Local	$Q = DllStructGetData($AITEM, "quantity")
	Local	$t = DllStructGetData($AITEM, "Type")
	Local	$r = GetRarity($aItem)
	 Local   $a = DllStructGetData($aItem, "Quantity")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		$t = DllStructGetData($AITEM, "Type")
		$r = GetRarity($aItem)
	    $a = DllStructGetData($aItem, "Quantity")

	  If $m = 929 and $a = 250 Then
		   Do
				For $BAG = 8 To 16
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc


#Region Storing Stuff
; Big function that calls the smaller functions below
Func StoreItems()
	StackableDrops(1, 20)
	StackableDrops(2, 5)
	StackableDrops(3, 10)
	StackableDrops(4, 10)
	Alcohol(1, 20)
	Alcohol(2, 5)
	Alcohol(3, 10)
	Alcohol(4, 10)
	Party(1, 20)
	Party(2, 5)
	Party(3, 10)
	Party(4, 10)
	Sweets(1, 20)
	Sweets(2, 5)
	Sweets(3, 10)
	Sweets(4, 10)
	Scrolls(1, 20)
	Scrolls(2, 5)
	Scrolls(3, 10)
	Scrolls(4, 10)
	EliteTomes(1, 20)
	EliteTomes(2, 5)
	EliteTomes(3, 10)
	EliteTomes(4, 10)
	Tomes(1, 20)
	Tomes(2, 5)
	Tomes(3, 10)
	Tomes(4, 10)
	DPRemoval(1, 20)
	DPRemoval(2, 5)
	DPRemoval(3, 10)
	DPRemoval(4, 10)
	SpecialDrops(1, 20)
	SpecialDrops(2, 5)
	SpecialDrops(3, 10)
	SpecialDrops(4, 10)
EndFunc ;~ Includes event Items broken down by Type

Func StoreMaterials()
	Materials(1, 20)
	Materials(2, 5)
	Materials(3, 10)
	Materials(4, 10)
EndFunc ;~ Common and Rare Materials

Func StoreUNIDGolds()
	UNIDGolds(1, 20)
	UNIDGolds(2, 5)
	UNIDGolds(3, 10)
	UNIDGolds(4, 10)
EndFunc ;~ UNID Golds

Func StoreMods()
	Mods(1, 20)
	Mods(2, 5)
	Mods(3, 10)
	Mods(4, 10)
EndFunc ;~ Mods I want to keep

Func StoreWeapons()
	Weapons(1, 20)
	Weapons(2, 5)
	Weapons(3, 10)
	Weapons(4, 10)
EndFunc

Func Weapons($BagIndex, $SlotCount)
	Local $aItem
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		Local $aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		Local $ModStruct = GetModStruct($aItem)
		Local $Energy = StringInStr($ModStruct, "0500D822", 0, 1) ;~String for +5e mod
		Switch DllStructGetData($aItem, "Type")
			Case 2, 5, 15, 27, 32, 35, 36
				If $Energy > 0 Then
					Do
						For $Bag = 8 To 12
							$Slot = FindEmptySlot($Bag)
							$Slot = @extended
							If $Slot <> 0 Then
								$Full = False
								$NSlot = $Slot
								ExitLoop 2
							Else
								$Full = True
							EndIf
							Sleep(400)
						Next
					Until $Full = True
					If $Full = False Then
						MoveItem($aItem, $Bag, $NSlot)
						Sleep(Random(450, 550))
					EndIf
				EndIf
		EndSwitch
	Next
EndFunc

Func StackableDrops($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 460 Or $M = 474 Or $M = 476 Or $M = 486 Or $M = 522 Or $M = 525 Or $M = 811 Or $M = 819 Or $M = 822 Or $M = 835 Or $M = 1610 Or $M = 2994 Or $M = 19185 Or $M = 22751 Or $M = 24629 Or $M = 24630 Or $M = 24631 Or $M = 24632 Or $M = 27033 Or $M = 27035 Or $M = 27044 Or $M = 27046 Or $M = 27047 Or $M = 27052 Or $M = 35123) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ like Suarian Bones, lockpicks, Glacial Stones, etc

Func EliteTomes($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 21796 Or $M = 21797 Or $M = 21798 Or $M = 21799 Or $M = 21800 Or $M = 21801 Or $M = 21802 Or $M = 21803 Or $M = 21804 Or $M = 21805) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ non-Elite tomes only

Func Tomes($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 21796 Or $M = 21797 Or $M = 21798 Or $M = 21799 Or $M = 21800 Or $M = 21801 Or $M = 21802 Or $M = 21803 Or $M = 21804 Or $M = 21805) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ non-Elite tomes only

Func Alcohol($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 910 Or $M = 2513 Or $M = 5585 Or $M = 6049 Or $M = 6366 Or $M = 6367 Or $M = 6375 Or $M = 15477 Or $M = 19171 Or $M = 22190 Or $M = 24593 Or $M = 28435 Or $M = 30855 Or $M = 31145 Or $M = 31146 Or $M = 35124 Or $M = 36682) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Party($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 6376 Or $M = 6368 Or $M = 6369 Or $M = 21809 Or $M = 21810 Or $M = 21813 Or $M = 29436 Or $M = 29543 Or $M = 36683 Or $M = 4730 Or $M = 15837 Or $M = 21490 Or $M = 22192 Or $M = 30626 Or $M = 30630 Or $M = 30638 Or $M = 30642 Or $M = 30646 Or $M = 30648 Or $M = 31020 Or $M = 31141 Or $M = 31142 Or $M = 31144 Or $M = 31172) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Sweets($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 15528 Or $M = 15479 Or $M = 19170 Or $M = 21492 Or $M = 21812 Or $M = 22269 Or $M = 22644 Or $M = 22752 Or $M = 28431 Or $M = 28432 Or $M = 28436 Or $M = 31150 Or $M = 35125 Or $M = 36681) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Scrolls($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 3256 Or $M = 3746 Or $M = 5594 Or $M = 5595 Or $M = 5611 Or $M = 5853 Or $M = 5975 Or $M = 5976 Or $M = 21233 Or $M = 22279 Or $M = 22280) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func DPRemoval($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 6370 Or $M = 21488 Or $M = 21489 Or $M = 22191 Or $M = 35127 Or $M = 26784 Or $M = 28433) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func SpecialDrops($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 18345 Or $M = 21491 Or $M = 21833 Or $M = 28434 Or $M = 35121) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Materials($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 921 Or $M = 922 Or $M = 923 Or $M = 925 Or $M = 926 Or $M = 927 Or $M = 928 Or $M = 929 Or $M = 930 Or $M = 931 Or $M = 932 Or $M = 933 Or $M = 934 Or $M = 935 Or $M = 936 Or $M = 937 Or $M = 938 Or $M = 939 Or $M = 940 Or $M = 941 Or $M = 942 Or $M = 943 Or $M = 944 Or $M = 945 Or $M = 946 Or $M = 948 Or $M = 949 Or $M = 950 Or $M = 951 Or $M = 952 Or $M = 953 Or $M = 954 Or $M = 955 Or $M = 956 Or $M = 6532 Or $M = 6533) And $Q = 250 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

; Keeps all Golds
Func UNIDGolds($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $R
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$R = GetRarity($aItem)
		$M = DllStructGetData($aItem, "ModelID")
		If $R = 2624 Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ UNID Golds

; Stores the mods that I am salvaging out to keep for Hero weapons
Func Mods($BagIndex, $SlotCount)
	Local $aItem
	Local $M
	Local $Q
	Local $Bag
	Local $Slot
	Local $Full
	Local $NSlot
	For $I = 1 To $SlotCount
		$aItem = GetItemBySlot($BagIndex, $I)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($aItem, "ModelID")
		$Q = DllStructGetData($aItem, "quantity")
		If ($M = 896 Or $M = 908 Or $M = 15554 Or $M = 15551 Or $M = 15552 Or $M = 894 Or $M = 906 Or $M = 897 Or $M = 909 Or $M = 893 Or $M = 905 Or $M = 6323 Or $M = 6331 Or $M = 895 Or $M = 907 Or $M = 15543 Or $M = 15553 Or $M = 15544 Or $M = 15555 Or $M = 15540 Or $M = 15541 Or $M = 15542 Or $M = 17059 Or $M = 19122 Or $M = 19123) Then
			Do
				For $Bag = 8 To 12
					$Slot = FindEmptySlot($Bag)
					$Slot = @extended
					If $Slot <> 0 Then
						$Full = False
						$NSlot = $Slot
						ExitLoop 2
					Else
						$Full = True
					EndIf
					Sleep(400)
				Next
			Until $Full = True
			If $Full = False Then
				MoveItem($aItem, $Bag, $NSlot)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

; This searches for empty slots in your Storage
Func FindEmptySlot($BagIndex)
	Local $LItemINFO, $aSlot
	For $aSlot = 1 To DllStructGetData(GetBAG($BagIndex), "Slots")
		Sleep(40)
		$LItemINFO = GetItemBySlot($BagIndex, $aSlot)
		If DllStructGetData($LItemINFO, "ID") = 0 Then
			SetExtended($aSlot)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc
#EndRegion Storing Stuff
