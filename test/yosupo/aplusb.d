module test.yosupo.aplusb;

// verification-helper: PROBLEM https://judge.yosupo.jp/problem/aplusb
import std;
import daylight.base;

void main() {
    Reader reader = new Reader();
    int a = reader.read!int();
    int b = reader.read!int();
    writeln(a + b);
}
