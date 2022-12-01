module Lib
    ( someFunc
    ) where

counter :: [Int] -> [Int]
counter lst = counter' lst 0 []

-- src_lst -> acc -> acc_lst -> res
counter' :: [Int] -> Int -> [Int] -> [Int]
counter' [] _ rlst = rlst
counter' ((-1):t) acc rlst = counter' t 0 (acc:rlst)
counter' (h:t) acc rlst = counter' t (acc + h) rlst


someFunc :: IO ()

someFunc = do
        contents <- readFile "input1.txt"
        print . maximum . counter . map readInt . words $ contents

readInt :: String -> Int
readInt = read

