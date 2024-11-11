module test.yosupo.number_theory.primality_test;

// verification-helper: PROBLEM https://judge.yosupo.jp/problem/primality_test
import std;
import daylight.base;
import daylight.math.factorizer;

void main() {
    Reader reader = new Reader();
    int Q;
    reader.read(Q);
    auto factorizer = new Factorizer();
    while (Q--) {
        long N;
        reader.read(N);
        if (factorizer.isPrime(N)) {
            writeln("Yes");
        } else {
            writeln("No");
        }
    }
}
