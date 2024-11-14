module daylight.graph.dijkstra;

import std;

// --- start ---
import daylight.base;
import daylight.graph.base;

long[] dijkstra(int start, const ref Graph!(long) G) {
    alias P = Tuple!(long, int);
    BinaryHeap!(Array!P, "a > b") bh;
    long[] D = new long[G.length];
    D[] = LINF;
    D[start] = 0;
    bh.insert(P(0, start));
    while (!bh.empty()) {
        P p = bh.front;
        bh.removeFront();
        int v = p[1];
        if (D[v] < p[0])
            continue;
        foreach (e; G[v]) {
            if (D[e.to] > D[v] + e.info) {
                D[e.to] = D[v] + e.info;
                bh.insert(P(D[e.to], e.to));
            }
        }
    }
    return D;
}
