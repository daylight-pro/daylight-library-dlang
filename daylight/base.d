module daylight.base;
import std;

// --- start ---
class Reader {
    string[] buf;

private:
    void readNext() {
        while (buf.empty) {
            auto inputs = stdin.readln()[0 .. $ - 1].split(" ");
            buf ~= inputs;
        }
    }

public:
    T read(T)() {
        if (buf.empty) {
            readNext();
        }
        T ret = buf[0].to!T;
        buf = buf[1 .. $];
        return ret;
    }

    T[] read(T)(int n) {
        T[] ret;
        foreach (i; 0 .. n) {
            ret ~= read!T();
        }
        return ret;
    }

    T[][] read(T)(int n, int m) {
        T[][] ret;
        foreach (i; 0 .. n) {
            ret ~= read!T(m);
        }
        return ret;
    }
}

bool chmin(ref T a, T b) {
    if (a > b) {
        a = b;
        return true;
    }
    return false;
}

bool chmax(ref T a, T b) {
    if (a < b) {
        a = b;
        return true;
    }
    return false;
}
