module test.yosupo.tree.lca;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/lca
import std;

import daylight.base;
import daylight.graph.base;
import daylight.graph.builder;
import daylight.graph.lca;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);

    auto G = (new GraphBuilder!()(N)).setIndex(0).useTreeFormat().build(reader);
    auto lca = new LCA!()(G);
    while (Q--) {
        int u, v;
        reader.read(u, v);
        writeln(lca.query(u, v));
    }
}
