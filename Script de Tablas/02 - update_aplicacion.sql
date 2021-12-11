/************************************
|| Menu Configurable - Fortaleza
||***********************************
||
|| Actualizar las opciones del Aplicativo Acsel asignando en la columna plataforma el Valor = 01
||
*/
update aplicacion
   set id_aplicacion = aplicacion_seq.nextval,
       plataforma    = '01'   -- Acsel
 where id_aplicacion is null
 /
