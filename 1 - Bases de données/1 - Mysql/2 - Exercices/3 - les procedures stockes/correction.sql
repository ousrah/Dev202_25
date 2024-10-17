/*Exercice 1 :
On considère la table suivante :
Produit (NumProduit, libelle, PU, stock)*/

drop database if exists produits_202;

create database produits_202 collate utf8mb4_general_ci;
use produits_202;

create table Produit(
numProduit int auto_increment primary key,
libelle varchar(50) ,
PU float ,
stock int);


insert into produit values (1,'table',350,100),
							(2,'chaise',100,10),
                            (3,'armoire',2350,10),
                            (4,'pc',3500,20),
                            (5,'clavier',150,200),
                            (6,'souris',50,200),
                            (7,'ecran',2350,70),
                            (8,'scanner',1350,5),
                            (9,'imprimante',950,5);

#1.	Ecrire une PS qui affiche tous les produits ;
drop procedure if exists E1Q1;
delimiter $$
create procedure E1Q1()
begin
     select * from produit ;
end $$
delimiter ;
call E1Q1();
#2.	Ecrire une procédure stockée qui affiche les libellés des produits dont le stock est inférieur à 10 ;
drop procedure if exists E1Q2;
delimiter $$
create procedure E1Q2()
begin
     select libelle from produit where stock <10 ;
end $$
delimiter ;
call E1Q2();
#3.	Ecrire une PS qui admet en paramètre un numéro de produit et affiche 
#un message contenant le libellé, le prix et la quantité en stock équivalents, 
#si l’utilisateur passe une valeur lors de l’exécution de la procédure ;


drop procedure if exists E1Q3;
delimiter $$
create procedure E1Q3( x int)
begin
	if x is not null then
		select concat("libelle : ", libelle ," prix : ",pu, " stock : ", stock) as message from produit where numProduit = x;
	end if;
END$$
delimiter ;
call E1Q3(null) ;

#4.	Ecrire une PS qui permet de supprimer un produit en passant son numéro comme paramètre ;

drop procedure if exists E1Q4;
delimiter $$
create procedure E1Q4(id int)
begin
     delete from produit where numProduit = id ;
end $$
delimiter ;
call E1Q4(9);

select * from produit;


/*Exercice 2 :
Ecrire une PS qui permet de mettre à jour le stock après une opération de vente de produits, 
la PS admet en paramètre le numéro d’article à vendre et la quantité à vendre puis retourne un message suivant les cas :
a.	Opération impossible : si la quantité est supérieure au stock de l’article ;
b.	Besoin de réapprovisionnement si stock-quantité < 10
c.	Opération effectuée  avec succès, la nouvelle valeur du stock est (afficher la nouvelle valeur) ;
*/
drop procedure if exists E2;
delimiter $$
create procedure E2(p int,q int,out r varchar(40))
begin
		declare st int;
		select stock into st from produit where numProduit=p;
		if st is not null then
			if q>st then 
				set r = concat("Opération impossible");
			else
				update produit set stock = stock - q where  numProduit=p;
				if st-q<10 then 
					set r = concat("Besoin de réapprovisionnement");
				else 
					set r = concat("Opération effectuée  avec succès");
				end if;
			end if;
        end if;
end $$
delimiter ;

select * from produit;
call E2(1,12,@m);
select @m;



#Exercice 3 :
#Ecrire une PS qui retourne le prix moyen des produits (utiliser un paramètre OUTPUT) ; Exécuter la PS ;


drop procedure if exists E3;
delimiter $$
create procedure E3(out a double)
begin
     select avg(pu) into a from produit ;
end $$
delimiter ;
call E3(@a);
select @a;


#Exercice 4 :
#Créer une procédure stockée qui accepte comme paramètre un entier et retourne le factoriel de ce nombre.

drop procedure if exists E4;
delimiter $$
create procedure E4(a int, out fact bigint)
begin
    if a<0 then 
		select concat("impossible") as messg;
	else
		set fact=1;
        while a>1 do 
			set fact=fact*a;
            set a=a-1;
		end while;
	end if;
end $$
delimiter ;
call E4(5,@f);
select @f;
call E4(1,@f);
select @f;
call E4(0,@f);
select @f;
call E4(-1,@f);
select @f;


/*Exercice 5 :
1.	Créer une procédure stockée qui accepte les paramètres suivants : 
a.	 2 paramètres de type entier  
b.	 1 paramètre de type caractère.
c.	1 paramètre output de type entier
La procédure doit enregistrer le résultat de calcul entre les deux nombres selon l’opérateur passé dans le troisième paramètre (+,-,%,/,*). 
*/

drop procedure if exists EX5;
delimiter $$
create procedure EX5(in a int, in b int , in  op varchar(1), out r varchar(50))
begin
	case op
		when '+' then set r=format(a+b,2);
        when '-' then set r=format(a-b,2);
        when '/' then 
			if b=0 then set r="impossible de diviser par zero" ;
            else
            set r =format(a/b,2);
            end if;
		when '*' then set r=format(a*b,2);
        when '%' then set r=format(a%b,2);
        else
			set r ="opérateur incorrect";
	end case;
end $$
delimiter ;
call EX5(3,0,'/',@r);
select @r as resultat;
call EX5(3,2,'/',@r);
select @r as resultat;
call EX5(3,2,'+',@r);
select @r as resultat;
call EX5(3,2,'-',@r);
select @r as resultat;
call EX5(3,2,'*',@r);
select @r as resultat;
call EX5(3,2,'$',@r);
select @r as resultat;
/*Exercice 6 :
Soit la base de données suivante :
Recettes (NumRec, NomRec, MethodePreparation, TempsPreparation)
Ingrédients (NumIng, NomIng, PUIng, UniteMesureIng, NumFou)
Composition_Recette (NumRec, NumIng, QteUtilisee)
Fournisseur (NumFou, RSFou, AdrFou)
Créer les procédures stockées suivantes :*/


drop database if exists cuisine_202;
create database cuisine_202;
use cuisine_202;
create table Recettes (
NumRec int auto_increment primary key, 
NomRec varchar(50), 
MethodePreparation varchar(60), 
TempsPreparation int
);
create table Fournisseur (
NumFou int auto_increment primary key, 
RSFou varchar(50), 
AdrFou varchar(100)
);
create table Ingredients (
NumIng int auto_increment primary key,
NomIng varchar(50), 
PUIng float, 
UniteMesureIng varchar(20), 
NumFou int,
   constraint  fkIngredientsFournisseur foreign key (NumFou) references Fournisseur(NumFou)
);
create table Composition_Recette (
NumRec int not null,
constraint  fkCompo_RecetteRecette foreign key (NumRec) references Recettes(NumRec), 
NumIng int not null ,
  constraint  fkCompo_RecetteIngredients foreign key (NumIng) references Ingredients(NumIng),
QteUtilisee int,
constraint  pkRecetteIngredients primary key (NumIng,NumRec)
);


INSERT INTO Fournisseur (RSFou, AdrFou) VALUES
('Fournisseur A', '123 Rue des Oliviers, Casablanca'),
('Fournisseur B', '456 Avenue des Pâtes, Rabat'),
('Fournisseur C', '789 Boulevard des Epices, Marrakech');


INSERT INTO Fournisseur (RSFou, AdrFou) VALUES
('test', 'test');


INSERT INTO Ingredients (NomIng, PUIng, UniteMesureIng, NumFou) VALUES
('Farine', 3.50, 'kg', 1),
('Oeufs', 0.20, 'unité', 1),
('Beurre', 8.00, 'kg', 2),
('Sucre', 2.50, 'kg', 1),
('Lait', 1.00, 'litre', 2),
('Poulet', 6.00, 'kg', 3),
('Tomates', 2.00, 'kg', 3),
('Oignon', 1.20, 'kg', 3),
('Ail', 1.80, 'kg', 3),
('Poivre', 15.00, 'kg', 2);
INSERT INTO Recettes (NomRec, MethodePreparation, TempsPreparation) VALUES
('Gâteau au chocolat', 'Mélanger les ingrédients, cuire au four', 45),
('Crêpes', 'Mélanger, faire cuire des petites galettes', 20),
('Poulet rôti', 'Assaisonner et cuire le poulet au four', 60),
('Salade de tomates', 'Couper et mélanger les ingrédients', 10),
('Omelette', 'Battre les oeufs et cuire à la poêle', 10),
('Pain maison', 'Pétrir et cuire au four', 90),
('Soupe à l\'oignon', 'Faire revenir les oignons et cuire dans un bouillon', 40),
('Poulet curry', 'Faire cuire le poulet et les épices', 50),
('Tarte aux pommes', 'Préparer la pâte et garnir avec les pommes', 60),
('Gratin dauphinois', 'Couper les pommes de terre, ajouter la crème et cuire', 70);

INSERT INTO Composition_Recette (NumRec, NumIng, QteUtilisee) VALUES
-- Gâteau au chocolat
(1, 1, 1), -- Farine
(1, 2, 3), -- Oeufs
(1, 3, 0.2), -- Beurre
(1, 4, 0.5), -- Sucre
(1, 5, 0.25), -- Lait

-- Crêpes
(2, 1, 0.5), -- Farine
(2, 2, 2), -- Oeufs
(2, 3, 0.1), -- Beurre
(2, 5, 0.3), -- Lait

-- Poulet rôti
(3, 6, 1), -- Poulet
(3, 8, 0.1), -- Oignon
(3, 9, 0.05), -- Ail
(3, 10, 0.01), -- Poivre

-- Salade de tomates
(4, 7, 0.5), -- Tomates
(4, 8, 0.1), -- Oignon
(4, 9, 0.02), -- Ail

-- Omelette
(5, 2, 3), -- Oeufs
(5, 3, 0.05), -- Beurre
(5, 9, 0.01), -- Ail
(5, 10, 0.01), -- Poivre

-- Pain maison
(6, 1, 0.8), -- Farine
(6, 4, 0.2), -- Sucre
(6, 5, 0.5), -- Lait

-- Soupe à l'oignon
(7, 8, 0.5), -- Oignon
(7, 9, 0.05), -- Ail
(7, 10, 0.01), -- Poivre

-- Poulet curry
(8, 6, 0.8), -- Poulet
(8, 8, 0.1), -- Oignon
(8, 9, 0.05), -- Ail
(8, 10, 0.02), -- Poivre

-- Tarte aux pommes
(9, 1, 0.3), -- Farine
(9, 3, 0.15), -- Beurre
(9, 4, 0.2), -- Sucre

-- Gratin dauphinois
(10, 5, 0.7), -- Lait
(10, 8, 0.2), -- Oignon
(10, 10, 0.01); -- Poivre



#PS1 : Qui affiche la liste des ingrédients avec pour chaque ingrédient 
#le numéro, le nom et la raison sociale du fournisseur.

drop procedure if exists E6PS1;
delimiter $$
create procedure E6PS1()
begin
	select NumIng , NomIng ,rsfou
    from ingredients 
    join Fournisseur using(numfou) ;
end $$
delimiter ;
call E6PS1();



#PS2 : Qui affiche pour chaque recette le nombre d'ingrédients et le montant cette recette
drop procedure if exists E6PS2;
delimiter &&
create procedure E6PS2()
begin
select r.NumRec , r.NomRec , count(i.NumIng) as nombreingrediants
       , round(sum(i.PUIng * cr.QteUtilisee),2) as montant
from recettes r
join composition_recette cr using(NumRec)
join ingredients i using(NumIng)
group by r.NumRec , r.NomRec;
end &&
delimiter ;
call E6PS2();






#PS3 : Qui affiche la liste des recettes qui se composent de plus de 10 ingrédients
# avec pour chaque recette le numéro et le nom

drop procedure if exists E6PS3;
delimiter &&
create procedure E6PS3()
begin
select NumRec , NomRec 
from recettes 
join composition_recette using(NumRec)
group by NumRec , NomRec
 having count(NumIng) > 10 ;
end &&
delimiter ;
call E6PS3();



#PS4 : Qui reçoit un numéro de recette et qui retourne son nom


drop procedure if exists E6PS4;
delimiter &&
create procedure E6PS4(id int ,out nom varchar(50))
begin
select nomrec into nom from recettes where numrec = id;
end &&
delimiter ;
call E6PS4(3,@n);
select @n;







#PS5 : Qui reçoit un numéro de recette. Si cette recette a au moins un ingrédient,
-- la procédure retourne son meilleur ingrédient (celui qui a le montant le plus bas) 
-- sinon elle ne retourne "Aucun ingrédient associé"
drop procedure if exists E6ps5;
delimiter $$
create procedure E6ps5 (num int, out meilleur_ing varchar(50))
begin 
	if exists (select * from composition_recette where numrec = num) then
		select noming into meilleur_ing
		from ingredients join composition_recette using (numing)
		where numrec =num
		order by puing
		limit 1;
	else
		set meilleur_ing = "Aucun ingrédient associé";
	end if;
end $$
delimiter ;

call E6ps5(13,@n);
select @n;

with t1 as (select noming, puing 
from ingredients join composition_recette using (numing)
where numrec =3),
t2 as (select min(puing) puing from t1)
select noming from t1 join t2 using (puing) limit 1;
;


select noming
from ingredients join composition_recette using (numing)
where numrec =1
order by puing
limit 1;




#PS6 : Qui reçoit un numéro de recette et qui affiche la liste des ingrédients correspondant à 
#cette recette avec pour chaque ingrédient le nom, la quantité utilisée et le montant

drop procedure if exists E6Q6;
delimiter $$

create procedure E6Q6(n int)
begin
	select noming,qteutilisee, format(puing*qteutilisee,2) as montant
	from Composition_recette
	join ingredients as i on Composition_recette.numing= i.numing
	where numrec= n ;
end$$
delimiter ;
call E6Q6(1);



#PS7 : Qui reçoit un numéro de recette et qui affiche :
#Son nom (Procédure PS_4)
#La liste des ingrédients (procédure PS_6)
#Son meilleur ingrédient (PS_5)

drop procedure if exists E6Q7;
delimiter $$
create procedure E6Q7(n int)
begin
	call E6ps4(n,@r);
    select @r;
	call E6ps5(n,@r);
    select @r;
	call E6Q6(n);
    
    
end $$
delimiter ;

call E6Q7(3);

#PS8 : Qui reçoit un numéro de fournisseur vérifie si ce fournisseur existe. 
#Si ce n'est pas le cas afficher le message 'Aucun fournisseur ne porte ce numéro' Sinon vérifier,
# s'il existe des ingrédients fournis par ce fournisseur si c'est le cas afficher la liste
# des ingrédients associés (numéro et nom) Sinon afficher un message 'Ce fournisseur n'a aucun ingrédient 
#associé. Il sera supprimé' et supprimer ce fournisseur

drop procedure if exists ex6q8;
delimiter $$
create procedure ex6q8(n int)
begin 
    if exists(select*from fournisseur where numfou =n ) then
		if exists(select*from  ingredients  where numfou=n) then
			select numing,noming from  ingredients  where numfou=n;
        else 
			select "Ce fournisseur n'a aucun ingredient associe,Il sera supprime"; 
            delete from fournisseur where numfou=n;
        end if;
    else
      select concat("pas de fournisseur avec le numero",n);
	end if;
end $$
delimiter ;
call ex6q8(4);

select * from fournisseur;




/*PS9 : Qui affiche pour chaque recette :
Un message sous la forme : "Recette : (Nom de la recette), temps de préparation : (Temps)
La liste des ingrédients avec pour chaque ingrédient le nom et la quantité
Un message sous la forme : Sa méthode de préparation est : (Méthode)
Si le prix de reviens pour la recette est inférieur à 50 DH afficher le message
'Prix intéressant'
*/