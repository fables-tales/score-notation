all: parserscore check

parserscore: ParseScore.hs
	ghc ParseScore.hs -o $@
check: parserscore
	./parserscore "M"
