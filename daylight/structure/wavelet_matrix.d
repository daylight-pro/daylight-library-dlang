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
    private int[] vec;
    private ulong len;

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
    private WaveletMatrix!T matrix;
    private size_t start, end;

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

    T kMinSum(int k) {
        return matrix.kMinSum(start, end, k);
    }

    T kMaxSum(int k) {
        return matrix.kMaxSum(start, end, k);
    }

    int lessCount(T upper) {
        return matrix.lessCount(start, end, upper);
    }

    int lessEqualCount(T upper) {
        return matrix.lessEqualCount(start, end, upper);
    }

    int greaterEqualCount(T lower) {
        return matrix.greaterEqualCount(start, end, lower);
    }

    int greaterCount(T lower) {
        return matrix.greaterCount(start, end, lower);
    }

    T greaterEqualKthMin(T lower, int k) {
        return matrix.greaterEqualKthMin(start, end, lower, k);
    }

    T greaterKthMin(T lower, int k) {
        return matrix.greaterKthMin(start, end, lower, k);
    }

    T lessKthMax(T upper, int k) {
        return matrix.lessKthMax(start, end, upper, k);
    }

    T lessEqualKthMax(T upper, int k) {
        return matrix.lessEqualKthMax(start, end, upper, k);
    }

    T lessKMaxSum(T upper, int k) {
        return matrix.lessKMaxSum(start, end, upper, k);
    }

    T lessEqualKMaxSum(T upper, int k) {
        return matrix.lessEqualKMaxSum(start, end, upper, k);
    }

    T greaterKMinSum(T lower, int k) {
        return matrix.greaterKMinSum(start, end, lower, k);
    }

    T greaterEqualKMinSum(T lower, int k) {
        return matrix.greaterEqualKMinSum(start, end, lower, k);
    }

    int valueRangeCount(T lower, T upper) {
        return matrix.valueRangeCount(start, end, lower, upper);
    }

    T valueRangeSum(T lower, T upper) {
        return matrix.valueRangeSum(start, end, lower, upper);
    }

    int rangeFreq(T v) {
        return matrix.rangeFreq(start, end, v);
    }
}

class WaveletMatrix(T) {
    private BitVector[] B;
    private T[][] acc;
    private int[] start_one;
    private int[T] start_num;
    private int len, bit_len;
    private T base = 0;

    this(ref T[] vec, bool use_acc = true) {
        foreach (e; vec)
            base.chmax(-e);
        foreach (ref e; vec)
            e += base;
        long max_el = 1;
        if (vec.length > 0)
            max_el = reduce!(max)(vec) + 1;
        bit_len = bsr(max_el) + 1;
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
        enforce(i < len, "Index out of bounds.");
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
        enforce(k <= len);
        assert(k >= 0);
        if (!(c in start_num))
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

    T kMinSum(ulong left, ulong right, int k) {
        int original_k = k;
        assert(right - left >= k);
        if (k == 0)
            return 0;
        long kth = 0, ret = 0;
        foreach (i; 0 .. bit_len) {
            ulong left_rank = B[i][0 .. left][0];
            ulong right_rank = B[i][0 .. right][0];
            ulong zero_in_range = right_rank - left_rank;
            T bit = (k < zero_in_range) ? 0 : 1;
            if (bit == 1) {
                ret += acc[i][right] - acc[i][left];
                k -= zero_in_range;
                left += start_one[i] - left_rank;
                right += start_one[i] - right_rank;
            } else {
                left = left_rank;
                right = right_rank;
            }
            kth <<= 1;
            kth |= bit;
        }
        ret += kth * k;
        return ret - base * original_k;
    }

    T kMaxSum(ulong left, ulong right, int k) {
        assert(right - left >= k);
        if (k == 0)
            return 0;
        assert(left < right);
        return kMinSum(left, right, (right - left).to!int) - kMinSum(left, right, (right - left - k)
                .to!int);
    }

    int lessCount(ulong left, ulong right, T upper) {
        upper += base;
        assert(left <= right);
        long ret = 0;
        if (left == right)
            return 0;
        if (upper >= (1.to!T << bit_len)) {
            return (right - left).to!int;
        }
        foreach (i; 0 .. bit_len) {
            ulong left_rank = B[i][0 .. left][0];
            ulong right_rank = B[i][0 .. right][0];
            ulong zero_in_range = right_rank - left_rank;
            ulong bit = (upper >> (bit_len - i - 1)) & 1;
            if (bit == 1) {
                ret += zero_in_range;
                left += start_one[i] - left_rank;
                right += start_one[i] - right_rank;
            } else {
                left = left_rank.to!int;
                right = right_rank.to!int;
            }
        }
        return ret.to!int;
    }

    int lessEqualCount(ulong left, ulong right, T upper) {
        assert(left <= right);
        return lessCount(left, right, upper) + rangeFreq(left, right, upper);
    }

    int greaterCount(ulong left, ulong right, T lower) {
        assert(left <= right);
        return (right - left).to!int - lessEqualCount(left, right, lower);
    }

    int greaterEqualCount(ulong left, ulong right, T lower) {
        assert(left <= right);
        return (right - left).to!int - lessCount(left, right, lower);
    }

    T greaterEqualKthMin(ulong left, ulong right, T lower, int k) {
        assert(left < right);
        int cnt = lessCount(left, right, lower);
        return kthMin(left, right, k + cnt);
    }

    T greaterKthMin(ulong left, ulong right, T lower, int k) {
        assert(left < right);
        int cnt = lessEqualCount(left, right, lower);
        return kthMin(left, right, k + cnt);
    }

    T lessKthMax(ulong left, ulong right, T upper, int k) {
        assert(left < right);
        int cnt = lessCount(left, right, upper);
        return kthMin(left, right, cnt - k - 1);
    }

    T lessEqualKthMax(ulong left, ulong right, T upper, int k) {
        assert(left < right);
        int cnt = lessEqualCount(left, right, upper);
        return kthMin(left, right, cnt - k - 1);
    }

    T lessKMaxSum(ulong left, ulong right, T upper, int k) {
        assert(left < right);
        int cnt = greaterEqualCount(left, right, upper);
        return kMaxSum(left, right, cnt + k) - kMaxSum(left, right, cnt);
    }

    T lessEqualKMaxSum(ulong left, ulong right, T upper, int k) {
        assert(left < right);
        int cnt = greaterCount(left, right, upper);
        return kMaxSum(left, right, cnt + k) - kMaxSum(left, right, cnt);
    }

    T greaterKMinSum(ulong left, ulong right, T lower, int k) {
        assert(left < right);
        int cnt = lessEqualCount(left, right, lower);
        return kMinSum(left, right, cnt + k) - kMinSum(left, right, cnt);
    }

    T greaterEqualKMinSum(ulong left, ulong right, T lower, int k) {
        assert(left < right);
        int cnt = lessCount(left, right, lower);
        return kMinSum(left, right, cnt + k) - kMinSum(left, right, cnt);
    }

    int valueRangeCount(ulong left, ulong right, T lower, T upper) {
        assert(left <= right);
        return lessCount(left, right, upper) - lessCount(left, right, lower);
    }

    T valueRangeSum(ulong left, ulong right, T lower, T upper) {
        assert(left <= right);
        int less = lessCount(left, right, lower);
        int greater = greaterEqualCount(left, right, upper);
        return kMaxSum(left, right, (right - left).to!int) - kMaxSum(left, right, greater) - kMinSum(left, right, less);
    }

    int rangeFreq(ulong l, ulong r, T v) {
        assert(0 <= l && l <= r && r <= len);
        return rank(v, r.to!int) - rank(v, l.to!int);
    }
}
