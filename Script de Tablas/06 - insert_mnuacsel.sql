/************************************
|| Menu Configurable - Fortaleza
||***********************************
||
|| Inserta registro de la opción AcselWeb a Todos los Grupos de Usuario
*/
 insert into mnuacsel
 select 'WEB',gu.codgrpusr,1,1,'ACSELWEB','N','N'
   from grupo_usuario gu
  where not exists ( select 1 
                       from mnuacsel me 
                      where me.codgrpusr=gu.codgrpusr 
                        and me.opcion='ACSELWEB')
/                     
