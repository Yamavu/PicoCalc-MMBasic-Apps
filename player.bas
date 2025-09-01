

option escape
dim mp3file$="runes/01.mp3"
dim playing=1
dim music_dir$="b:/music/"

col1=RGB(white)
col2=RGB(grey)
bg=RGB(black)

play_dir("runes")

sub play_dir d$
local pdir$=music_dir$+d$
local ex=MM.info(exists dir pdir$)
if ex = -1 then
print "directory not found"
endif
ui
chdir music_dir$+d$
play_album "."
cls
chdir "\"
end sub

function find_mp3(d$)
local n_mp3 = 0
local name_mp3$
local found
found=mm.info(exists file d$+"/01.mp3")
if found=0 then goto not_found 
do
n_mp3=n_mp3+1
if n_mp3<10 then 
name_mp3$=d$+"/0"+str$(n_mp3)+".mp3"
else
name_mp3$=d$+"/"+str$(n_mp3)+".mp3"
endif
found=mm.info(exists file name_mp3$)
loop until found = 0
not_found: find_mp3 = n_mp3
end function

sub play_album d$
local mp3file$=dir$("*.mp3",file)
local k$
do while mp3file$<>""
  play mp3 mp3file$, stop_play
  do while playing = 1
    pause 1000
    k$=inkey$
    if asc(k$)=27 then exit sub
    if asc(k$)=131 then
      play stop
      exit do
    endif
  loop
  mp3file$=dir$("*.mp3",file)
loop
end sub

sub stop_play
playing=0
end sub

sub ui
cls bg
circle 160,120,100,5,1,col1,col2
circle 160,120,20,10,1,col1,bg
t_name=1
text 160,250,"Track "+str$(t_name),"CB",1,1,col1
line 0,300,319,300,1,rgb(magenta)
local helps$=chr$(161)+" enter | "
helps$=helps$+chr$(160)+" enter | "
helps$=helps$+chr$(130)+" next | "
helps$=helps$+chr$(131)+" prev"
text 6,316,helps$,"LB",1,1,col1
end sub
