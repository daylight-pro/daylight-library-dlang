module test.yosupo.data_structure.static_rmq;

// verificaton-helper: PROBLEM https://judge.yosupo.jp/problem/static_rmq

import std;
import daylight.base;
import daylight.structure.sparse_table;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    auto A = new long[](N);
    reader.read(A);
    auto st = SparseTable!(long, (a, b) => min(a, b))(A);
    foreach (i; 0 .. Q) {
        int l, r;
        reader.read(l, r);
        writeln(st[l .. r]);
    }
}