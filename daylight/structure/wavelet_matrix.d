module daylight.structure.wavelet_matrix;
import std;

unittest {
    auto bv = new BitVector([1, 0, 0, 1, 0, 0, 1, 1]);
    assert(bv[0] == 1);
    assert(bv[4] == 0);
    assert(bv[0 .. $] == [4, 4]);
    assert(bv[1 .. 5] == [3, 1]);
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
