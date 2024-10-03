#Les instructions de controles

# les blocks d'instructions

# la declaration
use courses202;
drop function if exists somme;
delimiter $$
create function somme()
	returns int
	deterministic 
begin
	declare c int; -- la declaration doit être ecrite juste après begin
	return c;  -- returns null
end $$
delimiter ;

select somme();


drop function if exists somme;
delimiter $$
create function somme()
	returns int
    deterministic
begin
	declare c int default 3;
    return c;   # returns 3
end $$
delimiter ;

select somme();



drop function if exists somme;
delimiter $$
create function somme()
	returns int
    deterministic
begin
	declare a ,b int default 3;
    return a+b;
end $$
delimiter ;

select somme();




# l'affectation


drop function if exists somme;
delimiter $$
create function somme()
	returns int
    deterministic
begin
	declare a int default 5;
    declare b int default 3;
    declare c int;
    set c = a+b; #affectation
    return c;
end $$
delimiter ;

select somme();





drop function if exists somme;
delimiter $$
create function somme()
	returns int
    deterministic
begin
	declare a int default 5;
    declare b int default 3;
    declare c int;
	select a+b into c ; #affectation
    return c;
end $$
delimiter ;

select somme();


# les conditions

drop function if exists compare;
delimiter $$
create function compare()
	returns varchar(50)
    deterministic
begin
	declare a,b int;
    set a = 14;
    set b = 44;
    if a>b then
		return concat(a, " est plus que grande que " , b);
	else
		if a=b then
			return "les deux valeurs sont égaux";
		else
			return concat(a, " est plus que petite que " , b);
		end if;
	end if;
end $$
delimiter ;

select compare();




drop function if exists compare;
delimiter $$
create function compare()
	returns varchar(50)
    deterministic
begin
	declare a,b int;
    set a = 140;
    set b = 44;
    if a>b then
		return concat(a, " est plus que grande que " , b);
	elseif a=b then
			return "les deux valeurs sont égaux";
	else
			return concat(a, " est plus que petite que " , b);
	end if;
end $$
delimiter ;

select compare();


# faire attention a ce genres d'algothmes utilisez else et elseif
drop function if exists compare;
delimiter $$
create function compare()
	returns varchar(50)
    deterministic
begin
	declare a,b int;
    set a = 140;
    set b = 44;
    if a>b then
		return concat(a, " est plus que grande que " , b);
	end if;
	if a=b then
			return "les deux valeurs sont égaux";
	end if;
    if a<b then
			return concat(a, " est plus que petite que " , b);
	end if;
end $$
delimiter ;

select compare();


#passage des parametres



drop function if exists compare;
delimiter $$
create function compare(a int, b int)
	returns varchar(50)

begin
    if a>b then
		return concat(a, " est plus que grande que " , b);
	elseif a=b then
			return "les deux valeurs sont égaux";
	else
			return concat(a, " est plus que petite que " , b);
	end if;
end $$
delimiter ;

select compare(4,4);


# exercice 1
#ecrire une fonction qui accept 3 valeurs entier a, b et c et qui affiche la valeur la plus grande

drop function if exists calculmax;
delimiter $$
create function calculmax( a int ,b int,c int)
	returns int 
	deterministic 
begin
	declare d int;
	if (a>=b and a>=c)then 
		set d=a;
	elseif (b>=a and b>=c)then 
		set d=b;
	else
		set d=c;
	end if;
	return d;
end $$
delimiter ;
select calculmax(1,2,3); -- 9 operations
select calculmax(4,2,3);
select calculmax(2,4,3);
select calculmax(4,4,3);
select calculmax(3,4,4);
select calculmax(4,3,4);
select calculmax(4,4,4);
select calculmax(13,4,4);




drop function if exists calculmax;
delimiter $$
create function calculmax( a int ,b int,c int)
	returns int 
	deterministic 
begin
    declare max int default a;
    if b>max then
		set max = b;
	end if;
    if c>max then
		set max = c;
	end if;
	return max;
end $$
delimiter ;
select calculmax(1,2,3); -- 6 operations
select calculmax(4,2,3);
select calculmax(2,4,3);
select calculmax(4,4,3);
select calculmax(3,4,4);
select calculmax(4,3,4);
select calculmax(4,4,4);
select calculmax(13,4,4);



drop function if exists calculmax;
delimiter $$
create function calculmax( a int ,b int,c int)
	returns int 
	deterministic 
begin
	if a>b then
		if a>c then
			return a;
		else
			return c;
        end if;
	else
		if b>c then
			return b;
		else
			return c; 
		end if;
	end if;
end $$
delimiter ;
select calculmax(1,2,3); -- 3 operation
select calculmax(4,2,3);
select calculmax(2,4,3);
select calculmax(4,4,3);
select calculmax(3,4,4);
select calculmax(4,3,4);
select calculmax(4,4,4);
select calculmax(13,4,4);




#exercice 2 :
/*
un patron décide de participer aux prix de repas de ces employer 
il instaure les règles suivantes :
le pourcentage de la participation par defaut est 20% du prix de repas
si le salaire est inférieur à 2500 dh le taux est augmenté de 15%
si l'employé est marié le taux est augmenté de 5%
pour chaque enfant a charge le taux est augmenté de 10%
le plafond maximal est 60%
on souhaite ecrire une fonction qui reçoit tous les paramètres 
et qui affiche le montant de la participation selon 
le prix de repas acheté par l'employé
*/


     
     
     
     





#exercice 3
/*
ecrire une fonction qui permet de resoudre une equation premier degrès
Ax+B=0

3x+2=0

Rappels mathématique
si A = 0 et B = 0  x = R
si A = 0 et B <> 0 x = impossible
si A <>  0 x = -b/a
*/




#exercice 4
/*
ecrire une fonction qui permet de resoudre une equation deuxième degrès
Ax²+Bx+C=0
2x²+3x+0=0

Rappels mathématique
si A = 0 et B = 0 et C = 0  x1 = x2 = R
si A = 0 et B = 0  et C <> 0 x1 = x2 = impossible
si A = 0 et B <> 0  x= -c/b
si A <> 0 
	 delta  = B²-4AC
     si delta < 0 x1 = impossible
     si delta = 0 x1 = x2 = -b/2a
      si delta > 0 x1 = (-b-racine(delta))/2a  et x2 =  (-b+racine(delta))/2a   
    */






# les boucles

#les fonctions

#les procedures stockées

#les tables temporaires

#les transactions

#la gestion des erreurs

#les declencheurs - les triggers

#les curseurs

#la gestion des utilisateurs

#la sauvegarde et la restauration

