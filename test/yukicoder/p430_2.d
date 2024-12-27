module test.yukicoder.p430_2;

// competitive-verifier: PROBLEM https://yukicoder.me/problems/no/430
import std;
import daylight.base;
import daylight.string.aho_corasick;

void main() {
    Reader reader = new Reader();
    char[] S;
    reader.read(S);
    int M;
    reader.read(M);
    auto aho = new AhoCorasick!(26, 'A');
    foreach (i; 0 .. M) {
        char[] s;
        reader.read(s);
        aho ~= s;
    }
    aho.build();
    auto result = aho.match(S);
    long ans = 0;
    foreach (k, v; result) {
        ans += v;
    }
    writeln(ans);
}
