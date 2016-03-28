module Position
  ( Position
  , position
  ) where

import Json.Decode exposing (Decoder, (:=), float, object2)

-- | A record describing one position with latitude and longitude.
type alias Position =
  { latitude  : Float
  , longitude : Float
  }

-- | Decode a position from JSON.
position : Decoder Position
position =
  object2 Position
    ("latitude"  := float)
    ("longitude" := float)
