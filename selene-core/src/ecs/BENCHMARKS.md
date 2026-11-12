# Query interface benchmarks

Measured on 2026-11-12 on an Apple M3 Max, using Moon 0.1.20261104,
moonc v0.10.20+65efd5b93, and Node.js v25.2.1. Both targets used release builds
and sequential benchmark execution. JavaScript results are from Node, not Chrome.

## Previous flat callbacks and current lazy iteration

The baseline is PR #79 commit `bc6703e7`, before query unification. Current results
use ordinary `for` loops after removing the row-callback API. Both versions
use the same 8,192-entity fixture in `multi_column_bench_wbtest.mbt`. Eight groups
spread matches across archetypes. A stride of 1 matches all 8,192 entities;
a stride of 8 matches 1,024 and gives the remaining entities only two columns.
The timed operation sums five integer columns. Fixture construction is excluded.

```sh
moon bench selene-core/src/ecs/multi_column_bench_wbtest.mbt --target native --release --no-parallelize
moon bench selene-core/src/ecs/multi_column_bench_wbtest.mbt --target js --release --no-parallelize
```

Means in microseconds, with 15 samples per case:

| Target | Matching rows | Previous flat callback | Current lazy `for` loop |
|---|---:|---:|---:|
| Native | 8,192 | 21.58 | 123.43 |
| Native | 1,024 | 2.70 | 15.66 |
| Node.js | 8,192 | 54.13 | 234.29 |
| Node.js | 1,024 | 5.54 | 30.23 |

Lazy iteration avoids collecting entity handles or result arrays, but does not
remove per-row tuple construction and iterator dispatch. It is substantially
slower than the previous flat callbacks in this fixture. Removing the callback
API simplifies the public interface; it is not a throughput improvement. Use
`query.batches(callback)` with typed columns for performance-sensitive loops.

## Scoped column access

`query_bench_wbtest.mbt` compares ordinary `for` loops, scoped columns, and an internal
direct-column reference on the same fixture. This fixture uses five distinct
component wrapper types, so its absolute timings are not a before/after comparison
with the integer-only fixture above. All three paths assert identical checksums.

```sh
moon bench selene-core/src/ecs/query_bench_wbtest.mbt --target native --release --no-parallelize
moon bench selene-core/src/ecs/query_bench_wbtest.mbt --target js --release --no-parallelize
```

Means in microseconds, with 12 samples per case:

| Target | Matching rows | Lazy `for` loop | Scoped read columns | Direct-column reference |
|---|---:|---:|---:|---:|
| Native | 8,192 | 119.52 | 20.64 | 12.97 |
| Native | 1,024 | 15.02 | 3.51 | 1.85 |
| Node.js | 8,192 | 372.90 | 46.83 | 43.98 |
| Node.js | 1,024 | 50.16 | 6.38 | 6.28 |

The same benchmark writes the second and fifth columns together. The measured
means were 15.77 / 2.71 microseconds for native and 32.85 / 5.04 microseconds for
Node.js at 8,192 / 1,024 matches respectively. There is no previous equivalent
public API for simultaneously replacing these two columns.

Scoped columns avoid per-row tuples and validate that access remains inside the
batch callback. Those checks have a cost, visible against the internal reference,
especially on native. Sprite extraction uses the column path rather than forming
one tuple per sprite.

These are local microbenchmarks, not CI performance thresholds. Runtime, payload,
JIT/GC behavior, and machine load affect the results. No browser FPS or WebGPU
rendering time was measured by these tests.
