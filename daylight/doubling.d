module daylight.doubling;

unittest {
    auto db = new Doubling!(true)([1, 2, 3, 4, 0]);
}

import std;

// --- start ---

class DoublingFrom(T = long) {
    private Doubling!(T) db;
    private int from;
    private long walk_len;
    this(Doubling!(T) db, int from) {
        this.db = db;
        this.from = from;
    }

    ref auto walk(long walk_len) {
        this.walk_len = walk_len;
        return this;
    }

    int get() {
        return db.get(walk_len, from.to!int);
    }

    static if (!is(T == void)) {
        long prod() {
            return db.prod(walk_len, from.to!int);
        }

        long max_walk(bool function(T) f) {
            return db.max_walk(from, f);
        }

        long min_walk(bool function(T) f, long limit = long.max / 2) {
            return db.min_walk(from, f, limit);
        }
    }
}

class Doubling(T = void) {
    private ulong N;
    private int[][] V;
    static if (!is(T == void)) {
        private T[][] S;
        private T[] s;
        private T delegate(T, T) op;
        private T delegate() e;
    }

    this(int[] v) {
        this.N = v.length;
        foreach (i; v) {
            enforce(0 <= i && i < N);
        }
        V ~= v;
        foreach (i; 0 .. N) {
            V[0][i] = v[i];
        }
    }

    private void buildNext() {
        ulong n = V.length;
        V ~= new int[N];
        static if (!is(T == void)) {
            S ~= new T[N];
        }
        foreach (i; 0 .. N) {
            V[n][i] = V[n - 1][V[n - 1][i]];
            static if (!is(T == void)) {
                S[n][i] = op(S[n - 1][i], S[n - 1][V[n - 1][i]]);
            }
        }
    }

    ref auto opIndex(size_t index) {
        enforce(0 <= index && index <= N);
        return new DoublingFrom!(T)(this, index.to!int);
    }

    int get(long L, int x) {
        int ret = x;
        for (int i = 0; L > 0L; i++) {
            if (i >= V.length)
                buildNext();
            if (L & 1L)
                ret = V[i][ret];
            L >>= 1L;
        }
        return ret;
    }

    static if (!is(T == void)) {
        void setMonoid(const T[] _s, T delegate(T, T) _op, T delegate() _e) {
            enforce(_s.length == N);
            op = _op;
            e = _e;
            s = _s.dup;
            S.length = 0;
            S ~= new T[N];
            foreach (i; 0 .. N)
                S[0][i] = s[i];
        }

        T prod(long L, int x) {
            enforce(s.length == N);
            int cur = x;
            T ret = e();
            for (int i = 0; L > 0L; i++) {
                if (i >= V.length)
                    buildNext();
                if (L & 1L) {
                    ret = op(ret, S[i][cur]);
                    cur = V[i][cur];
                }
                L >>= 1L;
            }
            return ret;
        }

        long max_walk(int x, bool function(T) f) {
            long ok = 0;
            long ng = 1;
            while (f(prod(ng, x))) {
                ng *= 2;
            }
            while (ng - ok > 1) {
                long mid = (ng + ok) / 2;
                if (f(prod(mid, x))) {
                    ok = mid;
                } else {
                    ng = mid;
                }
            }
            return ok;
        }

        long min_walk(int x, bool function(T) f, long limit = long.max / 2) {
            long ng = -1;
            long ok = 1;
            while (!f(prod(ok, x))) {
                if (ok >= long.max / 2) {
                    ok = long.max / 2;
                    break;
                }
                ok *= 2;
            }
            while (ok - ng > 1) {
                long mid = (ok + ng) / 2;
                if (f(prod(mid, x))) {
                    ok = mid;
                } else {
                    ng = mid;
                }

            }
            return ok;
        }
    }
}
