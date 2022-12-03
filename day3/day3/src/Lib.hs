module Lib
    ( someFunc
    ) where

import qualified Data.MultiSet as Set
import Data.Char

someFunc :: IO ()
someFunc = do
        contents <- readFile "../input.txt"
--        contents <- readFile "../testset.txt"
        print . sum . map getVal1 . lines $ contents
        --print . map getVal1 . lines $ contents

charVal :: Char -> Int
charVal c = charVal' (isLower c) (isUpper c) c

charVal' True _ c = (ord c) - 96
charVal' _ True c = (ord c) - 38
charVal' _ _ _ = 0

getVal1 :: [Char] -> Int
getVal1 str = getVal1' str Set.empty ((length str) `div` 2)

--getVal1' :: [Char] -> Set.Set -> Char
getVal1' [] _ _ = 0
getVal1' (c:cs) charset 0 =
    if Set.member c charset then charVal c
    else getVal1' cs charset 0
getVal1' (c:cs) charset ln = getVal1' cs (Set.insert c charset) (ln - 1)
