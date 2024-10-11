use courses202;
-- A.	la liste de tous les cheveaux.

select * from cheval;


-- A2 la liste des chevaux des proprietaires sont le prenom contient la lettre 'a'

-- methode de jointure
select * from cheval join proprietaire using(id_proprietaire) where prenom_proprietaire like '%a%';


-- methode ensembliste
select * 
from cheval 
where id_proprietaire in (
						select id_proprietaire 
                        from proprietaire 
                        where prenom_proprietaire 
                        like '%a%'
                        );

-- methode avec with

with chevaux_de_A as (select *
                        from proprietaire 
                        where prenom_proprietaire 
                        like '%a%'
           )
           
select * from cheval join chevaux_de_A using(id_proprietaire);





-- B.	la listes de champs qui peuvent acceuillir la catégorie "trot attelé"

SELECT CHAMP.* from CHAMP join APPARTIENT ON CHAMP.ID_CHAMP=APPARTIENT.ID_CHAMP 
JOIN CATEGORIE ON CATEGORIE.ID_CATEGORIE = APPARTIENT.ID_CATEGORIE where CATEGORIE.NOM_CATEGORIE='trot attelé';


select * 
from champ 
where id_champ in (select id_champ 
					from appartient 
                    where id_categorie in (select id_categorie 
											from categorie 
                                            where nom_categorie = 'trot attelé'
											)
					);







-- C.	la liste des chevaux qui participent a la course 
-- "prix d'amérique" de la session 'am2024''am2024' triés par classement


select cheval.*, classement
from cheval
join participe using(id_cheval)
join session using(id_session)
join course using(id_course)
where designation_course="prix d'amérique" 
and nom_session='am2024' 
order by classement;


select ch.*, classement 
from cheval ch join participe using(id_cheval)
               where id_session = (select S.id_session 
										from session S 
                                        where  S.nom_session='am2024' 
                                        and S.ID_course = ( select C.id_course 
															from course C 
                                                            where C.designation_course = 'prix d''amérique'
														   ) 
                                    )
order by classement asc; 
with cou as ( select id_course 
			from course C 
			where designation_course = 'prix d''amérique'
			),
sess as (select id_session 
		from session S  join cou using(id_course)
		where nom_session='am2024' 
		)
select ch.*, classement from cheval ch join participe using(id_cheval) 
					join sess using(id_session)
order by classement asc;




with sess as (select id_session from session
				join course using(id_course)
                where designation_course like 'prix d_amérique' 
                and nom_session = 'am2024')
select cheval.*, classement
		from cheval join participe using(id_cheval)
        join sess using(id_session)
        order by classement asc;
			
















-- D.	la liste des jockeys qui ont monté le cheval "black" durant tout son historique
select distinct jockey.*
from jockey
join participe using (id_jockey)
join cheval using (id_cheval)
where nom_cheval = "black";


select  * 
from jockey 
where id_jockey in (select	id_jockey 
					from participe 
                    where id_cheval in (select id_cheval 
												from cheval 
                                                where nom_cheval = 'black')
					);
				
with chev as (select id_cheval 
				from cheval 
			where nom_cheval = 'black')
select distinct j.* from jockey j 
join participe using(id_jockey)
join chev using(id_cheval);


with p as (select	id_jockey 
					from participe 
                    where id_cheval in (select id_cheval 
												from cheval 
                                                where nom_cheval = 'black')
				)
select distinct * from jockey join p using(id_jockey);

                    
                


-- E.	Le cheval qui a remporté le plus grand nombre de compétitions

-- mauvaise réponse parceque le nombre des chevaux qui ont remporté le plus grand nombre de compétitions peut changer 
select cheval.nom_cheval ,count(participe.classement) as nb_vict  from participe
join cheval using(id_cheval)
where participe.classement=1
group by nom_cheval
order by nb_vict desc
limit 1;


with t1 as (select nom_cheval, count(id_cheval) as nb_victoires
from cheval 
join participe using (id_cheval)
where classement = 1
group by nom_cheval),
t2 as (select max(nb_victoires) as nb_victoires from t1)
select * from t1 join t2 using(nb_victoires); 

select * from participe where classement = 1;


-- F.	Les parents du cheval qui a remporté le plus grand nombre de compétitions
with gagnants as (with t1 as (select id_cheval, nom_cheval, count(id_cheval) as nb_victoires
				from cheval 
				join participe using (id_cheval)
				where classement = 1
				group by id_cheval, nom_cheval),
				t2 as (select max(nb_victoires) as nb_victoires from t1)
				select * from t1 join t2 using(nb_victoires))
select gagnants.id_cheval,gagnants.nom_cheval, par.id_cheval, par.nom_cheval  from gagnants
left join parents on gagnants.id_cheval=id_fils
left join cheval par on id_pere=par.id_cheval;


-- G.	Le montant total remporté par 'black' dans toutes les compétitions qu'il a remporté
use courses202;
select sum(dotation) as montant_total from cheval join participe using(id_cheval)
join session using (id_session)
where nom_cheval = 'black'
and classement = 1;

-- H.	La catégorie que le cheval 'black' remporte le plus

with t1 as (
select count(id_cheval) as nb_victoires, nom_categorie from cheval join participe using(id_cheval)
join session using (id_session)
join course using(id_course)
join categorie using(id_categorie)
where nom_cheval = 'black'
and classement = 1
group by nom_categorie),
t2 as (select max(nb_victoires) as nb_victoires from t1)
select nom_categorie from t1 join t2 using(nb_victoires);


