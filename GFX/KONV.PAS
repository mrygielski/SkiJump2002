Uses Dos,FGraphB;
var d:SearchRec;
    p:TPaleta;
    ss:string;
    x,y,mx:integer;







Procedure SaveASGFXFile(plik:String);
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     assign(f,plik);
     rewrite(f);
     for xx:=0 to 19 do
     for yy:=0 to 29 do
      begin
       b:=getpixel(xx,yy,1);
       write(f,b);
      end;
     close(F);
end;

begin
     InitFGraph;
     getpal(p);
     newlayer;
     FindFirst('*.gif',archive,d);
     repeat
           ss:=d.name;
           delete(ss,length(ss)-3,4);
           loadgif(ss+'.gif',1);
           movebuf2screen;
           ekran2pal(0,0,19,29,p,1);
           setpal(p);
           for x:=0 to 19 do for y:=0 to 29 do if getpixel(x,y,1)=255 then putpixel(x,y,16,1);
           movebuf2screen;
           saveasGFXfile(ss);
           movebuf2screen;
           findnext(d);
     until doserror<>0;
     CloseFGraph;
end.