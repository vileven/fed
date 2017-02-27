-- #1 Найти названия всех фильмов снятых 'Steven Spielberg', отсортировать по алфавиту.

SELECT title
FROM movie
WHERE director = 'Steven Spielberg'
ORDER BY title;

-- #2 Найти года в которых были фильмы с рейтингом 4 или 5, и отсортировать по возрастанию.
SELECT ratingDate
FROM rating AS r
WHERE stars >= 4
ORDER BY ratingDate;

-- #3 Найти названия всех фильмов которые не имеют рейтинга, отсортировать по алфавиту.
SELECT m.title AS film
FROM movie AS m
  LEFT JOIN rating AS r ON m.mid = r.mid
WHERE r.mid IS NULL
ORDER BY film;

-- #4 Некоторые оценки не имеют даты. Найти имена всех экспертов, имеющих оценки без даты, отсортировать по алфавиту.
SELECT name
FROM reviewer AS rw
  JOIN rating AS rt ON rw.rID = rt.rID
WHERE rt.ratingDate IS NULL
ORDER BY name;

-- #5 Напишите запрос возвращающий информацию о рейтингах в более читаемом формате: имя эксперта, название фильма,
--  оценка и дата оценки. Отсортируйте данные по имени эксперта, затем названию фильма и наконец оценка.
SELECT
  rw.name,
  m.title,
  rt.stars,
  rt.ratingdate
FROM rating AS rt
  JOIN movie AS m ON m.mid = rt.mid
  JOIN reviewer AS rw ON rw.rid = rt.rid
GROUP BY rw.name, m.title, rt.stars, rt.ratingdate
ORDER BY rw.name, m.title, rt.stars;

-- #6 Для каждого фильма, выбрать название и "разброс оценок", то есть, разницу между самой высокой и самой низкой
--  оценками для этого фильма. Сортировать по "разбросу оценок" от высшего к низшему, и по названию фильма.
SELECT
  resp.title                        AS film,
  max(resp.stars) - min(resp.stars) AS range
FROM (
       SELECT
         m.title,
         r.stars
       FROM movie AS m
         LEFT JOIN rating AS r ON m.mid = r.mid
     ) AS resp
GROUP BY film
ORDER BY range DESC, film;

-- #7 Найти разницу между средней оценкой фильмов выпущенных до 1980 года,
--  а средней оценкой фильмов выпущенных после 1980 года (фильмы выпущенные в 1980 году не учитываются).
-- (Убедитесь, что для расчета используете среднюю оценку для каждого фильма. Не просто среднюю оценку фильмов
--  до и после 1980 года.)
SELECT avg(CASE WHEN resp.year > 1980
  THEN stars
           ELSE NULL END) -
       avg(CASE WHEN resp.year < 1980
         THEN stars
           ELSE NULL END) AS result
FROM (
       SELECT
         m.mid,
         m.year,
         AVG(r.stars) AS stars
       FROM movie AS m
         JOIN rating AS r USING (mid)
       GROUP BY m.mid, m.year
     ) AS resp;

-- #8 Найти имена всех экспертов, кто оценил "Gone with the Wind", отсортировать по алфавиту.
SELECT rw.name AS n
FROM reviewer AS rw
  JOIN rating AS rt USING (rid)
  JOIN movie AS m USING (mid)
WHERE m.title = 'Gone with the Wind'
GROUP BY n
ORDER BY n;

-- #9 Для каждой оценки, где эксперт тот же человек что и режиссер, выбрать имя, название фильма и оценку,
--  отсортировать по имени, названию фильма и оценке.
SELECT
  rw.name  AS name,
  m.title  AS film,
  rt.stars AS stars
FROM movie AS m
  JOIN rating AS rt USING (mid)
  JOIN reviewer AS rw USING (rid)
WHERE m.director = rw.name
GROUP BY name, film, stars
ORDER BY name, film, stars;

-- #10 Выберите всех экспертов и названия фильмов в едином списке в алфавитном порядке.
SELECT rw.name AS col
FROM reviewer AS rw
UNION ALL SELECT m.title AS col
      FROM movie AS m
ORDER BY col;

-- #11 Выберите названия всех фильмов, по алфавиту, которым не поставил оценку 'Chris Jackson'.
SELECT m.title AS film
FROM movie AS m
  LEFT JOIN rating AS rt USING (mid)
  JOIN reviewer AS rw USING (rid)
WHERE NOT exists(SELECT *
                 FROM reviewer
                 WHERE rw.name = 'Chris Jackson');

-- #12 Для всех пар экспертов, если оба оценили один и тот же фильм, выбрать имена обоих. Устранить дубликаты,
--  проверить отсутствие пар самих с собой и включать каждую пару только 1 раз. Выбрать имена в паре в алфавитном
--  порядке и отсортировать по именам.
SELECT DISTINCT
  rv1.name,
  rv2.name
FROM reviewer AS rv1
  JOIN rating AS r1 USING (rid)
  JOIN rating AS r2 ON r1.mid = r2.mid
  JOIN reviewer AS rv2 ON r2.rid = rv2.rid
WHERE rv1.name < rv2.name
GROUP BY rv1.name, rv2.name
ORDER BY rv1.name, rv2.name;

-- #13 Выбрать список названий фильмов и средний рейтинг, от самого низкого до самого высокого.
--  Если два или более фильмов имеют одинаковый средний балл, перечислить их в алфавитном порядке.
SELECT
  m.title      AS film,
  avg(r.stars) AS rating
FROM movie AS m
  LEFT JOIN rating AS r USING (mid)
GROUP BY film
ORDER BY rating, film;

-- #14 Найти имена всех экспертов, которые поставили три или более оценок, сортировка по алфавиту.
SELECT rv.name AS name
FROM reviewer AS rv
  JOIN rating AS rt USING (rid)
GROUP BY rv.name
HAVING count(rt.rid) >= 3
ORDER BY name;

-- #15 Некоторые режиссеры сняли более чем один фильм. Для всех таких режиссеров,
--  выбрать названия всех фильмов режиссера, его имя. Сортировка по имени режиссера.
--  Пример: Titanic,Avatar | James Cameron
SELECT
  string_agg(m.title, ','),
  m.director AS director
FROM movie AS m
GROUP BY director
HAVING count(*) > 1
ORDER BY director;

-- #16 Для всех случаев когда один эксперт оценивал фильм более одного раза и указал лучший рейтинг второй раз,
--  выведите имя эксперта и название фильма, отсортировав по имени, затем по названию фильма.
SELECT
    rv.name as expert,
    m.title as film
FROM movie AS m
  JOIN rating AS rt1 USING (mid)
  JOIN rating AS rt2 ON rt1.rid = rt2.rid AND rt2.ratingdate > rt1.ratingdate
                        AND rt2.stars > rt1.stars AND rt1.mid = rt2.mid
  JOIN reviewer AS rv ON rv.rid = rt2.rid
ORDER BY expert, film;

