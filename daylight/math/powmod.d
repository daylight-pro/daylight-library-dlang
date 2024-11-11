module daylight.math.powmod;

import std;

// --- start ---

long powMod(long a, long p, long m) {
    auto ret = Int128(1L);
    auto mul = Int128(a);
    for (; p > 0; p >>= 1) {
        if (p & 1)
            ret = (ret * mul) % m;
        mul = (mul * mul) % m;
    }
    return ret.to!long;
}
