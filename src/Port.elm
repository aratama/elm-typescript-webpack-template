port module Port exposing (receiveItem, requestItem, setItem)


port requestItem : String -> Cmd msg


port receiveItem : ({ key : String, value : Maybe String } -> msg) -> Sub msg


port setItem : { key : String, value : String } -> Cmd msg
