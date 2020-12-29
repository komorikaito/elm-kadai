# ゼミナールB　Elm課題
## 目標
Elmを使って図形を描画し、その図形をマウスのドラッグで移動できるようにする。

## 開発環境
Ellieというクラウド開発環境
> https://qiita.com/ababup1192/items/f72dc6bbcbe2f075a74b

## SVGを使用した図形描画
'''elm
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
        '''

## viewで図形を表示する
上記でmainで図形描画していたものをviewで描画できるようにする。

