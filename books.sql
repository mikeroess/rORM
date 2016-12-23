CREATE TABLE publishers (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE authors (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  publisher_id INTEGER,

  FOREIGN KEY(publisher_id) REFERENCES author(id)
);

CREATE TABLE books (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author_id INTEGER,

  FOREIGN KEY(author_id) REFERENCES author(id)
);

INSERT INTO
  publishers (id, name, address)
VALUES
  (1, "Oxford University Press", "198 Madison Ave # 8, New York, NY 10016"),
  (2, "O'Reilly Media", "1005 Gravenstein Highway North Sebastopol, CA 95472");

INSERT INTO
  authors (id, fname, lname, publisher_id)
VALUES
  (1, "Carin", "Meier", 2),
  (2, "Alex", "Banks", 2),
  (3, "Richard", "Tieszan", 1),
  (4, "Jon", "Williamson", 1);

INSERT INTO
  books (id, title, author_id)
VALUES
  (1, "Bayesian Nets and Causality", 4),
  (2, "After Godel", 3),
  (3, "Living Clojure", 1),
  (4, "Learning React", 2),
  (5, "In Defence of Objective Bayesianism", 4);
