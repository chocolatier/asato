{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module Lib where

import Data.Yaml.Config
import qualified Data.Aeson as JSON

import qualified Data.Text as T  
import Network.API.TheMovieDB
import GHC.Generics
import Data.Maybe

data TMDBAuth = TMDBAuth {
      v4Auth :: T.Text
    , v3Auth :: T.Text
} deriving (Generic, Show)

data Error' = APIError Error | NoResultError deriving Show

instance JSON.FromJSON TMDBAuth

parseAuth :: IO TMDBAuth
parseAuth = do 
  settings <- loadYamlSettings ["app/conf.yaml"] [] ignoreEnv :: IO JSON.Value
  return $ fromResult $ JSON.fromJSON settings

fromResult :: JSON.Result TMDBAuth -> TMDBAuth 
fromResult (JSON.Success x) = x
fromResult x = error (show x)

searchMovie :: T.Text -> T.Text -> IO (Either Error' Movie)
searchMovie key str = do
  result <- runTheMovieDB key (searchMovies str) 
  case result of
    Left er -> return $ Left $ APIError er
    Right ms -> do
        return $
          if (length ms) > 0 then 
            Right $ head ms
          else 
            Left $ NoResultError 
        
-- formatMovie :: Movie -> Embed 
-- formatMovie m = 
--   let
--     url = "https://www.themoviedb.org/movie/" ++ show $ movieID m
--     title = movieTitle m
--     imageURL = "http://image.tmdb.org/t/p/w92/" ++ moviePosterPath m 
