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
extern "js" fn set_viewport_height(
  elem : @dom.HTMLCanvasElement,
  height : Double,
) -> Unit = "(x, y) => { x.height = y; }"

///|
extern "js" fn set_viewport_width(
  elem : @dom.HTMLCanvasElement,
  width : Double,
) -> Unit = "(x, y) => { x.width = y; }"

///|
extern "js" fn request_pointer_lock_if_enabled(
  elem : @dom.HTMLCanvasElement,
  enabled : Bool,
) -> Unit = "(elem, enabled) => { if (enabled && document.pointerLockElement !== elem) { elem.requestPointerLock(); } }"

///|
extern "js" fn is_pointer_locked(canvas : @dom.HTMLCanvasElement) -> Bool = "(canvas) => document.pointerLockElement === canvas"

///|
extern "js" fn exit_pointer_lock() -> Unit = "() => { if (document.exitPointerLock) { document.exitPointerLock(); } }"

///|
extern "js" fn document_add_event_listener(
  event : String,
  callback : (@dom.Event) -> Unit,
) -> Unit = "(event, callback) => { document.addEventListener(event, callback); }"

///|
extern "js" fn document_hidden() -> Bool = "() => document.hidden"

///|
extern "js" fn prevent_default_event(event : @dom.Event) -> Unit = "(event) => event.preventDefault()"

///|
extern "js" fn load_font_async(font : String, path : String) -> Unit =
  #| (font, path) => {
  #|   const ff = new FontFace(font, 'url(' + path + ')');
  #|   ff.load().then(loadedFont => {
  #|     document.fonts.add(loadedFont);
  #|   });
  #| }

///|
extern "js" fn webgpu_preload_font_bytes(font : String, path : String) -> Unit =
  #| (font, path) => {
  #|   const g = globalThis;
  #|   if (!g.__selene_font_bytes_states) {
  #|     g.__selene_font_bytes_states = new Map();
  #|   }
  #|   const states = g.__selene_font_bytes_states;
  #|   const rec = states.get(font);
  #|   if (rec && (rec.status === 0 || rec.status === 1)) {
  #|     return;
  #|   }
  #|   states.set(font, { status: 0, bytes: [] });
  #|   fetch(path)
  #|     .then((res) => {
  #|       if (!res.ok) throw new Error('failed to fetch font');
  #|       return res.arrayBuffer();
  #|     })
  #|     .then((buf) => {
  #|       states.set(font, { status: 1, bytes: Array.from(new Uint8Array(buf)) });
  #|     })
  #|     .catch(() => {
  #|       states.set(font, { status: 2, bytes: [] });
  #|     });
  #| }

///|
extern "js" fn webgpu_font_bytes_status(font : String) -> Int =
  #| (font) => {
  #|   const states = globalThis.__selene_font_bytes_states;
  #|   if (!states) return -1;
  #|   const rec = states.get(font);
  #|   if (!rec) return -1;
  #|   return rec.status | 0;
  #| }

///|
extern "js" fn webgpu_take_font_bytes(font : String) -> Array[Int] =
  #| (font) => {
  #|   const states = globalThis.__selene_font_bytes_states;
  #|   if (!states) return [];
  #|   const rec = states.get(font);
  #|   if (!rec || rec.status !== 1) return [];
  #|   states.set(font, { status: 3, bytes: [] });
  #|   return rec.bytes || [];
  #| }

///|
extern "js" fn resolve_asset_path(path : String) -> String =
  #| (path) => {
  #|   if (
  #|     path.startsWith("http://") ||
  #|     path.startsWith("https://") ||
  #|     path.startsWith("data:") ||
  #|     path.startsWith("blob:")
  #|   ) {
  #|     return path;
  #|   }
  #|   if (!path.startsWith("assets/")) {
  #|     return path;
  #|   }
  #|   try {
  #|     const href = globalThis.location?.href;
  #|     if (!href) return path;
  #|     return new URL(path, href).pathname;
  #|   } catch (_err) {
  #|     return path;
  #|   }
  #| }

///|
extern "js" fn webgpu_load_file_bytes_sync(path : String) -> Array[Int] =
  #| (path) => {
  #|   try {
  #|     const xhr = new XMLHttpRequest();
  #|     xhr.open('GET', path, false);
  #|     // Browsers reject `responseType = "arraybuffer"` for synchronous XHR
  #|     // on document contexts. Use x-user-defined text decoding to preserve
  #|     // raw byte values for sync file reads.
  #|     xhr.overrideMimeType('text/plain; charset=x-user-defined');
  #|     xhr.send(null);
  #|     if (xhr.status >= 200 && xhr.status < 300) {
  #|       const text = xhr.responseText || '';
  #|       const out = new Array(text.length);
  #|       for (let i = 0; i < text.length; i += 1) {
  #|         out[i] = text.charCodeAt(i) & 0xff;
  #|       }
  #|       return out;
  #|     }
  #|   } catch (_err) {
  #|     return [];
  #|   }
  #|   return [];
  #| }

///|
extern "js" fn webgpu_gamepad_count() -> Int =
  #| () => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   return pads ? (pads.length | 0) : 0;
  #| }

///|
extern "js" fn webgpu_gamepad_connected(index : Int) -> Bool =
  #| (index) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   if (!pads || index < 0 || index >= pads.length) return false;
  #|   const pad = pads[index];
  #|   return !!(pad && pad.connected);
  #| }

///|
extern "js" fn webgpu_gamepad_button_pressed(index : Int, button : Int) -> Bool =
  #| (index, button) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   const pad = pads?.[index];
  #|   const b = pad?.buttons?.[button];
  #|   return !!(b && b.pressed);
  #| }

///|
extern "js" fn webgpu_gamepad_button_value(index : Int, button : Int) -> Double =
  #| (index, button) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   const pad = pads?.[index];
  #|   const b = pad?.buttons?.[button];
  #|   if (!b) return 0;
  #|   const v = Number(b.value);
  #|   if (!Number.isFinite(v)) return 0;
  #|   if (v < 0) return 0;
  #|   if (v > 1) return 1;
  #|   return v;
  #| }

///|
extern "js" fn webgpu_gamepad_axis_value(index : Int, axis : Int) -> Double =
  #| (index, axis) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   const pad = pads?.[index];
  #|   const a = pad?.axes?.[axis];
  #|   if (a == null) return 0;
  #|   const v = Number(a);
  #|   if (!Number.isFinite(v)) return 0;
  #|   if (v < -1) return -1;
  #|   if (v > 1) return 1;
  #|   return v;
  #| }

///|
extern "js" fn webgpu_measure_text(
  text : String,
  family : String,
  size : Double,
) -> Array[Double] =
  #| (text, family, size) => {
  #|   const cvs = document.createElement('canvas');
  #|   const ctx = cvs.getContext('2d');
  #|   const fontSize = Number.isFinite(size) && size > 0 ? size : 16;
  #|   const fontFamily = family && family.length > 0 ? family : 'Arial';
  #|   ctx.font = `${fontSize}px ${fontFamily}`;
  #|   const m = ctx.measureText(text ?? '');
  #|   const width = Math.max(0, Number(m.width) || 0);
  #|   const ascent = Math.max(0, Number(m.actualBoundingBoxAscent) || fontSize * 0.8);
  #|   const descent = Math.max(0, Number(m.actualBoundingBoxDescent) || fontSize * 0.2);
  #|   const height = Math.max(1, Math.ceil(ascent + descent));
  #|   return [width, height];
  #| }

///|
extern "js" fn webgpu_initialize(
  canvas : @dom.HTMLCanvasElement,
  width : Double,
  height : Double,
  image_smooth : Bool,
) -> Unit =
  #| (canvas, width, height, imageSmooth) => {
  #|   const g = globalThis;
  #|   if (!g.__selene_webgpu_runtime) {
  #|     const rt = {
  #|       canvas: null,
  #|       context: null,
  #|       adapter: null,
  #|       device: null,
  #|       format: null,
  #|       ready: false,
  #|       initPromise: null,
  #|       imageSmooth: true,
  #|       clearColor: [0, 0, 0, 1],
  #|       draw2dCommands: [],
  #|       sections3d: [],
  #|       current3dSection: null,
  #|       imageCache: new Map(),
  #|       textCache: new Map(),
  #|       light3d: {
  #|         directionalLights: [],
  #|         pointLights: [],
  #|         spotLights: [],
  #|         ambient: [1, 1, 1],
  #|         directionalShadowMapSize: 2048,
  #|         pointShadowMapSize: 1024,
  #|       },
  #|       samplers: null,
  #|       pipelines: null,
  #|       bindGroupLayouts: null,
  #|       uniformBuffers: null,
  #|       bindGroups: null,
  #|       depthTexture: null,
  #|       depthView: null,
  #|       depthWidth: 0,
  #|       depthHeight: 0,
  #|       shadowTextures: {
  #|         directional: [null, null, null, null],
  #|         spot: null,
  #|         point: null,
  #|         dummy: null,
  #|       },
  #|       shadowCameraBuffers: [],
  #|       dynamicBuffers: new Map(),
  #|     };
  #|
  #|     const clamp01 = (x) => Math.max(0, Math.min(1, x));
  #|     const colorNorm = (r, g, b, a) => [
  #|       clamp01((r || 0) / 255.0),
  #|       clamp01((g || 0) / 255.0),
  #|       clamp01((b || 0) / 255.0),
  #|       clamp01(a == null ? 1.0 : a),
  #|     ];
  #|     const toCanvasSize = () => [
  #|       Math.max(1, Math.floor(rt.canvas?.width || 1)),
  #|       Math.max(1, Math.floor(rt.canvas?.height || 1)),
  #|     ];
  #|     const nextPow2 = (v) => {
  #|       let n = 1;
  #|       while (n < v) n <<= 1;
  #|       return n;
  #|     };
  #|     const mat4Multiply = (a, b) => {
  #|       const out = new Float32Array(16);
  #|       for (let c = 0; c < 4; c += 1) {
  #|         for (let r = 0; r < 4; r += 1) {
  #|           out[c * 4 + r] =
  #|             a[0 * 4 + r] * b[c * 4 + 0] +
  #|             a[1 * 4 + r] * b[c * 4 + 1] +
  #|             a[2 * 4 + r] * b[c * 4 + 2] +
  #|             a[3 * 4 + r] * b[c * 4 + 3];
  #|         }
  #|       }
  #|       return out;
  #|     };
  #|     const vec3Sub = (a, b) => [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
  #|     const vec3Dot = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
  #|     const vec3Cross = (a, b) => [
  #|       a[1] * b[2] - a[2] * b[1],
  #|       a[2] * b[0] - a[0] * b[2],
  #|       a[0] * b[1] - a[1] * b[0],
  #|     ];
  #|     const vec3Norm = (v) => {
  #|       const len = Math.hypot(v[0], v[1], v[2]) || 1;
  #|       return [v[0] / len, v[1] / len, v[2] / len];
  #|     };
  #|     const mat4LookAt = (eye, target, up) => {
  #|       const z = vec3Norm(vec3Sub(eye, target));
  #|       const x = vec3Norm(vec3Cross(up, z));
  #|       const y = vec3Cross(z, x);
  #|       return new Float32Array([
  #|         x[0], y[0], z[0], 0,
  #|         x[1], y[1], z[1], 0,
  #|         x[2], y[2], z[2], 0,
  #|         -vec3Dot(x, eye), -vec3Dot(y, eye), -vec3Dot(z, eye), 1,
  #|       ]);
  #|     };
  #|     const mat4Perspective = (fovyDeg, aspect, near, far) => {
  #|       const fovy = (fovyDeg * Math.PI) / 180.0;
  #|       const f = 1.0 / Math.tan(fovy / 2.0);
  #|       return new Float32Array([
  #|         f / aspect, 0, 0, 0,
  #|         0, f, 0, 0,
  #|         0, 0, far / (near - far), -1,
  #|         0, 0, (near * far) / (near - far), 0,
  #|       ]);
  #|     };
  #|     const mat4Orthographic = (width, height, near, far) => {
  #|       const halfW = Math.max(Math.abs(width), 0.0001) / 2.0;
  #|       const halfH = Math.max(Math.abs(height), 0.0001) / 2.0;
  #|       const left = -halfW;
  #|       const right = halfW;
  #|       const bottom = -halfH;
  #|       const top = halfH;
  #|       const dz = Math.max(far - near, 0.0001);
  #|       return new Float32Array([
  #|         2.0 / (right - left), 0, 0, 0,
  #|         0, 2.0 / (top - bottom), 0, 0,
  #|         0, 0, 1.0 / (near - far), 0,
  #|         -(right + left) / (right - left),
  #|         -(top + bottom) / (top - bottom),
  #|         near / (near - far),
  #|         1,
  #|       ]);
  #|     };
  #|     const mat4Translation = (x, y, z) =>
  #|       new Float32Array([
  #|         1, 0, 0, 0,
  #|         0, 1, 0, 0,
  #|         0, 0, 1, 0,
  #|         x, y, z, 1,
  #|       ]);
  #|     ;
  #|     const vec3Add = (a, b) => [a[0] + b[0], a[1] + b[1], a[2] + b[2]];
  #|     const vec3Scale = (v, s) => [v[0] * s, v[1] * s, v[2] * s];
  #|     const vec3LengthSq = (v) => vec3Dot(v, v);
  #|     const vec3Min = (a, b) => [
  #|       Math.min(a[0], b[0]),
  #|       Math.min(a[1], b[1]),
  #|       Math.min(a[2], b[2]),
  #|     ];
  #|     const vec3Max = (a, b) => [
  #|       Math.max(a[0], b[0]),
  #|       Math.max(a[1], b[1]),
  #|       Math.max(a[2], b[2]),
  #|     ];
  #|     const chooseShadowUp = (direction) => {
  #|       const normalized = vec3LengthSq(direction) <= 1e-8
  #|         ? [0, -1, 0]
  #|         : vec3Norm(direction);
  #|       const worldUp = [0, 1, 0];
  #|       return vec3LengthSq(vec3Cross(normalized, worldUp)) <= 1e-4
  #|         ? [0, 0, 1]
  #|         : worldUp;
  #|     };
  #|     const cameraBasis = (camera) => {
  #|       const forward = vec3LengthSq(vec3Sub(camera.target, camera.position)) <= 1e-8
  #|         ? [0, 0, -1]
  #|         : vec3Norm(vec3Sub(camera.target, camera.position));
  #|       const up = vec3LengthSq(camera.up) <= 1e-8
  #|         ? [0, 1, 0]
  #|         : vec3Norm(camera.up);
  #|       const right = vec3LengthSq(vec3Cross(forward, up)) <= 1e-8
  #|         ? [1, 0, 0]
  #|         : vec3Norm(vec3Cross(forward, up));
  #|       const correctedUp = vec3LengthSq(vec3Cross(right, forward)) <= 1e-8
  #|         ? [0, 1, 0]
  #|         : vec3Norm(vec3Cross(right, forward));
  #|       return { forward, right, up: correctedUp };
  #|     };
  #|     const cameraFrustumSliceCorners = (camera, aspect, nearBound, farBound) => {
  #|       const { forward, right, up } = cameraBasis(camera);
  #|       const corners = [];
  #|       if (camera.orthographic) {
  #|         const halfWidth = Math.max(Math.abs(camera.orthoWidth || 20), 0.0001) * 0.5;
  #|         const halfHeight = Math.max(Math.abs(camera.orthoHeight || 20), 0.0001) * 0.5;
  #|         const nearCenter = vec3Add(camera.position, vec3Scale(forward, nearBound));
  #|         const farCenter = vec3Add(camera.position, vec3Scale(forward, farBound));
  #|         corners.push(
  #|           vec3Sub(vec3Sub(nearCenter, vec3Scale(right, halfWidth)), vec3Scale(up, halfHeight)),
  #|           vec3Add(vec3Sub(nearCenter, vec3Scale(up, halfHeight)), vec3Scale(right, halfWidth)),
  #|           vec3Add(vec3Add(nearCenter, vec3Scale(right, halfWidth)), vec3Scale(up, halfHeight)),
  #|           vec3Add(vec3Sub(nearCenter, vec3Scale(right, halfWidth)), vec3Scale(up, halfHeight)),
  #|           vec3Sub(vec3Sub(farCenter, vec3Scale(right, halfWidth)), vec3Scale(up, halfHeight)),
  #|           vec3Add(vec3Sub(farCenter, vec3Scale(up, halfHeight)), vec3Scale(right, halfWidth)),
  #|           vec3Add(vec3Add(farCenter, vec3Scale(right, halfWidth)), vec3Scale(up, halfHeight)),
  #|           vec3Add(vec3Sub(farCenter, vec3Scale(right, halfWidth)), vec3Scale(up, halfHeight)),
  #|         );
  #|         return corners;
  #|       }
  #|       const fovy = (Math.max(0.0001, Number(camera.fovy) || 0.0001) * Math.PI) / 180.0;
  #|       const tanHalfY = Math.tan(fovy * 0.5);
  #|       const nearHeight = nearBound * tanHalfY;
  #|       const nearWidth = nearHeight * aspect;
  #|       const farHeight = farBound * tanHalfY;
  #|       const farWidth = farHeight * aspect;
  #|       const nearCenter = vec3Add(camera.position, vec3Scale(forward, nearBound));
  #|       const farCenter = vec3Add(camera.position, vec3Scale(forward, farBound));
  #|       corners.push(
  #|         vec3Sub(vec3Sub(nearCenter, vec3Scale(right, nearWidth)), vec3Scale(up, nearHeight)),
  #|         vec3Add(vec3Sub(nearCenter, vec3Scale(up, nearHeight)), vec3Scale(right, nearWidth)),
  #|         vec3Add(vec3Add(nearCenter, vec3Scale(right, nearWidth)), vec3Scale(up, nearHeight)),
  #|         vec3Add(vec3Sub(nearCenter, vec3Scale(right, nearWidth)), vec3Scale(up, nearHeight)),
  #|         vec3Sub(vec3Sub(farCenter, vec3Scale(right, farWidth)), vec3Scale(up, farHeight)),
  #|         vec3Add(vec3Sub(farCenter, vec3Scale(up, farHeight)), vec3Scale(right, farWidth)),
  #|         vec3Add(vec3Add(farCenter, vec3Scale(right, farWidth)), vec3Scale(up, farHeight)),
  #|         vec3Add(vec3Sub(farCenter, vec3Scale(right, farWidth)), vec3Scale(up, farHeight)),
  #|       );
  #|       return corners;
  #|     };
  #|     const directionalShadowBounds = (light, camera) => {
  #|       const config = light.cascadeConfig || {};
  #|       const minimumDistance = Math.max(
  #|         Math.max(0, Number(camera.near) || 0.1),
  #|         Math.max(0, Number(config.minimumDistance) || 0),
  #|       );
  #|       const far = Number(camera.far) || (minimumDistance + 200.0);
  #|       if (far <= minimumDistance) return [];
  #|       const overlap = Math.max(0, Math.min(1, Number(config.overlapProportion) || 0));
  #|       const authoredBounds = Array.isArray(config.bounds) ? config.bounds : [];
  #|       const cascadeCount = Math.max(1, Math.min(4, authoredBounds.length || 1));
  #|       const bounds = [];
  #|       let previousFar = minimumDistance;
  #|       for (let index = 0; index < cascadeCount; index += 1) {
  #|         const authoredFar = Number(authoredBounds[index]) || far;
  #|         const farBound = Math.min(far, authoredFar);
  #|         const nearBound = index === 0
  #|           ? minimumDistance
  #|           : Math.max(minimumDistance, previousFar * (1.0 - overlap));
  #|         previousFar = farBound;
  #|         if (farBound <= nearBound) continue;
  #|         bounds.push([nearBound, farBound]);
  #|         if (farBound >= far) break;
  #|       }
  #|       return bounds;
  #|     };
  #|     const directionalAtlasLayout = (cascadeCount) => {
  #|       if (cascadeCount <= 1) return [1, 1];
  #|       if (cascadeCount === 2) return [2, 1];
  #|       return [2, 2];
  #|     };
  #|     const makeShadowAtlasRect = (slot, columns, tileSize, atlasWidth, atlasHeight) => {
  #|       const column = slot % columns;
  #|       const row = Math.floor(slot / columns);
  #|       const tileWidth = tileSize / Math.max(1, atlasWidth);
  #|       const tileHeight = tileSize / Math.max(1, atlasHeight);
  #|       return {
  #|         offset: [column * tileWidth, row * tileHeight],
  #|         scale: [tileWidth, tileHeight],
  #|       };
  #|     };
  #|     const transformPoint = (matrix, point) => {
  #|       const x = point[0];
  #|       const y = point[1];
  #|       const z = point[2];
  #|       return [
  #|         matrix[0] * x + matrix[4] * y + matrix[8] * z + matrix[12],
  #|         matrix[1] * x + matrix[5] * y + matrix[9] * z + matrix[13],
  #|         matrix[2] * x + matrix[6] * y + matrix[10] * z + matrix[14],
  #|       ];
  #|     };
  #|     const buildDirectionalShadowCascadesForLight = (light, camera, aspect, tileSize) => {
  #|       const bounds = directionalShadowBounds(light, camera);
  #|       if (bounds.length === 0) return [];
  #|       const direction = vec3LengthSq(light.direction || [0, -1, 0]) <= 1e-8
  #|         ? [0, -1, 0]
  #|         : vec3Norm(light.direction);
  #|       const lightView = mat4LookAt([0, 0, 0], direction, chooseShadowUp(direction));
  #|       const [atlasColumns, atlasRows] = directionalAtlasLayout(bounds.length);
  #|       const atlasWidth = tileSize * atlasColumns;
  #|       const atlasHeight = tileSize * atlasRows;
  #|       const cascades = [];
  #|       for (let cascadeIndex = 0; cascadeIndex < bounds.length; cascadeIndex += 1) {
  #|         const nearBound = bounds[cascadeIndex][0];
  #|         const farBound = bounds[cascadeIndex][1];
  #|         const corners = cameraFrustumSliceCorners(camera, aspect, nearBound, farBound);
  #|         if (corners.length < 8) continue;
  #|         let minCorner = transformPoint(lightView, corners[0]);
  #|         let maxCorner = minCorner;
  #|         for (let index = 1; index < corners.length; index += 1) {
  #|           const point = transformPoint(lightView, corners[index]);
  #|           minCorner = vec3Min(minCorner, point);
  #|           maxCorner = vec3Max(maxCorner, point);
  #|         }
  #|         const bodyDiagonal = vec3LengthSq(vec3Sub(corners[0], corners[6]));
  #|         const farPlaneDiagonal = vec3LengthSq(vec3Sub(corners[4], corners[6]));
  #|         const diameter = Math.max(1.0, Math.ceil(Math.sqrt(Math.max(bodyDiagonal, farPlaneDiagonal))));
  #|         const texelSize = diameter / Math.max(1, tileSize);
  #|         const centerX = Math.floor(((minCorner[0] + maxCorner[0]) * 0.5) / texelSize) * texelSize;
  #|         const centerY = Math.floor(((minCorner[1] + maxCorner[1]) * 0.5) / texelSize) * texelSize;
  #|         const halfExtent = diameter * 0.5;
  #|         const nearPlane = 0.01;
  #|         const farPlane = Math.max(nearPlane + 1.0, (maxCorner[2] - minCorner[2]) + nearPlane);
  #|         const cascadeView = mat4Multiply(
  #|           lightView,
  #|           mat4Translation(-centerX, -centerY, -(maxCorner[2] + nearPlane)),
  #|         );
  #|         const cascadeProjection = mat4Orthographic(halfExtent * 2.0, halfExtent * 2.0, nearPlane, farPlane);
  #|         const atlasRect = makeShadowAtlasRect(
  #|           cascadeIndex,
  #|           atlasColumns,
  #|           tileSize,
  #|           atlasWidth,
  #|           atlasHeight,
  #|         );
  #|         cascades.push({
  #|           lightViewProjection: mat4Multiply(cascadeProjection, cascadeView),
  #|           atlasRect,
  #|           nearBound,
  #|           farBound,
  #|         });
  #|       }
  #|       return cascades;
  #|     };
  #|     const buildSpotShadowSetup = (light) => {
  #|       const direction = vec3LengthSq(light.direction || [0, -1, 0]) <= 1e-8
  #|         ? [0, -1, 0]
  #|         : vec3Norm(light.direction);
  #|       const target = vec3Add(light.position, direction);
  #|       const nearPlane = Math.max(0.01, Number(light.nearZ) || 0.01);
  #|       const farPlane = Math.max(nearPlane + 1.0, Number(light.range) || (nearPlane + 1.0));
  #|       const lightView = mat4LookAt(light.position, target, chooseShadowUp(direction));
  #|       const outerAngle = Math.max(Number(light.outerAngle) || 0.017453292519943295, 0.008726646259971648);
  #|       const fovyDeg = (outerAngle * 2.0 * 180.0) / Math.PI;
  #|       return {
  #|         lightViewProjection: mat4Multiply(
  #|           mat4Perspective(fovyDeg, 1.0, nearPlane, farPlane),
  #|           lightView,
  #|         ),
  #|       };
  #|     };
  #|     const pointShadowFace = (index) => {
  #|       switch (index) {
  #|         case 0: return [[1, 0, 0], [0, -1, 0]];
  #|         case 1: return [[-1, 0, 0], [0, -1, 0]];
  #|         case 2: return [[0, 1, 0], [0, 0, 1]];
  #|         case 3: return [[0, -1, 0], [0, 0, -1]];
  #|         case 4: return [[0, 0, 1], [0, -1, 0]];
  #|         default: return [[0, 0, -1], [0, -1, 0]];
  #|       }
  #|     };
  #|     const buildPointShadowFaceSetup = (light, faceIndex) => {
  #|       const [direction, up] = pointShadowFace(faceIndex);
  #|       const nearPlane = Math.max(0.01, Number(light.nearZ) || 0.01);
  #|       const farPlane = Math.max(nearPlane + 1.0, Number(light.range) || (nearPlane + 1.0));
  #|       const lightView = mat4LookAt(light.position, vec3Add(light.position, direction), up);
  #|       return {
  #|         lightViewProjection: mat4Multiply(
  #|           mat4Perspective(90.0, 1.0, nearPlane, farPlane),
  #|           lightView,
  #|         ),
  #|       };
  #|     };
  #|     const createShadowTexture = (width, height) => {
  #|       const texture = rt.device.createTexture({
  #|         size: [Math.max(1, width), Math.max(1, height), 1],
  #|         format: 'depth32float',
  #|         usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING,
  #|       });
  #|       return {
  #|         texture,
  #|         view: texture.createView(),
  #|         width: Math.max(1, width),
  #|         height: Math.max(1, height),
  #|       };
  #|     };
  #|     const destroyShadowTexture = (record) => {
  #|       if (!record?.texture) return;
  #|       try { record.texture.destroy(); } catch (_err) {}
  #|     };
  #|     rt.ensureDirectionalShadowTexture = (index, tileSize, cascadeCount) => {
  #|       if (!rt.device || index < 0 || index >= 4) return null;
  #|       const safeTileSize = Math.max(1, tileSize | 0);
  #|       const safeCascadeCount = Math.max(1, Math.min(4, cascadeCount | 0));
  #|       const [columns, rows] = directionalAtlasLayout(safeCascadeCount);
  #|       const width = safeTileSize * columns;
  #|       const height = safeTileSize * rows;
  #|       const existing = rt.shadowTextures.directional[index];
  #|       if (existing &&
  #|         existing.tileSize === safeTileSize &&
  #|         existing.cascadeCount === safeCascadeCount &&
  #|         existing.width === width &&
  #|         existing.height === height) {
  #|         return existing;
  #|       }
  #|       destroyShadowTexture(existing);
  #|       const record = {
  #|         ...createShadowTexture(width, height),
  #|         tileSize: safeTileSize,
  #|         cascadeCount: safeCascadeCount,
  #|         columns,
  #|         rows,
  #|       };
  #|       rt.shadowTextures.directional[index] = record;
  #|       return record;
  #|     };
  #|     rt.ensureSpotShadowTexture = (tileSize) => {
  #|       if (!rt.device) return null;
  #|       const safeTileSize = Math.max(1, tileSize | 0);
  #|       const width = safeTileSize * 2;
  #|       const height = safeTileSize * 2;
  #|       const existing = rt.shadowTextures.spot;
  #|       if (existing && existing.tileSize === safeTileSize && existing.width === width && existing.height === height) {
  #|         return existing;
  #|       }
  #|       destroyShadowTexture(existing);
  #|       const record = { ...createShadowTexture(width, height), tileSize: safeTileSize };
  #|       rt.shadowTextures.spot = record;
  #|       return record;
  #|     };
  #|     rt.ensurePointShadowTexture = (faceSize) => {
  #|       if (!rt.device) return null;
  #|       const safeFaceSize = Math.max(1, faceSize | 0);
  #|       const width = safeFaceSize * 8;
  #|       const height = safeFaceSize * 6;
  #|       const existing = rt.shadowTextures.point;
  #|       if (existing && existing.faceSize === safeFaceSize && existing.width === width && existing.height === height) {
  #|         return existing;
  #|       }
  #|       destroyShadowTexture(existing);
  #|       const record = { ...createShadowTexture(width, height), faceSize: safeFaceSize };
  #|       rt.shadowTextures.point = record;
  #|       return record;
  #|     };
  #|     rt.ensureDummyShadowTexture = () => {
  #|       if (rt.shadowTextures.dummy) return rt.shadowTextures.dummy;
  #|       const record = createShadowTexture(1, 1);
  #|       const encoder = rt.device.createCommandEncoder();
  #|       const pass = encoder.beginRenderPass({
  #|         colorAttachments: [],
  #|         depthStencilAttachment: {
  #|           view: record.view,
  #|           depthClearValue: 1.0,
  #|           depthLoadOp: 'clear',
  #|           depthStoreOp: 'store',
  #|         },
  #|       });
  #|       pass.end();
  #|       rt.device.queue.submit([encoder.finish()]);
  #|       rt.shadowTextures.dummy = record;
  #|       return record;
  #|     };
  #|
  #|     rt.ensureDepth = () => {
  #|       if (!rt.device || !rt.canvas) return;
  #|       const [w, h] = toCanvasSize();
  #|       if (rt.depthTexture && rt.depthWidth === w && rt.depthHeight === h) {
  #|         return;
  #|       }
  #|       if (rt.depthTexture) {
  #|         try { rt.depthTexture.destroy(); } catch (_err) {}
  #|       }
  #|       rt.depthTexture = rt.device.createTexture({
  #|         size: [w, h, 1],
  #|         format: 'depth24plus',
  #|         usage: GPUTextureUsage.RENDER_ATTACHMENT,
  #|       });
  #|       rt.depthWidth = w;
  #|       rt.depthHeight = h;
  #|       rt.depthView = rt.depthTexture.createView();
  #|     };
  #|
  #|     rt.ensureDynamicBuffer = (name, byteSize, usage) => {
  #|       const existed = rt.dynamicBuffers.get(name);
  #|       if (!existed || existed.size < byteSize) {
  #|         if (existed?.buffer) {
  #|           try { existed.buffer.destroy(); } catch (_err) {}
  #|         }
  #|         const size = nextPow2(Math.max(256, byteSize));
  #|         const buffer = rt.device.createBuffer({ size, usage: usage | GPUBufferUsage.COPY_DST });
  #|         rt.dynamicBuffers.set(name, { buffer, size });
  #|       }
  #|       return rt.dynamicBuffers.get(name).buffer;
  #|     };
  #|
  #|     rt.createImageTexture = (source, width, height) => {
  #|       const texture = rt.device.createTexture({
  #|         size: [Math.max(1, width), Math.max(1, height), 1],
  #|         format: 'rgba8unorm',
  #|         usage: GPUTextureUsage.COPY_DST | GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.RENDER_ATTACHMENT,
  #|       });
  #|       rt.device.queue.copyExternalImageToTexture(
  #|         { source },
  #|         { texture },
  #|         [Math.max(1, width), Math.max(1, height)],
  #|       );
  #|       return texture;
  #|     };
  #|
  #|     rt.ensureImage = (path) => {
  #|       let rec = rt.imageCache.get(path);
  #|       if (rec) return rec;
  #|       rec = { state: 'loading', texture: null, view: null, width: 1, height: 1, promise: null };
  #|       rec.promise = (async () => {
  #|         if (!rt.ready && rt.initPromise) {
  #|           await rt.initPromise;
  #|         }
  #|         const img = new Image();
  #|         img.src = path;
  #|         await img.decode();
  #|         const bitmap = await createImageBitmap(img);
  #|         rec.width = Math.max(1, bitmap.width);
  #|         rec.height = Math.max(1, bitmap.height);
  #|         rec.texture = rt.createImageTexture(bitmap, rec.width, rec.height);
  #|         rec.view = rec.texture.createView();
  #|         rec.state = 'ready';
  #|       })().catch(() => {
  #|         rec.state = 'error';
  #|       });
  #|       rt.imageCache.set(path, rec);
  #|       return rec;
  #|     };
  #|
  #|     rt.ensureSolidTexture = (key, r, g, b, a) => {
  #|       let rec = rt.imageCache.get(key);
  #|       if (rec) return rec;
  #|       if (!rt.ready) return null;
  #|       const cvs = document.createElement('canvas');
  #|       cvs.width = 1;
  #|       cvs.height = 1;
  #|       const ctx = cvs.getContext('2d');
  #|       ctx.fillStyle = `rgba(${r}, ${g}, ${b}, ${a})`;
  #|       ctx.fillRect(0, 0, 1, 1);
  #|       const texture = rt.createImageTexture(cvs, 1, 1);
  #|       rec = { state: 'ready', texture, view: texture.createView(), width: 1, height: 1, promise: null };
  #|       rt.imageCache.set(key, rec);
  #|       return rec;
  #|     };
  #|
  #|     rt.ensureTextTexture = (text, family, size, r, g, b, a) => {
  #|       const key = `${text}\u0000${family}\u0000${size}\u0000${r}\u0000${g}\u0000${b}\u0000${a}`;
  #|       const existed = rt.textCache.get(key);
  #|       if (existed) return existed;
  #|       if (!rt.ready) return null;
  #|       const cvs = document.createElement('canvas');
  #|       const ctx = cvs.getContext('2d');
  #|       const font = `${size}px ${family}`;
  #|       ctx.font = font;
  #|       const m = ctx.measureText(text);
  #|       const ascent = Math.max(1, Math.ceil(m.actualBoundingBoxAscent || size * 0.8));
  #|       const descent = Math.max(1, Math.ceil(m.actualBoundingBoxDescent || size * 0.2));
  #|       const width = Math.max(1, Math.ceil(m.width + 4));
  #|       const height = Math.max(1, ascent + descent + 4);
  #|       cvs.width = width;
  #|       cvs.height = height;
  #|       const draw = cvs.getContext('2d');
  #|       draw.font = font;
  #|       draw.textBaseline = 'alphabetic';
  #|       draw.fillStyle = `rgba(${r}, ${g}, ${b}, ${a})`;
  #|       draw.fillText(text, 2, 2 + ascent);
  #|       const texture = rt.createImageTexture(cvs, width, height);
  #|       const rec = { texture, view: texture.createView(), width, height };
  #|       rt.textCache.set(key, rec);
  #|       return rec;
  #|     };
  #|
  #|     rt.uploadTextTexture = (key, width, height, pixels) => {
  #|       if (!rt.ready || !rt.device) return false;
  #|       try {
  #|         const w = Math.max(1, width | 0);
  #|         const h = Math.max(1, height | 0);
  #|         const src = Array.isArray(pixels) ? pixels : [];
  #|         const tightBytesPerRow = w * 4;
  #|         const bytesPerRow = Math.ceil(tightBytesPerRow / 256) * 256;
  #|         const data = new Uint8Array(bytesPerRow * h);
  #|         for (let y = 0; y < h; y += 1) {
  #|           const srcBase = y * tightBytesPerRow;
  #|           const dstBase = y * bytesPerRow;
  #|           for (let x = 0; x < tightBytesPerRow; x += 1) {
  #|             const idx = srcBase + x;
  #|             if (idx >= src.length) break;
  #|             data[dstBase + x] = src[idx] & 0xFF;
  #|           }
  #|         }
  #|         const prev = rt.textCache.get(key);
  #|         if (prev?.texture) {
  #|           try { prev.texture.destroy(); } catch (_err) {}
  #|         }
  #|         const texture = rt.device.createTexture({
  #|           size: [w, h, 1],
  #|           format: 'rgba8unorm',
  #|           usage: GPUTextureUsage.COPY_DST | GPUTextureUsage.TEXTURE_BINDING,
  #|         });
  #|         rt.device.queue.writeTexture(
  #|           { texture },
  #|           data,
  #|           { offset: 0, bytesPerRow, rowsPerImage: h },
  #|           [w, h, 1],
  #|         );
  #|         const rec = { texture, view: texture.createView(), width: w, height: h };
  #|         rt.textCache.set(key, rec);
  #|         return true;
  #|       } catch (_err) {
  #|         return false;
  #|       }
  #|     };
  #|
  #|     rt.pushCachedText = (key, x, y, ma, mb, mc, md, tx, ty, align, baseline) => {
  #|       const rec = rt.textCache.get(key);
  #|       if (!rec) return false;
  #|       let ox = x;
  #|       let oy = y;
  #|       if (align === 1) ox -= rec.width / 2;
  #|       else if (align === 2) ox -= rec.width;
  #|       if (baseline === 1) oy -= rec.height / 2;
  #|       else if (baseline === 2) oy -= rec.height;
  #|       const p0x = ma * 0 + mc * 0 + tx + ox;
  #|       const p0y = mb * 0 + md * 0 + ty + oy;
  #|       const p1x = ma * rec.width + mc * 0 + tx + ox;
  #|       const p1y = mb * rec.width + md * 0 + ty + oy;
  #|       const p2x = ma * rec.width + mc * rec.height + tx + ox;
  #|       const p2y = mb * rec.width + md * rec.height + ty + oy;
  #|       const p3x = ma * 0 + mc * rec.height + tx + ox;
  #|       const p3y = mb * 0 + md * rec.height + ty + oy;
  #|       const verts = new Float32Array([
  #|         p0x, p0y, 0, 0, 1, 1, 1, 1,
  #|         p1x, p1y, 1, 0, 1, 1, 1, 1,
  #|         p2x, p2y, 1, 1, 1, 1, 1, 1,
  #|         p0x, p0y, 0, 0, 1, 1, 1, 1,
  #|         p2x, p2y, 1, 1, 1, 1, 1, 1,
  #|         p3x, p3y, 0, 1, 1, 1, 1, 1,
  #|       ]);
  #|       rt.pushTex2d(0, rec, verts);
  #|       return true;
  #|     };
  #|
  #|     rt.pushColor2d = (topology, verts) => {
  #|       rt.draw2dCommands.push({ kind: 'color', topology, verts });
  #|     };
  #|     rt.pushTex2d = (samplerCode, textureRec, verts) => {
  #|       rt.draw2dCommands.push({
  #|         kind: 'tex',
  #|         samplerCode,
  #|         textureRec,
  #|         verts,
  #|       });
  #|     };
  #|
  #|     rt.pushRect = (x, y, w, h, ma, mb, mc, md, tx, ty, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|       const fill = colorNorm(fr, fg, fb, fa);
  #|       const p0x = ma * 0 + mc * 0 + tx + x;
  #|       const p0y = mb * 0 + md * 0 + ty + y;
  #|       const p1x = ma * w + mc * 0 + tx + x;
  #|       const p1y = mb * w + md * 0 + ty + y;
  #|       const p2x = ma * w + mc * h + tx + x;
  #|       const p2y = mb * w + md * h + ty + y;
  #|       const p3x = ma * 0 + mc * h + tx + x;
  #|       const p3y = mb * 0 + md * h + ty + y;
  #|       const verts = new Float32Array([
  #|         p0x, p0y, fill[0], fill[1], fill[2], fill[3],
  #|         p1x, p1y, fill[0], fill[1], fill[2], fill[3],
  #|         p2x, p2y, fill[0], fill[1], fill[2], fill[3],
  #|         p0x, p0y, fill[0], fill[1], fill[2], fill[3],
  #|         p2x, p2y, fill[0], fill[1], fill[2], fill[3],
  #|         p3x, p3y, fill[0], fill[1], fill[2], fill[3],
  #|       ]);
  #|       rt.pushColor2d('triangle', verts);
  #|       if (hasStroke) {
  #|         const s = colorNorm(sr, sg, sb, sa);
  #|         const line = new Float32Array([
  #|           p0x, p0y, s[0], s[1], s[2], s[3], p1x, p1y, s[0], s[1], s[2], s[3],
  #|           p1x, p1y, s[0], s[1], s[2], s[3], p2x, p2y, s[0], s[1], s[2], s[3],
  #|           p2x, p2y, s[0], s[1], s[2], s[3], p3x, p3y, s[0], s[1], s[2], s[3],
  #|           p3x, p3y, s[0], s[1], s[2], s[3], p0x, p0y, s[0], s[1], s[2], s[3],
  #|         ]);
  #|         rt.pushColor2d('line', line);
  #|       }
  #|     };
  #|
  #|     rt.pushGradientRect = (x, y, w, h, ma, mb, mc, md, tx, ty, sr, sg, sb, sa, er, eg, eb, ea) => {
  #|       const c0 = colorNorm(sr, sg, sb, sa);
  #|       const c1 = colorNorm(er, eg, eb, ea);
  #|       const cm = [
  #|         (c0[0] + c1[0]) * 0.5,
  #|         (c0[1] + c1[1]) * 0.5,
  #|         (c0[2] + c1[2]) * 0.5,
  #|         (c0[3] + c1[3]) * 0.5,
  #|       ];
  #|       const p0x = ma * 0 + mc * 0 + tx + x;
  #|       const p0y = mb * 0 + md * 0 + ty + y;
  #|       const p1x = ma * w + mc * 0 + tx + x;
  #|       const p1y = mb * w + md * 0 + ty + y;
  #|       const p2x = ma * w + mc * h + tx + x;
  #|       const p2y = mb * w + md * h + ty + y;
  #|       const p3x = ma * 0 + mc * h + tx + x;
  #|       const p3y = mb * 0 + md * h + ty + y;
  #|       const verts = new Float32Array([
  #|         p0x, p0y, c0[0], c0[1], c0[2], c0[3],
  #|         p1x, p1y, cm[0], cm[1], cm[2], cm[3],
  #|         p2x, p2y, c1[0], c1[1], c1[2], c1[3],
  #|         p0x, p0y, c0[0], c0[1], c0[2], c0[3],
  #|         p2x, p2y, c1[0], c1[1], c1[2], c1[3],
  #|         p3x, p3y, cm[0], cm[1], cm[2], cm[3],
  #|       ]);
  #|       rt.pushColor2d('triangle', verts);
  #|     };
  #|
  #|     rt.pushCircle = (cx, cy, radius, ma, mb, mc, md, tx, ty, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|       const n = 40;
  #|       const fill = colorNorm(fr, fg, fb, fa);
  #|       const tri = [];
  #|       for (let i = 0; i < n; i += 1) {
  #|         const a0 = (i / n) * Math.PI * 2.0;
  #|         const a1 = ((i + 1) / n) * Math.PI * 2.0;
  #|         const lx0 = Math.cos(a0) * radius;
  #|         const ly0 = Math.sin(a0) * radius;
  #|         const lx1 = Math.cos(a1) * radius;
  #|         const ly1 = Math.sin(a1) * radius;
  #|         const x0 = ma * lx0 + mc * ly0 + tx + cx;
  #|         const y0 = mb * lx0 + md * ly0 + ty + cy;
  #|         const x1 = ma * lx1 + mc * ly1 + tx + cx;
  #|         const y1 = mb * lx1 + md * ly1 + ty + cy;
  #|         tri.push(
  #|           tx + cx, ty + cy, fill[0], fill[1], fill[2], fill[3],
  #|           x0, y0, fill[0], fill[1], fill[2], fill[3],
  #|           x1, y1, fill[0], fill[1], fill[2], fill[3],
  #|         );
  #|       }
  #|       rt.pushColor2d('triangle', new Float32Array(tri));
  #|       if (hasStroke) {
  #|         const stroke = colorNorm(sr, sg, sb, sa);
  #|         const lines = [];
  #|         for (let i = 0; i < n; i += 1) {
  #|           const a0 = (i / n) * Math.PI * 2.0;
  #|           const a1 = ((i + 1) / n) * Math.PI * 2.0;
  #|           const lx0 = Math.cos(a0) * radius;
  #|           const ly0 = Math.sin(a0) * radius;
  #|           const lx1 = Math.cos(a1) * radius;
  #|           const ly1 = Math.sin(a1) * radius;
  #|           const x0 = ma * lx0 + mc * ly0 + tx + cx;
  #|           const y0 = mb * lx0 + md * ly0 + ty + cy;
  #|           const x1 = ma * lx1 + mc * ly1 + tx + cx;
  #|           const y1 = mb * lx1 + md * ly1 + ty + cy;
  #|           lines.push(
  #|             x0, y0, stroke[0], stroke[1], stroke[2], stroke[3],
  #|             x1, y1, stroke[0], stroke[1], stroke[2], stroke[3],
  #|           );
  #|         }
  #|         rt.pushColor2d('line', new Float32Array(lines));
  #|       }
  #|     };
  #|
  #|     rt.pushImage = (path, dx, dy, dw, dh, hasSource, sx, sy, sw, sh, a, b, c, d, tx, ty, repeatMode, tr, tg, tb, ta) => {
  #|       const rec = rt.ensureImage(path);
  #|       if (!rec || rec.state !== 'ready') return;
  #|       const p0x = a * 0 + c * 0 + tx + dx;
  #|       const p0y = b * 0 + d * 0 + ty + dy;
  #|       const p1x = a * dw + c * 0 + tx + dx;
  #|       const p1y = b * dw + d * 0 + ty + dy;
  #|       const p2x = a * dw + c * dh + tx + dx;
  #|       const p2y = b * dw + d * dh + ty + dy;
  #|       const p3x = a * 0 + c * dh + tx + dx;
  #|       const p3y = b * 0 + d * dh + ty + dy;
  #|
  #|       let u0 = 0;
  #|       let v0 = 0;
  #|       let u1 = 1;
  #|       let v1 = 1;
  #|       let samplerCode = 0;
  #|       if (hasSource) {
  #|         u0 = sx / rec.width;
  #|         v0 = sy / rec.height;
  #|         u1 = (sx + sw) / rec.width;
  #|         v1 = (sy + sh) / rec.height;
  #|         samplerCode = 0;
  #|       } else {
  #|         const scaleU = rec.width > 0 ? dw / rec.width : 1;
  #|         const scaleV = rec.height > 0 ? dh / rec.height : 1;
  #|         if (repeatMode === 3) {
  #|           u1 = scaleU;
  #|           v1 = scaleV;
  #|           samplerCode = 3;
  #|         } else if (repeatMode === 0) {
  #|           u1 = scaleU;
  #|           v1 = 1;
  #|           samplerCode = 1;
  #|         } else if (repeatMode === 1) {
  #|           u1 = 1;
  #|           v1 = scaleV;
  #|           samplerCode = 2;
  #|         } else {
  #|           u1 = 1;
  #|           v1 = 1;
  #|           samplerCode = 0;
  #|         }
  #|       }
  #|
  #|       const tint = colorNorm(tr, tg, tb, ta);
  #|       const verts = new Float32Array([
  #|         p0x, p0y, u0, v0, tint[0], tint[1], tint[2], tint[3],
  #|         p1x, p1y, u1, v0, tint[0], tint[1], tint[2], tint[3],
  #|         p2x, p2y, u1, v1, tint[0], tint[1], tint[2], tint[3],
  #|         p0x, p0y, u0, v0, tint[0], tint[1], tint[2], tint[3],
  #|         p2x, p2y, u1, v1, tint[0], tint[1], tint[2], tint[3],
  #|         p3x, p3y, u0, v1, tint[0], tint[1], tint[2], tint[3],
  #|       ]);
  #|       rt.pushTex2d(samplerCode, rec, verts);
  #|     };
  #|
  #|     rt.pushText = (text, x, y, ma, mb, mc, md, tx, ty, family, size, align, baseline, r, g, b, alpha) => {
  #|       const rec = rt.ensureTextTexture(text, family, size, r, g, b, alpha);
  #|       if (!rec) return;
  #|       let ox = x;
  #|       let oy = y;
  #|       if (align === 1) ox -= rec.width / 2;
  #|       else if (align === 2) ox -= rec.width;
  #|       if (baseline === 1) oy -= rec.height / 2;
  #|       else if (baseline === 2) oy -= rec.height;
  #|       const p0x = ma * 0 + mc * 0 + tx + ox;
  #|       const p0y = mb * 0 + md * 0 + ty + oy;
  #|       const p1x = ma * rec.width + mc * 0 + tx + ox;
  #|       const p1y = mb * rec.width + md * 0 + ty + oy;
  #|       const p2x = ma * rec.width + mc * rec.height + tx + ox;
  #|       const p2y = mb * rec.width + md * rec.height + ty + oy;
  #|       const p3x = ma * 0 + mc * rec.height + tx + ox;
  #|       const p3y = mb * 0 + md * rec.height + ty + oy;
  #|       const verts = new Float32Array([
  #|         p0x, p0y, 0, 0, 1, 1, 1, 1,
  #|         p1x, p1y, 1, 0, 1, 1, 1, 1,
  #|         p2x, p2y, 1, 1, 1, 1, 1, 1,
  #|         p0x, p0y, 0, 0, 1, 1, 1, 1,
  #|         p2x, p2y, 1, 1, 1, 1, 1, 1,
  #|         p3x, p3y, 0, 1, 1, 1, 1, 1,
  #|       ]);
  #|       rt.pushTex2d(0, rec, verts);
  #|     };
  #|
  #|     rt.transformVerts3dWithStride = (verts, stride, tx, ty, tz, qx, qy, qz, qw, normalOffset = -1, tangentOffset = -1) => {
  #|       let qnx = qx;
  #|       let qny = qy;
  #|       let qnz = qz;
  #|       let qnw = qw;
  #|       const qLen = Math.hypot(qnx, qny, qnz, qnw);
  #|       if (qLen <= 1e-8) {
  #|         qnx = 0;
  #|         qny = 0;
  #|         qnz = 0;
  #|         qnw = 1;
  #|       } else {
  #|         qnx /= qLen;
  #|         qny /= qLen;
  #|         qnz /= qLen;
  #|         qnw /= qLen;
  #|       }
  #|       const rotate = (x, y, z) => {
  #|         const dotUV = qnx * x + qny * y + qnz * z;
  #|         const dotUU = qnx * qnx + qny * qny + qnz * qnz;
  #|         const cx = qny * z - qnz * y;
  #|         const cy = qnz * x - qnx * z;
  #|         const cz = qnx * y - qny * x;
  #|         const rx = 2 * dotUV * qnx + (qnw * qnw - dotUU) * x + 2 * qnw * cx;
  #|         const ry = 2 * dotUV * qny + (qnw * qnw - dotUU) * y + 2 * qnw * cy;
  #|         const rz = 2 * dotUV * qnz + (qnw * qnw - dotUU) * z + 2 * qnw * cz;
  #|         return [rx, ry, rz];
  #|       };
  #|       for (let i = 0; i < verts.length; i += stride) {
  #|         const [rx, ry, rz] = rotate(verts[i], verts[i + 1], verts[i + 2]);
  #|         verts[i] = rx + tx;
  #|         verts[i + 1] = ry + ty;
  #|         verts[i + 2] = rz + tz;
  #|         if (normalOffset >= 0) {
  #|           const ni = i + normalOffset;
  #|           if (ni + 2 < verts.length) {
  #|             const [nx, ny, nz] = rotate(verts[ni], verts[ni + 1], verts[ni + 2]);
  #|             const len = Math.hypot(nx, ny, nz);
  #|             if (len > 1e-8) {
  #|               verts[ni] = nx / len;
  #|               verts[ni + 1] = ny / len;
  #|               verts[ni + 2] = nz / len;
  #|             } else {
  #|               verts[ni] = 0.0;
  #|               verts[ni + 1] = 1.0;
  #|               verts[ni + 2] = 0.0;
  #|             }
  #|           }
  #|         }
  #|         if (tangentOffset >= 0) {
  #|           const ti = i + tangentOffset;
  #|           if (ti + 2 < verts.length) {
  #|             const [txr, tyr, tzr] = rotate(verts[ti], verts[ti + 1], verts[ti + 2]);
  #|             const len = Math.hypot(txr, tyr, tzr);
  #|             if (len > 1e-8) {
  #|               verts[ti] = txr / len;
  #|               verts[ti + 1] = tyr / len;
  #|               verts[ti + 2] = tzr / len;
  #|             } else {
  #|               verts[ti] = 1.0;
  #|               verts[ti + 1] = 0.0;
  #|               verts[ti + 2] = 0.0;
  #|             }
  #|           }
  #|         }
  #|       }
  #|       return verts;
  #|     };
  #|     rt.transformVerts3d = (verts, tx, ty, tz, qx, qy, qz, qw) =>
  #|       rt.transformVerts3dWithStride(verts, 7, tx, ty, tz, qx, qy, qz, qw);
  #|     rt.transformTexVerts3d = (verts, tx, ty, tz, qx, qy, qz, qw) =>
  #|       rt.transformVerts3dWithStride(verts, 9, tx, ty, tz, qx, qy, qz, qw);
  #|     rt.transformLitVerts3d = (verts, tx, ty, tz, qx, qy, qz, qw) =>
  #|       rt.transformVerts3dWithStride(verts, 17, tx, ty, tz, qx, qy, qz, qw, 3);
  #|     rt.transformLitTexVerts3d = (verts, tx, ty, tz, qx, qy, qz, qw) =>
  #|       rt.transformVerts3dWithStride(verts, 35, tx, ty, tz, qx, qy, qz, qw, 3, 23);
  #|
  #|     rt.makeCube = (sx, sy, sz, color) => {
  #|       const hx = sx / 2;
  #|       const hy = sy / 2;
  #|       const hz = sz / 2;
  #|       const p = [
  #|         [-hx, -hy, -hz],
  #|         [hx, -hy, -hz],
  #|         [hx, hy, -hz],
  #|         [-hx, hy, -hz],
  #|         [-hx, -hy, hz],
  #|         [hx, -hy, hz],
  #|         [hx, hy, hz],
  #|         [-hx, hy, hz],
  #|       ];
  #|       const idx = [
  #|         0, 1, 2, 0, 2, 3,
  #|         5, 4, 7, 5, 7, 6,
  #|         4, 0, 3, 4, 3, 7,
  #|         1, 5, 6, 1, 6, 2,
  #|         3, 2, 6, 3, 6, 7,
  #|         4, 5, 1, 4, 1, 0,
  #|       ];
  #|       const out = [];
  #|       for (let i = 0; i < idx.length; i += 1) {
  #|         const v = p[idx[i]];
  #|         out.push(v[0], v[1], v[2], color[0], color[1], color[2], color[3]);
  #|       }
  #|       return new Float32Array(out);
  #|     };
  #|
  #|     rt.pushLitVertex = (out, position, normal, color, emissive, alphaMode, alphaCutoff, unlit) => {
  #|       out.push(
  #|         position[0], position[1], position[2],
  #|         normal[0], normal[1], normal[2],
  #|         color[0], color[1], color[2], color[3],
  #|         emissive[0], emissive[1], emissive[2],
  #|         alphaMode,
  #|         alphaCutoff,
  #|         unlit ? 1.0 : 0.0,
  #|         0.0,
  #|       );
  #|     };
  #|
  #|     rt.makeLitCube = (sx, sy, sz, color, emissive, alphaMode, alphaCutoff, unlit) => {
  #|       const hx = sx / 2;
  #|       const hy = sy / 2;
  #|       const hz = sz / 2;
  #|       const faces = [
  #|         { normal: [0, 0, -1], corners: [[-hx, -hy, -hz], [-hx, hy, -hz], [hx, hy, -hz], [hx, -hy, -hz]] },
  #|         { normal: [0, 0, 1], corners: [[-hx, -hy, hz], [hx, -hy, hz], [hx, hy, hz], [-hx, hy, hz]] },
  #|         { normal: [-1, 0, 0], corners: [[-hx, -hy, hz], [-hx, hy, hz], [-hx, hy, -hz], [-hx, -hy, -hz]] },
  #|         { normal: [1, 0, 0], corners: [[hx, -hy, -hz], [hx, hy, -hz], [hx, hy, hz], [hx, -hy, hz]] },
  #|         { normal: [0, 1, 0], corners: [[-hx, hy, -hz], [-hx, hy, hz], [hx, hy, hz], [hx, hy, -hz]] },
  #|         { normal: [0, -1, 0], corners: [[-hx, -hy, hz], [-hx, -hy, -hz], [hx, -hy, -hz], [hx, -hy, hz]] },
  #|       ];
  #|       const out = [];
  #|       for (let index = 0; index < faces.length; index += 1) {
  #|         const face = faces[index];
  #|         rt.pushLitVertex(out, face.corners[0], face.normal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, face.corners[1], face.normal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, face.corners[2], face.normal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, face.corners[0], face.normal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, face.corners[2], face.normal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, face.corners[3], face.normal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|       }
  #|       return new Float32Array(out);
  #|     };
  #|
  #|     rt.makeCubeEdges = (sx, sy, sz, color) => {
  #|       const hx = sx / 2;
  #|       const hy = sy / 2;
  #|       const hz = sz / 2;
  #|       const p = [
  #|         [-hx, -hy, -hz],
  #|         [hx, -hy, -hz],
  #|         [hx, hy, -hz],
  #|         [-hx, hy, -hz],
  #|         [-hx, -hy, hz],
  #|         [hx, -hy, hz],
  #|         [hx, hy, hz],
  #|         [-hx, hy, hz],
  #|       ];
  #|       const e = [
  #|         0,1, 1,2, 2,3, 3,0,
  #|         4,5, 5,6, 6,7, 7,4,
  #|         0,4, 1,5, 2,6, 3,7,
  #|       ];
  #|       const out = [];
  #|       for (let i = 0; i < e.length; i += 1) {
  #|         const v = p[e[i]];
  #|         out.push(v[0], v[1], v[2], color[0], color[1], color[2], color[3]);
  #|       }
  #|       return new Float32Array(out);
  #|     };
  #|
  #|     rt.makeSphere = (radius, color) => {
  #|       const stacks = 12;
  #|       const slices = 24;
  #|       const out = [];
  #|       for (let i = 0; i < stacks; i += 1) {
  #|         const v0 = i / stacks;
  #|         const v1 = (i + 1) / stacks;
  #|         const phi0 = v0 * Math.PI;
  #|         const phi1 = v1 * Math.PI;
  #|         for (let j = 0; j < slices; j += 1) {
  #|           const u0 = j / slices;
  #|           const u1 = (j + 1) / slices;
  #|           const th0 = u0 * Math.PI * 2;
  #|           const th1 = u1 * Math.PI * 2;
  #|           const p0 = [Math.cos(th0) * Math.sin(phi0) * radius, Math.cos(phi0) * radius, Math.sin(th0) * Math.sin(phi0) * radius];
  #|           const p1 = [Math.cos(th1) * Math.sin(phi0) * radius, Math.cos(phi0) * radius, Math.sin(th1) * Math.sin(phi0) * radius];
  #|           const p2 = [Math.cos(th1) * Math.sin(phi1) * radius, Math.cos(phi1) * radius, Math.sin(th1) * Math.sin(phi1) * radius];
  #|           const p3 = [Math.cos(th0) * Math.sin(phi1) * radius, Math.cos(phi1) * radius, Math.sin(th0) * Math.sin(phi1) * radius];
  #|           out.push(
  #|             p0[0], p0[1], p0[2], color[0], color[1], color[2], color[3],
  #|             p1[0], p1[1], p1[2], color[0], color[1], color[2], color[3],
  #|             p2[0], p2[1], p2[2], color[0], color[1], color[2], color[3],
  #|             p0[0], p0[1], p0[2], color[0], color[1], color[2], color[3],
  #|             p2[0], p2[1], p2[2], color[0], color[1], color[2], color[3],
  #|             p3[0], p3[1], p3[2], color[0], color[1], color[2], color[3],
  #|           );
  #|         }
  #|       }
  #|       return new Float32Array(out);
  #|     };
  #|
  #|     rt.makeLitSphere = (radius, color, emissive, alphaMode, alphaCutoff, unlit) => {
  #|       const stacks = 12;
  #|       const slices = 24;
  #|       const out = [];
  #|       const safeRadius = Math.max(Math.abs(radius), 0.0001);
  #|       const pushSphereVertex = (point) => {
  #|         const normal = [point[0] / safeRadius, point[1] / safeRadius, point[2] / safeRadius];
  #|         rt.pushLitVertex(out, point, normal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|       };
  #|       for (let i = 0; i < stacks; i += 1) {
  #|         const v0 = i / stacks;
  #|         const v1 = (i + 1) / stacks;
  #|         const phi0 = v0 * Math.PI;
  #|         const phi1 = v1 * Math.PI;
  #|         for (let j = 0; j < slices; j += 1) {
  #|           const u0 = j / slices;
  #|           const u1 = (j + 1) / slices;
  #|           const th0 = u0 * Math.PI * 2;
  #|           const th1 = u1 * Math.PI * 2;
  #|           const p0 = [Math.cos(th0) * Math.sin(phi0) * radius, Math.cos(phi0) * radius, Math.sin(th0) * Math.sin(phi0) * radius];
  #|           const p1 = [Math.cos(th1) * Math.sin(phi0) * radius, Math.cos(phi0) * radius, Math.sin(th1) * Math.sin(phi0) * radius];
  #|           const p2 = [Math.cos(th1) * Math.sin(phi1) * radius, Math.cos(phi1) * radius, Math.sin(th1) * Math.sin(phi1) * radius];
  #|           const p3 = [Math.cos(th0) * Math.sin(phi1) * radius, Math.cos(phi1) * radius, Math.sin(th0) * Math.sin(phi1) * radius];
  #|           pushSphereVertex(p0);
  #|           pushSphereVertex(p1);
  #|           pushSphereVertex(p2);
  #|           pushSphereVertex(p0);
  #|           pushSphereVertex(p2);
  #|           pushSphereVertex(p3);
  #|         }
  #|       }
  #|       return new Float32Array(out);
  #|     };
  #|
  #|     rt.makeCylinder = (rtTop, rtBottom, height, slices, color) => {
  #|       const out = [];
  #|       const h2 = height / 2;
  #|       const n = Math.max(3, slices | 0);
  #|       for (let i = 0; i < n; i += 1) {
  #|         const a0 = (i / n) * Math.PI * 2;
  #|         const a1 = ((i + 1) / n) * Math.PI * 2;
  #|         const t0 = [Math.cos(a0) * rtTop, h2, Math.sin(a0) * rtTop];
  #|         const t1 = [Math.cos(a1) * rtTop, h2, Math.sin(a1) * rtTop];
  #|         const b0 = [Math.cos(a0) * rtBottom, -h2, Math.sin(a0) * rtBottom];
  #|         const b1 = [Math.cos(a1) * rtBottom, -h2, Math.sin(a1) * rtBottom];
  #|         out.push(
  #|           t0[0], t0[1], t0[2], color[0], color[1], color[2], color[3],
  #|           b0[0], b0[1], b0[2], color[0], color[1], color[2], color[3],
  #|           b1[0], b1[1], b1[2], color[0], color[1], color[2], color[3],
  #|           t0[0], t0[1], t0[2], color[0], color[1], color[2], color[3],
  #|           b1[0], b1[1], b1[2], color[0], color[1], color[2], color[3],
  #|           t1[0], t1[1], t1[2], color[0], color[1], color[2], color[3],
  #|         );
  #|         const top = [0, h2, 0];
  #|         out.push(
  #|           top[0], top[1], top[2], color[0], color[1], color[2], color[3],
  #|           t1[0], t1[1], t1[2], color[0], color[1], color[2], color[3],
  #|           t0[0], t0[1], t0[2], color[0], color[1], color[2], color[3],
  #|         );
  #|         const bottom = [0, -h2, 0];
  #|         out.push(
  #|           bottom[0], bottom[1], bottom[2], color[0], color[1], color[2], color[3],
  #|           b0[0], b0[1], b0[2], color[0], color[1], color[2], color[3],
  #|           b1[0], b1[1], b1[2], color[0], color[1], color[2], color[3],
  #|         );
  #|       }
  #|       return new Float32Array(out);
  #|     };
  #|
  #|     rt.makeLitCylinder = (rtTop, rtBottom, height, slices, color, emissive, alphaMode, alphaCutoff, unlit) => {
  #|       const out = [];
  #|       const h2 = height / 2;
  #|       const n = Math.max(3, slices | 0);
  #|       const safeHeight = Math.max(Math.abs(height), 0.0001);
  #|       const slope = (rtBottom - rtTop) / safeHeight;
  #|       const sideNormal = (angle) => {
  #|         const normal = [Math.cos(angle), slope, Math.sin(angle)];
  #|         const len = Math.hypot(normal[0], normal[1], normal[2]);
  #|         if (len <= 1e-8) return [1, 0, 0];
  #|         return [normal[0] / len, normal[1] / len, normal[2] / len];
  #|       };
  #|       for (let i = 0; i < n; i += 1) {
  #|         const a0 = (i / n) * Math.PI * 2;
  #|         const a1 = ((i + 1) / n) * Math.PI * 2;
  #|         const t0 = [Math.cos(a0) * rtTop, h2, Math.sin(a0) * rtTop];
  #|         const t1 = [Math.cos(a1) * rtTop, h2, Math.sin(a1) * rtTop];
  #|         const b0 = [Math.cos(a0) * rtBottom, -h2, Math.sin(a0) * rtBottom];
  #|         const b1 = [Math.cos(a1) * rtBottom, -h2, Math.sin(a1) * rtBottom];
  #|         const n0 = sideNormal(a0);
  #|         const n1 = sideNormal(a1);
  #|         rt.pushLitVertex(out, t0, n0, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, b0, n0, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, b1, n1, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, t0, n0, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, b1, n1, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, t1, n1, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         const top = [0, h2, 0];
  #|         const topNormal = [0, 1, 0];
  #|         rt.pushLitVertex(out, top, topNormal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, t1, topNormal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, t0, topNormal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         const bottom = [0, -h2, 0];
  #|         const bottomNormal = [0, -1, 0];
  #|         rt.pushLitVertex(out, bottom, bottomNormal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, b0, bottomNormal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|         rt.pushLitVertex(out, b1, bottomNormal, color, emissive, alphaMode, alphaCutoff, unlit);
  #|       }
  #|       return new Float32Array(out);
  #|     };
  #|
  #|     rt.begin3d = (px, py, pz, tx, ty, tz, ux, uy, uz, fovy, near, far, orthographic, orthoWidth, orthoHeight) => {
  #|       const section = {
  #|         camera: {
  #|           position: [px, py, pz],
  #|           target: [tx, ty, tz],
  #|           up: [ux, uy, uz],
  #|           fovy,
  #|           near,
  #|           far,
  #|           orthographic: orthographic !== 0,
  #|           orthoWidth,
  #|           orthoHeight,
  #|         },
  #|         triCommands: [],
  #|         litTriCommands: [],
  #|         texTriCommands: [],
  #|         lineCommands: [],
  #|       };
  #|       rt.sections3d.push(section);
  #|       rt.current3dSection = section;
  #|     };
  #|     rt.end3d = () => {
  #|       rt.current3dSection = null;
  #|     };
  #|     rt.pushCube3d = (cx, cy, cz, sx, sy, sz, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows) => {
  #|       if (!rt.current3dSection) return;
  #|       const verts = rt.makeLitCube(
  #|         sx,
  #|         sy,
  #|         sz,
  #|         colorNorm(r, g, b, a),
  #|         [clamp01(emissiveR), clamp01(emissiveG), clamp01(emissiveB)],
  #|         Number(alphaMode) || 0.0,
  #|         Math.max(0.0, Number(alphaCutoff) || 0.0),
  #|         !!unlit,
  #|       );
  #|       rt.pushColoredTriangles3d(verts, cx, cy, cz, qx, qy, qz, qw, false, castShadows, receiveShadows);
  #|     };
  #|     rt.pushCubeWires3d = (cx, cy, cz, sx, sy, sz, qx, qy, qz, qw, r, g, b, a) => {
  #|       if (!rt.current3dSection) return;
  #|       const verts = rt.makeCubeEdges(sx, sy, sz, colorNorm(r, g, b, a));
  #|       rt.transformVerts3d(verts, cx, cy, cz, qx, qy, qz, qw);
  #|       rt.current3dSection.lineCommands.push(verts);
  #|     };
  #|     rt.pushSphere3d = (cx, cy, cz, radius, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows) => {
  #|       if (!rt.current3dSection) return;
  #|       const verts = rt.makeLitSphere(
  #|         radius,
  #|         colorNorm(r, g, b, a),
  #|         [clamp01(emissiveR), clamp01(emissiveG), clamp01(emissiveB)],
  #|         Number(alphaMode) || 0.0,
  #|         Math.max(0.0, Number(alphaCutoff) || 0.0),
  #|         !!unlit,
  #|       );
  #|       rt.pushColoredTriangles3d(verts, cx, cy, cz, qx, qy, qz, qw, false, castShadows, receiveShadows);
  #|     };
  #|     rt.pushCylinder3d = (cx, cy, cz, rtTop, rtBottom, h, slices, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows) => {
  #|       if (!rt.current3dSection) return;
  #|       const verts = rt.makeLitCylinder(
  #|         rtTop,
  #|         rtBottom,
  #|         h,
  #|         slices,
  #|         colorNorm(r, g, b, a),
  #|         [clamp01(emissiveR), clamp01(emissiveG), clamp01(emissiveB)],
  #|         Number(alphaMode) || 0.0,
  #|         Math.max(0.0, Number(alphaCutoff) || 0.0),
  #|         !!unlit,
  #|       );
  #|       rt.pushColoredTriangles3d(verts, cx, cy, cz, qx, qy, qz, qw, false, castShadows, receiveShadows);
  #|     };
  #|     rt.pushTriangles3d = (verts, tx, ty, tz, qx, qy, qz, qw, r, g, b, a) => {
  #|       if (!rt.current3dSection) return;
  #|       if (!verts || verts.length < 9) return;
  #|       const triVertexCount = Math.floor(verts.length / 3);
  #|       if (triVertexCount < 3) return;
  #|       const out = new Float32Array(triVertexCount * 7);
  #|       const cr = clamp01((r || 0) / 255.0);
  #|       const cg = clamp01((g || 0) / 255.0);
  #|       const cb = clamp01((b || 0) / 255.0);
  #|       const ca = clamp01(a ?? 1.0);
  #|       for (let i = 0; i < triVertexCount; i += 1) {
  #|         const src = i * 3;
  #|         const dst = i * 7;
  #|         out[dst] = Number(verts[src]) || 0.0;
  #|         out[dst + 1] = Number(verts[src + 1]) || 0.0;
  #|         out[dst + 2] = Number(verts[src + 2]) || 0.0;
  #|         out[dst + 3] = cr;
  #|         out[dst + 4] = cg;
  #|         out[dst + 5] = cb;
  #|         out[dst + 6] = ca;
  #|       }
  #|       rt.transformVerts3d(out, tx, ty, tz, qx, qy, qz, qw);
  #|       rt.current3dSection.triCommands.push({ verts: out, castShadows: true });
  #|     };
  #|     rt.pushColoredTriangles3d = (verts, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows) => {
  #|       if (!rt.current3dSection) return;
  #|       if (!verts || verts.length < 51) return;
  #|       const triVertexCount = Math.floor(verts.length / 17);
  #|       if (triVertexCount < 3) return;
  #|       const out = new Float32Array(triVertexCount * 17);
  #|       for (let i = 0; i < out.length; i += 1) {
  #|         out[i] = Number(verts[i]) || 0.0;
  #|       }
  #|       rt.transformLitVerts3d(out, tx, ty, tz, qx, qy, qz, qw);
  #|       if (out.length >= 17) {
  #|         const receiveValue = receiveShadows ? 1.0 : 0.0;
  #|         for (let index = 16; index < out.length; index += 17) {
  #|           out[index] = receiveValue;
  #|         }
  #|       }
  #|       rt.current3dSection.litTriCommands.push({
  #|         verts: out,
  #|         doubleSided: !!doubleSided,
  #|         castShadows: !!castShadows,
  #|         receiveShadows: !!receiveShadows,
  #|       });
  #|     };
  #|     rt.pushTexturedTriangles3d = (basePath, emissivePath, metallicRoughnessPath, occlusionPath, normalPath, baseSamplerCode, emissiveSamplerCode, metallicRoughnessSamplerCode, occlusionSamplerCode, normalSamplerCode, verts, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows) => {
  #|       if (!rt.current3dSection) return;
  #|       if (!verts || verts.length < 105) return;
  #|       const baseRec = (basePath && basePath.length > 0)
  #|         ? rt.ensureImage(basePath)
  #|         : rt.ensureSolidTexture('__solid:white', 255, 255, 255, 1.0);
  #|       const emissiveRec = (emissivePath && emissivePath.length > 0)
  #|         ? rt.ensureImage(emissivePath)
  #|         : rt.ensureSolidTexture('__solid:white', 255, 255, 255, 1.0);
  #|       const metallicRoughnessRec = (metallicRoughnessPath && metallicRoughnessPath.length > 0)
  #|         ? rt.ensureImage(metallicRoughnessPath)
  #|         : rt.ensureSolidTexture('__solid:white', 255, 255, 255, 1.0);
  #|       const occlusionRec = (occlusionPath && occlusionPath.length > 0)
  #|         ? rt.ensureImage(occlusionPath)
  #|         : rt.ensureSolidTexture('__solid:white', 255, 255, 255, 1.0);
  #|       const normalRec = (normalPath && normalPath.length > 0)
  #|         ? rt.ensureImage(normalPath)
  #|         : rt.ensureSolidTexture('__solid:normal', 128, 128, 255, 1.0);
  #|       if (!baseRec || !emissiveRec || !metallicRoughnessRec || !occlusionRec || !normalRec) return;
  #|       const triVertexCount = Math.floor(verts.length / 35);
  #|       if (triVertexCount < 3) return;
  #|       const out = new Float32Array(triVertexCount * 35);
  #|       for (let i = 0; i < out.length; i += 1) {
  #|         out[i] = Number(verts[i]) || 0.0;
  #|       }
  #|       rt.transformLitTexVerts3d(out, tx, ty, tz, qx, qy, qz, qw);
  #|       if (out.length >= 35) {
  #|         const receiveValue = receiveShadows ? 1.0 : 0.0;
  #|         for (let index = 34; index < out.length; index += 35) {
  #|           out[index] = receiveValue;
  #|         }
  #|       }
  #|       rt.current3dSection.texTriCommands.push({
  #|         textureRec: baseRec,
  #|         emissiveTextureRec: emissiveRec,
  #|         metallicRoughnessTextureRec: metallicRoughnessRec,
  #|         occlusionTextureRec: occlusionRec,
  #|         normalTextureRec: normalRec,
  #|         baseSamplerCode,
  #|         emissiveSamplerCode,
  #|         metallicRoughnessSamplerCode,
  #|         occlusionSamplerCode,
  #|         normalSamplerCode,
  #|         verts: out,
  #|         doubleSided: !!doubleSided,
  #|         castShadows: !!castShadows,
  #|         receiveShadows: !!receiveShadows,
  #|       });
  #|     };
  #|
  #|     rt.beginFrame = (r, g, b, a) => {
  #|       rt.clearColor = [clamp01(r), clamp01(g), clamp01(b), clamp01(a)];
  #|       rt.draw2dCommands.length = 0;
  #|       rt.sections3d.length = 0;
  #|       rt.current3dSection = null;
  #|     };
  #|
  #|     rt.resolveSampler = (samplerCode) =>
  #|       samplerCode === 3
  #|         ? rt.samplers.repeat
  #|         : (samplerCode === 1
  #|           ? rt.samplers.repeatX
  #|           : (samplerCode === 2 ? rt.samplers.repeatY : rt.samplers.clamp));
  #|
  #|     rt.uploadCommandBuffer3d = (name, commands, getVerts) => {
  #|       if (!commands || commands.length === 0) {
  #|         return { buffer: null, offsets: [] };
  #|       }
  #|       let totalBytes = 0;
  #|       for (const command of commands) {
  #|         const verts = getVerts(command);
  #|         totalBytes += verts?.byteLength || 0;
  #|       }
  #|       if (totalBytes <= 0) {
  #|         return { buffer: null, offsets: [] };
  #|       }
  #|       const buffer = rt.ensureDynamicBuffer(name, totalBytes, GPUBufferUsage.VERTEX);
  #|       const offsets = [];
  #|       let offset = 0;
  #|       for (const command of commands) {
  #|         const verts = getVerts(command);
  #|         offsets.push(offset);
  #|         if (verts?.byteLength > 0) {
  #|           rt.device.queue.writeBuffer(buffer, offset, verts.buffer, verts.byteOffset, verts.byteLength);
  #|           offset += verts.byteLength;
  #|         }
  #|       }
  #|       return { buffer, offsets };
  #|     };
  #|
  #|     rt.prepareSectionBuffers3d = (section) => ({
  #|       tri: rt.uploadCommandBuffer3d('dyn3dTri', section.triCommands, (cmd) => cmd.verts),
  #|       line: rt.uploadCommandBuffer3d('dyn3dLine', section.lineCommands, (verts) => verts),
  #|       lit: rt.uploadCommandBuffer3d('dyn3dLitTri', section.litTriCommands, (cmd) => cmd.verts),
  #|       tex: rt.uploadCommandBuffer3d('dyn3dLitTexTri', section.texTriCommands, (cmd) => cmd.verts),
  #|     });
  #|
  #|     rt.ensureShadowCameraBuffer = (index) => {
  #|       while (rt.shadowCameraBuffers.length <= index) {
  #|         rt.shadowCameraBuffers.push(
  #|           rt.device.createBuffer({ size: 64, usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
  #|         );
  #|       }
  #|       return rt.shadowCameraBuffers[index];
  #|     };
  #|
  #|     rt.makeShadowTexBindGroup = (cmd, shadowCameraBuffer) => rt.device.createBindGroup({
  #|       layout: rt.bindGroupLayouts.shadow3dTex,
  #|       entries: [
  #|         { binding: 0, resource: { buffer: shadowCameraBuffer } },
  #|         { binding: 1, resource: rt.resolveSampler(cmd.baseSamplerCode) },
  #|         { binding: 2, resource: cmd.textureRec.view },
  #|       ],
  #|     });
  #|
  #|     rt.renderShadowCastersForSetup = (pass, section, buffers, lightViewProjection, shadowCameraBufferIndex) => {
  #|       const shadowCameraBuffer = rt.ensureShadowCameraBuffer(shadowCameraBufferIndex);
  #|       rt.device.queue.writeBuffer(
  #|         shadowCameraBuffer,
  #|         0,
  #|         lightViewProjection.buffer,
  #|         lightViewProjection.byteOffset,
  #|         lightViewProjection.byteLength,
  #|       );
  #|       const solidBindGroup = rt.device.createBindGroup({
  #|         layout: rt.bindGroupLayouts.shadow3d,
  #|         entries: [{ binding: 0, resource: { buffer: shadowCameraBuffer } }],
  #|       });
  #|       pass.setBindGroup(0, solidBindGroup);
  #|       if (buffers.tri.buffer && section.triCommands.length > 0) {
  #|         pass.setPipeline(rt.pipelines.shadow3dTri);
  #|         for (let index = 0; index < section.triCommands.length; index += 1) {
  #|           const cmd = section.triCommands[index];
  #|           if (!cmd.castShadows) continue;
  #|           pass.setVertexBuffer(0, buffers.tri.buffer, buffers.tri.offsets[index], cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 7, 1, 0, 0);
  #|         }
  #|       }
  #|       if (buffers.lit.buffer && section.litTriCommands.length > 0) {
  #|         pass.setPipeline(rt.pipelines.shadow3dLitTri);
  #|         for (let index = 0; index < section.litTriCommands.length; index += 1) {
  #|           const cmd = section.litTriCommands[index];
  #|           if (!cmd.castShadows) continue;
  #|           pass.setBindGroup(0, solidBindGroup);
  #|           pass.setVertexBuffer(0, buffers.lit.buffer, buffers.lit.offsets[index], cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 17, 1, 0, 0);
  #|         }
  #|       }
  #|       if (buffers.tex.buffer && section.texTriCommands.length > 0) {
  #|         pass.setPipeline(rt.pipelines.shadow3dTexTri);
  #|         for (let index = 0; index < section.texTriCommands.length; index += 1) {
  #|           const cmd = section.texTriCommands[index];
  #|           if (!cmd.castShadows || !cmd.textureRec?.view) continue;
  #|           pass.setBindGroup(0, rt.makeShadowTexBindGroup(cmd, shadowCameraBuffer));
  #|           pass.setVertexBuffer(0, buffers.tex.buffer, buffers.tex.offsets[index], cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 35, 1, 0, 0);
  #|         }
  #|       }
  #|     };
  #|
  #|     rt.createShadowState3d = () => ({
  #|       directionalRecords: [rt.ensureDummyShadowTexture(), rt.ensureDummyShadowTexture(), rt.ensureDummyShadowTexture(), rt.ensureDummyShadowTexture()],
  #|       directionalEnabled: [0, 0, 0, 0],
  #|       directionalCascadeCounts: [0, 0, 0, 0],
  #|       directionalDepthBiases: [0, 0, 0, 0],
  #|       directionalNormalBiases: [0, 0, 0, 0],
  #|       directionalMatrices: Array.from({ length: 16 }, () => new Float32Array(16)),
  #|       directionalRects: Array.from({ length: 16 }, () => [0, 0, 0, 0]),
  #|       directionalBounds: Array.from({ length: 16 }, () => [0, 0, 0, 0]),
  #|       directionalTexel: [0, 0],
  #|       spotRecord: rt.ensureDummyShadowTexture(),
  #|       spotEnabled: [0, 0, 0, 0],
  #|       spotDepthBiases: [0, 0, 0, 0],
  #|       spotNormalBiases: [0, 0, 0, 0],
  #|       spotMatrices: Array.from({ length: 4 }, () => new Float32Array(16)),
  #|       spotRects: Array.from({ length: 4 }, () => [0, 0, 0, 0]),
  #|       spotTexel: [0, 0],
  #|       pointRecord: rt.ensureDummyShadowTexture(),
  #|       pointEnabled: [0, 0, 0, 0, 0, 0, 0, 0],
  #|       pointDepthBiases: [0, 0, 0, 0, 0, 0, 0, 0],
  #|       pointNormalBiases: [0, 0, 0, 0, 0, 0, 0, 0],
  #|       pointMatrices: Array.from({ length: 48 }, () => new Float32Array(16)),
  #|       pointRects: Array.from({ length: 48 }, () => [0, 0, 0, 0]),
  #|       pointTexel: [0, 0],
  #|       shadowCameraBufferCursor: 0,
  #|     });
  #|
  #|     rt.renderDirectionalShadowMaps3d = (encoder, section, buffers, camera, aspect, light, shadowState) => {
  #|       const directionalLights = Array.isArray(light.directionalLights) ? light.directionalLights : [];
  #|       const tileSize = Math.max(1, Number(light.directionalShadowMapSize) || 2048);
  #|       if (directionalLights.length <= 0) return;
  #|       for (let lightIndex = 0; lightIndex < Math.min(4, directionalLights.length); lightIndex += 1) {
  #|         const directionalLight = directionalLights[lightIndex];
  #|         if (!directionalLight?.shadows) continue;
  #|         const cascades = buildDirectionalShadowCascadesForLight(directionalLight, camera, aspect, tileSize);
  #|         if (cascades.length <= 0) continue;
  #|         const record = rt.ensureDirectionalShadowTexture(lightIndex, tileSize, cascades.length);
  #|         if (!record?.view) continue;
  #|         shadowState.directionalRecords[lightIndex] = record;
  #|         shadowState.directionalEnabled[lightIndex] = 1;
  #|         shadowState.directionalCascadeCounts[lightIndex] = cascades.length;
  #|         shadowState.directionalDepthBiases[lightIndex] = Math.max(0, Number(directionalLight.depthBias) || 0);
  #|         shadowState.directionalNormalBiases[lightIndex] = Math.max(0, Number(directionalLight.normalBias) || 0);
  #|         shadowState.directionalTexel = [1 / tileSize, 1 / tileSize];
  #|         const pass = encoder.beginRenderPass({
  #|           colorAttachments: [],
  #|           depthStencilAttachment: {
  #|             view: record.view,
  #|             depthClearValue: 1.0,
  #|             depthLoadOp: 'clear',
  #|             depthStoreOp: 'store',
  #|           },
  #|         });
  #|         for (let cascadeIndex = 0; cascadeIndex < cascades.length; cascadeIndex += 1) {
  #|           const cascade = cascades[cascadeIndex];
  #|           const viewportX = cascade.atlasRect.offset[0] * record.width;
  #|           const viewportY = cascade.atlasRect.offset[1] * record.height;
  #|           const scissorX = Math.max(0, Math.floor(viewportX));
  #|           const scissorY = Math.max(0, Math.floor(viewportY));
  #|           pass.setViewport(viewportX, viewportY, tileSize, tileSize, 0.0, 1.0);
  #|           pass.setScissorRect(scissorX, scissorY, tileSize | 0, tileSize | 0);
  #|           rt.renderShadowCastersForSetup(
  #|             pass,
  #|             section,
  #|             buffers,
  #|             cascade.lightViewProjection,
  #|             shadowState.shadowCameraBufferCursor,
  #|           );
  #|           shadowState.shadowCameraBufferCursor += 1;
  #|           const stateIndex = lightIndex * 4 + cascadeIndex;
  #|           shadowState.directionalMatrices[stateIndex] = cascade.lightViewProjection;
  #|           shadowState.directionalRects[stateIndex] = [
  #|             cascade.atlasRect.offset[0],
  #|             cascade.atlasRect.offset[1],
  #|             cascade.atlasRect.scale[0],
  #|             cascade.atlasRect.scale[1],
  #|           ];
  #|           shadowState.directionalBounds[stateIndex] = [cascade.nearBound, cascade.farBound, 0, 0];
  #|         }
  #|         pass.end();
  #|       }
  #|     };
  #|
  #|     rt.renderSpotShadowMaps3d = (encoder, section, buffers, light, shadowState) => {
  #|       const spotLights = Array.isArray(light.spotLights) ? light.spotLights : [];
  #|       const tileSize = Math.max(1, Number(light.directionalShadowMapSize) || 2048);
  #|       if (spotLights.length <= 0) return;
  #|       const record = rt.ensureSpotShadowTexture(tileSize);
  #|       if (!record?.view) return;
  #|       shadowState.spotRecord = record;
  #|       shadowState.spotTexel = [1 / tileSize, 1 / tileSize];
  #|       const pass = encoder.beginRenderPass({
  #|         colorAttachments: [],
  #|         depthStencilAttachment: {
  #|           view: record.view,
  #|           depthClearValue: 1.0,
  #|           depthLoadOp: 'clear',
  #|           depthStoreOp: 'store',
  #|         },
  #|       });
  #|       for (let lightIndex = 0; lightIndex < Math.min(4, spotLights.length); lightIndex += 1) {
  #|         const spotLight = spotLights[lightIndex];
  #|         if (!spotLight?.shadows) continue;
  #|         const rect = makeShadowAtlasRect(lightIndex, 2, tileSize, record.width, record.height);
  #|         const viewportX = rect.offset[0] * record.width;
  #|         const viewportY = rect.offset[1] * record.height;
  #|         const scissorX = Math.max(0, Math.floor(viewportX));
  #|         const scissorY = Math.max(0, Math.floor(viewportY));
  #|         pass.setViewport(viewportX, viewportY, tileSize, tileSize, 0.0, 1.0);
  #|         pass.setScissorRect(scissorX, scissorY, tileSize | 0, tileSize | 0);
  #|         const setup = buildSpotShadowSetup(spotLight);
  #|         rt.renderShadowCastersForSetup(
  #|           pass,
  #|           section,
  #|           buffers,
  #|           setup.lightViewProjection,
  #|           shadowState.shadowCameraBufferCursor,
  #|         );
  #|         shadowState.shadowCameraBufferCursor += 1;
  #|         shadowState.spotEnabled[lightIndex] = 1;
  #|         shadowState.spotDepthBiases[lightIndex] = Math.max(0, Number(spotLight.depthBias) || 0);
  #|         shadowState.spotNormalBiases[lightIndex] = Math.max(0, Number(spotLight.normalBias) || 0);
  #|         shadowState.spotMatrices[lightIndex] = setup.lightViewProjection;
  #|         shadowState.spotRects[lightIndex] = [rect.offset[0], rect.offset[1], rect.scale[0], rect.scale[1]];
  #|       }
  #|       pass.end();
  #|     };
  #|
  #|     rt.renderPointShadowMaps3d = (encoder, section, buffers, light, shadowState) => {
  #|       const pointLights = Array.isArray(light.pointLights) ? light.pointLights : [];
  #|       const faceSize = Math.max(1, Number(light.pointShadowMapSize) || 1024);
  #|       if (pointLights.length <= 0) return;
  #|       const record = rt.ensurePointShadowTexture(faceSize);
  #|       if (!record?.view) return;
  #|       shadowState.pointRecord = record;
  #|       shadowState.pointTexel = [1 / faceSize, 1 / faceSize];
  #|       const pass = encoder.beginRenderPass({
  #|         colorAttachments: [],
  #|         depthStencilAttachment: {
  #|           view: record.view,
  #|           depthClearValue: 1.0,
  #|           depthLoadOp: 'clear',
  #|           depthStoreOp: 'store',
  #|         },
  #|       });
  #|       for (let lightIndex = 0; lightIndex < Math.min(8, pointLights.length); lightIndex += 1) {
  #|         const pointLight = pointLights[lightIndex];
  #|         if (!pointLight?.shadows) continue;
  #|         shadowState.pointEnabled[lightIndex] = 1;
  #|         shadowState.pointDepthBiases[lightIndex] = Math.max(0, Number(pointLight.depthBias) || 0);
  #|         shadowState.pointNormalBiases[lightIndex] = Math.max(0, Number(pointLight.normalBias) || 0);
  #|         for (let faceIndex = 0; faceIndex < 6; faceIndex += 1) {
  #|           const atlasSlot = lightIndex * 6 + faceIndex;
  #|           const rect = makeShadowAtlasRect(atlasSlot, 8, faceSize, record.width, record.height);
  #|           const viewportX = rect.offset[0] * record.width;
  #|           const viewportY = rect.offset[1] * record.height;
  #|           const scissorX = Math.max(0, Math.floor(viewportX));
  #|           const scissorY = Math.max(0, Math.floor(viewportY));
  #|           pass.setViewport(viewportX, viewportY, faceSize, faceSize, 0.0, 1.0);
  #|           pass.setScissorRect(scissorX, scissorY, faceSize | 0, faceSize | 0);
  #|           const setup = buildPointShadowFaceSetup(pointLight, faceIndex);
  #|           rt.renderShadowCastersForSetup(
  #|             pass,
  #|             section,
  #|             buffers,
  #|             setup.lightViewProjection,
  #|             shadowState.shadowCameraBufferCursor,
  #|           );
  #|           shadowState.shadowCameraBufferCursor += 1;
  #|           const stateIndex = lightIndex * 6 + faceIndex;
  #|           shadowState.pointMatrices[stateIndex] = setup.lightViewProjection;
  #|           shadowState.pointRects[stateIndex] = [rect.offset[0], rect.offset[1], rect.scale[0], rect.scale[1]];
  #|         }
  #|       }
  #|       pass.end();
  #|     };
  #|
  #|     rt.buildShadowUniform3d = (shadowState) => {
  #|       const out = new Float32Array(1496);
  #|       out[0] = Number(shadowState.directionalTexel?.[0]) || 0;
  #|       out[1] = Number(shadowState.directionalTexel?.[1]) || 0;
  #|       out[2] = Number(shadowState.spotTexel?.[0]) || 0;
  #|       out[3] = Number(shadowState.spotTexel?.[1]) || 0;
  #|       out[4] = Number(shadowState.pointTexel?.[0]) || 0;
  #|       out[5] = Number(shadowState.pointTexel?.[1]) || 0;
  #|       let offset = 8;
  #|       for (let index = 0; index < 4; index += 1) {
  #|         out[offset] = shadowState.directionalEnabled[index];
  #|         out[offset + 1] = shadowState.directionalCascadeCounts[index];
  #|         out[offset + 2] = shadowState.directionalDepthBiases[index];
  #|         out[offset + 3] = shadowState.directionalNormalBiases[index];
  #|         offset += 4;
  #|       }
  #|       for (let index = 0; index < 16; index += 1) {
  #|         out[offset] = shadowState.directionalBounds[index][0];
  #|         out[offset + 1] = shadowState.directionalBounds[index][1];
  #|         offset += 4;
  #|       }
  #|       for (let index = 0; index < 16; index += 1) {
  #|         out[offset] = shadowState.directionalRects[index][0];
  #|         out[offset + 1] = shadowState.directionalRects[index][1];
  #|         out[offset + 2] = shadowState.directionalRects[index][2];
  #|         out[offset + 3] = shadowState.directionalRects[index][3];
  #|         offset += 4;
  #|       }
  #|       for (let index = 0; index < 16; index += 1) {
  #|         out.set(shadowState.directionalMatrices[index], offset);
  #|         offset += 16;
  #|       }
  #|       for (let index = 0; index < 4; index += 1) {
  #|         out[offset] = shadowState.spotEnabled[index];
  #|         out[offset + 1] = shadowState.spotDepthBiases[index];
  #|         out[offset + 2] = shadowState.spotNormalBiases[index];
  #|         offset += 4;
  #|       }
  #|       for (let index = 0; index < 4; index += 1) {
  #|         out[offset] = shadowState.spotRects[index][0];
  #|         out[offset + 1] = shadowState.spotRects[index][1];
  #|         out[offset + 2] = shadowState.spotRects[index][2];
  #|         out[offset + 3] = shadowState.spotRects[index][3];
  #|         offset += 4;
  #|       }
  #|       for (let index = 0; index < 4; index += 1) {
  #|         out.set(shadowState.spotMatrices[index], offset);
  #|         offset += 16;
  #|       }
  #|       for (let index = 0; index < 8; index += 1) {
  #|         out[offset] = shadowState.pointEnabled[index];
  #|         out[offset + 1] = shadowState.pointDepthBiases[index];
  #|         out[offset + 2] = shadowState.pointNormalBiases[index];
  #|         offset += 4;
  #|       }
  #|       for (let index = 0; index < 48; index += 1) {
  #|         out[offset] = shadowState.pointRects[index][0];
  #|         out[offset + 1] = shadowState.pointRects[index][1];
  #|         out[offset + 2] = shadowState.pointRects[index][2];
  #|         out[offset + 3] = shadowState.pointRects[index][3];
  #|         offset += 4;
  #|       }
  #|       for (let index = 0; index < 48; index += 1) {
  #|         out.set(shadowState.pointMatrices[index], offset);
  #|         offset += 16;
  #|       }
  #|       return out;
  #|     };
  #|
  #|     rt.prepareSection3d = (encoder, section) => {
  #|       const [w, h] = toCanvasSize();
  #|       const aspect = w / h;
  #|       const camera = section.camera;
  #|       const proj = camera.orthographic
  #|         ? mat4Orthographic(
  #|             camera.orthoWidth > 0 ? camera.orthoWidth : 20,
  #|             camera.orthoHeight > 0 ? camera.orthoHeight : 20,
  #|             camera.near > 0 ? camera.near : 0.1,
  #|             camera.far > camera.near ? camera.far : (camera.near + 200.0),
  #|           )
  #|         : mat4Perspective(
  #|             camera.fovy,
  #|             aspect,
  #|             camera.near > 0 ? camera.near : 0.1,
  #|             camera.far > camera.near ? camera.far : (camera.near + 200.0),
  #|           );
  #|       const view = mat4LookAt(camera.position, camera.target, camera.up);
  #|       const viewProj = mat4Multiply(proj, view);
  #|       const light = rt.light3d || {
  #|         directionalLights: [],
  #|         pointLights: [],
  #|         spotLights: [],
  #|         ambient: [1, 1, 1],
  #|         directionalShadowMapSize: 2048,
  #|         pointShadowMapSize: 1024,
  #|       };
  #|       const directionalLights = Array.isArray(light.directionalLights) ? light.directionalLights : [];
  #|       const pointLights = Array.isArray(light.pointLights) ? light.pointLights : [];
  #|       const spotLights = Array.isArray(light.spotLights) ? light.spotLights : [];
  #|       const directionalCount = Math.min(4, directionalLights.length);
  #|       const pointCount = Math.min(8, pointLights.length);
  #|       const spotCount = Math.min(4, spotLights.length);
  #|       const basis = cameraBasis(camera);
  #|       const lightUniform = new Float32Array(44 * 4);
  #|       lightUniform[0] = clamp01(Number(light.ambient?.[0]) || 0);
  #|       lightUniform[1] = clamp01(Number(light.ambient?.[1]) || 0);
  #|       lightUniform[2] = clamp01(Number(light.ambient?.[2]) || 0);
  #|       lightUniform[3] = directionalCount;
  #|       lightUniform[4] = pointCount;
  #|       lightUniform[5] = spotCount;
  #|       lightUniform[8] = Number(camera.position?.[0]) || 0;
  #|       lightUniform[9] = Number(camera.position?.[1]) || 0;
  #|       lightUniform[10] = Number(camera.position?.[2]) || 0;
  #|       lightUniform[12] = Number(basis.forward?.[0]) || 0;
  #|       lightUniform[13] = Number(basis.forward?.[1]) || 0;
  #|       lightUniform[14] = Number(basis.forward?.[2]) || -1;
  #|       for (let index = 0; index < directionalCount; index += 1) {
  #|         const src = directionalLights[index];
  #|         const base = 16 + index * 8;
  #|         lightUniform[base] = Number(src.direction?.[0]) || 0;
  #|         lightUniform[base + 1] = Number(src.direction?.[1]) || -1;
  #|         lightUniform[base + 2] = Number(src.direction?.[2]) || 0;
  #|         lightUniform[base + 3] = Math.max(0, Number(src.intensity) || 0);
  #|         lightUniform[base + 4] = clamp01(Number(src.color?.[0]) || 0);
  #|         lightUniform[base + 5] = clamp01(Number(src.color?.[1]) || 0);
  #|         lightUniform[base + 6] = clamp01(Number(src.color?.[2]) || 0);
  #|       }
  #|       for (let index = 0; index < pointCount; index += 1) {
  #|         const src = pointLights[index];
  #|         const base = 48 + index * 8;
  #|         lightUniform[base] = Number(src.position?.[0]) || 0;
  #|         lightUniform[base + 1] = Number(src.position?.[1]) || 0;
  #|         lightUniform[base + 2] = Number(src.position?.[2]) || 0;
  #|         lightUniform[base + 3] = Math.max(0, Number(src.intensity) || 0);
  #|         lightUniform[base + 4] = clamp01(Number(src.color?.[0]) || 0);
  #|         lightUniform[base + 5] = clamp01(Number(src.color?.[1]) || 0);
  #|         lightUniform[base + 6] = clamp01(Number(src.color?.[2]) || 0);
  #|         lightUniform[base + 7] = Math.max(0.0001, Number(src.range) || 0.0001);
  #|       }
  #|       for (let index = 0; index < spotCount; index += 1) {
  #|         const src = spotLights[index];
  #|         const base = 112 + index * 16;
  #|         lightUniform[base] = Number(src.position?.[0]) || 0;
  #|         lightUniform[base + 1] = Number(src.position?.[1]) || 0;
  #|         lightUniform[base + 2] = Number(src.position?.[2]) || 0;
  #|         lightUniform[base + 3] = Math.max(0, Number(src.intensity) || 0);
  #|         lightUniform[base + 4] = clamp01(Number(src.color?.[0]) || 0);
  #|         lightUniform[base + 5] = clamp01(Number(src.color?.[1]) || 0);
  #|         lightUniform[base + 6] = clamp01(Number(src.color?.[2]) || 0);
  #|         lightUniform[base + 7] = Math.max(0.0001, Number(src.range) || 0.0001);
  #|         lightUniform[base + 8] = Number(src.direction?.[0]) || 0;
  #|         lightUniform[base + 9] = Number(src.direction?.[1]) || -1;
  #|         lightUniform[base + 10] = Number(src.direction?.[2]) || 0;
  #|         lightUniform[base + 11] = Number(src.innerCos) || 0;
  #|         lightUniform[base + 12] = Number(src.outerCos) || 0;
  #|       }
  #|       const buffers = rt.prepareSectionBuffers3d(section);
  #|       const shadowState = rt.createShadowState3d();
  #|       rt.renderDirectionalShadowMaps3d(encoder, section, buffers, camera, aspect, light, shadowState);
  #|       rt.renderSpotShadowMaps3d(encoder, section, buffers, light, shadowState);
  #|       rt.renderPointShadowMaps3d(encoder, section, buffers, light, shadowState);
  #|       const shadowUniform = rt.buildShadowUniform3d(shadowState);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.camera3d, 0, viewProj.buffer, viewProj.byteOffset, viewProj.byteLength);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.light3d, 0, lightUniform.buffer, lightUniform.byteOffset, lightUniform.byteLength);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.shadow3d, 0, shadowUniform.buffer, shadowUniform.byteOffset, shadowUniform.byteLength);
  #|       return { buffers, shadowState };
  #|     };
  #|
  #|     rt.renderSection3d = (pass, section, state) => {
  #|       pass.setBindGroup(0, rt.bindGroups.camera3d);
  #|       if (state.buffers.tri.buffer && section.triCommands.length > 0) {
  #|         pass.setPipeline(rt.pipelines.color3dTri);
  #|         for (let index = 0; index < section.triCommands.length; index += 1) {
  #|           const cmd = section.triCommands[index];
  #|           pass.setVertexBuffer(0, state.buffers.tri.buffer, state.buffers.tri.offsets[index], cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 7, 1, 0, 0);
  #|         }
  #|       }
  #|       if (state.buffers.line.buffer && section.lineCommands.length > 0) {
  #|         pass.setPipeline(rt.pipelines.color3dLine);
  #|         for (let index = 0; index < section.lineCommands.length; index += 1) {
  #|           const verts = section.lineCommands[index];
  #|           pass.setVertexBuffer(0, state.buffers.line.buffer, state.buffers.line.offsets[index], verts.byteLength);
  #|           pass.draw(verts.length / 7, 1, 0, 0);
  #|         }
  #|       }
  #|       if (state.buffers.lit.buffer && section.litTriCommands.length > 0) {
  #|         const bindGroup = rt.device.createBindGroup({
  #|           layout: rt.bindGroupLayouts.lit3d,
  #|           entries: [
  #|             { binding: 0, resource: { buffer: rt.uniformBuffers.camera3d } },
  #|             { binding: 1, resource: { buffer: rt.uniformBuffers.light3d } },
  #|             { binding: 2, resource: { buffer: rt.uniformBuffers.shadow3d } },
  #|             { binding: 3, resource: rt.samplers.shadowCompare },
  #|             { binding: 4, resource: state.shadowState.directionalRecords[0].view },
  #|             { binding: 5, resource: state.shadowState.directionalRecords[1].view },
  #|             { binding: 6, resource: state.shadowState.directionalRecords[2].view },
  #|             { binding: 7, resource: state.shadowState.directionalRecords[3].view },
  #|             { binding: 8, resource: state.shadowState.spotRecord.view },
  #|             { binding: 9, resource: state.shadowState.pointRecord.view },
  #|           ],
  #|         });
  #|         pass.setBindGroup(0, bindGroup);
  #|         for (let index = 0; index < section.litTriCommands.length; index += 1) {
  #|           const cmd = section.litTriCommands[index];
  #|           pass.setPipeline(cmd.doubleSided ? rt.pipelines.lit3dTriDouble : rt.pipelines.lit3dTriSingle);
  #|           pass.setVertexBuffer(0, state.buffers.lit.buffer, state.buffers.lit.offsets[index], cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 17, 1, 0, 0);
  #|         }
  #|       }
  #|       if (state.buffers.tex.buffer && section.texTriCommands.length > 0) {
  #|         for (let index = 0; index < section.texTriCommands.length; index += 1) {
  #|           const cmd = section.texTriCommands[index];
  #|           const rec = cmd.textureRec;
  #|           const emissiveRec = cmd.emissiveTextureRec;
  #|           const metallicRoughnessRec = cmd.metallicRoughnessTextureRec;
  #|           const occlusionRec = cmd.occlusionTextureRec;
  #|           const normalRec = cmd.normalTextureRec;
  #|           if (!rec?.view || !emissiveRec?.view || !metallicRoughnessRec?.view || !occlusionRec?.view || !normalRec?.view) continue;
  #|           const bindGroup = rt.device.createBindGroup({
  #|             layout: rt.bindGroupLayouts.lit3dTex,
  #|             entries: [
  #|               { binding: 0, resource: { buffer: rt.uniformBuffers.camera3d } },
  #|               { binding: 1, resource: { buffer: rt.uniformBuffers.light3d } },
  #|               { binding: 2, resource: { buffer: rt.uniformBuffers.shadow3d } },
  #|               { binding: 3, resource: rt.samplers.shadowCompare },
  #|               { binding: 4, resource: state.shadowState.directionalRecords[0].view },
  #|               { binding: 5, resource: state.shadowState.directionalRecords[1].view },
  #|               { binding: 6, resource: state.shadowState.directionalRecords[2].view },
  #|               { binding: 7, resource: state.shadowState.directionalRecords[3].view },
  #|               { binding: 8, resource: state.shadowState.spotRecord.view },
  #|               { binding: 9, resource: state.shadowState.pointRecord.view },
  #|               { binding: 10, resource: rt.resolveSampler(cmd.baseSamplerCode) },
  #|               { binding: 11, resource: rec.view },
  #|               { binding: 12, resource: rt.resolveSampler(cmd.emissiveSamplerCode) },
  #|               { binding: 13, resource: emissiveRec.view },
  #|               { binding: 14, resource: rt.resolveSampler(cmd.metallicRoughnessSamplerCode) },
  #|               { binding: 15, resource: metallicRoughnessRec.view },
  #|               { binding: 16, resource: rt.resolveSampler(cmd.occlusionSamplerCode) },
  #|               { binding: 17, resource: occlusionRec.view },
  #|               { binding: 18, resource: rt.resolveSampler(cmd.normalSamplerCode) },
  #|               { binding: 19, resource: normalRec.view },
  #|             ],
  #|           });
  #|           pass.setPipeline(cmd.doubleSided ? rt.pipelines.lit3dTexTriDouble : rt.pipelines.lit3dTexTriSingle);
  #|           pass.setBindGroup(0, bindGroup);
  #|           pass.setVertexBuffer(0, state.buffers.tex.buffer, state.buffers.tex.offsets[index], cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 35, 1, 0, 0);
  #|         }
  #|       }
  #|     };
  #|
  #|     rt.render2d = (pass) => {
  #|       const [w, h] = toCanvasSize();
  #|       const canvasUniform = new Float32Array([w, h, 0, 0]);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.canvas2d, 0, canvasUniform.buffer, canvasUniform.byteOffset, canvasUniform.byteLength);
  #|       let colorBytes = 0;
  #|       let texBytes = 0;
  #|       for (const cmd of rt.draw2dCommands) {
  #|         if (cmd.kind === 'color') colorBytes += cmd.verts.byteLength;
  #|         else texBytes += cmd.verts.byteLength;
  #|       }
  #|       const colorVb = colorBytes > 0
  #|         ? rt.ensureDynamicBuffer('dyn2dColor', colorBytes, GPUBufferUsage.VERTEX)
  #|         : null;
  #|       const texVb = texBytes > 0
  #|         ? rt.ensureDynamicBuffer('dyn2dTex', texBytes, GPUBufferUsage.VERTEX)
  #|         : null;
  #|       let colorOffset = 0;
  #|       let texOffset = 0;
  #|       for (const cmd of rt.draw2dCommands) {
  #|         if (cmd.kind === 'color') {
  #|           if (cmd.topology === 'line') pass.setPipeline(rt.pipelines.color2dLine);
  #|           else pass.setPipeline(rt.pipelines.color2dTri);
  #|           pass.setBindGroup(0, rt.bindGroups.canvas2d);
  #|           rt.device.queue.writeBuffer(colorVb, colorOffset, cmd.verts.buffer, cmd.verts.byteOffset, cmd.verts.byteLength);
  #|           pass.setVertexBuffer(0, colorVb, colorOffset, cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 6, 1, 0, 0);
  #|           colorOffset += cmd.verts.byteLength;
  #|           continue;
  #|         }
  #|         const rec = cmd.textureRec;
  #|         if (!rec?.view) continue;
  #|         pass.setPipeline(rt.pipelines.tex2dTri);
  #|         rt.device.queue.writeBuffer(texVb, texOffset, cmd.verts.buffer, cmd.verts.byteOffset, cmd.verts.byteLength);
  #|         const sampler = cmd.samplerCode === 3
  #|           ? rt.samplers.repeat
  #|           : (cmd.samplerCode === 1
  #|             ? rt.samplers.repeatX
  #|             : (cmd.samplerCode === 2 ? rt.samplers.repeatY : rt.samplers.clamp));
  #|         const bindGroup = rt.device.createBindGroup({
  #|           layout: rt.bindGroupLayouts.tex2d,
  #|           entries: [
  #|             { binding: 0, resource: { buffer: rt.uniformBuffers.canvas2d } },
  #|             { binding: 1, resource: sampler },
  #|             { binding: 2, resource: rec.view },
  #|           ],
  #|         });
  #|         pass.setBindGroup(0, bindGroup);
  #|         pass.setVertexBuffer(0, texVb, texOffset, cmd.verts.byteLength);
  #|         pass.draw(cmd.verts.length / 8, 1, 0, 0);
  #|         texOffset += cmd.verts.byteLength;
  #|       }
  #|     };
  #|
  #|     rt.endFrame = () => {
  #|       if (!rt.ready || !rt.device || !rt.context || !rt.canvas) return;
  #|       const view = rt.context.getCurrentTexture().createView();
  #|       const encoder = rt.device.createCommandEncoder();
  #|       let rendered = false;
  #|       if (rt.sections3d.length > 0) {
  #|         rt.ensureDepth();
  #|         let first = true;
  #|         for (const section of rt.sections3d) {
  #|           const sectionState = rt.prepareSection3d(encoder, section);
  #|           const pass = encoder.beginRenderPass({
  #|             colorAttachments: [{
  #|               view,
  #|               clearValue: { r: rt.clearColor[0], g: rt.clearColor[1], b: rt.clearColor[2], a: rt.clearColor[3] },
  #|               loadOp: first ? 'clear' : 'load',
  #|               storeOp: 'store',
  #|             }],
  #|             depthStencilAttachment: {
  #|               view: rt.depthView,
  #|               depthClearValue: 1.0,
  #|               depthLoadOp: first ? 'clear' : 'load',
  #|               depthStoreOp: 'store',
  #|             },
  #|           });
  #|           rt.renderSection3d(pass, section, sectionState);
  #|           pass.end();
  #|           first = false;
  #|           rendered = true;
  #|         }
  #|       }
  #|       if (rt.draw2dCommands.length > 0 || !rendered) {
  #|         const pass = encoder.beginRenderPass({
  #|           colorAttachments: [{
  #|             view,
  #|             clearValue: { r: rt.clearColor[0], g: rt.clearColor[1], b: rt.clearColor[2], a: rt.clearColor[3] },
  #|             loadOp: rendered ? 'load' : 'clear',
  #|             storeOp: 'store',
  #|           }],
  #|         });
  #|         rt.render2d(pass);
  #|         pass.end();
  #|       }
  #|       rt.device.queue.submit([encoder.finish()]);
  #|     };
  #|
  #|     rt.init = async () => {
  #|       if (!navigator.gpu) {
  #|         throw new Error('WebGPU is unavailable in this browser');
  #|       }
  #|       rt.adapter = await navigator.gpu.requestAdapter();
  #|       if (!rt.adapter) {
  #|         throw new Error('Failed to acquire WebGPU adapter');
  #|       }
  #|       rt.device = await rt.adapter.requestDevice();
  #|       rt.context = rt.canvas.getContext('webgpu');
  #|       rt.format = navigator.gpu.getPreferredCanvasFormat();
  #|       rt.context.configure({
  #|         device: rt.device,
  #|         format: rt.format,
  #|         alphaMode: 'premultiplied',
  #|       });
  #|       const magFilter = rt.imageSmooth ? 'linear' : 'nearest';
  #|       const minFilter = rt.imageSmooth ? 'linear' : 'nearest';
  #|       rt.samplers = {
  #|         clamp: rt.device.createSampler({ magFilter, minFilter, addressModeU: 'clamp-to-edge', addressModeV: 'clamp-to-edge' }),
  #|         repeatX: rt.device.createSampler({ magFilter, minFilter, addressModeU: 'repeat', addressModeV: 'clamp-to-edge' }),
  #|         repeatY: rt.device.createSampler({ magFilter, minFilter, addressModeU: 'clamp-to-edge', addressModeV: 'repeat' }),
  #|         repeat: rt.device.createSampler({ magFilter, minFilter, addressModeU: 'repeat', addressModeV: 'repeat' }),
  #|         shadowCompare: rt.device.createSampler({
  #|           compare: 'less',
  #|           magFilter: 'linear',
  #|           minFilter: 'linear',
  #|           mipmapFilter: 'nearest',
  #|           addressModeU: 'clamp-to-edge',
  #|           addressModeV: 'clamp-to-edge',
  #|         }),
  #|       };
  #|
  #|       const shader2dColor = rt.device.createShaderModule({
  #|         code: `
  #| struct CanvasUniform { size: vec2<f32>, _pad: vec2<f32> };
  #| @group(0) @binding(0) var<uniform> u_canvas: CanvasUniform;
  #| struct VSIn {
  #|   @location(0) pos: vec2<f32>,
  #|   @location(1) color: vec4<f32>,
  #| };
  #| struct VSOut {
  #|   @builtin(position) pos: vec4<f32>,
  #|   @location(0) color: vec4<f32>,
  #| };
  #| @vertex fn vs_main(v: VSIn) -> VSOut {
  #|   var o: VSOut;
  #|   let nx = (v.pos.x / u_canvas.size.x) * 2.0 - 1.0;
  #|   let ny = 1.0 - (v.pos.y / u_canvas.size.y) * 2.0;
  #|   o.pos = vec4<f32>(nx, ny, 0.0, 1.0);
  #|   o.color = v.color;
  #|   return o;
  #| }
  #| @fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
  #|   return v.color;
  #| }
  #| `,
  #|       });
  #|       const shader2dTex = rt.device.createShaderModule({
  #|         code: `
  #| struct CanvasUniform { size: vec2<f32>, _pad: vec2<f32> };
  #| @group(0) @binding(0) var<uniform> u_canvas: CanvasUniform;
  #| @group(0) @binding(1) var u_sampler: sampler;
  #| @group(0) @binding(2) var u_texture: texture_2d<f32>;
  #| struct VSIn {
  #|   @location(0) pos: vec2<f32>,
  #|   @location(1) uv: vec2<f32>,
  #|   @location(2) color: vec4<f32>,
  #| };
  #| struct VSOut {
  #|   @builtin(position) pos: vec4<f32>,
  #|   @location(0) uv: vec2<f32>,
  #|   @location(1) color: vec4<f32>,
  #| };
  #| @vertex fn vs_main(v: VSIn) -> VSOut {
  #|   var o: VSOut;
  #|   let nx = (v.pos.x / u_canvas.size.x) * 2.0 - 1.0;
  #|   let ny = 1.0 - (v.pos.y / u_canvas.size.y) * 2.0;
  #|   o.pos = vec4<f32>(nx, ny, 0.0, 1.0);
  #|   o.uv = v.uv;
  #|   o.color = v.color;
  #|   return o;
  #| }
  #| @fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
  #|   return textureSample(u_texture, u_sampler, v.uv) * v.color;
  #| }
  #| `,
  #|       });
  #|       const shader3dColor = rt.device.createShaderModule({
  #|         code: `
  #| struct CameraUniform {
  #|   view_proj: mat4x4<f32>,
  #| };
  #| @group(0) @binding(0) var<uniform> u_camera: CameraUniform;
  #| struct VSIn {
  #|   @location(0) pos: vec3<f32>,
  #|   @location(1) color: vec4<f32>,
  #| };
  #| struct VSOut {
  #|   @builtin(position) pos: vec4<f32>,
  #|   @location(0) color: vec4<f32>,
  #| };
  #| @vertex fn vs_main(v: VSIn) -> VSOut {
  #|   var o: VSOut;
  #|   o.pos = u_camera.view_proj * vec4<f32>(v.pos, 1.0);
  #|   o.color = v.color;
  #|   return o;
  #| }
  #| @fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
  #|   return v.color;
  #| }
  #| `,
  #|       });
  #|       const lightShadowStructsWgsl = `
  #| struct LightUniform {
  #|   ambient_directional_count: vec4<f32>,
  #|   point_spot_count: vec4<f32>,
  #|   view_position: vec4<f32>,
  #|   view_forward: vec4<f32>,
  #|   directional_data: array<vec4<f32>, 8>,
  #|   point_data: array<vec4<f32>, 16>,
  #|   spot_data: array<vec4<f32>, 16>,
  #| };
  #| struct ShadowUniform {
  #|   directional_spot_texel: vec4<f32>,
  #|   point_texel: vec4<f32>,
  #|   directional_meta: array<vec4<f32>, 4>,
  #|   directional_bounds: array<vec4<f32>, 16>,
  #|   directional_rects: array<vec4<f32>, 16>,
  #|   directional_matrices: array<mat4x4<f32>, 16>,
  #|   spot_meta: array<vec4<f32>, 4>,
  #|   spot_rects: array<vec4<f32>, 4>,
  #|   spot_matrices: array<mat4x4<f32>, 4>,
  #|   point_meta: array<vec4<f32>, 8>,
  #|   point_rects: array<vec4<f32>, 48>,
  #|   point_matrices: array<mat4x4<f32>, 48>,
  #| };
  #| `;
  #|       const shadowSamplingWgsl = `
  #| fn saturate(value: f32) -> f32 { return clamp(value, 0.0, 1.0); }
  #| fn point_light_attenuation(distance: f32, range: f32) -> f32 {
  #|   let safe_range = max(range, 0.0001);
  #|   return saturate(1.0 - distance / safe_range);
  #| }
  #| fn safe_normalize(value: vec3<f32>, fallback: vec3<f32>) -> vec3<f32> {
  #|   let len = length(value);
  #|   if (len <= 0.0001) { return fallback; }
  #|   return value / len;
  #| }
  #| fn shadow_local_uv(ndc: vec3<f32>) -> vec2<f32> {
  #|   return vec2<f32>(ndc.x * 0.5 + 0.5, 0.5 - ndc.y * 0.5);
  #| }
  #| fn sample_directional_shadow_compare(index: i32, uv: vec2<f32>, depth_ref: f32) -> f32 {
  #|   if (index == 0) { return textureSampleCompareLevel(u_directional_shadow0, u_shadow_sampler, uv, depth_ref); }
  #|   if (index == 1) { return textureSampleCompareLevel(u_directional_shadow1, u_shadow_sampler, uv, depth_ref); }
  #|   if (index == 2) { return textureSampleCompareLevel(u_directional_shadow2, u_shadow_sampler, uv, depth_ref); }
  #|   if (index == 3) { return textureSampleCompareLevel(u_directional_shadow3, u_shadow_sampler, uv, depth_ref); }
  #|   return 1.0;
  #| }
  #| fn sample_directional_shadow(light_index: i32, world_pos: vec3<f32>, normal: vec3<f32>, light_dir: vec3<f32>, receive_shadows: bool) -> f32 {
  #|   if (!receive_shadows || light_index < 0 || light_index >= 4) { return 1.0; }
  #|   let shadow_meta = u_shadow.directional_meta[light_index];
  #|   if (shadow_meta.x < 0.5) { return 1.0; }
  #|   let cascade_count = clamp(i32(round(shadow_meta.y)), 0, 4);
  #|   if (cascade_count <= 0) { return 1.0; }
  #|   let view_depth = dot(world_pos - u_light.view_position.xyz, u_light.view_forward.xyz);
  #|   let base_index = light_index * 4;
  #|   let first_near = u_shadow.directional_bounds[base_index].x;
  #|   let last_far = u_shadow.directional_bounds[base_index + cascade_count - 1].y;
  #|   if (view_depth < first_near || view_depth > last_far) { return 1.0; }
  #|   var selected = cascade_count - 1;
  #|   for (var cascade_index = 0; cascade_index < 4; cascade_index = cascade_index + 1) {
  #|     if (cascade_index >= cascade_count) { continue; }
  #|     if (view_depth <= u_shadow.directional_bounds[base_index + cascade_index].y) {
  #|       selected = cascade_index;
  #|       break;
  #|     }
  #|   }
  #|   let texel = u_shadow.directional_spot_texel.xy;
  #|   let ndotl = max(dot(normal, light_dir), 0.0);
  #|   let bias = max(0.0, shadow_meta.z) + max(0.0, shadow_meta.w) * max(texel.x, texel.y) * (1.0 - ndotl);
  #|   let filter_radius = 1.25;
  #|   let matrix_index = base_index + selected;
  #|   let clip = u_shadow.directional_matrices[matrix_index] * vec4<f32>(world_pos, 1.0);
  #|   if (abs(clip.w) <= 0.00001) { return 1.0; }
  #|   let ndc = clip.xyz / clip.w;
  #|   let local_uv = shadow_local_uv(ndc);
  #|   let depth = ndc.z;
  #|   if (depth <= 0.0 || depth >= 1.0 || any(local_uv < vec2<f32>(0.0)) || any(local_uv > vec2<f32>(1.0))) { return 1.0; }
  #|   let rect = u_shadow.directional_rects[matrix_index];
  #|   var lit = 0.0;
  #|   var total = 0.0;
  #|   for (var x = -1; x <= 1; x = x + 1) {
  #|     for (var y = -1; y <= 1; y = y + 1) {
  #|       let weight = 1.0 / (1.0 + abs(f32(x)) + abs(f32(y)));
  #|       let sample_uv = clamp(local_uv + vec2<f32>(f32(x), f32(y)) * texel * filter_radius, vec2<f32>(0.0), vec2<f32>(1.0));
  #|       let atlas_uv = rect.xy + sample_uv * rect.zw;
  #|       lit = lit + sample_directional_shadow_compare(light_index, atlas_uv, depth - bias) * weight;
  #|       total = total + weight;
  #|     }
  #|   }
  #|   var shadow = select(1.0, lit / total, total > 0.00001);
  #|   if (selected > 0) {
  #|     let previous = selected - 1;
  #|     let overlap_near = u_shadow.directional_bounds[base_index + selected].x;
  #|     let overlap_far = u_shadow.directional_bounds[base_index + previous].y;
  #|     if (overlap_near < overlap_far && view_depth >= overlap_near && view_depth <= overlap_far) {
  #|       let prev_index = base_index + previous;
  #|       let prev_clip = u_shadow.directional_matrices[prev_index] * vec4<f32>(world_pos, 1.0);
  #|       if (abs(prev_clip.w) > 0.00001) {
  #|         let prev_ndc = prev_clip.xyz / prev_clip.w;
  #|         let prev_local_uv = shadow_local_uv(prev_ndc);
  #|         let prev_depth = prev_ndc.z;
  #|         if (!(prev_depth <= 0.0 || prev_depth >= 1.0 || any(prev_local_uv < vec2<f32>(0.0)) || any(prev_local_uv > vec2<f32>(1.0)))) {
  #|           let prev_rect = u_shadow.directional_rects[prev_index];
  #|           var prev_lit = 0.0;
  #|           var prev_total = 0.0;
  #|           for (var px = -1; px <= 1; px = px + 1) {
  #|             for (var py = -1; py <= 1; py = py + 1) {
  #|               let prev_weight = 1.0 / (1.0 + abs(f32(px)) + abs(f32(py)));
  #|               let prev_sample_uv = clamp(prev_local_uv + vec2<f32>(f32(px), f32(py)) * texel * filter_radius, vec2<f32>(0.0), vec2<f32>(1.0));
  #|               let prev_atlas_uv = prev_rect.xy + prev_sample_uv * prev_rect.zw;
  #|               prev_lit = prev_lit + sample_directional_shadow_compare(light_index, prev_atlas_uv, prev_depth - bias) * prev_weight;
  #|               prev_total = prev_total + prev_weight;
  #|             }
  #|           }
  #|           let previous_shadow = select(1.0, prev_lit / prev_total, prev_total > 0.00001);
  #|           let blend = clamp((view_depth - overlap_near) / (overlap_far - overlap_near), 0.0, 1.0);
  #|           shadow = mix(previous_shadow, shadow, blend);
  #|         }
  #|       }
  #|     }
  #|   }
  #|   return shadow;
  #| }
  #| fn sample_spot_shadow(index: i32, world_pos: vec3<f32>, normal: vec3<f32>, light_dir: vec3<f32>, receive_shadows: bool) -> f32 {
  #|   if (!receive_shadows || index < 0 || index >= 4) { return 1.0; }
  #|   let shadow_meta = u_shadow.spot_meta[index];
  #|   if (shadow_meta.x < 0.5) { return 1.0; }
  #|   let clip = u_shadow.spot_matrices[index] * vec4<f32>(world_pos, 1.0);
  #|   if (abs(clip.w) <= 0.00001) { return 1.0; }
  #|   let ndc = clip.xyz / clip.w;
  #|   let local_uv = shadow_local_uv(ndc);
  #|   let depth = ndc.z;
  #|   if (depth <= 0.0 || depth >= 1.0 || any(local_uv < vec2<f32>(0.0)) || any(local_uv > vec2<f32>(1.0))) { return 1.0; }
  #|   let rect = u_shadow.spot_rects[index];
  #|   let texel = u_shadow.directional_spot_texel.zw;
  #|   let ndotl = max(dot(normal, light_dir), 0.0);
  #|   let bias = max(0.0, shadow_meta.y) + max(0.0, shadow_meta.z) * max(texel.x, texel.y) * (1.0 - ndotl);
  #|   var lit = 0.0;
  #|   var total = 0.0;
  #|   for (var x = -1; x <= 1; x = x + 1) {
  #|     for (var y = -1; y <= 1; y = y + 1) {
  #|       let weight = 1.0 / (1.0 + abs(f32(x)) + abs(f32(y)));
  #|       let sample_uv = clamp(local_uv + vec2<f32>(f32(x), f32(y)) * texel * 1.25, vec2<f32>(0.0), vec2<f32>(1.0));
  #|       let atlas_uv = rect.xy + sample_uv * rect.zw;
  #|       lit = lit + textureSampleCompareLevel(u_spot_shadow_atlas, u_shadow_sampler, atlas_uv, depth - bias) * weight;
  #|       total = total + weight;
  #|     }
  #|   }
  #|   return select(1.0, lit / total, total > 0.00001);
  #| }
  #| fn select_point_shadow_face(dir: vec3<f32>) -> i32 {
  #|   let abs_dir = abs(dir);
  #|   if (abs_dir.x >= abs_dir.y && abs_dir.x >= abs_dir.z) { return select(1, 0, dir.x >= 0.0); }
  #|   if (abs_dir.y >= abs_dir.x && abs_dir.y >= abs_dir.z) { return select(3, 2, dir.y >= 0.0); }
  #|   return select(5, 4, dir.z >= 0.0);
  #| }
  #| fn sample_point_shadow(index: i32, world_pos: vec3<f32>, normal: vec3<f32>, light_dir: vec3<f32>, light_to_fragment: vec3<f32>, receive_shadows: bool) -> f32 {
  #|   if (!receive_shadows || index < 0 || index >= 8) { return 1.0; }
  #|   let shadow_meta = u_shadow.point_meta[index];
  #|   if (shadow_meta.x < 0.5) { return 1.0; }
  #|   let face = select_point_shadow_face(light_to_fragment);
  #|   let matrix_index = index * 6 + face;
  #|   let clip = u_shadow.point_matrices[matrix_index] * vec4<f32>(world_pos, 1.0);
  #|   if (abs(clip.w) <= 0.00001) { return 1.0; }
  #|   let ndc = clip.xyz / clip.w;
  #|   let local_uv = shadow_local_uv(ndc);
  #|   let depth = ndc.z;
  #|   if (depth <= 0.0 || depth >= 1.0 || any(local_uv < vec2<f32>(0.0)) || any(local_uv > vec2<f32>(1.0))) { return 1.0; }
  #|   let rect = u_shadow.point_rects[matrix_index];
  #|   let texel = u_shadow.point_texel.xy;
  #|   let ndotl = max(dot(normal, light_dir), 0.0);
  #|   let bias = max(0.0, shadow_meta.y) + max(0.0, shadow_meta.z) * max(texel.x, texel.y) * (1.0 - ndotl);
  #|   var lit = 0.0;
  #|   var total = 0.0;
  #|   for (var x = -1; x <= 1; x = x + 1) {
  #|     for (var y = -1; y <= 1; y = y + 1) {
  #|       let weight = 1.0 / (1.0 + abs(f32(x)) + abs(f32(y)));
  #|       let sample_uv = clamp(local_uv + vec2<f32>(f32(x), f32(y)) * texel, vec2<f32>(0.0), vec2<f32>(1.0));
  #|       let atlas_uv = rect.xy + sample_uv * rect.zw;
  #|       lit = lit + textureSampleCompareLevel(u_point_shadow_atlas, u_shadow_sampler, atlas_uv, depth - bias) * weight;
  #|       total = total + weight;
  #|     }
  #|   }
  #|   return select(1.0, lit / total, total > 0.00001);
  #| }
  #| `;
  #|       const shader3dShadowSolid = rt.device.createShaderModule({
  #|         code: `
  #| struct ShadowCameraUniform { light_view_proj: mat4x4<f32>, };
  #| @group(0) @binding(0) var<uniform> u_shadow_camera: ShadowCameraUniform;
  #| struct VSIn { @location(0) pos: vec3<f32>, @location(1) color: vec4<f32>, };
  #| struct VSOut { @builtin(position) pos: vec4<f32>, };
  #| @vertex fn vs_main(v: VSIn) -> VSOut {
  #|   var o: VSOut;
  #|   o.pos = u_shadow_camera.light_view_proj * vec4<f32>(v.pos, 1.0);
  #|   return o;
  #| }
  #| `,
  #|       });
  #|       const shader3dShadowLit = rt.device.createShaderModule({
  #|         code: `
  #| struct ShadowCameraUniform { light_view_proj: mat4x4<f32>, };
  #| @group(0) @binding(0) var<uniform> u_shadow_camera: ShadowCameraUniform;
  #| struct VSIn {
  #|   @location(0) pos: vec3<f32>,
  #|   @location(2) color: vec4<f32>,
  #|   @location(4) material: vec4<f32>,
  #| };
  #| struct VSOut {
  #|   @builtin(position) pos: vec4<f32>,
  #|   @location(0) color: vec4<f32>,
  #|   @location(1) material: vec4<f32>,
  #| };
  #| @vertex fn vs_main(v: VSIn) -> VSOut {
  #|   var o: VSOut;
  #|   o.pos = u_shadow_camera.light_view_proj * vec4<f32>(v.pos, 1.0);
  #|   o.color = v.color;
  #|   o.material = v.material;
  #|   return o;
  #| }
  #| @fragment fn fs_main(v: VSOut) {
  #|   let alpha_mode = i32(round(v.material.x));
  #|   let alpha_cutoff = v.material.y;
  #|   if (alpha_mode == 2) { discard; }
  #|   if (alpha_mode == 1 && v.color.a < alpha_cutoff) { discard; }
  #| }
  #| `,
  #|       });
  #|       const shader3dShadowTex = rt.device.createShaderModule({
  #|         code: `
  #| struct ShadowCameraUniform { light_view_proj: mat4x4<f32>, };
  #| @group(0) @binding(0) var<uniform> u_shadow_camera: ShadowCameraUniform;
  #| @group(0) @binding(1) var u_shadow_base_sampler: sampler;
  #| @group(0) @binding(2) var u_shadow_base_texture: texture_2d<f32>;
  #| struct VSIn {
  #|   @location(0) pos: vec3<f32>,
  #|   @location(2) base_uv: vec2<f32>,
  #|   @location(7) color: vec4<f32>,
  #|   @location(10) material: vec4<f32>,
  #| };
  #| struct VSOut {
  #|   @builtin(position) pos: vec4<f32>,
  #|   @location(0) base_uv: vec2<f32>,
  #|   @location(1) color: vec4<f32>,
  #|   @location(2) material: vec4<f32>,
  #| };
  #| @vertex fn vs_main(v: VSIn) -> VSOut {
  #|   var o: VSOut;
  #|   o.pos = u_shadow_camera.light_view_proj * vec4<f32>(v.pos, 1.0);
  #|   o.base_uv = v.base_uv;
  #|   o.color = v.color;
  #|   o.material = v.material;
  #|   return o;
  #| }
  #| @fragment fn fs_main(v: VSOut) {
  #|   let alpha_mode = i32(round(v.material.x));
  #|   let alpha_cutoff = v.material.y;
  #|   if (alpha_mode == 2) { discard; }
  #|   let albedo = textureSample(u_shadow_base_texture, u_shadow_base_sampler, v.base_uv) * v.color;
  #|   if (alpha_mode == 1 && albedo.a < alpha_cutoff) { discard; }
  #| }
  #| `,
  #|       });
  #|       const shader3dLitColor = rt.device.createShaderModule({
  #|         code: `
  #| struct CameraUniform { view_proj: mat4x4<f32>, };
  #| ${lightShadowStructsWgsl}
  #| @group(0) @binding(0) var<uniform> u_camera: CameraUniform;
  #| @group(0) @binding(1) var<uniform> u_light: LightUniform;
  #| @group(0) @binding(2) var<uniform> u_shadow: ShadowUniform;
  #| @group(0) @binding(3) var u_shadow_sampler: sampler_comparison;
  #| @group(0) @binding(4) var u_directional_shadow0: texture_depth_2d;
  #| @group(0) @binding(5) var u_directional_shadow1: texture_depth_2d;
  #| @group(0) @binding(6) var u_directional_shadow2: texture_depth_2d;
  #| @group(0) @binding(7) var u_directional_shadow3: texture_depth_2d;
  #| @group(0) @binding(8) var u_spot_shadow_atlas: texture_depth_2d;
  #| @group(0) @binding(9) var u_point_shadow_atlas: texture_depth_2d;
  #| struct VSIn {
  #|   @location(0) pos: vec3<f32>,
  #|   @location(1) normal: vec3<f32>,
  #|   @location(2) color: vec4<f32>,
  #|   @location(3) emissive: vec3<f32>,
  #|   @location(4) material: vec4<f32>,
  #| };
  #| struct VSOut {
  #|   @builtin(position) pos: vec4<f32>,
  #|   @location(0) world_pos: vec3<f32>,
  #|   @location(1) normal: vec3<f32>,
  #|   @location(2) color: vec4<f32>,
  #|   @location(3) emissive: vec3<f32>,
  #|   @location(4) material: vec4<f32>,
  #| };
  #| @vertex fn vs_main(v: VSIn) -> VSOut {
  #|   var o: VSOut;
  #|   o.pos = u_camera.view_proj * vec4<f32>(v.pos, 1.0);
  #|   o.world_pos = v.pos;
  #|   o.normal = normalize(v.normal);
  #|   o.color = v.color;
  #|   o.emissive = v.emissive;
  #|   o.material = v.material;
  #|   return o;
  #| }
  #| ${shadowSamplingWgsl}
  #| fn apply_lighting(world_pos: vec3<f32>, normal: vec3<f32>, receive_shadows: bool) -> vec3<f32> {
  #|   let n = normalize(normal);
  #|   var lit = u_light.ambient_directional_count.xyz;
  #|   let directional_count = clamp(i32(round(u_light.ambient_directional_count.w)), 0, 4);
  #|   for (var idx = 0; idx < 4; idx = idx + 1) {
  #|     if (idx >= directional_count) { continue; }
  #|     let base = idx * 2;
  #|     let direction_intensity = u_light.directional_data[base];
  #|     let color_data = u_light.directional_data[base + 1];
  #|     let light_dir = normalize(-direction_intensity.xyz);
  #|     let lambert = max(dot(n, light_dir), 0.0);
  #|     let shadow = sample_directional_shadow(idx, world_pos, normal, light_dir, receive_shadows);
  #|     lit = lit + color_data.xyz * direction_intensity.w * lambert * shadow;
  #|   }
  #|   let point_count = clamp(i32(round(u_light.point_spot_count.x)), 0, 8);
  #|   for (var idx = 0; idx < 8; idx = idx + 1) {
  #|     if (idx >= point_count) { continue; }
  #|     let base = idx * 2;
  #|     let position_intensity = u_light.point_data[base];
  #|     let color_range = u_light.point_data[base + 1];
  #|     let offset = position_intensity.xyz - world_pos;
  #|     let distance = length(offset);
  #|     if (distance <= 0.0001) { continue; }
  #|     let light_dir = offset / distance;
  #|     let lambert = max(dot(n, light_dir), 0.0);
  #|     let attenuation = point_light_attenuation(distance, color_range.w) *
  #|       sample_point_shadow(idx, world_pos, normal, light_dir, world_pos - position_intensity.xyz, receive_shadows);
  #|     lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;
  #|   }
  #|   let spot_count = clamp(i32(round(u_light.point_spot_count.y)), 0, 4);
  #|   for (var idx = 0; idx < 4; idx = idx + 1) {
  #|     if (idx >= spot_count) { continue; }
  #|     let base = idx * 4;
  #|     let position_intensity = u_light.spot_data[base];
  #|     let color_range = u_light.spot_data[base + 1];
  #|     let direction_inner = u_light.spot_data[base + 2];
  #|     let outer_cos = u_light.spot_data[base + 3].x;
  #|     let offset = position_intensity.xyz - world_pos;
  #|     let distance = length(offset);
  #|     if (distance <= 0.0001) { continue; }
  #|     let light_dir = offset / distance;
  #|     let to_fragment = -light_dir;
  #|     let spot_direction = normalize(direction_inner.xyz);
  #|     let spot_cos = dot(spot_direction, to_fragment);
  #|     let inner_cos = direction_inner.w;
  #|     let spot_denom = max(inner_cos - outer_cos, 0.0001);
  #|     let spot_factor = saturate((spot_cos - outer_cos) / spot_denom);
  #|     if (spot_factor <= 0.0) { continue; }
  #|     let lambert = max(dot(n, light_dir), 0.0);
  #|     let attenuation = point_light_attenuation(distance, color_range.w) *
  #|       spot_factor * sample_spot_shadow(idx, world_pos, normal, light_dir, receive_shadows);
  #|     lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;
  #|   }
  #|   return lit;
  #| }
  #| @fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
  #|   var albedo = v.color;
  #|   let alpha_mode = i32(round(v.material.x));
  #|   let alpha_cutoff = v.material.y;
  #|   let unlit = v.material.z >= 0.5;
  #|   let receive_shadows = v.material.w >= 0.5;
  #|   if (alpha_mode == 0) {
  #|     albedo.a = 1.0;
  #|   } else if (alpha_mode == 1) {
  #|     if (albedo.a < alpha_cutoff) { discard; }
  #|     albedo.a = 1.0;
  #|   } else if (albedo.a <= 0.0001) {
  #|     discard;
  #|   }
  #|   if (unlit) { return albedo; }
  #|   let lit = apply_lighting(v.world_pos, v.normal, receive_shadows);
  #|   return vec4<f32>(albedo.rgb * lit + v.emissive, albedo.a);
  #| }
  #| `,
  #|       });
  #|       const shader3dLitTex = rt.device.createShaderModule({
  #|         code: `
  #| struct CameraUniform { view_proj: mat4x4<f32>, };
  #| ${lightShadowStructsWgsl}
  #| @group(0) @binding(0) var<uniform> u_camera: CameraUniform;
  #| @group(0) @binding(1) var<uniform> u_light: LightUniform;
  #| @group(0) @binding(2) var<uniform> u_shadow: ShadowUniform;
  #| @group(0) @binding(3) var u_shadow_sampler: sampler_comparison;
  #| @group(0) @binding(4) var u_directional_shadow0: texture_depth_2d;
  #| @group(0) @binding(5) var u_directional_shadow1: texture_depth_2d;
  #| @group(0) @binding(6) var u_directional_shadow2: texture_depth_2d;
  #| @group(0) @binding(7) var u_directional_shadow3: texture_depth_2d;
  #| @group(0) @binding(8) var u_spot_shadow_atlas: texture_depth_2d;
  #| @group(0) @binding(9) var u_point_shadow_atlas: texture_depth_2d;
  #| @group(0) @binding(10) var u_base_sampler: sampler;
  #| @group(0) @binding(11) var u_texture: texture_2d<f32>;
  #| @group(0) @binding(12) var u_emissive_sampler: sampler;
  #| @group(0) @binding(13) var u_emissive_texture: texture_2d<f32>;
  #| @group(0) @binding(14) var u_metallic_roughness_sampler: sampler;
  #| @group(0) @binding(15) var u_metallic_roughness_texture: texture_2d<f32>;
  #| @group(0) @binding(16) var u_occlusion_sampler: sampler;
  #| @group(0) @binding(17) var u_occlusion_texture: texture_2d<f32>;
  #| @group(0) @binding(18) var u_normal_sampler: sampler;
  #| @group(0) @binding(19) var u_normal_texture: texture_2d<f32>;
  #| struct VSIn {
  #|   @location(0) pos: vec3<f32>,
  #|   @location(1) normal: vec3<f32>,
  #|   @location(2) base_uv: vec2<f32>,
  #|   @location(3) emissive_uv: vec2<f32>,
  #|   @location(4) metallic_roughness_uv: vec2<f32>,
  #|   @location(5) occlusion_uv: vec2<f32>,
  #|   @location(6) normal_uv: vec2<f32>,
  #|   @location(7) color: vec4<f32>,
  #|   @location(8) emissive: vec3<f32>,
  #|   @location(9) tangent: vec4<f32>,
  #|   @location(10) material: vec4<f32>,
  #|   @location(11) surface: vec4<f32>,
  #| };
  #| struct VSOut {
  #|   @builtin(position) pos: vec4<f32>,
  #|   @location(0) world_pos: vec3<f32>,
  #|   @location(1) normal: vec3<f32>,
  #|   @location(2) base_uv: vec2<f32>,
  #|   @location(3) emissive_uv: vec2<f32>,
  #|   @location(4) metallic_roughness_uv: vec2<f32>,
  #|   @location(5) occlusion_uv: vec2<f32>,
  #|   @location(6) normal_uv: vec2<f32>,
  #|   @location(7) color: vec4<f32>,
  #|   @location(8) emissive: vec3<f32>,
  #|   @location(9) tangent: vec4<f32>,
  #|   @location(10) material: vec4<f32>,
  #|   @location(11) surface: vec4<f32>,
  #| };
  #| @vertex fn vs_main(v: VSIn) -> VSOut {
  #|   var o: VSOut;
  #|   o.pos = u_camera.view_proj * vec4<f32>(v.pos, 1.0);
  #|   o.world_pos = v.pos;
  #|   o.normal = normalize(v.normal);
  #|   o.base_uv = v.base_uv;
  #|   o.emissive_uv = v.emissive_uv;
  #|   o.metallic_roughness_uv = v.metallic_roughness_uv;
  #|   o.occlusion_uv = v.occlusion_uv;
  #|   o.normal_uv = v.normal_uv;
  #|   o.color = v.color;
  #|   o.emissive = v.emissive;
  #|   o.tangent = v.tangent;
  #|   o.material = v.material;
  #|   o.surface = v.surface;
  #|   return o;
  #| }
  #| ${shadowSamplingWgsl}
  #| fn apply_lighting(world_pos: vec3<f32>, shading_normal: vec3<f32>, geometric_normal: vec3<f32>, view_dir: vec3<f32>, roughness: f32, metallic: f32, receive_shadows: bool) -> vec3<f32> {
  #|   let n = normalize(shading_normal);
  #|   var lit = u_light.ambient_directional_count.xyz;
  #|   var specular = vec3<f32>(0.0);
  #|   let shininess = mix(96.0, 8.0, clamp(roughness, 0.0, 1.0));
  #|   let specular_strength = mix(0.04, 1.0, clamp(metallic, 0.0, 1.0));
  #|   let directional_count = clamp(i32(round(u_light.ambient_directional_count.w)), 0, 4);
  #|   for (var idx = 0; idx < 4; idx = idx + 1) {
  #|     if (idx >= directional_count) { continue; }
  #|     let base = idx * 2;
  #|     let direction_intensity = u_light.directional_data[base];
  #|     let color_data = u_light.directional_data[base + 1];
  #|     let light_dir = normalize(-direction_intensity.xyz);
  #|     let lambert = max(dot(n, light_dir), 0.0);
  #|     let shadow = sample_directional_shadow(idx, world_pos, geometric_normal, light_dir, receive_shadows);
  #|     lit = lit + color_data.xyz * direction_intensity.w * lambert * shadow;
  #|     if (lambert > 0.0) {
  #|       let halfway = safe_normalize(light_dir + view_dir, view_dir);
  #|       let spec = pow(max(dot(n, halfway), 0.0), shininess) * specular_strength;
  #|       specular = specular + color_data.xyz * direction_intensity.w * spec * shadow;
  #|     }
  #|   }
  #|   let point_count = clamp(i32(round(u_light.point_spot_count.x)), 0, 8);
  #|   for (var idx = 0; idx < 8; idx = idx + 1) {
  #|     if (idx >= point_count) { continue; }
  #|     let base = idx * 2;
  #|     let position_intensity = u_light.point_data[base];
  #|     let color_range = u_light.point_data[base + 1];
  #|     let offset = position_intensity.xyz - world_pos;
  #|     let distance = length(offset);
  #|     if (distance <= 0.0001) { continue; }
  #|     let light_dir = offset / distance;
  #|     let lambert = max(dot(n, light_dir), 0.0);
  #|     let shadow = sample_point_shadow(idx, world_pos, geometric_normal, light_dir, world_pos - position_intensity.xyz, receive_shadows);
  #|     let attenuation = point_light_attenuation(distance, color_range.w) * shadow;
  #|     lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;
  #|     if (lambert > 0.0 && attenuation > 0.0) {
  #|       let halfway = safe_normalize(light_dir + view_dir, view_dir);
  #|       let spec = pow(max(dot(n, halfway), 0.0), shininess) * specular_strength;
  #|       specular = specular + color_range.xyz * position_intensity.w * spec * attenuation;
  #|     }
  #|   }
  #|   let spot_count = clamp(i32(round(u_light.point_spot_count.y)), 0, 4);
  #|   for (var idx = 0; idx < 4; idx = idx + 1) {
  #|     if (idx >= spot_count) { continue; }
  #|     let base = idx * 4;
  #|     let position_intensity = u_light.spot_data[base];
  #|     let color_range = u_light.spot_data[base + 1];
  #|     let direction_inner = u_light.spot_data[base + 2];
  #|     let outer_cos = u_light.spot_data[base + 3].x;
  #|     let offset = position_intensity.xyz - world_pos;
  #|     let distance = length(offset);
  #|     if (distance <= 0.0001) { continue; }
  #|     let light_dir = offset / distance;
  #|     let to_fragment = -light_dir;
  #|     let spot_direction = normalize(direction_inner.xyz);
  #|     let spot_cos = dot(spot_direction, to_fragment);
  #|     let inner_cos = direction_inner.w;
  #|     let spot_denom = max(inner_cos - outer_cos, 0.0001);
  #|     let spot_factor = saturate((spot_cos - outer_cos) / spot_denom);
  #|     if (spot_factor <= 0.0) { continue; }
  #|     let lambert = max(dot(n, light_dir), 0.0);
  #|     let shadow = sample_spot_shadow(idx, world_pos, geometric_normal, light_dir, receive_shadows);
  #|     let attenuation = point_light_attenuation(distance, color_range.w) * spot_factor * shadow;
  #|     lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;
  #|     if (lambert > 0.0 && attenuation > 0.0) {
  #|       let halfway = safe_normalize(light_dir + view_dir, view_dir);
  #|       let spec = pow(max(dot(n, halfway), 0.0), shininess) * specular_strength;
  #|       specular = specular + color_range.xyz * position_intensity.w * spec * attenuation;
  #|     }
  #|   }
  #|   return lit + specular;
  #| }
  #| @fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
  #|   var albedo = textureSample(u_texture, u_base_sampler, v.base_uv) * v.color;
  #|   let emissive_sample = textureSample(u_emissive_texture, u_emissive_sampler, v.emissive_uv).rgb;
  #|   let mr_sample = textureSample(u_metallic_roughness_texture, u_metallic_roughness_sampler, v.metallic_roughness_uv);
  #|   let occlusion_sample = textureSample(u_occlusion_texture, u_occlusion_sampler, v.occlusion_uv);
  #|   let normal_sample = textureSample(u_normal_texture, u_normal_sampler, v.normal_uv).xyz * 2.0 - vec3<f32>(1.0, 1.0, 1.0);
  #|   let alpha_mode = i32(round(v.material.x));
  #|   let alpha_cutoff = v.material.y;
  #|   let unlit = v.surface.z >= 0.5;
  #|   let receive_shadows = v.surface.w >= 0.5;
  #|   if (alpha_mode == 0) {
  #|     albedo.a = 1.0;
  #|   } else if (alpha_mode == 1) {
  #|     if (albedo.a < alpha_cutoff) { discard; }
  #|     albedo.a = 1.0;
  #|   } else if (albedo.a <= 0.0001) {
  #|     discard;
  #|   }
  #|   if (unlit) { return albedo; }
  #|   let tangent = safe_normalize(v.tangent.xyz - v.normal * dot(v.tangent.xyz, v.normal), vec3<f32>(1.0, 0.0, 0.0));
  #|   let bitangent = safe_normalize(cross(v.normal, tangent) * v.tangent.w, vec3<f32>(0.0, 1.0, 0.0));
  #|   let tangent_normal = normalize(vec3<f32>(normal_sample.xy * v.surface.y, normal_sample.z));
  #|   let geometric_normal = normalize(v.normal);
  #|   let mapped_normal = safe_normalize(
  #|     tangent * tangent_normal.x + bitangent * tangent_normal.y + v.normal * tangent_normal.z,
  #|     geometric_normal,
  #|   );
  #|   let metallic = clamp(v.material.z * mr_sample.b, 0.0, 1.0);
  #|   let roughness = clamp(v.material.w * mr_sample.g, 0.0, 1.0);
  #|   let view_dir = safe_normalize(u_light.view_position.xyz - v.world_pos, vec3<f32>(0.0, 0.0, 1.0));
  #|   let lit = apply_lighting(v.world_pos, mapped_normal, geometric_normal, view_dir, roughness, metallic, receive_shadows);
  #|   let occlusion = mix(1.0, occlusion_sample.r, clamp(v.surface.x, 0.0, 1.0));
  #|   let emissive = emissive_sample * v.emissive;
  #|   return vec4<f32>(albedo.rgb * lit * occlusion + emissive, albedo.a);
  #| }
  #| `,
  #|       });
  #|
  #|       rt.uniformBuffers = {
  #|         canvas2d: rt.device.createBuffer({ size: 16, usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
  #|         camera3d: rt.device.createBuffer({ size: 64, usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
  #|         light3d: rt.device.createBuffer({ size: 704, usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
  #|         shadowCamera3d: rt.device.createBuffer({ size: 64, usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
  #|         shadow3d: rt.device.createBuffer({ size: 5984, usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
  #|       };
  #|       rt.bindGroupLayouts = {
  #|         canvas2d: rt.device.createBindGroupLayout({
  #|           entries: [{ binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} }],
  #|         }),
  #|         tex2d: rt.device.createBindGroupLayout({
  #|           entries: [
  #|             { binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} },
  #|             { binding: 1, visibility: GPUShaderStage.FRAGMENT, sampler: { type: 'filtering' } },
  #|             { binding: 2, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'float' } },
  #|           ],
  #|         }),
  #|         camera3d: rt.device.createBindGroupLayout({
  #|           entries: [{ binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} }],
  #|         }),
  #|         shadow3d: rt.device.createBindGroupLayout({
  #|           entries: [{ binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} }],
  #|         }),
  #|         shadow3dTex: rt.device.createBindGroupLayout({
  #|           entries: [
  #|             { binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} },
  #|             { binding: 1, visibility: GPUShaderStage.FRAGMENT, sampler: { type: 'filtering' } },
  #|             { binding: 2, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'float' } },
  #|           ],
  #|         }),
  #|         lit3d: rt.device.createBindGroupLayout({
  #|           entries: [
  #|             { binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} },
  #|             { binding: 1, visibility: GPUShaderStage.FRAGMENT, buffer: {} },
  #|             { binding: 2, visibility: GPUShaderStage.FRAGMENT, buffer: {} },
  #|             { binding: 3, visibility: GPUShaderStage.FRAGMENT, sampler: { type: 'comparison' } },
  #|             { binding: 4, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 5, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 6, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 7, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 8, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 9, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|           ],
  #|         }),
  #|         lit3dTex: rt.device.createBindGroupLayout({
  #|           entries: [
  #|             { binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} },
  #|             { binding: 1, visibility: GPUShaderStage.FRAGMENT, buffer: {} },
  #|             { binding: 2, visibility: GPUShaderStage.FRAGMENT, buffer: {} },
  #|             { binding: 3, visibility: GPUShaderStage.FRAGMENT, sampler: { type: 'comparison' } },
  #|             { binding: 4, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 5, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 6, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 7, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 8, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 9, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'depth' } },
  #|             { binding: 10, visibility: GPUShaderStage.FRAGMENT, sampler: { type: 'filtering' } },
  #|             { binding: 11, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'float' } },
  #|             { binding: 12, visibility: GPUShaderStage.FRAGMENT, sampler: { type: 'filtering' } },
  #|             { binding: 13, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'float' } },
  #|             { binding: 14, visibility: GPUShaderStage.FRAGMENT, sampler: { type: 'filtering' } },
  #|             { binding: 15, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'float' } },
  #|             { binding: 16, visibility: GPUShaderStage.FRAGMENT, sampler: { type: 'filtering' } },
  #|             { binding: 17, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'float' } },
  #|             { binding: 18, visibility: GPUShaderStage.FRAGMENT, sampler: { type: 'filtering' } },
  #|             { binding: 19, visibility: GPUShaderStage.FRAGMENT, texture: { sampleType: 'float' } },
  #|           ],
  #|         }),
  #|       };
  #|       rt.bindGroups = {
  #|         canvas2d: rt.device.createBindGroup({
  #|           layout: rt.bindGroupLayouts.canvas2d,
  #|           entries: [{ binding: 0, resource: { buffer: rt.uniformBuffers.canvas2d } }],
  #|         }),
  #|         camera3d: rt.device.createBindGroup({
  #|           layout: rt.bindGroupLayouts.camera3d,
  #|           entries: [{ binding: 0, resource: { buffer: rt.uniformBuffers.camera3d } }],
  #|         }),
  #|         shadow3d: rt.device.createBindGroup({
  #|           layout: rt.bindGroupLayouts.shadow3d,
  #|           entries: [{ binding: 0, resource: { buffer: rt.uniformBuffers.shadowCamera3d } }],
  #|         }),
  #|       };
  #|       const blendState = {
  #|         color: { srcFactor: 'src-alpha', dstFactor: 'one-minus-src-alpha', operation: 'add' },
  #|         alpha: { srcFactor: 'one', dstFactor: 'one-minus-src-alpha', operation: 'add' },
  #|       };
  #|
  #|       const layout2dColor = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.canvas2d] });
  #|       const layout2dTex = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.tex2d] });
  #|       const layout3d = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.camera3d] });
  #|       const layoutShadow3d = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.shadow3d] });
  #|       const layoutShadow3dTex = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.shadow3dTex] });
  #|       const layoutLit3d = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.lit3d] });
  #|       const layoutLit3dTex = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.lit3dTex] });
  #|
  #|       const color2dVertex = {
  #|         arrayStride: 24,
  #|         attributes: [
  #|           { shaderLocation: 0, offset: 0, format: 'float32x2' },
  #|           { shaderLocation: 1, offset: 8, format: 'float32x4' },
  #|         ],
  #|       };
  #|       const tex2dVertex = {
  #|         arrayStride: 32,
  #|         attributes: [
  #|           { shaderLocation: 0, offset: 0, format: 'float32x2' },
  #|           { shaderLocation: 1, offset: 8, format: 'float32x2' },
  #|           { shaderLocation: 2, offset: 16, format: 'float32x4' },
  #|         ],
  #|       };
  #|       const color3dVertex = {
  #|         arrayStride: 28,
  #|         attributes: [
  #|           { shaderLocation: 0, offset: 0, format: 'float32x3' },
  #|           { shaderLocation: 1, offset: 12, format: 'float32x4' },
  #|         ],
  #|       };
  #|       const lit3dVertex = {
  #|         arrayStride: 68,
  #|         attributes: [
  #|           { shaderLocation: 0, offset: 0, format: 'float32x3' },
  #|           { shaderLocation: 1, offset: 12, format: 'float32x3' },
  #|           { shaderLocation: 2, offset: 24, format: 'float32x4' },
  #|           { shaderLocation: 3, offset: 40, format: 'float32x3' },
  #|           { shaderLocation: 4, offset: 52, format: 'float32x4' },
  #|         ],
  #|       };
  #|       const litTex3dVertex = {
  #|         arrayStride: 140,
  #|         attributes: [
  #|           { shaderLocation: 0, offset: 0, format: 'float32x3' },
  #|           { shaderLocation: 1, offset: 12, format: 'float32x3' },
  #|           { shaderLocation: 2, offset: 24, format: 'float32x2' },
  #|           { shaderLocation: 3, offset: 32, format: 'float32x2' },
  #|           { shaderLocation: 4, offset: 40, format: 'float32x2' },
  #|           { shaderLocation: 5, offset: 48, format: 'float32x2' },
  #|           { shaderLocation: 6, offset: 56, format: 'float32x2' },
  #|           { shaderLocation: 7, offset: 64, format: 'float32x4' },
  #|           { shaderLocation: 8, offset: 80, format: 'float32x3' },
  #|           { shaderLocation: 9, offset: 92, format: 'float32x4' },
  #|           { shaderLocation: 10, offset: 108, format: 'float32x4' },
  #|           { shaderLocation: 11, offset: 124, format: 'float32x4' },
  #|         ],
  #|       };
  #|
  #|       rt.pipelines = {
  #|         color2dTri: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|         }),
  #|         color2dLine: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'line-list', cullMode: 'none' },
  #|         }),
  #|         tex2dTri: rt.device.createRenderPipeline({
  #|           layout: layout2dTex,
  #|           vertex: { module: shader2dTex, entryPoint: 'vs_main', buffers: [tex2dVertex] },
  #|           fragment: { module: shader2dTex, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|         }),
  #|         color3dTri: rt.device.createRenderPipeline({
  #|           layout: layout3d,
  #|           vertex: { module: shader3dColor, entryPoint: 'vs_main', buffers: [color3dVertex] },
  #|           fragment: { module: shader3dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|           depthStencil: { format: 'depth24plus', depthWriteEnabled: true, depthCompare: 'less' },
  #|         }),
  #|         color3dLine: rt.device.createRenderPipeline({
  #|           layout: layout3d,
  #|           vertex: { module: shader3dColor, entryPoint: 'vs_main', buffers: [color3dVertex] },
  #|           fragment: { module: shader3dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'line-list', cullMode: 'none' },
  #|           depthStencil: { format: 'depth24plus', depthWriteEnabled: false, depthCompare: 'less' },
  #|         }),
  #|         shadow3dTri: rt.device.createRenderPipeline({
  #|           layout: layoutShadow3d,
  #|           vertex: { module: shader3dShadowSolid, entryPoint: 'vs_main', buffers: [color3dVertex] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|           depthStencil: { format: 'depth32float', depthWriteEnabled: true, depthCompare: 'less' },
  #|         }),
  #|         shadow3dLitTri: rt.device.createRenderPipeline({
  #|           layout: layoutShadow3d,
  #|           vertex: { module: shader3dShadowLit, entryPoint: 'vs_main', buffers: [lit3dVertex] },
  #|           fragment: { module: shader3dShadowLit, entryPoint: 'fs_main', targets: [] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|           depthStencil: { format: 'depth32float', depthWriteEnabled: true, depthCompare: 'less' },
  #|         }),
  #|         shadow3dTexTri: rt.device.createRenderPipeline({
  #|           layout: layoutShadow3dTex,
  #|           vertex: { module: shader3dShadowTex, entryPoint: 'vs_main', buffers: [litTex3dVertex] },
  #|           fragment: { module: shader3dShadowTex, entryPoint: 'fs_main', targets: [] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|           depthStencil: { format: 'depth32float', depthWriteEnabled: true, depthCompare: 'less' },
  #|         }),
  #|         lit3dTriSingle: rt.device.createRenderPipeline({
  #|           layout: layoutLit3d,
  #|           vertex: { module: shader3dLitColor, entryPoint: 'vs_main', buffers: [lit3dVertex] },
  #|           fragment: { module: shader3dLitColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'back' },
  #|           depthStencil: { format: 'depth24plus', depthWriteEnabled: true, depthCompare: 'less' },
  #|         }),
  #|         lit3dTriDouble: rt.device.createRenderPipeline({
  #|           layout: layoutLit3d,
  #|           vertex: { module: shader3dLitColor, entryPoint: 'vs_main', buffers: [lit3dVertex] },
  #|           fragment: { module: shader3dLitColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|           depthStencil: { format: 'depth24plus', depthWriteEnabled: true, depthCompare: 'less' },
  #|         }),
  #|         lit3dTexTriSingle: rt.device.createRenderPipeline({
  #|           layout: layoutLit3dTex,
  #|           vertex: { module: shader3dLitTex, entryPoint: 'vs_main', buffers: [litTex3dVertex] },
  #|           fragment: { module: shader3dLitTex, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'back' },
  #|           depthStencil: { format: 'depth24plus', depthWriteEnabled: true, depthCompare: 'less' },
  #|         }),
  #|         lit3dTexTriDouble: rt.device.createRenderPipeline({
  #|           layout: layoutLit3dTex,
  #|           vertex: { module: shader3dLitTex, entryPoint: 'vs_main', buffers: [litTex3dVertex] },
  #|           fragment: { module: shader3dLitTex, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|           depthStencil: { format: 'depth24plus', depthWriteEnabled: true, depthCompare: 'less' },
  #|         }),
  #|       };
  #|       rt.ensureDepth();
  #|       rt.ready = true;
  #|     };
  #|
  #|     g.__selene_webgpu_runtime = rt;
  #|   }
  #|   const rt = g.__selene_webgpu_runtime;
  #|   rt.canvas = canvas;
  #|   rt.imageSmooth = !!imageSmooth;
  #|   canvas.width = Math.max(1, Math.floor(width));
  #|   canvas.height = Math.max(1, Math.floor(height));
  #|   if (rt.ready && rt.context && rt.device && rt.format) {
  #|     rt.context.configure({ device: rt.device, format: rt.format, alphaMode: 'premultiplied' });
  #|     rt.ensureDepth();
  #|   }
  #|   if (!rt.initPromise) {
  #|     rt.initPromise = rt.init().catch((err) => {
  #|       console.error('[selene-webgpu] init failed:', err);
  #|     });
  #|   }
  #| }

///|
extern "js" fn webgpu_begin_frame(
  clear_r : Double,
  clear_g : Double,
  clear_b : Double,
  clear_a : Double,
) -> Unit =
  #| (r, g, b, a) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.beginFrame(r, g, b, a);
  #|   }
  #| }

///|
extern "js" fn webgpu_end_frame() -> Unit =
  #| () => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.endFrame();
  #|   }
  #| }

///|
extern "js" fn webgpu_preload_img(path : String) -> Unit =
  #| (path) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.ensureImage(path);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_image(
  path : String,
  destination_x : Double,
  destination_y : Double,
  destination_width : Double,
  destination_height : Double,
  has_source : Bool,
  source_x : Double,
  source_y : Double,
  source_width : Double,
  source_height : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  repeat_mode : Int,
  tint_r : Double,
  tint_g : Double,
  tint_b : Double,
  tint_a : Double,
) -> Unit =
  #| (path, dx, dy, dw, dh, hasSource, sx, sy, sw, sh, a, b, c, d, tx, ty, repeatMode, tr, tg, tb, ta) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushImage(path, dx, dy, dw, dh, hasSource, sx, sy, sw, sh, a, b, c, d, tx, ty, repeatMode, tr, tg, tb, ta);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_text(
  text : String,
  x : Double,
  y : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  family : String,
  size : Double,
  align : Int,
  baseline : Int,
  color_r : Double,
  color_g : Double,
  color_b : Double,
  color_a : Double,
) -> Unit =
  #| (text, x, y, a, b, c, d, tx, ty, family, size, align, baseline, r, g, bcol, alpha) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushText(text, x, y, a, b, c, d, tx, ty, family, size, align, baseline, r, g, bcol, alpha);
  #|   }
  #| }

///|
extern "js" fn webgpu_upload_text_texture(
  key : String,
  width : Int,
  height : Int,
  pixels : Array[Int],
) -> Bool =
  #| (key, width, height, pixels) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return false;
  #|   try {
  #|     return !!rt.uploadTextTexture?.(key, width, height, pixels);
  #|   } catch (_err) {
  #|     return false;
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_cached_text(
  key : String,
  x : Double,
  y : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  align : Int,
  baseline : Int,
) -> Unit =
  #| (key, x, y, a, b, c, d, tx, ty, align, baseline) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCachedText?.(key, x, y, a, b, c, d, tx, ty, align, baseline);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  fill_r : Double,
  fill_g : Double,
  fill_b : Double,
  fill_a : Double,
  has_stroke : Bool,
  stroke_r : Double,
  stroke_g : Double,
  stroke_b : Double,
  stroke_a : Double,
) -> Unit =
  #| (x, y, w, h, a, b, c, d, tx, ty, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushRect(x, y, w, h, a, b, c, d, tx, ty, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_circle(
  center_x : Double,
  center_y : Double,
  radius : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  fill_r : Double,
  fill_g : Double,
  fill_b : Double,
  fill_a : Double,
  has_stroke : Bool,
  stroke_r : Double,
  stroke_g : Double,
  stroke_b : Double,
  stroke_a : Double,
) -> Unit =
  #| (cx, cy, radius, a, b, c, d, tx, ty, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCircle(cx, cy, radius, a, b, c, d, tx, ty, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_gradient_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  start_r : Double,
  start_g : Double,
  start_b : Double,
  start_a : Double,
  end_r : Double,
  end_g : Double,
  end_b : Double,
  end_a : Double,
) -> Unit =
  #| (x, y, w, h, a, b, c, d, tx, ty, sr, sg, sb, sa, er, eg, eb, ea) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushGradientRect(x, y, w, h, a, b, c, d, tx, ty, sr, sg, sb, sa, er, eg, eb, ea);
  #|   }
  #| }

///|
extern "js" fn webgpu_begin_3d(
  position_x : Double,
  position_y : Double,
  position_z : Double,
  target_x : Double,
  target_y : Double,
  target_z : Double,
  up_x : Double,
  up_y : Double,
  up_z : Double,
  fovy : Double,
  near_z : Double,
  far_z : Double,
  orthographic : Double,
  orthographic_width : Double,
  orthographic_height : Double,
) -> Unit =
  #| (px, py, pz, tx, ty, tz, ux, uy, uz, fovy, nearZ, farZ, orthographic, orthoWidth, orthoHeight) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.begin3d(px, py, pz, tx, ty, tz, ux, uy, uz, fovy, nearZ, farZ, orthographic, orthoWidth, orthoHeight);
  #|   }
  #| }

///|
extern "js" fn webgpu_end_3d() -> Unit =
  #| () => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.end3d();
  #|   }
  #| }

///|
extern "js" fn webgpu_set_lighting_3d(
  directional_data : Array[Double],
  point_data : Array[Double],
  spot_data : Array[Double],
  ambient_r : Double,
  ambient_g : Double,
  ambient_b : Double,
  directional_shadow_map_size : Double,
  point_shadow_map_size : Double,
) -> Unit =
  #| (directionalData, pointData, spotData, ar, ag, ab, directionalShadowMapSize, pointShadowMapSize) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return;
  #|   const clamp01 = (x) => Math.max(0, Math.min(1, Number.isFinite(x) ? x : 0));
  #|   const clampSigned = (x) => Math.max(-1, Math.min(1, Number.isFinite(x) ? x : 0));
  #|   const safeDirectional = Array.isArray(directionalData) ? directionalData : [];
  #|   const safePoint = Array.isArray(pointData) ? pointData : [];
  #|   const safeSpot = Array.isArray(spotData) ? spotData : [];
  #|   const safeDirectionalShadowMapSize = Math.max(1, Math.round(Number(directionalShadowMapSize) || 2048));
  #|   const safePointShadowMapSize = Math.max(1, Math.round(Number(pointShadowMapSize) || 1024));
  #|   const directionalLights = [];
  #|   for (let i = 0; i + 16 < safeDirectional.length && directionalLights.length < 4; i += 17) {
  #|     let dx = Number(safeDirectional[i]) || 0;
  #|     let dy = Number(safeDirectional[i + 1]) || -1;
  #|     let dz = Number(safeDirectional[i + 2]) || 0;
  #|     const len = Math.hypot(dx, dy, dz);
  #|     if (len <= 1e-8) {
  #|       dx = 0;
  #|       dy = -1;
  #|       dz = 0;
  #|     } else {
  #|       dx /= len;
  #|       dy /= len;
  #|       dz /= len;
  #|     }
  #|     directionalLights.push({
  #|       direction: [dx, dy, dz],
  #|       intensity: Math.max(0, Number(safeDirectional[i + 3]) || 0),
  #|       color: [
  #|         clamp01(safeDirectional[i + 4]),
  #|         clamp01(safeDirectional[i + 5]),
  #|         clamp01(safeDirectional[i + 6]),
  #|       ],
  #|       shadows: Number(safeDirectional[i + 7]) >= 0.5,
  #|       depthBias: Math.max(0, Number(safeDirectional[i + 8]) || 0),
  #|       normalBias: Math.max(0, Number(safeDirectional[i + 9]) || 0),
  #|       cascadeConfig: (() => {
  #|         const cascadeCount = Math.max(1, Math.min(4, Math.round(Number(safeDirectional[i + 10]) || 1)));
  #|         const minimumDistance = Math.max(0, Number(safeDirectional[i + 11]) || 0);
  #|         const overlapProportion = clamp01(safeDirectional[i + 12]);
  #|         const bounds = [];
  #|         let fallbackBound = minimumDistance + 1.0;
  #|         for (let boundIndex = 0; boundIndex < 4; boundIndex += 1) {
  #|           const rawBound = Number(safeDirectional[i + 13 + boundIndex]);
  #|           const bound = Number.isFinite(rawBound) ? rawBound : fallbackBound;
  #|           fallbackBound = bound;
  #|           if (boundIndex < cascadeCount) {
  #|             bounds.push(bound);
  #|           }
  #|         }
  #|         return { minimumDistance, overlapProportion, bounds };
  #|       })(),
  #|     });
  #|   }
  #|   const pointLights = [];
  #|   for (let i = 0; i + 11 < safePoint.length && pointLights.length < 8; i += 12) {
  #|     pointLights.push({
  #|       position: [
  #|         Number(safePoint[i]) || 0,
  #|         Number(safePoint[i + 1]) || 0,
  #|         Number(safePoint[i + 2]) || 0,
  #|       ],
  #|       intensity: Math.max(0, Number(safePoint[i + 3]) || 0),
  #|       color: [
  #|         clamp01(safePoint[i + 4]),
  #|         clamp01(safePoint[i + 5]),
  #|         clamp01(safePoint[i + 6]),
  #|       ],
  #|       range: Math.max(0.0001, Number(safePoint[i + 7]) || 0.0001),
  #|       shadows: Number(safePoint[i + 8]) >= 0.5,
  #|       depthBias: Math.max(0, Number(safePoint[i + 9]) || 0),
  #|       normalBias: Math.max(0, Number(safePoint[i + 10]) || 0),
  #|       nearZ: Math.max(0.0001, Number(safePoint[i + 11]) || 0.0001),
  #|     });
  #|   }
  #|   const spotLights = [];
  #|   for (let i = 0; i + 16 < safeSpot.length && spotLights.length < 4; i += 17) {
  #|     let dx = Number(safeSpot[i + 8]) || 0;
  #|     let dy = Number(safeSpot[i + 9]) || -1;
  #|     let dz = Number(safeSpot[i + 10]) || 0;
  #|     const dlen = Math.hypot(dx, dy, dz);
  #|     if (dlen <= 1e-8) {
  #|       dx = 0;
  #|       dy = -1;
  #|       dz = 0;
  #|     } else {
  #|       dx /= dlen;
  #|       dy /= dlen;
  #|       dz /= dlen;
  #|     }
  #|     const innerCos = clampSigned(safeSpot[i + 11]);
  #|     const outerCos = clampSigned(safeSpot[i + 12]);
  #|     spotLights.push({
  #|       position: [
  #|         Number(safeSpot[i]) || 0,
  #|         Number(safeSpot[i + 1]) || 0,
  #|         Number(safeSpot[i + 2]) || 0,
  #|       ],
  #|       intensity: Math.max(0, Number(safeSpot[i + 3]) || 0),
  #|       color: [
  #|         clamp01(safeSpot[i + 4]),
  #|         clamp01(safeSpot[i + 5]),
  #|         clamp01(safeSpot[i + 6]),
  #|       ],
  #|       range: Math.max(0.0001, Number(safeSpot[i + 7]) || 0.0001),
  #|       direction: [dx, dy, dz],
  #|       innerCos,
  #|       outerCos,
  #|       innerAngle: Math.acos(innerCos),
  #|       outerAngle: Math.acos(outerCos),
  #|       shadows: Number(safeSpot[i + 13]) >= 0.5,
  #|       depthBias: Math.max(0, Number(safeSpot[i + 14]) || 0),
  #|       normalBias: Math.max(0, Number(safeSpot[i + 15]) || 0),
  #|       nearZ: Math.max(0.0001, Number(safeSpot[i + 16]) || 0.0001),
  #|     });
  #|   }
  #|   rt.light3d = {
  #|     directionalLights,
  #|     pointLights,
  #|     spotLights,
  #|     ambient: [
  #|       clamp01(ar),
  #|       clamp01(ag),
  #|       clamp01(ab),
  #|     ],
  #|     directionalShadowMapSize: safeDirectionalShadowMapSize,
  #|     pointShadowMapSize: safePointShadowMapSize,
  #|   };
  #| }

///|
extern "js" fn webgpu_draw_cube_3d(
  center_x : Double,
  center_y : Double,
  center_z : Double,
  size_x : Double,
  size_y : Double,
  size_z : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
  emissive_r : Double,
  emissive_g : Double,
  emissive_b : Double,
  alpha_mode : Double,
  alpha_cutoff : Double,
  unlit : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (cx, cy, cz, sx, sy, sz, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCube3d(cx, cy, cz, sx, sy, sz, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_sphere_3d(
  center_x : Double,
  center_y : Double,
  center_z : Double,
  radius : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
  emissive_r : Double,
  emissive_g : Double,
  emissive_b : Double,
  alpha_mode : Double,
  alpha_cutoff : Double,
  unlit : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (cx, cy, cz, radius, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushSphere3d(cx, cy, cz, radius, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_cylinder_3d(
  center_x : Double,
  center_y : Double,
  center_z : Double,
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
  emissive_r : Double,
  emissive_g : Double,
  emissive_b : Double,
  alpha_mode : Double,
  alpha_cutoff : Double,
  unlit : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (cx, cy, cz, rtTop, rtBottom, h, slices, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCylinder3d(cx, cy, cz, rtTop, rtBottom, h, slices, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_colored_triangles_3d(
  vertices : Array[Double],
  translation_x : Double,
  translation_y : Double,
  translation_z : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  double_sided : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (vertices, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushColoredTriangles3d(vertices, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_textured_triangles_3d(
  base_path : String,
  emissive_path : String,
  metallic_roughness_path : String,
  occlusion_path : String,
  normal_path : String,
  base_sampler_code : Int,
  emissive_sampler_code : Int,
  metallic_roughness_sampler_code : Int,
  occlusion_sampler_code : Int,
  normal_sampler_code : Int,
  vertices : Array[Double],
  translation_x : Double,
  translation_y : Double,
  translation_z : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  double_sided : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (basePath, emissivePath, metallicRoughnessPath, occlusionPath, normalPath, baseSamplerCode, emissiveSamplerCode, metallicRoughnessSamplerCode, occlusionSamplerCode, normalSamplerCode, vertices, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushTexturedTriangles3d(basePath, emissivePath, metallicRoughnessPath, occlusionPath, normalPath, baseSamplerCode, emissiveSamplerCode, metallicRoughnessSamplerCode, occlusionSamplerCode, normalSamplerCode, vertices, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows);
  #|   }
  #| }

///|
pub extern "js" fn Audio::new(path : String) -> Audio = "(path) => new Audio(path)"

///|
pub extern "js" fn Audio::play(self : Self) -> Unit = "(self) => self.play()"

///|
pub extern "js" fn Audio::pause(self : Self) -> Unit = "(self) => self.pause()"

///|
pub extern "js" fn Audio::set_volume(self : Self, volume : Double) -> Unit = "(self, volume) => self.volume = volume"

///|
pub extern "js" fn Audio::set_loop(self : Self, loop_ : Bool) -> Unit = "(self, loop_) => self.loop = loop_"

///|
pub extern "js" fn Audio::set_playback_rate(
  self : Self,
  playback_rate : Double,
) -> Unit = "(self, playback_rate) => self.playbackRate = playback_rate"

///|
pub extern "js" fn Audio::set_current_time(
  self : Self,
  current_time : Double,
) -> Unit = "(self, current_time) => self.currentTime = current_time"

///|
pub extern "js" fn Audio::is_paused(self : Self) -> Bool = "(self) => self.paused"

///|
pub extern "js" fn Audio::is_ended(self : Self) -> Bool = "(self) => self.ended"

///|
#external
type Audio
