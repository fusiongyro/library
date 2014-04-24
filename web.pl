:- module(web).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).

:- use_module(database).
:- use_module(book_identifier).

:- initialization(start_serving).

start_serving :-
    http_server(http_dispatch, [port(8080)]).

:- http_handler(/, list_books, []).
:- http_handler('/book', get_book, [prefix]).

list_books(_Request) :-
    findall(Book, database:select_books(Book), Books),
    reply_html_page(
	    [title('All My Books')],
	    [h1('All my books'),
	     \show_books(Books)]).

show_books([]) --> [].
show_books([Book|BS]) -->
    show_book(Book), show_books(BS).

show_book(book(Id, Title, Author, ISBN, DDC)) -->
    html([h2([Title, ' - ', Author]), p(['ISBN: ', ISBN]), p(['DDC: ', DDC])]).

get_book(Request) :-
    member(path_info(Path), Request), atom_concat('/', BookId, Path), !,
    database:find_book(book(BookId, Title, Author, ISBN, DDC)),
    findall(SuggestedId, suggest_identifier(Title, SuggestedId), Suggestions),
    reply_html_page(
	    [title(Title)],
	    [h1(Title), p(Suggestions)]).
