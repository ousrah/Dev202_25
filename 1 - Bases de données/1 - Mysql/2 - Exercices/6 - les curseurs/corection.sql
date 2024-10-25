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

#2 – Ajouter le trigger qui permet de modifier le prix des recettes  lorsqu'on change le prix unitaire d'un ingrédient ( voir le dernier exercice de la série des triggers)

#Base de données ‘Gestion_vols’ :

#1)	Réalisez un curseur en lecture seule avec déplacement vers l’avant qui extrait la liste des pilotes avec pour informations l’identifiant, le nom et le salaire du pilote ;

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

/*3)	Vous allez modifier le curseur précédent pour pouvoir mettre à jour le salaire du pilote. Vous afficherz une ligne supplémentaire à la suite de la liste des vols en précisant l’ancien et le nouveau salaire du pilote.
Le salaire brut du pilote est fonction du nombre de vols auxquels il est affecté :

	Si 0 alors le salaire est 5 000
	Si entre 1 et 3,  salaire de 7 000
	Plus de 3, salaire de 8000
*/

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
