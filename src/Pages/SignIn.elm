module Pages.SignIn exposing (Model, Msg, page)

import Domain.User exposing (User)
import Effect exposing (Effect)
import Gen.Params.SignIn exposing (Params)
import Gen.Route
import Html exposing (div)
import Html.Attributes as Attr exposing (class)
import Html.Events as Events
import Page
import Port
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { email : String
    , password : String
    }


init : ( Model, Effect Msg )
init =
    ( { email = "", password = "" }
    , Effect.none
    )



-- UPDATE


type Msg
    = InputEmail String
    | SubmittedSignInForm
    | AuthStateChanged (Maybe User)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        InputEmail str ->
            ( { model | email = str }
            , Effect.fromCmd Cmd.none
            )

        SubmittedSignInForm ->
            ( model
            , Effect.fromShared (Shared.SignIn model)
            )

        AuthStateChanged auth ->
            case auth of
                Nothing ->
                    ( model, Effect.none )

                Just user ->
                    ( model
                    , Effect.none
                      -- Effect.fromCmd <| Request.pushRoute Gen.Route.Home_ ()
                    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Port.authStateChanged AuthStateChanged



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign in"
    , body =
        [ div [ class "page--sign-in" ]
            [ Html.form [ class "inner", Events.onSubmit SubmittedSignInForm ]
                [ Html.label []
                    [ Html.span [] [ Html.text "email" ]
                    , Html.input
                        [ Attr.type_ "text"
                        , Attr.value model.email
                        , Events.onInput InputEmail
                        ]
                        []
                    ]
                , Html.button [ Attr.disabled (String.isEmpty model.email) ]
                    [ Html.text "Sign in" ]
                ]
            ]
        ]
    }
