create or replace package body pr_cotiza_web is

procedure activar(nidecot  number) is
begin 
  null;
end;

 function calculo_prima_acreencias ( nidecotiza number ) return number is

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
      ntotprimaramo := p.mtoprima;
    for c in cur_acreencias ( p.codramoplan ) loop
        -- Verifica la naturaleza de la acreencia.
        if c.natcptoacre = 'A' then    --asignación
           -- Verificar Porcentaje de la acreencia - Asignación
           if c.porccptoacre is not null then
              ntotprimaramo := ntotprimaramo + (ntotprimaramo * (c.porccptoacre/100));
           elsif nvl(c.mtocptoacre,0) <> 0 then
              -- Se considera el monto de la Acreencia - Asignación
              ntotprimaramo := ntotprimaramo + nvl(c.mtocptoacre,0);
           end if;
        elsif c.natcptoacre = 'D' then -- Deducción
            -- Verificar Porcentaje de la acreencia - Deducción
           if c.porccptoacre is not null then
              ntotprimaramo := ntotprimaramo - (ntotprimaramo * (c.porccptoacre/100));
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

end;
