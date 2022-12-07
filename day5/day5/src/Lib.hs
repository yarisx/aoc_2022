module Lib
    ( someFunc
    ) where

import Data.List.Split
import qualified Data.Map as Map

someFunc :: IO ()
someFunc = do
    contents <- readFile "init_stacks.txt"
    moves <- readFile "../moves.d.txt"
    print . tops . doMoves (lines  contents) $ (lines moves)
    print . tops . doMoves2 (lines  contents) $ (lines moves)

mkState :: [String] -> Map.Map Int String
mkState stacks = Map.fromList . Prelude.map mkStack $ stacks

mkStack :: String -> (Int, String)
mkStack ln = (read n :: Int, Prelude.map head ns)
    where
        (n:ns) = splitOn " " ln

doMoves :: [String] -> [String] -> Map.Map Int String
doMoves stacks moves = doMoves' (mkState stacks) $ moves

doMoves' :: Map.Map Int String -> [String] -> Map.Map Int String
doMoves' stackmap [] = stackmap
doMoves' stackmap (m:moves) = doMoves' (doSingleMove stackmap (splitOn " " m)) moves

doSingleMove :: Map.Map Int String -> [String] -> Map.Map Int String
doSingleMove stackmap (n:fr:to:_) = doSingleMove' stackmap (read n :: Int) (read fr :: Int) (read to :: Int) 0

doSingleMove' :: Map.Map Int String -> Int -> Int -> Int -> Int -> Map.Map Int String
doSingleMove' stackMap 0 fr to _ = stackMap
doSingleMove' stackMap n fr to i =
    doSingleMove' newStackMap' (n - 1) fr to (i + 1)
    where
        (oldFrOne : newFr) = mylookup fr $ stackMap
        newTo = (oldFrOne : (mylookup to $ stackMap))
        newStackMap = Map.insert to newTo stackMap
        newStackMap' = Map.insert fr newFr newStackMap

doMoves2 :: [String] -> [String] -> Map.Map Int String
doMoves2 stacks moves = doMoves2' (mkState stacks) $ moves

doMoves2' :: Map.Map Int String -> [String] -> Map.Map Int String
doMoves2' stackmap [] = stackmap
doMoves2' stackmap (m:moves) = doMoves2' (doSingleMove2 stackmap (splitOn " " m)) moves

doSingleMove2 stackmap (n:fr:to:_) = doSingleMove2' stackmap (read n :: Int) (read fr :: Int) (read to :: Int)

doSingleMove2' stackMap n fr to =
    newStackMap'
    where
        oldFr = mylookup fr $ stackMap
        oldFrDeck = take n oldFr
        newFr = drop n oldFr
        newTo = oldFrDeck ++ (mylookup to $ stackMap)
        newStackMap = Map.insert to newTo stackMap
        newStackMap' = Map.insert fr newFr newStackMap


tops :: Map.Map Int String -> String
tops = Map.foldr (\x a -> ((head x):a)) []

mylookup :: Int -> Map.Map Int String -> String
mylookup i map = mylookup' (Map.lookup i map)
mylookup' (Just s) = s
mylookup' Nothing = ""
