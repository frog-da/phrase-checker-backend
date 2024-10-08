{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Concurrent
import Control.Exception
import Data.ByteString.UTF8 as BSU
import Lib
import Network.HTTP.Client (defaultManagerSettings, newManager)
import Servant.Client
import System.Environment (getEnv)

main :: IO ()
main = do
  host <- getEnv "PGHOST"
  port <- getEnv "PGPORT"
  dbname <- getEnv "PGDATABASE"
  user <- getEnv "PGUSER"
  password <- getEnv "PGPASSWORD"

  let connStr = BSU.fromString ("host=" ++ host ++ " port=" ++ port ++ " dbname=" ++ dbname ++ " user=" ++ user ++ " password=" ++ password)
  pool <- initConnectionPool connStr
  initDB connStr

  runApp pool

-- mgr <- newManager defaultManagerSettings
-- bracket (forkIO $ runApp pool) killThread $ \_ -> do
--   ms <- flip runClientM (mkClientEnv mgr (BaseUrl Http "localhost" 8080 "")) $ do
--     postPhr "hello"
--     postPhr "world"
--     getPhrs
--   print ms