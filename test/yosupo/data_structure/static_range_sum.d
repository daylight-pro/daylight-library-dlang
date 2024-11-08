module test.yosupo.data_structure.static_range_sum;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/static_range_sum
import std;
import daylight.base;
import daylight.structure.wavelet_matrix;

void main() {
    Reader reader = new Reader();
    int N, Q;
    long[] A(N);
    reader.read(N, Q, A);
    auto wm = new WaveletMatrix!long(A);
    foreach (i; 0 .. Q) {
        int l = reader.read!int();
        int r = reader.read!int();
        writeln(wm[l .. r].kMinSum(r - l));
    }
}
