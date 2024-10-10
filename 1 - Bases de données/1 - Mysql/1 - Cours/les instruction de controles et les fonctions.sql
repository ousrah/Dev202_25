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

drop function if exists remise;
delimiter $$
create function remise( prix_repas double ,salaire double,marie boolean,kids int)
	returns varchar(40) 
	deterministic 
begin
    declare r double default 0.2;
	if salaire<2500 then
		set r=r+0.15;
	end if;
    if marie=true then 
		set r=r+0.05;
	end if;
	set r=r+(0.10*kids);
    if r>0.6 then 
		set r=0.6;
	end if;
    return concat('tu vas recevoir ',prix_repas*r,' du cash back');
end $$
delimiter ;
select remise(100,2000,true,5);
select remise(100,8000,false,0);










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


drop function if exists eq1d;
delimiter //
create function eq1d(a int, b int)
	returns varchar(45)
    deterministic
begin
	if a = 0 then
		if b=0 then
			return "R";
		else
			return "Impossible";
        end if;
	else
		return -b/a;
	end if;
end //
delimiter ;

select eq1d(0,0);
select eq1d(0,2);
select eq1d(2,1);
select eq1d(2,0);



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



drop function if exists eq2d;
delimiter //
create function eq2d(a int, b int, c int)
	returns varchar(45)
    deterministic
begin
	declare d  double;
	if a = 0 then
		if b=0 then
			if c = 0 then
				return "R";
			else
				return "Impossible";
			end if;
		else
			return -c/b;
		end if;
	else
		set d = pow(b,2)-(4*a*c);
        if d<0 then
			return 'impossible dans R';
        elseif d=0 then
			return concat('x1=x2=',-b/(2*a)); 
        else
			return concat('x1=',(-b-sqrt(d))/(2*a),' x2=', (-b+sqrt(d))/(2*a)) ; 
        end if;
	end if;
end //
delimiter ;

select eq2d(0,0,0);
select eq2d(0,0,1);
select eq2d(0,2,1);
select eq2d(2,4,2);
select eq2d(2,6,2);
select eq2d(2,2,2);


#l'instruction case


drop function if exists feuRouge;
delimiter $$
create function feuRouge(color varchar(10))
	returns varchar(45)
    deterministic
begin
	declare r varchar(45);
    case color
    when "red" then set r = "stop";
    when "green" then set r = "go";
    when "orange" then set r = "calm down";
    else
		set r = "error";
    end case;
    return r;
end $$
delimiter ;

select feuRouge("black");




drop function if exists feuRouge;
delimiter $$
create function feuRouge(color varchar(10))
	returns varchar(45)
    deterministic
begin
	declare r varchar(45);
    case 
		when color="red" then set r = "stop";
		when color="green" then set r = "go";
		when color="orange" then set r = "calm down";
    else
		set r = "error";
    end case;
    return r;
end $$
delimiter ;




drop function if exists feuRouge;
delimiter $$
create function feuRouge(color varchar(10))
	returns varchar(45)
    deterministic
begin
	declare r varchar(45);
    set r = case  color
					when "red" then  "stop"
					when "green" then "go"
					when "orange" then  "calm down"
			else
					"error"
			end;
    return r;
end $$
delimiter ;




select feuRouge("red");
select feuRouge("green");
select feuRouge("orange");
select feuRouge("black");

#Exercice

#Ecrire un fonction qui accept le numero d''une journée et qui affiche son nom en arabe

"الأحد"
"الإثنين"
"الثلاثاء"
"الأربعاء"
"الخميس"
"الجمعة"
"السبت"


# les boucles

drop function if exists somme;
delimiter $$
create function somme(n int)
	returns int
    deterministic
begin
    declare s int default 0;
    declare i int default 1;
    while i <= n do
		set s = s + i;
        set i= i + 1;
    end while;
    return s;
end $$
delimiter ;

select somme(5);



drop function if exists somme;
delimiter $$
create function somme (n int)
	returns int
    deterministic
begin
	declare s int default 0;
    declare i int default 0;
    repeat
		set s = s +i;
        set i = i + 1;
	until i>n end repeat;
	return s;
end $$
delimiter ;

select somme(0); -- 0
select somme(1); -- 1
select somme(5); -- 15

drop function if exists somme;
delimiter $$
create function somme(n int)
	returns int
    deterministic
begin
	declare s int default 0;
    declare i int default 0;
    l1: loop
		set s = s+i;
        set i = i+1;
        if i>n then
			leave l1;
        end if;
	end loop;
    return s;
end $$
delimiter ;

select somme(0); -- 0
select somme(1); -- 1
select somme(5); -- 15


#Exercice 
#ecrire une fonction qui calcule la somme des entiers paires 
# inférieures à un entier entré en paramètres
#utilisez les trois formes des boucles sur trois solutions différents


#ecrire une fonction qui calcule le factoriel d'un entier
# Rappel 5! = 5x4x3x2
# 1! = 1
# 0! = 1





#les fonctions

#les procedures stockées

#les tables temporaires

#les transactions

#la gestion des erreurs

#les declencheurs - les triggers

#les curseurs

#la gestion des utilisateurs

#la sauvegarde et la restauration

