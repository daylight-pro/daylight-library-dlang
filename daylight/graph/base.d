module daylight.graph.base;

import std;

// --- start ---

struct Edge(T = long) {
    int from, to;
    T info;
    this(int from, int to) {
        this(from, to, T.init);
    }

    this(int from, int to, T info) {
        this.from = from;
        this.to = to;
        this.info = info;
    }
}

alias Edges(T = long) = Edge!T[];
alias Graph(T = long) = Edges!T[];
