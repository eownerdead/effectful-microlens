module Effectful.Reader.Static.Microlens where

import Data.Monoid
import Data.Functor.Const

import Effectful
import Effectful.Reader.Static

import Lens.Micro
import Lens.Micro.Internal


{- |
'view' is a synonym for ('^.'), generalised for 'MonadReader' (we are able to use it instead of ('^.') since functions are instances of the 'MonadReader' class):

>>> view _1 (1, 2)
1

When you're using 'Reader.Reader' for config and your config type has lenses generated for it, most of the time you'll be using 'view' instead of 'Reader.asks':

@
doSomething :: ('MonadReader' Config m) => m Int
doSomething = do
  thingy        <- 'view' setting1  -- same as “'Reader.asks' ('^.' setting1)”
  anotherThingy <- 'view' setting2
  ...
@
-}
view :: Reader s :> es => Getting a s a -> Eff es a
view l = asks (getConst #. l Const)
{-# INLINE view #-}


{- |
'preview' is a synonym for ('^?'), generalised for 'MonadReader' (just like 'view', which is a synonym for ('^.')).

>>> preview each [1..5]
Just 1
-}
preview :: Reader s :> es => Getting (First a) s a -> Eff es (Maybe a)
preview l = asks (getFirst #. foldMapOf l (First #. Just))
{-# INLINE preview #-}
