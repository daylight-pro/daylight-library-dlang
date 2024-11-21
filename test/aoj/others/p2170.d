module test.aoj.others.p2170;

// verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=2170
import std;
import daylight.base;
import daylight.graph.base;
import daylight.graph.builder;
import daylight.graph.hld;
import daylight.graph.dijkstra;
import acl.lazy_segtree;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    while (N > 0) {
        auto G = GraphBuilder!long(N).directed().useTreeFormat().build(reader);
        auto d = dijkstra(0, G);

        int op(int a, int b) {
            return max(a, b);
        }

        int e() {
            return 0;
        }

        int mapping(int f, int x) {
            return d[f] > d[x] ? f : x;
        }

        int composition(int f, int g) {
            return d[f] > d[g] ? f : g;
        }

        int id() {
            return 0;
        }

        auto hld = new HLDecomposition(N);
        foreach (i; 0 .. N) {
            foreach (ed; G[i]) {
                hld.addEdge(ed.from, ed.to);
            }
        }
        hld.build();

        auto seg = LazySegTree!(int, op, e, int, mapping, composition, id)(N);
        long ans = 0;
        while (Q--) {
            char C;
            int v;
            reader.read(C, v);
            v--;
            if (C == 'Q') {
                ans += seg[hld.index(v)] + 1;
            } else {
                auto t = hld.subtree_query(v);
                seg[t[0] .. t[1]] ~= v;
            }
        }
        ans.writeln;
        reader.read(N, Q);
    }
}
