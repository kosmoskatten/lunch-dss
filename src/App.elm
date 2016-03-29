module App
  ( Action (..)
  , initialModel
  , update
  , view
  ) where

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
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
  , display         : Display
  }

type Action
  = GpsPosition Position
  | GpsError String
  | GotRestaurants (Maybe (List Restaurant))
  | SwitchDisplay Display

-- | Enumeration of the main displays.
type Display
  = Closest
  | Best
  | Random

-- | Initial model, with default values and an action to fetch the list
-- of restaurants from the server.
initialModel : (Model, Effects Action)
initialModel =
  ( { currentPosition = Nothing
    , gpsError        = Nothing
    , restaurants     = []
    , display         = Closest
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

    SwitchDisplay display ->
      ({ model | display = display }, Effects.none)

view : Signal.Address Action -> Model -> Html
view address model =
  div [ w3Container ]
    [ viewPageHeader
    , viewButtonGroup address
    , case model.display of
        Closest -> viewClosestDisplay address model
        Best    -> viewBestDisplay address model
        Random  -> viewRandomDisplay address model
    ]

-- | Display the page header.
viewPageHeader : Html
viewPageHeader =
  header
    [ w3Container
    , w3Blue
    ]
    [ h2 [ w3Center ] [ text "Lunch? Choose from:" ] ]

-- | Display the group of navigation buttons.
viewButtonGroup : Signal.Address Action -> Html
viewButtonGroup address =
  div [ w3BtnGroup ]
    [ button
        [ w3Btn, w3LightBlue, style [("width", "33.3%")]
        , onClick address (SwitchDisplay Closest)
        ]
        [ text "Closest" ]
    , button
        [ w3Btn, w3LightBlue, style [("width", "33.3%")]
        , onClick address (SwitchDisplay Best)
        ]
        [ text "Best" ]
    , button
        [ w3Btn, w3LightBlue, style [("width", "33.3%")]
        , onClick address (SwitchDisplay Random)
        ]
        [ text "Random" ]
    ]

viewClosestDisplay : Signal.Address Action -> Model -> Html
viewClosestDisplay address model =
  text "Closest"

viewBestDisplay : Signal.Address Action -> Model -> Html
viewBestDisplay address model =
  text "Best"

viewRandomDisplay : Signal.Address Action -> Model -> Html
viewRandomDisplay address model =
  text "Random"

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

-- W3 helpers.
w3Container : Html.Attribute
w3Container = class "w3-container"

w3BtnGroup : Html.Attribute
w3BtnGroup = class "w3-btn-group"

w3Btn : Html.Attribute
w3Btn = class "w3-btn"

w3Blue : Html.Attribute
w3Blue = class "w3-blue"

w3LightBlue : Html.Attribute
w3LightBlue = class "w3-light-blue"

w3Center : Html.Attribute
w3Center = class "w3-center"
