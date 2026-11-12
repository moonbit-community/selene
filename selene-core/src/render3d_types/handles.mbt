// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
#derive(Eq, Debug, Hash)
pub(all) struct MeshHandle(UInt32)

///|
pub extend MeshHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend MeshHandle with Eq::{not_equal, equal}

///|
pub extend MeshHandle with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug, Hash)
pub(all) struct MaterialHandle(UInt32)

///|
pub extend MaterialHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend MaterialHandle with Eq::{not_equal, equal}

///|
pub extend MaterialHandle with Hash::{hash, hash_combine}

///|
pub type ImageHandle = @asset_types.ImageHandle

///|
#derive(Eq, Debug, Hash)
#selene.component
pub(all) struct SceneHandle(UInt32)

///|
pub extend SceneHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SceneHandle with Eq::{not_equal, equal}

///|
pub extend SceneHandle with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug, Hash)
pub(all) struct CubemapHandle(UInt32)

///|
pub extend CubemapHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CubemapHandle with Eq::{not_equal, equal}

///|
pub extend CubemapHandle with Hash::{hash, hash_combine}
