module App
  ( Action (..)
  , initialModel
  , update
  , view
  ) where

import Html exposing (Html, div, text)
import Effects exposing (Effects, none)
import Position exposing (Position)

type alias Model =
  { currentPosition : Maybe Position
  , gpsError        : Maybe String
  }

type Action
  = GpsPosition Position
  | GpsError String

initialModel : (Model, Effects Action)
initialModel =
  ( { currentPosition = Nothing
    , gpsError        = Nothing
    }
  , Effects.none
  )

update : Action -> Model -> (Model, Effects Action)
update action model = (model, Effects.none)

view : Signal.Address Action -> Model -> Html
view address model = div [] [ text "Hej" ]
