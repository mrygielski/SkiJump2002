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
     for xx:=0 to 14 do
     for yy:=0 to 11 do
      begin
       b:=getpixel(xx,yy,1);
       write(f,b);
      end;
     close(F);
end;

begin
     InitFGraph;
     setcol(255,0,63,63);
     getpal(p);
     newlayer;
     FindFirst('*.gif',archive,d);
     repeat
           ss:=d.name;
           delete(ss,length(ss)-3,4);
           loadgif(ss+'.gif',1);
           movebuf2screen;
           ekran2pal(0,0,15,12,p,1);
           setpal(p);
           movebuf2screen;
           saveasGFXfile(ss);
           movebuf2screen;
           findnext(d);
     until doserror<>0;
     CloseFGraph;
end.