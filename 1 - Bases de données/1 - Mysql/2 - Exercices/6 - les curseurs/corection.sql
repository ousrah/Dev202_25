#Objectif : Manipuler les curseurs/imbriquer les curseurs


#1 - Terminer la questions 9 du dernier exercice des procedures stockées

/*PS9 : Qui affiche pour chaque recette :
Un message sous la forme : "Recette : (Nom de la recette), temps de préparation : (Temps)
La liste des ingrédients avec pour chaque ingrédient le nom et la quantité
Un message sous la forme : Sa méthode de préparation est : (Méthode)
Si le prix de reviens pour la recette est inférieur à 50 DH afficher le message
'Prix intéressant'*/

use cuisine_202;


drop procedure if exists ps9;
delimiter $$
create procedure ps9()
begin
	declare nom_rec varchar(100);
    declare temp_prep int ;
    declare num_rec int;
    declare prix double;
    declare methode varchar(100);
    declare flag boolean default false ;
    declare c cursor for select NumRec,nomrec,tempspreparation, methodepreparation from Recettes ;
    declare continue handler for not found set flag = true ;
    open c ;
    b1 : loop
			fetch c into num_rec,nom_rec,temp_prep, methode ;
				if flag then 
					leave b1 ;
				end if;
             select concat("Nom : ",nom_rec," - Temps : ",temp_prep) as "recette";
             select NomIng,QteUtilisee from composition_recette
									   join ingredients using(NumIng)
                                       where NumRec=num_rec and QteUtilisee!=0;
			select concat("sa methode de préparation est ", methode) as "methode";
             
             select sum(puIng*QteUtilisee) into prix from ingredients 
									   join composition_recette using(NumIng)
                                       where NumRec=num_rec;
			if prix < 50 then
				select concat("prix interessant : ",format(prix,2)) as "prix";
            end if;
    end loop b1;
    close c;
end $$
delimiter ;
call ps9;

select * from composition_recette;

#2 – Ajouter le trigger qui permet de modifier le prix des recettes  
#lorsqu'on change le prix unitaire d'un ingrédient ( voir le dernier exercice de la série des triggers)

/*1 - strucutre du trigger
2 - recupérer la liste des recettes dont le prix doit être modifié
3 - parcourir la liste des recettes avec un curseur et sortir lorsqu'on atteind la fin
4 - calculer le nouveau prix pour chaque recette
5 - modifier l'ancien prix par le nouveau pour chaque recette.*/


use cuisine_202;

alter table recettes add prix double default 0;
drop trigger if exists ex1 ; 
delimiter $$ 
create trigger ex1 after update on Ingredients for each row 
begin 
	declare id int;
    declare flag boolean default false;
    declare p double;
	declare c1 cursor for select distinct numrec from Ingredients  join composition_recette c using(numIng) where c.NumIng = new.numing ;
    declare continue handler for not found set flag = true;
	open c1;
		b1:loop
			fetch c1 into id;
			if flag then
				leave b1;
            end if;
			#calcule du nouveau prix de la recette en cours
            select sum(puing*QteUtilisee) into p
            from ingredients join composition_recette using (numIng)
            where numrec=id;
            #modifier l'ancien prix pour le nouveaux
            update recettes  set prix =p where numrec=id;
        end loop b1;
	close c1;	
end $$  
delimiter ; 

update ingredients set puing = 7 where numing = 1;

select * from recettes;
select * from composition_recette where numing = 1;
use vols_202;
select * from pilote;
alter table pilote 
add salaire double default 5000;
#Base de données ‘Gestion_vols’ :
#1)	Réalisez un curseur  qui extrait la liste des pilotes avec pour informations l’identifiant, le nom et le salaire du pilote ;


drop procedure if exists E1Q1;
delimiter $$
create procedure E1Q1()
begin
declare flag bool default false;
declare pil int;
declare nompil varchar(50);
declare salairepil double;
declare c1 cursor for select numpilote, nom, salaire from pilote;
declare continue handler for not found set flag = true;
open c1;
	l1:loop
		fetch c1 into pil, nompil, salairepil;
        if flag then
			leave l1;
        end if;
        select pil,nompil,salairepil ;
    end loop l1;
close c1;
end $$
delimiter ;
call E1Q1;

#Affichez les informations à l’aide de l’instruction Select (print)
/*2)	Complétez le script précédent en imbriquant un deuxième curseur qui va préciser pour chaque pilote, quels sont les vols effectués par celui-ci.

Vous imprimerez alors, pour chaque pilote une liste sous la forme suivante :
- Le pilote ‘ xxxxx xxxxxxxxxxxxxxxxx est affecté aux vols :
       Départ : xxxx  Arrivée : xxxx
       Départ : xxxx  Arrivée : xxxx
       Départ : xxxx  Arrivée : xxxx
-Le pilote ‘ YYY YYYYYYYY est affecté aux vols :
       Départ : xxxx  Arrivée : xxxx
       Départ : xxxx  Arrivée : xxxx
*/

select * from vol;


#methode 1
drop procedure if exists E1Q2;
delimiter $$
create procedure E1Q2()
begin
declare flag bool default false;
declare pil int;
declare nompil varchar(50);
declare salairepil double;
declare vD varchar(50);
declare vA varchar(50);
declare c1 cursor for select numpilote, nom, salaire from pilote;
declare c2 cursor for select villed, villea from vol where numpil = pil;
declare continue handler for not found set flag = true;
open c1;
	l1:loop
		fetch c1 into pil, nompil, salairepil;
        if flag then
			leave l1;
        end if;
        select pil,nompil,salairepil ;
        open c2;
			l2:loop
				fetch c2 into vD,vA;
				if flag then 
					leave l2;
				end if;
				select concat("Le pilote ",nompil," est affecté aux vols : Depart :",vD," - Arrivé :",vA) as "voyage";
			end loop l2;
        close c2;
        set flag=false;
    end loop l1;
close c1;
end $$
delimiter ;
call E1Q2;

#methode 2

drop procedure if exists E1Q2;
delimiter $$
create procedure E1Q2()
begin
declare flag bool default false;
declare pil int;
declare nompil varchar(50);
declare salairepil double;
declare c1 cursor for select numpilote, nom, salaire from pilote;
declare continue handler for not found set flag = true;
open c1;
	l1:loop
		fetch c1 into pil, nompil, salairepil;
        if flag then
			leave l1;
        end if;
        select pil,nompil,salairepil ;
        select concat("Le pilote ",nompil," est affecté aux vols : ") as "pilote";
        begin
			declare flag2 bool default false;
			declare vD varchar(50);
			declare vA varchar(50);
			declare c2 cursor for select villed, villea from vol where numpil = pil;
			declare continue handler for not found set flag2 = true;
			open c2;
				l2:loop
					fetch c2 into vD,vA;
					if flag2 then 
						leave l2;
					end if;
					select concat("Depart :",vD," - Arrivé :",vA) as "voyage";
				end loop l2;
			close c2;
        end;
    end loop l1;
close c1;
end $$
delimiter ;
call E1Q2;




/*3)	Vous allez modifier le curseur précédent pour pouvoir mettre à jour le salaire du pilote. Vous afficherz une ligne supplémentaire à la suite de la liste des vols en précisant l’ancien et le nouveau salaire du pilote.
Le salaire brut du pilote est fonction du nombre de vols auxquels il est affecté :

	Si 0 alors le salaire est 5 000
	Si entre 1 et 3,  salaire de 7 000
	Plus de 3, salaire de 8000
*/

#methode 1
drop procedure if exists E1Q3;
delimiter $$
create procedure E1Q3()
begin
declare flag bool default false;
declare pil int;
declare nompil varchar(50);
declare salairepil double;
declare salairenv double ;
declare countp int;
declare c1 cursor for select numpilote, nom, salaire from pilote;
declare continue handler for not found set flag = true;
open c1;
	l1:loop
		fetch c1 into pil, nompil, salairepil;
        if flag then
			leave l1;
        end if;
        select pil,nompil,salairepil ;
        select concat("Le pilote ",nompil," est affecté aux vols : ") as "pilote";
        select count(*) into countp from vol where numpil = pil;
           
        begin
			declare flag2 bool default false;
			declare vD varchar(50);
			declare vA varchar(50);
			declare c2 cursor for select villed, villea from vol where numpil = pil;
             
			declare continue handler for not found set flag2 = true;
			open c2;
				l2:loop
					fetch c2 into vD,vA;
					if flag2 then 
						leave l2;
					end if;
					select concat("Depart :",vD," - Arrivé :",vA) as "voyage";
				end loop l2;
			close c2;
        end;
        if countp =0 then 
			set salairenv= 5000;
		elseif countp between 1 and 3  then 
			set salairenv= 7000;
		else 
			set salairenv= 8000;
		end if ;
		update pilote set salaire = salairenv where numpilote=pil;
		select concat(" salaire apres",salairepil," noveau salaire",salairenv)	;
    end loop l1;
close c1;
end $$
delimiter ;
call E1Q3;
update pilote set salaire = 0;
select * from pilote;



#methode 2
drop procedure if exists E1Q3;
delimiter $$
create procedure E1Q3()
begin
declare flag bool default false;
declare pil int;
declare nompil varchar(50);
declare salairepil double;
declare salairenv double ;
declare countp int;
declare c1 cursor for select numpilote, nom, salaire from pilote;
declare continue handler for not found set flag = true;
open c1;
	l1:loop
		fetch c1 into pil, nompil, salairepil;
        if flag then
			leave l1;
        end if;
        select pil,nompil,salairepil ;
        select concat("Le pilote ",nompil," est affecté aux vols : ") as "pilote";
        set countp=0;
        begin
			declare flag2 bool default false;
			declare vD varchar(50);
			declare vA varchar(50);
			declare c2 cursor for select villed, villea from vol where numpil = pil;
             
			declare continue handler for not found set flag2 = true;
			open c2;
				l2:loop
					fetch c2 into vD,vA;
					if flag2 then 
						leave l2;
					end if;
					select concat("Depart :",vD," - Arrivé :",vA) as "voyage";
                    set countp=countp+1;
				end loop l2;
			close c2;
        end;
        if countp =0 then 
			set salairenv= 5000;
		elseif countp between 1 and 3  then 
			set salairenv= 7000;
		else 
			set salairenv= 8000;
		end if ;
		update pilote set salaire = salairenv where numpilote=pil;
		select concat(" salaire apres",salairepil," noveau salaire",salairenv)	;
    end loop l1;
close c1;
end $$
delimiter ;
call E1Q3;
update pilote set salaire = 0;
select * from pilote;


/*Exercice 2
Soit la base de données suivante

Employé :

Matricule	nom	prénom	état
1453	Lemrani	Kamal	fatigué
4532	Senhaji	sara	En forme
			…
			..

Groupe :
Matricule	Groupe
1453	Administrateur
1453	Chef
4532	Besoin vacances
…	
On désire ajouter les employés dont l’état est fatigué dans le groupe ‘besoin vacances’ dans la table Groupe;
Utiliser un curseur ;
*/


drop database if exists vacances_202;
create database vacances_202 collate utf8mb4_general_ci;
use vacances_202;

create table employe (matricule int primary key, nom varchar(100), prenom varchar(100),etat  varchar(100));
create table groupe (matricule int , groupe varchar(100), constraint fk_groupe_employe foreign key (matricule) references employe(matricule) on delete cascade on update cascade);

insert into employe  (matricule, nom, etat) values
(1453,	'amal'	,'fatigué'),
(4532	,'sara'	,'En forme'),
(1454,	'Kamal'	,'fatigué'),
(4535	,'karima'	,'En forme'),
(1456,	'hasna'	,'fatigué'),
(4537	,'moad'	,'En forme'),
(1458,	'ziad'	,'fatigué'),
(4539	,'nada'	,'En forme'),
(1450,	'omar'	,'fatigué'),
(4531	,'mouna'	,'En forme');


select * from employe;

select * from groupe;

drop procedure if exists e2 ;
delimiter $$
create procedure e2()
begin
	declare mat int ;
    declare flag boolean default false ;
	declare c cursor for select matricule from employe where etat = 'fatigué';
    declare continue handler for not found set flag = true ;
    open c;
        b1 : loop
			fetch c into mat ;
			if flag then
				leave b1 ;
			end if;
			insert into  groupe value(mat , 'Besoin vacances ');
        end loop b1 ;
    close c;
end $$
delimiter ;

call e2;


select * from groupe;

delete from groupe;

#methode sans curseur

insert  into groupe select matricule, 'besoin vacance' from employe where etat = 'fatigue';

select ceiling(rand()*19);
