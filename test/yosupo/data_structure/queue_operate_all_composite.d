module test.yosupo.data_structure.queue_operate_all_composite;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/queue_operate_all_composite

import std;
import daylight.base;
import daylight.structure.swag;
import acl.modint;

alias mint = modint998244353;

void main() {
    Reader reader = new Reader();
    int Q;
    reader.read(Q);
    alias T = Tuple!(mint, mint);
    FoldableQueue!(T, (a, b) => T(a[0] * b[0], a[1] * b[0] + b[1]), T(
            mint(1), mint(0)
    )) swag;
    while (Q--) {
        int t;
        reader.read(t);
        if (t == 0) {
            int a, b;
            reader.read(a, b);
            swag ~= Tuple!(mint, mint)(mint(a), mint(b));
        } else if (t == 1) {
            swag.pop();
        } else {
            int x;
            reader.read(x);
            auto p = swag.fold();
            (mint(x) * p[0] + p[1]).val.writeln;
        }
    }

}
