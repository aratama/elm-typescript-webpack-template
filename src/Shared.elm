module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    )

import Domain.User exposing (User)
import Port
import Request exposing (Request)


type alias Flags =
    { user : Maybe User }


type alias Model =
    { user : Maybe User }


type Msg
    = SignIn { email : String, password : String }
    | AuthStateChanged (Maybe User)
    | SignOut


init : Request -> Flags -> ( Model, Cmd Msg )
init _ { user } =
    ( { user = user }, Cmd.none )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        SignIn credential ->
            ( model
            , Port.signIn credential
            )

        AuthStateChanged auth ->
            ( { model | user = auth }, Cmd.none )

        SignOut ->
            ( { model | user = Nothing }
            , Cmd.none
            )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Port.authStateChanged AuthStateChanged
