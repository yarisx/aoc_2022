module Lib
    ( someFunc,
        sandgrain,
        sandgrain'
    ) where

import Data.MultiMap
import Data.List (find)
import Data.List.Split
import Data.List.Unique

type Point = (Int, Int)
type Line = (Point, Point)
type PointMap = MultiMap Int Int
type Slice = (Int, [Int])

someFunc :: IO ()
someFunc = do
    contents <- readFile "../input.txt"
    print . sandgrain . expand_lines 0 [] . expand_lines' . Prelude.foldl parse [] . lines $ contents

-- does a set of linespecs from a string ("1,2 -> 3,4 -> 5,6" -> [((1,2),(3,4)), ((3,4),(5,6))]
parse :: [Line] -> String -> [Line]
parse acc ln = parse' acc . prep $ ln

prep :: String -> [String]
prep ln = filter f . splitOn " " $ ln
    where f = \x -> x /= "->"

parse' :: [Line] -> [String] -> [Line]
parse' linespecs (s:e:ln)
    | ln == [] = ((si, ei) : linespecs)
    | otherwise = parse' ((si, ei) : linespecs) (e:ln)
    where
        pt (x : y : []) = (read x :: Int, read y :: Int)
        si = pt . splitOn "," $ s
        ei = pt . splitOn "," $ e

-- it should be easier to produce slices when y-coord goes first
expand_line :: PointMap -> Line -> PointMap
expand_line expanded ((sx, sy), (ex, ey))
    | sx == ex && sy > ey = expand_line expanded ((ex, ey), (sx, sy))
    | sy == ey && sx > ex = expand_line expanded ((ex, ey), (sx, sy))
    | sx == ex = Prelude.foldl (\a (y,x) -> insert y x a) expanded (zip y x)
    | sy == ey = Prelude.foldl (\a (y,x) -> insert y x a) expanded (zip y' x')
    where
        x = replicate (ey - sy + 1) sx
        y = [sy..ey]
        x' = [sx..ex]
        y' = replicate (ex - sx + 1) sy

expand_lines' :: [Line] -> [Slice]
expand_lines' = Prelude.map (\(x, l) -> (x, sortUniq l)) . Data.MultiMap.assocs . Prelude.foldl expand_line empty --linespecs

expand_lines :: Int -> [Slice] -> [Slice] -> [Slice]
expand_lines _ res [] = reverse res
expand_lines mmin res prefill
    | mmin < prefill_y = expand_lines (mmin + 1) ((mmin, []):res) prefill
    | mmin == prefill_y = expand_lines (mmin + 1) (head prefill : res) . tail $ prefill
    where
        prefill_y = fst . head $ prefill

show :: PointMap -> [(Int, [Int])]
show m = Data.MultiMap.assocs m

sandgrain :: [Slice] -> Int
sandgrain pm = sandgrain' pm (500,0) 0 []

-- j is the _next_ slice, vpm are those that are checked, so the grain is -between- slices
-- if the grain is stuck then topmost/last from the checked is updated with the grains position

sandgrain' :: [Slice] -> Point -> Int -> [Slice] -> Int
sandgrain' [] _ cnt _vpm = cnt
sandgrain' s@(j:slices) (gx, gy) cnt vpm
    | nextx /= Nothing = sandgrain' slices (fromMaybe (-1) nextx, gy + 1) cnt (j:vpm)
    | otherwise = sandgrain' newslices (500, 0) (cnt + 1) []
    where
        nextx = find (\x -> not (elem x jxs)) [gx, (gx - 1), (gx + 1)]
        newslices = reverse (blocked: tail vpm) ++ s
        blocked = (iy, (gx:ixs))
        (iy, ixs) = head vpm
        (_, jxs) = j

fromMaybe :: a -> Maybe a -> a
fromMaybe def Nothing = def
fromMaybe _ (Just a) = a
