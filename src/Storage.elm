module Storage
  ( StorageCtrl
  , inc
  , dec
  , fetchFor
  , storageMailbox
  ) where

import Task exposing (..)
import Restaurant exposing (Restaurant)

type alias StorageCtrl =
  { op          : String
  , restaurant  : Maybe String
  , restaurants : Maybe (List Restaurant)
  }

inc : String -> Task x ()
inc name =
  Signal.send storageMailbox.address
    { op          = "inc"
    , restaurant  = Just name
    , restaurants = Nothing
    }

dec : String -> Task x ()
dec name =
  Signal.send storageMailbox.address
    { op          = "dec"
    , restaurant  = Just name
    , restaurants = Nothing
    }

fetchFor : List Restaurant -> Task x ()
fetchFor restaurants = 
  Signal.send storageMailbox.address
    { op          = "fetchAll"
    , restaurant  = Nothing
    , restaurants = Just restaurants
    }

-- | Mailbox for outgoing control messages to the native implemented
-- local storage.
storageMailbox : Signal.Mailbox StorageCtrl
storageMailbox =
  Signal.mailbox
    { op          = "NoOp"
    , restaurant  = Nothing
    , restaurants = Nothing
    }
