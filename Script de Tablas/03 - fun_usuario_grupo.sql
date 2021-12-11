/************************************
|| Menu Configurable - Fortaleza
||***********************************
||
|| Creación de una función para buscar grupo del usuario
||
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

