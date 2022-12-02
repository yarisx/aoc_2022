module Lib
    ( someFunc
    ) where

someFunc :: IO ()

someFunc = do
        contents <- readFile "../input"
        print . sum . map readStr2 . lines $ contents

readStr :: String -> Int
readStr (c:_:c2:[]) = readStr' (conv c) (conv c2)
readStr _ = (-1)

readStr2 :: String -> Int
readStr2 (c:_:c2:[]) = readStr2' (conv c) (cnt2 c2)

cnt2 :: Char -> Int
cnt2 'X' = 0
cnt2 'Y' = 3
cnt2 'Z' = 6

readStr2' :: Char -> Int -> Int
readStr2' c 3 = 3 + (cnt c)
readStr2' 'R' 6 = 6 + 2
readStr2' 'R' 0 = 3
readStr2' 'P' 6 = 6 + 3
readStr2' 'P' 0 = 1
readStr2' 'S' 6 = 6 + 1
readStr2' 'S' 0 = 2

conv :: Char -> Char
conv 'A' = 'R'
conv 'B' = 'P'
conv 'X' = 'R'
conv 'Y' = 'P'
conv _ = 'S'

readStr' :: Char -> Char -> Int
readStr' c1 c2 = (cmpr c1 c2) + cnt c2

cmpr :: Char -> Char -> Int
cmpr 'R' 'P' = 6
cmpr 'R' 'S' = 0
cmpr 'P' 'R' = 0
cmpr 'P' 'S' = 6
cmpr 'S' 'R' = 6
cmpr 'S' 'P' = 0
cmpr _ _ = 3

cnt :: Char -> Int
cnt 'R' = 1
cnt 'P' = 2
cnt _ = 3
