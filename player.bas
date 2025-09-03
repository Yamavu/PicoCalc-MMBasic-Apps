' PLAYER.BAS - MMBasic Script to play MP3s on PicoCalc
' Copyright (C) 2025 Yamavu
' 
' This program is free software: you can redistribute it and/or modify
' it under the terms of the GNU General Public License as published by
' the Free Software Foundation, either version 3 of the License, or
' (at your option) any later version.
' 
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.
' 
' You should have received a copy of the GNU General Public License
' along with this program.  If not, see <https://www.gnu.org/licenses/>.

OPTION DEFAULT NONE
OPTION EXPLICIT

DIM INTEGER vol = 50  
DIM INTEGER paused
DIM INTEGER choice = 0
DIM STRING title$

DIM music$ = "B:/music/"
'DIM folder$ = "B:/music/runes/"

CHOOSE_F

SUB CHOOSE_F
LOCAL STRING n$
LOCAL INTEGER y
LOCAL STRING k$ ' key
cho:
CLS
n$=dir$(music$+"*",DIR)
y=0
'chdir music$
DO WHILE n$<>"" 
  TEXT 30,20+y*16,n$,"LB"
  y=y+1
  n$=dir$()
LOOP
DO
BOX 0,0,30,320,1,1,1 ' clear 
TEXT 28,20+choice*16,">","RB"
next_: k$=INKEY$
IF k$ = "" THEN GOTO next_
SELECT CASE ASC(k$)
  CASE 128
    choice = MAX(0,choice-1)
  CASE 129
    choice = MIN(y-1,choice+1)
  CASE 27
    EXIT DO
  CASE 13
    play_f chosen$()
    GOTO cho
END SELECT
LOOP
CLS
chdir "/"
END SUB


FUNCTION chosen$()
LOCAL INTEGER i=0
LOCAL STRING n$=dir$(music$+"*",DIR)
DO
IF i=choice THEN EXIT DO
i=i+1
n$=dir$()
LOOP
chosen$=n$
END FUNCTION

SUB play_f name$
LOCAL STRING k$ ' key
LOCAL folder$=music$+name$+"/"
CLS
UI_ART folder$
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
END SUB

SUB UI_VOL
  BOX 60,20,200,20,1,1,1 ' clear
  BOX 60,20,200,20
  BOX 60,20,2*vol,20,1,,rgb(green)
END SUB

SUB UI_ART n$
LOCAL STRING im$=n$+"album.bmp"
IF MM.INFO(EXISTS FILE im$)=1 THEN
LOAD IMAGE im$, 70,50
ELSE
BOX 70,50 , 180,180,,,rgb(grey)
TEXT 110,110,"?","CM",,2,,rgb(grey)
ENDIF
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