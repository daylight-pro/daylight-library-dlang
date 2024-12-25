module test.aoj.others.p1276_2;

// verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=1276
import std;
import daylight.base;
import daylight.math.eratos;

void main() {
    Reader reader = new Reader();
    int K;
    reader.read(K);
    auto eratos = Eratos(1_299_710);
    while (K != 0) {
        if (eratos[K]) {
            0.writeln;
            reader.read(K);
            continue;
        }
        int ans = 1;
        for (int i = K; !eratos[i]; i++) {
            ans++;
        }
        for (int i = K - 1; !eratos[i]; i--) {
            ans++;
        }
        ans.writeln;
        reader.read(K);
    }
}
