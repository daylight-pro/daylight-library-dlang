module daylight.base;
import std;

// --- start ---
class Reader {
    DList!(string) buf;

    private void readNext() {
        while (buf.empty) {
            auto inputs = stdin.readln()[0 .. $ - 1].split(" ");
            foreach (token; inputs) {
                buf.insertBack(token);
            }
        }
    }

    void read()() {

    }

    void read(T, A...)(ref T t, ref A a) {
        if (buf.empty) {
            readNext();
        }
        static if (isArray!(T)) {
            foreach (ref v; t) {
                read(v);
            }
        } else {
            t = buf.front.to!T;
            buf.removeFront();
        }
        read(a);
    }
}

ref auto chmin(T)(ref T a, T b) {
    if (a > b) {
        a = b;
    }
    return a;
}

ref auto chmax(T)(ref T a, T b) {
    if (a < b) {
        a = b;
    }
    return a;
}

template bind(names...) {
    auto bind(T)(T t) {
        return tuple!(aliasSeqOf!(tuple(names)))(t.expand);
    }
}

public const int INF = 1 << 30;
public const long LINF = 2e18.to!long;
