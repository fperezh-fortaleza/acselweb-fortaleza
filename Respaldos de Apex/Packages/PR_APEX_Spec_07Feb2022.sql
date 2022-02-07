create or replace package PR_APEX as 
 
function apex_report_server return varchar2; 
function imprimir_reportes  (nIdePol        NUMBER  , nIdeOp         NUMBER, 
                             cTipoImpresion VARCHAR2, cIderep        VARCHAR2, 
                             cDescImp       VARCHAR2, nCantidadCopia NUMBER,  
                             cCodProd       VARCHAR2, cTipoRep       VARCHAR2) return varchar2; 
function imprimir_anexo     (nIdePol   NUMBER  , nIdeop NUMBER,   
                             cReporte  VARCHAR2, nCantidadCopia NUMBER) return varchar2; 
function gen_contrato       (nIdePol   NUMBER  ,nNumCert NUMBER  ,cCodProd   VARCHAR2,cCodPlan VARCHAR2, 
                             cRevPlan  VARCHAR2,cCodRamo VARCHAR2,cCodMoneda VARCHAR2,cCodCobert VARCHAR2, 
                             cTipoRep1 VARCHAR2) return varchar2;  
function imprimir_recibo    (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, cNombreImpresora VARCHAR2,  
                             nCantidadCopia NUMBER) return varchar2;   
function imprimir_relacion  (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, cNombreImpresora VARCHAR2,  
                             nCantidadCopia NUMBER) return varchar2;    
function imprimir_coaseguro (nIdePol NUMBER, nIdeOp NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, cNombreImpresora VARCHAR2,  
                             nCantidadCopia NUMBER, cCodProd VARCHAR2) return varchar2; 
function imprimir_condiciones_gen (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, cNombreImpresora VARCHAR2, 
                                   nCantidadCopia NUMBER, cCodProd VARCHAR2) return varchar2;  
function imprimir_cartas  (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2, cNombreImpresora VARCHAR2,  
                           nCantidadCopia NUMBER, cCodProd VARCHAR2) return varchar2;  
function imprimir_marbete (nIdepol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2,  
                           cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2; 
function imprimir_marbete_individual (nIdepol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2,  
                                      cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2; 
function imprimir_cancelacion (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2,  
                               cNombreImpresora VARCHAR2, nCantidadCopia NUMBER, cCodProd VARCHAR2) return varchar2;  
function imprimir_planilla_reclamo (nIdePol NUMBER, cTipo VARCHAR2, cReporte VARCHAR2,  
                                    cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2; 
function imprimir_condicion_pago (nIdePol NUMBER, cTipo VARCHAR2, cReporte VARCHAR2,  
                                  cNombreImpresora VARCHAR2, nCantidadCopia NUMBER, nIdeOp NUMBER) return varchar2; 
function imprimir_factura (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2,  
                           cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2;  
function imprimir_acuerdo (nNumAcuerdo NUMBER, cTipo VARCHAR2, cReporte VARCHAR2,  
                           cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2; 
function imprimir_siniestralidad (cCodProd VARCHAR2, nNumPol NUMBER, dFecha_Desde DATE, dFecha_Hasta DATE, 
                                  cTipo VARCHAR2, cReporte VARCHAR2, cNombreImpresora VARCHAR2,  
                                  nCantidadCopia NUMBER) return varchar2; 
function imprimir_clausulas_text ( nIdePol NUMBER, nIdeOp NUMBER, cReporte VARCHAR2, nCantidadCopia NUMBER ) return varchar2; 
function imprimir_marbete_flotilla (nIdepol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, 
                                    cReporte VARCHAR2, cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2;
function imprimir_nota_credito (nIdePol NUMBER, nIdeop NUMBER, cTipo VARCHAR2, cReporte VARCHAR2,
                                cNombreImpresora VARCHAR2, nCantidadCopia NUMBER) return varchar2;                                
                                	                                                                                                                                                                                                                                                                                                                                                                         
 
end PR_APEX; 
