module test.yosupo.data_structure.static_range_frequency;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/static_range_frequency
import std;
import daylight.base;
import daylight.structure.wavelet_matrix;

void main() {
    Reader reader = new Reader();
    int N, Q;
    reader.read(N, Q);
    long[] A = new long[N];
    reader.read(A);
    auto wm = new WaveletMatrix!long(A);
    foreach (i; 0 .. Q) {
        int l, r, x;
        reader.read(l, r, x);
        writeln(wm[l .. r].rangeFreq(x));
    }
}
