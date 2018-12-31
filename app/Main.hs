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

import Data.Time.Clock

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
                result <- searchMovie key searchStr
                let messageContent = T.pack $ case result of 
                                        Left _ -> "Error. @yeehaw"
                                        Right x -> getMovieURL x

                resp <- restCall dis (CreateMessage (messageChannel m) messageContent)
                putStrLn (show resp)
                putStrLn ""
            when (isbangF (messageText m)) $ do
                let msg = "!film" ++ (T.drop 2 (messageText m))
                resp <- restCall dis (CreateMessage (messageChannel m) msg)
                putStrLn (show resp)
                putStrLn ""

        _ -> pure ()
    listeningLoop dis key

isCmd :: T.Text -> Bool
isCmd = T.isPrefixOf "b!f "

isbangF :: T.Text -> Bool
isbangF = T.isPrefixOf "!f "

getMovieURL m = "https://www.themoviedb.org/movie/" ++ (show $ movieID m)

test = do
    currT <- getCurrentTime
    let x = Embed {
        embedTitle = "Test",
        embedType = "rich",
        embedDesc = "Test Embed",
        embedUrl = "https://duckduckgo.com",
        embedColor = 123456,
        embedFields = [],
        embedTime = currT
        }
    return x


