module daylight.structure.binary_trie;

import std;
// --- start ---

class BinaryTrie(T, int MAX_LOG = 32) {
    struct Node(T) {
        int[2] next = [-1, -1];
        long common = 0;
        T lz = T.init;
    }

    private Node!T[] nodes;

    this() {
        nodes ~= Node!T();
    }

    void apply_xor(T val) {
        nodes[0].lz ^= val;
    }

    private void push(int cur, int b) {
        if ((nodes[cur].lz >> T(b)) & T(1)) {
            swap(nodes[cur].next[0], nodes[cur].next[1]);
        }
        foreach (i; 0 .. 2) {
            if (nodes[cur].next[i] != -1) {
                nodes[nodes[cur].next[i]].lz ^= nodes[cur].lz;
            }
        }
        nodes[cur].lz = 0;
    }

    void add(T val, long cnt = 1) {
        add(val, cnt, 0, MAX_LOG - 1);
    }

    private void add(T val, long cnt, int cur, int b) {
        nodes[cur].common += cnt;
        if (b < 0)
            return;
        push(cur, b);
        int nxt = (val >> T(b)) & T(1);
        if (nodes[cur].next[nxt] == -1) {
            nodes[cur].next[nxt] = nodes.length.to!int;
            nodes ~= Node!T();
        }
        add(val, cnt, nodes[cur].next[nxt], b - 1);
    }

    void erase(T val, long cnt = 1) {
        add(val, -cnt, 0, MAX_LOG - 1);
    }

    T getMin(T x = 0) {
        return getMin(x, 0, MAX_LOG - 1);
    }

    private T getMin(T x, int cur, int b) {
        if (b < 0)
            return 0;
        push(cur, b);
        long nxt = (x >> T(b)) & T(1);
        int ind = nodes[cur].next[nxt];
        if (ind == -1 || nodes[ind].common == 0) {
            nxt ^= 1;
        }
        return getMin(x, nodes[cur].next[nxt], b - 1) | (T(nxt) << T(b));
    }

    T getMax(T x) {
        return getMin(~x, 0, MAX_LOG - 1);
    }

    long lowerBound(T x) {
        return lowerBound(x, 0, MAX_LOG - 1);
    }

    private long lowerBound(T val, int cur, int b) {
        if (cur == -1 || b < 0)
            return 0;
        push(cur, b);
        long nxt = (val >> T(b)) & T(1);
        long ret = lowerBound(val, nodes[cur].next[nxt], b - 1);
        if (nxt == 1 && nodes[cur].next[0] != -1) {
            ret += nodes[nodes[cur].next[0]].common;
        }
        return ret;
    }

    long upperBound(T val) {
        return lowerBound(val + 1);
    }

    T kthMin(long k) {
        return kthMin(k, 0, MAX_LOG - 1);
    }

    private T kthMin(long k, int cur, int b) {
        if (b < 0)
            return -1;
        push(cur, b);
        int lower_ind = nodes[cur].next[0];
        long lower_cnt = 0;
        if (lower_ind != -1) {
            lower_cnt = nodes[lower_ind].common;
        }
        if (k < lower_cnt) {
            return kthMin(k, nodes[cur].next[0], b - 1);
        } else {
            return kthMin(k - lower_cnt, nodes[cur].next[1], b - 1) | (T(1) << b);
        }
    }

    T kthMax(long k) {
        return kthMin(this.length - k - 1, 0, MAX_LOG - 1);
    }

    T count(T val) {
        int cur = 0;
        foreach_reverse (b; 0 .. MAX_LOG) {
            push(cur, b);
            cur = nodes[cur].next[val >> T(b) & T(1)];
            if (cur == -1)
                return 0;
        }
        return nodes[cur].common;
    }

    @property size_t length() {
        return nodes[0].common;
    }

    @property bool empty() {
        return nodes[0].common == 0;
    }

    T opIndex(size_t index) {
        return kthMin(index);
    }

    size_t opDollar() {
        return length;
    }

}
