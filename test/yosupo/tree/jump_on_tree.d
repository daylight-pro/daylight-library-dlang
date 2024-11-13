module test.yosupo.tree.jump_on_tree;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/jump_on_tree
import std;

import daylight.graph.base;
import daylight.graph.builder;
import daylight.graph.lca;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);

    auto G = (new GraphBuilder!()(N)).setIndex(0).useTreeFormat().build(reader);
    LCA lca = new LCA(G);
    while (Q--) {
        int s, t, i;
        reader.read(s, t, i);
        if (lca.getSimpleDistance(s, t) < i) {
            writeln(-1);
        } else {
            writeln(lca.jump(s, t, i));
        }
    }
}
