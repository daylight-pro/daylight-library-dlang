module test.aoj.ntl.p1_E;

// competitive-verifier: https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=NTL_1_E

import std;
import daylight.base;
import daylight.math.extgcd;

void main() {
    Reader reader = new Reader();
    long a, b;
    reader.read(a, b);
    long x, y;
    long _ = extGCD(a, b, x, y);
    writeln(x, " ", y);
}
