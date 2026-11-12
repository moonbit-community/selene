///|
/// Adapts a dependency-free callback to the single-parameter system protocol.
pub fn[R] args0(run : () -> R) -> (Unit) -> R {
  _ => run()
}

///|
/// Adapts a 2-argument callback without changing parameter preparation.
pub fn[A, B, R] args2(run : (A, B) -> R) -> ((A, B)) -> R {
  params => run(params.0, params.1)
}

///|
/// Adapts a 3-argument callback without changing parameter preparation.
pub fn[A, B, C, R] args3(run : (A, B, C) -> R) -> ((A, B, C)) -> R {
  params => run(params.0, params.1, params.2)
}

///|
/// Adapts a 4-argument callback without changing parameter preparation.
pub fn[A, B, C, D, R] args4(run : (A, B, C, D) -> R) -> ((A, B, C, D)) -> R {
  params => run(params.0, params.1, params.2, params.3)
}

///|
/// Adapts a 5-argument callback without changing parameter preparation.
pub fn[A, B, C, D, E, R] args5(
  run : (A, B, C, D, E) -> R,
) -> ((A, B, C, D, E)) -> R {
  params => run(params.0, params.1, params.2, params.3, params.4)
}

///|
/// Adapts a 6-argument callback without changing parameter preparation.
pub fn[A, B, C, D, E, F, R] args6(
  run : (A, B, C, D, E, F) -> R,
) -> ((A, B, C, D, E, F)) -> R {
  params => run(params.0, params.1, params.2, params.3, params.4, params.5)
}

///|
/// Adapts a 7-argument callback without changing parameter preparation.
pub fn[A, B, C, D, E, F, G, R] args7(
  run : (A, B, C, D, E, F, G) -> R,
) -> ((A, B, C, D, E, F, G)) -> R {
  params => {
    run(params.0, params.1, params.2, params.3, params.4, params.5, params.6)
  }
}

///|
/// Adapts a 8-argument callback without changing parameter preparation.
pub fn[A, B, C, D, E, F, G, H, R] args8(
  run : (A, B, C, D, E, F, G, H) -> R,
) -> ((A, B, C, D, E, F, G, H)) -> R {
  params => {
    run(
      params.0,
      params.1,
      params.2,
      params.3,
      params.4,
      params.5,
      params.6,
      params.7,
    )
  }
}
