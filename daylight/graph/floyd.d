module daylight.graph.floyd;

import daylight.base;

long[][] floyd(long[][] WF) {
    long[][] ret = WF.dup;
    ulong n = WF.length;
    foreach (i; 0 .. n) {
        ret[i][i] = 0;
    }
    foreach (k; 0 .. n)
        foreach (i; 0 .. n) {
            if (ret[i][k] == LINF)
                continue;
            foreach (j; 0 .. n) {
                if (ret[k][j] == LINF)
                    continue;
                ret[i][j].chmin(ret[i][k] + ret[k][j]);
            }
        }
    return ret;
}
