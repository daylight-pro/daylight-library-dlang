module daylight.structure.wavelet_matrix;
import std;
import daylight.base;

unittest {
    auto bv = new BitVector([1, 0, 0, 1, 0, 0, 1, 1]);
    assert(bv[0] == 1);
    assert(bv[4] == 0);
    assert(bv[0 .. $] == [4, 4]);
    assert(bv[1 .. 5] == [3, 1]);
    long[] v = [200, 100, 150, 350, 50, 300];
    auto wm = new WaveletMatrix!long(v);
    assert(wm[0] == 200);
    assert(wm[3] == 350);
    assert(wm[0 .. 4].kthMin(1) == 150);
    assert(wm[0 .. $].kthMin(4) == 300);
    assert(wm[1 .. 3].kthMax(0) == 150);
    assert(wm[2 .. 5].kthMax(2) == 50);
}

// --- start ---

class BitVector {
private:
    int[] vec;
    ulong len;
public:
    this(int[] v) {
        len = v.length;
        vec = new int[len + 1];
        foreach (i; 0 .. len) {
            vec[i + 1] += vec[i];
            vec[i + 1] += v[i];
        }
    }

    int opIndex(size_t i) {
        return vec[i + 1] - vec[i];
    }

    int[] opSlice(size_t start, size_t end) {
        int r1 = vec[end] - vec[start];
        return [(end - start - r1).to!int, r1];
    }

    size_t opDollar() {
        return len;
    }

    uint select(int b, int k) {
        if (this[0 .. $][b] >= k)
            return -1;
        ulong ok = 0;
        ulong ng = len;
        while (abs(ng - ok) > 1) {
            ulong mid = (ng + ok) / 2;
            if (this[0 .. mid][b] <= k)
                ok = mid;
            else
                ng = mid;
        }
        return ok.to!uint;
    }
}

class WaveletMatrixSlice(T) {
private:
    WaveletMatrix!T matrix;
    size_t start, end;
public:
    this(WaveletMatrix!T matrix, size_t start, size_t end) {
        this.matrix = matrix;
        this.start = start;
        this.end = end;
    }

    T kthMin(int k) {
        return matrix.kthMin(start, end, k);
    }

    T kthMax(int k) {
        return matrix.kthMax(start, end, k);
    }
}

class WaveletMatrix(T) {
private:
    BitVector[] B;
    T[][] acc;
    int[] start_one;
    int[T] start_num;
    int len, bit_len;
    T base = 0;
public:
    this(ref T[] vec, bool use_acc = true) {
        foreach (e; vec)
            base.chmax(-e);
        foreach (ref e; vec)
            e += base;
        long max_el = 1;
        if (vec.length > 0)
            max_el = reduce!(max)(vec) + 1;
        bit_len = 1;
        while (1 << bit_len <= max_el)
            bit_len++;
        len = vec.length.to!int;
        if (use_acc)
            acc = new T[][](bit_len, len + 1);
        start_one = new int[](bit_len);
        T[] v = vec[0 .. $];
        foreach (b; 0 .. bit_len) {
            T[] cur;
            int[] bi = new int[](len);
            foreach (i; 0 .. len) {
                T bit = (v[i] >> (bit_len - b - 1)) & 1;
                if (bit == 0) {
                    cur ~= v[i];
                    bi[i] = 0;
                }
            }
            start_one[b] = cur.length.to!int;
            foreach (i; 0 .. len) {
                T bit = (v[i] >> T(bit_len - b - 1)) & 1;
                if (bit == 1) {
                    cur ~= v[i];
                    bi[i] = 1;
                }
            }
            B ~= new BitVector(bi);
            if (use_acc) {
                foreach (i; 0 .. len) {
                    if (B[b][i] == 0)
                        acc[b][i + 1] = v[i];
                    acc[b][i + 1] += acc[b][i];
                }
            }
            v = cur;
        }
        foreach_reverse (i; 0 .. len) {
            start_num[v[i]] = i;
        }
    }

    T opIndex(size_t i) {
        assert(i < len);
        T ret = 0;
        foreach (j; 0 .. bit_len) {
            int b = B[j][i];
            ret <<= 1;
            ret |= b;
            i = B[j][0 .. i][b];
            if (b == 1) {
                i += start_one[j];
            }
        }
        return ret - base;
    }

    WaveletMatrixSlice!T opSlice(size_t start, size_t end) {
        return new WaveletMatrixSlice!(T)(this, start, end);
    }

    size_t opDollar() {
        return len;
    }

    int rank(T c, int k) {
        c += base;
        assert(k <= len);
        assert(k >= 0);
        if (c in start_num)
            return 0;
        foreach (i; 0 .. bit_len) {
            T bit = (c >> (bit_len - i - 1)) & 1;
            k = B[i][0 .. k][bit];
            if (bit == 1) {
                k += start_one[i];
            }
        }
        return k - start_num[c];
    }

    T kthMin(ulong left, ulong right, int k) {
        assert(right - left > k);
        assert(left < right);
        T res = 0;
        foreach (i; 0 .. bit_len) {
            ulong left_rank = B[i][0 .. left][0];
            ulong right_rank = B[i][0 .. right][0];
            ulong zero_in_range = right_rank - left_rank;
            T bit = (k < zero_in_range) ? 0 : 1;
            if (bit == 1) {
                k -= zero_in_range;
                left += start_one[i] - left_rank;
                right += start_one[i] - right_rank;
            } else {
                left = left_rank.to!int;
                right = right_rank.to!int;
            }
            res <<= 1;
            res |= bit;
        }
        return res - base;
    }

    T kthMax(ulong left, ulong right, int k) {
        assert(right - left > k);
        assert(left < right);
        ulong all = right - left;
        int nk = (all - k - 1).to!int;
        return kthMin(left, right, nk);
    }
}
