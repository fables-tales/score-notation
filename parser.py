import sys 

def fsm(string):
    corners = 0
    backs = 0
    ntokens = 0
    supers = 0
    score = 0
    onramp = False
    startpos = int(string[0])
    i = 1
    while i < len(string):
        instruction = string[i]
        if instruction == "M":
            score += 1
        elif instruction == "B":
            backs += 1

        elif instruction == "T":
            instruction += string[i+1]
            i += 1
            if instruction[1] == "u":
                ntokens += 1
            elif instruction[1] == "d":
                ntokens -= 1
            else:
                return -1

        elif instruction == "S":
            instruction += string[i+1]
            i +=  1
            if instruction[1] == "u":
                supers += 1

            elif instruction[1] == "d":
                supers -= 1
            else:
                return -1
        elif instruction == "R":
            instruction += string[i+1]
            i += 1
            if instruction[1] == "u":
                #ramp up case
                if (startpos - corners) % 4 == 0 and not onramp and backs == 0:
                    score += 3
                    onramp = True
            elif instruction[1] == "d":
                #ramp down case
                if (startpos - corners) % 4 == 3 and onramp and backs == 0:
                    score += 3
                    onramp = False
        elif instruction == "C":
           if (backs > 0): backs -= 1 
           else:
            score += 2 + ntokens + supers
            if (startpos - corners) % 4 == 1:
                onramp = False
            corners += 1
        i += 1
    if (ntokens > 0): score += 2
    if (supers > 0): score *= 2
    return score

def main():
    print fsm(sys.argv[1])


if __name__ == "__main__":
    main()
