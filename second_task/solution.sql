-- #1 Найти имена всех студентов кто дружит с кем-то по имени Gabriel.
SELECT DISTINCT
  h2.name
FROM highschooler AS h1
  JOIN friend AS f ON h1.id = f.id1 AND h1.name = 'Gabriel'
  JOIN friend AS f2 USING (id2)
  JOIN highschooler AS h2 ON f2.id2 = h2.id
ORDER BY h2.name;

