module test.yosupo.data_structure.set_xor_min;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/set_xor_min
import std;
import daylight.base;
import daylight.structure.binary_trie;

void main() {
    Reader reader = new Reader();
    int Q;
    reader.read(Q);
    auto bt = new BinaryTrie!long();
    while (Q--) {
        int t;
        reader.read(t);
        int x;
        reader.read(x);
        if (t == 0) {
            if (x in bt)
                continue;
            bt.add(x);
        } else if (t == 1) {
            if (!(x in bt))
                continue;
            bt.erase(x);
        } else {
            (bt.getMin(x) ^ x).writeln;
        }
    }
}
