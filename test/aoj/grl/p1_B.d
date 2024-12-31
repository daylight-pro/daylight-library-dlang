module test.aoj.grl.p1_B;

// competitive-verifier: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=GRL_1_B

import std;
import daylight.base;
import daylight.graph.base;
import daylight.graph.builder;
import daylight, graph.bellman_ford;

void main() {
    Reader reader = new Reader();
    int V, E, r;
    reader.read(V, E, r);
    auto es = GraphBuilder!long(V, E).buildEdgeList(reader);
    es.writeln;
    long[] d;
    if (bellman_ford(V, es, r, d)) {
        foreach (i, v; d) {
            if (v == long.max) {
                writeln("INF");
            } else {
                writeln(v);
            }
        }
    } else {
        writeln("NEGATIVE CYCLE");
    }
}
