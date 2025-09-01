OPTION DEFAULT NONE
OPTION EXPLICIT

DIM INTEGER vol = 50  
DIM INTEGER paused
DIM STRING k$
DIM STRING title$

CONST folder$ = "B:/music/runes/"

CLS
TEXT 160,13,"Folder:"+folder$,"CB"
UI_HELP
UI_VOL
PLAY MP3 folder$
PLAY VOLUME vol,vol
paused = 0
title$=MM.INFO(TRACK)
UI_TITLE
DO
k$ = INKEY$
IF k$ <> "" THEN
  SELECT CASE ASC(k$)
    CASE 128  ' up
      vol = MIN(vol + 5, 100)
      PLAY VOLUME vol,vol
      UI_VOL
    CASE 129  ' down
      vol = MAX(vol - 5, 0)
      PLAY VOLUME vol,vol
      UI_VOL
    CASE 130  ' left 
      PLAY PREVIOUS
      paused = 0
    CASE 131  ' right
      PLAY NEXT
      paused = 0
    CASE 13   ' Enter
      IF paused = 0 THEN
        PLAY PAUSE
        paused = 1
        PRINT "Paused"
      ELSE
        PLAY RESUME
        paused = 0
        PRINT "Playing"
      ENDIF
    CASE 27   ' Esc
      PLAY STOP
      EXIT DO
  END SELECT
ENDIF
IF MM.INFO(TRACK)<>title$ THEN
  title$=MM.INFO(TRACK)
  UI_TITLE
ENDIF
PAUSE 100
LOOP
CLS

SUB UI_VOL
  BOX 60,20,200,20,1,1,1 ' clear
  BOX 60,20,200,20
  BOX 60,20,2*vol,20,1,,rgb(green)
END SUB

SUB UI_TITLE
  BOX 0,150,320,20,1,1,1 ' clear
  TEXT 300,160,title$,"RM"
END SUB

SUB UI_HELP
line 0,300,319,300,1,rgb(magenta)
local helps$="enter "+chr$(161)+"/"
helps$=helps$+chr$(160)+" | "
helps$=helps$+chr$(130)+" next | "
helps$=helps$+chr$(131)+" prev"
text 6,316,helps$,"LB",1,1
END SUB