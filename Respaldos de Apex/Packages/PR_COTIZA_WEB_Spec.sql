create or replace PACKAGE pr_cotiza_web IS
PROCEDURE ACTIVAR(nIdeCot  NUMBER);
function calculo_prima_acreencias ( nidecotiza number ) return number;
END PR_cotiza_web;
