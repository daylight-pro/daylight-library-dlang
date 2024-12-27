module daylight.structure.disjoint_sparse_table;

import std;

struct DisjointSparseTable(T, alias op) {
    private T[][] table;
    private size_t[] lg;
    private size_t n;
    private size_t logn;

    this(const ref T[] a) {
        n = a.length;
        logn = 0;
        while ((1 << logn) <= n) {
            logn++;
        }
        table = new T[][](logn, n);
        foreach (i; 0 .. n) {
            table[0][i] = a[i];
        }
        foreach (i; 1 .. logn) {
            size_t width = 1 << i;
            for (int j = 0; j < a.length; j += width << 1) {
                int t = min(j + width, n).to!int;
                table[i][t - 1] = a[t - 1];
                for (int k = t - 2; k >= j; k--) {
                    table[i][k] = op(a[k], table[i][k + 1]);
                }
                if (n <= t)
                    break;
                table[i][t] = a[t];
                for (int k = t + 1; k < min(t + width, n); k++) {
                    table[i][k] = op(table[i][k - 1], a[k]);
                }
            }
        }
        lg = new size_t[1 << logn];
        foreach (i; 2 .. lg.length) {
            lg[i] = lg[i >> 1] + 1;
        }
    }

    T opSlice(size_t l, size_t r) {
        if (l >= --r)
            return table[0][l];
        size_t b = lg[l ^ r];
        return op(table[b][l], table[b][r]);
    }
}
