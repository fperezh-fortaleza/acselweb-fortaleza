  function busca_descprod ( cCodprod varchar2) return varchar2 is
   cDescProd producto.descprod%TYPE;
   begin
    begin
      select descprod
        into cDescProd
        from producto
       where codprod = cCodProd;
    exception
       when others then
            cDescProd := null;
    end;
   return cDescProd;
  end busca_descprod;