CREATE TABLE Movie (
  mID      INT,
  title    TEXT,
  year     INT,
  director TEXT
);

CREATE TABLE Reviewer (
  rID  INT,
  name TEXT
);

CREATE TABLE Rating (
  rID        INT,
  mID        INT,
  stars      INT,
  ratingDate DATE
);
