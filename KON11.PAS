uses crt,f13h,games,skiunit;

const versja = '1.0';

      flaga : array[1..25, 1..35] of byte = (
(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,4,4,4,1,1,1,4,4,4,1,1,4,1,1,1,1,4,4,4,1,1,4,4,4,4,1,4,1,1,1,4,1),
(1,1,4,1,1,1,4,1,4,1,1,1,4,1,4,1,1,1,1,4,1,1,4,1,4,1,1,1,1,4,4,1,1,4,1),
(1,1,4,1,1,1,1,1,4,1,1,1,4,1,4,1,1,1,1,4,1,1,4,1,4,1,1,1,1,4,1,4,1,4,1),
(1,1,4,1,4,4,4,1,4,1,1,1,4,1,4,1,1,1,1,4,1,1,4,1,4,4,4,1,1,4,1,4,1,4,1),
(1,1,4,1,1,1,4,1,4,1,1,1,4,1,4,1,1,1,1,4,1,1,4,1,4,1,1,1,1,4,1,1,4,4,1),
(1,1,1,4,4,4,1,1,1,4,4,4,1,1,4,4,4,4,1,4,4,4,1,1,4,4,4,4,1,4,1,1,1,4,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,4,4,4,1,1,1,4,4,1,1,4,4,4,4,4,1,4,4,4,4,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,4,1,1,1,4,1,4,1,1,4,1,1,1,4,1,1,1,4,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,4,1,1,1,1,1,4,1,1,4,1,1,1,4,1,1,1,4,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,4,1,1,4,4,1,4,4,4,4,1,1,1,4,1,1,1,4,4,4,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,4,1,1,1,4,1,4,1,1,4,1,1,1,4,1,1,1,4,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,4,4,4,1,1,4,1,1,4,1,1,1,4,1,1,1,4,4,4,4,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,1,1,1,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,4,1,4,1,1,1,4,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,4,1,4,1,1,1,4,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,4,1,4,4,1,1,4,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,4,1,4,1,1,1,4,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,1,1,1,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1),
(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1));

type
     flagatype = array[1..25,1..35] of byte;
     flagaxytype = array[1..25,1..35] of record x,y:word end;

var ff:file;
    imie,kraj: array[1..5] of string[20];
    graczy: byte;
    fl : flagatype;
    fxy : flagaxytype;
    r, s : word;
    costab : array[0..63] of shortint;

procedure start_game;

function czyplikistnieje(plik : string) : boolean;
var
   f : file of byte;
begin
     {$I-}
     assign(f,plik);
     reset(f);
     close(f);
     {$I+}
     czyplikistnieje:=ioresult=0;
end;

procedure file_(plik:string);
begin
     writeln;
     textcolor(12);
     write(plik);
     if czyplikistnieje(plik) then begin textcolor(10); write(' - OK'); end else
     begin textcolor(14); write(' - FILE NOT FOUND'); halt; end;
end;

Function InitMouse : Boolean; Assembler;
Asm
   Xor Ax, Ax
   Int $33
   Not Ax
   Xor Ax, 1
   And Ax, 1
End;

begin
     clrscr;
     textcolor(8);
     writeln('+-------------------------+');
     textcolor(14);
     writeln('SKI JUMP '+versja+' by GOLDEN GATE');
     textcolor(8);
     writeln('+-------------------------+');
     writeln;
     textcolor(12);
     write('MOUSE ');
     if initmouse then begin textcolor(14); write(' - OK'); end else
     begin textcolor(10); write(' - NOT');  halt; end;
     writeln;
     file_('data\imiona.dat');
     file_('data\opcje.dat');
     file_('data\skocznie.dat');
     file_('data\ski.pal');
     file_('data\licznik.fn2');
     file_('data\small.fn2');
     file_('gfx\menu.raw');
     file_('gfx\podium.raw');
     file_('gfx\skijump');
     file_('gfx\tree');
     file_('gfx\flagi\austria');
     file_('gfx\flagi\finland');
     file_('gfx\flagi\germany');
     file_('gfx\flagi\norway');
     file_('gfx\flagi\poland');
     file_('gfx\kibice\hum1');
     file_('gfx\kibice\hum2');
     file_('gfx\kibice\hum3');
     file_('gfx\kibice\hum4');
     file_('gfx\kibice\hum5');
     file_('gfx\kibice\hum6');
     file_('gfx\kibice\hum7');
     file_('gfx\kibice\hum8');
     file_('gfx\kibice\hum9');
     file_('gfx\kibice\hum10');
     writeln;
     textcolor(15);
     writeln('DONE');
end;

procedure flagaANI;
var i,j:word;
    ax,ay: integer;
    z: byte;
begin
 r:=3;
 for z:= 96 to 127 do setcol(z,z,(z-32)*3-10,0);
 for z:= 1 to 25 do move(flaga[z],fl[z],35);
 for z:= 1 to 64 do costab[z-1]:=round(cos(z/5)*(sin(z/4)*r));
 for z:= 1 to 95 do setcol(z,0,0,z+10);
repeat
      inc(s,1);
      for i:= 1 to 25 do
      for j:= 1 to 35 do
      begin
           fxy[i,j].y:=15+longmul(j,8)+costab[(i+j+s) mod 64];
           fxy[i,j].x:=10+longmul(i,7)+costab[(j+i+s) mod 64];
           for ax:=fxy[i-1,j].x to fxy[i,j].x-1 do
           for ay:=fxy[i,j-1].y to fxy[i,j].y-1 do
           putpixel1(ay,ax,fl[i,j] shl 5-costab[(i+j+s) mod 64]-12);
      end;
      movebuf2screen2;
      bar1(0,0,319,199,0);
until keypressed;
movebuf2screen2;
end;


Procedure Stroje(kraj:string;nr:byte;lider:boolean); forward;

Procedure Bar;
var x,y:integer;
begin
     for x:=0 to 319 do for y:=0 to 199 do
      begin
           bufor^[320*y+x]:=0;
           layer1^[320*y+x]:=0;
           layer2^[320*y+x]:=255;
      end;
end;

Procedure Kwalifikacje;
var i,jumper:byte;
    r:real;
    a,b:real;
    aa,bb:byte;
begin
     for jumper:=72 downto 1 do begin
      Stroje(tabela[jumper].kraj,jumper,false);
      r:=0;
      skoczek:=jumper;
      bb:=0;
      for aa:=1 to graczy do if imie[aa]=tabela[jumper].imie then begin bb:=aa;aa:=graczy end;
      if (bb=0) then begin
        a:=random(30) / (10); r:=skok_random+a;
        bar;end else r:=skokhum(imie[bb]);
      tabela[jumper].pun:=tabela[jumper].pun+r;
      if bb=0 then
      if not pokaz_komp then begin bar1(123,89,196,111,7);bar1(124,90,195-jumper,110,15);
      outtextxyfnt1(161-((length(tabela[jumper].imie) shl 2)shr 1),115,12,4,tabela[jumper].imie,'data\licznik.fn2',norm); end;
      movebuf2screen2;
     end;
end;

Procedure Seria1;
var i,jumper:byte;
    r,a:real;
    aa,bb:byte;
begin
     for jumper:=50 downto 1 do begin
      Stroje(tabela[jumper].kraj,jumper,false);
      r:=0;
      skoczek:=jumper;
      bb:=0;
      for aa:=1 to graczy do if imie[aa]=tabela[jumper].imie then begin bb:=aa;aa:=graczy end;
      if (bb=0) then begin
        a:=random(30) / (10); r:=skok_random+a;
        bar;end else r:=skokhum(imie[bb]);
      tabela[jumper].pun:=tabela[jumper].pun+r;
      if bb=0 then
      if not pokaz_komp then begin bar1(134,89,186,111,7);bar1(135,90,185-jumper,110,15);
      outtextxyfnt1(161-((length(tabela[jumper].imie) shl 2)shr 1),115,12,4,tabela[jumper].imie,'data\licznik.fn2',norm); end;
      movebuf2screen2;
     end;
end;

Procedure Seria2;
var i,jumper:byte;
    r,A:real;
    aa,bb:byte;
begin
     for jumper:=30 downto 1 do begin
      Stroje(tabela[jumper].kraj,jumper,false);
      r:=0;
      skoczek:=jumper;
      bb:=0;
      for aa:=1 to graczy do if imie[aa]=tabela[jumper].imie then begin bb:=aa;aa:=graczy end;
      if (bb=0) then begin
        a:=random(30) / (10); r:=skok_random+a;
        bar;end else r:=skokhum(imie[bb]);
      tabela[jumper].pun:=tabela[jumper].pun+r;
      if bb=0 then
      if not pokaz_komp then begin bar1(144,89,176,111,7);bar1(145,90,175-jumper,110,15);
      outtextxyfnt1(161-((length(tabela[jumper].imie) shl 2)shr 1),115,12,4,tabela[jumper].imie,'data\licznik.fn2',norm); end;
      movebuf2screen2;
     end;
end;

Procedure Sortuj_Kwalifikacje;
var a,b:integer;
    aa:zaw2;
begin
     for b:=1 to 72 do
      for a:=1 to 71 do
       begin
            if tabela[a].pun<tabela[a+1].pun then
             begin
              aa:=tabela[a];
              tabela[a]:=aa;
              tabela[a]:=tabela[a+1];
              tabela[a+1]:=aa;
             end;
       end;
end;

Procedure Zeruj_Punkty;
var a:byte;
begin
     for a:=1 to 72 do tabela[a].pun:=0;
end;

Procedure Sortuj_Seria1;
var a,b:integer;
    aa:zaw2;
begin
     for b:=1 to 50 do
      for a:=1 to 49 do
       begin
            if tabela[a].pun<tabela[a+1].pun then
             begin
              aa:=tabela[a];
              tabela[a]:=aa;
              tabela[a]:=tabela[a+1];
              tabela[a+1]:=aa;
             end;
       end;
end;

Procedure Sortuj_Seria2;
var a,b:integer;
    aa:zaw2;
begin
     for b:=1 to 30 do
      for a:=1 to 29 do
       begin
            if tabela[a].pun<tabela[a+1].pun then
             begin
              aa:=tabela[a];
              tabela[a]:=aa;
              tabela[a]:=tabela[a+1];
              tabela[a+1]:=aa;
             end;
       end;
end;


Function Real2Str2(re:real) : string;
var s:string;
begin
     str(re:2:1,s);
     real2str2:=s;
end;

Function Real2Str22(re:real) : string;
var s:string;
    a:longint;
begin
     a:=trunc(re);
     str(a,s);
     real2str22:=s;
end;

Function Real2str222(oc:real) : string;
var a,b:word;
    rrr:real;
begin
     a:=trunc(oc);
     rrr:=oc-trunc(oc);
     rrr:=rrr*10;
     if rrr<5 then b:=0 else b:=5;
     Real2str222:=num2str(a)+'.'+num2str(b);
end;

Procedure Tabelka(ile:word);
var i,nr:byte;
    x,y,aa,bb:integer;
begin
     bar;movebuf2screen2;
     loadraw1('gfx\menu.raw');
     bar1(95,20,225,195,0);
     if ile=72 then outtextxyfnt1(160-((length('KWALIFIKACJE')*7)div 2),5,15,7,'KWALIFIKACJE','data\small.fn2',bold);
     if ile=50 then outtextxyfnt1(160-((length('1 SERIA')*7)div 2),5,15,7,'1 SERIA','data\small.fn2',bold);
     if ile=30 then outtextxyfnt1(160-((length('2 SERIA')*7)div 2),5,15,7,'2 SERIA','data\small.fn2',bold);
     nr:=0;
     for i:= 1 to 16 do
     begin
          line1(10+85,10+i*10,141+85,10+i*10,14);
          outtextxyfnt1(12+85,23+(i-1)*10,15,4,num2str(i+nr),'data\licznik.fn2',norm);
     end;
     line1(10+85,180,141+85,180,14);
     line1(10+85,20,10+85,180,14);
     line1(20+85,20,20+85,180,14);
     line1(102+85,20,102+85,180,14);
     line1(115+85,20,115+85,180,14);
     line1(141+85,20,141+85,180,14);
     line1(95,180,95,195,14);
     line1(226,180,226,195,14);
     line1(95,195,226,195,14);
     outtextxyfnt1(97,182,11,4,
     'K-'+num2str(s__^[nr_skoczni].k)+'  '+s__^[nr_skoczni].name+'-'+s__^[nr_skoczni].kraj,
     'data\licznik.fn2',norm);
     outtextxyfnt1(97,189,11,4,'REKORD: '+real2str222(s__^[nr_skoczni].rec/3-0.3),'data\licznik.fn2',norm);

     repeat
           for i:= 1 to 16 do
           begin
                outtextxyfnt1(12+85,23+(i-1)*10,15,4,num2str(i+nr),'data\licznik.fn2',norm);
             bb:=0;
             for aa:=1 to graczy do if imie[aa]=tabela[i+nr].imie then begin bb:=aa;aa:=graczy end;
             if bb<>0 then outtextxyfnt1(22+85,23+(i-1)*10,11,4,tabela[nr+i].imie,'data\licznik.fn2',norm)
                else begin
                if ile=72 then begin
                  if nr+i>50 then outtextxyfnt1(22+85,23+(i-1)*10,1,4,tabela[nr+i].imie,'data\licznik.fn2',norm) else
                  outtextxyfnt1(22+85,23+(i-1)*10,15,4,tabela[nr+i].imie,'data\licznik.fn2',norm);
                end;
                if ile=50 then begin
                  if nr+i>30 then outtextxyfnt1(22+85,23+(i-1)*10,1,4,tabela[nr+i].imie,'data\licznik.fn2',norm) else
                  outtextxyfnt1(22+85,23+(i-1)*10,15,4,tabela[nr+i].imie,'data\licznik.fn2',norm);
                end;
                if ile=30 then begin
                  outtextxyfnt1(22+85,23+(i-1)*10,15,4,tabela[nr+i].imie,'data\licznik.fn2',norm);
                end;
                end;
                outtextxyfnt1(117+85,23+(i-1)*10,15,4,real2str2(tabela[nr+i].pun),'data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Austria' then outtextxyfnt1(188,23+(i-1)*10,15,4,'AUT','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Czechy' then outtextxyfnt1(188,23+(i-1)*10,15,4,'CZE','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Finlandia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'FIN','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Francja' then outtextxyfnt1(188,23+(i-1)*10,15,4,'FRA','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Niemcy' then outtextxyfnt1(188,23+(i-1)*10,15,4,'GER','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Wˆochy' then outtextxyfnt1(188,23+(i-1)*10,15,4,'ITA','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Japonia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'JPN','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Korea' then outtextxyfnt1(188,23+(i-1)*10,15,4,'KOR','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Polska' then outtextxyfnt1(188,23+(i-1)*10,15,4,'POL','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Norwegia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'NOR','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Rosja' then outtextxyfnt1(188,23+(i-1)*10,15,4,'RUS','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Sˆowenia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'SLO','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Szwajcaria' then outtextxyfnt1(188,23+(i-1)*10,15,4,'SWI','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='USA' then outtextxyfnt1(188,23+(i-1)*10,15,4,'USA','data\licznik.fn2',norm);
           end;
           movebuf2screen2;
           for i:= 1 to 16 do
           begin
                outtextxyfnt1(12+85,23+(i-1)*10,0,4,num2str(i+nr),'data\licznik.fn2',norm);
                outtextxyfnt1(22+85,23+(i-1)*10,0,4,tabela[nr+i].imie,'data\licznik.fn2',norm);
                outtextxyfnt1(117+85,23+(i-1)*10,0,4,real2str2(tabela[nr+i].pun),'data\licznik.fn2',norm);
                bar1(188,21+(i-1)*10,199,29+(i-1)*10,0);
           end;
           if keydown[72] and (nr>0) then nr:=nr-1;
           if keydown[80] and (nr<ile-16) then nr:=nr+1;
     until (button=1);
     bar;movebuf2screen2;
end;

Function Quit : boolean;
var x,y:integer;
begin
     bar2(130,90,190,110,8);
     outtextxyfnt2(160-((length('CZY WYJ—?')*4)div 2),94,15,4,'CZY WYJ—?','data\licznik.fn2',norm);
     outtextxyfnt2(160-((length('t/n')*4)div 2),102,7,4,'t/n','data\licznik.fn2',norm);
     movebuf2screen2;
     repeat
     until keydown[scanof('t')] or keydown[scanof('n')];
     if keydown[scanof('t')] then quit:=true else quit:=false;
     bar2(130,90,190,110,255);
end;


Procedure TabelkaGeneral;
var i,nr:byte;
    x,y,aa,bb:integer;
begin
     bar;movebuf2screen2;
     loadraw1('gfx\menu.raw');
     bar1(95,20,225,180,0);
     nr:=0;
     outtextxyfnt1(160-((length('KLASYFIKACJA GENERALNA')*7)div 2),5,15,7,'KLASYFIKACJA GENERALNA','data\small.fn2',bold);
     for i:= 1 to 16 do
     begin
          line1(10+85,10+i*10,141+85,10+i*10,14);
          outtextxyfnt1(12+85,23+(i-1)*10,15,4,num2str(i+nr),'data\licznik.fn2',norm);
     end;
     line1(10+85,180,141+85,180,14);
     line1(10+85,20,10+85,180,14);
     line1(20+85,20,20+85,180,14);
     line1(102+85,20,102+85,180,14);
     line1(115+85,20,115+85,180,14);
     line1(141+85,20,141+85,180,14);
     exitgame:=false;
     repeat
           for i:= 1 to 16 do
           begin
                outtextxyfnt1(12+85,23+(i-1)*10,15,4,num2str(i+nr),'data\licznik.fn2',norm);
             bb:=0;
             for aa:=1 to graczy do if imie[aa]=tabela[i+nr].imie then begin bb:=aa;aa:=graczy end;
             if bb<>0 then outtextxyfnt1(22+85,23+(i-1)*10,11,4,tabela[nr+i].imie,'data\licznik.fn2',norm)
                else begin
                outtextxyfnt1(22+85,23+(i-1)*10,15,4,tabela[nr+i].imie,'data\licznik.fn2',norm);
                end;
                outtextxyfnt1(117+85,23+(i-1)*10,15,4,real2str22(tabela[nr+i].pkt),'data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Austria' then outtextxyfnt1(188,23+(i-1)*10,15,4,'AUT','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Czechy' then outtextxyfnt1(188,23+(i-1)*10,15,4,'CZE','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Finlandia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'FIN','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Francja' then outtextxyfnt1(188,23+(i-1)*10,15,4,'FRA','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Niemcy' then outtextxyfnt1(188,23+(i-1)*10,15,4,'GER','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Wˆochy' then outtextxyfnt1(188,23+(i-1)*10,15,4,'ITA','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Japonia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'JPN','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Korea' then outtextxyfnt1(188,23+(i-1)*10,15,4,'KOR','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Polska' then outtextxyfnt1(188,23+(i-1)*10,15,4,'POL','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Norwegia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'NOR','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Rosja' then outtextxyfnt1(188,23+(i-1)*10,15,4,'RUS','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Sˆowenia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'SLO','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Szwajcaria' then outtextxyfnt1(188,23+(i-1)*10,15,4,'SWI','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='USA' then outtextxyfnt1(188,23+(i-1)*10,15,4,'USA','data\licznik.fn2',norm);
           end;
           if keydown[1] then exitgame:=quit;
           movebuf2screen2;
           for i:= 1 to 16 do
           begin
                outtextxyfnt1(12+85,23+(i-1)*10,0,4,num2str(i+nr),'data\licznik.fn2',norm);
                outtextxyfnt1(22+85,23+(i-1)*10,0,4,tabela[nr+i].imie,'data\licznik.fn2',norm);
                outtextxyfnt1(117+85,23+(i-1)*10,0,4,real2str22(tabela[nr+i].pkt),'data\licznik.fn2',norm);
                bar1(188,21+(i-1)*10,199,29+(i-1)*10,0);
           end;
           if keydown[72] and (nr>0) then nr:=nr-1;
           if keydown[80] and (nr<72-16) then nr:=nr+1;
     until (button=1) or exitgame;
     bar;movebuf2screen2;
     leader:=tabela[1].imie;
end;

Procedure Przyznaj_punkty;
var x:byte;
begin
     inc(tabela[1].pkt,100);inc(tabela[16].pkt,15);
     inc(tabela[2].pkt,80); inc(tabela[17].pkt,14);
     inc(tabela[3].pkt,60); inc(tabela[18].pkt,13);
     inc(tabela[4].pkt,50); inc(tabela[19].pkt,12);
     inc(tabela[5].pkt,45); inc(tabela[20].pkt,11);
     inc(tabela[6].pkt,40); inc(tabela[21].pkt,10);
     inc(tabela[7].pkt,36); inc(tabela[22].pkt,9);
     inc(tabela[8].pkt,32); inc(tabela[23].pkt,8);
     inc(tabela[9].pkt,29); inc(tabela[24].pkt,7);
     inc(tabela[10].pkt,26);inc(tabela[25].pkt,6);
     inc(tabela[11].pkt,24);inc(tabela[26].pkt,5);
     inc(tabela[12].pkt,22);inc(tabela[27].pkt,4);
     inc(tabela[13].pkt,20);inc(tabela[28].pkt,3);
     inc(tabela[14].pkt,18);inc(tabela[29].pkt,2);
     inc(tabela[15].pkt,16);inc(tabela[30].pkt,1);
     for x:=1 to 72 do tabela[x].pun:=0;
end;

Procedure Stroje(kraj:string;nr:byte;lider:boolean);
begin
     if kraj='Finlandia' then begin
      kolory.narty:=9;
      kolory.nogi:=11;
      kolory.tulow:=28;
      kolory.rece:=9;
      kolory.kask:=28;
     end;
     if kraj='Austria' then begin
      kolory.narty:=4;
      kolory.nogi:=28;
      kolory.tulow:=28;
      kolory.rece:=4;
      kolory.kask:=4;
     end;
     if kraj='Niemcy' then begin
      kolory.narty:=14;
      kolory.nogi:=4;
      kolory.tulow:=4;
      kolory.rece:=0;
      kolory.kask:=0;
     end;
     if kraj='Japonia' then begin
      kolory.narty:=28;
      kolory.nogi:=28;
      kolory.tulow:=28;
      kolory.rece:=28;
      kolory.kask:=4;
     end;
     if kraj='Norwegia' then begin
      kolory.narty:=4;
      kolory.nogi:=4;
      kolory.tulow:=9;
      kolory.rece:=28;
      kolory.kask:=4;
     end;
     if kraj='Polska' then begin
      kolory.narty:=4;
      kolory.nogi:=4;
      kolory.tulow:=4;
      kolory.rece:=28;
      kolory.kask:=28;
     end;
     if kraj='Szwajcaria' then begin
      kolory.narty:=4;
      kolory.nogi:=4;
      kolory.tulow:=28;
      kolory.rece:=4;
      kolory.kask:=4;
     end;
     if kraj='Sˆowenia' then begin
      kolory.narty:=9;
      kolory.nogi:=9;
      kolory.tulow:=4;
      kolory.rece:=28;
      kolory.kask:=28;
     end;
     if kraj='Czechy' then begin
      kolory.narty:=4;
      kolory.nogi:=4;
      kolory.tulow:=9;
      kolory.rece:=28;
      kolory.kask:=28;
     end;
     if kraj='Rosja' then begin
      kolory.narty:=9;
      kolory.nogi:=9;
      kolory.tulow:=4;
      kolory.rece:=28;
      kolory.kask:=28;
     end;
     if kraj='Wˆochy' then begin
      kolory.narty:=2;
      kolory.nogi:=2;
      kolory.tulow:=28;
      kolory.rece:=4;
      kolory.kask:=4;
     end;
     if kraj='USA' then begin
      kolory.narty:=4;
      kolory.nogi:=28;
      kolory.tulow:=4;
      kolory.rece:=28;
      kolory.kask:=9;
     end;
     if kraj='Francja' then begin
      kolory.narty:=11;
      kolory.nogi:=11;
      kolory.tulow:=28;
      kolory.rece:=4;
      kolory.kask:=4;
     end;
     if kraj='Korea' then begin
      kolory.narty:=28;
      kolory.nogi:=0;
      kolory.tulow:=0;
      kolory.rece:=28;
      kolory.kask:=28;
     end;
     if leader=tabela[nr].imie then kolory.tulow:=14;
end;


Procedure Sortuj_wg_pkt;
var a,b:integer;
    aa:zaw2;
begin
     For b:=1 to 72 do
      for a:=1 to 71 do
       begin
            if tabela[a].pkt<tabela[a+1].pkt then
             begin
              aa:=tabela[a];
              tabela[a]:=aa;
              tabela[a]:=tabela[a+1];
              tabela[a+1]:=aa;
             end;
       end;
end;

Procedure TextSrodek1(y,k,ods:byte;text:string);
begin
     outtextxyfnt1(160-((length(text)*ods) div 2),y,k,ods,text,'data\licznik.fn2',norm);
end;

Procedure Informacje;
begin
     bar;movebuf2screen2;
     loadraw1('gfx\menu.raw');
     bar1(100,70,220,130,14);
     bar1(101,71,219,129,0);
     line1(100,78,220,78,14);
     textsrodek1(72,11,4,'INFORMACJE');
     outtextxyfnt1(103,81+3,14,4,'Punkt konstrukcyjny: '+num2str(s__^[nr_skoczni].k)+' m','data\licznik.fn2',norm);
     outtextxyfnt1(103,88+3,14,4,'Miejscowo˜†: '+s__^[nr_skoczni].name,'data\licznik.fn2',norm);
     outtextxyfnt1(103,95+3,14,4,'Kraj: '+s__^[nr_skoczni].kraj,'data\licznik.fn2',norm);
     outtextxyfnt1(103,102+3,14,4,'Rekord: '+real2str222(s__^[nr_skoczni].rec/3),'data\licznik.fn2',norm);
     outtextxyfnt1(103,109+3,14,4,'        '+s__^[nr_skoczni].reko,'data\licznik.fn2',norm);
     outtextxyfnt1(103,116+3,14,4,'Przewidywany wiatr: '+real2str2(wiatr_),'data\licznik.fn2',norm);
     movebuf2screen2;
     repeat until (button=1);
     bar;
     movebuf2screen2;
end;

Procedure Konkurs(nr_skocznii:byte;igielitt:boolean);
begin
     if exitgame then exit;
     randomize;
     wiatr_:=random(5)*0.5;
     if random(2)<>1 then wiatr_:=-wiatr_;
     pokaz_komp:=false;
     Nr_skoczni:=Nr_skocznii;
     IGIELIT:=igielitt;
     Informacje;
     komp_rec:=false;gracz_rec:=false;Kwalifikacje;gracz_rec:=true;komp_rec:=true;     Bar;movebuf2screen2; crt.delay(200);
     Sortuj_Kwalifikacje;
     tabelka(72);Zeruj_Punkty;
     Seria1;           Bar;movebuf2screen2; crt.delay(200);
     Sortuj_Seria1;
     tabelka(50);
     Seria2;           Bar;movebuf2screen2; crt.delay(200);
     Sortuj_Seria2;
     tabelka(30);
     Przyznaj_punkty;
     Sortuj_wg_pkt;
     crt.delay(250);
     tabelkaGeneral;
end;

procedure final;
var r,g,b,rgb:byte;
    x,y:integer;
begin
     bar;
     loadraw1('gfx\podium.raw');
if igielit then begin
for x:=0 to 20 do for y:= 89 to 199 do
 begin
  getcol(getpixel1(x,y),r,g,b);
  rgb:=r+g+b;
  if rgb>110 then putpixel1(x,y,202+random(3));
 end;
for x:=0 to 319 do for y:= 180 to 199 do
 begin
  getcol(getpixel1(x,y),r,g,b);
  rgb:=r+g+b;
  if rgb>110 then putpixel1(x,y,202+random(3));
 end;
for x:=280 to 319 do for y:= 89 to 199 do
 begin
  getcol(getpixel1(x,y),r,g,b);
  rgb:=r+g+b;
  if rgb>110 then putpixel1(x,y,202+random(3));
 end;
end;
     centertextfnt1(60,178,205,4,tabela[2].imie,'data\licznik.fn2',norm);
     centertextfnt1(158,170,205,4,tabela[1].imie,'data\licznik.fn2',norm);
     centertextfnt1(257,180,205,4,tabela[3].imie,'data\licznik.fn2',norm);
     centertextfnt1(60,185,205,4,tabela[2].kraj,'data\licznik.fn2',norm);
     centertextfnt1(158,177,205,4,tabela[1].kraj,'data\licznik.fn2',norm);
     centertextfnt1(257,187,205,4,tabela[3].kraj,'data\licznik.fn2',norm);
     movebuf2screen;
     repeat until (button=1);
end;

Procedure GPLata;
begin
     leader:='';
     exitgame:=false;
     Konkurs(8,true);
     Konkurs(8,true);
     Konkurs(7,true);
     Konkurs(1,true);
     Konkurs(14,true);
     Konkurs(14,true);
     crt.delay(500);
     igielit:=true;
     if not exitgame then final;
end;

Procedure PS;
begin
     leader:='';
     exitgame:=false;
     Konkurs(5,false);
     Konkurs(5,false);
     Konkurs(9,false);
     Konkurs(9,false);
     Konkurs(2,false);
     Konkurs(2,false);
     Konkurs(21,false);
     Konkurs(21,false);
     Konkurs(13,false);
     Konkurs(13,false);
     Konkurs(10,false);
     Konkurs(11,false);
     Konkurs(4,false);
     Konkurs(3,false);
     Konkurs(12,false);
     Konkurs(19,false);
     Konkurs(19,false);
     Konkurs(14,false);
     Konkurs(15,false);
     Konkurs(15,false);
     Konkurs(23,false);
     Konkurs(24,false);
     Konkurs(24,false);
     Konkurs(6,false);
     Konkurs(6,false);
     Konkurs(16,false);
     Konkurs(16,false);
     Konkurs(22,false);
     Konkurs(17,false);
     Konkurs(18,false);
     Konkurs(20,false);
     Konkurs(20,false);
     crt.delay(500);
     if not exitgame then final;
end;

Procedure ShowLogo(x,y:integer);
var xx,yy:integer;
    b:Byte;
    f:file of byte;
begin
     assign(f,'gfx\skijump');
     reset(f);
     for xx:=0 to 119 do
     for yy:=0 to 27 do
      begin
       read(f,b);
       if b<>0 then putpixel1(xx+x,yy+y,b);
      end;
     close(f);
end;

Procedure Show_opcje;
var x,y:integer;
begin
     bar;
     movebuf2screen;
     loadraw1('gfx\menu.raw');
     showlogo(1,1);
     outtextxyfnt1(108,23,getpixel1(97,20),4,versja,'data\licznik.fn2',norm);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=252 then putpixel1(x,y,245);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=11 then putpixel1(x,y,242);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=17 then putpixel1(x,y,14);
     setcol(11,40,40,0);
     setcol(252,55,55,0);
     setcol(17,0,0,63);
     centertextfnt1(160,80,11,7,'DODAJ GRACZA','data\small.fn2',bold);
     centertextfnt1(159,81,252,7,'DODAJ GRACZA','data\small.fn2',bold);
     centertextfnt1(160,95,11,7,'USUã GRACZA','data\small.fn2',bold);
     centertextfnt1(159,96,252,7,'USUã GRACZA','data\small.fn2',bold);
     if detale=high then begin
     centertextfnt2(160,110,11,7,'DETALE: WYSOKIE','data\small.fn2',bold);
     centertextfnt2(159,111,252,7,'DETALE: WYSOKIE','data\small.fn2',bold);
     end else begin
     centertextfnt2(160,110,11,7,'DETALE: NISKIE','data\small.fn2',bold);
     centertextfnt2(159,111,252,7,'DETALE: NISKIE','data\small.fn2',bold);
     end;
     centertextfnt1(160,125,11,7,'POWRàT','data\small.fn2',bold);
     centertextfnt1(159,126,252,7,'POWRàT','data\small.fn2',bold);
end;

Procedure Dodaj;
var i,x,y:integer;
    im,kr:string[20];
    kraj_ : byte;
const kraje: array[1..14] of string[10]=('Polska','Finlandia','Niemcy',
          'Japonia','Austria','Szwajcaria','Sˆowenia','Czechy','USA',
          'Korea','Rosja','Francja','Wˆochy','Norwegia');
begin
     setoldkeyint;
     bar2(109,164,211,191,252);
     bar2(110,165,210,190,11);
     centertextfnt2(160,170,252,4,'PODAJ IMI¨','data\licznik.fn2',norm);
     im:=ReadStrFNT2(120,180,20,252,11,3,4,'data\licznik.fn2');
     initnewkeyint;
     bar2(109,164,211,191,252);
     bar2(110,165,210,190,11);
     centertextfnt2(160,170,252,4,'PODAJ KRAJ','data\licznik.fn2',norm);
     movebuf2screen2;
     kraj_:=1;
     repeat
           centertextfnt2(160,180,252,4,kraje[kraj_],'data\licznik.fn2',norm);
           outtextxyfnt2(112,170,252,4,num2str(kraj_)+'/14','data\licznik.fn2',norm);
           movebuf2screen2;
           outtextxyfnt2(112,170,11,4,num2str(kraj_)+'/14','data\licznik.fn2',norm);
           centertextfnt2(160,180,11,4,kraje[kraj_],'data\licznik.fn2',norm);
           if keydown[72] and (kraj_>1) then begin kraj_:=kraj_-1; crt.delay(100);end;
           if keydown[80] and (kraj_<14) then begin kraj_:=kraj_+1; crt.delay(100);end;
     until keydown[entscan];
     graczy:=graczy+1;
     imie[graczy]:=im;
     kraj[graczy]:=kraje[kraj_];
     For i:=1 to graczy do
      begin
       tabela[73-i].imie:=imie[i];
       tabela[73-i].kraj:=kraj[i];
       tabela[73-i].pun:=0;
       tabela[73-i].pkt:=0;
      end;
     crt.delay(200);
     show_opcje;
end;

Procedure Usun;
var i:byte;
begin
     assign(f,'data\imiona.dat');
     reset(f);
     read(f,z^);
     close(f);
     for i:=1 to 72 do begin
      tabela[i].imie:=z^[i].imie;
      tabela[i].kraj:=z^[i].kraj;
      tabela[i].pun:=0;
      tabela[i].pkt:=0;
     end;
     graczy:=graczy-1;
     For i:=1 to graczy do
      begin
       tabela[73-i].imie:=imie[i];
       tabela[73-i].kraj:=kraj[i];
       tabela[73-i].pun:=0;
       tabela[73-i].pkt:=0;
      end;
     crt.delay(200);
end;

Procedure Opcje;
var x,y,opcja:integer;
    quit:boolean;
begin
     assign(ff,'data\opcje.dat');
     reset(ff,1);
     blockread(ff,graczy,sizeof(graczy));
     blockread(ff,imie,sizeof(imie));
     blockread(ff,kraj,sizeof(kraj));
     blockread(ff,detale,1);
     close(ff);
     show_opcje;
     crt.delay(200);
     opcja:=1;
     quit:=false;
     centertextfnt1(51,191,11,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     centertextfnt1(50,190,252,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     repeat
       rectangle2(90,80+(15*(opcja-1)),225,95+(15*(opcja-1)),17);
       movebuf2screen2;
       rectangle2(90,80+(15*(opcja-1)),225,95+(15*(opcja-1)),255);
       if keydown[72] and (opcja>1) then begin opcja:=opcja-1; crt.delay(100);end;
       if keydown[80] and (opcja<4) then begin opcja:=opcja+1; crt.delay(100);end;
       if keydown[entscan] and(opcja=4) then quit:=true;
       if keydown[entscan] and(opcja=3) then begin
        if detale=high then begin
        centertextfnt2(160,110,255,7,'DETALE: WYSOKIE','data\small.fn2',bold);
        centertextfnt2(159,111,255,7,'DETALE: WYSOKIE','data\small.fn2',bold);
        end else begin
        centertextfnt2(160,110,255,7,'DETALE: NISKIE','data\small.fn2',bold);
        centertextfnt2(159,111,255,7,'DETALE: NISKIE','data\small.fn2',bold);
        end;
        if detale=high then detale:=low else detale:=high;
        if detale=high then begin
        centertextfnt2(160,110,11,7,'DETALE: WYSOKIE','data\small.fn2',bold);
        centertextfnt2(159,111,252,7,'DETALE: WYSOKIE','data\small.fn2',bold);
        end else begin
        centertextfnt2(160,110,11,7,'DETALE: NISKIE','data\small.fn2',bold);
        centertextfnt2(159,111,252,7,'DETALE: NISKIE','data\small.fn2',bold);
        end;
        crt.delay(100);
       end;
       if keydown[entscan] and(opcja=1)and(graczy<5) then Dodaj;
       if keydown[entscan] and(opcja=2)and(graczy>0) then Usun;
     until quit;

     assign(ff,'data\opcje.dat');
     rewrite(ff,1);
     blockwrite(ff,graczy,sizeof(graczy));
     blockwrite(ff,imie,sizeof(imie));
     blockwrite(ff,kraj,sizeof(kraj));
     blockwrite(ff,detale,1);
     close(ff);

     bar;
     movebuf2screen;
     loadraw1('gfx\menu.raw');
     showlogo(1,1);
     outtextxyfnt1(108,23,getpixel1(97,20),4,versja,'data\licznik.fn2',norm);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=252 then putpixel1(x,y,245);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=11 then putpixel1(x,y,242);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=17 then putpixel1(x,y,14);
     setcol(11,40,40,0);
     setcol(252,55,55,0);
     setcol(17,0,0,63);
     centertextfnt1(160,80,11,7,'SKOKI','data\small.fn2',bold);
     centertextfnt1(159,81,252,7,'SKOKI','data\small.fn2',bold);
     centertextfnt1(160,95,11,7,'REKORDY','data\small.fn2',bold);
     centertextfnt1(159,96,252,7,'REKORDY','data\small.fn2',bold);
     centertextfnt1(160,110,11,7,'OPCJE','data\small.fn2',bold);
     centertextfnt1(159,111,252,7,'OPCJE','data\small.fn2',bold);
     centertextfnt1(160,125,11,7,'WYJ—CIE','data\small.fn2',bold);
     centertextfnt1(159,126,252,7,'WYJ—CIE','data\small.fn2',bold);
     centertextfnt1(51,191,11,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     centertextfnt1(50,190,252,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     crt.delay(200);
end;

Procedure Show_skoki;
var x,y:integer;
begin
     bar;
     movebuf2screen;
     loadraw1('gfx\menu.raw');
     showlogo(1,1);
     outtextxyfnt1(108,23,getpixel1(97,20),4,versja,'data\licznik.fn2',norm);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=252 then putpixel1(x,y,245);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=11 then putpixel1(x,y,242);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=17 then putpixel1(x,y,14);
     setcol(11,40,40,0);
     setcol(252,55,55,0);
     setcol(17,0,0,63);
     centertextfnt1(160,80,11,7,'GP LATA','data\small.fn2',bold);
     centertextfnt1(159,81,252,7,'GP LATA','data\small.fn2',bold);
     centertextfnt1(160,95,11,7,'PUCHAR —WIATA','data\small.fn2',bold);
     centertextfnt1(159,96,252,7,'PUCHAR —WIATA','data\small.fn2',bold);
     centertextfnt1(160,110,11,7,'TRENING','data\small.fn2',bold);
     centertextfnt1(159,111,252,7,'TRENING','data\small.fn2',bold);
     centertextfnt1(160,125,11,7,'POWRàT','data\small.fn2',bold);
     centertextfnt1(159,126,252,7,'POWRàT','data\small.fn2',bold);
     centertextfnt1(51,191,11,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     centertextfnt1(50,190,252,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
end;

procedure trening;
var kraj_:byte;
begin
     crt.delay(200);
     bar2(109,164,211,191,252);
     bar2(110,165,210,190,11);
     centertextfnt2(160,170,252,4,'WYBIERZ','data\licznik.fn2',norm);
     centertextfnt1(51,191,11,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     centertextfnt1(50,190,252,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     kraj_:=1;
     repeat
           centertextfnt2(160,180,252,4,s__^[kraj_].name,'data\licznik.fn2',norm);
           outtextxyfnt2(112,170,252,4,num2str(kraj_)+'/25','data\licznik.fn2',norm);
           movebuf2screen2;
           outtextxyfnt2(112,170,11,4,num2str(kraj_)+'/25','data\licznik.fn2',norm);
           centertextfnt2(160,180,11,4,s__^[kraj_].name,'data\licznik.fn2',norm);
           if keydown[72] and (kraj_>1) then begin kraj_:=kraj_-1; crt.delay(100);end;
           if keydown[80] and (kraj_<25) then begin kraj_:=kraj_+1; crt.delay(100);end;
     until keydown[entscan];
     nr_skoczni:=kraj_;
     bar;movebuf2screen;
     skoktrening('TRENING');
     show_skoki;
end;

Procedure ZerujTabelke;
var
   i : integer;
begin
     for i:=1 to 72-graczy do begin
      tabela[i].imie:=z^[i].imie;
      tabela[i].kraj:=z^[i].kraj;
      tabela[i].pun:=0;
      tabela[i].pkt:=0;
     end;
     For i:=1 to graczy do
      begin
       tabela[73-i].imie:=imie[i];
       tabela[73-i].kraj:=kraj[i];
       tabela[73-i].pun:=0;
       tabela[73-i].pkt:=0;
      end;
end;

Procedure Skoki;
var x,y,opcja:integer;
    quit:boolean;
begin
     show_skoki;
     crt.delay(200);
     opcja:=1;
     quit:=false;
     repeat
       rectangle2(100,80+(15*(opcja-1)),217,95+(15*(opcja-1)),17);
       movebuf2screen2;
       rectangle2(100,80+(15*(opcja-1)),217,95+(15*(opcja-1)),255);
       if keydown[72] and (opcja>1) then begin opcja:=opcja-1; crt.delay(100);end;
       if keydown[80] and (opcja<4) then begin opcja:=opcja+1; crt.delay(100);end;
       if keydown[entscan] and(opcja=4) then quit:=true;
       if keydown[entscan] and(opcja=3) then trening;
       if keydown[entscan] and(opcja=2) then begin ZerujTabelke; PS; show_skoki; end;
       if keydown[entscan] and(opcja=1) then begin ZerujTabelke; GPLata; show_skoki; end;
     until quit;
     bar;
     movebuf2screen;
     loadraw1('gfx\menu.raw');
     showlogo(1,1);
     outtextxyfnt1(108,23,getpixel1(97,20),4,versja,'data\licznik.fn2',norm);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=252 then putpixel1(x,y,245);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=11 then putpixel1(x,y,242);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=17 then putpixel1(x,y,14);
     setcol(11,40,40,0);
     setcol(252,55,55,0);
     setcol(17,0,0,63);
     centertextfnt1(160,80,11,7,'SKOKI','data\small.fn2',bold);
     centertextfnt1(159,81,252,7,'SKOKI','data\small.fn2',bold);
     centertextfnt1(160,95,11,7,'REKORDY','data\small.fn2',bold);
     centertextfnt1(159,96,252,7,'REKORDY','data\small.fn2',bold);
     centertextfnt1(160,110,11,7,'OPCJE','data\small.fn2',bold);
     centertextfnt1(159,111,252,7,'OPCJE','data\small.fn2',bold);
     centertextfnt1(160,125,11,7,'WYJ—CIE','data\small.fn2',bold);
     centertextfnt1(159,126,252,7,'WYJ—CIE','data\small.fn2',bold);
     centertextfnt1(51,191,11,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     centertextfnt1(50,190,252,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     crt.delay(200);
end;

Procedure Rekordy;
var x,y,opcja:integer;
    quit:boolean;
    i : integer;
procedure reset_rec;

Procedure Save(nr,k,r:word;st,kr,rek:string;re:real);
begin
     s__^[nr].k:=k;
     s__^[nr].rec:=r;
     s__^[nr].name:=st;
     s__^[nr].kraj:=kr;
     s__^[nr].reko:=rek;
     s__^[nr].gr:=re;
end;

begin
     assign(f__,'data\skocznie.dat');
     rewrite(f__);
     save(1,105,1,'Stams','Austria','',0.25);
     save(2,90,1,'Villach','Austria','',0.3);
     save(3,120,1,'Bischofshofen','Austria','',0.25);
     save(4,110,1,'Innsbruck','Austria','',0.25);
     save(5,120,1,'Kuopio','Finlandia','',0.25);
     save(6,116,1,'Lahti','Finlandia','',0.275);
     save(7,120,1,'Courchevel','Francja','',0.25);
     save(8,95,1,'Hinterzarten','Niemcy','',0.3);
     save(9,120,1,'Neustadt','Niemcy','',0.25);
     save(10,115,1,'Oberstdorf','Niemcy','',0.275);
     save(11,115,1,'Garmisch-Part.','Niemcy','',0.275);
     save(12,120,1,'Willingen','Niemcy','',0.25);
     save(13,120,1,'Predazzo','Wˆochy','',0.25);
     save(14,120,1,'Hakuba','Japonia','',0.25);
     save(15,120,1,'Sapporo','Japonia','',0.25);
     save(16,180,1,'Harrachov','Czechy','',0.2);
     save(17,120,1,'Trondheim','Norwegia','',0.25);
     save(18,115,1,'Oslo','Norwegia','',0.275);
     save(19,120,1,'Zakopane','Polska','',0.25);
     save(20,185,1,'Planica','Sˆowenia','',0.2);
     save(21,120,1,'Engelberg','Szwajcaria','',0.25);
     save(22,115,1,'Falun','Szwecja','',0.275);
     save(23,90,1,'Salt Lake City','U.S.A.','',0.3);
     save(24,120,1,'Salt Lake City','U.S.A.','',0.25);
     save(25,350,1,'Himalaje','Nepal','',0.12);
     save(26,30,1,'Toruä','Polska','',0.25);
     write(f__,s__^);
     close(f__);
end;

procedure show_rec;
var
   i :integer;
begin
     bar2(59,34,261,180,252);
     bar2(60,35,260,179,11);
     assign(f__,'data\skocznie.dat');
     reset(f__);
     read(f__,s__^);
     close(f__);
     for i:= 1 to 24 do outtextxyfnt2(61,30+i*6,252,4,s__^[i].name+' K'+num2str(s__^[i].k)+
     ' - '+real2str22(s__^[i].rec/3)+' - '+s__^[i].reko,'data\licznik.fn2',norm);
end;

begin
     bar;
     movebuf2screen;
     crt.delay(200);
     loadraw1('gfx\menu.raw');
     showlogo(1,1);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=252 then putpixel1(x,y,245);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=11 then putpixel1(x,y,242);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=17 then putpixel1(x,y,14);
     setcol(11,40,40,0);
     setcol(252,55,55,0);
     setcol(17,0,0,63);
     centertextfnt1(28,165,11,7,'RESET','data\small.fn2',bold);
     centertextfnt1(27,166,252,7,'RESET','data\small.fn2',bold);
     centertextfnt1(28,180,11,7,'POWRàT','data\small.fn2',bold);
     centertextfnt1(27,181,252,7,'POWRàT','data\small.fn2',bold);
     show_rec;
     movebuf2screen2;
     opcja:=1;
     repeat
           rectangle2(3,180+(15*(opcja-1)),50,195+(15*(opcja-1)),17);
           movebuf2screen2;
           rectangle2(3,180+(15*(opcja-1)),50,195+(15*(opcja-1)),255);
           if keydown[upscan] and (opcja>0) then opcja:=opcja-1;
           if keydown[downscan] and (opcja<1) then opcja:=opcja+1;
           if (opcja=0) and keydown[entscan] then begin reset_rec; show_rec; end;
     until (opcja=1) and keydown[entscan];
     bar;
     movebuf2screen;
     loadraw1('gfx\menu.raw');
     showlogo(1,1);
     outtextxyfnt1(108,23,getpixel1(97,20),4,versja,'data\licznik.fn2',norm);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=252 then putpixel1(x,y,245);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=11 then putpixel1(x,y,242);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=17 then putpixel1(x,y,14);
     setcol(11,40,40,0);
     setcol(252,55,55,0);
     setcol(17,0,0,63);
     centertextfnt1(160,80,11,7,'SKOKI','data\small.fn2',bold);
     centertextfnt1(159,81,252,7,'SKOKI','data\small.fn2',bold);
     centertextfnt1(160,95,11,7,'REKORDY','data\small.fn2',bold);
     centertextfnt1(159,96,252,7,'REKORDY','data\small.fn2',bold);
     centertextfnt1(160,110,11,7,'OPCJE','data\small.fn2',bold);
     centertextfnt1(159,111,252,7,'OPCJE','data\small.fn2',bold);
     centertextfnt1(160,125,11,7,'WYJ—CIE','data\small.fn2',bold);
     centertextfnt1(159,126,252,7,'WYJ—CIE','data\small.fn2',bold);
     centertextfnt1(51,191,11,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     centertextfnt1(50,190,252,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     crt.delay(200);
end;

{************** SHINE ***********************}
const MaxRow=25;MaxColumn=80;
var Buffer:array[1..MaxRow] of byte;
    XTable:array[1..MaxRow] of shortint;
procedure Init_XTable;
var cnt:byte;
begin for cnt:=0 to MaxRow-1 do XTable[cnt+1]:=-cnt; end;
procedure Shine(sx,sy,ex,ey:integer;c:byte);
var x,y:integer;
    num,cnt:word;
begin
 cnt:=0;
 for x:=sx to ex+ey-sy do
 begin
  for y:=sy to ey do
   if (XTable[y-sy+1]+x > sx-1) and (XTable[y-sy+1]+x < ex+1) then
   begin
    num:=(y-1)*160+(XTable[y-sy+1]+(x-1))*2+1;
    Buffer[y]:=mem[$b800:num];                    {save background attr.}
    mem[$b800:num]:=c+Buffer[y] and 240;          {highlight the spot}
   end;
  asm
   mov dx,3dah;
   @r1: in al,dx; test al,8; jnz @r1
   @r2: in al,dx; test al,8; jz @r2
  end;
 for y:=sy to ey do
  if (XTable[y-sy+1]+x > sx-1) and (XTable[y-sy+1]+x < ex+1) then
  begin                                           {restore background attr.}
   mem[$b800:(y-1)*160+(XTable[y-sy+1]+(x-1))*2+1]:=Buffer[y];
  end;
 end;
end;
{*************************************************************************}

Procedure Menu;
var x,y,opcja:integer;
    quit:boolean;
begin
     bar;
     loadraw1('gfx\menu.raw');
     showlogo(1,1);
     outtextxyfnt1(108,23,getpixel1(97,20),4,versja,'data\licznik.fn2',norm);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=252 then putpixel1(x,y,245);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=11 then putpixel1(x,y,242);
     for x:=0 to 319 do for y:=0 to 199 do if getpixel1(x,y)=17 then putpixel1(x,y,14);
     setcol(11,40,40,0);
     setcol(252,55,55,0);
     setcol(17,0,0,63);
     centertextfnt1(160,80,11,7,'SKOKI','data\small.fn2',bold);
     centertextfnt1(159,81,252,7,'SKOKI','data\small.fn2',bold);
     centertextfnt1(160,95,11,7,'REKORDY','data\small.fn2',bold);
     centertextfnt1(159,96,252,7,'REKORDY','data\small.fn2',bold);
     centertextfnt1(160,110,11,7,'OPCJE','data\small.fn2',bold);
     centertextfnt1(159,111,252,7,'OPCJE','data\small.fn2',bold);
     centertextfnt1(160,125,11,7,'WYJ—CIE','data\small.fn2',bold);
     centertextfnt1(159,126,252,7,'WYJ—CIE','data\small.fn2',bold);
     centertextfnt1(51,191,11,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     centertextfnt1(50,190,252,4,'HTTP://WWW.GGATE.PRV.PL','data\licznik.fn2',norm);
     opcja:=1;
     quit:=false;
     repeat
       rectangle2(120,80+(15*(opcja-1)),195,95+(15*(opcja-1)),17);
       movebuf2screen2;
       rectangle2(120,80+(15*(opcja-1)),195,95+(15*(opcja-1)),255);
       if keydown[72] and (opcja>1) then begin opcja:=opcja-1; crt.delay(100);end;
       if keydown[80] and (opcja<4) then begin opcja:=opcja+1; crt.delay(100);end;
       if keydown[entscan] and(opcja=4) then quit:=true;
       if keydown[entscan] and(opcja=3) then Opcje;
       if keydown[entscan] and(opcja=2) then Rekordy;
       if keydown[entscan] and(opcja=1) then Skoki;
     until quit;
     setoldkeyint;
     dispose(s__);
     dispose(z);
     close13h;
     Init_XTable;
     Writeln;
     Writeln;
     Writeln;
     Writeln;Textcolor(8);
   Writeln('                 +***********************************************+');
   Writeln('                 *°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°*');
   Write('                 *°                ');textcolor(14);write('SKI JUMP '+versja);
   textcolor(8);writeln('                 °*');
   Write('                 *°    ');textcolor(1);write(' ÄÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÄ     ');
   textcolor(8);writeln('°*');
   Writeln('                 *°                 wykonanie                   °*');
   Writeln('                 *°                                             °*');
   Write('                 *°             -=');textcolor(14);write(' GOLDEN GATE ');
   textcolor(8);writeln('=-               °*');
   Writeln('                 *°                                             °*');
   Writeln('                 *°                   czyli                     °*');
   Write('                 *°       ');
   textcolor(7);write('Tomasz Fidos i Michaˆ Rygielski');textcolor(8);writeln('       °*');
   Writeln('                 *°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°*');
   Write('                 *°             ');textcolor(7);write('http://ggate.prv.pl');
   textcolor(8);writeln('             °*');
   Writeln('                 *°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°*');
   Writeln('                 *° tfidos@poczta.onet.pl - Tomasz Fidos        °*');
   Writeln('                 *° regi007@poczta.onet.pl - Michaˆ Rygielski   °*');
   Writeln('                 *°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°*');
   Writeln('                 +***********************************************+');
     asm
       mov cx,0f00h
       mov ah,1
       int 10h
     end;
     Shine(18,5,65,21,15);
     asm
       mov ah,1
       mov cx,0607h
       int 10h
     end;
     halt;
end;



var i,nr,jumper:byte;
    ch:char;
    p_ : tpaleta;

begin
     new(s__);
     new(z);
     start_game;
     init13h;
     getpal(p_);
     flagaANI;
     movebuf2screen;
     setpal(p_);
     initnewkeyint;
     for i:=1 to 30 do setcol(199+i,i*2,i*2,i*2);
     for i:=0 to 10 do setcol(240+i,0,i*2+20,0);
     for i:=1 to 10 do setcol(230+i,0,i*2+40,0);
     setcol(231,0,40,0);
     setcol(232,0,33,0);
     setcol(255,0,63,63);
     savepaltofile('data\ski.pal');

     assign(f,'data\imiona.dat');
     reset(f);
     read(f,z^);
     close(f);
     assign(f__,'data\skocznie.dat');
     reset(f__);
     read(f__,s__^);
     close(f__);
     {PRZYGOTOWANIA DO KONKURSU}
     for i:=1 to 72 do begin
      tabela[i].imie:=z^[i].imie;
      tabela[i].kraj:=z^[i].kraj;
      tabela[i].pun:=0;
      tabela[i].pkt:=0;
     end;


     assign(ff,'data\opcje.dat');
     reset(ff,1);
     blockread(ff,graczy,sizeof(graczy));
     blockread(ff,imie,sizeof(imie));
     blockread(ff,kraj,sizeof(kraj));
     blockread(ff,detale,1);
     close(ff);
     For i:=1 to graczy do
      begin
       tabela[73-i].imie:=imie[i];
       tabela[73-i].kraj:=kraj[i];
       tabela[73-i].pun:=0;
       tabela[73-i].pkt:=0;
      end;

     Menu;


     close13h;
     setoldkeyint;
     dispose(s__);
     dispose(z);
end.