module test.aoj.grl.p1_C;

// competitive-verifier: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=GRL_1_C&lang=jp
import std;
import daylight.base;
import daylight.graph.builder;
import daylight.graph.floyd;

void main() {
    Reader reader = new Reader();
    int V, E;
    reader.read(V, E);
    auto G = (new GraphBuilder!long(V, E)).weighted.directed.setIndex(0).buildMatrix(reader);
    auto d = floyd(G);
    foreach (i; 0 .. V) {
        if (d[i][i] < 0) {
            writeln("NEGATIVE CYCLE");
            return;
        }
    }
    foreach (i; 0 .. V) {
        foreach (j; 0 .. V) {
            if (j != 0)
                write(" ");
            if (d[i][j] == LINF)
                write("INF");
            else
                write(d[i][j]);
        }
        writeln;
    }
}
