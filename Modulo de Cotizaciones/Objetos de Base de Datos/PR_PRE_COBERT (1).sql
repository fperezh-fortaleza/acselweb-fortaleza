create or replace PACKAGE PR_PRE_COBERT AS

FUNCTION  PRE_SUMA(nIdePol NUMBER,nNumCert NUMBER,cCodProd VARCHAR2,
                   cCodPlan VARCHAR2,cRevPlan VARCHAR2,cCodRamoCert VARCHAR2,
                   cCodCobert VARCHAR2, cParam VARCHAR2,nIdeAseg NUMBER,
                   nIdeCobert NUMBER) RETURN NUMBER;
FUNCTION  PRE_TASA(nIdePol NUMBER,nNumCert NUMBER,cCodProd VARCHAR2,
                   cCodPlan VARCHAR2,cRevPlan VARCHAR2,cCodRamoCert VARCHAR2,
                   cCodCobert VARCHAR2, cParam VARCHAR2,nAsegurado NUMBER,
                   nIdeBien NUMBER,nDedCobert NUMBER,nSumAseg NUMBER,nIdeDatTran NUMBER) RETURN NUMBER;
FUNCTION  PRE_PRIMA(nIdePol NUMBER,nNumCert NUMBER,cCodProd VARCHAR2,
                   cCodPlan VARCHAR2,cRevPlan VARCHAR2,cCodRamoCert VARCHAR2,
                   cCodCobert VARCHAR2, cParam VARCHAR2,nAsegurado NUMBER,
                   nIdeBien NUMBER,nDedCobert NUMBER, nIdeCobert NUMBER) RETURN NUMBER;

FUNCTION  POST_PRIMA(nIdePol NUMBER,nNumCert NUMBER,cCodProd VARCHAR2,
                   cCodPlan VARCHAR2,cRevPlan VARCHAR2,cCodRamoCert VARCHAR2,
                   cCodCobert VARCHAR2, cParam VARCHAR2,nAsegurado NUMBER,
                   nSumaAsegMoneda NUMBER,nIdebien NUMBER)  RETURN NUMBER;

FUNCTION  PRE_SUMA_BIEN(nIdeBien NUMBER) RETURN NUMBER ;
FUNCTION  PRE_DEDUCIBLE(nIdePol NUMBER,nNumCert NUMBER,cCodProd VARCHAR2,
                   cCodPlan VARCHAR2,cRevPlan VARCHAR2,cCodRamoCert VARCHAR2,
                   cCodCobert VARCHAR2, cParam VARCHAR2,nAsegurado NUMBER, nIdeCotiza NUMBER DEFAULT NULL) RETURN NUMBER;
FUNCTION  PRE_PORCDED(nIdePol NUMBER,nNumCert NUMBER,cCodProd VARCHAR2,
                   cCodPlan VARCHAR2,cRevPlan VARCHAR2,cCodRamoCert VARCHAR2,
                   cCodCobert VARCHAR2, cParam VARCHAR2,nAsegurado NUMBER, nIdeCotiza NUMBER DEFAULT NULL) RETURN NUMBER;
FUNCTION  PRE_COASEG_PACTADO(nIdePol NUMBER,nNumCert NUMBER,cCodProd VARCHAR2,
                   cCodPlan VARCHAR2,cRevPlan VARCHAR2,cCodRamoCert VARCHAR2,
                   cCodCobert VARCHAR2,cParam VARCHAR2,nIdeBien NUMBER) RETURN NUMBER;
FUNCTION  PRE_SUMA_LEY(nIdePol NUMBER,nNumCert NUMBER, cCodCobert VARCHAR2) RETURN NUMBER;

FUNCTION  PRE_PRIMA_LEY(nIdePol NUMBER,nNumCert NUMBER, cCodCobert VARCHAR2,cPlanMin VARCHAR2) RETURN NUMBER;

END PR_PRE_COBERT;
 
 
 
 
