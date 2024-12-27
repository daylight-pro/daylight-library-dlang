module test.yosupo.convolution.gcd_convolution;

// verification-helper: PROBLEM https://judge.yosupo.jp/problem/gcd_convolution
import std;
import daylight.base;
import daylight.math.eratos;
import acl.modint;

alias mint = modint998244353;

void main() {
    Reader reader = new Reader();
    int N;
    reader.read(N);
    mint[] A = new mint[N + 1];
    mint[] B = new mint[N + 1];
    foreach (i; 0 .. N) {
        int a;
        reader.read(a);
        A[i + 1] = mint(a);
    }
    foreach (i; 0 .. N) {
        int b;
        reader.read(b);
        B[i + 1] = mint(b);
    }
    auto eratos = Eratos(N);
    eratos.fastZeta(A);
    eratos.fastZeta(B);
    mint[] C = new mint[N + 1];
    foreach (i; 0 .. N) {
        C[i + 1] = A[i + 1] * B[i + 1];
    }
    eratos.fastMobius(C);
    C[1 .. $].map!(x => x.val().to!string).join(" ").writeln;
}
