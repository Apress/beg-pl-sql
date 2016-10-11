CREATE OR REPLACE VIEW author_publication as
SELECT author.id,
       author.name,
       publication.title,
       publication.written_date
FROM   author,
       publication
WHERE  author.id = publication.id;       
