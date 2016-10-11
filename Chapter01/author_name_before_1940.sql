SELECT name
FROM   author
WHERE  birth_date < to_date('19400101', 'YYYYMMDD')
ORDER BY name;
