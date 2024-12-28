module daylight.structure.swag;

import std;

// --- start ---

struct FoldableStack(T, alias op, T e, bool reveresed = false) {
    struct Node {
        T value, sum;
    }

    private DList!Node st;
    ulong len = 0;

    auto opOpAssign(string o)(T value) {
        static if (o == "~") {
            if (st.empty) {
                st.insertBack(Node(value, value));
            } else {
                static if (reveresed) {
                    st.insertBack(Node(value, op(value, st.back.sum)));
                } else {
                    st.insertBack(Node(value, op(st.back.sum, value)));
                }
            }
            len++;
            return this;
        }
        assert(false, "Invalid operator");
    }

    T pop() {
        auto ret = st.back.value;
        st.removeBack();
        len--;
        return ret;
    }

    T fold() {
        if (st.empty) {
            return e;
        }

        return st.back.sum;
    }

    T top() {
        return st.back.value;
    }

    bool empty() {
        return st.empty;
    }

    ulong length() {
        return len;
    }
}

struct FoldableQueue(T, alias op, T e) {
    FoldableStack!(T, op, e, true) f;
    FoldableStack!(T, op, e) b;

    auto opOpAssign(string o)(T value) {
        static if (o == "~") {
            b ~= value;
            return this;
        }
        assert(false, "Invalid operator");
    }

    private void move() {
        while (!b.empty) {
            f ~= b.pop();
        }
    }

    T pop() {
        if (f.empty) {
            move();
        }
        return f.pop();
    }

    T fold() {
        return op(f.fold(), b.fold());
    }

    T front() {
        if (f.empty) {
            move();
        }
        return f.top();
    }

    bool empty() {
        return f.empty && b.empty;
    }

    ulong length() {
        return f.length + b.length;
    }
}

struct FoldableDeque(T, alias op, T e) {
    FoldableStack!(T, op, e, true) f;
    FoldableStack!(T, op, e) b;

    private void move() {
        if (f.empty) {
            DList!T tmp;
            ulong sz = b.length;
            foreach (_; 0 .. sz / 2) {
                tmp.insertBack(b.pop());
            }
            while (!b.empty) {
                f ~= b.pop();
            }
            while (!tmp.empty) {
                b ~= tmp.back;
                tmp.removeBack();
            }
        } else {
            DList!T tmp;
            ulong sz = f.length;
            foreach (_; 0 .. sz / 2) {
                tmp.insertBack(f.pop());
            }
            while (!f.empty) {
                b ~= f.pop();
            }
            while (!tmp.empty) {
                f ~= tmp.back;
                tmp.removeBack();
            }
        }
    }

    void insertFront(T value) {
        f ~= value;
    }

    void insertBack(T value) {
        b ~= value;
    }

    T popFront() {
        if (f.empty) {
            move();
        }
        return f.pop();
    }

    T popBack() {
        if (b.empty) {
            move();
        }
        return b.pop();
    }

    T front() {
        if (f.empty) {
            move();
        }
        return f.top();
    }

    T back() {
        if (b.empty) {
            move();
        }
        return b.top();
    }

    T fold() {
        return op(f.fold(), b.fold());
    }

    bool empty() {
        return f.empty && b.empty;
    }

    ulong length() {
        return f.length + b.length;
    }
}
