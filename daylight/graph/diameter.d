module daylight.graph.diameter;

import std;

// --- start ---

import daylight.base;
import daylight.graph.base;

Tuple!(T, int, int) getDiameter(T)(ref Graph!T G) {
    alias P = Tuple!(T, int);
    P dfs(int cur, int pre, ref Graph!T G) {
        auto p = P(0, cur);
        foreach (e; G[cur]) {
            if (e.to == pre)
                continue;
            T dis;
            int v;
            AliasSeq!(dis, v) = dfs(e.to, cur, G);
            p.chmax(P(dis + e.info, v));
        }
        return p;
    }

    long dis, dis2;
    int v, v2;
    AliasSeq!(dis, v) = dfs(0, -1, G);
    AliasSeq!(dis2, v2) = dfs(v, -1, G);
    return Tuple!(T, int, int)(dis2, v, v2);
}
