module daylight.math.powmod;

// --- start ---

long powMod(long a, long p, long m) {
    long ret = 1;
    long mul = a;
    for (; p > 0; p >>= 1) {
        if (p & 1)
            ret = (ret * mul) % m;
        mul = (mul * mul) % m;
    }
    return ret;
}
