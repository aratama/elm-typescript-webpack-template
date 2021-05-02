port module Port exposing (authStateChanged, receiveItem, requestItem, setItem, signIn)

import Domain.User exposing (User)


port requestItem : String -> Cmd msg


port receiveItem : ({ key : String, value : Maybe String } -> msg) -> Sub msg


port setItem : { key : String, value : String } -> Cmd msg


port signIn : { email : String, password : String } -> Cmd msg


port authStateChanged : (Maybe User -> msg) -> Sub msg
