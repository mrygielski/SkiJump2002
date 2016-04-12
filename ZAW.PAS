uses crt;
type
    zaw=record
               imie:string[20];
               kraj:string[10];
               AI:shortint;
               end;
    tskocznia=array[1..72] of zaw;


var f:file of tskocznia;
    s:tskocznia;
    ile,nr,aa,j,i:word;
    aaa:zaw;
    ch:char;

Procedure Save(nr:word;im,kr:string;a:shortint);
begin
     s[ile+1].imie:=im;
     s[ile+1].kraj:=kr;
     s[ile+1].ai:=a;
     ile:=ile+1;
     if length(im)>aa then aa:=length(im);
end;

begin
     clrscr;
     ile:=0;aa:=0;
     assign(f,'data\imiona.dat');
     rewrite(f);

     save(1,'Risto Jussilainen','Finlandia',1);
     save(2,'Jussi Hautamaki','Finlandia',2);
     save(3,'Veli-Matti Lindstrom','Finlandia',2);
     save(5,'Janne Ahonen','Finlandia',2);
     save(6,'Toni Nieminen','Finlandia',1);
     save(7,'Tami Kiuru','Finlandia',0);
     save(8,'Lauri Hakola','Finlandia',-1);
     save(10,'Jani Soininen','Finlandia',1);
     save(12,'Matti Hautamaki','Finlandia',3);
     save(14,'Kimo Yliriesto','Finlandia',1);

     save(15,'Martin Hollwarth','Austria',2);
     save(16,'Wolfgang Loitzl','Austria',1);
     save(17,'Martin Koch','Austria',2);
     save(18,'Stefan Horngacher','Austria',1);
     save(19,'Manuel Fettner','Austria',0);
     save(20,'Andreas Goldberger','Austria',1);
     save(22,'Andreas Widholzl','Austria',2);
     save(23,'Stefan Kaiser','Austria',1);

     save(24,'Martin Schmitt','Niemcy',3);
     save(25,'Alexander Herr','Niemcy',1);
     save(26,'Stefan Hocke','Niemcy',2);
     save(27,'Sven Hannawald','Niemcy',3);
     save(28,'Frank Loffler','Niemcy',1);
     save(29,'Hansjorg Jakle','Niemcy',1);
     save(30,'Georg Spath','Niemcy',1);
     save(31,'Christoph Duffner','Niemcy',2);
     save(32,'Michael Uhrmann','Niemcy',2);

     save(33,'Noriaki Kasai','Japonia',2);
     save(34,'Hideharu Miyahira','Japonia',1);
     save(35,'Kazuya Yoshioka','Japonia',1);
     save(36,'Masahiko Harada','Japonia',1);
     save(37,'Kazuyoshi Funaki','Japonia',2);
     save(38,'Hiroya Saito','Japonia',1);
     save(40,'Kazuhiro Nakamura','Japonia',1);
     save(41,'Takanobu Okabe','Japonia',1);
     save(42,'Hiroki Yamada','Japonia',2);

     save(43,'Tommy Ingebrigtsen','Norwegia',1);
     save(44,'Lesse Ottesen','Norwegia',1);
     save(45,'Roar Ljoekelsoey','Norwegia',1);
     save(46,'Kristian Brenden','Norwegia',1);
     save(47,'Henning Stensrud','Norwegia',1);
     save(49,'Olav Margne Doennem','Norwegia',1);

     save(51,'Adam Maàysz','Polska',3);
     save(52,'Wojciech Skupie‰','Polska',0);
     save(53,'Robert Mateja','Polska',1);
     save(54,'ùukasz Kruczek','Polska',1);
     save(56,'Tomasz Pochwaàa','Polska',1);
     save(57,'Tomisàaw Tajner','Polska',1);

     save(60,'Marco Stainauer','Szwajcaria',0);
     save(61,'Simon Ammann','Szwajcaria',3);
     save(62,'Sylvain Freiholz','Szwajcaria',1);
     save(63,'Marc Vogel','Szwajcaria',0);
     save(65,'Marco Daescher','Szwajcaria',0);
     save(66,'Andreas Kuttel','Szwajcaria',1);

     save(67,'Primoz Peterka','Sàowenia',1);
     save(68,'Igor Medved','Sàowenia',2);
     save(69,'Jure Radelj','Sàowenia',1);
     save(70,'Robert Kranjec','Sàowenia',3);
     save(71,'Damjan Fras','Sàowenia',2);
     save(72,'Peter Zonta','Sàowenia',2);

     save(74,'Michal Delezal','Czechy',0);
     save(75,'Jakub Suchacek','Czechy',0);
     save(76,'Jakub Janda','Czechy',2);
     save(77,'Jakub Hlava','Czechy',0);
     save(79,'Jaroslav Sakala','Czechy',0);

     save(80,'Valery Kobelev','Rosja',1);
     save(82,'Ildar Fatkullin','Rosja',1);

     save(83,'Roberto Cecon','Wàochy',2);

     save(84,'Alan Alborn','USA',2);
     save(85,'Clint Jones','USA',1);

     save(86,'Nicolan Dessum','Francja',1);

     save(87,'Heung Chul Choi','Korea',0);

     for j:=1 to 72 do
     for i:=71 downto 1 do
      begin
           if s[i].ai<s[i+1].ai then
            begin
                 aaa:=s[i];
                 s[i]:=s[i+1];
                 s[i+1]:=aaa;
            end;
      end;

     write(f,s);
     close(f);
     nr:=0;

     repeat
      for i:=1 to 24 do writeln(s[i+nr].imie,' - ',s[i+nr].kraj,' - ',s[i+nr].ai);
      ch:=readkey;
      clrscr;
      if ch=#72 then nr:=nr-1;
      if ch=#80 then nr:=nr+1;
      if nr>48 then nr:=nr-1;
      if nr<0 then nr:=nr+1;
     until port[$60]=1;
end.







