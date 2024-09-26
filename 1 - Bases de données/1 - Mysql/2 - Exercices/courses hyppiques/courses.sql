drop database if exists courses202;
create database courses202 collate utf8mb4_general_ci;
use courses202;

/*==============================================================*/
/* Table: APPARTIENT                                            */
/*==============================================================*/
create table APPARTIENT
(
   ID_CATEGORIE         int not null,
   ID_CHAMP             int not null,
   primary key (ID_CATEGORIE, ID_CHAMP)
) engine=InnoDB;

/*==============================================================*/
/* Table: CATEGORIE                                             */
/*==============================================================*/
create table CATEGORIE
(
   ID_CATEGORIE         int not null auto_increment,
   NOM_CATEGORIE        varchar(50),
   primary key (ID_CATEGORIE)
) engine=InnoDB;

/*==============================================================*/
/* Table: CHAMP                                                 */
/*==============================================================*/
create table CHAMP
(
   ID_CHAMP             int not null auto_increment,
   NOM_CHAMP            varchar(100),
   NB_PLACES            bigint,
   primary key (ID_CHAMP)
) engine=InnoDB;

/*==============================================================*/
/* Table: CHEVAL                                                */
/*==============================================================*/
create table CHEVAL
(
   ID_CHEVAL            int not null auto_increment,
   ID_PROPRIETAIRE      int not null,
   NOM_CHEVAL           varchar(100),
   DATE_NAISSANCE       date,
   SEXE                 varchar(1),
   constraint pk_cheval primary key (ID_CHEVAL)
) engine=InnoDB;

/*==============================================================*/
/* Table: COURSE                                                */
/*==============================================================*/
create table COURSE
(
   ID_COURSE            int not null auto_increment,
   ID_CATEGORIE         int not null,
   ID_CHAMP             int not null,
   DESIGNATION_COURSE   varchar(100),
   primary key (ID_COURSE)
) engine=InnoDB;

/*==============================================================*/
/* Table: JOCKEY                                                */
/*==============================================================*/
create table JOCKEY
(
   ID_JOCKEY            int not null auto_increment,
   NOM_JOCKEY           varchar(50),
   PRENOM_JOCKEY        varchar(50),
   primary key (ID_JOCKEY)
) engine=InnoDB;

/*==============================================================*/
/* Table: PARENTS                                               */
/*==============================================================*/
create table PARENTS
(
   id_pere        int not null,
   id_fils           int not null,
   primary key (id_pere, id_fils)
) engine=InnoDB;

/*==============================================================*/
/* Table: PARTICIPE                                             */
/*==============================================================*/
create table PARTICIPE
(
   ID_CHEVAL            int not null,
   ID_JOCKEY            int not null,
   ID_SESSION           int not null,
   CLASSEMENT           int,
   primary key (ID_CHEVAL, ID_JOCKEY, ID_SESSION)
) engine=InnoDB;

/*==============================================================*/
/* Table: PROPRIETAIRE                                          */
/*==============================================================*/
create table PROPRIETAIRE
(
   ID_PROPRIETAIRE      int not null auto_increment,
   NOM_PROPRIETAIRE     varchar(30),
   PRENOM_PROPRIETAIRE  varchar(50),
   primary key (ID_PROPRIETAIRE)
) engine=InnoDB;

/*==============================================================*/
/* Table: SESSION                                               */
/*==============================================================*/
create table SESSION
(
   ID_SESSION           int not null auto_increment,
   ID_COURSE            int not null,
   NOM_SESSION          varchar(100),
   DATE_SESSION         datetime,
   DOTATION             float,
   primary key (ID_SESSION)
) engine=InnoDB;

alter table APPARTIENT add constraint FK_APPARTIENT foreign key (ID_CATEGORIE)
      references CATEGORIE (ID_CATEGORIE) on delete restrict on update restrict;

alter table APPARTIENT add constraint FK_APPARTIENT2 foreign key (ID_CHAMP)
      references CHAMP (ID_CHAMP) on delete restrict on update restrict;

alter table CHEVAL add constraint FK_POSSEDE foreign key (ID_PROPRIETAIRE)
      references PROPRIETAIRE (ID_PROPRIETAIRE) on delete restrict on update restrict;

alter table COURSE add constraint FK_CONCERNE foreign key (ID_CATEGORIE)
      references CATEGORIE (ID_CATEGORIE) on delete restrict on update restrict;

alter table COURSE add constraint FK_S_ORGANISE foreign key (ID_CHAMP)
      references CHAMP (ID_CHAMP) on delete restrict on update restrict;

alter table PARENTS add constraint FK_PARENTS foreign key (id_pere)
      references CHEVAL (ID_CHEVAL) on delete restrict on update restrict;

alter table PARENTS add constraint FK_PARENTS2 foreign key (id_fils)
      references CHEVAL (ID_CHEVAL) on delete restrict on update restrict;

alter table PARTICIPE add constraint FK_PARTICIPE foreign key (ID_CHEVAL)
      references CHEVAL (ID_CHEVAL) on delete restrict on update restrict;

alter table PARTICIPE add constraint FK_PARTICIPE2 foreign key (ID_JOCKEY)
      references JOCKEY (ID_JOCKEY) on delete restrict on update restrict;

alter table PARTICIPE add constraint FK_PARTICIPE3 foreign key (ID_SESSION)
      references SESSION (ID_SESSION) on delete restrict on update restrict;

alter table SESSION add constraint FK_SE_DEROULE foreign key (ID_COURSE)
      references COURSE (ID_COURSE) on delete restrict on update restrict;

