module Position
  ( Position
  , Distance
  , position
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
toMeter : Distance -> Distance
toMeter (Distance d) = Distance (d * unit)

toKM : Distance -> Distance
toKM d =
  let (Distance d') = toMeter d
  in Distance (d' / 1000)

unit : Float
unit = 75000
