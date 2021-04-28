module Example.Counter exposing (Flags, Model, Msg, program)

import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation exposing (Key, load, pushUrl)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Port
import Url exposing (Url)


type alias Flags =
    Int


type alias Model =
    { key : Key
    , count : Int
    }


type Msg
    = Up
    | Down
    | UrlRequest UrlRequest
    | UrlChange Url
    | ReceiveItem { key : String, value : Maybe String }


init : Flags -> Url -> Key -> ( Model, Cmd msg )
init count _ key =
    ( { key = key, count = count }, Port.requestItem "count" )


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

        UrlRequest request ->
            case request of
                Browser.Internal url ->
                    ( model, pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, load href )

        UrlChange _ ->
            ( model, Cmd.none )

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


program : Program Flags Model Msg
program =
    application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequest
        , onUrlChange = UrlChange
        }
