SELECT a.id,
       a.name,
       p.title,
       p.written_date
FROM   author a JOIN 
       publication p
ON     a.id = p.id
ORDER BY a.name, 
       p.written_date, 
       p.title;       
