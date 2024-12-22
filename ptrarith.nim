# zlib License
#
# (C) 2024 carrexxii
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

# Version 0.1 (22/12/24)

{.push inline.}

func `+`*(p: pointer; n: SomeInteger): pointer = cast[pointer](cast[uint](p) + uint n)
func `+`*[T](p: ptr T; n: SomeInteger): ptr T  = cast[ptr T](cast[uint](p) + (uint n)*uint sizeof T)

func `-`*(p: pointer; n: SomeInteger): pointer = cast[pointer](cast[uint](p) - uint n)
func `-`*[T](p: ptr T; n: SomeInteger): ptr T  = cast[ptr T](cast[uint](p) - (uint n)*uint sizeof T)

func `+=`*(p: var pointer; n: SomeInteger)  = p = p + n
func `+=`*[T](p: var ptr T; n: SomeInteger) = p = p + n

func `-=`*(p: var pointer; n: SomeInteger)  = p = p - n
func `-=`*[T](p: var ptr T; n: SomeInteger) = p = p - n

func `[]`*[T](p: ptr T; i: SomeInteger): var T   = (p + i)[]
func `[]`*(p: pointer; i: SomeInteger): var byte = cast[ptr byte](p + i)[]

func `[]`*[T](p: ptr T; i: BackwardsIndex): var T   = (p - uint i)[]
func `[]`*(p: pointer; i: BackwardsIndex): var byte = cast[ptr byte](p - uint i)[]

func `[]=`*[T](p: ptr T; i: SomeInteger; val: T)   = (p + i)[] = val
func `[]=`*(p: pointer; i: SomeInteger; val: byte) = cast[ptr byte](p + i)[] = val

func inc*(p: var pointer)  = p += 1
func inc*[T](p: var ptr T) = p += 1

func dec*(p: var pointer)  = p -= 1
func dec*[T](p: var ptr T) = p -= 1

iterator items*[T](p: ptr T; len: SomeInteger): T =
    for i in 0..<len:
        yield (p + i)[]

iterator mitems*[T](p: ptr T; len: SomeInteger): var T =
    for i in 0..<len:
        yield (p + i)[]

iterator pairs*[T](p: ptr T; len: SomeInteger): (int, T) =
    for i in 0..<len:
        yield (i, (p + i)[])

iterator mpairs*[T](p: ptr T; len: SomeInteger): (int, var T) =
    for i in 0..<len:
        yield (i, (p + i)[])

{.pop.}
