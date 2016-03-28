module Restaurant
  ( Restaurant
  , restaurant
  ) where

import Json.Decode exposing (Decoder, (:=), object4, string, int)

import Position exposing (Position, position)

-- | Description of a restaurant.
type alias Restaurant =
  { name     : String
  , url      : String
  , rating   : Int
  , position : Position
  }

-- | Decode a Restaurant from JSON.
restaurant : Decoder Restaurant
restaurant =
  object4 Restaurant
    ("name"     := string)
    ("url"      := string)
    ("rating"   := int)
    ("position" := position)
