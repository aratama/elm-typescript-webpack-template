module Pages.Account exposing (Model, Msg, page)

import Domain.User exposing (User)
import Effect exposing (Effect)
import Gen.Params.Account exposing (Params)
import Gen.Route as Route
import Html exposing (button, div, table, td, text, tr)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Page
import Port
import Request
import Shared exposing (Msg(..))
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.advanced <|
        \user ->
            { init = init shared req user
            , update = update
            , view = view
            , subscriptions = subscriptions
            }



-- INIT


type alias Model =
    { shared : Shared.Model
    , req : Request.With Params
    , user : User
    }


init : Shared.Model -> Request.With Params -> User -> ( Model, Effect Msg )
init shared req user =
    ( { shared = shared, req = req, user = user }, Effect.none )



-- UPDATE


type Msg
    = SignOut


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SignOut ->
            ( model, Effect.fromCmd <| Port.signOut () )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = ""
    , body =
        [ div [ class "page--account" ]
            [ table []
                [ tr []
                    [ td [] [ text "Email" ]
                    , td [] [ text model.user.email ]
                    ]
                , tr []
                    [ td [] [ text "Email Verified" ]
                    , td []
                        [ text <|
                            if model.user.emailVerified then
                                "True"

                            else
                                "False"
                        ]
                    ]
                , tr []
                    [ td [] [ text "Display Name" ]
                    , td [] [ text model.user.displayName ]
                    ]
                ]
            , button [ onClick SignOut ] [ text "Sign Out" ]
            ]
        ]
    }
