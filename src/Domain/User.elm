module Domain.User exposing (User, decoder, encode)

import Json.Decode as Json
import Json.Encode as Encode


type alias User =
    { email : String
    , displayName : String
    , emailVerified : Bool
    }


decoder : Json.Decoder User
decoder =
    Json.map3 User
        (Json.field "email" Json.string)
        (Json.field "displayName" Json.string)
        (Json.field "emailVerified" Json.bool)


encode : User -> Json.Value
encode user =
    Encode.object
        [ ( "email", Encode.string user.email )
        , ( "displayName", Encode.string user.displayName )
        , ( "emailVerified", Encode.bool user.emailVerified )
        ]
