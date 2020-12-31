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

## ドラッグ移動のサンプル
```elm
module Main exposing (main)

import Browser
--import Html exposing (Html, button, div, text)
--import Html.Events exposing (onClick)
import Svg exposing(..)
import Svg.Attributes exposing(..)
import Html.Events.Extra.Mouse as Mouse
import List.Extra

main = 
    Browser.sandbox {init = init, update = update, view = view}

type alias Model = {
    rects: List (Float,Float),
    dragState: DragState }

type DragState = NotDragging | Dragging Int

init : Model
init = {
    rects=[(5,5),(200,200)],
    dragState = NotDragging }

type Msg = Down Mouse.Event | Move Mouse.Event | Up Mouse.Event

update : Msg -> Model -> Model
update msg model =
    case msg of
        Down event ->
            case intersects event.clientPos model.rects of
                Just index ->
                    { model | dragState = Dragging index}
                Nothing ->
                    { model | dragState = NotDragging }
        
        Move  event ->
            case model.dragState of
                Dragging index ->
                    {model | rects =List.Extra.setAt index
                        (event.clientPos) model.rects }
                NotDragging ->
                    model
            
        Up event ->
            { model | dragState = NotDragging }
            
intersects: (Float,Float) -> List (Float,Float) -> Maybe Int
intersects pos rects =
    rects
        |>List.Extra.findIndex(intersect pos)

intersect: (Float,Float) -> (Float,Float) -> Bool
intersect (px,py) (rx,ry) = 
    if between px rx (rx+100) then
        if between py ry (ry+100) then
            True
        else
            False
    else
        False
        
between: Float -> Float -> Float -> Bool
between o min max =
    if o > min then
        if o < max then
            True
        else
            False
     else
         False
         
-- VIEW
view : Model -> Svg Msg
view model =
    svg
        [ width "500"
        , height "500"
        ,viewBox "0 0 500 500"
        , Mouse.onDown Down
        , Mouse.onMove Move
        , Mouse.onUp Up
        ]
        (List.append
          (List.map viewRect model.rects)
          [text (Debug.toString model)]
        )
        
viewRect : (Float,Float) -> Svg msg
viewRect (xPos,yPos)=
    rect [x (String.fromFloat xPos), y (String.fromFloat yPos)
        ,width "100", height "100"] []
 ```
参考サイト
> https://youtu.be/pv_GM2Bu-NU

問題点
- コードが長い（50行ほどにおさまるらしい）
- Listなど理解できていないところが多数

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

図形のdiv要素をクリックした時dragがTrueになり
Trueの時、x,y座標をoffsetを基点にして移動させる(offsetはdiv要素の左上)
