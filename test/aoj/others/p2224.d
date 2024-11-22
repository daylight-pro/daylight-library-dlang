module test.aoj.others.p2224;

// verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=2224
import std;
import daylight.base;
import daylight.graph.base;
import daylight.graph.kruskal;

void main() {
    Reader reader = new Reader();
    int N, M;
    reader.read(N, M);
    long[][] XY = new long[][](N, 2);
    reader.read(XY);
    long[][] PQ = new long[][](M, 2);
    reader.read(PQ);
    auto G = new Edges!double;
    double dist(long u, long v) {
        return ((XY[u][0] - XY[v][0]) * (XY[u][0] - XY[v][0]) + (
                XY[u][1] - XY[v][1]) * (XY[u][1] - XY[v][1])).to!double.sqrt;
    }

    double sum = 0;
    foreach (i; 0 .. M) {
        long u = PQ[i][0] - 1;
        long v = PQ[i][1] - 1;
        sum += dist(u, v);
        G ~= Edge!double(u.to!int, v.to!int, -dist(u, v));
        G ~= Edge!double(v.to!int, u.to!int, -dist(v, u));
    }

    double d = kruskal!double(N, G);
    writef("%.10f\n", sum + d);
}
