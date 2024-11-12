module test.yukicoder.p1097;

// competitive-verifier: PROBLEM https://yukicoder.me/problems/no/1097
import std;
import daylight.base;
import daylight.doubling;

void main() {
    Reader reader = new Reader();
    int N;
    reader.read(N);
    auto P = new long[N];
    reader.read(P);
    auto A = new int[N];
    foreach (i; 0 .. N) {
        A[i] = (P[i] + i).to!int;
        A[i] %= N;
    }
    auto db = new Doubling!long(A);
    db.setMonoid(P, (long a, long b) => a + b, () => 0);
    int Q;
    reader.read(Q);
    while (Q--) {
        long K;
        reader.read(K);
        writeln(db[0].walk(K).prod());
    }
}
