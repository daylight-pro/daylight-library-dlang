module test.yosupo.tree.vertex_add_path_sum;

import std;
import acl.fenwicktree;
import daylight.base;
import daylight.graph.hld;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    int A[N];
    reader.read(A);
    auto hld = new HLDecomposition(N);
    foreach (i; 0 .. N - 1) {
        int u, v;
        reader.read(u, v);
        hld.addEdge(u, v);
    }
    hld.build();
    auto fw = FenwickTree!long(N);
    foreach (i; 0 .. N) {
        fw.add(hld.index(i), A[i]);
    }
    while (Q-- > 0) {
        int k;
        reader.read(k);
        if (k == 0) {
            int p, x;
            reader.read(p, x);
            fw.add(hld.index(p), x);

        } else {
            int u, v;
            reader.read(u, v);
            long ans = 0;
            foreach (t; hld.path_query(u, v)) {
                ans += fw.sum(t[0], t[1]);
            }
            writeln(ans);
        }
    }
}
