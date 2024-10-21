#la gestion des exceptions

drop database if exists commerce_202;
create database commerce_202 collate utf8mb4_general_ci;
use commerce_202;
create table produit (id_produit int auto_increment primary key,
nom_produit varchar(50), prix double, check (prix>0));

# procedure d'insertion du produit sans gestion d'erreur

drop procedure if exists new_product;
delimiter $$
create procedure new_product(name varchar(50), price double)
begin
	insert into produit (nom_produit,prix) value (name, price);
end $$
delimiter ;


call new_product('pc',8000);
call new_product('imprimante',-1000);  #plantage
select * from produit;


#procedure d'inservation avec gestion d'erreur général
drop procedure if exists new_product;
delimiter $$
create procedure new_product(name varchar(50), price double)
begin
	declare exit handler for sqlexception
    begin
		select "erreur d'insertion" as "erreur";
    end ;
	insert into produit (nom_produit,prix) value (name, price);
end $$
delimiter ;

call new_product('imprimante',-1000);  #affichage d'érreur


#ajout d'autres règle de validation à la table produit

drop table produit;
create table produit (id_produit int auto_increment primary key,
nom_produit varchar(50) not null unique, 
prix double, check (prix>0));

call new_product('imprimante',-1000);  #affichage d'érreur d'insertion
call new_product('imprimante',8000);  #insertion reussi
call new_product('imprimante',3000);  #affichage d'érreur d'insertion
call new_product(null,3000);  #affichage d'érreur d'insertion

#produre d'insertion des produits avec gestion des erreurs personnalisé

drop procedure if exists new_product;
delimiter $$
create procedure new_product(name varchar(50), price double)
begin
	declare exit handler for 3819
    begin
		select "le prix ne peut pas être inférieur à zero" as erreur;
    end;
    declare exit handler for 1062
    begin
		select "ce produit existe déjà" as erreur;
    end;
    declare exit handler for 1048
    begin
		select "le nom du produit ne peut pas être null" as erreur;
    end;
	insert into produit (nom_produit,prix) value (name, price);
end $$
delimiter ;

call new_product('imprimante',-1000);  #3819
call new_product('imprimante',3000);  #1062
call new_product(null,3000);  #1048





#produre d'insertion des produits avec gestion des erreurs par flag

drop procedure if exists new_product;
delimiter $$
create procedure new_product(name varchar(50), price double)
begin
	declare flag boolean default false;
    
    #nouveau bloc d'instructions
    begin
		declare exit handler for 3819,1062,1048  set flag = true;
		insert into produit (nom_produit,prix) value (name, price);
        select "insertion effectuée avec succes" as success;
    end;
	if flag then
		select "erreur d'insertion" as 'errer';
	end if;
	
end $$
delimiter ;

call new_product('imprimante',-1000);  #3819
call new_product('imprimante',3000);  #1062
call new_product(null,3000);  #1048


#produre d'insertion des produits avec gestion des erreurs par varchar

drop procedure if exists new_product;
delimiter $$
create procedure new_product(name varchar(50), price double)
begin
	declare msg varchar(100) default '';
    
    #nouveau bloc d'instructions
    begin
		declare exit handler for 3819 set msg = "le prix ne peut pas être négatif";
        declare exit handler for 1062 set msg = "ce produit existe déja";
        declare exit handler for 1048 set msg = "le nom du produit ne peut pas être null";
		insert into produit (nom_produit,prix) value (name, price);
        select "insertion effectuée avec succes" as success;
    end;
	if msg != '' then
		select msg as "erreur";
	end if;
	
end $$
delimiter ;

call new_product('imprimante',-1000);  #3819
call new_product('imprimante',3000);  #1062
call new_product(null,3000);  #1048




#produre d'insertion des produits avec gestion des erreurs par sqlstate

drop procedure if exists new_product;
delimiter $$
create procedure new_product(name varchar(50), price double)
begin
	declare msg varchar(100) default '';
    
    #nouveau bloc d'instructions
    begin
		declare exit handler for sqlstate '23000' set msg = "le nom ne peut pas être null et doit être unique";
        declare exit handler for 3819 set msg = "le prix ne peut pas être négatif";
		insert into produit (nom_produit,prix) value (name, price);
        select "insertion effectuée avec succes" as success;
    end;
	if msg != '' then
		select msg as "erreur";
	end if;
	
end $$
delimiter ;

call new_product('imprimante',-1000);  #3819
call new_product('imprimante',3000);  # sqlstate '23000'
call new_product(null,3000);  #sqlstate '23000'


#capture d'erreur

drop procedure if exists new_product;
delimiter $$
create procedure new_product(name varchar(50), price double)
begin
	declare flag boolean default false;
    declare msg varchar(150);
    declare err_number int;
    declare sql_state varchar(5);
    begin
		declare exit handler for sqlexception
        begin
			get diagnostics condition 1 
				err_number = mysql_errno,
                sql_state = returned_sqlstate,
                msg = message_text;
			set flag = true;
        end;
		insert into produit (nom_produit,prix) value (name, price);
        select "insertion effectuée avec succes" as success;
    end;
	if flag then
		select concat("erreur numero : ",err_number, " - etat sql : " , sql_state, " - message :",msg) as "erreur";
	end if;
	
end $$
delimiter ;

call new_product('imprimante',-1000);  #3819
call new_product('imprimante',3000);  #1062
call new_product(null,3000);  #1048





#not fount

drop procedure if exists get_product;
delimiter $$
create procedure get_product(id int, out name varchar(50))
begin
	declare exit handler for not found set name = "aucun produit trouvé";
	select nom_produit into name from  produit where id_produit = id;
end $$
delimiter ;

select * from produit;
call get_product(1,@n);
select @n;



drop procedure if exists diviser;
delimiter $$
create procedure diviser(a int, b int, out r double)
begin
	declare div_par_zero condition for sqlstate '11111';
    declare continue handler for div_par_zero resignal set message_text = "impossible de diviser par zero";
	if b=0 then
		signal  div_par_zero;
    else
		set r = a/b;
    end if;
end $$
delimiter ;


call diviser(3,0,@i);
select @i;

call diviser(3,0,@i);
select @i;

