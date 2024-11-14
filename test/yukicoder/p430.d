module test.yukicoder.p430;

// competitive-verifier: PROBLEM https://yukicoder.me/problems/no/430
import std;
import daylight.base;
import daylight.string.rolling_hash;

void main() {
    Reader reader = new Reader();
    char[] S;
    reader.read(S);
    long[ulong] mp;
    auto rh = RollingHash(S);
    int N = S.length.to!int;
    foreach (i; 0 .. N) {
        foreach (j; 0 .. min(10, N - i)) {
            mp[rh[i .. i + j + 1]]++;
        }
    }
    int M;
    reader.read(M);
    long ans = 0;
    foreach (i; 0 .. M) {
        char[] C;
        reader.read(C);
        auto rc = RollingHash(C);
        ans += mp.get(rc[0 .. $], 0);
    }
    writeln(ans);
}
