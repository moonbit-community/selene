///|
#cfg(target="js")
extern "js" fn keyboard_event_is_enter_key(event : @dom.KeyboardEvent) -> Bool =
  #| (event) => (event?.key || "").toLowerCase() === "enter"

///|
#cfg(target="js")
extern "js" fn keyboard_event_is_escape_key(event : @dom.KeyboardEvent) -> Bool =
  #| (event) => (event?.key || "").toLowerCase() === "escape"

///|
#cfg(target="js")
extern "js" fn keyboard_event_blur_target(event : @dom.KeyboardEvent) =
  #| (event) => event?.target?.blur?.()

///|
#cfg(target="js")
extern "js" fn mouse_event_alt_key(event : @dom.MouseEvent) -> Bool =
  #| (event) => !!event?.altKey

///|
#cfg(target="js")
extern "js" fn scroll_selected_asset_row_into_view() =
  #| () => {
  #|   requestAnimationFrame(() => {
  #|     const row = document.querySelector(".asset-tree-row.file.selected");
  #|     if (!row || typeof row.scrollIntoView !== "function") return;
  #|     row.scrollIntoView({ block: "nearest", inline: "nearest" });
  #|   });
  #| }

///|
#cfg(target="js")
extern "js" fn focus_component_search_input() =
  #| () => {
  #|   requestAnimationFrame(() => {
  #|     const input = document.querySelector(".component-search-input");
  #|     if (!input || typeof input.focus !== "function") return;
  #|     input.focus();
  #|     if (typeof input.select === "function") {
  #|       input.select();
  #|     }
  #|   });
  #| }

///|
#cfg(target="js")
extern "js" fn project_asset_src(path : String) -> String =
  #| (path) => {
  #|   const normalized = (path || "").replace(/^\/+/, "");
  #|   if (!normalized) return "";
  #|   const segments = normalized.split("/").map((segment) => {
  #|     try {
  #|       return encodeURIComponent(decodeURIComponent(segment));
  #|     } catch (_error) {
  #|       return encodeURIComponent(segment);
  #|     }
  #|   });
  #|   return "/project/" + segments.join("/");
  #| }

///|
#cfg(target="js")
extern "js" fn probe_image_asset(
  src : String,
  on_load : (Double, Double) -> Unit,
  on_error : () -> Unit,
) =
  #| (src, onLoad, onError) => {
  #|   if (!src) {
  #|     onError();
  #|     return;
  #|   }
  #|   const image = new Image();
  #|   image.decoding = "async";
  #|   image.onload = () => {
  #|     const width = Number(image.naturalWidth || 0);
  #|     const height = Number(image.naturalHeight || 0);
  #|     if (width > 0 && height > 0) {
  #|       onLoad(width, height);
  #|     } else {
  #|       onError();
  #|     }
  #|   };
  #|   image.onerror = () => onError();
  #|   image.src = src;
  #| }

///|
#cfg(target="js")
extern "js" fn sync_asset_tree_sticky_overlay() =
  #| () => {
  #|   const scroll = document.querySelector(".asset-tree-scroll");
  #|   if (!scroll) return;
  #|   const overlay = scroll.querySelector(".asset-tree-sticky-overlay");
  #|   if (!overlay) return;
  #|   const render = () => {
  #|     const rows = Array.from(
  #|       scroll.querySelectorAll(".asset-grid .asset-tree-row[data-sticky-kind]")
  #|     );
  #|     if (!rows.length) {
  #|       overlay.replaceChildren();
  #|       overlay.classList.add("empty");
  #|       return;
  #|     }
  #|     const scrollRect = scroll.getBoundingClientRect();
  #|     const firstVisible = rows.find((row) => {
  #|       const rect = row.getBoundingClientRect();
  #|       return rect.bottom > scrollRect.top + 1;
  #|     });
  #|     if (!firstVisible) {
  #|       overlay.replaceChildren();
  #|       overlay.classList.add("empty");
  #|       return;
  #|     }
  #|     const section = firstVisible.dataset.stickySection || "";
  #|     const chainRaw = firstVisible.dataset.stickyChain || "";
  #|     const segments = chainRaw ? chainRaw.split("/") : [];
  #|     const crumbs = [];
  #|     if (section) crumbs.push(section);
  #|     if (segments.length) {
  #|       const hiddenSegments = [];
  #|       const prefix = [];
  #|       for (const segment of segments) {
  #|         prefix.push(segment);
  #|         const chain = prefix.join("/");
  #|         const folderRow = rows.find((row) => {
  #|           return (
  #|             row.dataset.stickyKind === "folder" &&
  #|             (row.dataset.stickySection || "") === section &&
  #|             (row.dataset.stickyChain || "") === chain
  #|           );
  #|         });
  #|         if (!folderRow) continue;
  #|         const folderRect = folderRow.getBoundingClientRect();
  #|         if (folderRect.top < scrollRect.top + 1) {
  #|           hiddenSegments.push(segment);
  #|         }
  #|       }
  #|       if (hiddenSegments.length) {
  #|         crumbs.push(hiddenSegments.join(" / "));
  #|       }
  #|     }
  #|     if (!crumbs.length) {
  #|       overlay.replaceChildren();
  #|       overlay.classList.add("empty");
  #|       return;
  #|     }
  #|     const bar = document.createElement("div");
  #|     bar.className = "asset-tree-sticky-bar";
  #|     bar.textContent = crumbs.join(" > ");
  #|     overlay.replaceChildren(bar);
  #|     overlay.classList.remove("empty");
  #|   };
  #|
  #|   if (!scroll.__seleneTreeStickyBound) {
  #|     scroll.__seleneTreeStickyBound = true;
  #|     scroll.__seleneTreeStickyRender = render;
  #|     scroll.addEventListener("scroll", render, { passive: true });
  #|     window.addEventListener("resize", render, { passive: true });
  #|   } else {
  #|     scroll.__seleneTreeStickyRender = render;
  #|   }
  #|   requestAnimationFrame(render);
  #| }

///|
#cfg(target="js")
extern "js" fn sync_resource_previews() =
  #| () => {
  #|   const checkerFill = (ctx, width, height) => {
  #|     ctx.fillStyle = "#10161d";
  #|     ctx.fillRect(0, 0, width, height);
  #|     const size = 16;
  #|     for (let y = 0; y < height; y += size) {
  #|       for (let x = 0; x < width; x += size) {
  #|         if (((x + y) / size) % 2 === 0) {
  #|           ctx.fillStyle = "rgba(255,255,255,0.03)";
  #|           ctx.fillRect(x, y, size, size);
  #|         }
  #|       }
  #|     }
  #|   };
  #|
  #|   const ensureCanvasSize = (canvas) => {
  #|     const rect = canvas.getBoundingClientRect();
  #|     const dpr = window.devicePixelRatio || 1;
  #|     const width = Math.max(1, Math.round(rect.width * dpr));
  #|     const height = Math.max(1, Math.round(rect.height * dpr));
  #|     if (canvas.width !== width || canvas.height !== height) {
  #|       canvas.width = width;
  #|       canvas.height = height;
  #|     }
  #|     return { width, height, dpr };
  #|   };
  #|
  #|   const drawMessage = (ctx, width, height, message) => {
  #|     checkerFill(ctx, width, height);
  #|     ctx.fillStyle = "rgba(230, 237, 243, 0.78)";
  #|     ctx.font = "12px SF Mono, Iosevka, Menlo, monospace";
  #|     ctx.textAlign = "center";
  #|     ctx.textBaseline = "middle";
  #|     ctx.fillText(message, width / 2, height / 2);
  #|   };
  #|
  #|   const parseRectSpecs = (value) => {
  #|     const specs = [];
  #|     if (!value) return specs;
  #|     for (const item of value.split(";")) {
  #|       if (!item) continue;
  #|       const parts = item.split(",");
  #|       if (parts.length < 4) continue;
  #|       const x = Number(parts[0]);
  #|       const y = Number(parts[1]);
  #|       const width = Number(parts[2]);
  #|       const height = Number(parts[3]);
  #|       if (
  #|         Number.isFinite(x) &&
  #|         Number.isFinite(y) &&
  #|         Number.isFinite(width) &&
  #|         Number.isFinite(height) &&
  #|         width > 0 &&
  #|         height > 0
  #|       ) {
  #|         specs.push({ x, y, width, height });
  #|       }
  #|     }
  #|     return specs;
  #|   };
  #|
  #|   const imageCache = (window.__selenePreviewImageCache ||= new Map());
  #|   const ensureImage = (src) => {
  #|     if (!src) return null;
  #|     let entry = imageCache.get(src);
  #|     if (entry) return entry;
  #|     const image = new Image();
  #|     entry = { image, ready: false, failed: false };
  #|     image.decoding = "async";
  #|     image.onload = () => {
  #|       entry.ready = true;
  #|       entry.failed = false;
  #|     };
  #|     image.onerror = () => {
  #|       entry.ready = false;
  #|       entry.failed = true;
  #|     };
  #|     image.src = src;
  #|     imageCache.set(src, entry);
  #|     return entry;
  #|   };
  #|
  #|   const drawAtlasPreview = (canvas) => {
  #|     const ctx = canvas.getContext("2d");
  #|     if (!ctx) return;
  #|     const { width, height } = ensureCanvasSize(canvas);
  #|     const rects = parseRectSpecs(canvas.dataset.previewRects || "");
  #|     const src = canvas.dataset.previewSrc || "";
  #|     const imageEntry = ensureImage(src);
  #|     if (!src || !imageEntry) {
  #|       drawMessage(ctx, width, height, "No source image");
  #|       return;
  #|     }
  #|     if (imageEntry.failed) {
  #|       drawMessage(ctx, width, height, "Source image unavailable");
  #|       return;
  #|     }
  #|     if (!imageEntry.ready) {
  #|       drawMessage(ctx, width, height, "Loading atlas preview...");
  #|       return;
  #|     }
  #|     checkerFill(ctx, width, height);
  #|     const image = imageEntry.image;
  #|     const scale = Math.min(
  #|       (width - 24) / Math.max(1, image.naturalWidth),
  #|       (height - 24) / Math.max(1, image.naturalHeight)
  #|     );
  #|     const drawWidth = image.naturalWidth * scale;
  #|     const drawHeight = image.naturalHeight * scale;
  #|     const offsetX = (width - drawWidth) / 2;
  #|     const offsetY = (height - drawHeight) / 2;
  #|     ctx.drawImage(image, offsetX, offsetY, drawWidth, drawHeight);
  #|     ctx.save();
  #|     ctx.translate(offsetX, offsetY);
  #|     ctx.scale(scale, scale);
  #|     ctx.lineWidth = Math.max(1 / scale, 1);
  #|     for (let index = 0; index < rects.length; index += 1) {
  #|       const rect = rects[index];
  #|       ctx.strokeStyle =
  #|         index === 0 ? "rgba(246, 193, 119, 0.95)" : "rgba(88, 166, 255, 0.72)";
  #|       ctx.strokeRect(rect.x + 0.5, rect.y + 0.5, rect.width, rect.height);
  #|     }
  #|     ctx.restore();
  #|   };
  #|
  #|   const drawAnimationPreview = (canvas, now) => {
  #|     const ctx = canvas.getContext("2d");
  #|     if (!ctx) return;
  #|     const { width, height } = ensureCanvasSize(canvas);
  #|     const rects = parseRectSpecs(canvas.dataset.previewRects || "");
  #|     const src = canvas.dataset.previewSrc || "";
  #|     const imageEntry = ensureImage(src);
  #|     if (!src || !imageEntry) {
  #|       drawMessage(ctx, width, height, "No preview clip");
  #|       return;
  #|     }
  #|     if (imageEntry.failed) {
  #|       drawMessage(ctx, width, height, "Preview image unavailable");
  #|       return;
  #|     }
  #|     if (!imageEntry.ready) {
  #|       drawMessage(ctx, width, height, "Loading animation preview...");
  #|       return;
  #|     }
  #|     if (!rects.length) {
  #|       drawMessage(ctx, width, height, "No frames available");
  #|       return;
  #|     }
  #|
  #|     const paused = canvas.dataset.previewPaused === "true";
  #|     const speed = Math.max(0.01, Number(canvas.dataset.previewSpeed || "1") || 1);
  #|     const fps = Math.max(0.01, Number(canvas.dataset.previewFps || "1") || 1);
  #|     const looping = canvas.dataset.previewLooping !== "false";
  #|     const appliedSeek = Math.max(
  #|       0,
  #|       Number(canvas.dataset.previewSeekSeconds || "0") || 0
  #|     );
  #|     const seekSerial = Number(canvas.dataset.previewSeekSerial || "0") || 0;
  #|     const signature = [
  #|       src,
  #|       canvas.dataset.previewRects || "",
  #|       fps,
  #|       looping ? 1 : 0,
  #|       paused ? 1 : 0,
  #|       speed,
  #|       seekSerial,
  #|     ].join("|");
  #|     const state = (canvas.__selenePreviewState ||= {
  #|       signature: "",
  #|       currentTime: 0,
  #|       lastNow: now,
  #|       paused: true,
  #|       speed: 1,
  #|       seekSerial: 0,
  #|     });
  #|
  #|     if (state.signature !== signature) {
  #|       state.signature = signature;
  #|       state.currentTime = appliedSeek;
  #|       state.lastNow = now;
  #|       state.paused = paused;
  #|       state.speed = speed;
  #|       state.seekSerial = seekSerial;
  #|     } else {
  #|       const deltaSeconds = Math.max(0, now - state.lastNow) / 1000;
  #|       if (!state.paused) {
  #|         state.currentTime += deltaSeconds * state.speed;
  #|       }
  #|       state.lastNow = now;
  #|       state.paused = paused;
  #|       state.speed = speed;
  #|     }
  #|
  #|     const frameDuration = 1 / fps;
  #|     const totalDuration = frameDuration * rects.length;
  #|     let playhead = state.currentTime;
  #|     if (looping) {
  #|       playhead = totalDuration <= 0 ? 0 : playhead % totalDuration;
  #|     } else if (playhead >= totalDuration) {
  #|       playhead = Math.max(0, totalDuration - 0.0001);
  #|       state.currentTime = playhead;
  #|     }
  #|     const frameIndex = Math.max(
  #|       0,
  #|       Math.min(rects.length - 1, Math.floor(playhead / frameDuration))
  #|     );
  #|     const frame = rects[frameIndex];
  #|     checkerFill(ctx, width, height);
  #|     const scale = Math.min(
  #|       (width - 32) / frame.width,
  #|       (height - 32) / frame.height
  #|     );
  #|     const drawWidth = frame.width * scale;
  #|     const drawHeight = frame.height * scale;
  #|     const offsetX = (width - drawWidth) / 2;
  #|     const offsetY = (height - drawHeight) / 2;
  #|     ctx.drawImage(
  #|       imageEntry.image,
  #|       frame.x,
  #|       frame.y,
  #|       frame.width,
  #|       frame.height,
  #|       offsetX,
  #|       offsetY,
  #|       drawWidth,
  #|       drawHeight
  #|     );
  #|     ctx.strokeStyle = "rgba(88, 166, 255, 0.7)";
  #|     ctx.lineWidth = 1;
  #|     ctx.strokeRect(offsetX + 0.5, offsetY + 0.5, drawWidth - 1, drawHeight - 1);
  #|   };
  #|
  #|   const drawAll = (now = performance.now()) => {
  #|     document
  #|       .querySelectorAll(".atlas-preview-canvas")
  #|       .forEach((canvas) => drawAtlasPreview(canvas));
  #|     document
  #|       .querySelectorAll(".animation-preview-canvas")
  #|       .forEach((canvas) => drawAnimationPreview(canvas, now));
  #|   };
  #|
  #|   const renderLoop = (now = performance.now()) => {
  #|     drawAll(now);
  #|     requestAnimationFrame(renderLoop);
  #|   };
  #|
  #|   if (!window.__selenePreviewLoopStarted) {
  #|     window.__selenePreviewLoopStarted = true;
  #|     window.__selenePreviewRenderNow = drawAll;
  #|     requestAnimationFrame(renderLoop);
  #|   }
  #|   (window.__selenePreviewRenderNow || drawAll)(performance.now());
  #| }

///|
fn drag_drop_translation(event : @dom.DragEvent) -> @editor_bridge.Vec2Doc? {
  let metrics = drag_event_canvas_metrics(event)
  if metrics.length() < 4 {
    return None
  }
  @preview.viewport_to_world(metrics[0], metrics[1], metrics[2], metrics[3])
}

///|
fn subscribe_events_cmd(dispatch : @rabbita.Dispatch[@app.Msg]) -> @rabbita.Cmd {
  @cmd.custom_cmd(fn(scheduler : @cmd.Scheduler) {
    subscribe_events_forever(
      "/events",
      fn(data) {
        let result = try {
          let event : @shared.EventEnvelope = @json.from_json(@json.parse(data))
          Ok(event.event)
        } catch {
          err => {
            console_error("SSE decode failed: " + err.to_string())
            Err("Invalid event payload")
          }
        }
        schedule_cmd(scheduler, dispatch(@app.msg_service_event(result)))
      },
      fn(message) {
        console_error("SSE stream failed: " + message)
        schedule_cmd(scheduler, dispatch(@app.msg_service_event(Err(message))))
      },
    )
  })
}
