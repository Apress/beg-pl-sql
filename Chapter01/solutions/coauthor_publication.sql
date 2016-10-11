SELECT p.title, 
       a.name
FROM   author a,
       publication p
WHERE  a.id      = p.id
AND EXISTS (
SELECT 1
FROM   publication x
WHERE  x.title   = p.title
AND    x.id     <> p.id )
ORDER BY p.title,
       a.name;
