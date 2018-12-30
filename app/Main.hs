{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module Main where
    
import Lib
import Network.API.TheMovieDB


main :: IO ()
main = do 
    auth <- parseAuth
    let v3key = v3Auth auth
    result <- runTheMovieDB v3Key (searchMovies "Robots")
    putStrLn $ show result