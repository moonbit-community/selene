const $64$Milky2018$47$selene$47$system$46$Schedule$Startup = { $tag: 0 };
const $64$Milky2018$47$selene$47$system$46$Schedule$Update = { $tag: 1 };
function $64$Milky2018$47$selene$47$system$46$Schedule$Render(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$system$46$Schedule$Render.prototype.$tag = 2;
const Option$None$0$ = { $tag: 0 };
function Option$Some$0$(param0) {
  this._0 = param0;
}
Option$Some$0$.prototype.$tag = 1;
function $64$Milky2018$47$selene$47$style$46$SizePlan$Sized(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$style$46$SizePlan$Sized.prototype.$tag = 0;
const $64$Milky2018$47$selene$47$style$46$SizePlan$FromSprite = { $tag: 1 };
const Option$None$1$ = { $tag: 0 };
function Option$Some$1$(param0) {
  this._0 = param0;
}
Option$Some$1$.prototype.$tag = 1;
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
const $64$moonbitlang$47$core$47$list$46$List$Empty$2$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$list$46$List$More$2$(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$list$46$List$More$2$.prototype.$tag = 1;
function $bound_check(arr, index) {
  if (index < 0 || index >= arr.length) throw new Error("Index out of bounds");
}
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
const $bytes_literal$0 = new Uint8Array([65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,49,50,51,52,53,54]);
const $4294967295L = { hi: 0, lo: -1 };
const $0L = { hi: 0, lo: 0 };
const $1L = { hi: 0, lo: 1 };
const moonbitlang$core$builtin$$random_seed = () => {
  if (globalThis.crypto?.getRandomValues) {
    const array = new Uint32Array(1);
    globalThis.crypto.getRandomValues(array);
    return array[0] | 0; // Convert to signed 32
  } else {
    return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
  }
};
function Result$Err$3$(param0) {
  this._0 = param0;
}
Result$Err$3$.prototype.$tag = 0;
function Result$Ok$3$(param0) {
  this._0 = param0;
}
Result$Ok$3$.prototype.$tag = 1;
const Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$IndexOutOfBounds = { $tag: 1 };
const Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex = { $tag: 0 };
const moonbitlang$core$builtin$$int_to_string_js = (x, radix) => {
  return x.toString(radix);
};
const moonbitlang$core$builtin$$JSArray$push = (arr, val) => { arr.push(val); };
const Option$None$4$ = { $tag: 0 };
function Option$Some$4$(param0) {
  this._0 = param0;
}
Option$Some$4$.prototype.$tag = 1;
const Option$None$5$ = { $tag: 0 };
function Option$Some$5$(param0) {
  this._0 = param0;
}
Option$Some$5$.prototype.$tag = 1;
const moonbitlang$core$builtin$$MyInt64$convert_to_double_u = (a) => (a.hi >>> 0) * 4294967296.0 + (a.lo >>> 0);
const moonbitlang$core$builtin$$try_init_wasm_helper = function() {
  try {
    return new WebAssembly.Instance(new WebAssembly.Module(new Uint8Array([0, 97, 115, 109, 1, 0, 0, 0, 1, 13, 2, 96, 0, 1, 127, 96, 4, 127, 127, 127, 127, 1, 127, 3, 7, 6, 0, 1, 1, 1, 1, 1, 6, 6, 1, 127, 1, 65, 0, 11, 7, 50, 6, 3, 109, 117, 108, 0, 1, 5, 100, 105, 118, 95, 115, 0, 2, 5, 100, 105, 118, 95, 117, 0, 3, 5, 114, 101, 109, 95, 115, 0, 4, 5, 114, 101, 109, 95, 117, 0, 5, 8, 103, 101, 116, 95, 104, 105, 103, 104, 0, 0, 10, 191, 1, 6, 4, 0, 35, 0, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 126, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 127, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 128, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 129, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 130, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11])), {}).exports;
  } catch (e) {
    return undefined;
  }
};
const moonbitlang$core$builtin$$MyInt64$mod_u_bigint = (a, b) => {
  const aVal = (BigInt(a.hi >>> 0) << 32n) | BigInt(a.lo >>> 0);
  const bVal = (BigInt(b.hi >>> 0) << 32n) | BigInt(b.lo >>> 0);
  const result = aVal % bVal;
  const lo = Number(result & 0xFFFFFFFFn);
  const hi = Number((result >> 32n) & 0xFFFFFFFFn);
  return { hi: hi | 0, lo: lo | 0 };
};
const moonbitlang$core$builtin$$MyInt64$compare_u = (a, b) => {
  const ahi = a.hi >>> 0;
  const bhi = b.hi >>> 0;
  if (ahi < bhi) {
    return -1;
  }
  if (ahi > bhi) {
    return 1;
  }
  const alo = a.lo >>> 0;
  const blo = b.lo >>> 0;
  if (alo < blo) {
    return -1;
  }
  if (alo > blo) {
    return 1;
  }
  return 0;
};
const moonbitlang$core$builtin$$JSArray$set_length = (arr, len) => { arr.length = len; };
const moonbitlang$core$builtin$$JSArray$pop = (arr) => arr.pop();
function $compare_int(a, b) {
  return (a >= b) - (a <= b);
}
const rami3l$js$45$ffi$js$$Value$undefined = () => undefined;
const rami3l$js$45$ffi$js$$Value$is_null = (n) => Object.is(n, null);
const Option$None$6$ = { $tag: 0 };
function Option$Some$6$(param0) {
  this._0 = param0;
}
Option$Some$6$.prototype.$tag = 1;
const Option$None$7$ = { $tag: 0 };
function Option$Some$7$(param0) {
  this._0 = param0;
}
Option$Some$7$.prototype.$tag = 1;
const Option$None$8$ = { $tag: 0 };
function Option$Some$8$(param0) {
  this._0 = param0;
}
Option$Some$8$.prototype.$tag = 1;
const Option$None$9$ = { $tag: 0 };
function Option$Some$9$(param0) {
  this._0 = param0;
}
Option$Some$9$.prototype.$tag = 1;
const Yoorkin$rabbit$45$tea$dom$$Window$request_animation_frame = (self,f) => self.requestAnimationFrame(f);
const Yoorkin$rabbit$45$tea$dom$$Window$cancel_animation_frame = (self,id) => self.cancelAnimationFrame(id);
const Yoorkin$rabbit$45$tea$dom$$window = () => window;
const Yoorkin$rabbit$45$tea$dom$$ffi_to_mouse_event = (e) => e instanceof MouseEvent ? e : null;
const Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_button = (e) => e.button;
const Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_movement_x = (e) => e.movementX;
const Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_movement_y = (e) => e.movementY;
const Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_offset_x = (e) => e.offsetX;
const Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_offset_y = (e) => e.offsetY;
const Yoorkin$rabbit$45$tea$dom$$ffi_to_keyboard_event = (e) => e instanceof KeyboardEvent ? e : null;
const Yoorkin$rabbit$45$tea$dom$$KeyboardEvent$code = (e) => e.code;
const Yoorkin$rabbit$45$tea$dom$$HTMLImageElement$new = () => new Image();
const Yoorkin$rabbit$45$tea$dom$$HTMLImageElement$set_src = (self, value) => self.src = value;
const Yoorkin$rabbit$45$tea$dom$$ffi_to_html_canvas_element = (x) => x instanceof HTMLCanvasElement ? x : null;
const Yoorkin$rabbit$45$tea$dom$$HTMLCanvasElement$get_context = (x, id) => x.getContext(id);
const Yoorkin$rabbit$45$tea$dom$$ffi_add_event_listener = (target, type, listener) => target.addEventListener(type, listener);
const Yoorkin$rabbit$45$tea$dom$$checked_to_canvas_rendering_context_2d = (value) => value instanceof CanvasRenderingContext2D ? value : null;
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save = (x) => x.save();
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore = (x) => x.restore();
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$scale = (self,x,y) => self.scale(x,y);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$translate = (self,x,y) => self.translate(x,y);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$transform = (self,a,b,c,d,e,f) => self.transform(a,b,c,d,e,f);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_stroke_style = (x,value) => x.strokeStyle = value;
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style = (x,value) => x.fillStyle = value;
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$create_pattern = (self,image,repetition) => self.createPattern(image,repetition);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$clear_rect = (self,x,y,w,h) => self.clearRect(x,y,w,h);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_rect = (self,x,y,w,h) => self.fillRect(x,y,w,h);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$stroke_rect = (self,x,y,w,h) => self.strokeRect(x,y,w,h);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill$46$inner = (self, fillRule) => self.fill(fillRule);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$stroke = (self) => self.stroke();
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text$46$inner = (self,text,x,y,maxWidth) => self.fillText(text,x,y,maxWidth);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$draw_image_with_src_and_dst_size = (self,image,sx,sy,sw,sh,dx,dy,dw,dh) => self.drawImage(image,sx,sy,sw,sh,dx,dy,dw,dh);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$arc$46$inner = (self,x,y,radius,startAngle,endAngle,anticlockwise) => self.arc(x,y,radius,startAngle,endAngle,anticlockwise);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_font = (self,value) => self.font = value;
const Yoorkin$rabbit$45$tea$dom$$document = () => document;
const Yoorkin$rabbit$45$tea$dom$$Document$get_element_by_id = (doc,id) => doc.getElementById(id);
const Milky2018$selene$backend$$set_viewport_height = (x, y) => { x.height = y; };
const Milky2018$selene$backend$$set_viewport_width = (x, y) => { x.width = y; };
const Milky2018$selene$backend$$set_image_smoothing_enabled = (ctx, value) => ctx.imageSmoothingEnabled = value;;
const Milky2018$selene$backend$$set_text_align = (ctx, value) => ctx.textAlign = value;;
const Milky2018$selene$backend$$set_text_baseline = (ctx, value) => ctx.textBaseline = value;;
const Milky2018$selene$backend$$load_font_async = (font, path) => {
   const ff = new FontFace(font, 'url(' + path + ')');
   ff.load().then(loadedFont => {
     document.fonts.add(loadedFont);
   })
 };
const Milky2018$selene$backend$$begin_path = (ctx) => ctx.beginPath();;
const Option$None$10$ = { $tag: 0 };
function Option$Some$10$(param0) {
  this._0 = param0;
}
Option$Some$10$.prototype.$tag = 1;
function $f64_convert_i32_u(a) {
  return a < 0 ? a + 4294967296.0 : a + 0.0;
}
const $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$11$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$11$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$11$.prototype.$tag = 1;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$11$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$11$.prototype.$tag = 2;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$11$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$11$.prototype.$tag = 3;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$11$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$11$.prototype.$tag = 4;
function $64$Milky2018$47$selene$47$sprite$46$SpriteType$Picture(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$sprite$46$SpriteType$Picture.prototype.$tag = 0;
function $64$Milky2018$47$selene$47$sprite$46$SpriteType$Animation(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$Milky2018$47$selene$47$sprite$46$SpriteType$Animation.prototype.$tag = 1;
function $64$Milky2018$47$selene$47$sprite$46$SpriteType$Text(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$sprite$46$SpriteType$Text.prototype.$tag = 2;
function $64$Milky2018$47$selene$47$sprite$46$SpriteType$ColorRect(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$sprite$46$SpriteType$ColorRect.prototype.$tag = 3;
function $64$Milky2018$47$selene$47$sprite$46$SpriteType$ColorCircle(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$sprite$46$SpriteType$ColorCircle.prototype.$tag = 4;
function LevelUpSelection$PowerupSelection(param0) {
  this._0 = param0;
}
LevelUpSelection$PowerupSelection.prototype.$tag = 0;
function LevelUpSelection$WeaponSelection(param0) {
  this._0 = param0;
}
LevelUpSelection$WeaponSelection.prototype.$tag = 1;
function $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect.prototype.$tag = 0;
const moonbitlang$core$builtin$$wasm_helper_cache = { tried: false, exports: undefined };
const Milky2018$selene$inputs$$mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const Milky2018$selene$inputs$$mouse_movement = { movement: { _0: 0, _1: 0 } };
const Milky2018$selene$inputs$$last_mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const Milky2018$selene$inputs$$just_pressed_mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const Milky2018$selene$inputs$$just_release_mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const Milky2018$selene$inputs$$all_codes$46$42$bind$47$2416 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32];
const Milky2018$selene$inputs$$from_string$46$constr$47$2426 = 0;
const Milky2018$selene$inputs$$from_string$46$constr$47$2427 = 1;
const Milky2018$selene$inputs$$from_string$46$constr$47$2428 = 2;
const Milky2018$selene$inputs$$from_string$46$constr$47$2429 = 3;
const Milky2018$selene$inputs$$from_string$46$constr$47$2430 = 4;
const Milky2018$selene$inputs$$from_string$46$constr$47$2431 = 5;
const Milky2018$selene$inputs$$from_string$46$constr$47$2432 = 6;
const Milky2018$selene$inputs$$from_string$46$constr$47$2433 = 7;
const Milky2018$selene$inputs$$from_string$46$constr$47$2434 = 8;
const Milky2018$selene$inputs$$from_string$46$constr$47$2435 = 9;
const Milky2018$selene$inputs$$from_string$46$constr$47$2436 = 10;
const Milky2018$selene$inputs$$from_string$46$constr$47$2437 = 11;
const Milky2018$selene$inputs$$from_string$46$constr$47$2438 = 12;
const Milky2018$selene$inputs$$from_string$46$constr$47$2439 = 13;
const Milky2018$selene$inputs$$from_string$46$constr$47$2440 = 14;
const Milky2018$selene$inputs$$from_string$46$constr$47$2441 = 15;
const Milky2018$selene$inputs$$from_string$46$constr$47$2442 = 16;
const Milky2018$selene$inputs$$from_string$46$constr$47$2443 = 17;
const Milky2018$selene$inputs$$from_string$46$constr$47$2444 = 18;
const Milky2018$selene$inputs$$from_string$46$constr$47$2445 = 19;
const Milky2018$selene$inputs$$from_string$46$constr$47$2446 = 20;
const Milky2018$selene$inputs$$from_string$46$constr$47$2447 = 21;
const Milky2018$selene$inputs$$from_string$46$constr$47$2448 = 22;
const Milky2018$selene$inputs$$from_string$46$constr$47$2449 = 23;
const Milky2018$selene$inputs$$from_string$46$constr$47$2450 = 24;
const Milky2018$selene$inputs$$from_string$46$constr$47$2451 = 26;
const Milky2018$selene$inputs$$from_string$46$constr$47$2452 = 27;
const Milky2018$selene$inputs$$from_string$46$constr$47$2453 = 28;
const Milky2018$selene$inputs$$from_string$46$constr$47$2454 = 29;
const Milky2018$selene$inputs$$from_string$46$constr$47$2455 = 30;
const Milky2018$selene$inputs$$from_string$46$constr$47$2456 = 31;
const Milky2018$selene$inputs$$from_string$46$constr$47$2457 = 32;
const Milky2018$selene$entity$$entity_generator = { val: 0 };
const Milky2018$selene$collision$$collision_layer_generator = { val: 0 };
const Milky2018$selene$plugins$$default_plugin$46$constr$47$3404 = new $64$Milky2018$47$selene$47$system$46$Schedule$Render(0);
const Milky2018$selene$examples$survivors$$weapon_timers = [];
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3407 = "white";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3408 = "24px ThaleahFat";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3409 = "white";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3410 = "24px ThaleahFat";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3411 = "white";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3412 = "24px ThaleahFat";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3413 = "orange";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3414 = "24px ThaleahFat";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3415 = "cyan";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3416 = "24px ThaleahFat";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3417 = "yellow";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3418 = "24px ThaleahFat";
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3419 = 2;
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3420 = new Option$Some$0$(20);
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3421 = new Option$Some$0$(160);
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3422 = new Option$Some$0$(40);
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3423 = 2;
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3424 = new Option$Some$0$(20);
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3425 = new Option$Some$0$(140);
const Milky2018$selene$examples$survivors$$game_state$46$constr$47$3426 = new Option$Some$0$(100);
const Milky2018$selene$examples$survivors$$wave_state = { creeper_spawned: 0, icecream_spawned: 0, orc_spawned: 0, skull_spawned: 0, teleman_spawned: 0, devil_spawned: 0, pirate_spawned: 0 };
const Milky2018$selene$examples$survivors$$player_idle_right_animation$46$constr$47$3430 = true;
const Milky2018$selene$examples$survivors$$player_idle_right_animation$46$constr$47$3431 = new Option$Some$0$(12);
const Milky2018$selene$examples$survivors$$player_idle_up_animation$46$constr$47$3432 = true;
const Milky2018$selene$examples$survivors$$player_idle_up_animation$46$constr$47$3433 = new Option$Some$0$(12);
const Milky2018$selene$examples$survivors$$player_idle_down_animation$46$constr$47$3434 = true;
const Milky2018$selene$examples$survivors$$player_idle_down_animation$46$constr$47$3435 = new Option$Some$0$(12);
const Milky2018$selene$examples$survivors$$player_run_right_animation$46$constr$47$3436 = true;
const Milky2018$selene$examples$survivors$$player_run_right_animation$46$constr$47$3437 = new Option$Some$0$(12);
const Milky2018$selene$examples$survivors$$player_run_down_animation$46$constr$47$3438 = true;
const Milky2018$selene$examples$survivors$$player_run_down_animation$46$constr$47$3439 = new Option$Some$0$(12);
const Milky2018$selene$examples$survivors$$player_run_up_animation$46$constr$47$3440 = true;
const Milky2018$selene$examples$survivors$$player_run_up_animation$46$constr$47$3441 = new Option$Some$0$(12);
const Milky2018$selene$examples$survivors$$background_picture = "assets/tilesets/grass.png";
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3442 = { creeper_count: 40, icecream_count: 20, orc_count: 0, skull_count: 0, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 1 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3443 = { creeper_count: 30, icecream_count: 0, orc_count: 30, skull_count: 0, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 1 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3444 = { creeper_count: 0, icecream_count: 120, orc_count: 0, skull_count: 0, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 0.5 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3445 = { creeper_count: 60, icecream_count: 0, orc_count: 0, skull_count: 60, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 0.5 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3446 = { creeper_count: 0, icecream_count: 0, orc_count: 90, skull_count: 90, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 0.333 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3447 = { creeper_count: 0, icecream_count: 0, orc_count: 56, skull_count: 0, teleman_count: 4, devil_count: 0, pirate_count: 0, spawn_interval: 1 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3448 = { creeper_count: 0, icecream_count: 60, orc_count: 0, skull_count: 0, teleman_count: 0, devil_count: 60, pirate_count: 0, spawn_interval: 0.5 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3449 = { creeper_count: 0, icecream_count: 0, orc_count: 40, skull_count: 0, teleman_count: 40, devil_count: 40, pirate_count: 0, spawn_interval: 0.5 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3450 = { creeper_count: 20, icecream_count: 20, orc_count: 20, skull_count: 20, teleman_count: 20, devil_count: 20, pirate_count: 0, spawn_interval: 0.5 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3451 = { creeper_count: 0, icecream_count: 0, orc_count: 0, skull_count: 0, teleman_count: 59, devil_count: 0, pirate_count: 1, spawn_interval: 1 };
const Milky2018$selene$examples$survivors$$wave_spawn_plans = [Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3442, Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3443, Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3444, Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3445, Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3446, Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3447, Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3448, Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3449, Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3450, Milky2018$selene$examples$survivors$$wave_spawn_plans$46$record$47$3451];
const Milky2018$selene$examples$survivors$$spawners = [{ _0: 16, _1: 16 }, { _0: 624, _1: 16 }, { _0: 16, _1: 624 }, { _0: 624, _1: 624 }];
const Milky2018$selene$examples$survivors$$update_selection_display$46$constr$47$3599 = "white";
const Milky2018$selene$examples$survivors$$update_selection_display$46$constr$47$3600 = "16px ThaleahFat";
const Milky2018$selene$examples$survivors$$update_selection_display$46$constr$47$3601 = "white";
const Milky2018$selene$examples$survivors$$update_selection_display$46$constr$47$3602 = "16px ThaleahFat";
const Milky2018$selene$examples$survivors$$add_score_box$46$constr$47$3679 = new Option$Some$0$(200);
const Milky2018$selene$examples$survivors$$add_score_box$46$constr$47$3680 = new Option$Some$0$(16);
const Milky2018$selene$examples$survivors$$setup_level_up_ui$46$constr$47$3707 = new Option$Some$0$(8);
const Milky2018$selene$examples$survivors$$setup_level_up_ui$46$constr$47$3708 = "white";
const Milky2018$selene$examples$survivors$$setup_level_up_ui$46$constr$47$3709 = "16px ThaleahFat";
const Milky2018$selene$examples$survivors$$add_wave_box$46$constr$47$3719 = new Option$Some$0$(16);
const Milky2018$selene$examples$survivors$$add_wave_box$46$constr$47$3720 = new Option$Some$0$(84);
const Milky2018$selene$examples$survivors$$add_exp_box$46$constr$47$3722 = new Option$Some$0$(16);
const Milky2018$selene$examples$survivors$$add_exp_box$46$constr$47$3723 = new Option$Some$0$(50);
const Milky2018$selene$examples$survivors$$add_timer_box$46$constr$47$3725 = new Option$Some$0$(360);
const Milky2018$selene$examples$survivors$$add_timer_box$46$constr$47$3726 = new Option$Some$0$(16);
const Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3734 = new Option$Some$0$(30);
const Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3735 = new Option$Some$0$(8);
const Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3736 = new Option$Some$0$(10);
const Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3737 = "white";
const Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3738 = "24px ThaleahFat";
const Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3739 = new Option$Some$0$(45);
const Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3740 = new Option$Some$0$(8);
const Milky2018$selene$examples$survivors$$add_level_box$46$constr$47$3748 = new Option$Some$0$(16);
const Milky2018$selene$examples$survivors$$add_level_box$46$constr$47$3749 = new Option$Some$0$(16);
const Milky2018$selene$examples$survivors$$add_background$46$constr$47$3766 = 3;
const Milky2018$selene$examples$survivors$$game_start$46$constr$47$3832 = new Option$Some$0$(0);
const Milky2018$selene$examples$survivors$$game_start$46$constr$47$3833 = new Option$Some$0$(640);
const Milky2018$selene$examples$survivors$$game_start$46$constr$47$3834 = new Option$Some$0$(0);
const Milky2018$selene$examples$survivors$$game_start$46$constr$47$3835 = new Option$Some$0$(640);
const Milky2018$selene$position$$positions = moonbitlang$core$builtin$$Map$new$46$inner$0$(8);
const moonbitlang$core$builtin$$seed = moonbitlang$core$builtin$$random_seed();
const Milky2018$selene$backend$$canvas_backend = Milky2018$selene$backend$$CanvasBackend$new();
const Milky2018$selene$ui$$uis = moonbitlang$core$builtin$$Map$new$46$inner$1$(8);
const Milky2018$selene$style$$styles = moonbitlang$core$builtin$$Map$new$46$inner$2$(8);
const Milky2018$selene$entity$$all_entities = moonbitlang$core$set$$Set$new$46$inner$3$(8);
const Milky2018$selene$style$$screen_root = Milky2018$selene$entity$$Entity$new();
(() => {
  moonbitlang$core$builtin$$Map$set$2$(Milky2018$selene$style$$styles, Milky2018$selene$style$$screen_root, Milky2018$selene$style$$Style$new$46$inner(new $64$Milky2018$47$selene$47$style$46$SizePlan$Sized(Milky2018$selene$backend$$canvas_backend.viewport_size), 0, 0, 0, 0, 0));
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, Milky2018$selene$style$$screen_root, { _0: 0, _1: 0 });
  moonbitlang$core$builtin$$Map$set$1$(Milky2018$selene$ui$$uis, Milky2018$selene$style$$screen_root, Milky2018$selene$ui$$Ui$new());
})();
const Milky2018$selene$examples$survivors$$enemies = moonbitlang$core$builtin$$Map$new$46$inner$4$(8);
const Milky2018$selene$collision$$shapes = moonbitlang$core$builtin$$Map$new$46$inner$5$(8);
const Milky2018$selene$sprite$$sprites = moonbitlang$core$builtin$$Map$new$46$inner$6$(8);
const Milky2018$selene$collision$$pickables = moonbitlang$core$builtin$$Map$new$46$inner$7$(8);
const Milky2018$selene$entity$$children = moonbitlang$core$builtin$$Map$new$46$inner$8$(8);
const Milky2018$selene$entity$$parents = moonbitlang$core$builtin$$Map$new$46$inner$9$(8);
const Milky2018$selene$examples$survivors$$game_state = { player_entity: Milky2018$selene$entity$$Entity$new(), player_direction: 1, rand: moonbitlang$core$random$$Rand$new(Option$None$1$), score: 0, score_box: Milky2018$selene$sprite$$Text$new("Score: 0", Milky2018$selene$examples$survivors$$game_state$46$constr$47$3407, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3408, undefined, undefined), invincible: false, game_timer: 600, game_over: false, timer_box: Milky2018$selene$sprite$$Text$new("Time: 10:00", Milky2018$selene$examples$survivors$$game_state$46$constr$47$3409, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3410, undefined, undefined), game_over_box: Milky2018$selene$sprite$$Text$new("Final Score: 0", Milky2018$selene$examples$survivors$$game_state$46$constr$47$3411, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3412, undefined, undefined), game_over_displayed: false, current_wave: 1, wave_box: Milky2018$selene$sprite$$Text$new("Wave: 1", Milky2018$selene$examples$survivors$$game_state$46$constr$47$3413, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3414, undefined, undefined), exp: 0, exp_box: Milky2018$selene$sprite$$Text$new("EXP: 0/16", Milky2018$selene$examples$survivors$$game_state$46$constr$47$3415, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3416, undefined, undefined), player_level: 1, level_box: Milky2018$selene$sprite$$Text$new("Level: 1", Milky2018$selene$examples$survivors$$game_state$46$constr$47$3417, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3418, undefined, undefined), player_stats: { attack: 0, range: 0, speed: 150, attack_speed: 1, penetration: 0, weapon_instances: [0] }, level_up_panel: { panel_entity: Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new$46$inner({ _0: 160, _1: 250 }, "rgba(13, 170, 26, 1)", "black"), zindex, undefined), undefined, undefined, undefined, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3419, Option$None$0$, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3420, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3421, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3422), available_selections: [] }, pending_level_ups: [], score_blink_timer: 0, score_is_red: false, game_over_panel: { panel_entity: Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new$46$inner({ _0: 200, _1: 120 }, "rgba(0, 0, 0, 0.8)", "white"), zindex, undefined), undefined, undefined, undefined, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3423, Option$None$0$, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3424, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3425, Milky2018$selene$examples$survivors$$game_state$46$constr$47$3426) } };
const Milky2018$selene$system$$timers = moonbitlang$core$array$$Array$new$46$inner$10$(0);
const Milky2018$selene$system$$deferred_events = moonbitlang$core$array$$Array$new$46$inner$11$(0);
const Milky2018$selene$examples$survivors$$enemybullet_collision_layer = Milky2018$selene$collision$$CollisionLayer$new();
const Milky2018$selene$collision$$collision_layers = moonbitlang$core$builtin$$Map$new$46$inner$12$(8);
const Milky2018$selene$collision$$areas = moonbitlang$core$builtin$$Map$new$46$inner$13$(8);
const Milky2018$selene$examples$survivors$$player_collision_layer = Milky2018$selene$collision$$CollisionLayer$new();
const Milky2018$selene$examples$survivors$$wall_collision_layer = Milky2018$selene$collision$$CollisionLayer$new();
const Milky2018$selene$velocity$$velocities = moonbitlang$core$builtin$$Map$new$46$inner$14$(8);
const Milky2018$selene$sprite$$animation_generator = moonbitlang$core$ref$$Ref$new$15$(0);
const Milky2018$selene$examples$survivors$$skull_right_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Skull.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0));
const Milky2018$selene$examples$survivors$$devil_right_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Devil.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0));
const Milky2018$selene$examples$survivors$$orc_right_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Orc.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0));
const Milky2018$selene$examples$survivors$$pirate_left_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Pirate.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$flip_x(16));
const Milky2018$selene$examples$survivors$$devil_left_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Devil.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$flip_x(16));
const Milky2018$selene$examples$survivors$$teleman_right_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Teleman.png", 4, 16, 24, { _0: 0, _1: 0 }, 0), true, 12, Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0));
const Milky2018$selene$examples$survivors$$icecream_left_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Icecream.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$flip_x(16));
const Milky2018$selene$examples$survivors$$pirate_right_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Pirate.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0));
const Milky2018$selene$examples$survivors$$creeper_right_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Creeper.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0));
const Milky2018$selene$examples$survivors$$skull_left_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Skull.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$flip_x(16));
const Milky2018$selene$examples$survivors$$creeper_left_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Creeper.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$flip_x(16));
const Milky2018$selene$examples$survivors$$orc_left_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Orc.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$flip_x(16));
const Milky2018$selene$examples$survivors$$teleman_left_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Teleman.png", 4, 16, 24, { _0: 0, _1: 0 }, 0), true, 12, Milky2018$selene$math$$Transform$flip_x(16));
const Milky2018$selene$examples$survivors$$icecream_right_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/enemy/Icecream.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0));
const data = moonbitlang$core$builtin$$Map$new$46$inner$16$(8);
moonbitlang$core$builtin$$Map$set$16$(data, 0, { health: 1, speed: 60, points: 10, right_animation: Milky2018$selene$examples$survivors$$creeper_right_animation, left_animation: Milky2018$selene$examples$survivors$$creeper_left_animation });
moonbitlang$core$builtin$$Map$set$16$(data, 1, { health: 2, speed: 90, points: 20, right_animation: Milky2018$selene$examples$survivors$$icecream_right_animation, left_animation: Milky2018$selene$examples$survivors$$icecream_left_animation });
moonbitlang$core$builtin$$Map$set$16$(data, 2, { health: 3, speed: 75, points: 30, right_animation: Milky2018$selene$examples$survivors$$orc_right_animation, left_animation: Milky2018$selene$examples$survivors$$orc_left_animation });
moonbitlang$core$builtin$$Map$set$16$(data, 3, { health: 5, speed: 60, points: 40, right_animation: Milky2018$selene$examples$survivors$$skull_right_animation, left_animation: Milky2018$selene$examples$survivors$$skull_left_animation });
moonbitlang$core$builtin$$Map$set$16$(data, 4, { health: 20, speed: 60, points: 80, right_animation: Milky2018$selene$examples$survivors$$teleman_right_animation, left_animation: Milky2018$selene$examples$survivors$$teleman_left_animation });
moonbitlang$core$builtin$$Map$set$16$(data, 5, { health: 8, speed: 90, points: 50, right_animation: Milky2018$selene$examples$survivors$$devil_right_animation, left_animation: Milky2018$selene$examples$survivors$$devil_left_animation });
moonbitlang$core$builtin$$Map$set$16$(data, 6, { health: 500, speed: 60, points: 200, right_animation: Milky2018$selene$examples$survivors$$pirate_right_animation, left_animation: Milky2018$selene$examples$survivors$$pirate_left_animation });
const Milky2018$selene$examples$survivors$$enemy_data = data;
const _bind = { _0: 0, _1: 0 };
const _bind$2 = Option$None$0$;
const _bind$3 = Option$None$0$;
const _bind$4 = Option$None$0$;
const _bind$5 = Option$None$0$;
const _bind$6 = undefined;
const _bind$7 = { _0: 0, _1: 0 };
const Milky2018$selene$camera$$camera = { position: _bind, limit_top: _bind$4, limit_bottom: _bind$2, limit_left: _bind$3, limit_right: _bind$5, attached_entity: _bind$6, offset: _bind$7, follow_x: true, follow_y: true };
const Milky2018$selene$examples$survivors$$powerup_attack_icon = Milky2018$selene$sprite$$Animation$single_frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 384, _1: 128 });
const Milky2018$selene$examples$survivors$$powerup_bandana_icon = Milky2018$selene$sprite$$Animation$single_frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 192, _1: 288 });
const Milky2018$selene$examples$survivors$$powerup_range_icon = Milky2018$selene$sprite$$Animation$single_frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 192, _1: 192 });
const Milky2018$selene$examples$survivors$$powerup_speed_icon = Milky2018$selene$sprite$$Animation$single_frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 64, _1: 160 });
const Milky2018$selene$examples$survivors$$powerup_cooldown_icon = Milky2018$selene$sprite$$Animation$single_frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 96, _1: 160 });
const Milky2018$selene$examples$survivors$$weapon_minigun_icon = Milky2018$selene$sprite$$Animation$single_frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 32, _1: 224 });
const Milky2018$selene$examples$survivors$$weapon_sniperrifle_icon = Milky2018$selene$sprite$$Animation$single_frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 128, _1: 224 });
const Milky2018$selene$examples$survivors$$weapon_pistol_icon = Milky2018$selene$sprite$$Animation$single_frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 256, _1: 192 });
const Milky2018$selene$examples$survivors$$weapon_sword_icon = Milky2018$selene$sprite$$Animation$single_frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 32, _1: 192 });
const Milky2018$selene$examples$survivors$$grass_sprite = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/tilesets/decor_16x16.png", 1, 16, 16, { _0: 0, _1: 0 }, 0), -1, Option$None$0$, undefined);
const Milky2018$selene$collision$$colliders = moonbitlang$core$builtin$$Map$new$46$inner$17$(8);
const Milky2018$selene$examples$survivors$$player_idle_right_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/whiteboy/idle.png", 4, 16, 16, { _0: 32, _1: 32 }, 64), Milky2018$selene$examples$survivors$$player_idle_right_animation$46$constr$47$3430, Milky2018$selene$examples$survivors$$player_idle_right_animation$46$constr$47$3431, undefined);
const Milky2018$selene$examples$survivors$$player_run_down_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/whiteboy/run.png", 8, 16, 16, { _0: 32, _1: 112 }, 64), Milky2018$selene$examples$survivors$$player_run_down_animation$46$constr$47$3438, Milky2018$selene$examples$survivors$$player_run_down_animation$46$constr$47$3439, undefined);
const Milky2018$selene$examples$survivors$$player_run_up_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/whiteboy/run.png", 8, 16, 16, { _0: 32, _1: 192 }, 64), Milky2018$selene$examples$survivors$$player_run_up_animation$46$constr$47$3440, Milky2018$selene$examples$survivors$$player_run_up_animation$46$constr$47$3441, undefined);
const Milky2018$selene$examples$survivors$$player_idle_up_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/whiteboy/idle.png", 4, 16, 16, { _0: 32, _1: 192 }, 64), Milky2018$selene$examples$survivors$$player_idle_up_animation$46$constr$47$3432, Milky2018$selene$examples$survivors$$player_idle_up_animation$46$constr$47$3433, undefined);
const Milky2018$selene$examples$survivors$$player_idle_left_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/whiteboy/idle.png", 4, 16, 16, { _0: 32, _1: 32 }, 64), true, 12, Milky2018$selene$math$$Transform$flip_x(16));
const Milky2018$selene$examples$survivors$$player_run_left_animation = Milky2018$selene$sprite$$Animation$new$46$inner(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/whiteboy/run.png", 8, 16, 16, { _0: 32, _1: 32 }, 64), true, 12, Milky2018$selene$math$$Transform$flip_x(16));
const Milky2018$selene$inputs$$pressed_keys = moonbitlang$core$set$$Set$new$46$inner$18$(8);
const Milky2018$selene$examples$survivors$$player_idle_down_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/whiteboy/idle.png", 4, 16, 16, { _0: 32, _1: 112 }, 64), Milky2018$selene$examples$survivors$$player_idle_down_animation$46$constr$47$3434, Milky2018$selene$examples$survivors$$player_idle_down_animation$46$constr$47$3435, undefined);
const Milky2018$selene$examples$survivors$$player_run_right_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas$46$inner("assets/whiteboy/run.png", 8, 16, 16, { _0: 32, _1: 32 }, 64), Milky2018$selene$examples$survivors$$player_run_right_animation$46$constr$47$3436, Milky2018$selene$examples$survivors$$player_run_right_animation$46$constr$47$3437, undefined);
const Milky2018$selene$collision$$quadtree_root = moonbitlang$core$ref$$Ref$new$19$(Milky2018$selene$collision$$QuadTree$new({ _0: 0, _1: 0 }, { _0: 0, _1: 0 }, 0));
const Milky2018$selene$collision$$real_velocities = moonbitlang$core$builtin$$Map$new$46$inner$14$(8);
const Milky2018$selene$collision$$collision_infos = moonbitlang$core$builtin$$Map$new$46$inner$20$(8);
const Milky2018$selene$inputs$$last_pressed_keys = moonbitlang$core$set$$Set$new$46$inner$18$(8);
const Milky2018$selene$inputs$$all_codes = moonbitlang$core$set$$Set$from_array$18$({ buf: Milky2018$selene$inputs$$all_codes$46$42$bind$47$2416, start: 0, end: 33 });
const Milky2018$selene$inputs$$just_pressed_keys = moonbitlang$core$set$$Set$new$46$inner$18$(8);
const Milky2018$selene$inputs$$just_release_keys = moonbitlang$core$set$$Set$new$46$inner$18$(8);
const Milky2018$selene$backend$$element_cache = moonbitlang$core$builtin$$Map$new$46$inner$21$(8);
const Milky2018$selene$backend$$realtime_delta = moonbitlang$core$ref$$Ref$new$22$(0);
const Milky2018$selene$backend$$window = Yoorkin$rabbit$45$tea$dom$$window();
const Milky2018$selene$examples$survivors$$enemy_collision_layer = Milky2018$selene$collision$$CollisionLayer$new();
const Milky2018$selene$examples$survivors$$bullet_collision_layer = Milky2018$selene$collision$$CollisionLayer$new();
function moonbitlang$core$abort$$abort$23$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$24$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$25$(msg) {
  $panic();
}
function moonbitlang$core$abort$$abort$26$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$27$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$19$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$28$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$29$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$30$(msg) {
  return $panic();
}
function moonbitlang$core$list$$List$from_array$19$(arr) {
  let _tmp = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp$2 = $64$moonbitlang$47$core$47$list$46$List$Empty$2$;
  while (true) {
    const i = _tmp;
    const list = _tmp$2;
    if (i >= 0) {
      _tmp = i - 1 | 0;
      _tmp$2 = new $64$moonbitlang$47$core$47$list$46$List$More$2$(moonbitlang$core$array$$ArrayView$at$19$(arr, i), list);
      continue;
    } else {
      return list;
    }
  }
}
function moonbitlang$core$bytes$$Bytes$sub$46$inner(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end < 0 ? len + _end | 0 : _end;
  }
  const start$2 = start < 0 ? len + start | 0 : start;
  return start$2 >= 0 && (start$2 <= end$2 && end$2 <= len) ? { bytes: self, start: start$2, end: end$2 } : moonbitlang$core$abort$$abort$30$("Invalid index for View");
}
function moonbitlang$core$bytes$$BytesView$unsafe_extract_byte(bs, offset, len) {
  const byte_index = offset >> 3;
  if ((offset & 7) === 0) {
    const _tmp = bs.bytes;
    const _tmp$2 = bs.start + byte_index | 0;
    $bound_check(_tmp, _tmp$2);
    const byte = _tmp[_tmp$2];
    const _p = moonbitlang$core$builtin$$Shr$shr$31$(byte, 8 - len | 0);
    return _p;
  } else {
    if (((offset & 7) + len | 0) <= 8) {
      const _tmp = bs.bytes;
      const _tmp$2 = bs.start + byte_index | 0;
      $bound_check(_tmp, _tmp$2);
      const _p = _tmp[_tmp$2];
      const byte = _p;
      const shift = 8 - ((offset & 7) + len | 0) | 0;
      const mask = (1 << len >>> 0) - (1 >>> 0) | 0;
      return byte >>> shift & mask;
    } else {
      const _tmp = bs.bytes;
      const _tmp$2 = bs.start + byte_index | 0;
      $bound_check(_tmp, _tmp$2);
      const _p = _tmp[_tmp$2];
      const b0 = _p;
      const _p$2 = byte_index + 1 | 0;
      const _tmp$3 = bs.bytes;
      const _tmp$4 = bs.start + _p$2 | 0;
      $bound_check(_tmp$3, _tmp$4);
      const _p$3 = _tmp$3[_tmp$4];
      const b1 = _p$3;
      const data$2 = b0 << 8 | b1;
      const bit_mask = (1 << (16 - (offset & 7) | 0) >>> 0) - (1 >>> 0) | 0;
      const data$3 = data$2 & bit_mask;
      const shift = 16 - ((offset & 7) + len | 0) | 0;
      return data$3 >>> shift | 0;
    }
  }
}
function moonbitlang$core$bytes$$BytesView$unsafe_extract_uint_le(bs, offset, len) {
  const bytes_needed = (len + 7 | 0) / 8 | 0;
  const b0 = moonbitlang$core$bytes$$BytesView$unsafe_extract_byte(bs, offset, 8);
  switch (bytes_needed) {
    case 2: {
      const b1 = moonbitlang$core$bytes$$BytesView$unsafe_extract_byte(bs, offset + 8 | 0, len - 8 | 0);
      return b1 << 8 | b0;
    }
    case 3: {
      const b1$2 = moonbitlang$core$bytes$$BytesView$unsafe_extract_byte(bs, offset + 8 | 0, 8);
      const b2 = moonbitlang$core$bytes$$BytesView$unsafe_extract_byte(bs, offset + 16 | 0, len - 16 | 0);
      return b2 << 16 | b1$2 << 8 | b0;
    }
    case 4: {
      const b1$3 = moonbitlang$core$bytes$$BytesView$unsafe_extract_byte(bs, offset + 8 | 0, 8);
      const b2$2 = moonbitlang$core$bytes$$BytesView$unsafe_extract_byte(bs, offset + 16 | 0, 8);
      const b3 = moonbitlang$core$bytes$$BytesView$unsafe_extract_byte(bs, offset + 24 | 0, len - 24 | 0);
      return b3 << 24 | b2$2 << 16 | b1$3 << 8 | b0;
    }
    default: {
      return moonbitlang$core$abort$$abort$28$("Invalid byte count for int32 extraction");
    }
  }
}
function moonbitlang$core$set$$Set$new$46$inner$18$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$set$$Set$new$46$inner$3$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$set$$Set$add_entry_to_tail$3$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$set$$Set$add_entry_to_tail$18$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$set$$Set$set_entry$18$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$set$$Set$set_entry$3$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$set$$Set$push_away$3$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$set$$Set$set_entry$3$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$set$$Set$set_entry$3$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$set$$Set$push_away$18$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$set$$Set$set_entry$18$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$set$$Set$set_entry$18$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$set$$Set$add_with_hash$3$(self, key, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$set$$Set$grow$3$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$set$$Set$push_away$3$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key };
  moonbitlang$core$set$$Set$add_entry_to_tail$3$(self, _idx, entry);
}
function moonbitlang$core$set$$Set$add_with_hash$18$(self, key, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$set$$Set$grow$18$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$18$(_curr_entry.key, key)) {
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$set$$Set$push_away$18$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key };
  moonbitlang$core$set$$Set$add_entry_to_tail$18$(self, _idx, entry);
}
function moonbitlang$core$set$$Set$grow$3$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _hash = _x.hash;
      moonbitlang$core$set$$Set$add_with_hash$3$(self, _key, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$grow$18$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _hash = _x.hash;
      moonbitlang$core$set$$Set$add_with_hash$18$(self, _key, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$add$3$(self, key) {
  moonbitlang$core$set$$Set$add_with_hash$3$(self, key, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$set$$Set$add$18$(self, key) {
  moonbitlang$core$set$$Set$add_with_hash$18$(self, key, moonbitlang$core$builtin$$Hash$hash$33$(key));
}
function moonbitlang$core$set$$Set$from_array$18$(arr) {
  const length = arr.end - arr.start | 0;
  let capacity = moonbitlang$core$int$$Int$next_power_of_two(length);
  const _p = capacity;
  if (length > ((Math.imul(_p, 13) | 0) / 16 | 0)) {
    capacity = Math.imul(capacity, 2) | 0;
  }
  const m = moonbitlang$core$set$$Set$new$46$inner$18$(capacity);
  const _len = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const e = arr.buf[arr.start + _i | 0];
      moonbitlang$core$set$$Set$add$18$(m, e);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function moonbitlang$core$set$$Set$contains$3$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return false;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$contains$18$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$33$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return false;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      if (_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$18$(_entry.key, key)) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$remove_entry$18$(self, entry) {
  const _bind$8 = entry.prev;
  if (_bind$8 === -1) {
    self.head = entry.next;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    const _tmp$3 = _tmp$2;
    _tmp$3.next = entry.next;
  }
  const _bind$9 = entry.next;
  if (_bind$9 === undefined) {
    self.tail = entry.prev;
    return;
  } else {
    const _Some = _bind$9;
    const _next = _Some;
    _next.prev = entry.prev;
    return;
  }
}
function moonbitlang$core$set$$Set$remove_entry$3$(self, entry) {
  const _bind$8 = entry.prev;
  if (_bind$8 === -1) {
    self.head = entry.next;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    const _tmp$3 = _tmp$2;
    _tmp$3.next = entry.next;
  }
  const _bind$9 = entry.next;
  if (_bind$9 === undefined) {
    self.tail = entry.prev;
    return;
  } else {
    const _Some = _bind$9;
    const _next = _Some;
    _next.prev = entry.prev;
    return;
  }
}
function moonbitlang$core$set$$Set$shift_back$18$(self, idx) {
  let _tmp = idx;
  while (true) {
    const idx$2 = _tmp;
    const next = idx$2 + 1 & self.capacity_mask;
    _L: {
      const _tmp$2 = self.entries;
      $bound_check(_tmp$2, next);
      const _bind$8 = _tmp$2[next];
      if (_bind$8 === undefined) {
        break _L;
      } else {
        const _Some = _bind$8;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          moonbitlang$core$set$$Set$set_entry$18$(self, _x, idx$2);
          _tmp = next;
          continue;
        }
      }
    }
    const _tmp$2 = self.entries;
    $bound_check(_tmp$2, idx$2);
    _tmp$2[idx$2] = undefined;
    return;
  }
}
function moonbitlang$core$set$$Set$shift_back$3$(self, idx) {
  let _tmp = idx;
  while (true) {
    const idx$2 = _tmp;
    const next = idx$2 + 1 & self.capacity_mask;
    _L: {
      const _tmp$2 = self.entries;
      $bound_check(_tmp$2, next);
      const _bind$8 = _tmp$2[next];
      if (_bind$8 === undefined) {
        break _L;
      } else {
        const _Some = _bind$8;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          moonbitlang$core$set$$Set$set_entry$3$(self, _x, idx$2);
          _tmp = next;
          continue;
        }
      }
    }
    const _tmp$2 = self.entries;
    $bound_check(_tmp$2, idx$2);
    _tmp$2[idx$2] = undefined;
    return;
  }
}
function moonbitlang$core$set$$Set$remove$18$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$33$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      if (_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$18$(_entry.key, key)) {
        moonbitlang$core$set$$Set$remove_entry$18$(self, _entry);
        moonbitlang$core$set$$Set$shift_back$18$(self, idx);
        self.size = self.size - 1 | 0;
        break;
      }
      if (i > _entry.psl) {
        break;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$remove$3$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        moonbitlang$core$set$$Set$remove_entry$3$(self, _entry);
        moonbitlang$core$set$$Set$shift_back$3$(self, idx);
        self.size = self.size - 1 | 0;
        break;
      }
      if (i > _entry.psl) {
        break;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$clear$18$(self) {
  moonbitlang$core$array$$FixedArray$fill$46$inner$34$(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function moonbitlang$core$set$$Set$iter$3$(self) {
  const _p = (yield_) => {
    let _tmp = self.head;
    while (true) {
      const _param = _tmp;
      if (_param === undefined) {
        return 1;
      } else {
        const _Some = _param;
        const _x = _Some;
        const _key = _x.key;
        const _next = _x.next;
        const _bind$8 = yield_(_key);
        if (_bind$8 === 1) {
          _tmp = _next;
          continue;
        } else {
          return 0;
        }
      }
    }
  };
  return _p;
}
function moonbitlang$core$set$$Set$iterator$18$(self) {
  const curr_entry = { val: self.head };
  const _p = () => {
    const _bind$8 = curr_entry.val;
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _key = _x.key;
      const _next = _x.next;
      curr_entry.val = _next;
      return _key;
    }
  };
  return _p;
}
function moonbitlang$core$set$$Set$iterator$3$(self) {
  const curr_entry = { val: self.head };
  const _p = () => {
    const _bind$8 = curr_entry.val;
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _key = _x.key;
      const _next = _x.next;
      curr_entry.val = _next;
      return _key;
    }
  };
  return _p;
}
function moonbitlang$core$set$$Set$difference$18$(self, other) {
  const m = moonbitlang$core$set$$Set$new$46$inner$18$(8);
  let _tmp = self.head;
  while (true) {
    const _p = _tmp;
    if (_p === undefined) {
      break;
    } else {
      const _p$2 = _p;
      const _p$3 = _p$2;
      const _p$4 = _p$3.key;
      const _p$5 = _p$3.next;
      if (!moonbitlang$core$set$$Set$contains$18$(other, _p$4)) {
        moonbitlang$core$set$$Set$add$18$(m, _p$4);
      }
      _tmp = _p$5;
      continue;
    }
  }
  return m;
}
function moonbitlang$core$set$$Set$union$18$(self, other) {
  const m = moonbitlang$core$set$$Set$new$46$inner$18$(8);
  let _tmp = self.head;
  while (true) {
    const _p = _tmp;
    if (_p === undefined) {
      break;
    } else {
      const _p$2 = _p;
      const _p$3 = _p$2;
      const _p$4 = _p$3.key;
      const _p$5 = _p$3.next;
      moonbitlang$core$set$$Set$add$18$(m, _p$4);
      _tmp = _p$5;
      continue;
    }
  }
  let _tmp$2 = other.head;
  while (true) {
    const _p = _tmp$2;
    if (_p === undefined) {
      break;
    } else {
      const _p$2 = _p;
      const _p$3 = _p$2;
      const _p$4 = _p$3.key;
      const _p$5 = _p$3.next;
      moonbitlang$core$set$$Set$add$18$(m, _p$4);
      _tmp$2 = _p$5;
      continue;
    }
  }
  return m;
}
function moonbitlang$core$set$$Set$union$3$(self, other) {
  const m = moonbitlang$core$set$$Set$new$46$inner$3$(8);
  let _tmp = self.head;
  while (true) {
    const _p = _tmp;
    if (_p === undefined) {
      break;
    } else {
      const _p$2 = _p;
      const _p$3 = _p$2;
      const _p$4 = _p$3.key;
      const _p$5 = _p$3.next;
      moonbitlang$core$set$$Set$add$3$(m, _p$4);
      _tmp = _p$5;
      continue;
    }
  }
  let _tmp$2 = other.head;
  while (true) {
    const _p = _tmp$2;
    if (_p === undefined) {
      break;
    } else {
      const _p$2 = _p;
      const _p$3 = _p$2;
      const _p$4 = _p$3.key;
      const _p$5 = _p$3.next;
      moonbitlang$core$set$$Set$add$3$(m, _p$4);
      _tmp$2 = _p$5;
      continue;
    }
  }
  return m;
}
function moonbitlang$core$random$$Source$next$35$(self) {
  while (true) {
    const _bind$8 = moonbitlang$core$random$internal$random_source$$ChaCha8$next(self);
    if (_bind$8 === undefined) {
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      return _x;
    }
    moonbitlang$core$random$internal$random_source$$ChaCha8$refill(self);
    continue;
  }
}
function moonbitlang$core$random$$Rand$chacha8$46$inner(seed) {
  if (seed.length !== 32) {
    moonbitlang$core$abort$$abort$25$("seed must be 32 bytes long");
  }
  return { self: moonbitlang$core$random$internal$random_source$$ChaCha8$new(seed), method_0: moonbitlang$core$random$$Source$next$35$ };
}
function moonbitlang$core$random$$Rand$new(generator) {
  if (generator.$tag === 0) {
    return moonbitlang$core$random$$Rand$chacha8$46$inner($bytes_literal$0);
  } else {
    const _Some = generator;
    const _gen = _Some._0;
    return _gen;
  }
}
function moonbitlang$core$random$$umul128(a, b) {
  const aLo = moonbitlang$core$builtin$$BitAnd$land$36$(a, $4294967295L);
  const aHi = moonbitlang$core$builtin$$Shr$shr$36$(a, 32);
  const bLo = moonbitlang$core$builtin$$BitAnd$land$36$(b, $4294967295L);
  const bHi = moonbitlang$core$builtin$$Shr$shr$36$(b, 32);
  const x = moonbitlang$core$builtin$$Mul$mul$36$(aLo, bLo);
  const y = moonbitlang$core$builtin$$Add$add$36$(moonbitlang$core$builtin$$Mul$mul$36$(aHi, bLo), moonbitlang$core$builtin$$Shr$shr$36$(x, 32));
  const z = moonbitlang$core$builtin$$Add$add$36$(moonbitlang$core$builtin$$Mul$mul$36$(aLo, bHi), moonbitlang$core$builtin$$BitAnd$land$36$(y, $4294967295L));
  const w = moonbitlang$core$builtin$$Add$add$36$(moonbitlang$core$builtin$$Add$add$36$(moonbitlang$core$builtin$$Mul$mul$36$(aHi, bHi), moonbitlang$core$builtin$$Shr$shr$36$(y, 32)), moonbitlang$core$builtin$$Shr$shr$36$(z, 32));
  return { hi: w, lo: moonbitlang$core$builtin$$Mul$mul$36$(a, b) };
}
function moonbitlang$core$random$$Rand$uint64$46$inner(self, limit) {
  if (moonbitlang$core$builtin$$Eq$equal$36$(limit, $0L)) {
    const _p = self;
    return _p.method_0(_p.self);
  } else {
    if (moonbitlang$core$builtin$$Eq$equal$36$(moonbitlang$core$builtin$$BitAnd$land$36$(limit, moonbitlang$core$builtin$$Sub$sub$36$(limit, $1L)), $0L)) {
      const _p = self;
      return moonbitlang$core$builtin$$BitAnd$land$36$(_p.method_0(_p.self), moonbitlang$core$builtin$$Sub$sub$36$(limit, $1L));
    }
  }
  const _p = self;
  let r = moonbitlang$core$random$$umul128(_p.method_0(_p.self), limit);
  if (moonbitlang$core$builtin$$Compare$op_lt$37$(r.lo, limit)) {
    const thresh = moonbitlang$core$builtin$$Mod$mod$36$(moonbitlang$core$uint64$$UInt64$lnot(limit), limit);
    while (true) {
      if (moonbitlang$core$builtin$$Compare$op_lt$37$(r.lo, thresh)) {
        const _p$2 = self;
        r = moonbitlang$core$random$$umul128(_p$2.method_0(_p$2.self), limit);
        continue;
      } else {
        break;
      }
    }
  }
  return r.hi;
}
function moonbitlang$core$random$$Rand$uint$46$inner(self, limit) {
  if (limit === 0) {
    const _p = self;
    return moonbitlang$core$uint64$$UInt64$to_uint(_p.method_0(_p.self));
  }
  return moonbitlang$core$uint64$$UInt64$to_uint(moonbitlang$core$random$$Rand$uint64$46$inner(self, moonbitlang$core$uint$$UInt$to_uint64(limit)));
}
function moonbitlang$core$random$$Rand$int$46$inner(self, limit) {
  if (limit === 0) {
    const _p = self;
    return moonbitlang$core$uint64$$UInt64$to_int(moonbitlang$core$builtin$$Shr$shr$36$(_p.method_0(_p.self), 33));
  } else {
    return moonbitlang$core$random$$Rand$uint$46$inner(self, limit);
  }
}
function moonbitlang$core$random$$Rand$double(self) {
  const _p = self;
  return moonbitlang$core$double$$Double$convert_uint64(moonbitlang$core$builtin$$Shr$shr$36$(moonbitlang$core$builtin$$Shl$shl$36$(_p.method_0(_p.self), 11), 11)) / moonbitlang$core$double$$Double$convert_uint64(moonbitlang$core$builtin$$Shl$shl$36$($1L, 53));
}
function moonbitlang$core$random$internal$random_source$$setup(seed, b32, counter) {
  $bound_check(b32, 0);
  b32[0] = 1634760805;
  $bound_check(b32, 1);
  b32[1] = 1634760805;
  $bound_check(b32, 2);
  b32[2] = 1634760805;
  $bound_check(b32, 3);
  b32[3] = 1634760805;
  $bound_check(b32, 4);
  b32[4] = 857760878;
  $bound_check(b32, 5);
  b32[5] = 857760878;
  $bound_check(b32, 6);
  b32[6] = 857760878;
  $bound_check(b32, 7);
  b32[7] = 857760878;
  $bound_check(b32, 8);
  b32[8] = 2036477234;
  $bound_check(b32, 9);
  b32[9] = 2036477234;
  $bound_check(b32, 10);
  b32[10] = 2036477234;
  $bound_check(b32, 11);
  b32[11] = 2036477234;
  $bound_check(b32, 12);
  b32[12] = 1797285236;
  $bound_check(b32, 13);
  b32[13] = 1797285236;
  $bound_check(b32, 14);
  b32[14] = 1797285236;
  $bound_check(b32, 15);
  b32[15] = 1797285236;
  $bound_check(seed, 0);
  $bound_check(b32, 16);
  b32[16] = seed[0];
  $bound_check(seed, 0);
  $bound_check(b32, 17);
  b32[17] = seed[0];
  $bound_check(seed, 0);
  $bound_check(b32, 18);
  b32[18] = seed[0];
  $bound_check(seed, 0);
  $bound_check(b32, 19);
  b32[19] = seed[0];
  $bound_check(seed, 1);
  $bound_check(b32, 20);
  b32[20] = seed[1];
  $bound_check(seed, 1);
  $bound_check(b32, 21);
  b32[21] = seed[1];
  $bound_check(seed, 1);
  $bound_check(b32, 22);
  b32[22] = seed[1];
  $bound_check(seed, 1);
  $bound_check(b32, 23);
  b32[23] = seed[1];
  $bound_check(seed, 2);
  $bound_check(b32, 24);
  b32[24] = seed[2];
  $bound_check(seed, 2);
  $bound_check(b32, 25);
  b32[25] = seed[2];
  $bound_check(seed, 2);
  $bound_check(b32, 26);
  b32[26] = seed[2];
  $bound_check(seed, 2);
  $bound_check(b32, 27);
  b32[27] = seed[2];
  $bound_check(seed, 3);
  $bound_check(b32, 28);
  b32[28] = seed[3];
  $bound_check(seed, 3);
  $bound_check(b32, 29);
  b32[29] = seed[3];
  $bound_check(seed, 3);
  $bound_check(b32, 30);
  b32[30] = seed[3];
  $bound_check(seed, 3);
  $bound_check(b32, 31);
  b32[31] = seed[3];
  $bound_check(seed, 4);
  $bound_check(b32, 32);
  b32[32] = seed[4];
  $bound_check(seed, 4);
  $bound_check(b32, 33);
  b32[33] = seed[4];
  $bound_check(seed, 4);
  $bound_check(b32, 34);
  b32[34] = seed[4];
  $bound_check(seed, 4);
  $bound_check(b32, 35);
  b32[35] = seed[4];
  $bound_check(seed, 5);
  $bound_check(b32, 36);
  b32[36] = seed[5];
  $bound_check(seed, 5);
  $bound_check(b32, 37);
  b32[37] = seed[5];
  $bound_check(seed, 5);
  $bound_check(b32, 38);
  b32[38] = seed[5];
  $bound_check(seed, 5);
  $bound_check(b32, 39);
  b32[39] = seed[5];
  $bound_check(seed, 6);
  $bound_check(b32, 40);
  b32[40] = seed[6];
  $bound_check(seed, 6);
  $bound_check(b32, 41);
  b32[41] = seed[6];
  $bound_check(seed, 6);
  $bound_check(b32, 42);
  b32[42] = seed[6];
  $bound_check(seed, 6);
  $bound_check(b32, 43);
  b32[43] = seed[6];
  $bound_check(seed, 7);
  $bound_check(b32, 44);
  b32[44] = seed[7];
  $bound_check(seed, 7);
  $bound_check(b32, 45);
  b32[45] = seed[7];
  $bound_check(seed, 7);
  $bound_check(b32, 46);
  b32[46] = seed[7];
  $bound_check(seed, 7);
  $bound_check(b32, 47);
  b32[47] = seed[7];
  $bound_check(b32, 48);
  b32[48] = counter;
  $bound_check(b32, 49);
  b32[49] = (counter >>> 0) + (1 >>> 0) | 0;
  $bound_check(b32, 50);
  b32[50] = (counter >>> 0) + (2 >>> 0) | 0;
  $bound_check(b32, 51);
  b32[51] = (counter >>> 0) + (3 >>> 0) | 0;
  $bound_check(b32, 52);
  b32[52] = 0;
  $bound_check(b32, 53);
  b32[53] = 0;
  $bound_check(b32, 54);
  b32[54] = 0;
  $bound_check(b32, 55);
  b32[55] = 0;
  $bound_check(b32, 56);
  b32[56] = 0;
  $bound_check(b32, 57);
  b32[57] = 0;
  $bound_check(b32, 58);
  b32[58] = 0;
  $bound_check(b32, 59);
  b32[59] = 0;
  $bound_check(b32, 60);
  b32[60] = 0;
  $bound_check(b32, 61);
  b32[61] = 0;
  $bound_check(b32, 62);
  b32[62] = 0;
  $bound_check(b32, 63);
  b32[63] = 0;
}
function moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35(t) {
  const _a = t._0;
  const _b = t._1;
  const _c = t._2;
  const _d = t._3;
  const a = (_a >>> 0) + (_b >>> 0) | 0;
  const d = _d ^ a;
  const d$2 = d << 16 | (d >>> 16 | 0);
  const c = (_c >>> 0) + (d$2 >>> 0) | 0;
  const b = _b ^ c;
  const b$2 = b << 12 | (b >>> 20 | 0);
  const a$2 = (a >>> 0) + (b$2 >>> 0) | 0;
  const d$3 = d$2 ^ a$2;
  const d$4 = d$3 << 8 | (d$3 >>> 24 | 0);
  const c$2 = (c >>> 0) + (d$4 >>> 0) | 0;
  const b$3 = b$2 ^ c$2;
  const b$4 = b$3 << 7 | (b$3 >>> 25 | 0);
  return { _0: a$2, _1: b$4, _2: c$2, _3: d$4 };
}
function moonbitlang$core$random$internal$random_source$$chacha_block(seed, buf, counter) {
  moonbitlang$core$random$internal$random_source$$setup(seed, buf, counter);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 4) {
      $bound_check(buf, i);
      let b0 = buf[i];
      const _tmp$2 = 4 + i | 0;
      $bound_check(buf, _tmp$2);
      let b1 = buf[_tmp$2];
      const _tmp$3 = 8 + i | 0;
      $bound_check(buf, _tmp$3);
      let b2 = buf[_tmp$3];
      const _tmp$4 = 12 + i | 0;
      $bound_check(buf, _tmp$4);
      let b3 = buf[_tmp$4];
      const _tmp$5 = 16 + i | 0;
      $bound_check(buf, _tmp$5);
      let b4 = buf[_tmp$5];
      const _tmp$6 = 20 + i | 0;
      $bound_check(buf, _tmp$6);
      let b5 = buf[_tmp$6];
      const _tmp$7 = 24 + i | 0;
      $bound_check(buf, _tmp$7);
      let b6 = buf[_tmp$7];
      const _tmp$8 = 28 + i | 0;
      $bound_check(buf, _tmp$8);
      let b7 = buf[_tmp$8];
      const _tmp$9 = 32 + i | 0;
      $bound_check(buf, _tmp$9);
      let b8 = buf[_tmp$9];
      const _tmp$10 = 36 + i | 0;
      $bound_check(buf, _tmp$10);
      let b9 = buf[_tmp$10];
      const _tmp$11 = 40 + i | 0;
      $bound_check(buf, _tmp$11);
      let b10 = buf[_tmp$11];
      const _tmp$12 = 44 + i | 0;
      $bound_check(buf, _tmp$12);
      let b11 = buf[_tmp$12];
      const _tmp$13 = 48 + i | 0;
      $bound_check(buf, _tmp$13);
      let b12 = buf[_tmp$13];
      const _tmp$14 = 52 + i | 0;
      $bound_check(buf, _tmp$14);
      let b13 = buf[_tmp$14];
      const _tmp$15 = 56 + i | 0;
      $bound_check(buf, _tmp$15);
      let b14 = buf[_tmp$15];
      const _tmp$16 = 60 + i | 0;
      $bound_check(buf, _tmp$16);
      let b15 = buf[_tmp$16];
      let _tmp$17 = 0;
      while (true) {
        const round = _tmp$17;
        if (round < 4) {
          const _bind$8 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b0, _1: b4, _2: b8, _3: b12 });
          const _tb1_0 = _bind$8._0;
          const _tb1_1 = _bind$8._1;
          const _tb1_2 = _bind$8._2;
          const _tb1_3 = _bind$8._3;
          b0 = _tb1_0;
          b4 = _tb1_1;
          b8 = _tb1_2;
          b12 = _tb1_3;
          const _bind$9 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b1, _1: b5, _2: b9, _3: b13 });
          const _tb2_0 = _bind$9._0;
          const _tb2_1 = _bind$9._1;
          const _tb2_2 = _bind$9._2;
          const _tb2_3 = _bind$9._3;
          b1 = _tb2_0;
          b5 = _tb2_1;
          b9 = _tb2_2;
          b13 = _tb2_3;
          const _bind$10 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b2, _1: b6, _2: b10, _3: b14 });
          const _tb3_0 = _bind$10._0;
          const _tb3_1 = _bind$10._1;
          const _tb3_2 = _bind$10._2;
          const _tb3_3 = _bind$10._3;
          b2 = _tb3_0;
          b6 = _tb3_1;
          b10 = _tb3_2;
          b14 = _tb3_3;
          const _bind$11 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b3, _1: b7, _2: b11, _3: b15 });
          const _tb4_0 = _bind$11._0;
          const _tb4_1 = _bind$11._1;
          const _tb4_2 = _bind$11._2;
          const _tb4_3 = _bind$11._3;
          b3 = _tb4_0;
          b7 = _tb4_1;
          b11 = _tb4_2;
          b15 = _tb4_3;
          const _bind$12 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b0, _1: b5, _2: b10, _3: b15 });
          const _tb5_0 = _bind$12._0;
          const _tb5_1 = _bind$12._1;
          const _tb5_2 = _bind$12._2;
          const _tb5_3 = _bind$12._3;
          b0 = _tb5_0;
          b5 = _tb5_1;
          b10 = _tb5_2;
          b15 = _tb5_3;
          const _bind$13 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b1, _1: b6, _2: b11, _3: b12 });
          const _tb6_0 = _bind$13._0;
          const _tb6_1 = _bind$13._1;
          const _tb6_2 = _bind$13._2;
          const _tb6_3 = _bind$13._3;
          b1 = _tb6_0;
          b6 = _tb6_1;
          b11 = _tb6_2;
          b12 = _tb6_3;
          const _bind$14 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b2, _1: b7, _2: b8, _3: b13 });
          const _tb7_0 = _bind$14._0;
          const _tb7_1 = _bind$14._1;
          const _tb7_2 = _bind$14._2;
          const _tb7_3 = _bind$14._3;
          b2 = _tb7_0;
          b7 = _tb7_1;
          b8 = _tb7_2;
          b13 = _tb7_3;
          const _bind$15 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b3, _1: b4, _2: b9, _3: b14 });
          const _tb8_0 = _bind$15._0;
          const _tb8_1 = _bind$15._1;
          const _tb8_2 = _bind$15._2;
          const _tb8_3 = _bind$15._3;
          b3 = _tb8_0;
          b4 = _tb8_1;
          b9 = _tb8_2;
          b14 = _tb8_3;
          _tmp$17 = round + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      $bound_check(buf, i);
      buf[i] = b0;
      const _tmp$18 = 4 + i | 0;
      $bound_check(buf, _tmp$18);
      buf[_tmp$18] = b1;
      const _tmp$19 = 8 + i | 0;
      $bound_check(buf, _tmp$19);
      buf[_tmp$19] = b2;
      const _tmp$20 = 12 + i | 0;
      $bound_check(buf, _tmp$20);
      buf[_tmp$20] = b3;
      const _index_2 = 16 + i | 0;
      $bound_check(buf, _index_2);
      $bound_check(buf, _index_2);
      buf[_index_2] = (buf[_index_2] >>> 0) + (b4 >>> 0) | 0;
      const _index_4 = 20 + i | 0;
      $bound_check(buf, _index_4);
      $bound_check(buf, _index_4);
      buf[_index_4] = (buf[_index_4] >>> 0) + (b5 >>> 0) | 0;
      const _index_6 = 24 + i | 0;
      $bound_check(buf, _index_6);
      $bound_check(buf, _index_6);
      buf[_index_6] = (buf[_index_6] >>> 0) + (b6 >>> 0) | 0;
      const _index_8 = 28 + i | 0;
      $bound_check(buf, _index_8);
      $bound_check(buf, _index_8);
      buf[_index_8] = (buf[_index_8] >>> 0) + (b7 >>> 0) | 0;
      const _index_10 = 32 + i | 0;
      $bound_check(buf, _index_10);
      $bound_check(buf, _index_10);
      buf[_index_10] = (buf[_index_10] >>> 0) + (b8 >>> 0) | 0;
      const _index_12 = 36 + i | 0;
      $bound_check(buf, _index_12);
      $bound_check(buf, _index_12);
      buf[_index_12] = (buf[_index_12] >>> 0) + (b9 >>> 0) | 0;
      const _index_14 = 40 + i | 0;
      $bound_check(buf, _index_14);
      $bound_check(buf, _index_14);
      buf[_index_14] = (buf[_index_14] >>> 0) + (b10 >>> 0) | 0;
      const _index_16 = 44 + i | 0;
      $bound_check(buf, _index_16);
      $bound_check(buf, _index_16);
      buf[_index_16] = (buf[_index_16] >>> 0) + (b11 >>> 0) | 0;
      const _tmp$21 = 48 + i | 0;
      $bound_check(buf, _tmp$21);
      buf[_tmp$21] = b12;
      const _tmp$22 = 52 + i | 0;
      $bound_check(buf, _tmp$22);
      buf[_tmp$22] = b13;
      const _tmp$23 = 56 + i | 0;
      $bound_check(buf, _tmp$23);
      buf[_tmp$23] = b14;
      const _tmp$24 = 60 + i | 0;
      $bound_check(buf, _tmp$24);
      buf[_tmp$24] = b15;
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$random$internal$random_source$$ChaCha8$new(seed) {
  const seed$2 = moonbitlang$core$array$$FixedArray$makei$38$(8, (i) => {
    const _bind$8 = moonbitlang$core$bytes$$Bytes$sub$46$inner(seed, Math.imul(i, 4) | 0, undefined);
    return (_bind$8.end - _bind$8.start | 0) >= 4 ? moonbitlang$core$bytes$$BytesView$unsafe_extract_uint_le(_bind$8, 0, 32) : moonbitlang$core$abort$$abort$28$("seed must be 32 bytes long");
  });
  const buffer = $make_array_len_and_init(64, 0);
  moonbitlang$core$random$internal$random_source$$chacha_block(seed$2, buffer, 0);
  const _bind$8 = 32;
  return { buffer: buffer, seed: seed$2, i: 0, n: _bind$8, counter: 0 };
}
function moonbitlang$core$random$internal$random_source$$ChaCha8$next(self) {
  const i = self.i;
  if (i >>> 0 >= self.n >>> 0) {
    return undefined;
  }
  self.i = (i >>> 0) + (1 >>> 0) | 0;
  const index = i & 31;
  const _tmp = self.buffer;
  const _tmp$2 = Math.imul(index, 2) | 0;
  $bound_check(_tmp, _tmp$2);
  const lo = moonbitlang$core$uint$$UInt$to_uint64(_tmp[_tmp$2]);
  const _tmp$3 = self.buffer;
  const _tmp$4 = (Math.imul(index, 2) | 0) + 1 | 0;
  $bound_check(_tmp$3, _tmp$4);
  const hi = moonbitlang$core$uint$$UInt$to_uint64(_tmp$3[_tmp$4]);
  return moonbitlang$core$builtin$$BitOr$lor$36$(moonbitlang$core$builtin$$Shl$shl$36$(hi, 32), lo);
}
function moonbitlang$core$random$internal$random_source$$ChaCha8$refill(self) {
  self.counter = (self.counter >>> 0) + (4 >>> 0) | 0;
  if (self.counter === 16) {
    moonbitlang$core$array$$FixedArray$blit_to$46$inner$28$(self.buffer, self.seed, 8, 56, 0);
    self.counter = 0;
  }
  moonbitlang$core$random$internal$random_source$$chacha_block(self.seed, self.buffer, self.counter);
  self.i = 0;
  self.n = self.counter === 12 ? 28 : 32;
}
function moonbitlang$core$array$$Array$sort_by_key$39$(self, map) {
  moonbitlang$core$array$$MutArrayView$sort_by_key$39$(moonbitlang$core$array$$Array$mut_view$46$inner$27$(self, 0, undefined), map);
}
function moonbitlang$core$array$$Array$sort_by$29$(self, cmp) {
  moonbitlang$core$array$$MutArrayView$sort_by$29$(moonbitlang$core$array$$Array$mut_view$46$inner$29$(self, 0, undefined), cmp);
}
function moonbitlang$core$double$$Double$to_uint(self) {
  return self !== self ? 0 : self >= 4294967295 ? -1 : self <= 0 ? 0 : self | 0;
}
function moonbitlang$core$array$$FixedArray$unsafe_blit$28$(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        $bound_check(src, _tmp$3);
        $bound_check(dst, _tmp$2);
        dst[_tmp$2] = src[_tmp$3];
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    while (true) {
      const i = _tmp;
      if (i >= 0) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        $bound_check(src, _tmp$3);
        $bound_check(dst, _tmp$2);
        dst[_tmp$2] = src[_tmp$3];
        _tmp = i - 1 | 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function moonbitlang$core$builtin$$StringBuilder$new$46$inner(size_hint) {
  return { val: "" };
}
function moonbitlang$core$builtin$$Logger$write_char$40$(self, ch) {
  const _bind$8 = self;
  _bind$8.val = `${_bind$8.val}${String.fromCodePoint(ch)}`;
}
function moonbitlang$core$builtin$$op_notequal$41$(x, y) {
  return !moonbitlang$core$builtin$$Eq$equal$41$(x, y);
}
function moonbitlang$core$builtin$$op_notequal$3$(x, y) {
  return !(x === y);
}
function moonbitlang$core$array$$Array$at$42$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$43$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$44$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$22$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$45$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$46$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$41$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$3$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$47$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$builtin$$Logger$write_string$40$(self, str) {
  const _bind$8 = self;
  _bind$8.val = `${_bind$8.val}${str}`;
}
function moonbitlang$core$builtin$$Hasher$consume4(self, input) {
  const _p = (self.acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
  const _p$2 = 17;
  self.acc = Math.imul(_p << _p$2 | (_p >>> (32 - _p$2 | 0) | 0), 668265263) | 0;
}
function moonbitlang$core$builtin$$Hasher$combine_uint(self, value) {
  self.acc = (self.acc >>> 0) + (4 >>> 0) | 0;
  moonbitlang$core$builtin$$Hasher$consume4(self, value);
}
function moonbitlang$core$builtin$$Hasher$combine_int(self, value) {
  moonbitlang$core$builtin$$Hasher$combine_uint(self, value);
}
function moonbitlang$core$builtin$$Hasher$combine$3$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$3$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$18$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$18$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$41$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$41$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$48$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$48$(value, self);
}
function moonbitlang$core$builtin$$Compare$op_lt$37$(x, y) {
  return moonbitlang$core$builtin$$Compare$compare$36$(x, y) < 0;
}
function moonbitlang$core$builtin$$Hasher$avalanche(self) {
  let acc = self.acc;
  acc = acc ^ (acc >>> 15 | 0);
  acc = Math.imul(acc, -2048144777) | 0;
  acc = acc ^ (acc >>> 13 | 0);
  acc = Math.imul(acc, -1028477379) | 0;
  acc = acc ^ (acc >>> 16 | 0);
  return acc;
}
function moonbitlang$core$builtin$$Hasher$finalize(self) {
  return moonbitlang$core$builtin$$Hasher$avalanche(self);
}
function moonbitlang$core$builtin$$Hasher$new$46$inner(seed) {
  return { acc: (seed >>> 0) + (374761393 >>> 0) | 0 };
}
function moonbitlang$core$builtin$$Hasher$new(seed$46$opt) {
  let seed;
  if (seed$46$opt === undefined) {
    seed = moonbitlang$core$builtin$$seed;
  } else {
    const _Some = seed$46$opt;
    seed = _Some;
  }
  return moonbitlang$core$builtin$$Hasher$new$46$inner(seed);
}
function moonbitlang$core$builtin$$Hash$hash$32$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$3$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$33$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$18$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$49$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$41$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$50$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$48$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$string$$String$sub$46$inner(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end < 0 ? len + _end | 0 : _end;
  }
  const start$2 = start < 0 ? len + start | 0 : start;
  if (start$2 >= 0 && (start$2 <= end$2 && end$2 <= len)) {
    let _tmp;
    if (start$2 < len) {
      const _p = self.charCodeAt(start$2);
      _tmp = 56320 <= _p && _p <= 57343;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      return new Result$Err$3$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex);
    }
    let _tmp$2;
    if (end$2 < len) {
      const _p = self.charCodeAt(end$2);
      _tmp$2 = 56320 <= _p && _p <= 57343;
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      return new Result$Err$3$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex);
    }
    return new Result$Ok$3$({ str: self, start: start$2, end: end$2 });
  } else {
    return new Result$Err$3$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$IndexOutOfBounds);
  }
}
function moonbitlang$core$builtin$$Logger$write_substring$51$(self, value, start, len) {
  let _tmp;
  let _try_err;
  _L: {
    _L$2: {
      const _bind$8 = moonbitlang$core$string$$String$sub$46$inner(value, start, start + len | 0);
      if (_bind$8.$tag === 1) {
        const _ok = _bind$8;
        _tmp = _ok._0;
      } else {
        const _err = _bind$8;
        const _tmp$2 = _err._0;
        _try_err = _tmp$2;
        break _L$2;
      }
      break _L;
    }
    _tmp = $panic();
  }
  moonbitlang$core$builtin$$Logger$write_view$40$(self, _tmp);
}
function moonbitlang$core$builtin$$Show$to_string$52$(self) {
  const logger = moonbitlang$core$builtin$$StringBuilder$new$46$inner(0);
  moonbitlang$core$builtin$$Show$output$15$(self, { self: logger, method_0: moonbitlang$core$builtin$$Logger$write_string$40$, method_1: moonbitlang$core$builtin$$Logger$write_substring$51$, method_2: moonbitlang$core$builtin$$Logger$write_view$40$, method_3: moonbitlang$core$builtin$$Logger$write_char$40$ });
  return logger.val;
}
function moonbitlang$core$int$$Int$to_string$46$inner(self, radix) {
  return moonbitlang$core$builtin$$int_to_string_js(self, radix);
}
function moonbitlang$core$builtin$$Show$to_string$53$(self) {
  return self.str.substring(self.start, self.end);
}
function moonbitlang$core$builtin$$Logger$write_view$40$(self, str) {
  const _bind$8 = self;
  _bind$8.val = `${_bind$8.val}${moonbitlang$core$builtin$$Show$to_string$53$(str)}`;
}
function moonbitlang$core$array$$Array$new$46$inner$11$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$new$46$inner$10$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$new$46$inner$54$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$push$27$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$55$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$56$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$57$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$58$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$22$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$19$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$29$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$10$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$44$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$41$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$59$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$45$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$3$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$60$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$11$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$15$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$54$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$46$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$47$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$builtin$$Iterator$next$18$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$3$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$61$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$62$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$63$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$64$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Show$output$15$(self, logger) {
  logger.method_0(logger.self, moonbitlang$core$int$$Int$to_string$46$inner(self, 10));
}
function moonbitlang$core$array$$FixedArray$makei$38$(length, value) {
  if (length <= 0) {
    return [];
  } else {
    const array = $make_array_len_and_init(length, value(0));
    let _tmp = 1;
    while (true) {
      const i = _tmp;
      if (i < length) {
        $bound_check(array, i);
        array[i] = value(i);
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return array;
  }
}
function moonbitlang$core$option$$Option$unwrap$65$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$66$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$67$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$68$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$69$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap_or$22$(self, default_) {
  if (self.$tag === 0) {
    return default_;
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap_or_default$43$(self) {
  if (self === undefined) {
    return moonbitlang$core$builtin$$Default$default$43$();
  } else {
    const _Some = self;
    return _Some;
  }
}
function moonbitlang$core$option$$Option$map_or$70$(self, default_, f) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _x = _Some;
    return f(_x);
  }
}
function moonbitlang$core$option$$Option$map_or$71$(self, default_, f) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _x = _Some;
    return f(_x);
  }
}
function moonbitlang$core$array$$MutArrayView$at$27$(self, index) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    return _tmp[_tmp$2];
  } else {
    return moonbitlang$core$abort$$abort$27$(`index out of bounds: the len is from 0 to ${moonbitlang$core$builtin$$Show$to_string$52$(self.end - self.start | 0)} but the index is ${moonbitlang$core$builtin$$Show$to_string$52$(index)}`);
  }
}
function moonbitlang$core$array$$MutArrayView$at$29$(self, index) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    return _tmp[_tmp$2];
  } else {
    return moonbitlang$core$abort$$abort$29$(`index out of bounds: the len is from 0 to ${moonbitlang$core$builtin$$Show$to_string$52$(self.end - self.start | 0)} but the index is ${moonbitlang$core$builtin$$Show$to_string$52$(index)}`);
  }
}
function moonbitlang$core$array$$MutArrayView$set$27$(self, index, value) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    _tmp[_tmp$2] = value;
    return;
  } else {
    moonbitlang$core$abort$$abort$25$(`index out of bounds: the len is from 0 to ${moonbitlang$core$builtin$$Show$to_string$52$(self.end - self.start | 0)} but the index is ${moonbitlang$core$builtin$$Show$to_string$52$(index)}`);
    return;
  }
}
function moonbitlang$core$array$$MutArrayView$set$29$(self, index, value) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    _tmp[_tmp$2] = value;
    return;
  } else {
    moonbitlang$core$abort$$abort$25$(`index out of bounds: the len is from 0 to ${moonbitlang$core$builtin$$Show$to_string$52$(self.end - self.start | 0)} but the index is ${moonbitlang$core$builtin$$Show$to_string$52$(index)}`);
    return;
  }
}
function moonbitlang$core$array$$Array$mut_view$46$inner$27$(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end < 0 ? len + _end | 0 : _end;
  }
  const start$2 = start < 0 ? len + start | 0 : start;
  return start$2 >= 0 && (start$2 <= end$2 && end$2 <= len) ? { buf: self, start: start$2, end: end$2 } : moonbitlang$core$abort$$abort$24$("View index out of bounds");
}
function moonbitlang$core$array$$Array$mut_view$46$inner$29$(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end < 0 ? len + _end | 0 : _end;
  }
  const start$2 = start < 0 ? len + start | 0 : start;
  return start$2 >= 0 && (start$2 <= end$2 && end$2 <= len) ? { buf: self, start: start$2, end: end$2 } : moonbitlang$core$abort$$abort$26$("View index out of bounds");
}
function moonbitlang$core$array$$MutArrayView$mut_view$46$inner$27$(self, start, end) {
  const len = self.end - self.start | 0;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end < 0 ? len + _end | 0 : _end;
  }
  const start$2 = start < 0 ? len + start | 0 : start;
  return start$2 >= 0 && (start$2 <= end$2 && end$2 <= len) ? { buf: self.buf, start: self.start + start$2 | 0, end: (self.start + start$2 | 0) + (end$2 - start$2 | 0) | 0 } : moonbitlang$core$abort$$abort$24$("View index out of bounds");
}
function moonbitlang$core$array$$MutArrayView$mut_view$46$inner$29$(self, start, end) {
  const len = self.end - self.start | 0;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end < 0 ? len + _end | 0 : _end;
  }
  const start$2 = start < 0 ? len + start | 0 : start;
  return start$2 >= 0 && (start$2 <= end$2 && end$2 <= len) ? { buf: self.buf, start: self.start + start$2 | 0, end: (self.start + start$2 | 0) + (end$2 - start$2 | 0) | 0 } : moonbitlang$core$abort$$abort$26$("View index out of bounds");
}
function moonbitlang$core$array$$ArrayView$at$19$(self, index) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    return _tmp[_tmp$2];
  } else {
    return moonbitlang$core$abort$$abort$19$(`index out of bounds: the len is from 0 to ${moonbitlang$core$builtin$$Show$to_string$52$(self.end - self.start | 0)} but the index is ${moonbitlang$core$builtin$$Show$to_string$52$(index)}`);
  }
}
function moonbitlang$core$int$$Int$next_power_of_two(self) {
  if (self >= 0) {
    if (self <= 1) {
      return 1;
    }
    if (self > 1073741824) {
      return 1073741824;
    }
    return (2147483647 >> (Math.clz32(self - 1 | 0) - 1 | 0)) + 1 | 0;
  } else {
    return $panic();
  }
}
function moonbitlang$core$builtin$$Map$new$46$inner$2$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$0$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$1$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$14$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$4$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$20$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$17$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$5$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$7$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$13$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$12$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$6$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$16$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$9$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$8$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$21$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$2$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$0$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$1$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$14$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$6$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$12$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$17$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$5$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$4$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$13$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$9$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$7$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$16$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$8$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$20$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$21$(self, idx, entry) {
  const _bind$8 = self.tail;
  if (_bind$8 === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    $bound_check(_tmp, _bind$8);
    const _p = _tmp[_bind$8];
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  const _tmp = self.entries;
  $bound_check(_tmp, idx);
  _tmp[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$set_entry$2$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$0$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$1$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$14$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$6$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$12$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$17$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$5$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$4$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$13$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$9$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$7$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$16$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$8$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$20$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$21$(self, entry, new_idx) {
  const _tmp = self.entries;
  $bound_check(_tmp, new_idx);
  _tmp[new_idx] = entry;
  const _bind$8 = entry.next;
  if (_bind$8 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$8;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$push_away$2$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$2$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$2$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$0$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$0$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$0$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$1$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$1$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$1$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$14$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$14$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$14$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$6$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$6$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$6$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$12$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$12$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$12$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$17$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$17$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$17$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$5$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$5$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$5$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$4$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$4$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$4$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$13$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$13$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$13$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$9$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$9$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$9$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$7$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$7$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$7$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$16$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$16$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$16$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$8$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$8$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$8$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$20$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$20$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$20$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$21$(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx$2);
    const _bind$8 = _tmp$4[idx$2];
    if (_bind$8 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$21$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$21$(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$set_with_hash$2$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$2$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$2$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$2$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$0$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$0$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$0$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$0$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$1$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$1$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$1$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$1$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$14$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$14$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$14$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$14$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$6$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$6$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$6$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$6$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$12$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$12$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$12$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$12$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$17$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$17$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$17$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$17$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$5$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$5$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$5$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$5$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$4$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$4$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$4$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$4$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$13$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$13$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$13$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$13$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$7$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$7$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$7$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$7$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$16$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$16$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$41$(_curr_entry.key, key)) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$16$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$16$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$9$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$9$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$9$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$9$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$8$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$8$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$8$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$8$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$20$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$20$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      let _tmp$4;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$20$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$20$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$21$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$21$(self);
  }
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      _bind$8 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$9;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$21$(self, idx, _curr_entry);
        _bind$8 = { _0: idx, _1: psl };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _bind$9 = self.tail;
  const _bind$10 = undefined;
  const entry = { prev: _bind$9, next: _bind$10, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$21$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$grow$2$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$2$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$0$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$0$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$1$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$1$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$14$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$14$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$6$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$6$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$12$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$12$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$17$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$17$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$5$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$5$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$4$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$4$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$13$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$13$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$9$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$9$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$7$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$7$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$16$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$16$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$8$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$8$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$20$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$20$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$21$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$21$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$set$2$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$2$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$0$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$0$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$1$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$1$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$14$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$14$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$6$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$6$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$12$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$12$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$17$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$17$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$5$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$5$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$4$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$4$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$13$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$13$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$7$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$7$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$16$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$16$(self, key, value, moonbitlang$core$builtin$$Hash$hash$49$(key));
}
function moonbitlang$core$builtin$$Map$set$8$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$8$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$20$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$20$(self, key, value, moonbitlang$core$builtin$$Hash$hash$32$(key));
}
function moonbitlang$core$builtin$$Map$set$21$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$21$(self, key, value, moonbitlang$core$builtin$$Hash$hash$50$(key));
}
function moonbitlang$core$builtin$$Map$get$0$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$17$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$1$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return -1;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return -1;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$7$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$5$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$13$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$12$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$6$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$16$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$49$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      if (_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$41$(_entry.key, key)) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$2$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$9$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$4$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$8$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$20$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return Option$None$4$;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return new Option$Some$4$(_entry.value);
      }
      if (i > _entry.psl) {
        return Option$None$4$;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$21$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$50$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return Option$None$5$;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return new Option$Some$5$(_entry.value);
      }
      if (i > _entry.psl) {
        return Option$None$5$;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get_or_init$9$(self, key, default_) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _bind$8;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$9 = _tmp$3[idx];
    if (_bind$9 === undefined) {
      const new_value = default_();
      _bind$8 = { _0: idx, _1: psl, _2: new_value, _3: undefined };
      break;
    } else {
      const _Some = _bind$9;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return _entry.value;
      }
      if (psl > _entry.psl) {
        const new_value = default_();
        _bind$8 = { _0: idx, _1: psl, _2: new_value, _3: _entry };
        break;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$8._0;
  const _psl = _bind$8._1;
  const _new_value = _bind$8._2;
  const _push_away = _bind$8._3;
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$9$(self);
    moonbitlang$core$builtin$$Map$set_with_hash$9$(self, key, _new_value, hash);
  } else {
    if (_push_away === undefined) {
    } else {
      const _Some = _push_away;
      const _entry = _Some;
      moonbitlang$core$builtin$$Map$push_away$9$(self, _idx, _entry);
    }
    const entry = { prev: self.tail, next: undefined, psl: _psl, hash: hash, key: key, value: _new_value };
    moonbitlang$core$builtin$$Map$add_entry_to_tail$9$(self, _idx, entry);
  }
  return _new_value;
}
function moonbitlang$core$builtin$$Map$contains$8$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$32$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return false;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$array$$FixedArray$fill$46$inner$72$(self, value, start, end) {
  const array_length = self.length;
  if (array_length > 0) {
    if (start >= 0 && start < array_length) {
      let length;
      if (end === undefined) {
        length = array_length - start | 0;
      } else {
        const _Some = end;
        const _e = _Some;
        length = _e >= start && _e <= array_length ? _e - start | 0 : $panic();
      }
      self.fill(value, start, start + length);
      return;
    } else {
      $panic();
      return;
    }
  } else {
    return;
  }
}
function moonbitlang$core$array$$FixedArray$fill$46$inner$34$(self, value, start, end) {
  const array_length = self.length;
  if (array_length > 0) {
    if (start >= 0 && start < array_length) {
      let length;
      if (end === undefined) {
        length = array_length - start | 0;
      } else {
        const _Some = end;
        const _e = _Some;
        length = _e >= start && _e <= array_length ? _e - start | 0 : $panic();
      }
      self.fill(value, start, start + length);
      return;
    } else {
      $panic();
      return;
    }
  } else {
    return;
  }
}
function moonbitlang$core$array$$FixedArray$fill$46$inner$73$(self, value, start, end) {
  const array_length = self.length;
  if (array_length > 0) {
    if (start >= 0 && start < array_length) {
      let length;
      if (end === undefined) {
        length = array_length - start | 0;
      } else {
        const _Some = end;
        const _e = _Some;
        length = _e >= start && _e <= array_length ? _e - start | 0 : $panic();
      }
      self.fill(value, start, start + length);
      return;
    } else {
      $panic();
      return;
    }
  } else {
    return;
  }
}
function moonbitlang$core$builtin$$Map$clear$20$(self) {
  moonbitlang$core$array$$FixedArray$fill$46$inner$72$(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function moonbitlang$core$builtin$$Map$clear$4$(self) {
  moonbitlang$core$array$$FixedArray$fill$46$inner$73$(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function moonbitlang$core$builtin$$Map$iter$9$(self) {
  const _p = (yield_) => {
    let _tmp = self.head;
    while (true) {
      const _param = _tmp;
      if (_param === undefined) {
        return 1;
      } else {
        const _Some = _param;
        const _x = _Some;
        const _key = _x.key;
        const _value = _x.value;
        const _next = _x.next;
        const _bind$8 = yield_({ _0: _key, _1: _value });
        if (_bind$8 === 1) {
          _tmp = _next;
          continue;
        } else {
          return 0;
        }
      }
    }
  };
  return _p;
}
function moonbitlang$core$builtin$$Map$iterator$4$(self) {
  const curr_entry = { val: self.head };
  const _p = () => {
    const _bind$8 = curr_entry.val;
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _key = _x.key;
      const _value = _x.value;
      const _next = _x.next;
      curr_entry.val = _next;
      return { _0: _key, _1: _value };
    }
  };
  return _p;
}
function moonbitlang$core$builtin$$Map$iterator$14$(self) {
  const curr_entry = { val: self.head };
  const _p = () => {
    const _bind$8 = curr_entry.val;
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _key = _x.key;
      const _value = _x.value;
      const _next = _x.next;
      curr_entry.val = _next;
      return { _0: _key, _1: _value };
    }
  };
  return _p;
}
function moonbitlang$core$builtin$$Map$iterator$5$(self) {
  const curr_entry = { val: self.head };
  const _p = () => {
    const _bind$8 = curr_entry.val;
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _key = _x.key;
      const _value = _x.value;
      const _next = _x.next;
      curr_entry.val = _next;
      return { _0: _key, _1: _value };
    }
  };
  return _p;
}
function moonbitlang$core$builtin$$Map$iterator$1$(self) {
  const curr_entry = { val: self.head };
  const _p = () => {
    const _bind$8 = curr_entry.val;
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _key = _x.key;
      const _value = _x.value;
      const _next = _x.next;
      curr_entry.val = _next;
      return { _0: _key, _1: _value };
    }
  };
  return _p;
}
function moonbitlang$core$builtin$$Map$iterator2$4$(self) {
  return moonbitlang$core$builtin$$Map$iterator$4$(self);
}
function moonbitlang$core$builtin$$Map$iterator2$14$(self) {
  return moonbitlang$core$builtin$$Map$iterator$14$(self);
}
function moonbitlang$core$builtin$$Map$iterator2$5$(self) {
  return moonbitlang$core$builtin$$Map$iterator$5$(self);
}
function moonbitlang$core$builtin$$Map$iterator2$1$(self) {
  return moonbitlang$core$builtin$$Map$iterator$1$(self);
}
function moonbitlang$core$builtin$$Map$to_array$6$(self) {
  const arr = new Array(self.size);
  let i = 0;
  let _tmp = self.head;
  while (true) {
    const _param = _tmp;
    if (_param === undefined) {
      break;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _key = _x.key;
      const _value = _x.value;
      const _next = _x.next;
      arr[i] = { _0: _key, _1: _value };
      i = i + 1 | 0;
      _tmp = _next;
      continue;
    }
  }
  return arr;
}
function moonbitlang$core$builtin$$MyInt64$extend_i32_u(value) {
  return { hi: 0, lo: value };
}
function moonbitlang$core$uint64$$UInt64$extend_uint(value) {
  return moonbitlang$core$builtin$$MyInt64$extend_i32_u(value);
}
function moonbitlang$core$uint$$UInt$to_uint64(self) {
  return moonbitlang$core$uint64$$UInt64$extend_uint(self);
}
function moonbitlang$core$double$$Double$convert_uint64(value) {
  return moonbitlang$core$builtin$$MyInt64$convert_to_double_u(value);
}
function moonbitlang$core$builtin$$Iterator2$next$4$(self) {
  return moonbitlang$core$builtin$$Iterator$next$61$(self);
}
function moonbitlang$core$builtin$$Iterator2$next$14$(self) {
  return moonbitlang$core$builtin$$Iterator$next$62$(self);
}
function moonbitlang$core$builtin$$Iterator2$next$5$(self) {
  return moonbitlang$core$builtin$$Iterator$next$63$(self);
}
function moonbitlang$core$builtin$$Iterator2$next$1$(self) {
  return moonbitlang$core$builtin$$Iterator$next$64$(self);
}
function moonbitlang$core$uint64$$UInt64$to_int(self) {
  const _p = self;
  return _p.lo;
}
function moonbitlang$core$builtin$$MyInt64$add_hi_lo(self, bhi, blo) {
  const _ahi = self.hi;
  const _alo = self.lo;
  const lo = _alo + blo | 0;
  const s = lo >> 31;
  const as_ = _alo >> 31;
  const bs = blo >> 31;
  const c = (as_ & bs | ~s & (as_ ^ bs)) & 1;
  const hi = (_ahi + bhi | 0) + c | 0;
  return { hi: hi, lo: lo };
}
function moonbitlang$core$builtin$$Add$add$74$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$add_hi_lo(self, other.hi, other.lo);
}
function moonbitlang$core$builtin$$Sub$sub$74$(self, other) {
  return other.lo === 0 ? { hi: self.hi - other.hi | 0, lo: self.lo } : moonbitlang$core$builtin$$MyInt64$add_hi_lo(self, ~other.hi, ~other.lo + 1 | 0);
}
function moonbitlang$core$builtin$$Mul$mul$74$(self, other) {
  const _ahi = self.hi;
  const _alo = self.lo;
  const _bhi = other.hi;
  const _blo = other.lo;
  const ahi = _ahi;
  const alo = _alo;
  const bhi = _bhi;
  const blo = _blo;
  const a48 = ahi >>> 16 | 0;
  const a32 = ahi & 65535;
  const a16 = alo >>> 16 | 0;
  const a00 = alo & 65535;
  const b48 = bhi >>> 16 | 0;
  const b32 = bhi & 65535;
  const b16 = blo >>> 16 | 0;
  const b00 = blo & 65535;
  const c00 = Math.imul(a00, b00) | 0;
  const c16 = c00 >>> 16 | 0;
  const c00$2 = c00 & 65535;
  const c16$2 = (c16 >>> 0) + ((Math.imul(a16, b00) | 0) >>> 0) | 0;
  const c32 = c16$2 >>> 16 | 0;
  const c16$3 = c16$2 & 65535;
  const c16$4 = (c16$3 >>> 0) + ((Math.imul(a00, b16) | 0) >>> 0) | 0;
  const c32$2 = (c32 >>> 0) + ((c16$4 >>> 16 | 0) >>> 0) | 0;
  const c16$5 = c16$4 & 65535;
  const c32$3 = (c32$2 >>> 0) + ((Math.imul(a32, b00) | 0) >>> 0) | 0;
  const c48 = c32$3 >>> 16 | 0;
  const c32$4 = c32$3 & 65535;
  const c32$5 = (c32$4 >>> 0) + ((Math.imul(a16, b16) | 0) >>> 0) | 0;
  const c48$2 = (c48 >>> 0) + ((c32$5 >>> 16 | 0) >>> 0) | 0;
  const c32$6 = c32$5 & 65535;
  const c32$7 = (c32$6 >>> 0) + ((Math.imul(a00, b32) | 0) >>> 0) | 0;
  const c48$3 = (c48$2 >>> 0) + ((c32$7 >>> 16 | 0) >>> 0) | 0;
  const c32$8 = c32$7 & 65535;
  const c48$4 = (((((((c48$3 >>> 0) + ((Math.imul(a48, b00) | 0) >>> 0) | 0) >>> 0) + ((Math.imul(a32, b16) | 0) >>> 0) | 0) >>> 0) + ((Math.imul(a16, b32) | 0) >>> 0) | 0) >>> 0) + ((Math.imul(a00, b48) | 0) >>> 0) | 0;
  const c48$5 = c48$4 & 65535;
  return { hi: c48$5 << 16 | c32$8, lo: c16$5 << 16 | c00$2 };
}
function moonbitlang$core$builtin$$try_get_int64_wasm_helper() {
  if (moonbitlang$core$builtin$$wasm_helper_cache.tried) {
    const _bind$8 = moonbitlang$core$builtin$$wasm_helper_cache.exports;
    return !(_bind$8 === undefined);
  }
  moonbitlang$core$builtin$$wasm_helper_cache.tried = true;
  moonbitlang$core$builtin$$wasm_helper_cache.exports = moonbitlang$core$builtin$$try_init_wasm_helper();
  const _bind$8 = moonbitlang$core$builtin$$wasm_helper_cache.exports;
  return !(_bind$8 === undefined);
}
function moonbitlang$core$builtin$$MyInt64$mod_u(self, other) {
  if (!(other.hi === 0 && other.lo === 0)) {
    if (!moonbitlang$core$builtin$$try_get_int64_wasm_helper()) {
      return moonbitlang$core$builtin$$MyInt64$mod_u_bigint(self, other);
    }
    const _bind$8 = moonbitlang$core$builtin$$wasm_helper_cache.exports;
    if (_bind$8 === undefined) {
      return $panic();
    } else {
      const _Some = _bind$8;
      const _exports = _Some;
      const _ahi = self.hi;
      const _alo = self.lo;
      const _bhi = other.hi;
      const _blo = other.lo;
      const _func = _exports.rem_u;
      const lo = _func(_alo, _ahi, _blo, _bhi);
      const _func$2 = _exports.get_high;
      const hi = _func$2();
      return { hi: hi, lo: lo };
    }
  } else {
    return $panic();
  }
}
function moonbitlang$core$builtin$$MyInt64$lnot(self) {
  return { hi: ~self.hi, lo: ~self.lo };
}
function moonbitlang$core$builtin$$MyInt64$land(self, other) {
  return { hi: self.hi & other.hi, lo: self.lo & other.lo };
}
function moonbitlang$core$builtin$$MyInt64$lor(self, other) {
  return { hi: self.hi | other.hi, lo: self.lo | other.lo };
}
function moonbitlang$core$builtin$$MyInt64$lsl(self, shift) {
  const shift$2 = shift & 63;
  if (shift$2 === 0) {
    return self;
  } else {
    if (shift$2 < 32) {
      const _hi = self.hi;
      const _lo = self.lo;
      const hi = _hi;
      const lo = _lo;
      const hi$2 = hi << shift$2 | (lo >>> (32 - shift$2 | 0) | 0);
      const lo$2 = lo << shift$2;
      return { hi: hi$2, lo: lo$2 };
    } else {
      return { hi: self.lo << (shift$2 - 32 | 0), lo: 0 };
    }
  }
}
function moonbitlang$core$builtin$$MyInt64$lsr(self, shift) {
  const shift$2 = shift & 63;
  return shift$2 === 0 ? self : shift$2 < 32 ? { hi: self.hi >>> shift$2 | 0, lo: self.lo >>> shift$2 | self.hi << (32 - shift$2 | 0) } : { hi: 0, lo: self.hi >>> (shift$2 - 32 | 0) | 0 };
}
function moonbitlang$core$builtin$$Add$add$36$(self, other) {
  return moonbitlang$core$builtin$$Add$add$74$(self, other);
}
function moonbitlang$core$builtin$$Sub$sub$36$(self, other) {
  return moonbitlang$core$builtin$$Sub$sub$74$(self, other);
}
function moonbitlang$core$builtin$$Mul$mul$36$(self, other) {
  return moonbitlang$core$builtin$$Mul$mul$74$(self, other);
}
function moonbitlang$core$builtin$$Mod$mod$36$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$mod_u(self, other);
}
function moonbitlang$core$uint64$$UInt64$to_uint(self) {
  const _p = self;
  return _p.lo;
}
function moonbitlang$core$builtin$$Compare$compare$36$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$compare_u(self, other);
}
function moonbitlang$core$builtin$$Eq$equal$36$(self, other) {
  const _p = self;
  const _p$2 = other;
  return _p.hi === _p$2.hi && _p.lo === _p$2.lo;
}
function moonbitlang$core$builtin$$BitAnd$land$36$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$land(self, other);
}
function moonbitlang$core$builtin$$BitOr$lor$36$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$lor(self, other);
}
function moonbitlang$core$uint64$$UInt64$lnot(self) {
  return moonbitlang$core$builtin$$MyInt64$lnot(self);
}
function moonbitlang$core$builtin$$Shl$shl$36$(self, shift) {
  return moonbitlang$core$builtin$$MyInt64$lsl(self, shift);
}
function moonbitlang$core$builtin$$Shr$shr$36$(self, shift) {
  return moonbitlang$core$builtin$$MyInt64$lsr(self, shift);
}
function moonbitlang$core$builtin$$Hasher$combine_string(self, value) {
  const _end1620 = value.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _end1620) {
      moonbitlang$core$builtin$$Hasher$combine_uint(self, value.charCodeAt(i));
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$builtin$$Hash$hash_combine$48$(self, hasher) {
  moonbitlang$core$builtin$$Hasher$combine_string(hasher, self);
}
function moonbitlang$core$builtin$$Hash$hash_combine$28$(self, hasher) {
  moonbitlang$core$builtin$$Hasher$combine_uint(hasher, self);
}
function moonbitlang$core$array$$FixedArray$blit_to$46$inner$28$(self, dst, len, src_offset, dst_offset) {
  if (dst_offset >= 0 && (src_offset >= 0 && ((dst_offset + len | 0) <= dst.length && (src_offset + len | 0) <= self.length))) {
    moonbitlang$core$array$$FixedArray$unsafe_blit$28$(dst, dst_offset, self, src_offset, len);
    return;
  } else {
    moonbitlang$core$abort$$abort$25$(`bounds check failed: dst_offset = ${moonbitlang$core$builtin$$Show$to_string$52$(dst_offset)}, src_offset = ${moonbitlang$core$builtin$$Show$to_string$52$(src_offset)}, len = ${moonbitlang$core$builtin$$Show$to_string$52$(len)}, dst.length = ${moonbitlang$core$builtin$$Show$to_string$52$(dst.length)}, self.length = ${moonbitlang$core$builtin$$Show$to_string$52$(self.length)}`);
    return;
  }
}
function moonbitlang$core$double$$Double$to_int(self) {
  return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
}
function moonbitlang$core$builtin$$println$48$(input) {
  console.log(input);
}
function moonbitlang$core$builtin$$Shr$shr$31$(self, count) {
  return (self >>> count | 0) & 255;
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$11$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$10$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$15$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$44$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$22$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_pop$15$(self) {
  return moonbitlang$core$builtin$$JSArray$pop(self);
}
function moonbitlang$core$array$$Array$pop$15$(self) {
  if (self.length === 0) {
    return undefined;
  } else {
    const v = moonbitlang$core$array$$Array$unsafe_pop$15$(self);
    return v;
  }
}
function moonbitlang$core$builtin$$fixed_get_limit(len) {
  let len$2 = len;
  let limit = 0;
  while (true) {
    if (len$2 > 0) {
      len$2 = len$2 / 2 | 0;
      limit = limit + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return limit;
}
function moonbitlang$core$array$$MutArrayView$swap$27$(arr, i, j) {
  const temp = moonbitlang$core$array$$MutArrayView$at$27$(arr, i);
  moonbitlang$core$array$$MutArrayView$set$27$(arr, i, moonbitlang$core$array$$MutArrayView$at$27$(arr, j));
  moonbitlang$core$array$$MutArrayView$set$27$(arr, j, temp);
}
function moonbitlang$core$array$$MutArrayView$swap$29$(arr, i, j) {
  const temp = moonbitlang$core$array$$MutArrayView$at$29$(arr, i);
  moonbitlang$core$array$$MutArrayView$set$29$(arr, i, moonbitlang$core$array$$MutArrayView$at$29$(arr, j));
  moonbitlang$core$array$$MutArrayView$set$29$(arr, j, temp);
}
function moonbitlang$core$builtin$$fixed_bubble_sort_by$27$(arr, cmp) {
  const _end680 = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _end680) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(moonbitlang$core$array$$MutArrayView$at$27$(arr, j - 1 | 0), moonbitlang$core$array$$MutArrayView$at$27$(arr, j)) > 0) {
          moonbitlang$core$array$$MutArrayView$swap$27$(arr, j, j - 1 | 0);
          _tmp$2 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$builtin$$fixed_bubble_sort_by$29$(arr, cmp) {
  const _end680 = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _end680) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(moonbitlang$core$array$$MutArrayView$at$29$(arr, j - 1 | 0), moonbitlang$core$array$$MutArrayView$at$29$(arr, j)) > 0) {
          moonbitlang$core$array$$MutArrayView$swap$29$(arr, j, j - 1 | 0);
          _tmp$2 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$MutArrayView$rev_in_place$27$(arr) {
  const len = arr.end - arr.start | 0;
  const mid_len = len / 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < mid_len) {
      const j = (len - i | 0) - 1 | 0;
      const temp = moonbitlang$core$array$$MutArrayView$at$27$(arr, i);
      moonbitlang$core$array$$MutArrayView$set$27$(arr, i, moonbitlang$core$array$$MutArrayView$at$27$(arr, j));
      moonbitlang$core$array$$MutArrayView$set$27$(arr, j, temp);
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$MutArrayView$rev_in_place$29$(arr) {
  const len = arr.end - arr.start | 0;
  const mid_len = len / 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < mid_len) {
      const j = (len - i | 0) - 1 | 0;
      const temp = moonbitlang$core$array$$MutArrayView$at$29$(arr, i);
      moonbitlang$core$array$$MutArrayView$set$29$(arr, i, moonbitlang$core$array$$MutArrayView$at$29$(arr, j));
      moonbitlang$core$array$$MutArrayView$set$29$(arr, j, temp);
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_2$47$2154(_env, a, b) {
  const cmp = _env._2;
  const swaps = _env._1;
  const arr = _env._0;
  if (cmp(moonbitlang$core$array$$MutArrayView$at$27$(arr, a), moonbitlang$core$array$$MutArrayView$at$27$(arr, b)) > 0) {
    moonbitlang$core$array$$MutArrayView$swap$27$(arr, a, b);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2155(_env, a, b, c) {
  moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_2$47$2154(_env, a, b);
  moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_2$47$2154(_env, b, c);
  moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_2$47$2154(_env, a, b);
}
function moonbitlang$core$builtin$$fixed_choose_pivot_by$27$(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const swaps = { val: 0 };
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: arr, _1: swaps, _2: cmp };
    if (len > 50) {
      moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2155(_env, a - 1 | 0, a, a + 1 | 0);
      moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2155(_env, b - 1 | 0, b, b + 1 | 0);
      moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2155(_env, c - 1 | 0, c, c + 1 | 0);
    }
    moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2155(_env, a, b, c);
  }
  if (swaps.val === 12) {
    moonbitlang$core$array$$MutArrayView$rev_in_place$27$(arr);
    return { _0: (len - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: b, _1: swaps.val === 0 };
  }
}
function moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_2$47$2174(_env, a, b) {
  const cmp = _env._2;
  const swaps = _env._1;
  const arr = _env._0;
  if (cmp(moonbitlang$core$array$$MutArrayView$at$29$(arr, a), moonbitlang$core$array$$MutArrayView$at$29$(arr, b)) > 0) {
    moonbitlang$core$array$$MutArrayView$swap$29$(arr, a, b);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2175(_env, a, b, c) {
  moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_2$47$2174(_env, a, b);
  moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_2$47$2174(_env, b, c);
  moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_2$47$2174(_env, a, b);
}
function moonbitlang$core$builtin$$fixed_choose_pivot_by$29$(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const swaps = { val: 0 };
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: arr, _1: swaps, _2: cmp };
    if (len > 50) {
      moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2175(_env, a - 1 | 0, a, a + 1 | 0);
      moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2175(_env, b - 1 | 0, b, b + 1 | 0);
      moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2175(_env, c - 1 | 0, c, c + 1 | 0);
    }
    moonbitlang$core$builtin$$fixed_choose_pivot_by$46$sort_3$47$2175(_env, a, b, c);
  }
  if (swaps.val === 12) {
    moonbitlang$core$array$$MutArrayView$rev_in_place$29$(arr);
    return { _0: (len - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: b, _1: swaps.val === 0 };
  }
}
function moonbitlang$core$builtin$$fixed_sift_down_by$27$(arr, index, cmp) {
  let index$2 = index;
  const len = arr.end - arr.start | 0;
  let child = (Math.imul(index$2, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      if ((child + 1 | 0) < len && cmp(moonbitlang$core$array$$MutArrayView$at$27$(arr, child), moonbitlang$core$array$$MutArrayView$at$27$(arr, child + 1 | 0)) < 0) {
        child = child + 1 | 0;
      }
      if (cmp(moonbitlang$core$array$$MutArrayView$at$27$(arr, index$2), moonbitlang$core$array$$MutArrayView$at$27$(arr, child)) >= 0) {
        return undefined;
      }
      moonbitlang$core$array$$MutArrayView$swap$27$(arr, index$2, child);
      index$2 = child;
      child = (Math.imul(index$2, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$builtin$$fixed_sift_down_by$29$(arr, index, cmp) {
  let index$2 = index;
  const len = arr.end - arr.start | 0;
  let child = (Math.imul(index$2, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      if ((child + 1 | 0) < len && cmp(moonbitlang$core$array$$MutArrayView$at$29$(arr, child), moonbitlang$core$array$$MutArrayView$at$29$(arr, child + 1 | 0)) < 0) {
        child = child + 1 | 0;
      }
      if (cmp(moonbitlang$core$array$$MutArrayView$at$29$(arr, index$2), moonbitlang$core$array$$MutArrayView$at$29$(arr, child)) >= 0) {
        return undefined;
      }
      moonbitlang$core$array$$MutArrayView$swap$29$(arr, index$2, child);
      index$2 = child;
      child = (Math.imul(index$2, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$MutArrayView$slice$27$(arr, start, end) {
  return moonbitlang$core$array$$MutArrayView$mut_view$46$inner$27$(arr, start, end);
}
function moonbitlang$core$array$$MutArrayView$slice$29$(arr, start, end) {
  return moonbitlang$core$array$$MutArrayView$mut_view$46$inner$29$(arr, start, end);
}
function moonbitlang$core$builtin$$fixed_heap_sort_by$27$(arr, cmp) {
  const len = arr.end - arr.start | 0;
  let _tmp = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp;
    if (i >= 0) {
      moonbitlang$core$builtin$$fixed_sift_down_by$27$(arr, i, cmp);
      _tmp = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$2 = len - 1 | 0;
  while (true) {
    const i = _tmp$2;
    if (i > 0) {
      moonbitlang$core$array$$MutArrayView$swap$27$(arr, 0, i);
      moonbitlang$core$builtin$$fixed_sift_down_by$27$(moonbitlang$core$array$$MutArrayView$slice$27$(arr, 0, i), 0, cmp);
      _tmp$2 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$builtin$$fixed_heap_sort_by$29$(arr, cmp) {
  const len = arr.end - arr.start | 0;
  let _tmp = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp;
    if (i >= 0) {
      moonbitlang$core$builtin$$fixed_sift_down_by$29$(arr, i, cmp);
      _tmp = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$2 = len - 1 | 0;
  while (true) {
    const i = _tmp$2;
    if (i > 0) {
      moonbitlang$core$array$$MutArrayView$swap$29$(arr, 0, i);
      moonbitlang$core$builtin$$fixed_sift_down_by$29$(moonbitlang$core$array$$MutArrayView$slice$29$(arr, 0, i), 0, cmp);
      _tmp$2 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$builtin$$fixed_partition_by$27$(arr, cmp, pivot_index) {
  moonbitlang$core$array$$MutArrayView$swap$27$(arr, pivot_index, (arr.end - arr.start | 0) - 1 | 0);
  const pivot = moonbitlang$core$array$$MutArrayView$at$27$(arr, (arr.end - arr.start | 0) - 1 | 0);
  let i = 0;
  let partitioned = true;
  const _end669 = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp = 0;
  while (true) {
    const j = _tmp;
    if (j < _end669) {
      if (cmp(moonbitlang$core$array$$MutArrayView$at$27$(arr, j), pivot) < 0) {
        if (i !== j) {
          moonbitlang$core$array$$MutArrayView$swap$27$(arr, i, j);
          partitioned = false;
        }
        i = i + 1 | 0;
      }
      _tmp = j + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$MutArrayView$swap$27$(arr, i, (arr.end - arr.start | 0) - 1 | 0);
  return { _0: i, _1: partitioned };
}
function moonbitlang$core$builtin$$fixed_partition_by$29$(arr, cmp, pivot_index) {
  moonbitlang$core$array$$MutArrayView$swap$29$(arr, pivot_index, (arr.end - arr.start | 0) - 1 | 0);
  const pivot = moonbitlang$core$array$$MutArrayView$at$29$(arr, (arr.end - arr.start | 0) - 1 | 0);
  let i = 0;
  let partitioned = true;
  const _end669 = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp = 0;
  while (true) {
    const j = _tmp;
    if (j < _end669) {
      if (cmp(moonbitlang$core$array$$MutArrayView$at$29$(arr, j), pivot) < 0) {
        if (i !== j) {
          moonbitlang$core$array$$MutArrayView$swap$29$(arr, i, j);
          partitioned = false;
        }
        i = i + 1 | 0;
      }
      _tmp = j + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$MutArrayView$swap$29$(arr, i, (arr.end - arr.start | 0) - 1 | 0);
  return { _0: i, _1: partitioned };
}
function moonbitlang$core$builtin$$fixed_try_bubble_sort_by$27$(arr, cmp) {
  let tries = 0;
  const _end690 = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _end690) {
      let sorted = true;
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(moonbitlang$core$array$$MutArrayView$at$27$(arr, j - 1 | 0), moonbitlang$core$array$$MutArrayView$at$27$(arr, j)) > 0) {
          sorted = false;
          moonbitlang$core$array$$MutArrayView$swap$27$(arr, j, j - 1 | 0);
          _tmp$2 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (!sorted) {
        tries = tries + 1 | 0;
        if (tries > 8) {
          return false;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function moonbitlang$core$builtin$$fixed_try_bubble_sort_by$29$(arr, cmp) {
  let tries = 0;
  const _end690 = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _end690) {
      let sorted = true;
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(moonbitlang$core$array$$MutArrayView$at$29$(arr, j - 1 | 0), moonbitlang$core$array$$MutArrayView$at$29$(arr, j)) > 0) {
          sorted = false;
          moonbitlang$core$array$$MutArrayView$swap$29$(arr, j, j - 1 | 0);
          _tmp$2 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (!sorted) {
        tries = tries + 1 | 0;
        if (tries > 8) {
          return false;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function moonbitlang$core$builtin$$fixed_quick_sort_by$27$(arr, cmp, pred, limit) {
  let limit$2 = limit;
  let arr$2 = arr;
  let pred$2 = pred;
  let was_partitioned = true;
  let balanced = true;
  while (true) {
    const _p = arr$2;
    const len = _p.end - _p.start | 0;
    if (len <= 16) {
      if (len >= 2) {
        moonbitlang$core$builtin$$fixed_bubble_sort_by$27$(arr$2, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      moonbitlang$core$builtin$$fixed_heap_sort_by$27$(arr$2, cmp);
      return undefined;
    }
    const _bind$8 = moonbitlang$core$builtin$$fixed_choose_pivot_by$27$(arr$2, cmp);
    const _pivot_index = _bind$8._0;
    const _likely_sorted = _bind$8._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (moonbitlang$core$builtin$$fixed_try_bubble_sort_by$27$(arr$2, cmp)) {
        return undefined;
      }
    }
    const _bind$9 = moonbitlang$core$builtin$$fixed_partition_by$27$(arr$2, cmp, _pivot_index);
    const _pivot = _bind$9._0;
    const _partitioned = _bind$9._1;
    was_partitioned = _partitioned;
    const _p$2 = len - _pivot | 0;
    balanced = (_pivot > _p$2 ? _p$2 : _pivot) >= (len / 8 | 0);
    if (!balanced) {
      limit$2 = limit$2 - 1 | 0;
    }
    const _bind$10 = pred$2;
    if (_bind$10 === undefined) {
    } else {
      const _Some = _bind$10;
      const _pred = _Some;
      if (cmp(_pred, moonbitlang$core$array$$MutArrayView$at$27$(arr$2, _pivot)) === 0) {
        let i = _pivot;
        while (true) {
          if (i < len && cmp(_pred, moonbitlang$core$array$$MutArrayView$at$27$(arr$2, i)) === 0) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        arr$2 = moonbitlang$core$array$$MutArrayView$slice$27$(arr$2, i, len);
        continue;
      }
    }
    const left = moonbitlang$core$array$$MutArrayView$slice$27$(arr$2, 0, _pivot);
    const right = moonbitlang$core$array$$MutArrayView$slice$27$(arr$2, _pivot + 1 | 0, len);
    if ((left.end - left.start | 0) < (right.end - right.start | 0)) {
      moonbitlang$core$builtin$$fixed_quick_sort_by$27$(left, cmp, pred$2, limit$2);
      pred$2 = moonbitlang$core$array$$MutArrayView$at$27$(arr$2, _pivot);
      arr$2 = right;
    } else {
      moonbitlang$core$builtin$$fixed_quick_sort_by$27$(right, cmp, moonbitlang$core$array$$MutArrayView$at$27$(arr$2, _pivot), limit$2);
      arr$2 = left;
    }
    continue;
  }
}
function moonbitlang$core$builtin$$fixed_quick_sort_by$29$(arr, cmp, pred, limit) {
  let limit$2 = limit;
  let arr$2 = arr;
  let pred$2 = pred;
  let was_partitioned = true;
  let balanced = true;
  while (true) {
    const _p = arr$2;
    const len = _p.end - _p.start | 0;
    if (len <= 16) {
      if (len >= 2) {
        moonbitlang$core$builtin$$fixed_bubble_sort_by$29$(arr$2, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      moonbitlang$core$builtin$$fixed_heap_sort_by$29$(arr$2, cmp);
      return undefined;
    }
    const _bind$8 = moonbitlang$core$builtin$$fixed_choose_pivot_by$29$(arr$2, cmp);
    const _pivot_index = _bind$8._0;
    const _likely_sorted = _bind$8._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (moonbitlang$core$builtin$$fixed_try_bubble_sort_by$29$(arr$2, cmp)) {
        return undefined;
      }
    }
    const _bind$9 = moonbitlang$core$builtin$$fixed_partition_by$29$(arr$2, cmp, _pivot_index);
    const _pivot = _bind$9._0;
    const _partitioned = _bind$9._1;
    was_partitioned = _partitioned;
    const _p$2 = len - _pivot | 0;
    balanced = (_pivot > _p$2 ? _p$2 : _pivot) >= (len / 8 | 0);
    if (!balanced) {
      limit$2 = limit$2 - 1 | 0;
    }
    const _bind$10 = pred$2;
    if (_bind$10 === undefined) {
    } else {
      const _Some = _bind$10;
      const _pred = _Some;
      if (cmp(_pred, moonbitlang$core$array$$MutArrayView$at$29$(arr$2, _pivot)) === 0) {
        let i = _pivot;
        while (true) {
          if (i < len && cmp(_pred, moonbitlang$core$array$$MutArrayView$at$29$(arr$2, i)) === 0) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        arr$2 = moonbitlang$core$array$$MutArrayView$slice$29$(arr$2, i, len);
        continue;
      }
    }
    const left = moonbitlang$core$array$$MutArrayView$slice$29$(arr$2, 0, _pivot);
    const right = moonbitlang$core$array$$MutArrayView$slice$29$(arr$2, _pivot + 1 | 0, len);
    if ((left.end - left.start | 0) < (right.end - right.start | 0)) {
      moonbitlang$core$builtin$$fixed_quick_sort_by$29$(left, cmp, pred$2, limit$2);
      pred$2 = moonbitlang$core$array$$MutArrayView$at$29$(arr$2, _pivot);
      arr$2 = right;
    } else {
      moonbitlang$core$builtin$$fixed_quick_sort_by$29$(right, cmp, moonbitlang$core$array$$MutArrayView$at$29$(arr$2, _pivot), limit$2);
      arr$2 = left;
    }
    continue;
  }
}
function moonbitlang$core$array$$MutArrayView$sort_by_key$39$(self, map) {
  moonbitlang$core$builtin$$fixed_quick_sort_by$27$(self, (a, b) => $compare_int(map(a), map(b)), undefined, moonbitlang$core$builtin$$fixed_get_limit(self.end - self.start | 0));
}
function moonbitlang$core$array$$MutArrayView$sort_by$29$(self, cmp) {
  moonbitlang$core$builtin$$fixed_quick_sort_by$29$(self, cmp, undefined, moonbitlang$core$builtin$$fixed_get_limit(self.end - self.start | 0));
}
function moonbitlang$core$array$$Array$set$22$(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function moonbitlang$core$array$$Array$clear$11$(self) {
  moonbitlang$core$array$$Array$unsafe_truncate_to_length$11$(self, 0);
}
function moonbitlang$core$array$$Array$clear$15$(self) {
  moonbitlang$core$array$$Array$unsafe_truncate_to_length$15$(self, 0);
}
function moonbitlang$core$array$$Array$clear$44$(self) {
  moonbitlang$core$array$$Array$unsafe_truncate_to_length$44$(self, 0);
}
function moonbitlang$core$array$$Array$clear$22$(self) {
  moonbitlang$core$array$$Array$unsafe_truncate_to_length$22$(self, 0);
}
function moonbitlang$core$array$$Array$contains$75$(self, value) {
  const _len = self.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const v = self[_i];
      if (v === value) {
        return true;
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      return false;
    }
  }
}
function moonbitlang$core$ref$$Ref$new$76$(x) {
  return { val: x };
}
function moonbitlang$core$ref$$Ref$new$22$(x) {
  return { val: x };
}
function moonbitlang$core$ref$$Ref$new$19$(x) {
  return { val: x };
}
function moonbitlang$core$ref$$Ref$new$15$(x) {
  return { val: x };
}
function moonbitlang$core$builtin$$Default$default$43$() {
  return { _0: 0, _1: 0 };
}
function Milky2018$selene$math$$Vec2D$op_get(this_, axis) {
  if (axis === 0) {
    return this_._0;
  } else {
    return this_._1;
  }
}
function Milky2018$selene$math$$Vec2D$update(this_, axis, value) {
  if (axis === 0) {
    return { _0: value, _1: this_._1 };
  } else {
    return { _0: this_._0, _1: value };
  }
}
function Milky2018$selene$math$$Vec2D$distance_to(this_, other) {
  return Math.sqrt((this_._0 - other._0) * (this_._0 - other._0) + (this_._1 - other._1) * (this_._1 - other._1));
}
function Milky2018$selene$math$$Vec2D$normalize(this_) {
  const mag = Math.sqrt(this_._0 * this_._0 + this_._1 * this_._1);
  return mag > 0 ? { _0: this_._0 / mag, _1: this_._1 / mag } : { _0: 0, _1: 0 };
}
function Milky2018$selene$math$$Transform$new$46$inner(a, b, c, d, tx, ty) {
  return { a: a, b: b, c: c, d: d, tx: tx, ty: ty };
}
function Milky2018$selene$math$$Transform$from_translation(tx, ty) {
  return { a: 1, b: 0, c: 0, d: 1, tx: tx, ty: ty };
}
function Milky2018$selene$math$$Transform$from_scale(sx, sy) {
  return { a: sx, b: 0, c: 0, d: sy, tx: 0, ty: 0 };
}
function Milky2018$selene$math$$Transform$multiply(self, other) {
  return { a: self.a * other.a + self.c * other.b, b: self.b * other.a + self.d * other.b, c: self.a * other.c + self.c * other.d, d: self.b * other.c + self.d * other.d, tx: self.a * other.tx + self.c * other.ty + self.tx, ty: self.b * other.tx + self.d * other.ty + self.ty };
}
function Milky2018$selene$math$$Transform$apply_to_point(self, x, y) {
  const new_x = self.a * x + self.c * y + self.tx;
  const new_y = self.b * x + self.d * y + self.ty;
  return { _0: new_x, _1: new_y };
}
function Milky2018$selene$math$$Transform$apply_to_vec2d(self, vec) {
  const p = Milky2018$selene$math$$Transform$apply_to_point(self, vec._0, vec._1);
  return { _0: p._0, _1: p._1 };
}
function Milky2018$selene$math$$Transform$flip_x(width) {
  return moonbitlang$core$builtin$$Mul$mul$77$(Milky2018$selene$math$$Transform$from_translation(width, 0), Milky2018$selene$math$$Transform$from_scale(-1, 1));
}
function moonbitlang$core$builtin$$Mul$mul$77$(self, other) {
  return Milky2018$selene$math$$Transform$multiply(self, other);
}
function Milky2018$selene$math$$Rect$intersects(a, b) {
  return Milky2018$selene$math$$Vec2D$op_get(a.position, 0) < Milky2018$selene$math$$Vec2D$op_get(b.position, 0) + Milky2018$selene$math$$Vec2D$op_get(b.size, 0) && (Milky2018$selene$math$$Vec2D$op_get(a.position, 0) + Milky2018$selene$math$$Vec2D$op_get(a.size, 0) > Milky2018$selene$math$$Vec2D$op_get(b.position, 0) && (Milky2018$selene$math$$Vec2D$op_get(a.position, 1) < Milky2018$selene$math$$Vec2D$op_get(b.position, 1) + Milky2018$selene$math$$Vec2D$op_get(b.size, 1) && Milky2018$selene$math$$Vec2D$op_get(a.position, 1) + Milky2018$selene$math$$Vec2D$op_get(a.size, 1) > Milky2018$selene$math$$Vec2D$op_get(b.position, 1)));
}
function Milky2018$selene$math$$Rect$shift(self, dir) {
  const _p = self.position;
  const _tmp = { _0: _p._0 + dir._0, _1: _p._1 + dir._1 };
  return { position: _tmp, size: self.size };
}
function moonbitlang$core$builtin$$Eq$equal$18$(_x_29, _x_30) {
  switch (_x_29) {
    case 0: {
      if (_x_30 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_30 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_30 === 2) {
        return true;
      } else {
        return false;
      }
    }
    case 3: {
      if (_x_30 === 3) {
        return true;
      } else {
        return false;
      }
    }
    case 4: {
      if (_x_30 === 4) {
        return true;
      } else {
        return false;
      }
    }
    case 5: {
      if (_x_30 === 5) {
        return true;
      } else {
        return false;
      }
    }
    case 6: {
      if (_x_30 === 6) {
        return true;
      } else {
        return false;
      }
    }
    case 7: {
      if (_x_30 === 7) {
        return true;
      } else {
        return false;
      }
    }
    case 8: {
      if (_x_30 === 8) {
        return true;
      } else {
        return false;
      }
    }
    case 9: {
      if (_x_30 === 9) {
        return true;
      } else {
        return false;
      }
    }
    case 10: {
      if (_x_30 === 10) {
        return true;
      } else {
        return false;
      }
    }
    case 11: {
      if (_x_30 === 11) {
        return true;
      } else {
        return false;
      }
    }
    case 12: {
      if (_x_30 === 12) {
        return true;
      } else {
        return false;
      }
    }
    case 13: {
      if (_x_30 === 13) {
        return true;
      } else {
        return false;
      }
    }
    case 14: {
      if (_x_30 === 14) {
        return true;
      } else {
        return false;
      }
    }
    case 15: {
      if (_x_30 === 15) {
        return true;
      } else {
        return false;
      }
    }
    case 16: {
      if (_x_30 === 16) {
        return true;
      } else {
        return false;
      }
    }
    case 17: {
      if (_x_30 === 17) {
        return true;
      } else {
        return false;
      }
    }
    case 18: {
      if (_x_30 === 18) {
        return true;
      } else {
        return false;
      }
    }
    case 19: {
      if (_x_30 === 19) {
        return true;
      } else {
        return false;
      }
    }
    case 20: {
      if (_x_30 === 20) {
        return true;
      } else {
        return false;
      }
    }
    case 21: {
      if (_x_30 === 21) {
        return true;
      } else {
        return false;
      }
    }
    case 22: {
      if (_x_30 === 22) {
        return true;
      } else {
        return false;
      }
    }
    case 23: {
      if (_x_30 === 23) {
        return true;
      } else {
        return false;
      }
    }
    case 24: {
      if (_x_30 === 24) {
        return true;
      } else {
        return false;
      }
    }
    case 25: {
      if (_x_30 === 25) {
        return true;
      } else {
        return false;
      }
    }
    case 26: {
      if (_x_30 === 26) {
        return true;
      } else {
        return false;
      }
    }
    case 27: {
      if (_x_30 === 27) {
        return true;
      } else {
        return false;
      }
    }
    case 28: {
      if (_x_30 === 28) {
        return true;
      } else {
        return false;
      }
    }
    case 29: {
      if (_x_30 === 29) {
        return true;
      } else {
        return false;
      }
    }
    case 30: {
      if (_x_30 === 30) {
        return true;
      } else {
        return false;
      }
    }
    case 31: {
      if (_x_30 === 31) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_30 === 32) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function moonbitlang$core$builtin$$Hash$hash_combine$18$(_x_21, _x_22) {
  switch (_x_21) {
    case 0: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 0);
      return;
    }
    case 1: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 1);
      return;
    }
    case 2: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 2);
      return;
    }
    case 3: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 3);
      return;
    }
    case 4: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 4);
      return;
    }
    case 5: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 5);
      return;
    }
    case 6: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 6);
      return;
    }
    case 7: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 7);
      return;
    }
    case 8: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 8);
      return;
    }
    case 9: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 9);
      return;
    }
    case 10: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 10);
      return;
    }
    case 11: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 11);
      return;
    }
    case 12: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 12);
      return;
    }
    case 13: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 13);
      return;
    }
    case 14: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 14);
      return;
    }
    case 15: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 15);
      return;
    }
    case 16: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 16);
      return;
    }
    case 17: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 17);
      return;
    }
    case 18: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 18);
      return;
    }
    case 19: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 19);
      return;
    }
    case 20: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 20);
      return;
    }
    case 21: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 21);
      return;
    }
    case 22: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 22);
      return;
    }
    case 23: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 23);
      return;
    }
    case 24: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 24);
      return;
    }
    case 25: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 25);
      return;
    }
    case 26: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 26);
      return;
    }
    case 27: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 27);
      return;
    }
    case 28: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 28);
      return;
    }
    case 29: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 29);
      return;
    }
    case 30: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 30);
      return;
    }
    case 31: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 31);
      return;
    }
    default: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_22, 32);
      return;
    }
  }
}
function Milky2018$selene$inputs$$advanced_mouse_system(_delta) {
  Milky2018$selene$inputs$$just_pressed_mouse.left_button = Milky2018$selene$inputs$$mouse.left_button && !Milky2018$selene$inputs$$last_mouse.left_button;
  Milky2018$selene$inputs$$just_pressed_mouse.right_button = Milky2018$selene$inputs$$mouse.right_button && !Milky2018$selene$inputs$$last_mouse.right_button;
  Milky2018$selene$inputs$$just_pressed_mouse.middle_button = Milky2018$selene$inputs$$mouse.middle_button && !Milky2018$selene$inputs$$last_mouse.middle_button;
  Milky2018$selene$inputs$$just_release_mouse.left_button = !Milky2018$selene$inputs$$mouse.left_button && Milky2018$selene$inputs$$last_mouse.left_button;
  Milky2018$selene$inputs$$just_release_mouse.right_button = !Milky2018$selene$inputs$$mouse.right_button && Milky2018$selene$inputs$$last_mouse.right_button;
  Milky2018$selene$inputs$$just_release_mouse.middle_button = !Milky2018$selene$inputs$$mouse.middle_button && Milky2018$selene$inputs$$last_mouse.middle_button;
  Milky2018$selene$inputs$$last_mouse.pos = Milky2018$selene$inputs$$mouse.pos;
  Milky2018$selene$inputs$$last_mouse.left_button = Milky2018$selene$inputs$$mouse.left_button;
  Milky2018$selene$inputs$$last_mouse.right_button = Milky2018$selene$inputs$$mouse.right_button;
  Milky2018$selene$inputs$$last_mouse.middle_button = Milky2018$selene$inputs$$mouse.middle_button;
}
function Milky2018$selene$inputs$$is_mouse_pressed(button) {
  switch (button) {
    case 0: {
      return Milky2018$selene$inputs$$mouse.left_button;
    }
    case 1: {
      return Milky2018$selene$inputs$$mouse.right_button;
    }
    default: {
      return Milky2018$selene$inputs$$mouse.middle_button;
    }
  }
}
function Milky2018$selene$inputs$$is_mouse_released(button) {
  switch (button) {
    case 0: {
      return !Milky2018$selene$inputs$$mouse.left_button;
    }
    case 1: {
      return !Milky2018$selene$inputs$$mouse.right_button;
    }
    default: {
      return !Milky2018$selene$inputs$$mouse.middle_button;
    }
  }
}
function Milky2018$selene$inputs$$is_mouse_just_pressed(button) {
  switch (button) {
    case 0: {
      return Milky2018$selene$inputs$$just_pressed_mouse.left_button;
    }
    case 1: {
      return Milky2018$selene$inputs$$just_pressed_mouse.right_button;
    }
    default: {
      return Milky2018$selene$inputs$$just_pressed_mouse.middle_button;
    }
  }
}
function Milky2018$selene$inputs$$is_mouse_just_released(button) {
  switch (button) {
    case 0: {
      return Milky2018$selene$inputs$$just_release_mouse.left_button;
    }
    case 1: {
      return Milky2018$selene$inputs$$just_release_mouse.right_button;
    }
    default: {
      return Milky2018$selene$inputs$$just_release_mouse.middle_button;
    }
  }
}
function Milky2018$selene$inputs$$Code$from_string(code) {
  switch (code) {
    case "KeyA": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2426;
    }
    case "KeyB": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2427;
    }
    case "KeyC": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2428;
    }
    case "KeyD": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2429;
    }
    case "KeyE": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2430;
    }
    case "KeyF": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2431;
    }
    case "KeyG": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2432;
    }
    case "KeyH": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2433;
    }
    case "KeyI": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2434;
    }
    case "KeyJ": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2435;
    }
    case "KeyK": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2436;
    }
    case "KeyL": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2437;
    }
    case "KeyM": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2438;
    }
    case "KeyN": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2439;
    }
    case "KeyO": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2440;
    }
    case "KeyP": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2441;
    }
    case "KeyQ": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2442;
    }
    case "KeyR": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2443;
    }
    case "KeyS": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2444;
    }
    case "KeyT": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2445;
    }
    case "KeyU": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2446;
    }
    case "KeyV": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2447;
    }
    case "KeyW": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2448;
    }
    case "KeyX": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2449;
    }
    case "KeyY": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2450;
    }
    case "ArrowUp": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2451;
    }
    case "ArrowDown": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2452;
    }
    case "ArrowLeft": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2453;
    }
    case "ArrowRight": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2454;
    }
    case "Space": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2455;
    }
    case "Enter": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2456;
    }
    case "Escape": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2457;
    }
    default: {
      return undefined;
    }
  }
}
function Milky2018$selene$inputs$$is_pressed(code) {
  return moonbitlang$core$set$$Set$contains$18$(Milky2018$selene$inputs$$pressed_keys, code);
}
function Milky2018$selene$inputs$$key_vector(up, down, left, right) {
  const x = Milky2018$selene$inputs$$is_pressed(left) ? -1 : Milky2018$selene$inputs$$is_pressed(right) ? 1 : 0;
  const y = Milky2018$selene$inputs$$is_pressed(up) ? -1 : Milky2018$selene$inputs$$is_pressed(down) ? 1 : 0;
  return { _0: x, _1: y };
}
function Milky2018$selene$inputs$$advanced_key_system(_delta) {
  moonbitlang$core$set$$Set$clear$18$(Milky2018$selene$inputs$$just_pressed_keys);
  const _it = moonbitlang$core$set$$Set$iterator$18$(moonbitlang$core$set$$Set$difference$18$(Milky2018$selene$inputs$$pressed_keys, Milky2018$selene$inputs$$last_pressed_keys));
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator$next$18$(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _code = _Some;
      moonbitlang$core$set$$Set$add$18$(Milky2018$selene$inputs$$just_pressed_keys, _code);
      continue;
    }
  }
  moonbitlang$core$set$$Set$clear$18$(Milky2018$selene$inputs$$just_release_keys);
  const _it$2 = moonbitlang$core$set$$Set$iterator$18$(moonbitlang$core$set$$Set$union$18$(moonbitlang$core$set$$Set$difference$18$(Milky2018$selene$inputs$$all_codes, Milky2018$selene$inputs$$pressed_keys), Milky2018$selene$inputs$$last_pressed_keys));
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator$next$18$(_it$2);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _code = _Some;
      moonbitlang$core$set$$Set$add$18$(Milky2018$selene$inputs$$just_release_keys, _code);
      continue;
    }
  }
  moonbitlang$core$set$$Set$clear$18$(Milky2018$selene$inputs$$last_pressed_keys);
  const _it$3 = moonbitlang$core$set$$Set$iterator$18$(Milky2018$selene$inputs$$pressed_keys);
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator$next$18$(_it$3);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _code = _Some;
      moonbitlang$core$set$$Set$add$18$(Milky2018$selene$inputs$$last_pressed_keys, _code);
      continue;
    }
  }
}
function rami3l$js$45$ffi$js$$Union3$from0$78$(value) {
  return value;
}
function rami3l$js$45$ffi$js$$Union3$from2$78$(value) {
  return value;
}
function rami3l$js$45$ffi$js$$Union5$to0$79$(self) {
  return rami3l$js$45$ffi$js$$Cast$into$68$(self);
}
function rami3l$js$45$ffi$js$$Union7$from0$80$(value) {
  return rami3l$js$45$ffi$js$$Cast$from$81$(value);
}
function rami3l$js$45$ffi$js$$Optional$undefined$22$() {
  return rami3l$js$45$ffi$js$$Value$undefined();
}
function rami3l$js$45$ffi$js$$Nullable$is_null$82$(self) {
  return rami3l$js$45$ffi$js$$Value$is_null(self);
}
function rami3l$js$45$ffi$js$$Nullable$unwrap$82$(self) {
  if (rami3l$js$45$ffi$js$$Nullable$is_null$82$(self)) {
    moonbitlang$core$abort$$abort$25$("Cannot unwrap a null value");
  }
  return self;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$65$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$6$(self) : Option$None$6$;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$66$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$7$(self) : Option$None$7$;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$67$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$8$(self) : Option$None$8$;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$68$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$9$(self) : Option$None$9$;
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_button$83$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_button(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_x$83$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_movement_x(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_y$83$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_movement_y(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_x$83$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_offset_x(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_y$83$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_offset_y(s);
}
function rami3l$js$45$ffi$js$$Cast$from$81$(value) {
  return value;
}
function Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$84$(s, type_, callback) {
  Yoorkin$rabbit$45$tea$dom$$ffi_add_event_listener(s, type_, callback);
}
function Yoorkin$rabbit$45$tea$dom$$IsEventTarget$to_html_canvas_element$85$(s) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$67$(Yoorkin$rabbit$45$tea$dom$$ffi_to_html_canvas_element(s));
}
function Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$86$(s) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$66$(Yoorkin$rabbit$45$tea$dom$$ffi_to_mouse_event(s));
}
function Yoorkin$rabbit$45$tea$dom$$IsEvent$to_keyboard_event$86$(s) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$65$(Yoorkin$rabbit$45$tea$dom$$ffi_to_keyboard_event(s));
}
function rami3l$js$45$ffi$js$$Cast$into$68$(value) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$68$(Yoorkin$rabbit$45$tea$dom$$checked_to_canvas_rendering_context_2d(value));
}
function Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text(self, text, x, y, max_width$46$opt) {
  let max_width;
  if (max_width$46$opt.$tag === 1) {
    const _Some = max_width$46$opt;
    max_width = _Some._0;
  } else {
    max_width = rami3l$js$45$ffi$js$$Optional$undefined$22$();
  }
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text$46$inner(self, text, x, y, max_width);
}
function Milky2018$selene$backend$$CanvasBackend$new() {
  const canvas = moonbitlang$core$option$$Option$unwrap$67$(Yoorkin$rabbit$45$tea$dom$$IsEventTarget$to_html_canvas_element$85$(rami3l$js$45$ffi$js$$Nullable$unwrap$82$(Yoorkin$rabbit$45$tea$dom$$Document$get_element_by_id(Yoorkin$rabbit$45$tea$dom$$document(), "canvas"))));
  const context = moonbitlang$core$option$$Option$unwrap$68$(rami3l$js$45$ffi$js$$Union5$to0$79$(Yoorkin$rabbit$45$tea$dom$$HTMLCanvasElement$get_context(canvas, "2d")));
  const _bind$8 = { _0: 0, _1: 0 };
  const _bind$9 = moonbitlang$core$ref$$Ref$new$76$(undefined);
  return { canvas: canvas, context: context, viewport_size: _bind$8, zoom: 1, time_scale: 1, mouse_movement: _bind$9 };
}
function Milky2018$selene$backend$$register_mouse_events(mouse, mouse_movement) {
  Milky2018$selene$backend$$canvas_backend.mouse_movement.val = mouse_movement;
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$84$(Milky2018$selene$backend$$window, "mousemove", (event) => {
    const mouse_event = moonbitlang$core$option$$Option$unwrap$66$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$86$(event));
    mouse.pos = { _0: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_x$83$(mouse_event) + 0, _1: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_y$83$(mouse_event) + 0 };
    mouse_movement.movement = { _0: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_x$83$(mouse_event) + 0, _1: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_y$83$(mouse_event) + 0 };
  });
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$84$(Milky2018$selene$backend$$window, "mousedown", (event) => {
    const mouse_event = moonbitlang$core$option$$Option$unwrap$66$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$86$(event));
    const _bind$8 = Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_button$83$(mouse_event);
    switch (_bind$8) {
      case 0: {
        mouse.left_button = true;
        return;
      }
      case 1: {
        mouse.middle_button = true;
        return;
      }
      case 2: {
        mouse.right_button = true;
        return;
      }
      default: {
        return;
      }
    }
  });
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$84$(Milky2018$selene$backend$$window, "mouseup", (event) => {
    const mouse_event = moonbitlang$core$option$$Option$unwrap$66$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$86$(event));
    const _bind$8 = Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_button$83$(mouse_event);
    switch (_bind$8) {
      case 0: {
        mouse.left_button = false;
        return;
      }
      case 1: {
        mouse.middle_button = false;
        return;
      }
      case 2: {
        mouse.right_button = false;
        return;
      }
      default: {
        return;
      }
    }
  });
}
function Milky2018$selene$backend$$register_key_events(pressed_keys) {
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$84$(Milky2018$selene$backend$$window, "keyup", (event) => {
    const keyboard_event = moonbitlang$core$option$$Option$unwrap$65$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_keyboard_event$86$(event));
    const keycode = Milky2018$selene$inputs$$Code$from_string(Yoorkin$rabbit$45$tea$dom$$KeyboardEvent$code(keyboard_event));
    if (keycode === undefined) {
      return;
    } else {
      const _Some = keycode;
      const _c = _Some;
      moonbitlang$core$set$$Set$remove$18$(pressed_keys, _c);
      return;
    }
  });
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$84$(Milky2018$selene$backend$$window, "keydown", (event) => {
    const keyboard_event = moonbitlang$core$option$$Option$unwrap$65$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_keyboard_event$86$(event));
    const keycode = Milky2018$selene$inputs$$Code$from_string(Yoorkin$rabbit$45$tea$dom$$KeyboardEvent$code(keyboard_event));
    if (keycode === undefined) {
      return;
    } else {
      const _Some = keycode;
      const _c = _Some;
      moonbitlang$core$set$$Set$add$18$(pressed_keys, _c);
      return;
    }
  });
}
function Milky2018$selene$backend$$get_image_element(png) {
  const _bind$8 = moonbitlang$core$builtin$$Map$get$21$(Milky2018$selene$backend$$element_cache, png);
  if (_bind$8.$tag === 1) {
    const _Some = _bind$8;
    const _element = _Some._0;
    return _element;
  }
  const element = Yoorkin$rabbit$45$tea$dom$$HTMLImageElement$new();
  Yoorkin$rabbit$45$tea$dom$$HTMLImageElement$set_src(element, png);
  moonbitlang$core$builtin$$Map$set$21$(Milky2018$selene$backend$$element_cache, png, element);
  return element;
}
function Milky2018$selene$backend$$draw_picture(png, x, y, width, height, transform, repeat) {
  const element = Milky2018$selene$backend$$get_image_element(png);
  let repeat_mode;
  switch (repeat) {
    case 2: {
      repeat_mode = "no-repeat";
      break;
    }
    case 1: {
      repeat_mode = "repeat-y";
      break;
    }
    case 0: {
      repeat_mode = "repeat-x";
      break;
    }
    default: {
      repeat_mode = "repeat";
    }
  }
  const context = Milky2018$selene$backend$$canvas_backend.context;
  const pattern = Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$create_pattern(context, rami3l$js$45$ffi$js$$Union7$from0$80$(element), repeat_mode);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from2$78$(pattern));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$translate(context, x, y);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$transform(context, transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_rect(context, 0, 0, width, height);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore(context);
}
function Milky2018$selene$backend$$draw_sprite(sprite_path, x, y, offset_x, offset_y, width, height, transform) {
  const context = Milky2018$selene$backend$$canvas_backend.context;
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$translate(context, x, y);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$transform(context, transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
  const element = Milky2018$selene$backend$$get_image_element(sprite_path);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$draw_image_with_src_and_dst_size(context, element, offset_x, offset_y, width, height, 0, 0, width, height);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore(context);
}
function Milky2018$selene$backend$$draw_text(text, x, y, font, color, align, baseline) {
  const context = Milky2018$selene$backend$$canvas_backend.context;
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_font(context, font);
  let align$2;
  switch (align) {
    case 0: {
      align$2 = "left";
      break;
    }
    case 1: {
      align$2 = "center";
      break;
    }
    default: {
      align$2 = "right";
    }
  }
  Milky2018$selene$backend$$set_text_align(context, align$2);
  let baseline$2;
  switch (baseline) {
    case 0: {
      baseline$2 = "top";
      break;
    }
    case 1: {
      baseline$2 = "center";
      break;
    }
    default: {
      baseline$2 = "bottom";
    }
  }
  Milky2018$selene$backend$$set_text_baseline(context, baseline$2);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from0$78$(color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text(context, text, x, y, Option$None$10$);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore(context);
}
function Milky2018$selene$backend$$draw_color_rect(x, y, width, height, color, stroke_color) {
  const context = Milky2018$selene$backend$$canvas_backend.context;
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_stroke_style(context, rami3l$js$45$ffi$js$$Union3$from0$78$(stroke_color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$stroke_rect(context, x, y, width, height);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from0$78$(color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_rect(context, x, y, width, height);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore(context);
}
function Milky2018$selene$backend$$draw_color_circle(x, y, radius, color, stroke_color) {
  const context = Milky2018$selene$backend$$canvas_backend.context;
  Milky2018$selene$backend$$begin_path(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$arc$46$inner(context, x, y, radius, 0, 6.28318530717958623, false);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from0$78$(color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill$46$inner(context, "nonzero");
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_stroke_style(context, rami3l$js$45$ffi$js$$Union3$from0$78$(stroke_color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$stroke(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore(context);
}
function Milky2018$selene$backend$$set_time_scale(time_scale) {
  Milky2018$selene$backend$$canvas_backend.time_scale = time_scale;
}
function Milky2018$selene$backend$$schedule_with_fixed_interval(interval, callback) {
  const lastTime = { val: 0 };
  const accumulator = { val: 0 };
  const lastId = { val: 0 };
  const update = (time) => {
    if (lastTime.val === 0) {
      lastTime.val = time;
    }
    const delta = time - lastTime.val;
    lastTime.val = time;
    accumulator.val = accumulator.val + delta;
    while (true) {
      if (accumulator.val >= interval) {
        callback(delta);
        accumulator.val = accumulator.val - interval;
        continue;
      } else {
        break;
      }
    }
    lastId.val = Yoorkin$rabbit$45$tea$dom$$Window$request_animation_frame(Milky2018$selene$backend$$window, update);
  };
  lastId.val = Yoorkin$rabbit$45$tea$dom$$Window$request_animation_frame(Milky2018$selene$backend$$window, update);
  return () => {
    if (lastId.val !== 0) {
      Yoorkin$rabbit$45$tea$dom$$Window$cancel_animation_frame(Milky2018$selene$backend$$window, lastId.val);
      return;
    } else {
      return;
    }
  };
}
function Milky2018$selene$backend$$initialize(startup, render_loop, game_loop, canvas_width, canvas_height, fps, image_smooth, zoom) {
  if (fps >>> 0 > 60 >>> 0) {
    moonbitlang$core$builtin$$println$48$("Warning: FPS is set above 60. The browser's window only support up to 60 FPS.");
  }
  Milky2018$selene$backend$$canvas_backend.viewport_size = { _0: canvas_width, _1: canvas_height };
  Milky2018$selene$backend$$set_viewport_height(Milky2018$selene$backend$$canvas_backend.canvas, canvas_height);
  Milky2018$selene$backend$$set_viewport_width(Milky2018$selene$backend$$canvas_backend.canvas, canvas_width);
  Milky2018$selene$backend$$set_image_smoothing_enabled(Milky2018$selene$backend$$canvas_backend.context, image_smooth);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$scale(Milky2018$selene$backend$$canvas_backend.context, zoom, zoom);
  Milky2018$selene$backend$$canvas_backend.zoom = zoom;
  startup();
  Milky2018$selene$backend$$schedule_with_fixed_interval(1000 / $f64_convert_i32_u(fps), (delta) => {
    const delta$2 = delta / 1000;
    Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$clear_rect(Milky2018$selene$backend$$canvas_backend.context, 0, 0, canvas_width, canvas_height);
    Milky2018$selene$backend$$realtime_delta.val = delta$2;
    render_loop(delta$2 * Milky2018$selene$backend$$canvas_backend.time_scale);
    game_loop(delta$2 * Milky2018$selene$backend$$canvas_backend.time_scale);
    const _bind$8 = Milky2018$selene$backend$$canvas_backend.mouse_movement.val;
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _mouse_movement = _Some;
      _mouse_movement.movement = { _0: 0, _1: 0 };
      return;
    }
  });
  return () => {
  };
}
function Milky2018$selene$backend$$load_font(font, path) {
  Milky2018$selene$backend$$load_font_async(font, path);
}
function Milky2018$selene$system$$timeout$46$inner(time, callback, pausible) {
  moonbitlang$core$array$$Array$push$10$(Milky2018$selene$system$$timers, { rest: time, pausible: pausible, callback: callback });
}
function Milky2018$selene$system$$timer_system(delta) {
  const _p = [];
  const _p$2 = Milky2018$selene$system$$timers.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = Milky2018$selene$system$$timers[_p$3];
      if (_p$4.pausible) {
        moonbitlang$core$array$$Array$push$10$(_p, _p$4);
      }
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _arr = _p;
  const _len = _arr.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      const timer = _arr[_i];
      timer.rest = timer.rest - delta;
      if (timer.rest <= 0) {
        const _func = timer.callback;
        _func();
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$3 = Milky2018$selene$system$$timers.length;
  let _tmp$3 = 0;
  let _tmp$4 = 0;
  while (true) {
    const _p$4 = _tmp$3;
    const _p$5 = _tmp$4;
    if (_p$4 < _p$3) {
      const _p$6 = Milky2018$selene$system$$timers[_p$4];
      if (_p$6.rest > 0) {
        Milky2018$selene$system$$timers[_p$5] = _p$6;
        _tmp$3 = _p$4 + 1 | 0;
        _tmp$4 = _p$5 + 1 | 0;
        continue;
      }
      _tmp$3 = _p$4 + 1 | 0;
      continue;
    } else {
      moonbitlang$core$array$$Array$unsafe_truncate_to_length$10$(Milky2018$selene$system$$timers, _p$5);
      return;
    }
  }
}
function Milky2018$selene$system$$realtime_timer_system(_delta) {
  const _p = [];
  const _p$2 = Milky2018$selene$system$$timers.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = Milky2018$selene$system$$timers[_p$3];
      if (!_p$4.pausible) {
        moonbitlang$core$array$$Array$push$10$(_p, _p$4);
      }
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _arr = _p;
  const _len = _arr.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      const timer = _arr[_i];
      const realtime_delta = Milky2018$selene$backend$$realtime_delta.val;
      timer.rest = timer.rest - realtime_delta;
      if (timer.rest <= 0) {
        const _func = timer.callback;
        _func();
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$3 = Milky2018$selene$system$$timers.length;
  let _tmp$3 = 0;
  let _tmp$4 = 0;
  while (true) {
    const _p$4 = _tmp$3;
    const _p$5 = _tmp$4;
    if (_p$4 < _p$3) {
      const _p$6 = Milky2018$selene$system$$timers[_p$4];
      if (_p$6.rest > 0) {
        Milky2018$selene$system$$timers[_p$5] = _p$6;
        _tmp$3 = _p$4 + 1 | 0;
        _tmp$4 = _p$5 + 1 | 0;
        continue;
      }
      _tmp$3 = _p$4 + 1 | 0;
      continue;
    } else {
      moonbitlang$core$array$$Array$unsafe_truncate_to_length$10$(Milky2018$selene$system$$timers, _p$5);
      return;
    }
  }
}
function Milky2018$selene$system$$deferred_event_system(_delta) {
  const _len = Milky2018$selene$system$$deferred_events.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const event = Milky2018$selene$system$$deferred_events[_i];
      event();
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$Array$clear$11$(Milky2018$selene$system$$deferred_events);
}
function Milky2018$selene$system$$defer_event(event) {
  moonbitlang$core$array$$Array$push$11$(Milky2018$selene$system$$deferred_events, event);
}
function Milky2018$selene$system$$App$new() {
  return { canvas_height: 256, canvas_width: 512, zoom: 1, image_smooth: true, fps: 60, systems: [], plugins: [] };
}
function Milky2018$selene$system$$App$with_image_smooth(self, image_smooth) {
  return { ...self, image_smooth: image_smooth };
}
function Milky2018$selene$system$$App$with_canvas_height(self, height) {
  return { ...self, canvas_height: height };
}
function Milky2018$selene$system$$App$with_canvas_width(self, width) {
  return { ...self, canvas_width: width };
}
function Milky2018$selene$system$$App$with_fps(self, fps) {
  return { ...self, fps: fps };
}
function Milky2018$selene$system$$App$with_zoom(self, zoom) {
  return { ...self, zoom: zoom };
}
function Milky2018$selene$system$$App$add_plugin(self, plugin) {
  const plugins = self.plugins;
  moonbitlang$core$array$$Array$push$57$(plugins, plugin);
  return { ...self, plugins: plugins };
}
function Milky2018$selene$system$$App$add_system$46$inner(self, system, schedule, system_name) {
  const _p = `unnamed_system${moonbitlang$core$builtin$$Show$to_string$52$(self.systems.length)}`;
  let system_name$2;
  if (system_name === undefined) {
    system_name$2 = _p;
  } else {
    const _p$2 = system_name;
    system_name$2 = _p$2;
  }
  const systems = self.systems;
  moonbitlang$core$array$$Array$push$56$(systems, { _0: system, _1: schedule, _2: system_name$2 });
  return { ...self, systems: systems };
}
function Milky2018$selene$system$$App$add_system(self, system, schedule$46$opt, system_name) {
  let schedule;
  if (schedule$46$opt === undefined) {
    schedule = $64$Milky2018$47$selene$47$system$46$Schedule$Update;
  } else {
    const _Some = schedule$46$opt;
    schedule = _Some;
  }
  return Milky2018$selene$system$$App$add_system$46$inner(self, system, schedule, system_name);
}
function Milky2018$selene$system$$App$run(self) {
  const _arr = self.plugins;
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const plugin = _arr[_i];
      plugin(self);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const startup = () => {
    const _arr$2 = self.systems;
    const _len$2 = _arr$2.length;
    let _tmp$2 = 0;
    while (true) {
      const _i = _tmp$2;
      if (_i < _len$2) {
        const system = _arr$2[_i];
        const _bind$8 = system._1;
        if (_bind$8.$tag === 0) {
          const _func = system._0;
          _func(0);
        }
        _tmp$2 = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  };
  const renders = [];
  const _arr$2 = self.systems;
  const _len$2 = _arr$2.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len$2) {
      const system = _arr$2[_i];
      const _bind$8 = system._1;
      if (_bind$8.$tag === 2) {
        const _Render = _bind$8;
        const _pri = _Render._0;
        moonbitlang$core$array$$Array$push$27$(renders, { _0: system._0, _1: _pri });
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$Array$sort_by_key$39$(renders, (system) => -system._1 | 0);
  const render_loop = (delta) => {
    const _len$3 = renders.length;
    let _tmp$3 = 0;
    while (true) {
      const _i = _tmp$3;
      if (_i < _len$3) {
        const render = renders[_i];
        const _func = render._0;
        _func(delta);
        _tmp$3 = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  };
  const game_loops = [];
  const _arr$3 = self.systems;
  const _len$3 = _arr$3.length;
  let _tmp$3 = 0;
  while (true) {
    const _i = _tmp$3;
    if (_i < _len$3) {
      const system = _arr$3[_i];
      const _bind$8 = system._1;
      if (_bind$8.$tag === 1) {
        moonbitlang$core$array$$Array$push$55$(game_loops, system._0);
      }
      _tmp$3 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const game_loop = (delta) => {
    const _len$4 = game_loops.length;
    let _tmp$4 = 0;
    while (true) {
      const _i = _tmp$4;
      if (_i < _len$4) {
        const system = game_loops[_i];
        system(delta);
        _tmp$4 = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  };
  const run_game = Milky2018$selene$backend$$initialize(startup, render_loop, game_loop, self.canvas_width, self.canvas_height, self.fps, self.image_smooth, self.zoom);
  Milky2018$selene$backend$$register_key_events(Milky2018$selene$inputs$$pressed_keys);
  Milky2018$selene$backend$$register_mouse_events(Milky2018$selene$inputs$$mouse, Milky2018$selene$inputs$$mouse_movement);
  run_game();
}
function moonbitlang$core$builtin$$Hash$hash_combine$3$(_x_29, _x_30) {
  moonbitlang$core$builtin$$Hash$hash_combine$28$(_x_29, _x_30);
}
function Milky2018$selene$entity$$iter_entities() {
  return moonbitlang$core$set$$Set$iter$3$(Milky2018$selene$entity$$all_entities);
}
function Milky2018$selene$entity$$Entity$is_alive(e) {
  return moonbitlang$core$set$$Set$contains$3$(Milky2018$selene$entity$$all_entities, e);
}
function Milky2018$selene$entity$$Entity$new() {
  const entity = Milky2018$selene$entity$$entity_generator.val;
  Milky2018$selene$entity$$entity_generator.val = (Milky2018$selene$entity$$entity_generator.val >>> 0) + (1 >>> 0) | 0;
  moonbitlang$core$set$$Set$add$3$(Milky2018$selene$entity$$all_entities, entity);
  return entity;
}
function Milky2018$selene$entity$$Entity$destroy(e) {
  Milky2018$selene$system$$defer_event(() => {
    moonbitlang$core$set$$Set$remove$3$(Milky2018$selene$entity$$all_entities, e);
  });
  const _bind$8 = moonbitlang$core$builtin$$Map$get$9$(Milky2018$selene$entity$$parents, e);
  if (_bind$8 === undefined) {
    return;
  } else {
    const _Some = _bind$8;
    const _p = _Some;
    const _arr = _p.children;
    const _len = _arr.length;
    let _tmp = 0;
    while (true) {
      const _i = _tmp;
      if (_i < _len) {
        const c = _arr[_i];
        Milky2018$selene$entity$$Entity$destroy(c);
        _tmp = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function Milky2018$selene$entity$$Entity$respawn(e) {
  Milky2018$selene$system$$defer_event(() => {
    moonbitlang$core$set$$Set$add$3$(Milky2018$selene$entity$$all_entities, e);
  });
  const _bind$8 = moonbitlang$core$builtin$$Map$get$9$(Milky2018$selene$entity$$parents, e);
  if (_bind$8 === undefined) {
    return;
  } else {
    const _Some = _bind$8;
    const _p = _Some;
    const _arr = _p.children;
    const _len = _arr.length;
    let _tmp = 0;
    while (true) {
      const _i = _tmp;
      if (_i < _len) {
        const c = _arr[_i];
        Milky2018$selene$entity$$Entity$respawn(c);
        _tmp = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function Milky2018$selene$entity$$Entity$spawn_child(parent, offset) {
  const child_entity = Milky2018$selene$entity$$Entity$new();
  const p = moonbitlang$core$builtin$$Map$get_or_init$9$(Milky2018$selene$entity$$parents, parent, () => ({ children: [], is_root: !moonbitlang$core$builtin$$Map$contains$8$(Milky2018$selene$entity$$children, parent) }));
  moonbitlang$core$array$$Array$push$3$(p.children, child_entity);
  moonbitlang$core$builtin$$Map$set$8$(Milky2018$selene$entity$$children, child_entity, { parent: parent, offset: moonbitlang$core$option$$Option$unwrap_or_default$43$(offset) });
  return child_entity;
}
function Milky2018$selene$entity$$Entity$get_children(parent) {
  return moonbitlang$core$option$$Option$map_or$70$(moonbitlang$core$builtin$$Map$get$9$(Milky2018$selene$entity$$parents, parent), [], (p) => p.children);
}
function Milky2018$selene$entity$$Entity$is_child(entity) {
  return moonbitlang$core$builtin$$Map$contains$8$(Milky2018$selene$entity$$children, entity);
}
function Milky2018$selene$entity$$Entity$set_offset(child, offset) {
  const _p = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$entity$$children, child);
  let _tmp;
  if (_p === undefined) {
    _tmp = $panic();
  } else {
    const _p$2 = _p;
    _tmp = _p$2;
  }
  _tmp.offset = offset;
}
function Milky2018$selene$entity$$get_roots() {
  const _bind$8 = moonbitlang$core$builtin$$Map$iter$9$(Milky2018$selene$entity$$parents);
  return (_p) => _bind$8((_p$2) => _p$2._1.is_root && Milky2018$selene$entity$$Entity$is_alive(_p$2._0) ? _p(_p$2._0) : 1);
}
function Milky2018$selene$camera$$set_limits(top, bottom, left, right) {
  Milky2018$selene$camera$$camera.limit_top = top;
  Milky2018$selene$camera$$camera.limit_bottom = bottom;
  Milky2018$selene$camera$$camera.limit_left = left;
  Milky2018$selene$camera$$camera.limit_right = right;
}
function Milky2018$selene$camera$$attach_entity(entity, offset) {
  Milky2018$selene$camera$$camera.attached_entity = entity;
  Milky2018$selene$camera$$camera.offset = offset;
}
function Milky2018$selene$camera$$camera_system(_delta) {
  const _bind$8 = Milky2018$selene$camera$$camera.attached_entity;
  if (_bind$8 === undefined) {
    return;
  } else {
    const _Some = _bind$8;
    const _e = _Some;
    const _bind$9 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
    if (_bind$9 === undefined) {
      return;
    } else {
      const _Some$2 = _bind$9;
      const _pos = _Some$2;
      const zoom = Milky2018$selene$backend$$canvas_backend.zoom;
      const _p = Milky2018$selene$backend$$canvas_backend.viewport_size;
      const _p$2 = { _0: 1 / zoom, _1: 1 / zoom };
      const viewport_size = { _0: _p._0 * _p$2._0, _1: _p._1 * _p$2._1 };
      const _p$3 = { _0: 0.5, _1: 0.5 };
      const _p$4 = { _0: viewport_size._0 * _p$3._0, _1: viewport_size._1 * _p$3._1 };
      const _p$5 = { _0: _pos._0 - _p$4._0, _1: _pos._1 - _p$4._1 };
      const _p$6 = Milky2018$selene$camera$$camera.offset;
      const target_position = { _0: _p$5._0 + _p$6._0, _1: _p$5._1 + _p$6._1 };
      const new_x = Milky2018$selene$camera$$camera.follow_x ? Milky2018$selene$math$$Vec2D$op_get(target_position, 0) : Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 0);
      const new_y = Milky2018$selene$camera$$camera.follow_y ? Milky2018$selene$math$$Vec2D$op_get(target_position, 1) : Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 1);
      Milky2018$selene$camera$$camera.position = { _0: new_x, _1: new_y };
      const _bind$10 = Milky2018$selene$camera$$camera.limit_top;
      if (_bind$10.$tag === 1) {
        const _Some$3 = _bind$10;
        const _top = _Some$3._0;
        if (Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 1) < _top) {
          Milky2018$selene$camera$$camera.position = { _0: Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 0), _1: _top };
        }
      }
      const _bind$11 = Milky2018$selene$camera$$camera.limit_bottom;
      if (_bind$11.$tag === 1) {
        const _Some$3 = _bind$11;
        const _bottom = _Some$3._0;
        if (Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 1) > _bottom - Milky2018$selene$math$$Vec2D$op_get(viewport_size, 1)) {
          Milky2018$selene$camera$$camera.position = { _0: Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 0), _1: _bottom - Milky2018$selene$math$$Vec2D$op_get(viewport_size, 1) };
        }
      }
      const _bind$12 = Milky2018$selene$camera$$camera.limit_left;
      if (_bind$12.$tag === 1) {
        const _Some$3 = _bind$12;
        const _left = _Some$3._0;
        if (Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 0) < _left) {
          Milky2018$selene$camera$$camera.position = { _0: _left, _1: Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 1) };
        }
      }
      const _bind$13 = Milky2018$selene$camera$$camera.limit_right;
      if (_bind$13.$tag === 1) {
        const _Some$3 = _bind$13;
        const _right = _Some$3._0;
        if (Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 0) > _right - Milky2018$selene$math$$Vec2D$op_get(viewport_size, 0)) {
          Milky2018$selene$camera$$camera.position = { _0: _right - Milky2018$selene$math$$Vec2D$op_get(viewport_size, 0), _1: Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 1) };
          return;
        } else {
          return;
        }
      } else {
        return;
      }
    }
  }
}
function Milky2018$selene$ui$$Ui$new() {
  ({});
}
function Milky2018$selene$collision$$QuadTree$new(position, size, depth) {
  const _bind$8 = moonbitlang$core$set$$Set$new$46$inner$3$(8);
  const _bind$9 = [];
  const _bind$10 = { position: position, size: size };
  return { position: position, size: size, children: _bind$9, depth: depth, bounding_box: _bind$10, entities: _bind$8 };
}
function Milky2018$selene$collision$$QuadTree$is_smallest_size(self) {
  return Milky2018$selene$math$$Vec2D$op_get(self.size, 0) <= 64 || Milky2018$selene$math$$Vec2D$op_get(self.size, 1) <= 64;
}
function Milky2018$selene$collision$$QuadTree$insert(self, entity, box) {
  if (!Milky2018$selene$math$$Rect$intersects(self.bounding_box, box)) {
    return undefined;
  }
  if (Milky2018$selene$collision$$QuadTree$is_smallest_size(self)) {
    moonbitlang$core$set$$Set$add$3$(self.entities, entity);
    return undefined;
  }
  const _p = self.children;
  if (_p.length === 0) {
    const half_size = { _0: Milky2018$selene$math$$Vec2D$op_get(self.size, 0) * 0.5, _1: Milky2018$selene$math$$Vec2D$op_get(self.size, 1) * 0.5 };
    const _self = self.children;
    moonbitlang$core$array$$Array$push$19$(_self, Milky2018$selene$collision$$QuadTree$new(self.position, half_size, self.depth + 1 | 0));
    const _p$2 = self.position;
    const _p$3 = { _0: Milky2018$selene$math$$Vec2D$op_get(half_size, 0), _1: 0 };
    moonbitlang$core$array$$Array$push$19$(_self, Milky2018$selene$collision$$QuadTree$new({ _0: _p$2._0 + _p$3._0, _1: _p$2._1 + _p$3._1 }, half_size, self.depth + 1 | 0));
    const _p$4 = self.position;
    const _p$5 = { _0: 0, _1: Milky2018$selene$math$$Vec2D$op_get(half_size, 1) };
    moonbitlang$core$array$$Array$push$19$(_self, Milky2018$selene$collision$$QuadTree$new({ _0: _p$4._0 + _p$5._0, _1: _p$4._1 + _p$5._1 }, half_size, self.depth + 1 | 0));
    const _p$6 = self.position;
    moonbitlang$core$array$$Array$push$19$(_self, Milky2018$selene$collision$$QuadTree$new({ _0: _p$6._0 + half_size._0, _1: _p$6._1 + half_size._1 }, half_size, self.depth + 1 | 0));
  }
  const _arr = self.children;
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const child = _arr[_i];
      Milky2018$selene$collision$$QuadTree$insert(child, entity, box);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$collision$$quadtree_query(area) {
  const _bind$8 = [Milky2018$selene$collision$$quadtree_root.val];
  const trees = { val: moonbitlang$core$list$$List$from_array$19$({ buf: _bind$8, start: 0, end: 1 }) };
  let results = moonbitlang$core$set$$Set$new$46$inner$3$(8);
  while (true) {
    const _bind$9 = trees.val;
    if (_bind$9.$tag === 1) {
      const _More = _bind$9;
      const _hd = _More._0;
      const _rest = _More._1;
      trees.val = _rest;
      if (!Milky2018$selene$math$$Rect$intersects(_hd.bounding_box, area)) {
        continue;
      }
      const _bind$10 = _hd.children;
      if (_bind$10.length === 0) {
        results = moonbitlang$core$set$$Set$union$3$(results, _hd.entities);
      } else {
        const _p = _hd.children;
        const _p$2 = _p.length;
        let _tmp = 0;
        while (true) {
          const _p$3 = _tmp;
          if (_p$3 < _p$2) {
            const _p$4 = _p[_p$3];
            const _p$5 = trees.val;
            trees.val = new $64$moonbitlang$47$core$47$list$46$List$More$2$(_p$4, _p$5);
            _tmp = _p$3 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      }
      continue;
    } else {
      break;
    }
  }
  return results;
}
function Milky2018$selene$collision$$quadtree_clear_system(_delta) {
  let left_limit = 0;
  let right_limit = 0;
  let top_limit = 0;
  let bottom_limit = 0;
  const boxes = [];
  const _it = moonbitlang$core$builtin$$Map$iterator2$5$(Milky2018$selene$collision$$shapes);
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator2$next$5$(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      const _shape = _x._1;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        const _bind$9 = moonbitlang$core$builtin$$Map$get$1$(Milky2018$selene$ui$$uis, _e);
        if (_bind$9 === -1) {
          const _bind$10 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
          if (_bind$10 === undefined) {
            continue;
          } else {
            const _Some$2 = _bind$10;
            const _position = _Some$2;
            const _Rect = _shape;
            const _x$2 = _Rect._0;
            const _width = _x$2._0;
            const _height = _x$2._1;
            const _offset = _Rect._1;
            const _bind$11 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
            const _bind$12 = { _0: _width, _1: _height };
            const box = { position: _bind$11, size: _bind$12 };
            moonbitlang$core$array$$Array$push$58$(boxes, { _0: _e, _1: box });
            const _p = left_limit;
            const _p$2 = Milky2018$selene$math$$Vec2D$op_get(_bind$11, 0);
            left_limit = _p > _p$2 ? _p$2 : _p;
            const _p$3 = right_limit;
            const _p$4 = Milky2018$selene$math$$Vec2D$op_get(_bind$11, 0) + Milky2018$selene$math$$Vec2D$op_get(_bind$12, 0);
            right_limit = _p$3 > _p$4 ? _p$3 : _p$4;
            const _p$5 = top_limit;
            const _p$6 = Milky2018$selene$math$$Vec2D$op_get(_bind$11, 1);
            top_limit = _p$5 > _p$6 ? _p$6 : _p$5;
            const _p$7 = bottom_limit;
            const _p$8 = Milky2018$selene$math$$Vec2D$op_get(_bind$11, 1) + Milky2018$selene$math$$Vec2D$op_get(_bind$12, 1);
            bottom_limit = _p$7 > _p$8 ? _p$7 : _p$8;
          }
        } else {
          continue;
        }
      } else {
        continue;
      }
      continue;
    }
  }
  Milky2018$selene$collision$$quadtree_root.val = Milky2018$selene$collision$$QuadTree$new({ _0: left_limit, _1: top_limit }, { _0: right_limit - left_limit, _1: bottom_limit - top_limit }, 0);
  const _len = boxes.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const box = boxes[_i];
      Milky2018$selene$collision$$QuadTree$insert(Milky2018$selene$collision$$quadtree_root.val, box._0, box._1);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$collision$$Pickable$new() {
  return { on_pressed_callbacks: [], on_released_callbacks: [], on_just_pressed_callbacks: [], on_just_released_callbacks: [] };
}
function Milky2018$selene$collision$$Pickable$on_just_pressed(self, callback) {
  moonbitlang$core$array$$Array$push$60$(self.on_just_pressed_callbacks, callback);
}
function Milky2018$selene$collision$$pickable_click_system(_delta) {
  const zoom = Milky2018$selene$backend$$canvas_backend.zoom;
  const _bind$8 = { _0: 1, _1: 1 };
  const _p = Milky2018$selene$inputs$$mouse.pos;
  const _p$2 = { _0: 1 / zoom, _1: 1 / zoom };
  const _bind$9 = { _0: _p._0 * _p$2._0, _1: _p._1 * _p$2._1 };
  const box = { position: _bind$9, size: _bind$8 };
  const _it = moonbitlang$core$builtin$$Map$iterator2$1$(Milky2018$selene$ui$$uis);
  while (true) {
    const _bind$10 = moonbitlang$core$builtin$$Iterator2$next$1$(_it);
    if (_bind$10 === undefined) {
      break;
    } else {
      const _Some = _bind$10;
      const _x = _Some;
      const _e = _x._0;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        const _bind$11 = moonbitlang$core$builtin$$Map$get$7$(Milky2018$selene$collision$$pickables, _e);
        if (_bind$11 === undefined) {
          continue;
        } else {
          const _Some$2 = _bind$11;
          const _pick = _Some$2;
          const _bind$12 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
          if (_bind$12 === undefined) {
            continue;
          } else {
            const _Some$3 = _bind$12;
            const _position = _Some$3;
            const _bind$13 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, _e);
            if (_bind$13 === undefined) {
              continue;
            } else {
              const _Some$4 = _bind$13;
              const _shape = _Some$4;
              const _Rect = _shape;
              const _x$2 = _Rect._0;
              const _width = _x$2._0;
              const _height = _x$2._1;
              const _offset = _Rect._1;
              const _bind$14 = { _0: _width, _1: _height };
              const _bind$15 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
              const area_box = { position: _bind$15, size: _bind$14 };
              if (!Milky2018$selene$math$$Rect$intersects(box, area_box)) {
                continue;
              }
              const _arr = [0, 1, 2];
              const _len = _arr.length;
              let _tmp = 0;
              while (true) {
                const _i = _tmp;
                if (_i < _len) {
                  const button = _arr[_i];
                  if (Milky2018$selene$inputs$$is_mouse_pressed(button)) {
                    const _arr$2 = _pick.on_pressed_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2 = 0;
                    while (true) {
                      const _i$2 = _tmp$2;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_released(button)) {
                    const _arr$2 = _pick.on_released_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2 = 0;
                    while (true) {
                      const _i$2 = _tmp$2;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_just_pressed(button)) {
                    const _arr$2 = _pick.on_just_pressed_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2 = 0;
                    while (true) {
                      const _i$2 = _tmp$2;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_just_released(button)) {
                    const _arr$2 = _pick.on_just_released_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2 = 0;
                    while (true) {
                      const _i$2 = _tmp$2;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  _tmp = _i + 1 | 0;
                  continue;
                } else {
                  break;
                }
              }
            }
          }
        }
      } else {
        continue;
      }
      continue;
    }
  }
  const entities = Milky2018$selene$collision$$quadtree_query(box);
  const _it$2 = moonbitlang$core$set$$Set$iterator$3$(entities);
  while (true) {
    const _bind$10 = moonbitlang$core$builtin$$Iterator$next$3$(_it$2);
    if (_bind$10 === undefined) {
      return;
    } else {
      const _Some = _bind$10;
      const _e = _Some;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        const _bind$11 = moonbitlang$core$builtin$$Map$get$7$(Milky2018$selene$collision$$pickables, _e);
        if (_bind$11 === undefined) {
          continue;
        } else {
          const _Some$2 = _bind$11;
          const _pick = _Some$2;
          const _bind$12 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
          if (_bind$12 === undefined) {
            continue;
          } else {
            const _Some$3 = _bind$12;
            const _position = _Some$3;
            const _bind$13 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, _e);
            if (_bind$13 === undefined) {
              continue;
            } else {
              const _Some$4 = _bind$13;
              const _shape = _Some$4;
              const _Rect = _shape;
              const _x = _Rect._0;
              const _width = _x._0;
              const _height = _x._1;
              const _offset = _Rect._1;
              const _bind$14 = { _0: _width, _1: _height };
              const _bind$15 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
              const area_box = { position: _bind$15, size: _bind$14 };
              if (!Milky2018$selene$math$$Rect$intersects(Milky2018$selene$math$$Rect$shift(box, Milky2018$selene$camera$$camera.position), area_box)) {
                continue;
              }
              const _arr = [0, 1, 2];
              const _len = _arr.length;
              let _tmp = 0;
              while (true) {
                const _i = _tmp;
                if (_i < _len) {
                  const button = _arr[_i];
                  if (Milky2018$selene$inputs$$is_mouse_pressed(button)) {
                    const _arr$2 = _pick.on_pressed_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2 = 0;
                    while (true) {
                      const _i$2 = _tmp$2;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_released(button)) {
                    const _arr$2 = _pick.on_released_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2 = 0;
                    while (true) {
                      const _i$2 = _tmp$2;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_just_pressed(button)) {
                    const _arr$2 = _pick.on_just_pressed_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2 = 0;
                    while (true) {
                      const _i$2 = _tmp$2;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_just_released(button)) {
                    const _arr$2 = _pick.on_just_released_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2 = 0;
                    while (true) {
                      const _i$2 = _tmp$2;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  _tmp = _i + 1 | 0;
                  continue;
                } else {
                  break;
                }
              }
            }
          }
        }
      } else {
        continue;
      }
      continue;
    }
  }
}
function Milky2018$selene$collision$$aabb_resolve(a, b) {
  const _p = a.position;
  const _p$2 = a.size;
  const _p$3 = 0.5;
  const _p$4 = { _0: _p$2._0 * _p$3, _1: _p$2._1 * _p$3 };
  const a_center = { _0: _p._0 + _p$4._0, _1: _p._1 + _p$4._1 };
  const _p$5 = b.position;
  const _p$6 = b.size;
  const _p$7 = 0.5;
  const _p$8 = { _0: _p$6._0 * _p$7, _1: _p$6._1 * _p$7 };
  const b_center = { _0: _p$5._0 + _p$8._0, _1: _p$5._1 + _p$8._1 };
  const _p$9 = a.size;
  const _p$10 = 0.5;
  const a_half = { _0: _p$9._0 * _p$10, _1: _p$9._1 * _p$10 };
  const _p$11 = b.size;
  const _p$12 = 0.5;
  const b_half = { _0: _p$11._0 * _p$12, _1: _p$11._1 * _p$12 };
  const delta = { _0: b_center._0 - a_center._0, _1: b_center._1 - a_center._1 };
  const intersect = { _0: -Math.abs(Milky2018$selene$math$$Vec2D$op_get(delta, 0)) + (Milky2018$selene$math$$Vec2D$op_get(b_half, 0) + Milky2018$selene$math$$Vec2D$op_get(a_half, 0)), _1: -Math.abs(Milky2018$selene$math$$Vec2D$op_get(delta, 1)) + (Milky2018$selene$math$$Vec2D$op_get(b_half, 1) + Milky2018$selene$math$$Vec2D$op_get(a_half, 1)) };
  return Milky2018$selene$math$$Vec2D$op_get(intersect, 0) < Milky2018$selene$math$$Vec2D$op_get(intersect, 1) && Milky2018$selene$math$$Vec2D$op_get(intersect, 0) > 0 ? (Milky2018$selene$math$$Vec2D$op_get(delta, 0) > 0 ? { _0: -Milky2018$selene$math$$Vec2D$op_get(intersect, 0), _1: 0 } : { _0: Milky2018$selene$math$$Vec2D$op_get(intersect, 0), _1: 0 }) : Milky2018$selene$math$$Vec2D$op_get(intersect, 1) > 0 && Milky2018$selene$math$$Vec2D$op_get(intersect, 0) > 0 ? (Milky2018$selene$math$$Vec2D$op_get(delta, 1) > 0 ? { _0: 0, _1: -Milky2018$selene$math$$Vec2D$op_get(intersect, 1) } : { _0: 0, _1: Milky2018$selene$math$$Vec2D$op_get(intersect, 1) }) : { _0: 0, _1: 0 };
}
function Milky2018$selene$collision$$add_collision_info(entity, target, direction) {
  const _bind$8 = moonbitlang$core$builtin$$Map$get$20$(Milky2018$selene$collision$$collision_infos, entity);
  if (_bind$8.$tag === 0) {
    moonbitlang$core$builtin$$Map$set$20$(Milky2018$selene$collision$$collision_infos, entity, moonbitlang$core$array$$Array$new$46$inner$54$(0));
  }
  moonbitlang$core$array$$Array$push$54$(moonbitlang$core$option$$Option$unwrap$69$(moonbitlang$core$builtin$$Map$get$20$(Milky2018$selene$collision$$collision_infos, entity)), { entity: target, direction: direction });
}
function Milky2018$selene$collision$$make_ray_collision(object, speed, axis) {
  const pos = { _0: Milky2018$selene$math$$Vec2D$op_get(object.position, 0), _1: Milky2018$selene$math$$Vec2D$op_get(object.position, 1) };
  const size = { _0: Milky2018$selene$math$$Vec2D$op_get(object.size, 0), _1: Milky2018$selene$math$$Vec2D$op_get(object.size, 1) };
  return speed >= 0 ? { position: pos, size: Milky2018$selene$math$$Vec2D$update(size, axis, Milky2018$selene$math$$Vec2D$op_get(size, axis) + speed) } : { position: Milky2018$selene$math$$Vec2D$update(pos, axis, Milky2018$selene$math$$Vec2D$op_get(pos, axis) + speed), size: Milky2018$selene$math$$Vec2D$update(size, axis, Milky2018$selene$math$$Vec2D$op_get(size, axis) - speed) };
}
function Milky2018$selene$collision$$CollisionMask$contains(self, layer) {
  return moonbitlang$core$array$$Array$contains$75$(self, layer);
}
function Milky2018$selene$collision$$move_axis(entity, object, velocity, axis, mask) {
  const ray_collision = Milky2018$selene$collision$$make_ray_collision(object, Milky2018$selene$math$$Vec2D$op_get(velocity, axis), axis);
  let new_pos = { _0: Milky2018$selene$math$$Vec2D$op_get(object.position, 0), _1: Milky2018$selene$math$$Vec2D$op_get(object.position, 1) };
  new_pos = Milky2018$selene$math$$Vec2D$update(new_pos, axis, Milky2018$selene$math$$Vec2D$op_get(new_pos, axis) + Milky2018$selene$math$$Vec2D$op_get(velocity, axis));
  let new_velocity = velocity;
  const entities = Milky2018$selene$collision$$quadtree_query(ray_collision);
  const _it = moonbitlang$core$set$$Set$iterator$3$(entities);
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator$next$3$(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _e = _Some;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        if (moonbitlang$core$builtin$$op_notequal$3$(_e, entity)) {
          const _bind$9 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, _e);
          if (_bind$9 === undefined) {
            continue;
          } else {
            const _Some$2 = _bind$9;
            const _shape = _Some$2;
            const _Rect = _shape;
            const _x = _Rect._0;
            const _width = _x._0;
            const _height = _x._1;
            const _offset = _Rect._1;
            const _bind$10 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
            if (_bind$10 === undefined) {
              continue;
            } else {
              const _Some$3 = _bind$10;
              const _pos = _Some$3;
              const _bind$11 = moonbitlang$core$builtin$$Map$get$12$(Milky2018$selene$collision$$collision_layers, _e);
              if (_bind$11 === undefined) {
                continue;
              } else {
                const _Some$4 = _bind$11;
                const _collision_layer = _Some$4;
                if (Milky2018$selene$collision$$CollisionMask$contains(mask, _collision_layer)) {
                  const _bind$12 = { _0: _width, _1: _height };
                  const _bind$13 = { _0: _pos._0 + _offset._0, _1: _pos._1 + _offset._1 };
                  const collision_box = { position: _bind$13, size: _bind$12 };
                  if (Milky2018$selene$math$$Rect$intersects(object, collision_box)) {
                    const movement = Milky2018$selene$collision$$aabb_resolve(object, collision_box);
                    const _p = new_pos;
                    new_pos = { _0: _p._0 + movement._0, _1: _p._1 + movement._1 };
                    const dir = Milky2018$selene$math$$Vec2D$update({ _0: 0, _1: 0 }, axis, Milky2018$selene$math$$Vec2D$op_get(movement, axis) > 0 ? 1 : -1);
                    Milky2018$selene$collision$$add_collision_info(entity, _e, dir);
                    return { _0: new_pos, _1: movement };
                  }
                  if (Milky2018$selene$math$$Rect$intersects(ray_collision, collision_box)) {
                    let dir = { _0: 0, _1: 0 };
                    if (Milky2018$selene$math$$Vec2D$op_get(new_velocity, axis) > 0) {
                      const _tmp = new_pos;
                      const _p = Milky2018$selene$math$$Vec2D$op_get(_bind$13, axis) - Milky2018$selene$math$$Vec2D$op_get(object.size, axis);
                      const _p$2 = Milky2018$selene$math$$Vec2D$op_get(object.position, axis);
                      new_pos = Milky2018$selene$math$$Vec2D$update(_tmp, axis, _p > _p$2 ? _p : _p$2);
                      new_velocity = Milky2018$selene$math$$Vec2D$update(new_velocity, axis, Milky2018$selene$math$$Vec2D$op_get(new_pos, axis) - Milky2018$selene$math$$Vec2D$op_get(object.position, axis));
                      dir = Milky2018$selene$math$$Vec2D$update(dir, axis, 1);
                    } else {
                      if (Milky2018$selene$math$$Vec2D$op_get(new_velocity, axis) < 0) {
                        const _tmp = new_pos;
                        const _p = Milky2018$selene$math$$Vec2D$op_get(_bind$13, axis) + Milky2018$selene$math$$Vec2D$op_get(_bind$12, axis);
                        const _p$2 = Milky2018$selene$math$$Vec2D$op_get(object.position, axis);
                        new_pos = Milky2018$selene$math$$Vec2D$update(_tmp, axis, _p > _p$2 ? _p$2 : _p);
                        new_velocity = Milky2018$selene$math$$Vec2D$update(new_velocity, axis, Milky2018$selene$math$$Vec2D$op_get(new_pos, axis) - Milky2018$selene$math$$Vec2D$op_get(object.position, axis));
                        dir = Milky2018$selene$math$$Vec2D$update(dir, axis, -1);
                      }
                    }
                    Milky2018$selene$collision$$add_collision_info(entity, _e, dir);
                  }
                } else {
                  continue;
                }
              }
            }
          }
        } else {
          continue;
        }
      } else {
        continue;
      }
      continue;
    }
  }
  return { _0: new_pos, _1: new_velocity };
}
function Milky2018$selene$collision$$move_with_collide(e, collider, velocity) {
  const _bind$8 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, e);
  if (_bind$8 === undefined) {
    return $panic();
  } else {
    const _Some = _bind$8;
    const _pos = _Some;
    const _bind$9 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, e);
    if (_bind$9 === undefined) {
      return $panic();
    } else {
      const _Some$2 = _bind$9;
      const _shape = _Some$2;
      const _Rect = _shape;
      const _x = _Rect._0;
      const _width = _x._0;
      const _height = _x._1;
      const _offset = _Rect._1;
      const _bind$10 = { _0: _pos._0 + _offset._0, _1: _pos._1 + _offset._1 };
      const _bind$11 = { _0: _width, _1: _height };
      const box = { position: _bind$10, size: _bind$11 };
      const new_x = Milky2018$selene$collision$$move_axis(e, box, velocity, 0, collider.mask);
      const _bind$12 = new_x._0;
      const object_x = { position: _bind$12, size: _bind$11 };
      const new_y = Milky2018$selene$collision$$move_axis(e, object_x, new_x._1, 1, collider.mask);
      const _p = new_y._0;
      moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, e, { _0: _p._0 - _offset._0, _1: _p._1 - _offset._1 });
      return new_y._1;
    }
  }
}
function Milky2018$selene$collision$$move_without_collide(e, velocity) {
  const _bind$8 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, e);
  if (_bind$8 === undefined) {
    $panic();
    return;
  } else {
    const _Some = _bind$8;
    const _pos = _Some;
    const new_pos = { _0: Milky2018$selene$math$$Vec2D$op_get(_pos, 0) + Milky2018$selene$math$$Vec2D$op_get(velocity, 0), _1: Milky2018$selene$math$$Vec2D$op_get(_pos, 1) + Milky2018$selene$math$$Vec2D$op_get(velocity, 1) };
    moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, e, new_pos);
    return;
  }
}
function Milky2018$selene$collision$$move_system(delta) {
  moonbitlang$core$builtin$$Map$clear$20$(Milky2018$selene$collision$$collision_infos);
  const _it = moonbitlang$core$builtin$$Map$iterator2$14$(Milky2018$selene$velocity$$velocities);
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator2$next$14$(_it);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      const _vel = _x._1;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        _L: {
          _L$2: {
            const _bind$9 = moonbitlang$core$builtin$$Map$get$17$(Milky2018$selene$collision$$colliders, _e);
            if (_bind$9 === undefined) {
              break _L$2;
            } else {
              const _Some$2 = _bind$9;
              const _collide = _Some$2;
              if (_collide.active) {
                const new_vel = Milky2018$selene$collision$$move_with_collide(_e, _collide, { _0: _vel._0 * delta, _1: _vel._1 * delta });
                moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$collision$$real_velocities, _e, { _0: new_vel._0 / delta, _1: new_vel._1 / delta });
              } else {
                break _L$2;
              }
            }
            break _L;
          }
          Milky2018$selene$collision$$move_without_collide(_e, { _0: _vel._0 * delta, _1: _vel._1 * delta });
          moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$collision$$real_velocities, _e, _vel);
        }
      } else {
        continue;
      }
      continue;
    }
  }
}
function Milky2018$selene$collision$$CollisionLayer$new() {
  const layer = Milky2018$selene$collision$$collision_layer_generator.val;
  Milky2018$selene$collision$$collision_layer_generator.val = (Milky2018$selene$collision$$collision_layer_generator.val >>> 0) + (1 >>> 0) | 0;
  return layer;
}
function Milky2018$selene$collision$$Collider$new(mask) {
  return { active: true, mask: mask };
}
function Milky2018$selene$collision$$Area$new(mask) {
  const _bind$8 = moonbitlang$core$set$$Set$new$46$inner$3$(8);
  const _bind$9 = [];
  const _bind$10 = [];
  return { mask: mask, on_enter_callbacks: _bind$9, on_exit_callbacks: _bind$10, contains: _bind$8 };
}
function Milky2018$selene$collision$$Area$on_enter(self, callback) {
  moonbitlang$core$array$$Array$push$59$(self.on_enter_callbacks, callback);
}
function Milky2018$selene$collision$$area_collide_system(_delta) {
  let _foreach_result = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$11$;
  const _bind$8 = Milky2018$selene$entity$$iter_entities();
  _bind$8((e) => {
    const _bind$9 = moonbitlang$core$builtin$$Map$get$13$(Milky2018$selene$collision$$areas, e);
    if (_bind$9 === undefined) {
      return 1;
    } else {
      const _Some = _bind$9;
      const _area = _Some;
      const _bind$10 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, e);
      if (_bind$10 === undefined) {
        $panic();
      } else {
        const _Some$2 = _bind$10;
        const _position = _Some$2;
        const _bind$11 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, e);
        if (_bind$11 === undefined) {
          return 1;
        } else {
          const _Some$3 = _bind$11;
          const _shape = _Some$3;
          const _Rect = _shape;
          const _x = _Rect._0;
          const _width = _x._0;
          const _height = _x._1;
          const _offset = _Rect._1;
          const _bind$12 = { _0: _width, _1: _height };
          const _bind$13 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
          const box = { position: _bind$13, size: _bind$12 };
          const new_contains = moonbitlang$core$set$$Set$new$46$inner$3$(8);
          const entities = Milky2018$selene$collision$$quadtree_query(box);
          const _it = moonbitlang$core$set$$Set$iterator$3$(entities);
          while (true) {
            const _bind$14 = moonbitlang$core$builtin$$Iterator$next$3$(_it);
            if (_bind$14 === undefined) {
              break;
            } else {
              const _Some$4 = _bind$14;
              const _entity = _Some$4;
              if (Milky2018$selene$entity$$Entity$is_alive(_entity)) {
                const _bind$15 = moonbitlang$core$builtin$$Map$get$12$(Milky2018$selene$collision$$collision_layers, _entity);
                if (_bind$15 === undefined) {
                  continue;
                } else {
                  const _Some$5 = _bind$15;
                  const _other_layer = _Some$5;
                  const _bind$16 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, _entity);
                  if (_bind$16 === undefined) {
                    continue;
                  } else {
                    const _Some$6 = _bind$16;
                    const _other_shape = _Some$6;
                    const _Rect$2 = _other_shape;
                    const _x$2 = _Rect$2._0;
                    const _other_width = _x$2._0;
                    const _other_height = _x$2._1;
                    const _other_offset = _Rect$2._1;
                    const _bind$17 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _entity);
                    if (_bind$17 === undefined) {
                      $panic();
                    } else {
                      const _Some$7 = _bind$17;
                      const _other_position = _Some$7;
                      const _bind$18 = { _0: _other_width, _1: _other_height };
                      const _bind$19 = { _0: _other_position._0 + _other_offset._0, _1: _other_position._1 + _other_offset._1 };
                      const other_box = { position: _bind$19, size: _bind$18 };
                      if (Milky2018$selene$math$$Rect$intersects(box, other_box)) {
                        if (Milky2018$selene$collision$$CollisionMask$contains(_area.mask, _other_layer)) {
                          moonbitlang$core$set$$Set$add$3$(new_contains, _entity);
                          if (moonbitlang$core$set$$Set$contains$3$(_area.contains, _entity)) {
                            continue;
                          }
                          const _arr = _area.on_enter_callbacks;
                          const _len = _arr.length;
                          let _tmp = 0;
                          while (true) {
                            const _i = _tmp;
                            if (_i < _len) {
                              const callback = _arr[_i];
                              callback(_entity);
                              _tmp = _i + 1 | 0;
                              continue;
                            } else {
                              break;
                            }
                          }
                        } else {
                          continue;
                        }
                      } else {
                        continue;
                      }
                    }
                  }
                }
              } else {
                continue;
              }
              continue;
            }
          }
          const _it$2 = moonbitlang$core$set$$Set$iterator$3$(_area.contains);
          while (true) {
            const _bind$14 = moonbitlang$core$builtin$$Iterator$next$3$(_it$2);
            if (_bind$14 === undefined) {
              break;
            } else {
              const _Some$4 = _bind$14;
              const _entity = _Some$4;
              if (moonbitlang$core$set$$Set$contains$3$(new_contains, _entity)) {
                continue;
              }
              const _arr = _area.on_exit_callbacks;
              const _len = _arr.length;
              let _tmp = 0;
              while (true) {
                const _i = _tmp;
                if (_i < _len) {
                  const callback = _arr[_i];
                  callback(_entity);
                  _tmp = _i + 1 | 0;
                  continue;
                } else {
                  break;
                }
              }
              continue;
            }
          }
          _area.contains = new_contains;
        }
      }
    }
    return 1;
  });
  const _tmp = _foreach_result;
  switch (_tmp.$tag) {
    case 0: {
      return;
    }
    case 1: {
      const _break = _tmp;
      _break._0;
      return;
    }
    case 2: {
      const _return = _tmp;
      _return._0;
      return;
    }
    case 3: {
      $panic();
      return;
    }
    default: {
      $panic();
      return;
    }
  }
}
function Milky2018$selene$inherit$$adjust_children(entity) {
  const _arr = Milky2018$selene$entity$$Entity$get_children(entity);
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      _L: {
        const c = _arr[_i];
        if (Milky2018$selene$entity$$Entity$is_alive(c)) {
          const _bind$8 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, entity);
          if (_bind$8 === undefined) {
            break _L;
          } else {
            const _Some = _bind$8;
            const _parent_position = _Some;
            const _p = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$entity$$children, c);
            let _tmp$2;
            if (_p === undefined) {
              _tmp$2 = $panic();
            } else {
              const _p$2 = _p;
              _tmp$2 = _p$2;
            }
            const offset = _tmp$2.offset;
            moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, c, { _0: _parent_position._0 + offset._0, _1: _parent_position._1 + offset._1 });
            Milky2018$selene$inherit$$adjust_children(c);
          }
        } else {
          break _L;
        }
        break _L;
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$inherit$$inherit_position_system(_delta) {
  const roots = Milky2018$selene$entity$$get_roots();
  roots((p) => {
    Milky2018$selene$inherit$$adjust_children(p);
    return 1;
  });
}
function Milky2018$selene$sprite$$Sprite$from_animation$46$inner(animation, zindex, offset) {
  const _bind$8 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Animation(animation, 0);
  return { sprite_type: _bind$8, zindex: zindex, visible: true, offset: offset };
}
function Milky2018$selene$sprite$$Sprite$from_animation(animation, zindex, offset$46$opt) {
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  return Milky2018$selene$sprite$$Sprite$from_animation$46$inner(animation, zindex, offset);
}
function Milky2018$selene$sprite$$Sprite$from_picture$46$inner(picture, zindex, offset) {
  const _bind$8 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Picture(picture);
  return { sprite_type: _bind$8, zindex: zindex, visible: true, offset: offset };
}
function Milky2018$selene$sprite$$Sprite$from_picture(picture, zindex, offset$46$opt) {
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  return Milky2018$selene$sprite$$Sprite$from_picture$46$inner(picture, zindex, offset);
}
function Milky2018$selene$sprite$$Sprite$from_text$46$inner(text, zindex, offset) {
  const _bind$8 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Text(text);
  return { sprite_type: _bind$8, zindex: zindex, visible: true, offset: offset };
}
function Milky2018$selene$sprite$$Sprite$from_text(text, zindex, offset$46$opt) {
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  return Milky2018$selene$sprite$$Sprite$from_text$46$inner(text, zindex, offset);
}
function Milky2018$selene$sprite$$Sprite$from_color_rect$46$inner(color_rect, zindex, offset) {
  const _bind$8 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$ColorRect(color_rect);
  return { sprite_type: _bind$8, zindex: zindex, visible: true, offset: offset };
}
function Milky2018$selene$sprite$$Sprite$from_color_rect(color_rect, zindex, offset$46$opt) {
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  return Milky2018$selene$sprite$$Sprite$from_color_rect$46$inner(color_rect, zindex, offset);
}
function Milky2018$selene$sprite$$render_animation(animation, current_frame, pos, visible, delta) {
  const frame = moonbitlang$core$array$$Array$at$45$(animation.frames, moonbitlang$core$double$$Double$to_int(current_frame));
  if (visible) {
    Milky2018$selene$backend$$draw_sprite(frame.sprite_path, Milky2018$selene$math$$Vec2D$op_get(pos, 0), Milky2018$selene$math$$Vec2D$op_get(pos, 1), Milky2018$selene$math$$Vec2D$op_get(frame.offset, 0), Milky2018$selene$math$$Vec2D$op_get(frame.offset, 1), Milky2018$selene$math$$Vec2D$op_get(frame.size, 0), Milky2018$selene$math$$Vec2D$op_get(frame.size, 1), animation.transform);
  }
  let new_frame = current_frame + animation.fps * delta;
  if (moonbitlang$core$double$$Double$to_int(new_frame) >= animation.frames.length) {
    if (animation.loop_) {
      new_frame = 0;
    } else {
      new_frame = animation.frames.length + 0 - 0.01;
    }
  }
  return new_frame;
}
function Milky2018$selene$sprite$$render_color_circle(color_circle, position) {
  Milky2018$selene$backend$$draw_color_circle(Milky2018$selene$math$$Vec2D$op_get(position, 0) + color_circle.radius, Milky2018$selene$math$$Vec2D$op_get(position, 1) + color_circle.radius, color_circle.radius, color_circle.color, color_circle.stroke_color);
}
function Milky2018$selene$sprite$$render_color_rect(color_rect, position) {
  Milky2018$selene$backend$$draw_color_rect(Milky2018$selene$math$$Vec2D$op_get(position, 0), Milky2018$selene$math$$Vec2D$op_get(position, 1), Milky2018$selene$math$$Vec2D$op_get(color_rect.size, 0), Milky2018$selene$math$$Vec2D$op_get(color_rect.size, 1), color_rect.color, color_rect.stroke_color);
}
function Milky2018$selene$sprite$$render_picture(picture, pos) {
  Milky2018$selene$backend$$draw_picture(picture.tile_path, Milky2018$selene$math$$Vec2D$op_get(pos, 0), Milky2018$selene$math$$Vec2D$op_get(pos, 1), Milky2018$selene$math$$Vec2D$op_get(picture.size, 0), Milky2018$selene$math$$Vec2D$op_get(picture.size, 1), picture.transform, picture.repeat);
}
function Milky2018$selene$sprite$$render_text(text, position) {
  Milky2018$selene$backend$$draw_text(text.content, Milky2018$selene$math$$Vec2D$op_get(position, 0), Milky2018$selene$math$$Vec2D$op_get(position, 1), text.font, text.color, text.align, text.baseline);
}
function Milky2018$selene$sprite$$render_sprite_system(delta) {
  const _p = moonbitlang$core$builtin$$Map$to_array$6$(Milky2018$selene$sprite$$sprites);
  const _p$2 = [];
  const _p$3 = _p.length;
  let _tmp = 0;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$3) {
      const _p$5 = _p[_p$4];
      if (Milky2018$selene$entity$$Entity$is_alive(_p$5._0)) {
        moonbitlang$core$array$$Array$push$29$(_p$2, _p$5);
      }
      _tmp = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const sprites = _p$2;
  moonbitlang$core$array$$Array$sort_by$29$(sprites, (sprite1, sprite2) => {
    if (sprite1._1.zindex < sprite2._1.zindex) {
      return -1;
    } else {
      if (sprite1._1.zindex > sprite2._1.zindex) {
        return 1;
      } else {
        const _bind$8 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, sprite1._0);
        if (_bind$8 === undefined) {
          return 0;
        } else {
          const _Some = _bind$8;
          const _pos1 = _Some;
          const _bind$9 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, sprite2._0);
          if (_bind$9 === undefined) {
            return 0;
          } else {
            const _Some$2 = _bind$9;
            const _pos2 = _Some$2;
            return Milky2018$selene$math$$Vec2D$op_get(_pos1, 1) < Milky2018$selene$math$$Vec2D$op_get(_pos2, 1) ? -1 : Milky2018$selene$math$$Vec2D$op_get(_pos1, 1) > Milky2018$selene$math$$Vec2D$op_get(_pos2, 1) ? 1 : 0;
          }
        }
      }
    }
  });
  const _len = sprites.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      _L: {
        const sprite = sprites[_i];
        const e = sprite._0;
        const sprite$2 = sprite._1;
        const _bind$8 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, e);
        if (_bind$8 === undefined) {
          break _L;
        } else {
          const _Some = _bind$8;
          const _pos = _Some;
          const _bind$9 = moonbitlang$core$builtin$$Map$get$1$(Milky2018$selene$ui$$uis, e);
          let pos;
          if (_bind$9 === -1) {
            const _p$4 = Milky2018$selene$camera$$camera.position;
            pos = { _0: _pos._0 - _p$4._0, _1: _pos._1 - _p$4._1 };
          } else {
            pos = _pos;
          }
          const _bind$10 = sprite$2.sprite_type;
          switch (_bind$10.$tag) {
            case 0: {
              const _Picture = _bind$10;
              const _picture = _Picture._0;
              if (sprite$2.visible) {
                const _p$4 = sprite$2.offset;
                Milky2018$selene$sprite$$render_picture(_picture, { _0: pos._0 + _p$4._0, _1: pos._1 + _p$4._1 });
              }
              break;
            }
            case 1: {
              const _Animation = _bind$10;
              const _anime = _Animation._0;
              const _frame = _Animation._1;
              const _p$4 = sprite$2.offset;
              const _tmp$3 = { _0: pos._0 + _p$4._0, _1: pos._1 + _p$4._1 };
              const new_frame = Milky2018$selene$sprite$$render_animation(_anime, _frame, _tmp$3, sprite$2.visible, delta);
              _Animation._1 = new_frame;
              break;
            }
            case 2: {
              const _Text = _bind$10;
              const _text = _Text._0;
              if (sprite$2.visible) {
                const _p$5 = sprite$2.offset;
                Milky2018$selene$sprite$$render_text(_text, { _0: pos._0 + _p$5._0, _1: pos._1 + _p$5._1 });
              }
              break;
            }
            case 3: {
              const _ColorRect = _bind$10;
              const _color_rect = _ColorRect._0;
              if (sprite$2.visible) {
                const _p$5 = sprite$2.offset;
                Milky2018$selene$sprite$$render_color_rect(_color_rect, { _0: pos._0 + _p$5._0, _1: pos._1 + _p$5._1 });
              }
              break;
            }
            default: {
              const _ColorCircle = _bind$10;
              const _color_circle = _ColorCircle._0;
              if (sprite$2.visible) {
                const _p$5 = sprite$2.offset;
                Milky2018$selene$sprite$$render_color_circle(_color_circle, { _0: pos._0 + _p$5._0, _1: pos._1 + _p$5._1 });
              }
            }
          }
        }
        break _L;
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$sprite$$Text$new$46$inner(content, color, font, baseline, align) {
  return { content: content, color: color, font: font, baseline: baseline, align: align };
}
function Milky2018$selene$sprite$$Text$new(content, color$46$opt, font$46$opt, baseline$46$opt, align$46$opt) {
  let color;
  if (color$46$opt === undefined) {
    color = "white";
  } else {
    const _Some = color$46$opt;
    color = _Some;
  }
  let font;
  if (font$46$opt === undefined) {
    font = "16px Arial";
  } else {
    const _Some = font$46$opt;
    font = _Some;
  }
  let baseline;
  if (baseline$46$opt === undefined) {
    baseline = 0;
  } else {
    const _Some = baseline$46$opt;
    baseline = _Some;
  }
  let align;
  if (align$46$opt === undefined) {
    align = 0;
  } else {
    const _Some = align$46$opt;
    align = _Some;
  }
  return Milky2018$selene$sprite$$Text$new$46$inner(content, color, font, baseline, align);
}
function Milky2018$selene$sprite$$ColorRect$new$46$inner(size, color, stroke_color) {
  return { size: size, color: color, stroke_color: stroke_color };
}
function Milky2018$selene$sprite$$Picture$new$46$inner(size, tile_path, transform, repeat) {
  return { size: size, tile_path: tile_path, transform: transform, repeat: repeat };
}
function Milky2018$selene$sprite$$Picture$new(size, tile_path, transform$46$opt, repeat$46$opt) {
  let transform;
  if (transform$46$opt === undefined) {
    transform = Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0);
  } else {
    const _Some = transform$46$opt;
    transform = _Some;
  }
  let repeat;
  if (repeat$46$opt === undefined) {
    repeat = 2;
  } else {
    const _Some = repeat$46$opt;
    repeat = _Some;
  }
  return Milky2018$selene$sprite$$Picture$new$46$inner(size, tile_path, transform, repeat);
}
function Milky2018$selene$sprite$$generate_animation() {
  const id = Milky2018$selene$sprite$$animation_generator.val;
  Milky2018$selene$sprite$$animation_generator.val = Milky2018$selene$sprite$$animation_generator.val + 1 | 0;
  return id;
}
function Milky2018$selene$sprite$$Animation$new$46$inner(frames, loop_, fps, transform) {
  const max_frame = frames.length;
  if (max_frame === 0) {
    moonbitlang$core$abort$$abort$25$("Animation must have at least one frame");
  }
  return { frames: frames, transform: transform, loop_: loop_, fps: fps, id: Milky2018$selene$sprite$$generate_animation() };
}
function Milky2018$selene$sprite$$Animation$new(frames, loop_$46$opt, fps$46$opt, transform$46$opt) {
  const loop_ = loop_$46$opt === -1 ? false : loop_$46$opt;
  let fps;
  if (fps$46$opt.$tag === 1) {
    const _Some = fps$46$opt;
    fps = _Some._0;
  } else {
    fps = 1;
  }
  let transform;
  if (transform$46$opt === undefined) {
    transform = Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0);
  } else {
    const _Some = transform$46$opt;
    transform = _Some;
  }
  return Milky2018$selene$sprite$$Animation$new$46$inner(frames, loop_, fps, transform);
}
function Milky2018$selene$sprite$$Animation$single_frame$46$inner(sprite_path, size, transform, offset) {
  return Milky2018$selene$sprite$$Animation$new$46$inner([{ sprite_path: sprite_path, size: size, offset: offset }], false, 0, transform);
}
function Milky2018$selene$sprite$$Animation$single_frame(sprite_path, size, transform$46$opt, offset$46$opt) {
  let transform;
  if (transform$46$opt === undefined) {
    transform = Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0);
  } else {
    const _Some = transform$46$opt;
    transform = _Some;
  }
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  return Milky2018$selene$sprite$$Animation$single_frame$46$inner(sprite_path, size, transform, offset);
}
function Milky2018$selene$sprite$$frames_from_atlas$46$inner(sprite_path, frame_count, width, height, offset, space_x) {
  const frames = [];
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < frame_count) {
      const x = Milky2018$selene$math$$Vec2D$op_get(offset, 0) + (i + 0) * (width + space_x);
      moonbitlang$core$array$$Array$push$45$(frames, { sprite_path: sprite_path, size: { _0: width, _1: height }, offset: Milky2018$selene$math$$Vec2D$update(offset, 0, x) });
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return frames;
}
function Milky2018$selene$sprite$$play_animation$46$inner(entity, animation, from_start, loop_, rate, transform) {
  _L: {
    const _bind$8 = moonbitlang$core$builtin$$Map$get$6$(Milky2018$selene$sprite$$sprites, entity);
    if (_bind$8 === undefined) {
      break _L;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _x$2 = _x.sprite_type;
      if (_x$2.$tag === 1) {
        const _Animation = _x$2;
        const _current_anime = _Animation._0;
        const _current_frame = _Animation._1;
        const _zindex = _x.zindex;
        const _visible = _x.visible;
        const _offset = _x.offset;
        const _p = animation.loop_;
        const loop_$2 = loop_ === -1 ? _p : loop_;
        const rate$2 = moonbitlang$core$option$$Option$unwrap_or$22$(rate, animation.fps);
        const _p$2 = animation.transform;
        let transform$2;
        if (transform === undefined) {
          transform$2 = _p$2;
        } else {
          const _p$3 = transform;
          transform$2 = _p$3;
        }
        const frame = !from_start && animation.id === _current_anime.id ? _current_frame : 0;
        const new_anime = { frames: animation.frames, transform: transform$2, loop_: loop_$2, fps: rate$2, id: animation.id };
        moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, entity, { sprite_type: new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Animation(new_anime, frame), zindex: _zindex, visible: _visible, offset: _offset });
        return;
      } else {
        break _L;
      }
    }
  }
  $panic();
}
function Milky2018$selene$style$$get_zindex(entity) {
  return moonbitlang$core$option$$Option$map_or$71$(moonbitlang$core$builtin$$Map$get$6$(Milky2018$selene$sprite$$sprites, entity), 100, (s) => s.zindex);
}
function Milky2018$selene$style$$Style$new$46$inner(size_plan, flex, h_padding, v_padding, h_offset, v_offset) {
  return { size_plan: size_plan, flex: flex, h_padding: h_padding, v_padding: v_padding, h_offset: h_offset, v_offset: v_offset };
}
function Milky2018$selene$style$$add_widget$46$inner(parent, sprite, on_just_pressed, shape, size_plan, flex, h_padding, v_padding, h_offset, v_offset) {
  const child = Milky2018$selene$entity$$Entity$spawn_child(parent, undefined);
  moonbitlang$core$builtin$$Map$set$1$(Milky2018$selene$ui$$uis, child, Milky2018$selene$ui$$Ui$new());
  const style = Milky2018$selene$style$$Style$new$46$inner(size_plan, flex, h_padding, v_padding, h_offset, v_offset);
  moonbitlang$core$builtin$$Map$set$2$(Milky2018$selene$style$$styles, child, style);
  if (sprite === undefined) {
  } else {
    const _Some = sprite;
    const _sprite_maker = _Some;
    const zindex = Milky2018$selene$style$$get_zindex(parent) + 1 | 0;
    const sprite$2 = _sprite_maker(zindex);
    moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, child, sprite$2);
  }
  if (shape === undefined) {
  } else {
    const _Some = shape;
    const _shape = _Some;
    moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, child, _shape);
  }
  if (on_just_pressed === undefined) {
  } else {
    const _Some = on_just_pressed;
    const _button_cb = _Some;
    const pickable = Milky2018$selene$collision$$Pickable$new();
    Milky2018$selene$collision$$Pickable$on_just_pressed(pickable, _button_cb);
    moonbitlang$core$builtin$$Map$set$7$(Milky2018$selene$collision$$pickables, child, pickable);
  }
  return child;
}
function Milky2018$selene$style$$add_widget(parent, sprite, on_just_pressed, shape, size_plan$46$opt, flex$46$opt, h_padding$46$opt, v_padding$46$opt, h_offset$46$opt, v_offset$46$opt) {
  let size_plan;
  if (size_plan$46$opt === undefined) {
    size_plan = $64$Milky2018$47$selene$47$style$46$SizePlan$FromSprite;
  } else {
    const _Some = size_plan$46$opt;
    size_plan = _Some;
  }
  let flex;
  if (flex$46$opt === undefined) {
    flex = 0;
  } else {
    const _Some = flex$46$opt;
    flex = _Some;
  }
  let h_padding;
  if (h_padding$46$opt.$tag === 1) {
    const _Some = h_padding$46$opt;
    h_padding = _Some._0;
  } else {
    h_padding = 0;
  }
  let v_padding;
  if (v_padding$46$opt.$tag === 1) {
    const _Some = v_padding$46$opt;
    v_padding = _Some._0;
  } else {
    v_padding = 0;
  }
  let h_offset;
  if (h_offset$46$opt.$tag === 1) {
    const _Some = h_offset$46$opt;
    h_offset = _Some._0;
  } else {
    h_offset = 0;
  }
  let v_offset;
  if (v_offset$46$opt.$tag === 1) {
    const _Some = v_offset$46$opt;
    v_offset = _Some._0;
  } else {
    v_offset = 0;
  }
  return Milky2018$selene$style$$add_widget$46$inner(parent, sprite, on_just_pressed, shape, size_plan, flex, h_padding, v_padding, h_offset, v_offset);
}
function Milky2018$selene$style$$arrange(entity, offset) {
  const _bind$8 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$style$$styles, entity);
  if (_bind$8 === undefined) {
    return { _0: 0, _1: 0 };
  } else {
    const _Some = _bind$8;
    const _style = _Some;
    if (Milky2018$selene$entity$$Entity$is_child(entity)) {
      const _p = { _0: _style.h_offset, _1: _style.v_offset };
      Milky2018$selene$entity$$Entity$set_offset(entity, { _0: offset._0 + _p._0, _1: offset._1 + _p._1 });
    }
    const children = Milky2018$selene$entity$$Entity$get_children(entity);
    let cursor = { _0: _style.h_padding, _1: _style.v_padding };
    let max_width = 0;
    let max_height = 0;
    const _len = children.length;
    let _tmp = 0;
    while (true) {
      const _i = _tmp;
      if (_i < _len) {
        const c = children[_i];
        const size = Milky2018$selene$style$$arrange(c, cursor);
        const _bind$9 = _style.flex;
        let _tmp$2;
        switch (_bind$9) {
          case 1: {
            _tmp$2 = Milky2018$selene$math$$Vec2D$update(cursor, 0, Milky2018$selene$math$$Vec2D$op_get(cursor, 0) + Milky2018$selene$math$$Vec2D$op_get(size, 0) + _style.h_padding);
            break;
          }
          case 0: {
            _tmp$2 = cursor;
            break;
          }
          default: {
            _tmp$2 = Milky2018$selene$math$$Vec2D$update(cursor, 1, Milky2018$selene$math$$Vec2D$op_get(cursor, 1) + Milky2018$selene$math$$Vec2D$op_get(size, 1) + _style.v_padding);
          }
        }
        cursor = _tmp$2;
        const _p = max_width;
        const _p$2 = Milky2018$selene$math$$Vec2D$op_get(size, 0);
        max_width = _p > _p$2 ? _p : _p$2;
        const _p$3 = max_height;
        const _p$4 = Milky2018$selene$math$$Vec2D$op_get(size, 1);
        max_height = _p$3 > _p$4 ? _p$3 : _p$4;
        _tmp = _i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const _bind$9 = _style.size_plan;
    switch (_bind$9.$tag) {
      case 1: {
        const _bind$10 = moonbitlang$core$builtin$$Map$get$6$(Milky2018$selene$sprite$$sprites, entity);
        if (_bind$10 === undefined) {
          return $panic();
        } else {
          const _Some$2 = _bind$10;
          const _sprite = _Some$2;
          const _bind$11 = _sprite.sprite_type;
          switch (_bind$11.$tag) {
            case 0: {
              const _Picture = _bind$11;
              const _picture = _Picture._0;
              return Milky2018$selene$math$$Transform$apply_to_vec2d(_picture.transform, _picture.size);
            }
            case 2: {
              return { _0: 48, _1: 24 };
            }
            case 1: {
              const _Animation = _bind$11;
              const _anime = _Animation._0;
              return Milky2018$selene$math$$Transform$apply_to_vec2d(_anime.transform, moonbitlang$core$array$$Array$at$45$(_anime.frames, 0).size);
            }
            case 3: {
              const _ColorRect = _bind$11;
              const _rect = _ColorRect._0;
              return _rect.size;
            }
            default: {
              const _ColorCircle = _bind$11;
              const _circle = _ColorCircle._0;
              return { _0: _circle.radius * 2, _1: _circle.radius * 2 };
            }
          }
        }
      }
      case 0: {
        const _Sized = _bind$9;
        return _Sized._0;
      }
      case 2: {
        return { _0: max_width, _1: max_height };
      }
      default: {
        const _bind$11 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, entity);
        if (_bind$11 === undefined) {
          return $panic();
        } else {
          const _Some$2 = _bind$11;
          const _shape = _Some$2;
          const _Rect = _shape;
          return _Rect._0;
        }
      }
    }
  }
}
function Milky2018$selene$style$$style_system(_delta) {
  let _foreach_result = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$11$;
  const _bind$8 = Milky2018$selene$entity$$get_roots();
  _bind$8((e) => {
    if (Milky2018$selene$entity$$Entity$is_alive(e)) {
      Milky2018$selene$style$$arrange(e, { _0: 0, _1: 0 });
    } else {
      return 1;
    }
    return 1;
  });
  const _tmp = _foreach_result;
  switch (_tmp.$tag) {
    case 0: {
      return;
    }
    case 1: {
      const _break = _tmp;
      _break._0;
      return;
    }
    case 2: {
      const _return = _tmp;
      _return._0;
      return;
    }
    case 3: {
      $panic();
      return;
    }
    default: {
      $panic();
      return;
    }
  }
}
function Milky2018$selene$plugins$$default_plugin(app) {
  const _self = app.systems;
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$collision$$move_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Move System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$inputs$$advanced_key_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Advanced Key System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$inputs$$advanced_mouse_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Advanced Mouse System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$collision$$quadtree_clear_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Quadtree Clear System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$collision$$pickable_click_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Pickable Click System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$collision$$area_collide_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Area Collide System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$system$$deferred_event_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Deferred Event System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$sprite$$render_sprite_system, _1: Milky2018$selene$plugins$$default_plugin$46$constr$47$3404, _2: "Render Sprite System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$camera$$camera_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Camera System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$system$$timer_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Timer System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$system$$realtime_timer_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Realtime Timer System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$inherit$$inherit_position_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Inherit Position System" });
  moonbitlang$core$array$$Array$push$56$(_self, { _0: Milky2018$selene$style$$style_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Style System" });
}
function moonbitlang$core$builtin$$Eq$equal$41$(_x_326, _x_327) {
  switch (_x_326) {
    case 0: {
      if (_x_327 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_327 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_327 === 2) {
        return true;
      } else {
        return false;
      }
    }
    case 3: {
      if (_x_327 === 3) {
        return true;
      } else {
        return false;
      }
    }
    case 4: {
      if (_x_327 === 4) {
        return true;
      } else {
        return false;
      }
    }
    case 5: {
      if (_x_327 === 5) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_327 === 6) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function moonbitlang$core$builtin$$Hash$hash_combine$41$(_x_322, _x_323) {
  switch (_x_322) {
    case 0: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_323, 0);
      return;
    }
    case 1: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_323, 1);
      return;
    }
    case 2: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_323, 2);
      return;
    }
    case 3: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_323, 3);
      return;
    }
    case 4: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_323, 4);
      return;
    }
    case 5: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_323, 5);
      return;
    }
    default: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_323, 6);
      return;
    }
  }
}
function moonbitlang$core$builtin$$Eq$equal$47$(_x_318, _x_319) {
  switch (_x_318) {
    case 0: {
      if (_x_319 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_319 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_319 === 2) {
        return true;
      } else {
        return false;
      }
    }
    case 3: {
      if (_x_319 === 3) {
        return true;
      } else {
        return false;
      }
    }
    case 4: {
      if (_x_319 === 4) {
        return true;
      } else {
        return false;
      }
    }
    case 5: {
      if (_x_319 === 5) {
        return true;
      } else {
        return false;
      }
    }
    case 6: {
      if (_x_319 === 6) {
        return true;
      } else {
        return false;
      }
    }
    case 7: {
      if (_x_319 === 7) {
        return true;
      } else {
        return false;
      }
    }
    case 8: {
      if (_x_319 === 8) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_319 === 9) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function Milky2018$selene$examples$survivors$$get_weapon_data(weapon_type) {
  switch (weapon_type) {
    case 0: {
      return { cooldown_rate: 1.5, damage_formula: (base, atk) => base + atk, range_formula: (base, rng) => base + rng, bullet_speed: 300, base_damage: 1, base_range: 128, speed_modifier: -15, attack_speed_modifier: 0, penetration: 1 };
    }
    case 1: {
      return { cooldown_rate: 0.3, damage_formula: (base, atk) => base + atk * 0.3, range_formula: (base, rng) => base + rng, bullet_speed: 600, base_damage: 0.5, base_range: 128, speed_modifier: -50, attack_speed_modifier: 0, penetration: 1 };
    }
    case 2: {
      return { cooldown_rate: 3, damage_formula: (base, atk) => base + atk * 4, range_formula: (base, rng) => base + rng, bullet_speed: 900, base_damage: 2, base_range: 192, speed_modifier: -25, attack_speed_modifier: -0.2, penetration: 4 };
    }
    default: {
      return { cooldown_rate: 2, damage_formula: (base, atk) => base + atk * 4, range_formula: (base, rng) => base + rng * 0.5, bullet_speed: 150, base_damage: 2, base_range: 24, speed_modifier: -15, attack_speed_modifier: 0, penetration: 99 };
    }
  }
}
function Milky2018$selene$examples$survivors$$get_weapon_speed_modifier(weapon_type) {
  const weapon_data = Milky2018$selene$examples$survivors$$get_weapon_data(weapon_type);
  return weapon_data.speed_modifier;
}
function Milky2018$selene$examples$survivors$$get_weapon_attack_speed_modifier(weapon_type) {
  const weapon_data = Milky2018$selene$examples$survivors$$get_weapon_data(weapon_type);
  return weapon_data.attack_speed_modifier;
}
function Milky2018$selene$examples$survivors$$get_weapon_name(weapon_type) {
  switch (weapon_type) {
    case 0: {
      return "Pistol";
    }
    case 1: {
      return "Minigun";
    }
    case 2: {
      return "Sniper Rifle";
    }
    default: {
      return "Sword";
    }
  }
}
function Milky2018$selene$examples$survivors$$get_weapon_icon(weapon_type) {
  switch (weapon_type) {
    case 0: {
      return Milky2018$selene$examples$survivors$$weapon_pistol_icon;
    }
    case 1: {
      return Milky2018$selene$examples$survivors$$weapon_minigun_icon;
    }
    case 2: {
      return Milky2018$selene$examples$survivors$$weapon_sniperrifle_icon;
    }
    default: {
      return Milky2018$selene$examples$survivors$$weapon_sword_icon;
    }
  }
}
function Milky2018$selene$examples$survivors$$get_weapon_weight(weapon_type, level) {
  switch (weapon_type) {
    case 0: {
      return 10 + (level + 0) * 0.5;
    }
    case 1: {
      return (level + 0) * 0.2;
    }
    case 2: {
      return (level + 0) * 0.5;
    }
    default: {
      return 10 + (level + 0) * 0.5;
    }
  }
}
function Milky2018$selene$examples$survivors$$calculate_weapon_damage(weapon_data, attack) {
  const _func = weapon_data.damage_formula;
  return _func(weapon_data.base_damage, attack);
}
function Milky2018$selene$examples$survivors$$calculate_weapon_range(weapon_data, range) {
  const _func = weapon_data.range_formula;
  return _func(weapon_data.base_range, range);
}
function Milky2018$selene$examples$survivors$$find_nearest_enemy_in_range(player_pos, weapon_range) {
  let min = weapon_range;
  let res = undefined;
  const _it = moonbitlang$core$builtin$$Map$iterator2$4$(Milky2018$selene$examples$survivors$$enemies);
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator2$next$4$(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        const _bind$9 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
        if (_bind$9 === undefined) {
          $panic();
        } else {
          const _Some$2 = _bind$9;
          const _enemy_pos = _Some$2;
          const dist = Milky2018$selene$math$$Vec2D$distance_to(player_pos, _enemy_pos);
          if (dist < min) {
            min = dist;
            res = _enemy_pos;
          }
        }
      } else {
        continue;
      }
      continue;
    }
  }
  return res;
}
function Milky2018$selene$examples$survivors$$xp_required_for_level(n) {
  return (Math.imul(n, ((Math.imul(Math.imul(2, n) | 0, n) | 0) + (Math.imul(21, n) | 0) | 0) + 73 | 0) | 0) / 6 | 0;
}
function Milky2018$selene$examples$survivors$$get_level_from_xp(xp) {
  let level = 1;
  while (true) {
    if (xp >= Milky2018$selene$examples$survivors$$xp_required_for_level(level)) {
      level = level + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return level;
}
function Milky2018$selene$examples$survivors$$create_powerup(powerup_type) {
  switch (powerup_type) {
    case 0: {
      return { powerup_type: 0, name: "Attack +0.2", weight_formula: (_level) => 25 };
    }
    case 1: {
      return { powerup_type: 1, name: "Attack +0.3", weight_formula: (level) => 2 + (level + 0) * 0.2 };
    }
    case 2: {
      return { powerup_type: 2, name: "Attack +0.4", weight_formula: (level) => 1 + (level + 0) * 0.1 };
    }
    case 3: {
      return { powerup_type: 3, name: "Range +16", weight_formula: (_level) => 25 };
    }
    case 4: {
      return { powerup_type: 4, name: "Range +32", weight_formula: (level) => 5 + (level + 0) * 0.5 };
    }
    case 5: {
      return { powerup_type: 5, name: "Speed +15", weight_formula: (_level) => 25 };
    }
    case 6: {
      return { powerup_type: 6, name: "Speed +30", weight_formula: (level) => 5 + (level + 0) * 0.5 };
    }
    case 7: {
      return { powerup_type: 7, name: "Attack Speed +10%", weight_formula: (_level) => 25 };
    }
    case 8: {
      return { powerup_type: 8, name: "Attack Speed +20%", weight_formula: (level) => 2 + (level + 0) * 0.2 };
    }
    default: {
      return { powerup_type: 9, name: "Penetration +1", weight_formula: (level) => 1 + (level + 0) * 0.1 };
    }
  }
}
function Milky2018$selene$examples$survivors$$weighted_random_selection$47$(items, weights) {
  if (items.length === 0 || items.length !== weights.length) {
    return undefined;
  }
  let total_weight = 0;
  const _len = weights.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const weight = weights[_i];
      total_weight = total_weight + weight;
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (total_weight <= 0) {
    return undefined;
  }
  const random_value = moonbitlang$core$random$$Rand$double(Milky2018$selene$examples$survivors$$game_state.rand) * total_weight;
  let cumulative = 0;
  const _end126 = items.length;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _end126) {
      cumulative = cumulative + moonbitlang$core$array$$Array$at$22$(weights, i);
      if (random_value <= cumulative) {
        return moonbitlang$core$array$$Array$at$47$(items, i);
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return moonbitlang$core$array$$Array$at$47$(items, items.length - 1 | 0);
}
function Milky2018$selene$examples$survivors$$weighted_random_selection$44$(items, weights) {
  if (items.length === 0 || items.length !== weights.length) {
    return undefined;
  }
  let total_weight = 0;
  const _len = weights.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const weight = weights[_i];
      total_weight = total_weight + weight;
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (total_weight <= 0) {
    return undefined;
  }
  const random_value = moonbitlang$core$random$$Rand$double(Milky2018$selene$examples$survivors$$game_state.rand) * total_weight;
  let cumulative = 0;
  const _end126 = items.length;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _end126) {
      cumulative = cumulative + moonbitlang$core$array$$Array$at$22$(weights, i);
      if (random_value <= cumulative) {
        return moonbitlang$core$array$$Array$at$44$(items, i);
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return moonbitlang$core$array$$Array$at$44$(items, items.length - 1 | 0);
}
function Milky2018$selene$examples$survivors$$select_weighted_powerup(level, already_selected) {
  const all_powerup_types = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  const selected_types = [];
  const _len = already_selected.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const selection = already_selected[_i];
      if (selection.$tag === 0) {
        const _PowerupSelection = selection;
        const _powerup = _PowerupSelection._0;
        moonbitlang$core$array$$Array$push$47$(selected_types, _powerup.powerup_type);
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const available_types = [];
  const available_weights = [];
  const _len$2 = all_powerup_types.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len$2) {
      const powerup_type = all_powerup_types[_i];
      let already_has = false;
      const _len$3 = selected_types.length;
      let _tmp$3 = 0;
      while (true) {
        const _i$2 = _tmp$3;
        if (_i$2 < _len$3) {
          const selected_type = selected_types[_i$2];
          if (moonbitlang$core$builtin$$Eq$equal$47$(powerup_type, selected_type)) {
            already_has = true;
            break;
          }
          _tmp$3 = _i$2 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (!already_has) {
        const powerup = Milky2018$selene$examples$survivors$$create_powerup(powerup_type);
        const _func = powerup.weight_formula;
        const weight = _func(level);
        if (weight > 0) {
          moonbitlang$core$array$$Array$push$47$(available_types, powerup_type);
          moonbitlang$core$array$$Array$push$22$(available_weights, weight);
        }
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$8 = Milky2018$selene$examples$survivors$$weighted_random_selection$47$(available_types, available_weights);
  if (_bind$8 === undefined) {
    return undefined;
  } else {
    const _Some = _bind$8;
    const _powerup_type = _Some;
    return Milky2018$selene$examples$survivors$$create_powerup(_powerup_type);
  }
}
function Milky2018$selene$examples$survivors$$select_weighted_weapon(level) {
  const all_weapons = [0, 1, 2, 3];
  const weights = [];
  const _len = all_weapons.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const weapon_type = all_weapons[_i];
      moonbitlang$core$array$$Array$push$22$(weights, Milky2018$selene$examples$survivors$$get_weapon_weight(weapon_type, level));
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return Milky2018$selene$examples$survivors$$weighted_random_selection$44$(all_weapons, weights);
}
function Milky2018$selene$examples$survivors$$generate_mixed_selections(level) {
  const selected = [];
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < 2) {
      const _bind$8 = Milky2018$selene$examples$survivors$$select_weighted_powerup(level, selected);
      if (_bind$8 === undefined) {
      } else {
        const _Some = _bind$8;
        const _powerup = _Some;
        moonbitlang$core$array$$Array$push$46$(selected, new LevelUpSelection$PowerupSelection(_powerup));
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$8 = Milky2018$selene$examples$survivors$$select_weighted_weapon(level);
  if (_bind$8 === undefined) {
  } else {
    const _Some = _bind$8;
    const _weapon = _Some;
    moonbitlang$core$array$$Array$push$46$(selected, new LevelUpSelection$WeaponSelection(_weapon));
  }
  return selected;
}
function Milky2018$selene$examples$survivors$$generate_powerup_selections(level) {
  const selected = [];
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < 3) {
      const _bind$8 = Milky2018$selene$examples$survivors$$select_weighted_powerup(level, selected);
      if (_bind$8 === undefined) {
      } else {
        const _Some = _bind$8;
        const _powerup = _Some;
        moonbitlang$core$array$$Array$push$46$(selected, new LevelUpSelection$PowerupSelection(_powerup));
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return selected;
}
function Milky2018$selene$examples$survivors$$generate_level_up_selections(level) {
  return (level % 5 | 0) === 0 ? Milky2018$selene$examples$survivors$$generate_mixed_selections(level) : Milky2018$selene$examples$survivors$$generate_powerup_selections(level);
}
function Milky2018$selene$examples$survivors$$get_powerup_icon(powerup_type) {
  _L: {
    _L$2: {
      _L$3: {
        _L$4: {
          switch (powerup_type) {
            case 0: {
              break _L$4;
            }
            case 1: {
              break _L$4;
            }
            case 2: {
              break _L$4;
            }
            case 3: {
              break _L$3;
            }
            case 4: {
              break _L$3;
            }
            case 5: {
              break _L$2;
            }
            case 6: {
              break _L$2;
            }
            case 7: {
              break _L;
            }
            case 8: {
              break _L;
            }
            default: {
              return Milky2018$selene$examples$survivors$$powerup_bandana_icon;
            }
          }
        }
        return Milky2018$selene$examples$survivors$$powerup_attack_icon;
      }
      return Milky2018$selene$examples$survivors$$powerup_range_icon;
    }
    return Milky2018$selene$examples$survivors$$powerup_speed_icon;
  }
  return Milky2018$selene$examples$survivors$$powerup_cooldown_icon;
}
function Milky2018$selene$examples$survivors$$update_selection_display(selection, button_entity) {
  const children = Milky2018$selene$entity$$Entity$get_children(button_entity);
  const icon_entity = moonbitlang$core$array$$Array$at$3$(children, 0);
  const text_entity = moonbitlang$core$array$$Array$at$3$(children, 1);
  if (selection.$tag === 0) {
    const _PowerupSelection = selection;
    const _powerup = _PowerupSelection._0;
    const button_background = Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new$46$inner({ _0: 160, _1: 36 }, "rgba(13, 167, 170, 1)", "black"), 102, undefined);
    moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, button_entity, button_background);
    const button_text = Milky2018$selene$sprite$$Text$new(_powerup.name, Milky2018$selene$examples$survivors$$update_selection_display$46$constr$47$3599, Milky2018$selene$examples$survivors$$update_selection_display$46$constr$47$3600, undefined, undefined);
    const button_sprite = Milky2018$selene$sprite$$Sprite$from_text(button_text, 103, undefined);
    moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, text_entity, button_sprite);
    const icon_animation = Milky2018$selene$examples$survivors$$get_powerup_icon(_powerup.powerup_type);
    const icon_sprite = Milky2018$selene$sprite$$Sprite$from_animation(icon_animation, 103, undefined);
    moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, icon_entity, icon_sprite);
    return;
  } else {
    const _WeaponSelection = selection;
    const _weapon_type = _WeaponSelection._0;
    const button_background = Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new$46$inner({ _0: 160, _1: 36 }, "rgba(255, 140, 0, 1)", "black"), 102, undefined);
    moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, button_entity, button_background);
    const button_text = Milky2018$selene$sprite$$Text$new(Milky2018$selene$examples$survivors$$get_weapon_name(_weapon_type), Milky2018$selene$examples$survivors$$update_selection_display$46$constr$47$3601, Milky2018$selene$examples$survivors$$update_selection_display$46$constr$47$3602, undefined, undefined);
    const button_sprite = Milky2018$selene$sprite$$Sprite$from_text(button_text, 103, undefined);
    moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, text_entity, button_sprite);
    const icon_animation = Milky2018$selene$examples$survivors$$get_weapon_icon(_weapon_type);
    const icon_sprite = Milky2018$selene$sprite$$Sprite$from_animation(icon_animation, 103, undefined);
    moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, icon_entity, icon_sprite);
    return;
  }
}
function Milky2018$selene$examples$survivors$$level_up(level) {
  Milky2018$selene$backend$$set_time_scale(0);
  const panel = Milky2018$selene$examples$survivors$$game_state.level_up_panel;
  panel.available_selections = Milky2018$selene$examples$survivors$$generate_level_up_selections(level);
  Milky2018$selene$entity$$Entity$respawn(panel.panel_entity);
  const button_entities = Milky2018$selene$entity$$Entity$get_children(panel.panel_entity);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 3) {
      Milky2018$selene$examples$survivors$$update_selection_display(moonbitlang$core$array$$Array$at$46$(panel.available_selections, i), moonbitlang$core$array$$Array$at$3$(button_entities, i + 1 | 0));
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$examples$survivors$$process_next_level_up() {
  const _bind$8 = moonbitlang$core$array$$Array$pop$15$(Milky2018$selene$examples$survivors$$game_state.pending_level_ups);
  if (_bind$8 === undefined) {
    return;
  } else {
    const _Some = _bind$8;
    const _level = _Some;
    Milky2018$selene$examples$survivors$$level_up(_level);
    return;
  }
}
function Milky2018$selene$examples$survivors$$add_exp(exp_gained) {
  const old_level = Milky2018$selene$examples$survivors$$game_state.player_level;
  Milky2018$selene$examples$survivors$$game_state.exp = Milky2018$selene$examples$survivors$$game_state.exp + exp_gained | 0;
  const new_level = Milky2018$selene$examples$survivors$$get_level_from_xp(Milky2018$selene$examples$survivors$$game_state.exp);
  if (new_level > old_level) {
    let level = new_level;
    while (true) {
      if (level > old_level) {
        moonbitlang$core$array$$Array$push$15$(Milky2018$selene$examples$survivors$$game_state.pending_level_ups, level);
        level = level - 1 | 0;
        continue;
      } else {
        break;
      }
    }
    Milky2018$selene$examples$survivors$$game_state.player_level = new_level;
    Milky2018$selene$examples$survivors$$game_state.level_box.content = `Level: ${moonbitlang$core$int$$Int$to_string$46$inner(Milky2018$selene$examples$survivors$$game_state.player_level, 10)}`;
    Milky2018$selene$examples$survivors$$process_next_level_up();
  }
  const current_level_xp = Milky2018$selene$examples$survivors$$game_state.player_level === 1 ? 0 : Milky2018$selene$examples$survivors$$xp_required_for_level(Milky2018$selene$examples$survivors$$game_state.player_level - 1 | 0);
  const next_level_xp = Milky2018$selene$examples$survivors$$xp_required_for_level(Milky2018$selene$examples$survivors$$game_state.player_level);
  const progress_xp = Milky2018$selene$examples$survivors$$game_state.exp - current_level_xp | 0;
  const needed_xp = next_level_xp - current_level_xp | 0;
  Milky2018$selene$examples$survivors$$game_state.exp_box.content = `EXP: ${moonbitlang$core$int$$Int$to_string$46$inner(progress_xp, 10)}/${moonbitlang$core$int$$Int$to_string$46$inner(needed_xp, 10)}`;
}
function Milky2018$selene$examples$survivors$$get_enemy_data(enemy_type) {
  const _bind$8 = moonbitlang$core$builtin$$Map$get$16$(Milky2018$selene$examples$survivors$$enemy_data, enemy_type);
  if (_bind$8 === undefined) {
    return moonbitlang$core$abort$$abort$23$("Enemy data not found");
  } else {
    const _Some = _bind$8;
    return _Some;
  }
}
function Milky2018$selene$examples$survivors$$set_score(score) {
  Milky2018$selene$examples$survivors$$game_state.score = score;
  Milky2018$selene$examples$survivors$$game_state.score_box.content = `Score: ${moonbitlang$core$int$$Int$to_string$46$inner(Milky2018$selene$examples$survivors$$game_state.score, 10)}`;
}
function Milky2018$selene$examples$survivors$$shoot_weapon_bullet(player_pos, target_pos, weapon_data, damage, total_penetration) {
  const bullet_entity = Milky2018$selene$entity$$Entity$new();
  moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, bullet_entity, Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new$46$inner({ _0: 4, _1: 4 }, "white", "rgba(0, 0, 0, 0)"), 4, undefined));
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, bullet_entity, player_pos);
  const _p = Milky2018$selene$math$$Vec2D$normalize({ _0: target_pos._0 - player_pos._0, _1: target_pos._1 - player_pos._1 });
  const _p$2 = weapon_data.bullet_speed;
  const vel = { _0: _p._0 * _p$2, _1: _p._1 * _p$2 };
  moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$velocity$$velocities, bullet_entity, vel);
  moonbitlang$core$builtin$$Map$set$12$(Milky2018$selene$collision$$collision_layers, bullet_entity, Milky2018$selene$examples$survivors$$bullet_collision_layer);
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, bullet_entity, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 4, _1: 4 }, { _0: -2, _1: -2 }));
  const area = Milky2018$selene$collision$$Area$new([Milky2018$selene$examples$survivors$$enemy_collision_layer, Milky2018$selene$examples$survivors$$wall_collision_layer]);
  const bullet_alive = { val: true };
  const penetration_count = { val: 0 };
  Milky2018$selene$collision$$Area$on_enter(area, (enemy_entity) => {
    const _bind$8 = moonbitlang$core$builtin$$Map$get$4$(Milky2018$selene$examples$survivors$$enemies, enemy_entity);
    if (_bind$8 === undefined) {
      bullet_alive.val = false;
      Milky2018$selene$entity$$Entity$destroy(bullet_entity);
      return;
    } else {
      const _Some = _bind$8;
      const _enemy = _Some;
      if (bullet_alive.val) {
        _enemy.health = _enemy.health - damage;
        penetration_count.val = penetration_count.val + 1 | 0;
        if (_enemy.health <= 0) {
          Milky2018$selene$entity$$Entity$destroy(enemy_entity);
          const data$2 = Milky2018$selene$examples$survivors$$get_enemy_data(_enemy.enemy_type);
          Milky2018$selene$examples$survivors$$set_score(Milky2018$selene$examples$survivors$$game_state.score + data$2.points | 0);
          Milky2018$selene$examples$survivors$$add_exp(data$2.points);
        }
        if (penetration_count.val >= total_penetration) {
          bullet_alive.val = false;
          Milky2018$selene$entity$$Entity$destroy(bullet_entity);
          return;
        } else {
          return;
        }
      } else {
        return;
      }
    }
  });
  moonbitlang$core$builtin$$Map$set$13$(Milky2018$selene$collision$$areas, bullet_entity, area);
  const weapon_range = Milky2018$selene$examples$survivors$$calculate_weapon_range(weapon_data, 0);
  const bullet_duration = weapon_range / weapon_data.bullet_speed;
  Milky2018$selene$system$$timeout$46$inner(bullet_duration, () => {
    bullet_alive.val = false;
    Milky2018$selene$entity$$Entity$destroy(bullet_entity);
  }, true);
}
function Milky2018$selene$examples$survivors$$update_weapon_timers(weapon_instances, delta, attack_speed, player_attack, player_range, player_penetration, player_pos) {
  while (true) {
    if (Milky2018$selene$examples$survivors$$weapon_timers.length < weapon_instances.length) {
      moonbitlang$core$array$$Array$push$22$(Milky2018$selene$examples$survivors$$weapon_timers, 0);
      continue;
    } else {
      break;
    }
  }
  const _end278 = weapon_instances.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _end278) {
      const weapon_type = moonbitlang$core$array$$Array$at$44$(weapon_instances, i);
      const weapon_data = Milky2018$selene$examples$survivors$$get_weapon_data(weapon_type);
      if (moonbitlang$core$array$$Array$at$22$(Milky2018$selene$examples$survivors$$weapon_timers, i) > 0) {
        moonbitlang$core$array$$Array$set$22$(Milky2018$selene$examples$survivors$$weapon_timers, i, moonbitlang$core$array$$Array$at$22$(Milky2018$selene$examples$survivors$$weapon_timers, i) - delta);
      }
      if (moonbitlang$core$array$$Array$at$22$(Milky2018$selene$examples$survivors$$weapon_timers, i) <= 0) {
        if (attack_speed <= 0) {
          moonbitlang$core$array$$Array$set$22$(Milky2018$selene$examples$survivors$$weapon_timers, i, 999999);
        } else {
          moonbitlang$core$array$$Array$set$22$(Milky2018$selene$examples$survivors$$weapon_timers, i, weapon_data.cooldown_rate / attack_speed);
        }
        const weapon_range = Milky2018$selene$examples$survivors$$calculate_weapon_range(weapon_data, player_range);
        const nearest_enemy_pos = Milky2018$selene$examples$survivors$$find_nearest_enemy_in_range(player_pos, weapon_range);
        if (nearest_enemy_pos === undefined) {
        } else {
          const _Some = nearest_enemy_pos;
          const _enemy_pos = _Some;
          const weapon_damage = Milky2018$selene$examples$survivors$$calculate_weapon_damage(weapon_data, player_attack);
          const total_penetration = weapon_data.penetration + player_penetration | 0;
          Milky2018$selene$examples$survivors$$shoot_weapon_bullet(player_pos, _enemy_pos, weapon_data, weapon_damage, total_penetration);
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$examples$survivors$$add_score_box() {
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$survivors$$game_state.score_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$add_score_box$46$constr$47$3679, Milky2018$selene$examples$survivors$$add_score_box$46$constr$47$3680);
}
function Milky2018$selene$examples$survivors$$add_weapon(weapon_type) {
  moonbitlang$core$array$$Array$push$44$(Milky2018$selene$examples$survivors$$game_state.player_stats.weapon_instances, weapon_type);
  const speed_modifier = Milky2018$selene$examples$survivors$$get_weapon_speed_modifier(weapon_type);
  const _bind$8 = Milky2018$selene$examples$survivors$$game_state.player_stats;
  _bind$8.speed = _bind$8.speed + speed_modifier;
  const attack_speed_modifier = Milky2018$selene$examples$survivors$$get_weapon_attack_speed_modifier(weapon_type);
  const _bind$9 = Milky2018$selene$examples$survivors$$game_state.player_stats;
  _bind$9.attack_speed = _bind$9.attack_speed + attack_speed_modifier;
}
function Milky2018$selene$examples$survivors$$apply_powerup(powerup) {
  const _bind$8 = powerup.powerup_type;
  switch (_bind$8) {
    case 0: {
      const _bind$9 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$9.attack = _bind$9.attack + 0.2;
      return;
    }
    case 1: {
      const _bind$10 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$10.attack = _bind$10.attack + 0.3;
      return;
    }
    case 2: {
      const _bind$11 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$11.attack = _bind$11.attack + 0.4;
      return;
    }
    case 3: {
      const _bind$12 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$12.range = _bind$12.range + 16;
      return;
    }
    case 4: {
      const _bind$13 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$13.range = _bind$13.range + 32;
      return;
    }
    case 5: {
      const _bind$14 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$14.speed = _bind$14.speed + 15;
      return;
    }
    case 6: {
      const _bind$15 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$15.speed = _bind$15.speed + 30;
      return;
    }
    case 7: {
      const _bind$16 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$16.attack_speed = _bind$16.attack_speed + 0.1;
      return;
    }
    case 8: {
      const _bind$17 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$17.attack_speed = _bind$17.attack_speed + 0.2;
      return;
    }
    default: {
      const _bind$18 = Milky2018$selene$examples$survivors$$game_state.player_stats;
      _bind$18.penetration = _bind$18.penetration + 1 | 0;
      return;
    }
  }
}
function Milky2018$selene$examples$survivors$$apply_selection(selection) {
  if (selection.$tag === 0) {
    const _PowerupSelection = selection;
    const _powerup = _PowerupSelection._0;
    Milky2018$selene$examples$survivors$$apply_powerup(_powerup);
    return;
  } else {
    const _WeaponSelection = selection;
    const _weapon_type = _WeaponSelection._0;
    Milky2018$selene$examples$survivors$$add_weapon(_weapon_type);
    return;
  }
}
function Milky2018$selene$examples$survivors$$resume_game() {
  Milky2018$selene$entity$$Entity$destroy(Milky2018$selene$examples$survivors$$game_state.level_up_panel.panel_entity);
  const _p = Milky2018$selene$examples$survivors$$game_state.pending_level_ups;
  if (_p.length === 0) {
    Milky2018$selene$backend$$set_time_scale(1);
    return;
  } else {
    Milky2018$selene$examples$survivors$$process_next_level_up();
    return;
  }
}
function Milky2018$selene$examples$survivors$$select_powerup(index) {
  const panel = Milky2018$selene$examples$survivors$$game_state.level_up_panel;
  if (index < panel.available_selections.length) {
    const selection = moonbitlang$core$array$$Array$at$46$(panel.available_selections, index);
    Milky2018$selene$examples$survivors$$apply_selection(selection);
  }
  Milky2018$selene$examples$survivors$$resume_game();
}
function Milky2018$selene$examples$survivors$$setup_level_up_ui() {
  const panel = Milky2018$selene$examples$survivors$$game_state.level_up_panel.panel_entity;
  Milky2018$selene$style$$add_widget(panel, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$sprite$$Text$new$46$inner("LEVEL UP!", "gold", "36px ThaleahFat", 0, 0), zindex, undefined), undefined, undefined, new $64$Milky2018$47$selene$47$style$46$SizePlan$Sized({ _0: 160, _1: 36 }), undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$setup_level_up_ui$46$constr$47$3707, Option$None$0$);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 3) {
      const button = Milky2018$selene$style$$add_widget$46$inner(panel, (zindex) => Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new$46$inner({ _0: 160, _1: 36 }, "rgba(13, 167, 170, 1)", "black"), zindex, undefined), (_button) => {
        Milky2018$selene$examples$survivors$$select_powerup(i);
      }, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 160, _1: 36 }, { _0: 0, _1: 0 }), $64$Milky2018$47$selene$47$style$46$SizePlan$FromSprite, 1, 2, 2, 0, 0);
      Milky2018$selene$style$$add_widget(button, (zindex) => Milky2018$selene$sprite$$Sprite$from_animation(Milky2018$selene$examples$survivors$$powerup_range_icon, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Option$None$0$, Option$None$0$);
      Milky2018$selene$style$$add_widget(button, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$sprite$$Text$new("Default", Milky2018$selene$examples$survivors$$setup_level_up_ui$46$constr$47$3708, Milky2018$selene$examples$survivors$$setup_level_up_ui$46$constr$47$3709, undefined, undefined), zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Option$None$0$, Option$None$0$);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  Milky2018$selene$entity$$Entity$destroy(panel);
}
function Milky2018$selene$examples$survivors$$add_wave_box() {
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$survivors$$game_state.wave_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$add_wave_box$46$constr$47$3719, Milky2018$selene$examples$survivors$$add_wave_box$46$constr$47$3720);
}
function Milky2018$selene$examples$survivors$$add_exp_box() {
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$survivors$$game_state.exp_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$add_exp_box$46$constr$47$3722, Milky2018$selene$examples$survivors$$add_exp_box$46$constr$47$3723);
}
function Milky2018$selene$examples$survivors$$add_timer_box() {
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$survivors$$game_state.timer_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$add_timer_box$46$constr$47$3725, Milky2018$selene$examples$survivors$$add_timer_box$46$constr$47$3726);
}
function Milky2018$selene$examples$survivors$$reset_wave_state() {
  Milky2018$selene$examples$survivors$$wave_state.creeper_spawned = 0;
  Milky2018$selene$examples$survivors$$wave_state.icecream_spawned = 0;
  Milky2018$selene$examples$survivors$$wave_state.orc_spawned = 0;
  Milky2018$selene$examples$survivors$$wave_state.skull_spawned = 0;
  Milky2018$selene$examples$survivors$$wave_state.teleman_spawned = 0;
  Milky2018$selene$examples$survivors$$wave_state.devil_spawned = 0;
  Milky2018$selene$examples$survivors$$wave_state.pirate_spawned = 0;
}
function Milky2018$selene$examples$survivors$$restart_game() {
  Milky2018$selene$entity$$Entity$destroy(Milky2018$selene$examples$survivors$$game_state.game_over_panel.panel_entity);
  Milky2018$selene$examples$survivors$$game_state.game_over = false;
  Milky2018$selene$examples$survivors$$game_state.game_over_displayed = false;
  Milky2018$selene$examples$survivors$$game_state.game_timer = 600;
  Milky2018$selene$examples$survivors$$game_state.current_wave = 1;
  Milky2018$selene$examples$survivors$$game_state.wave_box.content = "Wave: 1";
  Milky2018$selene$examples$survivors$$set_score(0);
  Milky2018$selene$examples$survivors$$game_state.exp = 0;
  Milky2018$selene$examples$survivors$$game_state.player_level = 1;
  Milky2018$selene$examples$survivors$$game_state.level_box.content = "Level: 1";
  Milky2018$selene$examples$survivors$$game_state.exp_box.content = "EXP: 0/16";
  Milky2018$selene$examples$survivors$$game_state.invincible = false;
  Milky2018$selene$examples$survivors$$game_state.score_blink_timer = 0;
  Milky2018$selene$examples$survivors$$game_state.score_is_red = false;
  Milky2018$selene$examples$survivors$$game_state.score_box.color = "white";
  moonbitlang$core$array$$Array$clear$15$(Milky2018$selene$examples$survivors$$game_state.pending_level_ups);
  Milky2018$selene$examples$survivors$$game_state.player_stats.attack = 0;
  Milky2018$selene$examples$survivors$$game_state.player_stats.range = 0;
  Milky2018$selene$examples$survivors$$game_state.player_stats.speed = 150;
  Milky2018$selene$examples$survivors$$game_state.player_stats.attack_speed = 1;
  Milky2018$selene$examples$survivors$$game_state.player_stats.penetration = 0;
  moonbitlang$core$array$$Array$clear$44$(Milky2018$selene$examples$survivors$$game_state.player_stats.weapon_instances);
  moonbitlang$core$array$$Array$push$44$(Milky2018$selene$examples$survivors$$game_state.player_stats.weapon_instances, 0);
  moonbitlang$core$array$$Array$clear$22$(Milky2018$selene$examples$survivors$$weapon_timers);
  const _it = moonbitlang$core$builtin$$Map$iterator2$4$(Milky2018$selene$examples$survivors$$enemies);
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator2$next$4$(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        Milky2018$selene$entity$$Entity$destroy(_e);
      }
      continue;
    }
  }
  moonbitlang$core$builtin$$Map$clear$4$(Milky2018$selene$examples$survivors$$enemies);
  Milky2018$selene$examples$survivors$$reset_wave_state();
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, Milky2018$selene$examples$survivors$$game_state.player_entity, { _0: 320, _1: 320 });
  moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$velocity$$velocities, Milky2018$selene$examples$survivors$$game_state.player_entity, { _0: 0, _1: 0 });
}
function Milky2018$selene$examples$survivors$$setup_game_over_ui() {
  const panel = Milky2018$selene$examples$survivors$$game_state.game_over_panel.panel_entity;
  Milky2018$selene$style$$add_widget(panel, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$sprite$$Text$new$46$inner("VICTORY!", "gold", "32px ThaleahFat", 0, 0), zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3734, Option$None$0$);
  Milky2018$selene$style$$add_widget(panel, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$survivors$$game_state.game_over_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3735, Option$None$0$);
  const restart_button = Milky2018$selene$style$$add_widget(panel, (zindex) => Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new$46$inner({ _0: 180, _1: 40 }, "rgba(13, 167, 170, 1)", "white"), zindex, undefined), (_button) => {
    Milky2018$selene$examples$survivors$$restart_game();
  }, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 180, _1: 40 }, { _0: 0, _1: 0 }), undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3736, Option$None$0$);
  Milky2018$selene$style$$add_widget(restart_button, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$sprite$$Text$new("RESTART", Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3737, Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3738, undefined, undefined), zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3739, Milky2018$selene$examples$survivors$$setup_game_over_ui$46$constr$47$3740);
  Milky2018$selene$entity$$Entity$destroy(panel);
}
function Milky2018$selene$examples$survivors$$add_game_over_box() {
  Milky2018$selene$entity$$Entity$respawn(Milky2018$selene$examples$survivors$$game_state.game_over_panel.panel_entity);
}
function Milky2018$selene$examples$survivors$$add_level_box() {
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$survivors$$game_state.level_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$survivors$$add_level_box$46$constr$47$3748, Milky2018$selene$examples$survivors$$add_level_box$46$constr$47$3749);
}
function Milky2018$selene$examples$survivors$$add_player() {
  const entity = Milky2018$selene$examples$survivors$$game_state.player_entity;
  moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, entity, Milky2018$selene$sprite$$Sprite$from_animation$46$inner(Milky2018$selene$examples$survivors$$player_idle_right_animation, 3, { _0: -8, _1: -8 }));
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, entity, { _0: 320, _1: 320 });
  moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$velocity$$velocities, entity, { _0: 0, _1: 0 });
  Milky2018$selene$camera$$attach_entity(entity, { _0: 8, _1: 8 });
  moonbitlang$core$builtin$$Map$set$12$(Milky2018$selene$collision$$collision_layers, entity, Milky2018$selene$examples$survivors$$player_collision_layer);
  moonbitlang$core$builtin$$Map$set$17$(Milky2018$selene$collision$$colliders, entity, Milky2018$selene$collision$$Collider$new([Milky2018$selene$examples$survivors$$wall_collision_layer]));
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, entity, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 16, _1: 16 }, { _0: -8, _1: -8 }));
}
function Milky2018$selene$examples$survivors$$player_update_system(delta) {
  if (Milky2018$selene$examples$survivors$$game_state.game_over || delta === 0) {
    return undefined;
  }
  const entity = Milky2018$selene$examples$survivors$$game_state.player_entity;
  const speed = Milky2018$selene$examples$survivors$$game_state.player_stats.speed < 0 ? 0 : Milky2018$selene$examples$survivors$$game_state.player_stats.speed;
  const _p = Milky2018$selene$math$$Vec2D$normalize(Milky2018$selene$inputs$$key_vector(22, 18, 0, 3));
  const vel = { _0: _p._0 * speed, _1: _p._1 * speed };
  moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$velocity$$velocities, entity, vel);
  if (Milky2018$selene$math$$Vec2D$op_get(vel, 0) > 0) {
    Milky2018$selene$examples$survivors$$game_state.player_direction = 3;
  } else {
    if (Milky2018$selene$math$$Vec2D$op_get(vel, 0) < 0) {
      Milky2018$selene$examples$survivors$$game_state.player_direction = 2;
    } else {
      if (Milky2018$selene$math$$Vec2D$op_get(vel, 1) > 0) {
        Milky2018$selene$examples$survivors$$game_state.player_direction = 1;
      } else {
        if (Milky2018$selene$math$$Vec2D$op_get(vel, 1) < 0) {
          Milky2018$selene$examples$survivors$$game_state.player_direction = 0;
        }
      }
    }
  }
  const _p$2 = { _0: 0, _1: 0 };
  const _bind$8 = vel._0 === _p$2._0 && vel._1 === _p$2._1;
  const _bind$9 = Milky2018$selene$examples$survivors$$game_state.player_direction;
  if (_bind$8 === true) {
    switch (_bind$9) {
      case 2: {
        Milky2018$selene$sprite$$play_animation$46$inner(entity, Milky2018$selene$examples$survivors$$player_idle_left_animation, false, -1, Option$None$0$, undefined);
        return;
      }
      case 3: {
        Milky2018$selene$sprite$$play_animation$46$inner(entity, Milky2018$selene$examples$survivors$$player_idle_right_animation, false, -1, Option$None$0$, undefined);
        return;
      }
      case 0: {
        Milky2018$selene$sprite$$play_animation$46$inner(entity, Milky2018$selene$examples$survivors$$player_idle_up_animation, false, -1, Option$None$0$, undefined);
        return;
      }
      default: {
        Milky2018$selene$sprite$$play_animation$46$inner(entity, Milky2018$selene$examples$survivors$$player_idle_down_animation, false, -1, Option$None$0$, undefined);
        return;
      }
    }
  } else {
    switch (_bind$9) {
      case 2: {
        Milky2018$selene$sprite$$play_animation$46$inner(entity, Milky2018$selene$examples$survivors$$player_run_left_animation, false, -1, Option$None$0$, undefined);
        return;
      }
      case 3: {
        Milky2018$selene$sprite$$play_animation$46$inner(entity, Milky2018$selene$examples$survivors$$player_run_right_animation, false, -1, Option$None$0$, undefined);
        return;
      }
      case 0: {
        Milky2018$selene$sprite$$play_animation$46$inner(entity, Milky2018$selene$examples$survivors$$player_run_up_animation, false, -1, Option$None$0$, undefined);
        return;
      }
      default: {
        Milky2018$selene$sprite$$play_animation$46$inner(entity, Milky2018$selene$examples$survivors$$player_run_down_animation, false, -1, Option$None$0$, undefined);
        return;
      }
    }
  }
}
function Milky2018$selene$examples$survivors$$player_shooting_system(delta) {
  if (Milky2018$selene$examples$survivors$$game_state.game_over) {
    return undefined;
  }
  const _bind$8 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, Milky2018$selene$examples$survivors$$game_state.player_entity);
  if (_bind$8 === undefined) {
    $panic();
    return;
  } else {
    const _Some = _bind$8;
    const _player_pos = _Some;
    const attack_speed = Milky2018$selene$examples$survivors$$game_state.player_stats.attack_speed < 0 ? 0 : Milky2018$selene$examples$survivors$$game_state.player_stats.attack_speed;
    const attack = Milky2018$selene$examples$survivors$$game_state.player_stats.attack < 0 ? 0 : Milky2018$selene$examples$survivors$$game_state.player_stats.attack;
    const range = Milky2018$selene$examples$survivors$$game_state.player_stats.range < 0 ? 0 : Milky2018$selene$examples$survivors$$game_state.player_stats.range;
    const penetration = Milky2018$selene$examples$survivors$$game_state.player_stats.penetration < 0 ? 0 : Milky2018$selene$examples$survivors$$game_state.player_stats.penetration;
    Milky2018$selene$examples$survivors$$update_weapon_timers(Milky2018$selene$examples$survivors$$game_state.player_stats.weapon_instances, delta, attack_speed, attack, range, penetration, _player_pos);
    return;
  }
}
function Milky2018$selene$examples$survivors$$add_background(size) {
  const background = Milky2018$selene$entity$$Entity$new();
  const background_sprite = Milky2018$selene$sprite$$Sprite$from_picture(Milky2018$selene$sprite$$Picture$new(size, Milky2018$selene$examples$survivors$$background_picture, undefined, Milky2018$selene$examples$survivors$$add_background$46$constr$47$3766), 0, undefined);
  moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, background, background_sprite);
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, background, { _0: 0, _1: 0 });
}
function Milky2018$selene$examples$survivors$$add_border$46$add_one_border$124$163(pos, size) {
  const entity = Milky2018$selene$entity$$Entity$new();
  moonbitlang$core$builtin$$Map$set$12$(Milky2018$selene$collision$$collision_layers, entity, Milky2018$selene$examples$survivors$$wall_collision_layer);
  const collider = Milky2018$selene$collision$$Collider$new([]);
  moonbitlang$core$builtin$$Map$set$17$(Milky2018$selene$collision$$colliders, entity, collider);
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, entity, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect(size, { _0: 0, _1: 0 }));
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, entity, pos);
}
function Milky2018$selene$examples$survivors$$add_border(size) {
  Milky2018$selene$examples$survivors$$add_border$46$add_one_border$124$163({ _0: -16, _1: -16 }, { _0: Milky2018$selene$math$$Vec2D$op_get(size, 0) + 32, _1: 16 });
  Milky2018$selene$examples$survivors$$add_border$46$add_one_border$124$163({ _0: -16, _1: 0 }, { _0: 16, _1: Milky2018$selene$math$$Vec2D$op_get(size, 1) });
  Milky2018$selene$examples$survivors$$add_border$46$add_one_border$124$163({ _0: -16, _1: Milky2018$selene$math$$Vec2D$op_get(size, 1) }, { _0: Milky2018$selene$math$$Vec2D$op_get(size, 0) + 32, _1: 16 });
  Milky2018$selene$examples$survivors$$add_border$46$add_one_border$124$163({ _0: Milky2018$selene$math$$Vec2D$op_get(size, 0), _1: 0 }, { _0: 16, _1: Milky2018$selene$math$$Vec2D$op_get(size, 1) });
}
function Milky2018$selene$examples$survivors$$add_grass() {
  const rand = moonbitlang$core$random$$Rand$new(Option$None$1$);
  const _end151 = moonbitlang$core$double$$Double$to_int(40);
  let _tmp = 0;
  while (true) {
    const x = _tmp;
    if (x < _end151) {
      const _end156 = moonbitlang$core$double$$Double$to_int(40);
      let _tmp$2 = 0;
      while (true) {
        const y = _tmp$2;
        if (y < _end156) {
          if (moonbitlang$core$random$$Rand$double(rand) < 0.05) {
            const grass = Milky2018$selene$entity$$Entity$new();
            const sprite = Milky2018$selene$sprite$$Sprite$from_animation(Milky2018$selene$examples$survivors$$grass_sprite, 1, undefined);
            moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, grass, sprite);
            moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, grass, { _0: (x + 0) * 16, _1: (y + 0) * 16 });
          }
          _tmp$2 = y + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = x + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$examples$survivors$$check_victory_system(_delta) {
  if (Milky2018$selene$examples$survivors$$game_state.game_over) {
    return undefined;
  }
  if (Milky2018$selene$examples$survivors$$game_state.game_timer > 0) {
    return undefined;
  }
  let alive_count = 0;
  const _it = moonbitlang$core$builtin$$Map$iterator2$4$(Milky2018$selene$examples$survivors$$enemies);
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator2$next$4$(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        alive_count = alive_count + 1 | 0;
      }
      continue;
    }
  }
  if (alive_count === 0) {
    Milky2018$selene$examples$survivors$$game_state.game_over = true;
    return;
  } else {
    return;
  }
}
function Milky2018$selene$examples$survivors$$trigger_damage_effect() {
  Milky2018$selene$examples$survivors$$game_state.score_blink_timer = 1;
  Milky2018$selene$examples$survivors$$game_state.score_is_red = true;
  Milky2018$selene$examples$survivors$$game_state.score_box.color = "red";
}
function Milky2018$selene$examples$survivors$$shoot_enemy_bullet(enemy_pos, player_pos) {
  const bullet_entity = Milky2018$selene$entity$$Entity$new();
  moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, bullet_entity, Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new$46$inner({ _0: 4, _1: 4 }, "red", "rgba(0, 0, 0, 0)"), 4, undefined));
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, bullet_entity, enemy_pos);
  const _p = Milky2018$selene$math$$Vec2D$normalize({ _0: player_pos._0 - enemy_pos._0, _1: player_pos._1 - enemy_pos._1 });
  const _p$2 = 120;
  const vel = { _0: _p._0 * _p$2, _1: _p._1 * _p$2 };
  moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$velocity$$velocities, bullet_entity, vel);
  moonbitlang$core$builtin$$Map$set$12$(Milky2018$selene$collision$$collision_layers, bullet_entity, Milky2018$selene$examples$survivors$$enemybullet_collision_layer);
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, bullet_entity, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 4, _1: 4 }, { _0: -2, _1: -2 }));
  const area = Milky2018$selene$collision$$Area$new([Milky2018$selene$examples$survivors$$player_collision_layer, Milky2018$selene$examples$survivors$$wall_collision_layer]);
  const bullet_alive = { val: true };
  Milky2018$selene$collision$$Area$on_enter(area, (hit_entity) => {
    if (bullet_alive.val) {
      const _p$3 = Milky2018$selene$examples$survivors$$game_state.player_entity;
      if (hit_entity === _p$3) {
        if (!Milky2018$selene$examples$survivors$$game_state.invincible) {
          Milky2018$selene$examples$survivors$$game_state.invincible = true;
          const penalty = Math.imul(250, Milky2018$selene$examples$survivors$$game_state.current_wave) | 0;
          const _p$4 = Milky2018$selene$examples$survivors$$game_state.score - penalty | 0;
          const _p$5 = 0;
          const new_score = _p$4 > _p$5 ? _p$4 : _p$5;
          Milky2018$selene$examples$survivors$$set_score(new_score);
          Milky2018$selene$examples$survivors$$trigger_damage_effect();
          Milky2018$selene$system$$timeout$46$inner(1, () => {
            Milky2018$selene$examples$survivors$$game_state.invincible = false;
          }, true);
        }
      }
      bullet_alive.val = false;
      Milky2018$selene$entity$$Entity$destroy(bullet_entity);
      return;
    } else {
      return;
    }
  });
  moonbitlang$core$builtin$$Map$set$13$(Milky2018$selene$collision$$areas, bullet_entity, area);
}
function Milky2018$selene$examples$survivors$$devil_shooting_system(delta) {
  if (Milky2018$selene$examples$survivors$$game_state.game_over) {
    return undefined;
  }
  const _it = moonbitlang$core$builtin$$Map$iterator2$4$(Milky2018$selene$examples$survivors$$enemies);
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator2$next$4$(_it);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      const _state = _x._1;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        if (moonbitlang$core$builtin$$op_notequal$41$(_state.enemy_type, 5)) {
          continue;
        }
        const _bind$9 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
        if (_bind$9 === undefined) {
          $panic();
        } else {
          const _Some$2 = _bind$9;
          const _enemy_pos = _Some$2;
          const _bind$10 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, Milky2018$selene$examples$survivors$$game_state.player_entity);
          if (_bind$10 === undefined) {
            $panic();
          } else {
            const _Some$3 = _bind$10;
            const _player_pos = _Some$3;
            if (_state.shoot_timer > 0) {
              _state.shoot_timer = _state.shoot_timer - delta;
            }
            if (_state.shoot_timer <= 0) {
              _state.shoot_timer = 5;
              Milky2018$selene$examples$survivors$$shoot_enemy_bullet(_enemy_pos, _player_pos);
            }
          }
        }
      } else {
        continue;
      }
      continue;
    }
  }
}
function Milky2018$selene$examples$survivors$$enemy_ai_system(_delta) {
  if (Milky2018$selene$examples$survivors$$game_state.game_over) {
    return undefined;
  }
  const _it = moonbitlang$core$builtin$$Map$iterator2$4$(Milky2018$selene$examples$survivors$$enemies);
  while (true) {
    const _bind$8 = moonbitlang$core$builtin$$Iterator2$next$4$(_it);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      const _state = _x._1;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        const _bind$9 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, Milky2018$selene$examples$survivors$$game_state.player_entity);
        if (_bind$9 === undefined) {
          $panic();
        } else {
          const _Some$2 = _bind$9;
          const _player_position = _Some$2;
          const _bind$10 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
          if (_bind$10 === undefined) {
            $panic();
          } else {
            const _Some$3 = _bind$10;
            const _position = _Some$3;
            const data$2 = Milky2018$selene$examples$survivors$$get_enemy_data(_state.enemy_type);
            const dir = { _0: _player_position._0 - _position._0, _1: _player_position._1 - _position._1 };
            const _p = Milky2018$selene$math$$Vec2D$normalize(dir);
            const _p$2 = _state.speed;
            const vel = { _0: _p._0 * _p$2, _1: _p._1 * _p$2 };
            moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$velocity$$velocities, _e, vel);
            if (Milky2018$selene$math$$Vec2D$op_get(vel, 0) >= 0) {
              Milky2018$selene$sprite$$play_animation$46$inner(_e, data$2.right_animation, false, -1, Option$None$0$, undefined);
            } else {
              Milky2018$selene$sprite$$play_animation$46$inner(_e, data$2.left_animation, false, -1, Option$None$0$, undefined);
            }
          }
        }
      } else {
        continue;
      }
      continue;
    }
  }
}
function Milky2018$selene$examples$survivors$$game_start(_delta) {
  Milky2018$selene$backend$$load_font("ThaleahFat", "assets/fonts/ThaleahFat.ttf");
  Milky2018$selene$camera$$set_limits(Milky2018$selene$examples$survivors$$game_start$46$constr$47$3832, Milky2018$selene$examples$survivors$$game_start$46$constr$47$3833, Milky2018$selene$examples$survivors$$game_start$46$constr$47$3834, Milky2018$selene$examples$survivors$$game_start$46$constr$47$3835);
  Milky2018$selene$examples$survivors$$add_player();
  Milky2018$selene$examples$survivors$$add_border({ _0: 640, _1: 640 });
  Milky2018$selene$examples$survivors$$add_background({ _0: 640, _1: 640 });
  Milky2018$selene$examples$survivors$$add_grass();
  Milky2018$selene$examples$survivors$$add_score_box();
  Milky2018$selene$examples$survivors$$add_timer_box();
  Milky2018$selene$examples$survivors$$add_wave_box();
  Milky2018$selene$examples$survivors$$add_level_box();
  Milky2018$selene$examples$survivors$$add_exp_box();
  Milky2018$selene$examples$survivors$$setup_level_up_ui();
  Milky2018$selene$examples$survivors$$setup_game_over_ui();
}
function Milky2018$selene$examples$survivors$$game_timer_system(delta) {
  if (Milky2018$selene$examples$survivors$$game_state.game_over) {
    if (!Milky2018$selene$examples$survivors$$game_state.game_over_displayed) {
      Milky2018$selene$examples$survivors$$game_state.game_over_displayed = true;
      Milky2018$selene$examples$survivors$$game_state.game_over_box.content = `Final Score: ${moonbitlang$core$int$$Int$to_string$46$inner(Milky2018$selene$examples$survivors$$game_state.score, 10)}`;
      Milky2018$selene$examples$survivors$$add_game_over_box();
    }
    return undefined;
  }
  if (Milky2018$selene$examples$survivors$$game_state.game_timer > 0) {
    Milky2018$selene$examples$survivors$$game_state.game_timer = Milky2018$selene$examples$survivors$$game_state.game_timer - delta;
    if (Milky2018$selene$examples$survivors$$game_state.game_timer < 0) {
      Milky2018$selene$examples$survivors$$game_state.game_timer = 0;
    }
  }
  const elapsed_time = 600 - Milky2018$selene$examples$survivors$$game_state.game_timer;
  let new_wave = moonbitlang$core$double$$Double$to_int(elapsed_time / 60) + 1 | 0;
  if (new_wave > 10) {
    new_wave = 10;
  }
  if (new_wave !== Milky2018$selene$examples$survivors$$game_state.current_wave) {
    Milky2018$selene$examples$survivors$$game_state.current_wave = new_wave;
    Milky2018$selene$examples$survivors$$game_state.wave_box.content = `Wave: ${moonbitlang$core$int$$Int$to_string$46$inner(Milky2018$selene$examples$survivors$$game_state.current_wave, 10)}`;
    Milky2018$selene$examples$survivors$$reset_wave_state();
  }
  const total_seconds = moonbitlang$core$double$$Double$to_int(Milky2018$selene$examples$survivors$$game_state.game_timer);
  const minutes = total_seconds / 60 | 0;
  const seconds = total_seconds % 60 | 0;
  const seconds_str = seconds < 10 ? `0${moonbitlang$core$int$$Int$to_string$46$inner(seconds, 10)}` : moonbitlang$core$int$$Int$to_string$46$inner(seconds, 10);
  Milky2018$selene$examples$survivors$$game_state.timer_box.content = `Time: ${moonbitlang$core$int$$Int$to_string$46$inner(minutes, 10)}:${seconds_str}`;
}
function Milky2018$selene$examples$survivors$$score_blink_system(delta) {
  if (Milky2018$selene$examples$survivors$$game_state.score_blink_timer > 0) {
    Milky2018$selene$examples$survivors$$game_state.score_blink_timer = Milky2018$selene$examples$survivors$$game_state.score_blink_timer - delta;
    const elapsed = 1 - Milky2018$selene$examples$survivors$$game_state.score_blink_timer;
    const should_be_red = (moonbitlang$core$double$$Double$to_int(elapsed / 0.1) % 2 | 0) === 0;
    const _p = Milky2018$selene$examples$survivors$$game_state.score_is_red;
    if (!(should_be_red === _p)) {
      Milky2018$selene$examples$survivors$$game_state.score_is_red = should_be_red;
      Milky2018$selene$examples$survivors$$game_state.score_box.color = should_be_red ? "red" : "white";
    }
    if (Milky2018$selene$examples$survivors$$game_state.score_blink_timer <= 0) {
      Milky2018$selene$examples$survivors$$game_state.score_blink_timer = 0;
      Milky2018$selene$examples$survivors$$game_state.score_is_red = false;
      Milky2018$selene$examples$survivors$$game_state.score_box.color = "white";
      return;
    } else {
      return;
    }
  } else {
    return;
  }
}
function Milky2018$selene$examples$survivors$$select_enemy_type_for_wave(rand) {
  const wave = Milky2018$selene$examples$survivors$$game_state.current_wave;
  if (wave < 1 || wave > 10) {
    return undefined;
  }
  const plan = moonbitlang$core$array$$Array$at$42$(Milky2018$selene$examples$survivors$$wave_spawn_plans, wave - 1 | 0);
  const available_types = [];
  if (Milky2018$selene$examples$survivors$$wave_state.creeper_spawned < plan.creeper_count) {
    moonbitlang$core$array$$Array$push$41$(available_types, 0);
  }
  if (Milky2018$selene$examples$survivors$$wave_state.icecream_spawned < plan.icecream_count) {
    moonbitlang$core$array$$Array$push$41$(available_types, 1);
  }
  if (Milky2018$selene$examples$survivors$$wave_state.orc_spawned < plan.orc_count) {
    moonbitlang$core$array$$Array$push$41$(available_types, 2);
  }
  if (Milky2018$selene$examples$survivors$$wave_state.skull_spawned < plan.skull_count) {
    moonbitlang$core$array$$Array$push$41$(available_types, 3);
  }
  if (Milky2018$selene$examples$survivors$$wave_state.teleman_spawned < plan.teleman_count) {
    moonbitlang$core$array$$Array$push$41$(available_types, 4);
  }
  if (Milky2018$selene$examples$survivors$$wave_state.devil_spawned < plan.devil_count) {
    moonbitlang$core$array$$Array$push$41$(available_types, 5);
  }
  if (Milky2018$selene$examples$survivors$$wave_state.pirate_spawned < plan.pirate_count) {
    moonbitlang$core$array$$Array$push$41$(available_types, 6);
  }
  if (available_types.length === 0) {
    return undefined;
  }
  const index = moonbitlang$core$random$$Rand$int$46$inner(rand, available_types.length);
  const enemy_type = moonbitlang$core$array$$Array$at$41$(available_types, index);
  switch (enemy_type) {
    case 0: {
      Milky2018$selene$examples$survivors$$wave_state.creeper_spawned = Milky2018$selene$examples$survivors$$wave_state.creeper_spawned + 1 | 0;
      break;
    }
    case 1: {
      Milky2018$selene$examples$survivors$$wave_state.icecream_spawned = Milky2018$selene$examples$survivors$$wave_state.icecream_spawned + 1 | 0;
      break;
    }
    case 2: {
      Milky2018$selene$examples$survivors$$wave_state.orc_spawned = Milky2018$selene$examples$survivors$$wave_state.orc_spawned + 1 | 0;
      break;
    }
    case 3: {
      Milky2018$selene$examples$survivors$$wave_state.skull_spawned = Milky2018$selene$examples$survivors$$wave_state.skull_spawned + 1 | 0;
      break;
    }
    case 4: {
      Milky2018$selene$examples$survivors$$wave_state.teleman_spawned = Milky2018$selene$examples$survivors$$wave_state.teleman_spawned + 1 | 0;
      break;
    }
    case 5: {
      Milky2018$selene$examples$survivors$$wave_state.devil_spawned = Milky2018$selene$examples$survivors$$wave_state.devil_spawned + 1 | 0;
      break;
    }
    default: {
      Milky2018$selene$examples$survivors$$wave_state.pirate_spawned = Milky2018$selene$examples$survivors$$wave_state.pirate_spawned + 1 | 0;
    }
  }
  return enemy_type;
}
function Milky2018$selene$examples$survivors$$spawn_enemy_system$46$spawn_enemy$124$36() {
  if (Milky2018$selene$examples$survivors$$game_state.game_over) {
    return undefined;
  }
  const rand = Milky2018$selene$examples$survivors$$game_state.rand;
  const wave = Milky2018$selene$examples$survivors$$game_state.current_wave;
  const spawn_interval = wave >= 1 && wave <= 10 ? moonbitlang$core$array$$Array$at$42$(Milky2018$selene$examples$survivors$$wave_spawn_plans, wave - 1 | 0).spawn_interval : 1;
  const _bind$8 = Milky2018$selene$examples$survivors$$select_enemy_type_for_wave(rand);
  if (_bind$8 === undefined) {
  } else {
    const _Some = _bind$8;
    const _enemy_type = _Some;
    const enemy = Milky2018$selene$entity$$Entity$new();
    const pos = moonbitlang$core$array$$Array$at$43$(Milky2018$selene$examples$survivors$$spawners, moonbitlang$core$random$$Rand$int$46$inner(rand, Milky2018$selene$examples$survivors$$spawners.length));
    moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, enemy, pos);
    moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$velocity$$velocities, enemy, { _0: 0, _1: 0 });
    const data$2 = Milky2018$selene$examples$survivors$$get_enemy_data(_enemy_type);
    const sprite = Milky2018$selene$sprite$$Sprite$from_animation$46$inner(data$2.right_animation, 2, { _0: -8, _1: -12 });
    const enemy_state = { enemy_type: _enemy_type, speed: data$2.speed, health: data$2.health, shoot_timer: 0 };
    moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$sprite$$sprites, enemy, sprite);
    moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, enemy, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 8, _1: 8 }, { _0: -4, _1: -4 }));
    moonbitlang$core$builtin$$Map$set$12$(Milky2018$selene$collision$$collision_layers, enemy, Milky2018$selene$examples$survivors$$enemy_collision_layer);
    moonbitlang$core$builtin$$Map$set$17$(Milky2018$selene$collision$$colliders, enemy, Milky2018$selene$collision$$Collider$new([Milky2018$selene$examples$survivors$$enemy_collision_layer, Milky2018$selene$examples$survivors$$wall_collision_layer]));
    moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$examples$survivors$$enemies, enemy, enemy_state);
    const area = Milky2018$selene$collision$$Area$new([Milky2018$selene$examples$survivors$$player_collision_layer]);
    moonbitlang$core$builtin$$Map$set$13$(Milky2018$selene$collision$$areas, enemy, area);
    Milky2018$selene$collision$$Area$on_enter(area, (e) => {
      if (Milky2018$selene$entity$$Entity$is_alive(e)) {
        const _p = Milky2018$selene$examples$survivors$$game_state.player_entity;
        if (e === _p) {
          if (Milky2018$selene$examples$survivors$$game_state.invincible) {
            return undefined;
          }
          Milky2018$selene$examples$survivors$$game_state.invincible = true;
          const penalty = Math.imul(250, Milky2018$selene$examples$survivors$$game_state.current_wave) | 0;
          const _p$2 = Milky2018$selene$examples$survivors$$game_state.score - penalty | 0;
          const _p$3 = 0;
          const new_score = _p$2 > _p$3 ? _p$2 : _p$3;
          Milky2018$selene$examples$survivors$$set_score(new_score);
          Milky2018$selene$examples$survivors$$trigger_damage_effect();
          Milky2018$selene$system$$timeout$46$inner(1, () => {
            Milky2018$selene$examples$survivors$$game_state.invincible = false;
          }, true);
          return;
        } else {
          return;
        }
      } else {
        return;
      }
    });
  }
  Milky2018$selene$system$$timeout$46$inner(spawn_interval, Milky2018$selene$examples$survivors$$spawn_enemy_system$46$spawn_enemy$124$36, true);
}
function Milky2018$selene$examples$survivors$$spawn_enemy_system(_delta) {
  Milky2018$selene$examples$survivors$$spawn_enemy_system$46$spawn_enemy$124$36();
}
(() => {
  Milky2018$selene$system$$App$run(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system$46$inner(Milky2018$selene$system$$App$add_system$46$inner(Milky2018$selene$system$$App$add_plugin(Milky2018$selene$system$$App$with_fps(Milky2018$selene$system$$App$with_zoom(Milky2018$selene$system$$App$with_image_smooth(Milky2018$selene$system$$App$with_canvas_height(Milky2018$selene$system$$App$with_canvas_width(Milky2018$selene$system$$App$new(), 960), 640), false), 2), moonbitlang$core$double$$Double$to_uint(60)), Milky2018$selene$plugins$$default_plugin), Milky2018$selene$examples$survivors$$game_start, $64$Milky2018$47$selene$47$system$46$Schedule$Startup, undefined), Milky2018$selene$examples$survivors$$spawn_enemy_system, $64$Milky2018$47$selene$47$system$46$Schedule$Startup, undefined), Milky2018$selene$examples$survivors$$player_update_system, undefined, undefined), Milky2018$selene$examples$survivors$$player_shooting_system, undefined, undefined), Milky2018$selene$examples$survivors$$enemy_ai_system, undefined, undefined), Milky2018$selene$examples$survivors$$devil_shooting_system, undefined, undefined), Milky2018$selene$examples$survivors$$check_victory_system, undefined, undefined), Milky2018$selene$examples$survivors$$game_timer_system, undefined, undefined), Milky2018$selene$examples$survivors$$score_blink_system, undefined, undefined));
})();
