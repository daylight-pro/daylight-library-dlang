module test.aoj.others.p1276_2;

// verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=1276
import std;
import daylight.base;
import daylight.math.eratos;

void main() {
    Reader reader = new Reader();
    int K;
    reader.read(K);
    bool[] isPrime;
    eratos(1_299_710, isPrime);
    while (K != 0) {
        if (isPrime[K]) {
            0.writeln;
            reader.read(K);
            continue;
        }
        int ans = 1;
        for (int i = K; !isPrime[i]; i++) {
            ans++;
        }
        for (int i = K - 1; !isPrime[i]; i--) {
            ans++;
        }
        ans.writeln;
        reader.read(K);
    }
}
