module test.handmade.range_set;

// competitive-verifier: STANDALONE

import std;
import daylight.base;
import daylight.range;
import daylight.structure.range_set;

void main() {
    auto rs = new RangeSet!long();
    assert(rs[2].isNull);
    rs.add(Range!long("[1, 3]"));
    assert(rs.toString == "[1, 3]");
    assert(rs[0].isNull);
    assert(rs[1] == Range!long("[1, 3]"));
    assert(rs[2] == Range!long("[1, 3]"));
    assert(rs[3] == Range!long("[1, 3]"));
    assert(rs[4].isNull);
    rs.add(Range!long("[3, 9)"));
    assert(rs.toString == "[1, 9)");
    assert(rs[1] == Range!long("[1, 9)"));
    assert(rs[8] == Range!long("[1, 9)"));
    assert(rs[9].isNull);
    assert(rs[0].isNull);
    assert(rs.countIntegerPoint() == 8);
    assert(rs.countMiddlePoint() == 8);
    assert(rs.countIntegerPoint(Range!long(5, null, "[)")) == 4);
    assert(rs.countMiddlePoint(Range!long(5, null, "[)")) == 4);
    rs.remove(Range!long(4, 5, "[]"));
    assert(rs.toString == "[1, 4),(5, 9)");
    assert(rs[0].isNull);
    assert(rs[1] == Range!long("[1, 4)"));
    assert(rs[3] == Range!long("[1, 4)"));
    assert(rs[4].isNull);
    assert(rs[5].isNull);
    assert(rs[6] == Range!long("(5, 9)"));
    assert(rs[8] == Range!long("(5, 9)"));
    assert(rs[9].isNull);
    assert(rs.countIntegerPoint() == 6);
    assert(
        rs.countMiddlePoint() == 7);
    rs.add(Range!long("[4, 5]"));
    assert(rs.toString == "[1, 9)");
    rs.remove(Range!long("(4, 5)"));
    assert(rs.toString == "[1, 4],[5, 9)");
    assert(rs[4] == Range!long("[1, 4]"));
    assert(rs[5] == Range!long("[5, 9)"));
    rs.remove(Range!long("(1, 9)"));
    assert(rs.toString == "[1, 1]");
    assert(rs[1] == Range!long("[1, 1]"));
    rs.remove(Range!long("(-inf, inf)"));
    assert(rs[1].isNull);
    assert(rs.toString == "");
    assert(rs.empty);
    rs.add(Range!long("(-inf, inf)"));
    assert(rs.toString == "(-inf, inf)");
    rs.remove(Range!long("(5, 7]"));
    assert(rs.toString == "(-inf, 5],(7, inf)");
    rs.remove(Range!long("(-inf, 4]"));
    assert(rs.toString == "(4, 5],(7, inf)");
    rs.add(Range!long("(-inf, 4]"));
    assert(rs.toString == "(-inf, 5],(7, inf)");
    rs.remove(Range!long("(3, 9)"));
    assert(rs.toString == "(-inf, 3],[9, inf)");
    rs.add(Range!long("(-inf, 5]"));
    rs.add(Range!long("(7, inf)"));
    assert(rs.toString == "(-inf, 5],(7, inf)");
    rs.remove(Range!long("[9, 12)"));
    rs.remove(Range!long("[13, 21)"));
    rs.remove(Range!long("(22, 30]"));
    assert(rs.toString == "(-inf, 5],(7, 9),[12, 13),[21, 22],(30, inf)");
    rs.remove(Range!long("(3, 22)"));
    assert(rs.toString == "(-inf, 3],[22, 22],(30, inf)");
    rs.add(Range!long("[5, 7]"));
    assert(rs.toString == "(-inf, 3],[5, 7],[22, 22],(30, inf)");
    rs.add(Range!long("[9, 12)"));
    assert(rs.toString == "(-inf, 3],[5, 7],[9, 12),[22, 22],(30, inf)");
    rs.add(Range!long("(13, 21)"));
    assert(rs.toString == "(-inf, 3],[5, 7],[9, 12),(13, 21),[22, 22],(30, inf)");
    rs.add(Range!long("(5, 28]"));
    assert(rs.toString == "(-inf, 3],[5, 28],(30, inf)");
}
