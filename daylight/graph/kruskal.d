module daylight.graph.kruskal;
import std;

// --- start ---
import acl.dsu;
import daylight.base;
import daylight.graph.base;

long kruskal(int V, Edges!long ES) {
    bool comp(Edge!long a, Edge!long b) {
        if (a.info != b.info)
            return a.info < b.info;
        if (a.from != b.from)
            return a.from < b.from;
        return a.to < b.to;
    }

    ES.sort!(comp);

    long ret = 0;
    auto d = Dsu(V);
    foreach (e; ES) {
        if (!d.same(e.from, e.to)) {
            ret += e.info;
            d.merge(e.from, e.to);
        }
    }
    if (d.size(0) != V) {
        return LINF;
    }
    return ret;
}
