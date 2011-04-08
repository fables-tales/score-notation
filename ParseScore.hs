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
_score tokens supers (SuperDown : rest) = _score tokens (supers) rest
_score tokens supers [] = 0

hasSuperAtEnd :: [Token] -> Bool
hasSuperAtEnd a = ((reverse (filter (\x -> x == SuperUp || x == SuperDown) a)) ++ [SuperDown]) !! 0 == SuperUp


score :: [Token] -> Int
score a = let score = _score 0 0 a in
            if hasSuperAtEnd a then 2*score else score
