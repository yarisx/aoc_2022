module Lib
    ( someFunc
    ) where

import Data.List.Split
import Data.Set

type Point = (Int, Int)

someFunc :: IO ()
someFunc = do
        contents <- readFile "../input.txt"
        --print . size . fromList . thrd . Prelude.foldl move ((0,0), (0,0), [(0,0)]) . reverse . Prelude.foldl convmove [] . lines $ contents
        print . size . fromList . thrd . Prelude.foldl move ((0,0), replicate 1 (0,0), [(0,0)]) . reverse . Prelude.foldl convmove [] . lines $ contents
        print . size . fromList . thrd . Prelude.foldl move ((0,0), replicate 9 (0,0), [(0,0)]) . reverse . Prelude.foldl convmove [] . lines $ contents

-- where to move and how much
convmove :: [String] -> String -> [String]
convmove moves ln = (replicate nn f) ++ moves
    where
        (f:n:[]) = splitOn " " ln
        nn = read n :: Int

mov :: String -> Point -> Point
mov "R" (hx, hy) = (hx + 1, hy)
mov "L" (hx, hy) = (hx - 1, hy)
mov "U" (hx, hy) = (hx, hy + 1)
--mov "D" (hx, hy) = (hx, hy - 1)
mov _ (hx, hy) = (hx, hy - 1)

move :: (Point, [Point], [Point]) -> String -> (Point, [Point], [Point])
move (hd, tails, tlpoints) f = (newhd, tail . reverse $ newtails', newtlpoints)
    where
        newhd = mov f hd
        newtails' = Prelude.foldl longtailMove [newhd] tails
        newtl = head newtails'
        newtlpoints = (newtl:tlpoints)

tailMove :: Point -> Point -> Point
tailMove (hx, hy) (tx, ty)
    | sgx * (hx - tx) > 1 = (tx + sgx, ty + sgy)
    | sgy * (hy - ty) > 1 = (tx + sgx, ty + sgy)
    | otherwise = (tx, ty)
    where
        sgx = signum (hx - tx)
        sgy = signum (hy - ty)

longtailMove :: [Point] -> Point -> [Point]
longtailMove tails x = (tailMove (head tails) x:tails)

thrd :: (x, y, a) -> a
thrd (_, _, f) = f
