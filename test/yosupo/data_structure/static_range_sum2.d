module test.yosupo.data_structure.static_range_sum2;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/static_range_sum

import std;
import daylight.base;
import daylight.structure.disjoint_sparse_table;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    auto A = new long[](N);
    reader.read(A);
    auto st = DisjointSparseTable!(long, (a, b) => a + b)(A);
    foreach (i; 0 .. Q) {
        int l, r;
        reader.read(l, r);
        writeln(st[l .. r]);
    }
}
