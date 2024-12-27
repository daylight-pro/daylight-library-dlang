module daylight.math.extgcd;
import std;

// --- start ---

long extGCD(long a, long b, ref long x, ref long y) {
    if (b == 0) {
        x = 1;
        y = 0;
        return a;
    }
    long d = extGCD(b, a % b, x, y);
    long z = x;
    x = y;
    y = z - a / b * y;
    return d;
}
