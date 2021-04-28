module Main exposing (main)

import Example.Counter as Counter


main : Program Counter.Flags Counter.Model Counter.Msg
main =
    Counter.program
