module test.yosupo.data_structure.range_kth_smallest;

// competitive-verifier: PROBLEM https://judge.yosupo.jp/problem/range_kth_smallest
import std;
import daylight.base;
import daylight.structure.wavelet_matrix;

void main() {
    Reader reader = new Reader();
    int N = reader.read!int();
    int Q = reader.read!int();
    long[] A = reader.read!long(N);
    auto wm = new WaveletMatrix!long(A);
    foreach (i; 0 .. Q) {
        int l = reader.read!int();
        int r = reader.read!int();
        int k = reader.read!int();
        writeln(wm[l .. r].kthMin(k));
    }
}
