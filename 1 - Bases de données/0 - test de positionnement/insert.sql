create database test;
use test;
create table client (
						id int auto_increment primary key, 
						nom varchar(50) not null, 
						prenom varchar(50), 
						telephone varchar(20), 
						adresse varchar(150) default 'tetouan'
					);


insert into client value (1,'qlq','qlq','01','martil');
insert into client value ('khaldi','kamal','01','martil'); -- erreur
insert into client value (null, 'khaldi','kamal','01','martil'); 

insert into client (id, prenom, nom, telephone) value (2,'said','elyoussfi','05');
insert into client (prenom, nom, telephone) value ('saida','hassani','05');

insert into client values 	(null,'a','a','01','tetouan'),
							(null,'b','b','02','tanger'),
							(null,'c','c','03','martil'),
							(null,'d','d','04','tetouan');
       
insert into client 	values 	('a','a','01','tetouan'),
							('b','b','02','tanger'),
							('c','c','03','martil'),
							('d','d','04','tetouan'); -- erreur
                            
                            
insert into client (nom, prenom, telephone, adresse)
					values 	('a','a','01','tetouan'),
							('b','b','02','tanger'),
							('c','c','03','martil'),
							('d','d','04','tetouan');

select * from client;

