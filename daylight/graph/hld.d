module daylight.graph.hld;
import std;

// --- start ---

class HLDecomposition {
    private int V;
    private int[][] G;
    private int[] stsize, parent, pathtop, inT, outT;
    private int root;
    private bool built_flag;

    private void buildStsize(int u, int p) {
        stsize[u] = 1, parent[u] = p;
        foreach (ref v; G[u]) {
            if (v == p) {
                if (v == G[u][$ - 1])
                    break;
                else
                    swap(v, G[u][$ - 1]);
            }
            buildStsize(v, u);
            stsize[u] += stsize[v];
            if (stsize[v] > stsize[G[u][0]]) {
                swap(v, G[u][0]);
            }
        }
    }

    void buildPath(int u, int p, ref int tm) {
        inT[u] = tm++;
        foreach (v; G[u]) {
            if (v == p)
                continue;
            pathtop[v] = (v == G[u][0] ? pathtop[u] : v);
            buildPath(v, u, tm);
        }
        outT[u] = tm;
    }

    this(int node_size) {
        this.V = node_size;
        this.G = new int[][](node_size, 0);
        this.stsize = new int[node_size];
        this.parent = new int[node_size];
        this.pathtop = new int[node_size];
        this.inT = new int[node_size];
        this.outT = new int[node_size];
        this.parent[] = -1;
        this.pathtop[] = -1;
        this.inT[] = -1;
        this.outT[] = -1;
        this.built_flag = false;
    }

    void addEdge(int u, int v) {
        G[u] ~= v;
        G[v] ~= u;
    }

    void build(int root = 0) {
        this.root = root;
        built_flag = true;
        int tm = 0;
        buildStsize(root, -1);
        pathtop[root] = root;
        buildPath(root, -1, tm);
    }

    int index(int a) {
        return inT[a];
    }

    int lca(int a, int b) {
        int pa = pathtop[a], pb = pathtop[b];
        while (pa != pb) {
            if (inT[pa] > inT[pb]) {
                a = parent[pa], pa = pathtop[a];
            } else {
                b = parent[pb], pb = pathtop[b];
            }
        }
        if (inT[a] > inT[b])
            swap(a, b);
        return a;
    }

    Tuple!(int, int) subtree_query(int a) {
        enforce(built_flag, "You must call hld.build() before call query function");
        return Tuple!(int, int)(inT[a], outT[a]);
    }

    Tuple!(int, int, bool)[] path_query(int from, int to) {
        enforce(built_flag, "You must call hld.build() before call query function");
        int pf = pathtop[from], pt = pathtop[to];
        alias T = Tuple!(int, int, bool);
        DList!T front, back;
        while (pf != pt) {
            if (inT[pf] > inT[pt]) {
                front.insertBack(Tuple!(int, int, bool)(inT[pf], inT[from] + 1, true));
                from = parent[pf], pf = pathtop[from];
            } else {
                back.insertFront(Tuple!(int, int, bool)(inT[pt], inT[to] + 1, false));
                to = parent[pt], pt = pathtop[to];
            }
        }
        if (inT[from] > inT[to]) {
            front.insertBack(Tuple!(int, int, bool)(inT[to], inT[from] + 1, true));
        } else {
            front.insertBack(Tuple!(int, int, bool)(inT[from], inT[to] + 1, false));
        }
        T[] ret;
        while (!front.empty()) {
            ret ~= front.front;
            front.removeFront();
        }
        while (!back.empty()) {
            ret ~= back.front;
            back.removeFront();
        }
        return ret;
    }
}
