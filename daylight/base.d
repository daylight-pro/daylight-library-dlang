module daylight.base;
import std;

// --- start ---
class Reader {
    DList!(string) buf;

private:
    void readNext() {
        while (buf.empty) {
            auto inputs = stdin.readln()[0 .. $ - 1].split(" ");
            foreach (token; inputs) {
                buf.insertBack(token);
            }
        }
    }

public:
    void read()() {

    }

    void read(T, A...)(ref T t, ref A a) {
        if (buf.empty) {
            readNext();
        }
        if (__traits(hasMember, T, "length")) {
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

bool chmin(T)(ref T a, T b) {
    if (a > b) {
        a = b;
        return true;
    }
    return false;
}

bool chmax(T)(ref T a, T b) {
    if (a < b) {
        a = b;
        return true;
    }
    return false;
}
