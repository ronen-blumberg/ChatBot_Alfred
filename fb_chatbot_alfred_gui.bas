#cmdline "alfred.res -s gui"

#ifdef __FB_LINUX__
#undef MAKELONG
#endif

#INCLUDE "window9.bi"
#INCLUDE "fb_chatbot_alfred.bas"

#IFDEF __FB_WIN32__
  	#INCLUDE "TTS.bas"
#ENDIF

CONST ALFRED_VERSION = "0.6"

LoadArrays( EXEPATH + "/database/database-encrypted.txt")

IF UBound(g_Key_Reply) < 0 THEN
  MessageBox(null, "ERROR: Could not load database. Make sure database-encrypted.txt exists in the database folder.", _
  "Chatbot Alfred", MB_OK OR MB_ICONERROR OR MB_SYSTEMMODAL)
  END
END IF

DIM SHARED AS LONG BaseWidth
BaseWidth = 800
DIM SHARED AS LONG BaseHeight
BaseHeight = 600

#DEFINE ScaleX(_V) ((((_V)*WinWid)\BaseWidth))
#DEFINE ScaleY(_V) ((((_V)*WinHei)\BaseHeight))

'linux compat
#IFNDEF BS_DEFPUSHBUTTON
  #DEFINE BS_DEFPUSHBUTTON 0
#ENDIF

ENUM GadgetID
  giFirst = 100
  giOutputEdit
  giInputEdit
  giTalkButton
  giInstruction
  giAboutButton
END ENUM
ENUM ShortCutID
  siFirst = 1000
  siDefKey
END ENUM

DIM AS HWND hSecondForm
DIM AS HWND hMainForm
DIM AS INTEGER EVENT
VAR msg = txtfile( EXEPATH + "/database/instruction.txt")

hMainForm = OpenWindow( "Chatbot Alfred v" + ALFRED_VERSION, 100, 10, 850, 600)

EditorGadget(giOutputEdit, 10, 10, 700, 340, "Alfred: " + alfredtime(), 0 ) '"hello dear one i'm here to talk with you on what ever you want", 0 )
SetGadgetFont(giOutputEdit, CINT(LoadFont( "MS Dialog", 11)))
Readonlyeditor(giOutputEdit, 1)
SetTransferTextLineEditorGadget(giOutputEdit, 1)

#IFDEF __FB_LINUX__
  	EditorGadget(giInputEdit, 10, 350, 700, 190, "", 0 )
#ELSE
  	EditorGadget(giInputEdit, 10, 350, 700, 190, "", 0 )
#ENDIF
SetGadgetFont(giInputEdit, CINT(LoadFont( "MS Dialog", 11)))
SetTransferTextLineEditorGadget(giInputEdit, 1)

ButtonGadget(giTalkButton, 720, 520, 60, 30, "Talk", BS_DEFPUSHBUTTON)
ButtonGadget(giAboutButton, 720, 490, 60, 30, "ABOUT", BS_DEFPUSHBUTTON)

SetFocus(Gadgetid(giInputEdit))                  ' focus on the editor 2
UpdateInfoXserver()                              ' for linux , so that xserver has time to update the information

AddKeyboardShortcut(hMainForm, FVIRTKEY, VK_RETURN, siDefKey)

hSecondForm = openwindow( "instructions", 100, 10, 600, 500)
editorgadget(giInstruction, 10, 10, 560, 440, msg)
SetGadgetColor(giInstruction, 50000, 0, 3)
Readonlyeditor(giInstruction, 1)

SUB speak(text AS STRING PTR)
  #IFDEF __FB_LINUX__
    SHELL( "espeak-ng -v us-mbrola-2 -s 120 " & CHR(34) & *text & CHR(34))

  #ELSE
    		TTS.VoiceByID(0)
    		TTS.Speak( *text, TRUE )
  #ENDIF
END SUB

SUB DefaultButtonPressed()
  VAR text = GetGadgetText(giInputEdit)
  IF TRIM(text) = "" THEN RETURN
  IF LEN(text) > 500 THEN text = LEFT(text, 500)
  text = lcase(text)
  dim ans as string
  ans = userQuestion(text)
  SetGadgetText(giInputEdit, "")
  VAR reply = GetGadgetText(giOutputEdit)
  SetGadgetText(giOutputEdit, reply + CHR(10) + "You: " + text + CHR(10) + "Alfred: " + ans)
  'threadcreate for TTS speak function (sub) shell command
  STATIC AS ANY PTR a
  IF a THEN
    TTS.Stop()
    THREADWAIT(a)
  END IF
  STATIC AS STRING sTemp :sTemp = ans
  a = THREADCREATE(CAST(ANY PTR, @Speak), @sTemp)
  LineScrollEditor(giInputEdit, 5)
  LineScrollEditor(giOutputEdit, 5)
END SUB

SUB size_change( WinWid AS LONG , WinHei AS LONG )
  STATIC AS LONG lastFontSize
  STATIC AS LONG hCachedFont

  	Resizegadget(giOutputEdit,ScaleX(10),ScaleY(10), ScaleX(700), ScaleY(340))
  Readonlyeditor(giOutputEdit, 1)
  	SetTransferTextLineEditorGadget(giOutputEdit, 1)

  	Resizegadget(giInputEdit,ScaleX(10), ScaleY(350), ScaleX(700), ScaleY(190))
  	SetTransferTextLineEditorGadget(giInputEdit, 1)

  DIM AS LONG newFontSize = ScaleY(11)
  IF newFontSize <> lastFontSize THEN
    hCachedFont = LoadFont( "MS Dialog", newFontSize)
    lastFontSize = newFontSize
  END IF
  	SetGadgetFont(giOutputEdit, CINT(hCachedFont))
  	SetGadgetFont(giInputEdit, CINT(hCachedFont))

  Resizegadget(giTalkButton,ScaleX(720), ScaleY(520), ScaleX(60), ScaleY(30))
  Resizegadget(giAboutButton,ScaleX(720), ScaleY(490), ScaleX(60), ScaleY(30))

  	SetFocus(Gadgetid(giInputEdit))                  ' focus on the editor 2
  	UpdateInfoXserver()                              ' for linux , so that xserver has time to update the information
END SUB

sub resize_second_form( WinWid AS LONG , WinHei AS LONG )
  STATIC AS LONG lastFontSize2, hCachedFont2
  dim as long winX, winY
  winX = WinWid: winY = WinHei

  Resizegadget(giInstruction, ScaleX(10), ScaleY(10), winX-ScaleX(40), winY-ScaleY(60))

  DIM AS LONG newFontSize2 = ScaleY(11)
  IF newFontSize2 <> lastFontSize2 THEN
    hCachedFont2 = LoadFont("MS Dialog", newFontSize2)
    lastFontSize2 = newFontSize2
  END IF
  SetGadgetFont(giInstruction, CINT(hCachedFont2))

  SetTransferTextLineEditorGadget(giInstruction, 1)
  UpdateInfoXserver()                              ' for linux , so that xserver has time to update the information
END sub

sub AboutButtonClick(hSecondForm as HWND)
	hideWindow(hSecondForm, 0)
END SUB


DO
  SELECT CASE WaitEvent()
    CASE Eventsize
      			IF EventHwnd=hMainForm THEN
        			size_change( WindowWidth(hMainForm) , WindowHeight(hMainForm) )
      			ENDIF
            if EventHwnd=hSecondForm then
              resize_second_form( WindowWidth(hSecondForm) , WindowHeight(hSecondForm) )
            END IF
    	CASE EventMenu
      IF EventNumber = siDefKey THEN DefaultButtonPressed()
    CASE EventClose
      IF EventHwnd() = hSecondForm THEN
        hidewindow(hSecondForm, 1)
      ELSE
        END
      END IF
    CASE EventGadget
      SELECT CASE EventNumber
        CASE giTalkButton
          DefaultButtonPressed()
        CASE giAboutButton
          AboutButtonClick(hSecondForm)
      END SELECT
  END SELECT
LOOP

