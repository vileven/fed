DROP TABLE IF EXISTS Highschooler;
DROP TABLE IF EXISTS Friend;
DROP TABLE IF EXISTS Likes;

/* Create the schema for our tables */
CREATE TABLE Highschooler (
  ID    INT,
  name  TEXT,
  grade INT
);
CREATE TABLE Friend (
  ID1 INT,
  ID2 INT
);
CREATE TABLE Likes (
  ID1 INT,
  ID2 INT
);
