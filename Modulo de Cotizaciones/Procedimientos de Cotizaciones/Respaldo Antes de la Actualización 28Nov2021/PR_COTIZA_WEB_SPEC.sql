create or replace PACKAGE pr_cotiza_web IS
PROCEDURE ACTIVAR(nIdeCot  NUMBER);
procedure activar_cotizacion ( nIdeCot NUMBER);
procedure plantilla_cotizacion ( nIdeCotizaPlanilla number, nIdeCotiza number);
function calculo_prima_acreencias ( nidecotiza number, ntotprimacotiza number ) return number;
function busca_datos_particular_auto ( nidecotiza number ) return varchar2;
FUNCTION EMITE_POLIZA(nIdCotiza   NUMBER) RETURN NUMBER ;

END PR_cotiza_web; 
