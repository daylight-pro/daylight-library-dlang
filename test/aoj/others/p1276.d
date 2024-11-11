module test.aoj.others.p1276;

// verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=1276
import std;
import daylight.base;
import daylight.math.factorizer;

void main() {
    Reader reader = new Reader();
    int K;
    reader.read(K);
    auto factorizer = new Factorizer();
    while (K != 0) {
        if (factorizer.isPrime(K)) {
            writeln(0);
            reader.read(K);
            continue;
        }
        int ans = 1;
        for (int i = K; !factorizer.isPrime(i); i++) {
            ans++;
        }
        for (int i = K - 1; !factorizer.isPrime(i); i--) {
            ans++;
        }
        writeln(ans);
        reader.read(K);
    }
}
