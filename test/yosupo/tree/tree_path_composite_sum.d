module test.yosupo.tree.tree_path_composite_sum;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/tree_path_composite_sum

import std;
import daylight.base;
import daylight.graph.base;
import daylight.rerooting;
import acl.modint;

alias mint = modint998244353;

void main() {
    Reader reader = new Reader();
    int N;
    reader.read(N);
    int[] A = new int[N];
    reader.read(A);
    alias P = Tuple!(mint, mint);
    alias Q = Tuple!(mint, int);

    Q merge(Q x, Q y) {
        return Q(x[0] + y[0], x[1] + y[1]);
    }

    Q apply(Q a, Edge!P e) {
        return Q((a[0] + mint(A[e.from])) * e.info[0] + e.info[1] * mint(a[1] + 1), a[1] + 1);
    }

    auto rr = Rerooting!(Q, P)(N, &merge, &apply, Q(mint(0), 0));
    foreach (i; 0 .. N - 1) {
        int u, v, b, c;
        reader.read(u, v, b, c);
        rr.addEdge(u, v, P(mint(b), mint(c)));
    }
    auto V = rr.build();
    auto ans = new mint[](N);
    foreach (i; 0 .. N) {
        ans[i] = V[i][0] + mint(A[i]);
    }
    ans.map!(x => x.val().to!string).join(" ").writeln;
}
