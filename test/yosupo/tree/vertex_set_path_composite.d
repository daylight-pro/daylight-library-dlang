module test.yosupo.tree.vertex_set_path_composite;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/vertex_set_path_composite
import std;
import daylight.base;
import daylight.graph.hld;
import acl.segtree;
import acl.modint;

alias mint = modint998244353;
alias P = Tuple!(mint, mint);

P op(P a, P b) {
    return P(a[0] * b[0], a[1] * b[0] + b[1]);
}

P op2(P a, P b) {
    return P(a[0] * b[0], a[0] * b[1] + a[1]);
}

P e() {
    return P(mint(1), mint(0));
}

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    HLDecomposition hld = new HLDecomposition(N);
    int[] A = new int[N];
    int[] B = new int[N];
    foreach (i; 0 .. N) {
        reader.read(A[i], B[i]);
    }
    foreach (i; 0 .. N - 1) {
        int u, v;
        reader.read(u, v);
        hld.addEdge(u, v);
    }
    hld.build();
    auto seg = Segtree!(P, op, e)(N);
    auto seg2 = Segtree!(P, op2, e)(N);
    foreach (i; 0 .. N) {
        seg.set(hld.index(i), P(mint(A[i]), mint(B[i])));
        seg2.set(hld.index(i), P(mint(A[i]), mint(B[i])));
    }
    while (Q-- > 0) {
        int k;
        reader.read(k);
        if (k == 0) {
            int p, c, d;
            reader.read(p, c, d);
            seg.set(hld.index(p), P(mint(c), mint(d)));
            seg2.set(hld.index(p), P(mint(c), mint(d)));
        } else {
            int u, v, y;
            reader.read(u, v, y);
            auto x = mint(y);
            foreach (t; hld.path_query(u, v))
                with (t.bind!("l", "r", "rev")) {
                    if (rev) {
                        auto s = seg2.prod(l, r);
                        x = s[0] * x + s[1];
                    } else {
                        auto s = seg.prod(l, r);
                        x = s[0] * x + s[1];
                    }
                }
            writeln(x.val());
        }
    }
}
