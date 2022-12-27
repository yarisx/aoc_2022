module Lib ( someFunc
    ) where

import Data.Char

someFunc :: IO ()
someFunc = do
    contents <- readFile "../input.txt"
    --print . map dec2snafu $ [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 2022]
    print . sum . map (snafu2dec 0) . lines $ contents
    print . dec2snafu . sum . map (snafu2dec 0) . lines $ contents

snafu2dec :: Int -> String -> Int
snafu2dec a [] = a
snafu2dec a cs = a + (snafu2dec' (0, 1) . reverse $ cs)

snafu2dec' :: (Int, Int) -> [Char] -> Int
snafu2dec' (a, _) [] = a
snafu2dec' (a, m) css
    | c == '2' = snafu2dec' (a + 2 * m, newm) cs
    | c == '1' = snafu2dec' (a + m, newm) cs
    | c == '0' = snafu2dec' (a, newm) cs
    | c == '-' = snafu2dec' (a - m, newm) cs
    | c == '=' = snafu2dec' (a - 2*m, newm) cs
    | otherwise = snafu2dec' (a, m) cs
    where
        newm = m * 5
        c = head css
        cs = tail css

dec2snafu :: Int -> String
dec2snafu i = dec2snafu' i 0 ""

dec2snafu' 0 0 str = str
dec2snafu' i carry str
    | (rmndr + carry) == 3 = dec2snafu' ni 1 ('=':str)
    | (rmndr + carry) == 4 = dec2snafu' ni 1 ('-':str)
    | (rmndr + carry) == 5 = dec2snafu' ni 1 ('0':str)
    | otherwise = dec2snafu' ni 0 (chr(48 + rmndr + carry) : str)
    where
        rmndr = i `mod` 5
        ni = i `div` 5
