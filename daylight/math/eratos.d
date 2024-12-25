module daylight.math.eratos;

import std;

unittest {
    auto eratos = Eratos(100);
    assert(!eratos[57]);
    assert(eratos[97]);
    auto f = [0, 3, 1, 4, 1, 5, 9, 2, 6, 5];
    eratos.fastZeta(f);
    assert(f == [0, 36, 17, 18, 7, 5, 9, 2, 6, 5]);
    eratos.fastMobius(f);
    assert(f == [0, 3, 1, 4, 1, 5, 9, 2, 6, 5]);
    eratos.fastZeta!(int, "subset")(f);
    assert(f == [0, 3, 4, 7, 5, 8, 17, 5, 11, 12]);
    eratos.fastMobius!(int, "subset")(f);
    assert(f == [0, 3, 1, 4, 1, 5, 9, 2, 6, 5]);
}

// --- start ---

struct Eratos {
    bool[] isPrime;
    int[] minFactor;
    int[] mobius;
    int[] primes;
    this(int n) {
        isPrime = new bool[n + 1];
        minFactor = new int[n + 1];
        mobius = new int[n + 1];
        primes = new int[0];
        mobius[] = 1;
        minFactor[] = -1;

        isPrime[] = true;
        isPrime[0] = false;
        isPrime[1] = false;
        minFactor[1] = 1;
        int last = n.to!double
            .sqrt
            .to!int + 1;
        foreach (i; 2 .. last) {
            if (isPrime[i]) {
                minFactor[i] = i;
                mobius[i] = -1;
                int j = i + i;
                while (j <= n) {
                    isPrime[j] = false;
                    if (minFactor[j] == -1)
                        minFactor[j] = i;
                    if ((j / i) % i == 0)
                        mobius[j] = 0;
                    else
                        mobius[j] = -mobius[j];
                    j += i;
                }
            }
        }
        foreach (i; 2 .. n + 1) {
            if (isPrime[i])
                primes ~= i;
        }
    }

    ref int[] getPrimes() {
        return this.primes;
    }

    ref auto opIndex(size_t index) {
        return this.isPrime[index];
    }

    ref int getMinFactor(int n) {
        return minFactor[n];
    }

    ref int getMobius(int n) {
        return mobius[n];
    }

    void fastZeta(T, string mode = "superset")(ref T[] f) {
        int N = f.length.to!int;
        static if (mode == "superset") {
            foreach (p; 2 .. N) {
                if (!isPrime[p])
                    continue;
                for (int k = (N - 1) / p; k >= 1; --k) {
                    f[k] += f[k * p];
                }
            }
        } else {
            foreach (p; 2 .. N) {
                if (!isPrime[p])
                    continue;
                for (int k = 1; k * p < N; ++k) {
                    f[k * p] += f[k];
                }
            }
        }
    }

    void fastMobius(T, string mode = "superset")(ref T[] F) {
        int N = F.length.to!int;
        static if (mode == "superset") {
            foreach (p; 2 .. N) {
                if (!isPrime[p])
                    continue;
                for (int k = 1; k * p < N; ++k) {
                    F[k] -= F[k * p];
                }
            }
        } else {
            foreach (p; 2 .. N) {
                if (!isPrime[p])
                    continue;
                for (int k = (N - 1) / p; k >= 1; --k) {
                    F[k * p] -= F[k];
                }
            }
        }
    }
}

void eratos(int n, out bool[] isPrime) {
    isPrime = new bool[](n + 1);
}
