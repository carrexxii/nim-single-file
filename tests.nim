import std/unittest, ptrarith, bitgen

suite "ptrarith.nim":
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

# This must be at top-level for symbol export
type Mask = distinct uint32
Mask.gen_bit_ops(
    mA, mB, mC, mD,
    _, _, _, _,
    mE, mF, _, mG,
)
const mNone = Mask 0
suite "bitgen.nim":
    test "Basic bit mask usage":
        check 0x1 == uint mA
        check 0x2 == uint mB
        check 0x4 == uint mC
        check 0x8 == uint mD

        check 0x100 == uint mE
        check 0x200 == uint mF
        check 0x800 == uint mG

        check "{mA}" == $mA
        check "{mA, mB}" == $(mA or mB)
        check "{mC, mG}" == $(mG or mC)
        check "{mB, mD, mE, mG}" == $(mB or mD or mE or mG)

        let a  = mA
        let b  = mB
        let ab = mA or mB
        check mNone == (a and b)
        check mA == (ab and a)
        check mB == (ab and b)
        check mA == (a and ab)
        check mB == (b and ab)

        let ged = mG or mE or mD
        check mG in ged
        check mD in ged
        check mE in ged
        check (mG or mD) in ged
        check (mD or mE) in ged
