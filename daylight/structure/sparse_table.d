module daylight.structure.sparse_table;
import std;

struct SparseTable(T, alias op) {
    private T[][] st;
    private int[] lg;
    private ulong n;

    this(const ref T[] a) {
        n = a.length;
        lg = new int[n + 1];
        lg[1] = 0;
        foreach (i; 2 .. n + 1) {
            lg[i] = lg[i >> 1] + 1;
        }
        st = new T[][](lg[n] + 1, n);
        foreach (i; 0 .. n) {
            st[0][i] = a[i];
        }
        foreach (i; 1 .. lg[n] + 1) {
            foreach (j; 0 .. n) {
                if (j + (1 << i) <= n) {
                    st[i][j] = op(st[i - 1][j], st[i - 1][j + (1 << (i - 1))]);
                } else {
                    st[i][j] = st[i - 1][j];
                }
            }
        }
    }

    T opSlice(size_t l, size_t r) {
        auto i = lg[r - l];
        return op(st[i][l], st[i][r - (1 << i)]);
    }
}
