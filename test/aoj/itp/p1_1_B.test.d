module test.itp.p1_1_B.test;

// verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ITP1_1_B
import daylight.base;
import std.stdio;

void main() {
    Reader reader = new Reader();
    int x;
    reader.read(x);
    writeln(x * x * x);
}
