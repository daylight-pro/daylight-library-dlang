import std;

// --- start ---
import daylight.base;
import daylight.graph.base;

class LCA(T = long) {
    private static const int max_bit = 20;
    private int K = 1;
    private int[][] parent;
    private T[] dis;
    private int[] simple_dis;
    private void dfs(int cur, int pre, const ref Graph!T G, T d, int sd) {
        parent[cur][0] = pre;
        dis[cur] = d;
        simple_dis[cur] = sd;
        foreach (e; G[cur]) {
            if (e.to == pre)
                continue;
            dfs(e.to, cur, G, d + e.info, sd + 1);
        }
    }

    this(const ref Graph!T G) {
        ulong N = G.length;
        while ((1 << K) < N)
            K++;
        parent = new int[][](N, max_bit);
        foreach (i; 0 .. N) {
            parent[i][] = -1;
        }
        dis = new T[N];
        dis[] = -1;
        simple_dis = new int[N];
        simple_dis[] = -1;
        dfs(0, -1, G, 0, 0);
        foreach (i; 0 .. K - 1) {
            foreach (j; 0 .. N) {
                if (parent[j][i] < 0) {
                    parent[j][i + 1] = -1;
                } else {
                    parent[j][i + 1] = parent[parent[j][i]][i];
                }
            }
        }
    }

    int query(int u, int v, int root) {
        return query(u, v) ^ query(v, root) ^ query(u, root);
    }

    int query(int u, int v) {
        enforce(0 <= u && u < simple_dis.length && 0 <= v && v < simple_dis.length, "invalid vertex index");
        if (simple_dis[u] < simple_dis[v])
            swap(u, v);
        foreach (i; 0 .. K) {
            if ((simple_dis[u] - simple_dis[v]) >> i & 1) {
                u = parent[u][i];
            }
        }
        if (u == v)
            return u;
        foreach_reverse (i; 0 .. K) {
            if (parent[u][i] != parent[v][i]) {
                u = parent[u][i];
                v = parent[v][i];
            }
        }
        return parent[u][0];
    }

    int jump(int from, int to, int cnt) {
        if (cnt < 0 || getSimpleDistance(from, to) < cnt)
            return -1;
        int l = query(from, to);
        if (cnt <= getSimpleDistance(from, l)) {
            int cur = from;
            foreach (i; 0 .. K) {
                if (cnt >> i & 1)
                    cur = parent[cur][i];
            }
            return cur;
        }
        cnt = getSimpleDistance(from, to) - cnt;
        int cur = to;
        foreach (i; 0 .. K) {
            if (cnt >> i & 1)
                cur = parent[cur][i];
        }
        return cur;
    }

    T getDistance(int u, int v) {
        enforce(0 <= u && u < dis.length && 0 <= v && v < dis.length, "invalid vertex index");
        return dis[u] + dis[v] - 2 * dis[query(u, v)];
    }

    int getSimpleDistance(int u, int v) {
        enforce(0 <= u && u < simple_dis.length && 0 <= v && v < simple_dis.length, "invalid vertex index");
        return simple_dis[u] + simple_dis[v] - 2 * simple_dis[query(u, v)];
    }
}
