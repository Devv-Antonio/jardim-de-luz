port module Checks exposing (main)

import Api
import Array
import Garden exposing (Cell(..))
import Json.Decode as D
import Platform
import Set


port report : List String -> Cmd msg


main : Program () () Never
main =
    Platform.worker { init = \_ -> ( (), report checks ), update = \msg _ -> never msg, subscriptions = \_ -> Sub.none }


checks : List String
checks =
    case Garden.create (List.range 1 6 :: List.repeat 5 (List.repeat 6 1)) 7 [ 0, 0, 0, 0, 0, 0 ] of
        Err error ->
            [ error ]

        Ok puzzle ->
            let
                empty =
                    Garden.initial puzzle

                solved =
                    Array.fromList (List.map Player [ 2, 4, 6, 1, 3, 5 ])

                fixed =
                    Array.set 0 (Fixed 2) empty

                check label condition =
                    if condition then
                        Nothing

                    else
                        Just label

                fails decoder raw =
                    case D.decodeString decoder raw of
                        Err _ ->
                            True

                        Ok _ ->
                            False
            in
            List.filterMap identity
                [ check "vitória exige todas as regras" (Garden.complete puzzle solved)
                , check "vazio não vence" (not (Garden.complete puzzle empty))
                , check "soma exata" (Garden.energy puzzle solved == 7)
                , check "soma errada impede vitória" (not (Garden.complete { puzzle | target = 8 } solved))
                , check "coluna repetida" (not (Set.isEmpty (Garden.conflicts (Array.fromList (List.map Player [ 2, 2, 0, 0, 0, 0 ])))))
                , check "diagonal distante" (not (Set.isEmpty (Garden.conflicts (Array.fromList (List.map Player [ 2, 0, 4, 0, 0, 0 ])))))
                , check "pista imutável" (Garden.change 0 3 fixed == fixed)
                , check "trocar coluna" (Garden.columns (Garden.change 0 3 (Garden.change 0 2 empty)) == [ 3, 0, 0, 0, 0, 0 ])
                , check "clicar de novo apaga" (Garden.change 0 2 (Garden.change 0 2 empty) == empty)
                , check "linha fora dos limites" (Garden.change 9 2 empty == empty)
                , check "coluna fora dos limites" (Garden.change 0 7 empty == empty)
                , check "dica preserva pista" (Garden.place 0 3 fixed == fixed)
                , check "solução preserva pista" (Array.get 0 (Garden.reveal [ 3, 4, 6, 1, 3, 5 ] fixed) == Just (Fixed 2))
                , check "decoder rejeita solução curta" (fails Api.boardDecoder "{\"board\":[1]}")
                , check "decoder rejeita coluna inválida" (fails Api.hintDecoder "{\"row\":0,\"column\":7,\"forced\":true}")
                , check "decoder rejeita linha inválida" (fails Api.hintDecoder "{\"row\":6,\"column\":2,\"forced\":true}")
                , check "domínio rejeita dimensões erradas"
                    (case Garden.create [] 7 [] of
                        Err _ ->
                            True

                        Ok _ ->
                            False
                    )
                ]
