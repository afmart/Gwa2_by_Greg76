#cs
#################################
#                               #
#          Vaettir Bot          #
#                               #
#################################
Author: gigi
Modified by; Greg76
#ce

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Outfile=..\Exe\Tools_Bot-dev.a3x
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /sf /tl
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ScrollBarsConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <FileConstants.au3>
#include <Date.au3>
#include <GuiEdit.au3>
#include <_Files.au3>

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
; Opt("MustDeclareVars", True)

Global $charName  = ""
Global $ProcessID = ""
Global $cmdmode   = false
Global $timer = TimerInit()
Global $Version = "1.0.0"

Global $statPlatinum = 0
Global $statExperience = 0
Global $statTitlePoints = 0

; ==== Bot global variables ====
Global $RenderingEnabled = True
Global $PickUpMapPieces = False
Global $PickUpTomes = False
Global $RunCount = 0
Global $FailCount = 0
Global $BotRunning = False
Global $BotInitialized = False
Global $ChatStuckTimer = TimerInit()
Global $Deadlocked = False
Global $CurGold = 0

Global Const $SkillBarTemplate = "OwVUI2h5lPP8Id2BkAiAvpLBTAA"
; declare skill numbers to make the code WAY more readable (UseSkill($SkillSlot_Sf) is better than UseSkill(2))
Global Const $SkillSlot_Paradox = 1
Global Const $SkillSlot_Sf = 2
Global Const $SkillSlot_Shroud = 3
Global Const $SkillSlot_WayOfPerf = 4
Global Const $SkillSlot_HoS = 5
Global Const $SkillSlot_Wastrel = 6
Global Const $SkillSlot_Echo = 7
Global Const $SkillSlot_Channeling = 8
; Store skills energy cost
Global $skillCost[9]
$skillCost[$SkillSlot_Paradox] = 15
$skillCost[$SkillSlot_Sf] = 5
$skillCost[$SkillSlot_Shroud] = 10
$skillCost[$SkillSlot_WayOfPerf] = 5
$skillCost[$SkillSlot_HoS] = 5
$skillCost[$SkillSlot_Wastrel] = 5
$skillCost[$SkillSlot_Echo] = 15
$skillCost[$SkillSlot_Channeling] = 5

If $CmdLine[0] = 0 Then
Else
    $cmdmode = true

    If 1 > UBound($CmdLine)-1 Then exit; element is out of the array bounds
    If 2 > UBound($CmdLine)-1 Then exit;

    $charName  = $CmdLine[1]
    $ProcessID = $CmdLine[2]
    LOGIN($charName, $ProcessID)
EndIf

Global Const $doLoadLoggedChars = True

#Region GUI
Global $MATID, $RAREMATSBUY = True, $mFoundChest = False, $mFoundMerch = False, $Bags = 4, $PICKUP_GOLDS = False
Global $SELECT_MAT = "Fur Square|Bolt of Linen|Bolt of Damask|Bolt of Silk|Glob of Ectoplasm|Steel of Ignot|Deldrimor Steel Ingot|Monstrous Claws|Monstrous Eye|Monstrous Fangs|Rubies|Sapphires|Diamonds|Onyx Gemstones|Lumps of Charcoal|Obsidian Shard|Tempered Glass Vial|Leather Squares|Elonian Leather Square|Vial of Ink|Rolls of Parchment|Rolls of Vellum|Spiritwood Planks|Amber Chunk|Jadeite Shard"
Global $SELECT_TOWN = "Longeye's Ledge|Sifhalla"

Global Const $mainGui = GUICreate("Vaettir Bot", 375, 275)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
Global $Input
If $doLoadLoggedChars Then
	$Input = GUICtrlCreateCombo("", 8, 8, 129, 21)
		GUICtrlSetData(-1, GetLoggedCharNames())
Else
	$Input = GUICtrlCreateInput("character name", 8, 8, 129, 21)
EndIf
Global $LOCATION = GUICtrlCreateCombo("Location", 8, 35, 125, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlCreateLabel("Runs:", 8, 65, 70, 17)
Global Const $RunsLabel = GUICtrlCreateLabel($RunCount, 80, 65, 50, 17)
GUICtrlCreateLabel("Fails:", 8, 80, 70, 17)
Global Const $FailsLabel = GUICtrlCreateLabel($FailCount, 80, 80, 50, 17)
Global Const $Checkbox = GUICtrlCreateCheckbox("Disable Rendering", 8, 98, 129, 17)
	GUICtrlSetState( -1, $GUI_DISABLE)
	GUICtrlSetOnEvent( -1, "ToggleRendering")
Global Const $Button = GUICtrlCreateButton("Start", 8, 120, 131, 25)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")
Global Const $StatusLabel = GUICtrlCreateLabel("", 8, 148, 125, 17)
GUICtrlCreateLabel("Select Rare Mats", 8, 155, 100, 17)
Global $SELECTMAT = GUICtrlCreateCombo("Rare Mats", 8, 175, 125,  25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))

Global $GLOGBOX = GUICtrlCreateEdit("", 140, 8, 225, 240, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)
GUISetState(@SW_SHOW)
Global Const $Leeching = GUICtrlCreateCheckbox("Leech Bot Present", 8, 253, 110, 17)
Global Const $MapPieces = GUICtrlCreateCheckbox("Map Pieces", 8, 228, 75, 17)
GUICtrlSetState($MapPieces, $GUI_DISABLE)
Global Const $Tomes = GUICtrlCreateCheckbox("Mesmer Tomes", 8, 203, 90, 17)
GUICtrlSetState($Tomes, $GUI_DISABLE)
Global Const $StoreGolds = GUICtrlCreateCheckbox("Store Golds", 140, 253, 74, 17)
Global Const $EventItems = GUICtrlCreateCheckbox("Pickup Only Event Items", 224, 253, 137, 17)
GUICtrlSetState(-1,$gui_unchecked)
GUICtrlSetData($LOCATION, $SELECT_TOWN)
GUICtrlSetData($SELECTMAT, $SELECT_MAT)
GUICtrlSetOnEvent($SELECTMAT, "START_STOP")

;~ Description: Handles the button presses
Func GuiButtonHandler()
	If $BotRunning Then
		GUICtrlSetData($Button, "Will pause after this run")
		GUICtrlSetState($Button, $GUI_DISABLE)
		$BotRunning = False
	ElseIf $BotInitialized Then
		GUICtrlSetData($Button, "Pause")
		$BotRunning = True
	Else
		Out("Initializing")
		Local $CharName = GUICtrlRead($Input)
		If $CharName=="" Then
			If Initialize(ProcessExists("gw.exe")) = False Then
				MsgBox(0, "Error", "Guild Wars is not running.")
				Exit
			EndIf
		Else
			If Initialize($CharName) = False Then
				MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		GUICtrlSetState($Checkbox, $GUI_ENABLE)
		GUICtrlSetState($Leeching, $GUI_ENABLE)
		GUICtrlSetState($MapPieces, $GUI_ENABLE)
		GUICtrlSetState($Tomes, $GUI_ENABLE)
		GUICtrlSetState($StoreGolds, $GUI_ENABLE)
		GUICtrlSetState($EventItems, $GUI_ENABLE)
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetData($Button, "Pause")
		WinSetTitle($mainGui, "", "VBot-" & GetCharname())
		$BotRunning = True
		$BotInitialized = True
	EndIf
EndFunc
#EndRegion GUI

Func START_STOP()

	Switch (@GUI_CtrlId)
		Case $SelectMat
			MatSwitcher()
		 EndSwitch
EndFunc   ;==>START_STOP


Out("Vaettir Bot " & $Version)
Out("Author: gigi")
Out("Modified by: Greg76")

If $cmdmode Then
    GUICtrlSendMsg($Button, $BM_CLICK, 0, 0)
    ToggleRendering()
Else
    Out("Waiting for input...")
EndIf

While Not $BotRunning
	Sleep(100)
WEnd

While True
	If (CountSlots() < 5) Then
		If Not $BotRunning Then
			Out("Bot Paused")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "Start")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf
		Inventory()
	EndIf

	If GUICtrlRead($LOCATION, "") == "Longeye's Ledge" Then
		MapL()
		RunThereLongeyes()
	ElseIf GUICtrlRead($LOCATION, "") == "Sifhalla" Then
		MapS()
		RunThereSifhalla()
	EndIf
	If (GetIsDead(-2)==True) Then ContinueLoop

	If GUICtrlRead(4) = 1 Then
		$PickUpAll = False
	Else
		$PickUpAll = True
	EndIf

	If GUICtrlRead($MapPieces) = 1 Then
		$PickUpMapPieces = True
	Else
		$PickUpMapPieces = False
	EndIf

	If GUICtrlRead($Tomes) = 1 Then
		$PickUpTomes = True
	Else
		$PickUpTomes = False
	EndIf

	While (CountSlots() > 4)
		If Not $BotRunning Then
			Out("Bot Paused")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "Start")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf
		CombatLoop()
	WEnd

	If (CountSlots() < 6) Then
		If Not $BotRunning Then
			Out("Bot Paused")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "Start")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf
		Inventory()
	EndIf
WEnd

#Region Starting Map
Func MapL()
	;~ Checks if you are already in Longeye's Ledge, if not then you travel to Longeye's Ledge
	If GetMapID() <> $Longeyes_Ledge Then
		Out("Travelling to longeye")
		RndTravel($Longeyes_Ledge)
	EndIf

	LoadSkillTemplate($SkillBarTemplate, 0)

	;~ Hardmode
	SwitchMode(1)

	Out("Exiting Outpost")
	MoveTo(-25333, 15793)
	Do
		Move(-26472, 16217, 100)
		Sleep(2500)
	Until WaitMapLoading($Bjora_Marches)

	Sleep(GetPing()+500)
EndFunc

;~ Description: zones to longeye if we're not there, and travel to Jaga Moraine
Func RunThereLongeyes()
	Out("Running to farm spot")
	DIM $array_Longeyes[31][3] = [ _
		[1, 15003.8, -16598.1], _
		[1, 15003.8, -16598.1], _
		[1, 12699.5, -14589.8], _
		[1, 11628,   -13867.9], _
		[1, 10891.5, -12989.5], _
		[1, 10517.5, -11229.5], _
		[1, 10209.1, -9973.1], _
		[1, 9296.5,  -8811.5], _
		[1, 7815.6,  -7967.1], _
		[1, 6266.7,  -6328.5], _
		[1, 4940,    -4655.4], _
		[1, 3867.8,  -2397.6], _
		[1, 2279.6,  -1331.9], _
		[1, 7.2,     -1072.6], _
		[1, 7.2,     -1072.6], _
		[1, -1752.7, -1209], _
		[1, -3596.9, -1671.8], _
		[1, -5386.6, -1526.4], _
		[1, -6904.2, -283.2], _
		[1, -7711.6, 364.9], _
		[1, -9537.8, 1265.4], _
		[1, -11141.2,857.4], _
		[1, -12730.7,371.5], _
		[1, -13379,  40.5], _
		[1, -14925.7,1099.6], _
		[1, -16183.3,2753], _
		[1, -17803.8,4439.4], _
		[1, -18852.2,5290.9], _
		[1, -19250,  5431], _
		[1, -19968, 5564], _
		[2, -20076,  5580]]

	Out("Running to Jaga")
	For $i = 0 To (UBound($array_Longeyes) -1)
		If ($array_Longeyes[$i][0]==1) Then
			If Not MoveRunning($array_Longeyes[$i][1], $array_Longeyes[$i][2]) Then ExitLoop
		EndIf
		If ($array_Longeyes[$i][0]==2) Then
			Move($array_Longeyes[$i][1], $array_Longeyes[$i][2], 30)
			Sleep(3500)
		EndIf
	Next
EndFunc

Func MapS()
	;~ Checks if you are already in Sifhalla, if not then you travel to Sifhalla
	If (GetMapID() <> $Sifhalla) Then
		Out("Travelling to Sifhalla")
		RndTravel($Sifhalla)
	EndIf

	LoadSkillTemplate($SkillBarTemplate, 0)

	;~ Hardmode
	SwitchMode(1)

	Out("Exiting Outpost")
	MoveTo(16197, 22825)
	Do
		Move(16800, 22867)
		Sleep(250)
	Until WaitMapLoading($Jaga_Moraine)

	Sleep(GetPing()+500)
EndFunc

Func RunThereSifhalla()
	Out("Running to farm spot")
	DIM $array_Sifhalla[31][3] = [ _
		[1, -11059,	-23401], _
		[1, -8524,	-21590], _
		[1, -8870,	-21818], _
		[1, -6979,	-21705], _
		[1, -4144,	-25480], _
		[1, -456,	-25575], _
		[1, 2362,	-23315], _
		[1, 1877,	-21862], _
		[1, 914,	-21159], _
		[1, 1303,	-18593], _
		[1, 2092,	-16943], _
		[1, 2909,	-15487], _
		[1, 2757,	-13745], _
		[1, 1280,	-11243], _
		[1, -217,	-10112], _
		[1, -1201,	-8855], _
		[1, -2022,	-8535], _
		[1, -2383,	-7170], _
		[1, -332,	-5391], _
		[1, 1726,	-5463], _
		[1, 3465,	-5999], _
		[1, 4130,	-8139], _
		[1, 5170,	-9609], _
		[1, 7922,	-11222], _
		[1, 9600,	-11614], _
		[1, 11818,	-13547], _
		[1, 12911,	-15538], _
		[1, 14199,	-18786], _
		[1, 15201,	-20293], _
		[2, 15865, -20531], _
		[3, -20076,  5580]]

	For $i = 0 To (UBound($array_Sifhalla) -1)
		If ($array_Sifhalla[$i][0]==1) Then
			If Not MoveRunning($array_Sifhalla[$i][1], $array_Sifhalla[$i][2]) Then ExitLoop
		EndIf
		If ($array_Sifhalla[$i][0]==2) Then
			Move($array_Sifhalla[$i][1], $array_Sifhalla[$i][2], 30)
			WaitMapLoading($Bjora_Marches)
		EndIf
		If ($array_Sifhalla[$i][0]==3) Then
			Move($array_Sifhalla[$i][1], $array_Sifhalla[$i][2], 30)
			Sleep(3500)
		EndIf
	Next
EndFunc
#EndRegion Starting Map

#Region Fight
; Description: This is pretty much all, take bounty, do left, do right, kill, rezone
Func CombatLoop()
	If Not $RenderingEnabled Then ClearMemory()

	If GetNornTitle() < 160000 Then
		Out("Taking Blessing")
		GoNearestNPCToCoords(13318, -20826)
		Dialog(132)
	EndIf
;~ 	SendChat("")
	DisplayCounts()

	Sleep(GetPing()+2000)

	Out("Moving to aggro left")
	MoveTo(13501, -20925)
	MoveTo(13172, -22137)
	TargetNearestEnemy()
	MoveAggroing(12496, -22600, 150)
	MoveAggroing(11375, -22761, 150)
	MoveAggroing(10925, -23466, 150)
	MoveAggroing(10917, -24311, 150)
	MoveAggroing(9910, -24599, 150)
	MoveAggroing(8995, -23177, 150)
	MoveAggroing(8307, -23187, 150)
	MoveAggroing(8213, -22829, 150)
	MoveAggroing(8307, -23187, 150)
	MoveAggroing(8213, -22829, 150)
	MoveAggroing(8740, -22475, 150)
	MoveAggroing(8880, -21384, 150)
	MoveAggroing(8684, -20833, 150)
	MoveAggroing(8982, -20576, 150)

	Out("Waiting for left ball")
	WaitFor(12*1000)

	If GetDistance()<1000 Then
		UseSkillEx($SkillSlot_HoS, -1)
	Else
		UseSkillEx($SkillSlot_HoS, -2)
	EndIf

	WaitFor(6000)

	TargetNearestEnemy()

	Out("Moving to aggro right")
	MoveAggroing(10196, -20124, 150)
	MoveAggroing(9976, -18338, 150)
	MoveAggroing(11316, -18056, 150)
	MoveAggroing(10392, -17512, 150)
	MoveAggroing(10114, -16948, 150)
	MoveAggroing(10729, -16273, 150)
	MoveAggroing(10810, -15058, 150)
	MoveAggroing(11120, -15105, 150)
	MoveAggroing(11670, -15457, 150)
	MoveAggroing(12604, -15320, 150)
	TargetNearestEnemy()
	MoveAggroing(12476, -16157)

	Out("Waiting for right ball")
	WaitFor(15*1000)

	If GetDistance()<1000 Then
		UseSkillEx($SkillSlot_HoS, -1)
	Else
		UseSkillEx($SkillSlot_HoS, -2)
	EndIf

	WaitFor(5000)

	Out("Blocking enemies in spot")
	MoveAggroing(12920, -17032, 30)
	MoveAggroing(12847, -17136, 30)
	MoveAggroing(12720, -17222, 30)
	WaitFor(300)
	MoveAggroing(12617, -17273, 30)
	WaitFor(300)
	MoveAggroing(12518, -17305, 20)
	WaitFor(300)
	MoveAggroing(12445, -17327, 10)

	Out("Killing")
	Kill()

	WaitFor(1200)

	Out("Looting")
	If GUICtrlRead($EventItems) = $GUI_CHECKED Then
		EventPickUpLoot()
	Else
		PickUpLoot()
	EndIf

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
	Else
		$RunCount += 1
		GUICtrlSetData($RunsLabel, $RunCount)
	EndIf

	Out("Zoning")
	MoveAggroing(12289, -17700)
	MoveAggroing(15318, -20351)

	While GetIsDead(-2)
		Out("Waiting for res")
		Sleep(1000)
	WEnd

	Do
		Move(15865, -20531, 100)
		Sleep(250)
	Until WaitMapLoading($Bjora_Marches)

	MoveTo(-19968, 5564)

	Do
		Move(-20076,  5580, 100)
		Sleep(250)
	Until WaitMapLoading($Jaga_Moraine)

	ClearMemory()
EndFunc

Func StayAlive(Const ByRef $lAgentArray)
	If IsRecharged($SkillSlot_Sf) Then
		UseSkillEx($SkillSlot_Paradox)
		UseSkillEx($SkillSlot_Sf)
	EndIf

	Local $lMe = GetAgentByID(-2)
	Local $lEnergy = GetEnergy($lMe)
	Local $lAdjCount, $lAreaCount, $lSpellCastCount, $lProximityCount
	Local $lDistance
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
		If $lDistance < 1200*1200 Then
			$lProximityCount += 1
			If $lDistance < $spellcasting_range Then
				$lSpellCastCount += 1
				If $lDistance < $area_range Then
					$lAreaCount += 1
					If $lDistance < $adjacent_range Then
						$lAdjCount += 1
					EndIf
				EndIf
			EndIf
		EndIf
	Next

	UseSF($lProximityCount)

	If IsRecharged($SkillSlot_Shroud) Then
		If $lSpellCastCount > 0 And DllStructGetData(GetEffect($Shroud_of_Distress), "SkillID") == 0 Then
			UseSkillEx($SkillSlot_Shroud)
		ElseIf DllStructGetData($lMe, "HP") < 0.6 Then
			UseSkillEx($SkillSlot_Shroud)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($SkillSlot_Shroud)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($SkillSlot_WayOfPerf) Then
		If DllStructGetData($lMe, "HP") < 0.5 Then
			UseSkillEx($SkillSlot_WayOfPerf)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($SkillSlot_WayOfPerf)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($SkillSlot_Channeling) Then
		If Not HasEffect($Channeling) Then
			UseSkillEx($SkillSlot_Channeling)
		EndIf
	EndIf

	UseSF($lProximityCount)
EndFunc

;~ Description: Uses sf if there's anything close and if its recharged
Func UseSF($lProximityCount)
	If IsRecharged($SkillSlot_Sf) And $lProximityCount > 0 Then
		UseSkillEx($SkillSlot_Paradox)
		UseSkillEx($SkillSlot_Sf)
	EndIf
EndFunc

;~ Description: Move to destX, destY, while staying alive vs vaettirs
Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)
	If GetIsDead(-2) Then Return

	Local $lMe, $lAgentArray
	Local $lBlocked
	Local $lHosCount
	Local $lAngle
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)

	Do
		RndSleep(50)

		$lMe = GetAgentByID(-2)

		$lAgentArray = GetAgentArray(0xDB)

		If GetIsDead($lMe) Then Return False

		StayAlive($lAgentArray)

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			If $lHosCount > 6 Then
				Do	; suicide
					Sleep(100)
				Until GetIsDead(-2)
				Return False
			EndIf

			$lBlocked += 1
			If $lBlocked < 5 Then
				Move($lDestX, $lDestY, $lRandom)
			ElseIf $lBlocked < 10 Then
				$lAngle += 40
				Move(DllStructGetData($lMe, 'X')+300*sin($lAngle), DllStructGetData($lMe, 'Y')+300*cos($lAngle))
			ElseIf IsRecharged($SkillSlot_HoS) Then
				If $lHosCount==0 And GetDistance() < 1000 Then
					UseSkillEx($SkillSlot_HoS, -1)
				Else
					UseSkillEx($SkillSlot_HoS, -2)
				EndIf
				$lBlocked = 0
				$lHosCount += 1
			EndIf
		Else
			If $lBlocked > 0 Then
				If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
				EndIf
				$lBlocked = 0
				$lHosCount = 0
			EndIf

			If GetDistance() > 1100 Then ; target is far, we probably got stuck.
				If TimerDiff($ChatStuckTimer) > 3000 Then ; dont spam
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
					RndSleep(GetPing())
					If GetDistance() > 1100 Then ; we werent stuck, but target broke aggro. select a new one.
						TargetNearestEnemy()
					EndIf
				EndIf
			EndIf
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	Return True
EndFunc

;~ Description: Move to destX, destY. This is to be used in the run from across Bjora
Func MoveRunning($lDestX, $lDestY)
	If GetIsDead(-2) Then Return False

	Local $lMe, $lTgt
	Local $lBlocked

	Move($lDestX, $lDestY)

	Do
		RndSleep(500)

		TargetNearestEnemy()
		$lMe = GetAgentByID(-2)
		$lTgt = GetAgentByID(-1)

		If GetIsDead($lMe) Then Return False

		If GetDistance($lMe, $lTgt) < 1300 And GetEnergy($lMe)>20 And IsRecharged($SkillSlot_Paradox) And IsRecharged($SkillSlot_Sf) Then
			UseSkillEx($SkillSlot_Paradox)
			UseSkillEx($SkillSlot_Sf)
		EndIf

		If DllStructGetData($lMe, "HP") < 0.9 And GetEnergy($lMe) > 10 And IsRecharged($SkillSlot_Shroud) Then UseSkillEx($SkillSlot_Shroud)

		If DllStructGetData($lMe, "HP") < 0.5 And GetDistance($lMe, $lTgt) < 500 And GetEnergy($lMe) > 5 And IsRecharged($SkillSlot_HoS) Then UseSkillEx($SkillSlot_HoS, -1)

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($lDestX, $lDestY)
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 250
	Return True
EndFunc

;~ Description: Waits until all foes are in range (useless comment ftw)
Func WaitUntilAllFoesAreInRange($lRange)
	Local $lAgentArray
	Local $lAdjCount, $lSpellCastCount
	Local $lMe
	Local $lDistance
	Local $lShouldExit = False
	While Not $lShouldExit
		Sleep(100)
		$lMe = GetAgentByID(-2)
		If GetIsDead($lMe) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)
		$lShouldExit = False
		For $i=1 To $lAgentArray[0]
			$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
			If $lDistance < $spellcasting_range And $lDistance > $lRange^2 Then
				$lShouldExit = True
				ExitLoop
			EndIf
		Next
	WEnd
EndFunc

;~ Description: Wait and stay alive at the same time (like Sleep(..), but without the letting yourself die part)
Func WaitFor($lMs)
	If GetIsDead(-2) Then Return
	Local $lAgentArray
	Local $lTimer = TimerInit()
	Do
		Sleep(100)
		If GetIsDead(-2) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)
	Until TimerDiff($lTimer) > $lMs
EndFunc

;~ Description: BOOOOOOOOOOOOOOOOOM
Func Kill()
	If GetIsDead(-2) Then Return

	Local $lAgentArray
	Local $lDeadlock = TimerInit()

	TargetNearestEnemy()
	Sleep(100)
	Local $lTargetID = GetCurrentTargetID()

	While GetAgentExists($lTargetID) And DllStructGetData(GetAgentByID($lTargetID), "HP") > 0
		Sleep(50)
		If GetIsDead(-2) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)

		; Use echo if possible
		If GetSkillbarSkillRecharge($SkillSlot_Sf) > 5000 And GetSkillbarSkillID($SkillSlot_Echo)==$Arcane_Echo Then
			If IsRecharged($SkillSlot_Wastrel) And IsRecharged($SkillSlot_Echo) Then
				UseSkillEx($SkillSlot_Echo)
				UseSkillEx($SkillSlot_Wastrel, GetGoodTarget($lAgentArray))
				$lAgentArray = GetAgentArray(0xDB)
			EndIf
		EndIf

		UseSF(True)

		; Use wastrel if possible
		If IsRecharged($SkillSlot_Wastrel) Then
			UseSkillEx($SkillSlot_Wastrel, GetGoodTarget($lAgentArray))
			$lAgentArray = GetAgentArray(0xDB)
		EndIf

		UseSF(True)

		; Use echoed wastrel if possible
		If IsRecharged($SkillSlot_Echo) And GetSkillbarSkillID($SkillSlot_Echo)==$Wastrels_Demise Then
			UseSkillEx($SkillSlot_Echo, GetGoodTarget($lAgentArray))
		EndIf

		; Check if target has ran away
		If GetDistance(-2, $lTargetID) > $earshot_range Then
			TargetNearestEnemy()
			Sleep(GetPing()+100)
			If GetAgentExists(-1) And DllStructGetData(GetAgentByID(-1), "HP") > 0 And GetDistance(-2, -1) < $RANGE_AREA Then
				$lTargetID = GetCurrentTargetID()
			Else
				ExitLoop
			EndIf
		EndIf

		If TimerDiff($lDeadlock) > 60 * 1000 Then ExitLoop
	WEnd
EndFunc

; Returns a good target for watrels
; Takes the agent array as returned by GetAgentArray(..)
Func GetGoodTarget(Const ByRef $lAgentArray)
	Local $lMe = GetAgentByID(-2)
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If GetDistance($lMe, $lAgentArray[$i]) > $nearby_range Then ContinueLoop
		If GetHasHex($lAgentArray[$i]) Then ContinueLoop
		If Not GetIsEnchanted($lAgentArray[$i]) Then ContinueLoop
		Return DllStructGetData($lAgentArray[$i], "ID")
	Next
EndFunc

#EndRegion Fight

#Region Inventory
Func Inventory($aBags = 4)
	Out("travel map ")
	ZoneMap(642)
	WaitMapLoading()
	GoNearestNPCToCoords(-2748.00, 1019.00)

	If GUICtrlRead($StoreGolds) = $GUI_CHECKED Then
	StoreUNIDGolds()
	EndIf


	Out("Identifying")
	Ident(1)
	Ident(2)
	Ident(3)
	Ident(4)

	Out("Selling")
	Sell(1)
	Sell(2)
	Sell(3)
	Sell(4)


	Sleep(GetPing()+1000)
	If GetGoldCharacter() > 80000 Then
		out("Yes Master +80K")
		DepositGold(80000)
	EndIf

	ZoneMap(650)
	WaitMapLoading(1000)
    $BotRunning = True
    $BotInitialized = True
EndFunc

Func SalvageKit()
   If FindSalvageKit() = 0 Then
	  If GetGoldCharacter() < 100 Then
		 WithdrawGold(100)
		 RndSleep(2000)
	  EndIf
	  BuyItem(2, 1, 100)
	  RndSleep(1000)
   EndIf
EndFunc	;=> SalvageKit

Func Ident($BAGINDEX)
	Local $bag
	Local $I
	Local $AITEM
	$BAG = GETBAG($BAGINDEX)
	For $I = 1 To DllStructGetData($BAG, "slots")
		If FINDIDKIT() = 0 Then
			If GETGOLDCHARACTER() < 500 And GETGOLDSTORAGE() > 499 Then
				WITHDRAWGOLD(500)
				Sleep(GetPing()+500)
			EndIf
			Local $J = 0
			Do
				BuyItem(6, 1, 500)
				Sleep(GetPing()+500)
				$J = $J + 1
			Until FINDIDKIT() <> 0 Or $J = 3
			If $J = 3 Then ExitLoop
			Sleep(GetPing()+500)
		EndIf
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "Id") = 0 Then ContinueLoop
		IDENTIFYITEM($AITEM)
		Sleep(GetPing()+500)
	Next
EndFunc

Func Sell($BAGINDEX)
	Local $AITEM
	Local $BAG = GETBAG($BAGINDEX)
	Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "Id") == 0 Then ContinueLoop
		If CANSELL($AITEM) Then
			Out("Selling item: " & $BAGINDEX & ", " & $I)
			SELLITEM($AITEM)
		EndIf
		Sleep(GetPing()+250)
	Next
EndFunc

Func CanSell($aItem)
	Local $LMODELID = DllStructGetData($aitem, "ModelId")
	Local $LRARITY = GetRarity($aitem)
	Local $Requirement = GetItemReq($aItem)
	If $LRARITY == $RARITY_Gold Then
		Return True
	EndIf
	If $LRARITY == $RARITY_Purple Then
		Return True
	EndIf
;~ Leaving Blues and Whites as false for now. Going to make it salvage them at some point in the future. It does not currently pick up whites or blues
	If $LRARITY == $RARITY_Blue Then
		Return True
	EndIf
	If $LMODELID == $Dye Then
		Switch DllStructGetData($aitem, "ExtraId")
			Case $Black_Dye_ExtraID, $White_Dye_ExtraID
				Return False
			Case Else
				Return True
		EndSwitch
	EndIf
	If CheckArrayTomes($lModelID)					Then Return False
	If CheckArrayMaterials($lModelID)				Then Return False
	; All weapon mods
	If CheckArrayWeaponMods($lModelID)				Then Return False
	; ==== General ====
	If CheckArrayGeneralItems($lModelID)			Then Return False ; Lockpicks, Kits
	If $lModelID == $ITEM_ID_Glacial_Stone 		Then Return False
	If CheckArrayPscon($lModelID)					Then Return False
	; ==== Stupid Drops =
	If CheckArrayMapPieces($lModelID)				Then Return False
	;DONT SELL CANDY CANE SHARDS!!!
	If $lModelID == 556 							Then Return False
	If $LRARITY == $RARITY_White 					Then Return True
	Return True
EndFunc   ;==>CanSell

#EndRegion Inventory

Func GenericRandomPath($aPosX, $aPosY, $aRandom = 50, $STOPSMIN = 1, $STOPSMAX = 5, $NumberOfStops = -1)
	If $NumberOfStops = -1 Then $NumberOfStops = Random($STOPSMIN, $STOPSMAX, 1)
	Local $lAgent = GetAgentByID(-2)
	Local $MyPosX = DllStructGetData($lAgent, "X")
	Local $MyPosY = DllStructGetData($lAgent, "Y")
	Local $Distance = ComputeDistance($MyPosX, $MyPosY, $aPosX, $aPosY)
	If $NumberOfStops = 0 Or $Distance < 200 Then
		MoveTo($aPosX, $aPosY, $aRandom)
	Else
		Local $M = Random(0, 1)
		Local $N = $NumberOfStops - $M
		Local $StepX = (($M * $aPosX) + ($N * $MyPosX)) / ($M + $N)
		Local $StepY = (($M * $aPosY) + ($N * $MyPosY)) / ($M + $N)
		MoveTo($StepX, $StepY, $aRandom)
		GenericRandomPath($aPosX, $aPosY, $aRandom, $STOPSMIN, $STOPSMAX, $NumberOfStops - 1)
	EndIf
EndFunc   ;==>GENERICRANDOMPATH

Func LOGIN($char_name = "fail", $ProcessID = false)

    If $char_name = "" Then
    	MsgBox(0, "Error", "char_name" & $char_name)
        Exit
    EndIf

    If $ProcessID = False Then
    	MsgBox(0, "Error", "ProcessID" & $ProcessID)
        Exit
    EndIf

    Sleep(Random(1000,1500))

    Local $WindowList=WinList("Guild Wars")
    Local $WinHandle = False;


    For $i = 1 to $WindowList[0][0]
        If WinGetProcess($WindowList[$i][1])= $ProcessID Then
            $WinHandle=$WindowList[$i][1]
        EndIf
    Next

    If $WinHandle = False Then
    	MsgBox(0, "Error", "WinHandle" & $WinHandle)
        Exit
    EndIf

    ; ControlSend($WinHandle, "", "", "{enter}")
    ; Sleep(Random(2500,3500))
    ; ControlSend($WinHandle, "", "", "{enter}")
    ; Sleep(Random(100,150))
    ; ControlSend($WinHandle, "", "", "{enter}")
    ; Sleep(Random(2000,2500))
    ; ControlSend($WinHandle, "", "", "{enter}")
    ; Sleep(Random(1000,1500))
    ; WinSetTitle($WinHandle, "", $char_name & " - Guild Wars")
    ; Sleep(Random(5000,7500))
    Local $lCheck    = False
    Local $lDeadLock = Timerinit()

    ControlSend($WinHandle, "", "", "{enter}")
    Sleep(Random(500,1500))
    WinSetTitle($WinHandle, "", $char_name & " - Guild Wars")
    Do
        Sleep(50)
        ; $lCheck = GetMapLoading() <> 2 and GetAgentExists(-2)
        $lCheck = GetMapLoading() <> 2
    Until $lCheck Or TimerDiff($lDeadLock)>15000
    ; ControlSend($WinHandle, "", "", "{enter}")
    ; Sleep(Random(500,1500))
    If $lCheck = False Then
        ControlSend($WinHandle, "", "", "{enter}")
        $lDeadLock = Timerinit()
        Do
            Sleep(50)
            ; $lCheck = GetMapLoading() <> 2 and GetAgentExists(-2)
            $lCheck = GetMapLoading() <> 2
        Until $lCheck Or TimerDiff($lDeadLock)>15000
    EndIf
    ; ControlSend($WinHandle, "", "", "{enter}")
    ; Sleep(Random(500,1500))
    If $lCheck = False Then
        ControlSend($WinHandle, "", "", "{enter}")
        $lDeadLock = Timerinit()
        Do
            Sleep(50)
            ; $lCheck = GetMapLoading() <> 2 and GetAgentExists(-2)
            $lCheck = GetMapLoading() <> 2
        Until $lCheck Or TimerDiff($lDeadLock)>15000
    EndIf
    ; ControlSend($WinHandle, "", "", "{enter}")
    ; Sleep(Random(500,1500))
    If $lCheck = False Then
        ControlSend($WinHandle, "", "", "{enter}")
        $lDeadLock = Timerinit()
        Do
            Sleep(50)
            ; $lCheck = GetMapLoading() <> 2 and GetAgentExists(-2)
            $lCheck = GetMapLoading() <> 2
        Until $lCheck Or TimerDiff($lDeadLock)>15000
    EndIf

    ; $lCheck = False



    If $lCheck = False Then
        MsgBox(0, "Error", "lcheck")

        ProcessClose($ProcessID)
        Exit
    Else
        Sleep(Random(2500,3500))
    EndIf


EndFunc

#Region Gui stuff
;~ Description: Toggle rendering and also hide or show the gw window
Func ToggleRendering()
	$RenderingEnabled = Not $RenderingEnabled
	If $RenderingEnabled Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	EndIf
EndFunc   ;==>ToggleRendering

Func UpdateLock()
    Local $cn = GetCharname()
    If $cn Then
        Local $sFileName   = @ScriptDir & "\lock\" & $cn & ".lock"
        Local $hFilehandle = FileOpen($sFileName, $FO_OVERWRITE)
        FileWrite($hFilehandle,  @HOUR & ":" & @MIN)
        FileClose($hFilehandle)
    EndIf
EndFunc

;~ Description: Print to console with timestamp
Func Out($TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>OUT

Func _Exit()
	Local $AgentName = MemoryRead($mCharname, 'wchar[30]')
	WinSetTitle($mGWWindowHandle, '', 'Guild Wars')
	WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Exit
EndFunc
#Region Gui stuff