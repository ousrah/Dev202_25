/*EX 1 - Soit la base de données suivante :  (Utilisez celle de la série des fonctions):
Pilote(numpilote,nom,titre,villepilote,daten,datedebut)
Vol(numvol,villed,villea,dated,datea, #numpil,#numav)
Avion(numav,typeav ,capav)*/

use vols_202;

#1 – Ajouter à la table pilote le champ nb d’heures de vols ‘NBHV’ sous la forme  « 00:00:00 ».
alter table pilote add nbhv time default "00:00:00";
alter table vol modify dated datetime;
alter table vol modify datea datetime;

select * from pilote;
delete from vol;
select * from vol;

#2 – Ajouter un déclencheur qui calcule le nombre heures lorsqu’on ajoute un nouveau vol et qui augmente automatiquement le nb d’heures de vols du pilote qui a effectué le vol.

drop trigger if exists E1Q2;
delimiter $$
create trigger E1Q2 after insert on vol for each row
begin
	update pilote set nbhv=sec_to_time(time_to_sec(nbhv)+timestampdiff(second,new.dated,new.datea)) where numpilote=new.numpil;
end$$
delimiter ; 


drop trigger if exists E1Q2;
delimiter $$
create trigger E1Q2 after insert on vol for each row
begin
	update pilote set nbhv=nbhv+timediff(new.datea,new.dated) where numpilote=new.numpil;
end$$
delimiter ; 



select * from vol;
insert into vol values (null,'x','y','2024-10-21 08:00:00', '2024-10-21 10:00:00', 1,1);
insert into vol values (null,'x','y','2024-10-21 08:30:00', '2024-10-21 10:45:00', 2,1);
insert into vol values (null,'y','x','2024-10-21 14:30:00', '2024-10-21 16:45:00', 1,1);

select * from pilote;

#3 – Si on supprime un vol le nombre d’heures de vols du pilote qui a effectué ce vol doit être recalculé. Proposez une solution.
drop trigger if exists E1Q3;
delimiter $$
create trigger E1Q3 after delete on vol for each row
begin
	update pilote set nbhv=nbhv-timediff(old.datea,old.dated) where numpilote=old.numpil;
end$$
delimiter ; 
select * from vol;
delete from vol where numvol = 16;
select * from pilote;
#4 – Si on modifie la date de départ ou d’arrivée d’un vol le nombre d’heures de vols du pilote qui a effectué ce vol doit être recalculé. Proposez une solution.
drop trigger if exists E1Q4;
delimiter $$
create trigger E1Q4 after update on vol for each row
begin
    declare n time ;
    declare o time ;
    set o = timediff(old.datea,old.dated) ;
    set n =timediff(new.datea,new.dated) ;
	update pilote set nbhv=nbhv - o + n where numpilote=old.numpil;
end$$
delimiter ; 
select * from vol;
update vol set datea = '2024-10-21 10:30:00'  where numvol = 15;
select * from pilote;



/*EX 2 - Soit la base de données suivante :  (Utilisez celle de la série des PS):

DEPARTEMENT (ID_DEP, NOM_DEP, Ville)
EMPLOYE (ID_EMP, NOM_EMP, PRENOM_EMP, DATE_NAIS_EMP, SALAIRE, #ID_DEP)*/

use employes_202;
select * from departement;
select * from employe;

#1 – Ajouter le champs salaire moyen dans la table département.
alter table departement add salaire_moyen double default 0;
select * from departement;
delete from employe;
select * from employe;

/*2 – On souhaite que le salaire moyen soit recalculé automatiquement 
si on ajoute un nouvel employé,
 on supprime ou
 on modifie le salaire d’un ou plusieurs employés. Proposez une solution.
 */
 drop trigger if exists E2Q2A;
delimiter $$
create trigger E2Q2A after insert  on Employe for each row
begin
	update departement set salaire_moyen = (select avg(salaire) from Employe where id_dep = new.id_dep)
    where id_dep = new.id_dep ;
end$$
delimiter ; 

 drop trigger if exists E2Q2B;
delimiter $$
create trigger E2Q2B after update  on Employe for each row
begin
	update departement set salaire_moyen = (select avg(salaire) from Employe where id_dep = new.id_dep)
    where id_dep = new.id_dep ;
end$$
delimiter ; 
 drop trigger if exists E2Q2C;
delimiter $$
create trigger E2Q2C after delete  on Employe for each row
begin
	update departement set salaire_moyen = (select avg(salaire) from Employe where id_dep = old.id_dep)
    where id_dep = old.id_dep ;
end$$
delimiter ; 

select * from departement;
select * from employe;
insert into employe values (null,'x','x',null,8000,1);
insert into employe values (null,'y','y',null,6000,1);

delete from employe where id_emp = 9;

update employe set salaire = 9000 where id_emp = 8;

 

/*EX 2 - Soit la base de données suivante : (Utilisez celle de la série des PS):
Recettes (NumRec, NomRec, MethodePreparation, TempsPreparation)
Ingrédients (NumIng, NomIng, PUIng, UniteMesureIng, NumFou)
Composition_Recette (NumRec, NumIng, QteUtilisee)
Fournisseur (NumFou, RSFou, AdrFou)*/

use cuisine_202;
#1 – Ajoutez le champ prix à la table recettes.

alter table recettes add prix double default 0;
select * from recettes;
delete from composition_recette;
select * from composition_recette;




/*2 – On souhaite que le prix de la recette soit calculé automatiquement si 
on ajoute un nouvel ingrédient,
 on supprime un ingrédient ou on modifie 
 la quantité ou le prix d’un ou plusieurs ingrédients. Proposez une solution. */
 
 drop trigger if exists E3Q2a;
delimiter $$
create trigger E3Q2a after insert  on composition_recette for each row
begin
declare p decimal(10,2);
select sum(QteUtilisee * PUIng)into p from composition_recette
	join Ingredients using(NumIng)
	where NumRec=new.NumRec;
 	update Recettes set prix= p where NumRec = new.NumRec ;
end$$
delimiter ; 


select * from recettes;
update recettes set prix = 0;

select * from composition_recette;
insert into composition_recette values (1,1,1);
insert into composition_recette values (1,3,2);

select * from ingredients;
drop trigger if exists E3Q2b;
delimiter $$
create trigger E3Q2b after delete on composition_recette for each row
begin
declare p decimal(10,2);
select sum(QteUtilisee * PUIng)into p from composition_recette
	join Ingredients using(NumIng)
	where NumRec=old.NumRec;
 	update Recettes set prix= p where NumRec = old.NumRec ;
end$$
delimiter ; 
select * from recettes;
select * from composition_recette;

delete from composition_recette where numrec = 1 and numing = 3;


drop trigger if exists E3Q2c;
delimiter $$
create trigger E3Q2c after update on composition_recette for each row
begin
declare p decimal(10,2);
select sum(QteUtilisee * PUIng)into p from composition_recette
	join Ingredients using(NumIng)
	where NumRec=old.NumRec;
 	update Recettes set prix= p where NumRec = old.NumRec ;
end$$
delimiter ; 

select * from recettes;
select * from composition_recette;


update composition_recette set qteutilisee = 2 where numrec = 1 and numing = 1;


 
 
