Procedure Dodaj;
var i:integer;
    im,kr:string[20];
    kraj_ : byte;
    nazwakr:string[10];
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
           if kraj_=1 then nazwakr:='POLSKA';
           if kraj_=2 then nazwakr:='FINLANDIA';
           if kraj_=3 then nazwakr:='NIEMCY';
           if kraj_=4 then nazwakr:='AUSTRIA';
           if kraj_=5 then nazwakr:='JAPONIA';
           if kraj_=6 then nazwakr:='NORWEGIA';
           if kraj_=7 then nazwakr:='SZWAJCARIA';
           if kraj_=8 then nazwakr:='SOWENIA';
           if kraj_=9 then nazwakr:='CZECHY';
           if kraj_=10 then nazwakr:='ROSJA';
           if kraj_=11 then nazwakr:='FRANCJA';
           if kraj_=12 then nazwakr:='WOCHY';
           if kraj_=13 then nazwakr:='USA';
           if kraj_=14 then nazwakr:='KOREA';
           centertextfnt2(160,180,252,4,nazwakr,'data\licznik.fn2',norm);
           movebuf2screen2;
           centertextfnt2(160,180,11,4,nazwakr,'data\licznik.fn2',norm);
           if keydown[72] and (kraj_>1) then kraj_:=kraj_-1;
           if keydown[80] and (kraj_<14) then kraj_:=kraj_+1;
     until keydown[1];

     graczy:=graczy+1;
     imie[graczy]:=im;
     kraj[graczy]:=kr;
     For i:=1 to graczy do
      begin
       tabela[73-i].imie:=imie[i];
       tabela[73-i].kraj:=kraj[i];
       tabela[73-i].pun:=0;
       tabela[73-i].pkt:=0;
      end;
end;
