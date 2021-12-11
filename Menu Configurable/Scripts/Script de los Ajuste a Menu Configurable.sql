/************************************
|| Menu Configurable - Fortaleza
||***********************************
*/

/*
|| Ajustes a la Tabla Aplicacion
*/
alter table APLICACION add
( id_aplicacion number,       -- Id Unico de cada registro de la tabla.
  plataforma    varchar2(2),  -- Código de la Plataforma: 01 - ACSEL y 02 - ACSELWEB
  nropag        number,       -- Número de Pagina de Apex asociada a la opción
  icono         varchar2(200) -- Nombre del Icono de la Opción en el Menú
)
/  

COMMENT ON COLUMN aplicacion.id_aplicacion IS 'Id Unico de cada registro de la tabla'
/
COMMENT ON COLUMN aplicacion.plataforma is 'Código de la Paltaforma: 01 - ACSEL y 02 - ACSELWEB'
/
COMMENT ON COLUMN aplicacion.nropag is 'Número de Pagina de Apex asociada a la opción'
/
COMMENT ON COLUMN aplicacion.icono is 'Nombre del Icono de la Opción en el Menú'
/

/*
|| Creación de la Secuencia de la Tabla Aplicacion
*/
 create sequence aplicacion_seq
   minvalue 1 maxvalue 9999999999999999999999999999 
   increment by 1 start with 1906 cache 5 noorder  
   nocycle  nokeep  noscale  global
/

/*
|| update a la tabla de Aplicación
*/
update aplicacion
   set id_aplicacion = aplicacion_seq.nextval,
       plataforma    = '01'   -- Acsel
 where id_aplicacion is null
 /

/*
|| Creacion de un trigger en la tabla de APLICACION
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
end
/

/*
|| Creación de un trigger para buscar grupo del usuario
*/
create or replace function usuario_grupo
(cUsuario in varchar2) return varchar2 is
 cGrupo varchar2(200);
begin
  begin
    select codgrpusr
      into cGrupo
      from usuario
     where stsusr = 'ACT'
       and codusr = cUsuario;
  exception
      when no_data_found then
           cGrupo := null;
  end;
  return (cGrupo);
end;

/*
|| Inserta una Lista de Valores - Estatus de la aplicacion - DIR_LVAL
*/
insert into dir_lval
   (tipolval, descrip, longcod, tipocod, longdesc, tipouso)
values 
   ('STSAPLIC', 'Estatus de las opciones del Sistema', 3, 'A', 60, G)
/

/*
|| Inserta una lista de Valores - Estatus de la Aplicación - LVAL
*/
insert into lval ( tipolval,codlval,descrip)
  values ( 'STSAPLIC', 'ACT', 'ACTIVO')
/
insert into lval ( tipolval,codlval,descrip)
  values ( 'STSAPLIC', 'SUS', 'SUSPENDIDO')
/

22/07/2021

- pruebas del menu.

- crear aplicacion web a todos los grupos.
 insert into mnuacsel
 select 'WEB',gu.codgrpusr,1,1,'ACSELWEB','N','N',NULL
   from grupo_usuario gu
  where not exists ( select 1 
                       from mnuacsel me 
                      where me.codgrpusr=gu.codgrpusr 
                        and me.opcion='ACSELWEB')
                        
- no pueda eliminar ese registro de ACSELWEB.
- crear un trigger en grupo_usuario para registrar la opcion ACSELWEB.

create or replace trigger grupo_usuario_ins
BEFORE
insert on "GRUPO_USUARIO"
for each row
declare
 nExiste NUMBER(1) := 0;
begin
 begin
   select 1
     into nExiste
     from mnuacsel
    where opcion    = 'ACSELWEB'
      and codgrpusr = :NEW.codgrpusr;
 exception
    when no_data_found then nExiste := 0;
    when too_many_rows then nExiste := 1;
 end;
 if nExiste = 0 then
    insert into mnuacsel
      select 'WEB',:NEW.codgrpusr,1,1,'ACSELWEB','N','N',NULL
        from dual;
 end if;
end;
- elaborar documento word para instructivo.



