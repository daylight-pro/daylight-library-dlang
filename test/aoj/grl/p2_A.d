module test.aoj.grl.p2_A;

// competitive-verifier: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=GRL_2_A
import std;
import daylight.base;
import daylight.graph.builder;
import daylight.graph.kruskal;

void main() {
    Reader reader = new Reader();
    int V, E;
    reader.read(V, E);
    auto G = (new GraphBuilder!long(V, E)).weighted.directed.setIndex(0).buildEdgeList(reader);
    auto ans = kruskal(V, G);
    writeln(ans);
}
