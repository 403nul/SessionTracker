TimerActive = 1
StayOnTop = 1
ShowTitle := 0  ; 1 = visible, 0 = hidden (off by default)
PersistentTitle := 0  ; 0 = off, 1 = on

; ------------------ INI READ ------------------

IniRead, IdleTime, timer.ini, Settings, Timeout, 10
IniRead, TimeoutEnabled, timer.ini, Settings, PauseTimeout, 1
IniRead, ColorAlert, timer.ini, Settings, ColorAlert, true
IniRead, StayOnTop, timer.ini, Settings, StayOnTop, 1
IniRead, PersistentTitle, timer.ini, Settings, PersistentTitle, 0

IniRead, Program1, timer.ini, BoundPrograms, Program1, Unbound
IniRead, Program2, timer.ini, BoundPrograms, Program2, Unbound
IniRead, Program3, timer.ini, BoundPrograms, Program3, Unbound

IniRead, Program1Title, timer.ini, BoundPrograms, Program1Title, Unbound
IniRead, Program2Title, timer.ini, BoundPrograms, Program2Title, Unbound
IniRead, Program3Title, timer.ini, BoundPrograms, Program3Title, Unbound

IniRead, LastTime, timer.ini, LastTime, Time, 00:00:00

IniRead, OnColor, timer.ini, Settings, OnColor, 686868
IniRead, OffColor, timer.ini, Settings, OffColor, aa2727

; ------------------ INITIAL WRITE ------------------

IniWrite, %IdleTime%, timer.ini, Settings, Timeout
IniWrite, %TimeoutEnabled%, timer.ini, Settings, PauseTimeout
IniWrite, %ColorAlert%, timer.ini, Settings, ColorAlert
IniWrite, %StayOnTop%, timer.ini, Settings, StayOnTop
IniWrite, %PersistentTitle%, timer.ini, Settings, PersistentTitle

IniWrite, %Program1%, timer.ini, BoundPrograms, Program1
IniWrite, %Program2%, timer.ini, BoundPrograms, Program2
IniWrite, %Program3%, timer.ini, BoundPrograms, Program3

IniWrite, %Program1Title%, timer.ini, BoundPrograms, Program1Title
IniWrite, %Program2Title%, timer.ini, BoundPrograms, Program2Title
IniWrite, %Program3Title%, timer.ini, BoundPrograms, Program3Title

IniWrite, %LastTime%, timer.ini, LastTime, Time

IniWrite, %OnColor%, timer.ini, Settings, OnColor
IniWrite, %OffColor%, timer.ini, Settings, OffColor

GOTO START

; ---------------- START ----------------

START:
SetBatchLines, -1

Gui +LastFound
if (StayOnTop = 1)
    Gui +AlwaysOnTop

Gui, Color, %OnColor%

; Timer numbers
Gui, Font, S20 Bold, Consolas
Gui, Add, Text, x0 y0 w200 h40 Center +0x200 vMyText, 00:00:00

; Program title underneath (smaller & compact)
Gui, Font, S10, Consolas
Gui, Add, Text, x0 y38 w200 h14 Center vProgramText, 

SetFormat, Float, 02.0
h := m := s := "00"
LastFocusedProgram := ""

SetTimer, Update, 1000
Gosub, Update

Gui, -MinimizeBox -MaximizeBox

; Set initial window height based on ShowTitle
InitialHeight := ShowTitle ? 65 : 40
Gui, Show, w200 h%InitialHeight%, Session Tracker
WinGet, TimerHwnd, ID, Session Tracker

; ---------------- MENU SETUP ----------------

progmen1 = Program 1: %Program1Title%
if (Program1Title = "" || Program1Title = "ERROR")
    progmen1 = Program 1: %Program1%

progmen2 = Program 2: %Program2Title%
if (Program2Title = "" || Program2Title = "ERROR")
    progmen2 = Program 2: %Program2%

progmen3 = Program 3: %Program3Title%
if (Program3Title = "" || Program3Title = "ERROR")
    progmen3 = Program 3: %Program3%

Menu, MyMenu, Add, Resume Previous Time, Prev
Menu, MyMenu, Add
Menu, MyMenu, Add, %progmen1%, SetProgram1
Menu, MyMenu, Add, %progmen2%, SetProgram2
Menu, MyMenu, Add, %progmen3%, SetProgram3
Menu, MyMenu, Add
Menu, MyMenu, Add, Pause Timeout, ToggleTimeout
Menu, MyMenu, Add, Color Alert, ChangeColor
Menu, MyMenu, Add, Stay On Top, ToggleStayOnTop
Menu, MyMenu, Add, Toggle Title, ToggleTitle
Menu, MyMenu, Add, Toggle Persistent Title, TogglePersistentTitle
Menu, MyMenu, UnCheck, Toggle Title  ; off by default
Menu, MyMenu, % PersistentTitle ? "Check" : "UnCheck", Toggle Persistent Title

if (ColorAlert = "true")
    Menu, MyMenu, Check, Color Alert
if (StayOnTop = 1)
    Menu, MyMenu, Check, Stay On Top
if (TimeoutEnabled = 1)
    Menu, MyMenu, UnCheck, Pause Timeout
else
    Menu, MyMenu, Check, Pause Timeout
RETURN

; ---------------- HOTKEYS ----------------

^m::
Gosub, PopMenu
Return

GuiClose:
IniWrite, %H%:%M%:%S%, timer.ini, LastTime, Time
ExitApp

; ---------------- TOGGLE FUNCTIONS ----------------

ToggleStayOnTop:
if (StayOnTop = 1){
    StayOnTop = 0
    WinSet, AlwaysOnTop, Off, ahk_id %TimerHwnd%
    Menu, MyMenu, UnCheck, Stay On Top
}else{
    StayOnTop = 1
    WinSet, AlwaysOnTop, On, ahk_id %TimerHwnd%
    Menu, MyMenu, Check, Stay On Top
}
IniWrite, %StayOnTop%, timer.ini, Settings, StayOnTop
RETURN

ToggleTimeout:
if (TimeoutEnabled = 1){
    TimeoutEnabled = 0
    Menu, MyMenu, Check, Pause Timeout
}else{
    TimeoutEnabled = 1
    Menu, MyMenu, UnCheck, Pause Timeout
}
IniWrite, %TimeoutEnabled%, timer.ini, Settings, PauseTimeout
RETURN

ToggleTitle:
if (ShowTitle){
    ShowTitle := 0
    GuiControl,, ProgramText,
    Menu, MyMenu, UnCheck, Toggle Title
}else{
    ShowTitle := 1
    GuiControl,, ProgramText, %LastFocusedProgram%
    Menu, MyMenu, Check, Toggle Title
}
RETURN

TogglePersistentTitle:
PersistentTitle := !PersistentTitle
Menu, MyMenu, % PersistentTitle ? "Check" : "UnCheck", Toggle Persistent Title
IniWrite, %PersistentTitle%, timer.ini, Settings, PersistentTitle
RETURN

ChangeColor:
if (ColorAlert = "true"){
    Menu, MyMenu, UnCheck, Color Alert
    ColorAlert = false
    IniWrite, false, timer.ini, Settings, ColorAlert
    Gui, Color, %OnColor%
}else{
    Menu, MyMenu, Check, Color Alert
    ColorAlert = true
    IniWrite, true, timer.ini, Settings, ColorAlert
    Gui, Color, %OffColor%
}
RETURN

; ---------------- MENU REFRESH ----------------

PopMenu:

if ((Program1 = "ERROR") or (Program1 = "")){
    progmen1b = Program 1: (Unbound)
}else{
    if (Program1Title != "" && Program1Title != "ERROR")
        progmen1b = Program 1: %Program1Title%
    else
        progmen1b = Program 1: %Program1%
}

if ((Program2 = "ERROR") or (Program2 = "")){
    progmen2b = Program 2: (Unbound)
}else{
    if (Program2Title != "" && Program2Title != "ERROR")
        progmen2b = Program 2: %Program2Title%
    else
        progmen2b = Program 2: %Program2%
}

if ((Program3 = "ERROR") or (Program3 = "")){
    progmen3b = Program 3: (Unbound)
}else{
    if (Program3Title != "" && Program3Title != "ERROR")
        progmen3b = Program 3: %Program3Title%
    else
        progmen3b = Program 3: %Program3%
}

if (progmen1 != progmen1b){
    Menu, MyMenu, Rename, %progmen1%, %progmen1b%
    progmen1 = %progmen1b%
}

if (progmen2 != progmen2b){
    Menu, MyMenu, Rename, %progmen2%, %progmen2b%
    progmen2 = %progmen2b%
}

if (progmen3 != progmen3b){
    Menu, MyMenu, Rename, %progmen3%, %progmen3b%
    progmen3 = %progmen3b%
}

Menu, MyMenu, Show
RETURN

Prev:
StringSplit, LastTimeA, LastTime, `:
H = %LastTimeA1%
M = %LastTimeA2%
S = %LastTimeA3%
GuiControl,, MyText, %H%:%M%:%S%
SetTimer, Update, 1000
RETURN

; ---------------- PROGRAM SET ----------------

SetProgram:
Gui, Font, S10, Arial
GuiControl, Font, MyText
GuiControl,, MyText, Awaiting program...
while (class = "AutoHotkeyGUI"){
}
Gui, Font, S20 Bold, Consolas
GuiControl, Font, MyText
GuiControl,, MyText, %H%:%M%:%S%
RETURN

SetProgram1:
Gosub, SetProgram
Program1 = %class%
Program1Title = %title%
IniWrite, %class%, timer.ini, BoundPrograms, Program1
IniWrite, %title%, timer.ini, BoundPrograms, Program1Title
RETURN

SetProgram2:
Gosub, SetProgram
Program2 = %class%
Program2Title = %title%
IniWrite, %class%, timer.ini, BoundPrograms, Program2
IniWrite, %title%, timer.ini, BoundPrograms, Program2Title
RETURN

SetProgram3:
Gosub, SetProgram
Program3 = %class%
Program3Title = %title%
IniWrite, %class%, timer.ini, BoundPrograms, Program3
IniWrite, %title%, timer.ini, BoundPrograms, Program3Title
RETURN

; ---------------- TIMER UPDATE ----------------

Update:

if (H > 99){
    MsgBox, Wow, go to sleep
    IniWrite, 00:00:00, timer.ini, LastTime, Time
    ExitApp
}

ID := DllCall("GetParent", "UInt", WinExist("A"))
ID := !ID ? WinExist("A") : ID
WinGetClass, class, ahk_id %ID%
WinGetTitle, title, ahk_id %ID%

ProgramActive := ((class = Program1) or (class = Program2) or (class = Program3))

if (!PersistentTitle and ProgramActive){
    LastFocusedProgram := title ? title : class
}

GuiHeight := ShowTitle ? 65 : 40

if (TimerActive=0) and (TimeoutEnabled=1) and ((A_TimeIdle > IdleTime*1000) or (ProgramActive = 0))
    RETURN
else{

    if (TimeoutEnabled=1) and ((A_TimeIdle > IdleTime*1000) or (ProgramActive = 0)){
        TimerActive = 0
        if (ColorAlert = "true")
            Gui, Color, %OffColor%
        GuiControl,, MyText, %H%:%M%:%S%
        if (ShowTitle)
            GuiControl,, ProgramText, %LastFocusedProgram%
        else
            GuiControl,, ProgramText,
        Gui, Show, w200 h%GuiHeight% NA, Work Stopped
        RETURN
    }

    TimerActive = 1

    if (ColorAlert = "true")
        Gui, Color, %OnColor%

    Gui, Show, w200 h%GuiHeight% NA, Work In Progress

    if (S >= 59){
        if (M >= 59){
            M = 00
            H += 1.0
        }else{
            M += 1.0
        }
        S = 00
        GuiControl,, MyText, %H%:%M%:%S%
        if (ShowTitle)
            GuiControl,, ProgramText, %LastFocusedProgram%
        else
            GuiControl,, ProgramText,
        RETURN
    }

    S += 1.0
    GuiControl,, MyText, %H%:%M%:%S%
    if (ShowTitle)
        GuiControl,, ProgramText, %LastFocusedProgram%
    else
        GuiControl,, ProgramText,

    Gui, Show, w200 h%GuiHeight% NA
    RETURN
}
RETURN