#include-once
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Outfile=..\Exe\Tools_Testing.a3x
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /sf /tl
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <AVIConstants.au3>
#include <GUIListBox.au3>
#include <GuiListView.au3>
#include <GuiComboBox.au3>
#include <ScrollBarsConstants.au3>
#include <Array.au3>
#Include <WinAPIEx.au3>
#include <GuiEdit.au3>
#include <WinAPIFiles.au3>
#include <GuiSlider.au3>
#include <ColorConstants.au3>
#include <WinAPITheme.au3> ; <<<<<<<<<<<<<<<<<<
#include <Array.au3>
#include "_Files.au3"
#include <WinAPIDiag.au3>

Global Const $doLoadLoggedChars = True
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)

#region Variables Leader
Opt("ExpandVarStrings", 1)
Global $sClipString
Global $GUI_HOLDER = False
Global $boolRun = True
Global $NeedToChangeMap = False
Global $OldGuiText
Global $LastDialog = 0
#endregion Variables Leader

#Region Declarations
Global Const $Version = "1.0"
Global $charName  = ""
Global $ProcessID = ""
Global $Status	= ""
Global $cmdmode   = false
Global $Button
Global $timer = TimerInit()
Global $AttrQuest1 = False ;; Lost Treasure - Do NOT touch
Global $statPlatinum = 0
Global $statExperience = 0
Global $statTitlePoints = 0

If $CmdLine[0] = 0 Then
Else
    $cmdmode = true
    If 1 > UBound($CmdLine)-1 Then exit; element is out of the array bounds
    If 2 > UBound($CmdLine)-1 Then exit;
    $charName  = $CmdLine[1]
    $ProcessID = $CmdLine[2]
    LOGIN($charName, $ProcessID)
EndIf

Global $BotRunning = False
Global $BotInitialized = False
Global $HideWindow = False
Global Const $BotTitle = "Bot for test"
;TIME
Global $TotalSeconds = 0
Global $Seconds = 0
Global $Minutes = 0
Global $Hours = 0
Global $HWND
#EndRegion Declaration

Global $2mGWProcHandle
Global $2mGWWindowHandle

#Region ### START Koda GUI section ### Form=
$MainGui = GUICreate($BotTitle, 336, 285, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
GUISetBkColor(0x005680)
$Group1 = GUICtrlCreateGroup("Select Your Character", 8, 8, 313, 265)
Global $GUINameCombo
If $doLoadLoggedChars Then
	$GUINameCombo = GUICtrlCreateCombo($charName, 24, 32, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetLoggedCharNames())
Else
	$GUINameCombo = GUICtrlCreateInput("Character name", 24, 32, 145, 25)
EndIf
$GUIUpdateButton = GUICtrlCreateButton("Refresh", 176, 34, 51, 17)
GUICtrlSetOnEvent($GUIUpdateButton, "GuiButtonHandler")
$GUIStartButton = GUICtrlCreateButton("Start", 24, 72, 75, 25)
GUICtrlSetOnEvent($GUIStartButton, "GuiButtonHandler")
$gOnTopCheckbox = GUICtrlCreateCheckbox("On Top", 232, 31, 81, 24)
GUICtrlSetState(-1, $GUI_CHECKED)
$GUIActionsEdit = GUICtrlCreateEdit("", 16, 104, 297, 161)
GUICtrlSetData(-1, "Edit1")
GUICtrlSetData(-1, "")
GUICtrlSetColor(-1, 0x00FF00)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Func GuiButtonHandler()
    Switch @GUI_CtrlId
        Case $GUIStartButton
			If $BotRunning Then
        If GUICtrlRead($GUIStartButton) == "Paused" Then
          GuiCtrlSetData($GUIStartButton, "Pause")
          Return ;Cancels existing pause -- for test purposes only
        EndIf
				GUICtrlSetData($GUIStartButton, "Will pause after this run")
				GUICtrlSetState($GUIStartButton, $GUI_Disable)
				$BotRunning = False
			ElseIf $BotInitialized Then
				GUICtrlSetData($GUIStartButton, "Pause")
				$BotRunning = True
			Else
				;Out("Initializing")
				Local $charName = GUICtrlRead($GUINameCombo)
				If $charName=="" Then
					If Initialize(ProcessExists("gw.exe"), True, True, True) = 0 Then
           MsgBox(0, "Error", "Guild Wars is not running.")
						_Exit()
					EndIf
                ElseIf $ProcessID and $cmdMode Then
                    $proc_id_int = Number($ProcessID, 2)
                    ;Out("Initializing in cmd mode via pid " & $proc_id_int)
                    If Initialize($proc_id_int, True, True, True) = 0 Then
                        MsgBox(0, "Error", "Could not Find a ProcessID or somewhat '"&$proc_id_int&"'  "&VarGetType($proc_id_int)&"'")
                        _Exit()
                        If ProcessExists($proc_id_int) Then
                            ProcessClose($proc_id_int)
                        EndIf
                        Exit
                    EndIf
                    SetPlayerStatus(0)
				Else
					If Initialize($CharName, True, True, True) = 0 Then
						MsgBox(0, "Error", "Could not Find a Guild Wars client with a Character named '"&$CharName&"'")
						_Exit()
					EndIf
				EndIf
				EnsureEnglish(True)
				GUICtrlSetData($GUIStartButton, "Pause")
				GUICtrlSetState($GUINameCombo, $GUI_Disable)
				WinSetTitle($MainGui, "", GetCharname() & " - Bot for test")
				$BotRunning = True
				$BotInitialized = True
			EndIf

		Case $GUIUpdateButton
			;Out("Initializing")
			GUICtrlSetData($GUINameCombo, "")
			GUICtrlSetData($GUINameCombo, GetLoggedCharNames())

		Case $gOnTopCheckbox
			If GetChecked($gOnTopCheckbox) Then
				WinSetOnTop($BotTitle, "", 1)
			Else
				WinSetOnTop($BotTitle, "", 0)
			EndIf

		Case $GUI_Event_Close
            ;If Not $Rendering Then ToggleRendering()
		Exit
    EndSwitch
EndFunc


If $cmdmode Then
    GUICtrlSendMsg($Button, $BM_CLICK, 0, 0)
    ToggleRendering()
Else

EndIf

While Not $BotRunning
	Sleep(100)
WEnd

Func GetChecked($GUICtrl)
	If BitAND(GUICtrlRead($GUICtrl), $GUI_CHECKED) = $GUI_CHECKED then
		Return  true;$GUI_Checked
	Else
		Return false;$GUI_UNCHECKED
	EndIf
EndFunc

Func Main()

EndFunc

While True
    If $BotRunning = True Then
	   Main()
    EndIf
WEnd

Func Out($TEXT) ;No Time Stamp
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GUIActionsEdit)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GUIActionsEdit, StringRight(_GUICtrlEdit_GetText($GUIActionsEdit), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GUIActionsEdit, @CRLF & $TEXT)
	_GUICtrlEdit_Scroll($GUIActionsEdit, 1)
EndFunc   ;==>OUT

Func _Exit()
	Exit
EndFunc