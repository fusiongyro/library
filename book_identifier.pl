:- module(book_identifier, [suggest_identifier/2]).

:- use_module(library(dcg/basics)).

% remove_whitespace(+Title, ?CompressedTitle) is semidet.
%
%   True if Title contains whitespace and CompressedTitle is Title
%   without the whitespace.
remove_whitespace(Title, CompressedTitle) :-
    atom(Title), atom_codes(Title, TitleChars),
    remove_whitespace(TitleChars, CompressedTitleChars),
    atom_codes(CompressedTitle, CompressedTitleChars).
remove_whitespace([], []).
remove_whitespace([T|Ts], Rest) :-
    (char_type(T, graph)
       -> (remove_whitespace(Ts, Remaining),
           Rest = [T|Remaining])
       ;  (remove_whitespace(Ts, Rest))).


% word_tokens(+Title, ?WordTokens) is det.
%
%   Unifies WordTokens with a list of words from Title.
word_tokens(Word, Tokens) :-
    atom(Word),
    atom_codes(Word, WordCodes), !,
    word_tokens(WordCodes, Tokens).
word_tokens(WordCodes, Tokens) :-
    is_list(WordCodes),
    once(phrase(word_tokens(Tokens), WordCodes)).

word_tokens([Word]) -->
    nonblanks(WordCodes), 
    { atom_codes(Word, WordCodes) }.
word_tokens([Word|Words]) -->
    nonblanks(WordCodes),
    whites,
    word_tokens(Words), 
    { atom_codes(Word, WordCodes) }.


% remove_matching(:Goal, +Title, ?CompressedTitle) is det.
%
%   True if CompressedTitle is a title with all words matching Goal
%   removed.
remove_matching(Goal, Title, CompressedTitle) :-
    atom(Title),
    word_tokens(Title, TitleWords),
    remove_matching(Goal, TitleWords, CompressedTitleWords), !,
    atomic_list_concat(CompressedTitleWords, ' ', CompressedTitle).
remove_matching(_, [], []).
remove_matching(Goal, [Word|TitleRest], Result) :-
    remove_matching(Goal, TitleRest, Remaining),
    (\+ (call(Goal, Article), string_lower(Word, Article))
     	-> (Result = [Word|Remaining])
     	;  (Result = Remaining)).

% support for remove_articles
article(a). article(an).
article(the).

% remove_articles(+Title, ?CompressedTitle) is semidet.
%
%   True if Title contains articles (a, an, the) and CompressedTitle
%   is Title without the articles.
remove_articles(Title, CompressedTitle) :-
    once(remove_matching(article, Title, CompressedTitle)).

% support for remove_grammatical_words
grammar(and).	grammar(from).	grammar(onto).
grammar(but).	grammar(in).	grammar(of).
grammar(by).	grammar(over).	grammar(to).
grammar(for).	grammar(on).	grammar(unto).

% remove_grammatical_words(+Title, ?CompressedTitle) is semidet.
%
%   True if Title contains grammatical words (the, of, to, etc.) and
%   CompressedTitle is Title without the grammatical words.
remove_grammatical_words(Title, CompressedTitle) :-
    remove_matching(article, Title, ArticlelessTitle),
    remove_matching(grammar, ArticlelessTitle, CompressedTitle).

% take_initials(+Title, ?Initials) is det.
%
%   Unifies Initials with the initial letter of each word of Title.
take_initials(Title, Initials) :-
    atom(Title),
    word_tokens(Title, TitleWords),
    take_initials(TitleWords, InitialChars),
    atomic_list_concat(InitialChars, Initials).
take_initials([], []).
take_initials([Word|Words], [Initial|Initials]) :-
    atom_chars(Word, [Initial|_]),
    take_initials(Words, Initials).

% take_prefixes(+Title, +TargetLength, ?Prefixes) is det.
%
%   Takes an equal number of letters from the start of each word of
%   Title to produce a single prefix list.
%
%   Example: "Programming Languages", 6 -> "ProLan".
take_prefixes(Title, TargetLength, Prefixes) :-
    atom(Title),
    word_tokens(Title, TitleWords),
    take_prefixes(TitleWords, TargetLength, PrefixWords), !,
    atomic_list_concat(PrefixWords, Prefixes).
take_prefixes(TitleList, TargetLength, Prefixes) :-
    length(TitleList, N),
    PerWord is ceil(TargetLength / N),
    once(take_prefixes(TitleList, TargetLength, PerWord, Prefixes)).
take_prefixes([], _, _, []).
take_prefixes(_, Target, _, []) :- Target =< 0.
take_prefixes([Word|Title], Target, PerWord, [Next|Prefixes]) :-
    Len is min(Target, PerWord), Len > 0,
    sub_atom(Word, 0, Len, _, Next),
    NewTarget is Target - Len,
    take_prefixes(Title, NewTarget, PerWord, Prefixes).

% suggest_identifier(+Title, -SuggestedIdentifier) is multi.
%
%   Unifies suggestions for Title with SuggestedIdentifier.
suggest_identifier(Title, SuggestedIdentifier) :-
    string_upper(Title, TITLES),
    atom_string(TITLE, TITLES),
    take_initials(TITLE, SuggestedIdentifier).
suggest_identifier(TheTitle, SuggestedIdentifier) :-
    remove_articles(TheTitle, Title),
    string_upper(Title, TITLES),
    atom_string(TITLE, TITLES),
    take_initials(TITLE, SuggestedIdentifier).
suggest_identifier(Title, TITLE) :-
    atom_length(Title, Len),
    Len =< 8,
    string_upper(Title, TITLES),
    atom_string(TITLE, TITLES).
suggest_identifier(TheTitle, SuggestedIdentifier) :-
    remove_grammatical_words(TheTitle, Title),
    string_upper(Title, TITLES),
    atom_string(TITLE, TITLES),
    take_initials(TITLE, SuggestedIdentifier).
suggest_identifier(TheTitle, SuggestedIdentifier) :-
    remove_grammatical_words(TheTitle, Title),
    string_upper(Title, TITLES),
    atom_string(TITLE, TITLES),
    between(5, 9, N),
    take_prefixes(TITLE, N, SuggestedIdentifier).
    
% Test cases
:- use_module(library(plunit)).

:- begin_tests(word_tokens).

test(wt_theend) :-
    word_tokens('This is the End', ['This',is,the,'End']).
test(wt_hhiker) :-
    word_tokens('The Hitchhiker''s Guide to the Galaxy', ['The','Hitchhiker''s','Guide',to,the,'Galaxy']).

:- end_tests(word_tokens).

:- begin_tests(remove_whitespace).

test(rw_theend) :-
    remove_whitespace('This is the End', 'ThisistheEnd').
test(rw_theend2) :-
    remove_whitespace('This    is\t the End\n\n', 'ThisistheEnd').

:- end_tests(remove_whitespace).

:- begin_tests(remove_articles).

test(ra_the) :- remove_articles('This is the End', 'This is End').
test(ra_an)  :- remove_articles('An Anthology', 'Anthology').
test(ra_a)   :- remove_articles('A Christmas Story', 'Christmas Story').

:- end_tests(remove_articles).

:- begin_tests(remove_grammatical_words).

test(rgw_to) :-
    remove_grammatical_words('The Hitchhiker''s Guide to the Galaxy', 'Hitchhiker''s Guide Galaxy').
test(rgw_startwar) :-
    remove_grammatical_words('The start of a war', 'start war').

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

test(si_taocp, [nondet]) :-
    suggest_identifier('The Art of Computer Programming', 'TAOCP').
test(si_cll, [nondet]) :-
    suggest_identifier('Common Lisp: The Language', 'CLL').
test(tanach, [nondet]) :-
    suggest_identifier('Tanach', 'TANACH').
test(hhtg, [nondet]) :-
    suggest_identifier('The Hitchhiker''s Guide to the Galaxy', 'HGTG').
test(stark, [nondet]) :-
    % a choose-4 target 8
    suggest_identifier('The Rise of Christianity', 'RISECHRI').
test(chuangtzu, [nondet]) :-
    % this should become a choose-3 target 6
    suggest_identifier('Chuang Tzu', 'CHUTZU').
test(biblit, [nondet]) :-
    % this should become a choose-3 target 6
    suggest_identifier('Biblical Literacy', 'BIBLIT').

:- end_tests(suggest_identifier).
