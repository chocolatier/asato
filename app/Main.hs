{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module Main where
    
import Lib
import Network.API.TheMovieDB


main :: IO ()
main = do 
    auth <- parseAuth
    let v3key = v3Auth auth
    result <- searchMovie v3key "Robots"
    putStrLn $ show result