module daylight.graph.builder;

import std;
import daylight.base;
import daylight.graph.base;

class GraphBuilder(T = long) {
    private int N, M;
    private Graph!T G;
    private int index = 1;
    private bool m_weighted = false;
    private bool m_directed = false;
    private bool tree_format = false;

    this(int N) {
        this(N, N - 1);
    }

    this(int N, int M) {
        this.N = N;
        this.M = M;
        this.G = new Graph!T(N);
    }

    ref auto setIndex(int index = 1) {
        this.index = index;
        return this;
    }

    ref auto weighted(bool weighted = 1) {
        this.m_weighted = weighted;
        return this;
    }

    ref auto directed(bool directed = 1) {
        this.m_directed = directed;
        return this;
    }

    ref auto useTreeFormat(bool tree_format = true) {
        this.tree_format = tree_format;
        return this;
    }

    ref Graph!T build(Reader reader) {
        if (tree_format) {
            foreach (i; 1 .. N) {
                int p;
                reader.read(p);
                p -= index;
                T c = T.init + 1;
                if (m_weighted) {
                    reader.read(c);
                }
                G[p] ~= Edge!T(p, i, c);
                if (!m_directed) {
                    G[i] ~= Edge!T(i, p, c);
                }
            }
        } else {
            foreach (i; 0 .. M) {
                int u, v;
                reader.read(u, v);
                u -= index;
                v -= index;
                T c = T.init + 1;
                if (m_weighted) {
                    reader.read(c);
                }
                G[u] ~= Edge!T(u, v, c);
                if (!m_directed) {
                    G[v] ~= Edge!T(v, u, c);
                }
            }
        }
        return G;
    }

    T[][] buildMatrix(Reader reader, T non_edge = LINF) {
        T[][] G = new T[][](N, N);
        foreach (i; 0 .. N) {
            G[i][] = non_edge;
        }
        if (tree_format) {
            foreach (i; 1 .. N) {
                int p;
                reader.read(p);
                p -= index;
                T c = T.init + 1;
                if (m_weighted) {
                    reader.read(c);
                }
                G[p][i] = c;
                if (!m_directed) {
                    G[i][p] = c;
                }
            }
        } else {
            foreach (i; 0 .. M) {
                int u, v;
                reader.read(u, v);
                u -= index;
                v -= index;
                T c = T.init + 1;
                if (m_weighted) {
                    reader.read(c);
                }
                G[u][v] = c;
                if (m_directed) {
                    G[v][u] = c;
                }
            }
        }
        return G;
    }

    Edges!T buildEdgeList(Reader reader) {
        Edges!T edges;
        if (tree_format) {
            foreach (i; 1 .. N) {
                int p;
                reader.read(p);
                p -= index;
                T c = T.init + 1;
                if (weighted) {
                    reader.read(c);
                }
                edges ~= Edge!T(p, i, c);
                if (!directed) {
                    edges ~= Edge!T(i, p, c);
                }
            }
        } else {
            foreach (i; 0 .. M) {
                int u, v;
                reader.read(u, v);
                u -= index;
                v -= index;
                T c = T.init + 1;
                if (weighted) {
                    reader.read(c);
                }
                edges ~= Edge!T(u, v, c);
                if (directed) {
                    edges ~= Edge!T(v, u, c);
                }
            }
        }
        return edges;
    }
}
