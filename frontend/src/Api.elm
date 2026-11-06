module Api exposing (Difficulty(..), Hint, boardDecoder, generate, hint, hintDecoder, label, puzzleDecoder, solve)

import Array
import Garden exposing (Board, Puzzle)
import Http
import Json.Decode as D exposing (Decoder)
import Json.Encode as E


type Difficulty
    = Easy
    | Medium
    | Hard


label : Difficulty -> String
label difficulty =
    case difficulty of
        Easy ->
            "Brotar"

        Medium ->
            "Florescer"

        Hard ->
            "Iluminar"


name : Difficulty -> String
name difficulty =
    case difficulty of
        Easy ->
            "easy"

        Medium ->
            "medium"

        Hard ->
            "hard"


type alias Hint =
    { row : Int, column : Int, forced : Bool }


generate : Difficulty -> (Result String Puzzle -> msg) -> Cmd msg
generate difficulty =
    post "generate" (E.object [ ( "difficulty", E.string (name difficulty) ) ]) puzzleDecoder


solve : Puzzle -> Board -> (Result String (List Int) -> msg) -> Cmd msg
solve puzzle board =
    post "solve" (encode puzzle board) boardDecoder


hint : Puzzle -> Board -> (Result String Hint -> msg) -> Cmd msg
hint puzzle board =
    post "hint" (encode puzzle board) hintDecoder


encode : Puzzle -> Board -> E.Value
encode puzzle board =
    E.object
        [ ( "energies", E.list (Array.toList >> E.list E.int) (Array.toList puzzle.energies) )
        , ( "target", E.int puzzle.target )
        , ( "givens", E.list E.int puzzle.givens )
        , ( "board", E.list E.int (Garden.columns board) )
        ]


puzzleDecoder : Decoder Puzzle
puzzleDecoder =
    D.map3 Garden.create
        (D.field "energies" (D.list (D.list D.int)))
        (D.field "target" D.int)
        (D.field "givens" (D.list D.int))
        |> D.andThen
            (\result ->
                case result of
                    Ok puzzle ->
                        D.succeed puzzle

                    Err error ->
                        D.fail error
            )


bounded : Int -> Int -> Decoder Int
bounded low high =
    D.int
        |> D.andThen
            (\n ->
                if n >= low && n <= high then
                    D.succeed n

                else
                    D.fail "Fora do intervalo"
            )


boardDecoder : Decoder (List Int)
boardDecoder =
    D.field "board" (D.list (bounded 1 6))
        |> D.andThen
            (\board ->
                if List.length board == 6 then
                    D.succeed board

                else
                    D.fail "Tabuleiro incompleto"
            )


hintDecoder : Decoder Hint
hintDecoder =
    D.map3 Hint (D.field "row" (bounded 0 5)) (D.field "column" (bounded 1 6)) (D.field "forced" D.bool)


post : String -> E.Value -> Decoder a -> (Result String a -> msg) -> Cmd msg
post route body decoder toMsg =
    Http.request
        { method = "POST"
        , headers = []
        , url = "/api/" ++ route
        , body = Http.jsonBody body
        , timeout = Just 10000
        , tracker = Nothing
        , expect =
            Http.expectStringResponse toMsg
                (\response ->
                    case response of
                        Http.GoodStatus_ _ raw ->
                            D.decodeString decoder raw |> Result.mapError (\_ -> "Resposta inválida do servidor.")

                        Http.BadStatus_ metadata raw ->
                            case D.decodeString (D.field "detail" D.string) raw of
                                Ok detail ->
                                    Err detail

                                Err _ ->
                                    Err ("Pedido recusado (HTTP " ++ String.fromInt metadata.statusCode ++ ").")

                        Http.Timeout_ ->
                            Err "O Prolog demorou a responder. Tente novamente."

                        Http.NetworkError_ ->
                            Err "Sem conexão com o backend. Confira se ele está rodando e tente novamente."

                        Http.BadUrl_ _ ->
                            Err "Endereço do servidor inválido."
                )
        }
