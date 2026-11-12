# Query interface benchmarks

Measured on 2026-11-12 on an Apple M3 Max, using Moon 0.1.20261104,
moonc v0.10.20+65efd5b93, and Node.js v25.2.1. Both targets used release builds
and sequential benchmark execution. JavaScript results are from Node, not Chrome.

## Before and after the row interface change

The baseline is PR #79 commit `bc6703e7`, before query unification. Both versions
use the same 8,192-entity fixture in `multi_column_bench_wbtest.mbt`. Eight groups
spread matches across archetypes. A stride of 1 matches all 8,192 entities;
a stride of 8 matches 1,024 and gives the remaining entities only two columns.
The timed operation sums five integer columns. Fixture construction is excluded.

```sh
moon bench selene-core/src/ecs/multi_column_bench_wbtest.mbt --target native --release --no-parallelize
moon bench selene-core/src/ecs/multi_column_bench_wbtest.mbt --target js --release --no-parallelize
```

Means in microseconds, with 15 samples per case:

| Target | Matching rows | Previous flat callback | Unified tuple-row callback |
|---|---:|---:|---:|
| Native | 8,192 | 21.58 | 58.54 |
| Native | 1,024 | 2.70 | 6.76 |
| Node.js | 8,192 | 54.13 | 89.73 |
| Node.js | 1,024 | 5.54 | 11.23 |

The common tuple-row callback has a measurable cost. The implementation retains
specialized column traversal kernels, but materializing rows and dispatching the
callback still costs more than passing separate arguments. The interface change
must not be described as preserving the previous row-callback throughput.

## Scoped column access

`query_bench_wbtest.mbt` compares row callbacks, scoped columns, and an internal
direct-column reference on the same fixture. This fixture uses five distinct
component wrapper types, so its absolute timings are not a before/after comparison
with the integer-only fixture above. All three paths assert identical checksums.

```sh
moon bench selene-core/src/ecs/query_bench_wbtest.mbt --target native --release --no-parallelize
moon bench selene-core/src/ecs/query_bench_wbtest.mbt --target js --release --no-parallelize
```

Means in microseconds, with 12 samples per case:

| Target | Matching rows | Tuple rows | Scoped read columns | Direct-column reference |
|---|---:|---:|---:|---:|
| Native | 8,192 | 54.52 | 21.02 | 13.23 |
| Native | 1,024 | 6.86 | 3.52 | 1.91 |
| Node.js | 8,192 | 273.45 | 48.07 | 47.00 |
| Node.js | 1,024 | 33.65 | 6.72 | 6.29 |

The same benchmark writes the second and fifth columns together. The measured
means were 16.09 / 2.80 microseconds for native and 33.63 / 5.05 microseconds for
Node.js at 8,192 / 1,024 matches respectively. There is no previous equivalent
public API for simultaneously replacing these two columns.

Scoped columns avoid per-row tuples and validate that access remains inside the
batch callback. Those checks have a cost, visible against the internal reference,
especially on native. Sprite extraction uses the column path rather than forming
one tuple per sprite.

These are local microbenchmarks, not CI performance thresholds. Runtime, payload,
JIT/GC behavior, and machine load affect the results. No browser FPS or WebGPU
rendering time was measured by these tests.
