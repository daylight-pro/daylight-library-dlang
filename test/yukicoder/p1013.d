module test.yukicoder.p1013;

// competitive-verifier: PROBLEM https://yukicoder.me/problems/no/1013

import std;
import daylight.base;
import daylight.doubling;

void main() {
    Reader reader = new Reader();
    int N, K;
    reader.read(N, K);
    int[] P = new int[N];
    reader.read(P);
    long[] S = new long[N];
    foreach (i; 0 .. N) {
        P[i] += i;
        if (P[i] >= N) {
            P[i] -= N;
            S[i] = N;
        }
    }
    auto db = new Doubling!(long)(P);
    long op(long a, long b) {
        return a + b;
    }

    long e() {
        return 0;
    }

    db.setMonoid(S, &op, &e);
    foreach (i; 0 .. N) {
        writeln(db[i].walk(K).prod + db[i].walk(K).get + 1);
    }
}
