module test.aoj.grl.p1_A;

// verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=GRL_1_A
import std;
import daylight.base;
import daylight.graph.base;
import daylight.graph.builder;
import daylight.graph.dijkstra;

void main() {
    Reader reader = new Reader();
    int V, E, r;
    reader.read(V, E, r);
    auto G = (new GraphBuilder!()(V, E)).weighted().directed().setIndex(0).build();
    auto d = dijkstra(r, G);
    foreach (x; d) {
        if (x == LINF) {
            writeln("INF");
        } else {
            writeln(x);
        }
    }
}
