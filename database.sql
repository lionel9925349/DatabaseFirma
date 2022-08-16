create table abteilung (
    Abtname VARCHAR(30),
    Abtnr SERIAL,
    PRIMARY KEY(Abtnr)
);

DROP table abteilung;
create table mitarbeiter (
    PNr SERIAL,
    Mname VARCHAR(30),
    Abtnr INTEGER(10),
    Gehalt INTEGER(10),
    PRIMARY KEY(PNr),
    CONSTRAINT PK_Abtnr FOREIGN KEY (Abtnr) REFERENCES abteilung(Abtnr) 
);

create table hotel (
    HNr SERIAL  PRIMARY KEY,
    Hname VARCHAR(30),
    Kategorie VARCHAR(30),
    PLZ INTEGER (10),
    Ort VARCHAR(30)
);

create table reisen (
    PNr INteger,
    Beginndatum DATE,
    Dauer integer,
    Kosten decimal , 
    HNr INTEGEr,
    PRIMARY KEY (PNr,HNr,Beginndatum),
    CONSTRAINT PK_Mitarbeiter FOREIGN KEY (PNr) REFERENCES mitarbeiter(PNr),
    CONSTRAINT PK_Hotel FOREIGN KEY (HNr) REFERENCES hotel(HNr)
    
);

INSERT INTO abteilung(Abtname, Abtnr) VALUES('Softwareentwicklung',1);
INSERT INTO abteilung(Abtname, Abtnr) VALUES('webentwicklung',2);
INSERT INTO abteilung(Abtname, Abtnr) VALUES('backendentwicklung',3);


INSERT INTO mitarbeiter(Mname,Abtnr,Gehalt) VALUES ('lionel',2,300);
INSERT INTO mitarbeiter(Mname,Abtnr,Gehalt) VALUES ('noumi',1,325);
INSERT INTO mitarbeiter(Mname,Abtnr,Gehalt) VALUES ('Fally',3,235);
INSERT INTO mitarbeiter(Mname,Abtnr,Gehalt) VALUES ('ulrich',2,250);
INSERT INTO mitarbeiter(Mname,Abtnr,Gehalt) VALUES ('toofan',1,300);
INSERT INTO mitarbeiter(Mname,Abtnr,Gehalt) VALUES ('dominik',2,700);


INSERT INTO hotel(Hname,Kategorie,PLZ,Ort) VALUES('Ibiza','3_stern',70002,'Dortmund')
INSERT INTO hotel(Hname,Kategorie,PLZ,Ort) VALUES('record','3_stern',70002,'Dortmund')
INSERT INTO hotel(Hname,Kategorie,PLZ,Ort) VALUES('wvw','3_stern',70002,'Dortmund')

INSERT INTO hotel(Hname,Kategorie,PLZ,Ort) VALUES('B&B','4_stern',60002,'Bochum')
INSERT INTO hotel(Hname,Kategorie,PLZ,Ort) VALUES('DuPont','5_stern',78000,'Hamburg')
INSERT INTO hotel(Hname,Kategorie,PLZ,Ort) VALUES('DuPont','5_stern',78000,'HamburgCity')
INSERT INTO hotel(Hname,Kategorie,PLZ,Ort) VALUES('Baham','7_stern',71200,'BahamCity')



INSERT INTO reisen(PNr,Beginndatum,Dauer,Kosten,HNr) VALUES(1,'2021-05-21',3,250.00,1);
INSERT INTO reisen(PNr,Beginndatum,Dauer,Kosten,HNr) VALUES(5,'2021-07-21',1,350.00,4);
INSERT INTO reisen(PNr,Beginndatum,Dauer,Kosten,HNr) VALUES(3,'2022-01-21',5,450.00,4);
INSERT INTO reisen(PNr,Beginndatum,Dauer,Kosten,HNr) VALUES(4,'2021-10-21',8,155.00,5);
INSERT INTO reisen(PNr,Beginndatum,Dauer,Kosten,HNr) VALUES(4,'2025-05-21',4,310.00,1);
INSERT INTO reisen(PNr,Beginndatum,Dauer,Kosten,HNr) VALUES(5,'2025-05-21',7,810.00,5);

INSERT INTO reisen(PNr,Beginndatum,Dauer,Kosten,HNr) VALUES(7,'2025-05-21',7,810.00,5);
INSERT INTO reisen(PNr,Beginndatum,Dauer,Kosten,HNr) VALUES(7,'2025-10-21',4,410.00,5);

INSERT INTO reisen(PNr,Beginndatum,Dauer,Kosten,HNr) VALUES(7,'2025-05-21',7,810.00,7);



delete 
from reisen 
where pnr = 7


---Erste Frage ----
/* Liste aller Mitarbeiter aus der Softwareentwicklung, mit PNr. und Namen aufsteigend
sortiert nach Personal-Nr.*/

SELECT mitarbeiter.PNr, mitarbeiter.Mname
FROM mitarbeiter , abteilung
WHERE mitarbeiter.Abtnr =  abteilung.Abtnr AND Abtname = 'Softwareentwicklung'
ORDER BY mitarbeiter.PNr, mitarbeiter.Mname ASC

---zweite Frage ----
/*Ermitteln Sie die Mitarbeiter mit dem niedrigsten Gehalt unter Angabe von PNr., Name
und Gehalt.*/

SELECT PNr,Mname , Gehalt
FROM mitarbeiter
WHERE Gehalt = (SELECT MIN(Gehalt) FROM mitarbeiter)

---dritte Frage---
/*. Suchen Sie alle Hotels mit dem Namensbestandteil City im Postleitbezirk 70000 bis 78000
aus der Datenbank heraus und gegeben Sie die Felder HNr, HName, Kategorie, PLZ und
Ort aus.*/

select HNr, Hname, Kategorie, PLZ, Ort from hotel
where (PLZ >=70000 and PLZ<= 78000) and
      ort LIKE '%City%'


---vierte Frage ----
/*Nach Namen absteigend sortierte Liste aller reisenden Mitarbeiter mit Name, PNr.,
Anzahl der Reisen und den Durchschnittskosten ihrer Reisen.*/

SELECT mitarbeiter.Mname, mitarbeiter.PNr, count(reisen.PNr), round(AVG(Kosten),2)
from mitarbeiter, reisen
where mitarbeiter.PNr = reisen.PNr
group by mitarbeiter.PNr
order by Mname desc

---fünfte Frage---
/* 5. Namen aller Mitarbeiter, die schon einmal in Hamburg waren (jeder Name nur einmal).*/

SELECT  mitarbeiter.Mname
from mitarbeiter, hotel, reisen
where mitarbeiter.PNr = reisen.PNr and
      hotel.HNr = reisen.HNr and 
      Ort = 'Hamburg'
      group by mitarbeiter.PNr, ort
   having   count(Ort) > 0
   
      
      
SELECT distinct v.Mname , j.Mname
from mitarbeiter v, mitarbeiter j, hotel, reisen
where mitarbeiter.PNr = reisen.PNr and
      hotel.HNr = reisen.HNr and 
      Ort = 'Hamburg' and v.Mname  <> j.Mname
            
      
---sechste Frage---
/* 6. Name, Personal-Nr. und Abteilungsname des Mitarbeiters, der die teuerste Reise gemacht
hat (mehrere Mitarbeiter möglich) - inkl. der angefallenen Kosten und des Beginndatums.*/

select Mname, mitarbeiter.PNr, Abtname, Kosten, Beginndatum
from mitarbeiter,abteilung, reisen
where mitarbeiter.Abtnr = abteilung.Abtnr and
      mitarbeiter.PNr = reisen.PNr and
      Kosten in (select max(Kosten)
                from reisen)
                
                
SELECT Mname, PNr, Abtname, kosten, Beginndatum 
FROM mitarbeiter join abteilung using(abtnr)
                 join reisen using(pnr)
WHERE kosten = (SELECT Max(kosten) FROM reisen);  

select * from reisen
select * from hotel
select * from mitarbeiter
                
 ---siebte Frage ---
 /* 7. Angabe aller Paare von Mitarbeitern nur mit Personal-Nr1, Personal-Nr2, Hotelname und
Beginndatum, die gemeinsam im gleichen Hotel zum gleichen Datum ihre Übernachtungen begonnen haben. Die Datensätze sollen nach den Paaren aufsteigend sortiert sein.
Beachten Sie auch, dass jedes Paar i,j einmal in einem Datensatz (i,j,...) und einmal in
(j,i,...) vorkommt! –> ein Paar = zwei Zeilen. */

SELECT mitarbeiter.PNr, mitarbeiter2.PNr, hotel.Hname, Beginndatum 
FROM mitarbeiter, mitarbeiter as mitarbeiter2, hotel, hotel as hotel2, reisen
WHERE mitarbeiter.PNr = reisen.PNr and mitarbeiter2.PNr = reisen.PNr 
            and hotel.HNr = reisen.HNr
            and hotel2.HNr = reisen.HNr
            and mitarbeiter.PNr != mitarbeiter2.PNr 
order by mitarbeiter.PNr 
            and mitarbeiter2.PNr
            
            
---achte Frage ---
/* 8. Anzeige der Hotels mit HNr u. HName, die mindestens zweimal gebucht wurden. */

SELECT distinct reisen.HNr, Hname
from hotel, reisen
where hotel.HNr = reisen.HNr
group by reisen.HNr,hname
HAVING count(reisen.HNr) >= 2

---neunte Frage---
/* Geben Sie eine Liste aller bisher gebuchten Hotels mit HNr, HName, Gesamtanzahl der
verbrachten Nächte und die durchschnittlichen Kosten pro Nacht, aufsteigend sortiert nach
HNr, aus.*/
select hotel.HNr ,Hname, sum(dauer), round((kosten / (dauer)),2) as kosten
from hotel , reisen
where hotel.HNr = reisen.HNr
group by hotel.HNr ,Hname , kosten,dauer
order by hotel.HNr asc

select hotel.HNr ,HName, sum(dauer), round((kosten / (dauer)),2) as kosten
from hotel , reisen
where hotel.HNr = reisen.HNr
group by hotel.HNr ,HName , kosten,dauer
order by hotel.HNr asc

---zehnte Frage---
/* Anzahl der Hotels, die nie gebucht wurden.*/
select count(*)
from hotel 
where  hotel.HNr in (  select hotel.HNr
from hotel
where hotel.hnr not in( 
select reisen.HNr from reisen) )

SELECT count(*)
from  hotel
left join reisen  on hotel.hnr = reisen.hnr 
group by reisen.HNr 
HAVING count(reisen.HNr)  = 0;


SELECT count(hotel.hname)
from  hotel
left join reisen  on hotel.hnr = reisen.hnr 
HAVING count(reisen.HNr)  < 1;

SELECT count(*)
from  hotel
left join reisen  on hotel.hnr = reisen.hotel
group by reisen.hotel
HAVING count(reisen.hotel)  = 0;

select * from reisen
select * from hotel
select * from mitarbeiter



SELECT Mname
FROM mitarbeiter join reisen using(pnr)
WHERE hnr in(SELECT hotel.hnr from hotel where ort = 'Hamburg')



























SELECT distinct reisen.HNr, hotel.Hname
from hotel, reisen
where hotel.HNr = reisen.HNr
group by reisen.HNr ,hotel.Hname
HAVING count(reisen.HNr) > 2;

 

alter table reisen alter column kosten type INTEGER
SELECT CONVERT(kosten, Integer) FROM reisen
SELECT CAST(kosten AS INteger FROM reisen


SELECT mitarbeiter.name, mitarbeiter.PNr, count(reisen.mitarbeiter), AVG(Kosten)
from mitarbeiter, reisen
where mitarbeiter.PNr = reisen.mitarbeiter
group by mitarbeiter.PNr
order by Mname asc

select * from reisen


select distinct mitarbeiter.Mname from reisen 
where 
select * from mitarbeiter


select r.Mname 
from reisen v join mitarbeiter  r  using(PNr)
                    join hotel h using(HNr)
                    where h.ort = 'Hamburg'
                    
 select mitarbeiter.Mname 
 from mitarbeiter , hotel , reisen 
 where mitarbeiter.PNr = reisen.PNr and mitarbeiter.PNr = hotel.HNr and hotel.ort = 'Bochum'

select kosten, mitarbeiter.Mname ,mitarbeiter.PNr, abteilung.Abtname,reisen.Beginndatum
from mitarbeiter,abteilung, reisen
where mitarbeiter.Abtnr = abteilung.Abtnr and mitarbeiter.PNr = reisen.PNr 
group by kosten

select count(hotel.HNr),hotel.Hname ,hotel.HNr
from hotel , reisen
where hotel.HNr = reisen.HNr 
group by hotel.Hname ,hotel.HNr
having count(hotel.HNr)>= 2


group by count(reisen.HNr) >= 2

select  mitarbeiter.Mname ,mitarbeiter.PNr, abteilung.Abtname, reisen.Beginndatum,max(kosten)
from mitarbeiter,abteilung,reisen
where mitarbeiter.Abtnr = abteilung.Abtnr and mitarbeiter.PNr = reisen.PNr 
group by kosten
having mitarbeiter.PNr = max(kosten)

 
where 

select Mname 
from mitarbeiter , reisen
where mitarbeiter .PNr = reisen.PNr and ( select Hname from hotel , reisen where reisen.HNr = hotel.HNr and Hname = 'Bochum') ;

select * from reisen;
select * from hotel;


select hotel.HNr ,Hname, sum(dauer), (kosten / (dauer)) as kosten
from hotel , reisen
where hotel.HNr = reisen.HNr
group by hotel.HNr ,Hname , kosten,dauer
order by hotel.HNr asc

select count(hotel.HNr)
from hotel 
where  hotel.HNr in (  select hotel.HNr
from hotel
except 
select reisen.HNr from reisen)


SELECT c1, c2
FROM t1
RIGHT JOIN t2 ON condition;

select reisen.HNr , hotel.HNr
from hotel
right join reisen on reisen.HNr = hotel.HNr


select count(hotel.HNr)
from hotel
except 
select reisen.HNr from reisen

SELECT Mname
FROM mitarbeiter , hotel 
WHERE ort = 'Hamburg';


---question 4  select * from reisen     

SELECT mitarbeiter.Mname, mitarbeiter.PNr, count(reisen.PNr), avg(regexp_replace(kosten::text, '[$,]', '', 'g')::integer)
from mitarbeiter, reisen
where mitarbeiter.PNr = reisen.PNr
group by mitarbeiter.PNr
order by Mname asc



            
            
            
  select * from reisen     
    select * from abteilung    
              select * from hotel     

          
   1)         
            
 select    *   
  from  abteilung join mitarbeiter using(abtnr)
  where abtname  = 'Softwareentwicklung'
  order by mitarbeiter.pnr asc          
 2)
            
select pnr , mname 
 from mitarbeiter 
 where gehalt in (select min(gehalt) from mitarbeiter)


   3)         
            
 select  hnr ,hname,kategorie,plz , ort
 from hotel 
 where ort like '%City%' and  plz >=70000 and plz <= 78000
            
  4)  
  
  select mname , pnr, count(reisen.pnr),round(avg(kosten),2)
  from mitarbeiter join reisen  using(pnr)
  group by mname ,pnr
  order by mname desc
            
            
       5)
       
  select distinct mname 
  from mitarbeiter join reisen using(pnr)
        join hotel using(hnr)
  where ort = 'Hamburg'
            
     6)
     
     select mname ,pnr,abtname , kosten, beginndatum
     from mitarbeiter join abteilung using (abtnr)  join reisen using(pnr)
      where kosten in (select max(kosten) from reisen )      
            
            
  7)           
            
            
 select h.pnr, b.pnr ,hname, beginndatum
from mitarbeiter h , mitarbeiter b     join  reisen using ( pnr)       join hotel using (hnr)
where  h.pnr  in (select hname from hotel)          
            
            
   8)
    
    select hnr , hname 
    from reisen join hotel using(hnr)
    group by hnr ,hname
    having count(reisen.hnr)>1
            
            
               select hnr , hname 
    from reisen join hotel using(hnr)
    where reisen.hnr in ( select reisen.hnr from reisen where ) 
    
    
       select hnr , hname ,count(reisen.hnr)
    from reisen join hotel using(hnr)
    group by hnr ,hname
    having 2 > 1 
            
    9)
    
    select hnr, hname, sum(dauer), round((sum(kosten)/sum(dauer)),2) as durchnit
    from reisen join hotel using (hnr)
    group by hnr, hname
    order by hnr asc        
            
            
            
            
            10) 
            
            
            select count(hnr)
            from hotel left join reisen using (hnr)
            where reisen.hnr is null
            


             select count(hnr)
            from hotel left join reisen using (hnr)
            where reisen.hnr is null
            
