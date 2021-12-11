create or replace PACKAGE BODY       pr_pre_cobert AS
    --/*******************************************************************************************
    -- * NOMBRE PROGRAMA : PR_PRE_COBERT                                                         *
    -- * DESCRIPCION     : MANTENIMIENTO DE TARIFAS, AUTOMATIZACION DE TARIFAS(SUMA,TASA Y PRIMA)*
    -- Parametros para coberturas del Ramo de Vida
    -- Pre_Tasa
    --      BPREMUER - Parametro de cobertura de muerte o vida. (Vida Tradicional)
    --                 Retorna Tasas por sexo, condicion de fumador y edad.
    --                 Se busca en tablas TASA_EDAD_PLAN_VIDA.
    --
    --      TASAEDAD - Busca tasa de la cobertura por Edad
    --                 en la tabla TASA_EDAD_COBERT_VIDA
    --                        EPP "Exoneracion de Pago de Prima"
    --                        BAC "Beneficio de Anticipacion de Capital"
    --                        STC "Cobertura de Seguro Temporal Creciente"
    --
    --      SUMATASA - Busca tasa de la cobertura por Edad
    --                 en la tabla TASA_EDAD_COBERT_VIDA
    --
    --      SEXOEDAD - Busca tasa por sexo y edad en la tabla TASA_EDAD_SEXO_PLAN_VIDA
    --
    --      FACTPARE - Factores para suma y tasa por edad y parentesco.
    --                 Busca en tabla FACTOR_PARENTESCO.
    --
    --      TMPRENOV - Temporal Anual / Temporal Anual Renovable
    --                      VID "Cobertura Basica para Temporal Anual Renovable"
    --
    --      BPREMUERUNI  - Retorna Tasa de Vida Universal. Busca en Tabla TASA_EDAD_PLAN_VIDA_UNI
    --                      VID "Cobertura Basica de Vida para Vida Universal"
    --                      MAD "Muerte Accidental y Desmembramiento"
    --                      PE  "Pago por Enfermedad"
    --                      SS  "Seguro Saldado por Invalidez"
    --
    --      TARIFABC o TARIFABP - Busca tasa en TASA_EDAD_COBERT_VIDA para cobertura de Beneficio del Contratante
    --                  o Pagador para menores de edad (Escolaridad).  Cobertura del Contratante o Pagador. Se
    --                  busca con la Edad del Contratante
    --                          BC "Beneficio del Contratante"
    --                          BP "Beneficio del Pagador"
    --
    --       Parametro de tasa para cobertura
    --       TEDADSEX       Retorna Tasas por sexo, condicion de fumador y edad.
    --                      Se busca en tablas TASA_EDAD_PLAN_VIDA.
    --
    --      TARRENTA    -  RI  "Renta por Invalidez" Retorna tasa por edad y sexo para coberturas de renta
    --         y        -  RO  "Renta por Orfandad" Retorna tasa por edad y sexo para coberturas de renta
    --      TARRENTAUNI -  RV  "Renta por Viudez" Retorna tasa por edad y sexo para coberturas de renta
    --
    --      TARTARD  - Parametro de Cobertura de Muerte o Vida para los Planes Temporales Anuales
    --                 Renovables Decreciente.
    --
    --      TARTMPD  - Parametro de Cobertura de Muerte o Vida para los Planes Temporales Decreciente
    --
    -- Pre_suma
    --      BPREMUER - Retorna suma asegurada. Se busca en la tabla DATOS_PARTICULARES_VIDA_ASEG
    --                 para la basica y para las adicionales en Mod_Cobert o Cobert_Aseg
    --                      VID "Cobertura Basica de Vida para Vida Universal"
    --                      MAD "Muerte Accidental y Desmembramiento"
    --                      PE  "Pago por Enfermedad"
    --                      SS  "Seguro Saldado por Invalidez"
    --
    --      SUMAEDAD - Busca suma por edad en tabla SUMA_EDAD_COBERT_VIDA.
    --
    --      SUMATASA - Busca suma por edad en tabla SUMA_EDAD_COBERT_VIDA.
    --
    --      FACTPARE - Factores para suma y tasa por edad y parentesco.
    --                 Busca en tabla FACTOR_PARENTESCO.
    --
    --      TARRENTA      -  RI  "Renta por Invalidez"
    --         y          -  RO  "Renta por Orfandad"
    --      TARRENTAUNI   -  RV  "Renta por Viudez"
    --                   Calculo de la Suma Asegurada para las Coberturas de Renta
    --                   LLama Rutina de Calculo PR_RENTA_INVALIDEZ_ASEG.CALC_SUMA.
    --
    --      TARTARD  - Parametro de Cobertura de Muerte o Vida para los Planes Temporales Anuales
    --                 Renovables Decreciente.
    --
    --      TARTMPD  - Parametro de Cobertura de Muerte o Vida para los Planes Temporales Decreciente
    --
    --      TARIESGO - Tarifa definida por Regional o Sucursal/Oficina y Nivel de Riesgo se establece en la forma TARIESGO
    -----------------------

    FUNCTION PRE_SUMA(nIdePol      NUMBER,
                      nNumCert     NUMBER,
                      cCodProd     VARCHAR2,
                      cCodPlan     VARCHAR2,
                      cRevPlan     VARCHAR2,
                      cCodRamoCert VARCHAR2,
                      cCodCobert   VARCHAR2,
                      cParam       VARCHAR2,
                      nIdeAseg     NUMBER,
                      nIdeCobert   NUMBER) RETURN NUMBER IS

        nSumaAseg       NUMBER(14, 2) := 0;
        cValEst1        VARCHAR2(3);
        cValEst2        VARCHAR2(3);
        dFecNac         DATE;
        dFecIniVig      DATE;
        nEdad           NUMBER(4);

        cCodParent      VARCHAR2(4);



    BEGIN

        IF cParam IN ('TARCASCO', 'TARCASTV') THEN
            BEGIN
                SELECT MtoCostoVeh
                  INTO nSumaAseg
                  FROM COSTO_ANO_VEH MV, CERT_VEH CV
                 WHERE MV.CodMarca = CV.CodMarca
                   AND MV.CodModelo = CV.CodModelo
                   AND MV.CodVersion = CV.CodVersion
                   AND MV.AnoVeh = CV.AnoVeh
                   AND CV.IdePol = nIdePol
                   AND CV.NumCert = nNumCert
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
            -----------------------------------------
            ---- COASEGURO MINORITARIO AUTOMOVIL
            -----------------------------------------
        ELSIF cParam = 'TARFIA' THEN

            BEGIN
                SELECT SUMAAFIANZADA
                INTO nSumaAseg
                FROM DATOS_PARTICULARES_FIANZAS
                WHERE IDEPOL = nIdePol
                AND NUMCERT = nNumCert
                ;

            EXCEPTION WHEN OTHERS THEN
                nSumaAseg := 0;
            END;

        ELSIF cParam IN ('COASEG') THEN
            BEGIN
                SELECT c.Valor_Total
                  INTO nSumaAseg
                  FROM Cert_Veh c
                 WHERE c.IdePol = nIdepol
                   AND c.NumCert = nNumCert
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = c.Numexp
                           and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
                WHEN TOO_MANY_ROWS THEN
                    nSumaAseg := 0;
            END;
        ELSIF cParam = 'PDECTRA' THEN
            -- DECLARACIONES
            BEGIN
                SELECT NVL(SUM(MtoLiqLocal), 0)
                  INTO nSumaAseg
                  FROM DECLARACION
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND StsDec IN ('INC', 'MOD');
            END;
            --//
        ELSIF cParam = 'DECLVIDA' THEN
            BEGIN
                SELECT NVL(SUM(MtoLiqMoneda), 0)
                  INTO nSumaAseg
                  FROM DECLARACION
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND StsDec IN ('INC', 'MOD');
            END;
        ELSIF cParam IN ('PDECINC', 'PDECINCA', 'PDECINCH', 'PCOBHIPO') THEN
            BEGIN
                SELECT NVL(MAX(MtoLiqLocal), 0)
                  INTO nSumaAseg
                  FROM DECLARACION
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND StsDec IN ('INC', 'MOD');
            END;
        ELSIF cParam IN ('PDEPINCE') THEN
            DECLARE
                cCodProd   VARCHAR2(4);
                cCodPlan   VARCHAR2(3);
                cRevPlan   VARCHAR2(3);
                cClaseBien VARCHAR2(3);
                cCodBien   VARCHAR2(4);
                cSts       VARCHAR2(3);
            BEGIN
                BEGIN
                    SELECT CODPROD
                      INTO cCodProd
                      FROM POLIZA
                     WHERE IDEPOL = nIdePol;
                EXCEPTION
                    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                        NULL;
                END;
                BEGIN
                    SELECT CODPLAN, REVPLAN, STSCERTRAMO
                      INTO cCodPlan, cRevPlan, cSts
                      FROM CERT_RAMO
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                        NULL;
                END;
                BEGIN
                    SELECT DISTINCT CLASEBIEN, CODBIEN
                      INTO cClaseBien, cCodBien
                      FROM DECLARACION_RAMO_PLAN_PROD DRPP
                     WHERE DRPP.CodProd = cCodProd
                       AND DRPP.CodPlan = cCodPlan
                       AND DRPP.RevPlan = cRevPlan
                       AND DRPP.CodRamoPlan = cCodRamoCert
                       AND DRPP.ParamCobDeposito IS NOT NULL;
                EXCEPTION
                    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'Error, verificar configuracion ...');
                END;
                IF cSts IN ('VAL', 'INC') THEN
                    BEGIN
                        SELECT NVL(MTOVALBIENMONEDA, 0)
                          INTO nSumaAseg
                          FROM BIEN_CERT
                         WHERE IDEPOL = nIdePol
                           AND NUMCERT = nNumCert
                           AND CODRAMOCERT = cCodRamoCert
                           AND CLASEBIEN = cClaseBien
                           AND CODBIEN = cCodBien
                           AND STSBIEN IN ('VAL', 'INC');
                    END;
                ELSIF cSts IN ('MOD', 'ACT') THEN
                    BEGIN
                        SELECT NVL(MTOVALBIENMONEDA, 0)
                          INTO nSumaAseg
                          FROM MOD_BIEN_CERT MBC
                         WHERE IDEPOL = nIdePol
                           AND NUMCERT = nNumCert
                           AND CODRAMOCERT = cCodRamoCert
                           AND CLASEBIEN = cClaseBien
                           AND CODBIEN = cCodBien
                           AND CODPLAN = cCodPlan
                           AND REVPLAN = cRevPlan
                           AND NUMMOD =
                               (SELECT MAX(NUMMOD)
                                  FROM MOD_BIEN_CERT
                                 WHERE IDEPOL = nIdePol
                                   AND NUMCERT = nNumCert
                                   AND CODRAMOCERT = cCodRamoCert
                                   AND CLASEBIEN = cClaseBien
                                   AND CODBIEN = cCodBien
                                   AND CODPLAN = cCodPlan
                                   AND REVPLAN = cRevPlan
                                   AND STSMODBIEN IN ('INC', 'ACT')
                                   AND IDEBIEN = MBC.IDEBIEN);
                    END;
                END IF;
            END;
        ELSIF cParam IN ('TARFULL') THEN
            nSumaAseg := PR_PRE_AUTOMOVIL.PRE_SUMA(nIdePol,
                                                   nNumCert,
                                                   cCodProd,
                                                   cCodPlan,
                                                   cRevPlan,
                                                   cCodRamoCert,
                                                   cCodCobert,
                                                   cParam,
                                                   nIdeAseg,
                                                   nIdeCobert);
        ELSIF cParam IN ('TARAUTO', 'TARAUTOR', 'TARAURC', 'TARAURC2',
               'TARAURCR', 'TARAURCR2', 'TARAURV', 'TARAURVR','TARAUTFOR','TARGRFOR') THEN
            DECLARE
                nSumaAsegRc NUMBER(14, 2);
            BEGIN
                BEGIN
                    SELECT c.Valor_Total, c.SumaAsegRc
                      INTO nSumaAseg, nSumaAsegRc
                      FROM Cert_Veh c
                     WHERE c.IdePol = nIdepol
                       AND c.NumCert = nNumCert
                       and exists (select 'S'
                              from Inspeccion I
                             where I.NumExp = c.Numexp
                               and i.tipoexp = 'SU');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg   := 0;
                        nSumaAsegRc := 0;
                    WHEN TOO_MANY_ROWS THEN
                        nSumaAseg   := 0;
                        nSumaAsegRc := 0;
                END;
                IF cParam IN ('TARAURC', 'TARAURCR') THEN
                    nSumaAseg := nSumaAsegRc;
                ELSIF cParam IN ('TARAURC2', 'TARAURCR2') THEN
                    nSumaAseg := nSumaAsegRc * 2;
                END IF;
                RETURN(nSumaAseg);
            END;
        ELSIF cParam IN
              ('TARAUFI', 'TARAUAC', 'TARAUGM', 'TARAUCE', 'TARAUPC',
               'TARAUFU', 'TARAUAP', 'TARAUGP', -- JJVR 04/08/2000
               'TARAUFIR', 'TARAUACR', 'TARAUGMR', 'TARAUCER', 'TARAUPCR',
               'TARAUFUR', 'TARAUAPR', 'TARAUGPR', 'TARLEY146') THEN

            DECLARE
                cTipoFianza     VARCHAR2(15);
                CPLANMINFIANZAS VARCHAR2(15);
                --    cRentaVeh          VARCHAR2(15);
                cAccConductor    VARCHAR2(15);
                cAccPasajeros    VARCHAR2(15);
                cRCExceso        VARCHAR2(15);
                cPolitAcc        VARCHAR2(15);
                cGastosFunerales VARCHAR2(15);
                cClase           VARCHAR2(15);
                cParametro       VARCHAR2(15);
                cTipoFianza1     VARCHAR2(15);

            BEGIN

                BEGIN
                    SELECT c.Tipo_Fianza, /*c.RentaVeh,*/
                           c.AccConductor,
                           c.AccPasajeros,
                           c.RCExceso,
                           c.PolitAcc,
                           c.GastosFunerales,
                           PLANMINFIANZAS
                      INTO cTipoFianza, /* cRentaVeh,*/
                           cAccConductor,
                           cAccPasajeros,
                           cRCExceso,
                           cPolitAcc,
                           cGastosFunerales,
                           CPLANMINFIANZAS
                      FROM Cert_Veh c
                     WHERE c.IdePol = nIdepol
                       AND c.NumCert = nNumCert
                       and exists (select 'S'
                              from Inspeccion I
                             where I.NumExp = c.Numexp
                               and i.tipoexp = 'SU');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;

                IF cParam IN ('TARAUFI', 'TARAUFIR') THEN
                    cTipoFianza1 := cTipoFianza;
                    -- cClase     := cTipoFianza;
                    cClase     := cTipoFianza1;
                    cParametro := 'TARAUFI';
                ELSIF cParam IN ('TARAUFIMIN') THEN
                    cClase     := CPLANMINFIANZAS;
                    cParametro := 'TARAUFI';
                ELSIF cParam IN ('TARAUAC', 'TARAUACR') THEN
                    cClase     := cAccConductor;
                    cParametro := 'TARAUAC';
                ELSIF cParam IN ('TARAUGM', 'TARAUGMR') THEN
                    cClase     := cAccConductor;
                    cParametro := 'TARAUGM';
                ELSIF cParam IN ('TARAUCE', 'TARAUCER') THEN
                    cClase     := cRCExceso;
                    cParametro := 'TARAUCE';
                ELSIF cParam IN ('TARAUPC', 'TARAUPCR') THEN
                    cClase     := cPolitAcc;
                    cParametro := 'TARAUPC';
                ELSIF cParam IN ('TARAUFU', 'TARAUFUR') THEN
                    cClase     := cGastosFunerales;
                    cParametro := 'TARAUFU';
                ELSIF cParam IN ('TARAUAP', 'TARAUAPR') THEN
                    cClase     := cAccPasajeros;
                    cParametro := 'TARAUAP';
                ELSIF cParam IN ('TARAUGP', 'TARAUGPR') THEN
                    cClase     := cAccPasajeros;
                    cParametro := 'TARAUGP';
                ELSIF cParam = 'TARLEY146' THEN
                    nSumaAseg := PRE_SUMA_LEY(nIdePol, nNumCert, cCodCobert);
                ELSE
                    cClase     := null;
                    cParametro := null;
                END IF;

                IF cParam != 'TARLEY146' THEN
                    BEGIN
                        SELECT to_number(l.descrip, '999,999,999.99')
                          INTO nSumaAseg
                          FROM LVAL l
                         WHERE L.TIPOLVAL = cParametro
                           AND L.CODLVAL = cClase;
                    EXCEPTION
                        WHEN NO_DATA_FOUND then
                            nSumaAseg := 0;
                    END;
                END IF;

                RETURN(nSumaAseg);
            END;
            -----------------------------------------------------------------------------
        ELSIF cParam = 'COLUSUM' THEN
            BEGIN
                SELECT MAX(MTOVALBIENMONEDA) * 2
                  INTO nSumaAseg
                  FROM BIEN_CERT
                 WHERE IDEPOL = nIdePol
                   AND NUMCERT = nNumCert
                   AND CODRAMOCERT = cCodRamoCert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
                WHEN TOO_MANY_ROWS THEN
                    RAISE_APPLICATION_ERROR(-20100,
                                            'Registro duplicado para FIDSTD');
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TARRCV' THEN
            BEGIN
                SELECT SumaASeg
                  INTO nSumaAseg
                  FROM TARIFA_RCV TR, CERT_VEH CV
                 WHERE TR.ClaseVeh = CV.ClaseVeh
                   AND CV.IdePol = nIdePol
                   AND CV.NumCert = nNumCert
                   AND TR.CodProd = cCodProd
                   AND TR.CodRamo = cCodRamoCert
                   AND TR.CodPlan = cCodPlan
                   AND TR.RevPlan = cRevPlan
                   AND TR.CodCobert = cCodCobert
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TARCRIS' THEN
            DECLARE
                nIdeBien NUMBER(14);
            BEGIN
                BEGIN
                    SELECT IDEBIEN
                      INTO nIdeBien
                      FROM COBERT_BIEN
                     WHERE IDECOBERT = nIdeCobert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;

                BEGIN
                    SELECT SUM(TOTVALASEG)
                      INTO nSumaAseg
                      FROM DATOS_PART_CRISTALES
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert
                       AND IDEBIEN = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;

                RETURN(nSumaAseg);
            END;
        ELSIF cParam = 'TARAPOV' THEN
            BEGIN
                SELECT SumaASeg
                  INTO nSumaAseg
                  FROM TARIFA_APOV TAP, CERT_VEH CV
                 WHERE TAP.CodSubPlan = CV.CodPlanApov
                   AND CV.IdePol = nIdePol
                   AND CV.NumCert = nNumCert
                   AND TAP.CodProd = cCodProd
                   AND TAP.CodRamo = cCodRamoCert
                   AND TAP.CodPlan = cCodPlan
                   AND TAP.RevPlan = cRevPlan
                   AND TAP.CodCobert = cCodCobert
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
        ELSIF cParam = 'TARFUN' THEN
            BEGIN
                SELECT Suma
                  INTO nSumaAseg
                  FROM TARIFA_PRIMA_PLAN
                 WHERE CodProd = cCodProd
                   AND CodRamoPlan = cCodRamoCert
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodCobert = cCodCobert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TAREGM' THEN
            BEGIN
                SELECT C.FecNac, CodParent
                  INTO dFecNac, cCodParent
                  FROM ASEGURADO A, CLIENTE C
                 WHERE IdeAseg = nIdeAseg
                   AND A.CodCli = C.CodCli;
            END;
            BEGIN
                SELECT FecIniVig
                  INTO dFecIniVig
                  FROM POLIZA
                 WHERE IdePol = nIdePol;
            END;
            nEdad := NVL(FLOOR((dFecIniVig - dFecNac) / 365), 25);
            IF nEdad < 25 AND
               cCodParent IN ('0001', '0002', '0003', '0004') THEN
                nEdad := 25;
            END IF;
            BEGIN
                SELECT ValEst
                  INTO cValEst1
                  FROM EST_CERT
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND CodEst = 'LICOB';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    cValEst1 := NULL;
            END;
            BEGIN
                SELECT ValEst
                  INTO cValEst2
                  FROM EST_CERT
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND CodEst = 'DEDUC';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    cValEst2 := NULL;
            END;
            BEGIN
                SELECT LimiteCobertura
                  INTO nSumaAseg
                  FROM TARIFA_EXCESO
                 WHERE CodProd = cCodProd
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodEst1 = 'LICOB'
                   AND ValEst1 = cValEst1
                   AND CodEst2 = 'DEDUC'
                   AND ValEst2 = cValEst2
                   AND nEdad >= EdaIni
                   AND nEdad <= EdaFin;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            /****************************************************************************/
            -- TARRESPR (TARIFA DE RESPONSABILIDAD CIVIL PROSEGUROS ---------
            -----------------------------------------------------------------
        ELSIF cParam IN ('TARRESP', 'RESPPRE', 'RESPPRO', 'TARRESPPR') THEN
            -------------------------------------------------------------
            -- Tarifa de Responsabilidad Civil.
            -------------------------------------------------------------
            DECLARE
                nSumaAsegSalario NUMBER(14, 2);
                nSumaAsegVenta   NUMBER(14, 2);
                nSumaAsegurada   NUMBER(14, 2);
            BEGIN
                BEGIN
                    SELECT VOLSALARIO, VENTAANUAL, SUMAASEGURADA
                      INTO nSumaAsegSalario, nSumaAsegVenta, nSumaAsegurada
                      FROM DATOS_PART_RESP
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAsegSalario := 0;
                        nSumaAsegVenta   := 0;
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20213,
                                                'DUPLICADOS DATOS ' ||
                                                'IdePol       = ' ||
                                                nIdePol ||
                                                'NumCert      = ' ||
                                                nNumCert);

                END;
                IF cParam = 'RESPPRE' THEN
                    nSumaAseg := nSumaAsegSalario;
                ELSIF cParam = 'RESPPRO' THEN
                    nSumaAseg := nSumaAsegVenta;
                ELSE
                    nSumaAseg := nSumaAsegurada;
                END IF;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TARFIAN' THEN
            BEGIN
                SELECT SumaAfianzada
                  INTO nSumaAseg
                  FROM DATOS_PARTICULARES_FIANZAS
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;

            RETURN(nSumaAseg);
        ELSIF cParam = 'TAREXC' THEN
            BEGIN
                SELECT SumaAsegMin
                  INTO nSumaAseg
                  FROM COBERT_PLAN_PROD
                 WHERE CodProd = cCodProd
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodRamoPlan = cCodRamoCert
                   AND CodCobert = cCodCobert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);

        ELSIF cParam = 'TARTERRM' THEN
            BEGIN
                SELECT nvl(sum(nvl((MtoValBienMoneda * PorcRiesgo) / 100, 0)),
                           0)
                  INTO nSumaAseg
                  FROM BIEN_CERT
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumcert
                   AND CodRamoCert = cCodRamoCert;
            END;
            /* TARIFA DE Incendio Republica Dominicana  */
        ELSIF cParam IN
              ('TARINBRD', 'TARTERRD', 'TARHURRD', 'TARMOHRD', 'TARROBOP',
               'PERDIND', 'TAREXPRD', 'TARNAVRD', 'TARDPARD', 'TARINURD') THEN
            nSumaAseg := NVL(PR_PRE_INCENDIO.PRE_SUMA(nIdePol,
                                                      nNumCert,
                                                      cCodProd,
                                                      cCodPlan,
                                                      cRevPlan,
                                                      cCodRamoCert,
                                                      cCodCobert,
                                                      cParam,
                                                      nIdeAseg,
                                                      nIdeCobert),
                             0);
            RETURN(nSumaAseg);

        ELSIF cParam = 'TARTRDEX' THEN
            BEGIN
                SELECT NVL(SUMAASEG, 0)
                  INTO nSumaAseg
                  FROM DECLARACION_TRANSPORTE
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CODRAMOCERT = cCodRamoCert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
                WHEN TOO_MANY_ROWS THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TARTRAN' THEN
            BEGIN
                SELECT NVL(MTOTOTALENVIOS, 0)
                  INTO nSumaAseg
                  FROM dat_transporte_pol
                 WHERE IdePol = nIdePol;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'LMAXTRAN' THEN
            BEGIN
                SELECT MAX(MtoMaxTran)
                  INTO nSumaAseg
                  FROM MED_TRANS_POL
                 WHERE IdePol = nIdePol;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TARAVI' THEN
            BEGIN
                SELECT SumAsegurada
                  INTO nSumaAseg
                  FROM CERT_AVI
                 WHERE IdePol = nIdePol
                   AND Numcert = nNumcert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam IN ('TRANVEH', 'TRANVET') THEN
            BEGIN
                SELECT MAX(SumaAsegTran)
                  INTO nSumaAseg
                  FROM CERT_VEH_TRAN
                 WHERE IdePol = nIdePol
                   AND Numcert = nNumcert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam IN ('3DTARFI', 'TARFI4D') THEN
            BEGIN
                SELECT SumaAseg
                  INTO nSumaAseg
                  FROM DATOS_PART_FI3D
                 WHERE IdePol = nIdePol
                   AND Numcert = nNumcert
                   AND CodProd = cCodProd
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodRamoCert = cCodRamoCert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'COLU' THEN
            DECLARE
                Factor NUMBER(3);
            BEGIN
                BEGIN
                    SELECT FACTOR
                      INTO Factor
                      FROM TARIFA_FI3D_COLU
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        Factor := 0;
                END;
                BEGIN
                    SELECT SumaAseg
                      INTO nSumaAseg
                      FROM DATOS_PART_FI3D
                     WHERE IdePol = nIdePol
                       AND Numcert = nNumcert
                       AND CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoCert = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;
                nSumaAseg := nSumaAseg * Factor;
                RETURN(nSumaAseg);
            END;
        ELSIF cParam IN
              ('TARTRC', 'TRCINUN', 'TRCTERR', 'TRCSIM', 'TRCAMP', 'TRCSUM') THEN
            BEGIN
                -- Tarifa de TRC.
                SELECT SUMAASEG
                  INTO nSumaAseg
                  FROM DATOS_PART_TRC
                 WHERE IDEPOL = nIdePol
                   AND NUMCERT = nNumCert
                   AND CODRAMOCERT = cCodRamoCert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam IN ('TARTRM', 'TRMFAB', 'TRMTERR', 'TRMCLO', 'TRMINU',
               'TRMPRU', 'TRMSIM', 'TRMAMP', 'TRMSUM') THEN
            BEGIN
                -- Tarifa de TRM.
                SELECT SUMAASEG -- Se incluyeron 'TRMSIM','TRMAMP' .
                  INTO nSumaAseg
                  FROM DATOS_PART_TRM
                 WHERE IDEPOL = nIdePol
                   AND NUMCERT = nNumCert
                   AND CODRAMOCERT = cCodRamoCert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TARDIVE' THEN
            -- Tarifa de Diversos
            BEGIN
                SELECT SUM(Valor)
                  INTO nSumaAseg
                  FROM DAT_PART_DIV
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TARPBAM' THEN
            -- PARAMETRO BUSCA SUMA PARA INTERRUPCION POR AVERIA DE MAQUINARIA
            BEGIN
                SELECT TOTAL
                  INTO nSumaAseg
                  FROM DAT_PART_NEG
                 WHERE IDEPOL = nIdePol
                   AND NUMCERT = nNumCert
                   AND CodRamoCert = cCodRamoCert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TARTRANCEG' THEN
            BEGIN
                SELECT NVL(valuacion, 0)
                  INTO nSumaAseg
                  FROM dat_tipotrans_pol
                 WHERE IdePol = nIdePol;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
        ELSIF cParam = 'TARTRANCE' THEN
            BEGIN
                SELECT NVL(valuacion, 0)
                  INTO nSumaAseg
                  FROM dat_tipotrans_pol
                 WHERE IdePol = nIdePol;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
            RETURN(nSumaAseg);
            -- Vida
        ELSIF cParam IN
              ('BPREMUER', 'SUMAEDAD', 'SUMATASA', 'FACTPARE', 'BPREMUERUNI',
               'TARRENTA', 'TARRENTAUNI', 'TARTARD', 'TARTMPD', 'TMPRENOV',
               'TARIFABC', 'TARIFASSI', 'TASAEDAD') THEN
            nSumaAseg := PR_PRE_VIDA.PRE_SUMA(nIdePol,
                                              nNumCert,
                                              cCodProd,
                                              cCodPlan,
                                              cRevPlan,
                                              cCodRamoCert,
                                              cCodCobert,
                                              cParam,
                                              nIdeAseg);
        ELSIF cParam IN ('DPHIPOTE') THEN
            nSumaAseg := PR_DAT_PART_HIPOTECARIO.PRE_SUMA(nIdePol,
                                                          nNumCert,
                                                          cCodProd,
                                                          cCodPlan,
                                                          cRevPlan,
                                                          cCodRamoCert,
                                                          cCodCobert,
                                                          cParam,
                                                          nIdeAseg);
        ELSIF cParam IN ('BCATASIN', 'BNOCATASIN') THEN
            DECLARE
                NVALOR NUMBER(14, 2);
            BEGIN
                SELECT VALOR
                  INTO nSumaAseg
                  FROM DATOS_PART_INTERRUPCION_INCE
                 WHERE IdePol = nIdepol
                   AND NumCert = nNumcert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
        ELSIF cParam IN ('TRENTADS') THEN
            DECLARE
                nCantPagos NUMBER(3);
                nMtoRenta  NUMBER(14, 2);
                nPorcPago  NUMBER(7, 4);
            BEGIN
                SELECT R.CantPagos, R.mtorenta, R.porcpago
                  INTO nCantPagos, nMtoRenta, nPorcPago
                  FROM renta_invalidez_aseg R
                 WHERE R.IdeAseg = nIdeAseg
                   AND R.IdeCobert = nIdeCobert
                   AND R.IndRenta IN ('D', 'B') -- Discapacidad y Sobrevivencia
                   AND R.NumMod =
                       (SELECT MAX(R1.NumMod)
                          FROM RENTA_INVALIDEZ_ASEG R1
                         WHERE R.IdeCobert = R1.IdeCobert);
                nSumaAseg := (nMtoRenta * nPorcPago / 100); -- * nCantPagos ;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nSumaAseg := 0;
            END;
        ELSIF cParam IN ('CTARSASA', 'CTARSAOP') THEN
            nSumaAseg := PR_PRE_SALUD_TARIFA.PRE_SUMA(nIdePol,
                                                      cCodProd,
                                                      cCodPlan,
                                                      cRevPlan,
                                                      cCodRamoCert,
                                                      cCodCobert,
                                                      cParam,
                                                      nIdeAseg);
        END IF;
        RETURN(nSumaAseg);
    END;

    FUNCTION PRE_TASA(nIdePol      NUMBER,
                      nNumCert     NUMBER,
                      cCodProd     VARCHAR2,
                      cCodPlan     VARCHAR2,
                      cRevPlan     VARCHAR2,
                      cCodRamoCert VARCHAR2,
                      cCodCobert   VARCHAR2,
                      cParam       VARCHAR2,
                      nAsegurado   NUMBER,
                      nIdeBien     NUMBER,
                      nDedCobert   NUMBER,
                      nSumAseg     NUMBER,
                      nIdeDatTran  NUMBER) RETURN NUMBER IS

        nTasa         NUMBER(10, 6) := 0;
        cCodPais      VARCHAR2(3);
        cCodEstado    VARCHAR2(3);
        cCodCiudad    VARCHAR2(3);
        cCodMunicipio VARCHAR2(4);

        nCX           NUMBER(9, 4);
        nDX           NUMBER(12, 4);
        nMX           NUMBER(10, 4);
        nNx           NUMBER(13, 4);
        dFecNac       DATE;
        dFecIng       DATE;
        nPripur       NUMBER(15, 7);
        nPriCom       NUMBER(15, 7);
        cCodFormPago  VARCHAR2(1);
        cClaseRie     VARCHAR2(14);
        nfactorAjuste CERT_AJUSTE_TASA.FACTOR%TYPE;
        cTIPOPDCION   VARCHAR2(1);
        NPORCPART     NUMBER(6, 4);
        cDummy        VARCHAR2(3);
        v_tasa        NUMBER(14,6);

        CURSOR EST_CERT_T IS
            SELECT CodEst, ValEst
              FROM EST_CERT
             WHERE IdePol = nIdePol
               AND NumCert = nNumCert
               AND CodRamoCert = cCodRamoCert;

    BEGIN
        IF cParam = 'TARCASCO' THEN
            BEGIN
            SELECT CodPais, CodEstado, CodCiudad, CodMunicipio
            INTO cCodPais, cCodEstado, cCodCiudad, cCodMunicipio
            FROM CERTIFICADO
            WHERE IdePol = nIdePol
              AND NumCert = nNumCert;
            END;

            BEGIN
            SELECT Tasa
            INTO nTasa
            FROM TARIFA_AUCA TA, CERT_VEH CV
            WHERE TA.CodMarca = CV.CodMarca
              AND TA.CodModelo = CV.CodModelo
              AND TA.CodVersion = CV.CodVersion
              AND TA.AnoVeh = CV.AnoVeh
              AND CV.IdePol = nIdePol
              AND CV.NumCert = nNumCert
              AND TA.CodProd = cCodProd
              AND TA.CodRamo = cCodRamoCert
              AND TA.CodPlan = cCodPlan
              AND TA.RevPlan = cRevPlan
              AND TA.CodCobert = cCodCobert
              AND (TA.CodPais = cCodPais OR cCodPais Is NULL)
              AND (TA.CodEstado = cCodEstado OR cCodEstado Is NULL)
              AND (TA.CodCiudad = cCodCiudad OR cCodCiudad Is NULL)
              AND (TA.CodMunicipio = cCodMunicipio OR
                   cCodMunicipio Is NULL)
              and exists (select 'S' from Inspeccion I
                          where I.NumExp = cv.Numexp
                            and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nTasa := 0;
            END;
            RETURN(nTasa);
         ----------------------- TARIFICACION POR TASA
         -- HUMBERTO CHAHIN
         ELSIF cParam IN ('TARAUTFOR') THEN
            BEGIN
            SELECT ROUND(T.TASA,4)
            INTO v_tasa
            FROM poliza p, cert_ramo cr, cert_veh c, TARIFA_AUT T
            WHERE p.idepol         = cr.idepol
              and cr.idepol        = c.idepol
              and cr.numcert       = c.numcert
              and cr.codramocert   = c.codramocert
              and p.codprod        = t.codprod
              and cr.codramocert   = t.codramoplan
              and cr.codplan       = t.codplan
              and cr.revplan       = t.revplan
              and T.desde          = ( select max(desde) from TARIFA_AUT
                                        where CodProd   = T.CODPROD
                                        AND CodRamoPlan = T.CODRAMOPLAN
                                        AND CodPlan     = T.CODPLAN
                                        AND RevPlan     = T.REVPLAN
                                        AND Codcobert   = T.CODCOBERT
                                        AND T.CODPROD     = cCodProd
                                        AND T.CODRAMOPLAN = cCodPlan
                                        AND T.REVPLAN     = cRevPlan
                                        AND T.CODCOBERT   = cCodCobert
                                        AND DESDE       < TO_DATE(SYSDATE,'DD/MM/YYYY') + 1
                                        AND Oficina     = DECODE(Oficina     ,'%',oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = P.IDEPOL))
                                        AND Marca       = DECODE(Marca       ,'%',Marca       ,C.CodMarca)
                                        AND Clase       = DECODE(Clase       ,'%',Clase       ,C.ClaseVeh)
                                        AND Categoria   = DECODE(Categoria   ,'%',Categoria   ,C.Clase)
                                        AND Subcategoria= DECODE(Subcategoria,'%',Subcategoria,C.Subcategoria)
                                        AND Cilindrada  = DECODE(cilindrada  ,0  ,cilindrada  ,C.codpotencia)
                                        AND nvl(Modelo_inicial,0) <= c.AnoVeh
                                        AND decode(Modelo_final,0,9999,Modelo_final)    >= c.AnoVeh
                                        AND Sumaseg_ini                                 <= c.Valor_total
                                        AND decode(Sumaseg_fin,0,999999999,Sumaseg_fin) >= c.Valor_total
                                        AND exists (select 'S' from Inspeccion I where I.NumExp = c.Numexp and i.tipoexp = 'SU'))
             AND T.Oficina        = DECODE(T.Oficina    ,'%',T.oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = P.IDEPOL))
             AND C.IdePol         = nIdepol
             AND C.NumCert        = nNumcert
             AND T.CODPROD        = cCodProd
             AND T.CODRAMOPLAN    = cCodPlan
             AND T.REVPLAN        = cRevPlan
             AND T.CODCOBERT      = cCodCobert
             --AND T.Tipo_Veh        = DECODE(T.Tipo_Veh    ,'%',T.Tipo_Veh    ,C.Tipomodelo)
             AND T.Clase           = DECODE(T.Clase       ,'%',T.Clase       ,C.ClaseVeh)
             AND T.Marca           = DECODE(T.Marca       ,'%',T.Marca       ,C.CodMarca)
             AND T.Categoria       = DECODE(T.Categoria   ,'%',T.Categoria   ,C.Clase)
             AND T.Subcategoria    = DECODE(T.Subcategoria,'%',T.Subcategoria,C.Subcategoria)
             AND T.Cilindrada      = DECODE(T.cilindrada  ,0  ,T.cilindrada  ,C.codpotencia)
             AND nvl(T.Modelo_inicial,0) <= c.AnoVeh
             AND decode(T.Modelo_final,0,9999,T.Modelo_final) >= c.AnoVeh
             AND T.Sumaseg_ini    <= c.Valor_total
             AND decode(T.Sumaseg_fin,0,999999999,T.Sumaseg_fin)    >= c.Valor_total
             AND exists (select 'S' from Inspeccion I where I.NumExp = c.Numexp and i.tipoexp = 'SU');
            EXCEPTION WHEN OTHERS THEN
                 v_tasa         := 0;
            END;
            RETURN(V_Tasa);
         -- ****    NUEVA TARIFA AGOSTO 2021   
         ELSIF cParam IN ('TARIESGO') THEN
            --  Coberturas a nivel de  ASEGURADO
            IF NVL(nAsegurado,0) > 0 THEN
                 BEGIN
                  SELECT T.TasaMinTecnica
                  INTO   v_tasa
                  FROM  POLIZA P, TARIFA_REGIONAL_NIVEL_RIESGO T, ASEGURADO A
                  WHERE P.IdePol          = nIdepol
                  AND   T.CODPROD         = cCodProd
                  AND   T.CodPlan         = cCodPlan
                  AND   T.REVPLAN         = cRevPlan
                  AND   T.CODRAMOPLAN     = cCodRamoCert
                  AND   T.CodOfi          = P.CodOfiSusc
                  AND   T.CodCobert       = cCodCobert
                  AND   A.IdeAseg         = nAsegurado
                  AND   T.NivelRiesgo     = A.NivelRiesgo;
                EXCEPTION WHEN OTHERS THEN
                     v_tasa         := 0;
                END;
            ELSE    --   Coberturas a nivel de  Certificados   
                BEGIN
                  SELECT T.TasaMinTecnica
                  INTO   v_tasa                  
                  FROM  POLIZA P, CERTIFICADO C, TARIFA_REGIONAL_NIVEL_RIESGO T
                  WHERE P.IdePol          = nIdepol
                  AND   C.IdePol          = P.IdePol
                  AND   C.NumCert         = nNumcert
                  AND   T.CODPROD         = cCodProd
                  AND   T.CodPlan         = cCodPlan
                  AND   T.REVPLAN         = cRevPlan
                  AND   T.CODRAMOPLAN     = cCodRamoCert
                  AND   T.CodOfi          = P.CodOfiSusc                  
                  AND   T.CodCobert       = cCodCobert
                  AND   T.NivelRiesgo     = C.NivelRiesgo;
                EXCEPTION WHEN OTHERS THEN
                     v_tasa         := 0;
                END;
            END IF;    
            RETURN(V_Tasa);

       ELSIF cParam IN ('TARGRFOR') THEN                   -------  TARIFICACION RUBROS GENERALES
            BEGIN
            SELECT ROUND(TG.TASA,4)
            INTO v_tasa
            from BIEN_CERT BC, COBERT_BIEN CB, poliza PO, TARIFA_GRL TG
            WHERE BC.IDEPOL         = nIdepol
              AND BC.Idebien        = nIdeBien
              AND BC.IDEBIEN        = CB.IDEBIEN
              AND BC.IDEPOL         = PO.IDEPOL
              AND TG.CODPROD        = cCodProd
              AND TG.CODRAMOPLAN    = cCodRamoCert
              AND TG.REVPLAN        = cRevPlan
              AND TG.CODCOBERT      = cCodCobert
              AND TG.CODPLAN        = cCodPlan
              AND CB.IDECOBERT      = nIdeDatTran    -- SE UTILIZA ESTE CAMPO EN VEZ DE nIdeCobert
              AND TG.desde          = ( select max(desde) from TARIFA_GRL
                                        WHERE BC.IDEPOL         = nIdepol
                                          AND BC.IDEBIEN        = CB.IDEBIEN
                                          AND BC.IDEPOL         = PO.IDEPOL
                                          AND TG.CODPROD        = cCodProd
                                          AND TG.CODRAMOPLAN    = cCodRamoCert
                                          AND TG.REVPLAN        = cRevPlan
                                          AND TG.CODCOBERT      = cCodCobert
                                          AND TG.CODPLAN        = cCodPlan
                                          AND CB.IDECOBERT      = nIdeDatTran    --nIdeCobert
                                          AND DESDE       < TO_DATE(SYSDATE,'DD/MM/YYYY') + 1
                                          AND Oficina     = DECODE(Oficina     ,'%',oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = PO.IDEPOL))
                                          AND Sumaseg_ini                                 <= BC.MTOVALBIENMONEDA
                                          AND decode(Sumaseg_fin,0,999999999,Sumaseg_fin) >= BC.MTOVALBIENMONEDA)

              AND TG.Oficina        = DECODE(TG.Oficina    ,'%',TG.oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = PO.IDEPOL))
              AND TG.Sumaseg_ini    <= BC.MTOVALBIENMONEDA
              AND decode(TG.Sumaseg_fin,0,999999999,TG.Sumaseg_fin) >= BC.MTOVALBIENMONEDA;
            EXCEPTION WHEN OTHERS THEN
                  v_tasa         := 0;
            END;
            RETURN(V_Tasa);

        ELSIF cParam = 'TARTRAN' THEN
            -- |----------------> Tarifa de DECLARACIONES
            BEGIN
                --                    Transporte Maritimo
                DECLARE
                    nRecaEdad          NUMBER(11, 5);
                    cGrupMerc          VARCHAR2(1);
                    nAnoBuque          NUMBER(4);
                    nTonelaje          NUMBER(10);
                    cIndEdad           VARCHAR2(1);
                    cIndnoclasificado  VARCHAR2(1);
                    cIndTrasBordo      VARCHAR2(1);
                    cIndBajoTonelaje   VARCHAR2(1);
                    cGrupBandera       VARCHAR2(1);
                    nAno               NUMBER(4);
                    nEdadBuque         NUMBER(4);
                    cCodBuque          VARCHAR2(4);
                    nRecaNoclasificado NUMBER(11, 5);
                    nRecaTrasbordo     NUMBER(11, 5);
                    nRecaBajotonelaje  NUMBER(11, 5);
                    nRecaBarcaza       NUMBER(11, 5);
                    nRecaGuerra        NUMBER(11, 5);
                    nPorcRecargo       NUMBER(10, 6) := 0;
                BEGIN
                    BEGIN
                        SELECT D.Tasa, T.GRUPO
                          INTO nTasa, cGrupMerc
                          FROM TIPO_MERCANCIA T, DECLARACION_TRANSPORTE D
                         WHERE T.TipoMerc = D.TipoMercancia
                           AND D.IdePol = nIdePol
                           AND D.NUMCERT = nNumcert
                           AND D.CODRAMOCERT = CCodRamoCert;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            cGrupMerc := NULL;
                            nTasa     := 0;
                        WHEN TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'Registro duplicado para TIPO_MERCANCIA');
                    END;
                    BEGIN
                        SELECT B.Anocontru,
                               B.Tonelaje,
                               D.IndEdad,
                               D.Indnoclasificado,
                               D.IndTrasBordo,
                               D.Indbajotonelaje,
                               BB.GrupBan
                          INTO nAnoBuque,
                               nTonelaje,
                               cIndEdad,
                               cIndnoclasificado,
                               cIndTrasBordo,
                               cindbajotonelaje,
                               cGrupBandera
                          FROM BUQUES                 B,
                               DECLARACION_TRANSPORTE D,
                               BANDERA_BUQUE          BB
                         WHERE IDEPOL = nIdepol
                           AND NUMCERT = nNumcert
                           AND CODRAMOCERT = cCodRamoCert
                           AND B.CODIGO = D.CODBUQUE
                           AND B.BANDERA = BB.CODBANDERA;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            dbms_output.put_line('NO EXISTEN DATOS DE LA DECLARACION ');
                            NULL;
                        WHEN TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'Registro duplicado para BUQUES');
                    END;
                    BEGIN
                        SELECT SUBSTR(TO_CHAR(SYSDATE, 'DD/MM/YYYY'), 7, 4)
                          INTO nAno
                          FROM DUAL;
                        nEdadBuque := (NVL(nAno, 0) - NVL(nAnoBuque, 0));
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                        WHEN TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'Registro duplicado para DUAL');
                    END;
                    BEGIN
                        SELECT RecaEdad
                          INTO nRecaEdad
                          FROM DAT_TRANSPORTE_POL
                         WHERE IDEPOL = nIdePol
                           AND IdeDatTran = nIdeDatTran;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            nRecaEdad := 0;
                        WHEN TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'Registro duplicado para DAT_TRANSPORTE_POL');
                    END;
                    IF nRecaEdad = 0 THEN
                        IF cIndEdad = 'S' THEN
                            BEGIN
                                SELECT NVL(PorcRecargo, 0) ---------------- [Recargo por Edad]
                                  INTO nPorcRecargo
                                  FROM RECAR_BUQUES
                                 WHERE TIPORECARGO = 'E'
                                   AND nEdadBuque >= AnoContruDESDE
                                   AND nEdadBuque <= AnoContruHASTA
                                   AND TipoBandera = cGrupBandera
                                   AND TipoMerc = cGrupMerc;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    nPorcRecargo := 0;
                                WHEN TOO_MANY_ROWS THEN
                                    RAISE_APPLICATION_ERROR(-20100,
                                                            'Registro duplicado para Recargo por Edad');
                            END;
                            PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                           'RECTRAN',
                                                           nPorcRecargo,
                                                           nNumCert,
                                                           'E');
                        END IF;
                    ELSE
                        nPorcRecargo := nRecaEdad;
                        PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                       'RECTRAN',
                                                       nPorcRecargo,
                                                       nNumCert,
                                                       'E');
                    END IF;
                    BEGIN
                        SELECT NVL(RecaNoclasificado, 0)
                          INTO nRecaNoclasificado
                          FROM DAT_TRANSPORTE_POL
                         WHERE IDEPOL = nIdePol
                           AND IdeDatTran = nIdeDatTran;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            nRecaNoclasificado := 0;
                        WHEN TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'Registro duplicado para DAT_TRANSPORTE_POL');
                    END;
                    IF nRecaNoclasificado = 0 THEN
                        IF cIndnoclasificado = 'S' THEN
                            ------------------ [Recargo por Noclasificado]
                            BEGIN
                                SELECT NVL(PorcRecargo, 0)
                                  INTO nPorcRecargo
                                  FROM RECAR_BUQUES
                                 WHERE TIPORECARGO = 'N';
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    nPorcRecargo := 0;
                                WHEN TOO_MANY_ROWS THEN
                                    RAISE_APPLICATION_ERROR(-20100,
                                                            'Registro duplicado para Recargo por Noclasificado');
                            END;
                            PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                           'RECTRAN',
                                                           nPorcRecargo,
                                                           nNumCert,
                                                           'N');
                        END IF;
                    ELSE
                        nPorcRecargo := nRecaNoclasificado; --MANDAR A GENERAR EL RECARGO EN LA TABLA
                        PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                       'RECTRAN',
                                                       nPorcRecargo,
                                                       nNumCert,
                                                       'N');
                    END IF;
                    BEGIN
                        SELECT nvl(RecaTrasbordo, 0)
                          INTO nRecaTrasbordo
                          FROM DAT_TRANSPORTE_POL
                         WHERE IDEPOL = nIdePol
                           AND IdeDatTran = nIdeDatTran;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            nRecaTrasbordo := 0;
                        WHEN TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'Registro duplicado para DAT_TRANSPORTE_POL');
                    END;
                    IF nRecaTrasbordo = 0 THEN
                        IF cIndTrasBordo = 'S' THEN
                            ------------------------ [Recargo por trasbordo]
                            BEGIN
                                SELECT NVL(PorcRecargo, 0)
                                  INTO nPorcRecargo
                                  FROM RECAR_BUQUES
                                 WHERE TIPORECARGO = 'T';
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    nPorcRecargo := 0;
                                WHEN TOO_MANY_ROWS THEN
                                    RAISE_APPLICATION_ERROR(-20100,
                                                            'Registro duplicado para Recargo por trasbordo');
                            END;
                            PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                           'RECTRAN',
                                                           nPorcRecargo,
                                                           nNumCert,
                                                           'T');
                        END IF;
                    ELSE
                        nPorcRecargo := nRecaTrasbordo; --MANDAR A GENERAR EL RECARGO EN LA TABLA
                        PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                       'RECTRAN',
                                                       nPorcRecargo,
                                                       nNumCert,
                                                       'T');
                    END IF;
                    BEGIN
                        SELECT NVL(RecaBajotonelaje, 0)
                          INTO nRecaBajotonelaje
                          FROM DAT_TRANSPORTE_POL
                         WHERE IDEPOL = nIdePol
                           AND IdeDatTran = nIdeDatTran;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            nRecaBajotonelaje := 0;
                    END;
                    IF nRecaBajotonelaje = 0 THEN
                        IF cindbajotonelaje = 'S' THEN
                            ---------------------- [Recargo por bajotonelaje]
                            BEGIN
                                SELECT NVL(PorcRecargo, 0)
                                  INTO nPorcRecargo
                                  FROM RECAR_BUQUES
                                 WHERE TIPORECARGO = 'B'
                                   AND nTonelaje >= tonelajemin
                                   AND nTonelaJe <= tonelajemax;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    nPorcRecargo := 0;
                                WHEN TOO_MANY_ROWS THEN
                                    RAISE_APPLICATION_ERROR(-20100,
                                                            'Registro duplicado para Recargo por bajotonelaje');
                            END;
                            PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                           'RECTRAN',
                                                           nPorcRecargo,
                                                           nNumCert,
                                                           'B');
                        END IF;
                    ELSE
                        nPorcRecargo := nRecaBajotonelaje; --MANDAR A GENERAR EL RECARGO EN LA TABLA
                        PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                       'RECTRAN',
                                                       nPorcRecargo,
                                                       nNumCert,
                                                       'B');
                    END IF;
                    BEGIN
                        SELECT RecaBarcaza
                          INTO nRecaBarcaza
                          FROM DAT_TRANSPORTE_POL
                         WHERE IDEPOL = nIdePol
                           AND IdeDatTran = nIdeDatTran;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            nRecaBarcaza := 0;
                        WHEN TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'Registro duplicado para DAT_TRANSPORTE_POL');
                    END;
                    IF nRecaBarcaza = 0 THEN
                        IF cindbajotonelaje = 'S' THEN
                            ---------------------- [Recargo por barcaza]
                            BEGIN
                                SELECT NVL(PorcRecargo, 0)
                                  INTO nPorcRecargo
                                  FROM RECAR_BUQUES
                                 WHERE TIPORECARGO = 'Z';
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    nPorcRecargo := 0;
                                WHEN TOO_MANY_ROWS THEN
                                    RAISE_APPLICATION_ERROR(-20100,
                                                            'Registro duplicado para Recargo por barcaza');
                            END;
                            PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                           'RECTRAN',
                                                           nPorcRecargo,
                                                           nNumCert,
                                                           'Z');
                        END IF;
                    ELSE
                        nPorcRecargo := nRecaBarcaza; --MANDAR A GENERAR EL RECARGO EN LA TABLA
                        PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                       'RECTRAN',
                                                       nPorcRecargo,
                                                       nNumCert,
                                                       'Z');
                    END IF;
                    BEGIN
                        SELECT NVL(RecaGuerra, 0)
                          INTO nRecaGuerra
                          FROM DAT_TRANSPORTE_POL
                         WHERE IDEPOL = nIdePol
                           AND IdeDatTran = nIdeDatTran;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            nRecaGuerra := 0;
                        WHEN TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'Registro duplicado para DAT_TRANSPORTE_POL');
                    END;
                    IF nRecaGuerra = 0 THEN
                        IF cindbajotonelaje = 'S' THEN
                            ---------------------- [Recargo por Guerra]
                            BEGIN
                                SELECT NVL(PorcRecargo, 0)
                                  INTO nPorcRecargo
                                  FROM RECAR_BUQUES
                                 WHERE TIPORECARGO = 'G';
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    nPorcRecargo := 0;
                                WHEN TOO_MANY_ROWS THEN
                                    RAISE_APPLICATION_ERROR(-20100,
                                                            'Registro duplicado para Recargo por Guerra');
                            END;
                            PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                           'RECTRAN',
                                                           nPorcRecargo,
                                                           nNumCert,
                                                           'G');
                        END IF;
                    ELSE
                        nPorcRecargo := nRecaGuerra; --MANDAR A GENERAR EL RECARGO EN LA TABLA
                        PR_RECADCTO_AUTOM.PRE_RECADCTO(nIdePol,
                                                       'RECTRAN',
                                                       nPorcRecargo,
                                                       nNumCert,
                                                       'G');
                    END IF;
                END;
                RETURN(nTasa);
            END;
        ELSIF cParam = 'TARMAQU' THEN
            -- Tarifa de Averia de Maquinarias.
            DECLARE
                nFVigencia varchar2(1);
                cCodBien   VARCHAR2(4);
                cClaseBien VARCHAR2(3);
            BEGIN
                BEGIN
                    SELECT V.CODLVAL
                      INTO nFVigencia
                      FROM POLIZA P, LVAL V
                     WHERE V.TipoLval = 'FVIGEMAQ'
                       AND P.Idepol = nIdepol
                       AND V.Codlval = P. TipoVig;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nFVigencia := NULL;
                END;
                BEGIN
                    SELECT CODBIEN, CLASEBIEN
                      INTO cCodBien, cClaseBien
                      FROM BIEN_CERT
                     WHERE IDEBIEN = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cCodbien   := NULL;
                        cClasebien := NULL;
                END;

                BEGIN
                    SELECT Tasa
                      INTO nTasa
                      FROM TIPO_MAQUINARIAS
                     WHERE CODBIEN = cCodBien
                       AND CLASEBIEN = cClaseBien
                       AND CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa := 0;
                END;
                IF nFVigencia = 'A' THEN
                    nTasa := (NVL(nTasa, 0) * 1.0);
                ELSIF nFVigencia IN ('B', 'C', 'M', 'T') THEN
                    nTasa := (NVL(nTasa, 0) * 0.5);
                ELSIF nFVigencia = 'S' THEN
                    nTasa := (NVL(nTasa, 0) * 0.7);
                END IF;
            END;
            RETURN(nTasa);
        ELSIF cParam = 'ASALTO' THEN
            DECLARE
                nPrimaMinima    tarifa_robo_tecnico.PrimaMinima%TYPE;
                nSUMAASEGMONEDA cobert_cert.SUMAASEGMONEDA%TYPE;
                nfactor         tarifa_robo_tecnico.Factor%TYPE;
                nTasaRobo       tarifa_robo_tecnico.tasa%TYPE;
                nprimafactor    NUMBER;
                nprima          NUMBER;

            BEGIN
                /*
                IF  nSumAseg != 0 THEN
                    BEGIN
                       select SUMAASEGMONEDA    ,  SUMAASEGMONEDA
                       into   nSUMAASEGMONEDA   ,  nSUMAASEG
                       FROM   COBERT_CERT
                       WHERE  IDEPOL          = nIdePOL
                       AND    NUMCERT         = nNumcert
                       AND    CODRAMOCERT     = cCodRamocert
                       AND    CODPLAN         = cCodPlan
                       AND    REVPLAN         = cRevPlan
                       AND    CODCOBERT       = cCodCobert;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                       NULL;
                    END;

                    BEGIN
                      SELECT Tasa , Primaminima  , factor
                      INTO   nTasaRobo, nPrimaMinima , nfactor
                      FROM   tarifa_robo_tecnico
                      WHERE  CODPROD           = cCodProd
                      AND    CODRAMOPLAN       = cCodramoCert
                      AND    CODPLAN           = ccodplan
                      AND    REVPLAN           = cRevPlan
                      AND    CODCOBERT         = cCodCobert;
                   EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                          nTasa           := 0;
                   END;

                   nprimaminima := nPrimaMinima * nfactor;
                   nprimafactor := nSumAseg * ntasarobo/100;


                   IF   nPrimafactor <  nPrimaMinima then
                        nprima := nPrimaMinima;
                        nTasa  := nSUMASEG/nprima;
                   ELSE
                        nTasa := nTasarobo;
                   END IF;

                END IF;  */
                NULL;
                RETURN(ntASA);
            END;

        ELSIF cParam = 'TARTRDEX' THEN
            -- --------> Tasa de Extension de Cobertura en Transporte
            BEGIN
                DECLARE
                    nTasaRecar        NUMBER(11, 5);
                    cGrupMerc         VARCHAR2(1);
                    nAnoBuque         NUMBER(4);
                    nTonelaje         NUMBER(10);
                    cIndEdad          VARCHAR2(1);
                    cIndnoclasificado VARCHAR2(1);
                    cIndTrasBordo     VARCHAR2(1);
                    cIndBajoTonelaje  VARCHAR2(1);
                    cGrupBandera      VARCHAR2(1);
                    nAno              NUMBER(4);
                    nEdadBuque        NUMBER(4);
                    cPARAMCOBEXT      VARCHAR2(20);
                    nFecLlegada       DATE;
                    nFecEntrada       DATE;
                    nFechamayor       DATE;
                    nNumDias          NUMBER(4);
                    nTasaTotal        NUMBER(11, 6);
                    cLineaObarco      VARCHAR2(10);
                    cCodBuque         VARCHAR2(4);
                BEGIN
                    BEGIN
                        SELECT D.Tasa, T.GRUPO
                          INTO nTasa, cGrupMerc
                          FROM TIPO_MERCANCIA T, DECLARACION_TRANSPORTE D
                         WHERE T.TipoMerc = D.TipoMercancia
                           AND D.IdePol = nIdePol
                           AND D.NUMCERT = nNumcert
                           AND D.CODRAMOCERT = CCodRamoCert;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            cGrupMerc := NULL;
                            nTasa     := 0;
                    END;
                    /*    BEGIN
                      SELECT PARAMCOBEXT
                      INTO  cPARAMCOBEXT
                      FROM RAMO_PLAN_PROD
                      WHERE CODPROD = cCodProd
                      AND   REVPLAN  = cREVPLAN
                      AND   CODPLAN = cCODPLAN;
                      dbms_output.put_line('CONSEGUI PARAMCOBEXT:'||cPARAMCOBEXT);
                    EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                           cPARAMCOBEXT :=NULL;
                           dbms_output.put_line('CONSEGUI PARAMCOBEXT'||cPARAMCOBEXT||' PARAMCOBEXT:'||cCODCOBERT );
                    END;
                    IF cPARAMCOBEXT = cCODCOBERT THEN  */
                    BEGIN
                        SELECT FecLlegada,
                               FecEntrada,
                               LineaObarco,
                               CodBuque
                          INTO nFecLlegada,
                               nFecEntrada,
                               cLineaObarco,
                               cCodBuque
                          FROM DECLARACION_TRANSPORTE
                         WHERE IDEPOL = nIdepol
                           AND NUMCERT = nNumcert
                           AND CODRAMOCERT = cCodRamoCert;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
                    IF cLineaObarco IS NOT NULL THEN
                        nFechaMayor := (TRUNC(nFecLlegada) + 30);
                    ELSIF cCodBuque IS NOT NULL THEN
                        nFechaMayor := (TRUNC(nFecLlegada) + 60);
                    END IF;

                    nNumDias := nFecEntrada - nFechaMayor;

                    IF NVL(nNumDias, 0) >= 1 AND NVL(nNumDias, 0) <= 30 THEN
                        nTasa := NVL(nTasa, 0) / 3;
                    ELSIF NVL(nNumDias, 0) > 30 AND NVL(nNumDias, 0) <= 60 THEN
                        nTasa := (NVL(nTasa, 0) / 3) * 2;
                    ELSIF NVL(nNumDias, 0) > 60 THEN
                        nTasa := (NVL(nTasa, 0) / 3) * 3;
                    ELSE
                        nTasa := 27;
                    END IF;
                    --       END IF;
                END;
            END;
            RETURN(nTasa);
        ELSIF cParam = 'TAREST' THEN
            -- Tarifa por valor estadistico
            BEGIN
                FOR E IN EST_CERT_T LOOP
                    nTasa := NVL(nTasa, 0) + NVL(PR_TARIFA_EST.PRE_TASA(cCodProd,
                                                                        cCodPlan,
                                                                        cRevPlan,
                                                                        cCodRamoCert,
                                                                        cCodCobert,
                                                                        E.CodEst,
                                                                        E.ValEst),
                                                 0);

                END LOOP;
            END;
            RETURN(nTasa);
        ELSIF cParam = 'APCLAS' THEN
            -- Tarifa por valor estadistico para Accidentes Personales.
            BEGIN
                BEGIN
                    SELECT MAX(CLASERIE)
                      INTO cClaseRie
                      FROM DATOS_PARTICULARES_AP
                     WHERE IDEASEG = nAsegurado;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                    WHEN TOO_MANY_ROWS THEN
                        dbms_output.put_line('DATOS_PARTICULARES_AP DUPLICADOS ');
                        NULL;
                END;
                IF cClaseRie IS NOT NULL THEN
                    nTasa := NVL(nTasa, 0) + NVL(PR_TARIFA_EST.PRE_TASA(cCodProd,
                                                                        cCodPlan,
                                                                        cRevPlan,
                                                                        cCodRamoCert,
                                                                        cCodCobert,
                                                                        '00500',
                                                                        cClaseRie),
                                                 0);
                END IF;
            END;
            RETURN(nTasa);

        ELSIF cParam = 'TARCASTV' THEN
            BEGIN
                SELECT CodPais, CodEstado, CodCiudad, CodMunicipio
                  INTO cCodPais, cCodEstado, cCodCiudad, cCodMunicipio
                  FROM CERTIFICADO
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert;
            END;
            BEGIN
                SELECT Tasa
                  INTO nTasa
                  FROM TARIFA_AUCA_TIPO_VEH TA, CERT_VEH CV
                 WHERE TA.TipoVeh = CV.TipoVeh
                   AND TA.AnoTarif = CV.AnoVeh
                   AND CV.IdePol = nIdePol
                   AND CV.NumCert = nNumCert
                   AND TA.CodProd = cCodProd
                   AND TA.CodRamo = cCodRamoCert
                   AND TA.CodPlan = cCodPlan
                   AND TA.RevPlan = cRevPlan
                   AND TA.CodCobert = cCodCobert
                   AND (TA.CodPais = cCodPais OR cCodPais Is NULL)
                   AND (TA.CodEstado = cCodEstado OR cCodEstado Is NULL)
                   AND (TA.CodCiudad = cCodCiudad OR cCodCiudad Is NULL)
                   AND (TA.CodMunicipio = cCodMunicipio OR
                       cCodMunicipio Is NULL)
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nTasa := 0;
            END;
            RETURN(nTasa);
        ELSIF cParam = 'TARRCV' THEN
            BEGIN
                SELECT Tasa
                  INTO nTasa
                  FROM TARIFA_RCV TR, CERT_VEH CV
                 WHERE TR.ClaseVeh = CV.ClaseVeh
                   AND CV.IdePol = nIdePol
                   AND CV.NumCert = nNumCert
                   AND TR.CodProd = cCodProd
                   AND TR.CodRamo = cCodRamoCert
                   AND TR.CodPlan = cCodPlan
                   AND TR.RevPlan = cRevPlan
                   AND TR.CodCobert = cCodCobert
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nTasa := 0;
            END;
            RETURN(nTasa);
        ELSIF cParam = 'TASMAX' THEN
            BEGIN
                SELECT TasaMax
                  INTO nTasa
                  FROM COBERT_PLAN_PROD
                 WHERE CodProd = cCodProd
                   AND CodRamoPlan = cCodRamoCert
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodCobert = cCodCobert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nTasa := 0;
            END;
            RETURN(nTasa);
        ELSIF cParam = 'TRANVET' THEN
            -- Transporte Terrestre
            BEGIN
                SELECT NVL(MAX(Tasa), 0)
                  INTO nTasa
                  FROM MERCANCIA_TRANS_GEN
                 WHERE IdePol = nIdePol;
            END;
        ELSIF cParam IN ('TAREQUIP', 'EQUIPMOT') THEN
            DECLARE
                nTasaBasica       NUMBER(7, 4);
                nTasacampaplica   NUMBER(7, 4);
                nTasaampliacion   NUMBER(7, 4);
                nTasalimitacion   NUMBER(7, 4);
                nTasacircuntancia NUMBER(7, 4);
                nTasarecargo      NUMBER(7, 4);
                nTasadescuento    NUMBER(7, 4);
                nTasaVigencia     NUMBER(7, 4);
                nVigencia         NUMBER(3);
                nNumBien          NUMBER;
                cClaseBien        VARCHAR2(3);
                cCodBien          VARCHAR2(4);
                nTipoEquielect    NUMBER(5);
            BEGIN
                BEGIN
                    SELECT ClaseBien, CodBien, NumBien
                      INTO cClaseBien, cCodBien, nNumBien
                      FROM BIEN_CERT
                     WHERE IdeBien = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cClaseBien := NULL;
                        cCodBien   := NULL;
                END;

                BEGIN
                    SELECT TipoEquielect
                      INTO nTipoEquielect
                      FROM TARIFA_EQUIELECT
                     WHERE CodProd = cCodProd
                       and CodPlan = cCodPlan
                       and RevPlan = cRevPlan
                       and CodRamoPlan = cCodRamoCert
                       and ClaseBien = cClaseBien
                       AND CodBien = cCodBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTipoEquielect := NULL;
                END;

                BEGIN
                    SELECT TASA
                      INTO nTasaBasica -- Tasa Basica del equipo
                      FROM TASA_EQUIELECT
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND CLASEBIEN = cClaseBien
                       AND CODBIEN = cCodBien
                       AND nSumAseg >= DESDE
                       AND nSumAseg <= HASTA;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaBasica := 0;
                END;
                BEGIN
                    SELECT TASA
                      INTO nTasacampaplica -- Tasa del Campo de Aplicacion
                      FROM RECA_EQUIELECT TE, DATOS_PART_EQUIELECT DE
                     WHERE TE.CODTIPOFACTOR = DE.CODCAMPAPLICA
                       AND TE.CODFACTOR = 'CAMP'
                       AND TE.TIPOEQUIELECT = nTipoEquielect
                       AND DE.IDEBIEN = nIdeBien
                       AND DE.IdePol = nIdePol
                       AND TE.CODPROD = cCodProd
                       AND TE.CODPLAN = cCodPlan
                       AND TE.REVPLAN = cRevPlan
                       AND TE.CODRAMOPLAN = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasacampaplica := 0;
                END;
                BEGIN
                    SELECT TASA
                      INTO nTasaampliacion -- Tasa del Factor Ampliacion
                      FROM RECA_EQUIELECT TE, DATOS_PART_EQUIELECT DE
                     WHERE TE.CODTIPOFACTOR = DE.CODAMPLIACION
                       AND TE.CODFACTOR = 'AMPL'
                       AND TE.TIPOEQUIELECT = nTipoEquielect
                       AND DE.IDEBIEN = nIdeBien
                       AND DE.IdePol = nIdePol
                       AND TE.CODPROD = cCodProd
                       AND TE.CODPLAN = cCodPlan
                       AND TE.REVPLAN = cRevPlan
                       AND TE.CODRAMOPLAN = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaampliacion := 0;
                END;

                BEGIN
                    SELECT TASA
                      INTO nTasalimitacion -- Tasa del Factor Limitacion
                      FROM RECA_EQUIELECT TE, DATOS_PART_EQUIELECT DE
                     WHERE TE.CODTIPOFACTOR = DE.CODLIMITACION
                       AND TE.CODFACTOR = 'LIMI'
                       AND TE.TIPOEQUIELECT = nTipoEquielect
                       AND DE.IDEBIEN = nIdeBien
                       AND DE.IdePol = nIdePol
                       AND TE.CODPROD = cCodProd
                       AND TE.CODPLAN = cCodPlan
                       AND TE.REVPLAN = cRevPlan
                       AND TE.CODRAMOPLAN = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasalimitacion := 0;
                END;

                BEGIN
                    SELECT TASA
                      INTO nTasacircuntancia -- Tasa del Factor Circunstancia
                      FROM RECA_EQUIELECT TE, DATOS_PART_EQUIELECT DE
                     WHERE TE.CODTIPOFACTOR = DE.CODCIRCUNTANCIA
                       AND TE.CODFACTOR = 'CIRC'
                       AND TE.TIPOEQUIELECT = nTipoEquielect
                       AND DE.IDEBIEN = nIdeBien
                       AND DE.IdePol = nIdePol
                       AND TE.CODPROD = cCodProd
                       AND TE.CODPLAN = cCodPlan
                       AND TE.REVPLAN = cRevPlan
                       AND TE.CODRAMOPLAN = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasacircuntancia := 0;
                END;

                BEGIN
                    SELECT TASA
                      INTO nTasarecargo -- Tasa del Factor Recargo
                      FROM RECA_EQUIELECT TE, DATOS_PART_EQUIELECT DE
                     WHERE TE.CODTIPOFACTOR = DE.CODRECARGO
                       AND TE.CODFACTOR = 'RECA'
                       AND TE.TIPOEQUIELECT = nTipoEquielect
                       AND DE.IDEBIEN = nIdeBien
                       AND DE.IdePol = nIdePol
                       AND TE.CODPROD = cCodProd
                       AND TE.CODPLAN = cCodPlan
                       AND TE.REVPLAN = cRevPlan
                       AND TE.CODRAMOPLAN = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasarecargo := 0;
                END;

                BEGIN
                    SELECT TASA
                      INTO nTasadescuento -- Tasa del Factor Descuento
                      FROM RECA_EQUIELECT TE, DATOS_PART_EQUIELECT DE
                     WHERE TE.CODTIPOFACTOR = DE.CODDESCUENTO
                       AND TE.CODFACTOR = 'DESC'
                       AND TE.TIPOEQUIELECT = nTipoEquielect
                       AND DE.IDEBIEN = nIdeBien
                       AND DE.IdePol = nIdePol
                       AND TE.CODPROD = cCodProd
                       AND TE.CODPLAN = cCodPlan
                       AND TE.REVPLAN = cRevPlan
                       AND TE.CODRAMOPLAN = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasadescuento := 0;
                END;

                BEGIN
                    SELECT MONTHS_BETWEEN(FECFINVIG, FECINIVIG)
                      INTO nVIGENCIA
                      FROM POLIZA
                     WHERE IDEPOL = nIdePol;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nVigencia := 0;
                END;
                -----------------------------------------------------------
                -- Tasa aplicable por la vigencia de la poliza   ----------
                -----------------------------------------------------------
                IF nVigencia = 1 THEN
                    nTasaVigencia := 0.30;
                ELSIF nVigencia = 2 THEN
                    nTasaVigencia := 0.35;
                ELSIF nVigencia = 3 THEN
                    nTasaVigencia := 0.40;
                ELSIF nVigencia = 4 THEN
                    nTasaVigencia := 0.45;
                ELSIF nVigencia = 5 THEN
                    nTasaVigencia := 0.50;
                ELSIF nVigencia = 6 THEN
                    nTasaVigencia := 0.60;
                ELSIF nVigencia = 7 THEN
                    nTasaVigencia := 0.70;
                ELSIF nVigencia = 8 THEN
                    nTasaVigencia := 0.80;
                ELSIF nVigencia = 9 THEN
                    nTasaVigencia := 0.90;
                ELSIF nVigencia BETWEEN 10 AND 36 THEN
                    nTasaVigencia := 1;
                ELSIF nVigencia BETWEEN 37 AND 60 THEN
                    nTasaVigencia := 0.95;
                ELSIF nVigencia BETWEEN 61 AND 120 THEN
                    nTasaVigencia := 0.925;
                END IF;

                BEGIN
                    SELECT DECODE(nTasacampaplica, 0, 1, nTasacampaplica),
                           DECODE(nTasaampliacion, 0, 1, nTasaampliacion),
                           DECODE(nTasalimitacion, 0, 1, nTasalimitacion),
                           DECODE(nTasacircuntancia,
                                  0,
                                  1,
                                  nTasacircuntancia),
                           DECODE(nTasarecargo, 0, 1, nTasarecargo),
                           DECODE(nTasadescuento, 0, 1, nTasadescuento)
                      INTO nTasacampaplica,
                           nTasaampliacion,
                           nTasalimitacion,
                           nTasacircuntancia,
                           nTasarecargo,
                           nTasadescuento
                      FROM DUAL;
                END;

                nTasa := nTasaBasica * nTasacampaplica * nTasaampliacion *
                         nTasalimitacion * nTasacircuntancia * nTasarecargo *
                         nTasadescuento * nTasaVigencia;

                IF cParam = 'EQUIPMOT' THEN
                    -- Tasa motin, huelga y conmocion civil
                    nTasa := nTasa * 10 / 100;
                END IF;

                RETURN(nTasa);
            END;

            /********************************************************************************************
               Tarifa Equipos Electronicos
               -- Coberturas Adicionales
               -- 0.68                   Tasa terremoto (Fija)
               -- 1.00                   Tasa Ciclon (fija)
            *******************************************************************************************/
            ------------------------------------------------------
        ELSIF cParam IN ('TAREQPRX') THEN
            ----- TARIFA EQUIPOS ELECTRONICOS
            ------------------------------------------------------
            DECLARE
                nTasaBasica       NUMBER(7, 4);
                nTasacampaplica   NUMBER(7, 4);
                nTasaampliacion   NUMBER(7, 4);
                nTasalimitacion   NUMBER(7, 4);
                nTasacircuntancia NUMBER(7, 4);
                nTasarecargo      NUMBER(7, 4);
                nTasadescuento    NUMBER(7, 4);
                nTasaVigencia     NUMBER(7, 4);
                nVigencia         NUMBER(3);
                cClaseBien        VARCHAR2(3);
                cCodBien          VARCHAR2(4);
                nTipoEquielect    NUMBER(5);
                nAno              NUMBER(4);
                nNumBien          NUMBER;
                cCodTarifa        VARCHAR2(2);
                nEdadEquipo       NUMBER(4);

            BEGIN
                BEGIN
                    SELECT ClaseBien, CodBien, NumBien
                      INTO cClaseBien, cCodBien, nNumBien
                      FROM BIEN_CERT
                     WHERE IdeBien = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cClaseBien := NULL;
                        cCodBien   := NULL;
                END;
                /*
                IF  nAno IS NULL THEN
                    RAISE_APPLICATION_ERROR(-20100,'Debe Incluir A?o del Equipo'||
                                                   'nNumCert  '||NNUMCERT    ||
                                                   'codbien   '||cCodBien    ||
                                                   'clasebien '||cClaseBien  ||
                                                   'IdeBien '||nIdeBien);
                END IF; */

                BEGIN
                    nEdadEquipo := TO_NUMBER(to_CHAR(Sysdate, 'YYYY')) - nAno;
                END;
                ------------------------------------------------------
                ------- BUSCO EL TIPO DE EQUIPO ELECTRONICO ----------
                ------------------------------------------------------
                BEGIN
                    SELECT TipoEquielect
                      INTO nTipoEquielect
                      FROM TARIFA_EQUIELECT
                     WHERE CodProd = cCodProd
                       and CodPlan = cCodPlan
                       and RevPlan = cRevPlan
                       and CodRamoPlan = cCodRamoCert
                       and ClaseBien = cClaseBien
                       AND CodBien = cCodBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTipoEquielect := NULL;
                END;
                ---------------------------------
                ----  BUSCO LA TARIFA -----------
                ---------------------------------

                BEGIN
                    SELECT DISTINCT (CodTipoTarifa)
                      INTO cCodTarifa
                      FROM TASA_EQUIELECT
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND CLASEBIEN = cClaseBien
                       AND CODBIEN = cCodBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cCodTarifa := null;
                END;
                IF cCodTarifa = 'SA' THEN
                    BEGIN
                        SELECT TASA
                          INTO nTasaBasica
                          FROM TASA_EQUIELECT
                         WHERE CODPROD = cCodProd
                           AND CODPLAN = cCodPlan
                           AND REVPLAN = cRevPlan
                           AND CODRAMOPLAN = cCodRamoCert
                           AND CLASEBIEN = cClaseBien
                           AND CODBIEN = cCodBien
                           AND nSumAseg >= DESDE
                           AND nSumAseg <= HASTA;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            nTasaBasica := 0;
                    END;
                ELSIF cCodTarifa = 'EE' THEN
                    BEGIN
                        SELECT TASA
                          INTO nTasaBasica
                          FROM TASA_EQUIELECT
                         WHERE CODPROD = cCodProd
                           AND CODPLAN = cCodPlan
                           AND REVPLAN = cRevPlan
                           AND CODRAMOPLAN = cCodRamoCert
                           AND CLASEBIEN = cClaseBien
                           AND CODBIEN = cCodBien
                           AND nEdadEquipo BETWEEN DESDE AND HASTA;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            nTasaBasica := 0;
                    END;
                ELSE
                    RAISE_APPLICATION_ERROR(-20100,
                                            'TARIFA NO DEFINIDA CERT. CODBIEN CLASE NUMBIEN ' ||
                                            nNumCert || ' ' || nNumBien);
                END IF;
                -- nTasa := nTasabasica/100;
                nTasa := nTasabasica;
                RETURN(nTasa);
            END;
        ELSIF cParam IN ('TARAVI') THEN
            -- Tarifa de Aviacion.
            DECLARE
                cSiniestro VARCHAR2(1);
            BEGIN
                BEGIN
                    SELECT TA.TASA, CA.INDSINCINCO
                      INTO nTasa, cSiniestro
                      FROM TARIFA_AVIACION TA, CERT_AVI CA
                     WHERE TA.CODPROD = cCodProd
                       AND TA.CODPLAN = cCodPlan
                       AND TA.REVPLAN = cRevPlan
                       AND TA.CODRAMOPLAN = cCodRamoCert
                       AND TA.CODCOBERT = cCodCobert
                       AND CA.IDEPOL = nIdePol
                       AND CA.NUMCERT = nNumCert
                       AND TA.TIPOAVI = CA.TIPOAVI
                       AND TA.CODESTINADO = CA.CODDESTINADO
                       AND nSumAseg >= TA.RANGOMIN
                       AND nSumAseg <= TA.RANGOMAX;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa      := 0;
                        cSiniestro := NULL;
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20213,
                                                'IdePol    ' || nIdePol ||
                                                'COBERTURA ' || cCodCobert);
                END;
            END;
            RETURN(nTasa);

            /***************************************************************************/
        ELSIF cParam = 'TARCRISX' THEN
            -- Tarifa de Cristales y Letreros.
            DECLARE
                cCodBien   VARCHAR2(4);
                cClaseBien VARCHAR2(3);
            BEGIN
                BEGIN
                    SELECT CODBIEN, CLASEBIEN
                      INTO cCodBien, cClaseBien
                      FROM BIEN_CERT
                     WHERE IDEBIEN = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cCodbien   := NULL;
                        cClasebien := NULL;
                END;

                BEGIN
                    SELECT DISTINCT (TC.TASA)
                      INTO nTasa
                      FROM TARIFA_CRISTALES     TC,
                           DATOS_PART_CRISTALES DC,
                           BIEN_CERT            BC
                     WHERE DC.IDEPOL = nIdePol
                       AND DC.NUMCERT = nNumCert
                       AND DC.IDEBIEN = nIdeBien
                       AND TC.CODPROD = cCodProd
                       AND TC.CODPLAN = cCodPlan
                       AND TC.RevPlan = cRevPlan
                       AND TC.CodRamoPlan = cCodRamoCert
                       AND TC.CodCobert = cCodCobert
                       AND TC.CodBien = cCodBien
                       AND TC.ClaseBien = cClaseBien
                       AND BC.IDEBIEN = DC.IDEBIEN;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa := 0;
                END;
            END;
            RETURN(nTasa);
            /****************************************************************************/
        ELSIF cParam IN ('RESPPRE', 'RESPPRO') THEN
            -- TARRESP Tarifa de Responsabilidad Civil.
            DECLARE
                nCodTipoEmpresa   NUMBER(5);
                nTasaDcto         NUMBER(9, 6);
                cAumentoLimite    CHAR(1);
                cAumentoLimiteMax CHAR(1);
                nTasaMax          NUMBER(9, 6);
                nTasaReca         NUMBER(9, 6);
                nSumaMaxima       NUMBER(14, 2);
            BEGIN
                BEGIN
                    SELECT CODTIPOEMPRESA
                      INTO nCodTipoEmpresa
                      FROM DATOS_PART_RESP
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nCodTipoEmpresa := 0;
                END;
                BEGIN
                    SELECT MAX(SUMAHASTA)
                      INTO nSumaMaxima
                      FROM TARIFA_RESP_CIVIL
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND CODCOBERT = cCodCobert
                       AND CODTIPOEMPRESA = nCodTipoEmpresa;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaMaxima := 0;
                END;
                BEGIN
                    SELECT TASA, AUMENTOLIMITE
                      INTO nTasaMax, cAumentoLimiteMax
                      FROM TARIFA_RESP_CIVIL
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND CODCOBERT = cCodCobert
                       AND CODTIPOEMPRESA = nCodTipoEmpresa
                       AND SUMAHASTA = nSumaMaxima;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaMax := 0;
                END;
                BEGIN
                    SELECT TASA, AUMENTOLIMITE
                      INTO nTasa, cAumentoLimite
                      FROM TARIFA_RESP_CIVIL
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND CODCOBERT = cCodCobert
                       AND CODTIPOEMPRESA = nCodTipoEmpresa
                       AND nSumAseg >= SUMADESDE
                       AND nSumAseg <= SUMAHASTA;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa := 0;
                END;
                BEGIN
                    SELECT TASA
                      INTO nTasaDcto
                      FROM RANGO_DCTO_RC
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND nSumAseg >= SUMADESDE
                       AND nSumAseg <= SUMAHASTA;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaDcto := 1;
                END;
                BEGIN
                    SELECT TASA
                      INTO nTasaReca
                      FROM RANGO_RECA_RC
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND nSumAseg = SUMALIMITE
                       AND AUMENTOLIMITE = cAumentoLimiteMax;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaReca := 0;
                END;
                IF nTasa = 0 AND nSumAseg > 0 THEN
                    nTasa := nTasaMax;
                END IF;

                nTasaDcto := (nTasa * nTasaDcto) / 100;
                nTasaReca := 1 + (nTasaReca / 100);
                nTasa     := nTasa * nTasaDcto * nTasaReca;
            END;
            RETURN(nTasa);
            /****************************************************************************
                                  Tarifa de Incendio para R.D.
            ****************************************************************************/

        ELSIF cParam IN
              ('TARINBRD', 'TARTERRD', 'TARHURRD', 'TARDPARD', 'TARINURD',
               'TARMOHRD', 'TAREXPRD', 'TARNAVRD', 'PERDIND', 'BCATAS',
               'BCATASIN', 'BNOCATAS', 'BNOCATASIN') THEN
            DECLARE
                nIndPlanPol NUMBER(1);
            BEGIN

                nTasa := NVL(PR_PRE_INCENDIO.PRE_TASA(nIdePol,
                                                      nNumCert,
                                                      cCodProd,
                                                      cCodPlan,
                                                      cRevPlan,
                                                      cCodRamoCert,
                                                      cCodCobert,
                                                      cParam,
                                                      nAsegurado,
                                                      nIdeBien,
                                                      nDedCobert,
                                                      nSumAseg),
                             0);

                BEGIN
                    SELECT 1
                      INTO nIndPlanPol
                      FROM Cert_Ramo
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert
                       AND CodPlan = cCodPlan
                       AND IndPlanPol = 'S';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nIndPlanPol := 0;
                    WHEN TOO_MANY_ROWS THEN
                        nIndPlanPol := 1;
                END;
                IF cParam NOT IN
                   ('BCATAS', 'BNOCATAS', 'BCATASIN', 'BNOCATASIN') THEN
                    IF nIndPlanPol = 0 THEN
                        IF NVL(nTasa, 0) > 0 THEN
                            nTasa := PR_CERT_AJUSTE_TASA.TASA_NUEVA(nIdePol,
                                                                    nNumCert,
                                                                    nTasa);
                        END IF;
                    END IF;
                END IF;
            END;
            ----------------------------------------------------------
            ----- TARIFA DE AUTO LA UNIVERSAL DE SEGUROS     ---------
            ----- COLISION Y VUELCO/INCENDIO Y ROBO/COMPRENSIVO ------
            ----------------------------------------------------------
        ELSIF cParam = 'TARFULL' THEN
            nTasa := pr_pre_automovil.PRE_TASA(nIdePol,
                                               nNumCert,
                                               cCodProd,
                                               cCodPlan,
                                               cRevPlan,
                                               cCodRamoCert,
                                               cCodCobert,
                                               cParam,
                                               nAsegurado,
                                               nIdeBien,
                                               nDedCobert,
                                               nSumAseg);

        ELSIF cParam = 'TARAUTO' THEN
            -- Tarifa de Automovil
            DECLARE
                cClaSeVeh   VARCHAR2(15);
                cTipoVeh    VARCHAR2(15);
                cTipoModelo VARCHAR2(15);
                cTipoFianza VARCHAR2(15);
                nFactorDcto NUMBER(9, 6);
                nFactorReca NUMBER(9, 6);
                nAnoVeh     NUMBER(4);
                nEdadVeh    NUMBER(2);
            BEGIN
                -- Tarifa de Automovil
                BEGIN
                    SELECT v.TipoVeh,
                           v.ClaseVeh,
                           v.TipoModelo,
                           c.Tipo_Fianza,
                           c.AnoVeh
                      INTO cTipoVeh,
                           cClaseVeh,
                           cTipoModelo,
                           cTipoFianza,
                           nAnoVeh
                      FROM MOD_VEH_VER V, modelo_veh m, Cert_Veh c
                     WHERE c.IdePol = nIdepol
                       AND v.CodMarca = c.CodMarca
                       AND v.CodModelo = c.CodModelo
                       AND v.CodVersion = c.CodVersion
                       AND M.CodMarca = c.CodMarca
                       AND M.CodModelo = c.CodModelo
                       AND c.NumCert = nNumCert
                       and exists (select 'S'
                              from Inspeccion I
                             where I.NumExp = c.Numexp
                               and i.tipoexp = 'SU');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;

                BEGIN
                    SELECT Tasa
                      INTO nTasa
                      FROM TARIFA_AUTO
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND Clase = cTipoModelo; ---- suma desde  suma hasta ----
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa := 0;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;
                -- --> Recargos y descuentos de la tarifa de Automovil
                --------------------------------------------------------------
                ------ en proseguros no existe descuentos en tarifas  --------
                --------------------------------------------------------------
                BEGIN
                    SELECT 1 - (Factor / 100)
                      INTO nFactorDcto
                      FROM DCTO_SUMA_AUTO
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND nSumAseg between SumaIni AND SumaFin;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nFactorDcto := 1;
                    WHEN TOO_MANY_ROWS THEN
                        nFactorDcto := 1;
                END;
                ---------------------------------------------------
                ---- SE DEBE DE VERIFICAR POR TIPO DE RECARGO -----
                ---- POR EL PARAMETRO
                ---------------------------------------------------

                nEdadVeh := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - nAnoVeh;

                BEGIN
                    SELECT 1 + (FACTOR / 100)
                      INTO nFactorReca
                      FROM RECA_EDAD_AUTO
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND nEdadVeh between EdadIni and EdadFin;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nFactorReca := 1;
                    WHEN TOO_MANY_ROWS THEN
                        nFactorReca := 1;
                END;

                nTasa := nTasa * nFactorDcto * nFactorReca;
                -- <-- Recargos y descuentos de la tarifa de Automovil
                RETURN(nTasa);
            END;

        ELSIF cParam = 'TARAUTOR' THEN
            -- Tarifa de Automovil para el Ramo en General                      JJVR 04/08/2000

            DECLARE
                cClaSeVeh   VARCHAR2(15);
                cTipoVeh    VARCHAR2(15);
                cTipoModelo VARCHAR2(15);
                cTipoFianza VARCHAR2(15);
                nFactorDcto NUMBER(9, 6);
                nFactorReca NUMBER(9, 6);
                nAnoVeh     NUMBER(4);
                nEdadVeh    NUMBER(2);
            BEGIN

                BEGIN
                    SELECT v.TipoVeh,
                           v.ClaseVeh,
                           v.TipoModelo,
                           c.Tipo_Fianza,
                           c.AnoVeh
                      INTO cTipoVeh,
                           cClaseVeh,
                           cTipoModelo,
                           cTipoFianza,
                           nAnoVeh
                      FROM MOD_VEH_VER V, modelo_veh m, Cert_Veh c
                     WHERE c.IdePol = nIdepol
                       AND v.CodMarca = c.CodMarca
                       AND v.CodModelo = c.CodModelo
                       AND v.CodVersion = c.CodVersion
                       AND M.CodMarca = c.CodMarca
                       AND M.CodModelo = c.CodModelo
                       AND c.NumCert = nNumCert
                       and exists (select 'S'
                              from Inspeccion I
                             where I.NumExp = c.Numexp
                               and i.tipoexp = 'SU');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;

                BEGIN
                    SELECT Tasa
                      INTO nTasa
                      FROM TARIFA_AUTO_RAMO
                     WHERE CodRamo = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND Clase = cTipoModelo;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa := 0;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;

                BEGIN
                    SELECT 1 - (Factor / 100)
                      INTO nFactorDcto
                      FROM DCTO_SUMA_AUTO_RAMO
                     WHERE CodRamo = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND nSumAseg between SumaIni AND SumaFin;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nFactorDcto := 1;
                    WHEN TOO_MANY_ROWS THEN
                        nFactorDcto := 1;
                END;
                nEdadVeh := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - nAnoVeh;
                BEGIN
                    SELECT 1 + (FACTOR / 100)
                      INTO nFactorReca
                      FROM RECA_EDAD_AUTO_RAMO
                     WHERE CodRamo = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND nEdadVeh between EdadIni and EdadFin;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nFactorReca := 1;
                    WHEN TOO_MANY_ROWS THEN
                        nFactorReca := 1;
                END;
                nTasa := nTasa * nFactorDcto * nFactorReca;

                RETURN(nTasa);
            END;

            --<-- Tarifa de Automovil para el Ramo en General

            -- --> Polizas Declarativa Mensual/Anual de Incendio
            /*
            ELSIF cParam = 'TARDEIN' THEN
                BEGIN
                   SELECT NVL(TASA,0)
                   INTO   nTasa
                   FROM   DECLARACION_INCENDIO
                   WHERE  IdePol = nIdePol
                   AND    IDEDECLINC = (SELECT MAX(IDEDECLINC)
                                        FROM DECLARACION_INCENDIO
                                        WHERE  IdePol = nIdePol);
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                       nTasa   := 0;
                  WHEN TOO_MANY_ROWS THEN
                       nTasa   := 0;
                END;
                  RETURN(nvl(nTasa,0));
            */
            -- <-- Polizas Declarativa Mensual/Anual de Incendio
        ELSIF cParam IN
              ('TARTRC', 'TRCINUN', 'TRCTERR', 'TRCSIM', 'TRCAMP', 'TRCRESP') THEN
            DECLARE
                -- Tarifa de TRC.
                nTasaInund NUMBER(7, 4);
                nTasaSis   NUMBER(7, 4);
                nTasaRc    NUMBER(7, 4);
                nVigencia  NUMBER(4);
                nSumaAseg  NUMBER(14, 2);
                nLimIdemni NUMBER(14, 4);
            BEGIN
                BEGIN
                    SELECT SUMAASEG
                      INTO nSumaAseg
                      FROM DATOS_PART_TRC
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;
                --      nLimIdemni := nSumAseg / nSumaAseg * 100 ;                                              -- JJVR 05/08/2000
                BEGIN
                    SELECT Tasa
                      INTO nTasaRc
                      FROM TASA_RC_TRC
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND Codramoplan = cCodRamoCert
                       AND nSumAseg >= DESDE -- JJVR 05/08/2000
                       AND nSumAseg <= HASTA; -- JJVR 05/08/2000
                    --               nLimIdemni >= DESDE AND
                    --               nLimIdemni <= HASTA;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaRc := 0;
                END;
                BEGIN
                    SELECT MONTHS_BETWEEN(FECFINVIG, FECINIVIG)
                      INTO nVigencia
                      FROM POLIZA
                     WHERE IDEPOL = nIdePol;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nVigencia := 0;
                END;
                BEGIN
                    SELECT TASA, TASAINUND
                      INTO nTasa, nTasaInund
                      FROM TARIFA_TRC TRC, DATOS_PART_TRC D
                     WHERE TRC.CODPROD = cCodProd
                       AND TRC.CODPLAN = cCodPlan
                       AND TRC.REVPLAN = cRevPlan
                       AND TRC.CODRAMOPLAN = cCodRamoCert
                       AND TRC.CODRIESGO = D.CODRIESGO
                       AND D.IDEPOL = nIdePol
                       AND D.NUMCERT = nNumCert
                       AND D.CODRAMOCERT = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa      := 0;
                        nTasaInund := 0;
                END;
                BEGIN
                    SELECT TASA
                      INTO nTasaSis
                      FROM RIESGOS_SISMICOS_TRC_TRM RS,
                           MANT_PROYECTO_MONTAJE    M,
                           DATOS_PART_TRC           D
                     WHERE D.IDEPOL = nIdePol
                       AND D.NUMCERT = nNumCert
                       AND D.CODRAMOCERT = cCodRamoCert
                       AND RS.GRADO = M.SUCEPTSISMICA
                       AND RS.ZONA = D.ZONATERR
                       AND M.CODIGORIESGO = D.CODRIESGO
                       AND M.TIPORIESGO = 'PROY';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaSis := 0;
                END;
                IF nVigencia = 1 THEN
                    -- Tasa para polizas menores a un a?o
                    nTasa := nTasa * 0.50;
                ELSIF nVigencia = 2 THEN
                    nTasa := nTasa * 0.54;
                ELSIF nVigencia = 3 THEN
                    nTasa := nTasa * 0.59;
                ELSIF nVigencia = 4 THEN
                    nTasa := nTasa * 0.64;
                ELSIF nVigencia = 5 THEN
                    nTasa := nTasa * 0.68;
                ELSIF nVigencia = 6 THEN
                    nTasa := nTasa * 0.73;
                ELSIF nVigencia = 7 THEN
                    nTasa := nTasa * 0.77;
                ELSIF nVigencia = 8 THEN
                    nTasa := nTasa * 0.82;
                ELSIF nVigencia = 9 THEN
                    nTasa := nTasa * 0.86;
                ELSIF nVigencia = 10 THEN
                    nTasa := nTasa * 0.91;
                ELSIF nVigencia = 11 THEN
                    nTasa := nTasa * 0.95;
                END IF;
                IF cParam = 'TRCINUN' THEN
                    -- Tasa para cobertura de Inundacion
                    nTasa := nTasaInund;
                END IF;
                IF cParam = 'TRCTERR' THEN
                    -- Tasa para cobertura de Terremoto
                    nTasa := nTasaSis;
                END IF;
                IF cParam = 'TRCRESP' THEN
                    -- Tasa para cobertura de Responsabilidad Civil
                    nTasa := nTasaRc;
                END IF;
                IF cParam = 'TRCSIM' THEN
                    -- Tasa para cobertura de Mantenimiento Simple
                    nTasa := nTasa * 5 / 100; -- Ver nota Sr. Garrigo de aplicar 5% de tasa basica
                END IF;
                IF cParam = 'TRCAMP' THEN
                    -- Tasa para cobertura de Mantenimiento Amplio
                    nTasa := nTasa * 10 / 100; -- Ver nota Sr. Garrigo de aplicar 10% de tasa basica
                END IF;
                /* Segun la tarifa de TRC  las tasas de la cobertura de terremoto debe ser prorrateada     *
                *  cuando la vigencia de la poliza es menor a un a?o, pero la tasa se tomara igual como   *
                *  si fuera anual porque el prorateo se le hace a la prima en el momento de actualizacion *
                *  de la poliza.                                                                          */
                RETURN(nTasa);
            END;

        ELSIF cParam IN ('TARTRM', 'TRMFAB', 'TRMTERR', 'TRMCLO', 'TRMINU',
               'TRMRESP', 'TRMSIM', 'TRMAMP') THEN
            -- Tarifa de TRM.
            DECLARE
                nTasaRecaRieFab NUMBER(7, 4);
                nTasaSis        NUMBER(7, 4);
                nTasaCiclon     NUMBER(7, 4);
                nTasaInund      NUMBER(7, 4);
                nVigenciaCob    NUMBER(4);
                nVigencia       NUMBER(4);
                nSumaAseg       NUMBER(14, 2);
                nLimIdemni      NUMBER(14, 4);
                nTasaRc         NUMBER(7, 4);
            BEGIN
                BEGIN
                    SELECT SUMAASEG
                      INTO nSumaAseg
                      FROM DATOS_PART_TRM
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;
                BEGIN
                    SELECT Tasa
                      INTO nTasaRc
                      FROM TASA_RC_TRC
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND Codramoplan = cCodRamoCert
                       AND nSumAseg >= DESDE -- JJVR   05/08/2000
                       AND nSumAseg <= HASTA; -- JJVR   05/08/2000
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaRc := 0;
                END;
                BEGIN
                    SELECT MONTHS_BETWEEN(FECFINVIG, FECINIVIG)
                      INTO nVigencia
                      FROM POLIZA
                     WHERE IDEPOL = nIdePol;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nVigencia := 0;
                END;
                BEGIN
                    SELECT TASA, RECARIESFAB
                      INTO nTasa, nTasaRecaRieFab
                      FROM TARIFA_TRM TRM, DATOS_PART_TRM D
                     WHERE TRM.CODPROD = cCodProd
                       AND TRM.CODPLAN = cCodPlan
                       AND TRM.REVPLAN = cRevPlan
                       AND TRM.CODRAMOPLAN = cCodRamoCert
                       AND TRM.CODRIESGO = D.CODRIESGO
                       AND D.IDEPOL = nIdePol
                       AND D.NUMCERT = nNumCert
                       AND D.CODRAMOCERT = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa           := 0;
                        nTasaRecaRieFab := 0;
                END;
                BEGIN
                    SELECT TASA
                      INTO nTasaSis
                      FROM RIESGOS_SISMICOS_TRC_TRM RS,
                           MANT_PROYECTO_MONTAJE    M,
                           DATOS_PART_TRM           D
                     WHERE D.IDEPOL = nIdePol
                       AND D.NUMCERT = nNumCert
                       AND D.CODRAMOCERT = cCodRamoCert
                       AND RS.GRADO = M.SUCEPTSISMICA
                       AND RS.ZONA = D.ZONATERR
                       AND M.CODIGORIESGO = D.CODRIESGO
                       AND M.TIPORIESGO = 'MONT';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaSis := 0;
                END;
                BEGIN
                    SELECT TASA
                      INTO nTasaCiclon
                      FROM RIESGOS_INUNDACION_TRC_TRM RI,
                           MANT_PROYECTO_MONTAJE      M,
                           DATOS_PART_TRM             D
                     WHERE D.IDEPOL = nIdePol
                       AND D.NUMCERT = nNumCert
                       AND D.CODRAMOCERT = cCodRamoCert
                       AND RI.GRADO = M.SUCEPTINUNDACION
                       AND RI.ZONA = D.ZONACICLO
                       AND RI.TIPOZONA = 'CICLO'
                       AND M.CODIGORIESGO = D.CODRIESGO
                       AND M.TIPORIESGO = 'MONT';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaCiclon := 0;
                END;
                BEGIN
                    SELECT TASA
                      INTO nTasaInund
                      FROM RIESGOS_INUNDACION_TRC_TRM RI,
                           MANT_PROYECTO_MONTAJE      M,
                           DATOS_PART_TRM             D
                     WHERE D.IDEPOL = nIdePol
                       AND D.NUMCERT = nNumCert
                       AND D.CODRAMOCERT = cCodRamoCert
                       AND RI.GRADO = M.SUCEPTINUNDACION
                       AND RI.ZONA = D.ZONAINUND
                       AND RI.TIPOZONA = 'INUND'
                       AND M.CODIGORIESGO = D.CODRIESGO
                       AND M.TIPORIESGO = 'MONT';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasaInund := 0;
                END;
                IF nVigencia = 1 THEN
                    -- Tasa para polizas menores a un a?o
                    nTasa := nTasa * 0.50;
                ELSIF nVigencia = 2 THEN
                    nTasa := nTasa * 0.54;
                ELSIF nVigencia = 3 THEN
                    nTasa := nTasa * 0.59;
                ELSIF nVigencia = 4 THEN
                    nTasa := nTasa * 0.64;
                ELSIF nVigencia = 5 THEN
                    nTasa := nTasa * 0.68;
                ELSIF nVigencia = 6 THEN
                    nTasa := nTasa * 0.73;
                ELSIF nVigencia = 7 THEN
                    nTasa := nTasa * 0.77;
                ELSIF nVigencia = 8 THEN
                    nTasa := nTasa * 0.82;
                ELSIF nVigencia = 9 THEN
                    nTasa := nTasa * 0.86;
                ELSIF nVigencia = 10 THEN
                    nTasa := nTasa * 0.91;
                ELSIF nVigencia = 11 THEN
                    nTasa := nTasa * 0.95;
                END IF;
                IF cParam = 'TRMFAB' THEN
                    -- Tasa para cobertura de Riesgo del Fabricante
                    nTasa := nTasaRecaRieFab;
                END IF;
                IF cParam = 'TRMTERR' THEN
                    -- Tasa para cobertura de Terremoto
                    nTasa := nTasaSis;
                END IF;
                IF cParam = 'TRMCLO' THEN
                    -- Tasa para cobertura de Ciclon
                    nTasa := nTasaCiclon;
                END IF;
                IF cParam = 'TRMINU' THEN
                    -- Tasa para cobertura de Inundacion
                    nTasa := nTasaCiclon;
                END IF;
                IF cParam = 'TRMRESP' THEN
                    -- Tasa para cobertura de Responsabilidad Civil
                    nTasa := nTasaRc;
                END IF;
                IF cParam = 'TRMSIM' THEN
                    -- Tasa para cobertura de Mantenimiento Simple
                    nTasa := nTasa * 5 / 100; -- aplicar 5% de tasa basica
                END IF;
                IF cParam = 'TRMAMP' THEN
                    -- Tasa para cobertura de Mantenimiento Amplio
                    nTasa := nTasa * 10 / 100; -- aplicar 10% de tasa basica
                END IF;
                /* Segun la tarifa de TRM  las tasas de las coberturas de terremoto, ciclon y inundacion    *
                * debe ser prorrateada cuando la vigencia de la poliza es menor a un a?o, pero la tasa se  *
                * tomara igual como si fuera anual porque el prorateo se le hace a la prima en el momento  *
                * de actualizacion de la poliza.                                                           */
                RETURN(nTasa);
            END;
            /* ****   TARIFA DE GARANTICASA     ************************************************** */
        ELSIF cParam = 'TARGARA' THEN
            DECLARE
                cCodBien   VARCHAR2(4);
                cClaseBien VARCHAR2(3);
                nIdePlan   NUMBER(14);
                nIdeBien_I NUMBER(14);
                CURSOR BIENES IS
                    SELECT CodBien, ClaseBien, IdeBien
                      FROM Bien_Cert
                     WHERE IdePol = nIdePol
                       AND StsBien IN ('MOD', 'INC')
                       AND NumCert = nNumCert;
                CURSOR COBERTURAS IS
                    SELECT CodCoBert
                      FROM COBERT_BIEN
                     WHERE IDEBIEN = nIdeBien_I;
            BEGIN
                IF nIdeBien IS NULL THEN
                    FOR X IN BIENES LOOP
                        nIdeBien_I := X.Idebien;
                        BEGIN
                            SELECT a.IdePlan
                              INTO nIdePlan
                              FROM ConfPlanGaranticasaCab a,
                                   DatPartGaranticasa     b
                             WHERE b.IdePol = nIdePol
                               AND b.NumCert = nNumCert
                               AND b.CodRamoCert = cCodRamoCert
                               AND a.CodGrupo = b.CodGrupo
                               AND a.CodSubGrupo = b.CodSubGrupo
                               AND a.CodBien = X.CodBien
                               AND a.ClaseBien = X.ClaseBien;
                        EXCEPTION
                            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                                RAISE_APPLICATION_ERROR(-20100,
                                                        'PR_PRE_COBERT :Error en los datos Particulares');
                        END;

                        FOR I IN COBERTURAS LOOP
                            BEGIN
                                SELECT NVL(a.Tasa, 0)
                                  INTO nTasa
                                  FROM ConfPlanGaranticasaDet a
                                 WHERE a.IdePlan = nIdePlan
                                   AND a.CodCobert = I.CodCobert;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    RAISE_APPLICATION_ERROR(-20100,
                                                            'PR_PRE_COBERT :No Existe Registro en ConfPlanGaranticasaDet ' ||
                                                            nIdePlan || '-' ||
                                                            cCodCobert);
                            END;
                            RETURN(nTasa);
                        END LOOP;
                    END LOOP;
                ELSE
                    BEGIN
                        SELECT a.CodBien, a.ClaseBien
                          INTO cCodBien, cClaseBien
                          FROM Bien_Cert a
                         WHERE a.IdeBien = nIdeBien;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'PR_PRE_COBERT :No Existe Bien ' ||
                                                    nIdeBien);
                    END;
                    BEGIN
                        SELECT a.IdePlan
                          INTO nIdePlan
                          FROM ConfPlanGaranticasaCab a,
                               DatPartGaranticasa     b
                         WHERE b.IdePol = nIdePol
                           AND b.NumCert = nNumCert
                           AND b.CodRamoCert = cCodRamoCert
                           AND a.CodGrupo = b.CodGrupo
                           AND a.CodSubGrupo = b.CodSubGrupo
                           AND a.CodBien = cCodBien
                           AND a.ClaseBien = cClaseBien;
                    EXCEPTION
                        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'PR_PRE_COBERT :Error en los datos Particulares');
                    END;
                    BEGIN
                        SELECT NVL(a.Tasa, 0)
                          INTO nTasa
                          FROM ConfPlanGaranticasaDet a
                         WHERE a.IdePlan = nIdePlan
                           AND a.CodCobert = cCodCobert;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'PR_PRE_COBERT :No Existe Registro en ConfPlanGaranticasaDet ' ||
                                                    nIdePlan || '-' ||
                                                    cCodCobert);
                    END;
                    RETURN(nTasa);
                END IF;
            END;
        ELSIF cParam = 'TARTRANCE' THEN
            -- |----------------> Tarifa de DECLARACIONES
            BEGIN
                --                    Transporte Maritimo
                DECLARE
                    nRecaEdad          NUMBER(11, 5);
                    cGrupMerc          VARCHAR2(1);
                    nAnoBuque          NUMBER(4);
                    nTonelaje          NUMBER(10);
                    cIndEdad           VARCHAR2(1);
                    cIndnoclasificado  VARCHAR2(1);
                    cIndTrasBordo      VARCHAR2(1);
                    cIndBajoTonelaje   VARCHAR2(1);
                    cGrupBandera       VARCHAR2(1);
                    nAno               NUMBER(4);
                    nEdadBuque         NUMBER(4);
                    cCodBuque          VARCHAR2(4);
                    nRecaNoclasificado NUMBER(11, 5);
                    nRecaTrasbordo     NUMBER(11, 5);
                    nRecaBajotonelaje  NUMBER(11, 5);
                    nRecaBarcaza       NUMBER(11, 5);
                    nRecaGuerra        NUMBER(11, 5);
                    nPorcRecargo       NUMBER(10, 6) := 0;
                    nRecargos          NUMBER(10, 6) := 0;
                BEGIN
                    BEGIN
                        SELECT D.Tasa, T.GRUPO
                          INTO nTasa, cGrupMerc
                          FROM TIPO_MERCANCIA    T,
                               DECLARACION_TRANS DT,
                               DECLARACION       D
                         WHERE DT.IdeDec = D.IdeDec
                           AND T.TipoMerc = DT.TipoMercancia
                           AND D.IdePol = nIdePol
                           AND D.NUMCERT = nNumcert
                           AND D.CODRAMOCERT = CCodRamoCert;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            cGrupMerc := NULL;
                            nTasa     := 0;
                        WHEN TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'Registro duplicado para TIPO_MERCANCIA');
                    END;
                    BEGIN
                        SELECT SUM(RECABARCAZA + RECAEDAD +
                                   RECANOCLASIFICADO + RECATRASBORDO +
                                   RECABAJOTONELAJE + RECAGUERRA) AS RECARGOS
                          INTO nRecargos
                          FROM DAT_TRANSPORTE_POL
                         WHERE IDEPOL = nIdePol;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            nRecargos := 0;
                    END;
                    nTasa := (nTasa + nRecargos);
                END;
                RETURN(nTasa);
            END;
        ELSIF cParam = 'PCOBHIPO' THEN
            DECLARE
                cCodGrupo    VARCHAR2(3);
                cCodSubGrupo VARCHAR2(3);
            BEGIN
                BEGIN
                    SELECT CODGRUPO, CODSUBGRUPO
                      INTO cCodGrupo, cCodSubGrupo
                      FROM DATOS_PARTICULARES_HIPOTECARIA
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'No existe datos particulares.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'Datos particulares duplicados.');
                END;
                BEGIN
                    SELECT TD.TASA
                      INTO nTasa
                      FROM TARIFA_HIPOTECARIA_CAB TC,
                           TARIFA_HIPOTECARIA_DET TD
                     WHERE TC.CODPROD = cCodProd
                       AND TC.CODRAMOPLAN = cCodRamoCert
                       AND TC.CODPLAN = cCodPlan
                       AND TC.REVPLAN = cRevPlan
                       AND TC.CODGRUPO = cCodGrupo
                       AND TC.CODSUBGRUPO = cCodSubGrupo
                       AND TC.IDEHIPO = TD.IDEHIPO
                       AND TD.CODCOBERT = cCodCobert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'No existe tarifa para estos datos particulares.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'Tarifa duplicado para estos datos particulares.');
                END;
                RETURN(NVL(nTasa, 0));
            END;
        ELSIF cParam = 'PDECINCH' THEN
            DECLARE
                cCodGrupo    VARCHAR2(3);
                cCodSubGrupo VARCHAR2(3);
                cCodRamoRea  VARCHAR2(4);
                cClaseBien   VARCHAR2(3);
                cCodBien     VARCHAR2(4);
            BEGIN
                BEGIN
                    SELECT CodRamoRea, ClaseBien, CodBien
                      INTO cCodRamorea, cClaseBien, cCodBien
                      FROM DECLARACION_RAMO_PLAN_PROD
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND PARAMCOBDECLARACION = cCodCobert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT.PRE_TASA : No existe la cobertura ' ||
                                                cCodCobert ||
                                                ' en el configurador del producto.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT.PRE_TASA : Cobertura ' ||
                                                cCodCobert || ' duplicada.');
                END;
                BEGIN
                    SELECT CODGRUPO, CODSUBGRUPO
                      INTO cCodGrupo, cCodSubGrupo
                      FROM DATOS_PARTICULARES_HIPOTECARIA
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'No existe datos particulares.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'Datos particulares duplicados.');
                END;
                BEGIN
                    SELECT NVL(SUM(TD.TASA), 0)
                      INTO nTasa
                      FROM TARIFA_HIPOTECARIA_CAB TC,
                           TARIFA_HIPOTECARIA_DET TD,
                           COBERT_PLAN_PROD       CPP
                     WHERE TC.CODPROD = cCodProd
                       AND TC.CODRAMOPLAN = cCodRamoCert
                       AND TC.CODPLAN = cCodPlan
                       AND TC.REVPLAN = cRevPlan
                       AND TC.CODGRUPO = cCodGrupo
                       AND TC.CODSUBGRUPO = cCodSubGrupo
                       AND TC.CLASEBIEN = cClaseBien
                       AND TC.CODBIEN = cCodBien
                       AND TC.CODPROD = CPP.CODPROD
                       AND TC.CODRAMOPLAN = CPP.CODRAMOPLAN
                       AND TC.CODPLAN = CPP.CODPLAN
                       AND TC.REVPLAN = CPP.REVPLAN
                       AND CPP.CODRAMOREA = cCodRamoRea
                       AND TC.IDEHIPO = TD.IDEHIPO
                       AND TD.CODCOBERT = CPP.CODCOBERT;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT.PRE_TASA: No existe tarifa para estos datos particulares.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT.PRE_TASA: Tarifa duplicado para estos datos particulares.');
                END;
            END;
            -- Vida

            -- Colectivo de Vida (Inicio)
        ELSIF cParam IN ('COLVIDA') THEN
            nTasa := PR_VIDA_COLECTIVA.PRE_TASA(nIdePol,
                                                nNumCert,
                                                cCodProd,
                                                cCodPlan,
                                                cRevPlan,
                                                cCodRamoCert,
                                                cCodCobert,
                                                nAsegurado);
            -- Accidentes Personales Empresas y Escolares
        ELSIF cParam = 'TASAACC' THEN
            nTasa := PR_ACCIDENTE.PRE_TASA(nIdePol,
                                           nNumCert,
                                           cCodProd,
                                           cCodPlan,
                                           cRevPlan,
                                           cCodRamoCert,
                                           cCodCobert,
                                           cParam,
                                           nAsegurado);
            -- Accidentes Personales en Viajes
        ELSIF cParam = 'TASADIAS' THEN
            nTasa := PR_ACCIDENTE.PRE_TASA(nIdePol,
                                           nNumCert,
                                           cCodProd,
                                           cCodPlan,
                                           cRevPlan,
                                           cCodRamoCert,
                                           cCodCobert,
                                           cParam,
                                           nAsegurado);
            -- Colectivo de Vida (Fin)
        ELSIF cParam IN
              ('BPREMUER', 'TASAEDAD', 'SUMATASA', 'FACTPARE', 'SEXOEDAD',
               'TEDADSEX', 'TMPRENOV', 'TARIFABC', 'TARRENTA', 'TARRENTAUNI',
               'BPREMUERUNI', 'TARTMPD', 'TARTARD', 'TARIFABC',
               'BPREMUERUNI', 'TARIFASSI', 'ACTUARIAL') THEN
            -- Formula Actuarial
            BEGIN
                SELECT 1
                  INTO nTasa
                  FROM PLAN_VIDA_OPER_ACT
                 WHERE CodProd = cCodProd
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodRamo = cCodRamoCert
                   AND CodCobert = cCodCobert
                   AND CodOperAct = '00004'
                   AND ROWNUM <= 1;
                nTasa := PR_PRE_VIDA.PRE_TASA(nIdePol,
                                              nNumCert,
                                              cCodProd,
                                              cCodPlan,
                                              cRevPlan,
                                              cCodRamoCert,
                                              cCodCobert,
                                              'ACTUARIAL',
                                              nAsegurado);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nTasa := PR_PRE_VIDA.PRE_TASA(nIdePol,
                                                  nNumCert,
                                                  cCodProd,
                                                  cCodPlan,
                                                  cRevPlan,
                                                  cCodRamoCert,
                                                  cCodCobert,
                                                  cParam,
                                                  nAsegurado);
            END;
        ELSIF cParam IN ('DPHIPOTE') THEN
            nTasa := PR_DAT_PART_HIPOTECARIO.PRE_TASA(nIdePol,
                                                      nNumCert,
                                                      cCodProd,
                                                      cCodPlan,
                                                      cRevPlan,
                                                      cCodRamoCert,
                                                      cCodCobert,
                                                      cParam,
                                                      nAsegurado);
        END IF;
        RETURN(NVL(nTasa, 0));
    END;

    ----------------------------------------------
    ------CALCULO DE PRE PRIMA
    ----------------------------------------------
    FUNCTION PRE_PRIMA(nIdePol      NUMBER,
                       nNumCert     NUMBER,
                       cCodProd     VARCHAR2,
                       cCodPlan     VARCHAR2,
                       cRevPlan     VARCHAR2,
                       cCodRamoCert VARCHAR2,
                       cCodCobert   VARCHAR2,
                       cParam       VARCHAR2,
                       nAsegurado   NUMBER,
                       nIdeBien     NUMBER,
                       nDedCobert   NUMBER,
                       nIdeCobert   NUMBER) RETURN NUMBER IS

        nPrima          NUMBER(14, 2) := 0;
        cCodPais        VARCHAR2(3);
        cCodEstado      VARCHAR2(3);
        cCodCiudad      VARCHAR2(3);
        cCodMunicipio   VARCHAR2(4);
        nMaxCargaPas    NUMBER(4);
        nPrimaCargaPas  NUMBER(14, 2);
        nCantTonelada   NUMBER(3);
        nNumPuestos     NUMBER(3);
        cCodDestinado   VARCHAR2(1);
        nNumPol         NUMBER(10);
        nNumDias        NUMBER(4);
        nNumAdultos     NUMBER(5);
        nNumMenores     NUMBER(5);
        cCodRamorea     VARCHAR2(4);
        nIdebiendeclara NUMBER(14);
        cIndPrimaUnica  VARCHAR2(1);
        nTasaTotal      NUMBER;
        nFactor         NUMBER;
        nPrimaTotalRamo NUMBER(14, 2);
        cClaseBien      VARCHAR2(3);
        cCodBien        VARCHAR2(4);
        cPlanMin        VARCHAR2(3);
        nTasaMin        NUMBER(14, 2);
        nTasaMax        NUMBER(14, 2);
        voficina        VARCHAR2(6);
        v_tasa          NUMBER(14,6) := 0;
        v_franquicia    NUMBER(14,5) := 0;
        v_prima_neta    NUMBER(14,6) := 0;
        v_prima_minima  NUMBER(14,6) := 0;
        vsumaseg        NUMBER(14,6) := 0;
        PTIPO           VARCHAR2(1);

        CURSOR EST_CERT_T IS
            SELECT CodEst, ValEst
              FROM EST_CERT
             WHERE IdePol = nIdePol
               AND NumCert = nNumCert
               AND CodRamoCert = cCodRamoCert;

        CURSOR DECLARA IS
            SELECT CP.CODCOBERT,
                   CP.CODPLAN,
                   CP.REVPLAN,
                   CB.PRIMAMONEDA,
                   CB.TASA
              FROM COBERT_PLAN_PROD CP, COBERT_BIEN CB
             WHERE CP.CODPROD = cCodprod
               AND CP.CODPLAN = cCodPlan
               AND CP.REVPLAN = cRevPlan
               AND CP.CODRAMOPLAN = cCodRamocert
               AND CP.CODRAMOREA = cCodRamorea
               AND CP.CODCOBERT = CB.CODCOBERT
               AND CB.IDEBIEN = nIdeBienDeclara
               AND CB.TASA > 0
               AND CB.STSCOBERT IN ('ACT', 'MOD');

        CURSOR BIEN_DECLARA IS
            SELECT IDEBIEN
              FROM BIEN_CERT
             WHERE IDEPOL = nIdePOL
               AND STSBIEN IN ('ACT', 'MOD')
               AND CLASEBIEN = cClaseBien
               AND CODBIEN = cCodBien
               AND NUMCERT = nNumCert;
    BEGIN
--  Dbms_output.put_line('11111111----cparam' || cparam );
        IF cParam = 'TARCASCO' THEN
            BEGIN
            SELECT CodPais, CodEstado, CodCiudad, CodMunicipio
            INTO cCodPais, cCodEstado, cCodCiudad, cCodMunicipio
            FROM CERTIFICADO
            WHERE IdePol = nIdePol
             AND NumCert = nNumCert;
            END;

            BEGIN
            SELECT Prima
            INTO nPrima
            FROM TARIFA_AUCA TA, CERT_VEH CV
            WHERE TA.CodMarca = CV.CodMarca
              AND TA.CodModelo = CV.CodModelo
              AND TA.CodVersion = CV.CodVersion
              AND TA.AnoVeh = CV.AnoVeh
              AND CV.IdePol = nIdePol
              AND CV.NumCert = nNumCert
              AND TA.CodProd = cCodProd
              AND TA.CodRamo = cCodRamoCert
              AND TA.CodPlan = cCodPlan
              AND TA.RevPlan = cRevPlan
              AND TA.CodCobert = cCodCobert
              AND (TA.CodPais = cCodPais OR cCodPais Is NULL)
              AND (TA.CodEstado = cCodEstado OR cCodEstado Is NULL)
              AND (TA.CodCiudad = cCodCiudad OR cCodCiudad Is NULL)
              AND (TA.CodMunicipio = cCodMunicipio OR cCodMunicipio Is NULL)
              and exists (select 'S'
                          from Inspeccion I
                          where I.NumExp = cv.Numexp
                          and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            RETURN(nPrima);
        ---- FIN TARCASCO------------------------
        --  TARIFICACION VEHICULOS FORTALEZA TARAUTFOR
        --  Ing. Humberto Chahin
        ELSIF cParam IN ('TARAUTFOR') THEN
            BEGIN
            SELECT ROUND(T.TASA,4) ,T.FRANQUICIA, T.PRIMA_NETA,T.PRIMA_MINIMA,c.Valor_total
            INTO v_tasa,v_franquicia,v_prima_neta,v_prima_minima, vsumaseg
            FROM poliza p, cert_ramo cr, cert_veh c, TARIFA_AUT T
            WHERE p.idepol         = cr.idepol
              and cr.idepol        = c.idepol
              and cr.numcert       = c.numcert
              and cr.codramocert   = c.codramocert
              and p.codprod        = t.codprod
              and cr.codramocert   = t.codramoplan
              and cr.codplan       = t.codplan
              and cr.revplan       = t.revplan
              and T.desde          = ( SELECT  max(desde)
                                       from TARIFA_AUT
                                       where DESDE < TO_DATE(SYSDATE,'DD/MM/YYYY') + 1
                                         AND Oficina = DECODE(Oficina,'%',oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = P.IDEPOL))
                                         AND CODPROD        = cCodProd
                                         AND CODRAMOPLAN    = cCodRamoCert
                                         AND REVPLAN        = cRevPlan
                                         AND CODCOBERT      = cCodCobert
                                         AND Clase          = DECODE(Clase ,'%',Clase,C.ClaseVeh)
                                         AND Marca          = DECODE(Marca ,'%',Marca,C.CodMarca)
                                         AND Categoria      = DECODE(Categoria ,'%',Categoria ,C.Clase)
                                         AND Subcategoria   = DECODE(Subcategoria,'%',Subcategoria,C.Subcategoria)
                                         AND Cilindrada     = DECODE(cilindrada,0,cilindrada,C.codpotencia)
                                         AND c.AnoVeh  >= decode(Modelo_inicial,0,9999,Modelo_inicial)
                                         AND c.AnoVeh  <= decode(Modelo_final  ,0,9999,Modelo_final)
                                         AND Sumaseg_ini    <= c.Valor_total
                                         AND decode(Sumaseg_fin,0,999999999,Sumaseg_fin)    >= c.Valor_total
                                         AND exists (select 'S' from Inspeccion I where I.NumExp = c.Numexp and i.tipoexp = 'SU'))
             AND T.Oficina        = DECODE(T.Oficina    ,'%',T.oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = P.IDEPOL))
             AND C.IdePol         = nIdepol
             AND C.NumCert        = nNumcert
             AND T.CODPROD        = cCodProd
             AND T.CODRAMOPLAN    = cCodRamoCert
             AND T.REVPLAN        = cRevPlan
             AND T.CODCOBERT      = cCodCobert
             AND T.Clase           = DECODE(T.Clase       ,'%',T.Clase       ,C.ClaseVeh)
             AND T.Marca           = DECODE(T.Marca       ,'%',T.Marca       ,C.CodMarca)
             AND T.Categoria       = DECODE(T.Categoria   ,'%',T.Categoria   ,C.Clase)
             AND T.Subcategoria    = DECODE(T.Subcategoria,'%',T.Subcategoria,C.Subcategoria)
             AND T.Cilindrada      = DECODE(T.cilindrada  ,0  ,T.cilindrada  ,C.codpotencia)
             AND c.AnoVeh  >= decode(T.Modelo_inicial,0,9999,T.Modelo_inicial)
             AND c.AnoVeh  <= decode(T.Modelo_final  ,0,9999,T.Modelo_final)
             AND T.Sumaseg_ini    <= c.Valor_total
             AND decode(T.Sumaseg_fin,0,999999999,T.Sumaseg_fin)    >= c.Valor_total
             AND exists (select 'S' from Inspeccion I where I.NumExp = c.Numexp and i.tipoexp = 'SU');
             EXCEPTION WHEN OTHERS THEN
                 v_tasa         := 0;
                 v_franquicia   := 0;
                 v_prima_neta   := 0;
                 v_prima_minima := 0;
                 vsumaseg       := 0;
            END;

            /* Dbms_output.put_line('CPROD='||cCodProd||
                                  'CODPLAN='||to_char(cCodPlan)||
                                  'REVPLAN='||to_char(cRevPlan)||
                                  'CODCOBERT='||to_char(cCodCobert)||
                                  'RAMOCERT'||cCodRamoCert  );*/

            IF NVL(V_tasa,0) <> 0 THEN -- EN FUNCION DE LA TASA
               nPrima := NVL(V_tasa,0) * NVL( vsumaseg  ,0) / 100;
               IF nPrima < nvl(v_prima_minima,0) then
                  nPrima := v_prima_minima;
               end if;
            ELSE
               -- EN FUNCION DE LA SUMA ASEGURADA
               nPrima :=  NVL( v_prima_neta ,0);
               IF nPrima < nvl(v_prima_minima,0) then
                  nPrima := v_prima_minima;
               end if;
            END IF;

          -- Dbms_output.put_line('Cobert ' || cCodCobert ||'PRIMA='||nPrima );
        ----------------------------------------------------------------
        --  TARIFICACION GENERAL  FORTALEZA TARGRFOR
        ELSIF cParam IN ('TARGRFOR') THEN

        BEGIN
        SELECT TIPOREGISTROCOBERT
        INTO PTIPO
        FROM COBERT_PLAN_PROD
        WHERE CODPROD     = cCodprod
          AND CODPLAN     = cCodPlan
          AND REVPLAN     = cRevPlan
          AND CODRAMOPLAN = cCodRamocert
          AND CODCOBERT   = cCodCobert;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;

           BEGIN
           SELECT ROUND(TG.TASA,4) ,TG.FRANQUICIA, TG.PRIMA_NETA,TG.PRIMA_MINIMA,BC.MTOVALBIENMONEDA
           INTO v_tasa,v_franquicia,v_prima_neta,v_prima_minima, vsumaseg
           from BIEN_CERT BC, COBERT_BIEN CB, poliza PO, TARIFA_GRL TG
           WHERE BC.IDEPOL         = nIdepol
             AND BC.Idebien        = nIdeBien
             AND BC.IDEBIEN        = CB.IDEBIEN
             AND BC.IDEPOL         = PO.IDEPOL
             AND TG.CODPROD        = cCodProd
             AND TG.CODRAMOPLAN    = cCodRamoCert
             AND TG.REVPLAN        = cRevPlan
             AND TG.CODCOBERT      = cCodCobert
             AND TG.CODPLAN        = cCodPlan
             AND CB.IDECOBERT      = nIdeCobert
             AND TG.desde          = ( select max(desde) from TARIFA_GRL
                                       WHERE BC.IDEPOL         = nIdepol
                                         AND BC.IDEBIEN        = CB.IDEBIEN
                                         AND BC.IDEPOL         = PO.IDEPOL
                                         AND TG.CODPROD        = cCodProd
                                         AND TG.CODRAMOPLAN    = cCodRamoCert
                                         AND TG.REVPLAN        = cRevPlan
                                         AND TG.CODCOBERT      = cCodCobert
                                         AND TG.CODPLAN        = cCodPlan
                                         AND CB.IDECOBERT      = nIdeCobert
                                         AND DESDE       < TO_DATE(SYSDATE,'DD/MM/YYYY') + 1
                                         AND Oficina     = DECODE(Oficina     ,'%',oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = PO.IDEPOL))
                                         AND Sumaseg_ini                                 <= BC.MTOVALBIENMONEDA
                                         AND decode(Sumaseg_fin,0,999999999,Sumaseg_fin) >= BC.MTOVALBIENMONEDA)

             AND TG.Oficina        = DECODE(TG.Oficina    ,'%',TG.oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = PO.IDEPOL))
             AND TG.Sumaseg_ini    <= BC.MTOVALBIENMONEDA
             AND decode(TG.Sumaseg_fin,0,999999999,TG.Sumaseg_fin) >= BC.MTOVALBIENMONEDA;
           EXCEPTION WHEN OTHERS THEN
                 v_tasa         := 0;
                 v_franquicia   := 0;
                 v_prima_neta   := 0;
                 v_prima_minima := 0;
                 vsumaseg       := 0;
           END;

           IF NVL(V_tasa,0) <> 0 THEN -- EN FUNCION DE LA TASA
              IF PTIPO = 'T' THEN -- tasa por 1000
                 nPrima := NVL(V_tasa,0) * NVL( vsumaseg  ,0) / 1000;
                 IF nPrima < nvl(v_prima_minima,0) then
                    nPrima := v_prima_minima;
                 end if;
              ELSIF  PTIPO = 'C' THEN -- tasa por 100
                 nPrima := NVL(V_tasa,0) * NVL( vsumaseg  ,0) / 100;
                 IF nPrima < nvl(v_prima_minima,0) then
                    nPrima := v_prima_minima;
                 end if;
              END IF;
           ELSE
               -- EN FUNCION DE LA SUMA ASEGURADA
              nPrima :=  NVL( v_prima_neta ,0);
              IF nPrima < nvl(v_prima_minima,0) then
                 nPrima := v_prima_minima;
              end if;
          END IF;
         -- ****    NUEVA TARIFA AGOSTO 2021           
         ELSIF cParam IN ('TARIESGO') THEN
            --  Coberturas a nivel de  ASEGURADO
            IF NVL(nAsegurado,0) > 0 THEN
                 BEGIN
                  SELECT T.PrimaMinTecnica
                  INTO   nPrima
                  FROM  POLIZA P, TARIFA_REGIONAL_NIVEL_RIESGO T, ASEGURADO A
                  WHERE P.IdePol          = nIdepol
                  AND   T.CODPROD         = cCodProd
                  AND   T.CodPlan         = cCodPlan
                  AND   T.REVPLAN         = cRevPlan
                  AND   T.CODRAMOPLAN     = cCodRamoCert
                  AND   T.CodOfi          = P.CodOfiSusc
                  AND   T.CodCobert       = cCodCobert
                  AND   A.IdeAseg         = nAsegurado
                  AND   T.NivelRiesgo     = A.NivelRiesgo;
                EXCEPTION WHEN OTHERS THEN
                     nPrima         := 0;
                END;
            ELSE    --   Coberturas a nivel de  Certificados   
                BEGIN
                  SELECT T.PrimaMinTecnica
                  INTO   nPrima                  
                  FROM  POLIZA P, CERTIFICADO C, TARIFA_REGIONAL_NIVEL_RIESGO T
                  WHERE P.IdePol          = nIdepol
                  AND   C.IdePol          = P.IdePol
                  AND   C.NumCert         = nNumcert
                  AND   T.CODPROD         = cCodProd
                  AND   T.CodPlan         = cCodPlan
                  AND   T.REVPLAN         = cRevPlan
                  AND   T.CODRAMOPLAN     = cCodRamoCert
                  AND   T.CodOfi          = P.CodOfiSusc                  
                  AND   T.CodCobert       = cCodCobert
                  AND   T.NivelRiesgo     = C.NivelRiesgo;
                EXCEPTION WHEN OTHERS THEN
                     nPrima         := 0;
                END;
            END IF;    
            RETURN(nPrima);
        --*******************************************            
        ELSIF CPARAM = 'COASEMIN' THEN
            null;
            -- DECLARACIONES
        ELSIF cParam = 'PDECTRA' THEN
            BEGIN
                SELECT DECODE(StsDec,
                              'INC',
                              NVL(SUM(Prima), 0),
                              'MOD',
                              NVL(SUM(PrimaNC) * -1, 0))
                  INTO nPrima
                  FROM DECLARACION
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND StsDec IN ('INC', 'MOD')
                 GROUP BY StsDec;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20100,
                                            'No existe Declaracion para la poliza, Verifique ');

            END;
        ELSIF cParam = 'DECLVIDA' THEN
            BEGIN
                SELECT DECODE(StsDec,
                              'INC',
                              NVL(SUM(PrimaMoneda), 0),
                              'MOD',
                              NVL(SUM(PrimaMonedaNC) * -1, 0)) -- Se busca la prima moneda y no la prima local
                  INTO nPrima
                  FROM DECLARACION
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND CodPlan = cCodPlan
                   and RevPlan = cRevPlan
                   AND StsDec IN ('INC', 'MOD')
                 GROUP BY StsDec;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
        ELSIF cParam = 'PDECINC' THEN
            -- DECLARACIONES DE INCENDIO
            BEGIN
                BEGIN
                    SELECT CodRamoRea
                      INTO cCodRamorea
                      FROM COBERT_PLAN_PROD
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND CODCOBERT = cCodCobert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRIMA : No existe la cobertura ' ||
                                                cCodCobert ||
                                                ' en el configurador del producto.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRIMA : Cobertura ' ||
                                                cCodCobert || ' duplicada.');
                END;
                BEGIN
                    SELECT CLASEBIEN, CODBIEN
                      INTO cClaseBien, cCodBien
                      FROM DECLARACION_RAMO_PLAN_PROD
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND CODRAMOREA = cCodRamoRea
                       AND PARAMCOBDECLARACION = cCodCobert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PRE_PRIMA : No existe bienes para el ramo reaseguro ' ||
                                                cCodRamoRea ||
                                                ' y cobertura declarativa ' ||
                                                cCodCobert || '.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PRE_PRIMA : Registro duplicado el ramo reaseguro ' ||
                                                cCodRamoRea ||
                                                ' y cobertura declarativa ' ||
                                                cCodCobert || '.');
                END;
                -----------------------------------------------------------
                --- SE MODIFICO PORQUE CUANDO ES UNA POLIZA EN DOLARES
                -- VOLVIA A MULTIPLICAR POR LA TASA
                ------------------------------------------------------------
                BEGIN
                    SELECT DECODE(StsDec,
                                  'INC',
                                  NVL(SUM(PrimaMoneda), 0),
                                  'MOD',
                                  NVL(SUM(PRIMAMONEDANC) * -1, 0))
                      INTO nPrima
                      FROM DECLARACION
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert
                       AND CodRamoCert = cCodRamoCert
                       AND StsDec IN ('INC', 'MOD')
                     GROUP BY StsDec;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                BEGIN
                    SELECT NVL(SUM(MC.TASA), 0)
                      INTO nTasaTotal
                      FROM MOD_COBERT MC, COBERT_BIEN CB, BIEN_CERT BC
                     WHERE BC.IdePol = nIdePol
                       AND BC.NumCert = nNumCert
                       AND BC.IdeBien = CB.IdeBien
                       AND BC.CLASEBIEN = cClaseBien
                       AND BC.CODBIEN = cCodBien
                       AND CB.IdeCobert = MC.IdeCobert
                       AND MC.IDEPOL = nIdePol
                       AND MC.NUMCERT = nNumCert
                       AND MC.NumMod =
                           (SELECT MAX(NumMod)
                              FROM MOD_COBERT MC1
                             WHERE MC1.IdeCobert = MC.IdeCobert);
                END;
                nFactor         := nPrima / nTasaTotal;
                nPrimaTotalRamo := 0;
                FOR B IN BIEN_DECLARA LOOP
                    nIdebiendeclara := B.IdeBien;
                    FOR D IN DECLARA LOOP
                        nPrimaTotalRamo := (nFactor * D.Tasa) +
                                           nPrimaTotalRamo;
                    END LOOP;
                END LOOP;
                nPrima := NVL(nPrimaTotalRamo, 0);
            END;
        ELSIF cParam = 'PDEPINCE' THEN
            DECLARE
                cCodProd      VARCHAR2(4);
                cCodPlan      VARCHAR2(3);
                cRevPlan      VARCHAR2(3);
                cStsCertRamo  VARCHAR2(3);
                nPorcPrimaDep NUMBER(7, 4);
                cClaseBien    VARCHAR2(3);
                cCodBien      VARCHAR2(4);
                nPrimaA       NUMBER(14, 2) := 0;
                nPrimaT       NUMBER(14, 2) := 0;
                nIdeCobert    NUMBER(14);
                CURSOR c_Coberturas IS
                    SELECT CPP.CODCOBERT, DRPP.CLASEBIEN, DRPP.CODBIEN
                      FROM DECLARACION_RAMO_PLAN_PROD DRPP,
                           COBERT_PLAN_PROD           CPP
                     WHERE DRPP.CODPROD = cCodProd
                       AND DRPP.CODPLAN = cCodPlan
                       AND DRPP.REVPLAN = cRevPlan
                       AND DRPP.CODRAMOPLAN = cCodRamoCert
                       AND DRPP.PARAMCOBDEPOSITO = cCodCobert
                       AND DRPP.CODPROD = CPP.CodProd
                       AND DRPP.CODPLAN = CPP.CodPlan
                       AND DRPP.REVPLAN = CPP.RevPlan
                       AND DRPP.CODRAMOPLAN = CPP.CodRamoPlan
                       AND DRPP.CODRAMOREA = CPP.CODRAMOREA
                       AND DRPP.PARAMCOBDEPOSITO IS NOT NULL;
            BEGIN
                BEGIN
                    SELECT CODPROD
                      INTO cCodProd
                      FROM POLIZA
                     WHERE IDEPOL = nIdePol;
                EXCEPTION
                    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                        NULL;
                END;
                BEGIN
                    SELECT CODPLAN, REVPLAN, STSCERTRAMO
                      INTO cCodPlan, cRevPlan, cStsCertRamo
                      FROM CERT_RAMO
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                        NULL;
                END;
                BEGIN
                    SELECT NVL(PORCPRIMADEP, 0)
                      INTO nPorcPrimaDep
                      FROM DATOS_PART_INCERD
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                        NULL;
                END;
                nPorcPrimaDep := nPorcPrimaDep / 100;
                IF cStsCertRamo IN ('VAL', 'INC') THEN
                    FOR c IN c_Coberturas LOOP
                        nPrimaA := 0;
                        BEGIN
                            SELECT NVL(CB.PRIMAMONEDA, 0)
                              INTO nPrimaA
                              FROM BIEN_CERT BC, COBERT_BIEN CB
                             WHERE BC.IdePol = nIdePol
                               AND BC.NumCert = nNumCert
                               AND BC.CodRamoCert = cCodRamoCert
                               AND BC.ClaseBien = c.ClaseBien
                               AND BC.CodBien = c.CodBien
                               AND BC.STSBIEN IN ('VAL', 'INC')
                               AND BC.IDEBIEN = CB.IdeBien
                               AND CB.STSCOBERT IN ('VAL', 'INC')
                               AND CB.CodCobert = c.CodCobert;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                NULL;
                        END;
                        nPrimaT := nPrimaT + nPrimaA;
                    END LOOP;
                ELSIF cStsCertRamo IN ('MOD', 'ACT') THEN
                    FOR c IN c_Coberturas LOOP
                        nPrimaA := 0;
                        BEGIN
                            SELECT MC.PRIMAMONEDA
                              INTO nPrimaA
                              FROM BIEN_CERT   BC,
                                   COBERT_BIEN CB,
                                   MOD_COBERT  MC
                             WHERE BC.IdePol = nIdePol
                               AND BC.NumCert = nNumCert
                               AND BC.CodRamoCert = cCodRamoCert
                               AND BC.ClaseBien = c.ClaseBien
                               AND BC.CodBien = c.CodBien
                               AND BC.STSBIEN IN ('INC', 'MOD', 'ACT')
                               AND BC.IDEBIEN = CB.IdeBien
                               AND CB.STSCOBERT IN ('INC', 'MOD', 'ACT')
                               AND CB.CodCobert = c.CodCobert
                               AND CB.IDECOBERT = MC.IDECOBERT
                               AND MC.NUMMOD =
                                   (SELECT MAX(NUMMOD)
                                      FROM MOD_COBERT
                                     WHERE IDECOBERT = MC.IDECOBERT
                                       AND STSMODCOBERT IN ('INC', 'ACT'));
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                NULL;
                        END;
                        nPrimaT := nPrimaT + nPrimaA;
                    END LOOP;
                END IF;
                nPrima := nPrimaT * nPorcPrimaDep;
            END;
        ELSIF cParam = 'PDECINCH' THEN
            DECLARE
                cCodGrupo    VARCHAR2(3);
                cCodSubGrupo VARCHAR2(3);
                cCodRamoRea  VARCHAR2(4);
                cClaseBien   VARCHAR2(3);
                cCodBien     VARCHAR2(4);
                nSumaAseg    NUMBER(14, 2);
                nTasa        NUMBER(9, 6);
            BEGIN
                BEGIN
                    SELECT CodRamoRea, ClaseBien, CodBien
                      INTO cCodRamorea, cClaseBien, cCodBien
                      FROM DECLARACION_RAMO_PLAN_PROD
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND PARAMCOBDECLARACION = cCodCobert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT.PRE_PRIMA : No existe la cobertura ' ||
                                                cCodCobert ||
                                                ' en el configurador del producto.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT.PRE_PRIMA : Cobertura ' ||
                                                cCodCobert || ' duplicada.');
                END;
                BEGIN
                    SELECT CODGRUPO, CODSUBGRUPO
                      INTO cCodGrupo, cCodSubGrupo
                      FROM DATOS_PARTICULARES_HIPOTECARIA
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'No existe datos particulares.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'Datos particulares duplicados.');
                END;
                BEGIN
                    SELECT NVL(SUM(TD.TASA), 0)
                      INTO nTasa
                      FROM TARIFA_HIPOTECARIA_CAB TC,
                           TARIFA_HIPOTECARIA_DET TD,
                           COBERT_PLAN_PROD       CPP
                     WHERE TC.CODPROD = cCodProd
                       AND TC.CODRAMOPLAN = cCodRamoCert
                       AND TC.CODPLAN = cCodPlan
                       AND TC.REVPLAN = cRevPlan
                       AND TC.CODGRUPO = cCodGrupo
                       AND TC.CODSUBGRUPO = cCodSubGrupo
                       AND TC.CLASEBIEN = cClaseBien
                       AND TC.CODBIEN = cCodBien
                       AND TC.CODPROD = CPP.CODPROD
                       AND TC.CODRAMOPLAN = CPP.CODRAMOPLAN
                       AND TC.CODPLAN = CPP.CODPLAN
                       AND TC.REVPLAN = CPP.REVPLAN
                       AND CPP.CODRAMOREA = cCodRamoRea
                       AND TC.IDEHIPO = TD.IDEHIPO
                       AND TD.CODCOBERT = CPP.CODCOBERT;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT.PRE_TASA: No existe tarifa para estos datos particulares.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT.PRE_TASA: Tarifa duplicado para estos datos particulares.');
                END;
                BEGIN
                    SELECT NVL(MAX(MtoLiqLocal), 0)
                      INTO nSumaAseg
                      FROM DECLARACION
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert
                       AND CodRamoCert = cCodRamoCert
                       AND StsDec IN ('INC', 'MOD');
                END;
                nPrima := nSumaAseg * nTasa / 1000;
                BEGIN
                    SELECT DECODE(StsDec,
                                  'INC',
                                  NVL(SUM(nPrima), 0),
                                  'MOD',
                                  NVL(SUM(nPrima) * -1, 0))
                      INTO nPrima
                      FROM DECLARACION
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert
                       AND CodRamoCert = cCodRamoCert
                       AND StsDec IN ('INC', 'MOD')
                     GROUP BY StsDec;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;
            END;
        ELSIF cParam = 'TARRCV' THEN
            BEGIN
                SELECT Prima,
                       MaxCargaPas,
                       PrimaCargaPas,
                       CantTonelada,
                       NumPuestos,
                       CodDestinado
                  INTO nPrima,
                       nMaxCargaPas,
                       nPrimaCargaPas,
                       nCantTonelada,
                       nNumPuestos,
                       cCodDestinado
                  FROM TARIFA_RCV TR, CERT_VEH CV
                 WHERE TR.ClaseVeh = CV.ClaseVeh
                   AND CV.IdePol = nIdePol
                   AND CV.NumCert = nNumCert
                   AND TR.CodProd = cCodProd
                   AND TR.CodRamo = cCodRamoCert
                   AND TR.CodPlan = cCodPlan
                   AND TR.RevPlan = cRevPlan
                   AND TR.CodCobert = cCodCobert
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
                IF nNumPuestos IS NULL THEN
                    BEGIN
                        SELECT NumPOl
                          INTO nNumPol
                          FROM POLIZA
                         WHERE IdePol = nIdePol;
                    END;
                    RAISE_APPLICATION_ERROR(-20100,
                                            'ES NECESARIO LA CANTIDAD DE PUESTOS PARA TARIFICAR R.C.V., POLIZA: ' ||
                                            cCodProd || ' ' || nNumpol);
                END IF;
                IF cCodDestinado = 'P' THEN
                    IF nMaxCargaPas <> 0 AND nMaxCargaPas IS NOT NULL THEN
                        IF nNumPuestos > nMaxCargaPas THEN
                            nPrima := nPrima + (nNumPuestos - nMaxCargaPas) *
                                      nPrimaCargaPas;
                        END IF;
                    END IF;
                ELSE
                    IF nMaxCargaPas <> 0 AND nMaxCargaPas IS NOT NULL THEN
                        IF nCantTonelada > nMaxCargaPas THEN
                            nPrima := nPrima +
                                      (nCantTonelada - nMaxCargaPas) *
                                      nPrimaCargaPas;
                        END IF;
                    END IF;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            RETURN(nPrima);
        ELSIF cParam = 'TARFUN' THEN
            BEGIN
                SELECT Prima
                  INTO nPrima
                  FROM TARIFA_PRIMA_PLAN
                 WHERE CodProd = cCodProd
                   AND CodRamoPlan = cCodRamoCert
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodCobert = cCodCobert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            RETURN(nPrima);
        ELSIF cParam IN
              ('TARAURC', 'TARAURC2', 'TARAUFI', 'TARAUPA', 'TARAUPE',
               'TARAURV', 'TARAUAC', 'TARAUGM', 'TARAUACMIN', 'TARAUCE',
               'TARAUPC', 'TARAUFU', 'TARAUAP', 'TARAUGP', 'TARAUFIMIN') THEN
            DECLARE
                cClase      VARCHAR2(15);
                cClaseVeh   VARCHAR2(15);
                cTipoVeh    VARCHAR2(15);
                cTipoModelo VARCHAR2(15);
                cTipoFianza VARCHAR2(15);

                cPLANMINFIANZAS    VARCHAR2(15);
                cPLANMINRCONDUCTOR VARCHAR2(15);

                cRentaVeh        VARCHAR2(15);
                cAccConductor    VARCHAR2(15);
                cAccPasajeros    VARCHAR2(15);
                cRCExceso        VARCHAR2(15);
                cPolitAcc        VARCHAR2(15);
                cGastosFunerales VARCHAR2(15);

                nNumPuestos     NUMBER;
                nNumPeones      NUMBER(5);
                nTasa           NUMBER(7, 4);
                nNumPuestosOrig NUMBER;
                nDifPuestos     NUMBER;

            BEGIN
                BEGIN
                    SELECT v.TipoVeh,
                           v.ClaseVeh,
                           v.TipoModelo,
                           c.NumPuestos,
                           c.Tipo_Fianza,
                           c.RentaVeh,
                           c.AccConductor,
                           c.AccPasajeros,
                           c.RCExceso,
                           c.PolitAcc,
                           c.GastosFunerales,
                           v.numpuestos,
                           c.PLANMINFIANZAS,
                           c.PLANMINRCONDUCTOR
                      INTO cTipoVeh,
                           cClaseVeh,
                           cTipoModelo,
                           nNumPuestos,
                           cTipoFianza,
                           cRentaVeh,
                           cAccConductor,
                           cAccPasajeros,
                           cRCExceso,
                           cPolitAcc,
                           cGastosFunerales,
                           nNumPuestosOrig,
                           cPLANMINFIANZAS,
                           cPLANMINRCONDUCTOR
                      FROM MOD_VEH_VER V, modelo_veh m, Cert_Veh c
                     WHERE c.IdePol = nIdepol
                       AND v.CodMarca = c.CodMarca
                       AND v.CodModelo = c.CodModelo
                       AND v.CodVersion = c.CodVersion
                       AND M.CodMarca = c.CodMarca
                       AND M.CodModelo = c.CodModelo
                       AND c.NumCert = nNumCert
                       and exists (select 'S'
                              from Inspeccion I
                             where I.NumExp = c.Numexp
                               and i.tipoexp = 'SU');

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;
                IF cParam = 'TARAURC' THEN
                    cClase := cClaseVeh;
                ELSIF cParam IN ('TARAUPA', 'TARAUPE') THEN
                    cClase := cTipoVeh;
                ELSIF cParam = 'TARAUFI' THEN
                    cClase := cTipoFianza;
                ELSIF cParam = 'TARAUFIMIN' THEN
                    cClase := cPLANMINFIANZAS;
                ELSIF cParam = 'TARAURV' THEN
                    cClase := cRentaVeh;
                ELSIF cParam = 'TARAUAC' THEN
                    cClase := cAccConductor;
                ELSIF cParam = 'TARAUACMIN' THEN
                    cClase := cPLANMINRCONDUCTOR;
                ELSIF cParam = 'TARAUGM' THEN
                    cClase := cAccConductor;
                ELSIF cParam = 'TARAUCE' THEN
                    cClase := cRCExceso;
                ELSIF cParam = 'TARAUPC' THEN
                    cClase := cPolitAcc;
                ELSIF cParam = 'TARAUFU' THEN
                    cClase := cGastosFunerales;
                ELSIF cParam = 'TARAUAP' THEN
                    cClase := cAccPasajeros;
                ELSIF cParam = 'TARAUGP' THEN
                    cClase := cAccPasajeros;

                END IF;
                BEGIN
                    SELECT Prima, Tasa
                      INTO nPrima, nTasa
                      FROM TARIFA_AUTO
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND Clase = cClase;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nPrima := 0;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;

                -- <-- Tarifa de Automovil, multiplicacion de prima por pasajero por el # de pasajeros
                BEGIN
                    SELECT NumPeones
                      INTO nNumPeones
                      FROM CERT_VEH cv
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert
                       and exists (select 'S'
                              from Inspeccion I
                             where I.NumExp = cv.Numexp
                               and i.tipoexp = 'SU');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nNumPeones := 0;
                END;

                IF cParam = 'TARAUPA' THEN
                    nPrima := nPrima * nNumPuestos;

                ELSIF cParam = 'TARAUPE' THEN
                    nPrima := nPrima * nNumPeones;
                ELSIF cParam = 'TARAURC' AND nNumPuestos > 20 THEN
                    nPrima := nPrima + ((nNumPuestos - 20) * nTasa);
                END IF;
                -- <-- Tarifa de Automovil, multiplicacion de prima por pasajero por el # de pasajeros
                RETURN(nPrima);
            END;

            -->--  Tarifa de Automovil para el Ramo en General
        ELSIF cParam = 'TARAUPER' THEN

            DECLARE
                cTipoVeh   VARCHAR2(15);
                nNumPeones NUMBER(5);

            BEGIN
                BEGIN
                    SELECT v.TipoVeh, c.NumPeones
                      INTO cTipoVeh, nNumPeones
                      FROM MOD_VEH_VER V, modelo_veh m, Cert_Veh c
                     WHERE c.IdePol = nIdepol
                       AND v.CodMarca = c.CodMarca
                       AND v.CodModelo = c.CodModelo
                       AND v.CodVersion = c.CodVersion
                       AND M.CodMarca = c.CodMarca
                       AND M.CodModelo = c.CodModelo
                       AND c.NumCert = nNumCert
                       and exists (select 'S'
                              from Inspeccion I
                             where I.NumExp = c.Numexp
                               and i.tipoexp = 'SU');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;
                BEGIN
                    SELECT Prima
                      INTO nPrima
                      FROM TARIFA_AUTO_RAMO
                     WHERE CodRamo = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND Clase = cTipoVeh;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nPrima := 0;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;
                nPrima := nPrima * nNumPeones;
            END;
            RETURN(nPrima);

            -->--  Tarifa de Automovil para el Ramo en General
        ELSIF cParam = 'PLANVAC' THEN
            BEGIN
                SELECT NumDias, NumAdultos, NumMenores
                  INTO nNumDias, nNumAdultos, nNumMenores
                  FROM DATOS_PLAN_VACACIONAL
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert;
            END;
            BEGIN
                SELECT Prima
                  INTO nPrima
                  FROM TARIFA_PRIMA_DIAS
                 WHERE CodProd = cCodProd
                   AND CodRamoPlan = cCodRamoCert
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodCobert = cCodCobert
                   AND NumDiasDesde <= nNumDias
                   AND NumDiasHasta >= nNumDias;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            RETURN(nPrima * (nNumAdultos + nNumMenores));
        ELSIF cParam = 'TARVEN' THEN
            FOR E IN EST_CERT_T LOOP
                nPrima := nPrima + NVL(PR_TARIFA_EST.PRE_PRIMA(cCodProd,
                                                               cCodPlan,
                                                               cRevPlan,
                                                               cCodRamoCert,
                                                               cCodCobert,
                                                               E.CodEst,
                                                               E.ValEst),
                                       0);
            END LOOP;
        ELSIF cParam = 'TARAPOV' THEN
            BEGIN
                SELECT Prima, NumPuestos, IndPrimaUnica
                  INTO nPrima, nNumPuestos, cIndPrimaUnica
                  FROM TARIFA_APOV TAP, CERT_VEH CV
                 WHERE TAP.CodSubPlan = CV.CodPlanAPov
                   AND CV.IdePol = nIdePol
                   AND CV.NumCert = nNumCert
                   AND TAP.CodProd = cCodProd
                   AND TAP.CodRamo = cCodRamoCert
                   AND TAP.CodPlan = cCodPlan
                   AND TAP.RevPlan = cRevPlan
                   AND TAP.CodCobert = cCodCobert
                   And exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
                IF nNumPuestos IS NULL THEN
                    BEGIN
                        SELECT NumPOl
                          INTO nNumPol
                          FROM POLIZA
                         WHERE IdePol = nIdePol;
                    END;
                    RAISE_APPLICATION_ERROR(-20100,
                                            'ES NECESARIO LA CANTIDAD DE PUESTOS PARA TARIFICAR A.P.O.V.,POLIZA: ' ||
                                            cCodProd || '-' || nNumPol);
                END IF;
                IF cIndPrimaUnica = 'N' THEN
                    nPrima := nPrima * nvl(nNumPuestos, 0);
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            RETURN(nPrima);
        ELSIF cParam = 'TARTERRM' THEN
            IF nIdeBien IS NULL THEN
                BEGIN
                    DECLARE
                        nTasabien NUMBER(9, 6);
                        CURSOR CBIEN IS
                            SELECT IdeBien,
                                   nvl(sum(nvl((MtoValBienMoneda *
                                               PorcRiesgo) / 100,
                                               0)),
                                       0) nSum
                              FROM BIEN_CERT
                             WHERE IdePol = nIdePol
                               AND NumCert = nNumcert
                               AND CodRamoCert = cCodRamoCert
                             GROUP BY Idebien;
                    BEGIN
                        FOR B IN CBIEN LOOP
                            nTasaBien := PRE_TASA(nIdePol,
                                                  nNumCert,
                                                  cCodProd,
                                                  cCodPlan,
                                                  cRevPlan,
                                                  cCodRamoCert,
                                                  cCodCobert,
                                                  cParam,
                                                  nAsegurado,
                                                  B.IdeBien,
                                                  nDedCobert,
                                                  0,
                                                  null);
                            nPrima    := nPrima +
                                         (B.nSum * ntasaBien / 100);
                        END LOOP;
                    END;
                END;
            END IF;

        ELSIF cParam = 'TARROBOP' THEN
            IF PR_BIEN_CERT.VERIFICA_PLAN_BIEN(nIdeBien) = 0 THEN
                -- Para Buscar el Plan especifco de Catastroficos/No catastroficos
                nPrima := NVL(PR_PRE_INCENDIO.PRE_PRIMA(nIdePol,
                                                        nNumCert,
                                                        cCodProd,
                                                        cCodPlan,
                                                        cRevPlan,
                                                        cCodRamoCert,
                                                        cCodCobert,
                                                        cParam,
                                                        nAsegurado,
                                                        nIdeBien,
                                                        nDedCobert,
                                                        nIdeCobert),
                              0);
            END IF;
        ELSIF cParam = 'TARFIAN' THEN
            ------------------------- [TARIFA_FIANZA]
            DECLARE
                nSumaAsegMoneda  NUMBER(14, 2) := 0;
                nSumAseg         NUMBER(14, 2);
                nLimiteConsumido NUMBER(14, 2) := 0;
                CURSOR RANGOS IS
                    SELECT Tasa, Minimo, Maximo
                      FROM TARIFA_FIANZAS
                     WHERE CodProd = cCodProd
                       AND CodRamoPlan = cCodRamoCert
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodCobert = cCodCobert
                     ORDER BY Minimo;
            BEGIN
                BEGIN
                    SELECT SumaAfianzada
                      INTO nSumaAsegMoneda
                      FROM DATOS_PARTICULARES_FIANZAS
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAsegMoneda := 0;
                END;
                nPrima := 0;
                FOR R IN RANGOS LOOP
                    IF nSumaAsegMoneda > R.Maximo THEN
                        nSumASeg := R.Maximo - nLimiteConsumido;
                    ELSE
                        nSumAseg := nSumaAsegMoneda;
                    END IF;
                    nPrima           := NVL(nPrima, 0) +
                                        (nSumAseg * R.Tasa / 100);
                    nLimiteConsumido := R.Maximo;
                    nSumaAsegMoneda  := nSumaAsegMoneda - nSumAseg;
                    EXIT WHEN nSumaAsegMoneda <= 0;
                END LOOP;
            END;
        ELSIF cParam = 'FIDSTD' THEN
            ------------------------- [TARIFA_FIDELIDAD]
            DECLARE
                nSumaAsegMoneda  NUMBER(14, 2) := 0;
                nSumAseg         NUMBER(14, 2);
                nLimiteConsumido NUMBER(14, 2) := 0;
                cCodBien         VARCHAR2(4);
                CURSOR RANGOS IS
                    SELECT MINIMO, MAXIMO, TASA
                      FROM TAR_FID_STD
                     WHERE CODPROD = cCodProd
                       AND CODRAMO = cCodRamoCert
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CLASEBIEN = '021'
                       AND CODBIEN = cCodBien
                     ORDER BY MINIMO;
            BEGIN
                BEGIN
                    SELECT CODBIEN
                      INTO cCodBien
                      FROM BIEN_CERT
                     WHERE IDEPOL = nIdepol
                       AND IDEBIEN = nIdeBien
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert
                       AND CLASEBIEN = '021';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cCodBien := NULL;
                END;
                BEGIN
                    SELECT MTOVALBIENMONEDA
                      INTO nSumaAsegMoneda
                      FROM BIEN_CERT
                     WHERE IdeBien = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAsegMoneda := 0;
                END;
                nPrima := 0;
                FOR R IN RANGOS LOOP
                    IF nSumaAsegMoneda > R.Maximo THEN
                        nSumASeg := R.Maximo - nLimiteConsumido;
                    ELSE
                        nSumAseg := nSumaAsegMoneda;
                    END IF;
                    nPrima           := NVL(nPrima, 0) +
                                        (nSumAseg * R.Tasa / 100);
                    nLimiteConsumido := R.Maximo;
                    nSumaAsegMoneda  := nSumaAsegMoneda - nSumAseg;
                    EXIT WHEN nSumaAsegMoneda <= 0;
                END LOOP;
            END;
        ELSIF cParam = 'COLUSUM' THEN
            ------------ [TARIFA_FIDELIDAD / COBERTURA LIMITE X COLUSION]
            DECLARE
                nSumaAsegMoneda  NUMBER(14, 2) := 0;
                nSumAseg         NUMBER(14, 2);
                nLimiteConsumido NUMBER(14, 2) := 0;
                cCodBien         VARCHAR2(4);
                CURSOR RANGOS IS
                    SELECT MINIMO, MAXIMO, TASA
                      FROM TAR_FID_STD
                     WHERE CODPROD = cCodProd
                       AND CODRAMO = cCodRamoCert
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CLASEBIEN = '021'
                       AND CODBIEN = cCodBien
                     ORDER BY MINIMO;
            BEGIN
                BEGIN
                    SELECT CODBIEN
                      INTO cCodBien
                      FROM BIEN_CERT
                     WHERE IDEPOL = nIdepol
                       AND IDEBIEN = nIdeBien
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert
                       AND CLASEBIEN = '021';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cCodBien := NULL;
                END;
                BEGIN
                    SELECT MAX(MTOVALBIENMONEDA) * 2
                      INTO nSumaAsegMoneda
                      FROM BIEN_CERT
                     WHERE IdeBien = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAsegMoneda := 0;
                END;
                nPrima := 0;
                FOR R IN RANGOS LOOP

                    IF nSumaAsegMoneda > R.Maximo THEN
                        nSumASeg := R.Maximo - nLimiteConsumido;
                    ELSE
                        nSumAseg := nSumaAsegMoneda;
                    END IF;
                    nPrima           := NVL(nPrima, 0) +
                                        (nSumAseg * R.Tasa / 100);
                    nLimiteConsumido := R.Maximo;
                    nSumaAsegMoneda  := nSumaAsegMoneda - nSumAseg;
                    EXIT WHEN nSumaAsegMoneda <= 0;
                END LOOP;
            END;
        ELSIF cParam = 'TARDIVE' THEN
            BEGIN
                SELECT SUM(Total)
                  INTO nPrima
                  FROM DAT_PART_DIV
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            /********************** TARIFA DE GARANTICASA   ******************************/
            --Datos Particulares Garanticasa
        ELSIF cParam = 'TARGARA' THEN
            DECLARE
                cCodBien   VARCHAR2(4);
                cClaseBien VARCHAR2(3);
                nIdePlan   NUMBER(14);
                nIdeBien_I NUMBER(14);
                CURSOR BIENES IS
                    SELECT CodBien, ClaseBien, IdeBien
                      FROM Bien_Cert
                     WHERE IdePol = nIdePol
                       AND StsBien IN ('MOD', 'INC')
                       AND NumCert = nNumCert;
                CURSOR COBERTURAS IS
                    SELECT CodCoBert
                      FROM COBERT_BIEN
                     WHERE IDEBIEN = nIdeBien_I;
            BEGIN
                IF nIdeBien IS NULL THEN
                    FOR X IN BIENES LOOP
                        nIdeBien_I := X.IdeBien;
                        BEGIN
                            SELECT a.IdePlan
                              INTO nIdePlan
                              FROM ConfPlanGaranticasaCab a,
                                   DatPartGaranticasa     b
                             WHERE b.IdePol = nIdePol
                               AND b.NumCert = nNumCert
                               AND b.CodRamoCert = cCodRamoCert
                               AND a.CodGrupo = b.CodGrupo
                               AND a.CodSubGrupo = b.CodSubGrupo
                               AND a.CodBien = X.CodBien
                               AND a.ClaseBien = X.ClaseBien;
                        EXCEPTION
                            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                                RAISE_APPLICATION_ERROR(-20100,
                                                        'PR_PRE_COBERT : Error en los datos Particulares');
                        END;
                        FOR I IN COBERTURAS LOOP
                            BEGIN
                                SELECT NVL(a.Prima, 0)
                                  INTO nPrima
                                  FROM ConfPlanGaranticasaDet a
                                 WHERE a.IdePlan = nIdePlan
                                   AND a.CodCobert = I.CodCobert;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    RAISE_APPLICATION_ERROR(-20100,
                                                            'PR_PRE_COBERT : No Existe Registro en ConfPlanGaranticasaDet ' ||
                                                            nIdePlan || '-' ||
                                                            cCodCobert);
                            END;
                            RETURN(nPrima);
                        END LOOP;
                    END LOOP;
                ELSE
                    BEGIN
                        SELECT a.CodBien, a.ClaseBien
                          INTO cCodBien, cClaseBien
                          FROM Bien_Cert a
                         WHERE a.IdeBien = nIdeBien;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'PR_PRE_COBERT : No Existe Bien ' ||
                                                    nIdeBien);
                    END;
                    BEGIN
                        SELECT a.IdePlan
                          INTO nIdePlan
                          FROM ConfPlanGaranticasaCab a,
                               DatPartGaranticasa     b
                         WHERE b.IdePol = nIdePol
                           AND b.NumCert = nNumCert
                           AND b.CodRamoCert = cCodRamoCert
                           AND a.CodGrupo = b.CodGrupo
                           AND a.CodSubGrupo = b.CodSubGrupo
                           AND a.CodBien = cCodBien
                           AND a.ClaseBien = cClaseBien;
                    EXCEPTION
                        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'PR_PRE_COBERT : Error en los datos Particulares');
                    END;
                    BEGIN
                        SELECT NVL(a.Prima, 0)
                          INTO nPrima
                          FROM ConfPlanGaranticasaDet a
                         WHERE a.IdePlan = nIdePlan
                           AND a.CodCobert = cCodCobert;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            RAISE_APPLICATION_ERROR(-20100,
                                                    'PR_PRE_COBERT : No Existe Registro en ConfPlanGaranticasaDet ' ||
                                                    nIdePlan || '-' ||
                                                    cCodCobert);
                    END;
                    RETURN(nPrima);
                END IF;
            END;
        ELSIF cParam = 'TARTRANCE' THEN
            BEGIN
                SELECT DT.PRIMAMONEDA
                  INTO nPrima
                  FROM DECLARACION_TRANS DT, DECLARACION D
                 WHERE DT.IDEDEC = D.IDEDEC
                   AND D.IDEPOL = nIdePol;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            RETURN(nPrima);
        ELSIF cParam = 'PCUADINCE' THEN
            DECLARE
                cParamCobDeposito VARCHAR2(4);
                nPrimaDepositoTot NUMBER(14, 2) := 0;
                nPrimaDepositoCob NUMBER(14, 2) := 0;
                nPorcPrima        NUMBER := 0;
                cStsCert          VARCHAR2(3);
                nTasaUltMov       NUMBER := 0;
                nTotSumaAsegurada NUMBER(14, 2) := 0;
                nCantDecl         NUMBER(2) := 0;
                nPrimaDevengada   NUMBER(14, 2) := 0;
                nPrimaNetaLiq     NUMBER(14, 2) := 0;
                nValorMaxDev      NUMBER(14, 2) := 0;
                cCodMoneda        VARCHAR2(3);
                nTasaCambio       NUMBER(11, 6);
            BEGIN
                BEGIN
                    SELECT PARAMCOBDEPOSITO
                      INTO cParamCobDeposito
                      FROM DECLARACION_RAMO_PLAN_PROD
                     WHERE CODPROD = cCodProd
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CODRAMOPLAN = cCodRamoCert
                       AND PARAMCOBCUADANUAL = cCodCobert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT : No Existe coberturas de prima deposito configurada.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT : Existe coberturas de prima deposito configurada duplicadas.');
                END;
                BEGIN
                    SELECT NVL(SUM(MC.PRIMAFACTMONEDA), 0)
                      INTO nPrimaDepositoTot
                      FROM COBERT_CERT                CC,
                           DECLARACION_RAMO_PLAN_PROD DRPP,
                           MOD_COBERT                 MC
                     WHERE CC.IDEPOL = nIdePol
                       AND CC.NUMCERT = nNumCert
                       AND CC.CODRAMOCERT = cCodRamoCert
                       AND CC.CODPLAN = cCodPlan
                       AND CC.REVPLAN = cRevPlan
                       AND CC.STSCOBERT = 'ACT'
                       AND DRPP.CODPROD = cCodProd
                       AND DRPP.CODPLAN = cCodPlan
                       AND DRPP.REVPLAN = cRevPlan
                       AND DRPP.CODRAMOPLAN = cCodRamoCert
                       AND DRPP.PARAMCOBDEPOSITO = CC.CodCobert
                       AND CC.IDECOBERT = MC.IDECOBERT;
                END;
                BEGIN
                    SELECT NVL(SUM(MC.PRIMAFACTMONEDA), 0)
                      INTO nPrimaDepositoCob
                      FROM COBERT_CERT CC, MOD_COBERT MC
                     WHERE CC.IDEPOL = nIdePol
                       AND CC.NUMCERT = nNumCert
                       AND CC.CODRAMOCERT = cCodRamoCert
                       AND CC.CODCOBERT = cParamCobDeposito
                       AND CC.CODPLAN = cCodPlan
                       AND CC.REVPLAN = cRevPlan
                       AND CC.STSCOBERT = 'ACT'
                       AND CC.IDECOBERT = MC.IDECOBERT;
                END;
                BEGIN
                    SELECT STSCERT
                      INTO cStsCert
                      FROM CERTIFICADO
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert;
                END;

                nTasaUltMov := NVL(PR_DECLARACION_STD.TASA_ANUAL_BIEN(nIdePol,
                                                                      nNumCert,
                                                                      cCodProd,
                                                                      cCodPlan,
                                                                      cRevPlan,
                                                                      cCodRamoCert),
                                   0);
                BEGIN
                    SELECT NVL(SUM(MTOLIQLOCAL), 0)
                      INTO nTotSumaAsegurada
                      FROM DECLARACION
                     WHERE IDEPOL = nIdepol
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert
                       AND STSDEC = 'ACT';
                END;
                BEGIN
                    SELECT NVL(COUNT(*), 0)
                      INTO nCantDecl
                      FROM DECLARACION
                     WHERE IDEPOL = nIdepol
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert
                       AND STSDEC = 'ACT';
                END;
                BEGIN
                    SELECT Distinct CodMoneda
                      INTO cCodMoneda
                      FROM Declaracion
                     WHERE idepol = nIdepol;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT : No ha especificado el tipo de moneda en la declaracion.');
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20100,
                                                'PR_PRE_COBERT : Tiene dos tipo de moneda diferente verifique.');
                END;
                nTasaCambio := PR.TASA_CAMBIO(cCodMoneda, SYSDATE);
                IF nCantDecl > 12 THEN
                    RAISE_APPLICATION_ERROR(-20100,
                                            'PR_PRE_COBERT : Cantidad de declaraciones excede el limite maximo de declaraciones (12).');
                END IF;

                nPrimaDevengada := (nTotSumaAsegurada / nCantDecl) *
                                   (nTasaUltMov / 1000);
                nPrimaNetaLiq   := nPrimaDevengada -
                                   (nPrimaDepositoTot * nvl(nTasaCambio, 1));

                nPorcPrima := nPrimaDepositoCob /
                              (nPrimaDepositoTot * nvl(nTasaCambio, 1));

                IF nPrimaNetaLiq < 0 THEN
                    nValorMaxDev := nPrimaDepositoTot / 2;
                    IF nValorMaxDev < ABS(nPrimaNetaLiq) THEN
                        nPrimaNetaLiq := nValorMaxDev * -1;
                    END IF;
                END IF;
                nPrima := nPrimaNetaLiq * nPorcPrima;
                RETURN(nPrima);
            END;
            -- Vida
        ELSIF cParam IN ('BPREMUER', 'VIDUNIVERS', 'EXCEDENTE') THEN
            BEGIN
                nPrima := PR_PRE_VIDA.PRE_PRIMA(nIdePol,
                                                nNumCert,
                                                cCodProd,
                                                cCodPlan,
                                                cRevPlan,
                                                cCodRamoCert,
                                                cCodCobert,
                                                cParam,
                                                nAsegurado);

            END;
        ELSIF cParam IN ('DPHIPOTE') THEN
            nPrima := PR_DAT_PART_HIPOTECARIO.PRE_PRIMA(nIdePol,
                                                        nNumCert,
                                                        cCodProd,
                                                        cCodPlan,
                                                        cRevPlan,
                                                        cCodRamoCert,
                                                        cCodCobert,
                                                        cParam,
                                                        nAsegurado);
        ELSIF cParam = 'TARLEY146' THEN
            BEGIN
                SELECT PlanMin
                  INTO cPlanMin
                  FROM CERT_VEH cv
                 WHERE Idepol = nIdepol
                   AND NumCert = nNumCert
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
            END;
            nPrima := PRE_PRIMA_LEY(nIdePol, nNumCert, cCodCobert, cPlanMin);

        ELSIF cParam = 'TARLEY146MIN' THEN
            BEGIN
                SELECT PlanMinLey
                  INTO cPlanMin
                  FROM CERT_VEH cv
                 WHERE Idepol = nIdepol
                   AND NumCert = nNumCert
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
            END;

            nPrima := PRE_PRIMA_LEY(nIdePol, nNumCert, cCodCobert, cPlanMin);
        ELSIF cParam IN ('TARGRUPO') THEN
            -- Colectivo Grupo Familiar -- Ultimos Gastos
            nPrima := PR_VIDA_COLECTIVA.PRE_PRIMA_GRUPO(nIdePol,
                                                        nNumCert,
                                                        cCodProd,
                                                        cCodPlan,
                                                        cRevPlan,
                                                        cCodRamoCert,
                                                        cCodCobert,
                                                        nAsegurado);
        ELSIF cParam = 'TARFULL' THEN
            nprima := PR_PRE_AUTOMOVIL.PRE_PRIMA(nIdePol,
                                                 nNumCert,
                                                 cCodProd,
                                                 cCodPlan,
                                                 cRevPlan,
                                                 cCodRamoCert,
                                                 cCodCobert,
                                                 cParam,
                                                 nAsegurado,
                                                 nIdeBien,
                                                 nDedCobert,
                                                 nIdeCobert);

        ELSIF CPARAM = '3DTARFI' THEN
            DECLARE
                nSumaAseg   NUMBER;
                ntasa       NUMBER;
                nfACTOR     number;
                NCANTEMP    number;
                NSUMAASEGFI number;
            BEGIN

                nSumaAseg := PR_PRE_COBERT.PRE_SUMA(nIdePol,
                                                    nNumCert,
                                                    cCodProd,
                                                    cCodPlan,
                                                    cRevPlan,
                                                    cCodRamoCert,
                                                    cCodCobert,
                                                    cParam,
                                                    nAsegurado,
                                                    nIdeCobert);

                BEGIN
                    SELECT CANTEMP, SUMAASEG
                      INTO NCANTEMP, NSUMAASEGFI
                      FROM DATOS_PART_FI3D
                     WHERE IdePol = nIdePol
                       AND Numcert = nNumcert
                       AND CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoCert = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;

                BEGIN
                    SELECT factor
                      INTO nFactor
                      FROM TARIFA_FI3D
                     where CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPLAN = cCodRamoCert
                       AND nCantEmp BETWEEN rangomin and Rangomax;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nfactor := 0;
                END;

                NTASA := NFACTOR;

                BEGIN
                    SELECT TasaMin, TasaMax
                      INTO nTasaMin, nTasaMax
                      FROM COBERT_PLAN_PROD
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert
                       AND CodCobert = cCodCobert;
                END;

                IF ntasa > nTasaMax THEN
                    ntasa := nTasaMax;
                ELSIF ntasa < nTasaMin THEN
                    ntasa := nTasaMin;
                END IF;

                nprima := nSumaAseg * ntasa / 100;

                RETURN(nPrima);
            END;

        ELSIF CPARAM = 'TAREQPR' THEN
            DECLARE
                nSumaAseg        NUMBER;
                ntasa            NUMBER;
                nprimamax        NUMBER;
                nPrimaMin        NUMBER;
                NmTOVALBIEN      NUMBER;
                NPRIMAMINIMAPLAN NUMBER;
            BEGIN

                BEGIN
                    select mtovalbienmoneda
                      into NmTOVALBIEN
                      FROM BIEN_CERT
                     WHERE IDEBIEN = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nMtoValBien := 0;
                END;

                IF NVL(NmTOVALBIEN, 0) = 0 THEN
                    nSumaAseg := PR_PRE_COBERT.PRE_SUMA(nIdePol,
                                                        nNumCert,
                                                        cCodProd,
                                                        cCodPlan,
                                                        cRevPlan,
                                                        cCodRamoCert,
                                                        cCodCobert,
                                                        cParam,
                                                        nAsegurado,
                                                        nIdeCobert);
                ELSE
                    nSumaAseg := NmTOVALBIEN;
                END IF;

                ntasa := PR_PRE_COBERT.PRE_TASA(nIdePol,
                                                nNumCert,
                                                cCodProd,
                                                cCodPlan,
                                                cRevPlan,
                                                cCodRamoCert,
                                                cCodCobert,
                                                --cParam,
                                                'TAREQPRX',
                                                0,
                                                nIdeBien,
                                                nDedCobert,
                                                0,
                                                null);

                BEGIN
                    SELECT TasaMin, TasaMax, PrimaMax, PrimaMin
                      INTO nTasaMin, nTasaMax, nprimamax, nPrimaMin
                      FROM COBERT_PLAN_PROD
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert
                       AND CodCobert = cCodCobert;
                END;

                nPrima := nSumaAseg * ntasa / 1000;

                IF ntasa > nTasaMax THEN
                    ntasa := nTasaMax;
                ELSIF ntasa < nTasaMin THEN
                    ntasa := nTasaMin;
                END IF;

                IF npRIMA > nPRIMAMAX THEN
                    nPrima := nPRIMAMAX;
                ELSIF nPrima < nPRIMAMin THEN
                    nPrima := nPRIMAMin;
                END IF;
                RETURN(nPrima);
            END;
        ELSIF CPARAM = 'TARCRIS' THEN
            DECLARE
                nSumaAseg   NUMBER;
                ntasa       NUMBER;
                nprimamax   NUMBER;
                nPrimaMin   NUMBER;
                NmTOVALBIEN NUMBER;
                cCodBien    VARCHAR2(4);
                cClaseBien  VARCHAR2(3);
            BEGIN
                BEGIN
                    SELECT SUM(TOTVALASEG)
                      INTO nSumaAseg
                      FROM DATOS_PART_CRISTALES
                     WHERE IDEPOL = nIdePol
                       AND NUMCERT = nNumCert
                       AND IDEBIEN = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;

                BEGIN
                    SELECT CODBIEN, CLASEBIEN
                      INTO cCodBien, cClaseBien
                      FROM BIEN_CERT
                     WHERE IDEBIEN = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cCodbien   := NULL;
                        cClasebien := NULL;
                END;

                BEGIN
                    SELECT DISTINCT (TC.TASA)
                      INTO nTasa
                      FROM TARIFA_CRISTALES     TC,
                           DATOS_PART_CRISTALES DC,
                           BIEN_CERT            BC
                     WHERE DC.IDEPOL = nIdePol
                       AND DC.NUMCERT = nNumCert
                       AND DC.IDEBIEN = nIdeBien
                       AND TC.CODPROD = cCodProd
                       AND TC.CODPLAN = cCodPlan
                       AND TC.RevPlan = cRevPlan
                       AND TC.CodRamoPlan = cCodRamoCert
                       AND TC.CodCobert = cCodCobert
                       AND TC.CodBien = cCodBien
                       AND TC.ClaseBien = cClaseBien
                       AND BC.IDEBIEN = DC.IDEBIEN;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa := 0;
                END;
                BEGIN
                    SELECT TasaMin, TasaMax, PrimaMax, PrimaMin
                      INTO nTasaMin, nTasaMax, nprimamax, nPrimaMin
                      FROM COBERT_PLAN_PROD
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert
                       AND CodCobert = cCodCobert;
                END;
                nPrima := nSumaAseg * ntasa / 100;
                IF ntasa > nTasaMax THEN
                    ntasa := nTasaMax;
                ELSIF ntasa < nTasaMin THEN
                    ntasa := nTasaMin;
                END IF;
                IF npRIMA > nPRIMAMAX THEN
                    nPrima := nPRIMAMAX;
                ELSIF nPrima < nPRIMAMin THEN
                    nPrima := nPrimaMin;
                END IF;

            END;
        ELSIF CPARAM = 'TAREQUIP' THEN
            DECLARE
                nSumaBien NUMBER;
                ntasa     NUMBER;

            BEGIN

                nSumaBien := PR_PRE_COBERT.PRE_SUMA_BIEN(nIdeBien);
                ---- busco la tasa   ---
                ntasa  := pr_pre_cobert.PRE_TASA(nIdePol,
                                                 nNumCert,
                                                 cCodProd,
                                                 cCodPlan,
                                                 cRevPlan,
                                                 cCodRamoCert,
                                                 cCodCobert,
                                                 cParam,
                                                 0,
                                                 nIdeBien,
                                                 nDedCobert,
                                                 nSumaBien,
                                                 null);
                nprima := nSumaBien * ntasa / 1000;
                RETURN(nPrima);
            END;
            -------------------------------------------------------------
            --------------  ASALTO   ------------------------------------
            -----------------------------------------------------
            ---- RESPONSABILIDAD CIVIL PROSEGUROS   -------------
            -----------------------------------------------------
        ELSIF cParam = 'TARRESPPR' THEN
            DECLARE
                nCodTipoEmpresa   NUMBER(5);
                nTasaDcto         NUMBER(9, 6);
                cAumentoLimite    CHAR(1);
                cAumentoLimiteMax CHAR(1);
                nTasaMax          NUMBER(9, 6);
                nTasaReca         NUMBER(9, 6);
                nSumaMaxima       NUMBER(14, 2);
                nSumaAseg         NUMBER(14, 2);
                ntASA             NUMBER(9, 6);
                nTipTasa          NUMBER(4);
            BEGIN
                BEGIN
                    SELECT CodTipoEmpresa, SumaAsegurada
                      INTO nCodTipoEmpresa, nSumaAseg
                      FROM DATOS_PART_RESP
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert
                       AND CodRamoCert = cCodRamoCert
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nCodTipoEmpresa := 0;
                END;

                BEGIN
                    SELECT PRIMA
                      INTO nPrima
                      FROM TARIFA_RESP_CIVIL
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND CodTipoEmpresa = nCodTipoEmpresa
                       AND nSumaAseg >= SumaDesde
                       AND nSumaAseg <= SumaHasta;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nPrima := 0;
                    WHEN TOO_MANY_ROWS THEN
                        RAISE_APPLICATION_ERROR(-20213,
                                                'Configuracion Duplicada          ' ||
                                                'Producto           ' ||
                                                cCodprod ||
                                                'Codigo Plan        ' ||
                                                cCodplan ||
                                                'Revsision Plan     ' ||
                                                cRevplan ||
                                                'Ramo               ' ||
                                                cCodRamoCert ||
                                                'TipoEmpresa        ' ||
                                                nCodTipoEmpresa ||
                                                'Suma               ' ||
                                                nSumaAseg);
                END;

                IF NVL(nPrima, 0) = 0 THEN

                    BEGIN
                        SELECT TASA
                          INTO ntASA
                          FROM TARIFA_RESP_CIVIL
                         WHERE CodProd = cCodProd
                           AND CodPlan = cCodPlan
                           AND RevPlan = cRevPlan
                           AND CodRamoPlan = cCodRamoCert
                           AND CodCobert = cCodCobert
                           AND CodTipoEmpresa = nCodTipoEmpresa
                           AND nSumaAseg >= SumaDesde
                           AND nSumaAseg <= SumaHasta;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            ntASA := 0;
                    END;
                    IF NVL(NTASA, 0) != 0 THEN
                        nTipTasa := NVL(PR.BUSCA_TIPO_TASA_DPP(cCodProd,
                                                               cCodPlan,
                                                               cRevplan,
                                                               cCodramoCert,
                                                               cCodCobert),
                                        0);
                        nPrima   := nSumaAseg * (ntASA / nTipTasa);
                    END IF;
                END IF;
            END;
            RETURN(nPrima);
        ELSIF cparam IN ('CTARSALU', 'CTARGRUP') THEN
            nprima := PR_PRE_COB_PER.PRE_PRIMA(nidepol,
                                               nNumCert,
                                               cCodProd,
                                               cCodPlan,
                                               crevplan,
                                               ccodramocert,
                                               ccodcobert,
                                               cparam,
                                               nAsegurado,
                                               nidebien,
                                               ndedcobert,
                                               nidecobert);
            RETURN(nprima);

        ELSIF cParam = 'CTARSASA' THEN
            --  20/06/2007
            nPrima := PR_PRE_SALUD_TARIFA.PRE_PRIMA(nIdePol,
                                                    nNumCert,
                                                    cCodProd,
                                                    cCodPlan,
                                                    cRevPlan,
                                                    cCodRamoCert,
                                                    cCodCobert,
                                                    cParam,
                                                    nAsegurado,
                                                    nIdeBien,
                                                    0);

        END IF;
        RETURN(nPrima);
    END;
    -------------------------------------------
    -- FIN PRE PRIMA
    -------------------------------------------


    ------------------------------------------
    -- POST PRIMA
    ------------------------------------------

    FUNCTION POST_PRIMA(nIdePol         NUMBER,
                        nNumCert        NUMBER,
                        cCodProd        VARCHAR2,
                        cCodPlan        VARCHAR2,
                        cRevPlan        VARCHAR2,
                        cCodRamoCert    VARCHAR2,
                        cCodCobert      VARCHAR2,
                        cParam          VARCHAR2,
                        nAsegurado      NUMBER,
                        nSumaAsegMoneda NUMBER,
                        nIdeBien        NUMBER) RETURN NUMBER IS

        nPrima        NUMBER(14, 2) := 0;
        cCodCobertRcv VARCHAR2(4);
        nPorcReca     NUMBER(9, 6);
        cTipoVeh      varchar2(10);
        NPORC         number(9, 6);

    BEGIN

        IF cParam = 'TAREXC' THEN
            BEGIN
                SELECT PorcReca, tr.ClaseVeh
                  INTO nPorcReca, cTipoVeh
                  FROM TARIFA_RCV TR, CERT_VEH CV
                 WHERE CV.IdePol = nIdePol
                   AND CV.NumCert = nNumCert
                   AND TR.CodProd = cCodProd
                   AND TR.CodRamo = cCodRamoCert
                   AND TR.CodPlan = cCodPlan
                   AND TR.RevPlan = cRevPlan
                   AND TR.CodCobert = cCodCobert
                   AND TR.ClaseVeh = CV.ClaseVeh
                   AND TR.SumaAseg = nSumaAsegMoneda
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;

            IF cCodRamoCert = '2603' THEN
                /* Parametrizar automovil individual y Flota */
                cCodCobertRcv := '0171';
            END IF;

            BEGIN
                SELECT PrimaMoneda
                  INTO nPrima
                  FROM COBERT_CERT
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND CodCobert = cCodCobertRcv
                   AND StsCobert NOT IN ('EXC', 'ANU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            nPrima := NVL(nPrima, 0) * NVL(nPorcReca, 0) / 100;
            RETURN(nPrima);
        ELSIF cParam = 'COASEMIN' THEN
            BEGIN
                SELECT PORCPART
                  INTO NPORC
                  FROM PART_CED
                 WHERE IDEPOL = NIDEPOL
                   and CODACEPRIESGO = '23';
                   --23 Compañia Fortaleza OSV.18/03/2010
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPorc := 0;
            END;

            begin
                select PrimaMoneda
                  INTO nprima
                  from COBERT_CERT
                 where IDEPOL = nIdePol
                   and NUMCERT = nNumCert
                   and CODRAMOCERT = cCodRamoCert
                   and CODCOBERT = cCodCobert;
            exception
                when no_data_found then
                    nprima := 0;
            end;
            IF nprima != 0 then
                BEGIN
                    nprima := nprima * NPORC / 100;
                END;
            end if;
            ---------------------------
            ---- ASALTO ---------------
            ---------------------------
        ELSIF cParam = 'ASALTO' THEN

            DECLARE
                nTasa           tarifa_robo_tecnico.Tasa%TYPE;
                nPrimaMinima    tarifa_robo_tecnico.PrimaMinima%TYPE;
                nSUMAASEGMONEDA cobert_cert.SUMAASEGMONEDA%TYPE;
                nSUMAASEG       cobert_cert.SUMAASEG%TYPE;
                nfactor         tarifa_robo_tecnico.Factor%TYPE;
                nPRIMAFACTOR    NUMBER;

            BEGIN
                nPrima := 0;
                RETURN(nPrima);
            END;

            /*   BEGIN
                 SELECT Tasa , Primaminima  , factor
                 INTO   nTasa, nPrimaMinima , nfactor
                 FROM   tarifa_robo_tecnico
                 WHERE  CODPROD           = cCodProd
                 AND    CODRAMOPLAN       = cCodramoCert
                 AND    CODPLAN           = ccodplan
                 AND    REVPLAN           = cRevPlan
                 AND    CODCOBERT         = cCodCobert;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nTasa           := 0;
                    nPrimaMinima    := 0;
              END;

              nPRIMA        := nSumaAsegMoneda * NVL(NTASA,0)/100;

              IF   nPRIMA < nPrimaMinima THEN
                   nPRIMA  := nPrimaMinima;
              END IF;

              RETURN(nPrima);
            END;

              IF  nSumAseg != 0 THEN
                  BEGIN
                     select SUMAASEGMONEDA    ,  SUMAASEGMONEDA
                     into   nSUMAASEGMONEDA   ,  nSUMAASEG
                     FROM   COBERT_CERT
                     WHERE  IDEPOL          = nIdePOL
                     AND    NUMCERT         = nNumcert
                     AND    CODRAMOCERT     = cCodRamocert
                     AND    CODPLAN         = cCodPlan
                     AND    REVPLAN         = cRevPlan
                     AND    CODCOBERT       = cCodCobert;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                     NULL;
                  END;

                  BEGIN
                    SELECT Tasa , Primaminima  , factor
                    INTO   nTasaRobo, nPrimaMinima , nfactor
                    FROM   tarifa_robo_tecnico
                    WHERE  CODPROD           = cCodProd
                    AND    CODRAMOPLAN       = cCodramoCert
                    AND    CODPLAN           = ccodplan
                    AND    REVPLAN           = cRevPlan
                    AND    CODCOBERT         = cCodCobert;
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nTasa           := 0;
                 END;

                 nprimaminima := nPrimaMinima * nfactor;
                 nprimafactor := nSumAaseg * ntasarobo/100;


                 IF   nPrimafactor <  nPrimaMinima then
                      nprima := nPrimaMinima;
                      NTASA  := nSUMAASEG/nprima;
                 ELSE
                      nTasa := nTasarobo;
                 END IF;

             END IF;  */

        ELSIF cParam = 'TARAVI' THEN
            -- Tarifa de Aviacion.

            BEGIN
                SELECT TA.PRIMA
                  INTO nPrima
                  FROM TARIFA_AVIACION TA, CERT_AVI CA
                 WHERE TA.CODPROD = cCodProd
                   AND TA.CODPLAN = cCodPlan
                   AND TA.REVPLAN = cRevPlan
                   AND TA.CODRAMOPLAN = cCodRamoCert
                   AND TA.CODCOBERT = cCodCobert
                   AND CA.IDEPOL = nIdePol
                   AND CA.NUMCERT = nNumCert
                   AND TA.TIPOAVI = CA.TIPOAVI
                   AND TA.CODESTINADO = CA.CODDESTINADO
                   AND nSumaAsegMoneda >= TA.RANGOMIN
                   AND nSumaAsegMoneda <= TA.RANGOMAX;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
                when too_many_rows then
                    RAISE_APPLICATION_ERROR(-20213,
                                            'Registros Duplicados Para la suma ' ||
                                            nSumaAsegMoneda);
            END;
            RETURN(nPrima);
        ELSIF cParam = 'TARAVIC' THEN
            -- Tarifa de Aviacion.  (Casco) ---
            BEGIN
                SELECT TA.PRIMA
                  INTO nPrima
                  FROM TARIFA_AVIACION TA, CERT_AVI CA
                 WHERE TA.CODPROD = cCodProd
                   AND TA.CODPLAN = cCodPlan
                   AND TA.REVPLAN = cRevPlan
                   AND TA.CODRAMOPLAN = cCodRamoCert
                   AND TA.CODCOBERT = cCodCobert
                   AND CA.IDEPOL = nIdePol
                   AND CA.NUMCERT = nNumCert
                   AND TA.TIPOAVI = CA.TIPOAVI
                   AND TA.CODESTINADO = CA.CODDESTINADO
                   AND nSumaAsegMoneda >= TA.RANGOMIN
                   AND nSumaAsegMoneda <= TA.RANGOMAX;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            RETURN(nPrima);

            /****************************************************************************/
        ELSIF cParam = 'TARDEF' THEN
            BEGIN
                SELECT Prima
                  INTO nPrima
                  FROM TARIFA_RCV TR, CERT_VEH CV
                 WHERE CV.IdePol = nIdePol
                   AND CV.NumCert = nNumCert
                   AND TR.CodProd = cCodProd
                   AND TR.CodRamo = cCodRamoCert
                   AND TR.CodPlan = cCodPlan
                   AND TR.RevPlan = cRevPlan
                   AND TR.CodCobert = cCodCobert
                   AND TR.SumaAseg = nSumaAsegMoneda
                   and TR.ClaseVeh = CV.ClaseVeh
                   and exists (select 'S'
                          from Inspeccion I
                         where I.NumExp = cv.Numexp
                           and i.tipoexp = 'SU');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPrima := 0;
            END;
            RETURN(nPrima);
        ELSIF cParam = 'TARFI3D' THEN
            -------------- [TARIFA FIDELIDAD 3D]
            DECLARE
                nSumaAsegMoneda  NUMBER(14, 2) := 0;
                nSumAseg         NUMBER(14, 2);
                nLimiteConsumido NUMBER(14, 2) := 0;
                nCantEmp         NUMBER(5);
                nCantEmpTotal    NUMBER(5);
                Recargo          NUMBER(14, 4);
                CURSOR RANGOS IS
                    SELECT Factor, RangoMin, RangoMax
                      FROM TARIFA_FI3D
                     WHERE CodProd = cCodProd
                       AND CodRamoPlan = cCodRamoCert
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND SumaAseg =
                           (SELECT MIN(SumaAseg)
                              FROM TARIFA_FI3D
                             WHERE CodProd = cCodProd
                               AND CodPlan = cCodPlan
                               AND RevPlan = cRevPlan
                               AND CodRamoPlan = cCodRamoCert
                               AND SumaAseg >= nSumaAsegMoneda)
                     ORDER BY RangoMin;
            BEGIN
                BEGIN
                    SELECT SumaAseg, CantEmp
                      INTO nSumaAsegMoneda, nCantEmp
                      FROM DATOS_PART_FI3D
                     WHERE IdePol = nIdePol
                       AND Numcert = nNumcert
                       AND CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoCert = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAsegMoneda := 0;
                        nCantEmp        := 0;
                END;
                IF nCantEmp IS NULL THEN
                    nCantEmp := 0;
                END IF;
                BEGIN
                    SELECT Recargo
                      INTO Recargo
                      FROM TARIFA_FI3D
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoPlan = cCodRamoCert
                       AND nCantEmp BETWEEN RangoMin AND RangoMax
                       AND SumaAseg =
                           (SELECT MIN(SumaAseg)
                              FROM TARIFA_FI3D
                             WHERE CodProd = cCodProd
                               AND CodPlan = cCodPlan
                               AND RevPlan = cRevPlan
                               AND CodRamoPlan = cCodRamoCert
                               AND nCantEmp BETWEEN RangoMin AND RangoMax
                               AND SumaAseg >= nSumaAsegMoneda);
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        Recargo := 0;
                END;
                nCantEmpTotal := nCantEmp;
                nPrima        := 0;
                FOR R IN RANGOS LOOP
                    IF nCantEmpTotal > R.RangoMax THEN
                        nSumASeg := R.RangoMax - nLimiteConsumido;
                    ELSE
                        nSumAseg := nCantEmp;
                    END IF;
                    nPrima           := NVL(nPrima, 0) +
                                        (nSumAseg * R.Factor);
                    nLimiteConsumido := R.RangoMax;
                    nCantEmp         := nCantEmp - nSumAseg;
                    EXIT WHEN nCantEmp <= 0;
                END LOOP;
                Recargo := nPrima * nvl(Recargo, 0) / 100;
                nPrima  := nPrima + nvl(Recargo, 0);
            END;
            RETURN(nPrima);
        ELSIF cParam = 'FIDSTD' THEN
            ------------------------- [TARIFA_FIDELIDAD]
            DECLARE
                nSumaAsegMoneda  NUMBER(14, 2) := 0;
                nSumAseg         NUMBER(14, 2);
                nLimiteConsumido NUMBER(14, 2) := 0;
                cCodBien         VARCHAR2(4);
                CURSOR RANGOS IS
                    SELECT MINIMO, MAXIMO, TASA
                      FROM TAR_FID_STD
                     WHERE CODPROD = cCodProd
                       AND CODRAMO = cCodRamoCert
                       AND CODPLAN = cCodPlan
                       AND REVPLAN = cRevPlan
                       AND CLASEBIEN = '021'
                       AND CODBIEN = cCodBien
                     ORDER BY MINIMO;
            BEGIN
                BEGIN
                    SELECT CODBIEN
                      INTO cCodBien
                      FROM BIEN_CERT
                     WHERE IDEPOL = nIdepol
                       AND IDEBIEN = nIdeBien
                       AND NUMCERT = nNumCert
                       AND CODRAMOCERT = cCodRamoCert
                       AND CLASEBIEN = '021';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cCodBien := NULL;
                END;
                BEGIN
                    SELECT MTOVALBIENMONEDA
                      INTO nSumaAsegMoneda
                      FROM BIEN_CERT
                     WHERE IdeBien = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAsegMoneda := 0;
                END;
                nPrima := 0;
                FOR R IN RANGOS LOOP
                    IF nSumaAsegMoneda > R.Maximo THEN
                        nSumASeg := R.Maximo - nLimiteConsumido;
                    ELSE
                        nSumAseg := nSumaAsegMoneda;
                    END IF;
                    nPrima           := NVL(nPrima, 0) +
                                        (nSumAseg * R.Tasa / 100);
                    nLimiteConsumido := R.Maximo;
                    nSumaAsegMoneda  := nSumaAsegMoneda - nSumAseg;
                    EXIT WHEN nSumaAsegMoneda <= 0;
                END LOOP;

            END;
            RETURN(nPrima);
            -->--  Tarifa de Automovil para el Ramo en General

        ELSIF cParam IN ('TARAURCR', 'TARAUFIR', 'TARAUPAR', 'TARAUPER',
               'TARAURVR', 'TARAUACR', 'TARAUGMR', 'TARAUCER',
               'TARAUPCR', 'TARAUFUR', 'TARAUAPR', 'TARAUGPR') THEN
            DECLARE
                cClase      VARCHAR2(15);
                cClaseVeh   VARCHAR2(15);
                cTipoVeh    VARCHAR2(15);
                cTipoModelo VARCHAR2(15);
                cTipoFianza VARCHAR2(15);
                nNumPuestos NUMBER;
                nFactor     NUMBER;
                nNumPeones  NUMBER(5);
                nTasa       NUMBER(7, 4);

                cRentaVeh        VARCHAR2(15);
                cAccConductor    VARCHAR2(15);
                cAccPasajeros    VARCHAR2(15);
                cRCExceso        VARCHAR2(15);
                cPolitAcc        VARCHAR2(15);
                cGastosFunerales VARCHAR2(15);
                nNumPuestosOrig  NUMBER;
                nDifPuestos      NUMBER;

            BEGIN
                BEGIN
                    SELECT v.TipoVeh,
                           v.ClaseVeh,
                           v.TipoModelo,
                           c.NumPuestos,
                           c.Tipo_Fianza,
                           c.RentaVeh,
                           c.AccConductor,
                           c.AccPasajeros,
                           c.RCExceso,
                           c.PolitAcc,
                           c.GastosFunerales,
                           v.NumPuestos
                      INTO cTipoVeh,
                           cClaseVeh,
                           cTipoModelo,
                           nNumPuestos,
                           cTipoFianza,
                           cRentaVeh,
                           cAccConductor,
                           cAccPasajeros,
                           cRCExceso,
                           cPolitAcc,
                           cGastosFunerales,
                           nNumPuestosOrig
                      FROM MOD_VEH_VER V, modelo_veh m, Cert_Veh c
                     WHERE c.IdePol = nIdepol
                       AND v.CodMarca = c.CodMarca
                       AND v.CodModelo = c.CodModelo
                       AND v.CodVersion = c.CodVersion
                       AND M.CodMarca = c.CodMarca
                       AND M.CodModelo = c.CodModelo
                       AND c.NumCert = nNumCert
                       and exists (select 'S'
                              from Inspeccion I
                             where I.NumExp = c.Numexp
                               and i.tipoexp = 'SU');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;
                -- >-- Calculo de tarifa de Automovil, selecion de la clase a buscar tarifa en tabla
                --     dependiendo de parametro de pre_cobert

                IF cParam = 'TARAURCR' THEN
                    cClase := cClaseVeh;
                ELSIF cParam IN ('TARAUPAR', 'TARAUPER') THEN
                    cClase := cTipoVeh;
                ELSIF cParam = 'TARAUFIR' THEN
                    cClase := cTipoFianza;
                ELSIF cParam = 'TARAURVR' THEN
                    cClase := cRentaVeh;
                ELSIF cParam = 'TARAUACR' THEN
                    cClase := cAccConductor;
                ELSIF cParam = 'TARAUGMR' THEN
                    cClase := cAccConductor;
                ELSIF cParam = 'TARAUCER' THEN
                    cClase := cRCExceso;
                ELSIF cParam = 'TARAUPCR' THEN
                    cClase := cPolitAcc;
                ELSIF cParam = 'TARAUFUR' THEN
                    cClase := cGastosFunerales;
                ELSIF cParam = 'TARAUAPR' THEN
                    cClase := cAccPasajeros;
                ELSIF cParam = 'TARAUGPR' THEN
                    cClase := cAccPasajeros;

                END IF;

                -- <-- Calculo de tarifa de Automovil, selecion de la clase a buscar tarifa en tabla
                --     dependiendo de parametro de pre_cobert
                BEGIN
                    SELECT Prima, Tasa
                      INTO nPrima, nTasa
                      FROM TARIFA_AUTO_RAMO
                     WHERE CodRamo = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND Clase = cClase;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nPrima := 0;
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;
                BEGIN
                    SELECT NumPeones
                      INTO nNumPeones
                      FROM CERT_VEH cv
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert
                       and exists (select 'S'
                              from Inspeccion I
                             where I.NumExp = cv.Numexp
                               and i.tipoexp = 'SU');

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nNumPeones := 0;
                END;

                IF cParam = 'TARAUPAR' THEN
                    nPrima := nPrima * nNumPuestos;
                ELSIF cParam = 'TARAUPER' THEN
                    nPrima := nPrima * nNumPeones;
                ELSIF cParam = 'TARAURCR' AND nNumPuestos > 20 THEN
                    nPrima := nPrima + ((nNumPuestos - 20) * nTasa);
                END IF;

                BEGIN
                    SELECT 1 + (Factor / 100)
                      INTO nFactor
                      FROM TARIFA_RANGO_AUTO_RC
                     WHERE CodRamo = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND nSumaAsegMoneda between SumaIni and SumaFin;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nFactor := 1;
                END;

                nPrima := nPrima * nFactor;

            END;
            RETURN(nPrima);
            -->--  Tarifa de Automovil para el Ramo en General
        ELSIF cParam IN ('DPHIPOTE') THEN
            nPrima := PR_DAT_PART_HIPOTECARIO.POST_PRIMA(nIdePol,
                                                         nNumCert,
                                                         cCodProd,
                                                         cCodPlan,
                                                         cRevPlan,
                                                         cCodRamoCert,
                                                         cCodCobert,
                                                         cParam,
                                                         nAsegurado);
        END IF;
        RETURN(nPrima);
    END;

    FUNCTION PRE_SUMA_BIEN(nIdeBien NUMBER) RETURN NUMBER IS
        nSumaAseg         NUMBER(14, 2) := 0;
        nMtoValBien       NUMBER(14, 2) := 0;
        nMtoValBienMoneda NUMBER(14, 2) := 0;
        nPorcRiesgo       NUMBER(7, 4);
        cStsBien          VARCHAR2(3);
        nNumModmax        NUMBER(3);
        nExiste           NUMBER(3);
    BEGIN
        BEGIN
            SELECT MtoValBien, MtoValBienMoneda, PorcRiesgo, StsBien
              INTO nMtoValBien, nMtoValBienMoneda, nPorcRiesgo, cStsBien
              FROM BIEN_CERT
             WHERE IdeBien = nIdeBien;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN(nSumaAseg);
        END;
        IF cStsBien = 'MOD' THEN
            BEGIN
                SELECT MAX(NumMod)
                  INTO nNumModmax
                  FROM MOD_BIEN_CERT
                 WHERE IdeBien = nIdebien
                   AND STSMODBIEN NOT IN ('VAL', 'ANU', 'EXC');
                nExiste := 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nExiste := 0;
            END;
            IF NVL(nExiste, 0) = 1 THEN
                BEGIN
                    SELECT MtoValBienMoneda
                      INTO nMtoValBienMoneda
                      FROM MOD_BIEN_CERT
                     WHERE IdeBien = nIdeBien
                       AND NumMod = nNumModMax;
                END;
            END IF;
        END IF;
        nSumaAseg := (nMtoValBienMoneda * nPorcRiesgo) / 100;
        RETURN(nSumaAseg);
    END;

    FUNCTION PRE_DEDUCIBLE(nIdePol      NUMBER,
                           nNumCert     NUMBER,
                           cCodProd     VARCHAR2,
                           cCodPlan     VARCHAR2,
                           cRevPlan     VARCHAR2,
                           cCodRamoCert VARCHAR2,
                           cCodCobert   VARCHAR2,
                           cParam       VARCHAR2,
                           nAsegurado   NUMBER,
                           nIdeCotiza   NUMBER DEFAULT NULL) RETURN NUMBER IS
        nDeducible NUMBER(14, 2) := 0;
        cValEst1   VARCHAR2(3);
        cValEst2   VARCHAR2(3);
        dFecNac    DATE;
        dFecIniVig DATE;
        nEdad      NUMBER(4);
        cTipo      VARCHAR2(1);
        cCodParent VARCHAR2(4);
        dFechaMax  DATE;
    BEGIN
        IF cParam = 'TAREGM' THEN
            BEGIN
                SELECT C.FecNac, CodParent
                  INTO dFecNac, cCodParent
                  FROM ASEGURADO A, CLIENTE C
                 WHERE IdeAseg = nAsegurado
                   AND A.CodCli = C.CodCli;
            END;
            BEGIN
                SELECT FecIniVig
                  INTO dFecIniVig
                  FROM POLIZA
                 WHERE IdePol = nIdePol;
            END;
            nEdad := FLOOR((dFecIniVig - dFecNac) / 365);
            IF nEdad < 25 AND
               cCodParent IN ('0001', '0002', '0003', '0004') THEN
                nEdad := 25;
            END IF;
            BEGIN
                SELECT ValEst
                  INTO cValEst1
                  FROM EST_CERT
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND CodEst = 'LICOB';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    cValEst1 := NULL;
            END;
            BEGIN
                SELECT ValEst
                  INTO cValEst2
                  FROM EST_CERT
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND CodEst = 'DEDUC';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    cValEst2 := NULL;
            END;
            BEGIN
                SELECT Deducible
                  INTO nDeducible
                  FROM TARIFA_EXCESO
                 WHERE CodProd = cCodProd
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodEst1 = 'LICOB'
                   AND ValEst1 = cValEst1
                   AND CodEst2 = 'DEDUC'
                   AND ValEst2 = cValEst2
                   AND nEdad >= EdaIni
                   AND nEdad <= EdaFin;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nDeducible := 0;
            END;
         ELSIF cParam IN ('TARIESGO') THEN
            --  Coberturas a nivel de  ASEGURADO
            IF NVL(nAsegurado,0) > 0 THEN
                 BEGIN
                  SELECT T.Franquicia
                  INTO   nDeducible
                  FROM  POLIZA P, TARIFA_REGIONAL_NIVEL_RIESGO T, ASEGURADO A
                  WHERE P.IdePol          = nIdepol
                  AND   T.CODPROD         = cCodProd
                  AND   T.CodPlan         = cCodPlan
                  AND   T.REVPLAN         = cRevPlan
                  AND   T.CODRAMOPLAN     = cCodRamoCert
                  AND   T.CodOfi          = P.CodOfiSusc
                  AND   T.CodCobert       = cCodCobert
                  AND   A.IdeAseg         = nAsegurado
                  AND   T.NivelRiesgo     = A.NivelRiesgo;
                EXCEPTION WHEN OTHERS THEN
                     nDeducible         := 0;
                END;
            ELSE    --   Coberturas a nivel de  Certificados   
                BEGIN
                  SELECT T.Franquicia
                  INTO   nDeducible                  
                  FROM  POLIZA P, CERTIFICADO C, TARIFA_REGIONAL_NIVEL_RIESGO T
                  WHERE P.IdePol          = nIdepol
                  AND   C.IdePol          = P.IdePol
                  AND   C.NumCert         = nNumcert
                  AND   T.CODPROD         = cCodProd
                  AND   T.CodPlan         = cCodPlan
                  AND   T.REVPLAN         = cRevPlan
                  AND   T.CODRAMOPLAN     = cCodRamoCert
                  AND   T.CodOfi          = P.CodOfiSusc                  
                  AND   T.CodCobert       = cCodCobert
                  AND   T.NivelRiesgo     = C.NivelRiesgo;
                EXCEPTION WHEN OTHERS THEN
                     nDeducible         := 0;
                END;
            END IF;    
            RETURN(nDeducible);
            
        ELSIF cParam = '3DTARFI' THEN
            --cParam = 'TARFI3D' THEN       [TARIFA FIDELIDAD 3D]
            DECLARE
                nSumaAseg NUMBER(14, 2);
            BEGIN
                BEGIN
                    SELECT SumaAseg
                      INTO nSumaAseg
                      FROM DATOS_PART_FI3D
                     WHERE IdePol = nIdePol
                       AND Numcert = nNumcert
                       AND CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoCert = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;

                BEGIN
                    SELECT Deducible
                      INTO nDeducible
                      FROM TARIFA_FI3D_DEDUC
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND Codramoplan = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND nSumaAseg >= RANGOMIN
                       AND nSumaAseg <= RANGOMAX;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nDeducible := 0;
                END;
            END;

        ELSIF cParam = 'TAREQPR' THEN
            -------------- EQUIPOS ELECTRONICOS ---------
            DECLARE
                nSumaAseg NUMBER(14, 2);
            BEGIN
                BEGIN
                    SELECT SumaAseg
                      INTO nSumaAseg
                      FROM DATOS_PART_FI3D
                     WHERE IdePol = nIdePol
                       AND Numcert = nNumcert
                       AND CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoCert = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;

                BEGIN
                    SELECT Deducible
                      INTO nDeducible
                      FROM TARIFA_FI3D_DEDUC
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND Codramoplan = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND nSumaAseg >= RANGOMIN
                       AND nSumaAseg <= RANGOMAX;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nDeducible := 0;
                END;
            END;
        ----------------- TARIFICACION POR TASA
        -- Para las Cotizaciones de
        ELSIF cParam IN ('TARAUTFOR') and nIdeCotiza IS NOT NULL THEN
            BEGIN
              SELECT MAX(TA.Desde)
                INTO dFechaMax
                FROM TARIFA_AUT TA, COT_DATOS_PARTICULARES_AUTO DP, COTIZACION CO
               WHERE TA.Marca         = DECODE(TA.Marca,'%',TA.Marca,DP.CodMarca)
                 AND DECODE(TA.Modelo_final,0,9999,TA.Modelo_final) >= DP.AnoVeh
                 AND TA.Sumaseg_Ini   <= DP.ValorVeh
                 AND DECODE(TA.Sumaseg_Fin,0,999999999,TA.Sumaseg_Fin) >= DP.ValorVeh
                 AND TA.Oficina       = DECODE(TA.Oficina,'%',TA.oficina,CO.CodOfi)
                 AND TA.CodCobert     = cCodCobert
                 AND TA.CodRamoPlan   = cCodRamoCert
                 AND TA.RevPlan       = cRevPlan
                 AND TA.CodPlan       = cCodPlan
                 AND TA.CodProd       = cCodProd 
                 AND DP.IdCotizacion  = CO.IdCotiza
                 AND CO.IdCotiza      = nIdeCotiza;
            END;
            BEGIN
              SELECT ROUND(TA.Franquicia,2)
                INTO nDeducible
                FROM TARIFA_AUT TA, COT_DATOS_PARTICULARES_AUTO DP, COTIZACION CO
               WHERE TA.Desde         = dFechaMax
                 AND TA.Marca         = DECODE(TA.Marca,'%',TA.Marca,DP.CodMarca)
                 AND DECODE(TA.Modelo_final,0,9999,TA.Modelo_final) >= DP.AnoVeh
                 AND TA.Sumaseg_Ini   <= DP.ValorVeh
                 AND DECODE(TA.Sumaseg_Fin,0,999999999,TA.Sumaseg_Fin) >= DP.ValorVeh
                 AND TA.Oficina       = DECODE(TA.Oficina,'%',TA.oficina,CO.CodOfi)
                 AND TA.CodCobert     = cCodCobert
                 AND TA.CodRamoPlan   = cCodRamoCert
                 AND TA.RevPlan       = cRevPlan
                 AND TA.CodPlan       = cCodPlan
                 AND TA.CodProd       = cCodProd 
                 AND DP.IdCotizacion  = CO.IdCotiza
                 AND CO.IdCotiza      = nIdeCotiza;
            EXCEPTION 
                WHEN OTHERS THEN
                     nDeducible := 0;
            END;             
        -- TARIFICACION AUTO FORTALEZA
        ------------------------------
        -- HUMBERTO CHAHIN
        ELSIF cParam IN ('TARAUTFOR') and nIdeCotiza IS NULL THEN
            BEGIN
            SELECT ROUND(T.FRANQUICIA,2)
            INTO nDeducible
            FROM poliza p, cert_ramo cr, cert_veh c, TARIFA_AUT T
            WHERE p.idepol         = cr.idepol
              and cr.idepol        = c.idepol
              and cr.numcert       = c.numcert
              and cr.codramocert   = c.codramocert
              and p.codprod        = t.codprod
              and cr.codramocert   = t.codramoplan
              and cr.codplan       = t.codplan
              and cr.revplan       = t.revplan
              and T.desde          = ( select max(desde) from TARIFA_AUT
                                        where CodProd   = T.CODPROD
                                        AND CodRamoPlan = T.CODRAMOPLAN
                                        AND CodPlan     = T.CODPLAN
                                        AND RevPlan     = T.REVPLAN
                                        AND Codcobert   = T.CODCOBERT
                                        AND T.CODPROD     = cCodProd
                                        AND T.CODRAMOPLAN = cCodPlan
                                        AND T.REVPLAN     = cRevPlan
                                        AND T.CODCOBERT   = cCodCobert
                                        AND DESDE       < TO_DATE(SYSDATE,'DD/MM/YYYY') + 1
                                        AND Oficina     = DECODE(Oficina     ,'%',oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = P.IDEPOL))
                                        AND Marca       = DECODE(Marca       ,'%',Marca       ,C.CodMarca)
                                        AND Clase       = DECODE(Clase       ,'%',Clase       ,C.ClaseVeh)
                                        AND Categoria   = DECODE(Categoria   ,'%',Categoria   ,C.Clase)
                                        AND Subcategoria= DECODE(Subcategoria,'%',Subcategoria,C.Subcategoria)
                                        AND Cilindrada  = DECODE(cilindrada  ,0  ,cilindrada  ,C.codpotencia)
                                        AND nvl(Modelo_inicial,0) <= c.AnoVeh
                                        AND decode(Modelo_final,0,9999,Modelo_final)    >= c.AnoVeh
                                        AND Sumaseg_ini                                 <= c.Valor_total
                                        AND decode(Sumaseg_fin,0,999999999,Sumaseg_fin) >= c.Valor_total
                                        AND exists (select 'S' from Inspeccion I where I.NumExp = c.Numexp and i.tipoexp = 'SU'))
             AND T.Oficina        = DECODE(T.Oficina    ,'%',T.oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = P.IDEPOL))
             AND C.IdePol         = nIdepol
             AND C.NumCert        = nNumcert
             AND T.CODPROD        = cCodProd
             AND T.CODRAMOPLAN    = cCodPlan
             AND T.REVPLAN        = cRevPlan
             AND T.CODCOBERT      = cCodCobert
             --AND T.Tipo_Veh        = DECODE(T.Tipo_Veh    ,'%',T.Tipo_Veh    ,C.Tipomodelo)
             AND T.Clase           = DECODE(T.Clase       ,'%',T.Clase       ,C.ClaseVeh)
             AND T.Marca           = DECODE(T.Marca       ,'%',T.Marca       ,C.CodMarca)
             AND T.Categoria       = DECODE(T.Categoria   ,'%',T.Categoria   ,C.Clase)
             AND T.Subcategoria    = DECODE(T.Subcategoria,'%',T.Subcategoria,C.Subcategoria)
             AND T.Cilindrada      = DECODE(T.cilindrada  ,0  ,T.cilindrada  ,C.codpotencia)
             AND nvl(T.Modelo_inicial,0) <= c.AnoVeh
             AND decode(T.Modelo_final,0,9999,T.Modelo_final) >= c.AnoVeh
             AND T.Sumaseg_ini    <= c.Valor_total
             AND decode(T.Sumaseg_fin,0,999999999,T.Sumaseg_fin)    >= c.Valor_total
             AND exists (select 'S' from Inspeccion I where I.NumExp = c.Numexp and i.tipoexp = 'SU');
            EXCEPTION WHEN OTHERS THEN
                 nDeducible         := 0;
            END;

        -- TARIFICACION GENERALES
        -------------------------
        -- HUMBERTO CHAHIN
        ELSIF cParam IN ('TARGRFOR') THEN




           BEGIN
           SELECT DISTINCT ROUND(TG.FRANQUICIA,2)
           INTO nDeducible
           from BIEN_CERT BC, COBERT_BIEN CB, poliza PO, TARIFA_GRL TG
           WHERE BC.IDEPOL         = nIdepol
        --     AND BC.Idebien        = nIdeBien
             AND BC.IDEBIEN        = CB.IDEBIEN
             AND BC.IDEPOL         = PO.IDEPOL
             AND TG.CODPROD        = cCodProd
             AND TG.CODRAMOPLAN    = cCodRamoCert
             AND TG.REVPLAN        = cRevPlan
             AND TG.CODCOBERT      = cCodCobert
             AND TG.CODPLAN        = cCodPlan
       --      AND CB.IDECOBERT    = nIdeCobert
             AND TG.desde          = ( select max(desde) from TARIFA_GRL
                                       WHERE BC.IDEPOL         = nIdepol
                                         AND BC.IDEBIEN        = CB.IDEBIEN
                                         AND BC.IDEPOL         = PO.IDEPOL
                                         AND TG.CODPROD        = cCodProd
                                         AND TG.CODRAMOPLAN    = cCodRamoCert
                                         AND TG.REVPLAN        = cRevPlan
                                         AND TG.CODCOBERT      = cCodCobert
                                         AND TG.CODPLAN        = cCodPlan
                               --          AND CB.IDECOBERT      = nIdeCobert
                                         AND DESDE       < TO_DATE(SYSDATE,'DD/MM/YYYY') + 1
                                         AND Oficina     = DECODE(Oficina     ,'%',oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = PO.IDEPOL))
                                         AND Sumaseg_ini                                 <= BC.MTOVALBIENMONEDA
                                         AND decode(Sumaseg_fin,0,999999999,Sumaseg_fin) >= BC.MTOVALBIENMONEDA)

             AND TG.Oficina        = DECODE(TG.Oficina    ,'%',TG.oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = PO.IDEPOL))
             AND TG.Sumaseg_ini    <= BC.MTOVALBIENMONEDA
             AND decode(TG.Sumaseg_fin,0,999999999,TG.Sumaseg_fin) >= BC.MTOVALBIENMONEDA;
           EXCEPTION WHEN OTHERS THEN
                 nDeducible        := 0;
           END;
       END IF;
        RETURN(nDeducible);
    END;

    FUNCTION PRE_PORCDED(nIdePol      NUMBER,
                         nNumCert     NUMBER,
                         cCodProd     VARCHAR2,
                         cCodPlan     VARCHAR2,
                         cRevPlan     VARCHAR2,
                         cCodRamoCert VARCHAR2,
                         cCodCobert   VARCHAR2,
                         cParam       VARCHAR2,
                         nAsegurado   NUMBER,
                         nIdeCotiza   NUMBER DEFAULT NULL) RETURN NUMBER IS
        nPorcDed   NUMBER(14, 6) := 0;
        cValEst1   VARCHAR2(3);
        cValEst2   VARCHAR2(3);
        nDeducible NUMBER(14, 2);
        nSumaAseg  NUMBER(14, 2);
        dFecNac    DATE;
        nEdad      NUMBER(4);
        dFecIniVig DATE;
        cTipo      VARCHAR2(1);
        cCodParent VARCHAR2(4);
        V_tasa      NUMBER(14,6);
        dFechaMax   DATE;
    BEGIN
        IF cParam = 'TAREGM' THEN
            BEGIN
                SELECT C.FecNac, CodParent
                  INTO dFecNac, cCodParent
                  FROM ASEGURADO A, CLIENTE C
                 WHERE IdeAseg = nAsegurado
                   AND A.CodCli = C.CodCli;
            END;
            BEGIN
                SELECT FecIniVig
                  INTO dFecIniVig
                  FROM POLIZA
                 WHERE IdePol = nIdePol;
            END;
            nEdad := FLOOR((dFecIniVig - dFecNac) / 365);
            IF nEdad < 25 AND
               cCodParent IN ('0001', '0002', '0003', '0004') THEN
                nEdad := 25;
            END IF;
            BEGIN
                SELECT ValEst
                  INTO cValEst1
                  FROM EST_CERT
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND CodEst = 'LICOB';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    cValEst1 := NULL;
            END;
            BEGIN
                SELECT ValEst
                  INTO cValEst2
                  FROM EST_CERT
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodRamoCert = cCodRamoCert
                   AND CodEst = 'DEDUC';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    cValEst2 := NULL;
            END;
            BEGIN
                SELECT Deducible, LimiteCobertura
                  INTO nDeducible, nSumaAseg
                  FROM TARIFA_EXCESO
                 WHERE CodProd = cCodProd
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodEst1 = 'LICOB'
                   AND ValEst1 = cValEst1
                   AND CodEst2 = 'DEDUC'
                   AND ValEst2 = cValEst2
                   AND nEdad >= EdaIni
                   AND nEdad <= EdaFin;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nDeducible := 0;

            END;
            nPorcDed := (nDeducible * 100) / nSumaAseg;
        ELSIF cParam = 'TARFI3D' THEN
            --- [TARIFA FIDELIDAD 3D]
            DECLARE
                nSumaAseg NUMBER(14, 2);
            BEGIN
                BEGIN
                    SELECT SumaAseg
                      INTO nSumaAseg
                      FROM DATOS_PART_FI3D
                     WHERE IdePol = nIdePol
                       AND Numcert = nNumcert
                       AND CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND CodRamoCert = cCodRamoCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nSumaAseg := 0;
                END;
                BEGIN
                    SELECT Deducible
                      INTO nDeducible
                      FROM TARIFA_FI3D_DEDUC
                     WHERE CodProd = cCodProd
                       AND CodPlan = cCodPlan
                       AND RevPlan = cRevPlan
                       AND Codramoplan = cCodRamoCert
                       AND CodCobert = cCodCobert
                       AND nSumaAseg >= RANGOMIN
                       AND nSumaAseg <= RANGOMAX;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nDeducible := 0;
                END;
                nPorcDed := (nDeducible * 100) / nSumaAseg;
            END;
        ELSIF cParam = 'TRANVET' THEN
            BEGIN
                SELECT NVL(MAX(PorcDed), 0)
                  INTO nPorcDed
                  FROM COBERT_CERT
                 WHERE IdePol = nIdePol
                   AND NumCert = nNumCert
                   AND CodCobert = cCodCobert;
            END;
        ----------------- TARIFICACION POR TASA
        -- Para las Cotizaciones de
        ELSIF cParam IN ('TARAUTFOR') and nIdeCotiza IS NOT NULL THEN
            BEGIN
              SELECT MAX(TA.Desde)
                INTO dFechaMax
                FROM TARIFA_AUT TA, COT_DATOS_PARTICULARES_AUTO DP, COTIZACION CO
               WHERE TA.Marca         = DECODE(TA.Marca,'%',TA.Marca,DP.CodMarca)
                 AND DECODE(TA.Modelo_final,0,9999,TA.Modelo_final) >= DP.AnoVeh
                 AND TA.Sumaseg_Ini   <= DP.ValorVeh
                 AND DECODE(TA.Sumaseg_Fin,0,999999999,TA.Sumaseg_Fin) >= DP.ValorVeh
                 AND TA.Oficina       = DECODE(TA.Oficina,'%',TA.oficina,CO.CodOfi)
                 AND TA.CodCobert     = cCodCobert
                 AND TA.CodRamoPlan   = cCodRamoCert
                 AND TA.RevPlan       = cRevPlan
                 AND TA.CodPlan       = cCodPlan
                 AND TA.CodProd       = cCodProd 
                 AND DP.IdCotizacion  = CO.IdCotiza
                 AND CO.IdCotiza      = nIdeCotiza;
            END;
            BEGIN
              SELECT ROUND(TA.TasaDedu,4)
                INTO nPorcDed
                FROM TARIFA_AUT TA, COT_DATOS_PARTICULARES_AUTO DP, COTIZACION CO
               WHERE TA.Desde         = dFechaMax
                 AND TA.Marca         = DECODE(TA.Marca,'%',TA.Marca,DP.CodMarca)
                 AND DECODE(TA.Modelo_final,0,9999,TA.Modelo_final) >= DP.AnoVeh
                 AND TA.Sumaseg_Ini   <= DP.ValorVeh
                 AND DECODE(TA.Sumaseg_Fin,0,999999999,TA.Sumaseg_Fin) >= DP.ValorVeh
                 AND TA.Oficina       = DECODE(TA.Oficina,'%',TA.oficina,CO.CodOfi)
                 AND TA.CodCobert     = cCodCobert
                 AND TA.CodRamoPlan   = cCodRamoCert
                 AND TA.RevPlan       = cRevPlan
                 AND TA.CodPlan       = cCodPlan
                 AND TA.CodProd       = cCodProd 
                 AND DP.IdCotizacion  = CO.IdCotiza
                 AND CO.IdCotiza      = nIdeCotiza;
            EXCEPTION 
                WHEN OTHERS THEN
                     nPorcDed := 0;
            END;        
        ELSIF cParam IN ('TARAUTFOR') and nIdeCotiza IS NULL THEN
            BEGIN
            SELECT ROUND(T.TASADEDU,4)
            INTO nPorcDed
            FROM poliza p, cert_ramo cr, cert_veh c, TARIFA_AUT T
            WHERE p.idepol         = cr.idepol
              and cr.idepol        = c.idepol
              and cr.numcert       = c.numcert
              and cr.codramocert   = c.codramocert
              and p.codprod        = t.codprod
              and cr.codramocert   = t.codramoplan
              and cr.codplan       = t.codplan
              and cr.revplan       = t.revplan
              and T.desde          = ( select max(desde) from TARIFA_AUT
                                        where CodProd   = T.CODPROD
                                        AND CodRamoPlan = T.CODRAMOPLAN
                                        AND CodPlan     = T.CODPLAN
                                        AND RevPlan     = T.REVPLAN
                                        AND Codcobert   = T.CODCOBERT
                                        AND T.CODPROD     = cCodProd
                                        AND T.CODRAMOPLAN = cCodPlan
                                        AND T.REVPLAN     = cRevPlan
                                        AND T.CODCOBERT   = cCodCobert
                                        AND DESDE       < TO_DATE(SYSDATE,'DD/MM/YYYY') + 1
                                        AND Oficina     = DECODE(Oficina     ,'%',oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = P.IDEPOL))
                                        AND Marca       = DECODE(Marca       ,'%',Marca       ,C.CodMarca)
                                        AND Clase       = DECODE(Clase       ,'%',Clase       ,C.ClaseVeh)
                                        AND Categoria   = DECODE(Categoria   ,'%',Categoria   ,C.Clase)
                                        AND Subcategoria= DECODE(Subcategoria,'%',Subcategoria,C.Subcategoria)
                                        AND Cilindrada  = DECODE(cilindrada  ,0  ,cilindrada  ,C.codpotencia)
                                        AND nvl(Modelo_inicial,0) <= c.AnoVeh
                                        AND decode(Modelo_final,0,9999,Modelo_final)    >= c.AnoVeh
                                        AND Sumaseg_ini                                 <= c.Valor_total
                                        AND decode(Sumaseg_fin,0,999999999,Sumaseg_fin) >= c.Valor_total
                                        AND exists (select 'S' from Inspeccion I where I.NumExp = c.Numexp and i.tipoexp = 'SU'))
             AND T.Oficina        = DECODE(T.Oficina    ,'%',T.oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = P.IDEPOL))
             AND C.IdePol         = nIdepol
             AND C.NumCert        = nNumcert
             AND T.CODPROD        = cCodProd
             AND T.CODRAMOPLAN    = cCodPlan
             AND T.REVPLAN        = cRevPlan
             AND T.CODCOBERT      = cCodCobert
             --AND T.Tipo_Veh        = DECODE(T.Tipo_Veh    ,'%',T.Tipo_Veh    ,C.Tipomodelo)
             AND T.Clase           = DECODE(T.Clase       ,'%',T.Clase       ,C.ClaseVeh)
             AND T.Marca           = DECODE(T.Marca       ,'%',T.Marca       ,C.CodMarca)
             AND T.Categoria       = DECODE(T.Categoria   ,'%',T.Categoria   ,C.Clase)
             AND T.Subcategoria    = DECODE(T.Subcategoria,'%',T.Subcategoria,C.Subcategoria)
             AND T.Cilindrada      = DECODE(T.cilindrada  ,0  ,T.cilindrada  ,C.codpotencia)
             AND nvl(T.Modelo_inicial,0) <= c.AnoVeh
             AND decode(T.Modelo_final,0,9999,T.Modelo_final) >= c.AnoVeh
             AND T.Sumaseg_ini    <= c.Valor_total
             AND decode(T.Sumaseg_fin,0,999999999,T.Sumaseg_fin)    >= c.Valor_total
             AND exists (select 'S' from Inspeccion I where I.NumExp = c.Numexp and i.tipoexp = 'SU');
            EXCEPTION WHEN OTHERS THEN
                 nPorcDed        := 0;
            END;
       ELSIF cParam IN ('TARGRFOR') THEN                   -------  TARIFICACION RUBROS GENERALES
            BEGIN
            SELECT DISTINCT ROUND(TG.TASADEDU,4)
            INTO nPorcDed
            from BIEN_CERT BC, COBERT_BIEN CB, poliza PO, TARIFA_GRL TG
            WHERE BC.IDEPOL         = nIdepol
        --      AND BC.Idebien        = nIdeBien
              AND BC.IDEBIEN        = CB.IDEBIEN
              AND BC.IDEPOL         = PO.IDEPOL
              AND TG.CODPROD        = cCodProd
              AND TG.CODRAMOPLAN    = cCodRamoCert
              AND TG.REVPLAN        = cRevPlan
              AND TG.CODCOBERT      = cCodCobert
              AND TG.CODPLAN        = cCodPlan
       --       AND CB.IDECOBERT      = nIdeCobert
              AND TG.desde          = ( select max(desde) from TARIFA_GRL
                                        WHERE BC.IDEPOL         = nIdepol
                                          AND BC.IDEBIEN        = CB.IDEBIEN
                                          AND BC.IDEPOL         = PO.IDEPOL
                                          AND TG.CODPROD        = cCodProd
                                          AND TG.CODRAMOPLAN    = cCodRamoCert
                                          AND TG.REVPLAN        = cRevPlan
                                          AND TG.CODCOBERT      = cCodCobert
                                          AND TG.CODPLAN        = cCodPlan
                              --            AND CB.IDECOBERT      = nIdeCobert
                                          AND DESDE       < TO_DATE(SYSDATE,'DD/MM/YYYY') + 1
                                          AND Oficina     = DECODE(Oficina     ,'%',oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = PO.IDEPOL))
                                          AND Sumaseg_ini                                 <= BC.MTOVALBIENMONEDA
                                          AND decode(Sumaseg_fin,0,999999999,Sumaseg_fin) >= BC.MTOVALBIENMONEDA)
              AND TG.Oficina        = DECODE(TG.Oficina    ,'%',TG.oficina,(SELECT codofiemi FROM POLIZA WHERE IDEPOL = PO.IDEPOL))
              AND TG.Sumaseg_ini    <= BC.MTOVALBIENMONEDA
              AND decode(TG.Sumaseg_fin,0,999999999,TG.Sumaseg_fin) >= BC.MTOVALBIENMONEDA;
            EXCEPTION WHEN OTHERS THEN
                  nPorcDed        := 0;
            END;
        END IF;
        RETURN(nPorcDed);
    END;

    FUNCTION PRE_COASEG_PACTADO(nIdePol      NUMBER,
                                nNumCert     NUMBER,
                                cCodProd     VARCHAR2,
                                cCodPlan     VARCHAR2,
                                cRevPlan     VARCHAR2,
                                cCodRamoCert VARCHAR2,
                                cCodCobert   VARCHAR2,
                                cParam       VARCHAR2,
                                nIdeBien     NUMBER) RETURN NUMBER IS
        nPorCoaPact     NUMBER(7, 4);
        nPorcCoapactDet NUMBER(7, 4);
        cExiste         VARCHAR2(1) := 'N';
        cIndCoaseguro   VARCHAR2(1);
        cClaseBien      VARCHAR2(3);
        cCodBien        VARCHAR2(4);
    BEGIN
        BEGIN
            SELECT DISTINCT 'S'
              INTO cExiste
              FROM CERT_VEH cv
             WHERE IdePol = nIdePol
               AND NumCert = nNumCert
               and exists (select 'S'
                      from Inspeccion I
                     where I.NumExp = cv.Numexp
                       and i.tipoexp = 'SU');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cExiste := 'N';
        END;
        IF cExiste = 'S' THEN
            BEGIN
                SELECT PorCoaPact
                  INTO nPorCoaPact
                  FROM TARIFA_AUTO_COASEGURO
                 WHERE CodProd = cCodProd
                   AND CodPlan = cCodPlan
                   AND RevPlan = cRevPlan
                   AND CodRamoPlan = cCodRamoCert
                   AND CodCobert = cCodCobert;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    nPorCoaPact := 0;
            END;
        END IF;

        IF cParam = 'TARROBOP' THEN
            DECLARE
                nPorc_Coa NUMBER(7, 4);
            BEGIN
                BEGIN
                    SELECT ClaseBien, CodBien
                      INTO cClaseBien, cCodBien
                      FROM BIEN_CERT
                     WHERE IdeBien = nIdeBien;
                END;
                BEGIN
                    SELECT NVL(PorCoaPact, 0)
                      INTO nPorCoaPact
                      FROM BIEN_CERT
                     WHERE IdeBien = nIdeBien;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nPorCoaPact := 0;
                END;
                BEGIN
                    SELECT NVL(Porc_Coa, 0), IndCoaseguro
                      INTO nPorc_Coa, cIndCoaseguro
                      FROM DATOS_PART_ROBO
                     WHERE IdePol = nIdePol
                       AND NumCert = nNumCert;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nPorc_Coa := 0;
                        NULL;
                END;
                IF NVL(cIndCoaseguro, ' ') = 'S' THEN
                    BEGIN
                        SELECT PORCCOAPACT
                          INTO nPorcCoapactDet
                          FROM DET_DATOS_PART_ROBO
                         WHERE IDEPOL = nIdePol
                           AND NUMCERT = nNumCert
                           AND CLASEBIEN = cClaseBien
                           AND CODBIEN = cCodBien;
                    exception
                        when no_data_found then
                            RAISE_APPLICATION_ERROR(-20213,
                                                    'No posee Coaseguro pactado Para Esta Clase y Codigo del bien ');
                    END;
                    IF nPorcCoapactDet > 0 THEN
                        nPorCoaPact := nPorcCoapactDet;
                    END IF;
                ELSE
                    IF nPorc_Coa > 0 THEN
                        -- ROBO
                        nPorCoaPact := nPorc_Coa;
                    ELSE
                        RETURN(nPorCoaPact);
                    END IF;
                END IF;
            END;
        END IF;
        RETURN(nPorCoaPact);
    END;

    FUNCTION PRE_SUMA_LEY(nIdePol    NUMBER,
                          nNumCert   NUMBER,
                          cCodCobert VARCHAR2) RETURN NUMBER IS
        cTipVeh          VARCHAR2(3);
        cPlanMin         VARCHAR2(3);
        cLimMin          VARCHAR2(3);
        cCodPotencia     VARCHAR2(3);
        cDPA             VARCHAR2(4);
        nLIM_DPA         NUMBER(2);
        cRCP             VARCHAR2(4);
        nLIM_RCP         NUMBER(2);
        cRCPM            VARCHAR2(4);
        nLIM_RCPM        NUMBER(2);
        cLCM             VARCHAR2(4);
        nLIM_LCM         NUMBER(2);
        cLCMM            VARCHAR2(4);
        nLIM_LCMM        NUMBER(2);
        cACCC            VARCHAR2(4);
        nLIM_ACCC        NUMBER(2);
        cCodTarifa       VARCHAR2(3);
        cUso_Veh         VARCHAR2(3);
        nLimite          NUMBER(14, 2);
        nLimMin          NUMBER(14, 2);
        cFianza          VARCHAR2(4);
        cPeones          VARCHAR2(4);
        nSumaAsegFianza  NUMBER(14, 2);
        nSumaAsegCondMin NUMBER(14, 2);
        nSumaAsegCondMax NUMBER(14, 2);
        nSumaAsegPeones  NUMBER(14, 2);
        nSumaAseg        NUMBER(14, 2);
        cRemolque        VARCHAR2(4);
        nRecargoRemolque NUMBER(8, 2);
        nRecargoPot      NUMBER(8, 2);
        nRecargoUso      NUMBER(8, 2);
        cRemolque        VARCHAR2(4);
        cCodRemolque     VARCHAR2(5);

        CURSOR C1 IS
            SELECT DISTINCT TIPO, CODTARIFA
              FROM RECA_DCTO_LEY
             WHERE TipVeh = cTipVeh
               AND TIPO = 'P'
               AND CODRECADCTO = cCodPotencia
            UNION
            SELECT DISTINCT TIPO, CODTARIFA
              FROM RECA_DCTO_LEY
             WHERE TipVeh = cTipVeh
               AND TIPO = 'U'
               AND CODRECADCTO = cUso_Veh
            UNION
            SELECT DISTINCT TIPO, CODTARIFA
              FROM RECA_DCTO_LEY
             WHERE TipVeh = cTipVeh
               AND TIPO = 'R'
               AND CODRECADCTO = cCodRemolque;

    BEGIN
        BEGIN
            SELECT CodPotencia, Uso_Veh, PlanMin, TipoModelo
              INTO cCodPotencia, cUso_Veh, cPlanMin, cTipVeh
              FROM CERT_VEH cv
             WHERE Idepol = nIdepol
               AND NumCert = nNumCert
               and exists (select 'S'
                      from Inspeccion I
                     where I.NumExp = cv.Numexp
                       and i.tipoexp = 'SU');

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20100,
                                        'Debe Indicar los Datos Particulares... Favor Revice...');
        END;
        ---------- ----------------------------
        --- TIPO DE RECARGO -----

        FOR C2 IN C1 LOOP
            cCodTarifa := c2.CodTarifa;
            --------------------------
            ---- CALCULAR LA TASA ----
            --------------------------
            -- BUSCA LA SUMA ASEGURADA MINIMA Y MAXIMA  ----
            IF c2.Tipo = 'P' THEN
                ------- POTENCIA -----
                BEGIN
                    SELECT RECARGO
                      INTO nRecargoPot
                      FROM RECA_DCTO_LEY
                     WHERE CODTARIFA = C2.CODTARIFA
                       AND TIPO = C2.TIPO
                       AND CODRECADCTO = cCodPotencia
                       AND TIPVEH = cTipVeh;
                END;
            ELSIF c2.TIPO = 'U' THEN
                --- USO -----------
                BEGIN
                    SELECT RECARGO
                      INTO nRecargoUso
                      FROM RECA_DCTO_LEY
                     WHERE CODTARIFA = C2.CODTARIFA
                       AND TIPO = C2.TIPO
                       AND CODRECADCTO = cUso_Veh
                       AND TIPVEH = cTipVeh;
                END;
            ELSIF c2.TIPO = 'R' THEN
                ---- REMOLQUE --------
                BEGIN
                    SELECT RECARGO
                      INTO nRecargoRemolque
                      FROM RECA_DCTO_LEY
                     WHERE CODTARIFA = C2.CODTARIFA
                       AND TIPO = C2.TIPO
                       AND CODRECADCTO = cCodRemolque
                       AND TIPVEH = cTipVeh;
                END;
            END IF;
        END LOOP;

        /*
        BEGIN
           SELECT P.CodTarifa
           INTO   cCodTarifa
           FROM   Potencia P, Uso_Vehiculo U
           WHERE  P.CodPotencia = cCodPotencia
           AND    P.TipVeh      = cTipVeh
           AND    P.CodTarifa   = U.CodTarifa
           AND    P.TipVeh      = U.TipVeh
           AND    U.CodUsoVeh   = cUso_Veh;
        EXCEPTION
           WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20100,'La Tarifa esta Mal Configurada Idepol:'||nIdepol ||
                                          'Revisar Datos Particulares del vehiculo '||
                                          'potencia '||cCodPotencia||
                                          'tipo veh '||cTipVeh||
                                          'uso      '||cUso_Veh ||
                                          'NUMCERT   '||nNumCert);

        END;
        */
        BEGIN
            SELECT DPA,
                   Lim_DPA,
                   RCP,
                   Lim_RCP,
                   RCPM,
                   Lim_RCPM,
                   LCM,
                   Lim_LCM,
                   LCMM,
                   Lim_LCMM,
                   Fianza,
                   SumaAsegFianza,
                   Peones,
                   SumaAsegPeones,
                   ACCC,
                   PlanMin,
                   SumaAsegCondMin,
                   SumaAsegCondMax
              INTO cDPA,
                   nLim_DPA,
                   cRCP,
                   nLim_RCP,
                   cRCPM,
                   nLim_RCPM,
                   cLCM,
                   nLim_LCM,
                   cLCMM,
                   nLim_LCMM,
                   cFianza,
                   nSumaAsegFianza,
                   cPeones,
                   nSumaAsegPeones,
                   cACCC,
                   cLimMin,
                   nSumaAsegCondMin,
                   nSumaAsegCondMax
              FROM Tarifa_Veh
             WHERE CodTarifa = cCodTarifa;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        BEGIN
            SELECT TO_NUMBER(SUBSTR(DESCRIP, 1, INSTR(DESCRIP, '/') - 1))
              INTO nLimite
              FROM LIMITE
             WHERE Codigo = cPlanMin; --Limite Minimo que viene de la Poliza
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
                /* RAISE_APPLICATION_ERROR(-20100,
                'La Tarifa esta Mal Configurada Idepol:' ||
                nIdepol);*/

        END;

        BEGIN
            SELECT TO_NUMBER(SUBSTR(DESCRIP, 1, INSTR(DESCRIP, '/') - 1))
              INTO nLimMin
              FROM LIMITE
             WHERE Codigo = cLimMin; --Limite Minimo que viene de la Tarifa
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
                /*     RAISE_APPLICATION_ERROR(-20100,
                'La Tarifa esta Mal Configurada Idepol:' ||
                nIdepol);*/

        END;

        IF cCodCobert = cDPA THEN
            nSumaAseg := nLimite * 1000 * nLim_DPA;
        END IF;
        IF cCodCobert = cRCP THEN
            nSumaAseg := nLimite * 1000 * nLim_RCP;
        END IF;
        IF cCodCobert = cRCPM THEN
            nSumaAseg := nLimite * 1000 * nLim_RCPM;
        END IF;
        IF cCodCobert = cLCM THEN
            nSumaAseg := nLimite * 1000 * nLim_LCM;
        END IF;
        IF cCodCobert = cLCMM THEN
            nSumaAseg := nLimite * 1000 * nLim_LCMM;
        END IF;
        IF cCodCobert = cFianza THEN
            nSumaAseg := nSumaAsegFianza;
        END IF;
        IF cCodCobert = cACCC AND nLimite <= nLimMin THEN
            nSumaAseg := nSumaAsegCondMin;
        END IF;
        IF cCodCobert = cACCC AND nLimite > nLimMin THEN
            nSumaAseg := nSumaAsegCondMax;
        END IF;
        IF cCodCobert = cPeones THEN
            nSumaAseg := nSumaAsegPeones;
        END IF;
        RETURN(nSumaAseg);
    END;
    ----
    FUNCTION PRE_PRIMA_LEY(nIdePol    NUMBER,
                           nNumCert   NUMBER,
                           cCodCobert VARCHAR2,
                           cPlanMin   VARCHAR2) RETURN NUMBER IS
        nPrima           NUMBER(14, 2) := 0;
        cTipVeh          VARCHAR2(3);
        cLimMin          VARCHAR2(3);
        cCodPotencia     VARCHAR2(3);
        cDPA             VARCHAR2(4);
        nLIM_DPA         NUMBER(2);
        cRCP             VARCHAR2(4);
        nLIM_RCP         NUMBER(2);
        cRCPM            VARCHAR2(4);
        nLIM_RCPM        NUMBER(2);
        cLCM             VARCHAR2(4);
        nLIM_LCM         NUMBER(2);
        cLCMM            VARCHAR2(4);
        nLIM_LCMM        NUMBER(2);
        cACCC            VARCHAR2(4);
        nLIM_ACCC        NUMBER(2);
        cCodTarifa       VARCHAR2(3);
        cUso_Veh         VARCHAR2(3);
        nLimite          NUMBER(14, 2);
        nLimMin          NUMBER(14, 2);
        cFianza          VARCHAR2(4);
        cPeones          VARCHAR2(4);
        cRemolque        VARCHAR2(4);
        nSumaAsegFianza  NUMBER(14, 2);
        nSumaAsegCondMin NUMBER(14, 2);
        nSumaAsegCondMax NUMBER(14, 2);
        nSumaAsegPeones  NUMBER(14, 2);
        nPorc_RC         NUMBER(14, 3);
        nPorc_DPA        NUMBER(14, 3);
        nPorc_RC_Rem     NUMBER(14, 3);
        nPorc_DPA_Rem    NUMBER(14, 3);
        nPorc_RCP        NUMBER(14, 3);
        nIncremento      NUMBER(8, 2);
        nPrimaM          NUMBER(14, 3);
        nTasaFianza      NUMBER(14, 2);
        nTasaCond        NUMBER(14, 3);
        nRecargoPot      NUMBER(8, 2);
        nRecargoUso      NUMBER(8, 2);
        nPasajeroPlan    NUMBER(3);
        nPasajeroVeh     NUMBER(3);
        nRecargoPasaj    NUMBER(8, 2);
        nRecPasaj        NUMBER(6, 2);
        nTasaPeones      NUMBER(14, 2);
        nSumaAseg        NUMBER(14, 2);
        cCodRemolque     VARCHAR2(5);
        cTipo            VARCHAR2(1);
        nRecargoRemolque NUMBER(8, 2);

        CURSOR C1 IS
            SELECT DISTINCT TIPO, CODTARIFA
              FROM RECA_DCTO_LEY
             WHERE TipVeh = cTipVeh
               AND TIPO = 'P'
               AND CODRECADCTO = cCodPotencia
            UNION
            SELECT DISTINCT TIPO, CODTARIFA
              FROM RECA_DCTO_LEY
             WHERE TipVeh = cTipVeh
               AND TIPO = 'U'
               AND CODRECADCTO = cUso_Veh
            UNION
            SELECT DISTINCT TIPO, CODTARIFA
              FROM RECA_DCTO_LEY
             WHERE TipVeh = cTipVeh
               AND TIPO = 'R'
               AND CODRECADCTO = cCodRemolque;
    BEGIN

        BEGIN
            SELECT CodPotencia,
                   Uso_Veh,
                   NumPuestos,
                   TipoModelo,
                   CodRemolque
              INTO cCodPotencia,
                   cUso_Veh,
                   nPasajeroVeh,
                   cTipVeh,
                   cCodRemolque
              FROM CERT_VEH cv
             WHERE Idepol = nIdepol
               AND NumCert = nNumCert
               and exists (select 'S'
                      from Inspeccion I
                     where I.NumExp = cv.Numexp
                       and i.tipoexp = 'SU');

        END;
        ---------- ----------------------------
        --- TIPO DE RECARGO -----

        FOR C2 IN C1 LOOP
            cCodTarifa := c2.CodTarifa;
            --------------------------
            ---- CALCULAR LA TASA ----
            --------------------------
            -- BUSCA LA SUMA ASEGURADA MINIMA Y MAXIMA  ----
            IF c2.Tipo = 'P' THEN
                ------- POTENCIA -----
                BEGIN
                    SELECT RECARGO
                      INTO nRecargoPot
                      FROM RECA_DCTO_LEY
                     WHERE CODTARIFA = C2.CODTARIFA
                       AND TIPO = C2.TIPO
                       AND CODRECADCTO = cCodPotencia
                       AND TIPVEH = cTipVeh;
                END;
            ELSIF c2.TIPO = 'U' THEN
                --- USO -----------
                BEGIN
                    SELECT RECARGO
                      INTO nRecargoUso
                      FROM RECA_DCTO_LEY
                     WHERE CODTARIFA = C2.CODTARIFA
                       AND TIPO = C2.TIPO
                       AND CODRECADCTO = cUso_Veh
                       AND TIPVEH = cTipVeh;
                END;
            ELSIF c2.TIPO = 'R' THEN
                ---- REMOLQUE --------
                BEGIN
                    SELECT RECARGO
                      INTO nRecargoRemolque
                      FROM RECA_DCTO_LEY
                     WHERE CODTARIFA = C2.CODTARIFA
                       AND TIPO = C2.TIPO
                       AND CODRECADCTO = cCodRemolque
                       AND TIPVEH = cTipVeh;
                END;
            END IF;
        END LOOP;

        BEGIN
            SELECT DPA,
                   Lim_DPA,
                   RCP,
                   Lim_RCP,
                   RCPM,
                   Lim_RCPM,
                   LCM,
                   Lim_LCM,
                   LCMM,
                   Lim_LCMM,
                   Fianza,
                   SumaAsegFianza,
                   Peones,
                   SumaAsegPeones,
                   Remolque,
                   ACCC,
                   PlanMin,
                   SumaAsegCondMin,
                   SumaAsegCondMax,
                   Porc_RC,
                   Porc_DPA,
                   Porc_RC_Rem,
                   Porc_DPA_Rem,
                   Porc_RCP,
                   Prima,
                   TasaFianza,
                   TasaCond,
                   PasajMin,
                   RecPasaj,
                   TasaPeones
              INTO cDPA,
                   nLim_DPA,
                   cRCP,
                   nLim_RCP,
                   cRCPM,
                   nLim_RCPM,
                   cLCM,
                   nLim_LCM,
                   cLCMM,
                   nLim_LCMM,
                   cFianza,
                   nSumaAsegFianza,
                   cPeones,
                   nSumaAsegPeones,
                   cRemolque,
                   cACCC,
                   cLimMin,
                   nSumaAsegCondMin,
                   nSumaAsegCondMax,
                   nPorc_RC,
                   nPorc_DPA,
                   nPorc_RC_Rem,
                   nPorc_DPA_Rem,
                   nPorc_RCP,
                   nPrimaM,
                   nTasaFianza,
                   nTasaCond,
                   nPasajeroPlan,
                   nRecPasaj,
                   nTasaPeones
              FROM Tarifa_Veh
             WHERE CodTarifa = cCodTarifa;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;

        BEGIN
            SELECT TO_NUMBER(SUBSTR(DESCRIP, 1, INSTR(DESCRIP, '/') - 1)),
                   (Incremento / 100 + 1)
              INTO nLimite, nIncremento
              FROM LIMITE
             WHERE Codigo = cPlanMin; --Limite Minimo que viene de la Poliza
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;

        nRecargoRemolque := (nvl(nLimite, 0) * 10 * 3 *
                            nvl(nRecargoRemolque, 0)); --- .20
        --- este recargo de remolque se le debe colocar
        ---- dpa = 50 %
        ---- rc  = 50 %

        BEGIN
            SELECT TO_NUMBER(SUBSTR(DESCRIP, 1, INSTR(DESCRIP, '/') - 1))
              INTO nLimMin
              FROM LIMITE
             WHERE Codigo = cLimMin; --Limite Minimo que viene de la Tarifa
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;

        IF nPasajeroVeh > nPasajeroPlan THEN
            nRecargoPasaj := (nPasajeroVeh - nPasajeroPlan) * nRecPasaj *
                             nIncremento;
        ELSE
            nRecargoPasaj := 0;
        END IF;
        nPrimaM := NVL(nPrimaM, 0) * (1 + NVL(nRecargoPot, 0) / 100); --Se recarga la prima por la potencia
        nPrimaM := NVL(nPrimaM, 0) * (1 + NVL(nRecargoUso, 0) / 100); --Se recarga la prima por el uso

        IF cCodCobert = cDPA THEN
            nPrima := nPrimaM * nPorc_DPA * 0.01 * nIncremento;
            -- nPrima:= nPrima + nPorc_DPA_Rem/100 * nRecargoRemolque;
            -- Se le aplica 50% segun recargo por remolque
        END IF;

        IF cCodCobert = cRCP THEN
            nSumaAseg := nLimite * 1000 * nLim_RCP;
        END IF;
        IF cCodCobert = cRCPM THEN
            nPrima := nPrimaM * nPorc_RC * 0.01 * nIncremento;
            -- nPrima:= nPrima + nPorc_RC_Rem/100 * nRecargoRemolque;
            -- Se le aplica 50% segun recargo por remolque
        END IF;
        IF cCodCobert = cLCM THEN
            nSumaAseg := nLimite * 1000 * nLim_LCM;
        END IF;

        IF cCodCobert = cLCMM THEN
            nPrima := (nPrimaM * nPorc_RCP * 0.01 * nIncremento) +
                      nRecargoPasaj;
        END IF;
        IF cCodCobert = cACCC AND nLimite <= nLimMin THEN
            nSumaAseg := nSumaAsegCondMin;
        END IF;
        IF cCodCobert = cACCC AND nLimite > nLimMin THEN
            nSumaAseg := nSumaAsegCondMax;
        END IF;

        IF cCodCobert = cPeones THEN
            nPrima := nTasaPeones * nSumaAsegPeones * 0.01;
        END IF;
        IF cCodCobert = cRemolque THEN
            nPrima := nRecargoRemolque;
        END IF;
        RETURN(nPrima);
    END; -- End of PRE_PRIMA_LEY

END PR_PRE_COBERT;
