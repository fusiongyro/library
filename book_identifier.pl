:- module(book_identifier, [suggest_identifier/2]).

% remove_whitespace(+Title, ?CompressedTitle) is semidet.
%
%   True if Title contains whitespace and CompressedTitle is Title
%   without the whitespace.
remove_whitespace(Title, CompressedTitle) :- fail.

% remove_articles(+Title, ?CompressedTitle) is semidet.
%
%   True if Title contains articles (a, an, the) and CompressedTitle
%   is Title without the articles.
remove_articles(Title, CompressedTitle) :- fail.

% remove_grammatical_words(+Title, ?CompressedTitle) is semidet.
%
%   True if Title contains grammatical words (the, of, to, etc.) and
%   CompressedTitle is Title without the grammatical words.
remove_grammatical_words(Title, CompressedTitle) :- fail.

% take_initials(+Title, ?Initials) is det.
%
%   Unifies Initials with the initial letter of each word of Title.
take_initials(Title, Initials) :- fail.

% take_prefixes(+Title, +TargetLength, ?Prefixes) is det.
%
%   Takes an equal number of letters from the start of each word of
%   Title to produce a single prefix list.
%
%   Example: "Programming Languages", 6 -> "ProLan".
take_prefixes(Title, TargetLength, Prefixes) :- fail.

% suggest_identifier(+Title, -SuggestedIdentifier) is multi.
%
%   Unifies suggestions for Title with SuggestedIdentifier.
suggest_identifier(Title, SuggestedIdentifier) :- fail.
    

% Test cases
:- use_module(library(plunit)).

:- begin_tests(remove_whitespace).

test(whitespace) :- remove_whitespace('This is the End', 'ThisistheEnd').

:- end_tests(remove_whitespace).

:- begin_tests(remove_articles).

test(the) :- remove_articles('This is the End', 'This is End').
test(an)  :- remove_articles('An Anthology', 'Anthology').
test(a)   :- remove_articles('A Christmas Story', 'Christmas Story').

:- end_tests(remove_articles).

:- begin_tests(remove_grammatical_words).

test(to) :- remove_grammatical_words('The Hitchhiker''s Guide to the Galaxy', 'Hitchhiker''s Guide Galaxy').

:- end_tests(remove_grammatical_words).

:- begin_tests(take_initials).

test(ti_taocp) :- take_initials('The Art of Computer Programming', 'TAoCP').
test(ti_cll)   :- take_initials('Common Lisp: The Language', 'CLTL').

:- end_tests(take_initials).

:- begin_tests(take_prefixes).

test(tp_stark) :- take_prefixes('Rise Christianity', 8, 'RiseChri').
test(tp_chuangtzu) :- take_prefixes('Chuang Tzu', 6, 'ChuTzu').

:- end_tests(take_prefixes).

:- begin_tests(suggest_identifier).

test(si_taocp) :-
    suggest_identifier('The Art of Computer Programming', 'TAOCP').
test(si_cll) :-
    suggest_identifier('Common Lisp: The Language', 'CLL').
test(tanach) :-
    suggest_identifier('Tanach', 'TANACH').
test(hhtg) :-
    suggest_identifier('The Hitchhiker''s Guide to the Galaxy', 'HHTG').
test(stark) :-
    % a choose-4 target 8
    suggest_identifier('The Rise of Christianity', 'RISECHRI').
test(chuangtzu) :-
    % this should become a choose-3 target 6
    suggest_identifier('Chuang Tzu', 'CHUTZU').
test(biblit) :-
    % this should become a choose-3 target 6
    suggest_identifier('Biblical Literacy', 'BIBLIT').

:- end_tests(suggest_identifier).
