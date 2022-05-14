#Region Display
;~ Description: Enable graphics rendering.
Func EnableRendering()
	MemoryWrite($mDisableRendering, 0)
EndFunc   ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func DisableRendering()
	MemoryWrite($mDisableRendering, 1)
EndFunc   ;==>DisableRendering

;~ Description: Display all names.
Func DisplayAll($aDisplay)
	DisplayAllies($aDisplay)
	DisplayEnemies($aDisplay)
EndFunc   ;==>DisplayAll

;~ Description: Display the names of allies.
Func DisplayAllies($aDisplay)
	If $aDisplay Then
		Return PerformAction(0x89, 0x1E)
	Else
		Return PerformAction(0x89, 0x20)
	EndIf
EndFunc   ;==>DisplayAllies

;~ Description: Display the names of enemies.
Func DisplayEnemies($aDisplay)
	If $aDisplay Then
		Return PerformAction(0x94, 0x1E)
	Else
		Return PerformAction(0x94, 0x20)
	EndIf
EndFunc   ;==>DisplayEnemies
#EndRegion Display
