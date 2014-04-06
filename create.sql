CREATE TABLE books (
  id   	     VARCHAR  NOT NULL PRIMARY KEY,
  title      VARCHAR, NOT NULL,
  author     VARCHAR,
  isbn 	     isbn     NOT NULL UNIQUE,
  ddc 	     VARCHAR  NOT NULL,
  image      BYTEA    NOT NULL,
);

COMMENT ON TABLE books IS 'Represents the actual books in the library';

CREATE TABLE borrowers (
  book_id      VARCHAR NOT NULL REFERENCES books ON UPDATE CASCADE ON DELETE CASCADE,
  name 	       VARCHAR NOT NULL,
  email        VARCHAR,
  phone        VARCHAR,
  borrowed_on  TIMESTAMP NOT NULL,
  returned_on  TIMESTAMP,
  CONSTRAINT borrowers_pk PRIMARY KEY (book_id, borrowed_on)
  CONSTRAINT need_borrower_contact_method CHECK(COALESCE(email, phone) IS NOT NULL)
);

CREATE TABLE classifications (
  isbn 	     isbn    NOT NULL,
  label      VARCHAR NOT NULL,
  class      VARCHAR NOT NULL,
  CONSTRAINT classifications_pk PRIMARY KEY (isbn, label)
);

