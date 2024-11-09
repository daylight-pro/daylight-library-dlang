module test.yosupo.tree.vertex_add_subtree_sum;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/vertex_add_subtree_sum
import std;
import daylight.base;
import daylight.graph.hld;
import acl.fenwicktree;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    int[] A = new int[N];
    reader.read(A);
    auto hld = new HLDecomposition(N);
    foreach (i; 1 .. N) {
        int p;
        reader.read(p);
        hld.addEdge(p, i);
    }
    hld.build();
    auto fw = FenwickTree!long(N);
    foreach (i; 0 .. N) {
        fw.add(hld.index(i), A[i]);
    }
    while (Q--) {
        int k;
        reader.read(k);
        if (k == 0) {
            int u, x;
            reader.read(u, x);
            fw.add(hld.index(u, x));
        } else {
            int u;
            reader.read(u);
            auto lr = hld.subtree_query(u);
            writeln(fw.sum(lr[0], lr[1]));
        }
    }
}
