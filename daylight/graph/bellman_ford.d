module daylight.graph.bellman_ford;
import std;

// --- start

import daylight.base;
import daylight.graph.base;

bool bellman_ford(T)(int v, Edge!T[] es, int s, ref long[] d) {
    d = new long[](v);
    d[] = long.max;
    d[s] = 0;
    foreach (i; 0 .. v) {
        foreach (e; es) {
            if (d[e.from] != long.max && d[e.to] > d[e.from] + e.info) {
                d[e.to] = d[e.from] + e.info;
                if (i == v - 1) {
                    return false;
                }
            }
        }
    }
    return true;
}
