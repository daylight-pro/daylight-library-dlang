module test.yosupo.number_theory.factorize;

// verification-helper: PROBLEM https://judge.yosupo.jp/problem/factorize
import std;
import daylight.base;
import daylight.math.factorizer;

void main() {
    auto reader = new Reader();
    int Q;
    reader.read(Q);
    auto factorizer = new Factorizer();

    while (Q--) {
        long N;
        reader.read(N);
        auto mf = factorizer.factorize(N);
        auto ans = new long[0];
        foreach (key, val; mf) {
            foreach (i; 0 .. val) {
                ans ~= key;
            }
        }
        write(ans.length, " ");
        ans.sort.map!(x => x.to!string).joiner(" ").writeln();
    }
}
