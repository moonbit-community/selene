///|
#cfg(target="js")
extern "js" fn subscribe_shortcuts_forever(
  on_undo : () -> Unit,
  on_redo : () -> Unit,
  on_save : () -> Unit,
  on_delete : () -> Unit,
  on_frame : () -> Unit,
  on_select : () -> Unit,
  on_drag_canvas : () -> Unit,
  on_move : () -> Unit,
  on_rotate : () -> Unit,
  on_scale : () -> Unit,
  on_expand_assets : () -> Unit,
  on_collapse_assets : () -> Unit,
  on_insert_selected_asset : () -> Unit,
  on_select_previous_asset : () -> Unit,
  on_select_next_asset : () -> Unit,
  on_select_first_asset : () -> Unit,
  on_select_last_asset : () -> Unit,
  on_select_previous_asset_page : () -> Unit,
  on_select_next_asset_page : () -> Unit,
  on_move_snap_step_down : () -> Unit,
  on_move_snap_step_up : () -> Unit,
  on_open_add_component : () -> Unit,
  on_clear_selection : () -> Unit,
) =
  #| (
  #|   onUndo,
  #|   onRedo,
  #|   onSave,
  #|   onDelete,
  #|   onFrame,
  #|   onSelect,
  #|   onDragCanvas,
  #|   onMove,
  #|   onRotate,
  #|   onScale,
  #|   onExpandAssets,
  #|   onCollapseAssets,
  #|   onInsertSelectedAsset,
  #|   onSelectPreviousAsset,
  #|   onSelectNextAsset,
  #|   onSelectFirstAsset,
  #|   onSelectLastAsset,
  #|   onSelectPreviousAssetPage,
  #|   onSelectNextAssetPage,
  #|   onMoveSnapStepDown,
  #|   onMoveSnapStepUp,
  #|   onOpenAddComponent,
  #|   onClearSelection
  #| ) => {
  #|   const isEditable = (target) => {
  #|     if (!target) return false;
  #|     const tag = (target.tagName || "").toLowerCase();
  #|     return (
  #|       tag === "input" ||
  #|       tag === "textarea" ||
  #|       tag === "select" ||
  #|       target.isContentEditable === true
  #|     );
  #|   };
  #|   window.addEventListener("keydown", (event) => {
  #|     const key = (event.key || "").toLowerCase();
  #|     if (isEditable(event.target)) return;
  #|     if (event.metaKey || event.ctrlKey) {
  #|       if (key === "z") {
  #|         event.preventDefault();
  #|         if (event.shiftKey) onRedo();
  #|         else onUndo();
  #|         return;
  #|       }
  #|       if (key === "y") {
  #|         event.preventDefault();
  #|         onRedo();
  #|         return;
  #|       }
  #|       if (key === "s") {
  #|         event.preventDefault();
  #|         onSave();
  #|         return;
  #|       }
  #|       return;
  #|     }
  #|     if (key === "backspace" || key === "delete") {
  #|       event.preventDefault();
  #|       onDelete();
  #|       return;
  #|     }
  #|     if (key === "f") {
  #|       event.preventDefault();
  #|       onFrame();
  #|       return;
  #|     }
  #|     if (key === "v") {
  #|       event.preventDefault();
  #|       onSelect();
  #|       return;
  #|     }
  #|     if (key === "h") {
  #|       event.preventDefault();
  #|       onDragCanvas();
  #|       return;
  #|     }
  #|     if (key === "w") {
  #|       event.preventDefault();
  #|       onMove();
  #|       return;
  #|     }
  #|     if (key === "e") {
  #|       event.preventDefault();
  #|       onRotate();
  #|       return;
  #|     }
  #|     if (key === "r") {
  #|       event.preventDefault();
  #|       onScale();
  #|       return;
  #|     }
  #|     if (key === "]") {
  #|       event.preventDefault();
  #|       onExpandAssets();
  #|       return;
  #|     }
  #|     if (key === "[") {
  #|       event.preventDefault();
  #|       onCollapseAssets();
  #|       return;
  #|     }
  #|     if (key === "i") {
  #|       event.preventDefault();
  #|       onInsertSelectedAsset();
  #|       return;
  #|     }
  #|     if (key === "enter") {
  #|       event.preventDefault();
  #|       onInsertSelectedAsset();
  #|       return;
  #|     }
  #|     if (key === "arrowup") {
  #|       event.preventDefault();
  #|       onSelectPreviousAsset();
  #|       return;
  #|     }
  #|     if (key === "arrowdown") {
  #|       event.preventDefault();
  #|       onSelectNextAsset();
  #|       return;
  #|     }
  #|     if (key === "home") {
  #|       event.preventDefault();
  #|       onSelectFirstAsset();
  #|       return;
  #|     }
  #|     if (key === "end") {
  #|       event.preventDefault();
  #|       onSelectLastAsset();
  #|       return;
  #|     }
  #|     if (key === "pageup") {
  #|       event.preventDefault();
  #|       onSelectPreviousAssetPage();
  #|       return;
  #|     }
  #|     if (key === "pagedown") {
  #|       event.preventDefault();
  #|       onSelectNextAssetPage();
  #|       return;
  #|     }
  #|     if (key === "-" || key === "_") {
  #|       event.preventDefault();
  #|       onMoveSnapStepDown();
  #|       return;
  #|     }
  #|     if (key === "=" || key === "+") {
  #|       event.preventDefault();
  #|       onMoveSnapStepUp();
  #|       return;
  #|     }
  #|     if (key === "c") {
  #|       event.preventDefault();
  #|       onOpenAddComponent();
  #|       return;
  #|     }
  #|     if (key === "escape") {
  #|       event.preventDefault();
  #|       onClearSelection();
  #|       return;
  #|     }
  #|   });
  #| }

///|
#cfg(target="js")
extern "js" fn subscribe_sidebar_layout_forever(
  on_layout : (Double, Double) -> Unit,
) =
  #| (onLayout) => {
  #|   if (window.__seleneSidebarLayoutBound) return;
  #|   window.__seleneSidebarLayoutBound = true;
  #|
  #|   const clamp = (value, min, max) => Math.max(min, Math.min(max, value));
  #|   const readRatio = (sidebar, key, fallback) => {
  #|     const value = Number(sidebar?.dataset?.[key] ?? fallback);
  #|     return Number.isFinite(value) ? value : fallback;
  #|   };
  #|   const readMinimums = (sidebarHeight) => {
  #|     const available = Math.max(sidebarHeight - 16, 1);
  #|     const minimums = {
  #|       scene: 120 / available,
  #|       assets: 180 / available,
  #|       tree: 140 / available,
  #|     };
  #|     const total = minimums.scene + minimums.assets + minimums.tree;
  #|     if (total >= 0.98) {
  #|       const scale = 0.98 / total;
  #|       minimums.scene *= scale;
  #|       minimums.assets *= scale;
  #|       minimums.tree *= scale;
  #|     }
  #|     return minimums;
  #|   };
  #|
  #|   document.addEventListener(
  #|     "pointerdown",
  #|     (event) => {
  #|       const handle = event.target?.closest?.(".sidebar-splitter");
  #|       if (!handle) return;
  #|       const sidebar = handle.closest(".sidebar-column");
  #|       if (!sidebar) return;
  #|       const rect = sidebar.getBoundingClientRect();
  #|       const availableHeight = Math.max(rect.height - 16, 1);
  #|       const minimums = readMinimums(rect.height);
  #|       const kind = handle.dataset.sidebarSplitter || "";
  #|       const startY = Number(event.clientY || 0);
  #|       const startSceneRatio = readRatio(sidebar, "sceneRatio", 0.18);
  #|       const startAssetsRatio = readRatio(sidebar, "assetsRatio", 0.47);
  #|
  #|       document.body?.classList.add("sidebar-layout-dragging");
  #|       event.preventDefault();
  #|
  #|       const cleanup = () => {
  #|         document.body?.classList.remove("sidebar-layout-dragging");
  #|         window.removeEventListener("pointermove", onMove);
  #|         window.removeEventListener("pointerup", onUp);
  #|         window.removeEventListener("pointercancel", onUp);
  #|       };
  #|
  #|       const onMove = (moveEvent) => {
  #|         const delta = (Number(moveEvent.clientY || 0) - startY) / availableHeight;
  #|         if (kind === "scene-assets") {
  #|           const nextDelta = clamp(
  #|             delta,
  #|             minimums.scene - startSceneRatio,
  #|             startAssetsRatio - minimums.assets
  #|           );
  #|           onLayout(startSceneRatio + nextDelta, startAssetsRatio - nextDelta);
  #|           return;
  #|         }
  #|         if (kind === "assets-tree") {
  #|           const nextAssets = clamp(
  #|             startAssetsRatio + delta,
  #|             minimums.assets,
  #|             1 - startSceneRatio - minimums.tree
  #|           );
  #|           onLayout(startSceneRatio, nextAssets);
  #|         }
  #|       };
  #|
  #|       const onUp = () => cleanup();
  #|       window.addEventListener("pointermove", onMove, { passive: false });
  #|       window.addEventListener("pointerup", onUp, { passive: true });
  #|       window.addEventListener("pointercancel", onUp, { passive: true });
  #|     },
  #|     { passive: false }
  #|   );
  #| }

///|
let dragged_asset_path : Ref[String] = Ref::new("")

///|
fn begin_dragged_asset(path : String) -> Unit {
  dragged_asset_path.val = path
}

///|
fn clear_dragged_asset() -> Unit {
  dragged_asset_path.val = ""
}

///|
fn current_dragged_asset() -> String? {
  if dragged_asset_path.val == "" {
    None
  } else {
    Some(dragged_asset_path.val)
  }
}

///|
#cfg(target="js")
extern "js" fn drag_event_canvas_metrics(
  event : @dom.DragEvent,
) -> Array[Double] =
  #| (event) => {
  #|   const rect = event.currentTarget.getBoundingClientRect();
  #|   return [
  #|     event.clientX - rect.left,
  #|     event.clientY - rect.top,
  #|     rect.width,
  #|     rect.height,
  #|   ];
  #| }

///|
#cfg(target="js")
extern "js" fn drag_event_set_asset_payload(
  event : @dom.DragEvent,
  path : String,
) =
  #| (event, path) => {
  #|   const transfer = event.dataTransfer;
  #|   if (!transfer) return;
  #|   transfer.setData("text/plain", path);
  #|   transfer.effectAllowed = "copy";
  #| }

///|
#cfg(target="js")
extern "js" fn drag_event_get_asset_payload(event : @dom.DragEvent) -> String =
  #| (event) => {
  #|   const transfer = event.dataTransfer;
  #|   if (!transfer) return "";
  #|   return transfer.getData("text/plain") || "";
  #| }

///|
#cfg(target="js")
extern "js" fn drag_event_set_drop_copy(event : @dom.DragEvent) =
  #| (event) => {
  #|   const transfer = event.dataTransfer;
  #|   if (!transfer) return;
  #|   transfer.dropEffect = "copy";
  #| }

///|
#cfg(target="js")
extern "js" fn drag_event_set_graph_node_payload(
  event : @dom.DragEvent,
  node_id : String,
) =
  #| (event, nodeId) => {
  #|   const transfer = event.dataTransfer;
  #|   if (!transfer) return;
  #|   transfer.setData("application/x-selene-graph-node", nodeId);
  #|   transfer.setData("text/plain", `graph-node:${nodeId}`);
  #|   transfer.effectAllowed = "move";
  #| }

///|
#cfg(target="js")
extern "js" fn drag_event_get_graph_node_payload(
  event : @dom.DragEvent,
) -> String =
  #| (event) => {
  #|   const transfer = event.dataTransfer;
  #|   if (!transfer) return "";
  #|   const custom = transfer.getData("application/x-selene-graph-node");
  #|   if (custom) return custom;
  #|   const text = transfer.getData("text/plain") || "";
  #|   return text.startsWith("graph-node:") ? text.slice("graph-node:".length) : "";
  #| }

///|
#cfg(target="js")
extern "js" fn drag_event_set_drop_move(event : @dom.DragEvent) =
  #| (event) => {
  #|   const transfer = event.dataTransfer;
  #|   if (!transfer) return;
  #|   transfer.dropEffect = "move";
  #| }
