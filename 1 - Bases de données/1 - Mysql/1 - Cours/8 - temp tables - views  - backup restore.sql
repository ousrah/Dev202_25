
#tables temporarires
use bank_202;
create temporary table test (id int auto_increment primary key, nom varchar(50));
insert into test values (1,'a'),(2,'b');
select * from test;

#si on se connect avec un autre utilisateur sur le meme serveur et la meme base de données, on ne va pas trouver la table test.
#si l'utilisateur en cours ferme la session et se reconnect, il ne trouvera plus la table test.

#les vues (views);
# des requetes enregistrés
use cuisine_202;

# dans le contexte de la requette suivante on peut utiliser t1 comment une view temporaire propre a la requette.
with t1 as (select * from recettes r join composition_recette cr using(numrec) where prix <20
)
select * from t1;

#en dehors de la requete on ne peut plus reutiliser t1;
select * from t1;

#on peut créer une vue permanante en utilisant create view
create view v_test as select * from recettes r join composition_recette cr using(numrec) where prix <20;

#on peut reutiser v_test a chaque fois qu'on on aura besoin.
select * from v_test;



#backup (la sauvegarde)

#pour utiliser mysqldump il faut soit entrer dans le dossier  C:\Program Files\MySQL\MySQL Server x.x\bin
# ou ajouter C:\Program Files\MySQL\MySQL Server x.x\bin a path systeme dans les variables d'environnement
#tapez mysqldump en ligne de commande pour tester s'il existe.


#utilise le post locale et le port 3306
mysqldump -u root -p cuisine_202 > cuisine_202.sql

#ici on a précisé le host avec -h et le port avec -P (maj)
mysqldump -h 127.0.0.1 -P 3306 -u root -p cuisine_202 > cuisine_202B.sql

#ici on a founi aussi le mot de passe il doit être collé a -p
mysqldump -h 127.0.0.1 -P 3306 -u root -p123456 cuisine_202 > cuisine_202B.sql

#restore (la récupération - la restauration)

#methode 1
#créer une base de données en locale
#ouvrir le script sauvegarder sur worbench 
#ajouter use nom_de_la_db; au début du script
#executer le script


#méthode 2
#mysql -u root -p cuisine_202 < cuisine_202.sql


#méthode 3
#ouvrir la console mysql en ligne de commande
mysql -u root -p

create database cuisine_202x collate utf8mb4_general_ci;
use cuisine_202x;
source d:\files\script.sql   #ne metez pas ; a la fin de l'instruction source
