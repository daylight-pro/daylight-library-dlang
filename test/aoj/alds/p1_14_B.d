module test.aoj.alds.p1_14_B;

// competitive-verifier: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_14_B

import std;
import daylight.base;
import daylight.string.rolling_hash;

void main() {
    Reader reader = new Reader();
    char[] P, T;
    reader.read(P, T);
    auto hP = RollingHash(P), hT = RollingHash(T);
    ulong N = T.length;
    foreach (i; 0 .. P.length - T.length + 1) {
        if (hP[i .. i + N] == hT[0 .. N]) {
            writeln(i);
        }
    }
}
