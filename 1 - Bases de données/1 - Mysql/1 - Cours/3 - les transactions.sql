
-- gestion des exceptions

drop procedure if exists affectation;
delimiter $$
create procedure affectation (x bigint)
begin
    declare y smallint;	
    declare exit handler for sqlexception
    begin
		select "erreur d'affectation";
    end;

    set y = x;
    select y;
end $$
delimiter ;



call affectation(5);
call affectation(5455454542);








drop database if exists bank_202;
create database bank_202;
use bank_202;
create table account (id int primary key, funds double, check (funds>=0));


insert into account value (1,10000);
insert into account value (2,10000);
select * from account ;


drop procedure if exists transf;
delimiter $$
create procedure transf (acc1 int, acc2 int, amount double)
begin
	declare exit handler for sqlexception
    begin
		select "erreur de transfert d'argent" as erreur;
        rollback;
    end;
	start transaction;
		update account set  funds = funds + amount where id = acc2;
		update account set  funds = funds - amount where id = acc1;
        select "opération de transfert effectuée avec succes" as succes;
	commit;
        
end $$
delimiter ;

call transf (1,2,5000);
call transf (1,2,1000);
call transf (1,2,3000);
call transf (1,2,1500);
select * from account;




