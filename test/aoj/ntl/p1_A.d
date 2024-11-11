module test.aoj.ntl.p1_A;

// verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=NTL_1_A
import std;
import daylight.base;
import daylight.math.factorizer;

void main() {
    auto reader = new Reader();
    int n;
    reader.read(n);
    auto factorizer = new Factorizer();
    auto mf = factorizer.factorize(n);
    auto ans = new long[0];
    foreach (key, val; mf) {
        foreach (i; 0 .. val) {
            ans ~= key;
        }
    }
    write(n, ": ");
    ans.sort.map!(x => x.to!string).joiner(" ").writeln();
}
