create or replace package body PR_APEX as

function apex_report_server return VARCHAR2 is
begin
   return 'http://10.17.31.83:9002/reports/rwservlet?keyapex';
end apex_report_server;

function imprimir_reportes (nIdePol        NUMBER  , nIdeOp         NUMBER,
                            cTipoImpresion VARCHAR2, cIderep        VARCHAR2,
                            cDescImp       VARCHAR2, nCantidadCopia NUMBER, 
                            cCodProd       VARCHAR2, cTipoRep       VARCHAR2) return VARCHAR2 is
cCodMoneda   POLIZA.CodMoneda%TYPE;
cCodPlan     COBERT_CERT.CodPlan%TYPE;
cRevPlan     COBERT_CERT.RevPlan%TYPE;
cTipoPdCion  VARCHAR2(1); 
cNumAcuerdo  FACTURA.NumAcuerdo%TYPE; 
dFecha_Desde DATE;
nNumPol      POLIZA.NumPol%TYPE;                        
                          
begin
  -- Buscar Datos: Moneda y Plan de la Póliza
  BEGIN
    SELECT DISTINCT PO.CodMoneda,CC.CodPlan,CC.RevPlan, PO.TipoPdcion
      INTO cCodMoneda,cCodPlan,cRevPlan, cTipoPdcion
      FROM COBERT_CERT CC, POLIZA PO
     WHERE CC.IdePol = PO.IdePol
       AND PO.IdePol = nIdepol;
  EXCEPTION 
     WHEN OTHERS THEN 
          NULL;
  END;

  -- Preguntar a Oraldo. Si esto se sigue aplicando.
  IF nIdePol=94637 OR nIdePol=99999 OR nIdePol=111127 THEN
   	  NULL;
  ELSE
	  DELETE FROM CARATULA_POL WHERE IdePol = nIdePol;
	  PR_CARAT_POLIZA.Gen_Carat_Poliza(nIdePol);
      --COMMIT;
  END IF;

  IF cTipoPdcion != 'A' THEN
    IF cTipoRep = 'ANEX' THEN
      RETURN PR_APEX.IMPRIMIR_ANEXO(nIdePol,nIdeop,cIdeRep,nCantidadCopia);
    END IF;
    IF cTipoRep = 'RECI' THEN
    	IF cCodProd = 'PCC' THEN
    	   RETURN PR_APEX.GEN_CONTRATO (nIdePol,1,cCodProd,cCodPlan,cRevPlan,cCodProd,cCodMoneda,NULL,cTipoRep);
    	ELSE
           RETURN PR_APEX.IMPRIMIR_RECIBO ( nIdePol, nIdeop, NULL, cIdeRep, NULL, nCantidadCopia);
      END IF;
    END IF;
    IF cTipoRep = 'RELC' THEN
       return PR_APEX.IMPRIMIR_RELACION ( nIdePol,  nIdeop, NULL, cIdeRep, NULL, nCantidadCopia);
    END IF;
    IF cTipoRep = 'CESC' THEN
       return PR_APEX.IMPRIMIR_COASEGURO ( nIdePol, nIdeop, NULL, cIdeRep, NULL, nCantidadCopia, cCodProd);
    END IF;
    IF cTipoRep = 'CLAU' THEN
       --IF :W_T = 'W' THEN
       IF 1 = 1 THEN
          --FR_IMPRIMIR_CLAUSULAS ( nIdePol, nIdeop,cTipo,cIdeRep,cNombreImpresora,nCantidadCopia, cCodProd);
          null;
       ELSE
          --FR_IMPRIMIR_CLAUSULAS_TEXT( nIdePol, nIdeop,cTipo,cIdeRep,cNombreImpresora,nCantidadCopia, cCodProd);
          null;
       END IF;
    END IF;
    IF cTipoRep = 'COGE' THEN
       return PR_APEX.IMPRIMIR_CONDICIONES_GEN ( nIdePol, nIdeop, NULL, cIdeRep, NULL, nCantidadCopia, cCodProd);
    END IF; 
    IF cTipoRep = 'CART' THEN
       return PR_APEX.IMPRIMIR_CARTAS ( nIdePol, nIdeop, NULL, cIdeRep, NULL, nCantidadCopia, cCodProd);
    END IF;
    IF cTipoRep = 'MARB' THEN 
       return PR_APEX.IMPRIMIR_MARBETE (nIdePol,nIdeop,NULL,cIdeRep,NULL,nCantidadCopia);
    END IF;
    IF cTipoRep = 'MARI' THEN 
      RETURN PR_APEX.IMPRIMIR_MARBETE_INDIVIDUAL ( nIdePol, nIdeop, NULL, cIdeRep, NULL, nCantidadCopia);
    END IF;
    IF cTipoRep = 'MARF' THEN 
       --FR_IMPRIMIR_MARBETE_FLOTILLA ( nIdePol, nIdeop,cTipo,cIdeRep,cNombreImpresora,nCantidadCopia);
       null;
    END IF;
    IF cTipoRep = 'CANC' THEN
       return PR_APEX.IMPRIMIR_CANCELACION( nIdePol, nIdeop,NULL,cIdeRep,NULL,nCantidadCopia);
    END IF; 
    IF cTipoRep = 'PLAN' THEN
       return PR_APEX.IMPRIMIR_PLANILLA_RECLAMO(nIdePol, NULL, cIderep, NULL, nCantidadCopia);
    END IF; 
    IF cTipoRep = 'PAGO' THEN
       return PR_APEX.IMPRIMIR_CONDICION_PAGO(nIdePol, NULL, cIderep, NULL, nCantidadCopia);
    END IF;
  END IF; --cTipoPdcion != 'A'

  IF cTipoRep = 'FACT' THEN
     return PR_APEX.IMPRIMIR_FACTURA( nIdePol, nIdeop, NULL, cIdeRep, NULL, nCantidadCopia);
  END IF;

  IF cTipoRep IN ('CAFI','CAFD') THEN
	BEGIN
     -- Se modifica cursor para que sólo se tengan en cuenta las coberturas con plantillas previamente configuradas
	  FOR x IN (SELECT DISTINCT p.IdePol, c.NumCert, p.CodProd,
						cc.codplan, cc.revplan, cc.codramocert,
						p.CodMoneda, cc.codcobert, pf.TipoDoc, pf.NbreDoc
					FROM COBERT_CERT cc, CERTIFICADO c, POLIZA p, PLAN_FIANZAS pf
				   WHERE cc.NumCert     = c.NumCert
					 AND cc.IdePol      = c.IdePol
					 AND c.IdePol       = p.IdePol
					 AND cc.CodRamoCert = pf.CodRamo(+)
					 AND cc.CodPlan     = pf.CodPlan(+)
					 AND cc.RevPlan     = pf.RevPlan(+)
					 AND cc.CodCobert   = pf.CodCober(+)
					 AND p.IdePol       = nIdePol) LOOP
			BEGIN
			  IF X.TipoDoc = 'D' THEN
				 --Fr_Gen_Contrato (x.IdePol,x.NumCert,x.CodProd,x.CodPlan,x.RevPlan,x.CodRamoCert,x.CodMoneda,x.CodCobert,cTIPOREP);
                 null;
			  ELSE
                 --FR_IMPRIMIR_CARATULA_FIANZAS( nIdePol, nIdeop,cTipo,cIdeRep,cNombreImpresora,nCantidadCopia, X.NbreDoc, X.TipoDoc);
                 null;

			  END IF;   
			EXCEPTION
			  WHEN OTHERS THEN 
				   RAISE_APPLICATION_ERROR(-20100,'Error: '||SQLERRM);
			END;
	 END LOOP;
	END;
  END IF;

  BEGIN
  	-- seleccione el # de acuerdo desde la tabla de factura --
  	 SELECT DISTINCT NumAcuerdo
  	   INTO cNumAcuerdo
  	   FROM FACTURA
  	  WHERE IdeOp = nIdeop;
     IF cTipoRep = 'ACDO' THEN --condiciona si el tipo es ACDO, ACUERDO --
 	    return PR_APEX.IMPRIMIR_ACUERDO(cNumAcuerdo, NULL, cIdeRep, NULL, nCantidadCopia); 
     END IF;
  EXCEPTION 
     WHEN NO_DATA_FOUND THEN -- CUANDO NO ENCUENTRE DATOS --
          NULL;            
  END;

  IF cTipoRep = 'NOCR' THEN  -- Revisar con Efrain. Varias Ocurrencias.
    --FR_IMPRIMIR_NOTA_CREDITO( nIdePol, nIdeop,cTipo, cIdeRep, cNombreImpresora, nCantidadCopia);
    null;
  END IF;

  BEGIN
    SELECT fecinivig, numpol
      INTO dFecha_Desde, nNumPol
      FROM POLIZA 
     WHERE IdePol = nIdePol;
     IF cTipoRep = 'RESU' THEN 
        return PR_APEX.IMPRIMIR_SINIESTRALIDAD(cCodprod,nNumpol,dFecha_desde,sysdate,NULL,cIdeRep,
                                               NULL,nCantidadCopia);
     END IF;
  EXCEPTION 
     WHEN NO_DATA_FOUND THEN
          dFecha_Desde := null;
          nNumPol      := null;
  END;

end imprimir_reportes;

function imprimir_anexo (nIdePol   NUMBER  , nIdeop NUMBER,  
                         cReporte  VARCHAR2, nCantidadCopia NUMBER) return varchar2 IS
cCodAnexo ANEXO_POL.CodAnexo%TYPE; 
nIdeAnexo ANEXO_POL.IdeAnexo%TYPE;                        
begin
  BEGIN
	SELECT DISTINCT ap.CODANEXO 
	  INTO cCodAnexo
	  FROM ANEXO_POL ap, TEXTO_ANEXO_POL tap, POLIZA p
	 WHERE stsanexo     = 'ACT'
	   AND tap.IdeAnexo = ap.IdeAnexo
	   AND p.IdePol     = ap.IdePol
	   AND p.IdePol     = nIdePol
	   AND rownum       = 1;
   EXCEPTION
   	  WHEN NO_DATA_FOUND THEN
   	     Null;
   	  WHEN TOO_MANY_ROWS THEN
   	     Null;
   END;

   BEGIN
	 SELECT ap.IdeAnexo
	   INTO nIdeAnexo
	   FROM ANEXO_POL ap, TEXTO_ANEXO_POL tap, POLIZA p
	  WHERE stsanexo     = 'ACT'
	    AND tap.IdeAnexo = ap.IdeAnexo
	    AND p.IdePol     = ap.IdePol
	    AND p.IdePol     = nIdePol
	    AND rownum       = 1;
   EXCEPTION
   	  WHEN NO_DATA_FOUND THEN
   	     NULL;
   	  WHEN TOO_MANY_ROWS THEN
   	     Null;
   END;

   IF cCodAnexo IS NULL OR cCodAnexo = '9999' THEN
      BEGIN
	    SELECT ac.CodAnexo
	      INTO cCodAnexo
	      FROM ANEXO_CERT ac, TEXTO_ANEXO_CERT tac, POLIZA p
	     WHERE NUMOPER = nIdeOp
	       AND StsAnexo = 'ACT'
	       AND tac.IdeAnexo = ac.IdeAnexo
	       AND p.IdePol = ac.IdePol;
	  EXCEPTION
   	     WHEN NO_DATA_FOUND THEN
   	          cCodAnexo := NULL;
   	     WHEN TOO_MANY_ROWS THEN
   	          cCodAnexo := 'XXXXXX';
      END;   
   END IF;
   IF cCodAnexo IS NOT NULL THEN
      IF cCodAnexo != '9999' THEN
         return    pr_apex.apex_report_server
                || 'report='||cReporte
                || '&COPIES='||TO_CHAR(nCantidadCopia)
                || '&P_IDEOP='||TO_CHAR(nIdeop)
                || '&P_IDEANEXO='||TO_CHAR(nIdeAnexo)
                || '&P_POLIZA='||TO_CHAR(nIdepol);
       ELSE
            null;
       END IF;
   END IF;

end imprimir_anexo;

function gen_contrato   (nIdePol  NUMBER  ,nNumCert NUMBER  ,cCodProd   VARCHAR2,cCodPlan VARCHAR2,
                         cRevPlan VARCHAR2,cCodRamo VARCHAR2,cCodMoneda VARCHAR2,cCodCobert VARCHAR2,
                         cTipoRep1 VARCHAR2) return varchar2 IS
 CURSOR CUR_REGISTRO(PCodCli CLIENTE.CodCli%Type) IS
 SELECT CircunsJudicial,FecMod,Tomo,Folio1,Folio2,Numero,Tipo,
        PR.BUSCA_LVAL('TIPOREGM',Tipo) TipoReg
   FROM REG_MERC_CLIENTE
  WHERE CodCli = PCodCli;
 	cnit_ci         tercero.nit_ci%TYPE;
	Sw          	       BOOLEAN;
	dfecha      	       DATE           := NULL;
    dFechaContrato         DATE   		   := NULL;	
    dFecHoraCambio	       DATE  		   := NULL;  
    cContrato              VARCHAR2(2000) := NULL;	  --27/03/2009 Fernando Bautista
	nNumJunta              NUMBER         := NULL;  
    nTasa_Cambio           NUMBER;	
	ndummy                 NUMBER;
	nSumaAfian             NUMBER (14,2)  := NULL;	
	nMontoDolar            NUMBER (20,2);		
	nsumaAseg   	       NUMBER (20,2);
	nsumaAsegMoneda        NUMBER (20,2);
	nTasaCambio            NUMBER (11,6);
	cFeciniValid           VARCHAR2(2000) := NULL;	
	cDescMoneda            VARCHAR2(2000) := NULL;	
	cAfianzado  	       VARCHAR2(2000) := NULL;
	CAcreedor   	       VARCHAR2(2000) := NULL;
	Cpoliza     	       VARCHAR2(2000) := NULL;
	UbicPlant   	       VARCHAR2(2000) := NULL;
	UbicDoc     	       VARCHAR2(2000) := NULL;
	dFechaEmi              VARCHAR2(2000) := NULL;
	cFechaIni              VARCHAR2(2000) := NULL;		
	cFechaFin    	       VARCHAR2(2000) := NULL;
	cFechaEmi   	       VARCHAR2(2000) := NULL;
	CdescObra   	       VARCHAR2(2000) := NULL;
	vObra   	           VARCHAR2(2000) := NULL;
	CdescObra1   	       VARCHAR2(2000) := NULL;
	CdescObra2   	       VARCHAR2(2000) := NULL;
	CdescObra3   	       VARCHAR2(2000) := NULL;
	CdescObra4   	       VARCHAR2(2000) := NULL;
	CdescObra5   	       VARCHAR2(2000) := NULL;
	CdescObraDef	       VARCHAR2(4000) := NULL;
	cDirecObra   	       VARCHAR2(2000) := NULL; -- 03/03/2009 Fernando Bautista
	cCiudadObra   	       VARCHAR2(1000) := NULL; -- 03/03/2009 Fernando Bautista
	cEquivalenteA  	       VARCHAR2(1000) := NULL; -- 11/08/2009 Fernando Bautista
	cDescGarantia  	       VARCHAR2(1000) := NULL; -- 11/08/2009 Fernando Bautista
    cDocMayorJerarquia     VARCHAR2(1000) := NULL; -- 11/08/2009 Fernando Bautista  
	Documento   	       VARCHAR2(1000) := NULL;
	cNombFirmante          VARCHAR2(1000) := NULL;	
	cNombplant   	       VARCHAR2(2000) := NULL;
    cNombDoc   		       VARCHAR2(2000) := NULL;
	cCedula                VARCHAR2(1000) := NULL;
	cCantidad   	       VARCHAR2(1000) := NULL;
	cFechaContLetra        VARCHAR2(1000) := NULL;
	cDescCobert            VARCHAR2(2000) := NULL;
	cCodCargo              VARCHAR2(2000) := NULL; 
	CMoneda                VARCHAR2(2000) := NULL;
	cCobert                VARCHAR2(2000) := NULL;
	cEstado                VARCHAR2(2000) := NULL;
	cCiudad                VARCHAR2(2000) := NULL;
	cCodCli                VARCHAR2(2000) := NULL;
	cDescCargo             VARCHAR2(2000) := NULL;
	cPoder			       VARCHAR2(2000) := NULL;
    cPersonaFirmaContrato  VARCHAR2(2000) := NULL;
	cNOMBRE                VARCHAR2(2000) := NULL;
    cMontoDolarLetra       VARCHAR2(2000) := NULL;
	cCodMonedaLocal        POLIZA.CodMoneda%TYPE := NULL;
    cId                    VARCHAR2(2000)  := NULL;
    cDirAfian              VARCHAR2(2000) := NULL;  
	cTelAfian              VARCHAR2(2000) := NULL; 
	cEmail                 VARCHAR2(2000) := NULL; 
	cAnexClauPol           VARCHAR2(4000) := NULL; 
    cDirBenef              VARCHAR2(2000) := NULL;		
    cTelBenef              VARCHAR2(2000) := NULL;		
    nMontoContrato	       NUMBER (22,2)  := NULL;		
    nPrima                 NUMBER (22,2)  := NULL;		
    cFormaPago    	       VARCHAR2(2000) := NULL;		  
    cTipoPago              VARCHAR2(2000) := NULL;	
    cCauLiteral            VARCHAR2(2000) := NULL;		
    ccargo                 VARCHAR2(2000) := NULL;  	  
    cIntermediario         VARCHAR2(2000) := NULL;
    cCodInter              VARCHAR2(2000) := NULL;
    vnrogarlin             VARCHAR2(1000) := '';
    nTasa                  VARCHAR2(2000) := '0';
    nTasa_Literal          VARCHAR2(2000) := NULL;
    cCoreo                 VARCHAR2(2000) := NULL;
    vContrat_Contrato_Orig VARCHAR2(14);                         
begin
  PR_VINISUSC.CARGAR;
  cCodMonedaLocal := PR_VINISUSC.CODIGO_MONEDA;

  BEGIN
    SELECT MAX(FecHoraCambio)
      INTO dFecHoraCambio
      FROM TASA_CAMBIO
     WHERE CodMoneda = 'DL';
  EXCEPTION
	 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
          dFecHoraCambio := SYSDATE;
  END;

  BEGIN
    SELECT PR.TASA_CAMBIO('US',(dFecHoraCambio))
      INTO nTasa_Cambio
      FROM Dual;
  EXCEPTION
	  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
		   nTasa_Cambio := 1;
  END;

  IF nIdepol IS NOT NULL AND nNumCert IS NOT NULL THEN
    BEGIN 
 	   SELECT  P.CodPol||'-'||TO_CHAR(o.codofi)||'-'||TO_CHAR(P.NumPol)||'-'||to_char(p.numren),
 		       REPLACE(REPLACE(REPLACE(SUBSTR ( T.NomTer || ' ' ||  T.ApeTer || ' ' || T.apellido_materno,1,250) ,'"',''),CHR(13),' ') ,'  ',' ')  Afianzado,
 			   --SUBSTR ( T.NomTer || ' ' ||  T.ApeTer,1,250) Afianzado,
			    T.NumId  NumId,T.nit_ci  cnit_ci,T.Direc  DirAfian,
			    DECODE(T.Telef1,NULL,'',T.Telef1)||DECODE(T.Telef2,NULL,'',' - '||T.Telef2)||DECODE(T.Telef3,NULL,'',' - '||T.Telef3) TelAfian,
			    T.Email  Email,SUBSTR (TA.NomTer || ' ' || TA.ApeTer,1,250) Acreedor,TA.Direc  DirBenef,TA.Telef1 TelBenef,P.CodMoneda,nvl(D.SumaAfianzada,0),
			    TO_CHAR(P.FecIniVig,'DD/MM/YYYY'),TO_CHAR(P.FecFinVig,'DD/MM/YYYY'),TO_CHAR(P.Fecemi,'DD/MM/YYYY'),P.FecEmi,  
			    D.ActaJuntaDirectiva,D.DescObra,CER.Direc DirecObra,D.NumContrato,nvl(D.MontoContrato,0),
			    PR.BUSCA_LVAL('FORMPAGO',P.CodFormPago) FormaPago,CO.CodCobert,PP.DescPlanProd,nvl(CO.SumaAseg,0),nvl(CO.SumaAsegmoneda,0),
			    TO_CHAR(CO.FecIniValid,'DD/MM/YYYY'),P.CodCli, D.FechaInicio ,PR_REPORTES.REL_OFICINAS(substr(O.CodOfi,1,4)||'01'),substr(D.Mercancias,1,200),
			    CONTRAT_CONTRATO_ORIG,IC.CARGO
		 INTO   cPoliza,cAfianzado,cId,cnit_ci,cDirAfian,cTelAfian,cEmail,cAcreedor,cDirBenef,cTelBenef,cMoneda,nSumaAfian,cFechaIni,cFechaFin,cFechaEmi,
			    dFecha,nNumJunta,cDescObra,cDirecObra,cContrato,nMontoContrato,cFormaPago,cCobert,cDescCobert,nSumaAseg,nSumaAsegMoneda,cFecIniValid, 
			    cCodCli,dFechaContrato,cCiudad,cDocMayorJerarquia ,vCONTRAT_CONTRATO_ORIG,CCARGO
		 FROM POLIZA P, CERTIFICADO CER, CERT_RAMO CR,COBERT_CERT CO ,DATOS_PARTICULARES_FIANZAS D,PLAN_PROD PP, CLIENTE C,TERCERO T,
			  DATOS_FIANZA_ASEGURADOS DF, ACREEDOR A,TERCERO TA,OFICINA O, CLI_INFORM_COMPL IC
	    WHERE P.IdePol      = CER.IdePol
          AND   CER.IdePol      = CR.IdePol
          AND   CER.NumCert     = CR.NumCert
          AND   CR.IdePol       = CO.IdePol 
          AND   CR.NumCert      = CO.NumCert
          AND   CR.CodRamoCert  = CO.CodRamoCert
          AND   CR.CodPlan      = CO.CodPlan
          AND   CR.RevPlan      = CO.RevPlan
          AND   CER.IdePol      = D.IdePol
          AND   CER.NumCert     = D.NumCert
          AND   P.CODCLI        = IC.CODCLI (+)
          AND   P.CodProd       = PP.CodProd
          AND   CR.CodPlan      = PP.CodPlan
          AND   CR.RevPlan      = PP.RevPlan
  	      AND   P.CodCli        = C.CodCli
		  AND   C.TipoId        = T.TipoId
		  AND   C.NumId         = T.NumId
		  AND   C.DvId          = T.DvId
          AND   C.SerieId       = T.SerieId
		  AND   D.CodAfianzado  = DF.CodAfianzado
          AND   D.IdePol        = DF.IdePol
          AND   D.NumCert       = DF.NumCert
		  AND   DF.CodAsegurado = A.CodAcreedor 
          AND   A.TipoId        = TA.TipoId (+)
		  AND   A.NumId         = TA.NumId (+)
		  AND   A.DvId          = TA.DvId (+)
          AND   A.SerieId       = TA.SerieId (+)
          AND   P.CodOfiEmi     = O.CodOfi     
	      AND   CO.STSCOBERT    = 'ACT'
		  AND   P.IdePol        = nIdePol
		  AND   D.NumCert       = nNumCert
		  AND   CO.CODCOBERT    = nvl(cCodCobert,co.codcobert);
	EXCEPTION
		  WHEN NO_DATA_FOUND THEN   
		    BEGIN
			  SELECT  P.CodPol||'-'||TO_CHAR(o.codofi)||'-'||TO_CHAR(P.NumPol),
                      SUBSTR ( T.NomTer || ' ' ||  T.ApeTer || ' ' || T.apellido_materno,1,250) Afianzado,
                      T.TipoId||' '||T.NumId  NumId,
                      T.nit_ci,  
                      T.Direc  DirAfian,  -- -
                      DECODE(T.Telef1,NULL,'',T.Telef1)||DECODE(T.Telef2,NULL,'',' - '||T.Telef2)||DECODE(T.Telef3,NULL,'',' - '||T.Telef3) TelAfian,-- -
                      T.Email  Email,  NULL Acreedor, NULL  DirBenef, NULL  TelBenef, P.CodMoneda,
                      D.SumaAfianzada, TO_CHAR(P.FecIniVig,'DD/MM/YYYY'), TO_CHAR(P.FecFinVig,'DD/MM/YYYY'),
                      TO_CHAR(P.Fecemi,'DD/MM/YYYY'), P.FecEmi, D.ActaJuntaDirectiva,
                      D.DescObra, CER.Direc DirecObra, D.NumContrato, D.MontoContrato,   -- -
                      PR.BUSCA_LVAL('FORMPAGO',P.CodFormPago) FormaPago, CO.CodCobert, PP.DescPlanProd,
                      CO.SumaAseg, CO.SumaAsegmoneda, TO_CHAR(CO.FecIniValid,'DD/MM/YYYY'),
                      P.CodCli, D.FechaInicio, PR_REPORTES.REL_OFICINAS(O.CodOfi), D.Mercancias,
                      CONTRAT_CONTRATO_ORIG
               INTO cPoliza, cAfianzado, cId, cnit_ci, cDirAfian, cTelAfian, cEmail, cAcreedor,
					cDirBenef, cTelBenef, cMoneda, nSumaAfian, cFechaIni, cFechaFin, cFechaEmi,
			        dFecha, nNumJunta, cDescObra, cDirecObra, cContrato, nMontoContrato, cFormaPago,
			        cCobert, cDescCobert, nSumaAseg, nSumaAsegMoneda, cFecIniValid, cCodCli, dFechaContrato,
			        cCiudad, cDocMayorJerarquia, vCONTRAT_CONTRATO_ORIG
               FROM POLIZA P, CERTIFICADO CER, CERT_RAMO CR,COBERT_CERT CO , DATOS_PARTICULARES_FIANZAS D,
                    PLAN_PROD PP, CLIENTE C,TERCERO T, DATOS_FIANZA_ASEGURADOS DF, OFICINA O
              WHERE P.IdePol        = CER.IdePol
                AND CER.IdePol      = CR.IdePol
                AND CER.NumCert     = CR.NumCert
                AND CR.IdePol       = CO.IdePol 
                AND CR.NumCert      = CO.NumCert
                AND CR.CodRamoCert  = CO.CodRamoCert
                AND CR.CodPlan      = CO.CodPlan
                AND CR.RevPlan      = CO.RevPlan
                AND CER.IdePol      = D.IdePol
                AND CER.NumCert     = D.NumCert
                AND P.CodProd       = PP.CodProd
                AND CR.CodPlan      = PP.CodPlan
                AND CR.RevPlan      = PP.RevPlan
  	            AND P.CodCli        = C.CodCli
		        AND C.TipoId        = T.TipoId
		        AND C.NumId         = T.NumId
		        AND C.DvId          = T.DvId
                AND C.SerieId       = T.SerieId
		        AND D.CodAfianzado  = DF.CodAfianzado(+)
                AND D.IdePol        = DF.IdePol(+)
                AND D.NumCert       = DF.NumCert(+)
                AND P.CodOfiEmi     = O.CodOfi     
	            AND CO.STSCOBERT    = 'ACT'
			    AND P.IdePol        = nIdePol
			    AND D.NumCert       = nNumCert
		        AND CO.CODCOBERT    = nvl(cCodCobert,co.codcobert);
		    EXCEPTION 
               WHEN OTHERS THEN 
                    RAISE_APPLICATION_ERROR(-20100,'No Se puede Generar esta Fianza');
		    END;
    END;

    BEGIN
      SELECT NomPlanFracc 
        INTO cTipoPago
        FROM PLAN_FRACC
       WHERE IdePlanFracc IN ( SELECT pf.IdePlanFracc 
                                 FROM PLAN_FRACC_POL pf 
                                WHERE pf.IdePol = nIdePol
                                  AND pf.NumOper IS null );
    EXCEPTION 
       WHEN OTHERS THEN 
            cTipoPago := null;
    END;

    cDescMoneda := PR.BUSCA_LVAL('TIPOMON',cMoneda);
	dFechaEmi   := to_char(to_date(cFechaemi,'DD/MM/RRRR'),'DD')||' de '||enletra(to_NUMBER(To_char(to_date(cFechaEmi,'DD/MM/RRRR'),'MM')))||' de '||To_char(to_date(cFechaEmi,'DD/MM/RRRR'),'RRRR');

    -- En la Web, no se incorpora la plantilla con extensión DOC.  Esta parte no se incorporo.

    BEGIN
	  SELECT e.DescEstado
	    INTO cEstado
        FROM DIREC_COBROPOLIZA DC, ESTADO E, CIUDAD C
       WHERE IdePol = nIdePol
         AND dc.CodPais   = e.CodPais
         AND dc.CodEstado = e.CodEstado
         AND dc.CodPais   = c.CodPais
         AND dc.CodEstado = c.CodEstado
         AND dc.CodCiudad = c.CodCiudad;
	EXCEPTION
	   WHEN NO_DATA_FOUND THEN
			cEstado := NULL;
	   WHEN TOO_MANY_ROWS THEN
			cEstado := NULL;
	END;

    -- Busco los Datos del Firmante --
	BEGIN
	  SELECT TipoId||'-'||NumId Cedula,
			 lTrim(rTrim(Nombre))||' '||lTrim(rTrim(Apellido)) Nombre, 
			 CodCargo, Poder
		INTO cCedula, cNombFirmante, cCodCargo, cPoder
		FROM FIRMANTES_FIANZAS
	   WHERE CodCargo = cPersonaFirmaContrato;	
	EXCEPTION
	   WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
			cNombFirmante := NULL;
			cCodCargo     := NULL;
			cCedula       := NULL;
	END;

    cDescCargo        := PR.BUSCA_LVAL('CARGOS',cCodCargo);
  	nMontoDolar       := NsumaAfian / Nvl(nTasa_Cambio,1);
  	cMontoDolarLetra  := PR_MONTO_ESCRITO_FIANZA.Mto_Escrito(nMontoDolar,'DL');  	
	nPrima            := NVL(PR_CARAT_POLIZA.PRIMA_BRUTA_CERTIFICADO(nIdePol,nNumCert) + PR_CARAT_POLIZA.porcprima(nIdePol,nNumCert),0);

    FOR X IN      ( SELECT AC.CodAnexo CodAnexClau, A.DescAnexo DescAnexClau, 'A' TipoAnexClau
		   			  FROM ANEXO_CERT AC, CERT_RAMO CR, ANEXO A, CERTIFICADO C, POLIZA P
			  		 WHERE AC.IdePol       = CR.IdePol
					   AND AC.NumCert      = CR.NumCert
					   AND AC.CodRamoCert  = CR.CodRamoCert
					   AND AC.CodAnexo     = A.CodAnexo
					   AND CR.IdePol       = C.IdePol
					   AND CR.NumCert      = C.NumCert
					   AND C.IdePol        = P.IdePol
					   AND P.IdePol        = nIdePol
					   AND CR.NumCert      = nNumCert
					 UNION
					SELECT CLC.CodClau CodAnexClau, CLA.DescClau DescAnexClau, 'C' TipoAnexClau
					  FROM CLAU_CERT CLC, CERT_RAMO CR, CERTIFICADO C, CLAUSULA CLA, POLIZA P
					 WHERE CLA.CodClau     = CLC.CodClau
					   AND CLC.IdePol      = CR.IdePol
					   AND CLC.NumCert     = CR.NumCert
					   AND CLC.CodRamoCert = CR.CodRamoCert
					   AND CR.IdePol       = C.IdePol
					   AND CR.NumCert      = C.NumCert
					   AND CR.IdePol       = P.IdePol
					   AND P.IdePol        = nIdePol
					   AND CR.NumCert      = nNumCert
				  ORDER BY 3, 1 ) LOOP
             cAnexClauPol := cAnexClauPol ||'   '||x.DescAnexClau|| chr(10)|| chr(13);                      
    END LOOP;

    BEGIN
	  SELECT VE.DescValEst
		INTO cCiudadObra
		FROM EST_CERT EC, VAL_EST VE
       WHERE VE.CodEst  = EC.CodEst
         AND VE.ValEst  = EC.ValEst
		 AND EC.IdePol  = nIdePol
		 AND EC.NumCert = nNumCert
         AND EC.CodEst  = 'UBIC';
    EXCEPTION 
       WHEN OTHERS THEN
	      cCiudadObra := ' ';
    END;

    BEGIN
	  SELECT VE.DescValEst
	    INTO cEquivalenteA
		FROM EST_CERT EC, VAL_EST VE
       WHERE VE.CodEst  = EC.CodEst
         AND VE.ValEst  = EC.ValEst
		 AND EC.IdePol  = nIdePol
		 AND EC.NumCert = nNumCert
         AND EC.CodEst  = 'EQUIV';
    EXCEPTION 	
       WHEN OTHERS THEN
	        cEquivalenteA := ' ';
    END;
    cEquivalenteA := NVL(cEquivalenteA,'.');

    BEGIN
	  SELECT LV.Descrip
	    INTO cDescGarantia
        FROM CONTRAGARANTE CG, LVAL LV
       WHERE LV.CodLval = CG.TipoGarantia
		 AND CG.NumCert = nNumCert
		 AND CG.IdePol  = nIdePol;
    EXCEPTION  
       WHEN NO_DATA_FOUND THEN
	        cDescGarantia := ' ';
	   WHEN TOO_MANY_ROWS THEN
	        cDescGarantia := ' ';
    END; 

    IF  cCodProd = 'TIC'  THEN
    	PR.JUSTIFICARTEXTO(cDescObra,240);
        FOR X IN (SELECT Orden, Texto FROM MULTILINEA	ORDER BY 1) LOOP
             IF X.Texto = CHR(10) OR X.Texto=CHR(13) THEN
                vobra := CHR(10)||CHR(13)||CHR(10)||CHR(13)||vobra;
             ELSE
                vobra := X.Texto||vobra;
             END IF;
        END LOOP;
        /*		    		
        pl_id := Create_Parameter_List('tmpdata'); 
        Add_Parameter(pl_id,'DESTYPE'      ,TEXT_PARAMETER,'PREVIEW'); 
        Add_Parameter(pl_id,'PARAMFORM'    ,TEXT_PARAMETER,'NO'); 
        
        Add_Parameter(pl_id,'POLIZA'        ,TEXT_PARAMETER,cPoliza); 
        Add_Parameter(pl_id,'AFIANZADO'     ,TEXT_PARAMETER,REPLACE(cAfianzado,'"','')); 
        Add_Parameter(pl_id,'CODCLI'        ,TEXT_PARAMETER,cCodCli);
        Add_Parameter(pl_id,'DIRAFIAN'      ,TEXT_PARAMETER,cDirAfian);
        Add_Parameter(pl_id,'ACREEDOR'      ,TEXT_PARAMETER,cAcreedor);
        Add_Parameter(pl_id,'MONEDALARGO'   ,TEXT_PARAMETER,cDESCMONEDA);
        Add_Parameter(pl_id,'OBRA'          ,TEXT_PARAMETER,vObra);
        Add_Parameter(pl_id,'FECHAINI'      ,TEXT_PARAMETER,cFechaIni);
        Add_Parameter(pl_id,'FECHAFIN'      ,TEXT_PARAMETER,cfechafin);
        Add_Parameter(pl_id,'CODMONE'       ,TEXT_PARAMETER,Cmoneda);
        Add_Parameter(pl_id,'IDENTIFICACION',TEXT_PARAMETER,cNIT_CI);
        Add_Parameter(pl_id,'SUMAAFIANZADA' ,TEXT_PARAMETER,to_char(nSumaAfian,'999,999,999.99'));
        Add_Parameter(pl_id,'MPRIMA'        ,TEXT_PARAMETER,nPrima);
        Add_Parameter(pl_id,'FECHAEMI'      ,TEXT_PARAMETER,rTrim(lTrim(initcap(cCiudad)||', '||dFechaEmi)));  
        Add_Parameter(pl_id,'TIPODEPAGO'    ,TEXT_PARAMETER,cTipoPago);   
        Add_Parameter(pl_id,'ANEXCLAUPOL'   ,TEXT_PARAMETER,cAnexClauPol);    
        Add_Parameter(pl_id,'P_PRODUCTO'    ,TEXT_PARAMETER,cCodProd);
        Add_Parameter(pl_id,'P_IDEPOL'    ,TEXT_PARAMETER,nIdePol);
        */
        IF cTIPOREP1='CAFI' THEN
           --rp2rro.rp2rro_run_product(reports,'CONPATIC',ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam);
           -- Invocar Reporte de Apex
           null;
        ELSE -- CAFD
        	 --Add_Parameter(pl_id,'P_IDEPOL'    ,TEXT_PARAMETER,nIdePol);
        	 --rp2rro.rp2rro_run_product(reports,'CONPATIC_DI',ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam);
             -- Invocar Reporte de Apex
             null;
        END IF;
        --Destroy_Parameter_List( pl_id );
    ELSIF  cCodProd = 'SDP'  THEN
        PR.JUSTIFICARTEXTO(cDescObra,240);
        FOR X IN (SELECT Orden, Texto FROM MULTILINEA	ORDER BY 1) LOOP
             IF X.Texto = CHR(10) OR X.Texto=CHR(13) THEN
                vobra := CHR(10)||CHR(13)||CHR(10)||CHR(13)||vobra;
             ELSE
                vobra := X.Texto||vobra;
             END IF;
        END LOOP;
        			    		
        BEGIN 
          SELECT initcap(lower(TRIM(pr_numero.letra(nSumaAfian)))) || ' 00/100, ' || decode(Cmoneda,'BS','Bolivianos','UF','Unidad de Fomento de Vivienda.','US','Dolares') 
            INTO cCauLiteral 
            FROM dual;
        END;
        /*
        pl_id := Create_Parameter_List('tmpdata'); 
        Add_Parameter(pl_id,'DESTYPE'        ,TEXT_PARAMETER,'PREVIEW'); 
        Add_Parameter(pl_id,'PARAMFORM'      ,TEXT_PARAMETER,'NO'); 
        Add_Parameter(pl_id,'AFIANZADO'      ,TEXT_PARAMETER,REPLACE(cAfianzado,'"',''));   
        Add_Parameter(pl_id,'BENEFICIARIO'   ,TEXT_PARAMETER,cAcreedor);   
        Add_Parameter(pl_id,'CIUDAD'         ,TEXT_PARAMETER,initcap(cCiudad));     
        Add_Parameter(pl_id,'CODCLI'         ,TEXT_PARAMETER,cCodCli); 
        Add_Parameter(pl_id,'CODMONE'        ,TEXT_PARAMETER,Cmoneda);
        Add_Parameter(pl_id,'CONTRAGARANTIAS',TEXT_PARAMETER,PR_REPORTES.DESC_MODALIDAD(cCodProd,'COD')||'/'||cCodProd||'/'||NRO_GARANTIA_LINEA(nIdePol));    
        Add_Parameter(pl_id,'CORREO'         ,TEXT_PARAMETER,CEMAIL);   
        Add_Parameter(pl_id,'DIRAFIAN'       ,TEXT_PARAMETER,cDirAfian);   
        Add_Parameter(pl_id,'DIRECCION'      ,TEXT_PARAMETER,cDIRBENEF);          
        Add_Parameter(pl_id,'FECHAEMI'       ,TEXT_PARAMETER,rTrim(lTrim(initcap(cCiudad)||', '||dFechaEmi))); 
        Add_Parameter(pl_id,'FECHAFIN'       ,TEXT_PARAMETER,cfechafin);
        Add_Parameter(pl_id,'FECHAINI'       ,TEXT_PARAMETER,cFechaIni);
        Add_Parameter(pl_id,'MPRIMA'         ,TEXT_PARAMETER,TO_CHAR(nPrima,'999,999,999.99')); 
        Add_Parameter(pl_id,'NIT'            ,TEXT_PARAMETER,cNIT_CI);                  
        Add_Parameter(pl_id,'OBRA'           ,TEXT_PARAMETER,vObra);   
        Add_Parameter(pl_id,'POLIZA'         ,TEXT_PARAMETER,cPoliza); 
        Add_Parameter(pl_id,'P_PRODUCTO'     ,TEXT_PARAMETER,cCodProd);     
        Add_Parameter(pl_id,'SUMAAFIANZADA'  ,TEXT_PARAMETER,'SUMA GARANTIZADA(VALOR CAUCIONADO): La suma garantizada ( valor caucionado ) por la presente Póliza de Seguro de Caución es '||Cmoneda||'.-'||TRIM(to_char(nSumaAfian,'999,999,999.99'))||' ('||cCauLiteral||')' );
        Add_Parameter(pl_id,'TASA'           ,TEXT_PARAMETER,nTasa);    
        Add_Parameter(pl_id,'TASA_LITERAL'   ,TEXT_PARAMETER,'Equivalente al: '||cEquivalenteA);             
        Add_Parameter(pl_id,'TELEFONO'       ,TEXT_PARAMETER,ctelAfian);       
        rp2rro.rp2rro_run_product(reports,'CONPASDP',ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam);
        Destroy_Parameter_List( pl_id );
        */
    ELSIF  cCodProd = 'PCC'  THEN
    	PR.JUSTIFICARTEXTO(cDescObra,240);
        FOR X IN (SELECT Orden, Texto FROM MULTILINEA	ORDER BY 1) LOOP
             IF X.Texto = CHR(10) OR X.Texto=CHR(13) THEN
                vobra := CHR(10)||CHR(13)||CHR(10)||CHR(13)||vobra;
             ELSE
                vobra := X.Texto||vobra;
             END IF;
        END LOOP;
        
        BEGIN
          SELECT DISTINCT CODINTER 
            INTO cCODINTER
        	FROM PART_INTER_POL 
           WHERE IDEPOL = nIdepol;
        EXCEPTION 
           WHEN OTHERS THEN 
                NULL;
        END;

       	SELECT PR.Nombre_Intermediario(ccodinter,200) 
          INTO CINTERMEDIARIO	
          FROM SYS.DUAL;
        /*			    		
        pl_id := Create_Parameter_List('tmpdata'); 
        Add_Parameter(pl_id,'DESTYPE'      ,TEXT_PARAMETER,'PREVIEW'); 
        Add_Parameter(pl_id,'PARAMFORM'    ,TEXT_PARAMETER,'NO'); 
        
        Add_Parameter(pl_id,'BENEFICIARIO'  ,TEXT_PARAMETER,cAcreedor);  
        Add_Parameter(pl_id,'AFIANZADO'     ,TEXT_PARAMETER,REPLACE(cAfianzado,'"',''));
        Add_Parameter(pl_id,'ANEXCLAUPOL'   ,TEXT_PARAMETER,cAnexClauPol);     
        Add_Parameter(pl_id,'CIUDAD'        ,TEXT_PARAMETER,initcap(cCiudad));     
        Add_Parameter(pl_id,'CODCLI'        ,TEXT_PARAMETER,cCodCli); 
        Add_Parameter(pl_id,'CODMONE'       ,TEXT_PARAMETER,Cmoneda);  
        Add_Parameter(pl_id,'DIRAFIAN'      ,TEXT_PARAMETER,cDirAfian);   
        Add_Parameter(pl_id,'FECHAEMI'      ,TEXT_PARAMETER,rTrim(lTrim(initcap(cCiudad)||', '||dFechaEmi))); 
        Add_Parameter(pl_id,'FECHAFIN'      ,TEXT_PARAMETER,cfechafin);
        Add_Parameter(pl_id,'FECHAINI'      ,TEXT_PARAMETER,cFechaIni);
        Add_Parameter(pl_id,'IDENTIFICACION',TEXT_PARAMETER,cNIT_CI);      
        Add_Parameter(pl_id,'MONEDALARGO'   ,TEXT_PARAMETER,cDESCMONEDA);      
        Add_Parameter(pl_id,'MPRIMA'        ,TEXT_PARAMETER,nPrima);       
        Add_Parameter(pl_id,'OBRA'          ,TEXT_PARAMETER,vObra);        
        Add_Parameter(pl_id,'POLIZA'        ,TEXT_PARAMETER,cPoliza);   
        Add_Parameter(pl_id,'P_PRODUCTO'    ,TEXT_PARAMETER,'PCC');
        Add_Parameter(pl_id,'SUMAAFIANZADA' ,TEXT_PARAMETER,to_char(nSumaAfian,'999,999,999.99'));
        Add_Parameter(pl_id,'TIPODEPAGO'    ,TEXT_PARAMETER,cTipoPago);  
        Add_Parameter(pl_id,'CARGO'         ,TEXT_PARAMETER,cCARGO);   
        Add_Parameter(pl_id,'INTERMEDIARIO' ,TEXT_PARAMETER,cIntermediario); 
        Add_Parameter(pl_id,'DIRECCION'     ,TEXT_PARAMETER,cDIRBENEF);     -- DIRECCION DEL BENEFICIARIO
   
        IF cTIPOREP1 = 'RECI' THEN
           rp2rro.rp2rro_run_product(reports,'CONPAPCC',ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam);
        ELSE
        	 Add_Parameter(pl_id,'P_IDEPOL'    ,TEXT_PARAMETER,nIdePol);
        	 rp2rro.rp2rro_run_product(reports,'CONPAPCC',ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam);
        END IF;
        
        Destroy_Parameter_List( pl_id );
        */
    ELSIF  cCodProd = 'SCC'  THEN
    	PR.JUSTIFICARTEXTO(cDescObra,240);
        FOR X IN (SELECT Orden, Texto FROM MULTILINEA	ORDER BY 1) LOOP
             IF X.Texto = CHR(10) OR X.Texto=CHR(13) THEN
                vobra := CHR(10)||CHR(13)||CHR(10)||CHR(13)||vobra;
             ELSE
                vobra := X.Texto||vobra;
             END IF;
        END LOOP;
        
        BEGIN
          SELECT DISTINCT CODINTER INTO cCODINTER
        	FROM PART_INTER_POL 
           WHERE IDEPOL = nIdepol;
        EXCEPTION 
           WHEN OTHERS THEN 
                NULL;
        END;
       	
        SELECT PR.Nombre_Intermediario(ccodinter,200) 
          INTO CINTERMEDIARIO	
          FROM SYS.DUAL;   
	    /*		
        pl_id := Create_Parameter_List('tmpdata'); 
        Add_Parameter(pl_id,'DESTYPE'      ,TEXT_PARAMETER,'PREVIEW'); 
        Add_Parameter(pl_id,'PARAMFORM'    ,TEXT_PARAMETER,'NO'); 
        
        Add_Parameter(pl_id,'ACREEDOR'      ,TEXT_PARAMETER,cAcreedor);  
        Add_Parameter(pl_id,'AFIANZADO'     ,TEXT_PARAMETER,REPLACE(cAfianzado,'"',''));
        Add_Parameter(pl_id,'ANEXCLAUPOL'   ,TEXT_PARAMETER,cAnexClauPol);
        Add_Parameter(pl_id,'BENEFICIARIO'  ,TEXT_PARAMETER,cAcreedor);  
        Add_Parameter(pl_id,'CARGO'         ,TEXT_PARAMETER,cCARGO);  
        Add_Parameter(pl_id,'CIUDAD'        ,TEXT_PARAMETER,initcap(cCiudad)); 
        Add_Parameter(pl_id,'CODCLI'        ,TEXT_PARAMETER,cCodCli);       
        Add_Parameter(pl_id,'CODMONE'       ,TEXT_PARAMETER,Cmoneda); 
        Add_Parameter(pl_id,'DIRAFIAN'      ,TEXT_PARAMETER,cDirAfian);               
        Add_Parameter(pl_id,'DIRECCION'     ,TEXT_PARAMETER,cDIRBENEF);     
        Add_Parameter(pl_id,'FECHAEMI'      ,TEXT_PARAMETER,rTrim(lTrim(initcap(cCiudad)||', '||dFechaEmi)));     
        Add_Parameter(pl_id,'FECHAFIN'      ,TEXT_PARAMETER,cfechafin);       
        Add_Parameter(pl_id,'FECHAINI'      ,TEXT_PARAMETER,cFechaIni);
        Add_Parameter(pl_id,'IDENTIFICACION',TEXT_PARAMETER,cNIT_CI);   
        Add_Parameter(pl_id,'INTERMEDIARIO' ,TEXT_PARAMETER,cIntermediario); 
        Add_Parameter(pl_id,'MONEDALARGO'   ,TEXT_PARAMETER,cDESCMONEDA);      
        Add_Parameter(pl_id,'MPRIMA'        ,TEXT_PARAMETER,nPrima);   
        Add_Parameter(pl_id,'OBRA'          ,TEXT_PARAMETER,vObra); 
        Add_Parameter(pl_id,'POLIZA'        ,TEXT_PARAMETER,cPoliza);
        Add_Parameter(pl_id,'P_PRODUCTO'    ,TEXT_PARAMETER,'SCC');  
        Add_Parameter(pl_id,'SUMAAFIANZADA' ,TEXT_PARAMETER,to_char(nSumaAfian,'999,999,999.99'));   
        Add_Parameter(pl_id,'TIPODEPAGO'    ,TEXT_PARAMETER,cTipoPago);  
        Add_Parameter(pl_id,'CONTRAGARANTIAS',TEXT_PARAMETER,PR_REPORTES.DESC_MODALIDAD(cCodProd,'COD')||'/'||cCodProd||'/'||NRO_GARANTIA_LINEA(nIdePol));  
            
        p_registrar_error('CREA_SCC', 'FORMA', 'IMPEREPO', SYSDATE, 'Error en llamada a report :'||'SCC');
  
  
        rp2rro.rp2rro_run_product(reports,'CONPASCC',ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam);
        Destroy_Parameter_List( pl_id );
        */
    ELSIF  cCodProd = 'BET' THEN
        NULL;
        /*
        pl_id := Create_Parameter_List('tmpdata'); 
        Add_Parameter(pl_id,'DESTYPE'      ,TEXT_PARAMETER,'PREVIEW'); 
        Add_Parameter(pl_id,'PARAMFORM'    ,TEXT_PARAMETER,'NO'); 
        
        Add_Parameter(pl_id,'POLIZA'        ,TEXT_PARAMETER,cPoliza); 
        Add_Parameter(pl_id,'AFIANZADO'     ,TEXT_PARAMETER,cAfianzado); 
        Add_Parameter(pl_id,'CODCLI'        ,TEXT_PARAMETER,cCodCli);
        Add_Parameter(pl_id,'DIRAFIAN'      ,TEXT_PARAMETER,cDirAfian);
        Add_Parameter(pl_id,'ACREEDOR'      ,TEXT_PARAMETER,cAcreedor);
        Add_Parameter(pl_id,'MONEDALARGO'   ,TEXT_PARAMETER,cDESCMONEDA);
        Add_Parameter(pl_id,'OBRA'          ,TEXT_PARAMETER,SUBSTR(cDescObra,1,2000));
        Add_Parameter(pl_id,'FECHAINI'      ,TEXT_PARAMETER,cFechaIni);
        Add_Parameter(pl_id,'FECHAFIN'      ,TEXT_PARAMETER,cfechafin);
        Add_Parameter(pl_id,'CODMONE'       ,TEXT_PARAMETER,Cmoneda);
        Add_Parameter(pl_id,'IDENTIFICACION',TEXT_PARAMETER,cNIT_CI);
        Add_Parameter(pl_id,'SUMAAFIANZADA' ,TEXT_PARAMETER,nSumaAfian);
        Add_Parameter(pl_id,'MPRIMA'        ,TEXT_PARAMETER,nPrima);
        Add_Parameter(pl_id,'FECHAEMI'      ,TEXT_PARAMETER,rTrim(lTrim(initcap(cCiudad)||', '||dFechaEmi)));  
        Add_Parameter(pl_id,'TIPODEPAGO'    ,TEXT_PARAMETER,cTipoPago);    
        Add_Parameter(pl_id,'CIUDAD'        ,TEXT_PARAMETER,NULL);  
        Add_Parameter(pl_id,'ANEXCLAUPOL'   ,TEXT_PARAMETER,NULL);        
        Add_Parameter(pl_id,'P_PRODUCTO'    ,TEXT_PARAMETER,'BET');  
        IF cTIPOREP1='CAFI' THEN
           rp2rro.rp2rro_run_product(reports,'CONPABET',ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam);
        ELSE -- CAFD
        	 Add_Parameter(pl_id,'P_IDEPOL'    ,TEXT_PARAMETER,nIdePol);
        	 rp2rro.rp2rro_run_product(reports,'CONPABET_DI',ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam);
        END IF;
        Destroy_Parameter_List( pl_id );
        */
    -- No se incluyo la librería de WORD97OLE. Ya que eso aplica en el Acsel Cliente/Servidor.    
    END IF;      -- cCodProd = 'TIC'
  END IF;        -- nIdepol is not NULL and nNumCert is not NULL

end gen_contrato;  

function imprimir_recibo (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, cNombreImpresora VARCHAR2, 
                          nCantidadCopia NUMBER) return varchar2 is
 cSelloAgua VARCHAR2(20);                          
begin
  IF PR_ACCESO_USUARIO.AUTORIZA_OPERACION(SUBSTR(CODUSER,1,8),920) = 'S' THEN  
     cSelloAgua := 'O R I G I N A L';
  ELSE
	IF PR_POLIZA.NROCOPIAPOL(nIdePol,cReporte,null,null) = 1 THEN -- primera vez que se imprime la poliza
	   cSelloAgua := 'O R I G I N A L';
	ELSE
	   cSelloAgua := 'C O P I A '; --||to_char(v_active_copy-1);
	END IF;
  END IF;
	 
  --Regenerar Condiciones Particulares antes de imprimir.
  IF nIdePol=94637 OR nIdePol=99999 THEN   -- Asi viene del Acsel.
     NULL;
  ELSE
     DELETE FROM CARATULA_POL WHERE IDEPOL = nIdePol;
     PR_CARAT_POLIZA.GEN_CARAT_POLIZA(nIdePol);
  END IF;

  IF cReporte IS NOT NULL  THEN
     null;
     /*
     pl_id := Create_Parameter_List('tmpdata'); 
     --Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo);
     Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,'PRINTER');  
     IF cNombreImpresora IS NOT NULL THEN
        Add_Parameter(pl_id,'DESNAME',TEXT_PARAMETER,cNombreImpresora); 
     END IF;
     Add_Parameter(pl_id,'COPIES',TEXT_PARAMETER,nCantidadCopia); 
     Add_Parameter(pl_id,'P_POLIZA',TEXT_PARAMETER,TO_CHAR(nIdePol)); 
     Add_Parameter(pl_id,'P_NUMCERT',TEXT_PARAMETER,TO_CHAR(nNumCert));
            
     IF cReporte != 'CUADRAUTM3' THEN
        Add_Parameter(pl_id,'P_IDEOP',TEXT_PARAMETER,TO_CHAR(nIdeOp));
     ELSE
        Add_Parameter(pl_id,'P_IDEOP',TEXT_PARAMETER,:B02.NUMOPER);
     END IF;
            
     Add_Parameter(pl_id,'P_SELLOAGUA',TEXT_PARAMETER,cSelloAgua);
     Add_Parameter(pl_id,'P_LOGO'     ,TEXT_PARAMETER,:B02.IMPRIME_LOGO); 
     Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
     rp2rro.rp2rro_run_product(reports,cReporte,ASYNCHRONOUS,RUNTIME,filesystem,pl_id,  cParam1);
     Destroy_Parameter_List( pl_id );
     */ 
  END IF;
end imprimir_recibo; 

function imprimir_relacion (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                            cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2 IS
--pl_id     ParamList; 
--dummy     Number;
cParam1   VARCHAR2(1);
cParam     VARCHAR2(2000);  -- Variable agregada para pase de Parámetro --
BEGIN
  IF cReporte IS NOT NULL THEN
     return null;
     /*
     pl_id := Create_Parameter_List('tmpdata'); 
     Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
     Add_Parameter(pl_id,'COPIES',TEXT_PARAMETER,nCantidadCopia); 
     Add_Parameter(pl_id,'P_POLIZA',TEXT_PARAMETER,TO_CHAR(nIdePol)); 
     Add_Parameter(pl_id,'P_IDEOP',TEXT_PARAMETER,TO_CHAR(nIdeOp));  
     Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
     -- Concatena Agrega los parámetros correspondientes a la variable de parámetros --
     cParam:= '&COPIES='||TO_CHAR(nCantidadCopia)||'&P_POLIZA='||TO_CHAR(nIdepol)||'&P_IDEOP='||TO_CHAR(nIdeOp);
     CALL_IMPRIMIR(cReporte,cParam); -- Invoca el procedimiento que llama el reporte y pasa la variable que contiene los parámetros --                        
     Destroy_Parameter_List( pl_id );
     */ 
  END IF;
END imprimir_relacion;

function imprimir_coaseguro (nIdePol NUMBER, nIdeOp NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                             cNombreImpresora VARCHAR2, nCantidadCopia NUMBER, cCodProd VARCHAR2) return varchar2 IS
 cExiste      VARCHAR2(1) := 'N';   
BEGIN
   BEGIN
     SELECT DISTINCT 'S'
       INTO cExiste
       FROM DIST_COA
      WHERE IdePol = nIdePol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           cExiste := 'N';
   END;
   IF cExiste = 'S' THEN
      return null;
      /*  
      pl_id := Create_Parameter_List('tmpdata'); 
      Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
      IF cNombreImpresora IS NOT NULL THEN
         Add_Parameter(pl_id,'DESNAME',TEXT_PARAMETER,cNombreImpresora); 
      END IF;
      Add_Parameter(pl_id,'COPIES',TEXT_PARAMETER,nCantidadCopia); 
      Add_Parameter(pl_id,'P_IDEPOL',TEXT_PARAMETER,TO_CHAR(nIdePol)); 
      Add_Parameter(pl_id,'P_IDEREC',TEXT_PARAMETER,TO_CHAR(nIdeRec));  -- Pedro R. Piña² 28/08/2000
      Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
      rp2rro.rp2rro_run_product(reports,cReporte,ASYNCHRONOUS,RUNTIME,filesystem,pl_id,  cParam1);
      Destroy_Parameter_List( pl_id ); 
      */
   END IF;
END imprimir_coaseguro;

function imprimir_condiciones_gen (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                                   cNombreImpresora VARCHAR2, nCantidadCopia NUMBER, 
                                   cCodProd VARCHAR2) return varchar2 IS
BEGIN
 --	RETURN;    ---Asi esta en el Acsel. Hay que Preguntar.
 IF cReporte IS NOT NULL  THEN
    return null;
    /*
    pl_id := Create_Parameter_List('tmpdata'); 
    Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
    Add_Parameter(pl_id,'COPIES',TEXT_PARAMETER,nCantidadCopia); 
    Add_Parameter(pl_id,'P_IDEPOL',TEXT_PARAMETER,TO_CHAR(nIdePol)); 
    Add_Parameter(pl_id,'P_CODPROD',TEXT_PARAMETER,(cCodProd)); 
    Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
    rp2rro.rp2rro_run_product(reports,cReporte,ASYNCHRONOUS,RUNTIME,filesystem,pl_id,  cParam1);
    Destroy_Parameter_List( pl_id );
    */ 
 END IF;
END imprimir_condiciones_gen;

function imprimir_cartas (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, cNombreImpresora VARCHAR2, 
                          nCantidadCopia NUMBER, cCodProd VARCHAR2) return varchar2 is
BEGIN
 IF cReporte IS NOT NULL  THEN
    return null;
    /*
    pl_id := Create_Parameter_List('tmpdata'); 
    Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
    Add_Parameter(pl_id,'COPIES',TEXT_PARAMETER,nCantidadCopia); 
    Add_Parameter(pl_id,'P_IDEPOL',TEXT_PARAMETER,TO_CHAR(nIdePol)); 
    Add_Parameter(pl_id,'P_CODPROD',TEXT_PARAMETER,(ccodprod)); 
    Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
    rp2rro.rp2rro_run_product(reports,cReporte,ASYNCHRONOUS,RUNTIME,filesystem,pl_id,  cParam1);
    Destroy_Parameter_List( pl_id ); 
    */
 END IF;
END imprimir_cartas;

function imprimir_marbete (nIdepol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                           cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2 is
cParam1       VARCHAR2(1);
nNumPol       number(10);
nNumCert      NUMBER(10); 
dFecVig       date;
cParam        VARCHAR2(2000);  -- Variable agregada para pase de Parámetro --
BEGIN
  BEGIN
    SELECT DISTINCT p.numpol, cr.numcert, cr.FecFinValid
      INTO nNumPol, nNumCert, dFecVig 
      FROM CERT_RAMO cr, POLIZA p, OPER_POL Op
     WHERE op.idepol  = p.idepol
       AND op.numcert = cr.numcert
       AND Op.idepol  = Cr.idepol
       AND Op.idepol  = nidepol
       AND Op.NumOper = nIdeop; 
  EXCEPTION 
     WHEN NO_DATA_FOUND THEN
     	  RETURN NULL;
  END;
		
  IF cReporte IS NOT NULL THEN
     RETURN NULL;
     /*
     pl_id := Create_Parameter_List('tmpdata'); 
     Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
     IF cNombreImpresora IS NOT NULL THEN
        Add_Parameter(pl_id,'DESNAME',TEXT_PARAMETER,cNombreImpresora); 
     END IF;
     Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,'CACHE');                               
     Add_Parameter(pl_id,'p_Numpol',TEXT_PARAMETER,TO_CHAR(nNumpol));                              
     Add_Parameter(pl_id,'P_FECVIG',TEXT_PARAMETER,TO_CHAR(dFecVig,'DD/MM/YYYY')); 
     Add_Parameter(pl_id,'p_NumcertDesde',TEXT_PARAMETER,TO_CHAR(nNumcert));                                           
     Add_Parameter(pl_id,'p_NumcertHasta',TEXT_PARAMETER,TO_CHAR(nNumcert));                                           
     Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
     -- Concatena Agrega los parámetros correspondientes a la variable de parámetros --
     cParam:= '&p_Numpol='||TO_CHAR(nNumpol)||
              '&p_fecvig='||TO_CHAR(dFecVig,'DD/MM/RRRR')||
              '&p_Numcertdesde='||TO_CHAR(nNumcert)||
              '&p_NumcertHasta='||TO_CHAR(nNumcert);

     --CALL_IMPRIMIR(cReporte,cParam); -- Invoca el procedimiento que llama el reporte y pasa la variable que contiene los parámetros --               
     Destroy_Parameter_List( pl_id );
     */ 
  END IF; 
END imprimir_marbete;

function imprimir_marbete_individual (nIdepol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                                      cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2 is
cParam1       VARCHAR2(1);
nCantCert     NUMBER(5);
cParam        VARCHAR2(2000);  -- Variable agregada para pase de Parámetro --

CURSOR RECIBOS IS
   SELECT a.NUMCERT
     FROM RECIBO a, CERT_VEH b, CERTIFICADO c
    WHERE a.IdePol  = b.IdePol
      AND a.NumCert = b.NumCert
      AND a.IDEOP   = nIdeop
      and a.idepol  = c.idepol
      and a.numcert = c.numcert
      and c.stscert = 'ACT'
   GROUP BY a.NumCert
   ORDER BY a.NumCert;

BEGIN
   -- nCantCert := FR_TOTAL_CERT(nIdePol, nIdeop);
  SELECT NVL(COUNT (DISTINCT b.NumCert),0)
    INTO nCantCert
    FROM Recibo b, Certificado a, Cert_Veh c 
   WHERE b.IdePol  = a.IdePol
     AND b.IdePol  = c.IdePol
     AND b.NumCert = a.NumCert
     AND b.NumCert = c.NumCert
     AND b.IDEOP   = nIdeop
     AND a.StsCert = 'ACT';
   IF nCantCert >= 1 AND nCantCert <= 4 THEN 
      FOR R IN Recibos LOOP
          RETURN NULL;
          /*
          pl_id := Create_Parameter_List('tmpdata'); 
          Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
          IF cNombreImpresora IS NOT NULL THEN
             Add_Parameter(pl_id,'DESNAME',TEXT_PARAMETER,cNombreImpresora); 
          END IF;
          Add_Parameter(pl_id,'COPIES',TEXT_PARAMETER,nCantidadCopia); 
          Add_Parameter(pl_id,'P_POLIZA',TEXT_PARAMETER,TO_CHAR(nIdepol)); 
          Add_Parameter(pl_id,'P_NUMCERT',TEXT_PARAMETER,TO_CHAR(R.NumCert));
          Add_Parameter(pl_id,'P_IDEOP',TEXT_PARAMETER,TO_CHAR(nIdeOp));
          Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
          -- Concatena Agrega los parámetros correspondientes a la variable de parámetros --
          -- cParam:= '&COPIES='||TO_CHAR(nCantidadCopia)||'&P_POLIZA='||TO_CHAR(nIdepol)||'&P_NUMCERT='||TO_CHAR(R.NumCert)||'&P_IDEOP='||TO_CHAR(nIdeOp);
          -- CALL_IMPRIMIR(cReporte,cParam); -- Invoca el procedimiento que llama el reporte y pasa la variable que contiene los parámetros --               
          */
      END LOOP;
   END IF;
END imprimir_marbete_individual;

function imprimir_cancelacion (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                               cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2 is
cParam1    VARCHAR2(1);
estatus    varchar2(3);
cParam     VARCHAR2(2000); -- Variable agregada para pase de Parámetro --
BEGIN
  BEGIN	
	 SELECT StsPol 
       INTO estatus
	   FROM POLIZA 
      WHERE IdePol = nIdepol;
  EXCEPTION
	   WHEN NO_DATA_FOUND THEN
	        estatus := NULL;
  END;

  IF estatus IN ('ANU', 'EXC') THEN
 	 IF cReporte IS NOT NULL  THEN
        RETURN NULL;
        /*
        pl_id := Create_Parameter_List('tmpdata'); 
        Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
        IF cNombreImpresora IS NOT NULL THEN
           Add_Parameter(pl_id,'DESNAME',TEXT_PARAMETER,cNombreImpresora); 
        END IF;
        Add_Parameter(pl_id,'COPIES',TEXT_PARAMETER,nCantidadCopia); 
        Add_Parameter(pl_id,'P_IDEPOL',TEXT_PARAMETER,TO_CHAR(nIdePol)); 
        --Add_Parameter(pl_id,'P_CODPROD',TEXT_PARAMETER,(ccodprod)); 
        Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
        rp2rro.rp2rro_run_product(reports,cReporte,ASYNCHRONOUS,RUNTIME,filesystem,pl_id,  cParam1);
        Destroy_Parameter_List( pl_id ); 
        */
    END IF;
  END IF;
END imprimir_cancelacion; 

function imprimir_planilla_reclamo (nIdePol NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                                    cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2 IS
 cParam1    VARCHAR2(1);
 cParam     VARCHAR2(2000);  -- Variable agregada para pase de Parámetro --
BEGIN
 IF cReporte IS NOT NULL  THEN
    return null;
    /*
    pl_id := Create_Parameter_List('tmpdata'); 
    Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
    IF cNombreImpresora IS NOT NULL THEN
       Add_Parameter(pl_id,'DESNAME',TEXT_PARAMETER,cNombreImpresora); 
    END IF;
    Add_Parameter(pl_id,'COPIES',TEXT_PARAMETER,nCantidadCopia); 
    Add_Parameter(pl_id,'P_IDEPOL',TEXT_PARAMETER,TO_CHAR(nIdePol)); 
    Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
    rp2rro.rp2rro_run_product(reports,cReporte,ASYNCHRONOUS,RUNTIME,filesystem,pl_id,  cParam1);
    Destroy_Parameter_List( pl_id ); 
    */
 END IF;
END imprimir_planilla_reclamo;

function imprimir_condicion_pago (nIdePol NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                                  cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2 is
   cParam1      VARCHAR2(1);
   cFacturacion varchar2(1);
   cParam       long;
   cSelloAgua   varchar2(20);
BEGIN
  IF PR_ACCESO_USUARIO.AUTORIZA_OPERACION(SUBSTR(CODUSER,1,8),920) =  'S'  THEN  
	 cSelloAgua := 'O R I G I N A L';
  ELSE
     IF pr_poliza.NROCOPIAPOL(nidepol,cReporte,null,null)=1 THEN -- primera vez que se imprime la poliza
        cSelloAgua := 'O R I G I N A L';
     ELSE
	 	cSelloAgua := 'C O P I A '; 
	 END IF;
  END IF;
	 
  cFacturacion :=  PR_REPORTES.Tipo_Facturacion (nIdePol); 
	
  IF cReporte IS NOT NULL  THEN
     RETURN NULL;
     /*
     Add_Parameter(pl_id,'PARAMFORM'  ,TEXT_PARAMETER,'NO');       
     Add_Parameter(pl_id,'DESTYPE'    ,TEXT_PARAMETER,'PRINTER');
     Add_Parameter(pl_id,'P_IDEPOL'   ,TEXT_PARAMETER,nIdePol);      
     Add_Parameter(pl_id,'P_SELLOAGUA',TEXT_PARAMETER,cSelloAgua);
          
     IF cReporte = 'MXPOLIZF' OR cReporte = 'MXCERTFF' THEN --firmas digitales
        Add_Parameter(pl_id,'PNUMOPER'   ,TEXT_PARAMETER,:B02.NUMOPER); 
        Add_Parameter(pl_id,'P_LOGO'     ,TEXT_PARAMETER,:B02.IMPRIME_LOGO); 
        rp2rro.rp2rro_run_product(reports,cReporte,ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam1);
     ELSIF cFacturacion = 'P' THEN    
        rp2rro.rp2rro_run_product(reports,cReporte,ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam1);
     ELSIF cFacturacion = 'C' THEN  
        rp2rro.rp2rro_run_product(reports,'mxcertif',ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam1);
     END IF;
     */
   END IF;
END imprimir_condicion_pago;  

function imprimir_factura (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                           cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2 is
nIdeFact      NUMBER(14);
cParam1       VARCHAR2(1);
Producto      VARCHAR2(4);
cParam        VARCHAR2(2000);  -- Variable agregada para pase de Parámetro --
-------------------------------------------------------------------------------
---- SE HIZO UN CURSOR PORQUE cuando la facturacion es POR CERTIFICADO  -------
----- EMITE MAS DE UNA FACTURA                                   --------------
-------------------------------------------------------------------------------
CURSOR C1 is
  SELECT A.IDEFACT
    FROM RECIBO R, ACREENCIA A, FACTURA F
   WHERE R.IdePol   = nIdePol
     AND R.IdeOp    = nIdeOp
     AND R.NumACre  = A.NumAcre(+)
     AND A.IdeFact  = F.IdeFact(+)
     AND R.NumAcre IS NOT NULL
   GROUP BY R.TipoOpe,A.IdeFact;
BEGIN
  FOR C2 IN C1 LOOP 
   	  nIdeFact := C2.IdeFact;
      BEGIN
        SELECT  CodProd
          INTO  Producto 
          FROM  Poliza
         WHERE  IDEPOL = nIdepol;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
          WHEN TOO_MANY_ROWS THEN NULL;         
      END;
      IF cReporte IS NOT NULL  THEN
   	     IF nIdeFact IS NOT NULL THEN
            return null;
            /*
            pl_id := Create_Parameter_List('tmpdata'); 
            Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,'PRINTER'); 
            IF cNombreImpresora IS NOT NULL THEN
               Add_Parameter(pl_id,'DESNAME',TEXT_PARAMETER,cNombreImpresora); 
            END IF;
            add_Parameter(pl_id,'COPIES',TEXT_PARAMETER,nCantidadCopia); 
            Add_Parameter(pl_id,'P_NUMFACT',TEXT_PARAMETER,TO_CHAR(nIdeFact)); 
            Add_Parameter(pl_id,'P_TIPO',TEXT_PARAMETER,'PRINTER'); 
            Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
            rp2rro.rp2rro_run_product(reports,cReporte,ASYNCHRONOUS,RUNTIME,filesystem,pl_id,cParam1);
            Destroy_Parameter_List( pl_id );
            */
         END IF; 
      END IF; 
  END LOOP;
END imprimir_factura;

function imprimir_acuerdo (nNumAcuerdo NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, 
                           cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2 is
cParam1 VARCHAR2(1);
cParam  VARCHAR2(2000);  -- Variable agregada para pase de Parámetro --
BEGIN
  IF cReporte IS NOT NULL THEN
      return null;
      /*
      pl_id := Create_Parameter_List('tmpdata'); 
      Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
      IF cNombreImpresora IS NOT NULL THEN
         Add_Parameter(pl_id,'DESNAME',TEXT_PARAMETER,cNombreImpresora); 
      END IF;
      Add_Parameter(pl_id,'COPIES'      ,TEXT_PARAMETER,nCantidadCopia); 
      Add_Parameter(pl_id,'P_NUMACUERDO',TEXT_PARAMETER,TO_CHAR(V_NUMACUERDO));           
      Add_Parameter(pl_id,'PARAMFORM'   ,TEXT_PARAMETER,'NO'); 
      */         
  END IF;
END imprimir_acuerdo;  

function imprimir_siniestralidad (cCodProd VARCHAR2, nNumPol NUMBER, dFecha_Desde DATE, dFecha_Hasta DATE,
                                  cTipo VARCHAR2, cReporte VARCHAR2, cNombreImpresora VARCHAR2, 
                                  nCantidadCopia NUMBER) return varchar2 is
cParam1       VARCHAR2(1);
cParam        VARCHAR2(2000);  -- Variable agregada para pase de Parámetro --
BEGIN
  IF cReporte IS NOT NULL  THEN
     return null;
     /*
     Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,cTipo); 
     IF cNombreImpresora IS NOT NULL THEN
        Add_Parameter(pl_id,'DESNAME',TEXT_PARAMETER,cNombreImpresora); 
     END IF;
     Add_Parameter(pl_id,'DESTYPE',TEXT_PARAMETER,'CACHE');                                              
     Add_Parameter(pl_id,'p_Fecha_desde',TEXT_PARAMETER,TO_CHAR(dFecha_desde,'DD/MM/YYYY')); 
     Add_Parameter(pl_id,'p_Fecha_hasta',TEXT_PARAMETER,TO_CHAR(dFecha_hasta,'DD/MM/YYYY'));                
     Add_Parameter(pl_id,'p_producto',TEXT_PARAMETER,(cCodprod));                                             
     Add_Parameter(pl_id,'p_numpol',TEXT_PARAMETER,TO_CHAR(nNumpol));                              
     Add_Parameter(pl_id,'PARAMFORM',TEXT_PARAMETER,'NO'); 
     -- Concatena Agrega los parámetros correspondientes a la variable de parámetros --
     cParam:= '&p_fecha_desde='||TO_CHAR(dFecha_desde,'DD/MM/RRRR')||
              '&p_fecha_hasta='||TO_CHAR(dFecha_hasta,'DD/MM/RRRR')||
              '&p_producto='||cCodprod||
              '&p_numpol='||TO_CHAR(nNumpol);
     */         
  END IF; 
END imprimir_siniestralidad;                                                           


end PR_APEX;
