#include-once
#RequireAdmin

If @AutoItX64 Then
	MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
	Exit
EndIf

#Region Headers
;=QUEST=
;GAME_SMSG_QUEST_ADD
Global Const $HEADER_QUEST_ACCEPT = 0x4F	;Accepts a quest from the NPC
Global Const $HEADER_QUEST_REWARD = 0x4F	;Retrieves Quest reward from NPC
;GAME_CMSG_QUEST_ABANDON 0x10 or GAME_SMSG_QUEST_REMOVE 0x52
Global Const $HEADER_QUEST_ABANDON = 0x0F ;Abandons the quest
Global Const $HEADER_QUEST_INFOS = 0x10 ;Infos about Quest
Global Const $HEADER_QUEST_ACTIVE = 0x12

;=HERO=
;GAME_CMSG_HERO_BEHAVIOR
Global Const $HEADER_HERO_AGGRESSION = 0x13	;Sets the heroes aggression level
;GAME_CMSG_HERO_LOCK_TARGET
Global Const $HEADER_HERO_LOCK = 0x14	;Locks the heroes target
;GAME_CMSG_HERO_SKILL_TOGGLE
Global Const $HEADER_HERO_TOGGLE_SKILL = 0x17	;Enables or disables the heroes skill
;GAME_CMSG_HERO_FLAG_SINGLE
Global Const $HEADER_HERO_PLACE_FLAG = 0x18	;Sets the heroes position flag, hero runs to position
Global Const $HEADER_HERO_CLEAR_FLAG = 0x18	;Clears the heroes position flag
;GAME_CMSG_HERO_ADD 0x1D or GAME_SMSG_PARTY_HERO_ADD 0x1C8
Global Const $HEADER_HERO_ADD = 0x1C	;Adds hero to party
;GAME_CMSG_HERO_KICK 0x1E or GAME_SMSG_PARTY_HERO_REMOVE 0x1C9
Global Const $HEADER_HERO_KICK = 0x1D	;Kicks hero from party
Global Const $HEADER_HEROES_KICK = 0x1D	;Kicks ALL heroes from party

;=PARTY=
;GAME_CMSG_HERO_FLAG_ALL
Global Const $HEADER_PARTY_PLACE_FLAG = 0x19	;Sets the party position flag, all party-npcs runs to position
Global Const $HEADER_PARTY_CLEAR_FLAG = 0x19	;Clears the party position flag
;GAME_CMSG_PARTY_INVITE_NPC 0x9E or GAME_SMSG_PARTY_HENCHMAN_ADD 0x1C5
Global Const $HEADER_HENCHMAN_ADD = 0x9D	;Adds henchman to party
;GAME_CMSG_PARTY_LEAVE_GROUP
Global Const $HEADER_PARTY_LEAVE = 0xA0	;Leaves the party
;GAME_CMSG_PARTY_KICK_NPC 0xA7 or GAME_SMSG_PARTY_HENCHMAN_REMOVE 0x1C6
Global Const $HEADER_HENCHMAN_KICK = 0xA6	;Kicks a henchman from party
;GAME_CMSG_PARTY_INVITE_PLAYER 0x9F or GAME_SMSG_PARTY_INVITE_ADD 0x01CA
Global Const $HEADER_INVITE_TARGET = 0x9E	;Invite target player to party
;GAME_CMSG_PARTY_ACCEPT_CANCEL 0x9C or GAME_SMSG_PARTY_INVITE_CANCEL 0x01CC
Global Const $HEADER_INVITE_CANCEL = 0x9B	;Cancel invitation of player
;GAME_CMSG_PARTY_ACCEPT_INVITE 0x9B or GAME_SMSG_PARTY_JOIN_REQUEST 0x01CB
Global Const $HEADER_INVITE_ACCEPT = 0x9A	;Accept invitation to party

;=TARGET (Enemies or NPC)=
;GAME_CMSG_TARGET_CALL 0x22
Global Const $HEADER_CALL_TARGET = 0x21	;Calls the target without attacking (Ctrl+Shift+Space)
;GAME_CMSG_ATTACK_AGENT 0x25
Global Const $HEADER_ATTACK_AGENT = 0x24	;Attacks agent (Space IIRC)
;GAME_CMSG_CANCEL_MOVEMENT 0x27 or GAME_SMSG_SKILL_CANCEL 0xE4
Global Const $HEADER_CANCEL_ACTION = 0x26	;Cancels the current action
;GAME_CMSG_INTERACT_PLAYER 0x32
Global Const $HEADER_AGENT_FOLLOW = 0x31	;Follows the agent/npc. Ctrl+Click triggers "I am following Person" in chat
;GAME_CMSG_INTERACT_LIVING
Global Const $HEADER_NPC_TALK = 0x37	;talks/goes to npc
;GAME_CMSG_INTERACT_ITEM 0x3E or GAME_CMSG_INTERACT_GADGET 0x50
Global Const $HEADER_SIGNPOST_RUN = 0x4F	;Runs to signpost

;=DROP=
;GAME_CMSG_DROP_ITEM 0x2B
Global Const $HEADER_ITEM_DROP = 0x2A	;Drops item from inventory to ground
;GAME_CMSG_DROP_GOLD
Global Const $HEADER_GOLD_DROP = 0x2D	;Drops gold from inventory to ground

;=BUFFS=
;GAME_CMSG_DROP_BUFF
Global Const $HEADER_STOP_MAINTAIN_ENCH = 0x27	;Drops buff, cancel enchantmant, whatever you call it

;=ITEMS=
;GAME_CMSG_EQUIP_ITEM
Global Const $HEADER_ITEM_EQUIP = 0x2E	;Equips item from inventory/chest/no idea
;GAME_CMSG_INTERACT_ITEM
Global Const $HEADER_ITEM_PICKUP = 0x3D	;Picks up an item from ground
;GAME_CMSG_ITEM_DESTROY
Global Const $HEADER_ITEM_DESTROY = 0x67	;Destroys the item
;GAME_CMSG_ITEM_IDENTIFY
Global Const $HEADER_ITEM_ID = 0x6A	;Identifies item in inventory
;GAME_CMSG_ITEM_MOVE
Global Const $HEADER_ITEM_MOVE = 0x70	;Moves item in inventory
;GAME_CMSG_ITEM_ACCEPT_ALL
Global Const $HEADER_ITEMS_ACCEPT_UNCLAIMED = 0x71	;Accepts ITEMS not picked up in missions
;GAME_CMSG_ITEM_MOVE
Global Const $HEADER_ITEM_MOVE_EX = 0x73	;Moves an item, with amount to be moved.
;GAME_CMSG_ITEM_SALVAGE_MATERIALS
Global Const $HEADER_SALVAGE_MATS = 0x78	;Salvages materials from item
;GAME_CMSG_ITEM_SALVAGE_UPGRADE
Global Const $HEADER_SALVAGE_MODS = 0x79	;Salvages mods from item
;GAME_CMSG_ITEM_SALVAGE_UPGRADE
Global Const $HEADER_SALVAGE_SESSION = 0x75	;Salvages mods from item
;GAME_CMSG_ITEM_USE
Global Const $HEADER_ITEM_USE = 0x7C	;Uses item from inventory/chest
;GAME_CMSG_UNEQUIP_ITEM
Global Const $HEADER_ITEM_UNEQUIP = 0x4D	;Unequip item
Global Const $HEADER_UPGRADE = 0x86	;used by gwapi. is it even useful? NOT TESTED
Global Const $HEADER_UPGRADE_ARMOR_1 = 0x83	;used by gwapi. is it even useful? NOT TESTED
Global Const $HEADER_UPGRADE_ARMOR_2 = 0x86	;used by gwapi. is it even useful? NOT TESTED
Global Const $HEADER_EQUIP_BAG = 0x70
;Global Const $HEADER_USE_ITEM = 0x85

;=TRADE=
;GAME_SMSG_TRADE_REQUEST
Global Const $HEADER_TRADE_PLAYER = 0x00	;Send trade request to player
;GAME_SMSG_TRADE_ADD_ITEM
Global Const $HEADER_TRADE_OFFER_ITEM = 0x04	;Add item to trade window
;GAME_CMSG_TRADE_SEND_OFFER
Global Const $HEADER_TRADE_SUBMIT_OFFER = 0x03	;Submit offer
;GAME_SMSG_TRADE_CHANGE_OFFER
Global Const $HEADER_TRADE_CHANGE_OFFER = 0x02	;Change offer
;GAME_CMSG_TRADE_CANCEL
Global Const $HEADER_TRADE_CANCEL = 0x01	;Cancel trade
;GAME_CMSG_TRADE_ACCEPT
Global Const $HEADER_TRADE_ACCEPT = 0x07	;Accept trade

;=TRAVEL=
;GAME_CMSG_PARTY_TRAVEL
Global Const $HEADER_MAP_TRAVEL = 0xAF	;Travels to outpost via worldmap
;GAME_CMSG_PARTY_ENTER_GUILD_HALL
Global Const $HEADER_GUILDHALL_TRAVEL = 0xAE	;Travels to guild hall
;GAME_CMSG_PARTY_LEAVE_GUILD_HALL
Global Const $HEADER_GUILDHALL_LEAVE = 0xB0	;Leaves Guildhall

;=FACTION=
;GAME_CMSG_DEPOSIT_FACTION
Global Const $HEADER_FACTION_DONATE = 0x33	;Donates kurzick/luxon faction to ally

;=TITLE=
;GAME_CMSG_TITLE_DISPLAY 0x57 or GAME_SMSG_TITLE_RANK_DISPLAY 0xF5
Global Const $HEADER_TITLE_DISPLAY = 0x56	;Displays title
;GAME_CMSG_TITLE_HIDE
Global Const $HEADER_TITLE_CLEAR = 0x57	;Hides title

;=DIALOG=
;GAME_CMSG_SEND_DIALOG
Global Const $HEADER_DIALOG = 0x39	;Sends a dialog to NPC
;GAME_CMSG_SKIP_CINEMATIC
Global Const $HEADER_CINEMATIC_SKIP = 0x61	;Skips the cinematic
Global Const $HEADER_HOM_DIALOG = 0x58

;=SKILL / BUILD=
;GAME_CMSG_SKILLBAR_SKILL_SET
Global Const $HEADER_SET_SKILLBAR_SKILL = 0x5A	;Changes a skill on the skillbar
;GAME_CMSG_SKILLBAR_LOAD
Global Const $HEADER_LOAD_SKILLBAR = 0x5B	;Loads a complete build
;GAME_CMSG_CHANGE_SECOND_PROFESSION
Global Const $HEADER_CHANGE_SECONDARY = 0x3F	;Changes Secondary class (from Build window, not class changer)
Global Const $HEADER_SKILL_USE_ALLY = 0x4B	;used by gwapi. appears to have changed
Global Const $HEADER_SKILL_USE_FOE = 0x4B	;used by gwapi. appears to have changed
Global Const $HEADER_SKILL_USE_ID = 0x4B	;
Global Const $HEADER_SET_ATTRIBUTES = 0x0E	;hidden in init stuff like sendchat
Global Const $HEADER_OPEN_SKILLS = 0x40
;GAME_CMSG_USE_SKILL
Global Const $HEADER_USE_SKILL = 0x44
Global Const $HEADER_PROFESSION_ULOCK = 0x40

;=CHEST=
;GAME_CMSG_OPEN_CHEST
Global Const $HEADER_CHEST_OPEN = 0x51	;Opens a chest (with key AFAIK)
;GAME_CMSG_ITEM_CHANGE_GOLD
Global Const $HEADER_CHANGE_GOLD = 0x7A	;Moves Gold (from chest to inventory, and otherway around IIRC)

;=MISSION=
;GAME_CMSG_PARTY_SET_DIFFICULTY
Global Const $HEADER_MODE_SWITCH = 0x99	;Toggles hard- and normal mode
;GAME_CMSG_PARTY_ENTER_CHALLENGE
Global Const $HEADER_MISSION_ENTER = 0xA3	;Enter a mission/challenge
Global Const $HEADER_MISSION_FOREIGN_ENTER = 0xAB	;Enters a foreign mission/challenge (no idea honestly)
;GAME_CMSG_PARTY_RETURN_TO_OUTPOST
Global Const $HEADER_OUTPOST_RETURN = 0xA5	;Returns to outpost after /resign

;=CHAT=
;GAME_CMSG_SEND_CHAT_MESSAGE
Global Const $HEADER_SEND_CHAT = 0x62	;Needed for sending messages in chat

;=MOVEMENT=
;GAME_SMSG_AGENT_MOVEMENT_TICK
Global Const $HEADER_MOVEMENT_TICK = 0x1E

;=OTHER CONSTANTS=
Global Const $HEADER_MAX_ATTRIBUTES_CONST_5 = 0x03	;constant at word 5 of max attrib packet. Changed from 3 to four in most recent update
Global Const $HEADER_MAX_ATTRIBUTES_CONST_22	= 0x03	;constant at word 22 of max attrib packet. Changed from 3 to four in most recent update
Global Const $HEADER_OPEN_GB_WINDOW = 0x9E
Global Const $HEADER_CLOSE_GB_WINDOW = 0x9F
Global Const $HEADER_START_RATING_GVG = 0xA8
#EndRegion Headers

#Region Declarations
Local $mKernelHandle
Local $mGWProcHandle
Local $mMemory
Local $mLabels[1][2]
Local $mBase = 0x00C50000
Local $mASMString, $mASMSize, $mASMCodeOffset
Local $SecondInject

Local $mGUI = GUICreate('Gwa2'), $mSkillActivate, $mSkillCancel, $mSkillComplete, $mChatReceive, $mLoadFinished
Local $mSkillLogStruct = DllStructCreate('dword;dword;dword;float')
Local $mSkillLogStructPtr = DllStructGetPtr($mSkillLogStruct)
Local $mChatLogStruct = DllStructCreate('dword;wchar[256]')
Local $mChatLogStructPtr = DllStructGetPtr($mChatLogStruct)
GUIRegisterMsg(0x501, 'Event')

Local $mQueueCounter, $mQueueSize, $mQueueBase
Local $mGWWindowHandle
Local $mTargetLogBase
Local $mStringLogBase
Local $mAgentNameLogBase
Local $mSkillBase
Local $mEnsureEnglish
Local $mMyID, $mCurrentTarget
Local $mAgentBase
Local $mAgentMovement
Local $mSleepAfterPort = 1000
Local $MyID

Local $mBasePointer
Local $mRegion, $mLanguage
Local $mPing
Local $mCharname
Local $mMapID
Local $mMaxAgents
Local $mMapLoading
Local $mMapIsLoaded
Local $mLoggedIn
Local $mStringHandlerPtr
Local $mWriteChatSender
Local $mTraderQuoteID, $mTraderCostID, $mTraderCostValue
Local $mSkillTimer
Local $mBuildNumber
Local $mZoomStill, $mZoomMoving
Local $mDisableRendering
Local $mAgentCopyCount
Local $mAgentCopyBase
Local $mCurrentStatus
Local $mLastDialogID
Local $mUseStringLog
Local $mUseEventSystem
#EndRegion Declarations

#Region CommandStructs
Local $mInviteGuild = DllStructCreate('ptr;dword;dword header;dword counter;wchar name[32];dword type')
Local $mInviteGuildPtr = DllStructGetPtr($mInviteGuild)

Local $mUseSkill = DllStructCreate('ptr;dword;dword;dword')
Local $mUseSkillPtr = DllStructGetPtr($mUseSkill)

Local $mMove = DllStructCreate('ptr;float;float;float')
Local $mMovePtr = DllStructGetPtr($mMove)

Local $mChangeTarget = DllStructCreate('ptr;dword')
Local $mChangeTargetPtr = DllStructGetPtr($mChangeTarget)

Local $mPacket = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Local $mPacketPtr = DllStructGetPtr($mPacket)

Local $mWriteChat = DllStructCreate('ptr')
Local $mWriteChatPtr = DllStructGetPtr($mWriteChat)

Local $mSellItem = DllStructCreate('ptr;dword;dword;dword')
Local $mSellItemPtr = DllStructGetPtr($mSellItem)

Local $mAction = DllStructCreate('ptr;dword;dword;')
Local $mActionPtr = DllStructGetPtr($mAction)

Local $mToggleLanguage = DllStructCreate('ptr;dword')
Local $mToggleLanguagePtr = DllStructGetPtr($mToggleLanguage)

Local $mUseHeroSkill = DllStructCreate('ptr;dword;dword;dword')
Local $mUseHeroSkillPtr = DllStructGetPtr($mUseHeroSkill)

Local $mUpdateAgentPos = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword')
Local $mUpdateAgentPosPtr = DllStructGetPtr($mUpdateAgentPos)

Local $mBuyItem = DllStructCreate('ptr;dword;dword;dword;dword')
Local $mBuyItemPtr = DllStructGetPtr($mBuyItem)

Local $mCraftItemEx = DllStructCreate('ptr;dword;dword;ptr;dword;dword')
Local $mCraftItemExPtr = DllStructGetPtr($mCraftItemEx)

Local $mCraftItemEx2 = DllStructCreate("ptr;dword;dword;dword;dword;dword")
Local $mCraftItemEx2Ptr = DllStructGetPtr($mCraftItemEx)

Local $mUpgrade = DllStructCreate("ptr;dword;dword;dword;dword;dword")
Local $mUpgradePtr = DllStructGetPtr($mUpgrade)

Local $mSendChat = DllStructCreate('ptr;dword')
Local $mSendChatPtr = DllStructGetPtr($mSendChat)

Local $mSendChatPartySearch = DllStructCreate('ptr;dword')
Local $mSendChatPartySearchPtr = DllStructGetPtr($mSendChatPartySearch)

Local $mRequestQuote = DllStructCreate('ptr;dword')
Local $mRequestQuotePtr = DllStructGetPtr($mRequestQuote)

Local $mRequestQuoteSell = DllStructCreate('ptr;dword')
Local $mRequestQuoteSellPtr = DllStructGetPtr($mRequestQuoteSell)

Local $mTraderBuy = DllStructCreate('ptr')
Local $mTraderBuyPtr = DllStructGetPtr($mTraderBuy)

Local $mTraderSell = DllStructCreate('ptr')
Local $mTraderSellPtr = DllStructGetPtr($mTraderSell)

Local $mSalvage = DllStructCreate('ptr;dword;dword;dword')
Local $mSalvagePtr = DllStructGetPtr($mSalvage)

Local $mIncreaseAttribute = DllStructCreate('ptr;dword;dword')
Local $mIncreaseAttributePtr = DllStructGetPtr($mIncreaseAttribute)

Local $mDecreaseAttribute = DllStructCreate('ptr;dword;dword')
Local $mDecreaseAttributePtr = DllStructGetPtr($mDecreaseAttribute)

Local $mMaxAttributes = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Local $mMaxAttributesPtr = DllStructGetPtr($mMaxAttributes)

Local $mSetAttributes = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Local $mSetAttributesPtr = DllStructGetPtr($mSetAttributes)

Local $mMakeAgentArray = DllStructCreate('ptr;dword')
Local $mMakeAgentArrayPtr = DllStructGetPtr($mMakeAgentArray)

Local $mChangeStatus = DllStructCreate('ptr;dword')
Local $mChangeStatusPtr = DllStructGetPtr($mChangeStatus)

Global $traderBuyItemID
Global $traderBuyCostValue
Global $traderSellItemID
Global $MTradeHackAddress
Global $FirstSalvg = False
#EndRegion CommandStructs

#Region Memory
;~ Description: Internal use only.
Func MemoryOpen($aPID)
	$mKernelHandle = DllOpen('kernel32.dll')
	Local $lOpenProcess = DllCall($mKernelHandle, 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', 1, 'int', $aPID)
	$mGWProcHandle = $lOpenProcess[0]
EndFunc   ;==>MemoryOpen

;~ Description: Internal use only.
Func MemoryClose()
	DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $mGWProcHandle)
	DllClose($mKernelHandle)
EndFunc   ;==>MemoryClose

;~ Description: Internal use only.
Func WriteBinary($aBinaryString, $aAddress)
	Local $lData = DllStructCreate('byte[' & 0.5 * StringLen($aBinaryString) & ']'), $i
	For $i = 1 To DllStructGetSize($lData)
		DllStructSetData($lData, 1, Dec(StringMid($aBinaryString, 2 * $i - 1, 2)), $i)
	Next
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'ptr', $aAddress, 'ptr', DllStructGetPtr($lData), 'int', DllStructGetSize($lData), 'int', 0)
EndFunc   ;==>WriteBinary

;~ Description: Internal use only.
Func MemoryWrite($aAddress, $aData, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllStructSetData($lBuffer, 1, $aData)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
EndFunc   ;==>MemoryWrite

;~ Description: Internal use only.
Func MemoryRead($aAddress, $aType = 'dword')
	Local $lBuffer = DllStructCreate($aType)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Return DllStructGetData($lBuffer, 1)
EndFunc   ;==>MemoryRead

;~ Description: Internal use only.
Func MemoryReadToStruct($aAddress, ByRef $aStructure)
	Return DllCall($mKernelHandle, "int", "ReadProcessMemory", "int", $mGWProcHandle, "int", $aAddress, "ptr", DllStructGetPtr($aStructure), "int", DllStructGetSize($aStructure), "int", "")[0]
EndFunc   ;==>MemoryReadToStruct

;~ Description: Internal use only.
Func MemoryReadPtr($aAddress, $aOffset, $aType = 'dword')
	Local $lPointerCount = UBound($aOffset) - 2
	Local $lBuffer = DllStructCreate('dword')
	For $i = 0 To $lPointerCount
		$aAddress += $aOffset[$i]
		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
		$aAddress = DllStructGetData($lBuffer, 1)
		If $aAddress == 0 Then
			Local $lData[2] = [0, 0]
			Return $lData
		EndIf
	Next
	$aAddress += $aOffset[$lPointerCount + 1]
	$lBuffer = DllStructCreate($aType)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Local $lData[2] = [$aAddress, DllStructGetData($lBuffer, 1)]
	Return $lData
EndFunc   ;==>MemoryReadPtr

;Internal use only
Func GetInstanceBasePtr()
	Local $lOffset[3] = [0, 0x18, 0x2C]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset, 'ptr')
	Return $lReturn[1]
EndFunc   ;==>GetInstanceBasePtr

;Internal use only
Func MemoryReadOffset($aAddress, $aOffset = 0, $aType = 'dword')
	If $aAddress == 0 Then Return 0
	Return MemoryRead($aAddress + $aOffset, $aType)
EndFunc   ;==>MemoryReadOffset

;Internal use only
Func MemoryReadStruct($aAddress, $aStruct = 'dword')
	If $aAddress == 0 Then Return 0
	If Not IsDllStruct($aStruct) Then $aStruct = DllStructCreate($aStruct)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($aStruct), 'int', DllStructGetSize($aStruct), 'int', 0)
	Return $aStruct
EndFunc   ;==>MemoryReadStruct

;~ Description: Internal use only.
Func SwapEndian($aHex)
	Return StringMid($aHex, 7, 2) & StringMid($aHex, 5, 2) & StringMid($aHex, 3, 2) & StringMid($aHex, 1, 2)
EndFunc   ;==>SwapEndian

;~ Description: Emptys Guild Wars client memory
Func ClearMemory()
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSize', 'int', $mGWProcHandle, 'int', -1, 'int', -1)
EndFunc   ;==>ClearMemory

;~ Description: Changes the maximum memory Guild Wars can use.
Func SetMaxMemory($aMemory = 157286400)
	DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSizeEx', 'int', $mGWProcHandle, 'int', 1, 'int', $aMemory, 'int', 6)
EndFunc   ;==>SetMaxMemory

;~ Description: Internal use only.
Func Enqueue($aPtr, $aSize)
	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', 256 * $mQueueCounter + $mQueueBase, 'ptr', $aPtr, 'int', $aSize, 'int', '')
	If $mQueueCounter = $mQueueSize Then
		$mQueueCounter = 0
	Else
		$mQueueCounter = $mQueueCounter + 1
	EndIf
EndFunc   ;==>Enqueue
#EndRegion Memory

#Region Initialisation
;~ Description: Returns a list of logged characters
Func GetLoggedCharNames()
	Local $array = ScanGW()
	If $array[0] == 1 Then Return $array[1]
	If $array[0] < 1 Then Return ''
	Local $ret = $array[1]
	For $i = 2 To $array[0]
		$ret &= '|'
		$ret &= $array[$i]
	Next
	Return $ret
EndFunc   ;==>GetLoggedCharNames

Func ScanGW()
	Local $lProcessList = ProcessList('gw.exe')
	Local $lReturnArray[1] = [0]
	Local $lPid

	For $i = 1 To $lProcessList[0][0]
		MemoryOpen($lProcessList[$i][1])

		If $mGWProcHandle Then
			$lReturnArray[0] += 1
			ReDim $lReturnArray[$lReturnArray[0] + 1]
			$lReturnArray[$lReturnArray[0]] = ScanForCharname()
		EndIf

		MemoryClose()

		$mGWProcHandle = 0
	Next

	Return $lReturnArray
EndFunc   ;==>ScanGW

Func GetHwnd($aProc)
	Local $wins = WinList()
	For $i = 1 To UBound($wins) - 1
		If (WinGetProcess($wins[$i][1]) == $aProc) And (BitAND(WinGetState($wins[$i][1]), 2)) Then Return $wins[$i][1]
	Next
EndFunc   ;==>GetHwnd

;~ Description: Injects Gwa2 into the game client.
Func Initialize($aGW, $bChangeTitle = True, $aUseStringLog = False, $aUseEventSystem = True)
	Local $lWinList, $lWinList2, $mGWProcessId
	$mUseStringLog = $aUseStringLog
	$mUseEventSystem = $aUseEventSystem

	If IsString($aGW) Then
		Local $lProcessList = ProcessList('gw.exe')
		For $i = 1 To $lProcessList[0][0]
			$mGWProcessId = $lProcessList[$i][1]
			$mGWWindowHandle = GetHwnd($mGWProcessId)
			MemoryOpen($mGWProcessId)
			If $mGWProcHandle Then
				If StringRegExp(ScanForCharname(), $aGW) = 1 Then ExitLoop
			EndIf
			MemoryClose()
			$mGWProcHandle = 0
		Next
	Else
		$mGWProcessId = $aGW
		$mGWWindowHandle = GetHwnd($mGWProcessId)
		MemoryOpen($aGW)
		ScanForCharname()
	EndIf
	$MGWHWND = $mGWWindowHandle
	If $mGWProcHandle = 0 Then Return 0

	Scan()

	Local $lTemp
	$mBasePointer = MemoryRead(GetScannedAddress('ScanBasePointer', 8))
	SetValue('BasePointer', '0x' & Hex($mBasePointer, 8))
	$mAgentBase = GetScannedAddress('ScanAgentBase', 0x12)
	$mAgentBase = $mAgentBase + MemoryRead($mAgentBase) + 4
	$mAgentBase += 0x13
	$mAgentBase = MemoryRead($mAgentBase)
	SetValue('AgentBase', '0x' & Hex($mAgentBase, 8))
	$mMaxAgents = $mAgentBase + 8
	SetValue('MaxAgents', '0x' & Hex($mMaxAgents, 8))
	$mMyID = MemoryRead(GetScannedAddress('ScanMyID', -3))
	SetValue('MyID', '0x' & Hex($mMyID, 8))
	$mCurrentTarget = MemoryRead(GetScannedAddress('ScanCurrentTarget', -14))
	SetValue('PacketLocation', '0x' & Hex(MemoryRead(GetScannedAddress('ScanBaseOffset', 11)), 8))
	$mPing = MemoryRead(GetScannedAddress('ScanPing', -3))
	$mMapID = MemoryRead(GetScannedAddress('ScanMapID', 28))
	$mMapLoading = MemoryRead(GetScannedAddress('ScanMapLoading', 44))
	$mLoggedIn = MemoryRead(GetScannedAddress('ScanLoggedIn', -3)) - 0x198
	$mLanguage = MemoryRead(GetScannedAddress('ScanMapInfo', 11)) + 0xC
	$mRegion = $mLanguage + 4
	$mSkillBase = MemoryRead(GetScannedAddress('ScanSkillBase', 8))
	$mSkillTimer = MemoryRead(GetScannedAddress('ScanSkillTimer', -3))
	$lTemp = GetScannedAddress('ScanBuildNumber', 0x2C)
	$mBuildNumber = MemoryRead($lTemp + MemoryRead($lTemp) + 5)
	$mZoomStill = GetScannedAddress('ScanZoomStill', 0x33)
	$mZoomMoving = GetScannedAddress('ScanZoomMoving', 0x21)
	$mCurrentStatus = MemoryRead(GetScannedAddress('ScanChangeStatusFunction', 35))
	$lTemp = GetScannedAddress('ScanEngine', -0x6E)
	SetValue('MainStart', '0x' & Hex($lTemp, 8))
	SetValue('MainReturn', '0x' & Hex($lTemp + 5, 8))
	$lTemp = GetScannedAddress('ScanRenderFunc', 0x2E)
	SetValue('RenderingMod', '0x' & Hex($lTemp, 8))
	SetValue('RenderingModReturn', '0x' & Hex($lTemp + 10, 8))
	$lTemp = GetScannedAddress('ScanTargetLog', 1)
	SetValue('TargetLogStart', '0x' & Hex($lTemp, 8))
	SetValue('TargetLogReturn', '0x' & Hex($lTemp + 5, 8))
	$lTemp = GetScannedAddress('ScanSkillLog', -46)
	SetValue('SkillLogStart', '0x' & Hex($lTemp, 8))
	SetValue('SkillLogReturn', '0x' & Hex($lTemp + 5, 8))
	$lTemp = GetScannedAddress('ScanSkillCompleteLog', -4)
	SetValue('SkillCompleteLogStart', '0x' & Hex($lTemp, 8))
	SetValue('SkillCompleteLogReturn', '0x' & Hex($lTemp + 5, 8))
	$lTemp = GetScannedAddress('ScanSkillCancelLog', 5)
	SetValue('SkillCancelLogStart', '0x' & Hex($lTemp, 8))
	SetValue('SkillCancelLogReturn', '0x' & Hex($lTemp + 6, 8))
	$lTemp = GetScannedAddress('ScanChatLog', 18)
	SetValue('ChatLogStart', '0x' & Hex($lTemp, 8))
	SetValue('ChatLogReturn', '0x' & Hex($lTemp + 6, 8))
	$lTemp = GetScannedAddress('ScanTraderHook', -0x2F)
	SetValue('TraderHookStart', '0x' & Hex($lTemp, 8))
	SetValue('TraderHookReturn', '0x' & Hex($lTemp + 5, 8))
	$lTemp = GetScannedAddress('ScanDialogLog', -4)
	SetValue('DialogLogStart', '0x' & Hex($lTemp, 8))
	SetValue('DialogLogReturn', '0x' & Hex($lTemp + 5, 8))
	SetValue('LoadFinishedStart', '0x' & Hex(GetScannedAddress('ScanLoadFinished', 1), 8))
	SetValue('LoadFinishedReturn', '0x' & Hex(GetScannedAddress('ScanLoadFinished', 6), 8))
	SetValue('PostMessage', '0x' & Hex(MemoryRead(GetScannedAddress('ScanPostMessage', 25)), 8))
	SetValue('Sleep', MemoryRead(MemoryRead(GetValue('ScanSleep') + 8) + 3))
	SetValue('SalvageFunction', '0x' & Hex(GetScannedAddress('ScanSalvageFunction', -10), 8))
	SetValue('SalvageGlobal', '0x' & Hex(MemoryRead(GetScannedAddress('ScanSalvageGlobal', 1) - 0x4), 8))
	SetValue('IncreaseAttributeFunction', '0x' & Hex(GetScannedAddress('ScanIncreaseAttributeFunction', -0x5A), 8))
	SetValue('DecreaseAttributeFunction', '0x' & Hex(GetScannedAddress('ScanDecreaseAttributeFunction', 25), 8))
	SetValue('MoveFunction', '0x' & Hex(GetScannedAddress('ScanMoveFunction', 1), 8))
	SetValue('UseSkillFunction', '0x' & Hex(GetScannedAddress('ScanUseSkillFunction', -0x125), 8))
	SetValue('ChangeTargetFunction', '0x' & Hex(GetScannedAddress('ScanChangeTargetFunction', -15), 8))
	SetValue('WriteChatFunction', '0x' & Hex(GetScannedAddress('ScanWriteChatFunction', 0x1), 0x8))
	SetValue('SellItemFunction', '0x' & Hex(GetScannedAddress('ScanSellItemFunction', -85), 8))
	SetValue('PacketSendFunction', '0x' & Hex(GetScannedAddress('ScanPacketSendFunction', -0xC2), 8))
	SetValue('ActionBase', '0x' & Hex(MemoryRead(GetScannedAddress('ScanActionBase', -3)), 8))
	SetValue('ActionFunction', '0x' & Hex(GetScannedAddress('ScanActionFunction', -3), 8))
	SetValue('UseHeroSkillFunction', '0x' & Hex(GetScannedAddress('ScanUseHeroSkillFunction', -0x59), 8))
	SetValue('BuyItemBase', '0x' & Hex(MemoryRead(GetScannedAddress('ScanBuyItemBase', 15)), 8))
	SetValue('TransactionFunction', '0x' & Hex(GetScannedAddress('ScanTransactionFunction', -0x7E), 8))
	SetValue('RequestQuoteFunction', '0x' & Hex(GetScannedAddress('ScanRequestQuoteFunction', 0x3B), 8))
	SetValue('TraderFunction', '0x' & Hex(GetScannedAddress('ScanTraderFunction', -0x1E), 8))
	SetValue('ClickToMoveFix', '0x' & Hex(GetScannedAddress('ScanClickToMoveFix', 1), 8))
	SetValue('ChangeStatusFunction', '0x' & Hex(GetScannedAddress('ScanChangeStatusFunction', 1), 8))
	SetValue('TradeID', '0x' & Hex(GetScannedAddress('ScanTradeID', 34), 8))
	SetValue('QueueSize', '0x00000010')
	SetValue('SkillLogSize', '0x00000010')
	SetValue('ChatLogSize', '0x00000010')
	SetValue('TargetLogSize', '0x00000200')
	SetValue('StringLogSize', '0x00000200')
	SetValue('CallbackEvent', '0x00000501')
	SetValue('StringLogStart', '0x' & Hex(GetScannedAddress('ScanStringLog', 0x41), 8))
	SetValue('AgentNameLogMaxSize', '0x00000200')
	$lTemp = GetScannedAddress('ScanAgentNameLog', -0x14)
	SetValue('AgentNameLogStart', '0x' & Hex($lTemp, 8))
	SetValue('AgentNameLogReturn', '0x' & Hex($lTemp + 0x7, 8))

	ModifyMemory()

	$mStringLogBase = GetValue('StringLogBase')
	$mAgentNameLogBase = GetValue('AgentNameLogBase')
	$MTradeHackAddress = GetScannedAddress('ScanTradeHack', 0)
	$mQueueCounter = MemoryRead(GetValue('QueueCounter'))
	$mQueueSize = GetValue('QueueSize') - 1
	$mQueueBase = GetValue('QueueBase')
	$mTargetLogBase = GetValue('TargetLogBase')
	$mMapIsLoaded = GetValue('MapIsLoaded')
	$mEnsureEnglish = GetValue('EnsureEnglish')
	$mTraderQuoteID = GetValue('TraderQuoteID')
	$mTraderCostID = GetValue('TraderCostID')
	$mTraderCostValue = GetValue('TraderCostValue')
	$mDisableRendering = GetValue('DisableRendering')
	$mAgentCopyCount = GetValue('AgentCopyCount')
	$mAgentCopyBase = GetValue('AgentCopyBase')
	$mAgentMovement = GetAgentMovementPtr()
	$mLastDialogID = GetValue('LastDialogID')

	If $mUseEventSystem Then MemoryWrite(GetValue('CallbackHandle'), $mGUI)

	DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
	DllStructSetData($mInviteGuild, 2, 0x4C)
	DllStructSetData($mUseSkill, 1, GetValue('CommandUseSkill'))
	DllStructSetData($mMove, 1, GetValue('CommandMove'))
	DllStructSetData($mChangeTarget, 1, GetValue('CommandChangeTarget'))
	DllStructSetData($mPacket, 1, GetValue('CommandPacketSend'))
	DllStructSetData($mSellItem, 1, GetValue('CommandSellItem'))
	DllStructSetData($mAction, 1, GetValue('CommandAction'))
	DllStructSetData($mToggleLanguage, 1, GetValue('CommandToggleLanguage'))
	DllStructSetData($mUseHeroSkill, 1, GetValue('CommandUseHeroSkill'))
	DllStructSetData($mBuyItem, 1, GetValue('CommandBuyItem'))
	DllStructSetData($mSendChat, 1, GetValue('CommandSendChat'))
	DllStructSetData($mSendChat, 2, $HEADER_SEND_CHAT)
	DllStructSetData($mWriteChat, 1, GetValue('CommandWriteChat'))
	DllStructSetData($mRequestQuote, 1, GetValue('CommandRequestQuote'))
	DllStructSetData($mRequestQuoteSell, 1, GetValue('CommandRequestQuoteSell'))
	DllStructSetData($mTraderBuy, 1, GetValue('CommandTraderBuy'))
	DllStructSetData($mTraderSell, 1, GetValue('CommandTraderSell'))
	DllStructSetData($mSalvage, 1, GetValue('CommandSalvage'))
	DllStructSetData($mIncreaseAttribute, 1, GetValue('CommandIncreaseAttribute'))
	DllStructSetData($mDecreaseAttribute, 1, GetValue('CommandDecreaseAttribute'))
	DllStructSetData($mMakeAgentArray, 1, GetValue('CommandMakeAgentArray'))
	DllStructSetData($mChangeStatus, 1, GetValue('CommandChangeStatus'))

	If $bChangeTitle Then WinSetTitle($mGWWindowHandle, '', 'Guild Wars - ' & GetCharname())
	Return $mGWWindowHandle
EndFunc   ;==>Initialize

Func Disconnected()
	Local $lCheck = False
	Local $lDeadlock = TimerInit()
	Do
		Sleep(20)
		$lCheck = GetMapLoading() <> 2 And GetAgentExists(-2)
	Until $lCheck Or TimerDiff($lDeadlock) > 5000
	If $lCheck = False Then
		Out('Disconnected!')
		Out('Attempting to reconnect.')
		ControlSend(GetWindowHandle(), '', '', '{Enter}')
		$lDeadlock = TimerInit()
		Do
			Sleep(20)
			$lCheck = GetMapLoading() <> 2 And GetAgentExists(-2)
		Until $lCheck Or TimerDiff($lDeadlock) > 60000
		If $lCheck = False Then
			Out('Failed to Reconnect 1!')
			Out('Retrying.')
			ControlSend(GetWindowHandle(), '', '', '{Enter}')
			$lDeadlock = TimerInit()
			Do
				Sleep(20)
				$lCheck = GetMapLoading() <> 2 And GetAgentExists(-2)
			Until $lCheck Or TimerDiff($lDeadlock) > 60000
			If $lCheck = False Then
				Out('Failed to Reconnect 2!')
				Out('Retrying.')
				ControlSend(GetWindowHandle(), '', '', '{Enter}')
				$lDeadlock = TimerInit()
				Do
					Sleep(20)
					$lCheck = GetMapLoading() <> 2 And GetAgentExists(-2)
				Until $lCheck Or TimerDiff($lDeadlock) > 60000
				If $lCheck = False Then
					Out('Could not reconnect!')
					Out('Exiting.')
					EnableRendering()
					Exit 1
				EndIf
			EndIf
		EndIf
	EndIf
	Out('Reconnected!')
	Sleep(5000)
EndFunc   ;==>Disconnected

;~ Description: attempts to get correct $MyID and $MyPtr.
;~ Called in WaitMapLoading() and Disconnected().
Func SetPointers()
	Local $lDeadlock = TimerInit()
	Do
		Do
			If TimerDiff($lDeadlock) > 15000 Then Return False
			Sleep(1000)
			$MyID = MemoryRead($mMyID)
		Until $MyID > 0
		$MyPtr = GetAgentPtr($MyID)
	Until $MyID = MemoryRead($MyPtr + 44, 'long')
	Return True
EndFunc   ;==>SetPointers

;~ Description: Internal use only.
Func GetValue($aKey)
	For $i = 1 To $mLabels[0][0]
		If $mLabels[$i][0] = $aKey Then Return Number($mLabels[$i][1])
	Next
	Return -1
EndFunc   ;==>GetValue

;~ Description: Internal use only.
Func SetValue($aKey, $aValue)
	$mLabels[0][0] += 1
	ReDim $mLabels[$mLabels[0][0] + 1][2]
	$mLabels[$mLabels[0][0]][0] = $aKey
	$mLabels[$mLabels[0][0]][1] = $aValue
EndFunc   ;==>SetValue

;~ Description: Internal use only.
Func GetAgentMovementPtr()
	Local $offset[4] = [0, 24, 8, 232]
	Local $lPtr = MemoryReadPtr($mBasePointer, $offset, "ptr")
	Return $lPtr[1]
EndFunc   ;==>GetAgentMovementPtr

;~ Description: Internal use only.
Func Scan()
	Local $lGwBase = ScanForProcess()
	$mASMSize = 0
	$mASMCodeOffset = 0
	$mASMString = ''

	_('MainModPtr/4')
	_('ScanBasePointer:')
	AddPattern('506A0F6A00FF35')
	_('ScanAgentBase:')
	AddPattern('538B5D0C568B7508895DD885')
	_('ScanCurrentTarget:')
	AddPattern('83C4085B8BE55DC355')
	_('ScanMyID:')
	AddPattern('83EC08568BF13B15')
	_('ScanEngine:')
	AddPattern('56FFD083C4048B4E0485C9')
	_('ScanRenderFunc:')
	AddPattern('8D85E0FDFFFF6A0050')
	_('ScanLoadFinished:')
	AddPattern('8B561C8BCF52E8')
	_('ScanPostMessage:')
	AddPattern('6AFF6A00680180')
	_('ScanTargetLog:')
	AddPattern('5356578BFA894DF4E8')
	_('ScanChangeTargetFunction:')
	AddPattern('538B5D0C568B7508895DD8')
	_('ScanMoveFunction:')
	AddPattern('558BEC83EC208D45F0')
	_('ScanPing:')
	AddPattern('568B750889165E')
	_('ScanMapID:')
	AddPattern('558BEC8B450885C074078B')
	_('ScanMapLoading:')
	AddPattern('6A2C50E8')
	_('ScanLoggedIn:')
	AddPattern('85C07411B807')
	_('ScanMapInfo:')
	AddPattern('8BF0EB038B750C3B')
	_('ScanUseSkillFunction:')
	AddPattern('85F6745B83FE1174')
	_('ScanPacketSendFunction:')
	AddPattern('F7D9C74754010000001BC981')
	_('ScanBaseOffset:')
	AddPattern('83C40433C08BE55DC3A1')
	_('ScanWriteChatFunction:')
	AddPattern('558BEC83EC08FF750C')
	_('ScanSkillLog:')
	AddPattern('558BEC568B750885F67514680E05')
	_('ScanSkillCompleteLog:')
	AddPattern('741D6A006A40')
	_('ScanSkillCancelLog:')
	AddPattern('741D6A006A48')
	_('ScanChatLog:')
	AddPattern('8B45F48B138B4DEC50')
	_('ScanSellItemFunction:')
	AddPattern('8B4D2085C90F858E')
	_('ScanStringLog:')
	AddPattern('8D4900FF7508FF34B7')
	_('ScanAgentNameLog:')
	AddPattern('83C4088B471C83C81050FF7508')
	_('ScanStringFilter1:')
	AddPattern('8B368B4F2C6A006A008B06')
	_('ScanStringFilter2:')
	AddPattern('515356578BF933D28B4F2C')
	_('ScanActionFunction:')
	AddPattern('8B7508578BF983FE09750C6876')
	_('ScanActionBase:')
	AddPattern('8D1C87899DF4FEFFFF8BC32BC7C1F802')
	_('ScanSkillBase:')
	AddPattern('8D04B6C1E00505')
	_('ScanUseHeroSkillFunction:')
	AddPattern('BA02000000B954080000')
	_('ScanTransactionFunction:')
	AddPattern('85FF741D8B4D14EB08')
	_('ScanBuyItemBase:')
	AddPattern('D9EED9580CC74004')
	_('ScanRequestQuoteFunction:')
	AddPattern('83C4245B8BE55D')
	_('ScanTraderFunction:')
	AddPattern('83FF10761468D2210000')
	_('ScanTraderHook:')
	AddPattern('50516A466A06')
	_('ScanSleep:')
	AddPattern('5F5E5B741A6860EA0000')
	_('ScanSalvageFunction:')
	AddPattern('33C58945FC8B45088945F08B450C8945F48B45108945F88D45EC506A10C745EC75')
	_('ScanSalvageGlobal:')
	AddPattern('8B5104538945F48B4108568945E88B410C578945EC8B4110528955E48945F0')
	_('ScanIncreaseAttributeFunction:')
	AddPattern('8B7D088B702C8B1F3B9E00050000')
	_('ScanDecreaseAttributeFunction:')
	AddPattern('8B8AA800000089480C5DC3CC')
	_('ScanSkillTimer:')
	AddPattern('FFD68B4DF08BD88B4708')
	_('ScanClickToMoveFix:')
	AddPattern('3DD301000074')
	_('ScanZoomStill:')
	AddPattern('558BEC8B41085685C0')
	_('ScanZoomMoving:')
	AddPattern('EB358B4304')
	_('ScanBuildNumber:')
	AddPattern('558BEC83EC4053568BD9')
	_('ScanChangeStatusFunction:')
	AddPattern('558BEC568B750883FE047C14')
	_('ScanReadChatFunction:')
	AddPattern('A128B6EB00')
	_('ScanDialogLog:')
	AddPattern('8B45088945FC8D45F8506A08C745F83A')
	_('ScanTradeHack:')
	AddPattern('8BEC8B450883F846')
	_('ScanClickCoords:')
	AddPattern('8B451C85C0741CD945F8')

	_('ScanProc:')
	_('pushad')
	_('mov ecx,' & Hex($lGwBase, 8))
	_('mov esi,ScanProc')
	_('ScanLoop:')
	_('inc ecx')
	_('mov al,byte[ecx]')
	_('mov edx,ScanBasePointer')

	_('ScanInnerLoop:')
	_('mov ebx,dword[edx]')
	_('cmp ebx,-1')
	_('jnz ScanContinue')
	_('add edx,50')
	_('cmp edx,esi')
	_('jnz ScanInnerLoop')
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8)))
	_('jnz ScanLoop')
	_('jmp ScanExit')

	_('ScanContinue:')
	_('lea edi,dword[edx+ebx]')
	_('add edi,C')
	_('mov ah,byte[edi]')
	_('cmp al,ah')
	_('jz ScanMatched')
	_('mov dword[edx],0')
	_('add edx,50')
	_('cmp edx,esi')
	_('jnz ScanInnerLoop')
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8)))
	_('jnz ScanLoop')
	_('jmp ScanExit')

	_('ScanMatched:')
	_('inc ebx')
	_('mov edi,dword[edx+4]')
	_('cmp ebx,edi')
	_('jz ScanFound')
	_('mov dword[edx],ebx')
	_('add edx,50')
	_('cmp edx,esi')
	_('jnz ScanInnerLoop')
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8)))
	_('jnz ScanLoop')
	_('jmp ScanExit')

	_('ScanFound:')
	_('lea edi,dword[edx+8]')
	_('mov dword[edi],ecx')
	_('mov dword[edx],-1')
	_('add edx,50')
	_('cmp edx,esi')
	_('jnz ScanInnerLoop')
	_('cmp ecx,' & SwapEndian(Hex($lGwBase + 5238784, 8)))
	_('jnz ScanLoop')

	_('ScanExit:')
	_('popad')
	_('retn')

	$mBase = $lGwBase + 0x9DF000
	Local $lScanMemory = MemoryRead($mBase, 'ptr')
	If $lScanMemory = 0 Then
		$mMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $mASMSize, 'dword', 0x1000, 'dword', 0x40)
		$mMemory = $mMemory[0]
		MemoryWrite($mBase, $mMemory)
	Else
		$mMemory = $lScanMemory
	EndIf

	CompleteASMCode()

	If $lScanMemory = 0 Then
		WriteBinary($mASMString, $mMemory + $mASMCodeOffset)
		Local $lThread = DllCall($mKernelHandle, 'int', 'CreateRemoteThread', 'int', $mGWProcHandle, 'ptr', 0, 'int', 0, 'int', GetLabelInfo('ScanProc'), 'ptr', 0, 'int', 0, 'int', 0)
		$lThread = $lThread[0]
		Local $lResult
		Do
			$lResult = DllCall($mKernelHandle, 'int', 'WaitForSingleObject', 'int', $lThread, 'int', 50)
		Until $lResult[0] <> 258
		DllCall($mKernelHandle, 'int', 'CloseHandle', 'int', $lThread)
	EndIf
EndFunc   ;==>Scan

Func ScanForProcess()
	Local $lCharNameCode = BinaryToString('0x558BEC83EC105356578B7D0833F63BFE')
	Local $lCurrentSearchAddress = 0x00000000
	Local $lMBI[7], $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
	Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i

	While $lCurrentSearchAddress < 0x01F00000
		Local $lMBI[7]
		DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
		For $i = 0 To 6
			$lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
		Next
		If $lMBI[4] = 4096 Then
			Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')

			$lTmpMemData = DllStructGetData($lBuffer, 1)
			$lTmpMemData = BinaryToString($lTmpMemData)

			$lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
			If $lSearch > 0 Then
				Return $lMBI[0]
			EndIf
		EndIf
		$lCurrentSearchAddress += $lMBI[3]
	WEnd
	Return ''
EndFunc   ;==>ScanForProcess

;~ Description: Internal use only.
Func AddPattern($aPattern)
	Local $lSize = Int(0.5 * StringLen($aPattern))
	$mASMString &= '00000000' & SwapEndian(Hex($lSize, 8)) & '00000000' & $aPattern
	$mASMSize += $lSize + 12
	For $i = 1 To 68 - $lSize
		$mASMSize += 1
		$mASMString &= '00'
	Next
EndFunc   ;==>AddPattern

;~ Description: Internal use only.
Func GetScannedAddress($aLabel, $aOffset)
	Return MemoryRead(GetLabelInfo($aLabel) + 8) - MemoryRead(GetLabelInfo($aLabel) + 4) + $aOffset
EndFunc   ;==>GetScannedAddress

;~ Description: Internal use only.
Func ScanForCharname()
	Local $lCharNameCode = BinaryToString('0xCCCCCC558BEC5166')
	Local $lCurrentSearchAddress = 0x00000000
	Local $lMBI[7], $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
	Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i

	While $lCurrentSearchAddress < 0x01F00000
		Local $lMBI[7]
		DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
		For $i = 0 To 6
			$lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
		Next
		If $lMBI[4] = 4096 Then
			Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')

			$lTmpMemData = DllStructGetData($lBuffer, 1)
			$lTmpMemData = BinaryToString($lTmpMemData)

			$lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
			If $lSearch > 0 Then
				$lTmpAddress = $lCurrentSearchAddress + $lSearch - 1
				DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lTmpAddress + 10, 'ptr', DllStructGetPtr($lTmpBuffer), 'int', DllStructGetSize($lTmpBuffer), 'int', '')
				$mCharname = DllStructGetData($lTmpBuffer, 1)
				Return GetCharname()
			EndIf
		EndIf
		$lCurrentSearchAddress += $lMBI[3]
	WEnd
	Return ''
EndFunc   ;==>ScanForCharname#EndRegion Initialisation
#EndRegion Initialisation

#Region Process
;~ Description: Internal use for handing -1 and -2 agent IDs.
Func ConvertID($aID)
	If $aID = -2 Then
		Return GetMyID()
	ElseIf $aID = -1 Then
		Return GetCurrentTargetID()
	Else
		Return $aID
	EndIf
EndFunc   ;==>ConvertID

;~ Description: Internal use only.
Func SendPacket($aSize, $aHeader, $aParam1 = 0, $aParam2 = 0, $aParam3 = 0, $aParam4 = 0, $aParam5 = 0, $aParam6 = 0, $aParam7 = 0, $aParam8 = 0, $aParam9 = 0, $aParam10 = 0)
	If GetAgentExists(-2) Then
		DllStructSetData($mPacket, 2, $aSize)
		DllStructSetData($mPacket, 3, $aHeader)
		DllStructSetData($mPacket, 4, $aParam1)
		DllStructSetData($mPacket, 5, $aParam2)
		DllStructSetData($mPacket, 6, $aParam3)
		DllStructSetData($mPacket, 7, $aParam4)
		DllStructSetData($mPacket, 8, $aParam5)
		DllStructSetData($mPacket, 9, $aParam6)
		DllStructSetData($mPacket, 10, $aParam7)
		DllStructSetData($mPacket, 11, $aParam8)
		DllStructSetData($mPacket, 12, $aParam9)
		DllStructSetData($mPacket, 13, $aParam10)
		Enqueue($mPacketPtr, 52)
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SendPacket

;~ Description: Internal use only.
Func PerformAction($aAction, $aFlag)
	If GetAgentExists(-2) Then
		DllStructSetData($mAction, 2, $aAction)
		DllStructSetData($mAction, 3, $aFlag)
		Enqueue($mActionPtr, 12)
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>PerformAction

;~ Description: Internal use only.
Func Bin64ToDec($aBinary)
	Local $lReturn = 0

	For $i = 1 To StringLen($aBinary)
		If StringMid($aBinary, $i, 1) == 1 Then $lReturn += 2 ^ ($i - 1)
	Next

	Return $lReturn
EndFunc   ;==>Bin64ToDec

;~ Description: Internal use only.
Func Base64ToBin64($aCharacter)
	Select
		Case $aCharacter == 'A'
			Return '000000'
		Case $aCharacter == 'B'
			Return '100000'
		Case $aCharacter == 'C'
			Return '010000'
		Case $aCharacter == 'D'
			Return '110000'
		Case $aCharacter == 'E'
			Return '001000'
		Case $aCharacter == 'F'
			Return '101000'
		Case $aCharacter == 'G'
			Return '011000'
		Case $aCharacter == 'H'
			Return '111000'
		Case $aCharacter == 'I'
			Return '000100'
		Case $aCharacter == 'J'
			Return '100100'
		Case $aCharacter == 'K'
			Return '010100'
		Case $aCharacter == 'L'
			Return '110100'
		Case $aCharacter == 'M'
			Return '001100'
		Case $aCharacter == 'N'
			Return '101100'
		Case $aCharacter == 'O'
			Return '011100'
		Case $aCharacter == 'P'
			Return '111100'
		Case $aCharacter == 'Q'
			Return '000010'
		Case $aCharacter == 'R'
			Return '100010'
		Case $aCharacter == 'S'
			Return '010010'
		Case $aCharacter == 'T'
			Return '110010'
		Case $aCharacter == 'U'
			Return '001010'
		Case $aCharacter == 'V'
			Return '101010'
		Case $aCharacter == 'W'
			Return '011010'
		Case $aCharacter == 'X'
			Return '111010'
		Case $aCharacter == 'Y'
			Return '000110'
		Case $aCharacter == 'Z'
			Return '100110'
		Case $aCharacter == 'a'
			Return '010110'
		Case $aCharacter == 'b'
			Return '110110'
		Case $aCharacter == 'c'
			Return '001110'
		Case $aCharacter == 'd'
			Return '101110'
		Case $aCharacter == 'e'
			Return '011110'
		Case $aCharacter == 'f'
			Return '111110'
		Case $aCharacter == 'g'
			Return '000001'
		Case $aCharacter == 'h'
			Return '100001'
		Case $aCharacter == 'i'
			Return '010001'
		Case $aCharacter == 'j'
			Return '110001'
		Case $aCharacter == 'k'
			Return '001001'
		Case $aCharacter == 'l'
			Return '101001'
		Case $aCharacter == 'm'
			Return '011001'
		Case $aCharacter == 'n'
			Return '111001'
		Case $aCharacter == 'o'
			Return '000101'
		Case $aCharacter == 'p'
			Return '100101'
		Case $aCharacter == 'q'
			Return '010101'
		Case $aCharacter == 'r'
			Return '110101'
		Case $aCharacter == 's'
			Return '001101'
		Case $aCharacter == 't'
			Return '101101'
		Case $aCharacter == 'u'
			Return '011101'
		Case $aCharacter == 'v'
			Return '111101'
		Case $aCharacter == 'w'
			Return '000011'
		Case $aCharacter == 'x'
			Return '100011'
		Case $aCharacter == 'y'
			Return '010011'
		Case $aCharacter == 'z'
			Return '110011'
		Case $aCharacter == '0'
			Return '001011'
		Case $aCharacter == '1'
			Return '101011'
		Case $aCharacter == '2'
			Return '011011'
		Case $aCharacter == '3'
			Return '111011'
		Case $aCharacter == '4'
			Return '000111'
		Case $aCharacter == '5'
			Return '100111'
		Case $aCharacter == '6'
			Return '010111'
		Case $aCharacter == '7'
			Return '110111'
		Case $aCharacter == '8'
			Return '001111'
		Case $aCharacter == '9'
			Return '101111'
		Case $aCharacter == '+'
			Return '011111'
		Case $aCharacter == '/'
			Return '111111'
	EndSelect
EndFunc   ;==>Base64ToBin64

;~ Description: Returns window handle of Guild Wars.
Func GetWindowHandle()
	Return $mGWWindowHandle
EndFunc   ;==>GetWindowHandle

; Description: Returns a string containing the process name that belongs to a given PID.
Func __ProcessGetName($i_PID)
	If Not ProcessExists($i_PID) Then Return SetError(1, 0, '')
	If Not @error Then
		Local $a_Processes = ProcessList()
		For $i = 1 To $a_Processes[0][0]
			If $a_Processes[$i][1] = $i_PID Then Return $a_Processes[$i][0]
		Next
	EndIf
	Return SetError(1, 0, '')
EndFunc   ;==>__ProcessGetName

;~ Description: Converts float to integer.
Func FloatToInt($nFloat)
	Local $tFloat = DllStructCreate('float')
	Local $tInt = DllStructCreate('int', DllStructGetPtr($tFloat))
	DllStructSetData($tFloat, 1, $nFloat)
	Return DllStructGetData($tInt, 1)
EndFunc   ;==>FloatToInt
#EndRegion Process

#Region CallBack
;~ Description: Controls Event System.
Func SetEvent($aSkillActivate = '', $aSkillCancel = '', $aSkillComplete = '', $aChatReceive = '', $aLoadFinished = '')
	If Not $mUseEventSystem Then Return
	If $aSkillActivate <> '' Then
		WriteDetour('SkillLogStart', 'SkillLogProc')
	Else
		$mASMString = ''
		_('mov ebp,esp')
		_('push dword[ebp+8]')
		WriteBinary($mASMString, GetValue('SkillLogStart'))
	EndIf

	If $aSkillCancel <> '' Then
		WriteDetour('SkillCancelLogStart', 'SkillCancelLogProc')
	Else
		$mASMString = ''
		_('push 0')
		_('push 42')
		_('mov ecx,esi')
		WriteBinary($mASMString, GetValue('SkillCancelLogStart'))
	EndIf

	If $aSkillComplete <> '' Then
		WriteDetour('SkillCompleteLogStart', 'SkillCompleteLogProc')
	Else
		$mASMString = ''
		_('mov eax,dword[edi+4]')
		_('test eax,eax')
		WriteBinary($mASMString, GetValue('SkillCompleteLogStart'))
	EndIf

	If $aChatReceive <> '' Then
		WriteDetour('ChatLogStart', 'ChatLogProc')
	Else
		$mASMString = ''
		_('add edi,E')
		_('cmp eax,B')
		WriteBinary($mASMString, GetValue('ChatLogStart'))
	EndIf

	$mSkillActivate = $aSkillActivate
	$mSkillCancel = $aSkillCancel
	$mSkillComplete = $aSkillComplete
	$mChatReceive = $aChatReceive
	$mLoadFinished = $aLoadFinished
EndFunc   ;==>SetEvent

;~ Description: Internal use for event system.
;~ modified by gigi, avoid getagentbyid, just pass agent id to callback
Func Event($hwnd, $msg, $wparam, $lparam)
	Switch $lparam
		Case 0x1
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mSkillLogStructPtr, 'int', 16, 'int', '')
			Call($mSkillActivate, DllStructGetData($mSkillLogStruct, 1), DllStructGetData($mSkillLogStruct, 2), DllStructGetData($mSkillLogStruct, 3), DllStructGetData($mSkillLogStruct, 4))
		Case 0x2
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mSkillLogStructPtr, 'int', 16, 'int', '')
			Call($mSkillCancel, DllStructGetData($mSkillLogStruct, 1), DllStructGetData($mSkillLogStruct, 2), DllStructGetData($mSkillLogStruct, 3))
		Case 0x3
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mSkillLogStructPtr, 'int', 16, 'int', '')
			Call($mSkillComplete, DllStructGetData($mSkillLogStruct, 1), DllStructGetData($mSkillLogStruct, 2), DllStructGetData($mSkillLogStruct, 3))
		Case 0x4
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $wparam, 'ptr', $mChatLogStructPtr, 'int', 512, 'int', '')
			Local $lMessage = DllStructGetData($mChatLogStruct, 2)
			Local $lChannel
			Local $lSender
			Switch DllStructGetData($mChatLogStruct, 1)
				Case 0
					$lChannel = 'Alliance'
					$lSender = StringMid($lMessage, 6, StringInStr($lMessage, '</a>') - 6)
					$lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, '<quote>') + 6)
				Case 3
					$lChannel = 'All'
					$lSender = StringMid($lMessage, 6, StringInStr($lMessage, '</a>') - 6)
					$lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, '<quote>') + 6)
				Case 9
					$lChannel = 'Guild'
					$lSender = StringMid($lMessage, 6, StringInStr($lMessage, '</a>') - 6)
					$lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, '<quote>') + 6)
				Case 11
					$lChannel = 'Team'
					$lSender = StringMid($lMessage, 6, StringInStr($lMessage, '</a>') - 6)
					$lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, '<quote>') + 6)
				Case 12
					$lChannel = 'Trade'
					$lSender = StringMid($lMessage, 6, StringInStr($lMessage, '</a>') - 6)
					$lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, '<quote>') + 6)
				Case 10
					If StringLeft($lMessage, 3) == '-> ' Then
						$lChannel = 'Sent'
						$lSender = StringMid($lMessage, 10, StringInStr($lMessage, '</a>') - 10)
						$lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, '<quote>') + 6)
					Else
						$lChannel = 'Global'
						$lSender = 'Guild Wars'
					EndIf
				Case 13
					$lChannel = 'Advisory'
					$lSender = 'Guild Wars'
					$lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, '<quote>') + 6)
				Case 14
					$lChannel = 'Whisper'
					$lSender = StringMid($lMessage, 7, StringInStr($lMessage, '</a>') - 7)
					$lMessage = StringTrimLeft($lMessage, StringInStr($lMessage, '<quote>') + 6)
				Case Else
					$lChannel = 'Other'
					$lSender = 'Other'
			EndSwitch
			Call($mChatReceive, $lChannel, $lSender, $lMessage)
		Case 0x5
			Call($mLoadFinished)
	EndSwitch
EndFunc   ;==>Event
#EndRegion CallBack

#Region Modification
Func ModifyMemory()
	$mASMSize = 0
	$mASMCodeOffset = 0
	$mASMString = ''
	CreateData()
	CreateMain()
;~ 	CreateTargetLog()
	CreateSkillLog()
;~ 	CreateSkillCancelLog()
;~ 	CreateSkillCompleteLog()
;~ 	CreateChatLog()
	CreateTraderHook()
;~ 	CreateLoadFinished()
;~ 	CreateStringLog()
;~ 	CreateStringFilter1()
;~ 	CreateStringFilter2()
	CreateRenderingMod()
	CreateCommands()
	CreateDialogHook()
	CreateAgentNameLog()
	$mMemory = MemoryRead(MemoryRead($mBase), 'ptr')

	Switch $mMemory
		Case 0
			$mMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $mASMSize, 'dword', 0x1000, 'dword', 64)
			$mMemory = $mMemory[0]
			MemoryWrite(MemoryRead($mBase), $mMemory)
			CompleteASMCode()
			WriteBinary($mASMString, $mMemory + $mASMCodeOffset)
			$SecondInject = $mMemory + $mASMCodeOffset
;~ 			WriteBinary('83F8009090', GetValue('ClickToMoveFix'))
			MemoryWrite(GetValue('QueuePtr'), GetValue('QueueBase'))
			MemoryWrite(GetValue('SkillLogPtr'), GetValue('SkillLogBase'))
;~ 			MemoryWrite(GetValue('ChatRevAdr'), GetValue('ChatRevBase'))
;~ 			MemoryWrite(GetValue('ChatLogPtr'), GetValue('ChatLogBase'))
;~ 			MemoryWrite(GetValue('StringLogPtr'), GetValue('StringLogBase'))
		Case Else
			CompleteASMCode()
	EndSwitch
	WriteDetour('MainStart', 'MainProc')
;~ 	WriteDetour('TargetLogStart', 'TargetLogProc')
	WriteDetour('TraderHookStart', 'TraderHookProc')
;~ 	WriteDetour('LoadFinishedStart', 'LoadFinishedProc')
	WriteDetour('RenderingMod', 'RenderingModProc')
;~ 	WriteDetour('StringLogStart', 'StringLogProc')
;~ 	WriteDetour('StringFilter1Start', 'StringFilter1Proc')
;~ 	WriteDetour('StringFilter2Start', 'StringFilter2Proc')
	WriteDetour('DialogLogStart', 'DialogLogProc')
;~ 	WriteDetour('ChatLogStart1', 'ChatLogProc1'); added
	WriteDetour("AgentNameLogStart", "AgentNameLogProc")
EndFunc   ;==>ModifyMemory

;~ Description: Internal use only.
Func WriteDetour($aFrom, $aTo)
	WriteBinary('E9' & SwapEndian(Hex(GetLabelInfo($aTo) - GetLabelInfo($aFrom) - 5)), GetLabelInfo($aFrom))
EndFunc   ;==>WriteDetour

;~ Description: Internal use only.
Func CreateData()
	_('CallbackHandle/4')
	_('QueueCounter/4')
	_('SkillLogCounter/4')
	_('ChatLogCounter/4')
	_('ChatLogLastMsg/4')
	_('MapIsLoaded/4')
	_('NextStringType/4')
	_('EnsureEnglish/4')
	_('TraderQuoteID/4')
	_('TraderCostID/4')
	_('TraderCostValue/4')
	_('DisableRendering/4')

	_('QueueBase/' & 256 * GetValue('QueueSize'))
	_('TargetLogBase/' & 4 * GetValue('TargetLogSize'))
	_('SkillLogBase/' & 16 * GetValue('SkillLogSize'))
	_('StringLogBase/' & 256 * GetValue('StringLogSize'))
	_('ChatLogBase/' & 512)
	_('AgentNameLogBase/' & 256 * GetValue('AgentNameLogMaxSize'))
	_('AgentNameLogCurrentSize/4')

	_('LastDialogID/4')
	_('AgentCopyCount/4')
	_('AgentCopyBase/' & 0x1C0 * 256)
EndFunc   ;==>CreateData

;~ Description: Internal use only.
Func CreateMain()
	_('MainProc:')
	_('nop x')
	_('pushad')
	_('mov eax,dword[EnsureEnglish]')
	_('test eax,eax')
	_('jz MainMain')
	_('mov ecx,dword[BasePointer]')
	_('mov ecx,dword[ecx+18]')
	_('mov ecx,dword[ecx+18]')
	_('mov ecx,dword[ecx+194]')
	_('mov al,byte[ecx+4f]')
	_('cmp al,f')
	_('ja MainMain')
	_('mov ecx,dword[ecx+4c]')
	_('mov al,byte[ecx+3f]')
	_('cmp al,f')
	_('ja MainMain')
	_('mov eax,dword[ecx+40]')
	_('test eax,eax')
	_('jz MainMain')

	_('MainMain:')
	_('mov eax,dword[QueueCounter]')
	_('mov ecx,eax')
	_('shl eax,8')
	_('add eax,QueueBase')
	_('mov ebx,dword[eax]')
	_('test ebx,ebx')

	_('jz MainExit')
	_('push ecx')
	_('mov dword[eax],0')
	_('jmp ebx')
	_('CommandReturn:')
	_('pop eax')
	_('inc eax')
	_('cmp eax,QueueSize')
	_('jnz MainSkipReset')
	_('xor eax,eax')
	_('MainSkipReset:')
	_('mov dword[QueueCounter],eax')
	_('MainExit:')
	_('popad')

	_('mov ebp,esp')
	_('fld st(0),dword[ebp+8]')

	_('ljmp MainReturn')
EndFunc   ;==>CreateMain

Func CreateTargetLog()
	_('TargetLogProc:')
	_('cmp ecx,4')
	_('jz TargetLogMain')
	_('cmp ecx,32')
	_('jz TargetLogMain')
	_('cmp ecx,3C')
	_('jz TargetLogMain')
	_('jmp TargetLogExit')

	_('TargetLogMain:')
	_('pushad')
	_('mov ecx,dword[ebp+8]')
	_('test ecx,ecx')
	_('jnz TargetLogStore')
	_('mov ecx,edx')

	_('TargetLogStore:')
	_('lea eax,dword[edx*4+TargetLogBase]')
	_('mov dword[eax],ecx')
	_('popad')

	_('TargetLogExit:')
	_('push ebx')
	_('push esi')
	_('push edi')
	_('mov edi,edx')
	_('ljmp TargetLogReturn')
EndFunc   ;==>CreateTargetLog

;~ Description: Internal use only.
Func CreateAgentNameLog()
	_('AgentNameLogProc:')
	_('add esp,8')
	_('cmp byte[edi+17],0 -> 80 7F 17 00')

	_('push eax')
	_('push ebx')
	_('push ecx')
	_('push edx')

	; CHECK RANGE
	_('AgentNameLogRangeCheck:')
	_('mov edx,AgentNameLogCurrentSize')
	_('mov edx,[edx] -> 8b 12')
	_('cmp edx,AgentNameLogMaxSize')
	_('jb AgentNameSetBase')
	_('mov edx,AgentNameLogCurrentSize')
	_('mov ecx,0')
	_('mov [edx],ecx -> 89 0a') ; reset log
	_('mov edx,0')

	; FIND CORRECT POSITION IN OUR STORAGE
	_('AgentNameSetBase:')
	_('mov ebx,AgentNameLogBase') ; set base
	_('mov ecx,0') ; count
	_('AgentNameSetBaseLoop:')
	_('cmp edx,ecx -> 39 ca')
	_('je AgentNameLogCopy')
	_('add ecx,1')
	_('add ebx,100')
	_('jmp AgentNameSetBaseLoop')

	; COPY TEXT SETUP
	_('AgentNameLogCopy:')

	_('inc edx')
	_('mov dword[AgentNameLogCurrentSize],edx')
	_('mov edx,0')

	_('mov ecx,eax')
	_('add ecx,1c')
	_('mov ecx,[ecx] -> 8B 09')
	_('mov ax,word ptr [ebp+0x58] -> 66 8b 45 58')
	_('mov word[ebx],ax -> 66 89 03')
	_('add ebx,2')

	; COPY TEXT LOOP
	_('AgentNameLogCopyLoop:')
	_('mov dx,[ecx] -> 66 8b 11')

	_('cmp dx,1 -> 66 83 fa 01')
	_('je AgentNameLogExit')

	_('mov word[ebx],dx -> 66 89 13')
	_('add ecx,2')
	_('add ebx,2')
	_('jmp AgentNameLogCopyLoop')

	_('AgentNameLogExit:')
	_('pop edx')
	_('pop ecx')
	_('pop ebx')
	_('pop eax')
	_('ljmp AgentNameLogReturn')
EndFunc   ;==>CreateAgentNameLog

Func CreateSkillLog()
	_('SkillLogProc:')
	_('pushad')

	_('mov eax,dword[SkillLogCounter]')
	_('push eax')
	_('shl eax,4')
	_('add eax,SkillLogBase')

	_('mov dword[eax],edi')
	_('mov dword[eax+4],ecx')
	_('mov dword[eax+8],ebx')

	_('push 1')
	_('push eax')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('pop eax')
	_('inc eax')
	_('cmp eax,SkillLogSize')
	_('jnz SkillLogSkipReset')
	_('xor eax,eax')
	_('SkillLogSkipReset:')
	_('mov dword[SkillLogCounter],eax')

	_('popad')
	_('mov ebp,esp')
	_('push dword[ebp+8]')
	_('ljmp SkillLogReturn')
EndFunc   ;==>CreateSkillLog

;~ Description: Internal use only.
Func CreateSkillCancelLog()
	_('SkillCancelLogProc:')
	_('pushad')

	_('mov eax,dword[SkillLogCounter]')
	_('push eax')
	_('shl eax,4')
	_('add eax,SkillLogBase')

	_('mov ecx,dword[edi]')
	_('mov dword[eax],ecx')
	_('mov ecx,dword[ecx*4+TargetLogBase]')
	_('mov dword[eax+4],ecx')
	_('mov ecx,dword[edi+4]')
	_('mov dword[eax+8],ecx')

	_('push 2')
	_('push eax')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('pop eax')
	_('inc eax')
	_('cmp eax,SkillLogSize')
	_('jnz SkillCancelLogSkipReset')
	_('xor eax,eax')
	_('SkillCancelLogSkipReset:')
	_('mov dword[SkillLogCounter],eax')

	_('popad')
	_('push 0')
	_('push 48')
	_('mov ecx,esi')
	_('ljmp SkillCancelLogReturn')
EndFunc   ;==>CreateSkillCancelLog

Func CreateSkillCancelLog_Old()
	_("SkillCancelLogProc:")
	_("pushad")

	_("mov eax,dword[SkillLogCounter]")
	_("push eax")
	_("shl eax,4")
	_("add eax,SkillLogBase")

	_("mov ecx,dword[edi]")
	_("mov dword[eax],ecx")
	_("mov ecx,dword[ecx*4+TargetLogBase]")
	_("mov dword[eax+4],ecx")
	_("mov ecx,dword[edi+4]")
	_("mov dword[eax+8],ecx")

	_("push 2")
	_("push eax")
	_("push CallbackEvent")
	_("push dword[CallbackHandle]")
	_("call dword[PostMessage]")

	_("pop eax")
	_("inc eax")
	_("cmp eax,SkillLogSize")
	_("jnz SkillCancelLogSkipReset")
	_("xor eax,eax")
	_("SkillCancelLogSkipReset:")
	_("mov dword[SkillLogCounter],eax")
	_("popad")
	_("push 0")
	_("push 42")
	_("mov ecx,esi")
	_("ljmp SkillCancelLogReturn")
EndFunc

;~ Description: Internal use only.
Func CreateSkillCompleteLog()
	_('SkillCompleteLogProc:')
	_('pushad')

	_('mov eax,dword[SkillLogCounter]')
	_('push eax')
	_('shl eax,4')
	_('add eax,SkillLogBase')

	_('mov ecx,dword[edi]')
	_('mov dword[eax],ecx')
	_('mov ecx,dword[ecx*4+TargetLogBase]')
	_('mov dword[eax+4],ecx')
	_('mov ecx,dword[edi+4]')
	_('mov dword[eax+8],ecx')

	_('push 3')
	_('push eax')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('pop eax')
	_('inc eax')
	_('cmp eax,SkillLogSize')
	_('jnz SkillCompleteLogSkipReset')
	_('xor eax,eax')
	_('SkillCompleteLogSkipReset:')
	_('mov dword[SkillLogCounter],eax')

	_('popad')
	_('mov eax,dword[edi+4]')
	_('test eax,eax')
	_('ljmp SkillCompleteLogReturn')
EndFunc   ;==>CreateSkillCompleteLog

;~ Description: Internal use only.
Func CreateChatLog()
	_('ChatLogProc:')

	_('pushad')
	_('mov ecx,dword[esp+1F4]')
	_('mov ebx,eax')
	_('mov eax,dword[ChatLogCounter]')
	_('push eax')
	_('shl eax,9')
	_('add eax,ChatLogBase')
	_('mov dword[eax],ebx')

	_('mov edi,eax')
	_('add eax,4')
	_('xor ebx,ebx')

	_('ChatLogCopyLoop:')
	_('mov dx,word[ecx]')
	_('mov word[eax],dx')
	_('add ecx,2')
	_('add eax,2')
	_('inc ebx')
	_('cmp ebx,FF')
	_('jz ChatLogCopyExit')
	_('test dx,dx')
	_('jnz ChatLogCopyLoop')

	_('ChatLogCopyExit:')
	_('push 4')
	_('push edi')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('pop eax')
	_('inc eax')
	_('cmp eax,ChatLogSize')
	_('jnz ChatLogSkipReset')
	_('xor eax,eax')
	_('ChatLogSkipReset:')
	_('mov dword[ChatLogCounter],eax')
	_('popad')

	_('ChatLogExit:')
	_('add edi,E')
	_('cmp eax,B')
	_('ljmp ChatLogReturn')
EndFunc   ;==>CreateChatLog

;~ Description: Internal use only.
Func CreateTraderHook()
	_('TraderHookProc:')

	_('push eax')
	_('mov eax,dword[ebx+28] -> 8b 43 28')
	_('mov eax,[eax] -> 8b 00')
	_('mov dword[TraderCostID],eax')
	_('mov eax,dword[ebx+28] -> 8b 43 28')
	_('mov eax,[eax+4] -> 8b 40 04')
	_('mov dword[TraderCostValue],eax')
	_('pop eax')

	_('mov ebx,dword[ebp+C] -> 8B 5D 0C')
	_('mov esi,eax')

	_('push eax')
	_('mov eax,dword[TraderQuoteID]')
	_('inc eax')
	_('cmp eax,200')
	_('jnz TraderSkipReset')
	_('xor eax,eax')
	_('TraderSkipReset:')
	_('mov dword[TraderQuoteID],eax')
	_('pop eax')

	_('ljmp TraderHookReturn')
EndFunc   ;==>CreateTraderHook

;~ Description: Internal use only.
Func CreateDialogHook()
	_('DialogLogProc:')
	_('push ecx')
	_('mov ecx,esp')
	_('add ecx,C')
	_('mov ecx,dword[ecx]')
	_('mov dword[LastDialogID],ecx')
	_('pop ecx')
	_('mov ebp,esp')
	_('sub esp,8')
	_('ljmp DialogLogReturn')
EndFunc   ;==>CreateDialogHook

;~ Description: Internal use only.
Func CreateLoadFinished()
	_('LoadFinishedProc:')
	_('pushad')

	_('mov eax,1')
	_('mov dword[MapIsLoaded],eax')

	_('xor ebx,ebx')
	_('mov eax,StringLogBase')
	_('LoadClearStringsLoop:')
	_('mov dword[eax],0')
	_('inc ebx')
	_('add eax,100')
	_('cmp ebx,StringLogSize')
	_('jnz LoadClearStringsLoop')

	_('xor ebx,ebx')
	_('mov eax,TargetLogBase')
	_('LoadClearTargetsLoop:')
	_('mov dword[eax],0')
	_('inc ebx')
	_('add eax,4')
	_('cmp ebx,TargetLogSize')
	_('jnz LoadClearTargetsLoop')

	_('push 5')
	_('push 0')
	_('push CallbackEvent')
	_('push dword[CallbackHandle]')
	_('call dword[PostMessage]')

	_('popad')
	_('mov edx,dword[esi+1C]')
	_('mov ecx,edi')
	_('ljmp LoadFinishedReturn')
EndFunc   ;==>CreateLoadFinished

;~ Description: Internal use only.
Func CreateStringLog()
	_('StringLogProc:')
	_('pushad')
	_('mov eax,dword[NextStringType]')
	_('test eax,eax')
	_('jz StringLogExit')

	_('cmp eax,1')
	_('jnz StringLogFilter2')
	_('mov eax,dword[ebp+37c]')
	_('jmp StringLogRangeCheck')

	_('StringLogFilter2:')
	_('cmp eax,2')
	_('jnz StringLogExit')
	_('mov eax,dword[ebp+338]')

	_('StringLogRangeCheck:')
	_('mov dword[NextStringType],0')
	_('cmp eax,0')
	_('jbe StringLogExit')
	_('cmp eax,StringLogSize')
	_('jae StringLogExit')

	_('shl eax,8')
	_('add eax,StringLogBase')

	_('xor ebx,ebx')
	_('StringLogCopyLoop:')
	_('mov dx,word[ecx]')
	_('mov word[eax],dx')
	_('add ecx,2')
	_('add eax,2')
	_('inc ebx')
	_('cmp ebx,80')
	_('jz StringLogExit')
	_('test dx,dx')
	_('jnz StringLogCopyLoop')

	_('StringLogExit:')
	_('popad')
	_('mov esp,ebp')
	_('pop ebp')
	_('retn 10')
EndFunc   ;==>CreateStringLog

;~ Description: Internal use only.
Func CreateStringFilter1()
	_('StringFilter1Proc:')
	_('mov dword[NextStringType],1')

	_('push ebp')
	_('mov ebp,esp')
	_('push ecx')
	_('push esi')
	_('ljmp StringFilter1Return')
EndFunc   ;==>CreateStringFilter1

;~ Description: Internal use only.
Func CreateStringFilter2()
	_('StringFilter2Proc:')
	_('mov dword[NextStringType],2')

	_('push ebp')
	_('mov ebp,esp')
	_('push ecx')
	_('push esi')
	_('ljmp StringFilter2Return')
EndFunc   ;==>CreateStringFilter2

;~ Description: Internal use only.
Func CreateRenderingMod()
	_('RenderingModProc:')
	_('add esp,4')
	_('cmp dword[DisableRendering],1')
	_('ljmp RenderingModReturn')
EndFunc   ;==>CreateRenderingMod

;~ Description: Internal use only.
Func CreateCommands()
	_('CommandUseSkill:')
	_('mov ecx,dword[eax+C]')
	_('push ecx')
	_('mov ebx,dword[eax+8]')
	_('push ebx')
	_('mov edx,dword[eax+4]')
	_('dec edx')
	_('push edx')
	_('mov eax,dword[MyID]')
	_('push eax')
	_('call UseSkillFunction')
	_('pop eax')
	_('pop edx')
	_('pop ebx')
	_('pop ecx')
	_('ljmp CommandReturn')

	_('CommandMove:')
	_('lea eax,dword[eax+4]')
	_('push eax')
	_('call MoveFunction')
	_('pop eax')
	_('ljmp CommandReturn')

	_("CommandChangeTarget:")
	_("xor edx,edx")
	_("push edx")
	_("mov eax,dword[eax+4]")
	_("push eax")
	_("call ChangeTargetFunction")
	_("pop eax")
	_("pop edx")
	_("ljmp CommandReturn")

	_('CommandPacketSend:')
	_('lea edx,dword[eax+8]')
	_('push edx')
	_('mov ebx,dword[eax+4]')
	_('push ebx')
	_('mov eax,dword[PacketLocation]')
	_('push eax')
	_('call PacketSendFunction')
	_('pop eax')
	_('pop ebx')
	_('pop edx')
	_('ljmp CommandReturn')

	_('CommandChangeStatus:')
	_('mov eax,dword[eax+4]')
	_('push eax')
	_('call ChangeStatusFunction')
	_('pop eax')
	_('ljmp CommandReturn')

	_("CommandWriteChat:")
	_("push 0")
	_("add eax,4")
	_("push eax")
	_("call WriteChatFunction")
	_("add esp,8")
	_("ljmp CommandReturn")

	_('CommandSellItem:')
	_('mov esi,eax')
	_('add esi,C')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push dword[eax+4]')
	_('push 0')
	_('add eax,8')
	_('push eax')
	_('push 1')
	_('push 0')
	_('push B')
	_('call TransactionFunction')
	_('add esp,24')
	_('ljmp CommandReturn')

	_('CommandBuyItem:')
	_('mov esi,eax')
	_('add esi,10')
	_('mov ecx,eax')
	_('add ecx,4')
	_('push ecx')
	_('mov edx,eax')
	_('add edx,8')
	_('push edx')
	_('push 1')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('mov eax,dword[eax+C]')
	_('push eax')
	_('push 1')
	_('call TransactionFunction')
	_('add esp,24')
	_('ljmp CommandReturn')

	_('CommandCraftItemEx:')
	_('add eax,4')
	_('push eax')
	_('add eax,4')
	_('push eax')
	_('push 1')
	_('push 0')
	_('push 0')
	_('mov ecx,dword[TradeID]')
	_('mov ecx,dword[ecx]')
	_('mov ebx,dword[ecx+148]')
	_('mov edx,dword[eax+4]')
	_('mov ecx,dword[ecx+edx]')
	_('lea ecx,dword[ecx+ecx*2]')
	_('lea ecx,dword[ebx+ecx*4]')
	_('push ecx')
	_('push 1')
	_('push dword[eax+8]')
	_('push dword[eax+C]')
	_('call TraderFunction')
	_('add esp,24')
	_('mov dword[TraderCostID],0')
	_('ljmp CommandReturn')

	_("CommandAction:")
	_("mov ecx,dword[ActionBase]")
	_("mov ecx,dword[ecx+c]")
	_("add ecx,A0")
	_("push 0")
	_("add eax,4")
	_("push eax")
	_("push dword[eax+4]")
	_("mov edx,0")
	_("call ActionFunction")
	_("ljmp CommandReturn")

	_('CommandUseHeroSkill:')
	_('mov ecx,dword[eax+8]')
	_('push ecx')
	_('mov ecx,dword[eax+c]')
	_('push ecx')
	_('mov ecx,dword[eax+4]')
	_('push ecx')
	_('call UseHeroSkillFunction')
	_('add esp,C')
	_('ljmp CommandReturn')

;~ 	_('CommandToggleLanguage:')
;~ 	_('mov ecx,dword[ActionBase]')
;~ 	_('mov ecx,dword[ecx+170]')
;~ 	_('mov ecx,dword[ecx+20]')
;~ 	_('mov ecx,dword[ecx]')
;~ 	_('push 0')
;~ 	_('push 0')
;~ 	_('push bb')
;~ 	_('mov edx,esp')
;~ 	_('push 0')
;~ 	_('push edx')
;~ 	_('push dword[eax+4]')
;~ 	_('call ActionFunction')
;~ 	_('pop eax')
;~ 	_('pop ebx')
;~ 	_('pop ecx')
;~ 	_('ljmp CommandReturn')

	_('CommandSendChat:')
	_('lea edx,dword[eax+4]')
	_('push edx')
	_('mov ebx,11c')
	_('push ebx')
	_('mov eax,dword[PacketLocation]')
	_('push eax')
	_('call PacketSendFunction')
	_('pop eax')
	_('pop ebx')
	_('pop edx')
	_('ljmp CommandReturn')

	_('CommandRequestQuote:')
	_('mov dword[TraderCostID],0')
	_('mov dword[TraderCostValue],0')
	_('mov esi,eax')
	_('add esi,4')
	_('push esi')
	_('push 1')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push C')
	_('mov ecx,0')
	_('mov edx,2')
	_('call RequestQuoteFunction')
	_('add esp,20')
	_('ljmp CommandReturn')

	_('CommandRequestQuoteSell:')
	_('mov dword[TraderCostID],0')
	_('mov dword[TraderCostValue],0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('add eax,4')
	_('push eax')
	_('push 1')
	_('push 0')
	_('push 0')
	_('push D')
	_('xor edx,edx')
	_('call RequestQuoteFunction')
	_('add esp,20')
	_('ljmp CommandReturn')

	_('CommandTraderBuy:')
	_('push 0')
	_('push TraderCostID')
	_('push 1')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push 0')
	_('mov edx,dword[TraderCostValue]')
	_('push edx')
	_('push C')
	_('mov ecx,C')
	_('call TraderFunction')
	_('add esp,24')
	_('mov dword[TraderCostID],0')
	_('mov dword[TraderCostValue],0')
	_('ljmp CommandReturn')

	_('CommandTraderSell:')
	_('push 0')
	_('push 0')
	_('push 0')
	_('push dword[TraderCostValue]')
	_('push 0')
	_('push TraderCostID')
	_('push 1')
	_('push 0')
	_('push D')
	_('mov ecx,d')
	_('xor edx,edx')
	_('call TransactionFunction')
	_('add esp,24')
	_('mov dword[TraderCostID],0')
	_('mov dword[TraderCostValue],0')
	_('ljmp CommandReturn')

	_('CommandSalvage:')
	_('push eax')
	_('push ecx')
	_('push ebx')
	_('mov ebx,SalvageGlobal')
	_('mov ecx,dword[eax+4]')
	_('mov dword[ebx],ecx')
	_('add ebx,4')
	_('mov ecx,dword[eax+8]')
	_('mov dword[ebx],ecx')
	_('mov ebx,dword[eax+4]')
	_('push ebx')
	_('mov ebx,dword[eax+8]')
	_('push ebx')
	_('mov ebx,dword[eax+c]')
	_('push ebx')
	_('call SalvageFunction')
	_('add esp,C')
	_('pop ebx')
	_('pop ecx')
	_('pop eax')
	_('ljmp CommandReturn')

	_("CommandCraftItemEx2:")
	_("add eax,4")
	_("push eax")
	_("add eax,4")
	_("push eax")
	_("push 1")
	_("push 0")
	_("push 0")
	_("mov ecx,dword[TradeID]")
	_("mov ecx,dword[ecx]")
	_("mov ebx,dword[ecx+148]")
	_("mov edx,dword[eax+8]")
	_("mov ecx,dword[ecx+edx]")
	_("lea ecx,dword[ecx+ecx*2]")
	_("lea ecx,dword[ebx+ecx*4]")
	_("mov ecx,dword[ecx]")
	_("mov [eax+8],ecx")
	_("mov ecx,dword[TradeID]")
	_("mov ecx,dword[ecx]")
	_("mov ecx,dword[ecx+0xF4]")
	_("lea ecx,dword[ecx+ecx*2]")
	_("lea ecx,dword[ebx+ecx*4]")
	_("mov ecx,dword[ecx]")
	_("mov [eax+C],ecx")
	_("mov ecx,eax")
	_("add ecx,8")
	_("push ecx")
	_("push 2")
	_("push dword[eax+4]")
	_("push 3")
	_("call TransactionFunction")
	_("add esp,24")
	_("mov dword[TraderCostID],0")
	_("ljmp CommandReturn")

	_('CommandIncreaseAttribute:')
	_('mov edx,dword[eax+4]')
	_('push edx')
	_('mov ecx,dword[eax+8]')
	_('push ecx')
	_('call IncreaseAttributeFunction')
	_('pop ecx')
	_('pop edx')
	_('ljmp CommandReturn')

	_('CommandDecreaseAttribute:')
	_('mov edx,dword[eax+4]')
	_('push edx')
	_('mov ecx,dword[eax+8]')
	_('push ecx')
	_('call DecreaseAttributeFunction')
	_('pop ecx')
	_('pop edx')
	_('ljmp CommandReturn')

	_('CommandMakeAgentArray:')
	_('mov eax,dword[eax+4]')
	_('xor ebx,ebx')
	_('xor edx,edx')
	_('mov edi,AgentCopyBase')

	_('AgentCopyLoopStart:')
	_('inc ebx')
	_('cmp ebx,dword[MaxAgents]')
	_('jge AgentCopyLoopExit')

	_('mov esi,dword[AgentBase]')
	_('lea esi,dword[esi+ebx*4]')
	_('mov esi,dword[esi]')
	_('test esi,esi')
	_('jz AgentCopyLoopStart')

	_('cmp eax,0')
	_('jz CopyAgent')
	_('cmp eax,dword[esi+9C]')
	_('jnz AgentCopyLoopStart')

	_('CopyAgent:')
	_('mov ecx,1C0')
	_('clc')
	_('repe movsb')
	_('inc edx')
	_('jmp AgentCopyLoopStart')
	_('AgentCopyLoopExit:')
	_('mov dword[AgentCopyCount],edx')
	_('ljmp CommandReturn')

	_('CommandSendChatPartySearch:')
	_('lea edx,dword[eax+4]')
	_('push edx')
	_('mov ebx,4C')
	_('push ebx')
	_('mov eax,dword[PacketLocation]')
	_('push eax')
	_('call PacketSendFunction')
	_('pop eax')
	_('pop ebx')
	_('pop edx')
	_('ljmp CommandReturn')
EndFunc   ;==>CreateCommands

#EndRegion Modification

#Region Assembler
;~ Description: Internal use only.
Func _($aASM)
	Local $lBuffer
	Local $lOpCode
	Select
		Case StringInStr($aASM, ' -> ')
			Local $split = StringSplit($aASM, ' -> ', 1)
			$lOpCode = StringReplace($split[2], ' ', '')
			$mASMSize += 0.5 * StringLen($lOpCode)
			$mASMString &= $lOpCode
		Case StringLeft($aASM, 3) = 'jb '
			$mASMSize += 2
			$mASMString &= '72(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringLeft($aASM, 3) = 'je '
			$mASMSize += 2
			$mASMString &= '74(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringRegExp($aASM, 'cmp ebx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 6
			$mASMString &= '81FB[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'cmp edx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 6
			$mASMString &= '81FA[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRight($aASM, 1) = ':'
			SetValue('Label_' & StringLeft($aASM, StringLen($aASM) - 1), $mASMSize)
		Case StringInStr($aASM, '/') > 0
			SetValue('Label_' & StringLeft($aASM, StringInStr($aASM, '/') - 1), $mASMSize)
			Local $lOffset = StringRight($aASM, StringLen($aASM) - StringInStr($aASM, '/'))
			$mASMSize += $lOffset
			$mASMCodeOffset += $lOffset
		Case StringLeft($aASM, 5) = 'nop x'
			$lBuffer = Int(Number(StringTrimLeft($aASM, 5)))
			$mASMSize += $lBuffer
			For $i = 1 To $lBuffer
				$mASMString &= '90'
			Next
		Case StringLeft($aASM, 5) = 'ljmp '
			$mASMSize += 5
			$mASMString &= 'E9{' & StringRight($aASM, StringLen($aASM) - 5) & '}'
		Case StringLeft($aASM, 5) = 'ljne '
			$mASMSize += 6
			$mASMString &= '0F85{' & StringRight($aASM, StringLen($aASM) - 5) & '}'
		Case StringLeft($aASM, 4) = 'jmp ' And StringLen($aASM) > 7
			$mASMSize += 2
			$mASMString &= 'EB(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 4) = 'jae '
			$mASMSize += 2
			$mASMString &= '73(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 3) = 'jz '
			$mASMSize += 2
			$mASMString &= '74(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringLeft($aASM, 4) = 'jnz '
			$mASMSize += 2
			$mASMString &= '75(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 4) = 'jbe '
			$mASMSize += 2
			$mASMString &= '76(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 3) = 'ja '
			$mASMSize += 2
			$mASMString &= '77(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringLeft($aASM, 3) = 'jl '
			$mASMSize += 2
			$mASMString &= '7C(' & StringRight($aASM, StringLen($aASM) - 3) & ')'
		Case StringLeft($aASM, 4) = 'jge '
			$mASMSize += 2
			$mASMString &= '7D(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringLeft($aASM, 4) = 'jle '
			$mASMSize += 2
			$mASMString &= '7E(' & StringRight($aASM, StringLen($aASM) - 4) & ')'
		Case StringRegExp($aASM, 'mov eax,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 5
			$mASMString &= 'A1[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov ebx,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B1D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov ecx,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B0D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov edx,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B15[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov esi,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B35[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov edi,dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= '8B3D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'cmp ebx,dword\[[a-z,A-Z]{4,}\]')
			$mASMSize += 6
			$mASMString &= '3B1D[' & StringMid($aASM, 15, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'lea eax,dword[[]ecx[*]8[+][a-z,A-Z]{4,}[]]')
			$mASMSize += 7
			$mASMString &= '8D04CD[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
		Case StringRegExp($aASM, 'lea edi,dword\[edx\+[a-z,A-Z]{4,}\]')
			$mASMSize += 7
			$mASMString &= '8D3C15[' & StringMid($aASM, 19, StringLen($aASM) - 19) & ']'
		Case StringRegExp($aASM, 'cmp dword[[][a-z,A-Z]{4,}[]],[-[:xdigit:]]')
			$lBuffer = StringInStr($aASM, ',')
			$lBuffer = ASMNumber(StringMid($aASM, $lBuffer + 1), True)
			If @extended Then
				$mASMSize += 7
				$mASMString &= '833D[' & StringMid($aASM, 11, StringInStr($aASM, ',') - 12) & ']' & $lBuffer
			Else
				$mASMSize += 10
				$mASMString &= '813D[' & StringMid($aASM, 11, StringInStr($aASM, ',') - 12) & ']' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'cmp ecx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 6
			$mASMString &= '81F9[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'cmp ebx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 6
			$mASMString &= '81FB[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'cmp eax,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= '3D[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'add eax,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= '05[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov eax,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'B8[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov ebx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'BB[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov ecx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'B9[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov esi,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'BE[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov edi,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'BF[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov edx,[a-z,A-Z]{4,}') And StringInStr($aASM, ',dword') = 0
			$mASMSize += 5
			$mASMString &= 'BA[' & StringRight($aASM, StringLen($aASM) - 8) & ']'
		Case StringRegExp($aASM, 'mov dword[[][a-z,A-Z]{4,}[]],ecx')
			$mASMSize += 6
			$mASMString &= '890D[' & StringMid($aASM, 11, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'fstp dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= 'D91D[' & StringMid($aASM, 12, StringLen($aASM) - 12) & ']'
		Case StringRegExp($aASM, 'mov dword[[][a-z,A-Z]{4,}[]],edx')
			$mASMSize += 6
			$mASMString &= '8915[' & StringMid($aASM, 11, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'mov dword[[][a-z,A-Z]{4,}[]],eax')
			$mASMSize += 5
			$mASMString &= 'A3[' & StringMid($aASM, 11, StringLen($aASM) - 15) & ']'
		Case StringRegExp($aASM, 'lea eax,dword[[]edx[*]4[+][a-z,A-Z]{4,}[]]')
			$mASMSize += 7
			$mASMString &= '8D0495[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
		Case StringRegExp($aASM, 'mov eax,dword[[]ecx[*]4[+][a-z,A-Z]{4,}[]]')
			$mASMSize += 7
			$mASMString &= '8B048D[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
		Case StringRegExp($aASM, 'mov ecx,dword[[]ecx[*]4[+][a-z,A-Z]{4,}[]]')
			$mASMSize += 7
			$mASMString &= '8B0C8D[' & StringMid($aASM, 21, StringLen($aASM) - 21) & ']'
		Case StringRegExp($aASM, 'push dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= 'FF35[' & StringMid($aASM, 12, StringLen($aASM) - 12) & ']'
		Case StringRegExp($aASM, 'push [a-z,A-Z]{4,}\z')
			$mASMSize += 5
			$mASMString &= '68[' & StringMid($aASM, 6, StringLen($aASM) - 5) & ']'
		Case StringRegExp($aASM, 'call dword[[][a-z,A-Z]{4,}[]]')
			$mASMSize += 6
			$mASMString &= 'FF15[' & StringMid($aASM, 12, StringLen($aASM) - 12) & ']'
		Case StringLeft($aASM, 5) = 'call ' And StringLen($aASM) > 8
			$mASMSize += 5
			$mASMString &= 'E8{' & StringMid($aASM, 6, StringLen($aASM) - 5) & '}'
		Case StringRegExp($aASM, 'mov dword\[[a-z,A-Z]{4,}\],[-[:xdigit:]]{1,8}\z')
			$lBuffer = StringInStr($aASM, ',')
			$mASMSize += 10
			$mASMString &= 'C705[' & StringMid($aASM, 11, $lBuffer - 12) & ']' & ASMNumber(StringMid($aASM, $lBuffer + 1))
		Case StringRegExp($aASM, 'push [-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 6), True)
			If @extended Then
				$mASMSize += 2
				$mASMString &= '6A' & $lBuffer
			Else
				$mASMSize += 5
				$mASMString &= '68' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'mov eax,[-[:xdigit:]]{1,8}\z')
			$mASMSize += 5
			$mASMString &= 'B8' & ASMNumber(StringMid($aASM, 9))
		Case StringRegExp($aASM, 'mov ebx,[-[:xdigit:]]{1,8}\z')
			$mASMSize += 5
			$mASMString &= 'BB' & ASMNumber(StringMid($aASM, 9))
		Case StringRegExp($aASM, 'mov ecx,[-[:xdigit:]]{1,8}\z')
			$mASMSize += 5
			$mASMString &= 'B9' & ASMNumber(StringMid($aASM, 9))
		Case StringRegExp($aASM, 'mov edx,[-[:xdigit:]]{1,8}\z')
			$mASMSize += 5
			$mASMString &= 'BA' & ASMNumber(StringMid($aASM, 9))
		Case StringRegExp($aASM, 'add eax,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C0' & $lBuffer
			Else
				$mASMSize += 5
				$mASMString &= '05' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add ebx,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C3' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C3' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add ecx,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C1' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C1' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add edx,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C2' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C2' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add edi,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C7' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C7' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add esi,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C6' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C6' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'add esp,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83C4' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81C4' & $lBuffer
			EndIf
		Case StringRegExp($aASM, 'cmp ebx,[-[:xdigit:]]{1,8}\z')
			$lBuffer = ASMNumber(StringMid($aASM, 9), True)
			If @extended Then
				$mASMSize += 3
				$mASMString &= '83FB' & $lBuffer
			Else
				$mASMSize += 6
				$mASMString &= '81FB' & $lBuffer
			EndIf
		Case StringLeft($aASM, 8) = 'cmp ecx,' And StringLen($aASM) > 10
			Local $lOpCode = '81F9' & StringMid($aASM, 9)
			$mASMSize += 0.5 * StringLen($lOpCode)
			$mASMString &= $lOpCode
		Case Else
			Local $lOpCode
			Switch $aASM
				Case 'Flag_'
					$lOpCode = '9090903434'
				Case 'nop'
					$lOpCode = '90'
				Case 'pushad'
					$lOpCode = '60'
				Case 'popad'
					$lOpCode = '61'
				Case 'mov ebx,dword[eax]'
					$lOpCode = '8B18'
				Case 'mov ebx,dword[ecx]'
					$lOpCode = '8B19'
				Case 'mov ecx,dword[ebx+ecx]'
					$lOpCode = '8B0C0B'
				Case 'test eax,eax'
					$lOpCode = '85C0'
				Case 'test ebx,ebx'
					$lOpCode = '85DB'
				Case 'test ecx,ecx'
					$lOpCode = '85C9'
				Case 'mov dword[eax],0'
					$lOpCode = 'C70000000000'
				Case 'push eax'
					$lOpCode = '50'
				Case 'push ebx'
					$lOpCode = '53'
				Case 'push ecx'
					$lOpCode = '51'
				Case 'push edx'
					$lOpCode = '52'
				Case 'push ebp'
					$lOpCode = '55'
				Case 'push esi'
					$lOpCode = '56'
				Case 'push edi'
					$lOpCode = '57'
				Case 'jmp ebx'
					$lOpCode = 'FFE3'
				Case 'pop eax'
					$lOpCode = '58'
				Case 'pop ebx'
					$lOpCode = '5B'
				Case 'pop edx'
					$lOpCode = '5A'
				Case 'pop ecx'
					$lOpCode = '59'
				Case 'pop esi'
					$lOpCode = '5E'
				Case 'inc eax'
					$lOpCode = '40'
				Case 'inc ecx'
					$lOpCode = '41'
				Case 'inc ebx'
					$lOpCode = '43'
				Case 'dec edx'
					$lOpCode = '4A'
				Case 'mov edi,edx'
					$lOpCode = '8BFA'
				Case 'mov ecx,esi'
					$lOpCode = '8BCE'
				Case 'mov ecx,edi'
					$lOpCode = '8BCF'
				Case 'mov ecx,esp'
					$lOpCode = '8BCC'
				Case 'xor eax,eax'
					$lOpCode = '33C0'
				Case 'xor ecx,ecx'
					$lOpCode = '33C9'
				Case 'xor edx,edx'
					$lOpCode = '33D2'
				Case 'xor ebx,ebx'
					$lOpCode = '33DB'
				Case 'mov edx,eax'
					$lOpCode = '8BD0'
				Case 'mov edx,ecx'
					$lOpCode = '8BD1'
				Case 'mov ebp,esp'
					$lOpCode = '8BEC'
				Case 'sub esp,8'
					$lOpCode = '83EC08'
				Case 'sub esi,4'
					$lOpCode = '83EE04'
				Case 'sub esp,14'
					$lOpCode = '83EC14'
				Case 'sub eax,C'
					$lOpCode = '83E80C'
				Case 'cmp ecx,4'
					$lOpCode = '83F904'
				Case 'cmp ecx,32'
					$lOpCode = '83F932'
				Case 'cmp ecx,3C'
					$lOpCode = '83F93C'
				Case 'mov ecx,edx'
					$lOpCode = '8BCA'
				Case 'mov eax,ecx'
					$lOpCode = '8BC1'
				Case 'mov ecx,dword[ebp+8]'
					$lOpCode = '8B4D08'
				Case 'mov ecx,dword[esp+1F4]'
					$lOpCode = '8B8C24F4010000'
				Case 'mov ecx,dword[edi+4]'
					$lOpCode = '8B4F04'
				Case 'mov ecx,dword[edi+8]'
					$lOpCode = '8B4F08'
				Case 'mov eax,dword[edi+4]'
					$lOpCode = '8B4704'
				Case 'mov dword[eax+4],ecx'
					$lOpCode = '894804'
				Case 'mov dword[eax+8],ebx'
					$lOpCode = '895808'
				Case 'mov dword[eax+8],ecx'
					$lOpCode = '894808'
				Case 'mov dword[eax+C],ecx'
					$lOpCode = '89480C'
				Case 'mov dword[esi+10],eax'
					$lOpCode = '894610'
				Case 'mov ecx,dword[edi]'
					$lOpCode = '8B0F'
				Case 'mov dword[eax],ecx'
					$lOpCode = '8908'
				Case 'mov dword[eax],ebx'
					$lOpCode = '8918'
				Case 'mov edx,dword[eax+4]'
					$lOpCode = '8B5004'
				Case 'mov edx,dword[eax+8]'
					$lOpCode = '8B5008'
				Case 'mov edx,dword[eax+c]'
					$lOpCode = '8B500C'
				Case 'mov edx,dword[esi+1c]'
					$lOpCode = '8B561C'
				Case 'push dword[eax+8]'
					$lOpCode = 'FF7008'
				Case 'lea eax,dword[eax+18]'
					$lOpCode = '8D4018'
				Case 'lea ecx,dword[eax+4]'
					$lOpCode = '8D4804'
				Case 'lea ecx,dword[eax+C]'
					$lOpCode = '8D480C'
				Case 'lea eax,dword[eax+4]'
					$lOpCode = '8D4004'
				Case 'lea edx,dword[eax]'
					$lOpCode = '8D10'
				Case 'lea edx,dword[eax+4]'
					$lOpCode = '8D5004'
				Case 'lea edx,dword[eax+8]'
					$lOpCode = '8D5008'
				Case 'mov ecx,dword[eax+4]'
					$lOpCode = '8B4804'
				Case 'mov esi,dword[eax+4]'
					$lOpCode = '8B7004'
				Case 'mov esp,dword[eax+4]'
					$lOpCode = '8B6004'
				Case 'mov ecx,dword[eax+8]'
					$lOpCode = '8B4808'
				Case 'mov eax,dword[eax+8]'
					$lOpCode = '8B4008'
				Case 'mov eax,dword[eax+C]'
					$lOpCode = '8B400C'
				Case 'mov ebx,dword[eax+4]'
					$lOpCode = '8B5804'
				Case 'mov ebx,dword[eax]'
					$lOpCode = '8B10'
				Case 'mov ebx,dword[eax+8]'
					$lOpCode = '8B5808'
				Case 'mov ebx,dword[eax+C]'
					$lOpCode = '8B580C'
				Case 'mov ebx,dword[ecx+148]'
					$lOpCode = '8B9948010000'
				Case 'mov ecx,dword[ebx+13C]'
					$lOpCode = '8B9B3C010000'
				Case 'mov ebx,dword[ebx+F0]'
					$lOpCode = '8B9BF0000000'
				Case 'mov ecx,dword[eax+C]'
					$lOpCode = '8B480C'
				Case 'mov ecx,dword[eax+10]'
					$lOpCode = '8B4810'
				Case 'mov eax,dword[eax+4]'
					$lOpCode = '8B4004'
				Case 'push dword[eax+4]'
					$lOpCode = 'FF7004'
				Case 'push dword[eax+c]'
					$lOpCode = 'FF700C'
				Case 'mov esp,ebp'
					$lOpCode = '8BE5'
				Case 'mov esp,ebp'
					$lOpCode = '8BE5'
				Case 'pop ebp'
					$lOpCode = '5D'
				Case 'retn 10'
					$lOpCode = 'C21000'
				Case 'cmp eax,2'
					$lOpCode = '83F802'
				Case 'cmp eax,0'
					$lOpCode = '83F800'
				Case 'cmp eax,B'
					$lOpCode = '83F80B'
				Case 'cmp eax,200'
					$lOpCode = '3D00020000'
				Case 'shl eax,4'
					$lOpCode = 'C1E004'
				Case 'shl eax,8'
					$lOpCode = 'C1E008'
				Case 'shl eax,6'
					$lOpCode = 'C1E006'
				Case 'shl eax,7'
					$lOpCode = 'C1E007'
				Case 'shl eax,8'
					$lOpCode = 'C1E008'
				Case 'shl eax,9'
					$lOpCode = 'C1E009'
				Case 'mov edi,eax'
					$lOpCode = '8BF8'
				Case 'mov dx,word[ecx]'
					$lOpCode = '668B11'
				Case 'mov dx,word[edx]'
					$lOpCode = '668B12'
				Case 'mov word[eax],dx'
					$lOpCode = '668910'
				Case 'test dx,dx'
					$lOpCode = '6685D2'
				Case 'cmp word[edx],0'
					$lOpCode = '66833A00'
				Case 'cmp eax,ebx'
					$lOpCode = '3BC3'
				Case 'cmp eax,ecx'
					$lOpCode = '3BC1'
				Case 'mov eax,dword[esi+8]'
					$lOpCode = '8B4608'
				Case 'mov ecx,dword[eax]'
					$lOpCode = '8B08'
				Case 'mov ebx,edi'
					$lOpCode = '8BDF'
				Case 'mov ebx,eax'
					$lOpCode = '8BD8'
				Case 'mov eax,edi'
					$lOpCode = '8BC7'
				Case 'mov al,byte[ebx]'
					$lOpCode = '8A03'
				Case 'test al,al'
					$lOpCode = '84C0'
				Case 'mov eax,dword[ecx]'
					$lOpCode = '8B01'
				Case 'lea ecx,dword[eax+180]'
					$lOpCode = '8D8880010000'
				Case 'mov ebx,dword[ecx+14]'
					$lOpCode = '8B5914'
				Case 'mov eax,dword[ebx+c]'
					$lOpCode = '8B430C'
				Case 'mov ecx,eax'
					$lOpCode = '8BC8'
				Case 'cmp eax,-1'
					$lOpCode = '83F8FF'
				Case 'mov al,byte[ecx]'
					$lOpCode = '8A01'
				Case 'mov ebx,dword[edx]'
					$lOpCode = '8B1A'
				Case 'lea edi,dword[edx+ebx]'
					$lOpCode = '8D3C1A'
				Case 'mov ah,byte[edi]'
					$lOpCode = '8A27'
				Case 'cmp al,ah'
					$lOpCode = '3AC4'
				Case 'mov dword[edx],0'
					$lOpCode = 'C70200000000'
				Case 'mov dword[ebx],ecx'
					$lOpCode = '890B'
				Case 'cmp edx,esi'
					$lOpCode = '3BD6'
				Case 'cmp ecx,1050000'
					$lOpCode = '81F900000501'
				Case 'mov edi,dword[edx+4]'
					$lOpCode = '8B7A04'
				Case 'mov edi,dword[eax+4]'
					$lOpCode = '8B7804'
				Case $aASM = 'mov ecx,dword[E1D684]'
					$lOpCode = '8B0D84D6E100'
				Case $aASM = 'mov dword[edx-0x70],ecx'
					$lOpCode = '894A90'
				Case $aASM = 'mov ecx,dword[edx+0x1C]'
					$lOpCode = '8B4A1C'
				Case $aASM = 'mov dword[edx+0x54],ecx'
					$lOpCode = '894A54'
				Case $aASM = 'mov ecx,dword[edx+4]'
					$lOpCode = '8B4A04'
				Case $aASM = 'mov dword[edx-0x14],ecx'
					$lOpCode = '894AEC'
				Case 'cmp ebx,edi'
					$lOpCode = '3BDF'
				Case 'mov dword[edx],ebx'
					$lOpCode = '891A'
				Case 'lea edi,dword[edx+8]'
					$lOpCode = '8D7A08'
				Case 'mov dword[edi],ecx'
					$lOpCode = '890F'
				Case 'retn'
					$lOpCode = 'C3'
				Case 'mov dword[edx],-1'
					$lOpCode = 'C702FFFFFFFF'
				Case 'cmp eax,1'
					$lOpCode = '83F801'
				Case 'mov eax,dword[ebp+37c]'
					$lOpCode = '8B857C030000'
				Case 'mov eax,dword[ebp+338]'
					$lOpCode = '8B8538030000'
				Case 'mov ecx,dword[ebx+250]'
					$lOpCode = '8B8B50020000'
				Case 'mov ecx,dword[ebx+194]'
					$lOpCode = '8B8B94010000'
				Case 'mov ecx,dword[ebx+18]'
					$lOpCode = '8B5918'
				Case 'mov ecx,dword[ebx+40]'
					$lOpCode = '8B5940'
				Case 'mov ebx,dword[ecx+10]'
					$lOpCode = '8B5910'
				Case 'mov ebx,dword[ecx+18]'
					$lOpCode = '8B5918'
				Case 'mov ebx,dword[ecx+4c]'
					$lOpCode = '8B594C'
				Case 'mov ecx,dword[ebx]'
					$lOpCode = '8B0B'
				Case 'mov edx,esp'
					$lOpCode = '8BD4'
				Case 'mov ecx,dword[ebx+170]'
					$lOpCode = '8B8B70010000'
				Case 'cmp eax,dword[esi+9C]'
					$lOpCode = '3B869C000000'
				Case 'mov ebx,dword[ecx+20]'
					$lOpCode = '8B5920'
				Case 'mov ecx,dword[ecx]'
					$lOpCode = '8B09'
				Case 'mov eax,dword[ecx+40]'
					$lOpCode = '8B4140'
				Case 'mov ecx,dword[ecx+4]'
					$lOpCode = '8B4904'
				Case 'mov ecx,dword[ecx+8]'
					$lOpCode = '8B4908'
				Case 'mov ecx,dword[ecx+34]'
					$lOpCode = '8B4934'
				Case 'mov ecx,dword[ecx+C]'
					$lOpCode = '8B490C'
				Case 'mov ecx,dword[ecx+10]'
					$lOpCode = '8B4910'
				Case 'mov ecx,dword[ecx+18]'
					$lOpCode = '8B4918'
				Case 'mov ecx,dword[ecx+20]'
					$lOpCode = '8B4920'
				Case 'mov ecx,dword[ecx+4c]'
					$lOpCode = '8B494C'
				Case 'mov ecx,dword[ecx+50]'
					$lOpCode = '8B4950'
				Case 'mov ecx,dword[ecx+148]'
					$lOpCode = '8B8948010000'
				Case 'mov ecx,dword[ecx+170]'
					$lOpCode = '8B8970010000'
				Case 'mov ecx,dword[ecx+194]'
					$lOpCode = '8B8994010000'
				Case 'mov ecx,dword[ecx+250]'
					$lOpCode = '8B8950020000'
				Case 'mov ecx,dword[ecx+134]'
					$lOpCode = '8B8934010000'
				Case 'mov ecx,dword[ecx+13C]'
					$lOpCode = '8B893C010000'
				Case 'mov al,byte[ecx+4f]'
					$lOpCode = '8A414F'
				Case 'mov al,byte[ecx+3f]'
					$lOpCode = '8A413F'
				Case 'cmp al,f'
					$lOpCode = '3C0F'
				Case 'lea esi,dword[esi+ebx*4]'
					$lOpCode = '8D349E'
				Case 'mov esi,dword[esi]'
					$lOpCode = '8B36'
				Case 'test esi,esi'
					$lOpCode = '85F6'
				Case 'clc'
					$lOpCode = 'F8'
				Case 'repe movsb'
					$lOpCode = 'F3A4'
				Case 'inc edx'
					$lOpCode = '42'
				Case 'mov eax,dword[ebp+8]'
					$lOpCode = '8B4508'
				Case 'mov eax,dword[ecx+8]'
					$lOpCode = '8B4108'
				Case 'test al,1'
					$lOpCode = 'A801'
				Case $aASM = 'mov eax,[eax+2C]'
					$lOpCode = '8B402C'
				Case $aASM = 'mov eax,[eax+680]'
					$lOpCode = '8B8080060000'
				Case $aASM = 'fld st(0),dword[ebp+8]'
					$lOpCode = 'D94508'
				Case 'mov esi,eax'
					$lOpCode = '8BF0'
				Case 'mov edx,dword[ecx]'
					$lOpCode = '8B11'
				Case 'mov dword[eax],edx'
					$lOpCode = '8910'
				Case 'test edx,edx'
					$lOpCode = '85D2'
				Case 'mov dword[eax],F'
					$lOpCode = 'C7000F000000'
				Case 'mov ebx,[ebx+0]'
					$lOpCode = '8B1B'
				Case 'mov ebx,[ebx+AC]'
					$lOpCode = '8B9BAC000000'
				Case 'mov ebx,[ebx+C]'
					$lOpCode = '8B5B0C'
				Case 'mov eax,dword[ebx+28]'
					$lOpCode = '8B4328'
				Case 'mov eax,[eax]'
					$lOpCode = '8B00'
				Case 'mov eax,[eax+4]'
					$lOpCode = '8B4004'
				Case 'mov ebx,dword[ebp+C]'
					$lOpCode = '8B5D0C'
				Case 'add ebx,ecx'
					$lOpCode = '03D9'
				Case 'lea ecx,dword[ecx+ecx*2]'
					$lOpCode = '8D0C49'
				Case 'lea ecx,dword[ebx+ecx*4]'
					$lOpCode = '8D0C8B'
				Case 'lea ecx,dword[ecx+18]'
					$lOpCode = '8D4918'
				Case 'mov ecx,dword[ecx+edx]'
					$lOpCode = '8B0C11'
				Case 'push dword[ebp+8]'
					$lOpCode = 'FF7508'
				Case 'mov dword[eax],edi'
					$lOpCode = '8938'
				Case 'mov [eax+8],ecx'             ; this was added for crafting
					$lOpCode = '894808'            ; this was added for crafting
				Case 'mov [eax+C],ecx'             ; this was added for crafting
					$lOpCode = '89480C'            ; this was added for crafting
				Case 'mov ebx,dword[ecx-C]'        ; this was added
					$lOpCode = '8B59F4'            ; this was added
				Case 'mov [eax+!],ebx'             ; this was added
					$lOpCode = '89580C'            ; this was added
				Case 'mov ecx,[eax+8]'             ; this was added
					$lOpCode = '8B4808'            ; this was added
				Case 'lea ecx,dword[ebx+18]'       ; this was added
					$lOpCode = '8D4B18'            ; this was added
				Case 'mov ebx,dword[ebx+18]'       ; this was added
					$lOpCode = '8B5B18'            ; this was added
				Case 'mov ecx,dword[ecx+0xF4]'     ; this was added for crafting
					$lOpCode = '8B89F4000000'      ; this was added for crafting
				Case Else
					MsgBox(0x0, 'ASM', 'Could not assemble: ' & $aASM)
					Exit
			EndSwitch
			$mASMSize += 0.5 * StringLen($lOpCode)
			$mASMString &= $lOpCode
	EndSelect
EndFunc   ;==>_

;~ Description: Internal use only.
Func CompleteASMCode()
	Local $lInExpression = False
	Local $lExpression
	Local $lTempASM = $mASMString
	Local $lCurrentOffset = Dec(Hex($mMemory)) + $mASMCodeOffset
	Local $lToken

	For $i = 1 To $mLabels[0][0]
		If StringLeft($mLabels[$i][0], 6) = 'Label_' Then
			$mLabels[$i][0] = StringTrimLeft($mLabels[$i][0], 6)
			$mLabels[$i][1] = $mMemory + $mLabels[$i][1]
		EndIf
	Next

	$mASMString = ''
	For $i = 1 To StringLen($lTempASM)
		$lToken = StringMid($lTempASM, $i, 1)
		Switch $lToken
			Case '(', '[', '{'
				$lInExpression = True
			Case ')'
				$mASMString &= Hex(GetLabelInfo($lExpression) - Int($lCurrentOffset) - 1, 2)
				$lCurrentOffset += 1
				$lInExpression = False
				$lExpression = ''
			Case ']'
				$mASMString &= SwapEndian(Hex(GetLabelInfo($lExpression), 8))
				$lCurrentOffset += 4
				$lInExpression = False
				$lExpression = ''
			Case '}'
				$mASMString &= SwapEndian(Hex(GetLabelInfo($lExpression) - Int($lCurrentOffset) - 4, 8))
				$lCurrentOffset += 4
				$lInExpression = False
				$lExpression = ''
			Case Else
				If $lInExpression Then
					$lExpression &= $lToken
				Else
					$mASMString &= $lToken
					$lCurrentOffset += 0.5
				EndIf
		EndSwitch
	Next
EndFunc   ;==>CompleteASMCode

Func GetLabelInfo($aLab)
	Local Const $lVal = GetValue($aLab)
	Return $lVal
EndFunc   ;==>GetLabelInfo

;~ Description: Internal use only.
Func ASMNumber($aNumber, $aSmall = False)
	If $aNumber >= 0 Then
		$aNumber = Dec($aNumber)
	EndIf
	If $aSmall And $aNumber <= 127 And $aNumber >= -128 Then
		Return SetExtended(1, Hex($aNumber, 2))
	Else
		Return SetExtended(0, SwapEndian(Hex($aNumber, 8)))
	EndIf
EndFunc   ;==>ASMNumber

#EndRegion Assembler

