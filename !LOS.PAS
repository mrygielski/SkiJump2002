uses fgraphb,f13h,games;

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
    tskocznia=array[1..24] of sko;

    zaw=record
               imie:string[20];
               kraj:string[10];
               AI:shortint;
               end;
    tzaw=array[1..72] of zaw;

Procedure Skok_Komp;

Const
     IGIELIT = false; {czy zawody s• rozgrywane na igielicie}
     NR_Skoczni = 20;
     Komp_rec = false; {czy komputer moæe pobijaÜ rekordy}
     Skoczek = 9;


var
   poziom:shortint;
   imie,kraj:string;
   PUNKT_K: word;
   ZJAZD:word;
   GRAVITACJA:real;
   f__:file of tskocznia;
   s__:^tskocznia;
   f_:file of tzaw;
   s_:^tzaw;

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
   wiatr,wiatr_: real;

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
     assign(f_,'data\imiona.dat');
     reset(f_);
     read(f_,s_^);
     close(f_);

     assign(f__,'data\skocznie.dat');
     reset(f__);
     read(f__,s__^);
     close(f__);
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
     if random(rusz*100)=1 then if random(2)=0 then wiatr:=wiatr-0.1 else wiatr:=wiatr+0.1;
     if wiatr<wiatr_-2.5 then wiatr:=wiatr_-2.5;
     if wiatr>wiatr_+2.5 then wiatr:=wiatr_+2.5;
end;



begin
     mex:=165;mey:=107;
     new(skocznia);
     new(trees);
     new(s__);
     new(s_);
     if igielit then kskoczni:=231 else kskoczni:=15;
     if igielit then kziemi:=232 else kziemi:=30;
     if igielit then kzjazd:=231 else kzjazd:=30;
     randomize;

     wiatr_:=-2;

     wiatr:=wiatr_;

     wybierz_skocznie;
     imie:=s_^[skoczek].imie;
     kraj:=s_^[skoczek].kraj;
     poziom:=s_^[skoczek].ai;

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

{      outtextxyfnt1(315-(length(Nota_)*4),188,4,4,Nota_,'data\licznik.fn2',norm);}

     dispose(skocznia);
     dispose(trees);
     dispose(s__);
     dispose(s_);
end;


var i:byte;
begin
     init13h;
     initnewkeyint;
     for i:=1 to 30 do setcol(199+i,i*2,i*2,i*2);
     setcol(231,0,40,0);
     setcol(232,0,33,0);
     setcol(255,0,63,63);

     skok_komp;
     bar1(0,0,20,20,15);
     movebuf2screen;
     delay(500);
     close13h;
     setoldkeyint;
end.
