drop database if exists ventes_202;
create database ventes_202 collate utf8mb4_general_ci;
use ventes_202;


create table produit (id_produit int auto_increment primary key, 
					nom varchar(100), 
					prix double, 
					stock int);
                    
alter table produit add constraint chk_stock check (stock>=0);                    

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
# declencheur d'insertion
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

#le déclencheur et l'instruction qui l'a déclenché representent automatiquement la meme transaction
#(soit les deux sont effectuées, soit aucune)

insert into vente values (null,curdate(),1,2);
        
# declencheur de supression                         
drop trigger if exists delete_vente;
delimiter $$
create trigger delete_vente after delete on vente for each row
begin
	update produit set stock = stock+old.qte where id_produit = old.id_produit;  
end $$
delimiter ;  
        
delete from vente where id_vente = 1; #  --> créer un table systeme nommée old qui a meme structure que vente


# declencheur de modification
drop trigger if exists update_vente;
delimiter $$
create trigger update_vente after update on vente for each row
begin
	update produit set stock = stock+old.qte-new.qte  where id_produit = new.id_produit;
end $$
delimiter ;



update  vente set qte = 1 where id_vente = 2;
update  vente set qte = 5 where id_vente = 3;

select * from produit;
select * from vente;

													