OPtion base 1
CONST w=MM.HRES, h=MM.VRES
DIM STRING infile$,outfile$
infile$="pov.pov"
outfile$="pov.bmp"

setup
render_pov infile$, outfile$

SUB setup
CONST focal=1.0, v_h=2, v_w=2
DIM v_point(3)=(0,0,0)

DIM v_u(3)=(v_w,0,0)
DIM v_v(3)=(0,-v_h,0)

DIM px_du(3),px_dv(3) 
MATH SCALE v_u(),w,px_du()
MATH SCALE v_u(),h,px_dv()
END SUB

SUB draw i,j
  r%=255*(i/(w-1))
  g%=255*(j/(h-1))
  b%=255*(i/(w-1))*(j/(h-1))
  pixel i,j,rgb(r%,g%,b%)
END SUB


SUB render_pov infile$, outfile$
CLS
LOCAL INTEGER i,j
for i = 0 to w-1
  for j = 0 to h-1
    draw i,j  
  next j
next i


SAVE IMAGE outfile$,0,0,w,h
CLS
PRINT "written",w,"x",h,"to",outfile$
END SUB



