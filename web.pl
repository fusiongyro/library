:- module(web).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).

:- use_module(database).

:- initialization(start_serving).

start_serving :-
    http_server(http_dispatch, [port(8080)]).

:- http_handler(/, list_books, []).

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
