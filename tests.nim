import std/unittest, ptrarith

test "Basic ptr arithmetic":
    var v: array[5, int] = [1, 2, 3, 4, 5]
    var p: ptr int = v[0].addr
    check 1 == p[]
    check 2 == (p + 1)[]
    check 3 == (p + 2)[]
    check 4 == (p + 3)[]
    check 5 == (p + 4)[]

    p += 2
    check 3 == p[]
    check 2 == p[^1]
    check 1 == p[^2]

    check 3 == p[0]
    check 4 == p[1]
    check 5 == p[2]

    p -= 2
    for n in p.items v.len:
        check n == v[n - 1]

    p[3] = 11
    check 11 == (p + 3)[]

    for n in p.mitems v.len:
        n += 1

    check v == [2, 3, 4, 12, 6]

    for (i, n) in p.pairs v.len:
        check v[i] == n
