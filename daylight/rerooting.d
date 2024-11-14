module daylight.rerooting;

import std;

// --- start ---
import daylight.base;
import daylight.graph.base;

struct Rerooting(Data, Cost = ll, bool calc_contribution = false) {
private:
    Data[] dp, memo;
    Graph!Cost G;
    Data delegate(Data, Data) merge;
    Data delegate(Data, Edge!Cost) apply;
    Data e, leaf;
    Data[long] hash;
    long N = -1;
public:
    this(int n, Data delegate(Data, Data) merge, Data delegate(Data, Edge!Cost) apply, Data e) {
        this(n, merge, apply, e, e);
    }

    this(int n, Data delegate(Data, Data) merge, Data delegate(Data, Edge!Cost) apply, Data e, Data leaf) {
        N = n;
        this.merge = merge;
        this.apply = apply;
        this.e = e;
        this.leaf = leaf;
        G = new Graph!Cost(n);
    }

    void addEdge(int from, int to, Cost cost) {
        G[from] ~= Edge!Cost(from, to, cost);
        G[to] ~= Edge!Cost(to, from, cost);
    }

    Data[] build() {
        memo = new Data[G.length];
        memo[] = e;
        dp = new Data[G.length];
        dfs1(0);
        dfs2(0, e);
        return dp;
    }

    Data getContribution(int p, int c) {
        enforce(calc_contribution, "Enable this function by setting calc_contribution = true");
        if ((p * N + c) in hash) {
            return hash[p * N + c];
        } else {
            return e;
        }
    }

    private void dfs1(int cur, int pre = -1) {
        bool is_leaf = true;
        foreach (edge; G[cur]) {
            if (edge.to == pre)
                continue;
            dfs1(edge.to, cur);
            is_leaf = false;
            memo[cur] = merge(memo[cur], apply(memo[edge.to], Edge!Cost(edge.to, cur, edge.info)));
        }
        if (is_leaf)
            memo[cur] = leaf;
    }

    private void dfs2(int cur, const Data val, int pre = -1) {
        Data[] ds = new Data[](0);
        ds ~= val;
        static if (calc_contribution) {
            if (pre != -1) {
                hash[cur * N + pre] = val;
            }
        }
        foreach (edge; G[cur]) {
            if (edge.to == pre)
                continue;
            ds ~= apply(memo[edge.to], Edge!Cost(edge.to, cur, edge.info));
            static if (calc_contribution) {
                hash[cur * N + edge.to] = apply(memo[edge.to], Edge!Cost(edge.to, cur, edge.info));
            }
        }
        int n = ds.length.to!int;
        Data[] dp_left = new Data[n + 1];
        Data[] dp_right = new Data[n + 1];
        dp_left[] = e;
        dp_right[] = e;
        foreach (i; 0 .. n)
            dp_left[i + 1] = merge(dp_left[i], ds[i]);
        foreach_reverse (i; 0 .. n)
            dp_right[i] = merge(ds[i], dp_right[i + 1]);
        dp[cur] = dp_left[n];
        int ind = 1;
        foreach (edge; G[cur]) {
            if (edge.to == pre)
                continue;
            Data sub = merge(dp_left[ind], dp_right[ind + 1]);
            dfs2(edge.to, apply(sub, Edge!Cost(cur, edge.to, edge.info)), cur);
            ind++;
        }
    }
}
