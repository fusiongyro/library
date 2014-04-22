:- module(book_identifier, suggest_identifier/2).

% remove_whitespace(+Title, ?CompressedTitle) is semidet.
%
%   True if Title contains whitespace and CompressedTitle is Title
%   without the whitespace.
remove_whitespace(Title, CompressedTitle).

% remove_articles(+Title, ?CompressedTitle) is semidet.
%
%   True if Title contains articles (a, an, the) and CompressedTitle
%   is Title without the articles.
remove_articles(Title, CompressedTitle).

% remove_grammatical_words(+Title, ?CompressedTitle) is semidet.
%
%   True if Title contains grammatical words (the, of, to, etc.) and
%   CompressedTitle is Title without the grammatical words.
remove_grammatical_words(Title, CompressedTitle),

% take_initials(+Title, ?Initials) is det.
%
%   Unifies Initials with the initial letter of each word of Title.
take_initials(Title, Initials).

% take_prefixes(+Title, +TargetLength, ?Prefixes) is det.
%
%   Takes an equal number of letters from the start of each word of
%   Title to produce a single prefix list.
%
%   Example: "Programming Languages", 6 -> "ProLan".
take_prefixes(Title, TargetLength, Prefixes).

% suggest_identifier(+Title, -SuggestedIdentifier) is multi.
%
%   Unifies suggestions for Title with SuggestedIdentifier.
suggest_identifier(Title, SuggestedIdentifier).

    
