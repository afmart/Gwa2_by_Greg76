#Region Windows
;~ Description: Close all in-game windows.
Func CloseAllPanels()
	Return PerformAction(0x85, 0x1E)
EndFunc   ;==>CloseAllPanels

;~ Description: Toggle hero window.
Func ToggleHeroWindow()
	Return PerformAction(0x8A, 0x1E)
EndFunc   ;==>ToggleHeroWindow

;~ Description: Toggle inventory window.
Func ToggleInventory()
	Return PerformAction(0x8B, 0x1E)
EndFunc   ;==>ToggleInventory

;~ Description: Toggle all bags window.
Func ToggleAllBags()
	Return PerformAction(0xB8, 0x1E)
EndFunc   ;==>ToggleAllBags

;~ Description: Toggle world map.
Func ToggleWorldMap()
	Return PerformAction(0x8C, 0x1E)
EndFunc   ;==>ToggleWorldMap

;~ Description: Toggle options window.
Func ToggleOptions()
	Return PerformAction(0x8D, 0x1E)
EndFunc   ;==>ToggleOptions

;~ Description: Toggle quest window.
Func ToggleQuestWindow()
	Return PerformAction(0x8E, 0x1E)
EndFunc   ;==>ToggleQuestWindow

;~ Description: Toggle skills window.
Func ToggleSkillWindow()
	Return PerformAction(0x8F, 0x1E)
EndFunc   ;==>ToggleSkillWindow

;~ Description: Toggle mission map.
Func ToggleMissionMap()
	Return PerformAction(0xB6, 0x1E)
EndFunc   ;==>ToggleMissionMap

;~ Description: Toggle friends list window.
Func ToggleFriendList()
	Return PerformAction(0xB9, 0x1E)
EndFunc   ;==>ToggleFriendList

;~ Description: Toggle guild window.
Func ToggleGuildWindow()
	Return PerformAction(0xBA, 0x1E)
EndFunc   ;==>ToggleGuildWindow

;~ Description: Toggle party window.
Func TogglePartyWindow()
	Return PerformAction(0xBF, 0x1E)
EndFunc   ;==>TogglePartyWindow

;~ Description: Toggle score chart.
Func ToggleScoreChart()
	Return PerformAction(0xBD, 0x1E)
EndFunc   ;==>ToggleScoreChart

;~ Description: Toggle layout window.
Func ToggleLayoutWindow()
	Return PerformAction(0xC1, 0x1E)
EndFunc   ;==>ToggleLayoutWindow

;~ Description: Toggle minions window.
Func ToggleMinionList()
	Return PerformAction(0xC2, 0x1E)
EndFunc   ;==>ToggleMinionList

;~ Description: Toggle a hero panel.
Func ToggleHeroPanel($aHero)
	If $aHero < 4 Then
		Return PerformAction(0xDB + $aHero, 0x1E)
	ElseIf $aHero < 8 Then
		Return PerformAction(0xFE + $aHero, 0x1E)
	EndIf
EndFunc   ;==>ToggleHeroPanel

;~ Description: Toggle hero's pet panel.
Func ToggleHeroPetPanel($aHero)
	If $aHero < 4 Then
		Return PerformAction(0xDF + $aHero, 0x1E)
	ElseIf $aHero < 8 Then
		Return PerformAction(0xFA + $aHero, 0x1E)
	EndIf
EndFunc   ;==>ToggleHeroPetPanel

;~ Description: Toggle pet panel.
Func TogglePetPanel()
	Return PerformAction(0xDF, 0x1E)
EndFunc   ;==>TogglePetPanel

;~ Description: Toggle help window.
Func ToggleHelpWindow()
	Return PerformAction(0xE4, 0x1E)
EndFunc   ;==>ToggleHelpWindow
#EndRegion Windows

