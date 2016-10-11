SELECT a.name
FROM   author a
WHERE EXISTS (
SELECT 1
FROM   publication x1,
       publication x2
WHERE  x1.id     = a.id
and    x1.title  = x2.title
and    x2.id    <> a.id )
ORDER BY a.name;
