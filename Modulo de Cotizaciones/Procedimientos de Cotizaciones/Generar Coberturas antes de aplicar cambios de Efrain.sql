Antes del Cambio de Efrain

begin
 if :p9_existe_registro = 'N' then 
    :p9_existe_registro := 'S';
    insert into cotizacion
         ( IdCotiza, TipoId, NumId, DvId, Nombre, Email, Telefono, NroMovil,
           FechaReg, StsCotiza, DiasCotiza, CodProd, CodPlan,
           CodMoneda, Direccion, FecDesde, FecHasta, CodInter,
           Apellido, IdCotizaPlantilla,CodOfi)
     values
        ( :p9_IdCotiza, :p9_TipoId, :p9_NumId, :p9_DvId, :p9_Nombre, :p9_Correo, :p9_Telefono,
         :p9_Celular,sysdate, :p9_Estatus, 15, :p9_Producto, :p9_Plan, :p9_CodMoneda,
         :p9_Direccion,:p9_Desde, :p9_Hasta, :p9_Intermediario, :p9_Apellido, :p9_cotizaplantilla,
         :p9_codofi);
     -- Insertar Coberturas  
     insert into cotizacion_cobertura
     select :p9_IdCotiza, codramoplan||codcobert, indcobertoblig,sumaasegmax,tasamax,primamax,null,codramoplan
       from cobert_plan_prod
       where codplan||revplan = :p9_plan
         and codprod = :p9_producto;
     -- Insertar Clausulas
     insert into cotiza_clausula
        select :p9_IdCotiza,cl.codclau, cp.codramo, cp.indclauoblig, :p9_Desde, :p9_Hasta,null,null
          from clausula cl, clau_ramo_plan cp
         where cl.codclau = cp.codclau
           and cp.codplan||revplan = :p9_plan
           and cp.codprod = :p9_producto;   
     -- Insertar Requisitos.
     insert into cotizacion_requisito
        select codprod, codplan||revplan, codramoplan, codreq, indoblig, sysdate, 
               seq_cotizacion_requisito.nextval,'PEN',:p9_IdCotiza,null,null,null,null
          from req_plan_prod
         where codplan||revplan = :p9_plan
           and codprod          = :p9_producto;
     -- Insertar Anexos
     insert into cotiza_anexo
        select :p9_IdCotiza, an.codanexo, en.codramoplan,'N',:p9_Desde, :p9_Hasta, null
          from anexo an, endoso_ramo_plan_prod en 
         where an.codanexo = en.codanexo
           and codplan||revplan = :p9_plan
           and codprod          = :p9_producto;
 elsif :p9_existe_registro = 'S' then
     update cotizacion
        set Tipoid    = :p9_TipoId,
            NumId     = :p9_NumId,
            DvId      = :p9_DvId,
            Nombre    = :p9_Nombre,
            Email     = :p9_Correo,
            Telefono  = :p9_Telefono,
            NroMovil  = :p9_Celular,
            StsCotiza = :p9_Estatus, 
            CodProd   = :p9_Producto,
            CodPlan   = :p9_Plan,
            CodMoneda = :p9_CodMoneda,
            Direccion = :p9_Direccion,
            FecDesde  = :p9_Desde,
            FecHasta  = :p9_Hasta,
            CodInter  = :p9_Intermediario,
            Apellido  = :p9_Apellido
      where IdCotiza  = :p9_IdCotiza;
 end if;
end;
