-- #1 Найти имена всех студентов кто дружит с кем-то по имени Gabriel.
SELECT DISTINCT h2.name
FROM highschooler AS h1
  JOIN friend AS f ON h1.id = f.id1 AND h1.name = 'Gabriel'
  JOIN friend AS f2 USING (id2)
  JOIN highschooler AS h2 ON f2.id2 = h2.id
ORDER BY h2.name;

-- #2 Для всех студентов, кому понравился кто-то на 2 или более классов младше, чем он вывести имя этого
--  студента и класс, а так же имя и класс студента который ему нравится.
SELECT
  h1.name,
  h1.grade AS class,
  h2.name,
  h2.grade AS class
FROM highschooler AS h1
  JOIN likes AS l ON h1.id = l.id1
  JOIN highschooler AS h2 ON l.id2 = h2.id
WHERE h1.grade - h2.grade >= 2;

-- #3 Для каждой пары студентов, которые нравятся друг другу взаимно вывести имя и класс обоих студентов.
--  Включать каждую пару только 1 раз с именами в алфавитном порядке.
SELECT
  h1.name,
  h1.grade AS class,
  h2.name,
  h2.grade AS class
FROM highschooler AS h1
  JOIN likes AS l1 ON h1.id = l1.id1
  JOIN likes AS l2 ON h1.id = l2.id2
  JOIN highschooler AS h2 ON l1.id2 = h2.id AND l2.id1 = h2.id
WHERE h1.name < h2.name
ORDER BY h1.name;

-- #4 Найти всех студентов, которые не встречаются в таблице лайков (никому не нравится и ему никто не нравится),
--  вывести их имя и класс. Отсортировать по классу, затем по имени в классе.
SELECT
  h.name,
  h.grade AS class
FROM highschooler AS h
  LEFT JOIN likes as l ON h.id IN (l.id1, l.id2)
WHERE l.id1 IS NULL AND l.id2 IS NULL
GROUP BY h.name, class
ORDER BY class, h.name;

-- #5 Для каждой ситуации, когда студенту A нравится студент B, но B никто не нравится, вывести имена и классы A и B.
SELECT
  h1.name as A,
  h1.grade AS class,
  h2.name AS B,
  h2.grade AS class
FROM highschooler AS h1
  JOIN likes AS l1 ON h1.id = l1.id1
  JOIN highschooler AS h2 ON l1.id2 = h2.id
  LEFT JOIN likes AS l2 ON h2.id = l2.id1
WHERE l2.id1 IS NULL

-- #6 Найти имена и классы, которые имеют друзей только в том же классе. Вернуть результат,
--  отсортированный по классу, затем имени в классе.
SELECT
  h1.name,
  h1.grade AS class
FROM highschooler AS h1
  JOIN friend AS f ON f.id1 = h1.id
  LEFT JOIN highschooler AS h2 ON f.id2 = h2.id AND h2.grade != h1.grade
WHERE h2.id IS NULL
GROUP BY h1.name, class
ORDER BY class, h1.name;

-- #7 Для каждого студента A, которому нравится студент B, и они не друзья, найти есть ли у них общий друг.
--  Для каждой такой тройки вернуть имя и класс A, B, и C.
SELECT
  h1.name AS A,
  h1.grade,
  h2.name AS B,
  h2.grade,
  h3.name AS C,
  h3.grade
FROM highschooler AS h1
  JOIN likes AS l ON l.id1 = h1.id
  JOIN highschooler AS h2 ON l.id2 = h2.id
  JOIN friend AS f1 ON f1.id1 = h2.id AND f1.id2 != h1.id
  JOIN friend AS f2 ON f2.id1 = f1.id2 AND f2.id2 = h1.id
  JOIN highschooler AS h3 ON f2.id1 = h3.id ;










