module daylight.math.factorizer;

import std;

unittest {
    auto factorizer = new Factorizer();
    assert(factorizer.isPrime(11));
    assert(!factorizer.isPrime(57));

}

// --- start ---
import daylight.math.powmod;

class Factorizer {
    private static int[] sieve;

    bool isPrime(long N) {
        if (N == 2)
            return true;
        if (N == 1 || N % 2 == 0)
            return false;
        long s = 0;
        long d = N - 1;
        while (d % 2 == 0) {
            s++;
            d /= 2;
        }
        long[] tests = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];
        foreach (a; tests) {
            if (a == N)
                continue;
            long X = powMod(a, d, N);
            int r = 0;
            if (X == 1) {
                continue;
            }
            while (X != N - 1) {
                X = powMod(X, 2, N);
                r++;
                if (X == 1 || r == s)
                    return false;
            }
        }
        return true;
    }

    static void createSieve(int n) {
        n++;
        sieve = array(n.iota);
        for (int i = 2; i * i < n; ++i) {
            if (sieve[i] < i)
                continue;
            for (int j = i * i; j < n; j += i)
                if (sieve[j] == j)
                    sieve[j] = i;
        }
    }

    int[long] factorize(long n) {
        if (n < sieve.length) {
            return factorizeUsingSieve(n);
        } else {
            return rho(n);
        }
    }

    private int[long] factorizeUsingSieve(long n) {
        int[long] res;
        while (n > 1) {
            res[sieve[n]]++;
            n /= sieve[n];
        }
        return res;
    }

    private long findPrimeFactor(long n) {
        if (n % 2 == 0)
            return 2;
        int b = (n.to!double.sqrt.sqrt.sqrt + 1).floor.to!int;
        foreach (c; 1 .. n) {
            long f(long a) {
                return powMod(a, 2, n) + c;
            }

            long y = 6;
            long g = 1;
            auto q = Int128(1L);
            int r = 1;
            int k = 0;
            long ys = 0;
            long x = 0;
            while (g == 1) {
                x = y;
                while (k < 3 * r / 4) {
                    y = f(y);
                    k++;
                }
                while (k < r && g == 1) {
                    ys = y;
                    foreach (i; 0 .. min(b, r - k)) {
                        y = f(y);
                        q *= abs(x - y);
                        q %= n;
                    }
                    g = gcd(q.to!long, n).to!long;
                    k += b;
                }
                k = r;
                r *= 2;
            }
            if (g == n) {
                g = 1;
                y = ys;
                while (g == 1) {
                    y = f(y);
                    g = gcd(abs(x - y), n);
                }
            }
            if (g == n) {
                continue;
            }
            if (isPrime(g)) {
                return g;
            }
            if (isPrime(n / g)) {
                return n / g;
            }
            return findPrimeFactor(g);
        }
        assert(false);
    }

    private int[long] rho(long n) {
        int[long] ret;
        while (!isPrime(n) && n > 1) {
            long p = findPrimeFactor(n);
            int s = 0;
            while (n % p == 0) {
                n /= p;
                s++;
            }
            ret[p] = s;
        }
        if (n > 1) {
            ret[n] = 1;
        }
        return ret;
    }

    long[] getDivisers(long n) {
        auto mp = factorize(n);
        alias P = Tuple!(long, long);
        P[] V = new P[0];
        foreach (key, value; mp) {
            V ~= P(key, value);
        }
        long[] ret;
        void dfs(long i, long v, ref long[] ret, ref P[] mp) {
            long N = mp.length;
            if (i == N) {
                ret ~= v;
                return;
            }
            long m = mp[i][0];
            long p = mp[i][1];

            long mul = 1;
            foreach (j; 0 .. p + 1) {
                dfs(i + 1, v * mul, ret, mp);
                mul *= m;
            }
            return;
        }

        dfs(0, 1, ret, V);
        return ret;
    }
}
