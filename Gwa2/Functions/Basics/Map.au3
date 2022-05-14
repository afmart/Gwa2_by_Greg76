;~ Description: Returns amount of experience.
Func GetExperience()
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x740]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetExperience

;~ Description: Tests if an area has been vanquished.
Func GetAreaVanquished()
	If GetFoesToKill() = 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>GetAreaVanquished

;~ Description: Returns number of foes that have been killed so far.
Func GetFoesKilled()
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x84C]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetFoesKilled

;~ Description: Returns number of enemies left to kill for vanquish.
Func GetFoesToKill()
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x850]
	Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lReturn[1]
EndFunc   ;==>GetFoesToKill

;~ Description: Returns current map ID.
Func GetMapID()
	Return MemoryRead($mMapID)
EndFunc   ;==>GetMapID

;~ Description: Returns current load-state.
Func GetMapLoading()
	Return MemoryRead($mMapLoading)
EndFunc   ;==>GetMapLoading

;~ Description: Returns if map has been loaded. Reset with InitMapLoad().
Func GetMapIsLoaded()
;~ 	Return MemoryRead($mMapIsLoaded) And GetAgentExists(-2)
	Return GetAgentExists(-2)
EndFunc   ;==>GetMapIsLoaded

;~ Description: Returns current district
Func GetDistrict()
	Local $lOffset[4] = [0, 0x18, 0x44, 0x1B4]
	Local $lResult = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lResult[1]
EndFunc   ;==>GetDistrict

;~ Description: Internal use for travel functions.
Func GetRegion()
	Return MemoryRead($mRegion)
EndFunc   ;==>GetRegion

;~ Description: Internal use for travel functions.
Func GetLanguage()
	Return MemoryRead($mLanguage)
EndFunc   ;==>GetLanguage

;~ Description: Returns your characters name.
Func GetCharname()
	Return MemoryRead($mCharname, 'wchar[30]')
EndFunc   ;==>GetCharname

;~ Description: Returns if you're logged in.
Func GetLoggedIn()
	Return MemoryRead($mLoggedIn)
EndFunc   ;==>GetLoggedIn

;~ Description: Returns language currently being used.
Func GetDisplayLanguage()
	Local $lOffset[6] = [0, 0x18, 0x18, 0x194, 0x4C, 0x40]
	Local $lResult = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lResult[1]
EndFunc   ;==>GetDisplayLanguage

;~ Returns how long the current instance has been active, in milliseconds.
Func GetInstanceUpTime()
	Local $lOffset[4]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x8
	$lOffset[3] = 0x1AC
	Local $lTimer = MemoryReadPtr($mBasePointer, $lOffset)
	Return $lTimer[1]
EndFunc   ;==>GetInstanceUpTime

;~ Returns the game client's build number
Func GetBuildNumber()
	Return $mBuildNumber
EndFunc   ;==>GetBuildNumber

Func CheckArea($aX, $aY)
	$ret = False
	$pX = DllStructGetData(GetAgentByID(-2), "X")
	$pY = DllStructGetData(GetAgentByID(-2), "Y")

	If ($pX < $aX + 500) And ($pX > $aX - 500) And ($pY < $aY + 500) And ($pY > $aY - 500) Then
		$ret = True
	EndIf
	Return $ret
EndFunc   ;==>CheckArea

Func GetPartySize()
	Local $lOffset0[5] = [0, 0x18, 0x4C, 0x54, 0xC]
	Local $lplayersPtr = MemoryReadPtr($mBasePointer, $lOffset0)

	Local $lOffset1[5] = [0, 0x18, 0x4C, 0x54, 0x1C]
	Local $lhenchmenPtr = MemoryReadPtr($mBasePointer, $lOffset1)

	Local $lOffset2[5] = [0, 0x18, 0x4C, 0x54, 0x2C]
	Local $lheroesPtr = MemoryReadPtr($mBasePointer, $lOffset2)

	Local $Party1 = MemoryRead($lplayersPtr[0], 'long') ; players
	Local $Party2 = MemoryRead($lhenchmenPtr[0], 'long') ; henchmen
	Local $Party3 = MemoryRead($lheroesPtr[0], 'long') ; heroes

	Local $lReturn = $Party1 + $Party2 + $Party3
;~    If $lReturn > 12 or $lReturn < 1 Then $lReturn = 8
	Return $lReturn
EndFunc   ;==>GetPartySize

Func WaitMapLoading($aMapID = 0, $aDeadlock = 10000)
;~ 	Waits $aDeadlock for load to start, and $aDeadLock for agent to load after map is loaded.
	Local $lMapLoading
	Local $lDeadlock = TimerInit()

	InitMapLoad()

	Do
		Sleep(200)
		$lMapLoading = GetMapLoading()
		If $lMapLoading == 2 Then $lDeadlock = TimerInit()
		If TimerDiff($lDeadlock) > $aDeadlock And $aDeadlock > 0 Then Return False
	Until $lMapLoading <> 2 And GetMapIsLoaded() And (GetMapID() = $aMapID Or $aMapID = 0)

	RndSleep(5000)

	Return True
EndFunc   ;==>WaitMapLoading
