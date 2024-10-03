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
    deterministic
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

