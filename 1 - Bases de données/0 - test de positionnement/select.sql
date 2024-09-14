use location_202_25;

-- A.	La liste des bien de type ‘villa’

-- methode prédicative
select b.*,t.NOM_TYPE 
from BIEN b join TYPE t on b.ID_TYPE = t.ID_TYPE 
WHERE NOM_TYPE="villa";

create index idx_nomtype on type(nom_type);
-- methode ensembliste
select * 
from bien 
where  id_type in (select id_type from type where nom_type='villa');

-- methode du produit cartésien (à éviter)
select bien.*, type.nom_type
from bien, type
where bien.id_type = type.id_type
and type.nom_type = 'villa';





-- B.	La liste des appartements qui se trouve à Tétouan
-- methode prédicative 
select b.* ,t.nom_type, v.nom_ville 
from bien b
join type t using(id_type)
join quartier q using(id_quartier)
join ville v using(id_ville)
where nom_ville='tetouan' and nom_type = 'appartement';

-- methode ensembliste
select * 
from bien
where id_quartier in (
					select id_quartier 
                    from quartier 
                    where id_ville in (select id_ville 
										from ville 
                                        where nom_ville='tetouan'
                                        )
					)
and id_type in (
				select id_type 
                from type
                where nom_type = 'appartement'
                );


-- C.	La liste des appartements loués par M. Marchoud Ali
select b.* 
from client c 
join contrat  using(id_client)
join bien b  using(reference)
join type t using(id_type)
where c.nom_client='marchoud'
and c.prenom_client='ali'
and t.nom_type='appartement';


select * from bien where id_type in (select id_type from type where nom_type = 'appartement')
and reference in (
			select reference from contrat where id_client in (
              select id_client from client where  nom_client='marchoud' and prenom_client='ali'));


-- D.	Le nombre des appartements loués dans le mois en cours
-- methode prédicative
select count(id_contrat) as nb_app from contrat 
join bien using(reference)
join type using(id_type)
 where month(date_creation)=month(current_date()) and year(date_creation)=year(current_date()) and nom_type='appartement';

-- methode ensembliste
select  count(id_contrat) as nb_app
from contrat 
where 
month(date_creation)=month(current_date()) 
and year(date_creation)=year(current_date())
and reference in (
			select reference from bien where id_type in (select id_type from type where nom_type='appartement'));
 

-- E.	Les appartements disponibles actuellement à Martil dont le loyer est inférieur à 2000 DH triés du moins chère au plus chère

select b.* from bien b left join contrat using(reference) 
join type using(id_type)
join quartier using(id_quartier)
join ville using(id_ville)
where 
	nom_type = 'appartement' 
	and nom_ville = 'martil'
	and loyer <2000
	and ((date_sortie is null and date_entree is null) or date_sortie < current_date())
order by loyer asc;

-- F.	La liste des biens qui n’ont jamais été loués

-- methode prédicative
select bien.* 
from BIEN 
LEFT JOIN CONTRAT on bien.reference=contrat.reference
WHERE contrat.reference is null;


-- methode ensembliste
select * from bien where reference not in (
select distinct reference from contrat);



-- G.	La somme des loyers du mois en cours



select sum(loyer_contrat) from contrat where(date_sortie > current_date() or date_sortie is null);

