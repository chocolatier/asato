{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module Main where
    
import Lib

main :: IO ()
main = do 
    settings <- parseAuth
    putStrLn $ show settings