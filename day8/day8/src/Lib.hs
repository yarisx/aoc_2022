module Lib
    ( someFunc
    ) where

import Data.Char
import Data.Matrix

someFunc :: IO ()
someFunc = do
        contents <- readFile "../input.txt"
        let pass1 = map sec . massageTuples 10 . extremes . massage 10 . lines $ contents
        let pass2 = Lib.transpose . map sec . map (\(a, b, c, d, l) -> (a, b, c, d, ((-1):l))) . extremes . map (\x -> ((-1):x)) . Lib.transpose . map (map (\x -> read (x:"") :: Int)) . lines $ contents
        let pass3 = zipWith (zipWith (+)) pass1 pass2
        -- count got removed
        print . fourWay . map (map conv) . lines $ contents

extremes :: [[Int]] -> [(Int, [Int], Int, Int, [Int])]
extremes = map extreme

extreme :: [Int] -> (Int, [Int], Int, Int, [Int])
extreme = foldl f (-1, [], 0, 0, [])

f (curmax, trees, curridx, maxidx, rev) tv
    | curmax < tv = (tv, (tv + 20:trees), curridx + 1, curridx, (tv:rev))
    | otherwise = (curmax, (0:trees), curridx + 1, maxidx, (tv:rev))

sec (max, maxes, baselen, maxpos, ln) =
    zipWith (+) revmaxes extmaxes
    where
        revmaxes = tail . reverse $ maxes
        (_, newmaxes, _, _, _) = extreme . take (baselen - maxpos) $ ln
        extmaxes = (replicate maxpos 0) ++ newmaxes

transpose:: [[a]]->[[a]]
transpose ([]:_) = []
transpose x = (map head x) : Lib.transpose (map tail x)

massage c (l:lns)
    | lns == [] = ((10:map conv l): [])
    | c == 10 = ((10:map conv l): massage (-1) lns)
    | otherwise = ((c:map conv l): massage c lns)

conv = flip (-) (ord '0') . ord

massageTuples _ [] = []
massageTuples _ ((a, b, c, d, l):[]) = ((a, b, c, d, (10:l)):[])
massageTuples 10 (l:lns) = ((prepElem 10 l): massageTuples (-1) lns)
massageTuples x lns = map (prepElem x) lns

prepElem x (a, b, c, d, l) = (a, b, c, d, (x:l))

-- part2

fourWay rows = m3
    where
        lrRes = map seeTree rows
        rlRes = map (reverse . seeTree . reverse) rows
        joinlr = zipWith (zipWith (*)) lrRes rlRes
        trRows = Lib.transpose rows
        upDown = map seeTree trRows
        downUp = map (reverse . seeTree . reverse) trRows
        joindu = zipWith (zipWith (*)) upDown downUp
        trRes = Lib.transpose joindu
        -- here I got lazy
        m1 = fromLists joinlr
        m2 = fromLists trRes
        m3 = maximum . toList . elementwise (*) m1 $ m2

seeTree (t:trees)
    | trees == [] = [hv]
    | otherwise = (hv:hvs)
    where
        hv = seeTree' t trees
        hvs = seeTree trees

-- score for the particular tree
seeTree' :: Int -> [Int] -> Int
seeTree' h [] = 0
seeTree' h (t:trees) =
    if t >= h then 1 else 1 + (seeTree' h trees)
