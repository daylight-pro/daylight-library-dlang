module daylight.string.aho_corasick;
import std;

// --- start ---
import daylight.string.trie;

class AhoCorasick(size_t char_size, size_t margin) : Trie!(char_size + 1, margin) {
    const int FAIL = char_size;
    long[] correct;

    void build(bool heavy = true) {
        correct = new long[](nodes.length);
        foreach (i; 0 .. nodes.length) {
            correct[i] = nodes[i]._accept.length;
        }
        DList!(int) que;
        foreach (i; 0 .. char_size) {
            if (~nodes[0].next[i]) {
                nodes[nodes[0].next[i]].next[FAIL] = 0;
                que.insertBack(nodes[0].next[i]);
            } else {
                nodes[0].next[i] = 0;
            }
        }
        while (!que.empty) {
            auto now = this.nodes[que.front];
            int fail = now.next[FAIL];
            correct[que.front] += correct[fail];
            que.removeFront();
            foreach (c; 0 .. char_size) {
                if (~now.next[c]) {
                    nodes[now.next[c]].next[FAIL] = nodes[fail].next[c];
                    if (heavy) {
                        auto v = nodes[nodes[fail].next[c]]._accept;
                        foreach (ref n; v) {
                            nodes[now.next[c]]._accept ~= n;
                        }
                    }
                    que.insertBack(now.next[c]);
                } else {
                    now.next[c] = nodes[fail].next[c];
                }
            }
        }
    }

    int[] match(const ref char c, int now = 0) {
        int[] res = new int[](0);
        now = nodes[now].next[c - margin];
        foreach (ref v; nodes[now]._accept) {
            res ~= v;
        }
        return res;
    }

    int[int] match(const ref char[] str, int now = 0) {
        int[int] res, visit_cnt;
        foreach (ref c; str) {
            now = nodes[now].next[c - margin];
            visit_cnt[now]++;
        }
        foreach (ref k; visit_cnt.keys) {
            foreach (ref v; nodes[k]._accept) {
                res[v] += visit_cnt[k];
            }
        }
        return res;
    }

    int[int] match(const ref string str, int now = 0) {
        int[int] res, visit_cnt;
        foreach (ref c; str) {
            now = nodes[now].next[c - margin];
            visit_cnt[now]++;
        }
        foreach (ref k; visit_cnt.keys) {
            foreach (ref v; nodes[k]._accept) {
                res[v] += visit_cnt[k];
            }
        }
        return res;
    }

    Tuple!(long, int) move(const ref char c, int now = 0) {
        now = nodes[now].next[c - margin];
        return Tuple!(long, int)(correct[now], now);
    }

    Tuple!(long, int) move(const ref char[] str, int now = 0) {
        long res = 0;
        foreach (ref c; str) {
            long cnt;
            int nxt;
            AliasSeq!(cnt, nxt) = move(c, now);
            res += cnt;
            now = nxt;
        }
        return Tuple!(long, int)(res, now);
    }

    Tuple!(long, int) move(const ref string str, int now = 0) {
        long res = 0;
        foreach (ref c; str) {
            long cnt;
            int nxt;
            AliasSeq!(cnt, nxt) = move(c, now);
            res += cnt;
            now = nxt;
        }
        return Tuple!(long, int)(res, now);
    }
}
