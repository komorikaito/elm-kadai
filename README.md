# ゼミナールB　Elm課題
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
