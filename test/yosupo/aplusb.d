module test.yosupo.aplusb;

// verification-helper: PROBLEM https://judge.yosupo.jp/problem/aplusb
import std;
import daylight.base;

void main() {
    Reader reader = new Reader();
    int a, b;
    reader.read(a, b);
    writeln(a + b);
}
