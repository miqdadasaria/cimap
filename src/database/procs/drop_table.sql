CREATE or REPLACE function drop_table (varchar) returns varchar as $$
DECLARE
tablename alias for $1;
cnt int4;
BEGIN
SELECT into cnt count(*) from pg_class where relname =
tablename::name;
if cnt > 0 then
execute 'DROP TABLE ' || tablename;
return tablename || ' DROPPED';
end if;
return tablename || ' does not exist';
END;$$
language 'plpgsql' ;
