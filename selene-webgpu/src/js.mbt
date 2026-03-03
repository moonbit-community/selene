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
extern "js" fn request_pointer_lock(elem : @dom.HTMLCanvasElement) -> Unit = "(elem) => elem.requestPointerLock();"

///|
extern "js" fn is_pointer_locked(canvas : @dom.HTMLCanvasElement) -> Bool = "(canvas) => document.pointerLockElement === canvas"

///|
extern "js" fn document_add_event_listener(
  event : String,
  callback : (@dom.Event) -> Unit,
) -> Unit = "(event, callback) => { document.addEventListener(event, callback); }"

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
  #|   if (path.startsWith("assets/")) {
  #|     return "/" + path;
  #|   }
  #|   return path;
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
  #|       color2dCommands: [],
  #|       tex2dCommands: [],
  #|       sections3d: [],
  #|       current3dSection: null,
  #|       imageCache: new Map(),
  #|       textCache: new Map(),
  #|       samplers: null,
  #|       pipelines: null,
  #|       bindGroupLayouts: null,
  #|       uniformBuffers: null,
  #|       bindGroups: null,
  #|       depthTexture: null,
  #|       depthView: null,
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
  #|
  #|     rt.ensureDepth = () => {
  #|       if (!rt.device || !rt.canvas) return;
  #|       const [w, h] = toCanvasSize();
  #|       if (rt.depthTexture && rt.depthTexture.width === w && rt.depthTexture.height === h) {
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
  #|       rt.depthTexture.width = w;
  #|       rt.depthTexture.height = h;
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
  #|     rt.pushCachedText = (key, x, y, align, baseline) => {
  #|       const rec = rt.textCache.get(key);
  #|       if (!rec) return false;
  #|       let ox = x;
  #|       let oy = y;
  #|       if (align === 1) ox -= rec.width / 2;
  #|       else if (align === 2) ox -= rec.width;
  #|       if (baseline === 1) oy -= rec.height / 2;
  #|       else if (baseline === 2) oy -= rec.height;
  #|       const x0 = ox;
  #|       const y0 = oy;
  #|       const x1 = ox + rec.width;
  #|       const y1 = oy + rec.height;
  #|       const verts = new Float32Array([
  #|         x0, y0, 0, 0, 1, 1, 1, 1,
  #|         x1, y0, 1, 0, 1, 1, 1, 1,
  #|         x1, y1, 1, 1, 1, 1, 1, 1,
  #|         x0, y0, 0, 0, 1, 1, 1, 1,
  #|         x1, y1, 1, 1, 1, 1, 1, 1,
  #|         x0, y1, 0, 1, 1, 1, 1, 1,
  #|       ]);
  #|       rt.pushTex2d(0, rec, verts);
  #|       return true;
  #|     };
  #|
  #|     rt.pushColor2d = (topology, verts) => {
  #|       rt.color2dCommands.push({ topology, verts });
  #|     };
  #|     rt.pushTex2d = (samplerCode, textureRec, verts) => {
  #|       rt.tex2dCommands.push({ samplerCode, textureRec, verts });
  #|     };
  #|
  #|     rt.pushRect = (x, y, w, h, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|       const c = colorNorm(fr, fg, fb, fa);
  #|       const verts = new Float32Array([
  #|         x, y, c[0], c[1], c[2], c[3],
  #|         x + w, y, c[0], c[1], c[2], c[3],
  #|         x + w, y + h, c[0], c[1], c[2], c[3],
  #|         x, y, c[0], c[1], c[2], c[3],
  #|         x + w, y + h, c[0], c[1], c[2], c[3],
  #|         x, y + h, c[0], c[1], c[2], c[3],
  #|       ]);
  #|       rt.pushColor2d('triangle', verts);
  #|       if (hasStroke) {
  #|         const s = colorNorm(sr, sg, sb, sa);
  #|         const line = new Float32Array([
  #|           x, y, s[0], s[1], s[2], s[3], x + w, y, s[0], s[1], s[2], s[3],
  #|           x + w, y, s[0], s[1], s[2], s[3], x + w, y + h, s[0], s[1], s[2], s[3],
  #|           x + w, y + h, s[0], s[1], s[2], s[3], x, y + h, s[0], s[1], s[2], s[3],
  #|           x, y + h, s[0], s[1], s[2], s[3], x, y, s[0], s[1], s[2], s[3],
  #|         ]);
  #|         rt.pushColor2d('line', line);
  #|       }
  #|     };
  #|
  #|     rt.pushGradientRect = (x, y, w, h, sr, sg, sb, sa, er, eg, eb, ea) => {
  #|       const c0 = colorNorm(sr, sg, sb, sa);
  #|       const c1 = colorNorm(er, eg, eb, ea);
  #|       const cm = [
  #|         (c0[0] + c1[0]) * 0.5,
  #|         (c0[1] + c1[1]) * 0.5,
  #|         (c0[2] + c1[2]) * 0.5,
  #|         (c0[3] + c1[3]) * 0.5,
  #|       ];
  #|       const verts = new Float32Array([
  #|         x, y, c0[0], c0[1], c0[2], c0[3],
  #|         x + w, y, cm[0], cm[1], cm[2], cm[3],
  #|         x + w, y + h, c1[0], c1[1], c1[2], c1[3],
  #|         x, y, c0[0], c0[1], c0[2], c0[3],
  #|         x + w, y + h, c1[0], c1[1], c1[2], c1[3],
  #|         x, y + h, cm[0], cm[1], cm[2], cm[3],
  #|       ]);
  #|       rt.pushColor2d('triangle', verts);
  #|     };
  #|
  #|     rt.pushCircle = (cx, cy, radius, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|       const n = 40;
  #|       const fill = colorNorm(fr, fg, fb, fa);
  #|       const tri = [];
  #|       for (let i = 0; i < n; i += 1) {
  #|         const a0 = (i / n) * Math.PI * 2.0;
  #|         const a1 = ((i + 1) / n) * Math.PI * 2.0;
  #|         const x0 = cx + Math.cos(a0) * radius;
  #|         const y0 = cy + Math.sin(a0) * radius;
  #|         const x1 = cx + Math.cos(a1) * radius;
  #|         const y1 = cy + Math.sin(a1) * radius;
  #|         tri.push(
  #|           cx, cy, fill[0], fill[1], fill[2], fill[3],
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
  #|           const x0 = cx + Math.cos(a0) * radius;
  #|           const y0 = cy + Math.sin(a0) * radius;
  #|           const x1 = cx + Math.cos(a1) * radius;
  #|           const y1 = cy + Math.sin(a1) * radius;
  #|           lines.push(
  #|             x0, y0, stroke[0], stroke[1], stroke[2], stroke[3],
  #|             x1, y1, stroke[0], stroke[1], stroke[2], stroke[3],
  #|           );
  #|         }
  #|         rt.pushColor2d('line', new Float32Array(lines));
  #|       }
  #|     };
  #|
  #|     rt.pushImage = (path, dx, dy, dw, dh, hasSource, sx, sy, sw, sh, a, b, c, d, tx, ty, repeatMode) => {
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
  #|       const verts = new Float32Array([
  #|         p0x, p0y, u0, v0, 1, 1, 1, 1,
  #|         p1x, p1y, u1, v0, 1, 1, 1, 1,
  #|         p2x, p2y, u1, v1, 1, 1, 1, 1,
  #|         p0x, p0y, u0, v0, 1, 1, 1, 1,
  #|         p2x, p2y, u1, v1, 1, 1, 1, 1,
  #|         p3x, p3y, u0, v1, 1, 1, 1, 1,
  #|       ]);
  #|       rt.pushTex2d(samplerCode, rec, verts);
  #|     };
  #|
  #|     rt.pushText = (text, x, y, family, size, align, baseline, r, g, b, a) => {
  #|       const rec = rt.ensureTextTexture(text, family, size, r, g, b, a);
  #|       if (!rec) return;
  #|       let ox = x;
  #|       let oy = y;
  #|       if (align === 1) ox -= rec.width / 2;
  #|       else if (align === 2) ox -= rec.width;
  #|       if (baseline === 1) oy -= rec.height / 2;
  #|       else if (baseline === 2) oy -= rec.height;
  #|       const x0 = ox;
  #|       const y0 = oy;
  #|       const x1 = ox + rec.width;
  #|       const y1 = oy + rec.height;
  #|       const verts = new Float32Array([
  #|         x0, y0, 0, 0, 1, 1, 1, 1,
  #|         x1, y0, 1, 0, 1, 1, 1, 1,
  #|         x1, y1, 1, 1, 1, 1, 1, 1,
  #|         x0, y0, 0, 0, 1, 1, 1, 1,
  #|         x1, y1, 1, 1, 1, 1, 1, 1,
  #|         x0, y1, 0, 1, 1, 1, 1, 1,
  #|       ]);
  #|       rt.pushTex2d(0, rec, verts);
  #|     };
  #|
  #|     rt.makeCube = (cx, cy, cz, sx, sy, sz, color) => {
  #|       const hx = sx / 2;
  #|       const hy = sy / 2;
  #|       const hz = sz / 2;
  #|       const p = [
  #|         [cx - hx, cy - hy, cz - hz],
  #|         [cx + hx, cy - hy, cz - hz],
  #|         [cx + hx, cy + hy, cz - hz],
  #|         [cx - hx, cy + hy, cz - hz],
  #|         [cx - hx, cy - hy, cz + hz],
  #|         [cx + hx, cy - hy, cz + hz],
  #|         [cx + hx, cy + hy, cz + hz],
  #|         [cx - hx, cy + hy, cz + hz],
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
  #|     rt.makeCubeEdges = (cx, cy, cz, sx, sy, sz, color) => {
  #|       const hx = sx / 2;
  #|       const hy = sy / 2;
  #|       const hz = sz / 2;
  #|       const p = [
  #|         [cx - hx, cy - hy, cz - hz],
  #|         [cx + hx, cy - hy, cz - hz],
  #|         [cx + hx, cy + hy, cz - hz],
  #|         [cx - hx, cy + hy, cz - hz],
  #|         [cx - hx, cy - hy, cz + hz],
  #|         [cx + hx, cy - hy, cz + hz],
  #|         [cx + hx, cy + hy, cz + hz],
  #|         [cx - hx, cy + hy, cz + hz],
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
  #|     rt.makeSphere = (cx, cy, cz, radius, color) => {
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
  #|           const p0 = [cx + Math.cos(th0) * Math.sin(phi0) * radius, cy + Math.cos(phi0) * radius, cz + Math.sin(th0) * Math.sin(phi0) * radius];
  #|           const p1 = [cx + Math.cos(th1) * Math.sin(phi0) * radius, cy + Math.cos(phi0) * radius, cz + Math.sin(th1) * Math.sin(phi0) * radius];
  #|           const p2 = [cx + Math.cos(th1) * Math.sin(phi1) * radius, cy + Math.cos(phi1) * radius, cz + Math.sin(th1) * Math.sin(phi1) * radius];
  #|           const p3 = [cx + Math.cos(th0) * Math.sin(phi1) * radius, cy + Math.cos(phi1) * radius, cz + Math.sin(th0) * Math.sin(phi1) * radius];
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
  #|     rt.makeCylinder = (cx, cy, cz, rtTop, rtBottom, height, slices, color) => {
  #|       const out = [];
  #|       const h2 = height / 2;
  #|       const n = Math.max(3, slices | 0);
  #|       for (let i = 0; i < n; i += 1) {
  #|         const a0 = (i / n) * Math.PI * 2;
  #|         const a1 = ((i + 1) / n) * Math.PI * 2;
  #|         const t0 = [cx + Math.cos(a0) * rtTop, cy + h2, cz + Math.sin(a0) * rtTop];
  #|         const t1 = [cx + Math.cos(a1) * rtTop, cy + h2, cz + Math.sin(a1) * rtTop];
  #|         const b0 = [cx + Math.cos(a0) * rtBottom, cy - h2, cz + Math.sin(a0) * rtBottom];
  #|         const b1 = [cx + Math.cos(a1) * rtBottom, cy - h2, cz + Math.sin(a1) * rtBottom];
  #|         out.push(
  #|           t0[0], t0[1], t0[2], color[0], color[1], color[2], color[3],
  #|           b0[0], b0[1], b0[2], color[0], color[1], color[2], color[3],
  #|           b1[0], b1[1], b1[2], color[0], color[1], color[2], color[3],
  #|           t0[0], t0[1], t0[2], color[0], color[1], color[2], color[3],
  #|           b1[0], b1[1], b1[2], color[0], color[1], color[2], color[3],
  #|           t1[0], t1[1], t1[2], color[0], color[1], color[2], color[3],
  #|         );
  #|         const top = [cx, cy + h2, cz];
  #|         out.push(
  #|           top[0], top[1], top[2], color[0], color[1], color[2], color[3],
  #|           t1[0], t1[1], t1[2], color[0], color[1], color[2], color[3],
  #|           t0[0], t0[1], t0[2], color[0], color[1], color[2], color[3],
  #|         );
  #|         const bottom = [cx, cy - h2, cz];
  #|         out.push(
  #|           bottom[0], bottom[1], bottom[2], color[0], color[1], color[2], color[3],
  #|           b0[0], b0[1], b0[2], color[0], color[1], color[2], color[3],
  #|           b1[0], b1[1], b1[2], color[0], color[1], color[2], color[3],
  #|         );
  #|       }
  #|       return new Float32Array(out);
  #|     };
  #|
  #|     rt.begin3d = (px, py, pz, tx, ty, tz, ux, uy, uz, fovy) => {
  #|       const section = {
  #|         camera: {
  #|           position: [px, py, pz],
  #|           target: [tx, ty, tz],
  #|           up: [ux, uy, uz],
  #|           fovy,
  #|         },
  #|         triCommands: [],
  #|         lineCommands: [],
  #|       };
  #|       rt.sections3d.push(section);
  #|       rt.current3dSection = section;
  #|     };
  #|     rt.end3d = () => {
  #|       rt.current3dSection = null;
  #|     };
  #|     rt.pushCube3d = (cx, cy, cz, sx, sy, sz, r, g, b, a) => {
  #|       if (!rt.current3dSection) return;
  #|       const verts = rt.makeCube(cx, cy, cz, sx, sy, sz, colorNorm(r, g, b, a));
  #|       rt.current3dSection.triCommands.push(verts);
  #|     };
  #|     rt.pushCubeWires3d = (cx, cy, cz, sx, sy, sz, r, g, b, a) => {
  #|       if (!rt.current3dSection) return;
  #|       const verts = rt.makeCubeEdges(cx, cy, cz, sx, sy, sz, colorNorm(r, g, b, a));
  #|       rt.current3dSection.lineCommands.push(verts);
  #|     };
  #|     rt.pushSphere3d = (cx, cy, cz, radius, r, g, b, a) => {
  #|       if (!rt.current3dSection) return;
  #|       const verts = rt.makeSphere(cx, cy, cz, radius, colorNorm(r, g, b, a));
  #|       rt.current3dSection.triCommands.push(verts);
  #|     };
  #|     rt.pushCylinder3d = (cx, cy, cz, rtTop, rtBottom, h, slices, r, g, b, a) => {
  #|       if (!rt.current3dSection) return;
  #|       const verts = rt.makeCylinder(cx, cy, cz, rtTop, rtBottom, h, slices, colorNorm(r, g, b, a));
  #|       rt.current3dSection.triCommands.push(verts);
  #|     };
  #|
  #|     rt.beginFrame = (r, g, b, a) => {
  #|       rt.clearColor = [clamp01(r), clamp01(g), clamp01(b), clamp01(a)];
  #|       rt.color2dCommands.length = 0;
  #|       rt.tex2dCommands.length = 0;
  #|       rt.sections3d.length = 0;
  #|       rt.current3dSection = null;
  #|     };
  #|
  #|     rt.renderSection3d = (pass, section) => {
  #|       const [w, h] = toCanvasSize();
  #|       const aspect = w / h;
  #|       const proj = mat4Perspective(section.camera.fovy, aspect, 0.1, 200.0);
  #|       const view = mat4LookAt(section.camera.position, section.camera.target, section.camera.up);
  #|       const viewProj = mat4Multiply(proj, view);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.camera3d, 0, viewProj.buffer, viewProj.byteOffset, viewProj.byteLength);
  #|       pass.setBindGroup(0, rt.bindGroups.camera3d);
  #|       if (section.triCommands.length > 0) {
  #|         pass.setPipeline(rt.pipelines.color3dTri);
  #|         let totalBytes = 0;
  #|         for (const verts of section.triCommands) totalBytes += verts.byteLength;
  #|         const vb = rt.ensureDynamicBuffer('dyn3dTri', totalBytes, GPUBufferUsage.VERTEX);
  #|         let offset = 0;
  #|         for (const verts of section.triCommands) {
  #|           rt.device.queue.writeBuffer(vb, offset, verts.buffer, verts.byteOffset, verts.byteLength);
  #|           pass.setVertexBuffer(0, vb, offset, verts.byteLength);
  #|           pass.draw(verts.length / 7, 1, 0, 0);
  #|           offset += verts.byteLength;
  #|         }
  #|       }
  #|       if (section.lineCommands.length > 0) {
  #|         pass.setPipeline(rt.pipelines.color3dLine);
  #|         let totalBytes = 0;
  #|         for (const verts of section.lineCommands) totalBytes += verts.byteLength;
  #|         const vb = rt.ensureDynamicBuffer('dyn3dLine', totalBytes, GPUBufferUsage.VERTEX);
  #|         let offset = 0;
  #|         for (const verts of section.lineCommands) {
  #|           rt.device.queue.writeBuffer(vb, offset, verts.buffer, verts.byteOffset, verts.byteLength);
  #|           pass.setVertexBuffer(0, vb, offset, verts.byteLength);
  #|           pass.draw(verts.length / 7, 1, 0, 0);
  #|           offset += verts.byteLength;
  #|         }
  #|       }
  #|     };
  #|
  #|     rt.render2d = (pass) => {
  #|       const [w, h] = toCanvasSize();
  #|       const canvasUniform = new Float32Array([w, h, 0, 0]);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.canvas2d, 0, canvasUniform.buffer, canvasUniform.byteOffset, canvasUniform.byteLength);
  #|       pass.setBindGroup(0, rt.bindGroups.canvas2d);
  #|       let colorBytes = 0;
  #|       for (const cmd of rt.color2dCommands) colorBytes += cmd.verts.byteLength;
  #|       const colorVb = colorBytes > 0
  #|         ? rt.ensureDynamicBuffer('dyn2dColor', colorBytes, GPUBufferUsage.VERTEX)
  #|         : null;
  #|       let colorOffset = 0;
  #|       for (const cmd of rt.color2dCommands) {
  #|         if (cmd.topology === 'line') pass.setPipeline(rt.pipelines.color2dLine);
  #|         else pass.setPipeline(rt.pipelines.color2dTri);
  #|         rt.device.queue.writeBuffer(colorVb, colorOffset, cmd.verts.buffer, cmd.verts.byteOffset, cmd.verts.byteLength);
  #|         pass.setVertexBuffer(0, colorVb, colorOffset, cmd.verts.byteLength);
  #|         pass.draw(cmd.verts.length / 6, 1, 0, 0);
  #|         colorOffset += cmd.verts.byteLength;
  #|       }
  #|       pass.setPipeline(rt.pipelines.tex2dTri);
  #|       let texBytes = 0;
  #|       for (const cmd of rt.tex2dCommands) texBytes += cmd.verts.byteLength;
  #|       const texVb = texBytes > 0
  #|         ? rt.ensureDynamicBuffer('dyn2dTex', texBytes, GPUBufferUsage.VERTEX)
  #|         : null;
  #|       let texOffset = 0;
  #|       for (const cmd of rt.tex2dCommands) {
  #|         const rec = cmd.textureRec;
  #|         if (!rec?.view) continue;
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
  #|           rt.renderSection3d(pass, section);
  #|           pass.end();
  #|           first = false;
  #|           rendered = true;
  #|         }
  #|       }
  #|       if (rt.color2dCommands.length > 0 || rt.tex2dCommands.length > 0 || !rendered) {
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
  #|
  #|       rt.uniformBuffers = {
  #|         canvas2d: rt.device.createBuffer({ size: 16, usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
  #|         camera3d: rt.device.createBuffer({ size: 64, usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
  #|       };
  #|       rt.bindGroupLayouts = {
  #|         canvas2d: rt.device.createBindGroupLayout({
  #|           entries: [{ binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} }],
  #|         }),
  #|         tex2d: rt.device.createBindGroupLayout({
  #|           entries: [
  #|             { binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} },
  #|             { binding: 1, visibility: GPUShaderStage.FRAGMENT, sampler: {} },
  #|             { binding: 2, visibility: GPUShaderStage.FRAGMENT, texture: {} },
  #|           ],
  #|         }),
  #|         camera3d: rt.device.createBindGroupLayout({
  #|           entries: [{ binding: 0, visibility: GPUShaderStage.VERTEX, buffer: {} }],
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
  #|       };
  #|       const blendState = {
  #|         color: { srcFactor: 'src-alpha', dstFactor: 'one-minus-src-alpha', operation: 'add' },
  #|         alpha: { srcFactor: 'one', dstFactor: 'one-minus-src-alpha', operation: 'add' },
  #|       };
  #|
  #|       const layout2dColor = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.canvas2d] });
  #|       const layout2dTex = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.tex2d] });
  #|       const layout3d = rt.device.createPipelineLayout({ bindGroupLayouts: [rt.bindGroupLayouts.camera3d] });
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
) -> Unit =
  #| (path, dx, dy, dw, dh, hasSource, sx, sy, sw, sh, a, b, c, d, tx, ty, repeatMode) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushImage(path, dx, dy, dw, dh, hasSource, sx, sy, sw, sh, a, b, c, d, tx, ty, repeatMode);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_text(
  text : String,
  x : Double,
  y : Double,
  family : String,
  size : Double,
  align : Int,
  baseline : Int,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit =
  #| (text, x, y, family, size, align, baseline, r, g, b, a) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushText(text, x, y, family, size, align, baseline, r, g, b, a);
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
  align : Int,
  baseline : Int,
) -> Unit =
  #| (key, x, y, align, baseline) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCachedText?.(key, x, y, align, baseline);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
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
  #| (x, y, w, h, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushRect(x, y, w, h, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_circle(
  center_x : Double,
  center_y : Double,
  radius : Double,
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
  #| (cx, cy, radius, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCircle(cx, cy, radius, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_gradient_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
  start_r : Double,
  start_g : Double,
  start_b : Double,
  start_a : Double,
  end_r : Double,
  end_g : Double,
  end_b : Double,
  end_a : Double,
) -> Unit =
  #| (x, y, w, h, sr, sg, sb, sa, er, eg, eb, ea) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushGradientRect(x, y, w, h, sr, sg, sb, sa, er, eg, eb, ea);
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
) -> Unit =
  #| (px, py, pz, tx, ty, tz, ux, uy, uz, fovy) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.begin3d(px, py, pz, tx, ty, tz, ux, uy, uz, fovy);
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
extern "js" fn webgpu_draw_cube_3d(
  center_x : Double,
  center_y : Double,
  center_z : Double,
  size_x : Double,
  size_y : Double,
  size_z : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit =
  #| (cx, cy, cz, sx, sy, sz, r, g, b, a) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCube3d(cx, cy, cz, sx, sy, sz, r, g, b, a);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_cube_wires_3d(
  center_x : Double,
  center_y : Double,
  center_z : Double,
  size_x : Double,
  size_y : Double,
  size_z : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit =
  #| (cx, cy, cz, sx, sy, sz, r, g, b, a) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCubeWires3d(cx, cy, cz, sx, sy, sz, r, g, b, a);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_sphere_3d(
  center_x : Double,
  center_y : Double,
  center_z : Double,
  radius : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit =
  #| (cx, cy, cz, radius, r, g, b, a) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushSphere3d(cx, cy, cz, radius, r, g, b, a);
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
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit =
  #| (cx, cy, cz, rtTop, rtBottom, h, slices, r, g, b, a) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCylinder3d(cx, cy, cz, rtTop, rtBottom, h, slices, r, g, b, a);
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
#external
type Audio
