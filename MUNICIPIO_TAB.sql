--------------------------------------------------------------------------------
--> Cria o cadastro de linguas utilizadas no sistema
--------------------------------------------------------------------------------
Create table AUX_Lingua
(Lingua_ID         Number         Not Null
,Alfa2             Char(2)        Not Null
,Alfa3             Char(3)        Not Null
,Descricao         NVarchar2(30)  Not Null
,Constraint AUX_Linguas_PK primary key (Lingua_ID)
,Constraint AUX_Linguas_CK01 check (Alfa2 = UPPER(Alfa2))
,Constraint AUX_Linguas_CK02 check (Alfa3 = UPPER(Alfa3))
,Constraint AUX_Linguas_CK03 check (Descricao = UPPER(Descricao))
,Constraint AUX_Linguas_UK01 unique (Alfa2)
,Constraint AUX_Linguas_UK02 unique (Alfa3)
,Constraint AUX_Linguas_UK03 unique (Descricao))
tablespace AUX_DAD;

--------------------------------------------------------------------------------
--> Cria a esrutura de paises
--------------------------------------------------------------------------------
Create table AUX_Pais
(Pais_ID           Number        Not Null
,Alfa2             Char(2)       Not Null
,Alfa3             Char(3)       Not Null
,Constraint RFB_Pais_PK primary key (Pais_ID)
,Constraint RFB_Pais_CK01 Check (Alfa2 = Upper(Alfa2))
,Constraint RFB_Pais_CK02 Check (Alfa3 = Upper(Alfa3))
,Constraint RFB_Pais_UK01 Unique (Alfa2)
,Constraint RFB_Pais_UK02 Unique (Alfa3))
tablespace AUX_DAD;

Create table AUX_Pais_ML
(Pais_ID           Number         Not Null
,Lingua_ID         Number         Not Null
,Descricao         NVarchar2(150) Not Null
,Constraint AUX_Pais_ML_PK primary key (Pais_ID, Lingua_ID)
,COnstraint AUX_Pais_ML_CK01 Check (Descricao = UPPER(Descricao))
,Constraint AUX_Pais_ML_fk_Pais    Foreign key (Pais_ID)   References AUX_Pais (Pais_ID)
,Constraint AUX_Pais_ML_fk_Linguas Foreign key (Lingua_ID) References AUX_Lingua (Lingua_ID))
tablespace AUX_DAD;

Create view vAUX_Pais as
select a.pais_id
     , a.alfa2 Pais_alfa2
     , a.alfa3 Pais_alfa3
     , b.descricao pais_descricao
     , b.lingua_id
     , c.alfa2 Lingua_Alfa2
     , c.alfa3 Lingua_Alfa3
     , c.descricao Lingua_decricao
  from aux_pais a
     , aux_pais_ml b
     , aux_lingua c
 where a.pais_id = b.pais_id
   and b.lingua_id = c.lingua_id;
   
Create table AUX_estado
(Estado_ID         Number        Not Null
,Pais_ID           Number        Not Null
,sigla             Char(2)       Not Null
,Nome              Varchar2(30)  Not Null
,Constraint Aux_Estado_PK primary key (Estado_ID)
,Constraint Aux_Estado_FK_Pais foreign key (Pais_ID) references Aux_pais (Pais_id)
,Constraint Aux_Estado_CK01 check (Sigla = UPPER(Sigla))
,Constraint Aux_Estado_CK02 check (Nome = UPPER(Nome)))
tablespace AUX_DAD;

Create table AUX_OrigemCodigo
(OrigemCodigo_ID   Number       Not Null
,Descricao         Varchar2(30) Not Null
,Constraint Aux_OrigemCodigo_PK primary key (OrigemCodigo_ID)
,Constraint Aux_OrigemCodigo_CK01 check (Descricao = UPPER(Descricao)))
tablespace AUX_DAD;


Create table AUX_EstadoCodigo
(Estado_ID         Number        Not Null
,OrigemCodigo_ID   Number        Not Null
,Codigo            varchar2(30)  Not Null
,Constraint Aux_EstadoCodigo_PK Primary Key(Estado_ID, OrigemCodigo_ID)
,Constraint AUX_EstadoCodigo_FK_Estado     foreign key (Estado_ID)       References AUX_Estado (Estado_ID)
,Constraint AUX_EstadoCodigo_FK_OrigCodigo foreign key (OrigemCodigo_ID) References AUX_OrigemCodigo (OrigemCodigo_ID))
tablespace AUX_DAD;

Create table AUX_Municipio
(Municipio_ID      Number        Not Null
,Estado_ID         Number        Not Null
,Nome              Varchar2(50)  Not Null
,Constraint AUX_Municipio_PK primary key (Municipio_ID)
,Constraint AUX_Municipio_FK_Estado foreign key (Estado_ID) references AUX_Estado (Estado_ID)
,Constraint AUX_Municipio_CK01 Check (Nome = UPPER(Nome)))
tablespace AUX_DAD;

Create view vAUX_Municipio as
select a.estado_id
     , b.sigla   Estado_SG
     , b.nome    Estado_nm
     , a.municipio_id
     , a.nome
  from aux_municipio a
     , aux_estado b
 where a.estado_id = b.estado_id

Create table AUX_MunicipioCodigo
(Municipio_ID      Number        Not Null
,OrigemCodigo_ID   Number        Not Null
,Codigo            varchar2(30)  Not Null
,Constraint Aux_MunicCodigo_PK Primary Key(Municipio_ID, OrigemCodigo_ID)
,Constraint AUX_MunicCodigo_FK_Municipio  foreign key (Municipio_ID)    References AUX_Municipio (Municipio_ID)
,Constraint AUX_MuniCodigo_FK_OrigCodigo foreign key (OrigemCodigo_ID) References AUX_OrigemCodigo (OrigemCodigo_ID))
tablespace AUX_DAD;

Create view vAUX_MunicipioCodigo as
SELECT b.estado_id
     , c.sigla Estado_SG
     , c.nome Estado_NM
     , a.municipio_id
     , b.nome
     , a.origemcodigo_id
     , d.descricao OrigemCodigo_NM
     , a.codigo
 FROM AUX_MunicipioCodigo a
    , AUX_Municipio b
    , AUX_Estado c
    , AUX_OrigemCodigo d
WHERE a.Municipio_id = b.Municipio_ID
  AND b.estado_id = c.estado_id
  AND a.OrigemCodigo_ID = d.origemcodigo_id;
