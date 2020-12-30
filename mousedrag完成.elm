module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Json.Decode exposing (..)

main = Browser.sandbox{ init = init , update = update , view = view}

type alias Model = { x: Int , y: Int , offsetX:Int, offsetY:Int ,drag:Bool}

init : Model
init = { x = 0 , y = 0 ,offsetX=0, offsetY=0, drag=False}

type Msg = Move Int Int | Offset Int Int | Down | Up

update : Msg -> Model -> Model
update msg model =
  case msg of
    Down -> {model | drag=True}
    Up -> {model | drag=False}
    Move x y -> if model.drag==True then {model | x=x-model.offsetX,y=y-model.offsetY}
                else model
    Offset x y -> if model.drag == True then model
                  else {model | offsetX = x, offsetY = y}

view : Model -> Html Msg
view model =
      div[ style "position" "relative"
         , style "height" "80vh"
         , on "mousemove" (map2 Move (field "clientX" int) (field "clientY" int))
         , onMouseUp Up
        ]
      [ div
        [ style "position" "absolute"
        , style "top" <| String.fromInt model.y ++ "px"
        , style "left" <| String.fromInt model.x ++ "px"
        , style "width" "50px"
        , style "height" "50px"
        , style "background-color" "red"
        , on "mousemove" (map2 Offset (field "offsetX" int) (field "offsetY" int))
        , onMouseDown Down
        ]
        []
      ]