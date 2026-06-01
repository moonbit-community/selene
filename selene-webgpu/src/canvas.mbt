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
  #|     rt.renderDirectionalShadowMaps3d = (encoder, section, buffers, camera, aspect, light, shadowState) => {
  #|       const directionalLights = Array.isArray(light.directionalLights) ? light.directionalLights : [];
  #|       const tileSize = Math.max(1, Number(light.directionalShadowMapSize) || 2048);
  #|       if (directionalLights.length <= 0) return;
  #|       for (let lightIndex = 0; lightIndex < Math.min(4, directionalLights.length); lightIndex += 1) {
  #|         const directionalLight = directionalLights[lightIndex];
  #|         if (!directionalLight?.shadows) continue;
  #|         const cascades = rt.shadowViewProjection3d?.directionalCascades?.[lightIndex] || [];
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
  #|         const setup = rt.shadowViewProjection3d?.spotSetups?.[lightIndex];
  #|         if (!setup) continue;
  #|         const rect = setup.atlasRect;
  #|         const viewportX = rect.offset[0] * record.width;
  #|         const viewportY = rect.offset[1] * record.height;
  #|         const scissorX = Math.max(0, Math.floor(viewportX));
  #|         const scissorY = Math.max(0, Math.floor(viewportY));
  #|         pass.setViewport(viewportX, viewportY, tileSize, tileSize, 0.0, 1.0);
  #|         pass.setScissorRect(scissorX, scissorY, tileSize | 0, tileSize | 0);
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
  #|           const stateIndex = lightIndex * 6 + faceIndex;
  #|           const setup = rt.shadowViewProjection3d?.pointSetups?.[stateIndex];
  #|           if (!setup) continue;
  #|           const rect = setup.atlasRect;
  #|           const viewportX = rect.offset[0] * record.width;
  #|           const viewportY = rect.offset[1] * record.height;
  #|           const scissorX = Math.max(0, Math.floor(viewportX));
  #|           const scissorY = Math.max(0, Math.floor(viewportY));
  #|           pass.setViewport(viewportX, viewportY, faceSize, faceSize, 0.0, 1.0);
  #|           pass.setScissorRect(scissorX, scissorY, faceSize | 0, faceSize | 0);
  #|           rt.renderShadowCastersForSetup(
  #|             pass,
  #|             section,
  #|             buffers,
  #|             setup.lightViewProjection,
  #|             shadowState.shadowCameraBufferCursor,
  #|           );
  #|           shadowState.shadowCameraBufferCursor += 1;
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
  #|       const light = rt.light3d || {
  #|         directionalLights: [],
  #|         pointLights: [],
  #|         spotLights: [],
  #|         ambient: [1, 1, 1],
  #|         directionalShadowMapSize: 2048,
  #|         pointShadowMapSize: 1024,
  #|       };
  #|       const lightUniform = rt.lightUniform3d?.length === 176
  #|         ? rt.lightUniform3d
  #|         : new Float32Array(44 * 4);
  #|       const buffers = rt.prepareSectionBuffers3d(section);
  #|       const shadowState = rt.createShadowState3d();
  #|       rt.renderDirectionalShadowMaps3d(encoder, section, buffers, camera, aspect, light, shadowState);
  #|       rt.renderSpotShadowMaps3d(encoder, section, buffers, light, shadowState);
  #|       rt.renderPointShadowMaps3d(encoder, section, buffers, light, shadowState);
  #|       const shadowUniform = rt.buildShadowUniform3d(shadowState);
  #|       rt.device.queue.writeBuffer(rt.uniformBuffers.camera3d, 0, section.viewProjection.buffer, section.viewProjection.byteOffset, section.viewProjection.byteLength);
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
  #|       const lightShadowStructsWgsl = shaderSource(6);
  #|       const shadowSamplingWgsl = shaderSource(7);
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
  #| struct VSInInstanced {
  #|   @location(0) pos: vec3<f32>,
  #|   @location(1) normal: vec3<f32>,
  #|   @location(2) color: vec4<f32>,
  #|   @location(3) emissive: vec3<f32>,
  #|   @location(4) material: vec4<f32>,
  #|   @location(5) instance_translation: vec3<f32>,
  #|   @location(6) instance_rotation: vec4<f32>,
  #|   @location(7) instance_scale: vec3<f32>,
  #|   @location(8) instance_receive_shadows: f32,
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
  #| fn rotate_quat(value: vec3<f32>, quat: vec4<f32>) -> vec3<f32> {
  #|   let len = length(quat);
  #|   var q = quat;
  #|   if (len <= 0.00001) {
  #|     q = vec4<f32>(0.0, 0.0, 0.0, 1.0);
  #|   } else {
  #|     q = quat / len;
  #|   }
  #|   let u = q.xyz;
  #|   let s = q.w;
  #|   return 2.0 * dot(u, value) * u + (s * s - dot(u, u)) * value + 2.0 * s * cross(u, value);
  #| }
  #| fn safe_scale_component(value: f32) -> f32 {
  #|   return select(value, 1.0, abs(value) <= 0.00001);
  #| }
  #| @vertex fn vs_instanced(v: VSInInstanced) -> VSOut {
  #|   var o: VSOut;
  #|   let scaled_pos = v.pos * v.instance_scale;
  #|   let world_pos = rotate_quat(scaled_pos, v.instance_rotation) + v.instance_translation;
  #|   let inverse_scale = vec3<f32>(
  #|     safe_scale_component(v.instance_scale.x),
  #|     safe_scale_component(v.instance_scale.y),
  #|     safe_scale_component(v.instance_scale.z),
  #|   );
  #|   let scaled_normal = v.normal / inverse_scale;
  #|   let world_normal = normalize(rotate_quat(scaled_normal, v.instance_rotation));
  #|   var material = v.material;
  #|   material.w = v.instance_receive_shadows;
  #|   o.pos = u_camera.view_proj * vec4<f32>(world_pos, 1.0);
  #|   o.world_pos = world_pos;
  #|   o.normal = world_normal;
  #|   o.color = v.color;
  #|   o.emissive = v.emissive;
  #|   o.material = material;
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
