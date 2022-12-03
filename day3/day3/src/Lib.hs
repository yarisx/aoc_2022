module Lib
    ( someFunc
    ) where

import qualified Data.MultiSet as Set
import Data.Char

someFunc :: IO ()
someFunc = do
        contents <- readFile "../input.txt"
        print . map getVal1 . lines $ contents
        print . sum .  map getVal2 . groupLines . lines $ contents

charVal :: Char -> Int
charVal c = charVal' (isLower c) (isUpper c) c

charVal' True _ c = (ord c) - 96
charVal' _ True c = (ord c) - 38
charVal' _ _ _ = 0

-- first part
getVal1 :: [Char] -> Int
getVal1 str = getVal1' str Set.empty ((length str) `div` 2)

getVal1' [] _ _ = 0
getVal1' (c:cs) charset 0 =
    if Set.member c charset then charVal c
    else getVal1' cs charset 0
getVal1' (c:cs) charset ln = getVal1' cs (Set.insert c charset) (ln - 1)

--second part
groupLines :: [String] -> [[String]]
groupLines lns = groupLines' lns [] [] 0

groupLines' :: [String] -> [String] -> [[String]] -> Int -> [[String]]
groupLines' [] acc res _ = (acc:res)
groupLines' (ln:lns) acc res 3 = groupLines' (ln:lns) [] (acc:res) 0
groupLines' (ln:lns) acc res sz = groupLines' lns (ln:acc) res (sz + 1)

getVal2 :: [String] -> Int
getVal2 (l1:l2:l3:[]) = getVal2' l3 (Set.fromList l1) (Set.fromList l2)

getVal2' [] _ _ = 0
getVal2' (c:cs) charset1 charset2 =
    if (Set.occur c charset1 > 0) && (Set.occur c charset2 > 0) then charVal c
    else getVal2' cs charset1 charset2
