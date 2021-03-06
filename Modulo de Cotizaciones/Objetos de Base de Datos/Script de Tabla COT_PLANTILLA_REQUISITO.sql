/*
|| Script de Tabla COT_PLANTILLA_REQUISITO
*/
CREATE TABLE  "COT_PLANTILLA_REQUISITO" 
   (    "IDCOTPLANTIREQ" NUMBER(15,0), 
    "IDCOTIZAPLANTILLA" NUMBER(15,0), 
    "CODRAMO" VARCHAR2(4), 
    "CODREQ" VARCHAR2(4), 
    "INDOBLIG" VARCHAR2(1), 
    "FECHAREGISTRO" DATE, 
    "FECHACTUALIZA" DATE, 
     CONSTRAINT "COT_PLANTILLA_REQUISITO_PK" PRIMARY KEY ("IDCOTPLANTIREQ")
  USING INDEX  ENABLE
   )   NO INMEMORY
/

CREATE UNIQUE INDEX  "COT_PLANTILLA_REQUISITO_PK" ON  "COT_PLANTILLA_REQUISITO" ("IDCOTPLANTIREQ")
/

CREATE SEQUENCE   "COT_PLANTILLA_REQUISITO_SEQ"  
   MINVALUE 1 MAXVALUE 9999999999999999999999999999 
   INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/

CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_COT_PLANTILLA_REQUISITO" 
  before insert on "COT_PLANTILLA_REQUISITO"               
  for each row  
begin   
  if :NEW."IDCOTPLANTIREQ" is null then 
    select "COT_PLANTILLA_REQUISITO_SEQ".nextval into :NEW."IDCOTPLANTIREQ" from sys.dual; 
  end if; 
end; 
/

ALTER TRIGGER  "BI_COT_PLANTILLA_REQUISITO" ENABLE
/


