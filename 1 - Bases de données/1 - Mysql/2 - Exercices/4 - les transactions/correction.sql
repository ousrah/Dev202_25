drop database if exists salles_202;
create database salles_202 collate utf8mb4_general_ci;
use salles_202;


create table Salle (
	NumSalle int primary key, 
    Etage int, 
    NombreChaises int,
    check (NombreChaises between 20 and 30)
    );
    
create table Transfert (
	NumSalleOrigine int, 
    NumSalleDestination int, 
    DateTransfert date, 
    NbChaisesTransferees int, 
	constraint fk_salleOrigine foreign key (NumSalleOrigine) references Salle (NumSalle) on delete cascade on update cascade,
	constraint fk_salleDestination foreign key (NumSalleDestination) references Salle (NumSalle) on delete cascade on update cascade
);

insert into salle values 
(1,	1,	24),
(2,	1,	26),
(3,	1,	26),
(4,	2,	28);


drop procedure if exists transf;
delimiter $$
create procedure transf (SalleOrigine int, SalleDest int , NbChaises int, dateTransfert date)
begin
	declare exit handler for sqlexception
    begin
		select "Impossible d’effectuer le transfert des chaises" as message;
        rollback;
	end;
	start transaction;
		update Salle set NombreChaises=NombreChaises-NbChaises where NumSalle=SalleOrigine;
        update Salle set NombreChaises=NombreChaises+NbChaises where NumSalle=SalleDest;
        insert into transfert values (SalleOrigine,SalleDest,dateTransfert,NbChaises);
	commit;
    select "Transfert effectué avec succès" as message;
end $$
delimiter ;


select * from salle;
call transf(2,3,4,curdate());






