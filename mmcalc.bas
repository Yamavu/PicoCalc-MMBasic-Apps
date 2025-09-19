' MMCALC.BAS - MMBasic Script to edit CSVs on PicoCalc
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
' along with this program.  If not, see ttps://www.gnu.org/licenses/>.

MAIN "B:\try.csv"

SUB LOAD_CSV fname$
' read numeric csv from fname$
' results in global variable table()
' table size is set on input
LOCAL fnr = 1
LOCAL maxcols=16,maxrows=255
OPEN fname$ FOR INPUT AS #fnr
LOCAL dat(maxrows,maxcols)
LOCAL cline$,cfld$
LOCAL r=1,c=1
DIM lins=0,cols=0
DO WHILE NOT EOF(#fnr)
  LINE INPUT #fnr,cline$
  IF LEN(cline$)=0 THEN EXIT DO
  c=1
  DO WHILE c<maxcols
    cfld$=FIELD$(cline$,c,",")
    IF cfld$="" THEN
     EXIT DO
    ENDIF
    dat(r,c)=VAL(cfld$)
    INC c
  LOOP
  INC r
LOOP
CLOSE #fnr
cols=r-1
lins=c-1
IF lins<1 OR cols<1 THEN 
  PRINT "no data found in "+fname$
  END
ENDIF
DIM FLOAT table(lins,cols)
FOR r = 1 TO lins
  FOR c = 1 TO cols
    table(r,c)=dat(c,r) ' transposing for reasons?
  NEXT c
NEXT r
'MATH M_PRINT table()
END SUB

SUB SAVE_CSV fname$
LOCAL fnr = 1
LOCAL r=1,c=1
print fname$,"writing"
OPEN fname$ FOR OUTPUT AS #fnr
FOR r = 1 TO lins
  FOR c = 1 TO cols
    PRINT #fnr,table(r,c),",",
  NEXT c
  PRINT #fnr, ""
NEXT r
CLOSE #fnr
print fname$,"written"
END SUB

SUB MAIN fname$
OPTION BASE 1

DIM fg=MM.INFO(FCOLOR)
DIM bg=MM.INFO(BCOLOR)
DIM ft=MM.INFO(FONT)
DIM scene=1
DIM active(2)
ARRAY SET 1,active()
LOAD_CSV fname$
lins=BOUND(table(),2)
cols=BOUND(table(),1)
DIM wcol(cols)
ARRAY SET 8,wcol()
fw=MM.INFO(FONTWIDTH)
fh=MM.INFO(FONTHEIGHT)
DIM cw(cols)
DIM ch=(fh+2)
DIM gui_ch=1
MATH SCALE wcol(),fw,cw()
CLS
DO WHILE scene=1
  IF gui_ch=1 THEN 
    DTABLE 10,10
    gui_ch=0
  ENDIF
  TCTRL
LOOP
'SAVE_CSV fname$
END SUB

SUB CCTRL
LOCAL x=active(1), y=active(2)
INPUT ,nr
table(x,y)=nr
gui_ch=1
END SUB

SUB TCTRL
LOCAL k$=INKEY$
IF k$<>"" THEN
SELECT CASE ASC(k$)
CASE 27
  CLS
  scene=0
CASE 128 'up
  active(2)=MAX(active(2)-1,1)
CASE 129 'down
  active(2)=MIN(active(2)+1,lins)
CASE 130 'left
  active(1)=MAX(active(1)-1,1)
CASE 131 'right
  active(1)=MIN(active(1)+1,cols)
CASE 13  'enter
  CCTRL
END SELECT
gui_ch=1
ENDIF
PAUSE 20
END SUB


SUB DTABLE offx, offy
LOCAL cx=offx
LOCAL cy=offy+ch
LOCAL s$
LOCAL llw=fw*3
for j=1 to lins
l$=STR$(j)
BOX cx,cy,llw+1,ch,1,fg,bg
TEXT cx+llw/2,cy+1,l$,"CT",ft,1,fg,bg
INC cy,ch
NEXT j

cx=offx+llw
cy=offy
for i=1 to cols
l$=CHR$(i-1+ASC("A"))
BOX cx,cy,cw(i)+1,ch,1,fg,bg
TEXT cx+cw(i)/2,cy+1,l$,"CT",ft,1,fg,bg
INC cx,cw(i)
NEXT i

cx=offx+llw
for i=1 to cols
cy=offy+ch
for j=1 to lins
s$=str$(table(i,j))
IF active(1)=i AND active(2)=j THEN
  BOX cx,cy,cw(i),ch,1,fg,fg
  TEXT cx+cw(i),cy+1,s$,"RT",ft,1,bg,fg
ELSE
  BOX cx,cy,cw(i),ch,1,fg,bg
  TEXT cx+cw(i)-1,cy+1,s$,"RT",ft,1,fg,bg
ENDIF
INC cy,ch
NEXT j
INC cx,cw(i)
NEXT i
'END SUB

cx=offx+llw
LOCAL col(lins)
for i=1 to cols
'l$=CHR$(i-1+ASC("A"))
MATH SLICE table(),i ,,col()
l$=STR$(MATH(SUM col()))
BOX cx,cy,cw(i)+1,ch,1,fg,bg
TEXT cx+cw(i),cy+1,l$,"RT",ft,1,fg,bg
INC cx,cw(i)
NEXT i
INC cy,ch

LOCAL wtbl=MATH(SUM wcol())*fw
BOX offx,cy,wtbl+llw,ch,1,fg,bg
TEXT offx+1,cy+1,"> ","LT",ft,1,fg,bg

END SUB