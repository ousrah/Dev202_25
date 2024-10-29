#creer un utilisateur youssef 
create user 'youssef'@'localhost' identified by '123456';  

#modifier le mot de passe de youssef
set password for 'youssef'@'localhost' = '654321'; 

#donner tous les droit a youssef sur la base de données bank_202
grant all privileges on bank_202.* to 'youssef'@'localhost'; 


#enelver tous les droit de youssef sur la base de données bank_202
revoke all privileges on  bank_202.* from 'youssef'@'localhost';

#attribuer tous les droits a youssef sur la table pilote
grant all privileges on vols_202.pilote to 'youssef'@'localhost';

#attribuer des droits spécifique a youssef sur la table avion
grant select on vols_202.avion to 'youssef'@'localhost';
grant update, delete, insert on vols_202.avion to 'youssef'@'localhost';

#afficher la liste des droits de youssef
show grants for 'youssef'@'localhost';

grant all privileges on vols_202.avion to 'youssef'@'localhost';

show grants for 'youssef'@'localhost';
revoke all privileges on vols_202.avion from 'youssef'@'localhost';
show grants for 'youssef'@'localhost';

#donner des droits sur des champs spécifique de la table vol a youssef
 grant select(numvol, villed, dated, numpil) on vols_202.vol to 'youssef'@'localhost';

grant select on vols_202.vol to 'youssef'@'localhost';

#supprimer l'utilisateur youssef
drop user if exists 'youssef'@'localhost';


#gestion des roles

#creation des comptes des utilisateurs
drop user if exists u1@localhost;
drop user if exists u2@localhost;
drop user if exists u3@localhost;
drop user if exists u4@localhost;
drop user if exists u5@localhost;



create user u1@localhost identified by '123456';
create user u2@localhost identified by '123456';
create user u3@localhost identified by '123456';
create user u4@localhost identified by '123456';
create user u5@localhost identified by '123456';


#creation des roles
drop role if exists students@localhost;
drop role if exists teachers@localhost;

create role students@localhost;
create role teachers@localhost;


#attribuer des priviles aux differents roles
grant all privileges on vols_202.* to teachers@localhost;
grant select on vols_202.pilote to  students@localhost;


grant students@localhost to u1@localhost;
grant students@localhost to u2@localhost;
grant students@localhost to u3@localhost;


grant teachers@localhost to u4@localhost;
grant teachers@localhost to u5@localhost;



set default role all to u1@localhost;
set default role all to u2@localhost;
set default role all to u3@localhost;
set default role all to u4@localhost;
set default role all to u5@localhost;




#on va donner  plus de droits aux etudiants

grant select on vols_202.avion to  students@localhost;

#permet de rafraichir les privilèges de tous le monde
flush privileges;

#enlever le role techers de u5;
revoke teachers@localhost from u5@localhost;

show grants for u1@localhost;
show grants for students@localhost;
show grants for teachers@localhost;










