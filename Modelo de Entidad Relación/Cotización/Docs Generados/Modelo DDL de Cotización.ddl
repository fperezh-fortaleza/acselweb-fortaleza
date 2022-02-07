-- Generado por Oracle SQL Developer Data Modeler 21.2.0.183.1957
--   en:        2022-02-05 09:10:43 VET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g

CREATE TABLE cobert_plan_prod (
    codprod     VARCHAR2(4) NOT NULL,
    codplan     VARCHAR2(3) NOT NULL,
    revplan     VARCHAR2(3) NOT NULL,
    codramo     VARCHAR2(4) NOT NULL,
    codcobert   VARCHAR2(4) NOT NULL,
    sumaasegmin NUMBER(12, 2),
    sumaasgmax  NUMBER(12, 2),
    primamin    NUMBER(8, 2),
    primamax    NUMBER(8, 2),
    tasamin     NUMBER(6, 3),
    tasamax     NUMBER(6, 3)
);

ALTER TABLE cobert_plan_prod
    ADD CONSTRAINT cobert_plan_prod_pk PRIMARY KEY ( codprod,
                                                     codplan,
                                                     revplan,
                                                     codramo,
                                                     codcobert );

CREATE TABLE cot_datos_particulares_auto (
    idcotizacion     NUMBER(15) NOT NULL,
    numplaca         VARCHAR2(12),
    anoveh           NUMBER(4),
    codmarca         VARCHAR2(6),
    codmodelo        VARCHAR2(6),
    codversion       VARCHAR2(6),
    descmotor        VARCHAR2(17),
    claseveh         VARCHAR2(6),
    subcategoria     VARCHAR2(2),
    serialcarroceria VARCHAR2(30),
    numpeones        NUMBER(3),
    color            VARCHAR2(30),
    serialmotor      VARCHAR2(30),
    numpuestos       NUMBER(3),
    tipomodelo       VARCHAR2(3),
    codremolque      VARCHAR2(5),
    usado            VARCHAR2(1),
    codpotencia      VARCHAR2(4),
    uso_veh          VARCHAR2(3),
    tipocombustible  VARCHAR2(1),
    rentaveh         VARCHAR2(15),
    coddestinado     VARCHAR2(1),
    canttonelada     NUMBER(6, 2),
    tipo_transporte  VARCHAR2(1),
    valorveh         NUMBER(14, 2),
    fecendoso        DATE,
    tipoveh          VARCHAR2(3),
    fecreg           DATE
);

COMMENT ON COLUMN cot_datos_particulares_auto.claseveh IS
    'Es la Categoría del Vehiculo';

COMMENT ON COLUMN cot_datos_particulares_auto.numpeones IS
    'Número de Pasajeros o Peones';

CREATE TABLE cot_plantilla (
    idcotizaplantilla NUMBER(15) NOT NULL,
    nbreplantilla     VARCHAR2(200),
    codusr            VARCHAR2(10),
    stsplantilla      VARCHAR2(3),
    fecharegistro     DATE,
    fechaactualiza    DATE,
    codprod           VARCHAR2(4) NOT NULL,
    codplan           VARCHAR2(4) NOT NULL,
    revplan           VARCHAR2(4) NOT NULL,
    idcotizacion      NUMBER(15)
);

COMMENT ON COLUMN cot_plantilla.codusr IS
    'Código del Usuario propietario de la Plantilla.';

COMMENT ON COLUMN cot_plantilla.stsplantilla IS
    'Estatus de la Plantilla';

COMMENT ON COLUMN cot_plantilla.fecharegistro IS
    'Fecha en que se registra la Plantilla';

COMMENT ON COLUMN cot_plantilla.fechaactualiza IS
    'Fecha de Actualización de la Plantilla.';

COMMENT ON COLUMN cot_plantilla.codprod IS
    'Indica el producto asociado a la Plantilla de la Cotización';

COMMENT ON COLUMN cot_plantilla.codplan IS
    'Código del Plan del Producto';

COMMENT ON COLUMN cot_plantilla.revplan IS
    'Código de la Revisión del Plan ';

ALTER TABLE cot_plantilla ADD CONSTRAINT cot_plantilla_pk PRIMARY KEY ( idcotizaplantilla );

CREATE TABLE cot_plantilla_anexo (
    idcotplantianexo  NUMBER(15) NOT NULL,
    idcotizaplantilla NUMBER(15) NOT NULL,
    codramo           VARCHAR2(4),
    codanexo          VARCHAR2(6),
    indanexooblig     unknown 
--  ERROR: Datatype UNKNOWN is not allowed 

);

COMMENT ON COLUMN cot_plantilla_anexo.idcotplantianexo IS
    'Identificación Unica del Anexo de la Plantilla.';

COMMENT ON COLUMN cot_plantilla_anexo.idcotizaplantilla IS
    'Identificación de la Plantilla de Cotización a la cual se le asocia el Anexo.';

COMMENT ON COLUMN cot_plantilla_anexo.codramo IS
    'Código del Ramo.';

COMMENT ON COLUMN cot_plantilla_anexo.codanexo IS
    'Código del Anexo';

COMMENT ON COLUMN cot_plantilla_anexo.indanexooblig IS
    'Indicador de Obligatorio o no del Anexo';

ALTER TABLE cot_plantilla_anexo ADD CONSTRAINT cot_plantilla_anexos_pk PRIMARY KEY ( idcotplantianexo );

CREATE TABLE cot_plantilla_clausula (
    idcotplanticlau   NUMBER(15) NOT NULL,
    idcotizaplantilla NUMBER(15) NOT NULL,
    codramo           VARCHAR2(4),
    codclau           VARCHAR2(6),
    indclauoblig      VARCHAR2(1),
    fecharegistro     DATE,
    fechaactualiza    DATE
);

COMMENT ON COLUMN cot_plantilla_clausula.idcotplanticlau IS
    'Identificación de la Clausula dentro de la Plantilla';

COMMENT ON COLUMN cot_plantilla_clausula.idcotizaplantilla IS
    'Identificación de la Plantilla de la Cotización';

COMMENT ON COLUMN cot_plantilla_clausula.codramo IS
    'Código del Ramo';

COMMENT ON COLUMN cot_plantilla_clausula.codclau IS
    'Código de la Clausula.';

COMMENT ON COLUMN cot_plantilla_clausula.indclauoblig IS
    'Indicador de Obligatoria de la Clausula';

COMMENT ON COLUMN cot_plantilla_clausula.fecharegistro IS
    'Fecha de Ingreso';

COMMENT ON COLUMN cot_plantilla_clausula.fechaactualiza IS
    'Fecha de Actualización';

ALTER TABLE cot_plantilla_clausula ADD CONSTRAINT cot_plantilla_clausula_pk PRIMARY KEY ( idcotplanticlau );

CREATE TABLE cot_plantilla_cobert (
    idcotplantillacobert NUMBER(15),
    idcotizaplantilla    NUMBER(15) NOT NULL,
    codramo              VARCHAR2(4),
    codcobert            VARCHAR2(4),
    indcobertoblig       VARCHAR2(1),
    prima                NUMBER(14, 2),
    tasa                 NUMBER(14, 6),
    sumaaseg             NUMBER(14, 2),
    orden                NUMBER(4),
    porcded              NUMBER(3, 2),
    mtoded               NUMBER(14, 2),
    base                 VARCHAR2(2)
);

COMMENT ON COLUMN cot_plantilla_cobert.idcotplantillacobert IS
    'Identificación Unica de la Cobertura de la Plantilla';

COMMENT ON COLUMN cot_plantilla_cobert.idcotizaplantilla IS
    'Identificación de la Plantilla de la Cotización.';

COMMENT ON COLUMN cot_plantilla_cobert.codramo IS
    'Código del Ramo';

COMMENT ON COLUMN cot_plantilla_cobert.codcobert IS
    'Código de la Cobertura';

COMMENT ON COLUMN cot_plantilla_cobert.indcobertoblig IS
    'Indicador de Obligatoria o No de la Cobertura';

COMMENT ON COLUMN cot_plantilla_cobert.prima IS
    'Monto de la Prima Mínima de la Cobertura';

COMMENT ON COLUMN cot_plantilla_cobert.tasa IS
    'Tasa Minima de la Cobertura.';

COMMENT ON COLUMN cot_plantilla_cobert.sumaaseg IS
    'Suma Asegurada Minima de la Cobertura';

COMMENT ON COLUMN cot_plantilla_cobert.orden IS
    'Orden de la Cobertura';

CREATE TABLE cot_plantilla_requisito (
    idcotplantireq    NUMBER(15) NOT NULL,
    idcotizaplantilla NUMBER(15) NOT NULL,
    codramo           VARCHAR2(4),
    codreq            VARCHAR2(4),
    indoblig          VARCHAR2(1),
    fecharegistro     DATE,
    fechaactualiza    DATE
);

COMMENT ON COLUMN cot_plantilla_requisito.idcotplantireq IS
    'Identificación Unica del Requisito de la Plantilla.';

COMMENT ON COLUMN cot_plantilla_requisito.idcotizaplantilla IS
    'Identificación de la Plantilla de Cotización';

COMMENT ON COLUMN cot_plantilla_requisito.codreq IS
    'Código del Requisito';

COMMENT ON COLUMN cot_plantilla_requisito.indoblig IS
    'Indicador de Obligatoria o no del Requisito.';

COMMENT ON COLUMN cot_plantilla_requisito.fecharegistro IS
    'Fecha del Registro';

COMMENT ON COLUMN cot_plantilla_requisito.fechaactualiza IS
    'Fecha de la Actualización del Requisito';

ALTER TABLE cot_plantilla_requisito ADD CONSTRAINT cot_plantilla_requisitos_pk PRIMARY KEY ( idcotplantireq );

CREATE TABLE cotiza_anexo (
    idcotiza      NUMBER(15) NOT NULL,
    codanexo      NUMBER(6),
    codramo       VARCHAR2(4),
    indanexooblig VARCHAR2(1),
    fecha_desde   DATE,
    fecha_hasta   DATE,
    idcotizaanexo NUMBER(15)
);

CREATE TABLE cotiza_clausula (
    idcotiza         NUMBER(15) NOT NULL,
    codclausula      VARCHAR2(6) NOT NULL,
    codramo          VARCHAR2(4),
    indclausulaoblig VARCHAR2(1),
    fecha_desde      DATE,
    fecha_hasta      DATE,
    notas            VARCHAR2(4000),
    idcotizaclausula NUMBER(15)
);

CREATE TABLE cotizacion (
    idcotiza          NUMBER(15) NOT NULL,
    tipoid            VARCHAR2(3),
    numid             NUMBER(15),
    dvid              VARCHAR2(2),
    nombre            VARCHAR2(200),
    email             VARCHAR2(80),
    telefono          VARCHAR2(12),
    nromovil          VARCHAR2(12),
    fechareg          DATE,
    stscotiza         VARCHAR2(3),
    diascotiza        NUMBER(2),
    codprod           VARCHAR2(4) NOT NULL,
    codplan           VARCHAR2(8) NOT NULL,
    codmoneda         VARCHAR2(3),
    direccion         VARCHAR2(250),
    fechadesde        DATE,
    fechahasta        DATE,
    codinter          VARCHAR2(8),
    apellido          VARCHAR2(200),
    codofi            VARCHAR2(6),
    idcotizaplantilla NUMBER(15),
    notas             VARCHAR2(4000),
    codusr            VARCHAR2(15),
    planacuerdo       VARCHAR2(4),
    porcinicial       NUMBER(8, 4),
    cuotas            NUMBER(2),
    serieid           NUMBER(3),
    revplan           VARCHAR2(3) NOT NULL
);

COMMENT ON COLUMN cotizacion.idcotiza IS
    'Identificación Unica de la Cotización';

COMMENT ON COLUMN cotizacion.codofi IS
    'Código de la Sucursal';

COMMENT ON COLUMN cotizacion.codusr IS
    'Código del Usuario que elebaora la Cotización';

COMMENT ON COLUMN cotizacion.planacuerdo IS
    'Plan de Acuerdo de Pago';

COMMENT ON COLUMN cotizacion.porcinicial IS
    '% Porcentaje de la Inicial';

COMMENT ON COLUMN cotizacion.cuotas IS
    'Número de Cuotas de Pago.';

COMMENT ON COLUMN cotizacion.serieid IS
    'Este dato forma parte del TipoId y NumId.';

ALTER TABLE cotizacion ADD CONSTRAINT cotizacion_pk PRIMARY KEY ( idcotiza );

CREATE TABLE cotizacion_cobertura (
    idcotiza      NUMBER(15) NOT NULL,
    codcobert     VARCHAR2(8),
    indobliga     VARCHAR2(1),
    sumaasegurada NUMBER(12, 2),
    tasa          NUMBER(14, 6),
    prima         NUMBER(14, 2),
    idcobertura   NUMBER(15),
    codramoplan   VARCHAR2(4),
    porcded       NUMBER(3, 2),
    mtoded        NUMBER(14, 2),
    base          VARCHAR2(2)
);

CREATE TABLE cotizacion_requisito (
    codprod           VARCHAR2(4),
    codplan           VARCHAR2(6),
    codramo           VARCHAR2(4),
    codreq            VARCHAR2(4),
    indoblig          VARCHAR2(1) NOT NULL,
    fechasts          DATE,
    idrequisito       NUMBER(15) NOT NULL,
    stsreq            VARCHAR2(3),
    idcotizacion      NUMBER(15) NOT NULL,
    requisito_picture BLOB,
    mimetype          VARCHAR2(50),
    filename          VARCHAR2(200),
    created_date      DATE
);

COMMENT ON COLUMN cotizacion_requisito.indoblig IS
    'Indicador de obligatoriedad o no del Requisito.';

COMMENT ON COLUMN cotizacion_requisito.fechasts IS
    'Fecha de Registro del Requisito.';

COMMENT ON COLUMN cotizacion_requisito.idrequisito IS
    'Identificación Única del Requisito de la Cotización';

COMMENT ON COLUMN cotizacion_requisito.stsreq IS
    'Estatus del Requisito:
PEN - Pendiente.
ENT - Entregado.';

COMMENT ON COLUMN cotizacion_requisito.idcotizacion IS
    'Identificación del Plan de la Cotización a la cual se asocia el Requisito';

COMMENT ON COLUMN cotizacion_requisito.requisito_picture IS
    'Documento del Requisito Digital';

ALTER TABLE cotizacion_requisito ADD CONSTRAINT requisitos_plan_pk PRIMARY KEY ( idrequisito );

CREATE TABLE plan_prod (
    codprod VARCHAR2(4) NOT NULL,
    codplan VARCHAR2(4) NOT NULL,
    revplan VARCHAR2(4) NOT NULL
);

ALTER TABLE plan_prod
    ADD CONSTRAINT plan_prod_pk PRIMARY KEY ( codprod,
                                              codplan,
                                              revplan );

CREATE TABLE producto (
    codprod VARCHAR2(4) NOT NULL
);

ALTER TABLE producto ADD CONSTRAINT producto_pk PRIMARY KEY ( codprod );

CREATE TABLE ramo_plan_prod (
    codprod VARCHAR2(4) NOT NULL,
    codplan VARCHAR2(4) NOT NULL,
    revplan VARCHAR2(4) NOT NULL,
    codramo VARCHAR2(4)
);

ALTER TABLE ramo_plan_prod
    ADD CONSTRAINT ramo_plan_prod_pk PRIMARY KEY ( codprod,
                                                   codplan,
                                                   revplan );

ALTER TABLE cotiza_anexo
    ADD CONSTRAINT anexos_plan_cotizacion_fk FOREIGN KEY ( idcotiza )
        REFERENCES cotizacion ( idcotiza );

ALTER TABLE cotiza_clausula
    ADD CONSTRAINT clausulas_plan_cotizacion_fk FOREIGN KEY ( idcotiza )
        REFERENCES cotizacion ( idcotiza );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE cobert_plan_prod
    ADD CONSTRAINT cobert_plan_prod_ramo_plan_prod_fk FOREIGN KEY ( codprod,
                                                                    codplan,
                                                                    revplan )
        REFERENCES ramo_plan_prod ( codprod,
                                    codplan,
                                    revplan );

ALTER TABLE cotizacion_cobertura
    ADD CONSTRAINT cobertura_plan_cotizacion_fk FOREIGN KEY ( idcotiza )
        REFERENCES cotizacion ( idcotiza );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE cot_plantilla_anexo
    ADD CONSTRAINT cot_plantilla_anexos_cot_plantilla_fk FOREIGN KEY ( idcotizaplantilla )
        REFERENCES cot_plantilla ( idcotizaplantilla );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE cot_plantilla_clausula
    ADD CONSTRAINT cot_plantilla_clausula_cot_plantilla_fk FOREIGN KEY ( idcotizaplantilla )
        REFERENCES cot_plantilla ( idcotizaplantilla );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE cot_plantilla_cobert
    ADD CONSTRAINT cot_plantilla_cobert_cot_plantilla_fk FOREIGN KEY ( idcotizaplantilla )
        REFERENCES cot_plantilla ( idcotizaplantilla );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE cot_plantilla
    ADD CONSTRAINT cot_plantilla_ramo_plan_prod_fk FOREIGN KEY ( codprod,
                                                                 codplan,
                                                                 revplan )
        REFERENCES ramo_plan_prod ( codprod,
                                    codplan,
                                    revplan );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE cot_plantilla_requisito
    ADD CONSTRAINT cot_plantilla_requisitos_cot_plantilla_fk FOREIGN KEY ( idcotizaplantilla )
        REFERENCES cot_plantilla ( idcotizaplantilla );

ALTER TABLE cotizacion
    ADD CONSTRAINT cotizacion_plan_prod_fk FOREIGN KEY ( codprod,
                                                         codplan,
                                                         revplan )
        REFERENCES plan_prod ( codprod,
                               codplan,
                               revplan );

ALTER TABLE cotizacion
    ADD CONSTRAINT cotizacion_producto_fk FOREIGN KEY ( codprod )
        REFERENCES producto ( codprod );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE cot_datos_particulares_auto
    ADD CONSTRAINT datos_particulares_auto_cotizacion_fk FOREIGN KEY ( idcotizacion )
        REFERENCES cotizacion ( idcotiza );

ALTER TABLE plan_prod
    ADD CONSTRAINT plan_prod_producto_fk FOREIGN KEY ( codprod )
        REFERENCES producto ( codprod );

ALTER TABLE ramo_plan_prod
    ADD CONSTRAINT ramo_plan_prod_plan_prod_fk FOREIGN KEY ( codprod,
                                                             codplan,
                                                             revplan )
        REFERENCES plan_prod ( codprod,
                               codplan,
                               revplan );

ALTER TABLE cotizacion_requisito
    ADD CONSTRAINT requisitos_plan_cotizacion_fk FOREIGN KEY ( idcotizacion )
        REFERENCES cotizacion ( idcotiza );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            15
-- CREATE INDEX                             0
-- ALTER TABLE                             25
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   8
-- WARNINGS                                 0
