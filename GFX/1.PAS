
uses fgraphb;
var x, y :integer;
    r,g,b,rgb:byte;
begin
initfgraph;
loadgif('podium.gif',1);
setcol(0,0,0,0);
setcol(201,45,0,0);
setcol(202,0,50,0);
setcol(203,0,47,0);
setcol(204,0,44,0);
setcol(205,63,63,0);
for x:= 0 to 320 do for y:= 0 to 200 do if getpixel(x,y,1)=255 then putpixel(x,y,1,1);
for x:= 0 to 320 do for y:= 0 to 200 do if getpixel(x,y,1)=0 then putpixel(x,y,201,1);
{for x:=0 to 20 do for y:= 89 to 199 do
 begin
  getcol(getpixel(x,y,1),r,g,b);
  rgb:=r+g+b;
  if rgb>110 then putpixel(x,y,202+random(3),1);
 end;
for x:=0 to 319 do for y:= 180 to 199 do
 begin
  getcol(getpixel(x,y,1),r,g,b);
  rgb:=r+g+b;
  if rgb>110 then putpixel(x,y,202+random(3),1);
 end;
for x:=280 to 319 do for y:= 89 to 199 do
 begin
  getcol(getpixel(x,y,1),r,g,b);
  rgb:=r+g+b;
  if rgb>110 then putpixel(x,y,202+random(3),1);
 end;}


saveraw('podium.raw',1);
movebuf2screen;
readln;
closefgraph;
end.