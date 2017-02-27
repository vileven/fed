-- #1 Найти названия всех фильмов снятых 'Steven Spielberg', отсортировать по алфавиту.

SELECT title
FROM movie
WHERE director = 'Steven Spielberg'
ORDER BY title;

-- #2 Найти года в которых были фильмы с рейтингом 4 или 5, и отсортировать по возрастанию.
SELECT ratingDate
FROM rating as r
WHERE stars >= 4
ORDER BY ratingDate;

-- #3 Найти названия всех фильмов которые не имеют рейтинга, отсортировать по алфавиту.
SELECT m.title as film
FROM movie as m
LEFT JOIN rating as r ON m.mid = r.mid
WHERE r.mid IS NULL
ORDER BY film;


-- #4 Некоторые оценки не имеют даты. Найти имена всех экспертов, имеющих оценки без даты, отсортировать по алфавиту.
SELECT name
FROM reviewer as rw
JOIN rating as rt ON rw.rID = rt.rID
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