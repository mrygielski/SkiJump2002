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


Procedure Skok;
Const
     IGIELIT = false; {czy zawody s• rozgrywane na igielicie}
     NR_Skoczni = 17;
     IMIE : string = 'Tomek';

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
     assign(f__,'data\skocznie.dat');
     reset(f__);
     read(f__,s__);
     close(f__);
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
     line1(1,y,319,y,15);
     line1(1,y+29,319,y+29,15);
     line1(1,y+10,319,y+10,15);
     hline1(1,y,y+28,15);
     hline1(319,y,y+28,15);
     hline1(275,y,y+28,15);
     outtextxyfnt1(5,y+3,230,4,'UWAGI TRENERA','data\licznik.fn2',norm);
     outtextxyfnt1(280,y+3,230,4,'ODLEGùOóè','data\licznik.fn2',norm);
     outtextxyfnt1(315-(length(ocena(dlugosc_skoku))*4),y+17,230,4,ocena(dlugosc_skoku),'data\licznik.fn2',norm);
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
     new(skocznia);
     new(trees);
     LOADTREE;
     LOADFUN(1);LOADFUN(3);LOADFUN(5);LOADFUN(7);LOADFUN(9);
     LOADFUN(2);LOADFUN(4);LOADFUN(6);LOADFUN(8);LOADFUN(10);
     if igielit then kskoczni:=231 else kskoczni:=15;
     if igielit then kziemi:=232 else kziemi:=30;
     if igielit then kzjazd:=231 else kzjazd:=30;
     randomize;
     wiatr_:=random(3);
     wiatr_:=wiatr_+(random(10) div 10);
     wiatr_:=-wiatr_;
     if random(2)=0 then wiatr_:=-wiatr_;
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
     repeat
      hline2(0,0,199,0);
      teren;
      Show_funs;
      Show_trees;
      pokaz_wiatr;
      rysuj_narty(0);
      if mela then show_mela;
      movebuf2screen2;
      hide_mela;
      delay(20);
      if not mela and (button=1) then mela:=true;
     until (button=2) or keydown[1];

     rusz:=1;
     fpsc.start;
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
         if odl2>0 then hline1(i,(skocznia^[odl2]+y2)-20,(skocznia^[odl2]+y2)+10,1);
        end;




       if not keydown[75] then
         begin
          inc(odleglosc,1);
          if skocznia^[odleglosc+159]<skocznia^[odleglosc+160]then yr:=yr-(skocznia^[odleglosc+160]-skocznia^[odleglosc+159]);
          if ladowanie or wypadek or naziemi then
           if skocznia^[odleglosc+159]>skocznia^[odleglosc+160]then yr:=yr+(skocznia^[odleglosc+159]-skocznia^[odleglosc+160]);
         end;

       if button=2 then
        if wybicie then
         if not ladowanie then
         if not wypadek then
           if wysokosc<8 then begin
           ladowanie:=true;
           nartay2[2]:=nartay2[1]-1;
           nartay[2]:=nartay[1]-1;
           rozsuwanie_nart(2);
           lado:=wysokosc;
           end;

       if keydown[80] then y2:=y2-1;
       if keydown[f1scan] then delay(15);
       if keydown[f2scan] then begin wiatr_:=wiatr_-0.1;wiatr:=wiatr_; end;
       if keydown[f3scan] then begin wiatr_:=wiatr_+0.1;wiatr:=wiatr_; end;


       if (my=0)and(wybicie)and(narty>0)and(odleglosc+166>zjazd) then
        begin
             putmouse(0,5);
             zloz_narty(1);
             narty:=narty-1;
             stabilnosc_lotu:=stabilnosc_lotu+0.5;
        end;
       if (my=10)and(wybicie)and(narty<5)and(odleglosc+166>zjazd) then
        begin
             putmouse(0,5);
             rozloz_narty(1);
             narty:=narty+1;
             stabilnosc_lotu:=stabilnosc_lotu+0.5;
        end;

       if wiatr<0 then if random(300-round(20*wiatr))=0 then putmouse(mx,10);
       if wiatr>0 then if random(300-round(20*wiatr))=0 then putmouse(mx,0);

       y2:=round(yr);

       if not ladowanie and naziemi then begin WYPADEK:=true; outtextxy2(150,10,15,1,1,'WYPADEK');end;

       if wypadek or (ladowanie and naziemi) then
        begin
         speed:=speed+0.4;
         if speed>=1 then begin speed:=0;del:=del+1; end;
         delay(del);
         narty:=0;
        end;

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
      noty[1]:=lado;
      noty[2]:=(stabilnosc_lotu);
      noty[3]:=wyskok;{USTALANIE}
      if wypadek then noty[1]:=noty[1]-7;                 {PIERWSZEJ NOTY...}

      if (lado<3)and not wypadek then outtextxyfnt1(5,183,230,4,'Wspaniaàe l•dowanie!','data\licznik.fn2',norm);
      if (lado>=3)and(lado<5)and not wypadek then outtextxyfnt1(5,183,230,4,'Niezàe l•dowanie.','data\licznik.fn2',norm);
      if (lado>=5)and not wypadek then outtextxyfnt1(5,183,230,4,'L•dowanie w zàym momencie.','data\licznik.fn2',norm);
      if wypadek then outtextxyfnt1(5,183,230,4,'Uuuu. Chyba Ci si© nic nie staào? We´ si© w garòÜ do cholery!',
                                                'data\licznik.fn2',norm);

      if not wypadek then begin
      if (noty[2]<3) then outtextxyfnt1(5,191,230,4,'ówietna pozycja w locie!','data\licznik.fn2',norm);
      if (noty[2]>=3)and(noty[2]<5) then outtextxyfnt1(5,191,230,4,'Niezàa pozycja w locie.','data\licznik.fn2',norm);
      if (noty[2]>=5)and(noty[2]<10) then outtextxyfnt1(5,191,230,4,'Popracuj nad sylwetk• podczas lotu.',
                                                                   'data\licznik.fn2',norm);
      if (noty[2]>=10) then outtextxyfnt1(5,191,230,4,'Jak ty lecisz?','data\licznik.fn2',norm);
      end else outtextxyfnt1(5,191,230,4,'TRENUJ L§DOWANIE!!!','data\licznik.fn2',norm);

      movebuf2screen2;
     repeat until keydown[1];
     end;
     dispose(skocznia);
     dispose(trees);
end;


var i:byte;
begin
     init13h;
     initnewkeyint;
     for i:=1 to 30 do setcol(199+i,i*2,i*2,i*2);
     setcol(231,0,40,0);
     setcol(232,0,33,0);
     setcol(255,0,63,63);

     skok;
     close13h;
     setoldkeyint;
end.
