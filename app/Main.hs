{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module Main where
    
import Lib
import Network.API.TheMovieDB

import Control.Exception (finally)
import Control.Monad (when)
import Data.Char (toLower)
import Data.Monoid ((<>))
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

import Discord

main :: IO ()
main = do 
    auth <- parseAuth
    let v3key = v3Auth auth
    -- result <- searchMovie v3key "Robots"

    tok <- T.strip <$> TIO.readFile "./app/auth-token.secret"

    dis <- loginRestGateway (Auth tok)
  
    finally (listeningLoop dis v3key)
            (stopDiscord dis)
  

listeningLoop :: (RestChan, Gateway, z) -> T.Text -> IO ()
listeningLoop dis key = do
    e <- nextEvent dis
    case e of
        Left er -> putStrLn ("Event error: " <> show er)
        Right (MessageCreate m) -> do
            when (isCmd (messageText m)) $ do
                let searchStr = T.drop 4 (messageText m)
                result <- searchMovie key (messageText m)
                resp <- restCall dis (CreateMessage (messageChannel m) (T.pack $ show result))
                putStrLn (show resp)
                putStrLn ""
        _ -> pure ()
    listeningLoop dis key

isCmd :: T.Text -> Bool
isCmd = T.isPrefixOf "b!f "
    

                