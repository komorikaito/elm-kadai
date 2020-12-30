# ゼミナールB　Elm課題　完成版
## 目標
Elmを使って図形を描画し、その図形をマウスのドラッグで移動できるようにする。

## 開発環境
Ellieというクラウド開発環境
> https://qiita.com/ababup1192/items/f72dc6bbcbe2f075a74b

## SVGを使用した図形描画
``` elm
module Main exposing (main)

import Svg exposing (Svg, svg, rect, circle)
import Svg.Attributes exposing (width, height, viewBox, x, y, rx, ry, cx, cy, r, fill)


main : Svg msg
main =
    svg
        [ width "120"
        , height "120"
        , viewBox "0 0 120 120"
        ]
        [ rect
            [ x "10"
            , y "10"
            , width "100"
            , height "100"
            , rx "15"
            , ry "15"
            , fill "black"
            ]
            []

        ]
```

## マウスポインタの座標を取得する
``` elm
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
```

参考サイト
> https://blog.emattsan.org/entry/2019/05/26/093114

## ドラッグで図形を移動させる

``` elm
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
 ```
 
