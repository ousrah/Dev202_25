/*Exercice 1 :
Écrire une fonction qui renvoie une chaine qui sera exprimée sous la forme Jour, Mois et Année à partir d’une date passée comme paramètre où :
­	Mois est exprimé en toutes lettres
exemple : décembre 
Exemple : 12/09/2011 -----> 12 septembre 2011
*/

drop function if exists datecomplet;
delimiter $$    
create function datecomplet(d date)
returns varchar(255)
deterministic
begin
		declare mois varchar(255);
		 set mois = case  month(d)
			 when  1 then 'janvier'
			 when  2 then 'fevrier'
			 when  3 then 'mars'
			 when 4 then 'avril'
			 when 5 then 'mai'
			 when 6 then 'juin'
			 when 7 then 'juillet'
			 when 8 then 'aout'
			 when 9 then 'septembre'
			 when 10 then 'octobre'
			 when 11 then 'novembre'
			 when 12 then 'decembre'
			else 'error'
			end;
            return concat(day(d) , ' ' , mois , ' ' , year(d));
end $$
delimiter ;
select datecomplet('2005/06/01');
select datecomplet('2005/07/05');
select datecomplet('2028/03/04');
select datecomplet('2004/09/13');

select @@lc_time_names;
set lc_time_names = "ar_SA";
select date_format('2005/06/01', '%W  %d-%M-%Y');


drop function if exists datecomplet;
delimiter $$    
create function datecomplet(d date)
returns varchar(255)
deterministic
begin
	declare oldLc varchar(50) default @@lc_time_names;
    declare newDate varchar(50);
	set lc_time_names = "fr_FR";
	set newDate =  date_format(d, '%d %M %Y');
    set lc_time_names = oldLc;
    return newDate;
end $$
delimiter ;

select datecomplet('2004/09/13');


/*Exercice 2:
Ecrire une fonction qui reçoit deux dates comme paramètre et calcule l’écart en fonction 
de l’unité de calcul passée à la fonction ;
L’unité de calcul peut être de type : jour, mois, année, heure, minute, seconde
*/
drop function if exists dategap;
delimiter $$
create function dategap(d1 date,d2 date,t varchar(45))
	returns varchar(45)
	deterministic
begin
    
    return case t
				when 'jour' then concat(abs(datediff(d2,d1)),' jour')
				when 'mois' then concat(abs(TIMESTAMPDIFF(MONTH,d1,d2)),' mois')
				when 'année' then concat(abs(TIMESTAMPDIFF(YEAR,d1,d2)),' année')
				when 'heure' then concat(abs(TIMESTAMPDIFF(HOUR,d1,d2)),' heure')
				when 'minute' then concat(abs(TIMESTAMPDIFF(MINUTE,d1,d2)),' minute')
				when 'seconde' then concat(abs(TIMESTAMPDIFF(SECOND,d1,d2)),' seconde')
                else
					'erreur'
			end;


end$$
delimiter ;
select dategap('2006-7-9','2005-9-9','jour');
select dategap('2004-7-9','2005-9-9','mois');
select dategap('2004-7-9','2005-9-9','année');
select dategap('2004-7-9','2005-9-9','heure');
select dategap('2004-7-9','2005-9-9','minute');
select dategap('2004-7-9','2005-9-9','seconde');
select dategap('2004-7-9','2000-9-9','abs');






/*Exercice 3 : application sur la bd ‘gestion_vols’
Gestion vol
Pilote(numpilote,nom,titre,villepilote,daten,datedebut)
Vol(numvol,villed,villea,dated,datea, #numpil,#numav)
Avion(numav,typeav ,capav)
*/

drop database if exists vols_202;

create database vols_202 collate utf8mb4_general_ci;
use vols_202;

create table Pilote(
numpilote int auto_increment primary key,
nom varchar(50) ,
titre varchar(50) ,
villepilote varchar(50) ,
daten date,
datedebut date);

create table Vol(numvol int auto_increment primary key,
villed varchar(50) ,
villea varchar(50) ,
dated date ,
datea date , 
numpil int not null,
numav int not null);

create table Avion(numav int auto_increment primary key,
typeav  varchar(50) ,
capav int);

alter table vol add constraint fk_vol_pilote foreign key(numpil) references pilote(numpilote);
alter table vol add constraint fk_vol_avion foreign key(numav) references avion(numav);


insert into avion values (1,'boeing',350),
						(2,'caravel',50),
                        (3,'airbus',500),
                        (4,'test',350);
                        
insert into pilote values (1,'hassan','M.','tetouan','2000-01-01','2022-01-01'),
						(2,'saida','Mme.','casablanca','1980-01-01','2002-01-01'),
						(3,'youssef','M.','tanger','1983-01-01','2002-01-01');

insert into vol values (1,'tetouan','casablanca','2023-09-10','2023-09-10',1,1),
						(2,'casablanca','tetouan','2023-09-10','2023-09-10',1,1),
						(3,'tanger','casablanca','2023-09-11','2023-09-11',2,2),
						(4,'casablanca','tanger','2023-09-11','2023-09-11',2,2),
						(5,'agadir','casablanca','2023-09-11','2023-09-11',3,3),
						(6,'casablanca','agadir','2023-09-11','2023-09-11',3,3),
                        (7,'tetouan','casablanca','2023-09-10','2023-09-12',1,1),
						(8,'casablanca','tetouan','2023-09-10','2023-09-12',1,1),
						(9,'tanger','casablanca','2023-09-11','2023-09-13',1,2),
						(10,'casablanca','tanger','2023-09-11','2023-09-13',1,2),
						(11,'agadir','casablanca','2023-09-11','2023-09-13',3,3),
						(12,'casablanca','agadir','2023-09-11','2023-09-13',3,3),
                        (13,'tetouan','casablanca','2023-09-10','2023-09-15',2,1),
						(14,'casablanca','tetouan','2023-09-10','2023-09-15',3,1);  

select ceiling(rand()*19);

#1.	Ecrire une fonction qui retourne le nombre de pilotes ayant 
#effectué un nombre de vols supérieur à un nombre donné comme paramètre ;

-- construction de la requette
/*     select count(*) from (
select count(numvol), numpil 
from vol
group by numpil
having count(numvol)>3) f;
*/

drop function if exists E3Q1;
delimiter &&
create function E3Q1(nb int)
returns varchar(25)
deterministic
begin
     declare n int;
	 with t1 as (select count(numvol), numpil 
				from vol
				group by numpil
				having count(numvol)>nb
                )
	 select count(*) into n from t1;
	 return n;
end &&
delimiter ;

select E3Q1(8);
#2.	Ecrire une fonction qui retourne la durée de travail d’un pilote 
#dont l’identifiant est passé comme paramètre ;
select * from pilote;
drop function if exists E3Q2;
delimiter //
create function E3Q2(id_pilote int)
returns int
deterministic 
begin
      return (select( datediff(current_date(),datedebut)) 
          from pilote 
          where numpilote=id_pilote) ;
end //
delimiter ;

select E3Q2(1);


#3.	Ecrire une fonction qui renvoie le nombre des avions qui ne sont pas affectés à des vols ;



drop function if exists E3Q3;
delimiter //
create function E3Q3()
returns int
deterministic 
begin
      return (with t1 as (select * from  avion
			where numav not in (select numav from vol))
			select count(*) as nombre from t1) ;
            
 
end //
delimiter ;

select E3Q3();

#4.	Ecrire une fonction qui retourne le numero du plus ancien pilote qui a piloté l’avion dont le numero est passé en paramètre ;
drop function if exists E3Q4;
delimiter //
create function E3Q4(id_avion int)
returns int
deterministic 
begin
declare r int ;
 with t1 as (select distinct numpilote, datedebut from vol join pilote on vol.numpil = pilote.numpilote
 where numav = id_avion
 order by datedebut ),
 t2 as (select min(datedebut) as datedebut from t1)
 select numpilote into r from t1 join t2 using(datedebut) 
 limit 1;
 return r ;
end // 
delimiter ;
 select E3Q4(1);
 

 
 
#5.	Ecrire une fonction table qui retourne le nombre des pilotes dont le salaire est inférieur à une valeur passée comme paramètre ;

#my sql ne permet de créer des fonctions tables.


/*Exercice 4:
Considérant la base de données suivante :
DEPARTEMENT (ID_DEP, NOM_DEP, Ville)
EMPLOYE (ID_EMP, NOM_EMP, PRENOM_EMP, DATE_NAIS_EMP, SALAIRE,#ID_DEP)
*/



drop database if exists employes_202;

create database employes_202 COLLATE "utf8mb4_general_ci";
use employes_202;


create table DEPARTEMENT (
ID_DEP int auto_increment primary key, 
NOM_DEP varchar(50), 
Ville varchar(50));

create table EMPLOYE (
ID_EMP int auto_increment primary key, 
NOM_EMP varchar(50), 
PRENOM_EMP varchar(50), 
DATE_NAIS_EMP date, 
SALAIRE float,
ID_DEP int ,
constraint fkEmployeDepartement foreign key (ID_DEP) references DEPARTEMENT(ID_DEP));

insert into DEPARTEMENT (nom_dep, ville) values 
		('FINANCIER','Tanger'),
		('Informatique','Tétouan'),
		('Marketing','Martil'),
		('GRH','Mdiq');

insert into EMPLOYE (NOM_EMP , PRENOM_EMP , DATE_NAIS_EMP , SALAIRE ,ID_DEP ) values 
('said','said','1990/1/1',8000,1),
('hassan','hassan','1990/1/1',8500,1),
('khalid','khalid','1990/1/1',7000,2),
('souad','souad','1990/1/1',6500,2),
('Farida','Farida','1990/1/1',5000,3),
('Amal','Amal','1990/1/1',6000,4),
('Mohamed','Mohamed','1990/1/1',7000,4);


#1.	Créer une fonction qui retourne le nombre d’employés

drop function if exists E4Q1;
delimiter $$
create function E4Q1()
	returns int
	deterministic 
begin
	return (select count(*)  from employe);
end $$
delimiter ;

SELECT E4Q1();



#2.	Créer une fonction qui retourne la somme des salaires de tous les employés


drop function if exists E4Q2;
delimiter $$
create function E4Q2()
	returns double
	deterministic 
begin
	return (select sum(salaire)  from employe);
end $$
delimiter ;

SELECT E4Q2();

#3.	Créer une fonction pour retourner le salaire minimum de tous les employés



drop function if exists E4Q3;
delimiter $$
create function E4Q3()
	returns double
	deterministic 
begin
	return (select min(salaire)  from employe);
end $$
delimiter ;

SELECT E4Q3();
#4.	Créer une fonction pour retourner le salaire maximum de tous les employés




drop function if exists E4Q4;
delimiter $$
create function E4Q4()
	returns double
	deterministic 
begin
	return (select max(salaire)  from employe);
end $$
delimiter ;

SELECT E4Q4();
#5.	En utilisant les fonctions créées précédemment, Créer une requête pour afficher
# le nombre des employés, la somme des salaires, le salaire minimum et le salaire maximum
select E4Q1() as nombre_employe,
		E4Q2() as sum_salaire,
        E4Q3() as min_salaire,
        E4Q4() as max_salaire;



#6.	Créer une fonction pour retourner le nombre d’employés d’un département donné.



drop function if exists E4Q6;
delimiter $$
create function E4Q6(id int)
	returns int
	deterministic 
begin
	return (select count(id_dep) from employe where id_dep =id);
end $$
delimiter ;
select E4Q6(4);

#7.	Créer une fonction la somme des salaires des employés d’un département donné


drop function if exists E4Q7;
delimiter $$
create function E4Q7(id int)
	returns double
	deterministic 
begin
	return (select sum(salaire) from employe where id_dep =id);
end $$
delimiter ;
select E4Q7(4);
#8.	Créer une fonction pour retourner le salaire minimum des employés d’un département donné

drop function if exists E4Q8;
delimiter $$
create function E4Q8(id int)
	returns double
	deterministic 
begin
	return (select min(salaire) from employe where id_dep =id);
end $$
delimiter ;
select E4Q8(4);

#9.	Créer une fonction pour retourner le salaire maximum des employés d’un département.

drop function if exists E4Q9;
delimiter $$
create function E4Q9(id int)
	returns double
	deterministic 
begin
	return (select max(salaire) from employe where id_dep =id);
end $$
delimiter ;
select E4Q9(4);

#10.	En utilisant les fonctions créées précédemment, 
#Créer une requête pour afficher  les éléments suivants : 
#a.	Le nom de département en majuscule. 
#b.	Le nombre des employé du département
#c.	La somme des salaires du département
#d.	Le salaire minimum du département
#e.	Le salaire maximum du département


select upper(nom_dep) as nom_de_drpartement,
	E4Q6(id_dep) as nb_employes_du_departement,
    E4Q7(id_dep) as somme_des_salaires_du_departement,
    E4Q8(id_dep) as  salaire_minimum_du_d_partement,
    E4Q9(id_dep) as  salaire_maximum_du_drpartement 
    from departement ;
		


#11.	Créer une fonction qui accepte comme paramètres 2 chaines de caractères et elle retourne les deux chaines en majuscules concaténé avec un espace entre eux.

drop function if exists E4Q11;
delimiter $$
create function E4Q11(ch1 varchar(50) , ch2 varchar(50))
	returns varchar(200)
	deterministic 
begin
	return upper(concat(ch1," ",ch2));
end $$
delimiter ;


select E4Q11("hello","issam");