/************************************
|| Menu Configurable - Fortaleza
||***********************************
||
|| Ajustes a la Tabla Aplicacion
||
*/
alter table aplicacion add
( id_aplicacion number,       
  plataforma    varchar2(2),  
  nropag        number,       
  icono         varchar2(200) 
)
/ 

comment on column aplicacion.id_aplicacion is 'Id Unico de cada registro de la tabla'
/
comment on column aplicacion.plataforma is 'Código de la Paltaforma: 01 - ACSEL y 02 - ACSELWEB'
/
comment on column aplicacion.nropag is 'Número de Pagina de Apex asociada a la opción'
/
comment on column aplicacion.icono is 'Nombre del Icono de la Opción en el Menú'
/

/*
|| Creación de la Secuencia de la Tabla Aplicacion
*/
 create sequence aplicacion_seq
   minvalue 1 maxvalue 9999999999999999999999999999 
   increment by 1 start with 1906 cache 5 noorder  
   nocycle  nokeep  noscale 
/

/*
|| Creacion de un trigger en la tabla de APLICACION para generar el ID Unico de Registro
*/
create or replace trigger aplicacion_ins 
  before insert on aplicacion             
  for each row  
begin   
  if :NEW.id_aplicacion is null then 
    select aplicacion_seq.nextval 
      into :NEW.id_aplicacion 
      from sys.dual; 
  end if; 
end;
/
alter trigger aplicacion_ins enable
/

/*
|| Creación del Indice Unico del ID de la Tabla Aplicacion
*/
create unique index aplicacion_pk on aplicacion (id_aplicacion)
/
