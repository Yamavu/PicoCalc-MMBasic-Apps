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
CLS

SUB LOAD_CSV fname$
' read numeric csv from fname$
' results in global variable table()
' table size is set on input
LOCAL res = 0
ON ERROR SKIP
ERASE table(),rows,cols
ON ERROR ABORT

LOCAL fnr = 1
LOCAL maxcols=16,maxrows=255
OPEN fname$ FOR INPUT AS #fnr
LOCAL dat(maxrows,maxcols)
LOCAL cline$,cfld$
LOCAL r=1,c=1
DO WHILE NOT EOF(#fnr)
  LINE INPUT #fnr,cline$
  IF LEN(cline$)=0 THEN EXIT DO
  c=1
  DO WHILE c<maxcols
    cfld$=FIELD$(cline$,c,",")
    'print cfld$
    IF cfld$="" THEN
     EXIT DO
    ENDIF
    dat(r,c)=VAL(cfld$)
    'print field$; VAL(cfld$)
    INC c
  LOOP
  INC r
LOOP
CLOSE #fnr
DIM cols=c-1,rows=r-1
IF rows<1 OR cols<1 THEN 
  PRINT "no data found in "+fname$
  END
ENDIF
DIM FLOAT table(rows,cols)
FOR r = 1 TO rows
  FOR c = 1 TO cols
    table(r,c)=dat(r,c)
  NEXT c
NEXT r
MATH M_PRINT table()
print rows,cols
'print BOUND(table(),1),BOUND(table(),2)

END SUB

SUB SAVE_CSV fname$
LOCAL fnr=1
LOCAL r=1,c=1
print fname$,"writing"
OPEN fname$ FOR OUTPUT AS #fnr
FOR r = 1 TO rows
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
DIM scene=1
DIM curr(2)=(1,1)
LOAD_CSV fname$
DIM wcol(cols)
ARRAY SET 8,wcol()
LOCAL fw=MM.INFO(FONTWIDTH)
LOCAL fh=MM.INFO(FONTHEIGHT)
DIM cw(cols)
DIM ch=(fh+2)
DIM gui_ch=1
MATH SCALE wcol(),fw,cw()
CLS
DO WHILE scene=1
  IF gui_ch=1 THEN 
    DTABLE 
    gui_ch=0
  ENDIF
  TCTRL
  PAUSE 50
LOOP
END SUB

SUB CCTRL 'cell control
INPUT ,nr
' todo: lil window next to cell
table(curr(1),curr(2))=nr
gui_ch=1
END SUB

SUB TCTRL 'table control
LOCAL k$=INKEY$
IF k$="" THEN 
  PAUSE 50
  EXIT SUB
ENDIF
SELECT CASE ASC(k$)
CASE 27  'ESC
  scene=0
  EXIT SUB
CASE 128 'up
  curr(1)=MAX(curr(1)-1,1)
CASE 129 'down
  curr(1)=MIN(curr(1)+1,rows)
CASE 130 'left
  curr(2)=MAX(curr(2)-1,1)
CASE 131 'right
  curr(2)=MIN(curr(2)+1,cols)
CASE ASC("S")
  SAVE_CSV fname$
CASE 13  'enter
  CCTRL
END SELECT
gui_ch=1
END SUB


SUB DTABLE
LOCAL fg=MM.INFO(FCOLOR)
LOCAL bg=MM.INFO(BCOLOR)
LOCAL fg2=RGB(128,0,128)
LOCAL ft=MM.INFO(FONT)
LOCAL offx=10, offy=10
LOCAL fw=MM.INFO(FONTWIDTH)
LOCAL fh=MM.INFO(FONTHEIGHT)
LOCAL cx=offx,cy=offy
LOCAL s$,l$
LOCAL llw=fw*3

INC cx,llw
for j=1 to cols
  l$=CHR$(j-1+ASC("A"))
  BOX cx,cy,cw(j)+1,ch,1,fg,bg
  TEXT cx+cw(j)/2,cy+1,l$,"CT",ft,1,fg,bg
  INC cx,cw(j)
NEXT j
INC cy,ch
for i=1 to rows
  cx=offx
  '"cy=offy+ch
  l$=STR$(i)
  BOX cx,cy,llw+1,ch,1,fg,bg
  TEXT cx+llw/2,cy+1,l$,"CT",ft,1,fg,bg
  INC cx,llw
  for j=1 to cols
    s$=str$(table(i,j))
    IF curr(1)=i AND curr(2)=j THEN
      BOX cx,cy,cw(j),ch,1,fg,fg
      TEXT cx+cw(j),cy+1,s$,"RT",ft,1,bg,fg
    ELSE
      BOX cx,cy,cw(j),ch,1,fg,bg
      TEXT cx+cw(j)-1,cy+1,s$,"RT",ft,1,fg,bg
    ENDIF
    INC cx,cw(j)
  NEXT j
  INC cy,ch
NEXT i

cx=offx+llw
LOCAL col(rows)
for j=1 to cols
  'l$=CHR$(i-1+ASC("A"))
  MATH SLICE table(),,j,col()
  l$=STR$(MATH(SUM col()))
  BOX cx,cy,cw(j)+1,ch,1,fg,bg
  TEXT cx+cw(j),cy+1,l$,"RT",ft,1,fg,bg
  INC cx,cw(j)
NEXT j
INC cy,ch

LOCAL wtbl=MATH(SUM wcol())*fw
BOX offx,cy,wtbl+llw,ch,1,fg,bg
TEXT offx+1,cy+1,"> ","LT",ft,1,fg,bg
END SUB
