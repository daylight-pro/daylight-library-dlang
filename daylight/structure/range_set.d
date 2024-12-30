module daylight.structure.range_set;
import std;

// --- start ---
import daylight.range;

class RangeSet(T) {
    private RedBlackTree!(Range!T) ranges;

    this() {
        ranges = new RedBlackTree!(Range!T)();
    }

    Nullable!(Range!T) add(Range!T r) {
        if (contains(r) || r.empty())
            return Nullable!(Range!T)();
        auto ra = ranges.lowerBound(r);
        if (!ra.empty()) {
            auto it = ra.back;
            if (it.contact(r)) {
                r.merge(it);
                ranges.removeKey(it);
            }
        }
        Range!T[] to_erase = new Range!T[](0);
        auto upper = ranges.upperBound(Range!T(r.l, r.l, "[)"));
        foreach (it; upper) {
            if (it.contact(r)) {
                r.merge(it);
                to_erase ~= it;
            } else {
                break;
            }
        }
        foreach (it; to_erase) {
            ranges.removeKey(it);
        }
        ranges.insert(r);
        return nullable(r);
    }

    void remove(Range!T r) {
        auto it = ranges.lowerBound(r);
        Range!T[] to_erase = new Range!T[](0);
        Range!T[] to_add = new Range!T[](0);
        if (!it.empty()) {
            auto ra = it.back;
            if (ra.contact(r)) {
                to_erase ~= ra;
                Range!T tmp = ra;
                auto ret = r.l;
                if (!ret.isNull) {
                    tmp.r = ret.get;
                    tmp.boundary[1] = r.boundary[0] == '[' ? ')' : ']';
                }
                if (!tmp.empty()) {
                    to_add ~= tmp;
                }
                tmp = ra;
                ret = r.r;
                if (!ret.isNull) {
                    tmp.l = ret.get;
                    tmp.boundary[0] = r.boundary[1] == ']' ? '(' : '[';
                }
            } else if (r.l.isNull) {
                to_erase ~= ra;
            } else {
                if (ra.r.isNull || r.l.get < ra.r.get) {
                    to_erase ~= ra;
                    Range!T tmp = ra;
                    tmp.r = r.l.get;
                    tmp.boundary[1] = r.boundary[0] == '[' ? ')' : ']';
                    if (!tmp.empty()) {
                        to_add ~= tmp;
                    }
                }
            }
        }
        auto upper = ranges.upperBound(Range!T(r.l, r.l, "[)"));
        foreach (i; upper) {
            if (!r.contact(i)) {
                break;
            }
            if (r.contains(i)) {
                to_erase ~= i;
            } else {
                to_erase ~= i;
                if (!r.r.isNull) {
                    Range!T tmp = i;
                    tmp.l = i.l;
                    tmp.boundary[0] = r.boundary[1] == ']' ? '(' : '[';
                    if (!tmp.empty()) {
                        to_add ~= tmp;
                    }
                }
            }
        }
        foreach (e; to_erase) {
            ranges.removeKey(e);
        }
        foreach (e; to_add) {
            ranges.insert(e);
        }
    }

    Nullable!(Range!T) opIndex(T x) const {
        auto r = Range!T(nullable(x), nullable(x), "[]");
        auto lower = ranges.lowerBound(Range!T(nullable(x), nullable(x), "[]"));
        auto upper = ranges.upperBound(Range!T(nullable(x), nullable(x), "[)"));
        if (!upper.empty()) {
            auto R = upper.front.dup;
            if (R.contains(r)) {
                return nullable(R);
            }
        }
        if (!lower.empty()) {
            auto R = lower.back.dup;
            if (R.contains(r)) {
                return nullable(R);
            }
        }
        return Nullable!(Range!T)();
    }

    bool contains(Range!T r) const {
        if (r in ranges) {
            return true;
        }
        auto lower = ranges.lowerBound(r);
        auto upper = ranges.upperBound(r);
        if (!upper.empty()) {
            if (upper.front.contains(r)) {
                return true;
            }
        }
        if (!lower.empty()) {
            if (lower.back.contains(r)) {
                return true;
            }
        }
        return false;
    }

    int[] containsRangeList(Range!T r) const {
        if (r in ranges) {
            return [r.id];
        }
        int[] ret = new int[](0);
        auto lower = ranges.lowerBound(r);
        if (!lower.empty()) {
            auto R = lower.back();
            if (R.contains(r)) {
                ret ~= R.id;
            }
        }
        auto upper = ranges.upperBound(r);
        while (!upper.empty()) {
            auto R = ranges.front();
            if (!r.contains(R)) {
                break;
            }
            ret ~= R.id;
            upper.popFront();
        }
        return ret;
    }

    int[] crossRangeList(Range!T r) const {
        int[] ret = new int[](0);
        if (r in ranges) {
            ret ~= r.id;
        }
        auto lower = ranges.lowerBound(r);
        if (!lower.empty()) {
            auto R = lower.back();
            if (R.cross(r)) {
                ret ~= R.id;
            }
        }
        auto upper = ranges.upperBound(r);
        while (!upper.empty()) {
            auto R = upper.front();
            if (!r.cross(R)) {
                break;
            }
            ret ~= R.id;
            upper.popFront();
        }
        return ret;
    }

    int[] contactRangeList(Range!T r) const {
        int[] ret = new int[](0);
        if (r in ranges) {
            ret ~= r.id;
        }
        auto lower = ranges.lowerBound(r);
        if (!lower.empty()) {
            auto R = lower.back();
            if (R.contact(r)) {
                ret ~= R.id;
            }
        }
        auto upper = ranges.upperBound(r);
        while (!upper.empty()) {
            auto R = upper.front();
            if (!r.contact(R)) {
                break;
            }
            ret ~= R.id;
            upper.popFront();
        }
        return ret;
    }

    T countIntegerPoint(Range!T r) const {
        if (r in ranges) {
            return r.countIntegerPoint();
        }
        auto lower = ranges.lowerBound(r);
        T ret = 0;
        if (!lower.empty()) {
            auto R = lower.back();
            if (R.contact(r)) {
                auto RR = r.intersect(R);
                ret += RR.countIntegerPoint();
            }
        }
        auto upper = ranges.upperBound(r);
        while (!upper.empty()) {
            auto R = upper.front();
            if (!r.contact(R)) {
                break;
            }
            auto RR = r.intersect(R);
            ret += RR.countIntegerPoint();
            upper.popFront();
        }
        return ret;
    }

    T countMiddlePoint(Range!T r) const {
        if (r in ranges) {
            return r.countMiddlePoint();
        }
        auto lower = ranges.lowerBound(r);
        T ret = 0;
        if (!lower.empty()) {
            auto R = lower.back();
            if (R.contact(r)) {
                auto RR = r.intersect(R);
                ret += RR.countMiddlePoint();
            }
        }
        auto upper = ranges.upperBound(r);
        while (!upper.empty()) {
            auto R = upper.front();
            if (!r.contact(R)) {
                break;
            }
            auto RR = r.intersect(R);
            ret += RR.countMiddlePoint();
            upper.popFront();
        }
        return ret;
    }

    Nullable!(T) mex(T x) const {
        auto R = this[x];
        if (R.isNull) {
            return nullable(x);
        }
        if (R.get.r.isNull)
            return Nullable!(T)();
        int ans = R.get.r.get;
        if (R.get.boundary[1] == ']')
            ans++;
        return nullable(ans);
    }

    bool same(T x, T y) const {
        auto Rx = this[x];
        auto Ry = this[y];
        if (Rx.isNull || Ry.isNull)
            return x == y;
        return Rx.get == Ry.get;
    }

    override string toString() const {
        string ret = "";
        bool first = true;
        foreach (r; ranges) {
            if (first) {
                first = false;
            } else {
                ret ~= ",";
            }
            ret ~= r.toString;
        }
        return ret;
    }
}
