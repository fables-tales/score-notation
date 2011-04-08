module Main where
import System ( getArgs )


data Token = Moved | TokenUp | TokenDown | RampUp | RampDown | Corner
            | SuperUp | SuperDown deriving (Show, Eq)

tokenize :: String -> [Token]
tokenize [] = []
tokenize ('M' : rest) = Moved : tokenize rest
tokenize ('T' : 'u' : rest) = TokenUp : tokenize rest
tokenize ('T' : 'd' : rest) = TokenDown : tokenize rest
tokenize ('R' : 'u' : rest) = RampUp : tokenize rest
tokenize ('R' : 'd' : rest) = RampDown : tokenize rest
tokenize ('C' : rest) = Corner : tokenize rest
tokenize ('S' : 'u' : rest) = SuperUp : tokenize rest
tokenize ('S' : 'd' : rest) = SuperDown : tokenize rest

_score :: Int -> Int -> [Token] -> Int
_score tokens supers (Moved : rest) = 1 + _score tokens supers rest
_score tokens supers (TokenUp : rest) = _score (tokens + 1) supers rest
_score tokens supers (TokenDown : rest) = _score( tokens - 1) supers rest
_score tokens supers (RampUp : rest) = 3 + _score tokens supers rest
_score tokens supers (RampDown : rest) = 3 + _score tokens supers rest
_score tokens supers (Corner : rest) = 2 + (tokens + supers) + _score tokens supers rest
_score tokens supers (SuperUp : rest) = _score tokens (supers + 1) rest
_score tokens supers (SuperDown : rest) = _score tokens supers rest
_score tokens supers [] =  if (tokens > 0) then 2 else 0


tokenToSuperInt :: Token -> Int
tokenToSuperInt SuperUp = 1
tokenToSuperInt SuperDown = -1
tokenToSuperInt _ = 0

hasSuperAtEnd :: [Token] -> Bool
hasSuperAtEnd a = (sum (map (tokenToSuperInt) a)) > 0


score :: [Token] -> Int
score a = let score = _score 0 0 a in
            if hasSuperAtEnd a then 2*score else score

scoreFromString :: String -> Int
scoreFromString = score . tokenize

test :: [Bool]
test = [scoreFromString "M" == 1,
        scoreFromString "MC" == 3,
        scoreFromString "MTuTd" == 1,
        scoreFromString "MSu" == 2,
        scoreFromString "MRu" == 4,
        scoreFromString "MRuRd" == 7,
        scoreFromString "MTuRuCRd" == 12,
        scoreFromString "MCCCCCC" == 13,
        scoreFromString "MSuSdSuCCTuC" == 32,
        scoreFromString "MTuCTuCTuC" == 15
       ]

allPass :: [Bool] -> Bool
allPass = all (== True)

main :: IO()
main = do args <- getArgs;
          if allPass test then (putStrLn . show . score . tokenize) (head args) else error ("tests fail: " ++ (show test));
