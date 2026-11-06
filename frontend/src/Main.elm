module Main exposing (main)

import Api exposing (Difficulty(..))
import Array
import Browser
import Garden exposing (Board, Cell(..), Puzzle)
import Html exposing (Html, aside, button, div, footer, h1, h2, header, li, main_, ol, p, section, span, strong, text)
import Html.Attributes exposing (attribute, class, classList, disabled, title)
import Html.Events exposing (onClick)
import Set


type Model
    = Starting
    | StartFailed String
    | Ready Game
    | Waiting Operation Game


type Operation
    = Generating Difficulty
    | Hinting
    | Solving


type Assistance
    = Independent
    | Assisted


type alias Game =
    { puzzle : Puzzle
    , board : Board
    , history : List Board
    , difficulty : Difficulty
    , assistance : Assistance
    , message : Maybe String
    }


type Msg
    = NewGame Difficulty
    | GotPuzzle (Result String Puzzle)
    | Toggle Int Int
    | Undo
    | Reset
    | AskHint
    | GotHint (Result String Api.Hint)
    | AskSolution
    | GotSolution (Result String (List Int))


main : Program () Model Msg
main =
    Browser.element { init = \_ -> ( Starting, Api.generate Medium GotPuzzle ), update = update, view = view, subscriptions = \_ -> Sub.none }


newGame : Difficulty -> Puzzle -> Game
newGame difficulty puzzle =
    { puzzle = puzzle, board = Garden.initial puzzle, history = [], difficulty = difficulty, assistance = Independent, message = Nothing }


remember : Board -> Game -> Game
remember board game =
    if board == game.board then
        game

    else
        { game | board = board, history = game.board :: game.history, message = Nothing }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotPuzzle result, Starting ) ->
            case result of
                Ok puzzle ->
                    ( Ready (newGame Medium puzzle), Cmd.none )

                Err error ->
                    ( StartFailed error, Cmd.none )

        ( NewGame _, StartFailed _ ) ->
            ( Starting, Api.generate Medium GotPuzzle )

        ( NewGame difficulty, Ready game ) ->
            ( Waiting (Generating difficulty) game, Api.generate difficulty GotPuzzle )

        ( GotPuzzle result, Waiting (Generating difficulty) game ) ->
            case result of
                Ok puzzle ->
                    ( Ready (newGame difficulty puzzle), Cmd.none )

                Err error ->
                    ( Ready { game | message = Just error }, Cmd.none )

        ( Toggle row column, Ready game ) ->
            ( Ready (remember (Garden.change row column game.board) game), Cmd.none )

        ( Undo, Ready game ) ->
            case game.history of
                previous :: rest ->
                    ( Ready { game | board = previous, history = rest, message = Nothing }, Cmd.none )

                [] ->
                    ( model, Cmd.none )

        ( Reset, Ready game ) ->
            ( Ready (remember (Garden.reset game.puzzle) game), Cmd.none )

        ( AskHint, Ready game ) ->
            ( Waiting Hinting game, Api.hint game.puzzle game.board GotHint )

        ( GotHint result, Waiting Hinting game ) ->
            case result of
                Ok hint ->
                    let
                        changed =
                            remember (Garden.place hint.row hint.column game.board) game

                        explanation =
                            if hint.forced then
                                "Jogada forçada: todas as soluções compatíveis colocam a lanterna aqui."

                            else
                                "Uma jogada possível. Há mais de uma solução compatível; esta escolha não é forçada."
                    in
                    ( Ready { changed | assistance = Assisted, message = Just ("Linha " ++ String.fromInt (hint.row + 1) ++ ", coluna " ++ String.fromInt hint.column ++ ". " ++ explanation) }, Cmd.none )

                Err error ->
                    ( Ready { game | message = Just error }, Cmd.none )

        ( AskSolution, Ready game ) ->
            ( Waiting Solving game, Api.solve game.puzzle game.board GotSolution )

        ( GotSolution result, Waiting Solving game ) ->
            case result of
                Ok solution ->
                    let
                        changed =
                            remember (Garden.reveal solution game.board) game
                    in
                    ( Ready { changed | assistance = Assisted }, Cmd.none )

                Err error ->
                    ( Ready { game | message = Just error }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ header [ class "topbar" ]
            [ span [ class "brand" ] [ span [ class "brand-icon", attribute "aria-hidden" "true" ] [ text "✦" ], text "Jardim de Luz" ]
            , span [ class "course" ] [ text "PARADIGMAS DE PROGRAMAÇÃO · 2026" ]
            ]
        , main_ []
            [ section [ class "intro" ]
                [ p [ class "eyebrow" ] [ text "UM PEQUENO JARDIM. UM DESAFIO LÓGICO." ]
                , h1 [] [ text "Encontre o lugar", Html.br [] [], span [] [ text "de cada luz." ] ]
                , p [ class "lead" ] [ text "Seis lanternas, um equilíbrio perfeito. Combine posições e energia para iluminar o jardim." ]
                ]
            , case model of
                Starting ->
                    div [ class "empty-state", attribute "role" "status" ] [ text "Preparando seu jardim…" ]

                StartFailed error ->
                    div [ class "empty-state", attribute "role" "alert" ]
                        [ p [] [ text error ], button [ class "primary", onClick (NewGame Medium) ] [ text "Tentar novamente" ] ]

                Ready game ->
                    viewGame False game

                Waiting _ game ->
                    viewGame True game
            ]
        , footer [] [ text "Feito com raciocínio lógico e funções puras. ", strong [] [ text "Prolog + Elm" ], text " · Ponte FastAPI/JSON" ]
        ]


viewGame : Bool -> Game -> Html Msg
viewGame busy game =
    let
        total =
            Garden.energy game.puzzle game.board

        count =
            List.length (Garden.lanterns game.board)

        won =
            Garden.complete game.puzzle game.board

        conflictRows =
            Garden.conflicts game.board
    in
    div [ class "game-layout" ]
        [ section
            [ class "garden-panel"
            , attribute "aria-label" "Tabuleiro do Jardim de Luz"
            , attribute "aria-busy"
                (if busy then
                    "true"

                 else
                    "false"
                )
            ]
            [ div [ class "board-heading" ]
                [ div [] [ p [ class "eyebrow" ] [ text "SEU JARDIM" ], h2 [] [ text "Acenda com intenção" ] ]
                , span [ class "level-badge" ] [ text (Api.label game.difficulty) ]
                ]
            , div [ class "metrics", attribute "aria-live" "polite" ]
                [ metric "LANTERNAS" (String.fromInt count ++ " / 6")
                , metric "ENERGIA ATUAL" (String.fromInt total)
                , metric "ENERGIA ALVO" (String.fromInt game.puzzle.target)
                ]
            , div [ class "column-labels", attribute "aria-hidden" "true" ] (List.map (\n -> span [] [ text (String.fromInt n) ]) (List.range 1 6))
            , div [ class "board", classList [ ( "board--won", won ) ] ]
                (List.range 0 5 |> List.concatMap (\row -> List.range 1 6 |> List.map (viewCell busy game conflictRows row)))
            , div [ class "legend" ] [ span [] [ text "✦ sua lanterna" ], span [] [ text "◆ pista fixa" ], span [] [ text "✧ ajuda do Prolog" ] ]
            , div [ class "status", attribute "role" "status", attribute "aria-live" "polite" ]
                [ text
                    (if busy then
                        "O Prolog está buscando…"

                     else if won then
                        case game.assistance of
                            Independent ->
                                "Jardim iluminado! Você encontrou o equilíbrio."

                            Assisted ->
                                "Jardim iluminado com ajuda do Prolog."

                     else if not (Set.isEmpty conflictRows) then
                        "Conflito: lanternas não podem compartilhar coluna ou diagonal."

                     else if count == 6 then
                        "As posições estão livres, mas a energia ainda não atingiu o alvo."

                     else
                        "Clique numa casa para colocar ou retirar uma lanterna."
                    )
                ]
            ]
        , aside [ class "side-panel" ]
            [ section [ class "card" ]
                [ p [ class "eyebrow" ] [ text "01 / COMO JOGAR" ]
                , h2 [] [ text "Cultive o equilíbrio" ]
                , ol [ class "rules" ]
                    [ li [] [ strong [] [ text "Uma por linha e coluna." ], text " Ao escolher outra casa da linha, a lanterna se move." ]
                    , li [] [ strong [] [ text "Diagonais livres." ], text " Nenhuma lanterna pode enxergar outra na diagonal, mesmo à distância." ]
                    , li [] [ strong [] [ text "A soma precisa fechar." ], text " Some os números das seis casas iluminadas e alcance a energia alvo." ]
                    ]
                , p [ class "tip" ] [ text "As pistas ◆ são fixas. Os números indicam energia, não a quantidade de lanternas." ]
                ]
            , section [ class "card controls" ]
                [ p [ class "eyebrow" ] [ text "02 / ESCOLHA SEU DESAFIO" ]
                , div [ class "levels" ]
                    (List.map
                        (\difficulty ->
                            button
                                [ disabled busy, onClick (NewGame difficulty), classList [ ( "active", difficulty == game.difficulty ) ], title "Inicia outro jardim" ]
                                [ text (Api.label difficulty)
                                , span []
                                    [ text
                                        (case difficulty of
                                            Easy ->
                                                "2 pistas"

                                            Medium ->
                                                "1 pista"

                                            Hard ->
                                                "Sem pistas"
                                        )
                                    ]
                                ]
                        )
                        [ Easy, Medium, Hard ]
                    )
                , div [ class "actions" ]
                    [ button [ class "primary", disabled (busy || won), onClick AskHint ] [ text "✧ Pedir uma dica" ]
                    , button [ disabled (busy || won), onClick AskSolution ] [ text "Revelar solução" ]
                    , button [ disabled (busy || List.isEmpty game.history), onClick Undo ] [ text "↶ Desfazer" ]
                    , button [ disabled busy, onClick Reset ] [ text "Reiniciar jardim" ]
                    ]
                , case game.message of
                    Just message ->
                        p [ class "notice", attribute "role" "status" ] [ text message ]

                    Nothing ->
                        text ""
                ]
            , p [ class "footnote" ] [ text "Cada jardim gerado tem uma única solução. Sem cronômetro: pense no seu ritmo." ]
            ]
        ]


metric : String -> String -> Html msg
metric name value =
    div [] [ span [] [ text name ], strong [] [ text value ] ]


viewCell : Bool -> Game -> Set.Set Int -> Int -> Int -> Html Msg
viewCell busy game conflictRows row column =
    let
        cell =
            Array.get row game.board

        occupied =
            Maybe.map Garden.value cell == Just column

        fixed =
            case cell of
                Just (Fixed _) ->
                    True

                _ ->
                    False

        revealed =
            case cell of
                Just (Revealed _) ->
                    True

                _ ->
                    False

        energy =
            Array.get row game.puzzle.energies |> Maybe.andThen (Array.get (column - 1))

        symbol =
            if fixed then
                "◆"

            else if revealed then
                "✧"

            else
                "✦"

        suffix =
            if occupied then
                if fixed then
                    ", pista fixa"

                else
                    ", lanterna acesa"

            else
                ""
    in
    button
        [ class "cell"
        , classList [ ( "cell--lit", occupied ), ( "cell--fixed", fixed && occupied ), ( "cell--revealed", revealed && occupied ), ( "cell--conflict", occupied && Set.member row conflictRows ) ]
        , disabled (busy || fixed)
        , onClick (Toggle row column)
        , attribute "aria-pressed"
            (if occupied then
                "true"

             else
                "false"
            )
        , attribute "aria-label" ("Linha " ++ String.fromInt (row + 1) ++ ", coluna " ++ String.fromInt column ++ ", energia " ++ Maybe.withDefault "indisponível" (Maybe.map String.fromInt energy) ++ suffix)
        ]
        [ span [ class "cell-energy" ] [ text (Maybe.withDefault "" (Maybe.map String.fromInt energy)) ]
        , span [ class "lantern", attribute "aria-hidden" "true" ]
            [ text
                (if occupied then
                    symbol

                 else
                    "·"
                )
            ]
        ]
