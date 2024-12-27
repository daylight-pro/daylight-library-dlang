module daylight.structure.range_tree;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/point_add_rectangle_sum

import std;

// --- start --

class RangeTree(K, M) {
    alias S = M.S;
    alias D = M.D;
    private Tuple!(K, K)[] ps;
    private K[] xs;
    private K[][] ys;
    private D[] ds;
    int n;

    private ulong id(K x) const {
        return assumeSorted(xs).lowerBound(x).length;
    }

    private ulong id(int k, K y) const {
        return assumeSorted(ys[k]).lowerBound(y).length;
    }

    void add(K x, K y) {
        ps ~= tuple(x, y);
    }

    void build() {
        ps.sort.uniq;
        n = ps.length.to!int;
        xs = ps.map!(p => p[0]).array;
        ys = new K[][](2 * n);
        ds = new D[2 * n];
        foreach (i; 0 .. n) {
            ys[i + n] = [ps[i][1]];
            ds[i + n] = M.create(1);
        }
        void merge(ref const K[] a, ref const K[] b, ref K[] c) {
            c = new K[a.length + b.length];
            auto i = 0, j = 0, k = 0;
            while (k < c.length) {
                if (i == a.length) {
                    c[k++] = b[j++];
                } else if (j == b.length) {
                    c[k++] = a[i++];
                } else if (a[i] <= b[j]) {
                    c[k++] = a[i++];
                } else {
                    c[k++] = b[j++];
                }
            }
            c.sort.uniq;
        }

        foreach_reverse (i; 0 .. n) {
            merge(ys[i << 1], ys[(i << 1) | 1], ys[i]);
            ds[i] = M.create(ys[i].length.to!int);
        }
    }

    void apply(K x, K y, S a) {
        int k = (assumeSorted(ps).lowerBound(tuple(x, y)).length + n).to!int;
        while (k > 0) {
            M.apply(ds[k], id(k, y).to!int, a);
            k >>= 1;
        }
    }

    S prod(K x1, K y1, K x2, K y2) {
        S res1 = M.e();
        S res2 = M.e();
        int l = id(x1).to!int + n;
        int r = id(x2).to!int + n;
        while (l < r) {
            if (l & 1) {
                res1 = M.op(res1, M.prod(ds[l], id(l, y1).to!int, id(l, y2).to!int));
                l++;
            }
            if (r & 1) {
                r--;
                res2 = M.op(M.prod(ds[r], id(r, y1).to!int, id(r, y2).to!int), res2);
            }
            l >>= 1;
            r >>= 1;
        }
        return M.op(res1, res2);
    }

}
