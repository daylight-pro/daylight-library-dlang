module test.aoj.itp.p1_3_D;

// verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ITP1_3_D&lang=ja
import std;
import daylight.base;
import daylight.math.factorizer;

void main() {
    Reader reader = new Reader();
    int A, B, C;
    reader.read(A, B, C);
    int ans = 0;
    auto factorizer = new Factorizer();
    auto divisers = factorizer.getDivisers(C);
    foreach (div; divisers) {
        if (A <= div && div <= B)
            ans++;
    }
    writeln(ans);
}
