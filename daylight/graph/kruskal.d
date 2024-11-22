module daylight.graph.kruskal;
import std;

// --- start ---
import acl.dsu;
import daylight.base;
import daylight.graph.base;

T kruskal(T)(int V, Edges!T ES) {
    bool comp(Edge!T a, Edge!T b) {
        if (a.info != b.info)
            return a.info < b.info;
        if (a.from != b.from)
            return a.from < b.from;
        return a.to < b.to;
    }

    ES.sort!(comp);

    T ret = 0;
    auto d = Dsu(V);
    foreach (e; ES) {
        if (!d.same(e.from, e.to)) {
            ret += e.info;
            d.merge(e.from, e.to);
        }
    }
    return ret;
}
