CREATE EXTENSION isn;

-- This is used to form the default IDs. However, the user is free to
-- override them with better values.
CREATE SEQUENCE book_id_seq;

CREATE TABLE books (
  id   	     VARCHAR  PRIMARY KEY  DEFAULT nextval('book_id_seq')::varchar,
  title      VARCHAR  NOT NULL,
  author     VARCHAR,
  isbn 	     isbn     UNIQUE,
  ddc 	     VARCHAR,
  image      BYTEA
);

CREATE TABLE borrowers (
  book_id      VARCHAR NOT NULL REFERENCES books ON UPDATE CASCADE ON DELETE CASCADE,
  name 	       VARCHAR NOT NULL,
  email        VARCHAR,
  phone        VARCHAR,
  borrowed_on  TIMESTAMP NOT NULL,
  returned_on  TIMESTAMP,
  CONSTRAINT borrowers_pk PRIMARY KEY (book_id, borrowed_on),
  CONSTRAINT need_borrower_contact_method CHECK(COALESCE(email, phone) IS NOT NULL)
);

CREATE TABLE classifications (
  isbn 	     isbn    NOT NULL,
  label      VARCHAR NOT NULL,
  class      VARCHAR NOT NULL,
  CONSTRAINT classifications_pk PRIMARY KEY (isbn, label)
);

