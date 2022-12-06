module Lib
    ( someFunc
    ) where

import Data.List.Split

someFunc :: IO ()
someFunc = do
        contents <- readFile "../input.s.txt"
--        contents <- readFile "test.txt"
        print . sum . map (inclusive . ranges . mySplitOn "-") . map (splitOn ",") . lines $ contents
        print . sum . map (overlap . ranges . mySplitOn "-") . map (splitOn ",") . lines $ contents


mySplitOn c (p1:p2:[]) = ((splitOn c p1), (splitOn c p2))

ranges (r1,r2) = (ranges' r1, ranges' r2)

ranges' (l:r:[]) = ((read l :: Int), (read r :: Int))

-- part1
inclusive :: ((Int, Int), (Int, Int)) -> Int
inclusive (l@(l1,l2), r@(r1,r2))
    | l1 < r1 = if (l2 >= r2) then 1 else 0
    | l1 == r1 = 1
    | otherwise = if (l2 <= r2) then 1 else 0

--part2
overlap (l@(l1, l2), r@(r1, r2))
    | l1 < r1 = if l2 < r1 then 0 else 1
    | r1 < l1 = if r2 < l1 then 0 else 1
    | otherwise = 1
