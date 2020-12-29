module Main exposing (main)

import Browser
import Html exposing (Html, div, span, text)
import Html.Events exposing (on)
import Html.Attributes exposing (style)
import Json.Decode exposing (map2, field, int)

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }

type alias Model = { x: Int , y: Int }

init : Model
init = { x = 0 , y = 0 }

type Msg = Move Int Int

update : Msg -> Model -> Model
update msg model =
  case msg of
    Move x y -> {x = x, y = y}

view : Model -> Html Msg
view model =
  div []
    [ span
        []
        [ text ("(" ++ (String.fromInt model.x) ++ ", " ++ String.fromInt model.y ++ ")") ]
    , div
        [ style "background-color" "gray"
        , style "height" "80vh"
        , on "mousemove" (map2 Move (field "clientX" int) (field "clientY" int))
        ]
        []
    ]