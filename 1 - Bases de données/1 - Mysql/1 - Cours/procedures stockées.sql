#Les procedures stockées
drop procedure if exists test;

delimiter $$
create procedure test()
begin
	select * from employe;
	select * from departement;
	select e4q2();
end $$
delimiter ;


call test;



delimiter $$
create procedure math(a int, b int)
begin
	select a+b as somme;
	select a*b as multiplication;
	select a/b as division;
end $$
delimiter ;


call math(3,5);


drop procedure if exists math;

delimiter $$
create procedure math(a int, b int , out c int, out m int)

begin
	set c = a+b;
    set m = a*b;
end $$
delimiter ;


call math(3,5,@addition, @m);
select @addition, @m;

