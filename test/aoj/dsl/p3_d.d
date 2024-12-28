module test.aoj.dsl.p3_d;

// competitive-verifier: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_3_D&lang=jp
import std;
import daylight.base;
import daylight.structure.swag;

void main() {
    Reader reader = new Reader();
    int N, L;
    reader.read(N, L);
    int[] A = new int[](N);
    reader.read(A);
    FoldableQueue!(int, (a, b) => min(a, b), INF) swag;
    int[] ans = new int[0];
    foreach (a; A) {
        swag ~= a;
        if (swag.length > L) {
            swag.pop();
        }
        if (swag.length == L) {
            ans ~= swag.fold();
        }
    }
    ans.map!(a => a.to!string).join(" ").writeln;
}
