:- module(database, [insert_books/1]).

:- use_module(library(odbc)).

% Connect to the database as soon as the module is loaded.
:- initialization(connect_to_database).

% Creates the connection alias 'library' for our database.
connect_to_database :-
    odbc_connect(library, _, [alias(library)]).

% insert_books(+Books) is semidet.
%
%   Inserts a list of books into the database.
insert_books(Books) :-
    odbc_prepare(
	    library,
	    'INSERT INTO books (title, author, isbn) VALUES (?, ?, ?)',
	    [varchar, varchar, varchar],
	    Statement,
	    [null('')]),
    maplist(insert_book(Statement), Books).

insert_book(Statement, book(Title, Author, ISBN)) :-
    odbc_execute(Statement, [Title, Author, ISBN]).

select_books(book(Id, Title, Author, ISBN, DDC)) :-
    odbc_query(
	    library,
	    'SELECT id, title, author, isbn, ddc FROM books',
	    row(Id, Title, Author, ISBN, DDC),
	    [null(null)]).
    
