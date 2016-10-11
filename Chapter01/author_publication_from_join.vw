CREATE OR REPLACE VIEW author_publication as
SELECT author.id,
       author.name,
       publication.title,
       publication.written_date
FROM   author JOIN
       publication
ON     author.id = publication.id;       
