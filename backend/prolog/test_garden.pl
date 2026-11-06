:- use_module(garden).
:- use_module(library(plunit)).
:- use_module(library(clpfd)).

:- begin_tests(garden).

zero([0,0,0,0,0,0]).
fixture([[1,2,3,4,5,6],[1,1,1,1,1,1],[1,1,1,1,1,1],
         [1,1,1,1,1,1],[1,1,1,1,1,1],[1,1,1,1,1,1]]).

test(four_queens_solutions, true(N == 4)) :-
    findall(S, (queens(S), labeling([], S)), All), length(All, N).

test(unique_energy_solution, true(All == [[2,4,6,1,3,5]])) :-
    fixture(E), zero(Z), solutions(E, 7, Z, Z, All).

test(duplicate_column, fail) :-
    fixture(E), zero(Z), solve(E, 7, Z, [2,2,0,0,0,0], _).

test(distant_diagonal, fail) :-
    fixture(E), zero(Z), solve(E, 7, Z, [2,0,4,0,0,0], _).

test(wrong_energy, true(All == [])) :-
    fixture(E), zero(Z), solutions(E, 54, Z, Z, All).

test(cannot_override_given, fail) :-
    fixture(E), solve(E, 7, [3,0,0,0,0,0], [2,0,0,0,0,0], _).

test(given_applies_when_board_empty, true(All == [])) :-
    fixture(E), zero(Z), solutions(E, 7, [3,0,0,0,0,0], Z, All).

test(multiple_solutions, true(N == 4)) :-
    length(E, 6), maplist(=([1,1,1,1,1,1]), E), zero(Z),
    solutions(E, 6, Z, Z, All), length(All, N).

test(forced_hint, true(H == [0,2,forced])) :-
    fixture(E), zero(Z), hint(E, 7, Z, Z, H).

test(possible_hint_is_not_forced, true(H == [0,2,possible])) :-
    length(E, 6), maplist(=([1,1,1,1,1,1]), E), zero(Z),
    hint(E, 6, Z, Z, H).

test(complete_hint, true(H == complete)) :-
    fixture(E), zero(Z), hint(E, 7, Z, [2,4,6,1,3,5], H).

test(full_but_invalid_hint, true(H == unsolvable)) :-
    fixture(E), zero(Z), hint(E, 7, Z, [1,2,3,4,5,6], H).

test(invalid_shape, fail) :- fixture(E), zero(Z), solve(E, 7, Z, [0], _).
test(invalid_energy, fail) :- zero(Z), solve([[0]], 7, Z, Z, _).

test(all_levels_unique_and_correct_clues) :-
    forall((member(Level-Count, [easy-2,medium-1,hard-0]), between(1, 20, _)),
           (generate(Level, E, T, G), zero(Z), solutions(E, T, G, Z, [_]),
            include(\==(0), G, Clues), length(Clues, Count),
            solutions(E, T, Z, Z, [_]))).

test(fallback_always_separates_four_solutions) :-
    garden:fallback(E), garden:unique_totals(E, Options), length(Options, 4).

test(bad_difficulty, error(type_error(_, impossible))) :- generate(impossible, _, _, _).

:- end_tests(garden).
