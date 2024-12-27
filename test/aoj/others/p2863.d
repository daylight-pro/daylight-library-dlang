module test.aoj.others.p2863;

// competitive-verifier: PROBLEM "https://onlinejudge.u-aizu.ac.jp/problems/2863"

import std;
import daylight.base;
import acl.modint;
import daylight.string.aho_corasick;

alias mint = modint1000000007;

void main() {
    Reader reader = new Reader();
    int N;
    reader.read(N);
    auto aho = new AhoCorasick!(26, 'a');
    int[] len = new int[](N);
    foreach (i; 0 .. N) {
        char[] s;
        reader.read(s);
        len[i] = s.length.to!int;
        aho ~= s;
    }
    aho.build();

    char[] T;
    reader.read(T);

    int now = 0;
    int n = T.length.to!int;
    mint[] dp = new mint[](n + 1);
    dp[0] = 1;
    foreach (i; 0 .. n) {
        long res;
        int nxt;
        AliasSeq!(res, nxt) = aho.move(T[i], now);
        auto match = aho.match(T[i], now);
        now = nxt;
        foreach (v; match) {
            dp[i + 1] += dp[i + 1 - len[v]];
        }
    }
    dp[n].val.writeln;
}
