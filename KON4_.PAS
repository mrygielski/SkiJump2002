uses fgraphb,f13h,games,dos;

type
    tab = array[1..3000] of integer;
    Tfun = array[1..3000] of record y:integer; typ:byte; end;
    Tkolory = record
                    narty,nogi,tulow,rece,kask: byte;
              end;
    sko=record
                k:word;
                rec:real;
                name,kraj:string[20];
                reko:string[50];
                gr:real;
               end;
    tskocznia=array[1..25] of sko;

    zaw=record
               imie:string[20];
               kraj:string[10];
               AI:shortint;
               end;
    tzaw=array[1..72] of zaw;
    zaw2=record imie:string[20];kraj:string[20];pun:real;pkt:word;end;
    Tflaga=array[1..12,1..9] of byte;
    TFlagi=array[1..14] of tflaga;


    Stoper_ =
            Object
                  StH    :Word;
                  StM    :Word;
                  StS    :Word;
                  StHund :Word;
                  Procedure Start;
                  Function Stop : Longint;
            End;

Procedure Stoper_.Start;
Begin
     GetTime(StH, StM, StS, StHund);
End;

Function Stoper_.Stop : Longint;

Var
   H, M, S, Hund : Word;

Begin
     GetTime(H, M, S, Hund);
     Stop:=((H-StH)*60*60)+((M-StM)*60)+((S-StS));
End;

procedure palety;
begin
     {red}
     setcol(142,10,0,0);setcol(141,15,0,0);setcol(140,20,0,0);
     setcol(139,25,0,0);setcol(138,30,0,0);setcol(137,35,0,0);
     setcol(136,40,0,0);setcol(135,45,0,0);setcol(134,50,0,0);
     setcol(133,55,0,0);
     {yellow}
     setcol(162,10,10,0);setcol(161,15,15,0);setcol(160,20,20,0);
     setcol(159,25,25,0);setcol(158,30,30,0);setcol(157,35,35,0);
     setcol(156,40,40,0);setcol(155,45,45,0);setcol(154,50,50,0);
     setcol(153,55,55,0);
     {green}
     setcol(172,0,5,0);setcol(171,0,10,0);setcol(170,0,15,0);
     setcol(169,0,20,0);setcol(168,0,25,0);setcol(167,0,30,0);
     setcol(166,0,35,0);setcol(165,0,40,0);setcol(164,0,45,0);
     setcol(163,0,50,0);
     {lightgreen}
     setcol(152,0,5,0);setcol(151,0,7,0);setcol(150,0,9,0);
     setcol(149,0,11,0);setcol(148,0,13,0);setcol(147,0,15,0);
     setcol(146,0,17,0);setcol(145,0,19,0);setcol(144,0,21,0);
     setcol(143,0,23,0);
end;

procedure lampa(nr : byte);
var
   i : integer;
begin
     for i:= 1 to 10 do
     begin
          if nr=1 then
          begin
               circle1(20,20,i,i+132);
               circle1(20,20+1,i,i+132);
          end;
          if nr=2 then
          begin
          circle1(20,45,i,162+i);
          circle1(20,45+1,i,162+i);
          end;
          if nr=3 then
          begin
               circle1(20,20,i,i+152);
               circle1(20,20+1,i,i+152);
          end;
          if nr=4 then
          begin
          circle1(20,45,i,142+i);
          circle1(20,45+1,i,142+i);
          end;
     end;
end;

procedure swiatla;
begin
     palety;
     bar1(5,5,35,60,7);
     circle1(20,20,11,23);
     circle1(20,45,11,23);
     circle1(20,21,11,23);
     circle1(20,46,11,23);
     lampa(3);lampa(2);
     line1(36,5,36,61,23);
     line1(5,61,36,61,23);
end;

Var
   Flagi:^TFlagi;
   WIATR_ : real;
   Pokaz_komp: boolean;
   Skoczek: byte;
   NR_Skoczni: byte;
   IGIELIT: boolean;
   Komp_rec: boolean;
   gracz_rec : boolean;
   Imie,kraj: string;
   Stare_imie: string;
   f:file of tzaw;
   z:tzaw;
   skocznia: ^tab;
   trees: ^tfun;
   f__:file of tskocznia;
   s__:^tskocznia;

   tabela: array[1..72] of zaw2;


Function Skok_Random:real; forward;


Function Skok_Komp: real;
var
   old:string;
   wyjsc:boolean;
   poziom:shortint;
   imie,kraj:string;
   PUNKT_K: word;
   ZJAZD:word;
   GRAVITACJA:real;

   mela:boolean;
   mex,mey:integer;
   tree: array[1..20,1..30] of byte;
   fun: array[1..10,1..15,1..12] of byte;
   kolory:tkolory;
   i,j:integer;
   k:real;
   odleglosc,odl,odl2:integer;
   wysokosc: integer;
   y,y2:integer;
   yr: real;
   zwy1, zwy2 : integer;
   FPSC:FPSCounter;
   limit:stoper_;
   FPS:Word;

   dyskfalifikacja,dalej:boolean;
   od : byte;
   K_Point : word; {punkt K}
   R_Point : word; {rekord}

   NartaX, NartaY: Array[1..2] of integer; {dwie narty}
   NartaX2, NartaY2: Array[1..2] of integer; {dwie narty}
   PlayerX, PlayerY: integer;
   Yn1,yn2:byte;

   Wybicie,Wyb2 : boolean;
   NaZiemi : boolean;
   LADOWANIE: boolean;
   Wypadek : boolean;

   narty: byte;
   nartyR: real;

   mx,my,mxx,myy,los:word;

   stabilnosc_lotu: real; {im mniej tym lepiej}
   wyskok : word; {ocena wybicia z progu im mniej tym lepiej}
   lado   : word;
   skok : real; {ile kurna se poleciaà metr¢w nie}
   Dlugosc_skoku: real;

   speed: real;
   del,rusz:word;

   noty : array[1..5] of real;
   nn:array[1..5] of byte;

   kskoczni: byte; {kolor skoczni}
   kziemi: byte; {kolor ziemi}
   kzjazd: byte; {kolor zjazdu}

   nota : real;
   punkt,kpunkt: real;
   wiatr: real;

Procedure LoadTREE;
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     assign(f,'gfx\tree');
     reset(f);
     for xx:=0 to 19 do
     for yy:=0 to 29 do
      begin
       read(f,b);
       tree[1+xx,1+yy]:=b;
      end;
     close(F);
end;

Procedure LoadFUN(nr:byte);
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     assign(f,'gfx\kibice\hum'+num2str(nr));
     reset(f);
     for xx:=0 to 14 do
     for yy:=0 to 11 do
      begin
       read(f,b);
       fun[nr,1+xx,1+yy]:=b;
      end;
     close(F);
end;

Procedure Flag1(x,y:integer;kraj:string);
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     assign(f,'gfx\flagi\'+kraj);
     reset(f);
     for xx:=1 to 34 do
     for yy:=1 to 18 do
      begin
       read(f,b);
       putpixel1(xx+x,yy+y,b);
      end;
     close(F);
end;

Procedure ShowTREE(X,Y:integer);
var xx,yy:integer;
    b:Byte;
begin
     for xx:=0 to 19 do
     for yy:=0 to 29 do
      begin
       b:=tree[xx+1,yy+1];
       if b<>31 then putpixel1(xx+x,yy+y,b);
      end;
end;

Procedure ShowFUN(X,Y,NR:integer);
var xx,yy:integer;
    b:Byte;
begin
     for xx:=0 to 14 do
     for yy:=0 to 11 do
      begin
       b:=fun[nr,xx+1,yy+1];
       if b<>255 then putpixel1(xx+x,yy+y,b);
      end;
end;

Procedure Rozsuwanie_nart(ile:byte);
begin
     dec(nartax[1],ile);
     dec(nartax[2],ile);
     inc(nartax2[1],ile);
     inc(nartax2[2],ile);
end;
Procedure zsuwanie_nart(ile:byte);
begin
     inc(nartax[1],ile);
     inc(nartax[2],ile);
     dec(nartax2[1],ile);
     dec(nartax2[2],ile);
end;
Procedure Rozloz_narty(ile:byte);
begin
     inc(nartay[2],ile);
     dec(nartay2[2],ile);
end;
Procedure zloz_narty(ile:byte);
begin
     dec(nartay[2],ile);
     inc(nartay2[2],ile);
end;


Procedure Rysuj_Narty(kolor:byte);
var y,a,x,x2,y2,a2:integer;
begin
{NOGA2}line1(nartax2[1]+160,nartay2[1]+100,nartax2[2]+160,nartay2[2]+100,kolory.narty);

     line1(nartax[1]+160,nartay[1]+100,nartax[2]+160,nartay[2]+100,kolory.narty);

     a:=nartay[2]-nartay[1];
     x:=a div 3;
     x:=x+100;
     a:=a div 3;
     a2:=nartay2[2]-nartay2[1];
     x2:=a2 div 3;
     x2:=x2+100;
     a2:=a2 div 3;
     if wybicie=false then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+164,nartay[1]+x-2,kolory.nogi);
      line1(nartax[1]+164,nartay[1]+x-2,nartax[1]+164,nartay[1]+x-3,kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+164,nartay[1]+x-3,nartax[1]+168,nartay[1]+x+a-4,kolory.tulow);
      {GùOWA}
      circle1(nartax[1]+168,nartay[1]+x+a-4,1,kolory.kask);
      {R®KA}
      line1(nartax[1]+167,nartay[1]+x+a-4,nartax[1]+163,nartay[1]+x-4,kolory.rece);
     end;
     if wybicie and (naziemi=false) and not ladowanie and not wypadek then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+165,nartay[1]+x-3+(narty div 3),kolory.nogi);
      line1(nartax[1]+165,nartay[1]+x-3+(narty div 3),nartax[1]+166,nartay[1]+x-3+(narty div 3),kolory.nogi);
      line1(nartax2[1]+163,nartay2[1]+x2,nartax2[1]+165,nartay2[1]+x2+(narty div 3),kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+166,nartay[1]+x-3+(narty div 3),nartax[1]+169,nartay[1]+x-3+(narty div 3),kolory.tulow);
      {R®KA}
      line1(nartax[1]+167,nartay[1]+x+a-3,nartax[1]+163,nartay[1]+x-3,kolory.rece);
      {GùOWA}
      circle1(nartax[1]+169,nartay[1]+x-3+(narty div 3),1,kolory.kask);
     end;
     if wybicie and ladowanie and not wypadek then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+163,nartay[1]+x-3+(narty div 3),kolory.nogi);
      line1(nartax[1]+163,nartay[1]+x-2+(narty div 3),nartax[1]+164,nartay[1]+x-3+(narty div 3),kolory.nogi);
      line1(nartax2[1]+163,nartay2[1]+x2,nartax[1]+164,nartay[1]+x-4+(narty div 3),kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+164,nartay[1]+x-4+(narty div 3),nartax[1]+165,nartay[1]+x-8+(narty div 3),kolory.tulow);
      {R®KA}
      line1(nartax[1]+165,nartay[1]+x-6+(narty div 3),nartax[1]+168,nartay[1]+x-4+(narty div 3),kolory.rece);
      line1(nartax[1]+165,nartay[1]+x-6+(narty div 3),nartax[1]+168,nartay[1]+x-7+(narty div 3),kolory.rece);
      {GùOWA}
      circle1(nartax[1]+165,nartay[1]+x-8+(narty div 3),1,kolory.kask);
     end;
     if wypadek then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+158,nartay[1]+x,kolory.nogi);
      line1(nartax2[1]+163,nartay2[1]+x2,nartax[1]+158,nartay2[1]+x2,kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+158,nartay2[1]+x2,nartax[1]+155,nartay2[1]+x2-1,kolory.tulow);
      {R®KA}
      line1(nartax[1]+155,nartay2[1]+x2-1,nartax[1]+158,nartay2[1]+x2+3,kolory.rece);
      line1(nartax[1]+155,nartay2[1]+x2-1,nartax[1]+159,nartay2[1]+x2-4,kolory.rece);
      {GùOWA}
      circle1(nartax[1]+155,nartay2[1]+x2-1,1,kolory.kask);
     end;
end;

Procedure Chowaj_Narty;
var y,a:integer;
begin
     bar1(145,100,170,120,1);
end;

Procedure Fizyka_gry;
var c1,c2:byte;
begin
     {ZJAZD PO ZJEZDZALNI :)}
     if (odleglosc+160>ZJAZD-10) then else begin
       nartay[1]:=yn1-105;
       nartay[2]:=yn2-104;
       nartay2[1]:=yn1-106;
       nartay2[2]:=yn2-105;
     end;
     if (naziemi) then begin
       nartay[1]:=yn1-100;
       nartay[2]:=yn2-100;
       nartay2[1]:=yn1-101;
       nartay2[2]:=yn2-101;
     end;

     {ODBICIE SIE}
      if wybicie=false then if odleglosc+159-poziom=zjazd-poziom then
      begin
       wybicie:=true;
       nartay[2]:=nartay[1]-1;
       nartay2[2]:=nartay2[1]-1;
       if odleglosc+161<=zjazd then begin wyskok:=(zjazd-(odleglosc+162));wyskok:=wyskok div 2 end else wyskok:=1;
       wyskok:=wyskok+(3-poziom);
       wyb2:=true;
      end;
     if odleglosc+161=zjazd then if (punkt_k>=100)and(punkt_k<=150)then yr:=yr+15 else yr:=yr+10;

     {PARABOLA LOTU}
     if not naziemi and not wypadek then begin
      if wybicie and (odleglosc+160>=zjazd)and(odleglosc+160<zjazd+(PUNKT_K shr 3)) then yr:=yr+(GRAVITACJA*4);
    if wybicie and (odleglosc+160>=zjazd+(PUNKT_K shr 3))and(odleglosc+160<zjazd+(PUNKT_K shr 1)) then yr:=yr+(GRAVITACJA*2);
      if wybicie and (odleglosc+160>=zjazd+(PUNKT_K shr 1))and(odleglosc+160<zjazd+(PUNKT_K)) then yr:=yr+(GRAVITACJA);
      if (odleglosc>zjazd-160) then yr:=yr-GRAVITACJA;
      if (odleglosc>zjazd-161)and(odleglosc<k_point-250) then yr:=yr-(WIATR / 50);
      if (odleglosc>zjazd-161)and(odleglosc<k_point-250)and(wybicie=true) then begin
       if (narty=0) then yr:=yr-(GRAVITACJA*0.5);
       if (narty=1) then yr:=yr-(GRAVITACJA*0.3);
       if (narty=2) then yr:=yr-(GRAVITACJA*0.15);
       if (narty=3) then yr:=yr+(GRAVITACJA*0.25);
       if (narty=4) then yr:=yr-(GRAVITACJA*0.15);
       if (narty=5) then yr:=yr-(GRAVITACJA*0.4);
      if ladowanie then if not naziemi then yr:=yr-(GRAVITACJA);
      end;
     end;

end;


procedure wybierz_skocznie;
var i,a,y:integer;
begin
     stare_imie:=z[skoczek].imie;

     punkt_k:=s__^[nr_skoczni].k;
     zjazd:=s__^[nr_skoczni].k*3;
     gravitacja:=s__^[nr_skoczni].gr;
     r_point:=zjazd+round(s__^[nr_skoczni].rec);
     k_point:=zjazd+(punkt_k*3);
     if punkt_k=30 then
      begin
     {K-30 (SUPER MAùA! - BONUSOWA SKOCZNIA)}
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i+34)/75)*150 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i-250)/100)*70)+230;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=70 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-80)/80)*80 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+260)/100)*90 )+180;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=90 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-135)/80)*80 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+240)/110)*90 )+180;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=95 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-150)/80)*80 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+240)/110)*90 )+180;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=105 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-90)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=115 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-115)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=116 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-115)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=110 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-100)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=120 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-130)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=180 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-120)/260)*200 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+370)/200)*100 )+310;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=185 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-130)/260)*200 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+370)/200)*100 )+310;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=350 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-130)/580)*1000 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+1100)/450)*300 )+1310;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     for i:=1 to 3000 do trees^[i].y:=0;
     for i:=1 to 3000 do trees^[i].typ:=0;
     for i:=1 to 3000 do if random(20)=1 then begin trees^[i].y:=skocznia^[i]+50+random(120);
                                                    trees^[i].typ:=255; end;
     a:=ZJAZD+round(PUNKT_K*3)+((random(3)-1)*50);
     for i:=a to 3000 do begin
      y:=skocznia^[i]+30+random(30);
      if trees^[i].y=0 then
      if random(2)=0 then
      begin
       trees^[i].y:=y;
       trees^[i].typ:=random(10)+1;
      end;
     end;
end;

Function Dl_skoku : string;
var a,b:word;
    r:real;
begin
     a:=trunc(skok);
     r:=skok-trunc(skok);
     r:=r*10;
     if r<5 then b:=0 else b:=5;
     dl_skoku:=num2str(a)+'.'+num2str(b);
     dlugosc_skoku:=a;
     if b=5 then dlugosc_skoku:=dlugosc_skoku+0.5;
end;

Function Ocena(oc:real) : string;
var a,b:word;
    rrr:real;
begin
     a:=trunc(oc);
     rrr:=oc-trunc(oc);
     rrr:=rrr*10;
     if rrr<5 then b:=0 else b:=5;
     ocena:=num2str(a)+'.'+num2str(b);
end;

Function Nota_ : string;
var a,b:integer;
    r:real;
begin
     a:=trunc(nota);
     r:=nota-a;
     r:=r*10;
     b:=round(r);
     if b<0 then b:=-b;
     nota_:=num2str(a)+'.'+num2str(b);
     nota:=a+(b/10);
end;

Function Real_Str(re:real) : string;
var a,b:integer;
    r:real;
begin
     a:=trunc(re);
     r:=re-a;
     r:=r*10;
     b:=round(r);
     b:=abs(b);
     if b>9 then b:=9;
     real_str:=num2str(abs(a))+'.'+num2str(b);
end;

Procedure Tabelka(y:byte);
var a:byte;
begin
     for a:=1 to 30 do
      line1(1,y+a-1,319,y+a-1,229-(a div 2));
     Flag1(0,y+10,'austria');
     Flag1(35,y+10,'poland');
     Flag1(70,y+10,'finland');
     Flag1(105,y+10,'germany');
     Flag1(140,y+10,'norway');
     line1(1,y,319,y,15);
     line1(1,y+29,319,y+29,15);
     line1(1,y+10,319,y+10,15);
     hline1(1,y,y+28,15);
     hline1(319,y,y+28,15);
     hline1(175,y,y+28,15);
     hline1(220,y,y+28,15);
     for a:=1 to 5 do hline1(a*35,y+10,y+28,15);
     outtextxyfnt1(5,y+3,230,4,'OCENY S®DZIOWSKIE','data\licznik.fn2',norm);
     outtextxyfnt1(180,y+3,230,4,'ODLEGùOóè','data\licznik.fn2',norm);
     outtextxyfnt1(292,y+3,230,4,'PUNKTY','data\licznik.fn2',norm);
     outtextxyfnt1(180,y+17,230,4,ocena(dlugosc_skoku),'data\licznik.fn2',norm);
end;

Function Real2Str2(re:real) : string;
var a,b:integer;
    r:real;
begin
     a:=trunc(re);
     r:=re-trunc(re);
     r:=r*10;
     if r<5 then b:=0 else b:=5;
     real2str2:=num2str(a)+'.'+num2str(b);
end;

Procedure Teren;
var i,sky2:integer;
begin
       if odleglosc>0 then odl:=odleglosc else odl:=0;
       if odleglosc<3000 then odl:=odleglosc else odl:=0;
       for i:=319 downto 1 do
        begin
         odl2:=i+odl;
         sky2:=skocznia^[odl2]+y2;
         if (odl2>=ZJAZD) then {RYSOWANIE ZIEMI}
          begin
           putpixel1(i,(sky2),4);
           hline1(i,(sky2)+1,(sky2)+28,kskoczni);
           putpixel1(i,(sky2)+29,4);
           hline1(i,(sky2)+30,199,kziemi);
           if i=154 then if not naziemi then if sky2+15<=110 then begin naziemi:=true;wybicie:=true;
              skok:=(odleglosc-zjazd+160)/3;
      if ladowanie then if komp_rec then
      if skok*3>s__^[nr_skoczni].rec then
      begin
      outtextxyfnt2(160-((length('pobity rekord')*4) div 2),30,15,4,'POBITY REKORD','data\licznik.fn2',norm);
      outtextxyfnt2(160-((length('STARY: '+s__^[nr_skoczni].reko+' '+real2str2(s__^[nr_skoczni].rec/3))*4) div 2),40,4,4,
                    'STARY: '+s__^[nr_skoczni].reko+' '+real2str2(s__^[nr_skoczni].rec/3),'data\licznik.fn2',norm);
      outtextxyfnt2(160-((length('NOWY: '+z[skoczek].imie+' '+real2str2(skok))*4) div 2),47,12,4,
      'NOWY: '+z[skoczek].imie+' '+real2str2(skok),'data\licznik.fn2',norm);
           old:=s__^[nr_skoczni].reko;
           s__^[nr_skoczni].rec:=skok*3;
           s__^[nr_skoczni].reko:=imie;
           assign(f__,'data\skocznie.dat');
           rewrite(f__);
           write(f__,s__^);
           close(f__);
      end;
              end;
           if i=160 then wysokosc:=(sky2+15)-113;
           if i=154 then yn1:=sky2+15;
           if i=164 then yn2:=sky2+15;
           if (odleglosc+150>zjazd)and(i=154) then{CIE„}
            begin
             line1(154,yn1,166,yn2+(narty div 3),8);
             line1(154,yn1,166,yn2-(narty div 2)-2,8);
             line1(154,yn1,165,yn2-1,8);
             circle1(165,yn2-1,1,8);
            end;
          end;
         if odl2<1 then begin
           hline1(i,(skocznia^[1]+y2)+40,199,kziemi);{PRZED SKOCZNI§}
         end;
         if (odl2=k_point)then hline1(i,(sky2)+1,(sky2)+28,12);
         if (odl2=r_point)then hline1(i,(sky2)+1,(sky2)+28,9);
         if (odl2<ZJAZD)and(odl2>0) then {RYSOWANIE ZJAZDU}
          begin
           hline1(i,(sky2)-5,(sky2),kzjazd);
           hline1(i,(sky2),(sky2)+10,25);
           hline1(i,(sky2)+11,(sky2)+20,27);
           hline1(i,(sky2)+21,(sky2)+30,28);
           hline1(i,(sky2)+31,(sky2)+40,29);
           hline1(i,(sky2)+40,199,kziemi);
           if i=154 then yn1:=sky2;
           if i=164 then yn2:=sky2;
          end;
        end;
end;

Procedure Pokaz_wiatr;
begin
     if random(rusz*100)=1 then if random(2)=0 then wiatr:=wiatr-0.1 else wiatr:=wiatr+0.1;
     if wiatr<wiatr_-2.5 then wiatr:=wiatr_-2.5;
     if wiatr>wiatr_+2.5 then wiatr:=wiatr_+2.5;
     bar1(295,5,315,25,7);
     line1(295,25,315,25,23);
     line1(315,5,315,25,23);
     if wiatr>0 then
      begin
        line1(300,13-2,310,13-2,15);
        line1(310,13-2,307,10-2,15);
        line1(310,13-2,307,16-2,15);
      end;
     if wiatr<0 then
      begin
        line1(300,13-2,310,13-2,15);
        line1(300,13-2,303,10-2,15);
        line1(300,13-2,303,16-2,15);
      end;
     outtextxyfnt1(300,18,15,4,real_str(wiatr),'data\licznik.fn2',norm);
end;

Procedure Show_trees;
var i:integer;
begin
     for i:=344 downto -17 do
      begin
       odl2:=i+odl;
       if odl2>0 then if trees^[odl2].y<>0 then
       if trees^[odl2].typ=255 then showtree(i,(trees^[odl2].y+y2));{DRZEWKO}
      end;
end;

Procedure Show_funs;
var i:integer;
begin
     if odleglosc+160<zjazd then exit;
     if odleglosc>k_point-300 then
     for i:=344 downto -17 do
      begin
       odl2:=i+odl;
       if odl2>0 then
        if (trees^[odl2].y<>0)and(trees^[odl2].typ<>255) then
        showfun(i,trees^[odl2].y+y2,trees^[odl2].typ);
      end;
end;

var mel:real;
Procedure Show_Mela;
begin
     mex:=mex+round(sin(mel/(pi*180)+mel)*3);
     mey:=mey+round(cos(mel/(pi*180)+mel)*3);
     mel:=mel-0.2;
     if getpixel1(mex,mey)=kzjazd then begin mela:=false;mex:=165;mey:=107;mel:=90; end;
     if mela then Putpixel1(mex,mey,7);
end;
Procedure Hide_Mela;
begin
     Putpixel1(mex,mey,1);
end;

begin
     mex:=165;mey:=107;mel:=90;
     wyjsc:=false;
     new(skocznia);
     new(trees);
     LOADTREE;
     LOADFUN(1);LOADFUN(3);LOADFUN(5);LOADFUN(7);LOADFUN(9);
     LOADFUN(2);LOADFUN(4);LOADFUN(6);LOADFUN(8);LOADFUN(10);
     if igielit then kskoczni:=231 else kskoczni:=15;
     if igielit then kziemi:=232 else kziemi:=30;
     if igielit then kzjazd:=231 else kzjazd:=30;
     randomize;
     wiatr:=wiatr_;

     wybierz_skocznie;
     imie:=z[skoczek].imie;
     kraj:=z[skoczek].kraj;
     poziom:=z[skoczek].ai;

     odleglosc:=-149;
     y2:=-skocznia^[1]+116;


     bar1(0,0,319,199,1);

     nartax[1]:=-6;  nartay[1]:=10;
     nartax[2]:=6;  nartay[2]:=10;
     nartax2[1]:=-6;  nartay2[1]:=8;
     nartax2[2]:=6;  nartay2[2]:=8;

     kolory.narty:=9;
     kolory.nogi:=12;
     kolory.tulow:=2;
     kolory.rece:=4;
     kolory.kask:=7;

     mousetrap(0,0,5,10);
     putmouse(0,5);
     myy:=5;

     rusz:=3;
     wybicie:=false;
     naziemi:=false;
     ladowanie:=false;
     wypadek:=false;
     wyb2:=false;

     wyskok:=0;

     yr:=y2;
     narty:=0;
     skok:=0;
     speed:=-20;
     del:=0;
     stabilnosc_lotu:=0;

     hline2(0,0,199,0);
     teren;
     Show_funs;
     Show_trees;
     fizyka_gry;
     rysuj_narty(0);
     movebuf2screen;
     mela:=false;
     randomize;
     outtextxyfnt2(160-((length(z[skoczek].imie)div 2)*4),10,15,4,z[skoczek].imie,'data\licznik.fn2',norm);
     swiatla;
     limit.start;
     od:=0;
     DYSKFALIFIKACJA:=false;
     DALEJ:=false;
     repeat
      hline2(0,0,199,0);
      teren;
      Show_funs;
      Show_trees;
      pokaz_wiatr;
      rysuj_narty(0);
      if mela then show_mela;
      if not mela and (random(200)=1) then mela:=true;
      if (random(200)=1) then dalej:=true;
      if limit.stop>=10 then od:=3;
      if limit.stop=10 then lampa(4);
      if limit.stop=11 then lampa(2);
      if limit.stop=12 then lampa(4);
      if limit.stop=13 then lampa(2);
      if limit.stop=14 then lampa(4);
      if limit.stop=15 then
      begin
           lampa(1);
           lampa(2);
           DYSKFALIFIKACJA:=true;
      end;
      outtextxyfnt1(31-od,6,23,4,num2str(limit.stop),'data\licznik.fn2',norm);
      movebuf2screen2;
      delay(10);
      hide_mela;
      bar1(27,5,35,11,7);
     until dalej or dyskfalifikacja;
     if dalej then bar1(5,5,36,61,1);
     if dyskfalifikacja then
     begin
          hline2(0,0,199,0);
          teren;
          Show_funs;
          Show_trees;
          pokaz_wiatr;
          rysuj_narty(0);
          outtextxyfnt1(31-od,6,23,4,num2str(limit.stop),'data\licznik.fn2',norm);
          outtextxyfnt2(160-((length('DYSKFALIFIKACJA')div 2)*4),98,12,4,'DYSKFALIFIKACJA','data\licznik.fn2',norm);
          movebuf2screen;
          delay(500);
     end;
     if not dyskfalifikacja then
     rusz:=1;
     fpsc.start;
     randomize;
     repeat
       fpsc.nextframe;
       fps:=fpsc.fps;

       teren;

       Show_funs;
       Show_trees;

       Fizyka_gry;

       wysokosc:=wysokosc div 3;

       outtextxyfnt1(3,3,12,4,num2str(fps)+' fps','data\licznik.fn2',norm);

       Rysuj_Narty(12);

       if wypadek or (ladowanie and naziemi) then tabelka(210-del);

       pokaz_wiatr;

       movebuf2screen2;

       Chowaj_Narty;

       outtextxyfnt1(3,3,1,4,num2str(fps)+' fps','data\licznik.fn2',norm);
       dl_skoku;

       odl2:=odl+320;
       for i:=319 downto 1 do
        begin
         odl2:=odl2-1;
         if odl2>0 then hline1(i,(skocznia^[odl2]+y2)-20,(skocznia^[odl2]+y2)+10,1);
        end;




       if not keydown[75] then
         begin
          inc(odleglosc,1);
          if skocznia^[odleglosc+159]<skocznia^[odleglosc+160]then yr:=yr-(skocznia^[odleglosc+160]-skocznia^[odleglosc+159]);
          if ladowanie or wypadek or naziemi then
           if skocznia^[odleglosc+159]>skocznia^[odleglosc+160]then yr:=yr+(skocznia^[odleglosc+159]-skocznia^[odleglosc+160]);
         end;

        if wybicie then
         if not ladowanie then
         if not wypadek then
          if wysokosc<(4-poziom) then
          if random((5-poziom)*3)<>1 then
          begin
           begin
            ladowanie:=true;
            nartay2[2]:=nartay2[1]-1;
            nartay[2]:=nartay[1]-1;
            rozsuwanie_nart(2);
            lado:=wysokosc;
            end;
          end;

       if keydown[80] then y2:=y2-1;
       if keydown[f1scan] then delay(15);
       if keydown[f2scan] then begin wiatr_:=wiatr_-0.1;wiatr:=wiatr_; end;
       if keydown[f3scan] then begin wiatr_:=wiatr_+0.1;wiatr:=wiatr_; end;
       if keydown[f4scan] then begin wiatr_:=0;wiatr:=wiatr_; end;


       if (myy=0)and(wybicie)and(narty>0) then
        begin
             myy:=5;
             zloz_narty(1);
             narty:=narty-1;
        end;
       if (myy=10)and(wybicie)and(narty<5) then
        begin
             myy:=5;
             rozloz_narty(1);
             narty:=narty+1;
        end;
       my:=random(3+abs(3-poziom))-1;
       if wybicie and (narty<3+my) then myy:=myy+1;
       if wybicie and (narty>3+my) then myy:=myy-1;

       y2:=round(yr);

       if not ladowanie and naziemi then begin WYPADEK:=true end;

       if wypadek or (ladowanie and naziemi) then
        begin
         speed:=speed+0.4;
         if speed>=1 then begin speed:=0;del:=del+1; end;
         delay(del);
         narty:=0;
        end;

        if keydown[1] then wyjsc:=true;

     until wyjsc or (del=40);

     if del=40 then begin {WYSTAWIANIE NOT S®DZIOWSKICH}
      if not wyjsc then begin
       teren;
       Show_funs;
       Show_trees;
       rysuj_narty(0);
       pokaz_wiatr;
       tabelka(170);
      end;
      for i:=1 to 5 do noty[i]:=0;
      noty[1]:=20-((lado*0.5)/2)-((stabilnosc_lotu*0.5)/4)-wyskok;{USTALANIE}
      if wypadek then noty[1]:=noty[1]-7;                 {PIERWSZEJ NOTY...}
      noty[2]:=noty[1]+(random(3)*0.5);               {LOSOWANIE POZOSTAùYCH}
      noty[3]:=noty[1]-(random(3)*0.5);
      noty[4]:=noty[1];
      noty[5]:=noty[1]+((random(3)*0.5)*(random(3)-1));
      noty[1]:=noty[5];
      for i:=1 to 5 do if noty[i]>20 then noty[i]:=20;
      for i:=1 to 5 do if noty[i]<0 then noty[i]:=random(5)*0.5;
      los:=0;
      nn[1]:=0;nn[2]:=0;nn[3]:=0;nn[4]:=0;nn[5]:=0;
      for j:=1 to 5 do
       for i:=1 to 4 do
        if noty[i]>noty[i+1] then
          begin
           k:=noty[i];
           noty[i]:=noty[i+1];
           noty[i+1]:=k;
          end;
      if noty[4]-noty[1]>2 then begin noty[4]:=noty[3]+0.5;bar2(0,10,10,20,7); end;
      if noty[5]-noty[1]>2.5 then begin noty[5]:=noty[4]+0.5;bar2(0,0,10,10,15); end;
      for i:=1 to 5 do if noty[i]>20 then noty[i]:=20;
      if not wyjsc then begin
      repeat
        if i in[1..5] then outtextxyfnt1(5+((i-1)*35),188,230,4,ocena(noty[i]),'data\licznik.fn2',norm);
        if i in[1..5] then los:=los+1;
        if i in[1..5] then nn[i]:=1;
        if i in[1..5] then i:=0;
        movebuf2screen2;
        if (nn[1]=0)or(nn[2]=0)or(nn[3]=0)or(nn[4]=0)or(nn[5]=0) then begin
         if random(250)=1 then repeat i:=random(5)+1; until nn[i]=0 end else los:=5;
      until los=5;
      end;
      movebuf2screen2;
      end;

      if not wyjsc then begin
       outtextxyfnt1(5+((2-1)*35),188,9,4,ocena(noty[2]),'data\licznik.fn2',norm);
       outtextxyfnt1(5+((3-1)*35),188,9,4,ocena(noty[3]),'data\licznik.fn2',norm);
       outtextxyfnt1(5+((4-1)*35),188,9,4,ocena(noty[4]),'data\licznik.fn2',norm);
      end;

      kpunkt:=60;
      if punkt_k>150 then kpunkt:=120;
      if punkt_k<100 then punkt:=2;
      if punkt_k>100 then punkt:=1.8;
      if punkt_k>150 then punkt:=1.2;
      punkt:=(dlugosc_skoku-punkt_k)*punkt;
      if not wyjsc then nota:=noty[2]+noty[3]+noty[4]+(kpunkt+punkt);
      if not wyjsc then outtextxyfnt1(315-(length(Nota_)*4),188,4,4,Nota_,'data\licznik.fn2',norm);
      skok_komp:=nota;
      movebuf2screen2;

      if wyjsc and not dyskfalifikacja then skok_komp:=Skok_random;


      if dyskfalifikacja then skok_komp:=0;


     dispose(skocznia);
     dispose(trees);
     wiatr_:=wiatr;
end;{KOMP KONIEC}



Function SkokHUM:real;

var
   PUNKT_K: word;
   ZJAZD:word;
   GRAVITACJA:real;
   f__:file of tskocznia;
   s__:tskocznia;

   mela:boolean;
   mex,mey:integer;
   tree: array[1..20,1..30] of byte;
   fun: array[1..10,1..15,1..12] of byte;
   skocznia: ^tab;
   trees: ^tfun;
   kolory:tkolory;
   i,j:integer;
   k:real;
   odleglosc,odl,odl2:integer;
   wysokosc: integer;
   y,y2:integer;
   yr: real;
   zwy1, zwy2 : integer;
   FPSC:FPSCounter;
   limit:stoper_;
   FPS:Word;

   od : byte;
   dyskfalifikacja, dalej : boolean;
   K_Point : word; {punkt K}
   R_Point : word; {rekord}

   NartaX, NartaY: Array[1..2] of integer; {dwie narty}
   NartaX2, NartaY2: Array[1..2] of integer; {dwie narty}
   PlayerX, PlayerY: integer;
   Yn1,yn2:byte;

   Wybicie,Wyb2 : boolean;
   NaZiemi : boolean;
   LADOWANIE: boolean;
   Wypadek : boolean;

   narty: shortint;
   nartyR: real;

   mx,my,los:word;

   stabilnosc_lotu: real; {im mniej tym lepiej}
   wyskok : word; {ocena wybicia z progu im mniej tym lepiej}
   lado   : word;
   skok : real; {ile kurna se poleciaà metr¢w nie}
   Dlugosc_skoku: real;

   speed: real;
   del,rusz:word;

   noty : array[1..5] of real;
   nn:array[1..5] of byte;

   kskoczni: byte; {kolor skoczni}
   kziemi: byte; {kolor ziemi}
   kzjazd: byte; {kolor zjazdu}

   nota : real;
   punkt,kpunkt: real;
   wiatr: real;

Procedure LoadTREE;
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     assign(f,'gfx\tree');
     reset(f);
     for xx:=0 to 19 do
     for yy:=0 to 29 do
      begin
       read(f,b);
       tree[1+xx,1+yy]:=b;
      end;
     close(F);
end;

Procedure Flag1(x,y:integer;kraj:string);
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     assign(f,'gfx\flagi\'+kraj);
     reset(f);
     for xx:=1 to 34 do
     for yy:=1 to 18 do
      begin
       read(f,b);
       putpixel1(xx+x,yy+y,b);
      end;
     close(F);
end;

Procedure LoadFUN(nr:byte);
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     assign(f,'gfx\kibice\hum'+num2str(nr));
     reset(f);
     for xx:=0 to 14 do
     for yy:=0 to 11 do
      begin
       read(f,b);
       fun[nr,1+xx,1+yy]:=b;
      end;
     close(F);
end;

Procedure ShowTREE(X,Y:integer);
var xx,yy:integer;
    b:Byte;
begin
     for xx:=0 to 19 do
     for yy:=0 to 29 do
      begin
       b:=tree[xx+1,yy+1];
       if b<>31 then putpixel1(xx+x,yy+y,b);
      end;
end;

Procedure ShowFUN(X,Y,NR:integer);
var xx,yy:integer;
    b:Byte;
begin
     for xx:=0 to 14 do
     for yy:=0 to 11 do
      begin
       b:=fun[nr,xx+1,yy+1];
       if b<>255 then putpixel1(xx+x,yy+y,b);
      end;
end;

Procedure Rozsuwanie_nart(ile:byte);
begin
     dec(nartax[1],ile);
     dec(nartax[2],ile);
     inc(nartax2[1],ile);
     inc(nartax2[2],ile);
end;
Procedure zsuwanie_nart(ile:byte);
begin
     inc(nartax[1],ile);
     inc(nartax[2],ile);
     dec(nartax2[1],ile);
     dec(nartax2[2],ile);
end;
Procedure Rozloz_narty(ile:byte);
begin
     inc(nartay[2],ile);
     dec(nartay2[2],ile);
end;
Procedure zloz_narty(ile:byte);
begin
     dec(nartay[2],ile);
     inc(nartay2[2],ile);
end;


Procedure Rysuj_Narty(kolor:byte);
var y,a,x,x2,y2,a2:integer;
    nartydiv3: integer;
begin
{NOGA2}line1(nartax2[1]+160,nartay2[1]+100,nartax2[2]+160,nartay2[2]+100,kolory.narty);

     line1(nartax[1]+160,nartay[1]+100,nartax[2]+160,nartay[2]+100,kolory.narty);

     a:=nartay[2]-nartay[1];
     x:=a div 3;
     x:=x+100;
     a:=a div 3;
     a2:=nartay2[2]-nartay2[1];
     x2:=a2 div 3;
     x2:=x2+100;
     a2:=a2 div 3;
     nartydiv3:=narty div 3;
     if wybicie=false then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+164,nartay[1]+x-2,kolory.nogi);
      line1(nartax[1]+164,nartay[1]+x-2,nartax[1]+164,nartay[1]+x-3,kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+164,nartay[1]+x-3,nartax[1]+168,nartay[1]+x+a-4,kolory.tulow);
      {GùOWA}
      circle1(nartax[1]+168,nartay[1]+x+a-4,1,kolory.kask);
      {R®KA}
      line1(nartax[1]+167,nartay[1]+x+a-4,nartax[1]+163,nartay[1]+x-4,kolory.rece);
     end;
     if wybicie and (naziemi=false) and not ladowanie and not wypadek then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+165,nartay[1]+x-3+(nartydiv3),kolory.nogi);
      line1(nartax[1]+165,nartay[1]+x-3+(nartydiv3),nartax[1]+166,nartay[1]+x-3+(nartydiv3),kolory.nogi);
      line1(nartax2[1]+163,nartay2[1]+x2,nartax2[1]+165,nartay2[1]+x2+(nartydiv3),kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+166,nartay[1]+x-3+(nartydiv3),nartax[1]+169,nartay[1]+x-3+(nartydiv3),kolory.tulow);
      {R®KA}
      line1(nartax[1]+167,nartay[1]+x+a-3,nartax[1]+163,nartay[1]+x-3,kolory.rece);
      {GùOWA}
      circle1(nartax[1]+169,nartay[1]+x-3+(nartydiv3),1,kolory.kask);
     end;
     if wybicie and ladowanie and not wypadek then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+163,nartay[1]+x-3+(nartydiv3),kolory.nogi);
      line1(nartax[1]+163,nartay[1]+x-2+(nartydiv3),nartax[1]+164,nartay[1]+x-3+(nartydiv3),kolory.nogi);
      line1(nartax2[1]+163,nartay2[1]+x2,nartax[1]+164,nartay[1]+x-4+(nartydiv3),kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+164,nartay[1]+x-4+(nartydiv3),nartax[1]+165,nartay[1]+x-8+(nartydiv3),kolory.tulow);
      {R®KA}
      line1(nartax[1]+165,nartay[1]+x-6+(nartydiv3),nartax[1]+168,nartay[1]+x-4+(nartydiv3),kolory.rece);
      line1(nartax[1]+165,nartay[1]+x-6+(nartydiv3),nartax[1]+168,nartay[1]+x-7+(nartydiv3),kolory.rece);
      {GùOWA}
      circle1(nartax[1]+165,nartay[1]+x-8+(nartydiv3),1,kolory.kask);
     end;
     if wypadek then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+158,nartay[1]+x,kolory.nogi);
      line1(nartax2[1]+163,nartay2[1]+x2,nartax[1]+158,nartay2[1]+x2,kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+158,nartay2[1]+x2,nartax[1]+155,nartay2[1]+x2-1,kolory.tulow);
      {R®KA}
      line1(nartax[1]+155,nartay2[1]+x2-1,nartax[1]+158,nartay2[1]+x2+3,kolory.rece);
      line1(nartax[1]+155,nartay2[1]+x2-1,nartax[1]+159,nartay2[1]+x2-4,kolory.rece);
      {GùOWA}
      circle1(nartax[1]+155,nartay2[1]+x2-1,1,kolory.kask);
     end;
end;

Procedure Chowaj_Narty;
var y,a:integer;
begin
     bar1(145,100,170,120,1);
end;

Procedure Fizyka_gry;
var c1,c2:byte;
begin
     {ZJAZD PO ZJEZDZALNI :)}
     if (odleglosc+160>ZJAZD-10) then else begin
       nartay[1]:=yn1-105;
       nartay[2]:=yn2-104;
       nartay2[1]:=yn1-106;
       nartay2[2]:=yn2-105;
     end;
     if (naziemi) then begin
       nartay[1]:=yn1-100;
       nartay[2]:=yn2-100;
       nartay2[1]:=yn1-101;
       nartay2[2]:=yn2-101;
     end;


     {ODBICIE SIE}
     if odleglosc+161>zjazd-25 then
      if wybicie=false then if button=1 then
      begin
       wybicie:=true;
       nartay[2]:=nartay[1]-1;
       nartay2[1]:=nartay[1]-1;
       nartay2[2]:=nartay2[1]-1;
       if odleglosc+161<=zjazd then begin wyskok:=(zjazd-(odleglosc+162));wyskok:=wyskok div 4 end else wyskok:=3;
       wyb2:=true;
       mousetrap(0,0,5,10);
       narty:=0;
      end;
     if odleglosc+161=zjazd then if (punkt_k>=100)and(punkt_k<=150)then yr:=yr+15 else yr:=yr+10;

     {PARABOLA LOTU}
     if not naziemi and not wypadek then begin
      if wybicie and (odleglosc+160>=zjazd)and(odleglosc+160<zjazd+(PUNKT_K shr 3)) then yr:=yr+(GRAVITACJA*4);
    if wybicie and (odleglosc+160>=zjazd+(PUNKT_K shr 3))and(odleglosc+160<zjazd+(PUNKT_K shr 1)) then yr:=yr+(GRAVITACJA*2);
      if wybicie and (odleglosc+160>=zjazd+(PUNKT_K shr 1))and(odleglosc+160<zjazd+(PUNKT_K)) then yr:=yr+(GRAVITACJA);
      if (odleglosc>zjazd-160) then yr:=yr-GRAVITACJA;
      if (odleglosc>zjazd-161)and(odleglosc<k_point-250) then yr:=yr-(WIATR / 50);
      if (odleglosc>zjazd-161)and(odleglosc<k_point-250)and(wybicie=true) then begin
       if (narty=0) then yr:=yr-(GRAVITACJA*0.5);
       if (narty=1) then yr:=yr-(GRAVITACJA*0.3);
       if (narty=2) then yr:=yr-(GRAVITACJA*0.15);
       if (narty=3) then yr:=yr+(GRAVITACJA*0.25);
       if (narty=4) then yr:=yr-(GRAVITACJA*0.15);
       if (narty=5) then yr:=yr-(GRAVITACJA*0.4);
      if ladowanie then if not naziemi then yr:=yr-(GRAVITACJA);
      end;
     end;

end;


procedure wybierz_skocznie;
var i,a,y:integer;
begin
     punkt_k:=s__[nr_skoczni].k;
     zjazd:=s__[nr_skoczni].k*3;
     gravitacja:=s__[nr_skoczni].gr;
     r_point:=zjazd+round(s__[nr_skoczni].rec);
     k_point:=zjazd+(punkt_k*3);
     if punkt_k=30 then
      begin
     {K-30 (SUPER MAùA! - BONUSOWA SKOCZNIA)}
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i+34)/75)*150 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i-250)/100)*70)+230;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=70 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-80)/80)*80 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+260)/100)*90 )+180;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=90 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-135)/80)*80 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+240)/110)*90 )+180;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=95 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-150)/80)*80 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+240)/110)*90 )+180;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=105 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-90)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=115 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-115)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=116 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-115)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=110 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-100)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=120 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-130)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=180 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-120)/260)*200 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+370)/200)*100 )+310;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=185 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-130)/260)*200 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+370)/200)*100 )+310;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=250 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i+2020)/350)*300 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i-1000)/1000)*3500 )+314+850;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
     end;
     if punkt_k=350 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-130)/580)*1000 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+1100)/450)*300 )+1310;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     for i:=1 to 3000 do trees^[i].y:=0;
     for i:=1 to 3000 do trees^[i].typ:=0;
     for i:=1 to 3000 do if random(20)=1 then begin trees^[i].y:=skocznia^[i]+50+random(120);
                                                    trees^[i].typ:=255; end;
     a:=ZJAZD+round(PUNKT_K*3)+((random(3)-1)*50);
     for i:=a to 3000 do begin
      y:=skocznia^[i]+30+random(30);
      if trees^[i].y=0 then
      if random(2)=0 then
      begin
       trees^[i].y:=y;
       trees^[i].typ:=random(10)+1;
      end;
     end;
end;

Function Dl_skoku : string;
var a,b:word;
    r:real;
begin
     a:=trunc(skok);
     r:=skok-trunc(skok);
     r:=r*10;
     if r<5 then b:=0 else b:=5;
     dl_skoku:=num2str(a)+'.'+num2str(b);
     dlugosc_skoku:=a;
     if b=5 then dlugosc_skoku:=dlugosc_skoku+0.5;
end;

Function Ocena(oc:real) : string;
var a,b:word;
    r:real;
begin
     a:=trunc(oc);
     r:=oc-trunc(oc);
     r:=r*10;
     if r<5 then b:=0 else b:=5;
     ocena:=num2str(a)+'.'+num2str(b);
end;

Function Nota_ : string;
var a,b:integer;
    r:real;
begin
     a:=trunc(nota);
     r:=nota-a;
     r:=r*10;
     b:=round(r);
     if b<0 then b:=-b;
     nota_:=num2str(a)+'.'+num2str(b);
     nota:=a+(b/10);
end;

Function Real_Str(re:real) : string;
var a,b:integer;
    r:real;
begin
     a:=trunc(re);
     r:=re-a;
     r:=r*10;
     b:=round(r);
     b:=abs(b);
     if b>9 then b:=9;
     real_str:=num2str(abs(a))+'.'+num2str(b);
end;

Procedure Tabelka(y:byte);
var a:byte;
begin
     for a:=1 to 30 do
      line1(1,y+a-1,319,y+a-1,229-(a div 2));
     Flag1(0,y+10,'austria');
     Flag1(35,y+10,'poland');
     Flag1(70,y+10,'finland');
     Flag1(105,y+10,'germany');
     Flag1(140,y+10,'norway');
     line1(1,y,319,y,15);
     line1(1,y+29,319,y+29,15);
     line1(1,y+10,319,y+10,15);
     hline1(1,y,y+28,15);
     hline1(319,y,y+28,15);
     hline1(175,y,y+28,15);
     hline1(220,y,y+28,15);
     for a:=1 to 5 do hline1(a*35,y+10,y+28,15);
     outtextxyfnt1(5,y+3,230,4,'OCENY S®DZIOWSKIE','data\licznik.fn2',norm);
     outtextxyfnt1(180,y+3,230,4,'ODLEGùOóè','data\licznik.fn2',norm);
     outtextxyfnt1(292,y+3,230,4,'PUNKTY','data\licznik.fn2',norm);
     outtextxyfnt1(180,y+17,230,4,ocena(dlugosc_skoku),'data\licznik.fn2',norm);
end;

Function Real2Str(Number : Real; Ile : byte) : String;
Var Tekst : String;
Begin
     Str(Number:2:Ile,Tekst);
     Real2str:=Tekst;
End;

Function Real2Str2(re:real) : string;
var a,b:integer;
    r:real;
begin
     a:=trunc(re);
     r:=re-trunc(re);
     r:=r*10;
     if r<5 then b:=0 else b:=5;
     real2str2:=num2str(a)+'.'+num2str(b);
end;

Procedure Teren;
var i,sky2:integer;
begin
       if odleglosc>0 then odl:=odleglosc else odl:=0;
       if odleglosc<3000 then odl:=odleglosc else odl:=0;
       for i:=319 downto 1 do
        begin
         odl2:=i+odl;
         sky2:=skocznia^[odl2]+y2;
         if (odl2>=ZJAZD) then {RYSOWANIE ZIEMI}
          begin
           putpixel1(i,(sky2),4);
           hline1(i,(sky2)+1,(sky2)+28,kskoczni);
           putpixel1(i,(sky2)+29,4);
           hline1(i,(sky2)+30,199,kziemi);
           if i=154 then if not naziemi then if sky2+15<=110 then begin naziemi:=true;wybicie:=true;
              skok:=(odleglosc-zjazd+160)/3;
      if ladowanie then if gracz_rec then
      if skok*3>s__[nr_skoczni].rec then
      begin
      outtextxyfnt2(160-((length('pobity rekord')*4) div 2),30,15,4,'POBITY REKORD','data\licznik.fn2',norm);
      outtextxyfnt2(160-((length('STARY: '+s__[nr_skoczni].reko+' '+real2str2(s__[nr_skoczni].rec/3))*4) div 2),40,4,4,
                    'STARY: '+s__[nr_skoczni].reko+' '+real2str2(s__[nr_skoczni].rec/3),'data\licznik.fn2',norm);
      outtextxyfnt2(160-((length('NOWY: '+imie+' '+real2str2(skok))*4) div 2),47,12,4,'NOWY: '+imie+' '+real2str2(skok),
                    'data\licznik.fn2',norm);
           s__[nr_skoczni].rec:=skok*3;
           s__[nr_skoczni].reko:=imie;
           assign(f__,'data\skocznie.dat');
           rewrite(f__);
           write(f__,s__);
           close(f__)
      end;

              end;
           if i=160 then wysokosc:=(sky2+15)-113;
           if i=154 then yn1:=sky2+15;
           if i=164 then yn2:=sky2+15;
           if (odleglosc+150>zjazd)and(i=154) then{CIE„}
            begin
             line1(154,yn1,166,yn2+(narty div 3),8);
             line1(154,yn1,166,yn2-(narty div 2)-2,8);
             line1(154,yn1,165,yn2-1,8);
             circle1(165,yn2-1,1,8)
            end
          end;
         if odl2<1 then hline1(i,(skocznia^[1]+y2)+40,199,kziemi);
         if (odl2=k_point)then hline1(i,(sky2)+1,(sky2)+28,12);
         if (odl2=r_point)then hline1(i,(sky2)+1,(sky2)+28,9);
         if (odl2<ZJAZD)and(odl2>0) then {RYSOWANIE ZJAZDU}
          begin
           hline1(i,(sky2)-5,(sky2),kzjazd);
           hline1(i,(sky2),(sky2)+10,25);
           hline1(i,(sky2)+11,(sky2)+20,27);
           hline1(i,(sky2)+21,(sky2)+30,28);
           hline1(i,(sky2)+31,(sky2)+40,29);
           hline1(i,(sky2)+40,199,kziemi);
           if i=154 then yn1:=sky2;
           if i=164 then yn2:=sky2
          end
        end;
end;

Procedure Pokaz_wiatr;
begin
     if random(rusz*100)=1 then if random(2)=0 then wiatr:=wiatr-0.1 else wiatr:=wiatr+0.1;
     if wiatr<wiatr_-2.5 then wiatr:=wiatr_-2.5;
     if wiatr>wiatr_+2.5 then wiatr:=wiatr_+2.5;
     bar1(295,5,315,25,7);
     line1(295,25,315,25,23);
     line1(315,5,315,25,23);
     if wiatr>0 then
      begin
        line1(300,13-2,310,13-2,15);
        line1(310,13-2,307,10-2,15);
        line1(310,13-2,307,16-2,15);
      end;
     if wiatr<0 then
      begin
        line1(300,13-2,310,13-2,15);
        line1(300,13-2,303,10-2,15);
        line1(300,13-2,303,16-2,15);
      end;
     outtextxyfnt1(300,18,15,4,real_str(wiatr),'data\licznik.fn2',norm);
end;

Procedure Show_trees;
var i:integer;
begin
     for i:=344 downto -17 do
      begin
       odl2:=i+odl;
       if odl2>0 then if trees^[odl2].y<>0 then
       if trees^[odl2].typ=255 then showtree(i,(trees^[odl2].y+y2));{DRZEWKO}
      end;
end;

Procedure Show_funs;
var i:integer;
begin
     if odleglosc+160<zjazd then exit;
     if odleglosc>k_point-300 then
     for i:=344 downto -17 do
      begin
       odl2:=i+odl;
       if odl2>0 then
        if (trees^[odl2].y<>0)and(trees^[odl2].typ<>255) then
        showfun(i,trees^[odl2].y+y2,trees^[odl2].typ);
      end;
end;

var mel:real;
Procedure Show_Mela;
begin
     mex:=mex+round(sin(mel/(pi*180)+mel)*3);
     mey:=mey+round(cos(mel/(pi*180)+mel)*3);
     mel:=mel-0.2;
     if getpixel1(mex,mey)=kzjazd then begin mela:=false;mex:=165;mey:=107;mel:=90; end;
     if mela then Putpixel1(mex,mey,7);
end;
Procedure Hide_Mela;
begin
     Putpixel1(mex,mey,1);
end;


begin
     mex:=165;mey:=107;mel:=90;
     new(skocznia);
     new(trees);
     LOADTREE;
     LOADFUN(1);LOADFUN(3);LOADFUN(5);LOADFUN(7);LOADFUN(9);
     LOADFUN(2);LOADFUN(4);LOADFUN(6);LOADFUN(8);LOADFUN(10);
     if igielit then kskoczni:=231 else kskoczni:=15;
     if igielit then kziemi:=232 else kziemi:=30;
     if igielit then kzjazd:=231 else kzjazd:=30;
     randomize;
     wiatr:=wiatr_;

     wybierz_skocznie;

     odleglosc:=-149;
     y2:=-skocznia^[1]+116;


     bar1(0,0,319,199,1);

     nartax[1]:=-6;  nartay[1]:=10;
     nartax[2]:=6;  nartay[2]:=10;
     nartax2[1]:=-6;  nartay2[1]:=8;
     nartax2[2]:=6;  nartay2[2]:=8;

     kolory.narty:=9;
     kolory.nogi:=12;
     kolory.tulow:=2;
     kolory.rece:=4;
     kolory.kask:=7;

     mousetrap(0,4,5,6);
     putmouse(0,5);

     rusz:=3;
     wybicie:=false;
     naziemi:=false;
     ladowanie:=false;
     wypadek:=false;
     wyb2:=false;

     wyskok:=0;

     yr:=y2;
     narty:=0;
     skok:=0;
     speed:=-20;
     del:=0;
     stabilnosc_lotu:=0;

     hline2(0,0,199,0);
     teren;
     Show_funs;
     Show_trees;
     fizyka_gry;
     rysuj_narty(0);
     movebuf2screen;
     mela:=false;
     outtextxyfnt2(160-((length(imie)div 2)*4),10,15,4,imie,'data\licznik.fn2',norm);
     swiatla;
     limit.start;
     od:=0;
     DYSKFALIFIKACJA:=false;
     DALEJ:=false;
     repeat
      hline2(0,0,199,0);
      teren;
      Show_funs;
      Show_trees;
      pokaz_wiatr;
      rysuj_narty(0);
      if mela then show_mela;
      if not mela and (button=1) then mela:=true;
      if limit.stop>=10 then od:=3;
      if limit.stop=10 then lampa(4);
      if limit.stop=11 then lampa(2);
      if limit.stop=12 then lampa(4);
      if limit.stop=13 then lampa(2);
      if limit.stop=14 then lampa(4);
      if limit.stop=15 then
      begin
           lampa(1);
           lampa(2);
           DYSKFALIFIKACJA:=true;
      end;
      outtextxyfnt1(31-od,6,23,4,num2str(limit.stop),'data\licznik.fn2',norm);
      movebuf2screen2;
      delay(10);
      hide_mela;
      bar1(27,5,35,11,7);
      if button=2 then dalej:=true;
     until dalej or keydown[1] or dyskfalifikacja;
     if dalej then bar1(5,5,36,61,1);
     if dyskfalifikacja then
     begin
          hline2(0,0,199,0);
          teren;
          Show_funs;
          Show_trees;
          pokaz_wiatr;
          rysuj_narty(0);
          outtextxyfnt1(31-od,6,23,4,num2str(limit.stop),'data\licznik.fn2',norm);
          outtextxyfnt2(160-((length('DYSKFALIFIKACJA')div 2)*4),98,12,4,'DYSKFALIFIKACJA','data\licznik.fn2',norm);
          movebuf2screen;
          delay(500);
     end;
     if not dyskfalifikacja then
     rusz:=1;
     fpsc.start;
     randomize;
     repeat
       fpsc.nextframe;
       fps:=fpsc.fps;

       mx:=mousex;
       my:=mousey;

       Teren;

       Show_funs;
       Show_trees;

       Fizyka_gry;

       wysokosc:=wysokosc div 3;

       outtextxyfnt1(3,3,12,4,num2str(fps)+' fps','data\licznik.fn2',norm);

       Rysuj_Narty(12);

       if wypadek or (ladowanie and naziemi) then tabelka(210-del);

       pokaz_wiatr;

       movebuf2screen2;

       Chowaj_Narty;

       outtextxyfnt1(3,3,1,4,num2str(fps)+' fps','data\licznik.fn2',norm);
       dl_skoku;

       odl2:=odl+320;
       for i:=319 downto 1 do
        begin
         odl2:=odl2-1;
         if odl2>0 then hline1(i,(skocznia^[odl2]+y2)-20,(skocznia^[odl2]+y2)+10,1)
        end;




       if not keydown[75] then
         begin
          inc(odleglosc,1);
          if skocznia^[odleglosc+159]<skocznia^[odleglosc+160]then yr:=yr-(skocznia^[odleglosc+160]-skocznia^[odleglosc+159]);
          if ladowanie or wypadek or naziemi then
           if skocznia^[odleglosc+159]>skocznia^[odleglosc+160]then yr:=yr+(skocznia^[odleglosc+159]-skocznia^[odleglosc+160])
         end;

       if button=2 then
        if wybicie then
         if not ladowanie then
         if not wypadek then
          begin
           if wysokosc<8 then begin
           ladowanie:=true;
           nartay2[2]:=nartay2[1]-1;
           nartay[2]:=nartay[1]-1;
           rozsuwanie_nart(2);
           lado:=wysokosc
           end
          end;

       if keydown[80] then y2:=y2-1;
       if keydown[f1scan] then delay(15);
       if keydown[f2scan] then begin wiatr_:=wiatr_-0.1;wiatr:=wiatr_ end;
       if keydown[f3scan] then begin wiatr_:=wiatr_+0.1;wiatr:=wiatr_ end;


       if (my=0)and(wybicie)and(narty>0)and(odleglosc+166>zjazd) then
        begin
             putmouse(0,5);
             zloz_narty(1);
             narty:=narty-1;
             stabilnosc_lotu:=stabilnosc_lotu+0.5
        end;
       if (my=10)and(wybicie)and(narty<5)and(odleglosc+166>zjazd) then
        begin
             putmouse(0,5);
             rozloz_narty(1);
             narty:=narty+1;
             stabilnosc_lotu:=stabilnosc_lotu+0.5
        end;

       if wiatr<0 then if random(300-round(20*wiatr))=0 then putmouse(mx,10);
       if wiatr>0 then if random(300-round(20*wiatr))=0 then putmouse(mx,0);

       y2:=round(yr);

       if not ladowanie and naziemi then begin WYPADEK:=true end;

       if wypadek or (ladowanie and naziemi) then
        begin
         speed:=speed+0.4;
         if speed>=1 then begin speed:=0;del:=del+1 end;
         delay(del);
         narty:=0
        end

     until keydown[1] or (del=40);

     if del=40 then begin {WYSTAWIANIE NOT S®DZIOWSKICH}
      teren;
      Show_funs;
      Show_trees;
      rysuj_narty(0);
      pokaz_wiatr;
      tabelka(170);
      {lado - wys. ladowania}
      {stabilnosc_lotu}
      {wyskok - im mniej tym lepiej}
      for i:=1 to 5 do noty[i]:=0;
      noty[1]:=20-((lado*0.5)/2)-((stabilnosc_lotu*0.5)/8)-wyskok;{USTALANIE}
      if wypadek then noty[1]:=noty[1]-7;                 {PIERWSZEJ NOTY...}
      noty[2]:=noty[1]+(random(3)*0.5);               {LOSOWANIE POZOSTAùYCH}
      noty[3]:=noty[1]-(random(3)*0.5);
      noty[4]:=noty[2];
      noty[5]:=noty[1]+((random(3)*0.5)*(random(3)-1));
      for i:=1 to 5 do if noty[i]>20 then noty[i]:=20;
      for i:=1 to 5 do if noty[i]<0 then noty[i]:=random(5)*0.5;
      los:=0;
      nn[1]:=0;nn[2]:=0;nn[3]:=0;nn[4]:=0;nn[5]:=0;
      for j:=1 to 4 do
       for i:=1 to 4 do
        if noty[i]>noty[i+1] then
          begin
           k:=noty[i];
           noty[i]:=noty[i+1];
           noty[i+1]:=k;
          end;
      if noty[4]-noty[1]>2 then begin noty[4]:=noty[3]+0.5; end;
      if noty[5]-noty[1]>1.5 then begin noty[5]:=noty[4]; end;
      for i:=1 to 5 do if noty[i]>20 then noty[i]:=20;
      repeat
        if i in[1..5] then outtextxyfnt1(5+((i-1)*35),188,230,4,ocena(noty[i]),'data\licznik.fn2',norm);
        if i in[1..5] then los:=los+1;
        if i in[1..5] then nn[i]:=1;
        if i in[1..5] then i:=0;
        movebuf2screen2;
        if (nn[1]=0)or(nn[2]=0)or(nn[3]=0)or(nn[4]=0)or(nn[5]=0) then begin
         if random(250)=1 then repeat i:=random(5)+1; until nn[i]=0 end else los:=5;
      until los=5;
      movebuf2screen2;
      end;
      outtextxyfnt1(5+((2-1)*35),188,9,4,ocena(noty[2]),'data\licznik.fn2',norm);
      outtextxyfnt1(5+((3-1)*35),188,9,4,ocena(noty[3]),'data\licznik.fn2',norm);
      outtextxyfnt1(5+((4-1)*35),188,9,4,ocena(noty[4]),'data\licznik.fn2',norm);
      kpunkt:=60;
      if punkt_k>150 then kpunkt:=120;
      if punkt_k<100 then punkt:=2;
      if punkt_k>100 then punkt:=1.8;
      if punkt_k>150 then punkt:=1.2;
      punkt:=(dlugosc_skoku-punkt_k)*punkt;
      nota:=noty[2]+noty[3]+noty[4]+(kpunkt+punkt);
      outtextxyfnt1(315-(length(Nota_)*4),188,4,4,Nota_,'data\licznik.fn2',norm);
     outtextxyfnt2(160-((length(imie)div 2)*4),10,255,4,imie,'data\licznik.fn2',norm);
     movebuf2screen2;
     if del=40 then repeat until (button=1);
     nota_;
     skokHUM:=0;
     if (del=40) and not dyskfalifikacja then skokHUM:=nota;
     movebuf2screen2;
     dispose(skocznia);
     dispose(trees);
     wiatr_:=wiatr;
end;{ZAWODNIK KONIEC}


Function Skok_Random: real;

var
   poziom:shortint;
   imie,kraj:string;
   PUNKT_K: word;
   ZJAZD:word;
   GRAVITACJA:real;
   f__:file of tskocznia;
   s__:^tskocznia;

   mela:boolean;
   mex,mey:integer;
   tree: array[1..20,1..30] of byte;
   fun: array[1..10,1..15,1..12] of byte;
   skocznia: ^tab;
   trees: ^tfun;
   kolory:tkolory;
   i,j:integer;
   k:real;
   odleglosc,odl,odl2:integer;
   wysokosc: integer;
   y,y2:integer;
   yr: real;
   zwy1, zwy2 : integer;
   FPSC:FPSCounter;
   FPS:Word;

   K_Point : word; {punkt K}
   R_Point : word; {rekord}

   NartaX, NartaY: Array[1..2] of integer; {dwie narty}
   NartaX2, NartaY2: Array[1..2] of integer; {dwie narty}
   PlayerX, PlayerY: integer;
   Yn1,yn2:byte;

   Wybicie,Wyb2 : boolean;
   NaZiemi : boolean;
   LADOWANIE: boolean;
   Wypadek : boolean;

   narty: byte;
   nartyR: real;

   mx,my,mxx,myy,los:word;

   stabilnosc_lotu: real; {im mniej tym lepiej}
   wyskok : word; {ocena wybicia z progu im mniej tym lepiej}
   lado   : word;
   skok : real; {ile kurna se poleciaà metr¢w nie}
   Dlugosc_skoku: real;

   speed: real;
   del,rusz:word;

   noty : array[1..5] of real;
   nn:array[1..5] of byte;

   kskoczni: byte; {kolor skoczni}
   kziemi: byte; {kolor ziemi}
   kzjazd: byte; {kolor zjazdu}

   nota : real;
   punkt,kpunkt: real;
   wiatr: real;


Procedure Rozsuwanie_nart(ile:byte);
begin
     dec(nartax[1],ile);
     dec(nartax[2],ile);
     inc(nartax2[1],ile);
     inc(nartax2[2],ile);
end;
Procedure zsuwanie_nart(ile:byte);
begin
     inc(nartax[1],ile);
     inc(nartax[2],ile);
     dec(nartax2[1],ile);
     dec(nartax2[2],ile);
end;
Procedure Rozloz_narty(ile:byte);
begin
     inc(nartay[2],ile);
     dec(nartay2[2],ile);
end;
Procedure zloz_narty(ile:byte);
begin
     dec(nartay[2],ile);
     inc(nartay2[2],ile);
end;


Procedure Rysuj_Narty(kolor:byte);
var y,a,x,x2,y2,a2:integer;
begin
{NOGA2}line1(nartax2[1]+160,nartay2[1]+100,nartax2[2]+160,nartay2[2]+100,kolory.narty);

     line1(nartax[1]+160,nartay[1]+100,nartax[2]+160,nartay[2]+100,kolory.narty);

     a:=nartay[2]-nartay[1];
     x:=a div 3;
     x:=x+100;
     a:=a div 3;
     a2:=nartay2[2]-nartay2[1];
     x2:=a2 div 3;
     x2:=x2+100;
     a2:=a2 div 3;
     if wybicie=false then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+164,nartay[1]+x-2,kolory.nogi);
      line1(nartax[1]+164,nartay[1]+x-2,nartax[1]+164,nartay[1]+x-3,kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+164,nartay[1]+x-3,nartax[1]+168,nartay[1]+x+a-4,kolory.tulow);
      {GùOWA}
      circle1(nartax[1]+168,nartay[1]+x+a-4,1,kolory.kask);
      {R®KA}
      line1(nartax[1]+167,nartay[1]+x+a-4,nartax[1]+163,nartay[1]+x-4,kolory.rece);
     end;
     if wybicie and (naziemi=false) and not ladowanie and not wypadek then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+165,nartay[1]+x-3+(narty div 3),kolory.nogi);
      line1(nartax[1]+165,nartay[1]+x-3+(narty div 3),nartax[1]+166,nartay[1]+x-3+(narty div 3),kolory.nogi);
      line1(nartax2[1]+163,nartay2[1]+x2,nartax2[1]+165,nartay2[1]+x2+(narty div 3),kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+166,nartay[1]+x-3+(narty div 3),nartax[1]+169,nartay[1]+x-3+(narty div 3),kolory.tulow);
      {R®KA}
      line1(nartax[1]+167,nartay[1]+x+a-3,nartax[1]+163,nartay[1]+x-3,kolory.rece);
      {GùOWA}
      circle1(nartax[1]+169,nartay[1]+x-3+(narty div 3),1,kolory.kask);
     end;
     if wybicie and ladowanie and not wypadek then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+163,nartay[1]+x-3+(narty div 3),kolory.nogi);
      line1(nartax[1]+163,nartay[1]+x-2+(narty div 3),nartax[1]+164,nartay[1]+x-3+(narty div 3),kolory.nogi);
      line1(nartax2[1]+163,nartay2[1]+x2,nartax[1]+164,nartay[1]+x-4+(narty div 3),kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+164,nartay[1]+x-4+(narty div 3),nartax[1]+165,nartay[1]+x-8+(narty div 3),kolory.tulow);
      {R®KA}
      line1(nartax[1]+165,nartay[1]+x-6+(narty div 3),nartax[1]+168,nartay[1]+x-4+(narty div 3),kolory.rece);
      line1(nartax[1]+165,nartay[1]+x-6+(narty div 3),nartax[1]+168,nartay[1]+x-7+(narty div 3),kolory.rece);
      {GùOWA}
      circle1(nartax[1]+165,nartay[1]+x-8+(narty div 3),1,kolory.kask);
     end;
     if wypadek then begin
      {NOGI}
      line1(nartax[1]+163,nartay[1]+x,nartax[1]+158,nartay[1]+x,kolory.nogi);
      line1(nartax2[1]+163,nartay2[1]+x2,nartax[1]+158,nartay2[1]+x2,kolory.nogi);
      {TUù‡W}
      line1(nartax[1]+158,nartay2[1]+x2,nartax[1]+155,nartay2[1]+x2-1,kolory.tulow);
      {R®KA}
      line1(nartax[1]+155,nartay2[1]+x2-1,nartax[1]+158,nartay2[1]+x2+3,kolory.rece);
      line1(nartax[1]+155,nartay2[1]+x2-1,nartax[1]+159,nartay2[1]+x2-4,kolory.rece);
      {GùOWA}
      circle1(nartax[1]+155,nartay2[1]+x2-1,1,kolory.kask);
     end;
end;

Procedure Chowaj_Narty;
var y,a:integer;
begin
     bar1(145,100,170,120,1);
end;

Procedure Fizyka_gry;
var c1,c2:byte;
begin
     {ZJAZD PO ZJEZDZALNI :)}
     if (odleglosc+160>ZJAZD-10) then else begin
       nartay[1]:=yn1-105;
       nartay[2]:=yn2-104;
       nartay2[1]:=yn1-106;
       nartay2[2]:=yn2-105;
     end;
     if (naziemi) then begin
       nartay[1]:=yn1-100;
       nartay[2]:=yn2-100;
       nartay2[1]:=yn1-101;
       nartay2[2]:=yn2-101;
     end;

     {ODBICIE SIE}
      if wybicie=false then if odleglosc+159-poziom=zjazd-poziom then
      begin
       wybicie:=true;
       nartay[2]:=nartay[1]-1;
       nartay2[2]:=nartay2[1]-1;
       if odleglosc+161<=zjazd then begin wyskok:=(zjazd-(odleglosc+162));wyskok:=wyskok div 2 end else wyskok:=1;
       wyskok:=wyskok+(3-poziom);
       wyb2:=true;
      end;
     if odleglosc+161=zjazd then if (punkt_k>=100)and(punkt_k<=150)then yr:=yr+15 else yr:=yr+10;

     {PARABOLA LOTU}
     if not naziemi and not wypadek then begin
      if wybicie and (odleglosc+160>=zjazd)and(odleglosc+160<zjazd+(PUNKT_K shr 3)) then yr:=yr+(GRAVITACJA*4);
    if wybicie and (odleglosc+160>=zjazd+(PUNKT_K shr 3))and(odleglosc+160<zjazd+(PUNKT_K shr 1)) then yr:=yr+(GRAVITACJA*2);
      if wybicie and (odleglosc+160>=zjazd+(PUNKT_K shr 1))and(odleglosc+160<zjazd+(PUNKT_K)) then yr:=yr+(GRAVITACJA);
      if (odleglosc>zjazd-160) then yr:=yr-GRAVITACJA;
      if (odleglosc>zjazd-161)and(odleglosc<k_point-250) then yr:=yr-(WIATR / 50);
      if (odleglosc>zjazd-161)and(odleglosc<k_point-250)and(wybicie=true) then begin
       if (narty=0) then yr:=yr-(GRAVITACJA*0.5);
       if (narty=1) then yr:=yr-(GRAVITACJA*0.3);
       if (narty=2) then yr:=yr-(GRAVITACJA*0.15);
       if (narty=3) then yr:=yr+(GRAVITACJA*0.25);
       if (narty=4) then yr:=yr-(GRAVITACJA*0.15);
       if (narty=5) then yr:=yr-(GRAVITACJA*0.4);
      if ladowanie then if not naziemi then yr:=yr-(GRAVITACJA);
      end;
     end;

end;


procedure wybierz_skocznie;
var i,a,y:integer;
begin
     punkt_k:=s__^[nr_skoczni].k;
     zjazd:=s__^[nr_skoczni].k*3;
     gravitacja:=s__^[nr_skoczni].gr;
     r_point:=zjazd+round(s__^[nr_skoczni].rec);
     k_point:=zjazd+(punkt_k*3);
     if punkt_k=30 then
      begin
     {K-30 (SUPER MAùA! - BONUSOWA SKOCZNIA)}
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i+34)/75)*150 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i-250)/100)*70)+230;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=70 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-80)/80)*80 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+260)/100)*90 )+180;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=90 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-135)/80)*80 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+240)/110)*90 )+180;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=95 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-150)/80)*80 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+240)/110)*90 )+180;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=105 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-90)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=115 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-115)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=116 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-115)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=110 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-100)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=120 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-130)/140)*100 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+450)/170)*80 )+192;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=180 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-120)/260)*200 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+370)/200)*100 )+310;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=185 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-130)/260)*200 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+370)/200)*100 )+310;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     if punkt_k=350 then
      begin
     for i:=20 to ZJAZD do skocznia^[i]:=round( sin((i-130)/580)*1000 );
     for i:=ZJAZD to 3000 do skocznia^[i]:=round( sin((i+1100)/450)*300 )+1310;
     for i:=1 to 20 do skocznia^[i]:=skocznia^[20];
      end;
     for i:=1 to 3000 do trees^[i].y:=0;
     for i:=1 to 3000 do trees^[i].typ:=0;
     for i:=1 to 3000 do if random(20)=1 then begin trees^[i].y:=skocznia^[i]+50+random(120);
                                                    trees^[i].typ:=255; end;
     a:=ZJAZD+round(PUNKT_K*3)+((random(3)-1)*50);
     for i:=a to 3000 do begin
      y:=skocznia^[i]+30+random(30);
      if trees^[i].y=0 then
      if random(2)=0 then
      begin
       trees^[i].y:=y;
       trees^[i].typ:=random(10)+1;
      end;
     end;
end;

Function Dl_skoku : string;
var a,b:word;
    r:real;
begin
     a:=trunc(skok);
     r:=skok-trunc(skok);
     r:=r*10;
     if r<5 then b:=0 else b:=5;
     dl_skoku:=num2str(a)+'.'+num2str(b);
     dlugosc_skoku:=a;
     if b=5 then dlugosc_skoku:=dlugosc_skoku+0.5;
end;

Function Ocena(oc:real) : string;
var a,b:word;
    r:real;
begin
     a:=trunc(oc);
     r:=oc-trunc(oc);
     r:=r*10;
     if r<5 then b:=0 else b:=5;
     ocena:=num2str(a)+'.'+num2str(b);
end;

Function Nota_ : string;
var a,b:integer;
    r:real;
begin
     a:=trunc(nota);
     r:=nota-a;
     r:=r*10;
     b:=round(r);
     if b<0 then b:=-b;
     nota_:=num2str(a)+'.'+num2str(b);
     nota:=a+(b/10);
end;

Function Real_Str(re:real) : string;
var a,b:integer;
    r:real;
begin
     a:=trunc(re);
     r:=re-a;
     r:=r*10;
     b:=round(r);
     b:=abs(b);
     if b>9 then b:=9;
     real_str:=num2str(abs(a))+'.'+num2str(b);
end;


Function Real2Str2(re:real) : string;
var a,b:integer;
    r:real;
begin
     a:=trunc(re);
     r:=re-trunc(re);
     r:=r*10;
     if r<5 then b:=0 else b:=5;
     real2str2:=num2str(a)+'.'+num2str(b);
end;

Procedure Teren;
var i,sky2:integer;
begin
       if odleglosc>0 then odl:=odleglosc else odl:=0;
       if odleglosc<3000 then odl:=odleglosc else odl:=0;
       for i:=164 downto 154 do
        begin
         odl2:=i+odl;
         sky2:=skocznia^[odl2]+y2;
         if (odl2>=ZJAZD) then {RYSOWANIE ZIEMI}
          begin
           if i=154 then if not naziemi then if sky2+15<=110 then begin naziemi:=true;wybicie:=true;
              skok:=(odleglosc-zjazd+160)/3;
      if ladowanie then if komp_rec then
      if skok*3>s__^[nr_skoczni].rec then
      begin
           s__^[nr_skoczni].rec:=skok*3;
           s__^[nr_skoczni].reko:=imie;
           assign(f__,'data\skocznie.dat');
           rewrite(f__);
           write(f__,s__^);
           close(f__);
      end;
              end;
           if i=160 then wysokosc:=(sky2+15)-113;
           if i=154 then yn1:=sky2+15;
           if i=164 then yn2:=sky2+15;
          end;
         if (odl2<ZJAZD)and(odl2>0) then {RYSOWANIE ZJAZDU}
          begin
           if i=154 then yn1:=sky2;
           if i=164 then yn2:=sky2;
          end;
        end;
end;

Procedure Pokaz_wiatr;
begin
     if random(rusz*100)=1 then
     if random(2)=0 then wiatr:=wiatr-0.1 else wiatr:=wiatr+0.1;
     if wiatr<wiatr_-2.5 then wiatr:=wiatr_-2.5;
     if wiatr>wiatr_+2.5 then wiatr:=wiatr_+2.5;
end;



begin
     mex:=165;mey:=107;
     new(skocznia);
     new(trees);
     if igielit then kskoczni:=231 else kskoczni:=15;
     if igielit then kziemi:=232 else kziemi:=30;
     if igielit then kzjazd:=231 else kzjazd:=30;
     randomize;

     wiatr:=wiatr_;

     wybierz_skocznie;
     imie:=z[skoczek].imie;
     kraj:=z[skoczek].kraj;
     poziom:=z[skoczek].ai;

     odleglosc:=-149;
     y2:=-skocznia^[1]+116;


     bar1(0,0,319,199,1);

     nartax[1]:=-6;  nartay[1]:=10;
     nartax[2]:=6;  nartay[2]:=10;
     nartax2[1]:=-6;  nartay2[1]:=8;
     nartax2[2]:=6;  nartay2[2]:=8;

     kolory.narty:=9;
     kolory.nogi:=12;
     kolory.tulow:=2;
     kolory.rece:=4;
     kolory.kask:=7;

     mousetrap(0,0,5,10);
     putmouse(0,5);
     myy:=5;

     rusz:=3;
     wybicie:=false;
     naziemi:=false;
     ladowanie:=false;
     wypadek:=false;
     wyb2:=false;

     wyskok:=0;

     yr:=y2;
     narty:=0;
     skok:=0;
     speed:=-20;
     del:=0;
     stabilnosc_lotu:=0;
     mela:=false;
     randomize;
     rusz:=1;
     repeat

       teren;
       Fizyka_gry;
       wysokosc:=wysokosc div 3;

       pokaz_wiatr;

       dl_skoku;

       odl2:=odl+320;
          inc(odleglosc,1);
          if skocznia^[odleglosc+159]<skocznia^[odleglosc+160]then yr:=yr-(skocznia^[odleglosc+160]-skocznia^[odleglosc+159]);
          if ladowanie or wypadek or naziemi then
           if skocznia^[odleglosc+159]>skocznia^[odleglosc+160]then yr:=yr+(skocznia^[odleglosc+159]-skocznia^[odleglosc+160]);

        if wybicie then
         if not ladowanie then
         if not wypadek then
          if wysokosc<(4-poziom) then
          if random((5-poziom)*3)<>1 then
          begin
           begin
            ladowanie:=true;
            nartay2[2]:=nartay2[1]-1;
            nartay[2]:=nartay[1]-1;
            rozsuwanie_nart(2);
            lado:=wysokosc;
            end;
          end;

       if (myy=0)and(wybicie)and(narty>0) then
        begin
             myy:=5;
             zloz_narty(1);
             narty:=narty-1;
        end;
       if (myy=10)and(wybicie)and(narty<5) then
        begin
             myy:=5;
             rozloz_narty(1);
             narty:=narty+1;
        end;
       my:=random(3+abs(3-poziom))-1;
       if wybicie and (narty<3+my) then myy:=myy+1;
       if wybicie and (narty>3+my) then myy:=myy-1;

       y2:=round(yr);

       if not ladowanie and naziemi then begin WYPADEK:=true;end;

       if wypadek or (ladowanie and naziemi) then
        begin
         speed:=speed+0.4;
         if speed>=1 then begin speed:=0;del:=del+1; end;
         narty:=0;
        end;


     until (del=1);

     if del<>0 then begin {WYSTAWIANIE NOT S®DZIOWSKICH}
       teren;
       pokaz_wiatr;
      for i:=1 to 5 do noty[i]:=0;
      noty[1]:=20-((lado*0.5)/2)-((stabilnosc_lotu*0.5)/4)-wyskok;{USTALANIE}
      if wypadek then noty[1]:=noty[1]-7;                 {PIERWSZEJ NOTY...}
      noty[2]:=noty[1]+(random(3)*0.5);               {LOSOWANIE POZOSTAùYCH}
      noty[3]:=noty[1]-(random(3)*0.5);
      noty[4]:=noty[1];
      noty[5]:=noty[1]+((random(3)*0.5)*(random(3)-1));
      noty[1]:=noty[5];
      for i:=1 to 5 do if noty[i]>20 then noty[i]:=20;
      for i:=1 to 5 do if noty[i]<0 then noty[i]:=random(5)*0.5;
      los:=0;
      nn[1]:=0;nn[2]:=0;nn[3]:=0;nn[4]:=0;nn[5]:=0;
      for j:=1 to 5 do
       for i:=1 to 4 do
        if noty[i]>noty[i+1] then
          begin
           k:=noty[i];
           noty[i]:=noty[i+1];
           noty[i+1]:=k;
          end;
      if noty[4]-noty[1]>2 then begin noty[4]:=noty[3]+0.5;end;
      if noty[5]-noty[1]>2.5 then begin noty[5]:=noty[4]+0.5;end;
      for i:=1 to 5 do if noty[i]>20 then noty[i]:=20;
      repeat
        if i in[1..5] then los:=los+1;
        if i in[1..5] then nn[i]:=1;
        if i in[1..5] then i:=0;
        if (nn[1]=0)or(nn[2]=0)or(nn[3]=0)or(nn[4]=0)or(nn[5]=0) then begin
         if random(250)=1 then repeat i:=random(5)+1; until nn[i]=0 end else los:=5;
      until los=5;
      end;

      kpunkt:=60;
      if punkt_k>150 then kpunkt:=120;
      if punkt_k<100 then punkt:=2;
      if punkt_k>100 then punkt:=1.8;
      if punkt_k>150 then punkt:=1.2;
      punkt:=(dlugosc_skoku-punkt_k)*punkt;
      nota:=noty[2]+noty[3]+noty[4]+(kpunkt+punkt);

     nota_;
     skok_random:=nota;
     dispose(skocznia);
     dispose(trees);
end;

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
begin
     for jumper:=72 downto 1 do begin
      r:=0;
      skoczek:=jumper;
      if tabela[jumper].imie<>imie then begin
       if pokaz_komp then r:=skok_komp else begin a:=random(30) / (10); r:=skok_random+a; end;
        bar;end else r:=skokHUM;
      tabela[jumper].pun:=tabela[jumper].pun+r;
      if tabela[jumper].imie<>imie then
      if not pokaz_komp then begin bar1(123,89,196,111,7);bar1(124,90,195-jumper,110,15);
      outtextxyfnt1(161-((length(tabela[jumper].imie) shl 2)shr 1),115,12,4,tabela[jumper].imie,'data\licznik.fn2',norm); end;
      movebuf2screen2;
     end;
end;

Procedure Seria1;
var i,jumper:byte;
    r,a:real;
begin
     for jumper:=50 downto 1 do begin
      r:=0;
      skoczek:=jumper;
      if tabela[jumper].imie<>imie then begin
       if pokaz_komp then r:=skok_komp else begin a:=random(30) / (10); r:=skok_random+a; end;
        bar;end else r:=skokHUM;
      tabela[jumper].pun:=tabela[jumper].pun+r;
      if tabela[jumper].imie<>imie then
      if not pokaz_komp then begin bar1(134,89,186,111,7);bar1(135,90,185-jumper,110,15);
      outtextxyfnt1(161-((length(tabela[jumper].imie) shl 2)shr 1),115,12,4,tabela[jumper].imie,'data\licznik.fn2',norm); end;
      movebuf2screen2;
     end;
end;

Procedure Seria2;
var i,jumper:byte;
    r,A:real;
begin
     for jumper:=30 downto 1 do begin
      r:=0;
      skoczek:=jumper;
      if tabela[jumper].imie<>imie then begin
       if pokaz_komp then r:=skok_komp else begin a:=random(30) / (10); r:=skok_random+a; end;
        bar;end else r:=skokHUM;
      tabela[jumper].pun:=tabela[jumper].pun+r;
      if tabela[jumper].imie<>imie then
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

var nrfl:byte;
Procedure LoadFlag(plik:string);
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     inc(nrfl,1);
     assign(f,'gfx\flags\'+plik);
     reset(f);
     for xx:=0 to 11 do
     for yy:=0 to 8 do
      begin
       read(f,b);
       flagi^[nrfl,1+xx,1+yy]:=b;
      end;
     close(F);
end;

Function Real2Str2(re:real) : string;
var s:string;
begin
     str(re:2:1,s);
     real2str2:=s;
end;

Procedure Flaga(x,y,nr:integer);
var xx,yy:integer;
begin
     for xx:=1 to 12 do
     for yy:=1 to 9 do
      putpixel1(xx+x-1,yy+y-1,flagi^[nr,xx,yy]);
end;

Procedure Tabelka(ile:word);
var i,nr:byte;
    x,y:integer;
begin
     loadraw1('gfx\menu.raw');
     bar1(95,20,225,190,0);
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
     line1(95,180,95,190,14);
     line1(226,180,226,190,14);
     line1(95,190,226,190,14);
     outtextxyfnt1(99,183,11,4,
     'K-'+num2str(s__^[nr_skoczni].k)+' '+s__^[nr_skoczni].name+'-'+s__^[nr_skoczni].kraj+
     '  REK:'+real2str2(s__^[nr_skoczni].rec/3),'data\licznik.fn2',norm);

     repeat
           for i:= 1 to 16 do
           begin
                outtextxyfnt1(12+85,23+(i-1)*10,15,4,num2str(i+nr),'data\licznik.fn2',norm);
                if tabela[i+nr].imie=imie then outtextxyfnt1(22+85,23+(i-1)*10,145,4,tabela[nr+i].imie,'data\licznik.fn2',norm)
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
                if tabela[i+nr].kraj='Wàochy' then outtextxyfnt1(188,23+(i-1)*10,15,4,'ITA','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Japonia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'JPN','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Korea' then outtextxyfnt1(188,23+(i-1)*10,15,4,'KOR','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Polska' then outtextxyfnt1(188,23+(i-1)*10,15,4,'POL','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Norwegia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'NOR','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Rosja' then outtextxyfnt1(188,23+(i-1)*10,15,4,'RUS','data\licznik.fn2',norm);
                if tabela[i+nr].kraj='Sàowenia' then outtextxyfnt1(188,23+(i-1)*10,15,4,'SLO','data\licznik.fn2',norm);
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
     until keydown[1];
end;

Procedure Przyznaj_punkty;
begin
     inc(tabela[1].pkt,100); inc(tabela[16].pkt,15);
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
end;



var i,nr:byte;
    ch:char;

begin
     nrfl:=0;
     new(flagi);
     new(s__);
     LoadFlag('austria');
     LoadFlag('czech');
     LoadFlag('finland');
     LoadFlag('france');
     LoadFlag('germany');
     LoadFlag('italy');
     LoadFlag('japan');
     LoadFlag('korea');
     LoadFlag('POLAND');
     LoadFlag('norway');
     LoadFlag('russia');
     LoadFlag('slowenia');
     LoadFlag('switt');
     LoadFlag('usa');

     init13h;
     initnewkeyint;
     for i:=1 to 30 do setcol(199+i,i*2,i*2,i*2);
     setcol(231,0,40,0);
     setcol(232,0,33,0);
     setcol(255,0,63,63);

     assign(f,'data\imiona.dat');
     reset(f);
     read(f,z);
     close(f);
     assign(f__,'data\skocznie.dat');
     reset(f__);
     read(f__,s__^);
     close(f__);

     for i:=1 to 72 do begin
      tabela[i].imie:=z[i].imie;
      tabela[i].kraj:=z[i].kraj;
      tabela[i].pun:=0;
     end;
     wiatr_:=-2;
     pokaz_komp:=false;
     Imie:='www.ggate.prv.pl';
     Kraj:='Polska';
     Nr_skoczni:=25;
     IGIELIT:=false;



     tabela[72].imie:=imie;
     tabela[72].kraj:=kraj;
     tabela[72].pun:=0;
     tabelka(72);

{    gracz_rec:=false;komp_rec:=false;
     Kwalifikacje;     Bar;movebuf2screen2; delay(200);
     Sortuj_Kwalifikacje;
     tabelka(72);Zeruj_Punkty;
     gracz_rec:=true;komp_rec:=true;
     Seria1;           Bar;movebuf2screen2; delay(200);
     Sortuj_Seria1;
     tabelka(50);
     Seria2;           Bar;movebuf2screen2; delay(200);
     Sortuj_Seria2;
     tabelka(30);
     Przyznaj_punkty;}



     close13h;
     setoldkeyint;

{     nr:=1;
     repeat
      clrscr;
      for i:=0 to 23 do writeln(i+nr,'. ',tabela[i+nr].imie,' - ',tabela[i+nr].kraj,' - ',tabela[i+nr].pun:2:1,
      ' - ',tabela[i+nr].pkt);
      ch:=readkey;
      if ch=#72 then nr:=nr-1;
      if ch=#80 then nr:=nr+1;
      if nr>49 then nr:=nr-1;
      if nr<1 then nr:=nr+1;
     until ch=#27;}

     dispose(flagi);
     dispose(s__);
end.