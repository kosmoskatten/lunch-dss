module App
  ( Action (..)
  , initialModel
  , update
  , view
  ) where

import Html exposing (Html, div, text)
import Http exposing (get)
import Effects exposing (Effects, none)
import Json.Decode exposing (Decoder, list)
import Task exposing (..)

import Restaurant exposing (Restaurant, restaurant)
import Position exposing (Position)

type alias Model =
  { currentPosition : Maybe Position
  , gpsError        : Maybe String
  , restaurants     : List Restaurant
  }

type Action
  = GpsPosition Position
  | GpsError String
  | GotRestaurants (Maybe (List Restaurant))

initialModel : (Model, Effects Action)
initialModel =
  ( { currentPosition = Nothing
    , gpsError        = Nothing
    , restaurants     = []
    }
  , getRestaurants
  )

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    GpsPosition pos ->
      ({ model | currentPosition = Just pos }, Effects.none)

    GpsError    err ->
      ({ model | gpsError = Just err }, Effects.none)

    GotRestaurants maybeRs ->
      (
        { model | restaurants = Maybe.withDefault [] maybeRs }
      , Effects.none
      )

view : Signal.Address Action -> Model -> Html
view address model = div [] [ text (toString (List.length model.restaurants)) ]

getRestaurants : Effects Action
getRestaurants =
  Http.get decodeRestaurants restaurantsUrl
    |> Task.toMaybe
    |> Task.map GotRestaurants
    |> Effects.task

decodeRestaurants : Decoder (List Restaurant)
decodeRestaurants = list restaurant

restaurantsUrl : String
restaurantsUrl = "/resources/restaurants.json"
