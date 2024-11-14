module test.yosupo.tree.tree_diameter;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/tree_diameter
import std;
import daylight.base;
import daylight.graph.base;
import daylight.graph.builder;
import daylight.graph.diameter;
import daylight.graph.lca;

void main() {
    Reader reader = new Reader();
    int N;
    reader.read(N);
    auto G = (new GraphBuilder!long(N)).setIndex(0).weighted().build(reader);
    long d;
    int u, v;
    AliasSeq!(d, u, v) = getDiameter!long(G);
    auto lca = new LCA!long(G);
    int[] path = new int[0];
    foreach (i; 0 .. lca.getSimpleDistance(u, v) + 1)
        path ~= lca.jump(u, v, i);
    writeln(d, " ", path.length);
    path.map!(x => x.to!string).join(" ").writeln;
}
