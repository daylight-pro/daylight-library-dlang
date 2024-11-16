module daylight.math.eratos;

import std;

// --- start ---

void eratos(int n, out bool[] isPrime) {
    isPrime = new bool[](n + 1);
    isPrime[] = true;
    isPrime[0] = false;
    isPrime[1] = false;
    int last = n.to!double
        .sqrt
        .to!int + 1;
    foreach (i; 2 .. last) {
        if (isPrime[i]) {
            int j = i + i;
            while (j <= n) {
                isPrime[j] = false;
                j += i;
            }
        }
    }
}
