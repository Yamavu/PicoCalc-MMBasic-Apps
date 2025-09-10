' Write a 320x320 BMP file on PicoMite
OPTION BASE 0

SUB WriteBMPHeader fnr,width,height
  CONST size = width * height * 3
  ' BMP signature
  PRINT #1, "BM" ;

  ' File size (DWORD)
  PUTDWORD fnr, 54 + size

  ' Reserved (2x WORD)
  PUTWORD fnr, 0
  PUTWORD fnr, 0

  ' Pixel data offset (54 bytes)
  PUTDWORD fnr, 54

  ' BITMAPINFOHEADER (40 bytes)
  PUTDWORD fnr, 40     ' header size
  PUTDWORD fnr, width  ' width
  PUTDWORD fnr, height ' height
  PUTWORD  fnr, 1      ' planes = 1
  PUTWORD  fnr, 24     ' bits per pixel = 24
  PUTDWORD fnr, 0      ' compression = BI_RGB
  PUTDWORD fnr, size   ' image size
  PUTDWORD fnr, 0      ' XPelsPerMeter
  PUTDWORD fnr, 0      ' YPelsPerMeter
  PUTDWORD fnr, 0      ' colors used
  PUTDWORD fnr, 0      ' important colors
END SUB

SUB AppendPixel fnr, r, g, b
  ' BMP expects BGR order
  PRINT #1, CHR$(b) + CHR$(g) + CHR$(r) ;
END SUB

' Helpers to write integers in little endian
SUB PUTWORD fnr, val
  LOCAL a$
  a$ = CHR$(val AND &HFF) + CHR$((val >> 8) AND &HFF)
  PRINT #1, a$ ;
END SUB

SUB PUTDWORD fnr, val
  LOCAL a$
  a$ = CHR$(val AND &HFF) + CHR$((val >> 8) AND &HFF) + CHR$((val >> 16) AND &HFF) + CHR$((val >> 24) AND &HFF)
  PRINT #1, a$ ;
END SUB

SUB writeBMP filename$, width, height
OPEN filename$ FOR OUTPUT AS #1
WriteBMPHeader 1, width, height
'DIM r(width-1), g(width-1), b(width-1)
FOR y% = height-1 TO 0 STEP -1
  FOR x% = 0 TO width-1
      rx = x% MOD 256
      gx = y% MOD 256
      bx = (x%+y%) MOD 256
      PIXEL x%, y%, rgb(rx,gx,bx)
      AppendPixel fnr, rx, gx, bx
  NEXT x%
  'AppendScanline 1, width, r(), g(), b()
NEXT y%
'Write pixels bottom-up
'FOR y = height-1 TO 0 STEP -1
'    FOR x = 0 TO width-1
'        r = x MOD 256
'        g = y MOD 256
'        b = (x+y) MOD 256
'        AppendPixel(1, r, g, b)
'    NEXT x
'NEXT y
FLUSH #1
CLOSE #1
PRINT "BMP written: ", filename$ 
END SUB

CLS
filename$ = "test.bmp"
writeBMP filename$, 320, 320
