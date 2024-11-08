module test.yosupo.data_structure.range_kth_smallest;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/range_kth_smallest
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
        int l, r, k;
        reader.read(l, r, k);
        writeln(wm[l .. r].kthMin(k));
    }
}
