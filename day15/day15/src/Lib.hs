module Lib
    ( someFunc
    ) where

import Data.List.Split
import Data.List.Unique

type Point = (Int, Int)
type Sensor = (Point, Int) -- (sensor location, sensor 'radius')
data Intersect = Nothing |
                 Is {x :: Point, y :: Point} deriving (Eq)

someFunc :: IO ()
someFunc = do
    contents <- readFile "../input.txt"
    let sbs = map parse_sb . lines $ contents
    let xbeakons = snd . unzip $ sbs
    let fbeakons = length . sortUniq . filter (\(x, y) -> y == 2000000) $ xbeakons
    let pos = coverline 2000000 . parse_mdist $ sbs
    print  ((npos pos) - fbeakons)


parse_mdist :: [(Point, Point)] -> [Sensor]
parse_mdist [] = []
parse_mdist (sb : sbs) = ((s, sbdist) : parse_mdist sbs)
    where
        (s, b) = sb
        sbdist = mdist s b

parse_sb :: String -> (Point, Point)
parse_sb ln = ((sx, sy), (bx, by))
    where
        sx = read x1 :: Int
        sy = read y1 :: Int
        bx = read x2 :: Int
        by = read y2 :: Int
        (x1:y1:_) = splitOn "," s
        (x2:y2:_) = splitOn "," b
        (s:b:_) = splitOn ":" ln

mdist (x1, y1) (x2, y2) = dx + dy
    where
        moff a b = (a - b) * signum (a - b)
        dx = moff x1 x2
        dy = moff y1 y2


-- minimum x coordinate that is covered by present sensors
minmaxcoord :: [Sensor] -> (Int, Int)
minmaxcoord (s:ss) = minmaxcoord' ss ms mms
    where
        ms = sx - sr
        mms = sx + sr
        ((sx, _), sr) = s

minmaxcoord' :: [Sensor] -> Int -> Int -> (Int, Int)
minmaxcoord' [] ms mms = (ms, mms)
minmaxcoord' (((sx,_), sr):ss) ms mms
    | newms < ms && newmms > mms = minmaxcoord' ss newms newmms
    | newms < ms = minmaxcoord' ss newms mms
    | newmms > mms = minmaxcoord' ss ms newmms
    | otherwise = minmaxcoord' ss ms mms
    where
        newms = (sx - sr)
        newmms = (sx + sr)

coverline :: Int -> [Sensor] -> [Bool]
coverline y' ss = coverline' y' mc ss
    where mc = minmaxcoord ss

coverline' :: Int -> (Int, Int) -> [Sensor] -> [Bool]
coverline' y (minx, maxx) ss = map (\p -> foldl (folder p) False is) rng
    where
        folder p a (Is (x1, _) (x2, _)) = if (p >= x1 && p <= x2) then a || True else a
        is = filter (\x' -> x' /= Lib.Nothing) . intersections y $ ss
        rng = [minx..maxx]

-- ranges that are covered by sensors at 'height' y
intersections :: Int -> [Sensor] -> [Intersect]
intersections y ss = map (intersects y) ss

npos r = length . filter (== True) $ r

intersects :: Int -> Sensor -> Intersect
intersects y ((sx, sy), sr)
    | sq > sr = Lib.Nothing
    | otherwise = Is (sx - (sr - sq), y) (sx + (sr - sq), y)
    where sq = (sy - y) * signum (sy - y)

printfilter l = map (\x -> if x then '#' else '.') l
show (Is x y) = (x, y)
