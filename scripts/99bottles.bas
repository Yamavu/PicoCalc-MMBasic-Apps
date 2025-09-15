
T$=" of beer"
T0$=" bottles"
T1$=" on the wall"
T2$="take one down, pass it around"
T3$="go to the store and buy some more"

FOR btls% = 99 TO 1 STEP -1
  CLS
  PRINTB btls%
  PRINT T2$
  PAUSE 50
NEXT btls%
PRINTB 0
PRINT T3$
PRINT "99"+T0$+T$+T1$

SUB PRINTB btls%
LOCAL msg$
  IF btls% = 0 THEN
    msg$="no more bottles"
  ELSE IF btls% = 1 THEN 
    msg$="one last bottle"
  ELSE
    msg$=str$(btls%)+" bottles"
  ENDIF
  msg$=msg$+T$
  PRINT msg$+T1$
  PRINT msg$
END SUB
