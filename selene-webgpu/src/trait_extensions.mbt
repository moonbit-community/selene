///|
pub extend Render3DLightingMode with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Render3DLightingMode with Eq::{not_equal, equal}

///|
pub extend Render3DSubmissionStatsSnapshot with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend Render3DSubmissionStatsSnapshot with Eq::{not_equal, equal}

///|
pub extend WebGpuFrameTimingSnapshot with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend WebGpuFrameTimingSnapshot with Eq::{not_equal, equal}

///|
pub extend WebGpuRender3DTimingSnapshot with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend WebGpuRender3DTimingSnapshot with Eq::{not_equal, equal}
