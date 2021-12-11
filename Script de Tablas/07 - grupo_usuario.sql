/************************************
|| Menu Configurable - Fortaleza
||***********************************
||
|| Actualizar las opciones del Aplicativo Acsel asignando en la columna plataforma el Valor = 01
||
*/
create or replace trigger grupo_usuario_ins
before
insert on grupo_usuario
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
      select 'WEB',:NEW.codgrpusr,1,1,'ACSELWEB','N','N'
        from dual;
 end if;
end;
/
alter trigger grupo_usuario_ins enable
/
