import std/unittest, ptrarith, bitgen

suite "ptrarith.nim":
    test "Basic pointer arithmetic":
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

        p = v[0].addr
        check p[] == 2 ; inc p
        check p[] == 3 ; inc p
        check p[] == 4 ; inc p
        check p[] == 12; inc p
        check p[] == 6

        check p[] == 6 ; dec p
        check p[] == 12; dec p
        check p[] == 4 ; dec p
        check p[] == 3 ; dec p
        check p[] == 2

    test "Generic pointer":
        var v: array[5, int8] = [-4, -2, 0, 2, 4]
        var p: pointer = v[0].addr
        check -4 == cast[ptr int8](p)[]; inc p
        check -2 == cast[ptr int8](p)[]; inc p
        check  0 == cast[ptr int8](p)[]; inc p
        check  2 == cast[ptr int8](p)[]; inc p
        check  4 == cast[ptr int8](p)[]

        p = v[0].addr + 3
        check 2 == cast[ptr int8](p)[]
        p += 1
        check 4 == cast[ptr int8](p)[]

        p = v[0].addr
        check p[0] == cast[byte](v[0])
        check p[1] == cast[byte](v[1])
        check p[2] == cast[byte](v[2])
        check p[3] == cast[byte](v[3])
        check p[4] == cast[byte](v[4])

        p = v[^1].addr
        check p[^0] == cast[byte](v[4])
        check p[^1] == cast[byte](v[3])
        check p[^2] == cast[byte](v[2])
        check p[^3] == cast[byte](v[1])
        check p[^4] == cast[byte](v[0])

        p = v[0].addr
        for i in 0..<v.len:
            inc p[i]
        check v == [-3'i8, -1, 1, 3, 5]
        for i in 0..<v.len:
            p[i] -= 3
        check v == [-6'i8, -4, -2, 0, 2]

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
