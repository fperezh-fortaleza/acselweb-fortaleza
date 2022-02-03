create or replace package PR_APEX as

function apex_report_server return varchar2;
function imprimir_reportes (nIdePol        NUMBER  , nIdeOp         NUMBER,
                            cTipoImpresion VARCHAR2, cIderep        VARCHAR2,
                            cDescImp       VARCHAR2, nCantidadCopia NUMBER, 
                            cCodProd       VARCHAR2, cTipoRep       VARCHAR2) return varchar2;
function imprimir_anexo (nIdePol   NUMBER  , nIdeop NUMBER,  
                         cReporte  VARCHAR2, nCantidadCopia NUMBER) return varchar2;                           

end PR_APEX;
