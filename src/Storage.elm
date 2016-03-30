module Storage
  ( StorageCtrl
  , StorageData
  , inc
  , dec
  , fetchFor
  , storageMailbox
  ) where

import Task exposing (..)

type alias StorageCtrl =
  { op     : String
  , values : List String
  }

type alias StorageData =
  { name   : String
  , rating : Int
  }

inc : String -> Task x ()
inc name = Signal.send storageMailbox.address
             { op     = "inc"
             , values = [name]
             }

dec : String -> Task x ()
dec name = Signal.send storageMailbox.address
             { op     = "dec"
             , values = [name]
             }

fetchFor : List String -> Task x ()
fetchFor names = Signal.send storageMailbox.address
                   { op     = "fetchAll"
                   , values = names
                   }

-- | Mailbox for outgoing control messages to the native implemented
-- local storage.
storageMailbox : Signal.Mailbox StorageCtrl
storageMailbox = Signal.mailbox { op = "NoOp", values = [] }
