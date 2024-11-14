module test.yosupo.string.zalgorithm;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/zalgorithm
import std;
import daylight.base;
import daylight.string.rolling_hash;

void main() {
    Reader reader = new Reader();
    char[] S;
    reader.read(S);
    auto rh = RollingHash(S);
    int N = S.length.to!int;
    int[] ans = new int[N];
    foreach (i; 0 .. N) {
        int len = N - i;
        int ok = 0;
        int ng = len + 1;
        while (ng - ok > 1) {
            int mid = (ng + ok) / 2;
            if (rh[0 .. mid] == rh[i .. i + mid]) {
                ok = mid;
            } else {
                ng = mid;
            }
        }
        ans[i] = ok;
    }
    ans.map!(x => x.to!string).join(" ").writeln;
}
