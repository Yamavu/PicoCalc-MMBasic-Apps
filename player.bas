

option escape
dim mp3file$="runes/01.mp3"
dim playing=1
dim p$="B:/music/"

col1=RGB(white)
col2=RGB(grey)
bg=RGB(black)

play_dir("runes")

sub play_dir d$
local d_exists=MM.info(exists dir d$)
local mp3file$
if d_exists = -1 then
print "directory not found"
endif

chdir p$+d$
mp3file$=dir$("*.mp3",file)
n=find_mp3(".")
print n

play mp3 mp3file$, stop_play
ui
do while playing = 1
pause 10000
loop
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



sub stop_play
playing=0
end sub

sub ui
cls bg
circle 160,120,100,5,1,col1,col2
circle 160,120,20,10,1,col1,bg
t_name=1
text 160,250,"Track "+str$(t_name),"CB",1,1,col1
end sub
