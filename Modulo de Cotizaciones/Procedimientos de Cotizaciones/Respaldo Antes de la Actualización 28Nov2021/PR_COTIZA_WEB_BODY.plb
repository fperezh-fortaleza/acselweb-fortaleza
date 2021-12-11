create or replace PACKAGE BODY pr_cotiza_web is

procedure activar(nidecot  number) is
begin 
  null;
end;

procedure plantilla_cotizacion ( nIdeCotizaPlanilla number, nIdeCotiza number) is
 cursor cur_coberturas is 
    select codramoplan, codcobert, indobliga, prima, tasa, suma_asegurada
      from cotizacion_cobertura
     where idcotiza = nIdeCotiza;
 cursor cur_clausulas is
    select codramo,codclausula,indclausulaoblig
      from cotiza_clausula
     where idcotiza = nIdeCotiza;
 cursor cur_anexos is
    select codanexo,codramo,indanexooblig
      from cotiza_anexo
     where idcotiza = nIdeCotiza;
 cursor cur_requisitos is
    select codprod,codplan,codramo,codreq,indoblig,'PEN' stsreq
      from cotizacion_requisito
     where idcotizacion = nIdeCotiza;
begin
  -- Registrar las coberturas de la cotizacion en la Plantilla
  delete from cot_plantilla_cobert where idcotizaplantilla = nIdeCotizaPlanilla;
  for c in cur_coberturas loop
      insert into cot_plantilla_cobert 
       ( idcotizaplantilla, codramo, codcobert, indcobertoblig, prima, tasa, sumaaseg )
      values
       ( nIdeCotizaPlanilla,c.codramoplan,c.codcobert,c.indobliga,c.prima,c.tasa,c.suma_asegurada);
  end loop;
  -- Registrar las clausulas de la Cotización a la Plantilla
  delete from cot_plantilla_clausula where idcotizaplantilla = nIdeCotizaPlanilla;
  for d in cur_clausulas loop
      insert into cot_plantilla_clausula
       ( idcotizaplantilla, codramo, codclau, indclauoblig, fecharegistro, fechaactualiza )
      values
       ( nIdeCotizaPlanilla,d.codramo,d.codclausula,d.indclausulaoblig,sysdate,sysdate);
  end loop;
  -- Registrar los anexos de la cotización a la Plantilla
  delete from cot_plantilla_anexo where idcotizaplantilla = nIdeCotizaPlanilla;
  for e in cur_anexos loop
      insert into cot_plantilla_anexo
        ( idcotizaplantilla, codramo, codanexo, indanexooblig )
      values
        ( nIdeCotizaPlanilla,e.codramo,e.codanexo,e.indanexooblig);
  end loop;
  -- Registrar los requisitos de la cotización a la plantilla.
  delete cot_plantilla_requisito where idcotizaplantilla = nIdeCotizaPlanilla;
  for f in cur_requisitos loop
      insert into cot_plantilla_requisito
        ( idcotizaplantilla,codramo,codreq,indoblig,fecharegistro,fechactualiza )
      values
        ( nIdeCotizaPlanilla,f.codramo,f.codreq,f.indoblig,sysdate,sysdate );
  end loop;
end;

procedure activar_cotizacion (nidecot number) is
 ntotprima     number (12,2) := 0;
begin
    -- Verificar si la cotización tiene una prima mayor a cero 
    select sum(nvl(prima,0))
      into ntotprima
      from cotizacion_cobertura 
     where idcotiza = nidecot;
    if ntotprima > 0 then 
       update cotizacion
          set stscotiza = 'ACT'
        where idcotiza = nidecot;
    else
       raise_application_error (-20100,'Para activar la Cotizacion debe tener una prima mayor a cero.');
    end if;
end;

 function calculo_prima_acreencias ( nidecotiza number, ntotprimacotiza number ) return number is

 cursor cur_prima_ramo is
   select codramoplan,sum(nvl(prima,0)) mtoprima 
     from cotizacion_cobertura 
    where idcotiza = nidecotiza 
    group by codramoplan;

 cursor cur_acreencias ( p_codramoplan varchar2 ) is
   select ca.codgrupoacre,ca.codcptoacre,ca.natcptoacre,ca.indtipocpto,ca.mtocptoacre,ca.porccptoacre
     from cpto_acre_plan_prod ca, cotizacion co
    where ca.indauto             = 'S'
      and trunc(co.fechareg) BETWEEN trunc(nvl(ca.fecinivig,co.fechareg)) and trunc(nvl(ca.fecfinvig,co.fechareg)) 
      and ca.codramoplan         = p_codramoplan
      and ca.codplan||ca.revplan = co.codplan
      and ca.codprod             = co.codprod
      and co.idcotiza            = nidecotiza
      order by ca.natcptoacre;  
  ntotprima     number (12,2) := 0;
  ntotprimaramo number (12,2) := 0;
 begin
  for p in cur_prima_ramo loop
      --ntotprimaramo := p.mtoprima;
      ntotprimaramo := ntotprimacotiza; 
    for c in cur_acreencias ( p.codramoplan ) loop
        -- Verifica la naturaleza de la acreencia.
        if c.natcptoacre = 'A' then    --asignación
           -- Verificar Porcentaje de la acreencia - Asignación
           if c.porccptoacre is not null then
              --ntotprimaramo := ntotprimaramo + (ntotprimaramo * (c.porccptoacre/100));
              ntotprimaramo := ntotprimaramo + (ntotprimacotiza * (c.porccptoacre/100));  -- Siempre sobre la prima tecnica.
           elsif nvl(c.mtocptoacre,0) <> 0 then
              -- Se considera el monto de la Acreencia - Asignación
              ntotprimaramo := ntotprimaramo + nvl(c.mtocptoacre,0);
           end if;
        elsif c.natcptoacre = 'D' then -- Deducción
            -- Verificar Porcentaje de la acreencia - Deducción
           if c.porccptoacre is not null then
              --ntotprimaramo := ntotprimaramo - (ntotprimaramo * (c.porccptoacre/100));
              ntotprimaramo := ntotprimaramo - (ntotprimacotiza * (c.porccptoacre/100));  -- Siempre sobre la prima tecnica.
           elsif nvl(c.mtocptoacre,0) <> 0 then
              -- Se considera el monto de la Acreencia - Deducción
              ntotprimaramo := ntotprimaramo - nvl(c.mtocptoacre,0);
           end if;
        end if;
    end loop;   -- cur_acreencias    
    -- Sumatoria de la prima Total.
    ntotprima := ntotprima + nvl(ntotprimaramo,0);
  end loop;     -- cur_prima_ramo
  return (ntotprima);
 end calculo_prima_acreencias;

/********************************************************/
/*Funccion Emitir Poliza, Retorna Idepol****************/
/********************************************************/

FUNCTION EMITE_POLIZA(nIdCotiza   NUMBER) RETURN NUMBER IS

cCodProd      VARCHAR2(4);
cCodCli       VARCHAR2(14);
cCodMoneda     VARCHAR2(4);
cCodCondCobro VARCHAR2(6);--:='000024';
cRespCob      VARCHAR2(6);--:='COB';
cCodGrp       VARCHAR2(4);--:=NULL;
cActividad    VARCHAR2(6);--:='0020';
dFecIniVig    DATE;
dFecFinVig    DATE;
cCodOfiEmi    VARCHAR2(6);
cCodOfiSusc   VARCHAR2(6);
cCodArea      VARCHAR2(4);
--cCodRamoCert  VARCHAR2(4);
cCodPlan      VARCHAR2(3);
cRevPlan      VARCHAR2(3);
cCodClau      VARCHAR2(6);
nIdeClau      NUMBER;
cCodAnexo     VARCHAR2(6);
nIdAnexo      NUMBER;
cCodReq       VARCHAR2(6);
cCodCobert    VARCHAR2(4);
nSumaAsegMoneda NUMBER(14,2);
nTasa         NUMBER(6,3);

nPrimaMoneda  NUMBER(14,2);  
nPorcded      NUMBER(6,3):= 0;
nMtodedmin    NUMBER(14,2):= 0;  
cBaseded      VARCHAR2(4):= 'S';
nPorcprimadep NUMBER:= 100;
cIndmasiva    VARCHAR2(4);
nIdeCobert    NUMBER;
nIdePol       NUMBER;
cCodInter     VARCHAR2(6);
nNumPol       NUMBER;
nNumPolDef    NUMBER;
nNumCert      NUMBER:=1;
nExiste       NUMBER;
--
cCodModelo   VARCHAR2(4);
cCodMarca     VARCHAR2(4); 
cCodVersion   VARCHAR2(4);
cAnoVeh       VARCHAR2(4);
cDescMotor    VARCHAR2(4); 
cCodDestinado VARCHAR2(4);
cColor        VARCHAR2(4); 
cSerialCarroceria VARCHAR2(4); 
cNumPlaca     VARCHAR2(10); 
nNumExp       NUMBER;
cClaseEmi     VARCHAR2(4); 
cRegistroRap  VARCHAR2(4);
cUsado        VARCHAR2(4);
nValorveh     NUMBER;
nValor_total  NUMBER;
cTipo_fianza  VARCHAR2(4);
cPlacaexhibicion VARCHAR2(4);
nNumpeones    NUMBER;
nSumaasegrc   NUMBER(14,2);
cRentaveh     NUMBER(14,2);
cRcexceso     NUMBER(14,2);
cAccconductor NUMBER(14,2);
cAccpasajeros NUMBER(14,2);
cPolitacc     NUMBER(14,2);
cGastosfunerales  NUMBER(14,2);
cUso_veh      VARCHAR2(4);
cTipoveh      VARCHAR2(4);
cCodpotencia  VARCHAR2(4);
cPlanmin      VARCHAR2(4);
cTipomodelo   VARCHAR2(4);
nEdad_conductor NUMBER;
cPlanminley   VARCHAR2(4);
cPlanminfianzas VARCHAR2(4);
cPlanminrconductor  VARCHAR2(4);
dFecendoso     DATE;
cClase        VARCHAR2(4);
cTipocombustible  VARCHAR2(4);
nNumid        NUMBER;
cDvid         VARCHAR2(4);
cTipoid       VARCHAR2(4);
nSerieid      NUMBER;
cCodramocert  VARCHAR2(4);
cCodajustador VARCHAR2(4);
cIndtransito  VARCHAR2(4);
nPorcresp     NUMBER;
cConductor    VARCHAR2(4);
cLicenciacond VARCHAR2(4);
cReclamante   VARCHAR2(4);
cSubcategoria VARCHAR2(4);
cIndcondaseg  VARCHAR2(4);
cRoseta       VARCHAR2(4);
cFactura      VARCHAR2(4);
nPrimaanualcot  VARCHAR2(4);
cCodinspector VARCHAR2(4);
cTipo_transporte  VARCHAR2(4);
nNumPuestos   NUMBER;

cCodClifact   VARCHAR2(14); 
cCodpais      VARCHAR2(4);
cCodestado    VARCHAR2(4);
cCodciudad    VARCHAR2(4);
cCodmunicipio VARCHAR2(4);
cDirec        VARCHAR2(400);
cTextoMedio   VARCHAR2(4000);
cZonapostal   VARCHAR2(6);
nNumOper      NUMBER;
cIndliquida   VARCHAR2(6);
nOrden        NUMBER;
cindsumaded   VARCHAR2(1);
cIndMod       VARCHAR2(1);
cIndIncRen    VARCHAR2(1);
nMtototreca   NUMBER(14,2);
nMtototdctomoneda NUMBER(14,2);
nMtoTotRecaMoneda NUMBER(14,2);

CURSOR COTI IS
SELECT IdCotiza, TipoId, SerieId,NumId, DvId, Nombre, Email, Telefono, NroMovil,
           FechaReg, StsCotiza, DiasCotiza, CodProd, CodPlan,
           CodMoneda, Direccion, FecDesde, FecHasta, CodInter,
           Apellido, IdCotizaPlantilla,CodOfi,CodUsr
FROM COTIZACION 
WHERE IdCotiza = nIdCotiza;

CURSOR CERT_VEH IS
SELECT IdCotizacion,numplaca,anoveh,codmarca,codmodelo,codversion,descmotor,claseveh,subcategoria,
serialcarroceria,numpeones,color,serialmotor,numpuestos,tipomodelo,codremolque,usado,codpotencia,
uso_veh,tipocombustible,rentaveh,coddestinado,canttonelada,tipo_transporte,valorveh ,Fecendoso
FROM cot_datos_particulares_auto 
WHERE IdCotizacion = nIdCotiza;

CURSOR COBERT IS
SELECT IdCotiza,CodCobert,IndObliga,Suma_Asegurada,Tasa,Prima,IdCobertura,CodRamoPlan
FROM COTIZACION_COBERTURA 
WHERE IdCotiza = nIdCotiza;


CURSOR RAMOS IS
SELECT DISTINCT CodRamoPlan
FROM COTIZACION_COBERTURA 
WHERE IdCotiza = nIdCotiza;


CURSOR CLAUSULA IS
SELECT IdCotiza,CodClausula,CodRamo,IndClausulaOblig,Fecha_Desde,Fecha_Hasta,Notas,IdCotizaClausula
FROM COTIZA_CLAUSULA 
WHERE IdCotiza = nIdCotiza;

CURSOR REQUIS IS
SELECT IdCotizacion,CodProd,CodPlan,CodRamo,CodReq,IndOblig,FecSts,IdRequisito,StsReq
FROM COTIZACION_REQUISITO 
WHERE IdCotizacion = nIdCotiza;

CURSOR ENDOSOS IS
SELECT IdCotiza,CodAnexo,CodRamo,IndAnexoOblig,Fecha_Desde,Fecha_Hasta,IdCotizaAnexo
FROM cotiza_anexo 
WHERE IdCotiza = nIdCotiza;



BEGIN
  --- prueba de usuario:
  --raise_application_error(-20100,'Usuario: '||coduser);
  FOR P IN COTI LOOP
    cCodProd        :=P.CodProd;
    cCodMoneda       :=P.CodMoneda;
    cCodCondCobro   :='000024';
    cRespCob        :='COB';
    cCodGrp         :=NULL;
    cActividad      :='0020';
    cCodInter       :=P.CodInter;
    dFecIniVig      :=P.FecDesde;
    dFecFinVig      :=P.FecHasta;
    --cCodClifact     :=P.CodProd; 
    cCodpais        :='073'; 
    cCodestado      :='01'; 
    cCodciudad      :='001'; 
    cCodmunicipio   :='001'; 
    cDirec          :=P.CodProd; 
    cTextoMedio     :=P.CodProd; 
    cZonapostal     :=P.CodProd; 
    
    BEGIN
    PR_TERCERO.CREAR(P.TipoId ,
                    1, --P.SerieId,
                    P.NumId ,
                    P.DvId ,
                    P.Nombre ,
                    P.Nombre ,
                    'N',
                    SYSDATE,
                    'PRUEBAS',
                    '073',
                    '01',
                    '001',
                    '001',
                    '18292809762',
                    '18292809762',
                    '18292809762',
                    NULL,
                    NULL,
                    '00',
                    'ACT')
                    ;
    END;
    
    BEGIN
    SELECT sq_codcli.NEXTVAL
    INTO cCodCli
    FROM DUAL;
    END;
    
    cCodCli:=LPAD(cCodCli,14,'0');
    cCodCliFact:=LPAD(cCodCli,14,'0');
    
    BEGIN
    PR_CLIENTE.CREAR(P.TipoId ,1 ,P.NumId ,P.DvId ,
                 cCodCli ,SYSDATE);
    END;
    
    BEGIN
     SELECT SQ_POLDEF.NEXTVAL
     INTO nIdePol
     FROM SYS.DUAL;
    END;
    
   /* BEGIN
      SELECT CODSUC
      INTO cCodOfiEmi
      FROM USUARIO
      WHERE CODUSR = USER;
    END;*/
    cCodOfiEmi:='SC0101';
    
    BEGIN
      SELECT CODOFI
      INTO cCodOfiSusc
      FROM INTERMEDIARIO
      WHERE CODINTER = cCodInter;
    END;
    
    BEGIN
          SELECT NumPol
          INTO   nNumPol
          FROM   CORRELATIVO_PRODUCTO
          WHERE  CodProd = NVL(cCodProd,'AUTO')
          FOR UPDATE OF NUMPOL;
          EXCEPTION WHEN NO_DATA_FOUND THEN
              raise_application_error(-20100,'No se ha Definido el Correlativo de Polizas para este Producto ' ||cCodProd||sqlerrm);
      END;
    
    nNumPolDef:=nNumPol+1;
    BEGIN
    INSERT INTO POLIZA(tipocotpol,codpol,numpol,numren,idepol,indnumpol,codprod,stspol,
                      codcli,fecren,fecinivig,fecfinvig,tipovig,tipopdcion,tipofact,indcoa,codformfcion,
                      codofiemi,codofisusc,codmoneda,indmultiinter,indpoladhesion,indrenauto,tiposusc,
                      codformpago,fecultfact,codcondcobro,respcob,codgrp,indtasapromedio,fecingpol,fecemi,
                      indmovpolren,indfronting,indcomesp,indanuauto,indfactauto,tasacambio,indcumulocliente,
                      codcia,indresppago,idecot,actividad,login)
                VALUES('P',cCodProd,nNumPolDef,0,nIdePol,'N',cCodProd,'VAL',
                      cCodCli,Trunc(sysdate),Trunc(sysdate),ADD_MONTHS(sysdate,12),'A','P','M','N','P',
                      cCodOfiEmi,cCodOfiSusc,cCodMoneda,'N','N','S','I',
                      'A',Trunc(sysdate),'000024',cRespCob,cCodGrp,NULL,Trunc(sysdate),Trunc(sysdate),
                      'N','N','N','N','N',1,'N',
                      --'01','N',nIdCotiza,cActividad,user);
                      '01','N',nIdCotiza,cActividad,coduser);
                      dbms_output.put_line('Inserto la Poliza');
    EXCEPTION
      WHEN OTHERS THEN
      raise_application_error(-20100,'Error Insertando la Poliza ' ||nNumCert||sqlerrm);
        NULL;
    END;
    
    BEGIN
       SELECT 1
       INTO nExiste
       FROM POLIZA
       WHERE NumPol = nNumPol
       AND   CodProd = cCodProd;
       EXCEPTION
        WHEN NO_DATA_FOUND THEN nExiste:=0;
        WHEN TOO_MANY_ROWS THEN nExiste:=1;
    END;
    dbms_output.put_line('EXSITE ES '||nExiste);

    IF nExiste=0 THEN
         BEGIN
           UPDATE CORRELATIVO_PRODUCTO
           SET    NumPol  = NumPol - 1
           WHERE  CodProd = cCodProd;
         END;
          -- EXIT;
    ELSE
         BEGIN
             UPDATE CORRELATIVO_PRODUCTO
             SET    NumPol  = NumPol + 1
             WHERE  CodProd = cCodProd;
          END;

    END IF;
    
    BEGIN
      pr_direc_cobropoliza.insertar(nIdePol,cCodCli);
    END;
    
    UPDATE POLIZA SET IDECOT = nIdCotiza
    WHERE IDEPOL = nIdePol;
    
    BEGIN
    INSERT INTO PART_INTER_POL(idepol,codinter,indlider,porcpart,porcomesp,codagente)
                        VALUES(nIdePol,cCodInter,'S',100,0,NULL);
    EXCEPTION
      WHEN OTHERS THEN
       --raise_application_error(-20100,'Error Insertando el Certificado ' ||nNumCert||sqlerrm);
        NULL;
    END;
    
    BEGIN
     INSERT INTO CERTIFICADO(IdePol, NumCert, StsCert, DescCert, FecIng, CodCli,
                             CodCliFact, CodOfiSusc, CodOfiEmi,
                             Codpais,Codestado,Codciudad,Codmunicipio,Direc,
                             TextoMedio,Actividad,Zonapostal)
                      VALUES(nIdePol,nNumCert, 'VAL', 'COTIZACION',TRUNC(dFecIniVig), cCodCli,
                            cCodClifact, cCodOfiSusc, cCodOfiEmi,
                            cCodpais,cCodestado,cCodciudad,cCodmunicipio,cDirec,
                            cTextoMedio,cActividad,cZonapostal);
    EXCEPTION
      WHEN OTHERS THEN
        -- NULL;
         raise_application_error(-20100,'Error Insertando el Certificado ' ||nNumCert||sqlerrm);
    END;
    
    IF cCodArea = '0002' THEN
    
      FOR CV IN CERT_VEH LOOP
      cCodModelo    :=CV.CodModelo;
      cCodMarca     :=CV.CodMarca; 
      cCodVersion    :=CV.CodVersion;
      cDescMotor    :=CV.DescMotor;
      cCodDestinado :=CV.CodDestinado;
      cColor       :=CV.Color;
      cSerialCarroceria :=CV.SerialCarroceria;
      nNumExp       :=null;--CV.NumExp;
      cClaseEmi     :=CV.ClaseVeh;
      cRegistroRap  :=null;--CV.RegistroRap;
      cUsado        :=CV.Usado;
      nValorveh     :=CV.Valorveh;
      nValor_total  :=null;--CV.Valor_total;
      cTipo_fianza  :=null;--CV.Tipo_fianza;
      cPlacaexhibicion :=null;--CV.Placaexhibicion;
      nNumpeones    :=CV.Numpeones;
      nSumaasegrc   :=null;--CV.Sumaasegrc;
      cRentaveh     :=CV.Rentaveh;
      cRcexceso     :=null;--CV.Rcexceso;
      cAccconductor :=null;--CV.Accconductor;
      cAccpasajeros :=null;--CV.Accpasajeros;
      cPolitacc     :=null;--CV.Politacc;
      cGastosfunerales  :=null;--CV.Gastosfunerales;
      cUso_veh      :=CV.Uso_veh;
      cCodpotencia  :=CV.Codpotencia;
      cPlanmin      :=null;--CV.Planmin;
      cTipomodelo   :=CV.Tipomodelo;
      nEdad_conductor :=null;--CV.Edad_conductor;
      cPlanminley   :=null;--CV.Planminley;
      cPlanminfianzas :=null;--CV.Planminfianzas;
      cPlanminrconductor  :=null;--CV.Planminrconductor;
      dFecendoso     :=CV.Fecendoso;
      cClase        :=null;--CV.Clase;
      cTipoveh      :=null;--CV.Tipoveh;
      cTipocombustible  :=CV.Tipocombustible;
      nNumid        :=null;--CV.Numid;
      cDvid         :=null;--CV.Dvid;
      cTipoid       :=null;--CV.Tipoid;
      nSerieid      :=null;--CV.Serieid;
      cCodramocert  :=null;--CV.Codramocert;
      cCodajustador :=null;--CV.Codajustador;
      cIndtransito  :=null;--CV.Indtransito;
      nPorcresp     :=null;--CV.Porcresp;
      cConductor    :=null;--CV.Conductor;
      cLicenciacond :=null;--CV.Licenciacond;
      cReclamante   :=null;--CV.Reclamante;
      cSubcategoria :=CV.Subcategoria;
      cIndcondaseg  :=null;--CV.Indcondaseg;
      cRoseta       :=null;--CV.Roseta;
      cFactura      :=null;--CV.Factura;
      nPrimaanualcot  :=null;--CV.Primaanualcot;
      cCodinspector :=null;--CV.Codinspector;
      cTipo_transporte  :=CV.Tipo_transporte;    
    
      BEGIN
          INSERT INTO CERT_VEH
               ( IdePol, NumCert, CodModelo, CodMarca, CodVersion, DescMotor, CodDestinado,
                 CodRemolque, NumPlaca, AnoVeh, CantTonelada, NumPuestos, TipoVeh, FecAdq,
                 Color, SerialCarroceria, SerialMotor, NumExp, ClaseVeh, CodPlanApov, FecReg,
                 RegistroRap,usado,valorveh,valor_total,tipo_fianza,placaexhibicion,numpeones,
                 sumaasegrc,rentaveh,rcexceso,accconductor,accpasajeros,politacc,gastosfunerales,
                 uso_veh,codpotencia,planmin,tipomodelo,edad_conductor,planminley,planminfianzas,
                 planminrconductor,fecendoso,clase,tipocombustible,numid,dvid,tipoid,serieid,codcli,
                 codramocert,codajustador,indtransito,porcresp,conductor,licenciacond,reclamante,
                 subcategoria,indcondaseg,roseta,factura,primaanualcot,codinspector,tipo_transporte)
          VALUES
               ( nIdePol, nNumCert, cCodModelo, cCodMarca, NVL(cCodVersion,'01'),cDescMotor, cCodDestinado,
                 'NOUSA', cNumPlaca, cAnoVeh, NULL, nNumPuestos,  cTipoveh, NULL,
                 cColor, cSerialCarroceria, NULL, nNumExp,cClaseEmi, NULL, TRUNC(SYSDATE),
                 cRegistroRap,cUsado,nValorveh,nValor_total,cTipo_fianza,cPlacaexhibicion,nNumpeones,
                 nSumaasegrc,cRentaveh,cRcexceso,cAccconductor,cAccpasajeros,cPolitacc,cGastosfunerales,
                 cUso_veh,cCodpotencia,cPlanmin,cTipomodelo,nEdad_conductor,cPlanminley,cPlanminfianzas,
                 cPlanminrconductor,dFecendoso,cClase,cTipocombustible,nNumid,cDvid,cTipoid,nSerieid,cCodcli,
                 cCodramocert,cCodajustador,cIndtransito,nPorcresp,cConductor,cLicenciacond,cReclamante,
                 cSubcategoria,cIndcondaseg,cRoseta,cFactura,nPrimaanualcot,cCodinspector,cTipo_transporte);
                 
                  dbms_output.put_line('Datos Particulares Insertado');
      EXCEPTION
          WHEN OTHERS THEN
             raise_application_error(-20100,'Error Insertando Los Datos Particulares '||sqlerrm );
      END;
    
    END LOOP;
    
    END IF;
    
    FOR RA IN RAMOS LOOP
      cCodRamoCert:= RA.CodRamoPlan;
      cCodPlan    := substr(P.CodPlan,1,3);
      cRevPlan    := substr(P.CodPlan,4,3);    

      BEGIN
        INSERT INTO CERT_RAMO(IdePol, NumCert, CodRamoCert, StsCertRamo, FecIniValid,
                              FecFinValid, CodCumulo, Codplan, Revplan)
                       VALUES(nIdePol, nNumCert, cCodRamoCert, 'VAL', dFecIniVig,
                             dFecFinVig,cCodCli, cCodPlan, cRevPlan);
        EXCEPTION
        WHEN OTHERS THEN
           raise_application_error(-20100,'Error Insertando Los Ramos del Certificado '||' '||sqlerrm);
      END;
      
      
      FOR CLA IN CLAUSULA LOOP
      cCodClau := CLA.CodClausula;
      SELECT sq_clau_cert.NEXTVAL
      INTO nIdeClau
      FROM   DUAL;
      
        BEGIN
          INSERT INTO CLAU_CERT(IdePol, NumCert, CodRamoCert, CodClau, StsCLau, FecIniValid,
                                FecFinValid, IdeClau, NumOper)
                         VALUES(nIdePol, nNumCert, cCodRamoCert, cCodClau, 'VAL', dFecIniVig,
                               dFecFinVig,nIdeClau,nNumOper);
          EXCEPTION
          WHEN OTHERS THEN
             raise_application_error(-20100,'Error Insertando Los Ramos del Certificado '||sqlerrm );
        END;
      END LOOP;
      
      FOR ENDO IN ENDOSOS LOOP
      cCodAnexo := ENDO.CodAnexo;
      SELECT sq_anexocert.NEXTVAL
      INTO nIdAnexo
       FROM   DUAL;
       
        BEGIN
          INSERT INTO ANEXO_CERT(IdePol, NumCert, CodRamoCert, CodAnexo, StsAnexo, FecIniValid,
                                FecFinValid, FecRecep, IdeAnexo, NumOper)
                         VALUES(nIdePol, nNumCert, cCodRamoCert, cCodAnexo, 'VAL', dFecIniVig,
                               dFecFinVig, NULL, nIdAnexo, nNumOper);
          EXCEPTION
          WHEN OTHERS THEN
             raise_application_error(-20100,'Error Insertando Los Ramos del Certificado '||sqlerrm );
        END;
      END LOOP;
      
      FOR REQ IN REQUIS LOOP
      cCodReq := REQ.CodReq;      
        BEGIN
          INSERT INTO REQ_EMI_GEN(IdePol, NumCert, CodRamoCert, Codplan, Revplan, StsReq, CodReq, 
                                 IndOblig,FecSolReq, FecRecepReq, FecFinPlazo)
                         VALUES(nIdePol, nNumCert, cCodRamoCert, cCodplan, cRevplan, 'VAL', cCodReq,
                               'N',dFecFinVig,NULL,NULL);
          EXCEPTION
          WHEN OTHERS THEN
             raise_application_error(-20100,'Error Insertando Los Ramos del Certificado '||sqlerrm );
        END;
      END LOOP;
      
      
      
        FOR CC IN COBERT LOOP
          cCodCobert      := CC.CodCobert;
          nSumaAsegMoneda := CC.Suma_Asegurada;
          nTasa           := CC.Tasa; 
          nPrimaMoneda    := CC.Prima;
          nPorcded        := 0;
          nMtodedmin      := 0;  
          cBaseded        := 'S';
          nPorcprimadep   := 100;
          cIndmasiva      := 'N';
          
          BEGIN
           SELECT SQ_COBERT.NEXTVAL
             INTO nIdeCobert
             FROM   DUAL;
          END;
          
          BEGIN
            INSERT INTO COBERT_CERT(IdeCobert,IdePol, NumCert, CodRamoCert, CodPlan, RevPlan, 
                                   CodCobert, StsCobert, SumaAsegMoneda, Tasa, PrimaMoneda,MtoTotRecaMoneda,
                                   mtototdctomoneda,codmoneda,SumaAseg,Prima,mtototreca,FecIniValid,FecFinValid, 
                                   IndIncRen, IndMod,indsumaded,porcded,mtodedmin,baseded,orden,indliquida,
                                   porcprimadep,indmasiva)
                             VALUES(nIdeCobert,nIdePol, nNumCert, cCodRamoCert, cCodPlan, cRevPlan, 
                                   cCodCobert, 'VAL', nSumaAsegMoneda, nTasa, nPrimaMoneda,nMtoTotRecaMoneda,
                                   nMtototdctomoneda,cCodmoneda,nSumaAsegMoneda,nPrimaMoneda,nMtototreca,dFecIniVig,dFecFinVig, 
                                   cIndIncRen, cIndMod,cindsumaded,nPorcded,nMtodedmin,cBaseded,nOrden,cIndliquida,
                                   nPorcprimadep,cIndmasiva);                      
            EXCEPTION
            WHEN OTHERS THEN
               raise_application_error(-20100,'Error Insertando Las Coberturas del Certificado '||sqlerrm );
          END;
        END LOOP;    
    END LOOP;
  END LOOP;
  
  return nNumPolDef;
  END;
 

 function busca_datos_particular_auto ( nidecotiza number ) return varchar2 is
   cExiste varchar(1) := 'N';
 begin 
   -- Verificar si existe Datos Particulares de Automovil en la Cotización. 
   begin
    select 'S'
      into cExiste
      from cot_datos_particulares_auto
     where idcotizacion = nidecotiza;
   exception
     when no_data_found then cExiste := 'N';
     when too_many_rows then cExiste := 'S';
   end;
   return cExiste;
 end busca_datos_particular_auto;
END; 
