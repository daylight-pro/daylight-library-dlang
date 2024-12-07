module test.yosupo.data_structure.predecessor;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/predecessor_problem

import std;
import daylight.base;
import daylight.structure.binary_trie;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    char[] T = new char[N];
    reader.read(T);
    auto bt = new BinaryTrie!(long)();
    foreach (i; 0 .. N) {
        if (T[i] == '1')
            bt.add(i);
    }
    while (Q--) {
        int c, k;
        reader.read(c, k);
        if (c == 0) {
            if (!(k in bt))
                bt.add(k);
        } else if (c == 1) {
            if (k in bt)
                bt.erase(k);
        } else if (c == 2) {
            (bt.count(k) > 0 ? 1 : 0).writeln;
        } else if (c == 3) {
            long cnt = bt.lowerBound(k);
            if (cnt == bt.length)
                (-1).writeln;
            else
                bt[cnt].writeln;
        } else if (c == 4) {
            long cnt = bt.upperBound(k);
            if (cnt == 0)
                (-1).writeln;
            else
                bt[cnt - 1].writeln;
        }
    }
}
