#Region Misc
;~ Description: Change weapon sets.
Func ChangeWeaponSet($aSet)
	Return PerformAction(0x80 + $aSet, 0x1E) ;Return PerformAction(0x80 + $aSet, 0x1E) 0x14A
EndFunc   ;==>ChangeWeaponSet

;~ Description: Same as hitting spacebar.
Func ActionInteract()
	Return PerformAction(0x80, 0x1E)
EndFunc   ;==>ActionInteract

;~ Description: Follow a player.
Func ActionFollow()
	Return PerformAction(0xCC, 0x1E)
EndFunc   ;==>ActionFollow

;~ Description: Clear all hero flags.
Func ClearPartyCommands()
	Return PerformAction(0xDB, 0x1E)
EndFunc   ;==>ClearPartyCommands

;~ Description: Suppress action.
Func SuppressAction($aSuppress)
	If $aSuppress Then
		Return PerformAction(0xD0, 0x1E)
	Else
		Return PerformAction(0xD0, 0x20)
	EndIf
EndFunc   ;==>SuppressAction

;~ Description: Open a chest.
Func OpenChest()
	Return SendPacket(0x8, $HEADER_CHEST_OPEN, 2)
EndFunc   ;==>OpenChest

;~ Description: Take a screenshot.
Func MakeScreenshot()
	Return PerformAction(0xAE, 0x1E)
EndFunc   ;==>MakeScreenshot

;~ Description: Invite a player to the party.
Func InvitePlayer($aPlayerName)
	SendChat('invite ' & $aPlayerName, '/')
EndFunc   ;==>InvitePlayer

;~ Description: Leave your party.
Func LeaveGroup($aKickHeroes = True)
	If $aKickHeroes Then KickAllHeroes()
	Return SendPacket(0x4, $HEADER_PARTY_LEAVE)
EndFunc   ;==>LeaveGroup

;~ Description: Switches to/from Hard Mode.
Func SwitchMode($aMode)
	Return SendPacket(0x8, $HEADER_MODE_SWITCH, $aMode)
EndFunc   ;==>SwitchMode

;~ Description: Resign.
Func Resign()
	SendChat('resign', '/')
EndFunc   ;==>Resign

;~ Description: Donate Kurzick or Luxon faction.
Func DonateFaction($aFaction)
	If StringLeft($aFaction, 1) = 'k' Then
		Return SendPacket(0x10, $HEADER_FACTION_DONATE, 0, 0, 5000)
	Else
		Return SendPacket(0x10, $HEADER_FACTION_DONATE, 0, 1, 5000)
	EndIf
EndFunc   ;==>DonateFaction

;~ Description: Open a dialog.
Func Dialog($aDialogID)
	Return SendPacket(0x8, $HEADER_DIALOG, $aDialogID)
EndFunc   ;==>Dialog

;~ Description: Skip a cinematic.
Func SkipCinematic()
	Return SendPacket(0x4, $HEADER_CINEMATIC_SKIP)
EndFunc   ;==>SkipCinematic

;~ Description: Sets value of GetMapIsLoaded() to 0.
Func InitMapLoad()
	MemoryWrite($mMapIsLoaded, 0)
EndFunc   ;==>InitMapLoad

;~ Description: Changes game language to english.
Func EnsureEnglish($aEnsure)
	If $aEnsure Then
		MemoryWrite($mEnsureEnglish, 1)
	Else
		MemoryWrite($mEnsureEnglish, 0)
	EndIf
EndFunc   ;==>EnsureEnglish

;~ Description: Change game language.
Func ToggleLanguage()
	DllStructSetData($mToggleLanguage, 2, 0x18)
	Enqueue($mToggleLanguagePtr, 8)
EndFunc   ;==>ToggleLanguage

;~ Description: Changes the maximum distance you can zoom out.
Func ChangeMaxZoom($aZoom = 750)
	MemoryWrite($mZoomStill, $aZoom, "float")
	MemoryWrite($mZoomMoving, $aZoom, "float")
EndFunc   ;==>ChangeMaxZoom

;~ Description: Returns current morale.
Func GetMorale($aHeroNumber = 0)
	Local $lAgentID = GetHeroID($aHeroNumber)
	Local $lOffset[4]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x2C
	$lOffset[3] = 0x638
	Local $lIndex = MemoryReadPtr($mBasePointer, $lOffset)
	ReDim $lOffset[6]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x2C
	$lOffset[3] = 0x62C
	$lOffset[4] = 8 + 0xC * BitAND($lAgentID, $lIndex[1])
	$lOffset[5] = 0x18
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1] - 100
EndFunc   ;==>GetMorale

;~ Description: Returns current ping.
Func GetPing()
	Return MemoryRead($mPing)
EndFunc   ;==>GetPing

Func GetLastDialogID()
	Return MemoryRead($mLastDialogID)
EndFunc   ;==>GetLastDialogID

Func GetLastDialogIDHex(Const ByRef $aID)
	If $aID Then Return '0x' & StringReplace(Hex($aID, 8), StringRegExpReplace(Hex($aID, 8), '[^0].*', ''), '')
EndFunc   ;==>GetLastDialogIDHex

;~ Description: Sleep a random amount of time.
Func RndSleep($aAmount, $aRandom = 0.05)
	Local $lRandom = $aAmount * $aRandom
	Sleep(Random($aAmount - $lRandom, $aAmount + $lRandom))
EndFunc   ;==>RndSleep

;~ Description: Sleep a period of time, plus or minus a tolerance
Func TolSleep($aAmount = 150, $aTolerance = 50)
	Sleep(Random($aAmount - $aTolerance, $aAmount + $aTolerance))
EndFunc   ;==>TolSleep

Func InviteGuild($charName)
	If GetAgentExists(-2) Then
		DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
		DllStructSetData($mInviteGuild, 2, 0x4C)
		DllStructSetData($mInviteGuild, 3, 0xBC)
		DllStructSetData($mInviteGuild, 4, 0x01)
		DllStructSetData($mInviteGuild, 5, $charName)
		DllStructSetData($mInviteGuild, 6, 0x02)
		Enqueue(DllStructGetPtr($mInviteGuild), DllStructGetSize($mInviteGuild))
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>InviteGuild

Func InviteGuest($charName)
	If GetAgentExists(-2) Then
		DllStructSetData($mInviteGuild, 1, GetValue('CommandPacketSend'))
		DllStructSetData($mInviteGuild, 2, 0x4C)
		DllStructSetData($mInviteGuild, 3, 0xBC)
		DllStructSetData($mInviteGuild, 4, 0x01)
		DllStructSetData($mInviteGuild, 5, $charName)
		DllStructSetData($mInviteGuild, 6, 0x01)
		Enqueue(DllStructGetPtr($mInviteGuild), DllStructGetSize($mInviteGuild))
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>InviteGuest
#EndRegion Misc

#Region Online Status
Func SetPlayerStatus($iStatus)
	If (($iStatus >= 0 And $iStatus <= 3) And (GetPlayerStatus() <> $iStatus)) Then
		DllStructSetData($mChangeStatus, 2, $iStatus)

		Enqueue($mChangeStatusPtr, 8)
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SetPlayerStatus

Func GetPlayerStatus()
	Return MemoryRead($mCurrentStatus)
EndFunc   ;==>GetPlayerStatus
#EndRegion Online Status

