use courses202;

insert into proprietaire values	(1,'a','a'),
								(2,'b','b');
                                
insert into cheval values 	(1,1,'black','2014-1-1','M'), 
							(2,1,'white','2014-2-1','M'), 
							(3,2,'yellow','2014-1-1','F'), 
							(4,2,'red','2011-3-1','F'), 
							(5,2,'green','2011-3-1','F'), 
							(6,1,'blue','2011-3-1','M'),
							(7,2,'purple','2011-3-1','F');
                            
insert into parents values	(6,1),
							(7,1),
                            (6,2),
                            (7,2);
                            
insert into jockey values	(1,"v","v"),
							(2,"w","w"),
                            (3,"x","x"),
                            (4,"y","y"),
                            (5,"z","z");
                            
insert into categorie values	(1,'trot attelé'),
								(2,'trot monté'),
                                (3, 'obstacle' );



insert into champ values	(1,'ch1',5000),
							(2,'ch2',15000),
                            (3,'ch3',10000);

insert into appartient values	(1,1),
								(1,2),
                                (2,2),
                                (2,3),
                                (3,1),
                                (3,3);

insert into course values	(1,1,1,'prix d''Afrique'),
							(2,2,2,'prix d''Amérique'),
							(3,3,3,'prix d''Europe');
                            
insert into session values 	(1,1,'Af2023','2023-09-15 15:00:00',20),
							(2,1,'af2024','2024-09-15 15:00:00',30),
							(3,2,'Am2023','2023-09-15 15:00:00',25),
							(4,2,'Am2024','2024-09-15 15:00:00',45);

insert into participe values	(1,1,1,1),
								(2,2,1,2),
                                (3,3,1,3),
                                (4,4,1,4),
                                (5,5,1,5),
                                
                                (1,3,2,1),
                                (2,4,2,3),
                                (3,5,2,2),
                                (4,1,2,4),
                                (5,2,2,5),
                                
                                (1,3,3,1),
                                (2,4,3,3),
                                (3,5,3,2),
                                (4,1,3,4),
                                (5,2,3,5),
                                
								(1,3,4,2),
                                (2,4,4,1),
                                (3,5,4,2),
                                (4,1,4,4),
                                (5,2,4,5);
                                
                                
;