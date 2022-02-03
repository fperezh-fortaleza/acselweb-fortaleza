create or replace function "CODUSER"
return VARCHAR2
is
begin
return nvl(sys_context('APEX$SESSION','APP_USER'),sys_context('USERENV','SESSION_USER'));
end;
