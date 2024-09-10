
drop database if exists location_202_25;
create database location_202_25 collate utf8mb4_general_ci;

use location_202_25;

alter table quartier drop constraint fk_quartier_ville;
alter table bien drop constraint fk_bien_quartier;
alter table bien drop constraint fk_bien_type;
alter table bien drop constraint fk_bien_ville;
alter table contrat drop constraint fk_contrat_bien;
alter table contrat drop constraint fk_contrat_client;

drop table if exists type;
drop table if exists client;
drop table if exists ville;
drop table if exists quartier;
drop table if exists contrat;
drop table if exists bien;

create table type (id_type int auto_increment primary key, nom_type varchar(50) not null);

create table client (id_client int auto_increment primary key, nom_client varchar(30) not null, prenom_client varchar(30) , adresse varchar(150) , telephone varchar(20) );

create table ville (id_ville int auto_increment primary key, nom_ville varchar(50) not null);

create table quartier (id_quartier int auto_increment primary key,
					 nom_quartier varchar(50) not null,
					 id_ville int not null references ville(id_ville));

drop table quartier;

create table quartier (	id_quartier int auto_increment primary key, 
						nom_quartier varchar(50) not null, 
                        id_ville int not null , 
						constraint fk_quartier_ville foreign key(id_ville) references ville(id_ville) 
						on delete cascade on update cascade);

drop table quartier;

create table quartier (	id_quartier int auto_increment primary key, 
						nom_quartier varchar(50) not null, 
                        id_ville int not null);
                        
alter table quartier add constraint fk_quartier_ville foreign key(id_ville) references ville(id_ville) 
						on delete cascade on update cascade;

create table bien (reference int auto_increment primary key,
						 superficie float, 
						 nb_pieces smallint, 
						 loyer float, 
						 id_type int not null, 
						 id_quartier int not null, 
						 id_client int not null,
						 constraint fk_bien_quartier foreign key(id_quartier) references quartier(id_quartier) 
						on delete cascade on update cascade,
                        constraint fk_bien_type foreign key(id_type) references type(id_type) 
						on delete cascade on update cascade,
                        constraint fk_bien_client foreign key(id_client) references client(id_client) 
						on delete cascade on update cascade
 
 );


create table contrat (id_contrat int auto_increment primary key,
					date_creation date,
                    date_entree date,
                    date_sortie date,
                    charges float,
                    loyer_contrat float,
                    id_client int not null,
                    reference int not null,
                    constraint fk_contrat_client foreign key(id_client) references client(id_client) 
						on delete cascade on update cascade,
                        constraint fk_contrat_bien foreign key(reference) references bien(reference) 
						on delete cascade on update cascade);
                    


