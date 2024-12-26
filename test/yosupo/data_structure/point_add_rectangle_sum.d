module test.yosupo.data_structure.point_add_rectangle_sum;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/point_add_rectangle_sum

import std;
import daylight.base;
import acl.fenwicktree;
import daylgiht.structure.range_tree;

struct M {
    alias S = ll;
    alias D = FenwickTree!S;
    static S op(S a, S b) {
        return a + b;
    }

    static S e() {
        return 0;
    }

    static D create(int n) {
        return FenwickTree!S(n);
    }

    static void apply(ref D bit, int i, ref S x) {
        bit.add(i, x);
    }

    static S prod(ref D bit, int l, int r) {
        return bit.sum(l, r);
    }
}

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    auto rt = new RangeTree!(int, M)();
    auto qs = new Tuple!(int, long, long, long, long)[];
    foreach (i; 0 .. N) {
        int x, y, z;
        reader.read(x, y, z);
        qs ~= tuple(-1, x, y, z, -1);
        rt.add(x, y);
    }
    foreach (i; 0 .. Q) {
        int t;
        long l, d, r, u = -1;
        reader.read(t, l, d, r);
        if (t == 1)
            reader.read(u);
        qs ~= tuple(t, l, d, r, u);
        if (t == 0)
            rt.add(l, d);
    }
    rt.build();
    foreach (q; qs) {
        int t;
        long a, b, c, d;
        AliasSeq!(t, a, b, c, d) = qs;
        if (t <= 0)
            rt.apply(a, b, c);
        else
            (rt.prod(a, b, c, d)).writeln;
    }
}
