module test.yosupo.data_structure.point_add_rectangle_sum;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/point_add_rectangle_sum

import std;
import daylight.base;
import acl.fenwicktree;
import daylight.structure.range_tree;

struct M {
    alias S = long;
    alias D = FenwickTree!long;
    static S op(S a, S b) {
        return a + b;
    }

    static S e() {
        return 0;
    }

    static void apply(ref D d, int i, S a) {
        d.add(i, a);
    }

    static S prod(ref D d, int l, int r) {
        return d.sum(l, r);
    }

    static D create(int n) {
        return FenwickTree!long(n);
    }
}

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    alias Tuple!(int, long, long, long, long) T;
    T[] queries = new T[0];
    auto rt = new RangeTree!(long, M);
    foreach (i; 0 .. N) {
        long x, y, w;
        reader.read(x, y, w);
        rt.add(x, y);
        queries ~= T(0, x, y, w, -1);
    }
    foreach (i; 0 .. Q) {
        int t;
        reader.read(t);
        if (t == 0) {
            long x, y, w;
            reader.read(x, y, w);
            rt.add(x, y);
            queries ~= T(0, x, y, w, -1);
        } else {
            long l, d, r, u;
            reader.read(l, d, r, u);
            queries ~= T(1, l, d, r, u);
        }
    }
    rt.build();
    foreach (q; queries) {
        int t;
        long x, y, w, u;
        AliasSeq!(t, x, y, w, u) = q;
        if (t == 0) {
            rt.apply(x, y, w);
        } else {
            rt.prod(x, y, w, u).writeln;
        }
    }
}
