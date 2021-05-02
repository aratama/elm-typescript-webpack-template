module Pages.Home_ exposing (Model, Msg, page)

import Html
import View exposing (View)
import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation exposing (Key, load, pushUrl)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Port
import Url exposing (Url)
import Page
import Request exposing (Request)
import Shared

type alias Flags =
    Int


type alias Model =
    { count : Int
    }


type Msg
    = Up
    | Down
    | ReceiveItem { key : String, value : Maybe String }


init : ( Model, Cmd msg )
init =
    ( { count = 0 }, Port.requestItem "count" )


upDownButton : msg -> String -> Html msg
upDownButton msg label =
    button [ onClick msg, class "upDownButton" ] [ text label ]


view : Model -> Document Msg
view model =
    { title = ""
    , body =
        [ div [ class "outer" ]
            [ div [class "inner"]
                [ upDownButton Up "Up"
                , div [class "count"  ]                   [ text <| String.fromInt model.count ]
                , upDownButton Down "Down"
                ]
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
page shared _ =
    Page.element
        { init = init
        , update = update 
        , view = view 
        , subscriptions = subscriptions
        }