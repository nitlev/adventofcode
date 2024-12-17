def extract_sets(i, j):
    return [
        ((i, j), (i, j + 1), (i, j + 2), (i, j + 3)),
        ((i, j), (i, j-1), (i, j-2), (i, j-3)),
        ((i, j), (i+1, j), (i+2, j), (i+3, j)),
        ((i, j), (i-1, j), (i-2, j), (i-3, j)),
        ((i, j), (i+1, j+1), (i+2, j+2), (i+3, j+3)),
        ((i, j), (i-1, j-1), (i-2, j-2), (i-3, j-3)),
        ((i, j), (i-1, j+1), (i-2, j+2), (i-3, j+3)),
        ((i, j), (i+1, j-1), (i+2, j-2), (i+3, j-3)),
    ]


def main():
    with open('src/day4/input.txt') as f:
        lines = f.readlines()

    matches = 0

    for i, line in enumerate(lines):
        for j, _ in enumerate(line):
            for extracts in extract_sets(i, j):
                for (x, y), c in zip(extracts, "XMAS"):
                    if x < 0 or x >= len(lines) or y < 0 or y >= len(line):
                        break
                    if lines[x][y] != c:
                        break
                else:
                    matches += 1

    print(matches)



if __name__ == '__main__':
    main()
