module Lib
    ( someFunc
    ) where

import Data.List.Split
import Data.List.Unique

type Point = (Int, Int)
type Range = (Int, Int)

type Sensor = (Point, Int) -- (sensor location, sensor 'radius')
data Intersect = Nothing |
                 Is Point Point deriving (Eq, Show)

minX :: Int
minX = 0

maxX :: Int
maxX = 4000000
--maxX = 20

refX :: Int
refX = 2000000

someFunc :: IO ()
someFunc = do
    contents <- readFile "../input.txt"
    let sbs = map parse_sb . lines $ contents
    let sensors = parse_mdist $ sbs
    let xbeakons = snd . unzip $ sbs -- existing beakons
    let fbeakons = length . sortUniq . filter (\(_, y') -> y' == refX) $ xbeakons -- beakons on y = 2M
    let pos = coverline refX sensors
    print  ((npos pos) - fbeakons)
    print . calc . head . findCover' . coverall3 $ sensors


-- parse list of (sensor, closest beacon) into list of (sensor center, sensor 'radius')
parse_mdist :: [(Point, Point)] -> [Sensor]
parse_mdist [] = []
parse_mdist (sb : sbs) = ((s, sbdist) : parse_mdist sbs)
    where
        (s, b) = sb
        sbdist = mdist s b

-- parse a string into a pair of (sensor coords, beacon coords)
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

-- calculate 'manhattan distance' between two points
mdist :: Point -> Point -> Int
mdist (x1, y1) (x2, y2) = dx + dy
    where
        moff a b = (a - b) * signum (a - b)
        dx = moff x1 x2
        dy = moff y1 y2


-- minimum x coordinate that is covered by present sensors
minmaxcoord :: [Sensor] -> (Int, Int)
minmaxcoord [] = ((-1),(-1))
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

coverall3 :: [Sensor] -> [[(Range, Int)]]
coverall3 ss = map (\l -> foldl coverpoints3' l ss) initMap'

findCover' ::[[(Range, Int)]] -> [(Range, Int)]
findCover' pm = concat pm

calc :: (Range, Int) -> Int
calc ((x, _), y) = x * maxX + y

initMap' :: [[(Range, Int)]]
initMap' = zipWith (\a b -> [(a, b)]) (replicate (maxX - minX + 1) (minX, maxX)) [minX..maxX]

coverpoints3' :: [(Range, Int)] -> Sensor -> [(Range, Int)]
coverpoints3' [] _ = []
coverpoints3' rngs s = coverpoints3 rngs is
    where
        (_, y) = head rngs
        is = intersects' y s

coverpoints3 :: [(Range, Int)] -> Intersect -> [(Range, Int)]
coverpoints3 [] _ = []
coverpoints3 rngs Lib.Nothing = rngs
coverpoints3 (rng@((rl, rr), ry) : rngs) is@(Is (x1,_) (x2, _))
    | rr < x1 = (rng : coverpoints3 rngs is)
    | rl > x2 = (rng : coverpoints3 rngs is)
    | rl < x1 && rr > x2 = (((rl, x1 - 1), ry):((x2 + 1, rr), ry):coverpoints3 rngs is)
    | rl >= x1 && rr <= x2 = coverpoints3 rngs is
    | rl < x1 = (((rl, x1 - 1), ry) : coverpoints3 rngs is)
    | otherwise = (((x2 + 1, rr), ry) : coverpoints3 rngs is)

-- outputs the list of Bools, true if (x, y') is covered by some sensor
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

npos :: [Bool] -> Int
npos r = length . filter (== True) $ r

intersects :: Int -> Sensor -> Intersect
intersects y ((sx, sy), sr)
    | sq > sr = Lib.Nothing
    | otherwise = Is (sx - (sr - sq), y) (sx + (sr - sq), y)
    where sq = (sy - y) * signum (sy - y)

intersects' :: Int -> Sensor -> Intersect
intersects' y ((sx, sy), sr)
    | sq > sr = Lib.Nothing
    | otherwise = Is (lx', y) (rx', y)
    where
        lx = sx - (sr - sq)
        lx' = if lx < 0 then 0
              else
                if lx > maxX then maxX else lx
        rx = sx + (sr - sq)
        rx' = if rx < 0 then 0
              else
                if rx > maxX then maxX else rx
        sq = (sy - y) * signum (sy - y)
