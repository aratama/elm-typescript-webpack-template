module Pages.Home_ exposing (Model, Msg, page)

import Browser exposing (Document)
import Gen.Route
import Html exposing (Html, a, button, div, footer, header, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Page
import Port
import Request exposing (Request)
import Shared


type alias Model =
    { shared : Shared.Model
    , req : Request
    , count : Int
    }


type Msg
    = Up
    | Down
    | ReceiveItem { key : String, value : Maybe String }


init : Shared.Model -> Request -> ( Model, Cmd msg )
init shared req =
    ( { shared = shared, req = req, count = 0 }, Port.requestItem "count" )


upDownButton : msg -> String -> Html msg
upDownButton msg label =
    button [ onClick msg, class "upDownButton" ] [ text label ]


view : Model -> Document Msg
view model =
    { title = ""
    , body =
        [ div [ class "page--home" ]
            [ header []
                [ case model.shared.user of
                    Nothing ->
                        a [ href <| Gen.Route.toHref Gen.Route.SignIn ] [ text "Sign in" ]

                    Just user ->
                        a [ href <| Gen.Route.toHref Gen.Route.Account ] [ text user.email ]
                ]
            , div [ class "outer" ]
                [ div [ class "inner" ] <|
                    case model.shared.user of
                        Nothing ->
                            [ div [ class "count" ] [ text <| String.fromInt model.count ]
                            ]

                        Just _ ->
                            [ upDownButton Up "Up"
                            , div [ class "count" ] [ text <| String.fromInt model.count ]
                            , upDownButton Down "Down"
                            ]
                ]
            , footer [] [ text "\u{00A0}" ]
            ]
        ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        increment delta =
            ( { model | count = model.count + delta }, Port.setItem { key = "count", value = String.fromInt <| model.count + delta } )
    in
    case msg of
        Up ->
            increment 1

        Down ->
            increment <| negate 1

        ReceiveItem { key, value } ->
            if key == "count" then
                ( { model | count = Maybe.withDefault model.count <| Maybe.andThen String.toInt value }, Cmd.none )

            else
                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Port.receiveItem ReceiveItem
        ]


page : Shared.Model -> Request -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared req
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
