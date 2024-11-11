module test.handmade.linear_factorizer;
// competitive-verifier: STANDALONE

import daylight.math.factorizer;

void main() {
    auto factorizer = new Factorizer();
    Factorizer.createSieve(1_000_000);
    foreach (x; 1 .. 1_000_000) {
        auto a = factorizer.factorizeUsingSieve(x);
        auto b = factorizer.rho(x);
        assert(a == b);
    }
}
