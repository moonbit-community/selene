const $64$Milky2018$47$selene$47$system$46$Schedule$Startup = { $tag: 0 };
const $64$Milky2018$47$selene$47$system$46$Schedule$Update = { $tag: 1 };
function $64$Milky2018$47$selene$47$system$46$Schedule$Render(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$system$46$Schedule$Render.prototype.$tag = 2;
function HandRank$HighCard(param0) {
  this._0 = param0;
}
HandRank$HighCard.prototype.$tag = 0;
function HandRank$OnePair(param0) {
  this._0 = param0;
}
HandRank$OnePair.prototype.$tag = 1;
function HandRank$TwoPair(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
HandRank$TwoPair.prototype.$tag = 2;
function HandRank$ThreeOfKind(param0) {
  this._0 = param0;
}
HandRank$ThreeOfKind.prototype.$tag = 3;
function HandRank$Straight(param0) {
  this._0 = param0;
}
HandRank$Straight.prototype.$tag = 4;
function HandRank$Flush(param0) {
  this._0 = param0;
}
HandRank$Flush.prototype.$tag = 5;
function HandRank$FullHouse(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
HandRank$FullHouse.prototype.$tag = 6;
function HandRank$FourOfKind(param0) {
  this._0 = param0;
}
HandRank$FourOfKind.prototype.$tag = 7;
function HandRank$StraightFlush(param0) {
  this._0 = param0;
}
HandRank$StraightFlush.prototype.$tag = 8;
const Option$None$0$ = { $tag: 0 };
function Option$Some$0$(param0) {
  this._0 = param0;
}
Option$Some$0$.prototype.$tag = 1;
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
const $bytes_literal$0 = new Uint8Array([65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,49,50,51,52,53,54]);
const $4294967295L = { hi: 0, lo: -1 };
const $0L = { hi: 0, lo: 0 };
const $1L = { hi: 0, lo: 1 };
function $bound_check(arr, index) {
  if (index < 0 || index >= arr.length) throw new Error("Index out of bounds");
}
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
const $64$moonbitlang$47$core$47$list$46$List$Empty$1$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$list$46$List$More$1$(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$list$46$List$More$1$.prototype.$tag = 1;
function $compare_int(a, b) {
  return (a >= b) - (a <= b);
}
const moonbitlang$core$builtin$$random_seed = () => {
  if (globalThis.crypto?.getRandomValues) {
    const array = new Uint32Array(1);
    globalThis.crypto.getRandomValues(array);
    return array[0] | 0; // Convert to signed 32
  } else {
    return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
  }
};
const Option$None$2$ = { $tag: 0 };
function Option$Some$2$(param0) {
  this._0 = param0;
}
Option$Some$2$.prototype.$tag = 1;
const Option$None$3$ = { $tag: 0 };
function Option$Some$3$(param0) {
  this._0 = param0;
}
Option$Some$3$.prototype.$tag = 1;
const moonbitlang$core$builtin$$JSArray$push = (arr, val) => { arr.push(val); };
const moonbitlang$core$builtin$$get_int64_wasm_helper = function f() {
  if (f._exports) return f._exports;
  return f._exports = new WebAssembly.Instance(new WebAssembly.Module(new Uint8Array([0, 97, 115, 109, 1, 0, 0, 0, 1, 13, 2, 96, 0, 1, 127, 96, 4, 127, 127, 127, 127, 1, 127, 3, 7, 6, 0, 1, 1, 1, 1, 1, 6, 6, 1, 127, 1, 65, 0, 11, 7, 50, 6, 3, 109, 117, 108, 0, 1, 5, 100, 105, 118, 95, 115, 0, 2, 5, 100, 105, 118, 95, 117, 0, 3, 5, 114, 101, 109, 95, 115, 0, 4, 5, 114, 101, 109, 95, 117, 0, 5, 8, 103, 101, 116, 95, 104, 105, 103, 104, 0, 0, 10, 191, 1, 6, 4, 0, 35, 0, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 126, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 127, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 128, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 129, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 130, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11])), {}).exports;
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
const rami3l$js$45$ffi$js$$Value$undefined = () => undefined;
const rami3l$js$45$ffi$js$$Value$is_null = (n) => Object.is(n, null);
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
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text$46$inner = (self,text,x,y,maxWidth) => self.fillText(text,x,y,maxWidth);
const Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$draw_image_with_src_and_dst_size = (self,image,sx,sy,sw,sh,dx,dy,dw,dh) => self.drawImage(image,sx,sy,sw,sh,dx,dy,dw,dh);
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
const Option$None$8$ = { $tag: 0 };
function Option$Some$8$(param0) {
  this._0 = param0;
}
Option$Some$8$.prototype.$tag = 1;
function $f64_convert_i32_u(a) {
  return a < 0 ? a + 4294967296.0 : a + 0.0;
}
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
const $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$9$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$9$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$9$.prototype.$tag = 1;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$9$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$9$.prototype.$tag = 2;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$9$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$9$.prototype.$tag = 3;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$9$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$9$.prototype.$tag = 4;
const $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$10$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$10$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$10$.prototype.$tag = 1;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$10$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$10$.prototype.$tag = 2;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$10$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$10$.prototype.$tag = 3;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$10$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$10$.prototype.$tag = 4;
function $64$Milky2018$47$selene$47$style$46$SizePlan$Sized(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$style$46$SizePlan$Sized.prototype.$tag = 0;
const $64$Milky2018$47$selene$47$style$46$SizePlan$FromSprite = { $tag: 1 };
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
const $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$12$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$12$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$12$.prototype.$tag = 1;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$12$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$12$.prototype.$tag = 2;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$12$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$12$.prototype.$tag = 3;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$12$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$12$.prototype.$tag = 4;
function $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect.prototype.$tag = 0;
const Milky2018$selene$inputs$$mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const Milky2018$selene$inputs$$mouse_movement = { movement: { _0: 0, _1: 0 } };
const Milky2018$selene$inputs$$last_mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const Milky2018$selene$inputs$$just_pressed_mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const Milky2018$selene$inputs$$just_release_mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const Milky2018$selene$inputs$$from_string$46$constr$47$2328 = 0;
const Milky2018$selene$inputs$$from_string$46$constr$47$2329 = 1;
const Milky2018$selene$inputs$$from_string$46$constr$47$2330 = 2;
const Milky2018$selene$inputs$$from_string$46$constr$47$2331 = 3;
const Milky2018$selene$inputs$$from_string$46$constr$47$2332 = 4;
const Milky2018$selene$inputs$$from_string$46$constr$47$2333 = 5;
const Milky2018$selene$inputs$$from_string$46$constr$47$2334 = 6;
const Milky2018$selene$inputs$$from_string$46$constr$47$2335 = 7;
const Milky2018$selene$inputs$$from_string$46$constr$47$2336 = 8;
const Milky2018$selene$inputs$$from_string$46$constr$47$2337 = 9;
const Milky2018$selene$inputs$$from_string$46$constr$47$2338 = 10;
const Milky2018$selene$inputs$$from_string$46$constr$47$2339 = 11;
const Milky2018$selene$inputs$$from_string$46$constr$47$2340 = 12;
const Milky2018$selene$inputs$$from_string$46$constr$47$2341 = 13;
const Milky2018$selene$inputs$$from_string$46$constr$47$2342 = 14;
const Milky2018$selene$inputs$$from_string$46$constr$47$2343 = 15;
const Milky2018$selene$inputs$$from_string$46$constr$47$2344 = 16;
const Milky2018$selene$inputs$$from_string$46$constr$47$2345 = 17;
const Milky2018$selene$inputs$$from_string$46$constr$47$2346 = 18;
const Milky2018$selene$inputs$$from_string$46$constr$47$2347 = 19;
const Milky2018$selene$inputs$$from_string$46$constr$47$2348 = 20;
const Milky2018$selene$inputs$$from_string$46$constr$47$2349 = 21;
const Milky2018$selene$inputs$$from_string$46$constr$47$2350 = 22;
const Milky2018$selene$inputs$$from_string$46$constr$47$2351 = 23;
const Milky2018$selene$inputs$$from_string$46$constr$47$2352 = 24;
const Milky2018$selene$inputs$$from_string$46$constr$47$2353 = 26;
const Milky2018$selene$inputs$$from_string$46$constr$47$2354 = 27;
const Milky2018$selene$inputs$$from_string$46$constr$47$2355 = 28;
const Milky2018$selene$inputs$$from_string$46$constr$47$2356 = 29;
const Milky2018$selene$inputs$$from_string$46$constr$47$2357 = 30;
const Milky2018$selene$inputs$$from_string$46$constr$47$2358 = 31;
const Milky2018$selene$inputs$$from_string$46$constr$47$2359 = 32;
const Milky2018$selene$entity$$entity_generator = { val: 0 };
const Milky2018$selene$plugins$$default_plugin$46$constr$47$3213 = new $64$Milky2018$47$selene$47$system$46$Schedule$Render(0);
const Milky2018$selene$examples$cards$$is_straight$46$constr$47$3273 = 14;
const Milky2018$selene$examples$cards$$find_best_hand$46$constr$47$3337 = new HandRank$HighCard(0);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3400 = new Option$Some$0$(120);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3401 = new Option$Some$0$(285);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3402 = "white";
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3403 = "16px ThaleahFat";
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3404 = new Option$Some$0$(20);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3405 = new Option$Some$0$(4.5);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3406 = new Option$Some$0$(205);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3407 = new Option$Some$0$(285);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3408 = new Option$Some$0$(20);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3409 = new Option$Some$0$(4.5);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3410 = new Option$Some$0$(290);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3411 = new Option$Some$0$(285);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3412 = "white";
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3413 = "16px ThaleahFat";
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3414 = new Option$Some$0$(17);
const Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3415 = new Option$Some$0$(4.5);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3428 = new Option$Some$0$(200);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3429 = new Option$Some$0$(20);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3430 = new Option$Some$0$(200);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3431 = new Option$Some$0$(40);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3432 = new Option$Some$0$(20);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3433 = new Option$Some$0$(20);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3434 = new Option$Some$0$(390);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3435 = new Option$Some$0$(20);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3436 = new Option$Some$0$(180);
const Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3437 = new Option$Some$0$(80);
const moonbitlang$core$builtin$$seed = moonbitlang$core$builtin$$random_seed();
const Milky2018$selene$style$$styles = moonbitlang$core$builtin$$Map$new$46$inner$0$(8);
const Milky2018$selene$entity$$all_entities = moonbitlang$core$set$$Set$new$46$inner$1$(8);
const Milky2018$selene$style$$screen_root = Milky2018$selene$entity$$Entity$new();
const Milky2018$selene$backend$$canvas_backend = Milky2018$selene$backend$$CanvasBackend$new();
const Milky2018$selene$position$$positions = moonbitlang$core$builtin$$Map$new$46$inner$2$(8);
const Milky2018$selene$ui$$uis = moonbitlang$core$builtin$$Map$new$46$inner$3$(8);
const Milky2018$selene$inputs$$pressed_keys = moonbitlang$core$set$$Set$new$46$inner$4$(8);
const Milky2018$selene$backend$$window = Yoorkin$rabbit$45$tea$dom$$window();
const Milky2018$selene$backend$$realtime_delta = moonbitlang$core$ref$$Ref$new$5$(0);
const Milky2018$selene$entity$$parents = moonbitlang$core$builtin$$Map$new$46$inner$6$(8);
const Milky2018$selene$entity$$children = moonbitlang$core$builtin$$Map$new$46$inner$7$(8);
const _bind = { _0: 0, _1: 0 };
const _bind$2 = Option$None$0$;
const _bind$3 = Option$None$0$;
const _bind$4 = Option$None$0$;
const _bind$5 = Option$None$0$;
const _bind$6 = undefined;
const _bind$7 = { _0: 0, _1: 0 };
const Milky2018$selene$camera$$camera = { position: _bind, limit_top: _bind$4, limit_bottom: _bind$2, limit_left: _bind$3, limit_right: _bind$5, attached_entity: _bind$6, offset: _bind$7, follow_x: true, follow_y: true };
const Milky2018$selene$collision$$shapes = moonbitlang$core$builtin$$Map$new$46$inner$8$(8);
const Milky2018$selene$collision$$pickables = moonbitlang$core$builtin$$Map$new$46$inner$9$(8);
const Milky2018$selene$collision$$quadtree_root = moonbitlang$core$ref$$Ref$new$10$(Milky2018$selene$collision$$QuadTree$new({ _0: 0, _1: 0 }, { _0: 0, _1: 0 }, 0));
const Milky2018$selene$collision$$real_velocities = moonbitlang$core$builtin$$Map$new$46$inner$11$(8);
const Milky2018$selene$collision$$collision_infos = moonbitlang$core$builtin$$Map$new$46$inner$12$(8);
const Milky2018$selene$collision$$colliders = moonbitlang$core$builtin$$Map$new$46$inner$13$(8);
const Milky2018$selene$collision$$collision_layers = moonbitlang$core$builtin$$Map$new$46$inner$14$(8);
const Milky2018$selene$velocity$$velocities = moonbitlang$core$builtin$$Map$new$46$inner$11$(8);
const Milky2018$selene$sprite$$sprites = moonbitlang$core$builtin$$Map$new$46$inner$15$(8);
const Milky2018$selene$system$$deferred_events = moonbitlang$core$array$$Array$new$46$inner$16$(0);
const Milky2018$selene$collision$$areas = moonbitlang$core$builtin$$Map$new$46$inner$17$(8);
const Milky2018$selene$inputs$$last_pressed_keys = moonbitlang$core$set$$Set$new$46$inner$4$(8);
const Milky2018$selene$inputs$$all_codes = moonbitlang$core$set$$Set$from_array$4$([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]);
const Milky2018$selene$inputs$$just_pressed_keys = moonbitlang$core$set$$Set$new$46$inner$4$(8);
const Milky2018$selene$inputs$$just_release_keys = moonbitlang$core$set$$Set$new$46$inner$4$(8);
const Milky2018$selene$backend$$element_cache = moonbitlang$core$builtin$$Map$new$46$inner$18$(8);
const Milky2018$selene$system$$timers = moonbitlang$core$array$$Array$new$46$inner$19$(0);
const Milky2018$selene$examples$cards$$game_state = { rand: moonbitlang$core$random$$Rand$new(undefined), deck: [], player: { chips: 1000, hole_cards: [], current_bet: 0, has_folded: false, position: { _0: 240, _1: 240 } }, phase: 0, current_bet: 0, community_cards: [], hand_number: 0, small_blind: 10, big_blind: 20, turns_remaining: 10, starting_chips: 1000, magnification: 1, blind_text: Milky2018$selene$sprite$$Text$new("Blind: $20", "gold", "20px ThaleahFat", undefined, undefined), chips_text: Milky2018$selene$sprite$$Text$new("Chips: $1000", "lightgreen", "18px ThaleahFat", undefined, undefined), phase_text: Milky2018$selene$sprite$$Text$new("Pre-Flop", "white", "18px ThaleahFat", undefined, undefined), call_button_text: Milky2018$selene$sprite$$Text$new("Call", "white", "16px ThaleahFat", undefined, undefined), turns_text: Milky2018$selene$sprite$$Text$new("Turns: 10/10", "white", "18px ThaleahFat", undefined, undefined), action_text: Milky2018$selene$sprite$$Text$new("", "yellow", "16px ThaleahFat", undefined, undefined), hand_strength_text: Milky2018$selene$sprite$$Text$new("", "cyan", "16px ThaleahFat", undefined, undefined), fold_button: Milky2018$selene$entity$$Entity$new(), call_button: Milky2018$selene$entity$$Entity$new(), raise_button: Milky2018$selene$entity$$Entity$new(), waiting_for_player: false, hole_card_entities: [], community_card_entities: [] };
const Milky2018$selene$sprite$$animation_generator = moonbitlang$core$ref$$Ref$new$20$(0);
function moonbitlang$core$abort$$abort$21$(msg) {
  $panic();
}
function moonbitlang$core$abort$$abort$20$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$22$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$23$(msg) {
  return $panic();
}
function moonbitlang$core$random$$Source$next$24$(self) {
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
function moonbitlang$core$random$$chacha8$46$inner(seed) {
  return { self: moonbitlang$core$random$internal$random_source$$ChaCha8$new(seed), method_0: moonbitlang$core$random$$Source$next$24$ };
}
function moonbitlang$core$random$$Rand$new(generator) {
  if (generator === undefined) {
    return moonbitlang$core$random$$chacha8$46$inner($bytes_literal$0);
  } else {
    const _Some = generator;
    const _gen = _Some;
    return _gen;
  }
}
function moonbitlang$core$random$$umul128(a, b) {
  const aLo = moonbitlang$core$builtin$$BitAnd$land$25$(a, $4294967295L);
  const aHi = moonbitlang$core$builtin$$Shr$shr$25$(a, 32);
  const bLo = moonbitlang$core$builtin$$BitAnd$land$25$(b, $4294967295L);
  const bHi = moonbitlang$core$builtin$$Shr$shr$25$(b, 32);
  const x = moonbitlang$core$builtin$$Mul$mul$25$(aLo, bLo);
  const y = moonbitlang$core$builtin$$Add$add$25$(moonbitlang$core$builtin$$Mul$mul$25$(aHi, bLo), moonbitlang$core$builtin$$Shr$shr$25$(x, 32));
  const z = moonbitlang$core$builtin$$Add$add$25$(moonbitlang$core$builtin$$Mul$mul$25$(aLo, bHi), moonbitlang$core$builtin$$BitAnd$land$25$(y, $4294967295L));
  const w = moonbitlang$core$builtin$$Add$add$25$(moonbitlang$core$builtin$$Add$add$25$(moonbitlang$core$builtin$$Mul$mul$25$(aHi, bHi), moonbitlang$core$builtin$$Shr$shr$25$(y, 32)), moonbitlang$core$builtin$$Shr$shr$25$(z, 32));
  return { hi: w, lo: moonbitlang$core$builtin$$Mul$mul$25$(a, b) };
}
function moonbitlang$core$random$$Rand$uint64$46$inner(self, limit) {
  if (moonbitlang$core$builtin$$Eq$equal$25$(limit, $0L)) {
    const _p = self;
    return _p.method_0(_p.self);
  } else {
    if (moonbitlang$core$builtin$$Eq$equal$25$(moonbitlang$core$builtin$$BitAnd$land$25$(limit, moonbitlang$core$builtin$$Sub$sub$25$(limit, $1L)), $0L)) {
      const _p = self;
      return moonbitlang$core$builtin$$BitAnd$land$25$(_p.method_0(_p.self), moonbitlang$core$builtin$$Sub$sub$25$(limit, $1L));
    }
  }
  const _p = self;
  let r = moonbitlang$core$random$$umul128(_p.method_0(_p.self), limit);
  if (moonbitlang$core$builtin$$op_lt$25$(r.lo, limit)) {
    const thresh = moonbitlang$core$builtin$$Mod$mod$25$(moonbitlang$core$uint64$$UInt64$lnot(limit), limit);
    while (true) {
      if (moonbitlang$core$builtin$$op_lt$25$(r.lo, thresh)) {
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
function moonbitlang$core$bytes$$BytesView$at(self, index) {
  if (index >= 0 && index < self.len) {
    const _tmp = self.bytes;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    return _tmp[_tmp$2];
  } else {
    return moonbitlang$core$abort$$abort$23$(`index out of bounds: the len is from 0 to ${moonbitlang$core$builtin$$Show$to_string$20$(self.len)} but the index is ${moonbitlang$core$builtin$$Show$to_string$20$(index)}`);
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
  return start$2 >= 0 && (start$2 <= end$2 && end$2 <= len) ? { bytes: self, start: start$2, len: end$2 - start$2 | 0 } : moonbitlang$core$abort$$abort$22$("Invalid index for View");
}
function moonbitlang$core$bytes$$BytesView$to_uint_le(self) {
  const _p = moonbitlang$core$bytes$$BytesView$at(self, 0);
  const _p$2 = moonbitlang$core$bytes$$BytesView$at(self, 1);
  const _tmp = (_p >>> 0) + (_p$2 << 8 >>> 0) | 0;
  const _p$3 = moonbitlang$core$bytes$$BytesView$at(self, 2);
  const _tmp$2 = (_tmp >>> 0) + (_p$3 << 16 >>> 0) | 0;
  const _p$4 = moonbitlang$core$bytes$$BytesView$at(self, 3);
  return (_tmp$2 >>> 0) + (_p$4 << 24 >>> 0) | 0;
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
  const a = t._0;
  const b = t._1;
  const c = t._2;
  const d = t._3;
  const a$2 = (a >>> 0) + (b >>> 0) | 0;
  const d$2 = d ^ a$2;
  const d$3 = d$2 << 16 | (d$2 >>> 16 | 0);
  const c$2 = (c >>> 0) + (d$3 >>> 0) | 0;
  const b$2 = b ^ c$2;
  const b$3 = b$2 << 12 | (b$2 >>> 20 | 0);
  const a$3 = (a$2 >>> 0) + (b$3 >>> 0) | 0;
  const d$4 = d$3 ^ a$3;
  const d$5 = d$4 << 8 | (d$4 >>> 24 | 0);
  const c$3 = (c$2 >>> 0) + (d$5 >>> 0) | 0;
  const b$4 = b$3 ^ c$3;
  const b$5 = b$4 << 7 | (b$4 >>> 25 | 0);
  return { _0: a$3, _1: b$5, _2: c$3, _3: d$5 };
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
          const tb1 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b0, _1: b4, _2: b8, _3: b12 });
          b0 = tb1._0;
          b4 = tb1._1;
          b8 = tb1._2;
          b12 = tb1._3;
          const tb2 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b1, _1: b5, _2: b9, _3: b13 });
          b1 = tb2._0;
          b5 = tb2._1;
          b9 = tb2._2;
          b13 = tb2._3;
          const tb3 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b2, _1: b6, _2: b10, _3: b14 });
          b2 = tb3._0;
          b6 = tb3._1;
          b10 = tb3._2;
          b14 = tb3._3;
          const tb4 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b3, _1: b7, _2: b11, _3: b15 });
          b3 = tb4._0;
          b7 = tb4._1;
          b11 = tb4._2;
          b15 = tb4._3;
          const tb5 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b0, _1: b5, _2: b10, _3: b15 });
          b0 = tb5._0;
          b5 = tb5._1;
          b10 = tb5._2;
          b15 = tb5._3;
          const tb6 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b1, _1: b6, _2: b11, _3: b12 });
          b1 = tb6._0;
          b6 = tb6._1;
          b11 = tb6._2;
          b12 = tb6._3;
          const tb7 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b2, _1: b7, _2: b8, _3: b13 });
          b2 = tb7._0;
          b7 = tb7._1;
          b8 = tb7._2;
          b13 = tb7._3;
          const tb8 = moonbitlang$core$random$internal$random_source$$chacha_block$46$qr$124$35({ _0: b3, _1: b4, _2: b9, _3: b14 });
          b3 = tb8._0;
          b4 = tb8._1;
          b9 = tb8._2;
          b14 = tb8._3;
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
  const seed$2 = moonbitlang$core$array$$FixedArray$makei$26$(8, (i) => moonbitlang$core$bytes$$BytesView$to_uint_le(moonbitlang$core$bytes$$Bytes$sub$46$inner(seed, Math.imul(i, 4) | 0, (Math.imul(i, 4) | 0) + 4 | 0)));
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
  return moonbitlang$core$builtin$$BitOr$lor$25$(moonbitlang$core$builtin$$Shl$shl$25$(hi, 32), lo);
}
function moonbitlang$core$random$internal$random_source$$ChaCha8$refill(self) {
  self.counter = (self.counter >>> 0) + (4 >>> 0) | 0;
  if (self.counter === 16) {
    moonbitlang$core$array$$FixedArray$blit_to$46$inner$27$(self.buffer, self.seed, 8, 56, 0);
    self.counter = 0;
  }
  moonbitlang$core$random$internal$random_source$$chacha_block(self.seed, self.buffer, self.counter);
  self.i = 0;
  self.n = self.counter === 12 ? 28 : 32;
}
function moonbitlang$core$list$$List$of$10$(arr) {
  let _tmp = arr.length - 1 | 0;
  let _tmp$2 = $64$moonbitlang$47$core$47$list$46$List$Empty$1$;
  while (true) {
    const i = _tmp;
    const list = _tmp$2;
    if (i >= 0) {
      _tmp = i - 1 | 0;
      $bound_check(arr, i);
      _tmp$2 = new $64$moonbitlang$47$core$47$list$46$List$More$1$(arr[i], list);
      continue;
    } else {
      return list;
    }
  }
}
function moonbitlang$core$set$$Set$new$46$inner$4$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$set$$Set$new$46$inner$1$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$set$$Set$add_entry_to_tail$1$(self, idx, entry) {
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
function moonbitlang$core$set$$Set$add_entry_to_tail$4$(self, idx, entry) {
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
function moonbitlang$core$set$$Set$set_entry$4$(self, entry, new_idx) {
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
function moonbitlang$core$set$$Set$set_entry$1$(self, entry, new_idx) {
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
function moonbitlang$core$set$$Set$push_away$1$(self, idx, entry) {
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
      moonbitlang$core$set$$Set$set_entry$1$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$set$$Set$set_entry$1$(self, entry$2, idx$2);
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
function moonbitlang$core$set$$Set$push_away$4$(self, idx, entry) {
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
      moonbitlang$core$set$$Set$set_entry$4$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$set$$Set$set_entry$4$(self, entry$2, idx$2);
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
function moonbitlang$core$set$$Set$add_with_hash$1$(self, key, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$set$$Set$grow$1$(self);
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
        moonbitlang$core$set$$Set$push_away$1$(self, idx, _curr_entry);
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
  moonbitlang$core$set$$Set$add_entry_to_tail$1$(self, _idx, entry);
}
function moonbitlang$core$set$$Set$add_with_hash$4$(self, key, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$set$$Set$grow$4$(self);
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
      if (_curr_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$4$(_curr_entry.key, key)) {
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$set$$Set$push_away$4$(self, idx, _curr_entry);
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
  moonbitlang$core$set$$Set$add_entry_to_tail$4$(self, _idx, entry);
}
function moonbitlang$core$set$$Set$grow$1$(self) {
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
      moonbitlang$core$set$$Set$add_with_hash$1$(self, _key, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$grow$4$(self) {
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
      moonbitlang$core$set$$Set$add_with_hash$4$(self, _key, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$add$1$(self, key) {
  moonbitlang$core$set$$Set$add_with_hash$1$(self, key, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$set$$Set$add$4$(self, key) {
  moonbitlang$core$set$$Set$add_with_hash$4$(self, key, moonbitlang$core$builtin$$Hash$hash$29$(key));
}
function moonbitlang$core$set$$Set$from_array$4$(arr) {
  const length = arr.length;
  let capacity = moonbitlang$core$int$$Int$next_power_of_two(length);
  const _p = capacity;
  if (length > ((Math.imul(_p, 13) | 0) / 16 | 0)) {
    capacity = Math.imul(capacity, 2) | 0;
  }
  const m = moonbitlang$core$set$$Set$new$46$inner$4$(capacity);
  const _p$2 = arr.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = arr[_p$3];
      moonbitlang$core$set$$Set$add$4$(m, _p$4);
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function moonbitlang$core$set$$Set$contains$1$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
function moonbitlang$core$set$$Set$contains$4$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$29$(key);
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
      if (_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$4$(_entry.key, key)) {
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
function moonbitlang$core$set$$Set$remove_entry$4$(self, entry) {
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
function moonbitlang$core$set$$Set$remove_entry$1$(self, entry) {
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
function moonbitlang$core$set$$Set$shift_back$4$(self, idx) {
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
          moonbitlang$core$set$$Set$set_entry$4$(self, _x, idx$2);
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
function moonbitlang$core$set$$Set$shift_back$1$(self, idx) {
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
          moonbitlang$core$set$$Set$set_entry$1$(self, _x, idx$2);
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
function moonbitlang$core$set$$Set$remove$4$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$29$(key);
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
      if (_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$4$(_entry.key, key)) {
        moonbitlang$core$set$$Set$remove_entry$4$(self, _entry);
        moonbitlang$core$set$$Set$shift_back$4$(self, idx);
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
function moonbitlang$core$set$$Set$remove$1$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
        moonbitlang$core$set$$Set$remove_entry$1$(self, _entry);
        moonbitlang$core$set$$Set$shift_back$1$(self, idx);
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
function moonbitlang$core$set$$Set$clear$4$(self) {
  moonbitlang$core$array$$FixedArray$fill$46$inner$30$(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function moonbitlang$core$set$$Set$iter$4$(self) {
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
function moonbitlang$core$set$$Set$iter$1$(self) {
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
function moonbitlang$core$set$$Set$difference$4$(self, other) {
  const m = moonbitlang$core$set$$Set$new$46$inner$4$(8);
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
      if (!moonbitlang$core$set$$Set$contains$4$(other, _p$4)) {
        moonbitlang$core$set$$Set$add$4$(m, _p$4);
      }
      _tmp = _p$5;
      continue;
    }
  }
  return m;
}
function moonbitlang$core$set$$Set$union$4$(self, other) {
  const m = moonbitlang$core$set$$Set$new$46$inner$4$(8);
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
      moonbitlang$core$set$$Set$add$4$(m, _p$4);
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
      moonbitlang$core$set$$Set$add$4$(m, _p$4);
      _tmp$2 = _p$5;
      continue;
    }
  }
  return m;
}
function moonbitlang$core$set$$Set$union$1$(self, other) {
  const m = moonbitlang$core$set$$Set$new$46$inner$1$(8);
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
      moonbitlang$core$set$$Set$add$1$(m, _p$4);
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
      moonbitlang$core$set$$Set$add$1$(m, _p$4);
      _tmp$2 = _p$5;
      continue;
    }
  }
  return m;
}
function moonbitlang$core$array$$get_limit(len) {
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
function moonbitlang$core$array$$Array$bubble_sort_by$31$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const _start1236 = actual_start + 1 | 0;
  let _tmp = _start1236;
  while (true) {
    const i = _tmp;
    if (i < actual_end) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$31$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$31$(arr, j)) > 0) {
          const temp = moonbitlang$core$array$$Array$at$31$(arr, j);
          moonbitlang$core$array$$Array$set$31$(arr, j, moonbitlang$core$array$$Array$at$31$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$31$(arr, j - 1 | 0, temp);
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
function moonbitlang$core$array$$Array$bubble_sort_by$32$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const _start1236 = actual_start + 1 | 0;
  let _tmp = _start1236;
  while (true) {
    const i = _tmp;
    if (i < actual_end) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$32$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$32$(arr, j)) > 0) {
          const temp = moonbitlang$core$array$$Array$at$32$(arr, j);
          moonbitlang$core$array$$Array$set$32$(arr, j, moonbitlang$core$array$$Array$at$32$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$32$(arr, j - 1 | 0, temp);
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
function moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$382(_env, a_idx, b_idx) {
  const swaps = _env._3;
  const cmp = _env._2;
  const arr = _env._1;
  const actual_start = _env._0;
  const a_pos = actual_start + a_idx | 0;
  const b_pos = actual_start + b_idx | 0;
  if (cmp(moonbitlang$core$array$$Array$at$31$(arr, a_pos), moonbitlang$core$array$$Array$at$31$(arr, b_pos)) > 0) {
    const temp = moonbitlang$core$array$$Array$at$31$(arr, a_pos);
    moonbitlang$core$array$$Array$set$31$(arr, a_pos, moonbitlang$core$array$$Array$at$31$(arr, b_pos));
    moonbitlang$core$array$$Array$set$31$(arr, b_pos, temp);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$383(_env, a_idx, b_idx, c_idx) {
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$382(_env, a_idx, b_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$382(_env, b_idx, c_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$382(_env, a_idx, b_idx);
}
function moonbitlang$core$array$$Array$choose_pivot_by$31$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const len = actual_end - actual_start | 0;
  const swaps = { val: 0 };
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: actual_start, _1: arr, _2: cmp, _3: swaps };
    if (len > 50) {
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$383(_env, a - 1 | 0, a, a + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$383(_env, b - 1 | 0, b, b + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$383(_env, c - 1 | 0, c, c + 1 | 0);
    }
    moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$383(_env, a, b, c);
  }
  if (swaps.val === 12) {
    const mid_len = len / 2 | 0;
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < mid_len) {
        const j = (len - i | 0) - 1 | 0;
        const i_pos = actual_start + i | 0;
        const j_pos = actual_start + j | 0;
        const temp = moonbitlang$core$array$$Array$at$31$(arr, i_pos);
        moonbitlang$core$array$$Array$set$31$(arr, i_pos, moonbitlang$core$array$$Array$at$31$(arr, j_pos));
        moonbitlang$core$array$$Array$set$31$(arr, j_pos, temp);
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return { _0: ((actual_start + len | 0) - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: actual_start + b | 0, _1: swaps.val === 0 };
  }
}
function moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$417(_env, a_idx, b_idx) {
  const swaps = _env._3;
  const cmp = _env._2;
  const arr = _env._1;
  const actual_start = _env._0;
  const a_pos = actual_start + a_idx | 0;
  const b_pos = actual_start + b_idx | 0;
  if (cmp(moonbitlang$core$array$$Array$at$32$(arr, a_pos), moonbitlang$core$array$$Array$at$32$(arr, b_pos)) > 0) {
    const temp = moonbitlang$core$array$$Array$at$32$(arr, a_pos);
    moonbitlang$core$array$$Array$set$32$(arr, a_pos, moonbitlang$core$array$$Array$at$32$(arr, b_pos));
    moonbitlang$core$array$$Array$set$32$(arr, b_pos, temp);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$418(_env, a_idx, b_idx, c_idx) {
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$417(_env, a_idx, b_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$417(_env, b_idx, c_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$417(_env, a_idx, b_idx);
}
function moonbitlang$core$array$$Array$choose_pivot_by$32$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const len = actual_end - actual_start | 0;
  const swaps = { val: 0 };
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: actual_start, _1: arr, _2: cmp, _3: swaps };
    if (len > 50) {
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$418(_env, a - 1 | 0, a, a + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$418(_env, b - 1 | 0, b, b + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$418(_env, c - 1 | 0, c, c + 1 | 0);
    }
    moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$418(_env, a, b, c);
  }
  if (swaps.val === 12) {
    const mid_len = len / 2 | 0;
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < mid_len) {
        const j = (len - i | 0) - 1 | 0;
        const i_pos = actual_start + i | 0;
        const j_pos = actual_start + j | 0;
        const temp = moonbitlang$core$array$$Array$at$32$(arr, i_pos);
        moonbitlang$core$array$$Array$set$32$(arr, i_pos, moonbitlang$core$array$$Array$at$32$(arr, j_pos));
        moonbitlang$core$array$$Array$set$32$(arr, j_pos, temp);
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return { _0: ((actual_start + len | 0) - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: actual_start + b | 0, _1: swaps.val === 0 };
  }
}
function moonbitlang$core$array$$Array$sift_down_by$31$(arr, start, end, index, cmp) {
  let current = index;
  const len = end - start | 0;
  let child = (Math.imul(current, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      const child_pos = start + child | 0;
      const current_pos = start + current | 0;
      if ((child + 1 | 0) < len && cmp(moonbitlang$core$array$$Array$at$31$(arr, child_pos), moonbitlang$core$array$$Array$at$31$(arr, child_pos + 1 | 0)) < 0) {
        child = child + 1 | 0;
      }
      const new_child_pos = start + child | 0;
      if (cmp(moonbitlang$core$array$$Array$at$31$(arr, current_pos), moonbitlang$core$array$$Array$at$31$(arr, new_child_pos)) >= 0) {
        return undefined;
      }
      const temp = moonbitlang$core$array$$Array$at$31$(arr, current_pos);
      moonbitlang$core$array$$Array$set$31$(arr, current_pos, moonbitlang$core$array$$Array$at$31$(arr, new_child_pos));
      moonbitlang$core$array$$Array$set$31$(arr, new_child_pos, temp);
      current = child;
      child = (Math.imul(current, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$sift_down_by$32$(arr, start, end, index, cmp) {
  let current = index;
  const len = end - start | 0;
  let child = (Math.imul(current, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      const child_pos = start + child | 0;
      const current_pos = start + current | 0;
      if ((child + 1 | 0) < len && cmp(moonbitlang$core$array$$Array$at$32$(arr, child_pos), moonbitlang$core$array$$Array$at$32$(arr, child_pos + 1 | 0)) < 0) {
        child = child + 1 | 0;
      }
      const new_child_pos = start + child | 0;
      if (cmp(moonbitlang$core$array$$Array$at$32$(arr, current_pos), moonbitlang$core$array$$Array$at$32$(arr, new_child_pos)) >= 0) {
        return undefined;
      }
      const temp = moonbitlang$core$array$$Array$at$32$(arr, current_pos);
      moonbitlang$core$array$$Array$set$32$(arr, current_pos, moonbitlang$core$array$$Array$at$32$(arr, new_child_pos));
      moonbitlang$core$array$$Array$set$32$(arr, new_child_pos, temp);
      current = child;
      child = (Math.imul(current, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$heap_sort_by$31$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const len = actual_end - actual_start | 0;
  let _tmp = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp;
    if (i >= 0) {
      moonbitlang$core$array$$Array$sift_down_by$31$(arr, actual_start, actual_end, i, cmp);
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
      const last = actual_start + i | 0;
      const temp = moonbitlang$core$array$$Array$at$31$(arr, actual_start);
      moonbitlang$core$array$$Array$set$31$(arr, actual_start, moonbitlang$core$array$$Array$at$31$(arr, last));
      moonbitlang$core$array$$Array$set$31$(arr, last, temp);
      moonbitlang$core$array$$Array$sift_down_by$31$(arr, actual_start, actual_start + i | 0, 0, cmp);
      _tmp$2 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$heap_sort_by$32$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const len = actual_end - actual_start | 0;
  let _tmp = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp;
    if (i >= 0) {
      moonbitlang$core$array$$Array$sift_down_by$32$(arr, actual_start, actual_end, i, cmp);
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
      const last = actual_start + i | 0;
      const temp = moonbitlang$core$array$$Array$at$32$(arr, actual_start);
      moonbitlang$core$array$$Array$set$32$(arr, actual_start, moonbitlang$core$array$$Array$at$32$(arr, last));
      moonbitlang$core$array$$Array$set$32$(arr, last, temp);
      moonbitlang$core$array$$Array$sift_down_by$32$(arr, actual_start, actual_start + i | 0, 0, cmp);
      _tmp$2 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$partition_by$31$(arr, start, end, cmp, pivot_index) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const last_index = actual_end - 1 | 0;
  const temp = moonbitlang$core$array$$Array$at$31$(arr, pivot_index);
  moonbitlang$core$array$$Array$set$31$(arr, pivot_index, moonbitlang$core$array$$Array$at$31$(arr, last_index));
  moonbitlang$core$array$$Array$set$31$(arr, last_index, temp);
  const pivot = moonbitlang$core$array$$Array$at$31$(arr, last_index);
  let i = actual_start;
  let partitioned = true;
  let _tmp = actual_start;
  while (true) {
    const j = _tmp;
    if (j < last_index) {
      if (cmp(moonbitlang$core$array$$Array$at$31$(arr, j), pivot) < 0) {
        if (i !== j) {
          const temp$2 = moonbitlang$core$array$$Array$at$31$(arr, i);
          moonbitlang$core$array$$Array$set$31$(arr, i, moonbitlang$core$array$$Array$at$31$(arr, j));
          moonbitlang$core$array$$Array$set$31$(arr, j, temp$2);
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
  const temp$2 = moonbitlang$core$array$$Array$at$31$(arr, i);
  moonbitlang$core$array$$Array$set$31$(arr, i, moonbitlang$core$array$$Array$at$31$(arr, last_index));
  moonbitlang$core$array$$Array$set$31$(arr, last_index, temp$2);
  return { _0: i, _1: partitioned };
}
function moonbitlang$core$array$$Array$partition_by$32$(arr, start, end, cmp, pivot_index) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const last_index = actual_end - 1 | 0;
  const temp = moonbitlang$core$array$$Array$at$32$(arr, pivot_index);
  moonbitlang$core$array$$Array$set$32$(arr, pivot_index, moonbitlang$core$array$$Array$at$32$(arr, last_index));
  moonbitlang$core$array$$Array$set$32$(arr, last_index, temp);
  const pivot = moonbitlang$core$array$$Array$at$32$(arr, last_index);
  let i = actual_start;
  let partitioned = true;
  let _tmp = actual_start;
  while (true) {
    const j = _tmp;
    if (j < last_index) {
      if (cmp(moonbitlang$core$array$$Array$at$32$(arr, j), pivot) < 0) {
        if (i !== j) {
          const temp$2 = moonbitlang$core$array$$Array$at$32$(arr, i);
          moonbitlang$core$array$$Array$set$32$(arr, i, moonbitlang$core$array$$Array$at$32$(arr, j));
          moonbitlang$core$array$$Array$set$32$(arr, j, temp$2);
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
  const temp$2 = moonbitlang$core$array$$Array$at$32$(arr, i);
  moonbitlang$core$array$$Array$set$32$(arr, i, moonbitlang$core$array$$Array$at$32$(arr, last_index));
  moonbitlang$core$array$$Array$set$32$(arr, last_index, temp$2);
  return { _0: i, _1: partitioned };
}
function moonbitlang$core$array$$Array$try_bubble_sort_by$31$(arr, start, end, cmp) {
  let tries = 0;
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return true;
  }
  const _start1251 = actual_start + 1 | 0;
  let _tmp = _start1251;
  while (true) {
    const i = _tmp;
    if (i < actual_end) {
      let sorted = true;
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$31$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$31$(arr, j)) > 0) {
          sorted = false;
          const temp = moonbitlang$core$array$$Array$at$31$(arr, j);
          moonbitlang$core$array$$Array$set$31$(arr, j, moonbitlang$core$array$$Array$at$31$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$31$(arr, j - 1 | 0, temp);
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
function moonbitlang$core$array$$Array$try_bubble_sort_by$32$(arr, start, end, cmp) {
  let tries = 0;
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return true;
  }
  const _start1251 = actual_start + 1 | 0;
  let _tmp = _start1251;
  while (true) {
    const i = _tmp;
    if (i < actual_end) {
      let sorted = true;
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$32$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$32$(arr, j)) > 0) {
          sorted = false;
          const temp = moonbitlang$core$array$$Array$at$32$(arr, j);
          moonbitlang$core$array$$Array$set$32$(arr, j, moonbitlang$core$array$$Array$at$32$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$32$(arr, j - 1 | 0, temp);
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
function moonbitlang$core$array$$Array$quick_sort_by$31$(arr, start, end, cmp, pred, limit) {
  let limit$2 = limit;
  let current_start = start;
  let current_end = end;
  let pred$2 = pred;
  let was_partitioned = true;
  let balanced = true;
  while (true) {
    const len = current_end - current_start | 0;
    if (len <= 16) {
      if (len >= 2) {
        moonbitlang$core$array$$Array$bubble_sort_by$31$(arr, current_start, current_end, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      moonbitlang$core$array$$Array$heap_sort_by$31$(arr, current_start, current_end, cmp);
      return undefined;
    }
    const _bind$8 = moonbitlang$core$array$$Array$choose_pivot_by$31$(arr, current_start, current_end, cmp);
    const _pivot_index = _bind$8._0;
    const _likely_sorted = _bind$8._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (moonbitlang$core$array$$Array$try_bubble_sort_by$31$(arr, current_start, current_end, cmp)) {
        return undefined;
      }
    }
    const _bind$9 = moonbitlang$core$array$$Array$partition_by$31$(arr, current_start, current_end, cmp, _pivot_index);
    const _actual_pivot_pos = _bind$9._0;
    const _partitioned = _bind$9._1;
    was_partitioned = _partitioned;
    const pivot_pos = _actual_pivot_pos - current_start | 0;
    const diff = len - pivot_pos | 0;
    balanced = (pivot_pos < diff ? pivot_pos : diff) >= (len / 8 | 0);
    if (!balanced) {
      limit$2 = limit$2 - 1 | 0;
    }
    const _bind$10 = pred$2;
    if (_bind$10 === undefined) {
    } else {
      const _Some = _bind$10;
      const _pred = _Some;
      if (cmp(_pred, moonbitlang$core$array$$Array$at$31$(arr, _actual_pivot_pos)) === 0) {
        let i = _actual_pivot_pos;
        while (true) {
          if (i < current_end && cmp(_pred, moonbitlang$core$array$$Array$at$31$(arr, i)) === 0) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        current_start = i;
        continue;
      }
    }
    const left_start = current_start;
    const right_start = _actual_pivot_pos + 1 | 0;
    const right_end = current_end;
    if ((_actual_pivot_pos - left_start | 0) < (right_end - right_start | 0)) {
      moonbitlang$core$array$$Array$quick_sort_by$31$(arr, left_start, _actual_pivot_pos, cmp, pred$2, limit$2);
      pred$2 = moonbitlang$core$array$$Array$at$31$(arr, _actual_pivot_pos);
      current_start = right_start;
      current_end = right_end;
    } else {
      moonbitlang$core$array$$Array$quick_sort_by$31$(arr, right_start, right_end, cmp, moonbitlang$core$array$$Array$at$31$(arr, _actual_pivot_pos), limit$2);
      current_start = left_start;
      current_end = _actual_pivot_pos;
    }
    continue;
  }
}
function moonbitlang$core$array$$Array$quick_sort_by$32$(arr, start, end, cmp, pred, limit) {
  let limit$2 = limit;
  let current_start = start;
  let current_end = end;
  let pred$2 = pred;
  let was_partitioned = true;
  let balanced = true;
  while (true) {
    const len = current_end - current_start | 0;
    if (len <= 16) {
      if (len >= 2) {
        moonbitlang$core$array$$Array$bubble_sort_by$32$(arr, current_start, current_end, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      moonbitlang$core$array$$Array$heap_sort_by$32$(arr, current_start, current_end, cmp);
      return undefined;
    }
    const _bind$8 = moonbitlang$core$array$$Array$choose_pivot_by$32$(arr, current_start, current_end, cmp);
    const _pivot_index = _bind$8._0;
    const _likely_sorted = _bind$8._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (moonbitlang$core$array$$Array$try_bubble_sort_by$32$(arr, current_start, current_end, cmp)) {
        return undefined;
      }
    }
    const _bind$9 = moonbitlang$core$array$$Array$partition_by$32$(arr, current_start, current_end, cmp, _pivot_index);
    const _actual_pivot_pos = _bind$9._0;
    const _partitioned = _bind$9._1;
    was_partitioned = _partitioned;
    const pivot_pos = _actual_pivot_pos - current_start | 0;
    const diff = len - pivot_pos | 0;
    balanced = (pivot_pos < diff ? pivot_pos : diff) >= (len / 8 | 0);
    if (!balanced) {
      limit$2 = limit$2 - 1 | 0;
    }
    const _bind$10 = pred$2;
    if (_bind$10 === undefined) {
    } else {
      const _Some = _bind$10;
      const _pred = _Some;
      if (cmp(_pred, moonbitlang$core$array$$Array$at$32$(arr, _actual_pivot_pos)) === 0) {
        let i = _actual_pivot_pos;
        while (true) {
          if (i < current_end && cmp(_pred, moonbitlang$core$array$$Array$at$32$(arr, i)) === 0) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        current_start = i;
        continue;
      }
    }
    const left_start = current_start;
    const right_start = _actual_pivot_pos + 1 | 0;
    const right_end = current_end;
    if ((_actual_pivot_pos - left_start | 0) < (right_end - right_start | 0)) {
      moonbitlang$core$array$$Array$quick_sort_by$32$(arr, left_start, _actual_pivot_pos, cmp, pred$2, limit$2);
      pred$2 = moonbitlang$core$array$$Array$at$32$(arr, _actual_pivot_pos);
      current_start = right_start;
      current_end = right_end;
    } else {
      moonbitlang$core$array$$Array$quick_sort_by$32$(arr, right_start, right_end, cmp, moonbitlang$core$array$$Array$at$32$(arr, _actual_pivot_pos), limit$2);
      current_start = left_start;
      current_end = _actual_pivot_pos;
    }
    continue;
  }
}
function moonbitlang$core$array$$Array$sort_by_key$33$(self, map) {
  moonbitlang$core$array$$Array$quick_sort_by$31$(self, 0, self.length, (a, b) => $compare_int(map(a), map(b)), undefined, moonbitlang$core$array$$get_limit(self.length));
}
function moonbitlang$core$array$$Array$sort_by$32$(self, cmp) {
  moonbitlang$core$array$$Array$quick_sort_by$32$(self, 0, self.length, cmp, undefined, moonbitlang$core$array$$get_limit(self.length));
}
function moonbitlang$core$array$$choose_pivot$46$sort_2$47$630(_env, a_idx, b_idx) {
  const arr = _env._2;
  const swaps = _env._1;
  const actual_start = _env._0;
  const a_pos = actual_start + a_idx | 0;
  const b_pos = actual_start + b_idx | 0;
  if (moonbitlang$core$array$$Array$at$20$(arr, a_pos) > moonbitlang$core$array$$Array$at$20$(arr, b_pos)) {
    const temp = moonbitlang$core$array$$Array$at$20$(arr, a_pos);
    moonbitlang$core$array$$Array$set$20$(arr, a_pos, moonbitlang$core$array$$Array$at$20$(arr, b_pos));
    moonbitlang$core$array$$Array$set$20$(arr, b_pos, temp);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function moonbitlang$core$array$$choose_pivot$46$sort_3$47$631(_env, a_idx, b_idx, c_idx) {
  moonbitlang$core$array$$choose_pivot$46$sort_2$47$630(_env, a_idx, b_idx);
  moonbitlang$core$array$$choose_pivot$46$sort_2$47$630(_env, b_idx, c_idx);
  moonbitlang$core$array$$choose_pivot$46$sort_2$47$630(_env, a_idx, b_idx);
}
function moonbitlang$core$array$$Array$choose_pivot$20$(arr, start, end) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const len = actual_end - actual_start | 0;
  const swaps = { val: 0 };
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: actual_start, _1: swaps, _2: arr };
    if (len > 50) {
      moonbitlang$core$array$$choose_pivot$46$sort_3$47$631(_env, a - 1 | 0, a, a + 1 | 0);
      moonbitlang$core$array$$choose_pivot$46$sort_3$47$631(_env, b - 1 | 0, b, b + 1 | 0);
      moonbitlang$core$array$$choose_pivot$46$sort_3$47$631(_env, c - 1 | 0, c, c + 1 | 0);
    }
    moonbitlang$core$array$$choose_pivot$46$sort_3$47$631(_env, a, b, c);
  }
  if (swaps.val === 12) {
    const mid_len = len / 2 | 0;
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < mid_len) {
        const j = (len - i | 0) - 1 | 0;
        const i_pos = actual_start + i | 0;
        const j_pos = actual_start + j | 0;
        const temp = moonbitlang$core$array$$Array$at$20$(arr, i_pos);
        moonbitlang$core$array$$Array$set$20$(arr, i_pos, moonbitlang$core$array$$Array$at$20$(arr, j_pos));
        moonbitlang$core$array$$Array$set$20$(arr, j_pos, temp);
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return { _0: ((actual_start + len | 0) - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: actual_start + b | 0, _1: swaps.val === 0 };
  }
}
function moonbitlang$core$array$$Array$sift_down$20$(arr, start, end, index) {
  let current = index;
  const len = end - start | 0;
  let child = (Math.imul(current, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      const child_pos = start + child | 0;
      const current_pos = start + current | 0;
      if ((child + 1 | 0) < len && moonbitlang$core$array$$Array$at$20$(arr, child_pos) < moonbitlang$core$array$$Array$at$20$(arr, child_pos + 1 | 0)) {
        child = child + 1 | 0;
      }
      const new_child_pos = start + child | 0;
      if (moonbitlang$core$array$$Array$at$20$(arr, current_pos) >= moonbitlang$core$array$$Array$at$20$(arr, new_child_pos)) {
        return undefined;
      }
      const temp = moonbitlang$core$array$$Array$at$20$(arr, current_pos);
      moonbitlang$core$array$$Array$set$20$(arr, current_pos, moonbitlang$core$array$$Array$at$20$(arr, new_child_pos));
      moonbitlang$core$array$$Array$set$20$(arr, new_child_pos, temp);
      current = child;
      child = (Math.imul(current, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$heap_sort$20$(arr, start, end) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const len = actual_end - actual_start | 0;
  let _tmp = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp;
    if (i >= 0) {
      moonbitlang$core$array$$Array$sift_down$20$(arr, actual_start, actual_end, i);
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
      const last = actual_start + i | 0;
      const temp = moonbitlang$core$array$$Array$at$20$(arr, actual_start);
      moonbitlang$core$array$$Array$set$20$(arr, actual_start, moonbitlang$core$array$$Array$at$20$(arr, last));
      moonbitlang$core$array$$Array$set$20$(arr, last, temp);
      moonbitlang$core$array$$Array$sift_down$20$(arr, actual_start, actual_start + i | 0, 0);
      _tmp$2 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$insertion_sort$20$(arr, start, end) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const _start1087 = actual_start + 1 | 0;
  let _tmp = _start1087;
  while (true) {
    const i = _tmp;
    if (i < actual_end) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > actual_start && moonbitlang$core$array$$Array$at$20$(arr, j - 1 | 0) > moonbitlang$core$array$$Array$at$20$(arr, j)) {
          const temp = moonbitlang$core$array$$Array$at$20$(arr, j);
          moonbitlang$core$array$$Array$set$20$(arr, j, moonbitlang$core$array$$Array$at$20$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$20$(arr, j - 1 | 0, temp);
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
function moonbitlang$core$array$$Array$partition$20$(arr, start, end, pivot_index) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const last_index = actual_end - 1 | 0;
  const temp = moonbitlang$core$array$$Array$at$20$(arr, pivot_index);
  moonbitlang$core$array$$Array$set$20$(arr, pivot_index, moonbitlang$core$array$$Array$at$20$(arr, last_index));
  moonbitlang$core$array$$Array$set$20$(arr, last_index, temp);
  const pivot = moonbitlang$core$array$$Array$at$20$(arr, last_index);
  let i = actual_start;
  let partitioned = true;
  let _tmp = actual_start;
  while (true) {
    const j = _tmp;
    if (j < last_index) {
      if (moonbitlang$core$array$$Array$at$20$(arr, j) < pivot) {
        if (i !== j) {
          const temp$2 = moonbitlang$core$array$$Array$at$20$(arr, i);
          moonbitlang$core$array$$Array$set$20$(arr, i, moonbitlang$core$array$$Array$at$20$(arr, j));
          moonbitlang$core$array$$Array$set$20$(arr, j, temp$2);
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
  const temp$2 = moonbitlang$core$array$$Array$at$20$(arr, i);
  moonbitlang$core$array$$Array$set$20$(arr, i, moonbitlang$core$array$$Array$at$20$(arr, last_index));
  moonbitlang$core$array$$Array$set$20$(arr, last_index, temp$2);
  return { _0: i, _1: partitioned };
}
function moonbitlang$core$array$$Array$try_bubble_sort$20$(arr, start, end) {
  let tries = 0;
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return true;
  }
  const _start1101 = actual_start + 1 | 0;
  let _tmp = _start1101;
  while (true) {
    const i = _tmp;
    if (i < actual_end) {
      let sorted = true;
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > actual_start && moonbitlang$core$array$$Array$at$20$(arr, j - 1 | 0) > moonbitlang$core$array$$Array$at$20$(arr, j)) {
          sorted = false;
          const temp = moonbitlang$core$array$$Array$at$20$(arr, j);
          moonbitlang$core$array$$Array$set$20$(arr, j, moonbitlang$core$array$$Array$at$20$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$20$(arr, j - 1 | 0, temp);
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
function moonbitlang$core$array$$Array$quick_sort$20$(arr, start, end, pred, limit) {
  let limit$2 = limit;
  let current_start = start;
  let current_end = end;
  let pred$2 = pred;
  let was_partitioned = true;
  let balanced = true;
  while (true) {
    const len = current_end - current_start | 0;
    if (len <= 16) {
      if (len >= 2) {
        moonbitlang$core$array$$Array$insertion_sort$20$(arr, current_start, current_end);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      moonbitlang$core$array$$Array$heap_sort$20$(arr, current_start, current_end);
      return undefined;
    }
    const _bind$8 = moonbitlang$core$array$$Array$choose_pivot$20$(arr, current_start, current_end);
    const _pivot_index = _bind$8._0;
    const _likely_sorted = _bind$8._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (moonbitlang$core$array$$Array$try_bubble_sort$20$(arr, current_start, current_end)) {
        return undefined;
      }
    }
    const _bind$9 = moonbitlang$core$array$$Array$partition$20$(arr, current_start, current_end, _pivot_index);
    const _actual_pivot_pos = _bind$9._0;
    const _partitioned = _bind$9._1;
    was_partitioned = _partitioned;
    const pivot_pos = _actual_pivot_pos - current_start | 0;
    const diff = len - pivot_pos | 0;
    balanced = (pivot_pos < diff ? pivot_pos : diff) >= (len / 8 | 0);
    if (!balanced) {
      limit$2 = limit$2 - 1 | 0;
    }
    const _bind$10 = pred$2;
    if (_bind$10 === undefined) {
    } else {
      const _Some = _bind$10;
      const _pred = _Some;
      if (_pred === moonbitlang$core$array$$Array$at$20$(arr, _actual_pivot_pos)) {
        let i = _actual_pivot_pos;
        while (true) {
          if (i < current_end && _pred === moonbitlang$core$array$$Array$at$20$(arr, i)) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        current_start = i;
        continue;
      }
    }
    const left_start = current_start;
    const right_start = _actual_pivot_pos + 1 | 0;
    const right_end = current_end;
    if ((_actual_pivot_pos - left_start | 0) < (right_end - right_start | 0)) {
      moonbitlang$core$array$$Array$quick_sort$20$(arr, left_start, _actual_pivot_pos, pred$2, limit$2);
      pred$2 = moonbitlang$core$array$$Array$at$20$(arr, _actual_pivot_pos);
      current_start = right_start;
      current_end = right_end;
    } else {
      moonbitlang$core$array$$Array$quick_sort$20$(arr, right_start, right_end, moonbitlang$core$array$$Array$at$20$(arr, _actual_pivot_pos), limit$2);
      current_start = left_start;
      current_end = _actual_pivot_pos;
    }
    continue;
  }
}
function moonbitlang$core$array$$Array$sort$20$(self) {
  const len = self.length;
  moonbitlang$core$array$$Array$quick_sort$20$(self, 0, len, undefined, moonbitlang$core$array$$get_limit(len));
}
function moonbitlang$core$array$$FixedArray$makei$26$(length, value) {
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
function moonbitlang$core$option$$Option$map_or$34$(self, default_, f) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _x = _Some;
    return f(_x);
  }
}
function moonbitlang$core$option$$Option$map_or$35$(self, default_, f) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _x = _Some;
    return f(_x);
  }
}
function moonbitlang$core$option$$Option$unwrap_or_default$36$(self) {
  if (self === undefined) {
    return moonbitlang$core$builtin$$Default$default$36$();
  } else {
    const _Some = self;
    return _Some;
  }
}
function moonbitlang$core$builtin$$op_lt$25$(self_, other) {
  return moonbitlang$core$builtin$$Compare$compare$25$(self_, other) < 0;
}
function moonbitlang$core$array$$FixedArray$unsafe_blit$27$(dst, dst_offset, src, src_offset, len) {
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
function moonbitlang$core$builtin$$Logger$write_char$37$(self, ch) {
  const _bind$8 = self;
  _bind$8.val = `${_bind$8.val}${String.fromCodePoint(ch)}`;
}
function moonbitlang$core$builtin$$op_notequal$38$(x, y) {
  return !moonbitlang$core$builtin$$Eq$equal$38$(x, y);
}
function moonbitlang$core$builtin$$op_notequal$1$(x, y) {
  return !(x === y);
}
function moonbitlang$core$array$$Array$at$31$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$39$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$40$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$32$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$20$(self, index) {
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
function moonbitlang$core$builtin$$Logger$write_string$37$(self, str) {
  const _bind$8 = self;
  _bind$8.val = `${_bind$8.val}${str}`;
}
function moonbitlang$core$builtin$$Hasher$combine$1$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$1$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$4$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$4$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$42$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$42$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$43$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$43$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$44$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$44$(value, self);
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
function moonbitlang$core$builtin$$Hash$hash$28$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$1$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$29$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$4$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$45$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$42$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$46$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$43$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$47$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$44$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$output$46$inner$46$write_digits$124$1897(_env, num) {
  const logger = _env._1;
  const radix = _env._0;
  const num2 = num / radix | 0;
  if (num2 !== 0) {
    moonbitlang$core$builtin$$output$46$inner$46$write_digits$124$1897(_env, num2);
  }
  const _p = num % radix | 0;
  const _tmp = _p < 0 ? 0 - _p | 0 : _p;
  $bound_check("0123456789abcdefghijklmnopqrstuvwxyz", _tmp);
  logger.method_2(logger.self, "0123456789abcdefghijklmnopqrstuvwxyz".charCodeAt(_tmp));
}
function moonbitlang$core$int$$Int$output$46$inner(self, logger, radix) {
  if (self < 0) {
    logger.method_2(logger.self, 45);
  }
  const _env = { _0: radix, _1: logger };
  moonbitlang$core$builtin$$output$46$inner$46$write_digits$124$1897(_env, self < 0 ? 0 - self | 0 : self);
}
function moonbitlang$core$int$$Int$output_size_hint$46$inner(radix) {
  return radix >= 2 && radix < 7 ? 36 : radix >= 8 && radix < 15 ? 18 : radix >= 16 && radix <= 36 ? 10 : moonbitlang$core$abort$$abort$20$("radix must be between 2 and 36");
}
function moonbitlang$core$int$$Int$to_string$46$inner(self, radix) {
  const buf = moonbitlang$core$builtin$$StringBuilder$new$46$inner(moonbitlang$core$int$$Int$output_size_hint$46$inner(radix));
  moonbitlang$core$int$$Int$output$46$inner(self, { self: buf, method_0: moonbitlang$core$builtin$$Logger$write_string$37$, method_1: moonbitlang$core$builtin$$Logger$write_substring$37$, method_2: moonbitlang$core$builtin$$Logger$write_char$37$ }, radix);
  return buf.val;
}
function moonbitlang$core$builtin$$Show$to_string$20$(self) {
  return moonbitlang$core$int$$Int$to_string$46$inner(self, 10);
}
function moonbitlang$core$string$$String$substring$46$inner(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    end$2 = _Some;
  }
  return start >= 0 && (start <= end$2 && end$2 <= len) ? self.substring(start, end$2) : $panic();
}
function moonbitlang$core$builtin$$Logger$write_substring$37$(self, str, start, len) {
  const _bind$8 = self;
  _bind$8.val = `${_bind$8.val}${moonbitlang$core$string$$String$substring$46$inner(str, start, start + len | 0)}`;
}
function moonbitlang$core$option$$Option$unwrap$48$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$49$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$50$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$51$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$52$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
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
function moonbitlang$core$builtin$$Map$new$46$inner$0$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$2$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$3$(capacity) {
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
function moonbitlang$core$builtin$$Map$new$46$inner$11$(capacity) {
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
function moonbitlang$core$builtin$$Map$new$46$inner$8$(capacity) {
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
function moonbitlang$core$builtin$$Map$new$46$inner$17$(capacity) {
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
function moonbitlang$core$builtin$$Map$new$46$inner$15$(capacity) {
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
function moonbitlang$core$builtin$$Map$new$46$inner$7$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$53$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$18$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$54$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
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
function moonbitlang$core$builtin$$Map$add_entry_to_tail$3$(self, idx, entry) {
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
function moonbitlang$core$builtin$$Map$add_entry_to_tail$11$(self, idx, entry) {
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
function moonbitlang$core$builtin$$Map$add_entry_to_tail$15$(self, idx, entry) {
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
function moonbitlang$core$builtin$$Map$add_entry_to_tail$18$(self, idx, entry) {
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
function moonbitlang$core$builtin$$Map$add_entry_to_tail$53$(self, idx, entry) {
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
function moonbitlang$core$builtin$$Map$add_entry_to_tail$54$(self, idx, entry) {
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
function moonbitlang$core$builtin$$Map$set_entry$3$(self, entry, new_idx) {
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
function moonbitlang$core$builtin$$Map$set_entry$11$(self, entry, new_idx) {
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
function moonbitlang$core$builtin$$Map$set_entry$15$(self, entry, new_idx) {
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
function moonbitlang$core$builtin$$Map$set_entry$18$(self, entry, new_idx) {
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
function moonbitlang$core$builtin$$Map$set_entry$53$(self, entry, new_idx) {
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
function moonbitlang$core$builtin$$Map$set_entry$54$(self, entry, new_idx) {
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
function moonbitlang$core$builtin$$Map$push_away$3$(self, idx, entry) {
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
      moonbitlang$core$builtin$$Map$set_entry$3$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$3$(self, entry$2, idx$2);
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
function moonbitlang$core$builtin$$Map$push_away$11$(self, idx, entry) {
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
      moonbitlang$core$builtin$$Map$set_entry$11$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$11$(self, entry$2, idx$2);
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
function moonbitlang$core$builtin$$Map$push_away$15$(self, idx, entry) {
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
      moonbitlang$core$builtin$$Map$set_entry$15$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$15$(self, entry$2, idx$2);
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
function moonbitlang$core$builtin$$Map$push_away$18$(self, idx, entry) {
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
      moonbitlang$core$builtin$$Map$set_entry$18$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$18$(self, entry$2, idx$2);
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
function moonbitlang$core$builtin$$Map$push_away$53$(self, idx, entry) {
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
      moonbitlang$core$builtin$$Map$set_entry$53$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$53$(self, entry$2, idx$2);
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
function moonbitlang$core$builtin$$Map$push_away$54$(self, idx, entry) {
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
      moonbitlang$core$builtin$$Map$set_entry$54$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$54$(self, entry$2, idx$2);
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
function moonbitlang$core$builtin$$Map$set_with_hash$3$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$3$(self);
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
        moonbitlang$core$builtin$$Map$push_away$3$(self, idx, _curr_entry);
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
  moonbitlang$core$builtin$$Map$add_entry_to_tail$3$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$11$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$11$(self);
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
        moonbitlang$core$builtin$$Map$push_away$11$(self, idx, _curr_entry);
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
  moonbitlang$core$builtin$$Map$add_entry_to_tail$11$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$15$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$15$(self);
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
        moonbitlang$core$builtin$$Map$push_away$15$(self, idx, _curr_entry);
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
  moonbitlang$core$builtin$$Map$add_entry_to_tail$15$(self, _idx, entry);
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
function moonbitlang$core$builtin$$Map$set_with_hash$18$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$18$(self);
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
        moonbitlang$core$builtin$$Map$push_away$18$(self, idx, _curr_entry);
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
  moonbitlang$core$builtin$$Map$add_entry_to_tail$18$(self, _idx, entry);
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
function moonbitlang$core$builtin$$Map$set_with_hash$53$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$53$(self);
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
      if (_curr_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$43$(_curr_entry.key, key)) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$53$(self, idx, _curr_entry);
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
  moonbitlang$core$builtin$$Map$add_entry_to_tail$53$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$54$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$54$(self);
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
      if (_curr_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$44$(_curr_entry.key, key)) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$54$(self, idx, _curr_entry);
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
  moonbitlang$core$builtin$$Map$add_entry_to_tail$54$(self, _idx, entry);
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
function moonbitlang$core$builtin$$Map$grow$3$(self) {
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
      moonbitlang$core$builtin$$Map$set_with_hash$3$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$11$(self) {
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
      moonbitlang$core$builtin$$Map$set_with_hash$11$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$15$(self) {
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
      moonbitlang$core$builtin$$Map$set_with_hash$15$(self, _key, _value, _hash);
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
function moonbitlang$core$builtin$$Map$grow$18$(self) {
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
      moonbitlang$core$builtin$$Map$set_with_hash$18$(self, _key, _value, _hash);
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
function moonbitlang$core$builtin$$Map$grow$53$(self) {
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
      moonbitlang$core$builtin$$Map$set_with_hash$53$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$54$(self) {
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
      moonbitlang$core$builtin$$Map$set_with_hash$54$(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$set$0$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$0$(self, key, value, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$builtin$$Map$set$2$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$2$(self, key, value, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$builtin$$Map$set$3$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$3$(self, key, value, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$builtin$$Map$set$11$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$11$(self, key, value, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$builtin$$Map$set$15$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$15$(self, key, value, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$builtin$$Map$set$8$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$8$(self, key, value, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$builtin$$Map$set$9$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$9$(self, key, value, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$builtin$$Map$set$12$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$12$(self, key, value, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$builtin$$Map$set$18$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$18$(self, key, value, moonbitlang$core$builtin$$Hash$hash$45$(key));
}
function moonbitlang$core$builtin$$Map$set$7$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$7$(self, key, value, moonbitlang$core$builtin$$Hash$hash$28$(key));
}
function moonbitlang$core$builtin$$Map$set$53$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$53$(self, key, value, moonbitlang$core$builtin$$Hash$hash$46$(key));
}
function moonbitlang$core$builtin$$Map$set$54$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$54$(self, key, value, moonbitlang$core$builtin$$Hash$hash$47$(key));
}
function moonbitlang$core$builtin$$Map$get$13$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
function moonbitlang$core$builtin$$Map$get$3$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
function moonbitlang$core$builtin$$Map$get$2$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
function moonbitlang$core$builtin$$Map$get$14$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
function moonbitlang$core$builtin$$Map$get$0$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
function moonbitlang$core$builtin$$Map$get$15$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
function moonbitlang$core$builtin$$Map$get$7$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return Option$None$2$;
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
        return new Option$Some$2$(_entry.value);
      }
      if (i > _entry.psl) {
        return Option$None$2$;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$18$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$45$(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      return Option$None$3$;
    } else {
      const _Some = _bind$8;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return new Option$Some$3$(_entry.value);
      }
      if (i > _entry.psl) {
        return Option$None$3$;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$53$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$46$(key);
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
      if (_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$43$(_entry.key, key)) {
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
function moonbitlang$core$builtin$$Map$get$54$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$47$(key);
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
      if (_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$44$(_entry.key, key)) {
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
function moonbitlang$core$builtin$$Map$get_or_init$6$(self, key, default_) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
    moonbitlang$core$builtin$$Map$grow$6$(self);
    moonbitlang$core$builtin$$Map$set_with_hash$6$(self, key, _new_value, hash);
  } else {
    if (_push_away === undefined) {
    } else {
      const _Some = _push_away;
      const _entry = _Some;
      moonbitlang$core$builtin$$Map$push_away$6$(self, _idx, _entry);
    }
    const entry = { prev: self.tail, next: undefined, psl: _psl, hash: hash, key: key, value: _new_value };
    moonbitlang$core$builtin$$Map$add_entry_to_tail$6$(self, _idx, entry);
  }
  return _new_value;
}
function moonbitlang$core$builtin$$Map$contains$7$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$28$(key);
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
function moonbitlang$core$array$$FixedArray$fill$46$inner$55$(self, value, start, end) {
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
function moonbitlang$core$array$$FixedArray$fill$46$inner$30$(self, value, start, end) {
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
function moonbitlang$core$builtin$$Map$clear$12$(self) {
  moonbitlang$core$array$$FixedArray$fill$46$inner$55$(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function moonbitlang$core$builtin$$Map$iter$6$(self) {
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
function moonbitlang$core$builtin$$Map$iter$53$(self) {
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
function moonbitlang$core$builtin$$Map$iter$54$(self) {
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
function moonbitlang$core$builtin$$Map$iter2$11$(self) {
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
        const _bind$8 = yield_(_key, _value);
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
function moonbitlang$core$builtin$$Map$iter2$8$(self) {
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
        const _bind$8 = yield_(_key, _value);
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
function moonbitlang$core$builtin$$Map$iter2$3$(self) {
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
        const _bind$8 = yield_(_key, _value);
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
function moonbitlang$core$builtin$$Map$to_array$15$(self) {
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
function moonbitlang$core$array$$Array$push$31$(self, value) {
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
function moonbitlang$core$array$$Array$push$59$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$40$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$10$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$32$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$19$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$1$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$60$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$61$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$16$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$41$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$builtin$$Iter$to_array$41$(self) {
  const result = [];
  self((e) => {
    moonbitlang$core$array$$Array$push$41$(result, e);
    return 1;
  });
  return result;
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
function moonbitlang$core$builtin$$Add$add$62$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$add_hi_lo(self, other.hi, other.lo);
}
function moonbitlang$core$builtin$$Sub$sub$62$(self, other) {
  return other.lo === 0 ? { hi: self.hi - other.hi | 0, lo: self.lo } : moonbitlang$core$builtin$$MyInt64$add_hi_lo(self, ~other.hi, ~other.lo + 1 | 0);
}
function moonbitlang$core$builtin$$Mul$mul$62$(self, other) {
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
function moonbitlang$core$builtin$$MyInt64$mod_u(self, other) {
  if (!(other.hi === 0 && other.lo === 0)) {
    const exports = moonbitlang$core$builtin$$get_int64_wasm_helper();
    const _ahi = self.hi;
    const _alo = self.lo;
    const _bhi = other.hi;
    const _blo = other.lo;
    const _func = exports.rem_u;
    const lo = _func(_alo, _ahi, _blo, _bhi);
    const _func$2 = exports.get_high;
    const hi = _func$2();
    return { hi: hi, lo: lo };
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
function moonbitlang$core$builtin$$Add$add$25$(self, other) {
  return moonbitlang$core$builtin$$Add$add$62$(self, other);
}
function moonbitlang$core$builtin$$Sub$sub$25$(self, other) {
  return moonbitlang$core$builtin$$Sub$sub$62$(self, other);
}
function moonbitlang$core$builtin$$Mul$mul$25$(self, other) {
  return moonbitlang$core$builtin$$Mul$mul$62$(self, other);
}
function moonbitlang$core$builtin$$Mod$mod$25$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$mod_u(self, other);
}
function moonbitlang$core$uint64$$UInt64$to_uint(self) {
  const _p = self;
  return _p.lo;
}
function moonbitlang$core$builtin$$Compare$compare$25$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$compare_u(self, other);
}
function moonbitlang$core$builtin$$Eq$equal$25$(self, other) {
  const _p = self;
  const _p$2 = other;
  return _p.hi === _p$2.hi && _p.lo === _p$2.lo;
}
function moonbitlang$core$builtin$$BitAnd$land$25$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$land(self, other);
}
function moonbitlang$core$builtin$$BitOr$lor$25$(self, other) {
  return moonbitlang$core$builtin$$MyInt64$lor(self, other);
}
function moonbitlang$core$uint64$$UInt64$lnot(self) {
  return moonbitlang$core$builtin$$MyInt64$lnot(self);
}
function moonbitlang$core$builtin$$Shl$shl$25$(self, shift) {
  return moonbitlang$core$builtin$$MyInt64$lsl(self, shift);
}
function moonbitlang$core$builtin$$Shr$shr$25$(self, shift) {
  return moonbitlang$core$builtin$$MyInt64$lsr(self, shift);
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
function moonbitlang$core$builtin$$Hasher$combine_string(self, value) {
  const _end859 = value.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _end859) {
      moonbitlang$core$builtin$$Hasher$combine_uint(self, value.charCodeAt(i));
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$builtin$$Hash$hash_combine$42$(self, hasher) {
  moonbitlang$core$builtin$$Hasher$combine_string(hasher, self);
}
function moonbitlang$core$builtin$$Hash$hash_combine$27$(self, hasher) {
  moonbitlang$core$builtin$$Hasher$combine_uint(hasher, self);
}
function moonbitlang$core$array$$FixedArray$blit_to$46$inner$27$(self, dst, len, src_offset, dst_offset) {
  if (dst_offset >= 0 && (src_offset >= 0 && ((dst_offset + len | 0) <= dst.length && (src_offset + len | 0) <= self.length))) {
    moonbitlang$core$array$$FixedArray$unsafe_blit$27$(dst, dst_offset, self, src_offset, len);
    return;
  } else {
    moonbitlang$core$abort$$abort$21$(`bounds check failed: dst_offset = ${moonbitlang$core$builtin$$Show$to_string$20$(dst_offset)}, src_offset = ${moonbitlang$core$builtin$$Show$to_string$20$(src_offset)}, len = ${moonbitlang$core$builtin$$Show$to_string$20$(len)}, dst.length = ${moonbitlang$core$builtin$$Show$to_string$20$(dst.length)}, self.length = ${moonbitlang$core$builtin$$Show$to_string$20$(self.length)}`);
    return;
  }
}
function moonbitlang$core$double$$Double$to_int(self) {
  return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
}
function moonbitlang$core$builtin$$println$42$(input) {
  console.log(input);
}
function moonbitlang$core$array$$Array$new$46$inner$16$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$new$46$inner$19$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$new$46$inner$60$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$16$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$19$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$40$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$1$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_pop$40$(self) {
  return moonbitlang$core$builtin$$JSArray$pop(self);
}
function moonbitlang$core$array$$Array$pop$40$(self) {
  if (self.length === 0) {
    return undefined;
  } else {
    const v = moonbitlang$core$array$$Array$unsafe_pop$40$(self);
    return v;
  }
}
function moonbitlang$core$array$$Array$set$40$(self, index, value) {
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
function moonbitlang$core$array$$Array$set$31$(self, index, value) {
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
function moonbitlang$core$array$$Array$set$32$(self, index, value) {
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
function moonbitlang$core$array$$Array$set$20$(self, index, value) {
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
function moonbitlang$core$builtin$$Eq$equal$63$(self, other) {
  const self_len = self.length;
  const other_len = other.length;
  if (self_len === other_len) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < self_len) {
        if (self[i] === other[i]) {
        } else {
          return false;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return true;
      }
    }
  } else {
    return false;
  }
}
function moonbitlang$core$array$$Array$clear$16$(self) {
  moonbitlang$core$array$$Array$unsafe_truncate_to_length$16$(self, 0);
}
function moonbitlang$core$array$$Array$clear$40$(self) {
  moonbitlang$core$array$$Array$unsafe_truncate_to_length$40$(self, 0);
}
function moonbitlang$core$array$$Array$clear$1$(self) {
  moonbitlang$core$array$$Array$unsafe_truncate_to_length$1$(self, 0);
}
function moonbitlang$core$array$$Array$contains$64$(self, value) {
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
function moonbitlang$core$ref$$Ref$new$65$(x) {
  return { val: x };
}
function moonbitlang$core$ref$$Ref$new$5$(x) {
  return { val: x };
}
function moonbitlang$core$ref$$Ref$new$10$(x) {
  return { val: x };
}
function moonbitlang$core$ref$$Ref$new$20$(x) {
  return { val: x };
}
function moonbitlang$core$builtin$$Default$default$36$() {
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
function Milky2018$selene$math$$Transform$new$46$inner(a, b, c, d, tx, ty) {
  return { a: a, b: b, c: c, d: d, tx: tx, ty: ty };
}
function Milky2018$selene$math$$Transform$from_scale(sx, sy) {
  return { a: sx, b: 0, c: 0, d: sy, tx: 0, ty: 0 };
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
function Milky2018$selene$math$$Rect$intersects(a, b) {
  return Milky2018$selene$math$$Vec2D$op_get(a.position, 0) < Milky2018$selene$math$$Vec2D$op_get(b.position, 0) + Milky2018$selene$math$$Vec2D$op_get(b.size, 0) && (Milky2018$selene$math$$Vec2D$op_get(a.position, 0) + Milky2018$selene$math$$Vec2D$op_get(a.size, 0) > Milky2018$selene$math$$Vec2D$op_get(b.position, 0) && (Milky2018$selene$math$$Vec2D$op_get(a.position, 1) < Milky2018$selene$math$$Vec2D$op_get(b.position, 1) + Milky2018$selene$math$$Vec2D$op_get(b.size, 1) && Milky2018$selene$math$$Vec2D$op_get(a.position, 1) + Milky2018$selene$math$$Vec2D$op_get(a.size, 1) > Milky2018$selene$math$$Vec2D$op_get(b.position, 1)));
}
function Milky2018$selene$math$$Rect$shift(self, dir) {
  const _p = self.position;
  const _tmp = { _0: _p._0 + dir._0, _1: _p._1 + dir._1 };
  return { position: _tmp, size: self.size };
}
function moonbitlang$core$builtin$$Eq$equal$4$(_x_29, _x_30) {
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
function moonbitlang$core$builtin$$Hash$hash_combine$4$(_x_21, _x_22) {
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
      return Milky2018$selene$inputs$$from_string$46$constr$47$2328;
    }
    case "KeyB": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2329;
    }
    case "KeyC": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2330;
    }
    case "KeyD": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2331;
    }
    case "KeyE": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2332;
    }
    case "KeyF": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2333;
    }
    case "KeyG": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2334;
    }
    case "KeyH": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2335;
    }
    case "KeyI": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2336;
    }
    case "KeyJ": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2337;
    }
    case "KeyK": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2338;
    }
    case "KeyL": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2339;
    }
    case "KeyM": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2340;
    }
    case "KeyN": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2341;
    }
    case "KeyO": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2342;
    }
    case "KeyP": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2343;
    }
    case "KeyQ": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2344;
    }
    case "KeyR": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2345;
    }
    case "KeyS": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2346;
    }
    case "KeyT": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2347;
    }
    case "KeyU": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2348;
    }
    case "KeyV": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2349;
    }
    case "KeyW": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2350;
    }
    case "KeyX": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2351;
    }
    case "KeyY": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2352;
    }
    case "ArrowUp": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2353;
    }
    case "ArrowDown": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2354;
    }
    case "ArrowLeft": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2355;
    }
    case "ArrowRight": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2356;
    }
    case "Space": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2357;
    }
    case "Enter": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2358;
    }
    case "Escape": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2359;
    }
    default: {
      return undefined;
    }
  }
}
function Milky2018$selene$inputs$$advanced_key_system(_delta) {
  moonbitlang$core$set$$Set$clear$4$(Milky2018$selene$inputs$$just_pressed_keys);
  const _bind$8 = moonbitlang$core$set$$Set$iter$4$(moonbitlang$core$set$$Set$difference$4$(Milky2018$selene$inputs$$pressed_keys, Milky2018$selene$inputs$$last_pressed_keys));
  _bind$8((code) => {
    moonbitlang$core$set$$Set$add$4$(Milky2018$selene$inputs$$just_pressed_keys, code);
    return 1;
  });
  moonbitlang$core$set$$Set$clear$4$(Milky2018$selene$inputs$$just_release_keys);
  const _bind$9 = moonbitlang$core$set$$Set$iter$4$(moonbitlang$core$set$$Set$union$4$(moonbitlang$core$set$$Set$difference$4$(Milky2018$selene$inputs$$all_codes, Milky2018$selene$inputs$$pressed_keys), Milky2018$selene$inputs$$last_pressed_keys));
  _bind$9((code) => {
    moonbitlang$core$set$$Set$add$4$(Milky2018$selene$inputs$$just_release_keys, code);
    return 1;
  });
  moonbitlang$core$set$$Set$clear$4$(Milky2018$selene$inputs$$last_pressed_keys);
  const _bind$10 = moonbitlang$core$set$$Set$iter$4$(Milky2018$selene$inputs$$pressed_keys);
  _bind$10((code) => {
    moonbitlang$core$set$$Set$add$4$(Milky2018$selene$inputs$$last_pressed_keys, code);
    return 1;
  });
}
function rami3l$js$45$ffi$js$$Union3$from0$66$(value) {
  return value;
}
function rami3l$js$45$ffi$js$$Union3$from2$66$(value) {
  return value;
}
function rami3l$js$45$ffi$js$$Union5$to0$67$(self) {
  return rami3l$js$45$ffi$js$$Cast$into$51$(self);
}
function rami3l$js$45$ffi$js$$Union7$from0$68$(value) {
  return rami3l$js$45$ffi$js$$Cast$from$69$(value);
}
function rami3l$js$45$ffi$js$$Optional$undefined$5$() {
  return rami3l$js$45$ffi$js$$Value$undefined();
}
function rami3l$js$45$ffi$js$$Nullable$is_null$70$(self) {
  return rami3l$js$45$ffi$js$$Value$is_null(self);
}
function rami3l$js$45$ffi$js$$Nullable$unwrap$70$(self) {
  if (rami3l$js$45$ffi$js$$Nullable$is_null$70$(self)) {
    moonbitlang$core$abort$$abort$21$("Cannot unwrap a null value");
  }
  return self;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$48$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$4$(self) : Option$None$4$;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$49$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$5$(self) : Option$None$5$;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$50$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$6$(self) : Option$None$6$;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$51$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$7$(self) : Option$None$7$;
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_button$71$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_button(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_x$71$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_movement_x(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_y$71$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_movement_y(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_x$71$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_offset_x(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_y$71$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_offset_y(s);
}
function rami3l$js$45$ffi$js$$Cast$from$69$(value) {
  return value;
}
function Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$72$(s, type_, callback) {
  Yoorkin$rabbit$45$tea$dom$$ffi_add_event_listener(s, type_, callback);
}
function Yoorkin$rabbit$45$tea$dom$$IsEventTarget$to_html_canvas_element$73$(s) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$50$(Yoorkin$rabbit$45$tea$dom$$ffi_to_html_canvas_element(s));
}
function Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$74$(s) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$49$(Yoorkin$rabbit$45$tea$dom$$ffi_to_mouse_event(s));
}
function Yoorkin$rabbit$45$tea$dom$$IsEvent$to_keyboard_event$74$(s) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$48$(Yoorkin$rabbit$45$tea$dom$$ffi_to_keyboard_event(s));
}
function rami3l$js$45$ffi$js$$Cast$into$51$(value) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$51$(Yoorkin$rabbit$45$tea$dom$$checked_to_canvas_rendering_context_2d(value));
}
function Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text(self, text, x, y, max_width$46$opt) {
  let max_width;
  if (max_width$46$opt.$tag === 1) {
    const _Some = max_width$46$opt;
    max_width = _Some._0;
  } else {
    max_width = rami3l$js$45$ffi$js$$Optional$undefined$5$();
  }
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text$46$inner(self, text, x, y, max_width);
}
function Milky2018$selene$backend$$CanvasBackend$new() {
  const canvas = moonbitlang$core$option$$Option$unwrap$50$(Yoorkin$rabbit$45$tea$dom$$IsEventTarget$to_html_canvas_element$73$(rami3l$js$45$ffi$js$$Nullable$unwrap$70$(Yoorkin$rabbit$45$tea$dom$$Document$get_element_by_id(Yoorkin$rabbit$45$tea$dom$$document(), "canvas"))));
  const context = moonbitlang$core$option$$Option$unwrap$51$(rami3l$js$45$ffi$js$$Union5$to0$67$(Yoorkin$rabbit$45$tea$dom$$HTMLCanvasElement$get_context(canvas, "2d")));
  const _bind$8 = { _0: 0, _1: 0 };
  const _bind$9 = moonbitlang$core$ref$$Ref$new$65$(undefined);
  return { canvas: canvas, context: context, viewport_size: _bind$8, zoom: 1, time_scale: 1, mouse_movement: _bind$9 };
}
function Milky2018$selene$backend$$register_mouse_events(mouse, mouse_movement) {
  Milky2018$selene$backend$$canvas_backend.mouse_movement.val = mouse_movement;
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$72$(Milky2018$selene$backend$$window, "mousemove", (event) => {
    const mouse_event = moonbitlang$core$option$$Option$unwrap$49$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$74$(event));
    mouse.pos = { _0: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_x$71$(mouse_event) + 0, _1: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_y$71$(mouse_event) + 0 };
    mouse_movement.movement = { _0: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_x$71$(mouse_event) + 0, _1: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_y$71$(mouse_event) + 0 };
  });
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$72$(Milky2018$selene$backend$$window, "mousedown", (event) => {
    const mouse_event = moonbitlang$core$option$$Option$unwrap$49$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$74$(event));
    const _bind$8 = Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_button$71$(mouse_event);
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
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$72$(Milky2018$selene$backend$$window, "mouseup", (event) => {
    const mouse_event = moonbitlang$core$option$$Option$unwrap$49$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$74$(event));
    const _bind$8 = Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_button$71$(mouse_event);
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
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$72$(Milky2018$selene$backend$$window, "keyup", (event) => {
    const keyboard_event = moonbitlang$core$option$$Option$unwrap$48$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_keyboard_event$74$(event));
    const keycode = Milky2018$selene$inputs$$Code$from_string(Yoorkin$rabbit$45$tea$dom$$KeyboardEvent$code(keyboard_event));
    if (keycode === undefined) {
      return;
    } else {
      const _Some = keycode;
      const _c = _Some;
      moonbitlang$core$set$$Set$remove$4$(pressed_keys, _c);
      return;
    }
  });
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$72$(Milky2018$selene$backend$$window, "keydown", (event) => {
    const keyboard_event = moonbitlang$core$option$$Option$unwrap$48$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_keyboard_event$74$(event));
    const keycode = Milky2018$selene$inputs$$Code$from_string(Yoorkin$rabbit$45$tea$dom$$KeyboardEvent$code(keyboard_event));
    if (keycode === undefined) {
      return;
    } else {
      const _Some = keycode;
      const _c = _Some;
      moonbitlang$core$set$$Set$add$4$(pressed_keys, _c);
      return;
    }
  });
}
function Milky2018$selene$backend$$get_image_element(png) {
  const _bind$8 = moonbitlang$core$builtin$$Map$get$18$(Milky2018$selene$backend$$element_cache, png);
  if (_bind$8.$tag === 1) {
    const _Some = _bind$8;
    const _element = _Some._0;
    return _element;
  }
  const element = Yoorkin$rabbit$45$tea$dom$$HTMLImageElement$new();
  Yoorkin$rabbit$45$tea$dom$$HTMLImageElement$set_src(element, png);
  moonbitlang$core$builtin$$Map$set$18$(Milky2018$selene$backend$$element_cache, png, element);
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
  const pattern = Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$create_pattern(context, rami3l$js$45$ffi$js$$Union7$from0$68$(element), repeat_mode);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from2$66$(pattern));
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
function Milky2018$selene$backend$$draw_stroke_rect(x, y, width, height, color) {
  const context = Milky2018$selene$backend$$canvas_backend.context;
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_stroke_style(context, rami3l$js$45$ffi$js$$Union3$from0$66$(color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$stroke_rect(context, x, y, width, height);
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
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from0$66$(color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text(context, text, x, y, Option$None$8$);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore(context);
}
function Milky2018$selene$backend$$draw_color_rect(x, y, width, height, color) {
  const context = Milky2018$selene$backend$$canvas_backend.context;
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from0$66$(color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_rect(context, x, y, width, height);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore(context);
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
    moonbitlang$core$builtin$$println$42$("Warning: FPS is set above 60. The browser's window only support up to 60 FPS.");
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
function Milky2018$selene$system$$timer_system(delta) {
  const _p = [];
  const _p$2 = Milky2018$selene$system$$timers.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = Milky2018$selene$system$$timers[_p$3];
      if (_p$4.pausible) {
        moonbitlang$core$array$$Array$push$19$(_p, _p$4);
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
      moonbitlang$core$array$$Array$unsafe_truncate_to_length$19$(Milky2018$selene$system$$timers, _p$5);
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
        moonbitlang$core$array$$Array$push$19$(_p, _p$4);
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
      moonbitlang$core$array$$Array$unsafe_truncate_to_length$19$(Milky2018$selene$system$$timers, _p$5);
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
  moonbitlang$core$array$$Array$clear$16$(Milky2018$selene$system$$deferred_events);
}
function Milky2018$selene$system$$defer_event(event) {
  moonbitlang$core$array$$Array$push$16$(Milky2018$selene$system$$deferred_events, event);
}
function Milky2018$selene$system$$App$new() {
  return { canvas_height: 256, canvas_width: 512, zoom: 1, image_smooth: true, fps: 60, systems: [], plugins: [] };
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
  moonbitlang$core$array$$Array$push$58$(plugins, plugin);
  return { ...self, plugins: plugins };
}
function Milky2018$selene$system$$App$add_system$46$inner(self, system, schedule, system_name) {
  const _p = `unnamed_system${moonbitlang$core$builtin$$Show$to_string$20$(self.systems.length)}`;
  let system_name$2;
  if (system_name === undefined) {
    system_name$2 = _p;
  } else {
    const _p$2 = system_name;
    system_name$2 = _p$2;
  }
  const systems = self.systems;
  moonbitlang$core$array$$Array$push$57$(systems, { _0: system, _1: schedule, _2: system_name$2 });
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
        moonbitlang$core$array$$Array$push$31$(renders, { _0: system._0, _1: _pri });
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$Array$sort_by_key$33$(renders, (system) => -system._1 | 0);
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
        moonbitlang$core$array$$Array$push$56$(game_loops, system._0);
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
function moonbitlang$core$builtin$$Hash$hash_combine$1$(_x_29, _x_30) {
  moonbitlang$core$builtin$$Hash$hash_combine$27$(_x_29, _x_30);
}
function Milky2018$selene$entity$$iter_entities() {
  return moonbitlang$core$set$$Set$iter$1$(Milky2018$selene$entity$$all_entities);
}
function Milky2018$selene$entity$$Entity$is_alive(e) {
  return moonbitlang$core$set$$Set$contains$1$(Milky2018$selene$entity$$all_entities, e);
}
function Milky2018$selene$entity$$Entity$new() {
  const entity = Milky2018$selene$entity$$entity_generator.val;
  Milky2018$selene$entity$$entity_generator.val = (Milky2018$selene$entity$$entity_generator.val >>> 0) + (1 >>> 0) | 0;
  moonbitlang$core$set$$Set$add$1$(Milky2018$selene$entity$$all_entities, entity);
  return entity;
}
function Milky2018$selene$entity$$Entity$destroy(e) {
  Milky2018$selene$system$$defer_event(() => {
    moonbitlang$core$set$$Set$remove$1$(Milky2018$selene$entity$$all_entities, e);
  });
  const _bind$8 = moonbitlang$core$builtin$$Map$get$6$(Milky2018$selene$entity$$parents, e);
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
    moonbitlang$core$set$$Set$add$1$(Milky2018$selene$entity$$all_entities, e);
  });
  const _bind$8 = moonbitlang$core$builtin$$Map$get$6$(Milky2018$selene$entity$$parents, e);
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
  const p = moonbitlang$core$builtin$$Map$get_or_init$6$(Milky2018$selene$entity$$parents, parent, () => ({ children: [], is_root: !moonbitlang$core$builtin$$Map$contains$7$(Milky2018$selene$entity$$children, parent) }));
  moonbitlang$core$array$$Array$push$1$(p.children, child_entity);
  moonbitlang$core$builtin$$Map$set$7$(Milky2018$selene$entity$$children, child_entity, { parent: parent, offset: moonbitlang$core$option$$Option$unwrap_or_default$36$(offset) });
  return child_entity;
}
function Milky2018$selene$entity$$Entity$get_children(parent) {
  return moonbitlang$core$option$$Option$map_or$34$(moonbitlang$core$builtin$$Map$get$6$(Milky2018$selene$entity$$parents, parent), [], (p) => p.children);
}
function Milky2018$selene$entity$$Entity$is_child(entity) {
  return moonbitlang$core$builtin$$Map$contains$7$(Milky2018$selene$entity$$children, entity);
}
function Milky2018$selene$entity$$Entity$set_offset(child, offset) {
  const _p = moonbitlang$core$builtin$$Map$get$7$(Milky2018$selene$entity$$children, child);
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
  const _bind$8 = moonbitlang$core$builtin$$Map$iter$6$(Milky2018$selene$entity$$parents);
  return (_p) => _bind$8((_p$2) => _p$2._1.is_root ? _p(_p$2._0) : 1);
}
function Milky2018$selene$camera$$camera_system(_delta) {
  const _bind$8 = Milky2018$selene$camera$$camera.attached_entity;
  if (_bind$8 === undefined) {
    return;
  } else {
    const _Some = _bind$8;
    const _e = _Some;
    const _bind$9 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, _e);
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
  const frame = moonbitlang$core$array$$Array$at$39$(animation.frames, moonbitlang$core$double$$Double$to_int(current_frame));
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
function Milky2018$selene$sprite$$render_color_rect(color_rect, position) {
  Milky2018$selene$backend$$draw_color_rect(Milky2018$selene$math$$Vec2D$op_get(position, 0), Milky2018$selene$math$$Vec2D$op_get(position, 1), Milky2018$selene$math$$Vec2D$op_get(color_rect.size, 0), Milky2018$selene$math$$Vec2D$op_get(color_rect.size, 1), color_rect.color);
  const _bind$8 = color_rect.stroke_color;
  if (_bind$8 === undefined) {
    return;
  } else {
    const _Some = _bind$8;
    const _stroke_color = _Some;
    Milky2018$selene$backend$$draw_stroke_rect(Milky2018$selene$math$$Vec2D$op_get(position, 0), Milky2018$selene$math$$Vec2D$op_get(position, 1), Milky2018$selene$math$$Vec2D$op_get(color_rect.size, 0), Milky2018$selene$math$$Vec2D$op_get(color_rect.size, 1), _stroke_color);
    return;
  }
}
function Milky2018$selene$sprite$$render_picture(picture, pos) {
  Milky2018$selene$backend$$draw_picture(picture.tile_path, Milky2018$selene$math$$Vec2D$op_get(pos, 0), Milky2018$selene$math$$Vec2D$op_get(pos, 1), Milky2018$selene$math$$Vec2D$op_get(picture.size, 0), Milky2018$selene$math$$Vec2D$op_get(picture.size, 1), picture.transform, picture.repeat);
}
function Milky2018$selene$sprite$$render_text(text, position) {
  Milky2018$selene$backend$$draw_text(text.content, Milky2018$selene$math$$Vec2D$op_get(position, 0), Milky2018$selene$math$$Vec2D$op_get(position, 1), text.font, text.color, text.align, text.baseline);
}
function Milky2018$selene$sprite$$render_sprite_system(delta) {
  const _p = moonbitlang$core$builtin$$Map$to_array$15$(Milky2018$selene$sprite$$sprites);
  const _p$2 = [];
  const _p$3 = _p.length;
  let _tmp = 0;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$3) {
      const _p$5 = _p[_p$4];
      if (Milky2018$selene$entity$$Entity$is_alive(_p$5._0)) {
        moonbitlang$core$array$$Array$push$32$(_p$2, _p$5);
      }
      _tmp = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const sprites = _p$2;
  moonbitlang$core$array$$Array$sort_by$32$(sprites, (sprite1, sprite2) => {
    if (sprite1._1.zindex < sprite2._1.zindex) {
      return -1;
    } else {
      if (sprite1._1.zindex > sprite2._1.zindex) {
        return 1;
      } else {
        const _bind$8 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, sprite1._0);
        if (_bind$8 === undefined) {
          return 0;
        } else {
          const _Some = _bind$8;
          const _pos1 = _Some;
          const _bind$9 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, sprite2._0);
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
        const _bind$8 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, e);
        if (_bind$8 === undefined) {
          break _L;
        } else {
          const _Some = _bind$8;
          const _pos = _Some;
          const _bind$9 = moonbitlang$core$builtin$$Map$get$3$(Milky2018$selene$ui$$uis, e);
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
            default: {
              const _ColorRect = _bind$10;
              const _color_rect = _ColorRect._0;
              if (sprite$2.visible) {
                const _p$5 = sprite$2.offset;
                Milky2018$selene$sprite$$render_color_rect(_color_rect, { _0: pos._0 + _p$5._0, _1: pos._1 + _p$5._1 });
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
function Milky2018$selene$sprite$$ColorRect$new(size, color, stroke_color) {
  return { size: size, color: color, stroke_color: stroke_color };
}
function Milky2018$selene$sprite$$generate_animation() {
  const id = Milky2018$selene$sprite$$animation_generator.val;
  Milky2018$selene$sprite$$animation_generator.val = Milky2018$selene$sprite$$animation_generator.val + 1 | 0;
  return id;
}
function Milky2018$selene$sprite$$Animation$new$46$inner(frames, loop_, fps, transform) {
  const max_frame = frames.length;
  if (max_frame === 0) {
    moonbitlang$core$abort$$abort$21$("Animation must have at least one frame");
  }
  return { frames: frames, transform: transform, loop_: loop_, fps: fps, id: Milky2018$selene$sprite$$generate_animation() };
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
function Milky2018$selene$collision$$QuadTree$new(position, size, depth) {
  const _bind$8 = moonbitlang$core$set$$Set$new$46$inner$1$(8);
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
    moonbitlang$core$set$$Set$add$1$(self.entities, entity);
    return undefined;
  }
  const _p = self.children;
  if (_p.length === 0) {
    const half_size = { _0: Milky2018$selene$math$$Vec2D$op_get(self.size, 0) * 0.5, _1: Milky2018$selene$math$$Vec2D$op_get(self.size, 1) * 0.5 };
    const _self = self.children;
    moonbitlang$core$array$$Array$push$10$(_self, Milky2018$selene$collision$$QuadTree$new(self.position, half_size, self.depth + 1 | 0));
    const _p$2 = self.position;
    const _p$3 = { _0: Milky2018$selene$math$$Vec2D$op_get(half_size, 0), _1: 0 };
    moonbitlang$core$array$$Array$push$10$(_self, Milky2018$selene$collision$$QuadTree$new({ _0: _p$2._0 + _p$3._0, _1: _p$2._1 + _p$3._1 }, half_size, self.depth + 1 | 0));
    const _p$4 = self.position;
    const _p$5 = { _0: 0, _1: Milky2018$selene$math$$Vec2D$op_get(half_size, 1) };
    moonbitlang$core$array$$Array$push$10$(_self, Milky2018$selene$collision$$QuadTree$new({ _0: _p$4._0 + _p$5._0, _1: _p$4._1 + _p$5._1 }, half_size, self.depth + 1 | 0));
    const _p$6 = self.position;
    moonbitlang$core$array$$Array$push$10$(_self, Milky2018$selene$collision$$QuadTree$new({ _0: _p$6._0 + half_size._0, _1: _p$6._1 + half_size._1 }, half_size, self.depth + 1 | 0));
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
  const trees = { val: moonbitlang$core$list$$List$of$10$([Milky2018$selene$collision$$quadtree_root.val]) };
  let results = moonbitlang$core$set$$Set$new$46$inner$1$(8);
  while (true) {
    const _bind$8 = trees.val;
    if (_bind$8.$tag === 1) {
      const _More = _bind$8;
      const _hd = _More._0;
      const _rest = _More._1;
      trees.val = _rest;
      if (!Milky2018$selene$math$$Rect$intersects(_hd.bounding_box, area)) {
        continue;
      }
      const _bind$9 = _hd.children;
      if (_bind$9.length === 0) {
        results = moonbitlang$core$set$$Set$union$1$(results, _hd.entities);
      } else {
        const _p = _hd.children;
        const _p$2 = _p.length;
        let _tmp = 0;
        while (true) {
          const _p$3 = _tmp;
          if (_p$3 < _p$2) {
            const _p$4 = _p[_p$3];
            const _p$5 = trees.val;
            trees.val = new $64$moonbitlang$47$core$47$list$46$List$More$1$(_p$4, _p$5);
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
  const left_limit = { val: 0 };
  const right_limit = { val: 0 };
  const top_limit = { val: 0 };
  const bottom_limit = { val: 0 };
  const boxes = [];
  let _foreach_result = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$9$;
  const _bind$8 = moonbitlang$core$builtin$$Map$iter2$8$(Milky2018$selene$collision$$shapes);
  _bind$8((e, shape) => {
    if (Milky2018$selene$entity$$Entity$is_alive(e)) {
      const _bind$9 = moonbitlang$core$builtin$$Map$get$3$(Milky2018$selene$ui$$uis, e);
      if (_bind$9 === -1) {
        const _bind$10 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, e);
        if (_bind$10 === undefined) {
          return 1;
        } else {
          const _Some = _bind$10;
          const _position = _Some;
          const _Rect = shape;
          const _x = _Rect._0;
          const _width = _x._0;
          const _height = _x._1;
          const _offset = _Rect._1;
          const _bind$11 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
          const _bind$12 = { _0: _width, _1: _height };
          const box = { position: _bind$11, size: _bind$12 };
          moonbitlang$core$array$$Array$push$59$(boxes, { _0: e, _1: box });
          const _p = left_limit.val;
          const _p$2 = Milky2018$selene$math$$Vec2D$op_get(_bind$11, 0);
          left_limit.val = _p > _p$2 ? _p$2 : _p;
          const _p$3 = right_limit.val;
          const _p$4 = Milky2018$selene$math$$Vec2D$op_get(_bind$11, 0) + Milky2018$selene$math$$Vec2D$op_get(_bind$12, 0);
          right_limit.val = _p$3 > _p$4 ? _p$3 : _p$4;
          const _p$5 = top_limit.val;
          const _p$6 = Milky2018$selene$math$$Vec2D$op_get(_bind$11, 1);
          top_limit.val = _p$5 > _p$6 ? _p$6 : _p$5;
          const _p$7 = bottom_limit.val;
          const _p$8 = Milky2018$selene$math$$Vec2D$op_get(_bind$11, 1) + Milky2018$selene$math$$Vec2D$op_get(_bind$12, 1);
          bottom_limit.val = _p$7 > _p$8 ? _p$7 : _p$8;
        }
      } else {
        return 1;
      }
    } else {
      return 1;
    }
    return 1;
  });
  const _tmp = _foreach_result;
  switch (_tmp.$tag) {
    case 0: {
      break;
    }
    case 1: {
      const _break = _tmp;
      _break._0;
      break;
    }
    case 2: {
      const _return = _tmp;
      return _return._0;
    }
    case 3: {
      $panic();
      break;
    }
    default: {
      $panic();
    }
  }
  Milky2018$selene$collision$$quadtree_root.val = Milky2018$selene$collision$$QuadTree$new({ _0: left_limit.val, _1: top_limit.val }, { _0: right_limit.val - left_limit.val, _1: bottom_limit.val - top_limit.val }, 0);
  const _len = boxes.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      const box = boxes[_i];
      Milky2018$selene$collision$$QuadTree$insert(Milky2018$selene$collision$$quadtree_root.val, box._0, box._1);
      _tmp$2 = _i + 1 | 0;
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
  moonbitlang$core$array$$Array$push$61$(self.on_just_pressed_callbacks, callback);
}
function Milky2018$selene$collision$$pickable_click_system(_delta) {
  const zoom = Milky2018$selene$backend$$canvas_backend.zoom;
  const _bind$8 = { _0: 1, _1: 1 };
  const _p = Milky2018$selene$inputs$$mouse.pos;
  const _p$2 = { _0: 1 / zoom, _1: 1 / zoom };
  const _bind$9 = { _0: _p._0 * _p$2._0, _1: _p._1 * _p$2._1 };
  const box = { position: _bind$9, size: _bind$8 };
  let _foreach_result = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$9$;
  const _bind$10 = moonbitlang$core$builtin$$Map$iter2$3$(Milky2018$selene$ui$$uis);
  _bind$10((e, _ui) => {
    if (Milky2018$selene$entity$$Entity$is_alive(e)) {
      const _bind$11 = moonbitlang$core$builtin$$Map$get$9$(Milky2018$selene$collision$$pickables, e);
      if (_bind$11 === undefined) {
        return 1;
      } else {
        const _Some = _bind$11;
        const _pick = _Some;
        const _bind$12 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, e);
        if (_bind$12 === undefined) {
          return 1;
        } else {
          const _Some$2 = _bind$12;
          const _position = _Some$2;
          const _bind$13 = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$collision$$shapes, e);
          if (_bind$13 === undefined) {
            return 1;
          } else {
            const _Some$3 = _bind$13;
            const _shape = _Some$3;
            const _Rect = _shape;
            const _x = _Rect._0;
            const _width = _x._0;
            const _height = _x._1;
            const _offset = _Rect._1;
            const _bind$14 = { _0: _width, _1: _height };
            const _bind$15 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
            const area_box = { position: _bind$15, size: _bind$14 };
            if (!Milky2018$selene$math$$Rect$intersects(box, area_box)) {
              return 1;
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
      return 1;
    }
    return 1;
  });
  const _tmp = _foreach_result;
  switch (_tmp.$tag) {
    case 0: {
      break;
    }
    case 1: {
      const _break = _tmp;
      _break._0;
      break;
    }
    case 2: {
      const _return = _tmp;
      return _return._0;
    }
    case 3: {
      $panic();
      break;
    }
    default: {
      $panic();
    }
  }
  const entities = Milky2018$selene$collision$$quadtree_query(box);
  let _foreach_result$2 = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$9$;
  const _bind$11 = moonbitlang$core$set$$Set$iter$1$(entities);
  _bind$11((e) => {
    if (Milky2018$selene$entity$$Entity$is_alive(e)) {
      const _bind$12 = moonbitlang$core$builtin$$Map$get$9$(Milky2018$selene$collision$$pickables, e);
      if (_bind$12 === undefined) {
        return 1;
      } else {
        const _Some = _bind$12;
        const _pick = _Some;
        const _bind$13 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, e);
        if (_bind$13 === undefined) {
          return 1;
        } else {
          const _Some$2 = _bind$13;
          const _position = _Some$2;
          const _bind$14 = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$collision$$shapes, e);
          if (_bind$14 === undefined) {
            return 1;
          } else {
            const _Some$3 = _bind$14;
            const _shape = _Some$3;
            const _Rect = _shape;
            const _x = _Rect._0;
            const _width = _x._0;
            const _height = _x._1;
            const _offset = _Rect._1;
            const _bind$15 = { _0: _width, _1: _height };
            const _bind$16 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
            const area_box = { position: _bind$16, size: _bind$15 };
            if (!Milky2018$selene$math$$Rect$intersects(Milky2018$selene$math$$Rect$shift(box, Milky2018$selene$camera$$camera.position), area_box)) {
              return 1;
            }
            const _arr = [0, 1, 2];
            const _len = _arr.length;
            let _tmp$2 = 0;
            while (true) {
              const _i = _tmp$2;
              if (_i < _len) {
                const button = _arr[_i];
                if (Milky2018$selene$inputs$$is_mouse_pressed(button)) {
                  const _arr$2 = _pick.on_pressed_callbacks;
                  const _len$2 = _arr$2.length;
                  let _tmp$3 = 0;
                  while (true) {
                    const _i$2 = _tmp$3;
                    if (_i$2 < _len$2) {
                      const callback = _arr$2[_i$2];
                      callback(button);
                      _tmp$3 = _i$2 + 1 | 0;
                      continue;
                    } else {
                      break;
                    }
                  }
                }
                if (Milky2018$selene$inputs$$is_mouse_released(button)) {
                  const _arr$2 = _pick.on_released_callbacks;
                  const _len$2 = _arr$2.length;
                  let _tmp$3 = 0;
                  while (true) {
                    const _i$2 = _tmp$3;
                    if (_i$2 < _len$2) {
                      const callback = _arr$2[_i$2];
                      callback(button);
                      _tmp$3 = _i$2 + 1 | 0;
                      continue;
                    } else {
                      break;
                    }
                  }
                }
                if (Milky2018$selene$inputs$$is_mouse_just_pressed(button)) {
                  const _arr$2 = _pick.on_just_pressed_callbacks;
                  const _len$2 = _arr$2.length;
                  let _tmp$3 = 0;
                  while (true) {
                    const _i$2 = _tmp$3;
                    if (_i$2 < _len$2) {
                      const callback = _arr$2[_i$2];
                      callback(button);
                      _tmp$3 = _i$2 + 1 | 0;
                      continue;
                    } else {
                      break;
                    }
                  }
                }
                if (Milky2018$selene$inputs$$is_mouse_just_released(button)) {
                  const _arr$2 = _pick.on_just_released_callbacks;
                  const _len$2 = _arr$2.length;
                  let _tmp$3 = 0;
                  while (true) {
                    const _i$2 = _tmp$3;
                    if (_i$2 < _len$2) {
                      const callback = _arr$2[_i$2];
                      callback(button);
                      _tmp$3 = _i$2 + 1 | 0;
                      continue;
                    } else {
                      break;
                    }
                  }
                }
                _tmp$2 = _i + 1 | 0;
                continue;
              } else {
                break;
              }
            }
          }
        }
      }
    } else {
      return 1;
    }
    return 1;
  });
  const _tmp$2 = _foreach_result$2;
  switch (_tmp$2.$tag) {
    case 0: {
      return;
    }
    case 1: {
      const _break$2 = _tmp$2;
      _break$2._0;
      return;
    }
    case 2: {
      const _return$2 = _tmp$2;
      _return$2._0;
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
  const _bind$8 = moonbitlang$core$builtin$$Map$get$12$(Milky2018$selene$collision$$collision_infos, entity);
  if (_bind$8.$tag === 0) {
    moonbitlang$core$builtin$$Map$set$12$(Milky2018$selene$collision$$collision_infos, entity, moonbitlang$core$array$$Array$new$46$inner$60$(0));
  }
  moonbitlang$core$array$$Array$push$60$(moonbitlang$core$option$$Option$unwrap$52$(moonbitlang$core$builtin$$Map$get$12$(Milky2018$selene$collision$$collision_infos, entity)), { entity: target, direction: direction });
}
function Milky2018$selene$collision$$make_ray_collision(object, speed, axis) {
  const pos = { _0: Milky2018$selene$math$$Vec2D$op_get(object.position, 0), _1: Milky2018$selene$math$$Vec2D$op_get(object.position, 1) };
  const size = { _0: Milky2018$selene$math$$Vec2D$op_get(object.size, 0), _1: Milky2018$selene$math$$Vec2D$op_get(object.size, 1) };
  return speed >= 0 ? { position: pos, size: Milky2018$selene$math$$Vec2D$update(size, axis, Milky2018$selene$math$$Vec2D$op_get(size, axis) + speed) } : { position: Milky2018$selene$math$$Vec2D$update(pos, axis, Milky2018$selene$math$$Vec2D$op_get(pos, axis) + speed), size: Milky2018$selene$math$$Vec2D$update(size, axis, Milky2018$selene$math$$Vec2D$op_get(size, axis) - speed) };
}
function Milky2018$selene$collision$$CollisionMask$contains(self, layer) {
  return moonbitlang$core$array$$Array$contains$64$(self, layer);
}
function Milky2018$selene$collision$$move_axis(entity, object, velocity, axis, mask) {
  const ray_collision = Milky2018$selene$collision$$make_ray_collision(object, Milky2018$selene$math$$Vec2D$op_get(velocity, axis), axis);
  const new_pos = { val: { _0: Milky2018$selene$math$$Vec2D$op_get(object.position, 0), _1: Milky2018$selene$math$$Vec2D$op_get(object.position, 1) } };
  new_pos.val = Milky2018$selene$math$$Vec2D$update(new_pos.val, axis, Milky2018$selene$math$$Vec2D$op_get(new_pos.val, axis) + Milky2018$selene$math$$Vec2D$op_get(velocity, axis));
  const new_velocity = { val: velocity };
  const entities = Milky2018$selene$collision$$quadtree_query(ray_collision);
  const _foreach_result = { val: $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$10$ };
  const _bind$8 = moonbitlang$core$set$$Set$iter$1$(entities);
  _bind$8((e) => {
    if (Milky2018$selene$entity$$Entity$is_alive(e)) {
      if (moonbitlang$core$builtin$$op_notequal$1$(e, entity)) {
        const _bind$9 = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$collision$$shapes, e);
        if (_bind$9 === undefined) {
          return 1;
        } else {
          const _Some = _bind$9;
          const _shape = _Some;
          const _Rect = _shape;
          const _x = _Rect._0;
          const _width = _x._0;
          const _height = _x._1;
          const _offset = _Rect._1;
          const _bind$10 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, e);
          if (_bind$10 === undefined) {
            return 1;
          } else {
            const _Some$2 = _bind$10;
            const _pos = _Some$2;
            const _bind$11 = moonbitlang$core$builtin$$Map$get$14$(Milky2018$selene$collision$$collision_layers, e);
            if (_bind$11 === undefined) {
              return 1;
            } else {
              const _Some$3 = _bind$11;
              const _collision_layer = _Some$3;
              if (Milky2018$selene$collision$$CollisionMask$contains(mask, _collision_layer)) {
                const _bind$12 = { _0: _width, _1: _height };
                const _bind$13 = { _0: _pos._0 + _offset._0, _1: _pos._1 + _offset._1 };
                const collision_box = { position: _bind$13, size: _bind$12 };
                if (Milky2018$selene$math$$Rect$intersects(object, collision_box)) {
                  const movement = Milky2018$selene$collision$$aabb_resolve(object, collision_box);
                  const _p = new_pos.val;
                  new_pos.val = { _0: _p._0 + movement._0, _1: _p._1 + movement._1 };
                  const dir = Milky2018$selene$math$$Vec2D$update({ _0: 0, _1: 0 }, axis, Milky2018$selene$math$$Vec2D$op_get(movement, axis) > 0 ? 1 : -1);
                  Milky2018$selene$collision$$add_collision_info(entity, e, dir);
                  _foreach_result.val = new $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$10$({ _0: new_pos.val, _1: movement });
                  return 0;
                }
                if (Milky2018$selene$math$$Rect$intersects(ray_collision, collision_box)) {
                  let dir = { _0: 0, _1: 0 };
                  if (Milky2018$selene$math$$Vec2D$op_get(new_velocity.val, axis) > 0) {
                    const _tmp = new_pos.val;
                    const _p = Milky2018$selene$math$$Vec2D$op_get(_bind$13, axis) - Milky2018$selene$math$$Vec2D$op_get(object.size, axis);
                    const _p$2 = Milky2018$selene$math$$Vec2D$op_get(object.position, axis);
                    new_pos.val = Milky2018$selene$math$$Vec2D$update(_tmp, axis, _p > _p$2 ? _p : _p$2);
                    new_velocity.val = Milky2018$selene$math$$Vec2D$update(new_velocity.val, axis, Milky2018$selene$math$$Vec2D$op_get(new_pos.val, axis) - Milky2018$selene$math$$Vec2D$op_get(object.position, axis));
                    dir = Milky2018$selene$math$$Vec2D$update(dir, axis, 1);
                  } else {
                    if (Milky2018$selene$math$$Vec2D$op_get(new_velocity.val, axis) < 0) {
                      const _tmp = new_pos.val;
                      const _p = Milky2018$selene$math$$Vec2D$op_get(_bind$13, axis) + Milky2018$selene$math$$Vec2D$op_get(_bind$12, axis);
                      const _p$2 = Milky2018$selene$math$$Vec2D$op_get(object.position, axis);
                      new_pos.val = Milky2018$selene$math$$Vec2D$update(_tmp, axis, _p > _p$2 ? _p$2 : _p);
                      new_velocity.val = Milky2018$selene$math$$Vec2D$update(new_velocity.val, axis, Milky2018$selene$math$$Vec2D$op_get(new_pos.val, axis) - Milky2018$selene$math$$Vec2D$op_get(object.position, axis));
                      dir = Milky2018$selene$math$$Vec2D$update(dir, axis, -1);
                    }
                  }
                  Milky2018$selene$collision$$add_collision_info(entity, e, dir);
                }
              } else {
                return 1;
              }
            }
          }
        }
      } else {
        return 1;
      }
    } else {
      return 1;
    }
    return 1;
  });
  const _tmp = _foreach_result.val;
  switch (_tmp.$tag) {
    case 0: {
      break;
    }
    case 1: {
      const _break = _tmp;
      _break._0;
      break;
    }
    case 2: {
      const _return = _tmp;
      return _return._0;
    }
    case 3: {
      $panic();
      break;
    }
    default: {
      $panic();
    }
  }
  return { _0: new_pos.val, _1: new_velocity.val };
}
function Milky2018$selene$collision$$move_with_collide(e, collider, velocity) {
  const _bind$8 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, e);
  if (_bind$8 === undefined) {
    return $panic();
  } else {
    const _Some = _bind$8;
    const _pos = _Some;
    const _bind$9 = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$collision$$shapes, e);
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
      moonbitlang$core$builtin$$Map$set$2$(Milky2018$selene$position$$positions, e, { _0: _p._0 - _offset._0, _1: _p._1 - _offset._1 });
      return new_y._1;
    }
  }
}
function Milky2018$selene$collision$$move_without_collide(e, velocity) {
  const _bind$8 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, e);
  if (_bind$8 === undefined) {
    $panic();
    return;
  } else {
    const _Some = _bind$8;
    const _pos = _Some;
    const new_pos = { _0: Milky2018$selene$math$$Vec2D$op_get(_pos, 0) + Milky2018$selene$math$$Vec2D$op_get(velocity, 0), _1: Milky2018$selene$math$$Vec2D$op_get(_pos, 1) + Milky2018$selene$math$$Vec2D$op_get(velocity, 1) };
    moonbitlang$core$builtin$$Map$set$2$(Milky2018$selene$position$$positions, e, new_pos);
    return;
  }
}
function Milky2018$selene$collision$$move_system(delta) {
  moonbitlang$core$builtin$$Map$clear$12$(Milky2018$selene$collision$$collision_infos);
  let _foreach_result = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$9$;
  const _bind$8 = moonbitlang$core$builtin$$Map$iter2$11$(Milky2018$selene$velocity$$velocities);
  _bind$8((e, vel) => {
    if (Milky2018$selene$entity$$Entity$is_alive(e)) {
      _L: {
        _L$2: {
          const _bind$9 = moonbitlang$core$builtin$$Map$get$13$(Milky2018$selene$collision$$colliders, e);
          if (_bind$9 === undefined) {
            break _L$2;
          } else {
            const _Some = _bind$9;
            const _collide = _Some;
            if (_collide.active) {
              const new_vel = Milky2018$selene$collision$$move_with_collide(e, _collide, { _0: vel._0 * delta, _1: vel._1 * delta });
              moonbitlang$core$builtin$$Map$set$11$(Milky2018$selene$collision$$real_velocities, e, { _0: new_vel._0 / delta, _1: new_vel._1 / delta });
            } else {
              break _L$2;
            }
          }
          break _L;
        }
        Milky2018$selene$collision$$move_without_collide(e, { _0: vel._0 * delta, _1: vel._1 * delta });
        moonbitlang$core$builtin$$Map$set$11$(Milky2018$selene$collision$$real_velocities, e, vel);
      }
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
function Milky2018$selene$collision$$area_collide_system(_delta) {
  const _foreach_result = { val: $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$9$ };
  const _bind$8 = Milky2018$selene$entity$$iter_entities();
  _bind$8((e) => {
    const _bind$9 = moonbitlang$core$builtin$$Map$get$17$(Milky2018$selene$collision$$areas, e);
    if (_bind$9 === undefined) {
      return 1;
    } else {
      const _Some = _bind$9;
      const _area = _Some;
      const _bind$10 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, e);
      if (_bind$10 === undefined) {
        $panic();
      } else {
        const _Some$2 = _bind$10;
        const _position = _Some$2;
        const _bind$11 = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$collision$$shapes, e);
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
          const new_contains = moonbitlang$core$set$$Set$new$46$inner$1$(8);
          const entities = Milky2018$selene$collision$$quadtree_query(box);
          let _foreach_result$2 = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$9$;
          const _bind$14 = moonbitlang$core$set$$Set$iter$1$(entities);
          _bind$14((entity) => {
            if (Milky2018$selene$entity$$Entity$is_alive(entity)) {
              const _bind$15 = moonbitlang$core$builtin$$Map$get$14$(Milky2018$selene$collision$$collision_layers, entity);
              if (_bind$15 === undefined) {
                return 1;
              } else {
                const _Some$4 = _bind$15;
                const _other_layer = _Some$4;
                const _bind$16 = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$collision$$shapes, entity);
                if (_bind$16 === undefined) {
                  return 1;
                } else {
                  const _Some$5 = _bind$16;
                  const _other_shape = _Some$5;
                  const _Rect$2 = _other_shape;
                  const _x$2 = _Rect$2._0;
                  const _other_width = _x$2._0;
                  const _other_height = _x$2._1;
                  const _other_offset = _Rect$2._1;
                  const _bind$17 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, entity);
                  if (_bind$17 === undefined) {
                    $panic();
                  } else {
                    const _Some$6 = _bind$17;
                    const _other_position = _Some$6;
                    const _bind$18 = { _0: _other_width, _1: _other_height };
                    const _bind$19 = { _0: _other_position._0 + _other_offset._0, _1: _other_position._1 + _other_offset._1 };
                    const other_box = { position: _bind$19, size: _bind$18 };
                    if (Milky2018$selene$math$$Rect$intersects(box, other_box)) {
                      if (Milky2018$selene$collision$$CollisionMask$contains(_area.mask, _other_layer)) {
                        moonbitlang$core$set$$Set$add$1$(new_contains, entity);
                        if (moonbitlang$core$set$$Set$contains$1$(_area.contains, entity)) {
                          return 1;
                        }
                        const _arr = _area.on_enter_callbacks;
                        const _len = _arr.length;
                        let _tmp = 0;
                        while (true) {
                          const _i = _tmp;
                          if (_i < _len) {
                            const callback = _arr[_i];
                            callback(entity);
                            _tmp = _i + 1 | 0;
                            continue;
                          } else {
                            break;
                          }
                        }
                      } else {
                        return 1;
                      }
                    } else {
                      return 1;
                    }
                  }
                }
              }
            } else {
              return 1;
            }
            return 1;
          });
          const _tmp = _foreach_result$2;
          switch (_tmp.$tag) {
            case 0: {
              break;
            }
            case 1: {
              const _break = _tmp;
              _break._0;
              break;
            }
            case 2: {
              const _return = _tmp;
              _foreach_result.val = new $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$9$(_return._0);
              return 0;
            }
            case 3: {
              $panic();
              break;
            }
            default: {
              $panic();
            }
          }
          let _foreach_result$3 = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$9$;
          const _bind$15 = moonbitlang$core$set$$Set$iter$1$(_area.contains);
          _bind$15((entity) => {
            if (moonbitlang$core$set$$Set$contains$1$(new_contains, entity)) {
              return 1;
            }
            const _arr = _area.on_exit_callbacks;
            const _len = _arr.length;
            let _tmp$2 = 0;
            while (true) {
              const _i = _tmp$2;
              if (_i < _len) {
                const callback = _arr[_i];
                callback(entity);
                _tmp$2 = _i + 1 | 0;
                continue;
              } else {
                break;
              }
            }
            return 1;
          });
          const _tmp$2 = _foreach_result$3;
          switch (_tmp$2.$tag) {
            case 0: {
              break;
            }
            case 1: {
              const _break$2 = _tmp$2;
              _break$2._0;
              break;
            }
            case 2: {
              const _return$2 = _tmp$2;
              _foreach_result.val = new $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$9$(_return$2._0);
              return 0;
            }
            case 3: {
              $panic();
              break;
            }
            default: {
              $panic();
            }
          }
          _area.contains = new_contains;
        }
      }
    }
    return 1;
  });
  const _tmp = _foreach_result.val;
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
          const _bind$8 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$position$$positions, entity);
          if (_bind$8 === undefined) {
            break _L;
          } else {
            const _Some = _bind$8;
            const _parent_position = _Some;
            const _p = moonbitlang$core$builtin$$Map$get$7$(Milky2018$selene$entity$$children, c);
            let _tmp$2;
            if (_p === undefined) {
              _tmp$2 = $panic();
            } else {
              const _p$2 = _p;
              _tmp$2 = _p$2;
            }
            const offset = _tmp$2.offset;
            moonbitlang$core$builtin$$Map$set$2$(Milky2018$selene$position$$positions, c, { _0: _parent_position._0 + offset._0, _1: _parent_position._1 + offset._1 });
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
function Milky2018$selene$style$$get_zindex(entity) {
  return moonbitlang$core$option$$Option$map_or$35$(moonbitlang$core$builtin$$Map$get$15$(Milky2018$selene$sprite$$sprites, entity), 100, (s) => s.zindex);
}
function Milky2018$selene$style$$Style$new$46$inner(size_plan, flex, h_padding, v_padding, h_offset, v_offset) {
  return { size_plan: size_plan, flex: flex, h_padding: h_padding, v_padding: v_padding, h_offset: h_offset, v_offset: v_offset };
}
function Milky2018$selene$style$$add_widget$46$inner(parent, sprite, on_just_pressed, shape, size_plan, flex, h_padding, v_padding, h_offset, v_offset) {
  const child = Milky2018$selene$entity$$Entity$spawn_child(parent, undefined);
  moonbitlang$core$builtin$$Map$set$3$(Milky2018$selene$ui$$uis, child, Milky2018$selene$ui$$Ui$new());
  const style = Milky2018$selene$style$$Style$new$46$inner(size_plan, flex, h_padding, v_padding, h_offset, v_offset);
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$style$$styles, child, style);
  if (sprite === undefined) {
  } else {
    const _Some = sprite;
    const _sprite_maker = _Some;
    const zindex = Milky2018$selene$style$$get_zindex(parent) + 1 | 0;
    const sprite$2 = _sprite_maker(zindex);
    moonbitlang$core$builtin$$Map$set$15$(Milky2018$selene$sprite$$sprites, child, sprite$2);
  }
  if (shape === undefined) {
  } else {
    const _Some = shape;
    const _shape = _Some;
    moonbitlang$core$builtin$$Map$set$8$(Milky2018$selene$collision$$shapes, child, _shape);
  }
  if (on_just_pressed === undefined) {
  } else {
    const _Some = on_just_pressed;
    const _button_cb = _Some;
    const pickable = Milky2018$selene$collision$$Pickable$new();
    Milky2018$selene$collision$$Pickable$on_just_pressed(pickable, _button_cb);
    moonbitlang$core$builtin$$Map$set$9$(Milky2018$selene$collision$$pickables, child, pickable);
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
  const _bind$8 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$style$$styles, entity);
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
        const _bind$10 = moonbitlang$core$builtin$$Map$get$15$(Milky2018$selene$sprite$$sprites, entity);
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
              return Milky2018$selene$math$$Transform$apply_to_vec2d(_anime.transform, moonbitlang$core$array$$Array$at$39$(_anime.frames, 0).size);
            }
            default: {
              const _ColorRect = _bind$11;
              const _rect = _ColorRect._0;
              return _rect.size;
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
        const _bind$11 = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$collision$$shapes, entity);
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
  let _foreach_result = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$9$;
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
(() => {
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$style$$styles, Milky2018$selene$style$$screen_root, Milky2018$selene$style$$Style$new$46$inner(new $64$Milky2018$47$selene$47$style$46$SizePlan$Sized(Milky2018$selene$backend$$canvas_backend.viewport_size), 0, 0, 0, 0, 0));
  moonbitlang$core$builtin$$Map$set$2$(Milky2018$selene$position$$positions, Milky2018$selene$style$$screen_root, { _0: 0, _1: 0 });
  moonbitlang$core$builtin$$Map$set$3$(Milky2018$selene$ui$$uis, Milky2018$selene$style$$screen_root, Milky2018$selene$ui$$Ui$new());
})();
function Milky2018$selene$plugins$$default_plugin(app) {
  const _self = app.systems;
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$collision$$move_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Move System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$inputs$$advanced_key_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Advanced Key System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$inputs$$advanced_mouse_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Advanced Mouse System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$collision$$quadtree_clear_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Quadtree Clear System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$collision$$pickable_click_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Pickable Click System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$collision$$area_collide_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Area Collide System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$system$$deferred_event_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Deferred Event System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$sprite$$render_sprite_system, _1: Milky2018$selene$plugins$$default_plugin$46$constr$47$3213, _2: "Render Sprite System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$camera$$camera_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Camera System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$system$$timer_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Timer System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$system$$realtime_timer_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Realtime Timer System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$inherit$$inherit_position_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Inherit Position System" });
  moonbitlang$core$array$$Array$push$57$(_self, { _0: Milky2018$selene$style$$style_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Style System" });
}
function moonbitlang$core$builtin$$Eq$equal$44$(_x_282, _x_283) {
  switch (_x_282) {
    case 0: {
      if (_x_283 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_283 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_283 === 2) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_283 === 3) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function moonbitlang$core$builtin$$Hash$hash_combine$44$(_x_278, _x_279) {
  switch (_x_278) {
    case 0: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_279, 0);
      return;
    }
    case 1: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_279, 1);
      return;
    }
    case 2: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_279, 2);
      return;
    }
    default: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_279, 3);
      return;
    }
  }
}
function moonbitlang$core$builtin$$Eq$equal$38$(_x_274, _x_275) {
  switch (_x_274) {
    case 0: {
      if (_x_275 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_275 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_275 === 2) {
        return true;
      } else {
        return false;
      }
    }
    case 3: {
      if (_x_275 === 3) {
        return true;
      } else {
        return false;
      }
    }
    case 4: {
      if (_x_275 === 4) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_275 === 5) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function moonbitlang$core$builtin$$Eq$equal$43$(_x_262, _x_263) {
  switch (_x_262) {
    case 0: {
      if (_x_263 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_263 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_263 === 2) {
        return true;
      } else {
        return false;
      }
    }
    case 3: {
      if (_x_263 === 3) {
        return true;
      } else {
        return false;
      }
    }
    case 4: {
      if (_x_263 === 4) {
        return true;
      } else {
        return false;
      }
    }
    case 5: {
      if (_x_263 === 5) {
        return true;
      } else {
        return false;
      }
    }
    case 6: {
      if (_x_263 === 6) {
        return true;
      } else {
        return false;
      }
    }
    case 7: {
      if (_x_263 === 7) {
        return true;
      } else {
        return false;
      }
    }
    case 8: {
      if (_x_263 === 8) {
        return true;
      } else {
        return false;
      }
    }
    case 9: {
      if (_x_263 === 9) {
        return true;
      } else {
        return false;
      }
    }
    case 10: {
      if (_x_263 === 10) {
        return true;
      } else {
        return false;
      }
    }
    case 11: {
      if (_x_263 === 11) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_263 === 12) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function moonbitlang$core$builtin$$Hash$hash_combine$43$(_x_258, _x_259) {
  switch (_x_258) {
    case 0: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 0);
      return;
    }
    case 1: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 1);
      return;
    }
    case 2: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 2);
      return;
    }
    case 3: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 3);
      return;
    }
    case 4: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 4);
      return;
    }
    case 5: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 5);
      return;
    }
    case 6: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 6);
      return;
    }
    case 7: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 7);
      return;
    }
    case 8: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 8);
      return;
    }
    case 9: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 9);
      return;
    }
    case 10: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 10);
      return;
    }
    case 11: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 11);
      return;
    }
    default: {
      moonbitlang$core$builtin$$Hasher$combine_int(_x_259, 12);
      return;
    }
  }
}
function Milky2018$selene$examples$cards$$hide_action_buttons() {
  Milky2018$selene$examples$cards$$game_state.waiting_for_player = false;
  Milky2018$selene$entity$$Entity$destroy(Milky2018$selene$examples$cards$$game_state.fold_button);
  Milky2018$selene$entity$$Entity$destroy(Milky2018$selene$examples$cards$$game_state.call_button);
  Milky2018$selene$entity$$Entity$destroy(Milky2018$selene$examples$cards$$game_state.raise_button);
}
function Milky2018$selene$examples$cards$$deal_card() {
  return Milky2018$selene$examples$cards$$game_state.deck.length > 0 ? moonbitlang$core$array$$Array$pop$40$(Milky2018$selene$examples$cards$$game_state.deck) : undefined;
}
function Milky2018$selene$examples$cards$$CardNum$to_string(self) {
  switch (self) {
    case 0: {
      return "A";
    }
    case 1: {
      return "2";
    }
    case 2: {
      return "3";
    }
    case 3: {
      return "4";
    }
    case 4: {
      return "5";
    }
    case 5: {
      return "6";
    }
    case 6: {
      return "7";
    }
    case 7: {
      return "8";
    }
    case 8: {
      return "9";
    }
    case 9: {
      return "10";
    }
    case 10: {
      return "J";
    }
    case 11: {
      return "Q";
    }
    default: {
      return "K";
    }
  }
}
function Milky2018$selene$examples$cards$$CardSuit$to_string(self) {
  switch (self) {
    case 0: {
      return "H";
    }
    case 1: {
      return "D";
    }
    case 2: {
      return "C";
    }
    default: {
      return "S";
    }
  }
}
function Milky2018$selene$examples$cards$$Card$to_path(self) {
  return `assets/${Milky2018$selene$examples$cards$$CardNum$to_string(self._0)}-${Milky2018$selene$examples$cards$$CardSuit$to_string(self._1)}.png`;
}
function Milky2018$selene$examples$cards$$Card$to_sprite(self, zindex) {
  const transform = Milky2018$selene$math$$Transform$from_scale(0.2, 0.2);
  const anime = Milky2018$selene$sprite$$Animation$single_frame(Milky2018$selene$examples$cards$$Card$to_path(self), { _0: 295, _1: 420 }, transform, undefined);
  return Milky2018$selene$sprite$$Sprite$from_animation(anime, zindex, undefined);
}
function Milky2018$selene$examples$cards$$display_community_cards() {
  const _arr = Milky2018$selene$examples$cards$$game_state.community_card_entities;
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const entity = _arr[_i];
      Milky2018$selene$entity$$Entity$destroy(entity);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$Array$clear$1$(Milky2018$selene$examples$cards$$game_state.community_card_entities);
  const _arr$2 = Milky2018$selene$examples$cards$$game_state.community_cards;
  const _len$2 = _arr$2.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len$2) {
      const card = _arr$2[_i];
      const card_x = 240 + (_i + 0 - 2.5) * 30 - 15;
      const card_entity = Milky2018$selene$entity$$Entity$new();
      moonbitlang$core$builtin$$Map$set$2$(Milky2018$selene$position$$positions, card_entity, { _0: card_x, _1: 100 });
      moonbitlang$core$builtin$$Map$set$15$(Milky2018$selene$sprite$$sprites, card_entity, Milky2018$selene$examples$cards$$Card$to_sprite(card, 10 + _i | 0));
      moonbitlang$core$array$$Array$push$1$(Milky2018$selene$examples$cards$$game_state.community_card_entities, card_entity);
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$examples$cards$$reset_betting_round() {
  Milky2018$selene$examples$cards$$game_state.current_bet = 0;
  Milky2018$selene$examples$cards$$game_state.player.current_bet = 0;
}
function Milky2018$selene$examples$cards$$count_by_num(hand) {
  const map = moonbitlang$core$builtin$$Map$new$46$inner$53$(8);
  const _len = hand.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const card = hand[_i];
      const _p = moonbitlang$core$builtin$$Map$get$53$(map, card._0);
      const _p$2 = 0;
      let count;
      if (_p === undefined) {
        count = _p$2;
      } else {
        const _p$3 = _p;
        count = _p$3;
      }
      moonbitlang$core$builtin$$Map$set$53$(map, card._0, count + 1 | 0);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return map;
}
function Milky2018$selene$examples$cards$$count_by_suit(hand) {
  const map = moonbitlang$core$builtin$$Map$new$46$inner$54$(8);
  const _len = hand.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const card = hand[_i];
      const _p = moonbitlang$core$builtin$$Map$get$54$(map, card._1);
      const _p$2 = 0;
      let count;
      if (_p === undefined) {
        count = _p$2;
      } else {
        const _p$3 = _p;
        count = _p$3;
      }
      moonbitlang$core$builtin$$Map$set$54$(map, card._1, count + 1 | 0);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return map;
}
function Milky2018$selene$examples$cards$$CardNum$to_int(self) {
  switch (self) {
    case 0: {
      return 14;
    }
    case 1: {
      return 2;
    }
    case 2: {
      return 3;
    }
    case 3: {
      return 4;
    }
    case 4: {
      return 5;
    }
    case 5: {
      return 6;
    }
    case 6: {
      return 7;
    }
    case 7: {
      return 8;
    }
    case 8: {
      return 9;
    }
    case 9: {
      return 10;
    }
    case 10: {
      return 11;
    }
    case 11: {
      return 12;
    }
    default: {
      return 13;
    }
  }
}
function Milky2018$selene$examples$cards$$is_flush(hand) {
  const suit_counts = Milky2018$selene$examples$cards$$count_by_suit(hand);
  const _foreach_result = { val: $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$11$ };
  const _bind$8 = moonbitlang$core$builtin$$Map$iter$54$(suit_counts);
  _bind$8((entry) => {
    if (entry._1 >= 5) {
      const _p = [];
      const _p$2 = hand.length;
      let _tmp = 0;
      while (true) {
        const _p$3 = _tmp;
        if (_p$3 < _p$2) {
          const _p$4 = hand[_p$3];
          if (moonbitlang$core$builtin$$Eq$equal$44$(_p$4._1, entry._0)) {
            moonbitlang$core$array$$Array$push$40$(_p, _p$4);
          }
          _tmp = _p$3 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      const flush_cards = _p;
      const _p$3 = new Array(flush_cards.length);
      const _p$4 = flush_cards.length;
      let _tmp$2 = 0;
      while (true) {
        const _p$5 = _tmp$2;
        if (_p$5 < _p$4) {
          const _p$6 = flush_cards[_p$5];
          _p$3[_p$5] = Milky2018$selene$examples$cards$$CardNum$to_int(_p$6._0);
          _tmp$2 = _p$5 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      const values = _p$3;
      moonbitlang$core$array$$Array$sort$20$(values);
      _foreach_result.val = new $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$11$(moonbitlang$core$array$$Array$at$20$(values, values.length - 1 | 0));
      return 0;
    }
    return 1;
  });
  const _tmp = _foreach_result.val;
  switch (_tmp.$tag) {
    case 0: {
      break;
    }
    case 1: {
      const _break = _tmp;
      _break._0;
      break;
    }
    case 2: {
      const _return = _tmp;
      return _return._0;
    }
    case 3: {
      $panic();
      break;
    }
    default: {
      $panic();
    }
  }
  return undefined;
}
function Milky2018$selene$examples$cards$$is_straight(hand) {
  const _p = Milky2018$selene$examples$cards$$count_by_num(hand);
  if (_p.size < 5) {
    return undefined;
  }
  const _p$2 = new Array(hand.length);
  const _p$3 = hand.length;
  let _tmp = 0;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$3) {
      const _p$5 = hand[_p$4];
      _p$2[_p$4] = Milky2018$selene$examples$cards$$CardNum$to_int(_p$5._0);
      _tmp = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const hand$2 = _p$2;
  moonbitlang$core$array$$Array$sort$20$(hand$2);
  if ((moonbitlang$core$array$$Array$at$20$(hand$2, 4) - moonbitlang$core$array$$Array$at$20$(hand$2, 0) | 0) === 4) {
    return moonbitlang$core$array$$Array$at$20$(hand$2, 4);
  }
  if (moonbitlang$core$builtin$$Eq$equal$63$(hand$2, [2, 3, 4, 5, 14])) {
    return Milky2018$selene$examples$cards$$is_straight$46$constr$47$3273;
  }
  return undefined;
}
function Milky2018$selene$examples$cards$$eval_rank(hand) {
  const nums = Milky2018$selene$examples$cards$$count_by_num(hand);
  if (hand.length === 5) {
    const straight = Milky2018$selene$examples$cards$$is_straight(hand);
    const flush = Milky2018$selene$examples$cards$$is_flush(hand);
    if (straight === undefined) {
    } else {
      const _Some = straight;
      const _n = _Some;
      if (flush === undefined) {
      } else {
        return new HandRank$StraightFlush(_n);
      }
    }
    if (flush === undefined) {
    } else {
      const _Some = flush;
      const _n = _Some;
      return new HandRank$Flush(_n);
    }
    if (straight === undefined) {
    } else {
      const _Some = straight;
      const _n = _Some;
      return new HandRank$Straight(_n);
    }
  }
  const _foreach_result = { val: $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$12$ };
  const _bind$8 = moonbitlang$core$builtin$$Map$iter$53$(nums);
  _bind$8((entry) => {
    if (entry._1 === 4) {
      _foreach_result.val = new $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$12$(new HandRank$FourOfKind(Milky2018$selene$examples$cards$$CardNum$to_int(entry._0)));
      return 0;
    }
    return 1;
  });
  const _tmp = _foreach_result.val;
  switch (_tmp.$tag) {
    case 0: {
      break;
    }
    case 1: {
      const _break = _tmp;
      _break._0;
      break;
    }
    case 2: {
      const _return = _tmp;
      return _return._0;
    }
    case 3: {
      $panic();
      break;
    }
    default: {
      $panic();
    }
  }
  const three_kind = { val: undefined };
  const pair = { val: undefined };
  const _bind$9 = moonbitlang$core$builtin$$Map$iter$53$(nums);
  _bind$9((entry) => {
    if (entry._1 === 3) {
      three_kind.val = Milky2018$selene$examples$cards$$CardNum$to_int(entry._0);
    }
    if (entry._1 === 2) {
      pair.val = Milky2018$selene$examples$cards$$CardNum$to_int(entry._0);
    }
    return 1;
  });
  const _bind$10 = three_kind.val;
  if (_bind$10 === undefined) {
  } else {
    const _Some = _bind$10;
    const _n = _Some;
    const _bind$11 = pair.val;
    if (_bind$11 === undefined) {
    } else {
      const _Some$2 = _bind$11;
      const _m = _Some$2;
      return new HandRank$FullHouse(_n, _m);
    }
  }
  const _bind$11 = three_kind.val;
  if (_bind$11 === undefined) {
  } else {
    const _Some = _bind$11;
    const _n = _Some;
    return new HandRank$ThreeOfKind(_n);
  }
  const _bind$12 = moonbitlang$core$builtin$$Map$iter$53$(nums);
  const pairs = moonbitlang$core$builtin$$Iter$to_array$41$((_p) => _bind$12((_p$2) => _p$2._1 === 2 ? _p(_p$2) : 1));
  if (pairs.length >= 2) {
    const _p = new Array(pairs.length);
    const _p$2 = pairs.length;
    let _tmp$2 = 0;
    while (true) {
      const _p$3 = _tmp$2;
      if (_p$3 < _p$2) {
        const _p$4 = pairs[_p$3];
        _p[_p$3] = Milky2018$selene$examples$cards$$CardNum$to_int(_p$4._0);
        _tmp$2 = _p$3 + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const pair_values = _p;
    moonbitlang$core$array$$Array$sort$20$(pair_values);
    const high_pair = moonbitlang$core$array$$Array$at$20$(pair_values, pair_values.length - 1 | 0);
    const low_pair = moonbitlang$core$array$$Array$at$20$(pair_values, pair_values.length - 2 | 0);
    return new HandRank$TwoPair(high_pair, low_pair);
  }
  if (pairs.length === 1) {
    return new HandRank$OnePair(Milky2018$selene$examples$cards$$CardNum$to_int(moonbitlang$core$array$$Array$at$41$(pairs, 0)._0));
  }
  const _p = new Array(hand.length);
  const _p$2 = hand.length;
  let _tmp$2 = 0;
  while (true) {
    const _p$3 = _tmp$2;
    if (_p$3 < _p$2) {
      const _p$4 = hand[_p$3];
      _p[_p$3] = Milky2018$selene$examples$cards$$CardNum$to_int(_p$4._0);
      _tmp$2 = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const card_values = _p;
  moonbitlang$core$array$$Array$sort$20$(card_values);
  return new HandRank$HighCard(moonbitlang$core$array$$Array$at$20$(card_values, card_values.length - 1 | 0));
}
function Milky2018$selene$examples$cards$$hand_rank_base_award(rank) {
  switch (rank.$tag) {
    case 0: {
      const _HighCard = rank;
      return _HighCard._0;
    }
    case 1: {
      const _OnePair = rank;
      const _n = _OnePair._0;
      return 15 + (Math.imul(_n, 2) | 0) | 0;
    }
    case 2: {
      const _TwoPair = rank;
      const _m = _TwoPair._0;
      const _n$2 = _TwoPair._1;
      return (50 + (Math.imul(_m, 2) | 0) | 0) + (Math.imul(_n$2, 2) | 0) | 0;
    }
    case 3: {
      const _ThreeOfKind = rank;
      const _n$3 = _ThreeOfKind._0;
      return 120 + (Math.imul(_n$3, 3) | 0) | 0;
    }
    case 4: {
      const _Straight = rank;
      const _n$4 = _Straight._0;
      return 200 + (Math.imul(_n$4, 5) | 0) | 0;
    }
    case 5: {
      const _Flush = rank;
      const _n$5 = _Flush._0;
      return 300 + (Math.imul(_n$5, 5) | 0) | 0;
    }
    case 6: {
      const _FullHouse = rank;
      const _n$6 = _FullHouse._0;
      const _m$2 = _FullHouse._1;
      return (500 + (Math.imul(_n$6, 3) | 0) | 0) + (Math.imul(_m$2, 2) | 0) | 0;
    }
    case 7: {
      const _FourOfKind = rank;
      const _n$7 = _FourOfKind._0;
      return 2000 + (Math.imul(_n$7, 4) | 0) | 0;
    }
    default: {
      const _StraightFlush = rank;
      const _x = _StraightFlush._0;
      if (_x === 14) {
        return 20000;
      } else {
        return 8000 + (Math.imul(_x, 5) | 0) | 0;
      }
    }
  }
}
function Milky2018$selene$examples$cards$$find_best_hand(cards) {
  if (cards.length < 5) {
    return Milky2018$selene$examples$cards$$eval_rank(cards);
  }
  if (cards.length === 5) {
    return Milky2018$selene$examples$cards$$eval_rank(cards);
  }
  let best_rank = Milky2018$selene$examples$cards$$find_best_hand$46$constr$47$3337;
  let best_value = 0;
  const n = cards.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < n) {
      const _start108 = i + 1 | 0;
      let _tmp$2 = _start108;
      while (true) {
        const j = _tmp$2;
        if (j < n) {
          const _start113 = j + 1 | 0;
          let _tmp$3 = _start113;
          while (true) {
            const k = _tmp$3;
            if (k < n) {
              const _start118 = k + 1 | 0;
              let _tmp$4 = _start118;
              while (true) {
                const l = _tmp$4;
                if (l < n) {
                  const _start123 = l + 1 | 0;
                  let _tmp$5 = _start123;
                  while (true) {
                    const m = _tmp$5;
                    if (m < n) {
                      const hand_5 = [moonbitlang$core$array$$Array$at$40$(cards, i), moonbitlang$core$array$$Array$at$40$(cards, j), moonbitlang$core$array$$Array$at$40$(cards, k), moonbitlang$core$array$$Array$at$40$(cards, l), moonbitlang$core$array$$Array$at$40$(cards, m)];
                      const rank = Milky2018$selene$examples$cards$$eval_rank(hand_5);
                      const value = Milky2018$selene$examples$cards$$hand_rank_base_award(rank);
                      if (value > best_value) {
                        best_value = value;
                        best_rank = rank;
                      }
                      _tmp$5 = m + 1 | 0;
                      continue;
                    } else {
                      break;
                    }
                  }
                  _tmp$4 = l + 1 | 0;
                  continue;
                } else {
                  break;
                }
              }
              _tmp$3 = k + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          _tmp$2 = j + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return best_rank;
}
function Milky2018$selene$examples$cards$$HandRank$hand_rank_to_string(rank) {
  switch (rank.$tag) {
    case 0: {
      return "High Card";
    }
    case 1: {
      return "One Pair";
    }
    case 2: {
      return "Two Pair";
    }
    case 3: {
      return "Three of a Kind";
    }
    case 4: {
      return "Straight";
    }
    case 5: {
      return "Flush";
    }
    case 6: {
      return "Full House";
    }
    case 7: {
      return "Four of a Kind";
    }
    default: {
      const _StraightFlush = rank;
      const _v = _StraightFlush._0;
      return _v === 14 ? "Royal Flush" : "Straight Flush";
    }
  }
}
function Milky2018$selene$examples$cards$$update_hand_strength() {
  const player = Milky2018$selene$examples$cards$$game_state.player;
  if ((player.hole_cards.length + Milky2018$selene$examples$cards$$game_state.community_cards.length | 0) < 5) {
    Milky2018$selene$examples$cards$$game_state.hand_strength_text.content = "";
    return undefined;
  }
  const hand = [];
  const _arr = player.hole_cards;
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const card = _arr[_i];
      moonbitlang$core$array$$Array$push$40$(hand, card);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _arr$2 = Milky2018$selene$examples$cards$$game_state.community_cards;
  const _len$2 = _arr$2.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len$2) {
      const card = _arr$2[_i];
      moonbitlang$core$array$$Array$push$40$(hand, card);
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (hand.length >= 5) {
    const rank = Milky2018$selene$examples$cards$$find_best_hand(hand);
    const hand_name = Milky2018$selene$examples$cards$$HandRank$hand_rank_to_string(rank);
    const magnification = Milky2018$selene$examples$cards$$game_state.magnification;
    Milky2018$selene$examples$cards$$game_state.hand_strength_text.content = `Hand: ${hand_name} × ${moonbitlang$core$int$$Int$to_string$46$inner(magnification, 10)}`;
    return;
  } else {
    return;
  }
}
function Milky2018$selene$examples$cards$$update_ui() {
  Milky2018$selene$examples$cards$$game_state.blind_text.content = `Blind: $${moonbitlang$core$int$$Int$to_string$46$inner(Milky2018$selene$examples$cards$$game_state.big_blind, 10)}`;
  Milky2018$selene$examples$cards$$game_state.chips_text.content = `Chips: $${moonbitlang$core$int$$Int$to_string$46$inner(Milky2018$selene$examples$cards$$game_state.player.chips, 10)}`;
  const _tmp = Milky2018$selene$examples$cards$$game_state.phase_text;
  const _bind$8 = Milky2018$selene$examples$cards$$game_state.phase;
  let _tmp$2;
  switch (_bind$8) {
    case 0: {
      _tmp$2 = "Pre-Flop";
      break;
    }
    case 1: {
      _tmp$2 = "Flop";
      break;
    }
    case 2: {
      _tmp$2 = "Turn";
      break;
    }
    case 3: {
      _tmp$2 = "River";
      break;
    }
    case 4: {
      _tmp$2 = "Showdown";
      break;
    }
    default: {
      _tmp$2 = "GAME OVER";
    }
  }
  _tmp.content = _tmp$2;
  Milky2018$selene$examples$cards$$game_state.turns_text.content = `Turns: ${moonbitlang$core$int$$Int$to_string$46$inner(Milky2018$selene$examples$cards$$game_state.turns_remaining, 10)}/10`;
  Milky2018$selene$examples$cards$$update_hand_strength();
  if (moonbitlang$core$builtin$$Eq$equal$38$(Milky2018$selene$examples$cards$$game_state.phase, 5)) {
    const player = Milky2018$selene$examples$cards$$game_state.player;
    const profit = player.chips - Milky2018$selene$examples$cards$$game_state.starting_chips | 0;
    const profit_text = profit >= 0 ? `Profit: +$${moonbitlang$core$int$$Int$to_string$46$inner(profit, 10)}` : `Loss: $${moonbitlang$core$int$$Int$to_string$46$inner(profit, 10)}`;
    Milky2018$selene$examples$cards$$game_state.hand_strength_text.content = profit_text;
    return;
  } else {
    return;
  }
}
function Milky2018$selene$examples$cards$$advance_to_next_phase() {
  const _bind$8 = Milky2018$selene$examples$cards$$game_state.phase;
  switch (_bind$8) {
    case 0: {
      let _tmp = 0;
      while (true) {
        const _ = _tmp;
        if (_ < 3) {
          const _bind$9 = Milky2018$selene$examples$cards$$deal_card();
          if (_bind$9 === undefined) {
          } else {
            const _Some = _bind$9;
            const _card = _Some;
            moonbitlang$core$array$$Array$push$40$(Milky2018$selene$examples$cards$$game_state.community_cards, _card);
          }
          _tmp = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      Milky2018$selene$examples$cards$$game_state.phase = 1;
      Milky2018$selene$examples$cards$$reset_betting_round();
      Milky2018$selene$examples$cards$$display_community_cards();
      break;
    }
    case 1: {
      const _bind$9 = Milky2018$selene$examples$cards$$deal_card();
      if (_bind$9 === undefined) {
      } else {
        const _Some = _bind$9;
        const _card = _Some;
        moonbitlang$core$array$$Array$push$40$(Milky2018$selene$examples$cards$$game_state.community_cards, _card);
      }
      Milky2018$selene$examples$cards$$game_state.phase = 2;
      Milky2018$selene$examples$cards$$reset_betting_round();
      Milky2018$selene$examples$cards$$display_community_cards();
      break;
    }
    case 2: {
      const _bind$10 = Milky2018$selene$examples$cards$$deal_card();
      if (_bind$10 === undefined) {
      } else {
        const _Some = _bind$10;
        const _card = _Some;
        moonbitlang$core$array$$Array$push$40$(Milky2018$selene$examples$cards$$game_state.community_cards, _card);
      }
      Milky2018$selene$examples$cards$$game_state.phase = 3;
      Milky2018$selene$examples$cards$$reset_betting_round();
      Milky2018$selene$examples$cards$$display_community_cards();
      break;
    }
    case 3: {
      Milky2018$selene$examples$cards$$game_state.phase = 4;
      break;
    }
  }
  Milky2018$selene$examples$cards$$update_ui();
}
function Milky2018$selene$examples$cards$$on_call_click() {
  const human = Milky2018$selene$examples$cards$$game_state.player;
  const call_amount = Milky2018$selene$examples$cards$$game_state.current_bet - human.current_bet | 0;
  const _p = human.chips;
  const actual_amount = call_amount < _p ? call_amount : _p;
  human.chips = human.chips - actual_amount | 0;
  human.current_bet = human.current_bet + actual_amount | 0;
  if (human.chips === 0) {
    Milky2018$selene$examples$cards$$game_state.action_text.content = "You went All-In!";
  } else {
    if (call_amount === 0) {
      Milky2018$selene$examples$cards$$game_state.action_text.content = "You checked";
    } else {
      Milky2018$selene$examples$cards$$game_state.action_text.content = `You called $${moonbitlang$core$int$$Int$to_string$46$inner(actual_amount, 10)}`;
    }
  }
  Milky2018$selene$examples$cards$$hide_action_buttons();
  Milky2018$selene$examples$cards$$advance_to_next_phase();
  Milky2018$selene$examples$cards$$update_ui();
}
function Milky2018$selene$examples$cards$$on_fold_click() {
  const human = Milky2018$selene$examples$cards$$game_state.player;
  human.has_folded = true;
  Milky2018$selene$examples$cards$$game_state.action_text.content = "You folded";
  Milky2018$selene$examples$cards$$hide_action_buttons();
  Milky2018$selene$examples$cards$$game_state.phase = 4;
}
function Milky2018$selene$examples$cards$$on_raise_click() {
  const human = Milky2018$selene$examples$cards$$game_state.player;
  const min_raise = Milky2018$selene$examples$cards$$game_state.big_blind;
  const _p = human.chips;
  const raise_amount = min_raise < _p ? min_raise : _p;
  human.chips = human.chips - raise_amount | 0;
  human.current_bet = human.current_bet + raise_amount | 0;
  Milky2018$selene$examples$cards$$game_state.current_bet = human.current_bet;
  Milky2018$selene$examples$cards$$game_state.magnification = Milky2018$selene$examples$cards$$game_state.magnification + 1 | 0;
  if (human.chips === 0) {
    Milky2018$selene$examples$cards$$game_state.action_text.content = "You went All-In!";
  } else {
    Milky2018$selene$examples$cards$$game_state.action_text.content = `You raised $${moonbitlang$core$int$$Int$to_string$46$inner(raise_amount, 10)}`;
  }
  Milky2018$selene$examples$cards$$hide_action_buttons();
  Milky2018$selene$examples$cards$$advance_to_next_phase();
  Milky2018$selene$examples$cards$$update_ui();
}
function Milky2018$selene$examples$cards$$create_action_buttons() {
  const fold_button = Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new({ _0: 70, _1: 25 }, "#cc0000", undefined), zindex, undefined), (_button) => {
    Milky2018$selene$examples$cards$$on_fold_click();
  }, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 70, _1: 25 }, { _0: 0, _1: 0 }), undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3400, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3401);
  Milky2018$selene$examples$cards$$game_state.fold_button = fold_button;
  Milky2018$selene$style$$add_widget(fold_button, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$sprite$$Text$new("Fold", Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3402, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3403, undefined, undefined), zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3404, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3405);
  const call_button = Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new({ _0: 70, _1: 25 }, "#00aa00", undefined), zindex, undefined), (_button) => {
    Milky2018$selene$examples$cards$$on_call_click();
  }, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 70, _1: 25 }, { _0: 0, _1: 0 }), undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3406, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3407);
  Milky2018$selene$examples$cards$$game_state.call_button = call_button;
  Milky2018$selene$style$$add_widget(call_button, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$cards$$game_state.call_button_text, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3408, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3409);
  const raise_button = Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new({ _0: 70, _1: 25 }, "#0066cc", undefined), zindex, undefined), (_button) => {
    Milky2018$selene$examples$cards$$on_raise_click();
  }, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 70, _1: 25 }, { _0: 0, _1: 0 }), undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3410, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3411);
  Milky2018$selene$examples$cards$$game_state.raise_button = raise_button;
  Milky2018$selene$style$$add_widget(raise_button, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$sprite$$Text$new("Raise", Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3412, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3413, undefined, undefined), zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3414, Milky2018$selene$examples$cards$$create_action_buttons$46$constr$47$3415);
  Milky2018$selene$examples$cards$$hide_action_buttons();
}
function Milky2018$selene$examples$cards$$setup_ui() {
  const table_entity = Milky2018$selene$entity$$Entity$new();
  moonbitlang$core$builtin$$Map$set$2$(Milky2018$selene$position$$positions, table_entity, { _0: 0, _1: 0 });
  moonbitlang$core$builtin$$Map$set$15$(Milky2018$selene$sprite$$sprites, table_entity, Milky2018$selene$sprite$$Sprite$from_color_rect(Milky2018$selene$sprite$$ColorRect$new({ _0: 480, _1: 320 }, "#2d5016", undefined), 0, undefined));
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$cards$$game_state.blind_text, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3428, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3429);
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$cards$$game_state.chips_text, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3430, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3431);
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$cards$$game_state.phase_text, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3432, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3433);
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$cards$$game_state.turns_text, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3434, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3435);
  Milky2018$selene$style$$add_widget(Milky2018$selene$style$$screen_root, (zindex) => Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$cards$$game_state.hand_strength_text, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3436, Milky2018$selene$examples$cards$$setup_ui$46$constr$47$3437);
  Milky2018$selene$examples$cards$$create_action_buttons();
}
function Milky2018$selene$examples$cards$$show_action_buttons() {
  Milky2018$selene$examples$cards$$game_state.waiting_for_player = true;
  if (moonbitlang$core$builtin$$op_notequal$38$(Milky2018$selene$examples$cards$$game_state.phase, 3)) {
    Milky2018$selene$entity$$Entity$respawn(Milky2018$selene$examples$cards$$game_state.fold_button);
  }
  Milky2018$selene$entity$$Entity$respawn(Milky2018$selene$examples$cards$$game_state.call_button);
  if (moonbitlang$core$builtin$$op_notequal$38$(Milky2018$selene$examples$cards$$game_state.phase, 3)) {
    Milky2018$selene$entity$$Entity$respawn(Milky2018$selene$examples$cards$$game_state.raise_button);
  }
  const call_amount = Milky2018$selene$examples$cards$$game_state.current_bet - Milky2018$selene$examples$cards$$game_state.player.current_bet | 0;
  if (call_amount === 0) {
    Milky2018$selene$examples$cards$$game_state.call_button_text.content = "Check";
    return;
  } else {
    Milky2018$selene$examples$cards$$game_state.call_button_text.content = `Call $${moonbitlang$core$int$$Int$to_string$46$inner(call_amount, 10)}`;
    return;
  }
}
function Milky2018$selene$examples$cards$$display_all_cards() {
  const _arr = Milky2018$selene$examples$cards$$game_state.hole_card_entities;
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const entity = _arr[_i];
      Milky2018$selene$entity$$Entity$destroy(entity);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$Array$clear$1$(Milky2018$selene$examples$cards$$game_state.hole_card_entities);
  const _arr$2 = Milky2018$selene$examples$cards$$game_state.community_card_entities;
  const _len$2 = _arr$2.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len$2) {
      const entity = _arr$2[_i];
      Milky2018$selene$entity$$Entity$destroy(entity);
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$Array$clear$1$(Milky2018$selene$examples$cards$$game_state.community_card_entities);
  const player = Milky2018$selene$examples$cards$$game_state.player;
  const pos = player.position;
  const x_base = pos._0;
  const y_base = pos._1 - 40;
  const _arr$3 = player.hole_cards;
  const _len$3 = _arr$3.length;
  let _tmp$3 = 0;
  while (true) {
    const _i = _tmp$3;
    if (_i < _len$3) {
      const card = _arr$3[_i];
      const card_x = x_base + (_i + 0 - 0.5) * 30 - 30;
      const card_entity = Milky2018$selene$entity$$Entity$new();
      moonbitlang$core$builtin$$Map$set$2$(Milky2018$selene$position$$positions, card_entity, { _0: card_x, _1: y_base });
      moonbitlang$core$builtin$$Map$set$15$(Milky2018$selene$sprite$$sprites, card_entity, Milky2018$selene$examples$cards$$Card$to_sprite(card, _i));
      moonbitlang$core$array$$Array$push$1$(Milky2018$selene$examples$cards$$game_state.hole_card_entities, card_entity);
      _tmp$3 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  Milky2018$selene$examples$cards$$display_community_cards();
}
function Milky2018$selene$examples$cards$$create_deck() {
  const deck = [];
  const ranks = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  const suits = [0, 1, 2, 3];
  const _len = ranks.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const rank = ranks[_i];
      const _len$2 = suits.length;
      let _tmp$2 = 0;
      while (true) {
        const _i$2 = _tmp$2;
        if (_i$2 < _len$2) {
          const suit = suits[_i$2];
          moonbitlang$core$array$$Array$push$40$(deck, { _0: rank, _1: suit });
          _tmp$2 = _i$2 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return deck;
}
function Milky2018$selene$examples$cards$$deal_hole_cards() {
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < 2) {
      const _bind$8 = Milky2018$selene$examples$cards$$deal_card();
      if (_bind$8 === undefined) {
      } else {
        const _Some = _bind$8;
        const _card = _Some;
        moonbitlang$core$array$$Array$push$40$(Milky2018$selene$examples$cards$$game_state.player.hole_cards, _card);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  Milky2018$selene$examples$cards$$display_all_cards();
}
function Milky2018$selene$examples$cards$$shuffle_deck(deck, rand) {
  const _end4 = deck.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _end4) {
      const range = deck.length - i | 0;
      const j_offset = (moonbitlang$core$random$$Rand$uint$46$inner(rand, 0) >>> 0) % (range >>> 0) | 0;
      const j = i + j_offset | 0;
      const temp = moonbitlang$core$array$$Array$at$40$(deck, i);
      moonbitlang$core$array$$Array$set$40$(deck, i, moonbitlang$core$array$$Array$at$40$(deck, j));
      moonbitlang$core$array$$Array$set$40$(deck, j, temp);
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$examples$cards$$start_new_hand() {
  const player = Milky2018$selene$examples$cards$$game_state.player;
  if (player.chips <= 0) {
    Milky2018$selene$examples$cards$$game_state.phase = 5;
    Milky2018$selene$examples$cards$$update_ui();
    return undefined;
  }
  if (Milky2018$selene$examples$cards$$game_state.turns_remaining <= 0) {
    Milky2018$selene$examples$cards$$game_state.phase = 5;
    Milky2018$selene$examples$cards$$update_ui();
    return undefined;
  }
  if (player.chips < Milky2018$selene$examples$cards$$game_state.big_blind) {
    Milky2018$selene$examples$cards$$game_state.phase = 5;
    Milky2018$selene$examples$cards$$update_ui();
    return undefined;
  }
  Milky2018$selene$examples$cards$$game_state.hand_number = Milky2018$selene$examples$cards$$game_state.hand_number + 1 | 0;
  Milky2018$selene$examples$cards$$game_state.phase = 0;
  Milky2018$selene$examples$cards$$game_state.current_bet = Milky2018$selene$examples$cards$$game_state.big_blind;
  moonbitlang$core$array$$Array$clear$40$(Milky2018$selene$examples$cards$$game_state.community_cards);
  Milky2018$selene$examples$cards$$game_state.action_text.content = "";
  Milky2018$selene$examples$cards$$game_state.magnification = 1;
  if ((Milky2018$selene$examples$cards$$game_state.hand_number % 10 | 0) === 1 && Milky2018$selene$examples$cards$$game_state.hand_number > 1) {
    Milky2018$selene$examples$cards$$game_state.small_blind = Math.imul(Milky2018$selene$examples$cards$$game_state.small_blind, 2) | 0;
    Milky2018$selene$examples$cards$$game_state.big_blind = Math.imul(Milky2018$selene$examples$cards$$game_state.big_blind, 2) | 0;
  }
  moonbitlang$core$array$$Array$clear$40$(player.hole_cards);
  player.current_bet = Milky2018$selene$examples$cards$$game_state.big_blind;
  player.has_folded = false;
  const _p = Milky2018$selene$examples$cards$$game_state.big_blind;
  const _p$2 = player.chips;
  const blind_amount = _p < _p$2 ? _p : _p$2;
  player.chips = player.chips - blind_amount | 0;
  Milky2018$selene$examples$cards$$game_state.deck = Milky2018$selene$examples$cards$$create_deck();
  Milky2018$selene$examples$cards$$shuffle_deck(Milky2018$selene$examples$cards$$game_state.deck, Milky2018$selene$examples$cards$$game_state.rand);
  Milky2018$selene$examples$cards$$deal_hole_cards();
  Milky2018$selene$examples$cards$$update_ui();
}
function Milky2018$selene$examples$cards$$game_start(_delta) {
  Milky2018$selene$backend$$load_font("ThaleahFat", "assets/ThaleahFat.ttf");
  Milky2018$selene$examples$cards$$setup_ui();
  Milky2018$selene$examples$cards$$start_new_hand();
}
function Milky2018$selene$examples$cards$$handle_betting_round() {
  if (!Milky2018$selene$examples$cards$$game_state.waiting_for_player) {
    Milky2018$selene$examples$cards$$show_action_buttons();
    return;
  } else {
    return;
  }
}
function Milky2018$selene$examples$cards$$handle_showdown() {
  const player = Milky2018$selene$examples$cards$$game_state.player;
  if (!player.has_folded) {
    const hand = [];
    const _arr = player.hole_cards;
    const _len = _arr.length;
    let _tmp = 0;
    while (true) {
      const _i = _tmp;
      if (_i < _len) {
        const card = _arr[_i];
        moonbitlang$core$array$$Array$push$40$(hand, card);
        _tmp = _i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const _arr$2 = Milky2018$selene$examples$cards$$game_state.community_cards;
    const _len$2 = _arr$2.length;
    let _tmp$2 = 0;
    while (true) {
      const _i = _tmp$2;
      if (_i < _len$2) {
        const card = _arr$2[_i];
        moonbitlang$core$array$$Array$push$40$(hand, card);
        _tmp$2 = _i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    if (hand.length >= 5) {
      const rank = Milky2018$selene$examples$cards$$find_best_hand(hand);
      const base_award = Milky2018$selene$examples$cards$$hand_rank_base_award(rank);
      const magnification = Milky2018$selene$examples$cards$$game_state.magnification;
      const payout = Math.imul(base_award, magnification) | 0;
      player.chips = player.chips + payout | 0;
    }
    Milky2018$selene$examples$cards$$game_state.turns_remaining = Milky2018$selene$examples$cards$$game_state.turns_remaining - 1 | 0;
  }
  Milky2018$selene$examples$cards$$update_ui();
  Milky2018$selene$examples$cards$$start_new_hand();
}
function Milky2018$selene$examples$cards$$game_update_system(_delta) {
  _L: {
    const _bind$8 = Milky2018$selene$examples$cards$$game_state.phase;
    switch (_bind$8) {
      case 0: {
        break _L;
      }
      case 1: {
        break _L;
      }
      case 2: {
        break _L;
      }
      case 3: {
        break _L;
      }
      case 4: {
        Milky2018$selene$examples$cards$$handle_showdown();
        return;
      }
      default: {
        return;
      }
    }
  }
  Milky2018$selene$examples$cards$$handle_betting_round();
}
(() => {
  Milky2018$selene$system$$App$run(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system$46$inner(Milky2018$selene$system$$App$add_plugin(Milky2018$selene$system$$App$with_fps(Milky2018$selene$system$$App$with_zoom(Milky2018$selene$system$$App$with_canvas_height(Milky2018$selene$system$$App$with_canvas_width(Milky2018$selene$system$$App$new(), 960), 640), 2), 60), Milky2018$selene$plugins$$default_plugin), Milky2018$selene$examples$cards$$game_start, $64$Milky2018$47$selene$47$system$46$Schedule$Startup, undefined), Milky2018$selene$examples$cards$$game_update_system, undefined, undefined));
})();
