module daylight.string.trie;

import std;

// --- start ---

class Trie(int char_size, int margin) {
    public class TrieNode(int char_size) {
        int[char_size] next;
        int exist;
        int[] _accept;

        this() {
            next[] = -1;
            exist = 0;
            _accept = new int[](0);
        }
    }

    alias Node = TrieNode!char_size;
    Node[] nodes;
    int root;
    this() {
        nodes ~= new Node();
        root = 0;
    }

    private void update_direct(int node, int id) {
        nodes[node]._accept ~= id;
    }

    private void update_child(int node, int child, int id) {
        ++nodes[node].exist;
    }

    private void add(const ref char[] str, int str_index, int node_index, int id) {
        if (str_index == str.length) {
            update_direct(node_index, id);
        } else {
            const int c = str[str_index] - margin;
            if (nodes[node_index].next[c] == -1) {
                nodes[node_index].next[c] = nodes.length.to!int;
                nodes ~= new Node();
            }
            add(str, str_index + 1, nodes[node_index].next[c], id);
            update_child(node_index, nodes[node_index].next[c], id);
        }
    }

    void add(const ref char[] str, int id = -1) {
        if (id == -1)
            id = nodes[0].exist;
        add(str, 0, 0, id);
    }

    void add(const ref string str, int id = -1) {
        auto s = str.dup;
        add(s, id);
    }

    auto opOpAssign(string op, T)(T value) {
        static if (op == "~") {
            add(value);
            return this;
        }
        assert(false, "opOpAssign: unknown operator");
    }

    private void query(const ref char[] str, void delegate(int) f, int str_index, int node_index) {
        foreach (ref idx; nodes[node_index]._accept) {
            f(idx);
        }

        if (str_index == str.length) {
            return;
        } else {
            const int c = str[str_index] - margin;
            if (nodes[node_index].next[c] == -1) {
                return;
            }
            query(str, f, str_index + 1, nodes[node_index].next[c]);
        }
    }

    void query(F)(const ref char[] str, const ref F f)
            if (isFunction!F || isDelegate!F) {
        static if (isDelegate!F) {
            query(str, f, 0, 0);
        } else {
            query(str, toDelegate(&f), 0, 0);
        }
    }

    void query(F)(const ref string str, const ref F f)
            if (isFunction!F || isDelegate!F) {
        query(str.dup, f);
    }

    ulong length() @property const {
        return nodes.length;
    }
}
