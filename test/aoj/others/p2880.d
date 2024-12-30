module test.aoj.others.p2880;

// competitive-verifier: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=2880

import std;
import daylight.base;
import daylight.range;
import daylight.structure.range_set;

alias PQueue(T, alias less = "a < b") = BinaryHeap!(Array!T, less);

void main() {
    Reader reader = new Reader();
    int N, M, Q;
    reader.read(N, M, Q);
    PQueue!(Tuple!(int, int, int), "b[0] < a[0]") event;
    PQueue!(Tuple!(int, int), "b[0] < a[0]") query;

    foreach (i; 0 .. M) {
        int D, A, B;
        reader.read(D, A, B);
        event.insert(tuple(D, A, B));
    }
    Tuple!(int, int)[] q;
    foreach (i; 0 .. Q) {
        int E, S, T;
        reader.read(E, S, T);
        query.insert(tuple(E, i));
        q ~= tuple(S, T);
    }
    bool[] ans = new bool[Q];
    auto range_set = new RangeSet!int();
    while (!query.empty) {
        int E, i, S, T;
        AliasSeq!(E, i) = query.front;
        AliasSeq!(S, T) = q[i];
        query.popFront();
        while (!event.empty && event.front[0] < E) {
            auto e = event.front;
            event.popFront();
            range_set.add(Range!int(e[1], e[2], "[]"));
        }
        ans[i] = S >= T || range_set.same(S, T);
    }
    foreach (e; ans) {
        writeln(e ? "Yes" : "No");
    }
}
