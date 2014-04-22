

CREATE TABLE books (
                id VARCHAR NOT NULL,
                title VARCHAR NOT NULL,
                author VARCHAR,
                isbn VARCHAR NOT NULL,
                ddc VARCHAR NOT NULL,
                image BYTEA NOT NULL,
                CONSTRAINT books_pk PRIMARY KEY (id)
);
COMMENT ON TABLE books IS 'Represents the actual books in the library';


CREATE UNIQUE INDEX books_isbn_idx
 ON books
 ( isbn );

CREATE TABLE borrowers (
                book_id VARCHAR NOT NULL,
                borrowed_on TIMESTAMP NOT NULL,
                name VARCHAR NOT NULL,
                returned_on TIMESTAMP,
                email VARCHAR,
                phone VARCHAR,
                id VARCHAR NOT NULL,
                CONSTRAINT borrowers_pk PRIMARY KEY (book_id, borrowed_on)
);


CREATE TABLE classifications (
                isbn VARCHAR NOT NULL,
                label VARCHAR NOT NULL,
                class VARCHAR NOT NULL,
                id VARCHAR NOT NULL,
                CONSTRAINT classifications_pk PRIMARY KEY (isbn, label)
);


ALTER TABLE classifications ADD CONSTRAINT books_classifications_fk
FOREIGN KEY (id)
REFERENCES books (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE borrowers ADD CONSTRAINT books_borrowers_fk
FOREIGN KEY (id)
REFERENCES books (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
