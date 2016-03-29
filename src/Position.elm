module Position
  ( Position
  , Distance (..)
  , position
  , renderDistance
  , calculateDistance
  ) where

import Json.Decode exposing (Decoder, (:=), float, object2)

-- | A record describing one position with latitude and longitude.
type alias Position =
  { latitude  : Float
  , longitude : Float
  }

-- | A distance is the distance between two positions, expressed in
-- decimal degrees.
type Distance = Distance Float

-- | Decode a position from JSON.
position : Decoder Position
position =
  object2 Position
    ("latitude"  := float)
    ("longitude" := float)

-- | Render a distance to a string.
renderDistance : Distance -> String
renderDistance d =
  let asMeter = toMeter d
  in if asMeter < 10000 
        then toString (round asMeter) ++ " m"
        else toString (round (toKM d)) ++ " km"

-- | Calculate the distance between two positions using
-- Pythagoras' formula.
calculateDistance : Position -> Position -> Distance
calculateDistance pos1 pos2 =
  let deltaLat     = pos1.latitude - pos2.latitude
      deltaLong    = pos1.longitude - pos2.longitude
      sumOfSquares = deltaLat ^ 2 + deltaLong ^ 2
  in Distance (sqrt sumOfSquares)

-- | Convert the distance to metric values. This conversion is very
-- simplified at the moment as it approximates the unit - value of
-- distance 1 - to 75000 meters. Kind of works for southern Sweden
-- I think.
toMeter : Distance -> Float
toMeter (Distance d) = d * unit

toKM : Distance -> Float
toKM d =
  let d' = toMeter d
  in d' / 1000

unit : Float
unit = 75000
