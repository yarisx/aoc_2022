module Lib
    ( someFunc
    ) where

import Data.Char
import Data.List.Split
import Data.Set

type TlSet = Set (Int, Int)

someFunc :: IO ()
someFunc = do
        contents <- readFile "../input.txt"
        print . size . fromList . thrd . Prelude.foldl move ((0,0), (0,0), [(0,0)]) . reverse . Prelude.foldl convmove [] . lines $ contents

-- where to move and how much
convmove :: [String] -> String -> [String]
convmove moves ln = (replicate nn f) ++ moves
    where
        (f:n:[]) = splitOn " " ln
        nn = read n :: Int

mov :: String -> (Int, Int) -> (Int, Int)
mov "R" (hx, hy) = (hx + 1, hy)
mov "L" (hx, hy) = (hx - 1, hy)
mov "U" (hx, hy) = (hx, hy + 1)
--mov "D" (hx, hy) = (hx, hy - 1)
mov _ (hx, hy) = (hx, hy - 1)

move (hd, tl, tlpoints) f = (newhd, newtl, newtlpoints)
    where
        newhd = mov f hd
        newtl = tailMove newhd tl
        newtlpoints = (newtl:tlpoints)

tailMove :: (Int, Int) -> (Int, Int) -> (Int, Int)
tailMove (hx, hy) (tx, ty)
    | sgx * (hx - tx) > 1 = (tx + sgx, ty + sgy)
    | sgy * (hy - ty) > 1 = (tx + sgx, ty + sgy)
    | otherwise = (tx, ty)
    where
        sgx = signum (hx - tx)
        sgy = signum (hy - ty)

thrd (_, _, f) = f
