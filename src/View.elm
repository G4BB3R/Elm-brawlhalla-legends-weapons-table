module View exposing (..)

import Model exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


( iconWidth, iconHeight ) =
    ( 66, 66 )


posToXy : ( Int, Int ) -> ( Int, Int )
posToXy ( x_, y_ ) =
    ( x_ * iconWidth, y_ * iconHeight )


iconX : ( Int, Int ) -> Svg a
iconX pos =
    let
        ( x_, y_ ) =
            posToXy pos
    in
        svg
            [ x <| toString x_
            , y <| toString y_
            ]
            [ line
                [ x1 <| toString <| iconWidth // 4
                , x2 <| toString <| iconWidth - iconWidth // 4
                , y1 <| toString <| iconHeight // 4
                , y2 <| toString <| iconHeight - iconWidth // 4
                , stroke "red"
                , strokeWidth "2"
                ]
                []
            , line
                [ x1 <| toString <| iconWidth // 4
                , x2 <| toString <| iconWidth - iconWidth // 4
                , y1 <| toString <| iconHeight - iconWidth // 4
                , y2 <| toString <| iconHeight // 4
                , stroke "red"
                , strokeWidth "2"
                ]
                []
            ]


icon : ( Int, Int ) -> String -> Svg a
icon pos urlPath =
    let
        ( x_, y_ ) =
            posToXy pos
    in
        image
            [ x <| toString x_
            , y <| toString y_
            , width "64"
            , height "64"
            , xlinkHref urlPath
            ]
            []


weaponIcon : ( Int, Int ) -> ( Weapon, Int ) -> Svg a
weaponIcon (( x_, y_ ) as pos) ( weapon, count ) =
    svg []
        [ icon pos (weaponImg weapon)
        , text_
            [ x <| toString <| x_ * iconWidth + 52
            , y <| toString <| y_ * iconHeight + 60
            , fill "white"
            ]
            [ text <| toString count ]
        ]


legendIcon : ( Int, Int ) -> Maybe Legend -> Svg a
legendIcon pos legend =
    icon pos (legendImg legend)


legendIcons : List (Svg a)
legendIcons =
    List.concat <|
        List.indexedMap
            (\y ( w1, _ ) ->
                List.indexedMap
                    (\x ( w2, _ ) ->
                        getLegendWithWeapons w1 w2
                            |> Maybe.map .legend
                            |> legendIcon ( x + 1, y + 1 )
                    )
                    weapons
            )
            weapons


view : Model -> Svg a
view model =
    let
        ( width_, height_ ) =
            ( (1 + List.length weapons) * 66 - 2, (1 + List.length weapons) * 66 - 2 )
    in
        svg [ width (toString width_), height (toString height_) ] <|
            [ rect
                [ width (toString width_)
                , height (toString height_)
                , fill "blue"
                , stroke "black"
                , strokeWidth "2"
                , strokeOpacity "0.5"
                , fillOpacity "0.05"
                ]
                []
            ]
                ++ List.indexedMap (\i _ -> iconX ( i + 1, i + 1 )) weapons
                ++ List.indexedMap (\i w -> weaponIcon ( i + 1, 0 ) w) weapons
                ++ List.indexedMap (\i w -> weaponIcon ( 0, i + 1 ) w) weapons
                ++ legendIcons
