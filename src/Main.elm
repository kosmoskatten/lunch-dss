module Main where

import Html exposing (text)

import Position exposing (Position)

main = Signal.map (text << toString) position

-- | Getting positions from Javascript.
port position : Signal Position
