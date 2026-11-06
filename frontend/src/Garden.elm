module Garden exposing (Board, Cell(..), Puzzle, change, columns, complete, conflicts, create, energy, initial, lanterns, place, reset, reveal, value)

import Array exposing (Array)
import Set exposing (Set)


type alias Puzzle =
    { energies : Array (Array Int), target : Int, givens : List Int }


type Cell
    = Empty
    | Fixed Int
    | Player Int
    | Revealed Int


type alias Board =
    Array Cell


create : List (List Int) -> Int -> List Int -> Result String Puzzle
create energies target givens =
    if List.length energies == 6 && List.all (\row -> List.length row == 6 && List.all (\n -> n >= 1 && n <= 9) row) energies && List.length givens == 6 && List.all (\n -> n >= 0 && n <= 6) givens && target >= 6 && target <= 54 then
        Ok { energies = Array.fromList (List.map Array.fromList energies), target = target, givens = givens }

    else
        Err "O servidor enviou um jardim inválido."


initial : Puzzle -> Board
initial puzzle =
    puzzle.givens
        |> List.map
            (\n ->
                if n == 0 then
                    Empty

                else
                    Fixed n
            )
        |> Array.fromList


value : Cell -> Int
value cell =
    case cell of
        Empty ->
            0

        Fixed n ->
            n

        Player n ->
            n

        Revealed n ->
            n


columns : Board -> List Int
columns =
    Array.toList >> List.map value


change : Int -> Int -> Board -> Board
change row column board =
    case Array.get row board of
        Just (Fixed _) ->
            board

        Just cell ->
            if column >= 1 && column <= 6 then
                Array.set row
                    (if value cell == column then
                        Empty

                     else
                        Player column
                    )
                    board

            else
                board

        Nothing ->
            board


place : Int -> Int -> Board -> Board
place row column board =
    case Array.get row board of
        Just Empty ->
            if column >= 1 && column <= 6 then
                Array.set row (Revealed column) board

            else
                board

        _ ->
            board


reveal : List Int -> Board -> Board
reveal solution board =
    Array.indexedMap
        (\row cell ->
            case cell of
                Fixed _ ->
                    cell

                _ ->
                    case List.drop row solution of
                        column :: _ ->
                            Revealed column

                        [] ->
                            cell
        )
        board


reset : Puzzle -> Board
reset =
    initial


lanterns : Board -> List ( Int, Int )
lanterns board =
    board
        |> Array.toIndexedList
        |> List.filterMap
            (\( row, cell ) ->
                if value cell == 0 then
                    Nothing

                else
                    Just ( row, value cell )
            )


conflicts : Board -> Set Int
conflicts board =
    let
        placed =
            lanterns board

        attacked ( row, column ) =
            List.any (\( other, col ) -> row /= other && (column == col || abs (row - other) == abs (column - col))) placed
    in
    placed |> List.filter attacked |> List.map Tuple.first |> Set.fromList


energy : Puzzle -> Board -> Int
energy puzzle board =
    lanterns board
        |> List.filterMap
            (\( row, column ) ->
                Array.get row puzzle.energies |> Maybe.andThen (Array.get (column - 1))
            )
        |> List.sum


complete : Puzzle -> Board -> Bool
complete puzzle board =
    List.length (lanterns board) == 6 && Set.isEmpty (conflicts board) && energy puzzle board == puzzle.target
