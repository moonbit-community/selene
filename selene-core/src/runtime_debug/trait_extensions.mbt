///|
pub extend AtlasOverlayEntry with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AtlasOverlayEntry with ToJson::{to_json}

///|
pub extend DebugColor with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend DebugColor with Eq::{not_equal, equal}

///|
pub extend DebugColor with ToJson::{to_json}

///|
pub extend DebugRect with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend DebugRect with Eq::{not_equal, equal}

///|
pub extend DebugRect with ToJson::{to_json}

///|
pub extend DebugVec2 with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend DebugVec2 with Eq::{not_equal, equal}

///|
pub extend DebugVec2 with ToJson::{to_json}

///|
pub extend DebugVec3 with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend DebugVec3 with Eq::{not_equal, equal}

///|
pub extend DebugVec3 with ToJson::{to_json}

///|
pub extend DrawSubmission2DMetadataEntry with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend DrawSubmission2DMetadataEntry with ToJson::{to_json}

///|
pub extend FrameCaptureArtifact with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend FrameCaptureMetadata with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend FrameCaptureMetadata with ToJson::{to_json}

///|
pub extend FramePerformanceMetricsExport with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend FramePerformanceMetricsExport with Eq::{not_equal, equal}

///|
pub extend FramePerformanceMetricsExport with ToJson::{to_json}

///|
pub extend SpriteInspectorEntry with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SpriteInspectorEntry with ToJson::{to_json}
