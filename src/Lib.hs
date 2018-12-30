{-# LANGUAGE OverloadedStrings #-}

module Lib where

import qualified Data.Text as T  
import Network.API.TheMovieDB

testFunc :: IO ()
testFunc = do
  -- The API key assigned to you (as a 'Text' value).
  let key = "your API key"
  -- The 'fetch' function will get a 'Movie' record based on its ID.
  result <- runTheMovieDB key (fetchMovie 9340)
  -- Do something with the result (or error).
  putStrLn (show result)
