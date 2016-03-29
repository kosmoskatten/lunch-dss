module App
  ( Action (..)
  , initialModel
  , update
  , view
  ) where

import Html exposing (..)
import Html.Attributes exposing (class, style, href, target)
import Html.Events exposing (onClick)
import Http exposing (get)
import Effects exposing (Effects, none)
import Json.Decode exposing (Decoder, list)
import Task exposing (..)

import Restaurant exposing (Restaurant, restaurant)
import Position exposing ( Position
                         , Distance (..)
                         , calculateDistance
                         , renderDistance
                         )

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

type alias DisplayItem =
  { name     : String
  , url      : String
  , rating   : Int
  , distance : Maybe Distance
  }

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
  div [ class "w3-container" ]
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
    [ class "w3-container w3-black" ]
    [ h2 [ class "w3-center" ]
        [ text "Välj en matstrategi:" ]
    ]

-- | Display the group of navigation buttons.
viewButtonGroup : Signal.Address Action -> Html
viewButtonGroup address =
  div [ class "w3-btn-group w3-border" ]
    [ button
        [ class "w3-btn w3-light-grey w3-border", style [("width", "33.3%")]
        , onClick address (SwitchDisplay Closest)
        ]
        [ text "Närmaste" ]
    , button
        [ class "w3-btn w3-light-grey w3-border", style [("width", "33.3%")]
        , onClick address (SwitchDisplay Best)
        ]
        [ text "Bästa" ]
    , button
        [ class "w3-btn w3-light-grey w3-border", style [("width", "33.3%")]
        , onClick address (SwitchDisplay Random)
        ]
        [ text "Slumpen" ]
    ]

viewClosestDisplay : Signal.Address Action -> Model -> Html
viewClosestDisplay address model =
  let items = List.map (makeDisplayItem model) model.restaurants
  in viewRestaurantDisplay address items

viewRestaurantDisplay : Signal.Address Action -> List DisplayItem -> Html
viewRestaurantDisplay address items =
  -- Ok, this construction with consing is due to generated list of
  -- table rows. Need to be same list of nodes as the table head.
  table
    [ class "w3-table w3-border w3-bordered w3-striped" ]
    ( tr [ class "w3-blue-grey" ]
        [ td [] [ text "Namn" ]
        , td [] [ text "Avstånd" ]
        , td [] [ text "Poäng" ]
        , td [] [ text "Bedöm!" ]
        ] :: List.map (viewDisplayItem address) items )

viewBestDisplay : Signal.Address Action -> Model -> Html
viewBestDisplay address model =
  text "Best"

viewRandomDisplay : Signal.Address Action -> Model -> Html
viewRandomDisplay address model =
  text "Random"

viewDisplayItem : Signal.Address Action -> DisplayItem -> Html
viewDisplayItem address item =
  tr [ class "w3-dark-grey" ]
    [ td []
        [ a [ href item.url
            , target "_blank"
            ] [ text item.name ]
        ]
    , td []
        [ text (Maybe.withDefault "-"
               (Maybe.map renderDistance item.distance))
        ]
    , td [] [ text (toString item.rating) ]
    , td []
        [ i [ class "fa fa-thumbs-o-up"
            , style [("padding-right", "15px")]] []
        , i [ class "fa fa-thumbs-o-down" ] []
        ]
    ]

makeDisplayItem : Model -> Restaurant -> DisplayItem
makeDisplayItem model rest =
  { name     = rest.name
  , url      = rest.url
  , rating   = rest.rating
  , distance = case model.currentPosition of
                 Just p  -> Just (calculateDistance p rest.position)
                 Nothing -> Nothing
  }

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
