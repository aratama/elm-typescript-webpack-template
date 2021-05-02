module Pages.SignIn exposing (Model, Msg, page)

import Domain.User exposing (User)
import Effect exposing (Effect)
import Gen.Params.SignIn exposing (Params)
import Gen.Route
import Html exposing (a, button, div, footer, form, header, input, label, span, text)
import Html.Attributes as Attr exposing (class, href)
import Html.Events exposing (onInput, onSubmit)
import Page
import Port
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init shared req
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { shared : Shared.Model
    , req : Request.With Params
    , email : String
    , password : String
    }


init : Shared.Model -> Request.With Params -> ( Model, Effect Msg )
init shared req =
    ( { shared = shared, req = req, email = "", password = "" }
    , case shared.user of
        Nothing ->
            Effect.none

        Just _ ->
            Effect.fromCmd <| Request.pushRoute Gen.Route.Home_ req
    )



-- UPDATE


type Msg
    = InputEmail String
    | InputPassword String
    | SubmittedSignInForm
    | AuthStateChanged (Maybe User)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        InputEmail str ->
            ( { model | email = str }
            , Effect.fromCmd Cmd.none
            )

        InputPassword str ->
            ( { model | password = str }
            , Effect.fromCmd Cmd.none
            )

        SubmittedSignInForm ->
            ( model
            , Effect.fromShared (Shared.SignIn { email = model.email, password = model.password })
            )

        AuthStateChanged auth ->
            case auth of
                Nothing ->
                    ( model, Effect.none )

                Just _ ->
                    ( model
                    , Effect.fromCmd <| Request.pushRoute Gen.Route.Home_ model.req
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
            [ header []
                [ case model.shared.user of
                    Nothing ->
                        text "\u{00A0}"

                    Just user ->
                        text user.email
                ]
            , form [ class "inner", onSubmit SubmittedSignInForm ]
                [ label []
                    [ span [] [ text "email" ]
                    , input
                        [ Attr.type_ "text"
                        , Attr.value model.email
                        , onInput InputEmail
                        ]
                        []
                    ]
                , label []
                    [ span [] [ text "password" ]
                    , input
                        [ Attr.type_ "text"
                        , Attr.value model.password
                        , onInput InputPassword
                        ]
                        []
                    ]
                , button [ Attr.disabled (String.isEmpty model.email) ]
                    [ text "Sign in" ]
                , div [] [ a [ href <| Gen.Route.toHref Gen.Route.Home_ ] [ text "Home" ] ]
                ]
            , footer [] []
            ]
        ]
    }
