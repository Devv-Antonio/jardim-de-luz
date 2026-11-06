:- module(bridge, [main/0]).
:- use_module(library(http/json)).
:- use_module(garden).

% Um pedido JSON pela entrada padrão; uma resposta JSON, sem estado global.
main :-
    json_read_dict(current_input, Request),
    dispatch(Request.action, Request, Response),
    json_write_dict(current_output, Response), nl.

dispatch("generate", Request, Response) :-
    atom_string(Difficulty, Request.difficulty),
    generate(Difficulty, Energies, Target, Givens),
    Response = _{energies:Energies, target:Target, givens:Givens}.
dispatch("solve", R, Response) :-
    ( once(solve(R.energies, R.target, R.givens, R.board, Solution))
    -> Response = _{board:Solution}
    ; Response = _{status:unsolvable} ).
dispatch("hint", R, Response) :-
    hint(R.energies, R.target, R.givens, R.board, Hint),
    hint_response(Hint, Response).

hint_response(unsolvable, _{status:unsolvable}).
hint_response(complete, _{status:complete}).
hint_response([Row, Column, Kind], _{row:Row, column:Column, forced:Forced}) :-
    ( Kind == forced -> Forced = true ; Forced = false ).
