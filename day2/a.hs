
import Data.Char (isDigit)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

type PasswordRecord = (Char, Int, Int, Text)

sanitize :: Text -> PasswordRecord
sanitize x =
    let (i, r1) = T.span isDigit x
        (j, r2) = T.span isDigit (T.tail r1)
        c       = r2 `T.index` 1
        y       = T.drop 4 r2
    in (c, read (T.unpack i) :: Int, read (T.unpack j) :: Int, y)

valid :: PasswordRecord -> Bool
valid (c, i, j, x) = let n = T.foldl (\n c' -> if c == c' then n + 1 else n) 0 x
                     in i <= n && n <= j

main = do
    xs <- TIO.readFile "a.dat"
    let ps = filter id $ fmap (valid . sanitize) $ T.lines xs
    putStrLn $ show $ length ps
