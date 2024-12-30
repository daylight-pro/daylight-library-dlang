module test.yukicoder.p674;

import std;
import daylight.base;
import daylight.range;
import daylight.structure.range_set;

void main() {
    Reader reader = new Reader();
    long D, Q;
    reader.read(D, Q);
    auto rs = new RangeSet!long();
    long ans = 0;
    while (Q--) {
        long A, B;
        reader.read(A, B);
        auto r = rs.add(Range!long(A, B + 1, "[)"));
        if (!r.isNull) {
            ans.chmax(r.get.countIntegerPoint());
        }
        writeln(ans);
    }
}
