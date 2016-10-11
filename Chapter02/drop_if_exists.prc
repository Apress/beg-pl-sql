create or replace PROCEDURE drop_if_exists(
aiv_object_type                in     varchar2,
aiv_object_name                in     varchar2) is
/*
drop_if_exists.prc
by Donald J. Bales on 12/15/2006
Drop the object if it exists
*/

cursor c_constraint(
aiv_table_name                 in     varchar2) is
select f.table_name, 
       f.constraint_name
from   SYS.USER_CONSTRAINTS f,
       SYS.USER_CONSTRAINTS p
where  f.constraint_type = 'R'
and    f.r_owner            = p.owner
and    f.r_constraint_name  = p.constraint_name
and    p.table_name         = aiv_table_name;

n_count                             number;
v_sql                                 varchar2(100);

begin
  select count(1)
  into   n_count
  from   SYS.USER_OBJECTS
  where  object_type = upper(aiv_object_type)
  and    object_name = upper(aiv_object_name);

  if n_count > 0 then
    if upper(aiv_object_type) = 'TABLE' then
      for r_constraint in c_constraint(upper(aiv_object_name)) loop
        v_sql :=  'alter table '||
          r_constraint.table_name||
          ' drop constraint '||
          r_constraint.constraint_name;
        begin
          execute immediate v_sql;
        exception
          when OTHERS then
            pl(SQLERRM||': '||v_sql);
        end;
      end loop;
    end if;
    v_sql :=  'drop '||aiv_object_type||' '||aiv_object_name;
    begin
      execute immediate v_sql;
    exception
      when OTHERS then
        pl(SQLERRM||': '||v_sql);
    end;
  end if;
end drop_if_exists;
/
@pe.sql
