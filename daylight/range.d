module daylight.range;

import std;

// --- start ---

struct Range(T) {
    Nullable!T l, r;
    char[2] boundary = "[)";
    int id = -1;

    // -1: this < r
    // 0: this == r
    // 1: this > r
    int compareLeft(const ref Range!T other) const {
        if (!l.isNull && other.l.isNull)
            return 1;
        if (l.isNull && !other.l.isNull)
            return -1;
        if (l.isNull && other.l.isNull)
            return 0;
        if (l.get < other.l.get)
            return -1;
        if (l.get > other.l.get)
            return 1;
        if (boundary[0] == '(' && other.boundary[0] == '[')
            return -1;
        if (boundary[0] == '[' && other.boundary[0] == '(')
            return 1;
        return 0;
    }

    int compareRight(const ref Range!T other) const {
        if (!r.isNull && other.r.isNull)
            return -1;
        if (r.isNull && !other.r.isNull)
            return 1;
        if (r.isNull && other.r.isNull)
            return 0;
        if (r.get < other.r.get)
            return -1;
        if (r.get > other.r.get)
            return 1;
        if (boundary[1] == ']' && other.boundary[1] == ')')
            return -1;
        if (boundary[1] == ')' && other.boundary[1] == ']')
            return 1;
        return 0;
    }

    int opCmp(const ref Range!T other) const {
        int cmpL = compareLeft(other);
        if (cmpL != 0)
            return cmpL;
        return compareRight(other);
    }

    bool cross(const ref Range!T other) const {
        Range!T a = this;
        Range!T b = other;
        if (a.compareLeft(b) == -1)
            swap(a, b);
        if ((a.r.isNull) || (b.l.isNull))
            return true;
        return a.r.get > b.l.get;
    }

    bool contact(const ref Range!T other) const {
        Range!T a = this;
        Range!T b = other;
        if (a.compareLeft(b) == 1)
            swap(a, b);
        if ((a.r.isNull) || (b.l.isNull))
            return true;
        return a.r.get > b.l.get || ((a.boundary[1] == ']' || b.boundary[0] == '[') && a.r.get == b
                .l.get);
    }

    bool contains(const ref Range!T other) const {
        int leftcmp = compareLeft(other);
        int rightcmp = compareRight(other);
        return leftcmp != 1 && rightcmp != -1;
    }

    bool contained(const ref Range!T other) const {
        return other.contains(this);
    }

    bool contains(const T x) const {
        auto r = Range!T(x, x, "[]");
        return contains(r);
    }

    void extendLeft(const Range!T other) {
        if (compareLeft(other) == 1) {
            auto ret = other.l;
            if (ret.isNull) {
                this.l.nullify();
            } else {
                this.l = other.l;
                this.boundary[0] = other.boundary[0];
            }
        }
    }

    void extendRight(const Range!T other) {
        if (compareRight(other) == -1) {
            auto ret = other.r;
            if (ret.isNull) {
                this.r.nullify();
            } else {
                this.r = other.r;
                this.boundary[1] = other.boundary[1];
            }
        }
    }

    void merge(const Range!T other) {
        extendLeft(other);
        extendRight(other);
    }

    T countIntegerPoint() const {
        if (l.isNull || r.isNull)
            return 0;
        T ret = r.get - l.get - 1;
        if (boundary[0] == '[')
            ret++;
        if (boundary[1] == ']')
            ret++;
        return max(ret, T.init);
    }

    T countMiddlePoint() const {
        if (l.isNull || r.isNull)
            return 0;

        return max(r.get - l.get, T.init);
    }

    Range!T intersect(const Range!T other) const {
        Range!T ret = other;
        if (compareLeft(other) == 1) {
            ret.l = l;
            ret.boundary[0] = boundary[0];
        }
        if (compareRight(other) == -1) {
            ret.r = r;
            ret.boundary[1] = boundary[1];
        }
        return ret;
    }

    bool empty() const {
        if (l.isNull || r.isNull)
            return false;
        return l.get == r.get && (boundary[0] == ')' || boundary[1] == '(');
    }

    bool opEquals(const ref Range!T other) const {
        return l == other.l && r == other.r && boundary == other.boundary;
    }

    size_t toHash() const @nogc @safe pure nothrow {
        size_t h = 0;
        if (!l.isNull)
            h = std.hashOf(l.get, h);
        if (!r.isNull)
            h = std.hashOf(r.get, h);
        h = std.hashOf(boundary, h);
        return h;
    }

    Range!T dup() const {
        return Range!T(l, r, boundary, id);
    }

    this(Nullable!T l, Nullable!T r, char[2] boundary = "[)", int id = -1) {
        this.l = l;
        this.r = r;
        this.boundary = boundary;
        this.id = id;
    }

    this(T l, T r, char[2] boundary = "[)", int id = -1) {
        this.l = nullable(l);
        this.r = nullable(r);
        this.boundary = boundary;
        this.id = id;
    }

    string toString() const {
        string lstr = l.isNull ? "-inf" : l.get.to!string;
        string rstr = r.isNull ? "inf" : r.get.to!string;
        return format("%s%s, %s%s", boundary[0], lstr, rstr, boundary[1]);
    }
}
