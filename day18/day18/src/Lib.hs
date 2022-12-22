module Lib
    ( someFunc
    ) where

import Data.List.Split
import qualified Data.Set as Set

type TDPoint = (Int, Int, Int)
type PointMap = Set.Set TDPoint

someFunc :: IO ()
someFunc = do
        contents <- readFile "../input.txt"
        print . boulder . parse . lines $ contents

boulder nvset = boulder' (Set.findMin nvset) 0 Set.empty nvset

boulder' np cnt vset nvset
    | emptyset = cnt + nnum
    | otherwise = boulder' nn (cnt + nnum) vset' nvset'
    where
        nvset' = Set.delete np nvset        -- remove current from non-visited
        vset' = Set.insert np vset          -- add current to the visited
        emptyset = Set.null nvset'           -- check if non-visited is empty
        vneighs = get_neighs vset np        -- get visited neighbours of the current
        nvneighs = get_neighs nvset np      -- get non-visited neighbours of the current
        nnum = 6 - ((length vneighs) + (length nvneighs)) -- covered sides == number of neighbours (both visited and non-visited)
        nn = Set.findMin nvset'             -- next cube to check

get_neighs :: PointMap -> TDPoint -> [TDPoint]
get_neighs pm (x, y, z) =
    fst . unzip . filter (\(_, x') -> x') $ ((lp, ln):(rp, rn):(dp, dn):(up, un):(fp, fn):(bp, bn):[])
    where
        lp = (x - 1, y, z)
        ln = Set.member lp pm
        rp = (x + 1, y, z)
        rn = Set.member rp pm
        dp = (x, y - 1, z)
        dn = Set.member dp pm
        up = (x, y + 1, z)
        un = Set.member dp pm
        bp = (x, y, z - 1)
        bn = Set.member bp pm
        fp = (x, y, z + 1)
        fn = Set.member fp pm

parse :: [String] -> PointMap
parse lns = parse' Set.empty lns

parse' :: PointMap -> [String] -> PointMap
parse' vset [] = vset
parse' vset (ln:lns) = parse' vset' lns
    where
        (x:y:z:_) = map (\x' -> read x' :: Int) . splitOn "," $ ln
        vset' = Set.insert (x, y, z) vset
