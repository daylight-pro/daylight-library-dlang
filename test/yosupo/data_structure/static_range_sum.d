module test.yosupo.data_structure.static_range_sum;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/static_range_sum
import std;
import daylight.base;
import daylight.structure.wavelet_matrix;

void main() {
    Reader reader = new Reader();
    int N, Q;
    long[] A = new long[N];
    reader.read(N, Q, A);
    auto wm = new WaveletMatrix!long(A);
    foreach (i; 0 .. Q) {
        int l, r;
        reader.read(l, r);
        writeln(wm[l .. r].kMinSum(r - l));
    }
}
