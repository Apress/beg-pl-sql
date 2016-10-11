CREATE TRIGGER   author_bir
BEFORE INSERT ON author
FOR EACH ROW

begin
  if upper(:new.name) = 'JONATHAN GENNICK' then
    raise_application_error(20000, 'Sorry, that genius is not allowed.');
  end if;
end;
/
