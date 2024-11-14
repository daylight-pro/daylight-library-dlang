module daylight.string.rolling_hash;
import std;

struct RollingHash {
    private static const ulong mod = (1UL << 61) - 1;
    private static ulong base = 0;
    private static ulong[] pow;
    private ulong[] hash;

    private void expand(ulong sz) {
        ulong pre_sz = pow.length;
        if (pre_sz < sz + 1) {
            foreach (i; pre_sz - 1 .. sz) {
                pow ~= mul(pow[i], base);
            }
        }
    }

    private static ulong add(ulong a, ulong b) {
        if ((a += b) > mod) {
            a -= mod;
        }
        return a;
    }

    private static ulong mul(ulong a, ulong b) {
        auto c = Int128(a) * b;
        return add((c >> 61).to!ulong, (c & mod).to!ulong);
    }

    this(T)(const T[] s) {
        if (base == 0) {
            auto rnd = Random(unpredictableSeed);
            base = uniform(1e9.to!int, this.mod, rnd);
            pow ~= 1;
        }
        expand(s.length + 1);
        hash = new ulong[s.length + 1];
        foreach (i; 0 .. s.length) {
            hash[i + 1] = add(mul(hash[i], base), s[i]);
        }
    }

    ulong query(ulong begin, ulong length) {
        enforce(begin >= 0 && length >= 0 && begin + length < hash.length, "query out of bounds");
        if (length == 0) {
            return 0;
        }
        expand(length);
        return add(hash[begin + length], mod - mul(hash[begin], pow[length]));
    }

    ulong opSlice(size_t start, size_t end) {
        return query(start, end - start);
    }
}
