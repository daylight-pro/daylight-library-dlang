module acl.internal_math;

unittest {
    assert(safeMod(11, 5) == 1);
    assert(safeMod(-11, 5) == 4);

    assert(ctPowMod(12_345_678, 87_654_321, 1_000_000_007) == 904_406_885);

    assert(isPrime!(1_000_000_007));
    assert(!isPrime!(1_000_000_006));

    assert(invGcd(7, 4) == Tuple!(long, long)(1, 3));
    assert(invGcd(630, 300) == Tuple!(long, long)(30, 1));

    assert(primitiveRoot!(7) == 3);
}

unittest {
    foreach (m; 1 .. 100 + 1) {
        auto bt = Barrett(m);
        foreach (a; 0 .. m)
            foreach (b; 0 .. m) {
                assert(a * b % m == bt.mul(a, b));
            }
    }
    assert(0 == Barrett(1).mul(0, 0));
}

unittest {
    immutable int mod_upper = int.max;
    for (uint mod = mod_upper; mod >= mod_upper - 20; mod--) {
        auto bt = Barrett(mod);
        uint[] v;
        foreach (i; 0 .. 10) {
            v ~= i;
            v ~= mod - i;
            v ~= mod / 2 + i;
            v ~= mod / 2 - i;
        }
        foreach (a; v) {
            immutable long a2 = a;
            assert((a2 * a2) % mod == bt.mul(a, a));
            foreach (b; v) {
                immutable long b2 = b;
                assert((a2 * b2) % mod == bt.mul(a, b));
            }
        }
    }
}

unittest {
    bool isPrimeNaive(long n) {
        assert(0 <= n && n <= int.max);
        if (n == 0 || n == 1)
            return false;
        for (long i = 2; i * i <= n; i++)
            if (n % i == 0)
                return false;
        return true;
    }

    assert(!ctIsPrime(121));
    assert(!ctIsPrime(11 * 13));
    assert(ctIsPrime(1_000_000_007));
    assert(!ctIsPrime(1_000_000_008));
    assert(ctIsPrime(1_000_000_009));
    foreach (i; 0 .. 10_000 + 1)
        assert(isPrimeNaive(i) == ctIsPrime(i));
    foreach (i; 0 .. 10_000 + 1) {
        auto x = int.max - i;
        assert(isPrimeNaive(x) == ctIsPrime(x));
    }
}

unittest {
    long gcd(long a, long b) {
        assert(0 <= a && 0 <= b);
        if (b == 0)
            return a;
        return gcd(b, a % b);
    }

    long[] pred;
    foreach (i; 0 .. 10 + 1) {
        pred ~= i;
        pred ~= -i;
        pred ~= long.min + i;
        pred ~= long.max - i;
        pred ~= long.min / 2 + i;
        pred ~= long.min / 2 - i;
        pred ~= long.max / 2 + i;
        pred ~= long.max / 2 - i;
        pred ~= long.min / 3 + i;
        pred ~= long.min / 3 - i;
        pred ~= long.max / 3 + i;
        pred ~= long.max / 3 - i;
    }
    pred ~= 998_244_353;
    pred ~= 1_000_000_007;
    pred ~= 1_000_000_009;
    pred ~= -998_244_353;
    pred ~= -1_000_000_007;
    pred ~= -1_000_000_009;

    foreach (a; pred)
        foreach (b; pred) {
            if (b <= 0)
                continue;
            immutable long a2 = safeMod(a, b);
            auto eg = invGcd(a, b);
            immutable g = gcd(a2, b);
            assert(g == eg[0]);
            assert(0 <= eg[1]);
            assert(eg[1] <= b / eg[0]);
        }
}

unittest {
    foreach (m; 2 .. 10_000 + 1) {
        if (!ctIsPrime(m))
            continue;
        immutable int n = ctPrimitiveRoot(m);
        assert(1 <= n);
        assert(n < m);
        int x = 1;
        foreach (i; 1 .. m - 2 + 1) {
            x = cast(int)(cast(long) x * n % m);
            assert(1 != x);
        }
        x = cast(int)(cast(long) x * n % m);
        assert(1 == x);
    }
}

unittest {
    int[] factors(int m) {
        int[] result;
        for (int i = 2; cast(long) i * i <= m; i++)
            if (m % i == 0) {
                result ~= i;
                while (m % i == 0)
                    m /= i;
            }
        if (m > 1)
            result ~= m;
        return result;
    }

    bool isPrimitiveRoot(int m, int g) {
        assert(1 <= g && g < m);
        auto prs = factors(m - 1);
        foreach (x; prs) {
            if (ctPowMod(g, (m - 1) / x, m) == 1)
                return false;
        }
        return true;
    }

    assert(isPrimitiveRoot(2, primitiveRoot!(2)));
    assert(isPrimitiveRoot(3, primitiveRoot!(3)));
    assert(isPrimitiveRoot(5, primitiveRoot!(5)));
    assert(isPrimitiveRoot(7, primitiveRoot!(7)));
    assert(isPrimitiveRoot(11, primitiveRoot!(11)));
    assert(isPrimitiveRoot(998_244_353, primitiveRoot!(998_244_353)));
    assert(isPrimitiveRoot(1_000_000_007, primitiveRoot!(1_000_000_007)));
    assert(isPrimitiveRoot(469_762_049, primitiveRoot!(469_762_049)));
    assert(isPrimitiveRoot(167_772_161, primitiveRoot!(167_772_161)));
    assert(isPrimitiveRoot(754_974_721, primitiveRoot!(754_974_721)));
    assert(isPrimitiveRoot(324_013_369, primitiveRoot!(324_013_369)));
    assert(isPrimitiveRoot(831_143_041, primitiveRoot!(831_143_041)));
    assert(isPrimitiveRoot(1_685_283_601, primitiveRoot!(1_685_283_601)));

    foreach (i; 0 .. 1000) {
        immutable int x = int.max - i;
        if (!ctIsPrime(x))
            continue;
        assert(isPrimitiveRoot(x, ctPrimitiveRoot(x)));
    }
}

// --- start ---

import std.typecons : Tuple;

/// Return: `x mod m`
/// Param: `1 <= m`
ulong safeMod(long x, long m) @safe pure nothrow @nogc {
    x %= m;
    if (x < 0)
        x += m;
    return x;
}

/// Return: `a*b` (128bit width)
ulong[2] umul128(ulong a, ulong b) @safe @nogc pure nothrow {
    immutable ulong au = a >> 32;
    immutable ulong bu = b >> 32;
    immutable ulong al = a & ((1UL << 32) - 1);
    immutable ulong bl = b & ((1UL << 32) - 1);

    ulong t = al * bl;
    immutable ulong w3 = t & ((1UL << 32) - 1);
    ulong k = t >> 32;
    t = au * bl + k;

    k = t & ((1UL << 32) - 1);
    immutable ulong w1 = t >> 32;
    t = al * bu + k;
    k = t >> 32;
    return [au * bu + w1 + k, t << 32 + w3];
}

/// Fast modular multiplication by barrett reduction
/// Reference: https://en.wikipedia.org/wiki/Barrett_reduction
/// NOTE: reconsider after Ice Lake
struct Barrett {
    ///
    uint _m;
    ///
    ulong im;
    /// Param: `1 <= m < 2^31`
    this(uint m) @safe @nogc pure nothrow {
        _m = m;
        im = (cast(ulong)(-1)) / m + 1;
    }

    /// Return: `m`
    uint umod() @safe @nogc pure nothrow {
        return _m;
    }

    /// Param: `0 <= a < m`, `0 <= b < m`
    /// Return: `a * b % m`
    uint mul(uint a, uint b) @safe @nogc pure nothrow {
        ulong z = a;
        z *= b;
        immutable ulong x = umul128(z, im)[0];
        uint v = cast(uint)(z - x * _m);
        if (_m <= v)
            v += _m;
        return v;
    }
}

/// Param: `0 <= n`, `1 <= m`
/// Return: `(x ^^ n) % m`
long ctPowMod(long x, long n, int m) @safe pure nothrow @nogc {
    if (m == 1)
        return 0;
    uint _m = cast(uint) m;
    ulong r = 1;
    ulong y = safeMod(x, m);
    while (n) {
        if (n & 1)
            r = (r * y) % _m;
        y = (y * y) % _m;
        n >>= 1;
    }
    return r;
}

/// Reference:
/// M. Forisek and J. Jancina,
/// Fast Primality Testing for Integers That Fit into a Machine Word
/// Param: `0 <= n`
bool ctIsPrime(int n) @safe pure nothrow @nogc {
    if (n <= 1)
        return false;
    if (n == 2 || n == 7 || n == 61)
        return true;
    if (n % 2 == 0)
        return false;
    long d = n - 1;
    while (d % 2 == 0)
        d /= 2;
    foreach (a; [2, 7, 61]) {
        long t = d;
        long y = ctPowMod(a, t, n);
        while (t != n - 1 && y != 1 && y != n - 1) {
            y = y * y % n;
            t <<= 1;
        }
        if (y != n - 1 && t % 2 == 0) {
            return false;
        }
    }
    return true;
}

/// ditto
enum bool isPrime(int n) = ctIsPrime(n);

/// Param: `1 <= b`
/// Return: `pair(g, x)` s.t. `g = gcd(a, b)`, `x*a = g (mod b)`, `0 <= x < b/g`
Tuple!(long, long) invGcd(long a, long b) @safe pure nothrow @nogc {
    a = safeMod(a, b);
    if (a == 0)
        return Tuple!(long, long)(b, 0);
    long s = b, t = a, m0 = 0, m1 = 1;
    while (t) {
        immutable long u = s / t;
        s -= t * u;
        m0 -= m1 * u;
        long tmp = s;
        s = t;
        t = tmp;
        tmp = m0;
        m0 = m1;
        m1 = tmp;
    }
    if (m0 < 0)
        m0 += b / s;
    return Tuple!(long, long)(s, m0);
}

/// Compile time primitive root
/// Param: m must be prime
/// Return: primitive root (and minimum in now)
int ctPrimitiveRoot(int m) @safe pure nothrow @nogc {
    if (m == 2)
        return 1;
    if (m == 167_772_161)
        return 3;
    if (m == 469_762_049)
        return 3;
    if (m == 754_974_721)
        return 11;
    if (m == 998_244_353)
        return 3;
    int[20] divs;
    divs[0] = 2;
    int cnt = 1;
    int x = (m - 1) / 2;
    while (x % 2 == 0)
        x /= 2;
    for (int i = 3; (cast(long) i) * i <= x; i += 2)
        if (x % i == 0) {
            divs[cnt++] = i;
            while (x % i == 0)
                x /= i;
        }
    if (x > 1)
        divs[cnt++] = x;
    for (int g = 2;; g++) {
        bool ok = true;
        foreach (i; 0 .. cnt)
            if (ctPowMod(g, (m - 1) / divs[i], m) == 1) {
                ok = false;
                break;
            }
        if (ok)
            return g;
    }
}

/// ditto
enum primitiveRoot(int m) = ctPrimitiveRoot(m);
