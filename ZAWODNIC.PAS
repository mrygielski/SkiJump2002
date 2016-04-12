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
    i,j:integer;
    st:string;
    sh:shortint;
    aa:zaw;
    nr:integer;
    ch:char;

Procedure Save(im,kr:string;a:shortint);
begin
     nr:=nr+1;
     if nr>72 then exit;
     s[nr].imie:=im;
     s[nr].kraj:=kr;
     s[nr].ai:=a;
end;

begin
     assign(f,'data\imiona.dat');
     rewrite(f);
     nr:=0;
     save('Risto Jussilainen','Finlandia',1);
     save('Jussi Hautamaki','Finlandia',2);
     save('Veli-Matti Lindstrom','Finlandia',2);
     save('Pekka Salminen','Finlandia',1);
     save('Janne Ahonen','Finlandia',2);
     save('Toni Nieminen','Finlandia',1);
     save('Tami Kiuru','Finlandia',0);
     save('Lauri Hakola','Finlandia',-1);
     save('Ville Kantee','Finlandia',1);
     save('Jani Soininen','Finlandia',1);
     save('Akseli Lajunen','Finlandia',0);
     save('Matti Hautamaki','Finlandia',3);
     save('Mika Laitinen','Finlandia',1);
     save('Kimo Yliriesto','Finlandia',1);

     save('Martin Hollwarth','Austria',2);
     save('Wolfgang Loitzl','Austria',1);
     save('Martin Koch','Austria',2);
     save('Stefan Horngacher','Austria',1);
     save('Manuel Fettner','Austria',0);
     save('Andreas Goldberger','Austria',1);
     save('R. Schwarzenberger','Austria',0);
     save('Andreas Widholzl','Austria',2);
     save('Stefan Kaiser','Austria',1);

     save('Martin Schmitt','Niemcy',3);
     save('Alexander Herr','Niemcy',1);
     save('Stefan Hocke','Niemcy',2);
     save('Sven Hannawald','Niemcy',3);
     save('Frank Loffler','Niemcy',1);
     save('Hansjorg Jakle','Niemcy',1);
     save('Georg Spath','Niemcy',2);
     save('Christoph Duffner','Niemcy',2);
     save('Michael Uhrmann','Niemcy',2);

     save('Noriaki Kasai','Japonia',2);
     save('Hideharu Miyahira','Japonia',1);
     save('Kazuya Yoshioka','Japonia',1);
     save('Masahiko Harada','Japonia',1);
     save('Kazuyoshi Funaki','Japonia',2);
     save('Hiroya Saito','Japonia',1);
     save('Yuta Watase','Japonia',1);
     save('Kazuhiro Nakamura','Japonia',1);
     save('Takanobu Okabe','Japonia',1);
     save('Hiroki Yamada','Japonia',2);

     save('Tommy Ingebrigtsen','Norwegia',1);
     save('Lesse Ottesen','Norwegia',1);
     save('Roar Ljoekelsoey','Norwegia',1);
     save('Kristian Brenden','Norwegia',1);
     save('Henning Stensrud','Norwegia',1);
     save('Bjoern Einar Romoreren','Norwegia',0);
     save('Olav Margne Doennem','Norwegia',1);
     save('Morten Aagheim','Norwegia',-1);

     save('Adam Maàysz','Polska',3);
     save('Wojciech Skupie‰','Polska',0);
     save('Robert Mateja','Polska',1);
     save('ùukasz Kruczek','Polska',1);
     save('Grzegorz óliwka','Polska',0);
     save('Krystian Dàugopolski','Polska',-1);
     save('Tomasz Pochwaàa','Polska',1);
     save('Tomisàaw Tajner','Polska',1);
     save('Marcin Bachleda','Polska',0);

     save('Marco Stainauer','Szwajcaria',0);
     save('Simon Ammann','Szwajcaria',3);
     save('Sylvain Freiholz','Szwajcaria',1);
     save('Marc Vogel','Szwajcaria',0);
     save('Bruno Reuteler','Szwajcaria',0);
     save('Marco Daescher','Szwajcaria',0);
     save('Andreas Kuttel','Szwajcaria',1);

     save('Primoz Peterka','Sàowenia',1);
     save('Igor Medved','Sàowenia',2);
     save('Jure Radelj','Sàowenia',1);
     save('Robert Kranjec','Sàowenia',3);
     save('Damjan Fras','Sàowenia',2);
     save('Peter Zonta','Sàowenia',2);
     save('Primoz Zupan-Uhr','Sàowenia',0);

     save('Michal Delezal','Czechy',0);
     save('Jakub Suchacek','Czechy',0);
     save('Jakub Janda','Czechy',2);
     save('Jakub Hlava','Czechy',0);
     save('Jakub Jiroutek','Czechy',1);
     save('Jaroslav Sakala','Czechy',0);

     save('Valery Kobelev','Rosja',1);
     save('Dmitrij Wassiliev','Rosja',1);
     save('Ildar Farkullin','Rosja',1);

     save('Roberto Cecon','Wàochy',2);

     save('Alan Alborn','USA',2);
     save('Clint Jones','USA',1);

     save('Nicolan Dessum','Francja',1);

     save('Heung Chul Choi','Korea',0);

     for j:=1 to 72 do
     for i:=71 downto 1 do
      begin
           if s[i].ai<s[i+1].ai then
            begin
                 aa:=s[i];
                 s[i]:=s[i+1];
                 s[i+1]:=aa;
            end;
      end;

     write(f,s);
     close(f);
     writeln(nr);
     nr:=0;

     repeat
      for i:=1 to 20 do writeln(s[i+nr].imie,' - ',s[i+nr].kraj,' - ',s[i+nr].ai);
      ch:=readkey;
      clrscr;
      if ch=#72 then nr:=nr-1;
      if ch=#80 then nr:=nr+1;
      if nr>48 then nr:=nr-1;
      if nr<0 then nr:=0;
     until port[$60]=1;
end.







