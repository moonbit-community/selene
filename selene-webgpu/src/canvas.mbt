///|
extern "js" fn webgpu_initialize(
  canvas : @dom.HTMLCanvasElement,
  width : Double,
  height : Double,
  image_smooth : Bool,
  shader_sources : Array[String],
) -> Unit =
  #| (canvas, width, height, imageSmooth, shaderSources) => {
  #|   const g = globalThis;
  #|   if (!g.__selene_webgpu_runtime) {
  #|     const shaderSource = (index) => String(Array.isArray(shaderSources) ? (shaderSources[index] || '') : '');
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
  #|       passes2d: [],
  #|       current2dPass: null,
  #|       offscreenTargets2d: new Map(),
  #|       sections3d: [],
  #|       current3dSection: null,
  #|       imageCache: new Map(),
  #|       textCache: new Map(),
  #|       shadow3d: {
  #|         directional: new Float32Array(),
  #|         point: new Float32Array(),
  #|         spot: new Float32Array(),
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
  #|       retiredDynamicBuffers: [],
  #|       primitiveMeshCache: new Map(),
  #|       retainedInstanceBuffers3d: new Map(),
  #|       frameBindGroupCache3d: new Map(),
  #|       bindGroupResourceIds: new WeakMap(),
  #|       nextBindGroupResourceId: 1,
  #|     };
  #|
  #|     const clamp01 = (x) => Math.max(0, Math.min(1, x));
  #|     const toCanvasSize = () => [
  #|       Math.max(1, Math.floor(rt.canvas?.width || 1)),
  #|       Math.max(1, Math.floor(rt.canvas?.height || 1)),
  #|     ];
  #|     const nextPow2 = (v) => {
  #|       let n = 1;
  #|       while (n < v) n <<= 1;
  #|       return n;
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
  #|       const columns = safeCascadeCount <= 1 ? 1 : 2;
  #|       const rows = safeCascadeCount <= 2 ? 1 : 2;
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
  #|           // A buffer may already be referenced by commands recorded earlier
  #|           // in the same encoder. Retire it only after queue.submit().
  #|           rt.retiredDynamicBuffers.push(existed.buffer);
  #|         }
  #|         const size = nextPow2(Math.max(256, byteSize));
  #|         const buffer = rt.device.createBuffer({ size, usage: usage | GPUBufferUsage.COPY_DST });
  #|         rt.dynamicBuffers.set(name, { buffer, size });
  #|       }
  #|       return rt.dynamicBuffers.get(name).buffer;
  #|     };
  #|
  #|     rt.destroyPrimitiveMeshCache = () => {
  #|       for (const record of rt.primitiveMeshCache.values()) {
  #|         if (record?.buffer) {
  #|           try { record.buffer.destroy(); } catch (_err) {}
  #|         }
  #|       }
  #|       rt.primitiveMeshCache.clear();
  #|     };
  #|
  #|     rt.destroyRetainedInstanceBuffers3d = () => {
  #|       for (const record of rt.retainedInstanceBuffers3d.values()) {
  #|         if (record?.buffer) {
  #|           try { record.buffer.destroy(); } catch (_err) {}
  #|         }
  #|       }
  #|       rt.retainedInstanceBuffers3d.clear();
  #|     };
  #|
  #|     rt.releaseRetainedInstanceBuffer3d = (key) => {
  #|       const retainedKey = String(key || '');
  #|       const record = rt.retainedInstanceBuffers3d.get(retainedKey);
  #|       if (record?.buffer) {
  #|         try { record.buffer.destroy(); } catch (_err) {}
  #|       }
  #|       rt.retainedInstanceBuffers3d.delete(retainedKey);
  #|     };
  #|
  #|     rt.resolvePrimitiveMeshRecord = (key, createVerts) => {
  #|       const cacheKey = String(key || '');
  #|       const existing = rt.primitiveMeshCache.get(cacheKey);
  #|       if (existing?.buffer && existing?.verts) {
  #|         return existing;
  #|       }
  #|       const verts = createVerts();
  #|       if (!verts || verts.byteLength <= 0) {
  #|         return null;
  #|       }
  #|       const buffer = rt.device.createBuffer({
  #|         size: verts.byteLength,
  #|         usage: GPUBufferUsage.VERTEX | GPUBufferUsage.COPY_DST,
  #|       });
  #|       rt.device.queue.writeBuffer(buffer, 0, verts.buffer, verts.byteOffset, verts.byteLength);
  #|       const record = {
  #|         key: cacheKey,
  #|         verts,
  #|         buffer,
  #|         vertexCount: verts.length / 17,
  #|         byteLength: verts.byteLength,
  #|       };
  #|       rt.primitiveMeshCache.set(cacheKey, record);
  #|       return record;
  #|     };
  #|
  #|     rt.releasePrimitiveMeshResource = (key) => {
  #|       const cacheKey = String(key || '');
  #|       const record = rt.primitiveMeshCache.get(cacheKey);
  #|       if (record?.buffer) {
  #|         try { record.buffer.destroy(); } catch (_err) {}
  #|       }
  #|       rt.primitiveMeshCache.delete(cacheKey);
  #|     };
  #|
  #|     rt.uploadLitPrimitiveMeshResource = (key, vertices) => {
  #|       rt.resolvePrimitiveMeshRecord(key, () => new Float32Array(vertices || []));
  #|     };
  #|
  #|     rt.bindGroupResourceId = (resource) => {
  #|       if (!resource || (typeof resource !== 'object' && typeof resource !== 'function')) {
  #|         return 'none';
  #|       }
  #|       let id = rt.bindGroupResourceIds.get(resource);
  #|       if (!id) {
  #|         id = rt.nextBindGroupResourceId++;
  #|         rt.bindGroupResourceIds.set(resource, id);
  #|       }
  #|       return String(id);
  #|     };
  #|
  #|     rt.cached3dBindGroup = (key, createBindGroup) => {
  #|       const cacheKey = String(key || '');
  #|       const cached = rt.frameBindGroupCache3d.get(cacheKey);
  #|       if (cached) return cached;
  #|       const bindGroup = createBindGroup();
  #|       rt.frameBindGroupCache3d.set(cacheKey, bindGroup);
  #|       return bindGroup;
  #|     };
  #|
  #|     rt.shadowBindGroupKey3d = (shadowState) => [
  #|       rt.bindGroupResourceId(shadowState.directionalRecords[0].view),
  #|       rt.bindGroupResourceId(shadowState.directionalRecords[1].view),
  #|       rt.bindGroupResourceId(shadowState.directionalRecords[2].view),
  #|       rt.bindGroupResourceId(shadowState.directionalRecords[3].view),
  #|       rt.bindGroupResourceId(shadowState.spotRecord.view),
  #|       rt.bindGroupResourceId(shadowState.pointRecord.view),
  #|     ].join('|');
  #|
  #|     rt.resolveLit3dBindGroup = (shadowState) =>
  #|       rt.cached3dBindGroup(`lit:${rt.shadowBindGroupKey3d(shadowState)}`, () =>
  #|         rt.device.createBindGroup({
  #|           layout: rt.bindGroupLayouts.lit3d,
  #|           entries: [
  #|             { binding: 0, resource: { buffer: rt.uniformBuffers.camera3d } },
  #|             { binding: 1, resource: { buffer: rt.uniformBuffers.light3d } },
  #|             { binding: 2, resource: { buffer: rt.uniformBuffers.shadow3d } },
  #|             { binding: 3, resource: rt.samplers.shadowCompare },
  #|             { binding: 4, resource: shadowState.directionalRecords[0].view },
  #|             { binding: 5, resource: shadowState.directionalRecords[1].view },
  #|             { binding: 6, resource: shadowState.directionalRecords[2].view },
  #|             { binding: 7, resource: shadowState.directionalRecords[3].view },
  #|             { binding: 8, resource: shadowState.spotRecord.view },
  #|             { binding: 9, resource: shadowState.pointRecord.view },
  #|           ],
  #|         }),
  #|       );
  #|
  #|     rt.resolveLitTex3dBindGroup = (cmd, shadowState) => {
  #|       const key = [
  #|         'lit-tex',
  #|         rt.shadowBindGroupKey3d(shadowState),
  #|         cmd.baseSamplerCode,
  #|         rt.bindGroupResourceId(cmd.textureRec.view),
  #|         cmd.emissiveSamplerCode,
  #|         rt.bindGroupResourceId(cmd.emissiveTextureRec.view),
  #|         cmd.metallicRoughnessSamplerCode,
  #|         rt.bindGroupResourceId(cmd.metallicRoughnessTextureRec.view),
  #|         cmd.occlusionSamplerCode,
  #|         rt.bindGroupResourceId(cmd.occlusionTextureRec.view),
  #|         cmd.normalSamplerCode,
  #|         rt.bindGroupResourceId(cmd.normalTextureRec.view),
  #|       ].join('|');
  #|       return rt.cached3dBindGroup(key, () =>
  #|         rt.device.createBindGroup({
  #|           layout: rt.bindGroupLayouts.lit3dTex,
  #|           entries: [
  #|             { binding: 0, resource: { buffer: rt.uniformBuffers.camera3d } },
  #|             { binding: 1, resource: { buffer: rt.uniformBuffers.light3d } },
  #|             { binding: 2, resource: { buffer: rt.uniformBuffers.shadow3d } },
  #|             { binding: 3, resource: rt.samplers.shadowCompare },
  #|             { binding: 4, resource: shadowState.directionalRecords[0].view },
  #|             { binding: 5, resource: shadowState.directionalRecords[1].view },
  #|             { binding: 6, resource: shadowState.directionalRecords[2].view },
  #|             { binding: 7, resource: shadowState.directionalRecords[3].view },
  #|             { binding: 8, resource: shadowState.spotRecord.view },
  #|             { binding: 9, resource: shadowState.pointRecord.view },
  #|             { binding: 10, resource: rt.resolveSampler(cmd.baseSamplerCode) },
  #|             { binding: 11, resource: cmd.textureRec.view },
  #|             { binding: 12, resource: rt.resolveSampler(cmd.emissiveSamplerCode) },
  #|             { binding: 13, resource: cmd.emissiveTextureRec.view },
  #|             { binding: 14, resource: rt.resolveSampler(cmd.metallicRoughnessSamplerCode) },
  #|             { binding: 15, resource: cmd.metallicRoughnessTextureRec.view },
  #|             { binding: 16, resource: rt.resolveSampler(cmd.occlusionSamplerCode) },
  #|             { binding: 17, resource: cmd.occlusionTextureRec.view },
  #|             { binding: 18, resource: rt.resolveSampler(cmd.normalSamplerCode) },
  #|             { binding: 19, resource: cmd.normalTextureRec.view },
  #|           ],
  #|         }),
  #|       );
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
  #|     const OFFSCREEN_IMAGE_PREFIX = 'offscreen://';
  #|     rt.ensureOffscreenTarget2d = (name, width, height) => {
  #|       if (!rt.ready || !rt.device || !rt.format) return null;
  #|       const key = String(name || '');
  #|       if (!key) return null;
  #|       const w = Math.max(1, Math.floor(width || 1));
  #|       const h = Math.max(1, Math.floor(height || 1));
  #|       const existing = rt.offscreenTargets2d.get(key);
  #|       if (
  #|         existing &&
  #|         existing.width === w &&
  #|         existing.height === h &&
  #|         existing.texture &&
  #|         existing.view
  #|       ) {
  #|         return existing;
  #|       }
  #|       if (existing?.texture) {
  #|         try { existing.texture.destroy(); } catch (_err) {}
  #|       }
  #|       const texture = rt.device.createTexture({
  #|         size: [w, h, 1],
  #|         format: rt.format,
  #|         usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.COPY_SRC,
  #|       });
  #|       const created = { texture, view: texture.createView(), width: w, height: h };
  #|       rt.offscreenTargets2d.set(key, created);
  #|       return created;
  #|     };
  #|
  #|     rt.ensureImage = (path) => {
  #|       if (typeof path === 'string' && path.startsWith(OFFSCREEN_IMAGE_PREFIX)) {
  #|         const name = path.slice(OFFSCREEN_IMAGE_PREFIX.length);
  #|         const target = rt.offscreenTargets2d.get(name);
  #|         if (!target?.view) {
  #|           return { state: 'error', texture: null, view: null, width: 1, height: 1, promise: null };
  #|         }
  #|         return {
  #|           state: 'ready',
  #|           texture: target.texture,
  #|           view: target.view,
  #|           width: target.width,
  #|           height: target.height,
  #|           promise: null,
  #|         };
  #|       }
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
  #|     rt.current2dCommandList = () =>
  #|       rt.current2dPass?.commands || rt.draw2dCommands;
  #|     rt.beginPass2d = (x, y, w, h, loadOp, clearColor, targetName = '') => {
  #|       const hasTarget = typeof targetName === 'string' && targetName.length > 0;
  #|       if (hasTarget) {
  #|         const target = rt.ensureOffscreenTarget2d(targetName, w, h);
  #|         if (target) {
  #|           rt.current2dPass = {
  #|             viewport: [0, 0, target.width, target.height],
  #|             loadOp,
  #|             clearColor,
  #|             commands: [],
  #|             targetName,
  #|             targetSize: [target.width, target.height],
  #|           };
  #|           return;
  #|         }
  #|       }
  #|       rt.current2dPass = {
  #|         viewport: [x, y, w, h],
  #|         loadOp,
  #|         clearColor,
  #|         commands: [],
  #|         targetName: '',
  #|         targetSize: null,
  #|       };
  #|     };
  #|     rt.endPass2d = () => {
  #|       if (!rt.current2dPass) return;
  #|       rt.passes2d.push(rt.current2dPass);
  #|       rt.current2dPass = null;
  #|     };
  #|     rt.pushColor2d = (verts, pipelineCode = 0) => {
  #|       rt.current2dCommandList().push({ kind: 'color', verts, pipelineCode });
  #|     };
  #|     rt.pushTex2d = (samplerCode, textureRec, verts, pipelineCode = 8) => {
  #|       rt.current2dCommandList().push({
  #|         kind: 'tex',
  #|         samplerCode,
  #|         textureRec,
  #|         verts,
  #|         pipelineCode,
  #|       });
  #|     };
  #|     rt.pushClip2d = (x, y, w, h) => {
  #|       rt.current2dCommandList().push({
  #|         kind: 'pushClip',
  #|         rect: [x, y, w, h],
  #|       });
  #|     };
  #|     rt.popClip2d = () => {
  #|       rt.current2dCommandList().push({ kind: 'popClip' });
  #|     };
  #|     rt.resetClip2d = () => {
  #|       rt.current2dCommandList().push({ kind: 'resetClip' });
  #|     };
  #|
  #|     rt.begin3d = (viewProjection, px, py, pz, tx, ty, tz, ux, uy, uz, fovy, near, far, orthographic, orthoWidth, orthoHeight) => {
  #|       const section = {
  #|         viewProjection: new Float32Array(
  #|           Array.isArray(viewProjection) && viewProjection.length === 16
  #|             ? viewProjection
  #|             : [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
  #|         ),
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
  #|         skyboxTexTriCommands: [],
  #|         litTriCommands: [],
  #|         instancedLitCommands: [],
  #|         texTriCommands: [],
  #|         lineCommands: [],
  #|       };
  #|       rt.sections3d.push(section);
  #|       rt.current3dSection = section;
  #|     };
  #|     rt.end3d = () => {
  #|       rt.current3dSection = null;
  #|     };
  #|     rt.pushLitPrimitiveMeshBatch3d = (cacheKey, retainedKey, instances, doubleSided, castShadows) => {
  #|       if (!rt.current3dSection) return;
  #|       const meshRecord = rt.primitiveMeshCache.get(String(cacheKey || ''));
  #|       if (!meshRecord) return;
  #|       rt.current3dSection.instancedLitCommands.push({
  #|         meshRecord,
  #|         retainedKey: String(retainedKey || ''),
  #|         instances,
  #|         doubleSided: !!doubleSided,
  #|         castShadows: !!castShadows,
  #|         instanceArray: null,
  #|       });
  #|     };
  #|     rt.pushColoredTriangles3d = (verts, doubleSided, castShadows) => {
  #|       if (!rt.current3dSection) return;
  #|       if (!verts || verts.length < 51) return;
  #|       const triVertexCount = Math.floor(verts.length / 17);
  #|       if (triVertexCount < 3) return;
  #|       const out = new Float32Array(triVertexCount * 17);
  #|       for (let i = 0; i < out.length; i += 1) {
  #|         out[i] = Number(verts[i]) || 0.0;
  #|       }
  #|       rt.current3dSection.litTriCommands.push({
  #|         verts: out,
  #|         doubleSided: !!doubleSided,
  #|         castShadows: !!castShadows,
  #|       });
  #|     };
  #|     rt.pushLines3d = (verts) => {
  #|       if (!rt.current3dSection) return;
  #|       if (!verts || verts.length < 14) return;
  #|       const lineVertexCount = Math.floor(verts.length / 7);
  #|       if (lineVertexCount < 2) return;
  #|       const out = new Float32Array(lineVertexCount * 7);
  #|       for (let i = 0; i < out.length; i += 1) {
  #|         out[i] = Number(verts[i]) || 0.0;
  #|       }
  #|       rt.current3dSection.lineCommands.push(out);
  #|     };
  #|     rt.pushTexturedTriangles3d = (basePath, emissivePath, metallicRoughnessPath, occlusionPath, normalPath, baseSamplerCode, emissiveSamplerCode, metallicRoughnessSamplerCode, occlusionSamplerCode, normalSamplerCode, verts, doubleSided, castShadows) => {
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
  #|       });
  #|     };
  #|     rt.pushSkyboxTexturedTriangles3d = (basePath, verts) => {
  #|       if (!rt.current3dSection) return;
  #|       if (!verts || verts.length < 105) return;
  #|       const baseRec = (basePath && basePath.length > 0)
  #|         ? rt.ensureImage(basePath)
  #|         : rt.ensureSolidTexture('__solid:white', 255, 255, 255, 1.0);
  #|       const whiteRec = rt.ensureSolidTexture('__solid:white', 255, 255, 255, 1.0);
  #|       const normalRec = rt.ensureSolidTexture('__solid:normal', 128, 128, 255, 1.0);
  #|       if (!baseRec || !whiteRec || !normalRec) return;
  #|       const triVertexCount = Math.floor(verts.length / 35);
  #|       if (triVertexCount < 3) return;
  #|       const out = new Float32Array(triVertexCount * 35);
  #|       for (let i = 0; i < out.length; i += 1) {
  #|         out[i] = Number(verts[i]) || 0.0;
  #|       }
  #|       rt.current3dSection.skyboxTexTriCommands.push({
  #|         textureRec: baseRec,
  #|         emissiveTextureRec: whiteRec,
  #|         metallicRoughnessTextureRec: whiteRec,
  #|         occlusionTextureRec: whiteRec,
  #|         normalTextureRec: normalRec,
  #|         baseSamplerCode: 0,
  #|         emissiveSamplerCode: 0,
  #|         metallicRoughnessSamplerCode: 0,
  #|         occlusionSamplerCode: 0,
  #|         normalSamplerCode: 0,
  #|         verts: out,
  #|       });
  #|     };
  #|
  #|     rt.beginFrame = (r, g, b, a) => {
  #|       rt.clearColor = [clamp01(r), clamp01(g), clamp01(b), clamp01(a)];
  #|       rt.draw2dCommands.length = 0;
  #|       rt.passes2d.length = 0;
  #|       rt.current2dPass = null;
  #|       rt.sections3d.length = 0;
  #|       rt.current3dSection = null;
  #|       rt.frameBindGroupCache3d.clear();
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
  #|     rt.uploadInstancedLitBuffers3d = (commands) => {
  #|       if (!commands || commands.length === 0) {
  #|         return;
  #|       }
  #|       for (const command of commands) {
  #|         command.instanceArray = new Float32Array(command.instances);
  #|         command.instanceBuffer = null;
  #|         command.instanceByteLength = 0;
  #|         const instances = command.instanceArray;
  #|         if (!instances?.byteLength) continue;
  #|         const key = String(command.retainedKey || '');
  #|         if (key.length === 0) continue;
  #|         let retained = rt.retainedInstanceBuffers3d.get(key);
  #|         if (!retained) {
  #|           const buffer = rt.device.createBuffer({
  #|             size: instances.byteLength,
  #|             usage: GPUBufferUsage.VERTEX | GPUBufferUsage.COPY_DST,
  #|           });
  #|           rt.device.queue.writeBuffer(buffer, 0, instances.buffer, instances.byteOffset, instances.byteLength);
  #|           retained = { buffer, byteLength: instances.byteLength };
  #|           rt.retainedInstanceBuffers3d.set(key, retained);
  #|         }
  #|         command.instanceBuffer = retained.buffer;
  #|         command.instanceByteLength = retained.byteLength;
  #|       }
  #|     };
  #|
  #|     rt.prepareSectionBuffers3d = (section) => {
  #|       return {
  #|         tri: rt.uploadCommandBuffer3d('dyn3dTri', section.triCommands, (cmd) => cmd.verts),
  #|         line: rt.uploadCommandBuffer3d('dyn3dLine', section.lineCommands, (verts) => verts),
  #|         skyboxTex: rt.uploadCommandBuffer3d('dyn3dSkyboxTexTri', section.skyboxTexTriCommands, (cmd) => cmd.verts),
  #|         lit: rt.uploadCommandBuffer3d('dyn3dLitTri', section.litTriCommands, (cmd) => cmd.verts),
  #|         instancedLit: rt.uploadInstancedLitBuffers3d(section.instancedLitCommands),
  #|         tex: rt.uploadCommandBuffer3d('dyn3dLitTexTri', section.texTriCommands, (cmd) => cmd.verts),
  #|       };
  #|     };
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
  #|       if (section.instancedLitCommands.length > 0) {
  #|         pass.setPipeline(rt.pipelines.shadow3dLitInstanced);
  #|         pass.setBindGroup(0, solidBindGroup);
  #|         for (let index = 0; index < section.instancedLitCommands.length; index += 1) {
  #|           const cmd = section.instancedLitCommands[index];
  #|           if (!cmd.castShadows || !cmd.meshRecord?.buffer || !cmd.instanceBuffer || !cmd.instanceArray?.length) continue;
  #|           pass.setVertexBuffer(0, cmd.meshRecord.buffer, 0, cmd.meshRecord.byteLength);
  #|           pass.setVertexBuffer(1, cmd.instanceBuffer, 0, cmd.instanceByteLength);
  #|           pass.draw(cmd.meshRecord.vertexCount, cmd.instanceArray.length / 11, 0, 0);
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
  #|     rt.countDirectionalShadowPackets3d = (values, lightIndex) => {
  #|       let count = 0;
  #|       for (let offset = 0; offset + 23 < values.length; offset += 24) {
  #|         if ((Math.round(values[offset]) | 0) === lightIndex) count += 1;
  #|       }
  #|       return count;
  #|     };
  #|
  #|     rt.findShadowPacket3d = (values, stride, slot) => {
  #|       for (let offset = 0; offset + stride - 1 < values.length; offset += stride) {
  #|         if ((Math.round(values[offset]) | 0) === slot) return offset;
  #|       }
  #|       return -1;
  #|     };
  #|
  #|     rt.renderDirectionalShadowMaps3d = (encoder, section, buffers, camera, aspect, shadow, shadowState) => {
  #|       const directional = shadow?.directional || new Float32Array();
  #|       const shadowView = rt.shadowViewProjection3d?.directional || new Float32Array();
  #|       const tileSize = Math.max(1, Number(shadow?.directionalShadowMapSize) || 2048);
  #|       const lightCount = Math.min(4, Math.floor(directional.length / 4));
  #|       if (lightCount <= 0) return;
  #|       for (let lightIndex = 0; lightIndex < lightCount; lightIndex += 1) {
  #|         const base = lightIndex * 4;
  #|         if (directional[base] < 0.5) continue;
  #|         const cascadeCount = rt.countDirectionalShadowPackets3d(shadowView, lightIndex);
  #|         if (cascadeCount <= 0) continue;
  #|         const record = rt.ensureDirectionalShadowTexture(lightIndex, tileSize, cascadeCount);
  #|         if (!record?.view) continue;
  #|         shadowState.directionalRecords[lightIndex] = record;
  #|         shadowState.directionalEnabled[lightIndex] = 1;
  #|         shadowState.directionalCascadeCounts[lightIndex] = cascadeCount;
  #|         shadowState.directionalDepthBiases[lightIndex] = directional[base + 1] || 0;
  #|         shadowState.directionalNormalBiases[lightIndex] = directional[base + 2] || 0;
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
  #|         for (let offset = 0; offset + 23 < shadowView.length; offset += 24) {
  #|           if ((Math.round(shadowView[offset]) | 0) !== lightIndex) continue;
  #|           const cascadeIndex = Math.max(0, Math.min(3, Math.round(shadowView[offset + 1]) | 0));
  #|           const matrix = shadowView.subarray(offset + 2, offset + 18);
  #|           const rectOffsetX = shadowView[offset + 18] || 0;
  #|           const rectOffsetY = shadowView[offset + 19] || 0;
  #|           const rectScaleX = shadowView[offset + 20] || 0;
  #|           const rectScaleY = shadowView[offset + 21] || 0;
  #|           const viewportX = rectOffsetX * record.width;
  #|           const viewportY = rectOffsetY * record.height;
  #|           const scissorX = Math.max(0, Math.floor(viewportX));
  #|           const scissorY = Math.max(0, Math.floor(viewportY));
  #|           pass.setViewport(viewportX, viewportY, tileSize, tileSize, 0.0, 1.0);
  #|           pass.setScissorRect(scissorX, scissorY, tileSize | 0, tileSize | 0);
  #|           rt.renderShadowCastersForSetup(
  #|             pass,
  #|             section,
  #|             buffers,
  #|             matrix,
  #|             shadowState.shadowCameraBufferCursor,
  #|           );
  #|           shadowState.shadowCameraBufferCursor += 1;
  #|           const stateIndex = lightIndex * 4 + cascadeIndex;
  #|           shadowState.directionalMatrices[stateIndex] = matrix;
  #|           shadowState.directionalRects[stateIndex] = [rectOffsetX, rectOffsetY, rectScaleX, rectScaleY];
  #|           shadowState.directionalBounds[stateIndex] = [shadowView[offset + 22] || 0, shadowView[offset + 23] || 0, 0, 0];
  #|         }
  #|         pass.end();
  #|       }
  #|     };
  #|
  #|     rt.renderSpotShadowMaps3d = (encoder, section, buffers, shadow, shadowState) => {
  #|       const spot = shadow?.spot || new Float32Array();
  #|       const shadowView = rt.shadowViewProjection3d?.spot || new Float32Array();
  #|       const tileSize = Math.max(1, Number(shadow?.directionalShadowMapSize) || 2048);
  #|       const lightCount = Math.min(4, Math.floor(spot.length / 3));
  #|       if (lightCount <= 0) return;
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
  #|       for (let lightIndex = 0; lightIndex < lightCount; lightIndex += 1) {
  #|         const base = lightIndex * 3;
  #|         if (spot[base] < 0.5) continue;
  #|         const setupOffset = rt.findShadowPacket3d(shadowView, 21, lightIndex);
  #|         if (setupOffset < 0) continue;
  #|         const matrix = shadowView.subarray(setupOffset + 1, setupOffset + 17);
  #|         const rectOffsetX = shadowView[setupOffset + 17] || 0;
  #|         const rectOffsetY = shadowView[setupOffset + 18] || 0;
  #|         const rectScaleX = shadowView[setupOffset + 19] || 0;
  #|         const rectScaleY = shadowView[setupOffset + 20] || 0;
  #|         const viewportX = rectOffsetX * record.width;
  #|         const viewportY = rectOffsetY * record.height;
  #|         const scissorX = Math.max(0, Math.floor(viewportX));
  #|         const scissorY = Math.max(0, Math.floor(viewportY));
  #|         pass.setViewport(viewportX, viewportY, tileSize, tileSize, 0.0, 1.0);
  #|         pass.setScissorRect(scissorX, scissorY, tileSize | 0, tileSize | 0);
  #|         rt.renderShadowCastersForSetup(
  #|           pass,
  #|           section,
  #|           buffers,
  #|           matrix,
  #|           shadowState.shadowCameraBufferCursor,
  #|         );
  #|         shadowState.shadowCameraBufferCursor += 1;
  #|         shadowState.spotEnabled[lightIndex] = 1;
  #|         shadowState.spotDepthBiases[lightIndex] = spot[base + 1] || 0;
  #|         shadowState.spotNormalBiases[lightIndex] = spot[base + 2] || 0;
  #|         shadowState.spotMatrices[lightIndex] = matrix;
  #|         shadowState.spotRects[lightIndex] = [rectOffsetX, rectOffsetY, rectScaleX, rectScaleY];
  #|       }
  #|       pass.end();
  #|     };
  #|
  #|     rt.renderPointShadowMaps3d = (encoder, section, buffers, shadow, shadowState) => {
  #|       const point = shadow?.point || new Float32Array();
  #|       const shadowView = rt.shadowViewProjection3d?.point || new Float32Array();
  #|       const faceSize = Math.max(1, Number(shadow?.pointShadowMapSize) || 1024);
  #|       const lightCount = Math.min(8, Math.floor(point.length / 3));
  #|       if (lightCount <= 0) return;
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
  #|       for (let lightIndex = 0; lightIndex < lightCount; lightIndex += 1) {
  #|         const base = lightIndex * 3;
  #|         if (point[base] < 0.5) continue;
  #|         shadowState.pointEnabled[lightIndex] = 1;
  #|         shadowState.pointDepthBiases[lightIndex] = point[base + 1] || 0;
  #|         shadowState.pointNormalBiases[lightIndex] = point[base + 2] || 0;
  #|         for (let faceIndex = 0; faceIndex < 6; faceIndex += 1) {
  #|           const stateIndex = lightIndex * 6 + faceIndex;
  #|           const setupOffset = rt.findShadowPacket3d(shadowView, 21, stateIndex);
  #|           if (setupOffset < 0) continue;
  #|           const matrix = shadowView.subarray(setupOffset + 1, setupOffset + 17);
  #|           const rectOffsetX = shadowView[setupOffset + 17] || 0;
  #|           const rectOffsetY = shadowView[setupOffset + 18] || 0;
  #|           const rectScaleX = shadowView[setupOffset + 19] || 0;
  #|           const rectScaleY = shadowView[setupOffset + 20] || 0;
  #|           const viewportX = rectOffsetX * record.width;
  #|           const viewportY = rectOffsetY * record.height;
  #|           const scissorX = Math.max(0, Math.floor(viewportX));
  #|           const scissorY = Math.max(0, Math.floor(viewportY));
  #|           pass.setViewport(viewportX, viewportY, faceSize, faceSize, 0.0, 1.0);
  #|           pass.setScissorRect(scissorX, scissorY, faceSize | 0, faceSize | 0);
  #|           rt.renderShadowCastersForSetup(
  #|             pass,
  #|             section,
  #|             buffers,
  #|             matrix,
  #|             shadowState.shadowCameraBufferCursor,
  #|           );
  #|           shadowState.shadowCameraBufferCursor += 1;
  #|           shadowState.pointMatrices[stateIndex] = matrix;
  #|           shadowState.pointRects[stateIndex] = [rectOffsetX, rectOffsetY, rectScaleX, rectScaleY];
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
  #|       const shadow = rt.shadow3d || {
  #|         directional: new Float32Array(),
  #|         point: new Float32Array(),
  #|         spot: new Float32Array(),
  #|         directionalShadowMapSize: 2048,
  #|         pointShadowMapSize: 1024,
  #|       };
  #|       const lightUniform = rt.lightUniform3d?.length === 176
  #|         ? rt.lightUniform3d
  #|         : new Float32Array(44 * 4);
  #|       const buffers = rt.prepareSectionBuffers3d(section);
  #|       const shadowState = rt.createShadowState3d();
  #|       rt.renderDirectionalShadowMaps3d(encoder, section, buffers, camera, aspect, shadow, shadowState);
  #|       rt.renderSpotShadowMaps3d(encoder, section, buffers, shadow, shadowState);
  #|       rt.renderPointShadowMaps3d(encoder, section, buffers, shadow, shadowState);
  #|       const shadowUniform = rt.buildShadowUniform3d(shadowState);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.camera3d, 0, section.viewProjection.buffer, section.viewProjection.byteOffset, section.viewProjection.byteLength);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.light3d, 0, lightUniform.buffer, lightUniform.byteOffset, lightUniform.byteLength);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.shadow3d, 0, shadowUniform.buffer, shadowUniform.byteOffset, shadowUniform.byteLength);
  #|       return { buffers, shadowState };
  #|     };
  #|
  #|     rt.renderSection3d = (pass, section, state) => {
  #|       pass.setBindGroup(0, rt.bindGroups.camera3d);
  #|       if (state.buffers.skyboxTex.buffer && section.skyboxTexTriCommands.length > 0) {
  #|         for (let index = 0; index < section.skyboxTexTriCommands.length; index += 1) {
  #|           const cmd = section.skyboxTexTriCommands[index];
  #|           const rec = cmd.textureRec;
  #|           const emissiveRec = cmd.emissiveTextureRec;
  #|           const metallicRoughnessRec = cmd.metallicRoughnessTextureRec;
  #|           const occlusionRec = cmd.occlusionTextureRec;
  #|           const normalRec = cmd.normalTextureRec;
  #|           if (!rec?.view || !emissiveRec?.view || !metallicRoughnessRec?.view || !occlusionRec?.view || !normalRec?.view) continue;
  #|           pass.setPipeline(rt.pipelines.skybox3dTexTri);
  #|           pass.setBindGroup(0, rt.resolveLitTex3dBindGroup(cmd, state.shadowState));
  #|           pass.setVertexBuffer(0, state.buffers.skyboxTex.buffer, state.buffers.skyboxTex.offsets[index], cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 35, 1, 0, 0);
  #|         }
  #|       }
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
  #|         pass.setBindGroup(0, rt.resolveLit3dBindGroup(state.shadowState));
  #|         for (let index = 0; index < section.litTriCommands.length; index += 1) {
  #|           const cmd = section.litTriCommands[index];
  #|           pass.setPipeline(cmd.doubleSided ? rt.pipelines.lit3dTriDouble : rt.pipelines.lit3dTriSingle);
  #|           pass.setVertexBuffer(0, state.buffers.lit.buffer, state.buffers.lit.offsets[index], cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 17, 1, 0, 0);
  #|         }
  #|       }
  #|       if (section.instancedLitCommands.length > 0) {
  #|         pass.setBindGroup(0, rt.resolveLit3dBindGroup(state.shadowState));
  #|         for (let index = 0; index < section.instancedLitCommands.length; index += 1) {
  #|           const cmd = section.instancedLitCommands[index];
  #|           if (!cmd.meshRecord?.buffer || !cmd.instanceBuffer || !cmd.instanceArray?.length) continue;
  #|           pass.setPipeline(cmd.doubleSided ? rt.pipelines.lit3dInstancedDouble : rt.pipelines.lit3dInstancedSingle);
  #|           pass.setVertexBuffer(0, cmd.meshRecord.buffer, 0, cmd.meshRecord.byteLength);
  #|           pass.setVertexBuffer(1, cmd.instanceBuffer, 0, cmd.instanceByteLength);
  #|           pass.draw(cmd.meshRecord.vertexCount, cmd.instanceArray.length / 11, 0, 0);
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
  #|           pass.setPipeline(cmd.doubleSided ? rt.pipelines.lit3dTexTriDouble : rt.pipelines.lit3dTexTriSingle);
  #|           pass.setBindGroup(0, rt.resolveLitTex3dBindGroup(cmd, state.shadowState));
  #|           pass.setVertexBuffer(0, state.buffers.tex.buffer, state.buffers.tex.offsets[index], cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 35, 1, 0, 0);
  #|         }
  #|       }
  #|     };
  #|
  #|     rt.intersectClipRect = (lhs, rhs) => {
  #|       const x = Math.max(lhs[0], rhs[0]);
  #|       const y = Math.max(lhs[1], rhs[1]);
  #|       const x1 = Math.min(lhs[0] + lhs[2], rhs[0] + rhs[2]);
  #|       const y1 = Math.min(lhs[1] + lhs[3], rhs[1] + rhs[3]);
  #|       return [x, y, Math.max(0, x1 - x), Math.max(0, y1 - y)];
  #|     };
  #|     rt.applyClipScissor = (pass, clipRect, viewport, canvasWidth, canvasHeight) => {
  #|       const finalRect = rt.intersectClipRect(viewport, clipRect);
  #|       const scissorX = Math.max(0, Math.floor(finalRect[0]));
  #|       const scissorY = Math.max(0, Math.floor(finalRect[1]));
  #|       const maxWidth = Math.max(0, canvasWidth - scissorX);
  #|       const maxHeight = Math.max(0, canvasHeight - scissorY);
  #|       const scissorW = Math.max(0, Math.min(Math.ceil(finalRect[2]), maxWidth));
  #|       const scissorH = Math.max(0, Math.min(Math.ceil(finalRect[3]), maxHeight));
  #|       if (scissorW <= 0 || scissorH <= 0) return false;
  #|       pass.setScissorRect(scissorX, scissorY, scissorW, scissorH);
  #|       return true;
  #|     };
  #|     rt.pipeline2d = (code) => {
  #|       switch (code | 0) {
  #|         case 1: return rt.pipelines.color2dTriOpaque;
  #|         case 2: return rt.pipelines.color2dTriAdditive;
  #|         case 3: return rt.pipelines.color2dTriMultiply;
  #|         case 4: return rt.pipelines.color2dLine;
  #|         case 5: return rt.pipelines.color2dLineOpaque;
  #|         case 6: return rt.pipelines.color2dLineAdditive;
  #|         case 7: return rt.pipelines.color2dLineMultiply;
  #|         case 8: return rt.pipelines.tex2dTri;
  #|         case 9: return rt.pipelines.tex2dTriOpaque;
  #|         case 10: return rt.pipelines.tex2dTriAdditive;
  #|         case 11: return rt.pipelines.tex2dTriMultiply;
  #|         default: return rt.pipelines.color2dTri;
  #|       }
  #|     };
  #|     rt.render2d = (pass, passRecord, surfaceWidth, surfaceHeight, bufferScope = 0) => {
  #|       const canvasWidth = Math.max(1, Math.floor(surfaceWidth || rt.canvas?.width || 1));
  #|       const canvasHeight = Math.max(1, Math.floor(surfaceHeight || rt.canvas?.height || 1));
  #|       const canvasUniform = new Float32Array([canvasWidth, canvasHeight, 0, 0]);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.canvas2d, 0, canvasUniform.buffer, canvasUniform.byteOffset, canvasUniform.byteLength);
  #|       const viewport = Array.isArray(passRecord?.viewport)
  #|         ? passRecord.viewport
  #|         : [0, 0, canvasWidth, canvasHeight];
  #|       const commands = Array.isArray(passRecord?.commands)
  #|         ? passRecord.commands.slice()
  #|         : [];
  #|       let colorBytes = 0;
  #|       let texBytes = 0;
  #|       for (const cmd of commands) {
  #|         if (cmd.kind === 'color') colorBytes += cmd.verts.byteLength;
  #|         else if (cmd.kind === 'tex') texBytes += cmd.verts.byteLength;
  #|       }
  #|       const colorBufferName = `dyn2dColor:${bufferScope}`;
  #|       const texBufferName = `dyn2dTex:${bufferScope}`;
  #|       const colorVb = colorBytes > 0
  #|         ? rt.ensureDynamicBuffer(colorBufferName, colorBytes, GPUBufferUsage.VERTEX)
  #|         : null;
  #|       const texVb = texBytes > 0
  #|         ? rt.ensureDynamicBuffer(texBufferName, texBytes, GPUBufferUsage.VERTEX)
  #|         : null;
  #|       let colorOffset = 0;
  #|       let texOffset = 0;
  #|       const clipStack = [viewport];
  #|       for (const cmd of commands) {
  #|         if (cmd.kind === 'pushClip') {
  #|           clipStack.push(rt.intersectClipRect(clipStack[clipStack.length - 1], cmd.rect));
  #|           continue;
  #|         }
  #|         if (cmd.kind === 'popClip') {
  #|           if (clipStack.length > 1) clipStack.pop();
  #|           continue;
  #|         }
  #|         if (cmd.kind === 'resetClip') {
  #|           clipStack.length = 0;
  #|           clipStack.push(viewport);
  #|           continue;
  #|         }
  #|         if (!rt.applyClipScissor(pass, clipStack[clipStack.length - 1], viewport, canvasWidth, canvasHeight)) {
  #|           continue;
  #|         }
  #|         if (cmd.kind === 'color') {
  #|           pass.setPipeline(rt.pipeline2d(cmd.pipelineCode));
  #|           pass.setBindGroup(0, rt.bindGroups.canvas2d);
  #|           rt.device.queue.writeBuffer(colorVb, colorOffset, cmd.verts.buffer, cmd.verts.byteOffset, cmd.verts.byteLength);
  #|           pass.setVertexBuffer(0, colorVb, colorOffset, cmd.verts.byteLength);
  #|           pass.draw(cmd.verts.length / 6, 1, 0, 0);
  #|           colorOffset += cmd.verts.byteLength;
  #|           continue;
  #|         }
  #|         const rec = cmd.textureRec;
  #|         if (!rec?.view) continue;
  #|         pass.setPipeline(rt.pipeline2d(cmd.pipelineCode));
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
  #|       const hasQueued2d = rt.passes2d.length > 0 || rt.draw2dCommands.length > 0;
  #|       if (hasQueued2d || !rendered) {
  #|         const fallbackPasses2d = [{
  #|           viewport: [0, 0, rt.canvas.width, rt.canvas.height],
  #|           loadOp: 0,
  #|           clearColor: rt.clearColor,
  #|           commands: rt.draw2dCommands,
  #|           targetName: '',
  #|           targetSize: [rt.canvas.width, rt.canvas.height],
  #|         }];
  #|         const passes2d = rt.passes2d.length > 0 ? rt.passes2d : fallbackPasses2d;
  #|         let screenRendered = rendered;
  #|         let passBufferScope = 0;
  #|         for (const passRecord of passes2d) {
  #|           const targetName = typeof passRecord?.targetName === 'string'
  #|             ? passRecord.targetName
  #|             : '';
  #|           if (targetName.length > 0) {
  #|             const offscreenTarget = rt.offscreenTargets2d.get(targetName);
  #|             if (!offscreenTarget?.view) {
  #|               continue;
  #|             }
  #|             const offscreenClear = Array.isArray(passRecord?.clearColor)
  #|               ? passRecord.clearColor
  #|               : [0, 0, 0, 1];
  #|             const offscreenPass = encoder.beginRenderPass({
  #|               colorAttachments: [{
  #|                 view: offscreenTarget.view,
  #|                 clearValue: {
  #|                   r: offscreenClear[0],
  #|                   g: offscreenClear[1],
  #|                   b: offscreenClear[2],
  #|                   a: offscreenClear[3],
  #|                 },
  #|                 loadOp: Number(passRecord?.loadOp) === 1 ? 'clear' : 'load',
  #|                 storeOp: 'store',
  #|               }],
  #|             });
  #|             rt.render2d(
  #|               offscreenPass,
  #|               passRecord,
  #|               offscreenTarget.width,
  #|               offscreenTarget.height,
  #|               passBufferScope++,
  #|             );
  #|             offscreenPass.end();
  #|             continue;
  #|           }
  #|           const screenLoadOp = Number(passRecord?.loadOp) || 0;
  #|           const clearColor = Array.isArray(passRecord?.clearColor)
  #|             ? passRecord.clearColor
  #|             : rt.clearColor;
  #|           const screenPass = encoder.beginRenderPass({
  #|             colorAttachments: [{
  #|               view,
  #|               clearValue: {
  #|                 r: clearColor[0],
  #|                 g: clearColor[1],
  #|                 b: clearColor[2],
  #|                 a: clearColor[3],
  #|               },
  #|               loadOp: screenRendered
  #|                 ? (screenLoadOp === 1 ? 'clear' : 'load')
  #|                 : 'clear',
  #|               storeOp: 'store',
  #|             }],
  #|           });
  #|           const targetSize = Array.isArray(passRecord?.targetSize)
  #|             ? passRecord.targetSize
  #|             : [rt.canvas.width, rt.canvas.height];
  #|           rt.render2d(
  #|             screenPass,
  #|             passRecord,
  #|             targetSize[0],
  #|             targetSize[1],
  #|             passBufferScope++,
  #|           );
  #|           screenPass.end();
  #|           screenRendered = true;
  #|         }
  #|         if (!screenRendered) {
  #|           const clearPass = encoder.beginRenderPass({
  #|             colorAttachments: [{
  #|               view,
  #|               clearValue: {
  #|                 r: rt.clearColor[0],
  #|                 g: rt.clearColor[1],
  #|                 b: rt.clearColor[2],
  #|                 a: rt.clearColor[3],
  #|               },
  #|               loadOp: 'clear',
  #|               storeOp: 'store',
  #|             }],
  #|           });
  #|           clearPass.end();
  #|         }
  #|       }
  #|       rt.device.queue.submit([encoder.finish()]);
  #|       for (const buffer of rt.retiredDynamicBuffers) {
  #|         try { buffer.destroy(); } catch (_err) {}
  #|       }
  #|       rt.retiredDynamicBuffers.length = 0;
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
  #|       rt.destroyPrimitiveMeshCache();
  #|       rt.destroyRetainedInstanceBuffers3d();
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
  #|         code: shaderSource(0),
  #|       });
  #|       const shader2dTex = rt.device.createShaderModule({
  #|         code: shaderSource(1),
  #|       });
  #|       const shader3dColor = rt.device.createShaderModule({
  #|         code: shaderSource(2),
  #|       });
  #|       const shader3dShadowSolid = rt.device.createShaderModule({
  #|         code: shaderSource(3),
  #|       });
  #|       const shader3dShadowLit = rt.device.createShaderModule({
  #|         code: shaderSource(4),
  #|       });
  #|       const shader3dShadowTex = rt.device.createShaderModule({
  #|         code: shaderSource(5),
  #|       });
  #|       const shader3dLitColor = rt.device.createShaderModule({
  #|         code: shaderSource(8),
  #|       });
  #|       const shader3dLitTex = rt.device.createShaderModule({
  #|         code: shaderSource(9),
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
  #|       const blendStateAdditive = {
  #|         color: { srcFactor: 'src-alpha', dstFactor: 'one', operation: 'add' },
  #|         alpha: { srcFactor: 'one', dstFactor: 'one', operation: 'add' },
  #|       };
  #|       const blendStateMultiply = {
  #|         color: { srcFactor: 'dst', dstFactor: 'zero', operation: 'add' },
  #|         alpha: { srcFactor: 'one', dstFactor: 'one-minus-src-alpha', operation: 'add' },
  #|       };
  #|       const opaqueTarget = { format: rt.format };
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
  #|       const lit3dInstanceVertex = {
  #|         arrayStride: 44,
  #|         stepMode: 'instance',
  #|         attributes: [
  #|           { shaderLocation: 5, offset: 0, format: 'float32x3' },
  #|           { shaderLocation: 6, offset: 12, format: 'float32x4' },
  #|           { shaderLocation: 7, offset: 28, format: 'float32x3' },
  #|           { shaderLocation: 8, offset: 40, format: 'float32' },
  #|         ],
  #|       };
  #|       const lit3dShadowInstanceVertex = {
  #|         arrayStride: 44,
  #|         stepMode: 'instance',
  #|         attributes: [
  #|           { shaderLocation: 5, offset: 0, format: 'float32x3' },
  #|           { shaderLocation: 6, offset: 12, format: 'float32x4' },
  #|           { shaderLocation: 7, offset: 28, format: 'float32x3' },
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
  #|         color2dTriOpaque: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [opaqueTarget] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|         }),
  #|         color2dTri: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|         }),
  #|         color2dTriAdditive: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendStateAdditive }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|         }),
  #|         color2dTriMultiply: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendStateMultiply }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|         }),
  #|         color2dLineOpaque: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [opaqueTarget] },
  #|           primitive: { topology: 'line-list', cullMode: 'none' },
  #|         }),
  #|         color2dLine: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'line-list', cullMode: 'none' },
  #|         }),
  #|         color2dLineAdditive: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendStateAdditive }] },
  #|           primitive: { topology: 'line-list', cullMode: 'none' },
  #|         }),
  #|         color2dLineMultiply: rt.device.createRenderPipeline({
  #|           layout: layout2dColor,
  #|           vertex: { module: shader2dColor, entryPoint: 'vs_main', buffers: [color2dVertex] },
  #|           fragment: { module: shader2dColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendStateMultiply }] },
  #|           primitive: { topology: 'line-list', cullMode: 'none' },
  #|         }),
  #|         tex2dTriOpaque: rt.device.createRenderPipeline({
  #|           layout: layout2dTex,
  #|           vertex: { module: shader2dTex, entryPoint: 'vs_main', buffers: [tex2dVertex] },
  #|           fragment: { module: shader2dTex, entryPoint: 'fs_main', targets: [opaqueTarget] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|         }),
  #|         tex2dTri: rt.device.createRenderPipeline({
  #|           layout: layout2dTex,
  #|           vertex: { module: shader2dTex, entryPoint: 'vs_main', buffers: [tex2dVertex] },
  #|           fragment: { module: shader2dTex, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|         }),
  #|         tex2dTriAdditive: rt.device.createRenderPipeline({
  #|           layout: layout2dTex,
  #|           vertex: { module: shader2dTex, entryPoint: 'vs_main', buffers: [tex2dVertex] },
  #|           fragment: { module: shader2dTex, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendStateAdditive }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|         }),
  #|         tex2dTriMultiply: rt.device.createRenderPipeline({
  #|           layout: layout2dTex,
  #|           vertex: { module: shader2dTex, entryPoint: 'vs_main', buffers: [tex2dVertex] },
  #|           fragment: { module: shader2dTex, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendStateMultiply }] },
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
  #|         shadow3dLitInstanced: rt.device.createRenderPipeline({
  #|           layout: layoutShadow3d,
  #|           vertex: { module: shader3dShadowLit, entryPoint: 'vs_instanced', buffers: [lit3dVertex, lit3dShadowInstanceVertex] },
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
  #|         lit3dInstancedSingle: rt.device.createRenderPipeline({
  #|           layout: layoutLit3d,
  #|           vertex: { module: shader3dLitColor, entryPoint: 'vs_instanced', buffers: [lit3dVertex, lit3dInstanceVertex] },
  #|           fragment: { module: shader3dLitColor, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'back' },
  #|           depthStencil: { format: 'depth24plus', depthWriteEnabled: true, depthCompare: 'less' },
  #|         }),
  #|         lit3dInstancedDouble: rt.device.createRenderPipeline({
  #|           layout: layoutLit3d,
  #|           vertex: { module: shader3dLitColor, entryPoint: 'vs_instanced', buffers: [lit3dVertex, lit3dInstanceVertex] },
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
  #|         skybox3dTexTri: rt.device.createRenderPipeline({
  #|           layout: layoutLit3dTex,
  #|           vertex: { module: shader3dLitTex, entryPoint: 'vs_main', buffers: [litTex3dVertex] },
  #|           fragment: { module: shader3dLitTex, entryPoint: 'fs_main', targets: [{ format: rt.format, blend: blendState }] },
  #|           primitive: { topology: 'triangle-list', cullMode: 'none' },
  #|           depthStencil: { format: 'depth24plus', depthWriteEnabled: false, depthCompare: 'always' },
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
