select *
  from mnuacsel
 where codaplic='WEB'
   and codgrpusr='DESARROL'
union
select *
  from mnuacsel
 where codaplic='ACSELWEB'
   and codgrpusr='DESARROL'
   and opcion='FOLDER 1'


 insert into mnuacsel
   ( codaplic,codgrpusr,nivel,secuencia,opcion,indforma,indrest,indvieweb)
   values
   ( 'FOLDER2','DESARROL',1,1,'OPCION22','N','N','N')

   SELECT level,codaplic,nivel,secuencia,opcion,SYS_CONNECT_BY_PATH(opcion,'>') recorrido
     FROM mnuacsel
    WHERE codgrpusr = 'DESARROL'
    START WITH opcion = 'ACSELWEB'
  CONNECT BY PRIOR opcion = codaplic
  order siblings by secuencia
  
  
select level,me.codaplic,me.nivel,me.secuencia,me.opcion,sys_connect_by_path(ap.desaplic,'>') recorrido
  from aplicacion ap, mnuacsel me, usuario ua
 where ap.codaplic    = me.opcion
   and ap.plataforma  = '02'
   and me.codgrpusr   = ua.codgrpusr
   and ua.codusr      = 'FPEREZ'
 start with me.opcion = 'ACSELWEB'
 connect by prior me.opcion = me.codaplic
 order siblings by me.secuencia 
