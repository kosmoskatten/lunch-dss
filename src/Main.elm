module Main where

import Effects exposing (Never)
import Html exposing (Html)
import StartApp exposing (..)
import Task exposing (..)

import App exposing (Action (..), initialModel, update, view)
import Position exposing (Position)

main : Signal Html
main = app.html

-- | Setting up app record.
app =
  StartApp.start
    { init   = initialModel
    , update = update
    , view   = view
    , inputs =
        [ Signal.map GpsPosition gpsPosition
        , Signal.map GpsError gpsError
        ]
    }

-- | Execute application tasks.
port tasks : Signal (Task.Task Never ())
port tasks = app.tasks

-- | Getting Gps positions from Javascript.
port gpsPosition : Signal Position

-- | Getting Gps errors from Javascript.
port gpsError : Signal String
