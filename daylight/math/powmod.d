module daylight.math.powmod;

import std;

// --- start ---

long powMod(long a, long p, long m) {
    auto ret = 1L;
    auto mul = a % m;
    for (; p > 0; p >>= 1) {
        if (p & 1)
            ret = (ret * mul) % m;
        mul = (mul * mul) % m;
    }
    return ret.to!long;
}
