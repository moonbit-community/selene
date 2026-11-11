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
pub type MeshHandle = @render3d_types.MeshHandle

///|
pub type MaterialHandle = @render3d_types.MaterialHandle

///|
pub type ImageHandle = @render3d_types.ImageHandle

///|
pub type SceneHandle = @render3d_types.SceneHandle

///|
pub type CubemapHandle = @render3d_types.CubemapHandle

///|
pub type AlphaMode3D = @render3d_types.AlphaMode3D

///|
pub type TextureWrap3D = @render3d_types.TextureWrap3D

///|
pub type TextureFilter3D = @render3d_types.TextureFilter3D

///|
pub using @render3d_types {type TextureSampler3D}

///|
pub using @render3d_types {type TextureTransform3D}

///|
pub using @render3d_types {type TextureBinding3D}

///|
pub type Tangent3D = @render3d_types.Tangent3D

///|
pub type TriangleTopology3D = @render3d_types.TriangleTopology3D

///|
pub type MeshPrimitive3D = @render3d_types.MeshPrimitive3D

///|
pub type MeshAsset = @render3d_types.MeshAsset

///|
pub type ImageAsset = @render3d_types.ImageAsset

///|
pub using @render3d_types {type CubemapFaces3D}

///|
pub type CubemapAsset3D = @render3d_types.CubemapAsset3D

///|
pub using @render3d_types {type Skybox3D}

///|
pub using @render3d_types {type StandardMaterial3D}

///|
pub using @render3d_types {type DirectionalLight3D}

///|
pub using @render3d_types {type PointLight3D}

///|
pub type FramePointLight3D = @render3d_types.FramePointLight3D

///|
pub type FrameSpotLight3D = @render3d_types.FrameSpotLight3D

///|
pub using @render3d_types {type SpotLight3D}

///|
pub type AmbientLight3D = @render3d_types.AmbientLight3D

///|
pub using @render3d_types {type DirectionalLightShadowMap3D}

///|
pub using @render3d_types {type PointLightShadowMap3D}

///|
pub using @render3d_types {type CascadeShadowConfigBuilder3D}

///|
pub using @render3d_types {type CascadeShadowConfig3D}

///|
pub type RenderItem3D = @render3d_types.RenderItem3D

///|
pub type RenderLine3D = @render3d_types.RenderLine3D

///|
pub using @render3d_types {type RenderFrame3D}
