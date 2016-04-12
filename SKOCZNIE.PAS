uses crt;
type
    sko=record
                k:word;
                rec:real;
                name:string[20];
                kraj:string[10];
                reko:string[50];
                gr:real;
               end;
    tskocznia=array[1..26] of sko;


var f:file of tskocznia;
    s:tskocznia;

Procedure Save(nr,k,r:word;st,kr,rek:string;re:real);
begin
     s[nr].k:=k;
     s[nr].rec:=r;
     s[nr].name:=st;
     s[nr].kraj:=kr;
     s[nr].reko:=rek;
     s[nr].gr:=re;
end;

begin
     assign(f,'data\skocznie.dat');
     rewrite(f);
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
     write(f,s);
     close(f);
end.