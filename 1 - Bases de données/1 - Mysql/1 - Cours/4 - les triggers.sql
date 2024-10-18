drop database if exists ventes_202;
create database ventes_202 collate utf8mb4_general_ci;
use ventes_202;


create table produit (id_produit int auto_increment primary key, 
					nom varchar(100), 
					prix double, 
					stock int);

create table vente (
				id_vente int auto_increment primary key, 
				date_vente date, 
				qte int, 
				id_produit int , 
				constraint fk_vente_produit foreign key (id_produit) references produit(id_produit) 
											on delete cascade on update cascade);

insert into produit values (null,'pc',8500,15),
							(null,'imprimance',2500,8),
                            (null,'clavier',150,25);
                            
drop trigger if exists insert_vente;
delimiter $$
create trigger insert_vente after insert on vente for each row
begin
	update produit set stock = stock-new.qte where id_produit = new.id_produit;  
end $$
delimiter ;                            
                            
insert into vente values 
(null,curdate(),2,1),	# --> creation de la table system new qui a la meme structure que vente
(null,curdate(),2,2),	# --> creation de la table system new qui a la meme structure que vente
(null,curdate(),2,3);   # --> creation de la table system new qui a la meme structure que vente


                            
insert into vente values (null,curdate(),1,2);    
update produit set stock = stock-1 where id_produit = 2;                        

select * from produit;
select * from vente;

													