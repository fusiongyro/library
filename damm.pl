% number_digits(+Number, -Digits) is det.
%
%   Unifies Digits with the digits of Number, as numbers.
number_digits(Number, Digits) :-
    nonvar(Number),
    atom_chars(Number, NumberChars),
    maplist(atom_number, NumberChars, Digits).

% damm_check(+Number, -CheckDigit) is det.
% damm_check(+Number, ?CheckDigit) is semidet.
%
%   Unify CheckDigit with the appropriate Damm check digit for Number.
damm_check(Number, CheckDigit) :-
    number_digits(Number, Digits),
    damm_check_digits(Digits, 0, CheckDigit).

% damm_valid(+Number) is semidet.
%
%   True if Number is a number with the correct Damm check digit.
damm_valid(NumberWithCheckDigit) :-
    Number is NumberWithCheckDigit div 10,
    CheckDigit is NumberWithCheckDigit mod 10,
    damm_check(Number, CheckDigit).

damm_generate(Number, NumberWithCheckDigit) :-
    damm_check(Number, CheckDigit),
    NumberWithCheckDigit is Number * 10 + CheckDigit.

damm_check_digits([Digit], Interim, CheckDigit) :-
    !, damm_next_digit(Interim, Digit, CheckDigit).
damm_check_digits([Digit|Ds], Interim, CheckDigit) :-
    damm_next_digit(Interim, Digit, NextInterim),
    damm_check_digits(Ds, NextInterim, CheckDigit).
    
damm_next_digit(Interim, Digit, Next) :-
    DammTable = 
    [[0, 3, 1, 7, 5, 9, 8, 6, 4, 2],
     [7, 0, 9, 2, 1, 5, 4, 8, 6, 3],
     [4, 2, 0, 6, 8, 7, 1, 3, 5, 9],
     [1, 7, 5, 0, 9, 8, 3, 4, 2, 6],
     [6, 1, 2, 3, 0, 4, 5, 9, 7, 8],
     [3, 6, 7, 4, 2, 0, 9, 5, 8, 1],
     [5, 8, 6, 9, 7, 2, 0, 1, 3, 4],
     [8, 9, 4, 5, 3, 6, 2, 0, 1, 7],
     [9, 4, 3, 8, 6, 1, 7, 2, 0, 5],
     [2, 5, 8, 1, 4, 3, 6, 7, 9, 0]],
    nth0(Interim, DammTable, Row),
    nth0(Digit, Row, Next).

