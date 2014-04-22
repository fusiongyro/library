:- module(bookbuddy, [parse/2, initialize_database/1]).

:- use_module(library(csv)).
:- use_module(database).

simplify(
	row(_UploadedImageURL, _Author, AuthorLastFirst, Title,
	  _Subtitle, _Genre, _Rating, _LoanedTo, _DateLoaned,
	  _BorrowedFrom, _DateBorrowed, _Publisher, _Status, _Notes,
	  _Edition, _DatePublished, _Length, _Format, _Dimensions,
	  _Weight, ISBN, _PhysicalLocation, _DateAdded, _DateStarted,
	  _DateFinished, _PurchaseDate, _PurchasePlace,
	  _PurchasePrice, _ListPrice, _GoogleVolumeID, _Favorites,
	  _WishList, _Category, _Series, _Volume, _Quantity, _Summary,
	  _Tags),
	book(Title, AuthorLastFirst, ISBN)).

parse(Filename, Rows) :-
    csv_read_file(Filename, [_|ComplexRows], [convert(false)]),
    maplist(simplify, ComplexRows, Rows).

initialize_database(Filename) :-
    parse(Filename, Rows),
    database:insert_books(Rows).
