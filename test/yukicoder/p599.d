module test.yukicoder.p599;

// competitive-verifier: PROBLEM https://yukicoder.me/problems/no/599

import std;
import acl.modint;
import daylight.base;
import daylight.string.rolling_hash;

alias mint = modint1000000007;

void main() {
    Reader reader = new Reader();
    char[] S;
    reader.read(S);
    ulong N = S.length;
    auto rh = RollingHash(S);
    auto dp = new mint[N + 1];
    dp[0] = 1;
    foreach (i; 1 .. N + 1) {
        if (i + i > N)
            break;
        foreach (j; 0 .. i) {
            if (rh[j .. i] == rh[N - j - (i - j) .. N - j]) {
                dp[i] += dp[j];
            }
        }
    }
    mint ans = 0;
    foreach (i; 0 .. N + 1) {
        ans += dp[i];
    }
    write(ans.val());
}
