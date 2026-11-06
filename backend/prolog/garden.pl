:- module(garden, [solve/5, solutions/5, generate/4, hint/5, queens/1]).

:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(apply)).

%! queens(?Columns) is nondet.
% Uma variável por linha impede duas lanternas na mesma linha.
queens(Columns) :-
    length(Columns, 6),
    Columns ins 1..6,
    all_distinct(Columns),
    diagonals(Columns).

diagonals([]).
diagonals([Column|Rest]) :-
    separated(Rest, Column, 1),
    diagonals(Rest).

separated([], _, _).
separated([Other|Rest], Column, Distance) :-
    abs(Column - Other) #\= Distance,
    Next #= Distance + 1,
    separated(Rest, Column, Next).

energy_row(Row) :- length(Row, 6), maplist(between(1, 9), Row).
board(Board) :- length(Board, 6), maplist(between(0, 6), Board).

clue(0, _) :- !. % Zero é ausência de pista, nunca uma coluna válida.
clue(Column, Column).

%! solve(+Energies, +Target, +Givens, +Board, -Solution) is nondet.
% Sem corte: a mesma relação resolve, conta e explica alternativas.
solve(Energies, Target, Givens, Board, Solution) :-
    length(Energies, 6), maplist(energy_row, Energies),
    between(6, 54, Target), board(Givens), board(Board),
    queens(Solution),
    maplist(clue, Givens, Solution),
    maplist(clue, Board, Solution),
    maplist(element, Solution, Energies, Values),
    sum(Values, #=, Target),
    labeling([ff], Solution).

%! solutions(+Energies, +Target, +Givens, +Board, -Solutions) is det.
% O limite 6x6 restringe a enumeração a quatro soluções de N-rainhas.
solutions(Energies, Target, Givens, Board, Solutions) :-
    findall(S, solve(Energies, Target, Givens, Board, S), Solutions).

random_row(Row) :- length(Row, 6), maplist(random_between(1, 9), Row).
energy(Energies, Solution, Total) :-
    maplist(nth1, Solution, Energies, Values), sum_list(Values, Total).

unique_totals(Energies, Options) :-
    findall(T-S, (queens(S), labeling([ff], S), energy(Energies, S, T)), Pairs),
    include(unique_total(Pairs), Pairs, Options).

unique_total(Pairs, Total-_) :-
    findall(S, member(Total-S, Pairs), [_]).

% Esta matriz separa as quatro soluções sem uma repetição aleatória ilimitada.
fallback([[1,2,3,4,5,6],[1,1,1,1,1,1],[1,1,1,1,1,1],
          [1,1,1,1,1,1],[1,1,1,1,1,1],[1,1,1,1,1,1]]).

clue_count(easy, 2).
clue_count(medium, 1).
clue_count(hard, 0).

%! generate(+Difficulty, -Energies, -Target, -Givens) is det.
generate(Difficulty, Energies, Target, Givens) :-
    must_be(oneof([easy, medium, hard]), Difficulty),
    length(Random, 6), maplist(random_row, Random),
    unique_totals(Random, Options),
    ( Options = [] -> fallback(Energies), unique_totals(Energies, Choices)
    ; Energies = Random, Choices = Options ),
    random_member(Target-Solution, Choices),
    clue_count(Difficulty, Count),
    random_permutation([0,1,2,3,4,5], Order),
    length(Chosen, Count), append(Chosen, _, Order),
    numlist(0, 5, Rows),
    maplist(initial_clue(Chosen, Solution), Rows, Givens),
    !.

initial_clue(Chosen, Solution, Row, Value) :-
    ( memberchk(Row, Chosen) -> nth0(Row, Solution, Value) ; Value = 0 ).

%! hint(+Energies, +Target, +Givens, +Board, -Result) is det.
% Só diz "forçada" se TODAS as soluções compatíveis contêm a jogada.
hint(Energies, Target, Givens, Board, Result) :-
    solutions(Energies, Target, Givens, Board, Solutions),
    ( Solutions = [] -> Result = unsolvable
    ; nth0(Row, Board, 0) ->
        findall(C, (member(S, Solutions), nth0(Row, S, C)), Columns),
        sort(Columns, Candidates),
        Candidates = [Column|_],
        ( Candidates = [_] -> Kind = forced ; Kind = possible ),
        Result = [Row, Column, Kind]
    ; Result = complete ).
