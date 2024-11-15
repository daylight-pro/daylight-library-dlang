module test.yosupo.data_structure.point_set_range_frequency;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/point_set_range_frequency
import std;
import daylight.base;
import daylight.structure.binary_trie;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    auto bt = new BinaryTrie!(ulong, 64)();
    ulong[] A = new ulong[N];
    reader.read(A);
    foreach (i; 0 .. N) {
        bt.add(A[i] * N + i);
    }
    while (Q--) {
        int t;
        reader.read(t);
        if (t == 0) {
            int k;
            ulong v;
            reader.read(k, v);
            bt.erase(A[k] * N + k);
            A[k] = v;
            bt.add(A[k] * N + k);
        } else {
            int l, r;
            ulong x;
            reader.read(l, r, x);
            (bt.lowerBound(x * N + r) - bt.lowerBound(x * N + l)).writeln;
        }
    }
}
