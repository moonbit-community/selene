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
const $_4503599627370496L = { hi: -1048576, lo: 0 };
const $9218868437227405312L = { hi: 2146435072, lo: 0 };
const $64$moonbitlang$47$core$47$builtin$46$Json$True = { $tag: 1 };
const $64$moonbitlang$47$core$47$builtin$46$Json$False = { $tag: 2 };
function $64$moonbitlang$47$core$47$builtin$46$Json$Number(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$builtin$46$Json$Number.prototype.$tag = 3;
function $64$moonbitlang$47$core$47$builtin$46$Json$String(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$Json$String.prototype.$tag = 4;
function $64$moonbitlang$47$core$47$builtin$46$Json$Array(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$Json$Array.prototype.$tag = 5;
function $64$moonbitlang$47$core$47$builtin$46$Json$Object(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$Json$Object.prototype.$tag = 6;
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
function Result$Err$1$(param0) {
  this._0 = param0;
}
Result$Err$1$.prototype.$tag = 0;
function Result$Ok$1$(param0) {
  this._0 = param0;
}
Result$Ok$1$.prototype.$tag = 1;
function Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError(param0) {
  this._0 = param0;
}
Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError.prototype.$tag = 0;
function Result$Err$2$(param0) {
  this._0 = param0;
}
Result$Err$2$.prototype.$tag = 0;
function Result$Ok$2$(param0) {
  this._0 = param0;
}
Result$Ok$2$.prototype.$tag = 1;
function Result$Err$3$(param0) {
  this._0 = param0;
}
Result$Err$3$.prototype.$tag = 0;
function Result$Ok$3$(param0) {
  this._0 = param0;
}
Result$Ok$3$.prototype.$tag = 1;
function Result$Err$4$(param0) {
  this._0 = param0;
}
Result$Err$4$.prototype.$tag = 0;
function Result$Ok$4$(param0) {
  this._0 = param0;
}
Result$Ok$4$.prototype.$tag = 1;
function Result$Err$5$(param0) {
  this._0 = param0;
}
Result$Err$5$.prototype.$tag = 0;
function Result$Ok$5$(param0) {
  this._0 = param0;
}
Result$Ok$5$.prototype.$tag = 1;
function Result$Err$6$(param0) {
  this._0 = param0;
}
Result$Err$6$.prototype.$tag = 0;
function Result$Ok$6$(param0) {
  this._0 = param0;
}
Result$Ok$6$.prototype.$tag = 1;
const $64$moonbitlang$47$core$47$json$46$JsonPath$Root = { $tag: 0 };
function $64$moonbitlang$47$core$47$json$46$JsonPath$Key(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$json$46$JsonPath$Key.prototype.$tag = 1;
function $64$moonbitlang$47$core$47$json$46$JsonPath$Index(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$json$46$JsonPath$Index.prototype.$tag = 2;
const $64$moonbitlang$47$core$47$list$46$List$Empty$7$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$list$46$List$More$7$(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$list$46$List$More$7$.prototype.$tag = 1;
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
function $bound_check(arr, index) {
  if (index < 0 || index >= arr.length) throw new Error("Index out of bounds");
}
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
const moonbitlang$core$builtin$$int_to_string_js = (x, radix) => {
  return x.toString(radix);
};
const moonbitlang$core$builtin$$JSArray$push = (arr, val) => { arr.push(val); };
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
const Option$None$10$ = { $tag: 0 };
function Option$Some$10$(param0) {
  this._0 = param0;
}
Option$Some$10$.prototype.$tag = 1;
const moonbitlang$core$builtin$$MyInt64$reinterpret_as_double = function f(a) {
  let view = f._view;
  if (view === undefined) {
    view = f._view = new DataView(new ArrayBuffer(8));
  }
  view.setUint32(0, a.hi);
  view.setUint32(4, a.lo);
  return view.getFloat64(0);
};
const moonbitlang$core$builtin$$JSArray$set_length = (arr, len) => { arr.length = len; };
const rami3l$js$45$ffi$js$$Value$undefined = () => undefined;
const rami3l$js$45$ffi$js$$Value$is_null = (n) => Object.is(n, null);
const Option$None$11$ = { $tag: 0 };
function Option$Some$11$(param0) {
  this._0 = param0;
}
Option$Some$11$.prototype.$tag = 1;
const Option$None$12$ = { $tag: 0 };
function Option$Some$12$(param0) {
  this._0 = param0;
}
Option$Some$12$.prototype.$tag = 1;
const Option$None$13$ = { $tag: 0 };
function Option$Some$13$(param0) {
  this._0 = param0;
}
Option$Some$13$.prototype.$tag = 1;
const Option$None$14$ = { $tag: 0 };
function Option$Some$14$(param0) {
  this._0 = param0;
}
Option$Some$14$.prototype.$tag = 1;
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
const Milky2018$selene$backend$$Audio$new = (path) => new Audio(path);
const Milky2018$selene$backend$$Audio$play = (self) => self.play();
const Milky2018$selene$backend$$Audio$set_volume = (self, volume) => self.volume = volume;
const Milky2018$selene$backend$$Audio$set_loop = (self, loop_) => self.loop = loop_;
const Option$None$15$ = { $tag: 0 };
function Option$Some$15$(param0) {
  this._0 = param0;
}
Option$Some$15$.prototype.$tag = 1;
function $f64_convert_i32_u(a) {
  return a < 0 ? a + 4294967296.0 : a + 0.0;
}
const $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$16$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$16$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$16$.prototype.$tag = 1;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$16$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$16$.prototype.$tag = 2;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$16$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$16$.prototype.$tag = 3;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$16$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$16$.prototype.$tag = 4;
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
const Option$None$17$ = { $tag: 0 };
function Option$Some$17$(param0) {
  this._0 = param0;
}
Option$Some$17$.prototype.$tag = 1;
function Result$Err$18$(param0) {
  this._0 = param0;
}
Result$Err$18$.prototype.$tag = 0;
function Result$Ok$18$(param0) {
  this._0 = param0;
}
Result$Ok$18$.prototype.$tag = 1;
const Option$None$19$ = { $tag: 0 };
function Option$Some$19$(param0) {
  this._0 = param0;
}
Option$Some$19$.prototype.$tag = 1;
function Result$Err$20$(param0) {
  this._0 = param0;
}
Result$Err$20$.prototype.$tag = 0;
function Result$Ok$20$(param0) {
  this._0 = param0;
}
Result$Ok$20$.prototype.$tag = 1;
function Result$Err$21$(param0) {
  this._0 = param0;
}
Result$Err$21$.prototype.$tag = 0;
function Result$Ok$21$(param0) {
  this._0 = param0;
}
Result$Ok$21$.prototype.$tag = 1;
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
const Milky2018$selene$inputs$$all_codes$46$42$bind$47$2162 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32];
const Milky2018$selene$inputs$$from_string$46$constr$47$2174 = 0;
const Milky2018$selene$inputs$$from_string$46$constr$47$2175 = 1;
const Milky2018$selene$inputs$$from_string$46$constr$47$2176 = 2;
const Milky2018$selene$inputs$$from_string$46$constr$47$2177 = 3;
const Milky2018$selene$inputs$$from_string$46$constr$47$2178 = 4;
const Milky2018$selene$inputs$$from_string$46$constr$47$2179 = 5;
const Milky2018$selene$inputs$$from_string$46$constr$47$2180 = 6;
const Milky2018$selene$inputs$$from_string$46$constr$47$2181 = 7;
const Milky2018$selene$inputs$$from_string$46$constr$47$2182 = 8;
const Milky2018$selene$inputs$$from_string$46$constr$47$2183 = 9;
const Milky2018$selene$inputs$$from_string$46$constr$47$2184 = 10;
const Milky2018$selene$inputs$$from_string$46$constr$47$2185 = 11;
const Milky2018$selene$inputs$$from_string$46$constr$47$2186 = 12;
const Milky2018$selene$inputs$$from_string$46$constr$47$2187 = 13;
const Milky2018$selene$inputs$$from_string$46$constr$47$2188 = 14;
const Milky2018$selene$inputs$$from_string$46$constr$47$2189 = 15;
const Milky2018$selene$inputs$$from_string$46$constr$47$2190 = 16;
const Milky2018$selene$inputs$$from_string$46$constr$47$2191 = 17;
const Milky2018$selene$inputs$$from_string$46$constr$47$2192 = 18;
const Milky2018$selene$inputs$$from_string$46$constr$47$2193 = 19;
const Milky2018$selene$inputs$$from_string$46$constr$47$2194 = 20;
const Milky2018$selene$inputs$$from_string$46$constr$47$2195 = 21;
const Milky2018$selene$inputs$$from_string$46$constr$47$2196 = 22;
const Milky2018$selene$inputs$$from_string$46$constr$47$2197 = 23;
const Milky2018$selene$inputs$$from_string$46$constr$47$2198 = 24;
const Milky2018$selene$inputs$$from_string$46$constr$47$2199 = 26;
const Milky2018$selene$inputs$$from_string$46$constr$47$2200 = 27;
const Milky2018$selene$inputs$$from_string$46$constr$47$2201 = 28;
const Milky2018$selene$inputs$$from_string$46$constr$47$2202 = 29;
const Milky2018$selene$inputs$$from_string$46$constr$47$2203 = 30;
const Milky2018$selene$inputs$$from_string$46$constr$47$2204 = 31;
const Milky2018$selene$inputs$$from_string$46$constr$47$2205 = 32;
const Milky2018$selene$entity$$entity_generator = { val: 0 };
const Milky2018$selene$collision$$collision_layer_generator = { val: 0 };
const Milky2018$selene$plugins$$default_plugin$46$constr$47$3110 = new $64$Milky2018$47$selene$47$system$46$Schedule$Render(0);
const Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3213 = "24px ThaleahFat";
const Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3214 = "white";
const Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3215 = "20px ThaleahFat";
const Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3216 = "red";
const Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3217 = "20px ThaleahFat";
const Milky2018$selene$examples$pixeladventure$$player_idle_animation$46$constr$47$3222 = true;
const Milky2018$selene$examples$pixeladventure$$player_idle_animation$46$constr$47$3223 = new Option$Some$0$(12);
const Milky2018$selene$examples$pixeladventure$$player_run_animation$46$constr$47$3224 = true;
const Milky2018$selene$examples$pixeladventure$$player_run_animation$46$constr$47$3225 = new Option$Some$0$(12);
const Milky2018$selene$examples$pixeladventure$$player_fall_animation$46$constr$47$3226 = true;
const Milky2018$selene$examples$pixeladventure$$player_fall_animation$46$constr$47$3227 = new Option$Some$0$(12);
const Milky2018$selene$examples$pixeladventure$$player_jump_animation$46$constr$47$3228 = true;
const Milky2018$selene$examples$pixeladventure$$player_jump_animation$46$constr$47$3229 = new Option$Some$0$(12);
const Milky2018$selene$examples$pixeladventure$$player_hit_animation$46$constr$47$3230 = false;
const Milky2018$selene$examples$pixeladventure$$player_hit_animation$46$constr$47$3231 = new Option$Some$0$(12);
const Milky2018$selene$examples$pixeladventure$$bird_fly_animation$46$constr$47$3232 = true;
const Milky2018$selene$examples$pixeladventure$$bird_fly_animation$46$constr$47$3233 = new Option$Some$0$(12);
const Milky2018$selene$examples$pixeladventure$$bird_hit_animation$46$constr$47$3988 = false;
const Milky2018$selene$examples$pixeladventure$$bird_hit_animation$46$constr$47$3989 = new Option$Some$0$(12);
const Milky2018$selene$examples$pixeladventure$$add_apple$46$constr$47$4029 = true;
const Milky2018$selene$examples$pixeladventure$$add_apple$46$constr$47$4030 = new Option$Some$0$(12);
const Milky2018$selene$examples$pixeladventure$$add_background$46$constr$47$4036 = 3;
const Milky2018$selene$examples$pixeladventure$$generate_map$46$constr$47$4053 = new Option$Some$0$(0);
const Milky2018$selene$examples$pixeladventure$$generate_map$46$constr$47$4054 = new Option$Some$0$(0);
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
const Milky2018$selene$sprite$$sprites = moonbitlang$core$builtin$$Map$new$46$inner$4$(8);
const _bind = Milky2018$selene$entity$$Entity$new();
const _bind$2 = Milky2018$selene$sprite$$Text$new("", undefined, Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3213, undefined, undefined);
const _bind$3 = Milky2018$selene$sprite$$Text$new("Score: 0", Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3214, Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3215, undefined, undefined);
const _bind$4 = Milky2018$selene$sprite$$Text$new("HP: 3", Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3216, Milky2018$selene$examples$pixeladventure$$game_state$46$constr$47$3217, undefined, undefined);
const Milky2018$selene$examples$pixeladventure$$game_state = { player: _bind, player_state: 0, direction: 1, score: 0, result_box: _bind$2, score_box: _bind$3, health_box: _bind$4, volume_on: true, health: 3, hurt_timer: 0 };
const Milky2018$selene$collision$$shapes = moonbitlang$core$builtin$$Map$new$46$inner$5$(8);
const Milky2018$selene$collision$$pickables = moonbitlang$core$builtin$$Map$new$46$inner$6$(8);
const _bind$5 = { _0: 0, _1: 0 };
const _bind$6 = Option$None$0$;
const _bind$7 = Option$None$0$;
const _bind$8 = Option$None$0$;
const _bind$9 = Option$None$0$;
const _bind$10 = undefined;
const _bind$11 = { _0: 0, _1: 0 };
const Milky2018$selene$camera$$camera = { position: _bind$5, limit_top: _bind$8, limit_bottom: _bind$6, limit_left: _bind$7, limit_right: _bind$9, attached_entity: _bind$10, offset: _bind$11, follow_x: true, follow_y: true };
const Milky2018$selene$system$$deferred_events = moonbitlang$core$array$$Array$new$46$inner$7$(0);
const Milky2018$selene$entity$$parents = moonbitlang$core$builtin$$Map$new$46$inner$8$(8);
const Milky2018$selene$examples$pixeladventure$$player_collision_layer = Milky2018$selene$collision$$CollisionLayer$new();
const Milky2018$selene$collision$$areas = moonbitlang$core$builtin$$Map$new$46$inner$9$(8);
const Milky2018$selene$sprite$$animation_generator = moonbitlang$core$ref$$Ref$new$10$(0);
const Milky2018$selene$backend$$audio_cache = moonbitlang$core$builtin$$Map$new$46$inner$11$(8);
const moonbitlang$core$double$$neg_infinity = moonbitlang$core$int64$$Int64$reinterpret_as_double($_4503599627370496L);
const moonbitlang$core$double$$infinity = moonbitlang$core$int64$$Int64$reinterpret_as_double($9218868437227405312L);
const Milky2018$selene$examples$pixeladventure$$terrain_collision_layer = Milky2018$selene$collision$$CollisionLayer$new();
const Milky2018$selene$collision$$collision_layers = moonbitlang$core$builtin$$Map$new$46$inner$12$(8);
const _p = 16;
const _p$2 = undefined;
const _tmp = { _0: "tileSize", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p, _p$2) };
const _p$3 = 58;
const _p$4 = undefined;
const _tmp$2 = { _0: "mapWidth", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3, _p$4) };
const _p$5 = 36;
const _p$6 = undefined;
const _tmp$3 = { _0: "mapHeight", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$5, _p$6) };
const _p$7 = "Bird";
const _tmp$4 = { _0: "name", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$7) };
const _p$8 = "29";
const _tmp$5 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$8) };
const _p$9 = 15;
const _p$10 = undefined;
const _tmp$6 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$9, _p$10) };
const _p$11 = 3;
const _p$12 = undefined;
const _bind$12 = [_tmp$5, _tmp$6, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$11, _p$12) }];
const _p$13 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$12, start: 0, end: 3 });
const _tmp$7 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$13);
const _p$14 = "30";
const _tmp$8 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$14) };
const _p$15 = 16;
const _p$16 = undefined;
const _tmp$9 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$15, _p$16) };
const _p$17 = 3;
const _p$18 = undefined;
const _bind$13 = [_tmp$8, _tmp$9, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$17, _p$18) }];
const _p$19 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$13, start: 0, end: 3 });
const _tmp$10 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$19);
const _p$20 = "31";
const _tmp$11 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$20) };
const _p$21 = 15;
const _p$22 = undefined;
const _tmp$12 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$21, _p$22) };
const _p$23 = 4;
const _p$24 = undefined;
const _bind$14 = [_tmp$11, _tmp$12, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$23, _p$24) }];
const _p$25 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$14, start: 0, end: 3 });
const _tmp$13 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$25);
const _p$26 = "32";
const _tmp$14 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$26) };
const _p$27 = 16;
const _p$28 = undefined;
const _tmp$15 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$27, _p$28) };
const _p$29 = 4;
const _p$30 = undefined;
const _bind$15 = [_tmp$14, _tmp$15, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$29, _p$30) }];
const _p$31 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$15, start: 0, end: 3 });
const _tmp$16 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$31);
const _p$32 = "29";
const _tmp$17 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$32) };
const _p$33 = 47;
const _p$34 = undefined;
const _tmp$18 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$33, _p$34) };
const _p$35 = 13;
const _p$36 = undefined;
const _bind$16 = [_tmp$17, _tmp$18, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$35, _p$36) }];
const _p$37 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$16, start: 0, end: 3 });
const _tmp$19 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$37);
const _p$38 = "30";
const _tmp$20 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$38) };
const _p$39 = 48;
const _p$40 = undefined;
const _tmp$21 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$39, _p$40) };
const _p$41 = 13;
const _p$42 = undefined;
const _bind$17 = [_tmp$20, _tmp$21, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$41, _p$42) }];
const _p$43 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$17, start: 0, end: 3 });
const _tmp$22 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$43);
const _p$44 = "31";
const _tmp$23 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$44) };
const _p$45 = 47;
const _p$46 = undefined;
const _tmp$24 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$45, _p$46) };
const _p$47 = 14;
const _p$48 = undefined;
const _bind$18 = [_tmp$23, _tmp$24, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$47, _p$48) }];
const _p$49 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$18, start: 0, end: 3 });
const _tmp$25 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$49);
const _p$50 = "32";
const _tmp$26 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$50) };
const _p$51 = 48;
const _p$52 = undefined;
const _tmp$27 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$51, _p$52) };
const _p$53 = 14;
const _p$54 = undefined;
const _bind$19 = [_tmp$26, _tmp$27, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$53, _p$54) }];
const _p$55 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$19, start: 0, end: 3 });
const _p$56 = [_tmp$7, _tmp$10, _tmp$13, _tmp$16, _tmp$19, _tmp$22, _tmp$25, new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$55)];
const _tmp$28 = { _0: "tiles", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Array(_p$56) };
const _p$57 = false;
const _bind$20 = [_tmp$4, _tmp$28, { _0: "collider", _1: _p$57 ? $64$moonbitlang$47$core$47$builtin$46$Json$True : $64$moonbitlang$47$core$47$builtin$46$Json$False }];
const _p$58 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$20, start: 0, end: 3 });
const _tmp$29 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$58);
const _p$59 = "MaskDude";
const _tmp$30 = { _0: "name", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$59) };
const _p$60 = "0";
const _tmp$31 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$60) };
const _p$61 = 5;
const _p$62 = undefined;
const _tmp$32 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$61, _p$62) };
const _p$63 = 31;
const _p$64 = undefined;
const _bind$21 = [_tmp$31, _tmp$32, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$63, _p$64) }];
const _p$65 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$21, start: 0, end: 3 });
const _tmp$33 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$65);
const _p$66 = "1";
const _tmp$34 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$66) };
const _p$67 = 6;
const _p$68 = undefined;
const _tmp$35 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$67, _p$68) };
const _p$69 = 31;
const _p$70 = undefined;
const _bind$22 = [_tmp$34, _tmp$35, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$69, _p$70) }];
const _p$71 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$22, start: 0, end: 3 });
const _tmp$36 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$71);
const _p$72 = "2";
const _tmp$37 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$72) };
const _p$73 = 5;
const _p$74 = undefined;
const _tmp$38 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$73, _p$74) };
const _p$75 = 32;
const _p$76 = undefined;
const _bind$23 = [_tmp$37, _tmp$38, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$75, _p$76) }];
const _p$77 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$23, start: 0, end: 3 });
const _tmp$39 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$77);
const _p$78 = "3";
const _tmp$40 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$78) };
const _p$79 = 6;
const _p$80 = undefined;
const _tmp$41 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$79, _p$80) };
const _p$81 = 32;
const _p$82 = undefined;
const _bind$24 = [_tmp$40, _tmp$41, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$81, _p$82) }];
const _p$83 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$24, start: 0, end: 3 });
const _p$84 = [_tmp$33, _tmp$36, _tmp$39, new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$83)];
const _tmp$42 = { _0: "tiles", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Array(_p$84) };
const _p$85 = false;
const _bind$25 = [_tmp$30, _tmp$42, { _0: "collider", _1: _p$85 ? $64$moonbitlang$47$core$47$builtin$46$Json$True : $64$moonbitlang$47$core$47$builtin$46$Json$False }];
const _p$86 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$25, start: 0, end: 3 });
const _tmp$43 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$86);
const _p$87 = "Apple";
const _tmp$44 = { _0: "name", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$87) };
const _p$88 = "17";
const _tmp$45 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$88) };
const _p$89 = 10;
const _p$90 = undefined;
const _tmp$46 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$89, _p$90) };
const _p$91 = 24;
const _p$92 = undefined;
const _bind$26 = [_tmp$45, _tmp$46, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$91, _p$92) }];
const _p$93 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$26, start: 0, end: 3 });
const _tmp$47 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$93);
const _p$94 = "18";
const _tmp$48 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$94) };
const _p$95 = 11;
const _p$96 = undefined;
const _tmp$49 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$95, _p$96) };
const _p$97 = 24;
const _p$98 = undefined;
const _bind$27 = [_tmp$48, _tmp$49, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$97, _p$98) }];
const _p$99 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$27, start: 0, end: 3 });
const _tmp$50 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$99);
const _p$100 = "19";
const _tmp$51 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$100) };
const _p$101 = 10;
const _p$102 = undefined;
const _tmp$52 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$101, _p$102) };
const _p$103 = 25;
const _p$104 = undefined;
const _bind$28 = [_tmp$51, _tmp$52, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$103, _p$104) }];
const _p$105 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$28, start: 0, end: 3 });
const _tmp$53 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$105);
const _p$106 = "20";
const _tmp$54 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$106) };
const _p$107 = 11;
const _p$108 = undefined;
const _tmp$55 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$107, _p$108) };
const _p$109 = 25;
const _p$110 = undefined;
const _bind$29 = [_tmp$54, _tmp$55, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$109, _p$110) }];
const _p$111 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$29, start: 0, end: 3 });
const _tmp$56 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$111);
const _p$112 = "17";
const _tmp$57 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$112) };
const _p$113 = 28;
const _p$114 = undefined;
const _tmp$58 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$113, _p$114) };
const _p$115 = 24;
const _p$116 = undefined;
const _bind$30 = [_tmp$57, _tmp$58, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$115, _p$116) }];
const _p$117 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$30, start: 0, end: 3 });
const _tmp$59 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$117);
const _p$118 = "18";
const _tmp$60 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$118) };
const _p$119 = 29;
const _p$120 = undefined;
const _tmp$61 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$119, _p$120) };
const _p$121 = 24;
const _p$122 = undefined;
const _bind$31 = [_tmp$60, _tmp$61, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$121, _p$122) }];
const _p$123 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$31, start: 0, end: 3 });
const _tmp$62 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$123);
const _p$124 = "19";
const _tmp$63 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$124) };
const _p$125 = 28;
const _p$126 = undefined;
const _tmp$64 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$125, _p$126) };
const _p$127 = 25;
const _p$128 = undefined;
const _bind$32 = [_tmp$63, _tmp$64, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$127, _p$128) }];
const _p$129 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$32, start: 0, end: 3 });
const _tmp$65 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$129);
const _p$130 = "20";
const _tmp$66 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$130) };
const _p$131 = 29;
const _p$132 = undefined;
const _tmp$67 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$131, _p$132) };
const _p$133 = 25;
const _p$134 = undefined;
const _bind$33 = [_tmp$66, _tmp$67, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$133, _p$134) }];
const _p$135 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$33, start: 0, end: 3 });
const _tmp$68 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$135);
const _p$136 = "17";
const _tmp$69 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$136) };
const _p$137 = 46;
const _p$138 = undefined;
const _tmp$70 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$137, _p$138) };
const _p$139 = 24;
const _p$140 = undefined;
const _bind$34 = [_tmp$69, _tmp$70, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$139, _p$140) }];
const _p$141 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$34, start: 0, end: 3 });
const _tmp$71 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$141);
const _p$142 = "18";
const _tmp$72 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$142) };
const _p$143 = 47;
const _p$144 = undefined;
const _tmp$73 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$143, _p$144) };
const _p$145 = 24;
const _p$146 = undefined;
const _bind$35 = [_tmp$72, _tmp$73, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$145, _p$146) }];
const _p$147 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$35, start: 0, end: 3 });
const _tmp$74 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$147);
const _p$148 = "19";
const _tmp$75 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$148) };
const _p$149 = 46;
const _p$150 = undefined;
const _tmp$76 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$149, _p$150) };
const _p$151 = 25;
const _p$152 = undefined;
const _bind$36 = [_tmp$75, _tmp$76, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$151, _p$152) }];
const _p$153 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$36, start: 0, end: 3 });
const _tmp$77 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$153);
const _p$154 = "20";
const _tmp$78 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$154) };
const _p$155 = 47;
const _p$156 = undefined;
const _tmp$79 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$155, _p$156) };
const _p$157 = 25;
const _p$158 = undefined;
const _bind$37 = [_tmp$78, _tmp$79, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$157, _p$158) }];
const _p$159 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$37, start: 0, end: 3 });
const _tmp$80 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$159);
const _p$160 = "17";
const _tmp$81 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$160) };
const _p$161 = 53;
const _p$162 = undefined;
const _tmp$82 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$161, _p$162) };
const _p$163 = 31;
const _p$164 = undefined;
const _bind$38 = [_tmp$81, _tmp$82, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$163, _p$164) }];
const _p$165 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$38, start: 0, end: 3 });
const _tmp$83 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$165);
const _p$166 = "18";
const _tmp$84 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$166) };
const _p$167 = 54;
const _p$168 = undefined;
const _tmp$85 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$167, _p$168) };
const _p$169 = 31;
const _p$170 = undefined;
const _bind$39 = [_tmp$84, _tmp$85, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$169, _p$170) }];
const _p$171 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$39, start: 0, end: 3 });
const _tmp$86 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$171);
const _p$172 = "19";
const _tmp$87 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$172) };
const _p$173 = 53;
const _p$174 = undefined;
const _tmp$88 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$173, _p$174) };
const _p$175 = 32;
const _p$176 = undefined;
const _bind$40 = [_tmp$87, _tmp$88, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$175, _p$176) }];
const _p$177 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$40, start: 0, end: 3 });
const _tmp$89 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$177);
const _p$178 = "20";
const _tmp$90 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$178) };
const _p$179 = 54;
const _p$180 = undefined;
const _tmp$91 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$179, _p$180) };
const _p$181 = 32;
const _p$182 = undefined;
const _bind$41 = [_tmp$90, _tmp$91, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$181, _p$182) }];
const _p$183 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$41, start: 0, end: 3 });
const _tmp$92 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$183);
const _p$184 = "17";
const _tmp$93 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$184) };
const _p$185 = 19;
const _p$186 = undefined;
const _tmp$94 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$185, _p$186) };
const _p$187 = 6;
const _p$188 = undefined;
const _bind$42 = [_tmp$93, _tmp$94, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$187, _p$188) }];
const _p$189 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$42, start: 0, end: 3 });
const _tmp$95 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$189);
const _p$190 = "18";
const _tmp$96 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$190) };
const _p$191 = 20;
const _p$192 = undefined;
const _tmp$97 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$191, _p$192) };
const _p$193 = 6;
const _p$194 = undefined;
const _bind$43 = [_tmp$96, _tmp$97, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$193, _p$194) }];
const _p$195 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$43, start: 0, end: 3 });
const _tmp$98 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$195);
const _p$196 = "19";
const _tmp$99 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$196) };
const _p$197 = 19;
const _p$198 = undefined;
const _tmp$100 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$197, _p$198) };
const _p$199 = 7;
const _p$200 = undefined;
const _bind$44 = [_tmp$99, _tmp$100, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$199, _p$200) }];
const _p$201 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$44, start: 0, end: 3 });
const _tmp$101 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$201);
const _p$202 = "20";
const _tmp$102 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$202) };
const _p$203 = 20;
const _p$204 = undefined;
const _tmp$103 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$203, _p$204) };
const _p$205 = 7;
const _p$206 = undefined;
const _bind$45 = [_tmp$102, _tmp$103, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$205, _p$206) }];
const _p$207 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$45, start: 0, end: 3 });
const _tmp$104 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$207);
const _p$208 = "17";
const _tmp$105 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$208) };
const _p$209 = 53;
const _p$210 = undefined;
const _tmp$106 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$209, _p$210) };
const _p$211 = 13;
const _p$212 = undefined;
const _bind$46 = [_tmp$105, _tmp$106, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$211, _p$212) }];
const _p$213 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$46, start: 0, end: 3 });
const _tmp$107 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$213);
const _p$214 = "18";
const _tmp$108 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$214) };
const _p$215 = 54;
const _p$216 = undefined;
const _tmp$109 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$215, _p$216) };
const _p$217 = 13;
const _p$218 = undefined;
const _bind$47 = [_tmp$108, _tmp$109, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$217, _p$218) }];
const _p$219 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$47, start: 0, end: 3 });
const _tmp$110 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$219);
const _p$220 = "19";
const _tmp$111 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$220) };
const _p$221 = 53;
const _p$222 = undefined;
const _tmp$112 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$221, _p$222) };
const _p$223 = 14;
const _p$224 = undefined;
const _bind$48 = [_tmp$111, _tmp$112, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$223, _p$224) }];
const _p$225 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$48, start: 0, end: 3 });
const _tmp$113 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$225);
const _p$226 = "20";
const _tmp$114 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$226) };
const _p$227 = 54;
const _p$228 = undefined;
const _tmp$115 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$227, _p$228) };
const _p$229 = 14;
const _p$230 = undefined;
const _bind$49 = [_tmp$114, _tmp$115, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$229, _p$230) }];
const _p$231 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$49, start: 0, end: 3 });
const _tmp$116 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$231);
const _p$232 = "17";
const _tmp$117 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$232) };
const _p$233 = 28;
const _p$234 = undefined;
const _tmp$118 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$233, _p$234) };
const _p$235 = 13;
const _p$236 = undefined;
const _bind$50 = [_tmp$117, _tmp$118, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$235, _p$236) }];
const _p$237 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$50, start: 0, end: 3 });
const _tmp$119 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$237);
const _p$238 = "18";
const _tmp$120 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$238) };
const _p$239 = 29;
const _p$240 = undefined;
const _tmp$121 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$239, _p$240) };
const _p$241 = 13;
const _p$242 = undefined;
const _bind$51 = [_tmp$120, _tmp$121, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$241, _p$242) }];
const _p$243 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$51, start: 0, end: 3 });
const _tmp$122 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$243);
const _p$244 = "19";
const _tmp$123 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$244) };
const _p$245 = 28;
const _p$246 = undefined;
const _tmp$124 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$245, _p$246) };
const _p$247 = 14;
const _p$248 = undefined;
const _bind$52 = [_tmp$123, _tmp$124, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$247, _p$248) }];
const _p$249 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$52, start: 0, end: 3 });
const _tmp$125 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$249);
const _p$250 = "20";
const _tmp$126 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$250) };
const _p$251 = 29;
const _p$252 = undefined;
const _tmp$127 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$251, _p$252) };
const _p$253 = 14;
const _p$254 = undefined;
const _bind$53 = [_tmp$126, _tmp$127, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$253, _p$254) }];
const _p$255 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$53, start: 0, end: 3 });
const _p$256 = [_tmp$47, _tmp$50, _tmp$53, _tmp$56, _tmp$59, _tmp$62, _tmp$65, _tmp$68, _tmp$71, _tmp$74, _tmp$77, _tmp$80, _tmp$83, _tmp$86, _tmp$89, _tmp$92, _tmp$95, _tmp$98, _tmp$101, _tmp$104, _tmp$107, _tmp$110, _tmp$113, _tmp$116, _tmp$119, _tmp$122, _tmp$125, new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$255)];
const _tmp$128 = { _0: "tiles", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Array(_p$256) };
const _p$257 = false;
const _bind$54 = [_tmp$44, _tmp$128, { _0: "collider", _1: _p$257 ? $64$moonbitlang$47$core$47$builtin$46$Json$True : $64$moonbitlang$47$core$47$builtin$46$Json$False }];
const _p$258 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$54, start: 0, end: 3 });
const _tmp$129 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$258);
const _p$259 = "Flag";
const _tmp$130 = { _0: "name", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$259) };
const _p$260 = "22";
const _tmp$131 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$260) };
const _p$261 = 5;
const _p$262 = undefined;
const _tmp$132 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$261, _p$262) };
const _p$263 = 6;
const _p$264 = undefined;
const _bind$55 = [_tmp$131, _tmp$132, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$263, _p$264) }];
const _p$265 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$55, start: 0, end: 3 });
const _tmp$133 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$265);
const _p$266 = "23";
const _tmp$134 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$266) };
const _p$267 = 6;
const _p$268 = undefined;
const _tmp$135 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$267, _p$268) };
const _p$269 = 6;
const _p$270 = undefined;
const _bind$56 = [_tmp$134, _tmp$135, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$269, _p$270) }];
const _p$271 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$56, start: 0, end: 3 });
const _tmp$136 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$271);
const _p$272 = "25";
const _tmp$137 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$272) };
const _p$273 = 5;
const _p$274 = undefined;
const _tmp$138 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$273, _p$274) };
const _p$275 = 7;
const _p$276 = undefined;
const _bind$57 = [_tmp$137, _tmp$138, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$275, _p$276) }];
const _p$277 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$57, start: 0, end: 3 });
const _tmp$139 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$277);
const _p$278 = "26";
const _tmp$140 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$278) };
const _p$279 = 6;
const _p$280 = undefined;
const _tmp$141 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$279, _p$280) };
const _p$281 = 7;
const _p$282 = undefined;
const _bind$58 = [_tmp$140, _tmp$141, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$281, _p$282) }];
const _p$283 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$58, start: 0, end: 3 });
const _tmp$142 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$283);
const _p$284 = "28";
const _tmp$143 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$284) };
const _p$285 = 5;
const _p$286 = undefined;
const _tmp$144 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$285, _p$286) };
const _p$287 = 8;
const _p$288 = undefined;
const _bind$59 = [_tmp$143, _tmp$144, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$287, _p$288) }];
const _p$289 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$59, start: 0, end: 3 });
const _tmp$145 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$289);
const _p$290 = "21";
const _tmp$146 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$290) };
const _p$291 = 6;
const _p$292 = undefined;
const _tmp$147 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$291, _p$292) };
const _p$293 = 8;
const _p$294 = undefined;
const _bind$60 = [_tmp$146, _tmp$147, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$293, _p$294) }];
const _p$295 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$60, start: 0, end: 3 });
const _p$296 = [_tmp$133, _tmp$136, _tmp$139, _tmp$142, _tmp$145, new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$295)];
const _tmp$148 = { _0: "tiles", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Array(_p$296) };
const _p$297 = false;
const _bind$61 = [_tmp$130, _tmp$148, { _0: "collider", _1: _p$297 ? $64$moonbitlang$47$core$47$builtin$46$Json$True : $64$moonbitlang$47$core$47$builtin$46$Json$False }];
const _p$298 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$61, start: 0, end: 3 });
const _tmp$149 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$298);
const _p$299 = "Grass";
const _tmp$150 = { _0: "name", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$299) };
const _p$300 = "11";
const _tmp$151 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$300) };
const _p$301 = 0;
const _p$302 = undefined;
const _tmp$152 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$301, _p$302) };
const _p$303 = 4;
const _p$304 = undefined;
const _bind$62 = [_tmp$151, _tmp$152, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$303, _p$304) }];
const _p$305 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$62, start: 0, end: 3 });
const _tmp$153 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$305);
const _p$306 = "10";
const _tmp$154 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$306) };
const _p$307 = 2;
const _p$308 = undefined;
const _tmp$155 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$307, _p$308) };
const _p$309 = 4;
const _p$310 = undefined;
const _bind$63 = [_tmp$154, _tmp$155, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$309, _p$310) }];
const _p$311 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$63, start: 0, end: 3 });
const _tmp$156 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$311);
const _p$312 = "11";
const _tmp$157 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$312) };
const _p$313 = 0;
const _p$314 = undefined;
const _tmp$158 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$313, _p$314) };
const _p$315 = 5;
const _p$316 = undefined;
const _bind$64 = [_tmp$157, _tmp$158, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$315, _p$316) }];
const _p$317 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$64, start: 0, end: 3 });
const _tmp$159 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$317);
const _p$318 = "10";
const _tmp$160 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$318) };
const _p$319 = 2;
const _p$320 = undefined;
const _tmp$161 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$319, _p$320) };
const _p$321 = 5;
const _p$322 = undefined;
const _bind$65 = [_tmp$160, _tmp$161, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$321, _p$322) }];
const _p$323 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$65, start: 0, end: 3 });
const _tmp$162 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$323);
const _p$324 = "11";
const _tmp$163 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$324) };
const _p$325 = 0;
const _p$326 = undefined;
const _tmp$164 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$325, _p$326) };
const _p$327 = 6;
const _p$328 = undefined;
const _bind$66 = [_tmp$163, _tmp$164, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$327, _p$328) }];
const _p$329 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$66, start: 0, end: 3 });
const _tmp$165 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$329);
const _p$330 = "11";
const _tmp$166 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$330) };
const _p$331 = 0;
const _p$332 = undefined;
const _tmp$167 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$331, _p$332) };
const _p$333 = 7;
const _p$334 = undefined;
const _bind$67 = [_tmp$166, _tmp$167, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$333, _p$334) }];
const _p$335 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$67, start: 0, end: 3 });
const _tmp$168 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$335);
const _p$336 = "11";
const _tmp$169 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$336) };
const _p$337 = 0;
const _p$338 = undefined;
const _tmp$170 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$337, _p$338) };
const _p$339 = 8;
const _p$340 = undefined;
const _bind$68 = [_tmp$169, _tmp$170, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$339, _p$340) }];
const _p$341 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$68, start: 0, end: 3 });
const _tmp$171 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$341);
const _p$342 = "11";
const _tmp$172 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$342) };
const _p$343 = 0;
const _p$344 = undefined;
const _tmp$173 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$343, _p$344) };
const _p$345 = 9;
const _p$346 = undefined;
const _bind$69 = [_tmp$172, _tmp$173, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$345, _p$346) }];
const _p$347 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$69, start: 0, end: 3 });
const _tmp$174 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$347);
const _p$348 = "11";
const _tmp$175 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$348) };
const _p$349 = 0;
const _p$350 = undefined;
const _tmp$176 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$349, _p$350) };
const _p$351 = 10;
const _p$352 = undefined;
const _bind$70 = [_tmp$175, _tmp$176, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$351, _p$352) }];
const _p$353 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$70, start: 0, end: 3 });
const _tmp$177 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$353);
const _p$354 = "11";
const _tmp$178 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$354) };
const _p$355 = 0;
const _p$356 = undefined;
const _tmp$179 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$355, _p$356) };
const _p$357 = 11;
const _p$358 = undefined;
const _bind$71 = [_tmp$178, _tmp$179, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$357, _p$358) }];
const _p$359 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$71, start: 0, end: 3 });
const _tmp$180 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$359);
const _p$360 = "11";
const _tmp$181 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$360) };
const _p$361 = 0;
const _p$362 = undefined;
const _tmp$182 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$361, _p$362) };
const _p$363 = 12;
const _p$364 = undefined;
const _bind$72 = [_tmp$181, _tmp$182, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$363, _p$364) }];
const _p$365 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$72, start: 0, end: 3 });
const _tmp$183 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$365);
const _p$366 = "11";
const _tmp$184 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$366) };
const _p$367 = 0;
const _p$368 = undefined;
const _tmp$185 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$367, _p$368) };
const _p$369 = 13;
const _p$370 = undefined;
const _bind$73 = [_tmp$184, _tmp$185, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$369, _p$370) }];
const _p$371 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$73, start: 0, end: 3 });
const _tmp$186 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$371);
const _p$372 = "11";
const _tmp$187 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$372) };
const _p$373 = 0;
const _p$374 = undefined;
const _tmp$188 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$373, _p$374) };
const _p$375 = 14;
const _p$376 = undefined;
const _bind$74 = [_tmp$187, _tmp$188, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$375, _p$376) }];
const _p$377 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$74, start: 0, end: 3 });
const _tmp$189 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$377);
const _p$378 = "11";
const _tmp$190 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$378) };
const _p$379 = 0;
const _p$380 = undefined;
const _tmp$191 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$379, _p$380) };
const _p$381 = 15;
const _p$382 = undefined;
const _bind$75 = [_tmp$190, _tmp$191, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$381, _p$382) }];
const _p$383 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$75, start: 0, end: 3 });
const _tmp$192 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$383);
const _p$384 = "11";
const _tmp$193 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$384) };
const _p$385 = 0;
const _p$386 = undefined;
const _tmp$194 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$385, _p$386) };
const _p$387 = 16;
const _p$388 = undefined;
const _bind$76 = [_tmp$193, _tmp$194, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$387, _p$388) }];
const _p$389 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$76, start: 0, end: 3 });
const _tmp$195 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$389);
const _p$390 = "11";
const _tmp$196 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$390) };
const _p$391 = 0;
const _p$392 = undefined;
const _tmp$197 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$391, _p$392) };
const _p$393 = 17;
const _p$394 = undefined;
const _bind$77 = [_tmp$196, _tmp$197, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$393, _p$394) }];
const _p$395 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$77, start: 0, end: 3 });
const _tmp$198 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$395);
const _p$396 = "11";
const _tmp$199 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$396) };
const _p$397 = 0;
const _p$398 = undefined;
const _tmp$200 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$397, _p$398) };
const _p$399 = 18;
const _p$400 = undefined;
const _bind$78 = [_tmp$199, _tmp$200, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$399, _p$400) }];
const _p$401 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$78, start: 0, end: 3 });
const _tmp$201 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$401);
const _p$402 = "11";
const _tmp$202 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$402) };
const _p$403 = 0;
const _p$404 = undefined;
const _tmp$203 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$403, _p$404) };
const _p$405 = 19;
const _p$406 = undefined;
const _bind$79 = [_tmp$202, _tmp$203, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$405, _p$406) }];
const _p$407 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$79, start: 0, end: 3 });
const _tmp$204 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$407);
const _p$408 = "11";
const _tmp$205 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$408) };
const _p$409 = 0;
const _p$410 = undefined;
const _tmp$206 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$409, _p$410) };
const _p$411 = 20;
const _p$412 = undefined;
const _bind$80 = [_tmp$205, _tmp$206, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$411, _p$412) }];
const _p$413 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$80, start: 0, end: 3 });
const _tmp$207 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$413);
const _p$414 = "11";
const _tmp$208 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$414) };
const _p$415 = 0;
const _p$416 = undefined;
const _tmp$209 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$415, _p$416) };
const _p$417 = 21;
const _p$418 = undefined;
const _bind$81 = [_tmp$208, _tmp$209, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$417, _p$418) }];
const _p$419 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$81, start: 0, end: 3 });
const _tmp$210 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$419);
const _p$420 = "11";
const _tmp$211 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$420) };
const _p$421 = 0;
const _p$422 = undefined;
const _tmp$212 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$421, _p$422) };
const _p$423 = 22;
const _p$424 = undefined;
const _bind$82 = [_tmp$211, _tmp$212, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$423, _p$424) }];
const _p$425 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$82, start: 0, end: 3 });
const _tmp$213 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$425);
const _p$426 = "11";
const _tmp$214 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$426) };
const _p$427 = 0;
const _p$428 = undefined;
const _tmp$215 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$427, _p$428) };
const _p$429 = 23;
const _p$430 = undefined;
const _bind$83 = [_tmp$214, _tmp$215, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$429, _p$430) }];
const _p$431 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$83, start: 0, end: 3 });
const _tmp$216 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$431);
const _p$432 = "11";
const _tmp$217 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$432) };
const _p$433 = 0;
const _p$434 = undefined;
const _tmp$218 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$433, _p$434) };
const _p$435 = 24;
const _p$436 = undefined;
const _bind$84 = [_tmp$217, _tmp$218, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$435, _p$436) }];
const _p$437 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$84, start: 0, end: 3 });
const _tmp$219 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$437);
const _p$438 = "11";
const _tmp$220 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$438) };
const _p$439 = 0;
const _p$440 = undefined;
const _tmp$221 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$439, _p$440) };
const _p$441 = 25;
const _p$442 = undefined;
const _bind$85 = [_tmp$220, _tmp$221, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$441, _p$442) }];
const _p$443 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$85, start: 0, end: 3 });
const _tmp$222 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$443);
const _p$444 = "11";
const _tmp$223 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$444) };
const _p$445 = 0;
const _p$446 = undefined;
const _tmp$224 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$445, _p$446) };
const _p$447 = 26;
const _p$448 = undefined;
const _bind$86 = [_tmp$223, _tmp$224, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$447, _p$448) }];
const _p$449 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$86, start: 0, end: 3 });
const _tmp$225 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$449);
const _p$450 = "11";
const _tmp$226 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$450) };
const _p$451 = 0;
const _p$452 = undefined;
const _tmp$227 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$451, _p$452) };
const _p$453 = 27;
const _p$454 = undefined;
const _bind$87 = [_tmp$226, _tmp$227, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$453, _p$454) }];
const _p$455 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$87, start: 0, end: 3 });
const _tmp$228 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$455);
const _p$456 = "11";
const _tmp$229 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$456) };
const _p$457 = 0;
const _p$458 = undefined;
const _tmp$230 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$457, _p$458) };
const _p$459 = 28;
const _p$460 = undefined;
const _bind$88 = [_tmp$229, _tmp$230, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$459, _p$460) }];
const _p$461 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$88, start: 0, end: 3 });
const _tmp$231 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$461);
const _p$462 = "11";
const _tmp$232 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$462) };
const _p$463 = 0;
const _p$464 = undefined;
const _tmp$233 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$463, _p$464) };
const _p$465 = 29;
const _p$466 = undefined;
const _bind$89 = [_tmp$232, _tmp$233, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$465, _p$466) }];
const _p$467 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$89, start: 0, end: 3 });
const _tmp$234 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$467);
const _p$468 = "11";
const _tmp$235 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$468) };
const _p$469 = 0;
const _p$470 = undefined;
const _tmp$236 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$469, _p$470) };
const _p$471 = 30;
const _p$472 = undefined;
const _bind$90 = [_tmp$235, _tmp$236, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$471, _p$472) }];
const _p$473 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$90, start: 0, end: 3 });
const _tmp$237 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$473);
const _p$474 = "11";
const _tmp$238 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$474) };
const _p$475 = 0;
const _p$476 = undefined;
const _tmp$239 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$475, _p$476) };
const _p$477 = 31;
const _p$478 = undefined;
const _bind$91 = [_tmp$238, _tmp$239, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$477, _p$478) }];
const _p$479 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$91, start: 0, end: 3 });
const _tmp$240 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$479);
const _p$480 = "13";
const _tmp$241 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$480) };
const _p$481 = 1;
const _p$482 = undefined;
const _tmp$242 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$481, _p$482) };
const _p$483 = 4;
const _p$484 = undefined;
const _bind$92 = [_tmp$241, _tmp$242, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$483, _p$484) }];
const _p$485 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$92, start: 0, end: 3 });
const _tmp$243 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$485);
const _p$486 = "13";
const _tmp$244 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$486) };
const _p$487 = 1;
const _p$488 = undefined;
const _tmp$245 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$487, _p$488) };
const _p$489 = 5;
const _p$490 = undefined;
const _bind$93 = [_tmp$244, _tmp$245, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$489, _p$490) }];
const _p$491 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$93, start: 0, end: 3 });
const _tmp$246 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$491);
const _p$492 = "13";
const _tmp$247 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$492) };
const _p$493 = 1;
const _p$494 = undefined;
const _tmp$248 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$493, _p$494) };
const _p$495 = 12;
const _p$496 = undefined;
const _bind$94 = [_tmp$247, _tmp$248, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$495, _p$496) }];
const _p$497 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$94, start: 0, end: 3 });
const _tmp$249 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$497);
const _p$498 = "13";
const _tmp$250 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$498) };
const _p$499 = 1;
const _p$500 = undefined;
const _tmp$251 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$499, _p$500) };
const _p$501 = 13;
const _p$502 = undefined;
const _bind$95 = [_tmp$250, _tmp$251, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$501, _p$502) }];
const _p$503 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$95, start: 0, end: 3 });
const _tmp$252 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$503);
const _p$504 = "13";
const _tmp$253 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$504) };
const _p$505 = 1;
const _p$506 = undefined;
const _tmp$254 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$505, _p$506) };
const _p$507 = 14;
const _p$508 = undefined;
const _bind$96 = [_tmp$253, _tmp$254, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$507, _p$508) }];
const _p$509 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$96, start: 0, end: 3 });
const _tmp$255 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$509);
const _p$510 = "13";
const _tmp$256 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$510) };
const _p$511 = 1;
const _p$512 = undefined;
const _tmp$257 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$511, _p$512) };
const _p$513 = 15;
const _p$514 = undefined;
const _bind$97 = [_tmp$256, _tmp$257, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$513, _p$514) }];
const _p$515 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$97, start: 0, end: 3 });
const _tmp$258 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$515);
const _p$516 = "13";
const _tmp$259 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$516) };
const _p$517 = 1;
const _p$518 = undefined;
const _tmp$260 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$517, _p$518) };
const _p$519 = 16;
const _p$520 = undefined;
const _bind$98 = [_tmp$259, _tmp$260, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$519, _p$520) }];
const _p$521 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$98, start: 0, end: 3 });
const _tmp$261 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$521);
const _p$522 = "13";
const _tmp$262 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$522) };
const _p$523 = 1;
const _p$524 = undefined;
const _tmp$263 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$523, _p$524) };
const _p$525 = 17;
const _p$526 = undefined;
const _bind$99 = [_tmp$262, _tmp$263, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$525, _p$526) }];
const _p$527 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$99, start: 0, end: 3 });
const _tmp$264 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$527);
const _p$528 = "13";
const _tmp$265 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$528) };
const _p$529 = 1;
const _p$530 = undefined;
const _tmp$266 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$529, _p$530) };
const _p$531 = 18;
const _p$532 = undefined;
const _bind$100 = [_tmp$265, _tmp$266, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$531, _p$532) }];
const _p$533 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$100, start: 0, end: 3 });
const _tmp$267 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$533);
const _p$534 = "13";
const _tmp$268 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$534) };
const _p$535 = 1;
const _p$536 = undefined;
const _tmp$269 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$535, _p$536) };
const _p$537 = 19;
const _p$538 = undefined;
const _bind$101 = [_tmp$268, _tmp$269, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$537, _p$538) }];
const _p$539 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$101, start: 0, end: 3 });
const _tmp$270 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$539);
const _p$540 = "13";
const _tmp$271 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$540) };
const _p$541 = 1;
const _p$542 = undefined;
const _tmp$272 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$541, _p$542) };
const _p$543 = 20;
const _p$544 = undefined;
const _bind$102 = [_tmp$271, _tmp$272, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$543, _p$544) }];
const _p$545 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$102, start: 0, end: 3 });
const _tmp$273 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$545);
const _p$546 = "13";
const _tmp$274 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$546) };
const _p$547 = 1;
const _p$548 = undefined;
const _tmp$275 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$547, _p$548) };
const _p$549 = 21;
const _p$550 = undefined;
const _bind$103 = [_tmp$274, _tmp$275, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$549, _p$550) }];
const _p$551 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$103, start: 0, end: 3 });
const _tmp$276 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$551);
const _p$552 = "13";
const _tmp$277 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$552) };
const _p$553 = 1;
const _p$554 = undefined;
const _tmp$278 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$553, _p$554) };
const _p$555 = 22;
const _p$556 = undefined;
const _bind$104 = [_tmp$277, _tmp$278, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$555, _p$556) }];
const _p$557 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$104, start: 0, end: 3 });
const _tmp$279 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$557);
const _p$558 = "13";
const _tmp$280 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$558) };
const _p$559 = 1;
const _p$560 = undefined;
const _tmp$281 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$559, _p$560) };
const _p$561 = 23;
const _p$562 = undefined;
const _bind$105 = [_tmp$280, _tmp$281, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$561, _p$562) }];
const _p$563 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$105, start: 0, end: 3 });
const _tmp$282 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$563);
const _p$564 = "13";
const _tmp$283 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$564) };
const _p$565 = 1;
const _p$566 = undefined;
const _tmp$284 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$565, _p$566) };
const _p$567 = 24;
const _p$568 = undefined;
const _bind$106 = [_tmp$283, _tmp$284, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$567, _p$568) }];
const _p$569 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$106, start: 0, end: 3 });
const _tmp$285 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$569);
const _p$570 = "13";
const _tmp$286 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$570) };
const _p$571 = 1;
const _p$572 = undefined;
const _tmp$287 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$571, _p$572) };
const _p$573 = 25;
const _p$574 = undefined;
const _bind$107 = [_tmp$286, _tmp$287, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$573, _p$574) }];
const _p$575 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$107, start: 0, end: 3 });
const _tmp$288 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$575);
const _p$576 = "13";
const _tmp$289 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$576) };
const _p$577 = 1;
const _p$578 = undefined;
const _tmp$290 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$577, _p$578) };
const _p$579 = 26;
const _p$580 = undefined;
const _bind$108 = [_tmp$289, _tmp$290, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$579, _p$580) }];
const _p$581 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$108, start: 0, end: 3 });
const _tmp$291 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$581);
const _p$582 = "13";
const _tmp$292 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$582) };
const _p$583 = 1;
const _p$584 = undefined;
const _tmp$293 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$583, _p$584) };
const _p$585 = 27;
const _p$586 = undefined;
const _bind$109 = [_tmp$292, _tmp$293, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$585, _p$586) }];
const _p$587 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$109, start: 0, end: 3 });
const _tmp$294 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$587);
const _p$588 = "13";
const _tmp$295 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$588) };
const _p$589 = 1;
const _p$590 = undefined;
const _tmp$296 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$589, _p$590) };
const _p$591 = 28;
const _p$592 = undefined;
const _bind$110 = [_tmp$295, _tmp$296, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$591, _p$592) }];
const _p$593 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$110, start: 0, end: 3 });
const _tmp$297 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$593);
const _p$594 = "13";
const _tmp$298 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$594) };
const _p$595 = 1;
const _p$596 = undefined;
const _tmp$299 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$595, _p$596) };
const _p$597 = 29;
const _p$598 = undefined;
const _bind$111 = [_tmp$298, _tmp$299, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$597, _p$598) }];
const _p$599 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$111, start: 0, end: 3 });
const _tmp$300 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$599);
const _p$600 = "13";
const _tmp$301 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$600) };
const _p$601 = 1;
const _p$602 = undefined;
const _tmp$302 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$601, _p$602) };
const _p$603 = 30;
const _p$604 = undefined;
const _bind$112 = [_tmp$301, _tmp$302, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$603, _p$604) }];
const _p$605 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$112, start: 0, end: 3 });
const _tmp$303 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$605);
const _p$606 = "13";
const _tmp$304 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$606) };
const _p$607 = 1;
const _p$608 = undefined;
const _tmp$305 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$607, _p$608) };
const _p$609 = 31;
const _p$610 = undefined;
const _bind$113 = [_tmp$304, _tmp$305, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$609, _p$610) }];
const _p$611 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$113, start: 0, end: 3 });
const _tmp$306 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$611);
const _p$612 = "11";
const _tmp$307 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$612) };
const _p$613 = 0;
const _p$614 = undefined;
const _tmp$308 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$613, _p$614) };
const _p$615 = 32;
const _p$616 = undefined;
const _bind$114 = [_tmp$307, _tmp$308, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$615, _p$616) }];
const _p$617 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$114, start: 0, end: 3 });
const _tmp$309 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$617);
const _p$618 = "13";
const _tmp$310 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$618) };
const _p$619 = 1;
const _p$620 = undefined;
const _tmp$311 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$619, _p$620) };
const _p$621 = 32;
const _p$622 = undefined;
const _bind$115 = [_tmp$310, _tmp$311, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$621, _p$622) }];
const _p$623 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$115, start: 0, end: 3 });
const _tmp$312 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$623);
const _p$624 = "11";
const _tmp$313 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$624) };
const _p$625 = 0;
const _p$626 = undefined;
const _tmp$314 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$625, _p$626) };
const _p$627 = 33;
const _p$628 = undefined;
const _bind$116 = [_tmp$313, _tmp$314, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$627, _p$628) }];
const _p$629 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$116, start: 0, end: 3 });
const _tmp$315 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$629);
const _p$630 = "13";
const _tmp$316 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$630) };
const _p$631 = 1;
const _p$632 = undefined;
const _tmp$317 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$631, _p$632) };
const _p$633 = 33;
const _p$634 = undefined;
const _bind$117 = [_tmp$316, _tmp$317, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$633, _p$634) }];
const _p$635 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$117, start: 0, end: 3 });
const _tmp$318 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$635);
const _p$636 = "11";
const _tmp$319 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$636) };
const _p$637 = 0;
const _p$638 = undefined;
const _tmp$320 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$637, _p$638) };
const _p$639 = 34;
const _p$640 = undefined;
const _bind$118 = [_tmp$319, _tmp$320, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$639, _p$640) }];
const _p$641 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$118, start: 0, end: 3 });
const _tmp$321 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$641);
const _p$642 = "14";
const _tmp$322 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$642) };
const _p$643 = 0;
const _p$644 = undefined;
const _tmp$323 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$643, _p$644) };
const _p$645 = 35;
const _p$646 = undefined;
const _bind$119 = [_tmp$322, _tmp$323, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$645, _p$646) }];
const _p$647 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$119, start: 0, end: 3 });
const _tmp$324 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$647);
const _p$648 = "8";
const _tmp$325 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$648) };
const _p$649 = 1;
const _p$650 = undefined;
const _tmp$326 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$649, _p$650) };
const _p$651 = 35;
const _p$652 = undefined;
const _bind$120 = [_tmp$325, _tmp$326, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$651, _p$652) }];
const _p$653 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$120, start: 0, end: 3 });
const _tmp$327 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$653);
const _p$654 = "8";
const _tmp$328 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$654) };
const _p$655 = 2;
const _p$656 = undefined;
const _tmp$329 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$655, _p$656) };
const _p$657 = 35;
const _p$658 = undefined;
const _bind$121 = [_tmp$328, _tmp$329, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$657, _p$658) }];
const _p$659 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$121, start: 0, end: 3 });
const _tmp$330 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$659);
const _p$660 = "8";
const _tmp$331 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$660) };
const _p$661 = 3;
const _p$662 = undefined;
const _tmp$332 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$661, _p$662) };
const _p$663 = 35;
const _p$664 = undefined;
const _bind$122 = [_tmp$331, _tmp$332, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$663, _p$664) }];
const _p$665 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$122, start: 0, end: 3 });
const _tmp$333 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$665);
const _p$666 = "8";
const _tmp$334 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$666) };
const _p$667 = 4;
const _p$668 = undefined;
const _tmp$335 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$667, _p$668) };
const _p$669 = 35;
const _p$670 = undefined;
const _bind$123 = [_tmp$334, _tmp$335, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$669, _p$670) }];
const _p$671 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$123, start: 0, end: 3 });
const _tmp$336 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$671);
const _p$672 = "8";
const _tmp$337 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$672) };
const _p$673 = 5;
const _p$674 = undefined;
const _tmp$338 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$673, _p$674) };
const _p$675 = 35;
const _p$676 = undefined;
const _bind$124 = [_tmp$337, _tmp$338, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$675, _p$676) }];
const _p$677 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$124, start: 0, end: 3 });
const _tmp$339 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$677);
const _p$678 = "8";
const _tmp$340 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$678) };
const _p$679 = 6;
const _p$680 = undefined;
const _tmp$341 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$679, _p$680) };
const _p$681 = 35;
const _p$682 = undefined;
const _bind$125 = [_tmp$340, _tmp$341, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$681, _p$682) }];
const _p$683 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$125, start: 0, end: 3 });
const _tmp$342 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$683);
const _p$684 = "8";
const _tmp$343 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$684) };
const _p$685 = 7;
const _p$686 = undefined;
const _tmp$344 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$685, _p$686) };
const _p$687 = 35;
const _p$688 = undefined;
const _bind$126 = [_tmp$343, _tmp$344, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$687, _p$688) }];
const _p$689 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$126, start: 0, end: 3 });
const _tmp$345 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$689);
const _p$690 = "8";
const _tmp$346 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$690) };
const _p$691 = 8;
const _p$692 = undefined;
const _tmp$347 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$691, _p$692) };
const _p$693 = 35;
const _p$694 = undefined;
const _bind$127 = [_tmp$346, _tmp$347, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$693, _p$694) }];
const _p$695 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$127, start: 0, end: 3 });
const _tmp$348 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$695);
const _p$696 = "8";
const _tmp$349 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$696) };
const _p$697 = 9;
const _p$698 = undefined;
const _tmp$350 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$697, _p$698) };
const _p$699 = 35;
const _p$700 = undefined;
const _bind$128 = [_tmp$349, _tmp$350, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$699, _p$700) }];
const _p$701 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$128, start: 0, end: 3 });
const _tmp$351 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$701);
const _p$702 = "8";
const _tmp$352 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$702) };
const _p$703 = 10;
const _p$704 = undefined;
const _tmp$353 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$703, _p$704) };
const _p$705 = 35;
const _p$706 = undefined;
const _bind$129 = [_tmp$352, _tmp$353, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$705, _p$706) }];
const _p$707 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$129, start: 0, end: 3 });
const _tmp$354 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$707);
const _p$708 = "8";
const _tmp$355 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$708) };
const _p$709 = 11;
const _p$710 = undefined;
const _tmp$356 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$709, _p$710) };
const _p$711 = 35;
const _p$712 = undefined;
const _bind$130 = [_tmp$355, _tmp$356, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$711, _p$712) }];
const _p$713 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$130, start: 0, end: 3 });
const _tmp$357 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$713);
const _p$714 = "8";
const _tmp$358 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$714) };
const _p$715 = 12;
const _p$716 = undefined;
const _tmp$359 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$715, _p$716) };
const _p$717 = 35;
const _p$718 = undefined;
const _bind$131 = [_tmp$358, _tmp$359, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$717, _p$718) }];
const _p$719 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$131, start: 0, end: 3 });
const _tmp$360 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$719);
const _p$720 = "8";
const _tmp$361 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$720) };
const _p$721 = 13;
const _p$722 = undefined;
const _tmp$362 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$721, _p$722) };
const _p$723 = 35;
const _p$724 = undefined;
const _bind$132 = [_tmp$361, _tmp$362, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$723, _p$724) }];
const _p$725 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$132, start: 0, end: 3 });
const _tmp$363 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$725);
const _p$726 = "8";
const _tmp$364 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$726) };
const _p$727 = 14;
const _p$728 = undefined;
const _tmp$365 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$727, _p$728) };
const _p$729 = 35;
const _p$730 = undefined;
const _bind$133 = [_tmp$364, _tmp$365, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$729, _p$730) }];
const _p$731 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$133, start: 0, end: 3 });
const _tmp$366 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$731);
const _p$732 = "8";
const _tmp$367 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$732) };
const _p$733 = 15;
const _p$734 = undefined;
const _tmp$368 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$733, _p$734) };
const _p$735 = 35;
const _p$736 = undefined;
const _bind$134 = [_tmp$367, _tmp$368, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$735, _p$736) }];
const _p$737 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$134, start: 0, end: 3 });
const _tmp$369 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$737);
const _p$738 = "8";
const _tmp$370 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$738) };
const _p$739 = 16;
const _p$740 = undefined;
const _tmp$371 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$739, _p$740) };
const _p$741 = 35;
const _p$742 = undefined;
const _bind$135 = [_tmp$370, _tmp$371, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$741, _p$742) }];
const _p$743 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$135, start: 0, end: 3 });
const _tmp$372 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$743);
const _p$744 = "8";
const _tmp$373 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$744) };
const _p$745 = 17;
const _p$746 = undefined;
const _tmp$374 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$745, _p$746) };
const _p$747 = 35;
const _p$748 = undefined;
const _bind$136 = [_tmp$373, _tmp$374, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$747, _p$748) }];
const _p$749 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$136, start: 0, end: 3 });
const _tmp$375 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$749);
const _p$750 = "8";
const _tmp$376 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$750) };
const _p$751 = 18;
const _p$752 = undefined;
const _tmp$377 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$751, _p$752) };
const _p$753 = 35;
const _p$754 = undefined;
const _bind$137 = [_tmp$376, _tmp$377, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$753, _p$754) }];
const _p$755 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$137, start: 0, end: 3 });
const _tmp$378 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$755);
const _p$756 = "8";
const _tmp$379 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$756) };
const _p$757 = 19;
const _p$758 = undefined;
const _tmp$380 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$757, _p$758) };
const _p$759 = 35;
const _p$760 = undefined;
const _bind$138 = [_tmp$379, _tmp$380, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$759, _p$760) }];
const _p$761 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$138, start: 0, end: 3 });
const _tmp$381 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$761);
const _p$762 = "8";
const _tmp$382 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$762) };
const _p$763 = 20;
const _p$764 = undefined;
const _tmp$383 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$763, _p$764) };
const _p$765 = 35;
const _p$766 = undefined;
const _bind$139 = [_tmp$382, _tmp$383, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$765, _p$766) }];
const _p$767 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$139, start: 0, end: 3 });
const _tmp$384 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$767);
const _p$768 = "8";
const _tmp$385 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$768) };
const _p$769 = 21;
const _p$770 = undefined;
const _tmp$386 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$769, _p$770) };
const _p$771 = 35;
const _p$772 = undefined;
const _bind$140 = [_tmp$385, _tmp$386, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$771, _p$772) }];
const _p$773 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$140, start: 0, end: 3 });
const _tmp$387 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$773);
const _p$774 = "8";
const _tmp$388 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$774) };
const _p$775 = 22;
const _p$776 = undefined;
const _tmp$389 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$775, _p$776) };
const _p$777 = 35;
const _p$778 = undefined;
const _bind$141 = [_tmp$388, _tmp$389, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$777, _p$778) }];
const _p$779 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$141, start: 0, end: 3 });
const _tmp$390 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$779);
const _p$780 = "8";
const _tmp$391 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$780) };
const _p$781 = 23;
const _p$782 = undefined;
const _tmp$392 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$781, _p$782) };
const _p$783 = 35;
const _p$784 = undefined;
const _bind$142 = [_tmp$391, _tmp$392, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$783, _p$784) }];
const _p$785 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$142, start: 0, end: 3 });
const _tmp$393 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$785);
const _p$786 = "8";
const _tmp$394 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$786) };
const _p$787 = 24;
const _p$788 = undefined;
const _tmp$395 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$787, _p$788) };
const _p$789 = 35;
const _p$790 = undefined;
const _bind$143 = [_tmp$394, _tmp$395, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$789, _p$790) }];
const _p$791 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$143, start: 0, end: 3 });
const _tmp$396 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$791);
const _p$792 = "8";
const _tmp$397 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$792) };
const _p$793 = 25;
const _p$794 = undefined;
const _tmp$398 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$793, _p$794) };
const _p$795 = 35;
const _p$796 = undefined;
const _bind$144 = [_tmp$397, _tmp$398, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$795, _p$796) }];
const _p$797 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$144, start: 0, end: 3 });
const _tmp$399 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$797);
const _p$798 = "8";
const _tmp$400 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$798) };
const _p$799 = 26;
const _p$800 = undefined;
const _tmp$401 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$799, _p$800) };
const _p$801 = 35;
const _p$802 = undefined;
const _bind$145 = [_tmp$400, _tmp$401, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$801, _p$802) }];
const _p$803 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$145, start: 0, end: 3 });
const _tmp$402 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$803);
const _p$804 = "8";
const _tmp$403 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$804) };
const _p$805 = 27;
const _p$806 = undefined;
const _tmp$404 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$805, _p$806) };
const _p$807 = 35;
const _p$808 = undefined;
const _bind$146 = [_tmp$403, _tmp$404, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$807, _p$808) }];
const _p$809 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$146, start: 0, end: 3 });
const _tmp$405 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$809);
const _p$810 = "8";
const _tmp$406 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$810) };
const _p$811 = 28;
const _p$812 = undefined;
const _tmp$407 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$811, _p$812) };
const _p$813 = 35;
const _p$814 = undefined;
const _bind$147 = [_tmp$406, _tmp$407, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$813, _p$814) }];
const _p$815 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$147, start: 0, end: 3 });
const _tmp$408 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$815);
const _p$816 = "8";
const _tmp$409 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$816) };
const _p$817 = 29;
const _p$818 = undefined;
const _tmp$410 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$817, _p$818) };
const _p$819 = 35;
const _p$820 = undefined;
const _bind$148 = [_tmp$409, _tmp$410, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$819, _p$820) }];
const _p$821 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$148, start: 0, end: 3 });
const _tmp$411 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$821);
const _p$822 = "8";
const _tmp$412 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$822) };
const _p$823 = 30;
const _p$824 = undefined;
const _tmp$413 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$823, _p$824) };
const _p$825 = 35;
const _p$826 = undefined;
const _bind$149 = [_tmp$412, _tmp$413, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$825, _p$826) }];
const _p$827 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$149, start: 0, end: 3 });
const _tmp$414 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$827);
const _p$828 = "8";
const _tmp$415 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$828) };
const _p$829 = 31;
const _p$830 = undefined;
const _tmp$416 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$829, _p$830) };
const _p$831 = 35;
const _p$832 = undefined;
const _bind$150 = [_tmp$415, _tmp$416, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$831, _p$832) }];
const _p$833 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$150, start: 0, end: 3 });
const _tmp$417 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$833);
const _p$834 = "8";
const _tmp$418 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$834) };
const _p$835 = 32;
const _p$836 = undefined;
const _tmp$419 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$835, _p$836) };
const _p$837 = 35;
const _p$838 = undefined;
const _bind$151 = [_tmp$418, _tmp$419, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$837, _p$838) }];
const _p$839 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$151, start: 0, end: 3 });
const _tmp$420 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$839);
const _p$840 = "8";
const _tmp$421 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$840) };
const _p$841 = 33;
const _p$842 = undefined;
const _tmp$422 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$841, _p$842) };
const _p$843 = 35;
const _p$844 = undefined;
const _bind$152 = [_tmp$421, _tmp$422, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$843, _p$844) }];
const _p$845 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$152, start: 0, end: 3 });
const _tmp$423 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$845);
const _p$846 = "8";
const _tmp$424 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$846) };
const _p$847 = 34;
const _p$848 = undefined;
const _tmp$425 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$847, _p$848) };
const _p$849 = 35;
const _p$850 = undefined;
const _bind$153 = [_tmp$424, _tmp$425, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$849, _p$850) }];
const _p$851 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$153, start: 0, end: 3 });
const _tmp$426 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$851);
const _p$852 = "8";
const _tmp$427 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$852) };
const _p$853 = 35;
const _p$854 = undefined;
const _tmp$428 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$853, _p$854) };
const _p$855 = 35;
const _p$856 = undefined;
const _bind$154 = [_tmp$427, _tmp$428, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$855, _p$856) }];
const _p$857 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$154, start: 0, end: 3 });
const _tmp$429 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$857);
const _p$858 = "8";
const _tmp$430 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$858) };
const _p$859 = 36;
const _p$860 = undefined;
const _tmp$431 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$859, _p$860) };
const _p$861 = 35;
const _p$862 = undefined;
const _bind$155 = [_tmp$430, _tmp$431, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$861, _p$862) }];
const _p$863 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$155, start: 0, end: 3 });
const _tmp$432 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$863);
const _p$864 = "8";
const _tmp$433 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$864) };
const _p$865 = 37;
const _p$866 = undefined;
const _tmp$434 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$865, _p$866) };
const _p$867 = 35;
const _p$868 = undefined;
const _bind$156 = [_tmp$433, _tmp$434, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$867, _p$868) }];
const _p$869 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$156, start: 0, end: 3 });
const _tmp$435 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$869);
const _p$870 = "13";
const _tmp$436 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$870) };
const _p$871 = 1;
const _p$872 = undefined;
const _tmp$437 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$871, _p$872) };
const _p$873 = 34;
const _p$874 = undefined;
const _bind$157 = [_tmp$436, _tmp$437, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$873, _p$874) }];
const _p$875 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$157, start: 0, end: 3 });
const _tmp$438 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$875);
const _p$876 = "13";
const _tmp$439 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$876) };
const _p$877 = 2;
const _p$878 = undefined;
const _tmp$440 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$877, _p$878) };
const _p$879 = 34;
const _p$880 = undefined;
const _bind$158 = [_tmp$439, _tmp$440, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$879, _p$880) }];
const _p$881 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$158, start: 0, end: 3 });
const _tmp$441 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$881);
const _p$882 = "13";
const _tmp$442 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$882) };
const _p$883 = 3;
const _p$884 = undefined;
const _tmp$443 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$883, _p$884) };
const _p$885 = 34;
const _p$886 = undefined;
const _bind$159 = [_tmp$442, _tmp$443, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$885, _p$886) }];
const _p$887 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$159, start: 0, end: 3 });
const _tmp$444 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$887);
const _p$888 = "13";
const _tmp$445 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$888) };
const _p$889 = 4;
const _p$890 = undefined;
const _tmp$446 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$889, _p$890) };
const _p$891 = 34;
const _p$892 = undefined;
const _bind$160 = [_tmp$445, _tmp$446, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$891, _p$892) }];
const _p$893 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$160, start: 0, end: 3 });
const _tmp$447 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$893);
const _p$894 = "13";
const _tmp$448 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$894) };
const _p$895 = 5;
const _p$896 = undefined;
const _tmp$449 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$895, _p$896) };
const _p$897 = 34;
const _p$898 = undefined;
const _bind$161 = [_tmp$448, _tmp$449, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$897, _p$898) }];
const _p$899 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$161, start: 0, end: 3 });
const _tmp$450 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$899);
const _p$900 = "13";
const _tmp$451 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$900) };
const _p$901 = 6;
const _p$902 = undefined;
const _tmp$452 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$901, _p$902) };
const _p$903 = 34;
const _p$904 = undefined;
const _bind$162 = [_tmp$451, _tmp$452, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$903, _p$904) }];
const _p$905 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$162, start: 0, end: 3 });
const _tmp$453 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$905);
const _p$906 = "13";
const _tmp$454 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$906) };
const _p$907 = 7;
const _p$908 = undefined;
const _tmp$455 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$907, _p$908) };
const _p$909 = 34;
const _p$910 = undefined;
const _bind$163 = [_tmp$454, _tmp$455, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$909, _p$910) }];
const _p$911 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$163, start: 0, end: 3 });
const _tmp$456 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$911);
const _p$912 = "13";
const _tmp$457 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$912) };
const _p$913 = 8;
const _p$914 = undefined;
const _tmp$458 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$913, _p$914) };
const _p$915 = 34;
const _p$916 = undefined;
const _bind$164 = [_tmp$457, _tmp$458, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$915, _p$916) }];
const _p$917 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$164, start: 0, end: 3 });
const _tmp$459 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$917);
const _p$918 = "13";
const _tmp$460 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$918) };
const _p$919 = 9;
const _p$920 = undefined;
const _tmp$461 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$919, _p$920) };
const _p$921 = 34;
const _p$922 = undefined;
const _bind$165 = [_tmp$460, _tmp$461, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$921, _p$922) }];
const _p$923 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$165, start: 0, end: 3 });
const _tmp$462 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$923);
const _p$924 = "13";
const _tmp$463 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$924) };
const _p$925 = 10;
const _p$926 = undefined;
const _tmp$464 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$925, _p$926) };
const _p$927 = 34;
const _p$928 = undefined;
const _bind$166 = [_tmp$463, _tmp$464, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$927, _p$928) }];
const _p$929 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$166, start: 0, end: 3 });
const _tmp$465 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$929);
const _p$930 = "13";
const _tmp$466 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$930) };
const _p$931 = 11;
const _p$932 = undefined;
const _tmp$467 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$931, _p$932) };
const _p$933 = 34;
const _p$934 = undefined;
const _bind$167 = [_tmp$466, _tmp$467, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$933, _p$934) }];
const _p$935 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$167, start: 0, end: 3 });
const _tmp$468 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$935);
const _p$936 = "13";
const _tmp$469 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$936) };
const _p$937 = 12;
const _p$938 = undefined;
const _tmp$470 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$937, _p$938) };
const _p$939 = 34;
const _p$940 = undefined;
const _bind$168 = [_tmp$469, _tmp$470, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$939, _p$940) }];
const _p$941 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$168, start: 0, end: 3 });
const _tmp$471 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$941);
const _p$942 = "13";
const _tmp$472 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$942) };
const _p$943 = 13;
const _p$944 = undefined;
const _tmp$473 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$943, _p$944) };
const _p$945 = 34;
const _p$946 = undefined;
const _bind$169 = [_tmp$472, _tmp$473, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$945, _p$946) }];
const _p$947 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$169, start: 0, end: 3 });
const _tmp$474 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$947);
const _p$948 = "13";
const _tmp$475 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$948) };
const _p$949 = 14;
const _p$950 = undefined;
const _tmp$476 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$949, _p$950) };
const _p$951 = 34;
const _p$952 = undefined;
const _bind$170 = [_tmp$475, _tmp$476, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$951, _p$952) }];
const _p$953 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$170, start: 0, end: 3 });
const _tmp$477 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$953);
const _p$954 = "13";
const _tmp$478 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$954) };
const _p$955 = 15;
const _p$956 = undefined;
const _tmp$479 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$955, _p$956) };
const _p$957 = 34;
const _p$958 = undefined;
const _bind$171 = [_tmp$478, _tmp$479, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$957, _p$958) }];
const _p$959 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$171, start: 0, end: 3 });
const _tmp$480 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$959);
const _p$960 = "13";
const _tmp$481 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$960) };
const _p$961 = 16;
const _p$962 = undefined;
const _tmp$482 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$961, _p$962) };
const _p$963 = 34;
const _p$964 = undefined;
const _bind$172 = [_tmp$481, _tmp$482, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$963, _p$964) }];
const _p$965 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$172, start: 0, end: 3 });
const _tmp$483 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$965);
const _p$966 = "13";
const _tmp$484 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$966) };
const _p$967 = 17;
const _p$968 = undefined;
const _tmp$485 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$967, _p$968) };
const _p$969 = 34;
const _p$970 = undefined;
const _bind$173 = [_tmp$484, _tmp$485, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$969, _p$970) }];
const _p$971 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$173, start: 0, end: 3 });
const _tmp$486 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$971);
const _p$972 = "13";
const _tmp$487 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$972) };
const _p$973 = 18;
const _p$974 = undefined;
const _tmp$488 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$973, _p$974) };
const _p$975 = 34;
const _p$976 = undefined;
const _bind$174 = [_tmp$487, _tmp$488, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$975, _p$976) }];
const _p$977 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$174, start: 0, end: 3 });
const _tmp$489 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$977);
const _p$978 = "13";
const _tmp$490 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$978) };
const _p$979 = 19;
const _p$980 = undefined;
const _tmp$491 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$979, _p$980) };
const _p$981 = 34;
const _p$982 = undefined;
const _bind$175 = [_tmp$490, _tmp$491, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$981, _p$982) }];
const _p$983 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$175, start: 0, end: 3 });
const _tmp$492 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$983);
const _p$984 = "13";
const _tmp$493 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$984) };
const _p$985 = 20;
const _p$986 = undefined;
const _tmp$494 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$985, _p$986) };
const _p$987 = 34;
const _p$988 = undefined;
const _bind$176 = [_tmp$493, _tmp$494, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$987, _p$988) }];
const _p$989 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$176, start: 0, end: 3 });
const _tmp$495 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$989);
const _p$990 = "13";
const _tmp$496 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$990) };
const _p$991 = 21;
const _p$992 = undefined;
const _tmp$497 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$991, _p$992) };
const _p$993 = 34;
const _p$994 = undefined;
const _bind$177 = [_tmp$496, _tmp$497, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$993, _p$994) }];
const _p$995 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$177, start: 0, end: 3 });
const _tmp$498 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$995);
const _p$996 = "13";
const _tmp$499 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$996) };
const _p$997 = 22;
const _p$998 = undefined;
const _tmp$500 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$997, _p$998) };
const _p$999 = 34;
const _p$1000 = undefined;
const _bind$178 = [_tmp$499, _tmp$500, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$999, _p$1000) }];
const _p$1001 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$178, start: 0, end: 3 });
const _tmp$501 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1001);
const _p$1002 = "13";
const _tmp$502 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1002) };
const _p$1003 = 23;
const _p$1004 = undefined;
const _tmp$503 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1003, _p$1004) };
const _p$1005 = 34;
const _p$1006 = undefined;
const _bind$179 = [_tmp$502, _tmp$503, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1005, _p$1006) }];
const _p$1007 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$179, start: 0, end: 3 });
const _tmp$504 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1007);
const _p$1008 = "13";
const _tmp$505 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1008) };
const _p$1009 = 24;
const _p$1010 = undefined;
const _tmp$506 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1009, _p$1010) };
const _p$1011 = 34;
const _p$1012 = undefined;
const _bind$180 = [_tmp$505, _tmp$506, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1011, _p$1012) }];
const _p$1013 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$180, start: 0, end: 3 });
const _tmp$507 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1013);
const _p$1014 = "13";
const _tmp$508 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1014) };
const _p$1015 = 25;
const _p$1016 = undefined;
const _tmp$509 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1015, _p$1016) };
const _p$1017 = 34;
const _p$1018 = undefined;
const _bind$181 = [_tmp$508, _tmp$509, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1017, _p$1018) }];
const _p$1019 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$181, start: 0, end: 3 });
const _tmp$510 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1019);
const _p$1020 = "13";
const _tmp$511 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1020) };
const _p$1021 = 26;
const _p$1022 = undefined;
const _tmp$512 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1021, _p$1022) };
const _p$1023 = 34;
const _p$1024 = undefined;
const _bind$182 = [_tmp$511, _tmp$512, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1023, _p$1024) }];
const _p$1025 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$182, start: 0, end: 3 });
const _tmp$513 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1025);
const _p$1026 = "13";
const _tmp$514 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1026) };
const _p$1027 = 27;
const _p$1028 = undefined;
const _tmp$515 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1027, _p$1028) };
const _p$1029 = 34;
const _p$1030 = undefined;
const _bind$183 = [_tmp$514, _tmp$515, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1029, _p$1030) }];
const _p$1031 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$183, start: 0, end: 3 });
const _tmp$516 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1031);
const _p$1032 = "13";
const _tmp$517 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1032) };
const _p$1033 = 28;
const _p$1034 = undefined;
const _tmp$518 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1033, _p$1034) };
const _p$1035 = 34;
const _p$1036 = undefined;
const _bind$184 = [_tmp$517, _tmp$518, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1035, _p$1036) }];
const _p$1037 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$184, start: 0, end: 3 });
const _tmp$519 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1037);
const _p$1038 = "13";
const _tmp$520 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1038) };
const _p$1039 = 29;
const _p$1040 = undefined;
const _tmp$521 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1039, _p$1040) };
const _p$1041 = 34;
const _p$1042 = undefined;
const _bind$185 = [_tmp$520, _tmp$521, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1041, _p$1042) }];
const _p$1043 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$185, start: 0, end: 3 });
const _tmp$522 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1043);
const _p$1044 = "13";
const _tmp$523 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1044) };
const _p$1045 = 30;
const _p$1046 = undefined;
const _tmp$524 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1045, _p$1046) };
const _p$1047 = 34;
const _p$1048 = undefined;
const _bind$186 = [_tmp$523, _tmp$524, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1047, _p$1048) }];
const _p$1049 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$186, start: 0, end: 3 });
const _tmp$525 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1049);
const _p$1050 = "13";
const _tmp$526 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1050) };
const _p$1051 = 31;
const _p$1052 = undefined;
const _tmp$527 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1051, _p$1052) };
const _p$1053 = 34;
const _p$1054 = undefined;
const _bind$187 = [_tmp$526, _tmp$527, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1053, _p$1054) }];
const _p$1055 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$187, start: 0, end: 3 });
const _tmp$528 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1055);
const _p$1056 = "13";
const _tmp$529 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1056) };
const _p$1057 = 32;
const _p$1058 = undefined;
const _tmp$530 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1057, _p$1058) };
const _p$1059 = 34;
const _p$1060 = undefined;
const _bind$188 = [_tmp$529, _tmp$530, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1059, _p$1060) }];
const _p$1061 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$188, start: 0, end: 3 });
const _tmp$531 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1061);
const _p$1062 = "13";
const _tmp$532 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1062) };
const _p$1063 = 33;
const _p$1064 = undefined;
const _tmp$533 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1063, _p$1064) };
const _p$1065 = 34;
const _p$1066 = undefined;
const _bind$189 = [_tmp$532, _tmp$533, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1065, _p$1066) }];
const _p$1067 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$189, start: 0, end: 3 });
const _tmp$534 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1067);
const _p$1068 = "13";
const _tmp$535 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1068) };
const _p$1069 = 34;
const _p$1070 = undefined;
const _tmp$536 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1069, _p$1070) };
const _p$1071 = 34;
const _p$1072 = undefined;
const _bind$190 = [_tmp$535, _tmp$536, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1071, _p$1072) }];
const _p$1073 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$190, start: 0, end: 3 });
const _tmp$537 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1073);
const _p$1074 = "13";
const _tmp$538 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1074) };
const _p$1075 = 35;
const _p$1076 = undefined;
const _tmp$539 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1075, _p$1076) };
const _p$1077 = 34;
const _p$1078 = undefined;
const _bind$191 = [_tmp$538, _tmp$539, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1077, _p$1078) }];
const _p$1079 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$191, start: 0, end: 3 });
const _tmp$540 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1079);
const _p$1080 = "13";
const _tmp$541 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1080) };
const _p$1081 = 36;
const _p$1082 = undefined;
const _tmp$542 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1081, _p$1082) };
const _p$1083 = 34;
const _p$1084 = undefined;
const _bind$192 = [_tmp$541, _tmp$542, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1083, _p$1084) }];
const _p$1085 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$192, start: 0, end: 3 });
const _tmp$543 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1085);
const _p$1086 = "13";
const _tmp$544 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1086) };
const _p$1087 = 37;
const _p$1088 = undefined;
const _tmp$545 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1087, _p$1088) };
const _p$1089 = 34;
const _p$1090 = undefined;
const _bind$193 = [_tmp$544, _tmp$545, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1089, _p$1090) }];
const _p$1091 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$193, start: 0, end: 3 });
const _tmp$546 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1091);
const _p$1092 = "9";
const _tmp$547 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1092) };
const _p$1093 = 2;
const _p$1094 = undefined;
const _tmp$548 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1093, _p$1094) };
const _p$1095 = 0;
const _p$1096 = undefined;
const _bind$194 = [_tmp$547, _tmp$548, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1095, _p$1096) }];
const _p$1097 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$194, start: 0, end: 3 });
const _tmp$549 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1097);
const _p$1098 = "9";
const _tmp$550 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1098) };
const _p$1099 = 3;
const _p$1100 = undefined;
const _tmp$551 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1099, _p$1100) };
const _p$1101 = 0;
const _p$1102 = undefined;
const _bind$195 = [_tmp$550, _tmp$551, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1101, _p$1102) }];
const _p$1103 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$195, start: 0, end: 3 });
const _tmp$552 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1103);
const _p$1104 = "9";
const _tmp$553 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1104) };
const _p$1105 = 4;
const _p$1106 = undefined;
const _tmp$554 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1105, _p$1106) };
const _p$1107 = 0;
const _p$1108 = undefined;
const _bind$196 = [_tmp$553, _tmp$554, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1107, _p$1108) }];
const _p$1109 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$196, start: 0, end: 3 });
const _tmp$555 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1109);
const _p$1110 = "9";
const _tmp$556 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1110) };
const _p$1111 = 5;
const _p$1112 = undefined;
const _tmp$557 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1111, _p$1112) };
const _p$1113 = 0;
const _p$1114 = undefined;
const _bind$197 = [_tmp$556, _tmp$557, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1113, _p$1114) }];
const _p$1115 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$197, start: 0, end: 3 });
const _tmp$558 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1115);
const _p$1116 = "9";
const _tmp$559 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1116) };
const _p$1117 = 6;
const _p$1118 = undefined;
const _tmp$560 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1117, _p$1118) };
const _p$1119 = 0;
const _p$1120 = undefined;
const _bind$198 = [_tmp$559, _tmp$560, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1119, _p$1120) }];
const _p$1121 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$198, start: 0, end: 3 });
const _tmp$561 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1121);
const _p$1122 = "9";
const _tmp$562 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1122) };
const _p$1123 = 7;
const _p$1124 = undefined;
const _tmp$563 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1123, _p$1124) };
const _p$1125 = 0;
const _p$1126 = undefined;
const _bind$199 = [_tmp$562, _tmp$563, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1125, _p$1126) }];
const _p$1127 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$199, start: 0, end: 3 });
const _tmp$564 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1127);
const _p$1128 = "9";
const _tmp$565 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1128) };
const _p$1129 = 8;
const _p$1130 = undefined;
const _tmp$566 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1129, _p$1130) };
const _p$1131 = 0;
const _p$1132 = undefined;
const _bind$200 = [_tmp$565, _tmp$566, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1131, _p$1132) }];
const _p$1133 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$200, start: 0, end: 3 });
const _tmp$567 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1133);
const _p$1134 = "9";
const _tmp$568 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1134) };
const _p$1135 = 9;
const _p$1136 = undefined;
const _tmp$569 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1135, _p$1136) };
const _p$1137 = 0;
const _p$1138 = undefined;
const _bind$201 = [_tmp$568, _tmp$569, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1137, _p$1138) }];
const _p$1139 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$201, start: 0, end: 3 });
const _tmp$570 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1139);
const _p$1140 = "9";
const _tmp$571 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1140) };
const _p$1141 = 10;
const _p$1142 = undefined;
const _tmp$572 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1141, _p$1142) };
const _p$1143 = 0;
const _p$1144 = undefined;
const _bind$202 = [_tmp$571, _tmp$572, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1143, _p$1144) }];
const _p$1145 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$202, start: 0, end: 3 });
const _tmp$573 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1145);
const _p$1146 = "9";
const _tmp$574 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1146) };
const _p$1147 = 11;
const _p$1148 = undefined;
const _tmp$575 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1147, _p$1148) };
const _p$1149 = 0;
const _p$1150 = undefined;
const _bind$203 = [_tmp$574, _tmp$575, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1149, _p$1150) }];
const _p$1151 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$203, start: 0, end: 3 });
const _tmp$576 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1151);
const _p$1152 = "9";
const _tmp$577 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1152) };
const _p$1153 = 12;
const _p$1154 = undefined;
const _tmp$578 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1153, _p$1154) };
const _p$1155 = 0;
const _p$1156 = undefined;
const _bind$204 = [_tmp$577, _tmp$578, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1155, _p$1156) }];
const _p$1157 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$204, start: 0, end: 3 });
const _tmp$579 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1157);
const _p$1158 = "9";
const _tmp$580 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1158) };
const _p$1159 = 13;
const _p$1160 = undefined;
const _tmp$581 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1159, _p$1160) };
const _p$1161 = 0;
const _p$1162 = undefined;
const _bind$205 = [_tmp$580, _tmp$581, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1161, _p$1162) }];
const _p$1163 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$205, start: 0, end: 3 });
const _tmp$582 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1163);
const _p$1164 = "9";
const _tmp$583 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1164) };
const _p$1165 = 14;
const _p$1166 = undefined;
const _tmp$584 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1165, _p$1166) };
const _p$1167 = 0;
const _p$1168 = undefined;
const _bind$206 = [_tmp$583, _tmp$584, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1167, _p$1168) }];
const _p$1169 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$206, start: 0, end: 3 });
const _tmp$585 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1169);
const _p$1170 = "9";
const _tmp$586 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1170) };
const _p$1171 = 15;
const _p$1172 = undefined;
const _tmp$587 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1171, _p$1172) };
const _p$1173 = 0;
const _p$1174 = undefined;
const _bind$207 = [_tmp$586, _tmp$587, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1173, _p$1174) }];
const _p$1175 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$207, start: 0, end: 3 });
const _tmp$588 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1175);
const _p$1176 = "9";
const _tmp$589 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1176) };
const _p$1177 = 16;
const _p$1178 = undefined;
const _tmp$590 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1177, _p$1178) };
const _p$1179 = 0;
const _p$1180 = undefined;
const _bind$208 = [_tmp$589, _tmp$590, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1179, _p$1180) }];
const _p$1181 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$208, start: 0, end: 3 });
const _tmp$591 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1181);
const _p$1182 = "9";
const _tmp$592 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1182) };
const _p$1183 = 17;
const _p$1184 = undefined;
const _tmp$593 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1183, _p$1184) };
const _p$1185 = 0;
const _p$1186 = undefined;
const _bind$209 = [_tmp$592, _tmp$593, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1185, _p$1186) }];
const _p$1187 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$209, start: 0, end: 3 });
const _tmp$594 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1187);
const _p$1188 = "9";
const _tmp$595 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1188) };
const _p$1189 = 18;
const _p$1190 = undefined;
const _tmp$596 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1189, _p$1190) };
const _p$1191 = 0;
const _p$1192 = undefined;
const _bind$210 = [_tmp$595, _tmp$596, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1191, _p$1192) }];
const _p$1193 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$210, start: 0, end: 3 });
const _tmp$597 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1193);
const _p$1194 = "9";
const _tmp$598 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1194) };
const _p$1195 = 19;
const _p$1196 = undefined;
const _tmp$599 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1195, _p$1196) };
const _p$1197 = 0;
const _p$1198 = undefined;
const _bind$211 = [_tmp$598, _tmp$599, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1197, _p$1198) }];
const _p$1199 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$211, start: 0, end: 3 });
const _tmp$600 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1199);
const _p$1200 = "9";
const _tmp$601 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1200) };
const _p$1201 = 20;
const _p$1202 = undefined;
const _tmp$602 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1201, _p$1202) };
const _p$1203 = 0;
const _p$1204 = undefined;
const _bind$212 = [_tmp$601, _tmp$602, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1203, _p$1204) }];
const _p$1205 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$212, start: 0, end: 3 });
const _tmp$603 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1205);
const _p$1206 = "9";
const _tmp$604 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1206) };
const _p$1207 = 21;
const _p$1208 = undefined;
const _tmp$605 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1207, _p$1208) };
const _p$1209 = 0;
const _p$1210 = undefined;
const _bind$213 = [_tmp$604, _tmp$605, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1209, _p$1210) }];
const _p$1211 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$213, start: 0, end: 3 });
const _tmp$606 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1211);
const _p$1212 = "9";
const _tmp$607 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1212) };
const _p$1213 = 22;
const _p$1214 = undefined;
const _tmp$608 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1213, _p$1214) };
const _p$1215 = 0;
const _p$1216 = undefined;
const _bind$214 = [_tmp$607, _tmp$608, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1215, _p$1216) }];
const _p$1217 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$214, start: 0, end: 3 });
const _tmp$609 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1217);
const _p$1218 = "9";
const _tmp$610 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1218) };
const _p$1219 = 23;
const _p$1220 = undefined;
const _tmp$611 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1219, _p$1220) };
const _p$1221 = 0;
const _p$1222 = undefined;
const _bind$215 = [_tmp$610, _tmp$611, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1221, _p$1222) }];
const _p$1223 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$215, start: 0, end: 3 });
const _tmp$612 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1223);
const _p$1224 = "9";
const _tmp$613 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1224) };
const _p$1225 = 24;
const _p$1226 = undefined;
const _tmp$614 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1225, _p$1226) };
const _p$1227 = 0;
const _p$1228 = undefined;
const _bind$216 = [_tmp$613, _tmp$614, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1227, _p$1228) }];
const _p$1229 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$216, start: 0, end: 3 });
const _tmp$615 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1229);
const _p$1230 = "9";
const _tmp$616 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1230) };
const _p$1231 = 25;
const _p$1232 = undefined;
const _tmp$617 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1231, _p$1232) };
const _p$1233 = 0;
const _p$1234 = undefined;
const _bind$217 = [_tmp$616, _tmp$617, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1233, _p$1234) }];
const _p$1235 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$217, start: 0, end: 3 });
const _tmp$618 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1235);
const _p$1236 = "9";
const _tmp$619 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1236) };
const _p$1237 = 26;
const _p$1238 = undefined;
const _tmp$620 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1237, _p$1238) };
const _p$1239 = 0;
const _p$1240 = undefined;
const _bind$218 = [_tmp$619, _tmp$620, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1239, _p$1240) }];
const _p$1241 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$218, start: 0, end: 3 });
const _tmp$621 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1241);
const _p$1242 = "9";
const _tmp$622 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1242) };
const _p$1243 = 27;
const _p$1244 = undefined;
const _tmp$623 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1243, _p$1244) };
const _p$1245 = 0;
const _p$1246 = undefined;
const _bind$219 = [_tmp$622, _tmp$623, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1245, _p$1246) }];
const _p$1247 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$219, start: 0, end: 3 });
const _tmp$624 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1247);
const _p$1248 = "9";
const _tmp$625 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1248) };
const _p$1249 = 28;
const _p$1250 = undefined;
const _tmp$626 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1249, _p$1250) };
const _p$1251 = 0;
const _p$1252 = undefined;
const _bind$220 = [_tmp$625, _tmp$626, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1251, _p$1252) }];
const _p$1253 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$220, start: 0, end: 3 });
const _tmp$627 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1253);
const _p$1254 = "9";
const _tmp$628 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1254) };
const _p$1255 = 29;
const _p$1256 = undefined;
const _tmp$629 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1255, _p$1256) };
const _p$1257 = 0;
const _p$1258 = undefined;
const _bind$221 = [_tmp$628, _tmp$629, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1257, _p$1258) }];
const _p$1259 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$221, start: 0, end: 3 });
const _tmp$630 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1259);
const _p$1260 = "9";
const _tmp$631 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1260) };
const _p$1261 = 30;
const _p$1262 = undefined;
const _tmp$632 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1261, _p$1262) };
const _p$1263 = 0;
const _p$1264 = undefined;
const _bind$222 = [_tmp$631, _tmp$632, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1263, _p$1264) }];
const _p$1265 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$222, start: 0, end: 3 });
const _tmp$633 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1265);
const _p$1266 = "9";
const _tmp$634 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1266) };
const _p$1267 = 31;
const _p$1268 = undefined;
const _tmp$635 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1267, _p$1268) };
const _p$1269 = 0;
const _p$1270 = undefined;
const _bind$223 = [_tmp$634, _tmp$635, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1269, _p$1270) }];
const _p$1271 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$223, start: 0, end: 3 });
const _tmp$636 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1271);
const _p$1272 = "9";
const _tmp$637 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1272) };
const _p$1273 = 32;
const _p$1274 = undefined;
const _tmp$638 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1273, _p$1274) };
const _p$1275 = 0;
const _p$1276 = undefined;
const _bind$224 = [_tmp$637, _tmp$638, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1275, _p$1276) }];
const _p$1277 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$224, start: 0, end: 3 });
const _tmp$639 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1277);
const _p$1278 = "9";
const _tmp$640 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1278) };
const _p$1279 = 33;
const _p$1280 = undefined;
const _tmp$641 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1279, _p$1280) };
const _p$1281 = 0;
const _p$1282 = undefined;
const _bind$225 = [_tmp$640, _tmp$641, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1281, _p$1282) }];
const _p$1283 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$225, start: 0, end: 3 });
const _tmp$642 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1283);
const _p$1284 = "9";
const _tmp$643 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1284) };
const _p$1285 = 34;
const _p$1286 = undefined;
const _tmp$644 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1285, _p$1286) };
const _p$1287 = 0;
const _p$1288 = undefined;
const _bind$226 = [_tmp$643, _tmp$644, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1287, _p$1288) }];
const _p$1289 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$226, start: 0, end: 3 });
const _tmp$645 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1289);
const _p$1290 = "9";
const _tmp$646 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1290) };
const _p$1291 = 35;
const _p$1292 = undefined;
const _tmp$647 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1291, _p$1292) };
const _p$1293 = 0;
const _p$1294 = undefined;
const _bind$227 = [_tmp$646, _tmp$647, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1293, _p$1294) }];
const _p$1295 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$227, start: 0, end: 3 });
const _tmp$648 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1295);
const _p$1296 = "9";
const _tmp$649 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1296) };
const _p$1297 = 36;
const _p$1298 = undefined;
const _tmp$650 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1297, _p$1298) };
const _p$1299 = 0;
const _p$1300 = undefined;
const _bind$228 = [_tmp$649, _tmp$650, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1299, _p$1300) }];
const _p$1301 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$228, start: 0, end: 3 });
const _tmp$651 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1301);
const _p$1302 = "15";
const _tmp$652 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1302) };
const _p$1303 = 0;
const _p$1304 = undefined;
const _tmp$653 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1303, _p$1304) };
const _p$1305 = 0;
const _p$1306 = undefined;
const _bind$229 = [_tmp$652, _tmp$653, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1305, _p$1306) }];
const _p$1307 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$229, start: 0, end: 3 });
const _tmp$654 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1307);
const _p$1308 = "9";
const _tmp$655 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1308) };
const _p$1309 = 1;
const _p$1310 = undefined;
const _tmp$656 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1309, _p$1310) };
const _p$1311 = 0;
const _p$1312 = undefined;
const _bind$230 = [_tmp$655, _tmp$656, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1311, _p$1312) }];
const _p$1313 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$230, start: 0, end: 3 });
const _tmp$657 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1313);
const _p$1314 = "11";
const _tmp$658 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1314) };
const _p$1315 = 0;
const _p$1316 = undefined;
const _tmp$659 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1315, _p$1316) };
const _p$1317 = 1;
const _p$1318 = undefined;
const _bind$231 = [_tmp$658, _tmp$659, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1317, _p$1318) }];
const _p$1319 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$231, start: 0, end: 3 });
const _tmp$660 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1319);
const _p$1320 = "11";
const _tmp$661 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1320) };
const _p$1321 = 0;
const _p$1322 = undefined;
const _tmp$662 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1321, _p$1322) };
const _p$1323 = 2;
const _p$1324 = undefined;
const _bind$232 = [_tmp$661, _tmp$662, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1323, _p$1324) }];
const _p$1325 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$232, start: 0, end: 3 });
const _tmp$663 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1325);
const _p$1326 = "11";
const _tmp$664 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1326) };
const _p$1327 = 0;
const _p$1328 = undefined;
const _tmp$665 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1327, _p$1328) };
const _p$1329 = 3;
const _p$1330 = undefined;
const _bind$233 = [_tmp$664, _tmp$665, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1329, _p$1330) }];
const _p$1331 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$233, start: 0, end: 3 });
const _tmp$666 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1331);
const _p$1332 = "13";
const _tmp$667 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1332) };
const _p$1333 = 1;
const _p$1334 = undefined;
const _tmp$668 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1333, _p$1334) };
const _p$1335 = 2;
const _p$1336 = undefined;
const _bind$234 = [_tmp$667, _tmp$668, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1335, _p$1336) }];
const _p$1337 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$234, start: 0, end: 3 });
const _tmp$669 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1337);
const _p$1338 = "13";
const _tmp$670 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1338) };
const _p$1339 = 1;
const _p$1340 = undefined;
const _tmp$671 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1339, _p$1340) };
const _p$1341 = 3;
const _p$1342 = undefined;
const _bind$235 = [_tmp$670, _tmp$671, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1341, _p$1342) }];
const _p$1343 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$235, start: 0, end: 3 });
const _tmp$672 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1343);
const _p$1344 = "13";
const _tmp$673 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1344) };
const _p$1345 = 2;
const _p$1346 = undefined;
const _tmp$674 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1345, _p$1346) };
const _p$1347 = 2;
const _p$1348 = undefined;
const _bind$236 = [_tmp$673, _tmp$674, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1347, _p$1348) }];
const _p$1349 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$236, start: 0, end: 3 });
const _tmp$675 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1349);
const _p$1350 = "10";
const _tmp$676 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1350) };
const _p$1351 = 2;
const _p$1352 = undefined;
const _tmp$677 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1351, _p$1352) };
const _p$1353 = 3;
const _p$1354 = undefined;
const _bind$237 = [_tmp$676, _tmp$677, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1353, _p$1354) }];
const _p$1355 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$237, start: 0, end: 3 });
const _tmp$678 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1355);
const _p$1356 = "8";
const _tmp$679 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1356) };
const _p$1357 = 3;
const _p$1358 = undefined;
const _tmp$680 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1357, _p$1358) };
const _p$1359 = 2;
const _p$1360 = undefined;
const _bind$238 = [_tmp$679, _tmp$680, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1359, _p$1360) }];
const _p$1361 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$238, start: 0, end: 3 });
const _tmp$681 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1361);
const _p$1362 = "8";
const _tmp$682 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1362) };
const _p$1363 = 4;
const _p$1364 = undefined;
const _tmp$683 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1363, _p$1364) };
const _p$1365 = 2;
const _p$1366 = undefined;
const _bind$239 = [_tmp$682, _tmp$683, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1365, _p$1366) }];
const _p$1367 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$239, start: 0, end: 3 });
const _tmp$684 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1367);
const _p$1368 = "8";
const _tmp$685 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1368) };
const _p$1369 = 5;
const _p$1370 = undefined;
const _tmp$686 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1369, _p$1370) };
const _p$1371 = 2;
const _p$1372 = undefined;
const _bind$240 = [_tmp$685, _tmp$686, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1371, _p$1372) }];
const _p$1373 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$240, start: 0, end: 3 });
const _tmp$687 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1373);
const _p$1374 = "8";
const _tmp$688 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1374) };
const _p$1375 = 6;
const _p$1376 = undefined;
const _tmp$689 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1375, _p$1376) };
const _p$1377 = 2;
const _p$1378 = undefined;
const _bind$241 = [_tmp$688, _tmp$689, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1377, _p$1378) }];
const _p$1379 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$241, start: 0, end: 3 });
const _tmp$690 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1379);
const _p$1380 = "8";
const _tmp$691 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1380) };
const _p$1381 = 7;
const _p$1382 = undefined;
const _tmp$692 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1381, _p$1382) };
const _p$1383 = 2;
const _p$1384 = undefined;
const _bind$242 = [_tmp$691, _tmp$692, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1383, _p$1384) }];
const _p$1385 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$242, start: 0, end: 3 });
const _tmp$693 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1385);
const _p$1386 = "8";
const _tmp$694 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1386) };
const _p$1387 = 8;
const _p$1388 = undefined;
const _tmp$695 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1387, _p$1388) };
const _p$1389 = 2;
const _p$1390 = undefined;
const _bind$243 = [_tmp$694, _tmp$695, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1389, _p$1390) }];
const _p$1391 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$243, start: 0, end: 3 });
const _tmp$696 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1391);
const _p$1392 = "8";
const _tmp$697 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1392) };
const _p$1393 = 9;
const _p$1394 = undefined;
const _tmp$698 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1393, _p$1394) };
const _p$1395 = 2;
const _p$1396 = undefined;
const _bind$244 = [_tmp$697, _tmp$698, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1395, _p$1396) }];
const _p$1397 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$244, start: 0, end: 3 });
const _tmp$699 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1397);
const _p$1398 = "8";
const _tmp$700 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1398) };
const _p$1399 = 10;
const _p$1400 = undefined;
const _tmp$701 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1399, _p$1400) };
const _p$1401 = 2;
const _p$1402 = undefined;
const _bind$245 = [_tmp$700, _tmp$701, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1401, _p$1402) }];
const _p$1403 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$245, start: 0, end: 3 });
const _tmp$702 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1403);
const _p$1404 = "8";
const _tmp$703 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1404) };
const _p$1405 = 11;
const _p$1406 = undefined;
const _tmp$704 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1405, _p$1406) };
const _p$1407 = 2;
const _p$1408 = undefined;
const _bind$246 = [_tmp$703, _tmp$704, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1407, _p$1408) }];
const _p$1409 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$246, start: 0, end: 3 });
const _tmp$705 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1409);
const _p$1410 = "8";
const _tmp$706 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1410) };
const _p$1411 = 12;
const _p$1412 = undefined;
const _tmp$707 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1411, _p$1412) };
const _p$1413 = 2;
const _p$1414 = undefined;
const _bind$247 = [_tmp$706, _tmp$707, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1413, _p$1414) }];
const _p$1415 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$247, start: 0, end: 3 });
const _tmp$708 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1415);
const _p$1416 = "8";
const _tmp$709 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1416) };
const _p$1417 = 13;
const _p$1418 = undefined;
const _tmp$710 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1417, _p$1418) };
const _p$1419 = 2;
const _p$1420 = undefined;
const _bind$248 = [_tmp$709, _tmp$710, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1419, _p$1420) }];
const _p$1421 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$248, start: 0, end: 3 });
const _tmp$711 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1421);
const _p$1422 = "8";
const _tmp$712 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1422) };
const _p$1423 = 14;
const _p$1424 = undefined;
const _tmp$713 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1423, _p$1424) };
const _p$1425 = 2;
const _p$1426 = undefined;
const _bind$249 = [_tmp$712, _tmp$713, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1425, _p$1426) }];
const _p$1427 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$249, start: 0, end: 3 });
const _tmp$714 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1427);
const _p$1428 = "8";
const _tmp$715 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1428) };
const _p$1429 = 15;
const _p$1430 = undefined;
const _tmp$716 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1429, _p$1430) };
const _p$1431 = 2;
const _p$1432 = undefined;
const _bind$250 = [_tmp$715, _tmp$716, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1431, _p$1432) }];
const _p$1433 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$250, start: 0, end: 3 });
const _tmp$717 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1433);
const _p$1434 = "8";
const _tmp$718 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1434) };
const _p$1435 = 16;
const _p$1436 = undefined;
const _tmp$719 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1435, _p$1436) };
const _p$1437 = 2;
const _p$1438 = undefined;
const _bind$251 = [_tmp$718, _tmp$719, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1437, _p$1438) }];
const _p$1439 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$251, start: 0, end: 3 });
const _tmp$720 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1439);
const _p$1440 = "8";
const _tmp$721 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1440) };
const _p$1441 = 17;
const _p$1442 = undefined;
const _tmp$722 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1441, _p$1442) };
const _p$1443 = 2;
const _p$1444 = undefined;
const _bind$252 = [_tmp$721, _tmp$722, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1443, _p$1444) }];
const _p$1445 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$252, start: 0, end: 3 });
const _tmp$723 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1445);
const _p$1446 = "8";
const _tmp$724 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1446) };
const _p$1447 = 18;
const _p$1448 = undefined;
const _tmp$725 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1447, _p$1448) };
const _p$1449 = 2;
const _p$1450 = undefined;
const _bind$253 = [_tmp$724, _tmp$725, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1449, _p$1450) }];
const _p$1451 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$253, start: 0, end: 3 });
const _tmp$726 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1451);
const _p$1452 = "8";
const _tmp$727 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1452) };
const _p$1453 = 19;
const _p$1454 = undefined;
const _tmp$728 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1453, _p$1454) };
const _p$1455 = 2;
const _p$1456 = undefined;
const _bind$254 = [_tmp$727, _tmp$728, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1455, _p$1456) }];
const _p$1457 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$254, start: 0, end: 3 });
const _tmp$729 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1457);
const _p$1458 = "8";
const _tmp$730 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1458) };
const _p$1459 = 20;
const _p$1460 = undefined;
const _tmp$731 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1459, _p$1460) };
const _p$1461 = 2;
const _p$1462 = undefined;
const _bind$255 = [_tmp$730, _tmp$731, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1461, _p$1462) }];
const _p$1463 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$255, start: 0, end: 3 });
const _tmp$732 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1463);
const _p$1464 = "8";
const _tmp$733 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1464) };
const _p$1465 = 21;
const _p$1466 = undefined;
const _tmp$734 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1465, _p$1466) };
const _p$1467 = 2;
const _p$1468 = undefined;
const _bind$256 = [_tmp$733, _tmp$734, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1467, _p$1468) }];
const _p$1469 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$256, start: 0, end: 3 });
const _tmp$735 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1469);
const _p$1470 = "8";
const _tmp$736 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1470) };
const _p$1471 = 22;
const _p$1472 = undefined;
const _tmp$737 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1471, _p$1472) };
const _p$1473 = 2;
const _p$1474 = undefined;
const _bind$257 = [_tmp$736, _tmp$737, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1473, _p$1474) }];
const _p$1475 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$257, start: 0, end: 3 });
const _tmp$738 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1475);
const _p$1476 = "8";
const _tmp$739 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1476) };
const _p$1477 = 23;
const _p$1478 = undefined;
const _tmp$740 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1477, _p$1478) };
const _p$1479 = 2;
const _p$1480 = undefined;
const _bind$258 = [_tmp$739, _tmp$740, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1479, _p$1480) }];
const _p$1481 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$258, start: 0, end: 3 });
const _tmp$741 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1481);
const _p$1482 = "8";
const _tmp$742 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1482) };
const _p$1483 = 24;
const _p$1484 = undefined;
const _tmp$743 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1483, _p$1484) };
const _p$1485 = 2;
const _p$1486 = undefined;
const _bind$259 = [_tmp$742, _tmp$743, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1485, _p$1486) }];
const _p$1487 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$259, start: 0, end: 3 });
const _tmp$744 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1487);
const _p$1488 = "8";
const _tmp$745 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1488) };
const _p$1489 = 25;
const _p$1490 = undefined;
const _tmp$746 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1489, _p$1490) };
const _p$1491 = 2;
const _p$1492 = undefined;
const _bind$260 = [_tmp$745, _tmp$746, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1491, _p$1492) }];
const _p$1493 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$260, start: 0, end: 3 });
const _tmp$747 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1493);
const _p$1494 = "8";
const _tmp$748 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1494) };
const _p$1495 = 26;
const _p$1496 = undefined;
const _tmp$749 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1495, _p$1496) };
const _p$1497 = 2;
const _p$1498 = undefined;
const _bind$261 = [_tmp$748, _tmp$749, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1497, _p$1498) }];
const _p$1499 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$261, start: 0, end: 3 });
const _tmp$750 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1499);
const _p$1500 = "8";
const _tmp$751 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1500) };
const _p$1501 = 27;
const _p$1502 = undefined;
const _tmp$752 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1501, _p$1502) };
const _p$1503 = 2;
const _p$1504 = undefined;
const _bind$262 = [_tmp$751, _tmp$752, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1503, _p$1504) }];
const _p$1505 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$262, start: 0, end: 3 });
const _tmp$753 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1505);
const _p$1506 = "8";
const _tmp$754 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1506) };
const _p$1507 = 28;
const _p$1508 = undefined;
const _tmp$755 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1507, _p$1508) };
const _p$1509 = 2;
const _p$1510 = undefined;
const _bind$263 = [_tmp$754, _tmp$755, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1509, _p$1510) }];
const _p$1511 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$263, start: 0, end: 3 });
const _tmp$756 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1511);
const _p$1512 = "8";
const _tmp$757 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1512) };
const _p$1513 = 29;
const _p$1514 = undefined;
const _tmp$758 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1513, _p$1514) };
const _p$1515 = 2;
const _p$1516 = undefined;
const _bind$264 = [_tmp$757, _tmp$758, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1515, _p$1516) }];
const _p$1517 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$264, start: 0, end: 3 });
const _tmp$759 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1517);
const _p$1518 = "8";
const _tmp$760 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1518) };
const _p$1519 = 30;
const _p$1520 = undefined;
const _tmp$761 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1519, _p$1520) };
const _p$1521 = 2;
const _p$1522 = undefined;
const _bind$265 = [_tmp$760, _tmp$761, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1521, _p$1522) }];
const _p$1523 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$265, start: 0, end: 3 });
const _tmp$762 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1523);
const _p$1524 = "8";
const _tmp$763 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1524) };
const _p$1525 = 31;
const _p$1526 = undefined;
const _tmp$764 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1525, _p$1526) };
const _p$1527 = 2;
const _p$1528 = undefined;
const _bind$266 = [_tmp$763, _tmp$764, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1527, _p$1528) }];
const _p$1529 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$266, start: 0, end: 3 });
const _tmp$765 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1529);
const _p$1530 = "8";
const _tmp$766 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1530) };
const _p$1531 = 32;
const _p$1532 = undefined;
const _tmp$767 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1531, _p$1532) };
const _p$1533 = 2;
const _p$1534 = undefined;
const _bind$267 = [_tmp$766, _tmp$767, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1533, _p$1534) }];
const _p$1535 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$267, start: 0, end: 3 });
const _tmp$768 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1535);
const _p$1536 = "8";
const _tmp$769 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1536) };
const _p$1537 = 33;
const _p$1538 = undefined;
const _tmp$770 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1537, _p$1538) };
const _p$1539 = 2;
const _p$1540 = undefined;
const _bind$268 = [_tmp$769, _tmp$770, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1539, _p$1540) }];
const _p$1541 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$268, start: 0, end: 3 });
const _tmp$771 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1541);
const _p$1542 = "8";
const _tmp$772 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1542) };
const _p$1543 = 34;
const _p$1544 = undefined;
const _tmp$773 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1543, _p$1544) };
const _p$1545 = 2;
const _p$1546 = undefined;
const _bind$269 = [_tmp$772, _tmp$773, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1545, _p$1546) }];
const _p$1547 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$269, start: 0, end: 3 });
const _tmp$774 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1547);
const _p$1548 = "8";
const _tmp$775 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1548) };
const _p$1549 = 35;
const _p$1550 = undefined;
const _tmp$776 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1549, _p$1550) };
const _p$1551 = 2;
const _p$1552 = undefined;
const _bind$270 = [_tmp$775, _tmp$776, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1551, _p$1552) }];
const _p$1553 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$270, start: 0, end: 3 });
const _tmp$777 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1553);
const _p$1554 = "8";
const _tmp$778 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1554) };
const _p$1555 = 36;
const _p$1556 = undefined;
const _tmp$779 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1555, _p$1556) };
const _p$1557 = 2;
const _p$1558 = undefined;
const _bind$271 = [_tmp$778, _tmp$779, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1557, _p$1558) }];
const _p$1559 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$271, start: 0, end: 3 });
const _tmp$780 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1559);
const _p$1560 = "13";
const _tmp$781 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1560) };
const _p$1561 = 1;
const _p$1562 = undefined;
const _tmp$782 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1561, _p$1562) };
const _p$1563 = 1;
const _p$1564 = undefined;
const _bind$272 = [_tmp$781, _tmp$782, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1563, _p$1564) }];
const _p$1565 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$272, start: 0, end: 3 });
const _tmp$783 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1565);
const _p$1566 = "13";
const _tmp$784 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1566) };
const _p$1567 = 2;
const _p$1568 = undefined;
const _tmp$785 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1567, _p$1568) };
const _p$1569 = 1;
const _p$1570 = undefined;
const _bind$273 = [_tmp$784, _tmp$785, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1569, _p$1570) }];
const _p$1571 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$273, start: 0, end: 3 });
const _tmp$786 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1571);
const _p$1572 = "13";
const _tmp$787 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1572) };
const _p$1573 = 3;
const _p$1574 = undefined;
const _tmp$788 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1573, _p$1574) };
const _p$1575 = 1;
const _p$1576 = undefined;
const _bind$274 = [_tmp$787, _tmp$788, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1575, _p$1576) }];
const _p$1577 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$274, start: 0, end: 3 });
const _tmp$789 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1577);
const _p$1578 = "13";
const _tmp$790 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1578) };
const _p$1579 = 4;
const _p$1580 = undefined;
const _tmp$791 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1579, _p$1580) };
const _p$1581 = 1;
const _p$1582 = undefined;
const _bind$275 = [_tmp$790, _tmp$791, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1581, _p$1582) }];
const _p$1583 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$275, start: 0, end: 3 });
const _tmp$792 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1583);
const _p$1584 = "13";
const _tmp$793 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1584) };
const _p$1585 = 5;
const _p$1586 = undefined;
const _tmp$794 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1585, _p$1586) };
const _p$1587 = 1;
const _p$1588 = undefined;
const _bind$276 = [_tmp$793, _tmp$794, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1587, _p$1588) }];
const _p$1589 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$276, start: 0, end: 3 });
const _tmp$795 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1589);
const _p$1590 = "13";
const _tmp$796 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1590) };
const _p$1591 = 6;
const _p$1592 = undefined;
const _tmp$797 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1591, _p$1592) };
const _p$1593 = 1;
const _p$1594 = undefined;
const _bind$277 = [_tmp$796, _tmp$797, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1593, _p$1594) }];
const _p$1595 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$277, start: 0, end: 3 });
const _tmp$798 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1595);
const _p$1596 = "13";
const _tmp$799 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1596) };
const _p$1597 = 7;
const _p$1598 = undefined;
const _tmp$800 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1597, _p$1598) };
const _p$1599 = 1;
const _p$1600 = undefined;
const _bind$278 = [_tmp$799, _tmp$800, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1599, _p$1600) }];
const _p$1601 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$278, start: 0, end: 3 });
const _tmp$801 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1601);
const _p$1602 = "13";
const _tmp$802 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1602) };
const _p$1603 = 8;
const _p$1604 = undefined;
const _tmp$803 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1603, _p$1604) };
const _p$1605 = 1;
const _p$1606 = undefined;
const _bind$279 = [_tmp$802, _tmp$803, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1605, _p$1606) }];
const _p$1607 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$279, start: 0, end: 3 });
const _tmp$804 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1607);
const _p$1608 = "13";
const _tmp$805 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1608) };
const _p$1609 = 9;
const _p$1610 = undefined;
const _tmp$806 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1609, _p$1610) };
const _p$1611 = 1;
const _p$1612 = undefined;
const _bind$280 = [_tmp$805, _tmp$806, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1611, _p$1612) }];
const _p$1613 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$280, start: 0, end: 3 });
const _tmp$807 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1613);
const _p$1614 = "13";
const _tmp$808 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1614) };
const _p$1615 = 10;
const _p$1616 = undefined;
const _tmp$809 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1615, _p$1616) };
const _p$1617 = 1;
const _p$1618 = undefined;
const _bind$281 = [_tmp$808, _tmp$809, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1617, _p$1618) }];
const _p$1619 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$281, start: 0, end: 3 });
const _tmp$810 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1619);
const _p$1620 = "13";
const _tmp$811 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1620) };
const _p$1621 = 11;
const _p$1622 = undefined;
const _tmp$812 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1621, _p$1622) };
const _p$1623 = 1;
const _p$1624 = undefined;
const _bind$282 = [_tmp$811, _tmp$812, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1623, _p$1624) }];
const _p$1625 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$282, start: 0, end: 3 });
const _tmp$813 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1625);
const _p$1626 = "13";
const _tmp$814 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1626) };
const _p$1627 = 12;
const _p$1628 = undefined;
const _tmp$815 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1627, _p$1628) };
const _p$1629 = 1;
const _p$1630 = undefined;
const _bind$283 = [_tmp$814, _tmp$815, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1629, _p$1630) }];
const _p$1631 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$283, start: 0, end: 3 });
const _tmp$816 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1631);
const _p$1632 = "13";
const _tmp$817 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1632) };
const _p$1633 = 13;
const _p$1634 = undefined;
const _tmp$818 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1633, _p$1634) };
const _p$1635 = 1;
const _p$1636 = undefined;
const _bind$284 = [_tmp$817, _tmp$818, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1635, _p$1636) }];
const _p$1637 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$284, start: 0, end: 3 });
const _tmp$819 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1637);
const _p$1638 = "13";
const _tmp$820 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1638) };
const _p$1639 = 14;
const _p$1640 = undefined;
const _tmp$821 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1639, _p$1640) };
const _p$1641 = 1;
const _p$1642 = undefined;
const _bind$285 = [_tmp$820, _tmp$821, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1641, _p$1642) }];
const _p$1643 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$285, start: 0, end: 3 });
const _tmp$822 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1643);
const _p$1644 = "13";
const _tmp$823 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1644) };
const _p$1645 = 15;
const _p$1646 = undefined;
const _tmp$824 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1645, _p$1646) };
const _p$1647 = 1;
const _p$1648 = undefined;
const _bind$286 = [_tmp$823, _tmp$824, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1647, _p$1648) }];
const _p$1649 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$286, start: 0, end: 3 });
const _tmp$825 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1649);
const _p$1650 = "13";
const _tmp$826 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1650) };
const _p$1651 = 16;
const _p$1652 = undefined;
const _tmp$827 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1651, _p$1652) };
const _p$1653 = 1;
const _p$1654 = undefined;
const _bind$287 = [_tmp$826, _tmp$827, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1653, _p$1654) }];
const _p$1655 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$287, start: 0, end: 3 });
const _tmp$828 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1655);
const _p$1656 = "13";
const _tmp$829 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1656) };
const _p$1657 = 17;
const _p$1658 = undefined;
const _tmp$830 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1657, _p$1658) };
const _p$1659 = 1;
const _p$1660 = undefined;
const _bind$288 = [_tmp$829, _tmp$830, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1659, _p$1660) }];
const _p$1661 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$288, start: 0, end: 3 });
const _tmp$831 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1661);
const _p$1662 = "13";
const _tmp$832 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1662) };
const _p$1663 = 18;
const _p$1664 = undefined;
const _tmp$833 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1663, _p$1664) };
const _p$1665 = 1;
const _p$1666 = undefined;
const _bind$289 = [_tmp$832, _tmp$833, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1665, _p$1666) }];
const _p$1667 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$289, start: 0, end: 3 });
const _tmp$834 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1667);
const _p$1668 = "13";
const _tmp$835 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1668) };
const _p$1669 = 19;
const _p$1670 = undefined;
const _tmp$836 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1669, _p$1670) };
const _p$1671 = 1;
const _p$1672 = undefined;
const _bind$290 = [_tmp$835, _tmp$836, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1671, _p$1672) }];
const _p$1673 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$290, start: 0, end: 3 });
const _tmp$837 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1673);
const _p$1674 = "13";
const _tmp$838 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1674) };
const _p$1675 = 20;
const _p$1676 = undefined;
const _tmp$839 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1675, _p$1676) };
const _p$1677 = 1;
const _p$1678 = undefined;
const _bind$291 = [_tmp$838, _tmp$839, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1677, _p$1678) }];
const _p$1679 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$291, start: 0, end: 3 });
const _tmp$840 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1679);
const _p$1680 = "13";
const _tmp$841 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1680) };
const _p$1681 = 21;
const _p$1682 = undefined;
const _tmp$842 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1681, _p$1682) };
const _p$1683 = 1;
const _p$1684 = undefined;
const _bind$292 = [_tmp$841, _tmp$842, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1683, _p$1684) }];
const _p$1685 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$292, start: 0, end: 3 });
const _tmp$843 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1685);
const _p$1686 = "13";
const _tmp$844 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1686) };
const _p$1687 = 22;
const _p$1688 = undefined;
const _tmp$845 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1687, _p$1688) };
const _p$1689 = 1;
const _p$1690 = undefined;
const _bind$293 = [_tmp$844, _tmp$845, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1689, _p$1690) }];
const _p$1691 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$293, start: 0, end: 3 });
const _tmp$846 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1691);
const _p$1692 = "13";
const _tmp$847 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1692) };
const _p$1693 = 23;
const _p$1694 = undefined;
const _tmp$848 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1693, _p$1694) };
const _p$1695 = 1;
const _p$1696 = undefined;
const _bind$294 = [_tmp$847, _tmp$848, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1695, _p$1696) }];
const _p$1697 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$294, start: 0, end: 3 });
const _tmp$849 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1697);
const _p$1698 = "13";
const _tmp$850 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1698) };
const _p$1699 = 24;
const _p$1700 = undefined;
const _tmp$851 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1699, _p$1700) };
const _p$1701 = 1;
const _p$1702 = undefined;
const _bind$295 = [_tmp$850, _tmp$851, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1701, _p$1702) }];
const _p$1703 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$295, start: 0, end: 3 });
const _tmp$852 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1703);
const _p$1704 = "13";
const _tmp$853 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1704) };
const _p$1705 = 25;
const _p$1706 = undefined;
const _tmp$854 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1705, _p$1706) };
const _p$1707 = 1;
const _p$1708 = undefined;
const _bind$296 = [_tmp$853, _tmp$854, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1707, _p$1708) }];
const _p$1709 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$296, start: 0, end: 3 });
const _tmp$855 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1709);
const _p$1710 = "13";
const _tmp$856 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1710) };
const _p$1711 = 26;
const _p$1712 = undefined;
const _tmp$857 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1711, _p$1712) };
const _p$1713 = 1;
const _p$1714 = undefined;
const _bind$297 = [_tmp$856, _tmp$857, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1713, _p$1714) }];
const _p$1715 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$297, start: 0, end: 3 });
const _tmp$858 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1715);
const _p$1716 = "13";
const _tmp$859 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1716) };
const _p$1717 = 27;
const _p$1718 = undefined;
const _tmp$860 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1717, _p$1718) };
const _p$1719 = 1;
const _p$1720 = undefined;
const _bind$298 = [_tmp$859, _tmp$860, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1719, _p$1720) }];
const _p$1721 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$298, start: 0, end: 3 });
const _tmp$861 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1721);
const _p$1722 = "13";
const _tmp$862 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1722) };
const _p$1723 = 28;
const _p$1724 = undefined;
const _tmp$863 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1723, _p$1724) };
const _p$1725 = 1;
const _p$1726 = undefined;
const _bind$299 = [_tmp$862, _tmp$863, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1725, _p$1726) }];
const _p$1727 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$299, start: 0, end: 3 });
const _tmp$864 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1727);
const _p$1728 = "13";
const _tmp$865 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1728) };
const _p$1729 = 29;
const _p$1730 = undefined;
const _tmp$866 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1729, _p$1730) };
const _p$1731 = 1;
const _p$1732 = undefined;
const _bind$300 = [_tmp$865, _tmp$866, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1731, _p$1732) }];
const _p$1733 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$300, start: 0, end: 3 });
const _tmp$867 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1733);
const _p$1734 = "13";
const _tmp$868 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1734) };
const _p$1735 = 30;
const _p$1736 = undefined;
const _tmp$869 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1735, _p$1736) };
const _p$1737 = 1;
const _p$1738 = undefined;
const _bind$301 = [_tmp$868, _tmp$869, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1737, _p$1738) }];
const _p$1739 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$301, start: 0, end: 3 });
const _tmp$870 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1739);
const _p$1740 = "13";
const _tmp$871 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1740) };
const _p$1741 = 31;
const _p$1742 = undefined;
const _tmp$872 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1741, _p$1742) };
const _p$1743 = 1;
const _p$1744 = undefined;
const _bind$302 = [_tmp$871, _tmp$872, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1743, _p$1744) }];
const _p$1745 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$302, start: 0, end: 3 });
const _tmp$873 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1745);
const _p$1746 = "13";
const _tmp$874 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1746) };
const _p$1747 = 32;
const _p$1748 = undefined;
const _tmp$875 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1747, _p$1748) };
const _p$1749 = 1;
const _p$1750 = undefined;
const _bind$303 = [_tmp$874, _tmp$875, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1749, _p$1750) }];
const _p$1751 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$303, start: 0, end: 3 });
const _tmp$876 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1751);
const _p$1752 = "13";
const _tmp$877 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1752) };
const _p$1753 = 33;
const _p$1754 = undefined;
const _tmp$878 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1753, _p$1754) };
const _p$1755 = 1;
const _p$1756 = undefined;
const _bind$304 = [_tmp$877, _tmp$878, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1755, _p$1756) }];
const _p$1757 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$304, start: 0, end: 3 });
const _tmp$879 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1757);
const _p$1758 = "13";
const _tmp$880 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1758) };
const _p$1759 = 34;
const _p$1760 = undefined;
const _tmp$881 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1759, _p$1760) };
const _p$1761 = 1;
const _p$1762 = undefined;
const _bind$305 = [_tmp$880, _tmp$881, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1761, _p$1762) }];
const _p$1763 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$305, start: 0, end: 3 });
const _tmp$882 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1763);
const _p$1764 = "13";
const _tmp$883 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1764) };
const _p$1765 = 35;
const _p$1766 = undefined;
const _tmp$884 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1765, _p$1766) };
const _p$1767 = 1;
const _p$1768 = undefined;
const _bind$306 = [_tmp$883, _tmp$884, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1767, _p$1768) }];
const _p$1769 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$306, start: 0, end: 3 });
const _tmp$885 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1769);
const _p$1770 = "13";
const _tmp$886 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1770) };
const _p$1771 = 36;
const _p$1772 = undefined;
const _tmp$887 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1771, _p$1772) };
const _p$1773 = 1;
const _p$1774 = undefined;
const _bind$307 = [_tmp$886, _tmp$887, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1773, _p$1774) }];
const _p$1775 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$307, start: 0, end: 3 });
const _tmp$888 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1775);
const _p$1776 = "9";
const _tmp$889 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1776) };
const _p$1777 = 40;
const _p$1778 = undefined;
const _tmp$890 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1777, _p$1778) };
const _p$1779 = 0;
const _p$1780 = undefined;
const _bind$308 = [_tmp$889, _tmp$890, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1779, _p$1780) }];
const _p$1781 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$308, start: 0, end: 3 });
const _tmp$891 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1781);
const _p$1782 = "9";
const _tmp$892 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1782) };
const _p$1783 = 41;
const _p$1784 = undefined;
const _tmp$893 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1783, _p$1784) };
const _p$1785 = 0;
const _p$1786 = undefined;
const _bind$309 = [_tmp$892, _tmp$893, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1785, _p$1786) }];
const _p$1787 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$309, start: 0, end: 3 });
const _tmp$894 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1787);
const _p$1788 = "9";
const _tmp$895 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1788) };
const _p$1789 = 42;
const _p$1790 = undefined;
const _tmp$896 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1789, _p$1790) };
const _p$1791 = 0;
const _p$1792 = undefined;
const _bind$310 = [_tmp$895, _tmp$896, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1791, _p$1792) }];
const _p$1793 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$310, start: 0, end: 3 });
const _tmp$897 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1793);
const _p$1794 = "9";
const _tmp$898 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1794) };
const _p$1795 = 43;
const _p$1796 = undefined;
const _tmp$899 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1795, _p$1796) };
const _p$1797 = 0;
const _p$1798 = undefined;
const _bind$311 = [_tmp$898, _tmp$899, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1797, _p$1798) }];
const _p$1799 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$311, start: 0, end: 3 });
const _tmp$900 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1799);
const _p$1800 = "9";
const _tmp$901 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1800) };
const _p$1801 = 44;
const _p$1802 = undefined;
const _tmp$902 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1801, _p$1802) };
const _p$1803 = 0;
const _p$1804 = undefined;
const _bind$312 = [_tmp$901, _tmp$902, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1803, _p$1804) }];
const _p$1805 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$312, start: 0, end: 3 });
const _tmp$903 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1805);
const _p$1806 = "9";
const _tmp$904 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1806) };
const _p$1807 = 45;
const _p$1808 = undefined;
const _tmp$905 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1807, _p$1808) };
const _p$1809 = 0;
const _p$1810 = undefined;
const _bind$313 = [_tmp$904, _tmp$905, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1809, _p$1810) }];
const _p$1811 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$313, start: 0, end: 3 });
const _tmp$906 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1811);
const _p$1812 = "9";
const _tmp$907 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1812) };
const _p$1813 = 46;
const _p$1814 = undefined;
const _tmp$908 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1813, _p$1814) };
const _p$1815 = 0;
const _p$1816 = undefined;
const _bind$314 = [_tmp$907, _tmp$908, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1815, _p$1816) }];
const _p$1817 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$314, start: 0, end: 3 });
const _tmp$909 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1817);
const _p$1818 = "9";
const _tmp$910 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1818) };
const _p$1819 = 47;
const _p$1820 = undefined;
const _tmp$911 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1819, _p$1820) };
const _p$1821 = 0;
const _p$1822 = undefined;
const _bind$315 = [_tmp$910, _tmp$911, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1821, _p$1822) }];
const _p$1823 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$315, start: 0, end: 3 });
const _tmp$912 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1823);
const _p$1824 = "9";
const _tmp$913 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1824) };
const _p$1825 = 48;
const _p$1826 = undefined;
const _tmp$914 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1825, _p$1826) };
const _p$1827 = 0;
const _p$1828 = undefined;
const _bind$316 = [_tmp$913, _tmp$914, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1827, _p$1828) }];
const _p$1829 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$316, start: 0, end: 3 });
const _tmp$915 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1829);
const _p$1830 = "9";
const _tmp$916 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1830) };
const _p$1831 = 49;
const _p$1832 = undefined;
const _tmp$917 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1831, _p$1832) };
const _p$1833 = 0;
const _p$1834 = undefined;
const _bind$317 = [_tmp$916, _tmp$917, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1833, _p$1834) }];
const _p$1835 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$317, start: 0, end: 3 });
const _tmp$918 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1835);
const _p$1836 = "9";
const _tmp$919 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1836) };
const _p$1837 = 50;
const _p$1838 = undefined;
const _tmp$920 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1837, _p$1838) };
const _p$1839 = 0;
const _p$1840 = undefined;
const _bind$318 = [_tmp$919, _tmp$920, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1839, _p$1840) }];
const _p$1841 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$318, start: 0, end: 3 });
const _tmp$921 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1841);
const _p$1842 = "9";
const _tmp$922 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1842) };
const _p$1843 = 51;
const _p$1844 = undefined;
const _tmp$923 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1843, _p$1844) };
const _p$1845 = 0;
const _p$1846 = undefined;
const _bind$319 = [_tmp$922, _tmp$923, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1845, _p$1846) }];
const _p$1847 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$319, start: 0, end: 3 });
const _tmp$924 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1847);
const _p$1848 = "9";
const _tmp$925 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1848) };
const _p$1849 = 52;
const _p$1850 = undefined;
const _tmp$926 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1849, _p$1850) };
const _p$1851 = 0;
const _p$1852 = undefined;
const _bind$320 = [_tmp$925, _tmp$926, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1851, _p$1852) }];
const _p$1853 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$320, start: 0, end: 3 });
const _tmp$927 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1853);
const _p$1854 = "9";
const _tmp$928 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1854) };
const _p$1855 = 53;
const _p$1856 = undefined;
const _tmp$929 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1855, _p$1856) };
const _p$1857 = 0;
const _p$1858 = undefined;
const _bind$321 = [_tmp$928, _tmp$929, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1857, _p$1858) }];
const _p$1859 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$321, start: 0, end: 3 });
const _tmp$930 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1859);
const _p$1860 = "9";
const _tmp$931 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1860) };
const _p$1861 = 37;
const _p$1862 = undefined;
const _tmp$932 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1861, _p$1862) };
const _p$1863 = 0;
const _p$1864 = undefined;
const _bind$322 = [_tmp$931, _tmp$932, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1863, _p$1864) }];
const _p$1865 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$322, start: 0, end: 3 });
const _tmp$933 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1865);
const _p$1866 = "9";
const _tmp$934 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1866) };
const _p$1867 = 38;
const _p$1868 = undefined;
const _tmp$935 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1867, _p$1868) };
const _p$1869 = 0;
const _p$1870 = undefined;
const _bind$323 = [_tmp$934, _tmp$935, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1869, _p$1870) }];
const _p$1871 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$323, start: 0, end: 3 });
const _tmp$936 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1871);
const _p$1872 = "9";
const _tmp$937 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1872) };
const _p$1873 = 39;
const _p$1874 = undefined;
const _tmp$938 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1873, _p$1874) };
const _p$1875 = 0;
const _p$1876 = undefined;
const _bind$324 = [_tmp$937, _tmp$938, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1875, _p$1876) }];
const _p$1877 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$324, start: 0, end: 3 });
const _tmp$939 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1877);
const _p$1878 = "13";
const _tmp$940 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1878) };
const _p$1879 = 37;
const _p$1880 = undefined;
const _tmp$941 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1879, _p$1880) };
const _p$1881 = 1;
const _p$1882 = undefined;
const _bind$325 = [_tmp$940, _tmp$941, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1881, _p$1882) }];
const _p$1883 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$325, start: 0, end: 3 });
const _tmp$942 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1883);
const _p$1884 = "8";
const _tmp$943 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1884) };
const _p$1885 = 37;
const _p$1886 = undefined;
const _tmp$944 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1885, _p$1886) };
const _p$1887 = 2;
const _p$1888 = undefined;
const _bind$326 = [_tmp$943, _tmp$944, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1887, _p$1888) }];
const _p$1889 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$326, start: 0, end: 3 });
const _tmp$945 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1889);
const _p$1890 = "13";
const _tmp$946 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1890) };
const _p$1891 = 38;
const _p$1892 = undefined;
const _tmp$947 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1891, _p$1892) };
const _p$1893 = 1;
const _p$1894 = undefined;
const _bind$327 = [_tmp$946, _tmp$947, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1893, _p$1894) }];
const _p$1895 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$327, start: 0, end: 3 });
const _tmp$948 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1895);
const _p$1896 = "8";
const _tmp$949 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1896) };
const _p$1897 = 38;
const _p$1898 = undefined;
const _tmp$950 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1897, _p$1898) };
const _p$1899 = 2;
const _p$1900 = undefined;
const _bind$328 = [_tmp$949, _tmp$950, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1899, _p$1900) }];
const _p$1901 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$328, start: 0, end: 3 });
const _tmp$951 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1901);
const _p$1902 = "8";
const _tmp$952 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1902) };
const _p$1903 = 39;
const _p$1904 = undefined;
const _tmp$953 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1903, _p$1904) };
const _p$1905 = 2;
const _p$1906 = undefined;
const _bind$329 = [_tmp$952, _tmp$953, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1905, _p$1906) }];
const _p$1907 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$329, start: 0, end: 3 });
const _tmp$954 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1907);
const _p$1908 = "8";
const _tmp$955 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1908) };
const _p$1909 = 40;
const _p$1910 = undefined;
const _tmp$956 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1909, _p$1910) };
const _p$1911 = 2;
const _p$1912 = undefined;
const _bind$330 = [_tmp$955, _tmp$956, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1911, _p$1912) }];
const _p$1913 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$330, start: 0, end: 3 });
const _tmp$957 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1913);
const _p$1914 = "8";
const _tmp$958 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1914) };
const _p$1915 = 41;
const _p$1916 = undefined;
const _tmp$959 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1915, _p$1916) };
const _p$1917 = 2;
const _p$1918 = undefined;
const _bind$331 = [_tmp$958, _tmp$959, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1917, _p$1918) }];
const _p$1919 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$331, start: 0, end: 3 });
const _tmp$960 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1919);
const _p$1920 = "8";
const _tmp$961 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1920) };
const _p$1921 = 42;
const _p$1922 = undefined;
const _tmp$962 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1921, _p$1922) };
const _p$1923 = 2;
const _p$1924 = undefined;
const _bind$332 = [_tmp$961, _tmp$962, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1923, _p$1924) }];
const _p$1925 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$332, start: 0, end: 3 });
const _tmp$963 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1925);
const _p$1926 = "8";
const _tmp$964 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1926) };
const _p$1927 = 43;
const _p$1928 = undefined;
const _tmp$965 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1927, _p$1928) };
const _p$1929 = 2;
const _p$1930 = undefined;
const _bind$333 = [_tmp$964, _tmp$965, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1929, _p$1930) }];
const _p$1931 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$333, start: 0, end: 3 });
const _tmp$966 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1931);
const _p$1932 = "8";
const _tmp$967 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1932) };
const _p$1933 = 44;
const _p$1934 = undefined;
const _tmp$968 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1933, _p$1934) };
const _p$1935 = 2;
const _p$1936 = undefined;
const _bind$334 = [_tmp$967, _tmp$968, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1935, _p$1936) }];
const _p$1937 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$334, start: 0, end: 3 });
const _tmp$969 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1937);
const _p$1938 = "8";
const _tmp$970 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1938) };
const _p$1939 = 45;
const _p$1940 = undefined;
const _tmp$971 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1939, _p$1940) };
const _p$1941 = 2;
const _p$1942 = undefined;
const _bind$335 = [_tmp$970, _tmp$971, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1941, _p$1942) }];
const _p$1943 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$335, start: 0, end: 3 });
const _tmp$972 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1943);
const _p$1944 = "8";
const _tmp$973 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1944) };
const _p$1945 = 46;
const _p$1946 = undefined;
const _tmp$974 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1945, _p$1946) };
const _p$1947 = 2;
const _p$1948 = undefined;
const _bind$336 = [_tmp$973, _tmp$974, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1947, _p$1948) }];
const _p$1949 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$336, start: 0, end: 3 });
const _tmp$975 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1949);
const _p$1950 = "8";
const _tmp$976 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1950) };
const _p$1951 = 47;
const _p$1952 = undefined;
const _tmp$977 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1951, _p$1952) };
const _p$1953 = 2;
const _p$1954 = undefined;
const _bind$337 = [_tmp$976, _tmp$977, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1953, _p$1954) }];
const _p$1955 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$337, start: 0, end: 3 });
const _tmp$978 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1955);
const _p$1956 = "8";
const _tmp$979 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1956) };
const _p$1957 = 48;
const _p$1958 = undefined;
const _tmp$980 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1957, _p$1958) };
const _p$1959 = 2;
const _p$1960 = undefined;
const _bind$338 = [_tmp$979, _tmp$980, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1959, _p$1960) }];
const _p$1961 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$338, start: 0, end: 3 });
const _tmp$981 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1961);
const _p$1962 = "8";
const _tmp$982 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1962) };
const _p$1963 = 49;
const _p$1964 = undefined;
const _tmp$983 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1963, _p$1964) };
const _p$1965 = 2;
const _p$1966 = undefined;
const _bind$339 = [_tmp$982, _tmp$983, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1965, _p$1966) }];
const _p$1967 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$339, start: 0, end: 3 });
const _tmp$984 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1967);
const _p$1968 = "8";
const _tmp$985 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1968) };
const _p$1969 = 50;
const _p$1970 = undefined;
const _tmp$986 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1969, _p$1970) };
const _p$1971 = 2;
const _p$1972 = undefined;
const _bind$340 = [_tmp$985, _tmp$986, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1971, _p$1972) }];
const _p$1973 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$340, start: 0, end: 3 });
const _tmp$987 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1973);
const _p$1974 = "8";
const _tmp$988 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1974) };
const _p$1975 = 51;
const _p$1976 = undefined;
const _tmp$989 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1975, _p$1976) };
const _p$1977 = 2;
const _p$1978 = undefined;
const _bind$341 = [_tmp$988, _tmp$989, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1977, _p$1978) }];
const _p$1979 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$341, start: 0, end: 3 });
const _tmp$990 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1979);
const _p$1980 = "8";
const _tmp$991 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1980) };
const _p$1981 = 52;
const _p$1982 = undefined;
const _tmp$992 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1981, _p$1982) };
const _p$1983 = 2;
const _p$1984 = undefined;
const _bind$342 = [_tmp$991, _tmp$992, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1983, _p$1984) }];
const _p$1985 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$342, start: 0, end: 3 });
const _tmp$993 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1985);
const _p$1986 = "8";
const _tmp$994 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1986) };
const _p$1987 = 53;
const _p$1988 = undefined;
const _tmp$995 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1987, _p$1988) };
const _p$1989 = 2;
const _p$1990 = undefined;
const _bind$343 = [_tmp$994, _tmp$995, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1989, _p$1990) }];
const _p$1991 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$343, start: 0, end: 3 });
const _tmp$996 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1991);
const _p$1992 = "13";
const _tmp$997 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1992) };
const _p$1993 = 39;
const _p$1994 = undefined;
const _tmp$998 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1993, _p$1994) };
const _p$1995 = 1;
const _p$1996 = undefined;
const _bind$344 = [_tmp$997, _tmp$998, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1995, _p$1996) }];
const _p$1997 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$344, start: 0, end: 3 });
const _tmp$999 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$1997);
const _p$1998 = "13";
const _tmp$1000 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$1998) };
const _p$1999 = 40;
const _p$2000 = undefined;
const _tmp$1001 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$1999, _p$2000) };
const _p$2001 = 1;
const _p$2002 = undefined;
const _bind$345 = [_tmp$1000, _tmp$1001, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2001, _p$2002) }];
const _p$2003 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$345, start: 0, end: 3 });
const _tmp$1002 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2003);
const _p$2004 = "13";
const _tmp$1003 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2004) };
const _p$2005 = 41;
const _p$2006 = undefined;
const _tmp$1004 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2005, _p$2006) };
const _p$2007 = 1;
const _p$2008 = undefined;
const _bind$346 = [_tmp$1003, _tmp$1004, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2007, _p$2008) }];
const _p$2009 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$346, start: 0, end: 3 });
const _tmp$1005 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2009);
const _p$2010 = "13";
const _tmp$1006 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2010) };
const _p$2011 = 42;
const _p$2012 = undefined;
const _tmp$1007 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2011, _p$2012) };
const _p$2013 = 1;
const _p$2014 = undefined;
const _bind$347 = [_tmp$1006, _tmp$1007, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2013, _p$2014) }];
const _p$2015 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$347, start: 0, end: 3 });
const _tmp$1008 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2015);
const _p$2016 = "13";
const _tmp$1009 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2016) };
const _p$2017 = 43;
const _p$2018 = undefined;
const _tmp$1010 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2017, _p$2018) };
const _p$2019 = 1;
const _p$2020 = undefined;
const _bind$348 = [_tmp$1009, _tmp$1010, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2019, _p$2020) }];
const _p$2021 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$348, start: 0, end: 3 });
const _tmp$1011 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2021);
const _p$2022 = "13";
const _tmp$1012 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2022) };
const _p$2023 = 44;
const _p$2024 = undefined;
const _tmp$1013 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2023, _p$2024) };
const _p$2025 = 1;
const _p$2026 = undefined;
const _bind$349 = [_tmp$1012, _tmp$1013, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2025, _p$2026) }];
const _p$2027 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$349, start: 0, end: 3 });
const _tmp$1014 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2027);
const _p$2028 = "13";
const _tmp$1015 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2028) };
const _p$2029 = 45;
const _p$2030 = undefined;
const _tmp$1016 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2029, _p$2030) };
const _p$2031 = 1;
const _p$2032 = undefined;
const _bind$350 = [_tmp$1015, _tmp$1016, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2031, _p$2032) }];
const _p$2033 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$350, start: 0, end: 3 });
const _tmp$1017 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2033);
const _p$2034 = "13";
const _tmp$1018 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2034) };
const _p$2035 = 46;
const _p$2036 = undefined;
const _tmp$1019 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2035, _p$2036) };
const _p$2037 = 1;
const _p$2038 = undefined;
const _bind$351 = [_tmp$1018, _tmp$1019, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2037, _p$2038) }];
const _p$2039 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$351, start: 0, end: 3 });
const _tmp$1020 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2039);
const _p$2040 = "13";
const _tmp$1021 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2040) };
const _p$2041 = 47;
const _p$2042 = undefined;
const _tmp$1022 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2041, _p$2042) };
const _p$2043 = 1;
const _p$2044 = undefined;
const _bind$352 = [_tmp$1021, _tmp$1022, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2043, _p$2044) }];
const _p$2045 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$352, start: 0, end: 3 });
const _tmp$1023 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2045);
const _p$2046 = "13";
const _tmp$1024 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2046) };
const _p$2047 = 48;
const _p$2048 = undefined;
const _tmp$1025 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2047, _p$2048) };
const _p$2049 = 1;
const _p$2050 = undefined;
const _bind$353 = [_tmp$1024, _tmp$1025, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2049, _p$2050) }];
const _p$2051 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$353, start: 0, end: 3 });
const _tmp$1026 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2051);
const _p$2052 = "13";
const _tmp$1027 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2052) };
const _p$2053 = 49;
const _p$2054 = undefined;
const _tmp$1028 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2053, _p$2054) };
const _p$2055 = 1;
const _p$2056 = undefined;
const _bind$354 = [_tmp$1027, _tmp$1028, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2055, _p$2056) }];
const _p$2057 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$354, start: 0, end: 3 });
const _tmp$1029 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2057);
const _p$2058 = "13";
const _tmp$1030 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2058) };
const _p$2059 = 50;
const _p$2060 = undefined;
const _tmp$1031 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2059, _p$2060) };
const _p$2061 = 1;
const _p$2062 = undefined;
const _bind$355 = [_tmp$1030, _tmp$1031, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2061, _p$2062) }];
const _p$2063 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$355, start: 0, end: 3 });
const _tmp$1032 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2063);
const _p$2064 = "13";
const _tmp$1033 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2064) };
const _p$2065 = 51;
const _p$2066 = undefined;
const _tmp$1034 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2065, _p$2066) };
const _p$2067 = 1;
const _p$2068 = undefined;
const _bind$356 = [_tmp$1033, _tmp$1034, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2067, _p$2068) }];
const _p$2069 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$356, start: 0, end: 3 });
const _tmp$1035 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2069);
const _p$2070 = "13";
const _tmp$1036 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2070) };
const _p$2071 = 52;
const _p$2072 = undefined;
const _tmp$1037 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2071, _p$2072) };
const _p$2073 = 1;
const _p$2074 = undefined;
const _bind$357 = [_tmp$1036, _tmp$1037, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2073, _p$2074) }];
const _p$2075 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$357, start: 0, end: 3 });
const _tmp$1038 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2075);
const _p$2076 = "13";
const _tmp$1039 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2076) };
const _p$2077 = 53;
const _p$2078 = undefined;
const _tmp$1040 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2077, _p$2078) };
const _p$2079 = 1;
const _p$2080 = undefined;
const _bind$358 = [_tmp$1039, _tmp$1040, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2079, _p$2080) }];
const _p$2081 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$358, start: 0, end: 3 });
const _tmp$1041 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2081);
const _p$2082 = "9";
const _tmp$1042 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2082) };
const _p$2083 = 54;
const _p$2084 = undefined;
const _tmp$1043 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2083, _p$2084) };
const _p$2085 = 0;
const _p$2086 = undefined;
const _bind$359 = [_tmp$1042, _tmp$1043, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2085, _p$2086) }];
const _p$2087 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$359, start: 0, end: 3 });
const _tmp$1044 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2087);
const _p$2088 = "9";
const _tmp$1045 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2088) };
const _p$2089 = 55;
const _p$2090 = undefined;
const _tmp$1046 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2089, _p$2090) };
const _p$2091 = 0;
const _p$2092 = undefined;
const _bind$360 = [_tmp$1045, _tmp$1046, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2091, _p$2092) }];
const _p$2093 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$360, start: 0, end: 3 });
const _tmp$1047 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2093);
const _p$2094 = "9";
const _tmp$1048 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2094) };
const _p$2095 = 56;
const _p$2096 = undefined;
const _tmp$1049 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2095, _p$2096) };
const _p$2097 = 0;
const _p$2098 = undefined;
const _bind$361 = [_tmp$1048, _tmp$1049, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2097, _p$2098) }];
const _p$2099 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$361, start: 0, end: 3 });
const _tmp$1050 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2099);
const _p$2100 = "16";
const _tmp$1051 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2100) };
const _p$2101 = 57;
const _p$2102 = undefined;
const _tmp$1052 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2101, _p$2102) };
const _p$2103 = 0;
const _p$2104 = undefined;
const _bind$362 = [_tmp$1051, _tmp$1052, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2103, _p$2104) }];
const _p$2105 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$362, start: 0, end: 3 });
const _tmp$1053 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2105);
const _p$2106 = "13";
const _tmp$1054 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2106) };
const _p$2107 = 54;
const _p$2108 = undefined;
const _tmp$1055 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2107, _p$2108) };
const _p$2109 = 1;
const _p$2110 = undefined;
const _bind$363 = [_tmp$1054, _tmp$1055, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2109, _p$2110) }];
const _p$2111 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$363, start: 0, end: 3 });
const _tmp$1056 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2111);
const _p$2112 = "13";
const _tmp$1057 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2112) };
const _p$2113 = 55;
const _p$2114 = undefined;
const _tmp$1058 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2113, _p$2114) };
const _p$2115 = 1;
const _p$2116 = undefined;
const _bind$364 = [_tmp$1057, _tmp$1058, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2115, _p$2116) }];
const _p$2117 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$364, start: 0, end: 3 });
const _tmp$1059 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2117);
const _p$2118 = "10";
const _tmp$1060 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2118) };
const _p$2119 = 57;
const _p$2120 = undefined;
const _tmp$1061 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2119, _p$2120) };
const _p$2121 = 1;
const _p$2122 = undefined;
const _bind$365 = [_tmp$1060, _tmp$1061, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2121, _p$2122) }];
const _p$2123 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$365, start: 0, end: 3 });
const _tmp$1062 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2123);
const _p$2124 = "8";
const _tmp$1063 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2124) };
const _p$2125 = 54;
const _p$2126 = undefined;
const _tmp$1064 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2125, _p$2126) };
const _p$2127 = 2;
const _p$2128 = undefined;
const _bind$366 = [_tmp$1063, _tmp$1064, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2127, _p$2128) }];
const _p$2129 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$366, start: 0, end: 3 });
const _tmp$1065 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2129);
const _p$2130 = "13";
const _tmp$1066 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2130) };
const _p$2131 = 55;
const _p$2132 = undefined;
const _tmp$1067 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2131, _p$2132) };
const _p$2133 = 2;
const _p$2134 = undefined;
const _bind$367 = [_tmp$1066, _tmp$1067, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2133, _p$2134) }];
const _p$2135 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$367, start: 0, end: 3 });
const _tmp$1068 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2135);
const _p$2136 = "10";
const _tmp$1069 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2136) };
const _p$2137 = 57;
const _p$2138 = undefined;
const _tmp$1070 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2137, _p$2138) };
const _p$2139 = 2;
const _p$2140 = undefined;
const _bind$368 = [_tmp$1069, _tmp$1070, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2139, _p$2140) }];
const _p$2141 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$368, start: 0, end: 3 });
const _tmp$1071 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2141);
const _p$2142 = "11";
const _tmp$1072 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2142) };
const _p$2143 = 55;
const _p$2144 = undefined;
const _tmp$1073 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2143, _p$2144) };
const _p$2145 = 3;
const _p$2146 = undefined;
const _bind$369 = [_tmp$1072, _tmp$1073, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2145, _p$2146) }];
const _p$2147 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$369, start: 0, end: 3 });
const _tmp$1074 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2147);
const _p$2148 = "10";
const _tmp$1075 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2148) };
const _p$2149 = 57;
const _p$2150 = undefined;
const _tmp$1076 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2149, _p$2150) };
const _p$2151 = 3;
const _p$2152 = undefined;
const _bind$370 = [_tmp$1075, _tmp$1076, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2151, _p$2152) }];
const _p$2153 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$370, start: 0, end: 3 });
const _tmp$1077 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2153);
const _p$2154 = "11";
const _tmp$1078 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2154) };
const _p$2155 = 55;
const _p$2156 = undefined;
const _tmp$1079 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2155, _p$2156) };
const _p$2157 = 4;
const _p$2158 = undefined;
const _bind$371 = [_tmp$1078, _tmp$1079, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2157, _p$2158) }];
const _p$2159 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$371, start: 0, end: 3 });
const _tmp$1080 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2159);
const _p$2160 = "10";
const _tmp$1081 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2160) };
const _p$2161 = 57;
const _p$2162 = undefined;
const _tmp$1082 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2161, _p$2162) };
const _p$2163 = 4;
const _p$2164 = undefined;
const _bind$372 = [_tmp$1081, _tmp$1082, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2163, _p$2164) }];
const _p$2165 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$372, start: 0, end: 3 });
const _tmp$1083 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2165);
const _p$2166 = "11";
const _tmp$1084 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2166) };
const _p$2167 = 55;
const _p$2168 = undefined;
const _tmp$1085 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2167, _p$2168) };
const _p$2169 = 5;
const _p$2170 = undefined;
const _bind$373 = [_tmp$1084, _tmp$1085, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2169, _p$2170) }];
const _p$2171 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$373, start: 0, end: 3 });
const _tmp$1086 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2171);
const _p$2172 = "10";
const _tmp$1087 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2172) };
const _p$2173 = 57;
const _p$2174 = undefined;
const _tmp$1088 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2173, _p$2174) };
const _p$2175 = 5;
const _p$2176 = undefined;
const _bind$374 = [_tmp$1087, _tmp$1088, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2175, _p$2176) }];
const _p$2177 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$374, start: 0, end: 3 });
const _tmp$1089 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2177);
const _p$2178 = "10";
const _tmp$1090 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2178) };
const _p$2179 = 57;
const _p$2180 = undefined;
const _tmp$1091 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2179, _p$2180) };
const _p$2181 = 6;
const _p$2182 = undefined;
const _bind$375 = [_tmp$1090, _tmp$1091, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2181, _p$2182) }];
const _p$2183 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$375, start: 0, end: 3 });
const _tmp$1092 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2183);
const _p$2184 = "10";
const _tmp$1093 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2184) };
const _p$2185 = 57;
const _p$2186 = undefined;
const _tmp$1094 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2185, _p$2186) };
const _p$2187 = 7;
const _p$2188 = undefined;
const _bind$376 = [_tmp$1093, _tmp$1094, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2187, _p$2188) }];
const _p$2189 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$376, start: 0, end: 3 });
const _tmp$1095 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2189);
const _p$2190 = "10";
const _tmp$1096 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2190) };
const _p$2191 = 57;
const _p$2192 = undefined;
const _tmp$1097 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2191, _p$2192) };
const _p$2193 = 8;
const _p$2194 = undefined;
const _bind$377 = [_tmp$1096, _tmp$1097, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2193, _p$2194) }];
const _p$2195 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$377, start: 0, end: 3 });
const _tmp$1098 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2195);
const _p$2196 = "10";
const _tmp$1099 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2196) };
const _p$2197 = 57;
const _p$2198 = undefined;
const _tmp$1100 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2197, _p$2198) };
const _p$2199 = 9;
const _p$2200 = undefined;
const _bind$378 = [_tmp$1099, _tmp$1100, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2199, _p$2200) }];
const _p$2201 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$378, start: 0, end: 3 });
const _tmp$1101 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2201);
const _p$2202 = "10";
const _tmp$1102 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2202) };
const _p$2203 = 57;
const _p$2204 = undefined;
const _tmp$1103 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2203, _p$2204) };
const _p$2205 = 10;
const _p$2206 = undefined;
const _bind$379 = [_tmp$1102, _tmp$1103, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2205, _p$2206) }];
const _p$2207 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$379, start: 0, end: 3 });
const _tmp$1104 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2207);
const _p$2208 = "10";
const _tmp$1105 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2208) };
const _p$2209 = 57;
const _p$2210 = undefined;
const _tmp$1106 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2209, _p$2210) };
const _p$2211 = 11;
const _p$2212 = undefined;
const _bind$380 = [_tmp$1105, _tmp$1106, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2211, _p$2212) }];
const _p$2213 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$380, start: 0, end: 3 });
const _tmp$1107 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2213);
const _p$2214 = "10";
const _tmp$1108 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2214) };
const _p$2215 = 57;
const _p$2216 = undefined;
const _tmp$1109 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2215, _p$2216) };
const _p$2217 = 12;
const _p$2218 = undefined;
const _bind$381 = [_tmp$1108, _tmp$1109, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2217, _p$2218) }];
const _p$2219 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$381, start: 0, end: 3 });
const _tmp$1110 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2219);
const _p$2220 = "10";
const _tmp$1111 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2220) };
const _p$2221 = 57;
const _p$2222 = undefined;
const _tmp$1112 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2221, _p$2222) };
const _p$2223 = 13;
const _p$2224 = undefined;
const _bind$382 = [_tmp$1111, _tmp$1112, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2223, _p$2224) }];
const _p$2225 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$382, start: 0, end: 3 });
const _tmp$1113 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2225);
const _p$2226 = "10";
const _tmp$1114 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2226) };
const _p$2227 = 57;
const _p$2228 = undefined;
const _tmp$1115 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2227, _p$2228) };
const _p$2229 = 14;
const _p$2230 = undefined;
const _bind$383 = [_tmp$1114, _tmp$1115, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2229, _p$2230) }];
const _p$2231 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$383, start: 0, end: 3 });
const _tmp$1116 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2231);
const _p$2232 = "10";
const _tmp$1117 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2232) };
const _p$2233 = 57;
const _p$2234 = undefined;
const _tmp$1118 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2233, _p$2234) };
const _p$2235 = 15;
const _p$2236 = undefined;
const _bind$384 = [_tmp$1117, _tmp$1118, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2235, _p$2236) }];
const _p$2237 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$384, start: 0, end: 3 });
const _tmp$1119 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2237);
const _p$2238 = "10";
const _tmp$1120 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2238) };
const _p$2239 = 57;
const _p$2240 = undefined;
const _tmp$1121 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2239, _p$2240) };
const _p$2241 = 16;
const _p$2242 = undefined;
const _bind$385 = [_tmp$1120, _tmp$1121, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2241, _p$2242) }];
const _p$2243 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$385, start: 0, end: 3 });
const _tmp$1122 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2243);
const _p$2244 = "10";
const _tmp$1123 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2244) };
const _p$2245 = 57;
const _p$2246 = undefined;
const _tmp$1124 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2245, _p$2246) };
const _p$2247 = 17;
const _p$2248 = undefined;
const _bind$386 = [_tmp$1123, _tmp$1124, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2247, _p$2248) }];
const _p$2249 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$386, start: 0, end: 3 });
const _tmp$1125 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2249);
const _p$2250 = "10";
const _tmp$1126 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2250) };
const _p$2251 = 57;
const _p$2252 = undefined;
const _tmp$1127 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2251, _p$2252) };
const _p$2253 = 18;
const _p$2254 = undefined;
const _bind$387 = [_tmp$1126, _tmp$1127, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2253, _p$2254) }];
const _p$2255 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$387, start: 0, end: 3 });
const _tmp$1128 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2255);
const _p$2256 = "10";
const _tmp$1129 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2256) };
const _p$2257 = 57;
const _p$2258 = undefined;
const _tmp$1130 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2257, _p$2258) };
const _p$2259 = 19;
const _p$2260 = undefined;
const _bind$388 = [_tmp$1129, _tmp$1130, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2259, _p$2260) }];
const _p$2261 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$388, start: 0, end: 3 });
const _tmp$1131 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2261);
const _p$2262 = "10";
const _tmp$1132 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2262) };
const _p$2263 = 57;
const _p$2264 = undefined;
const _tmp$1133 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2263, _p$2264) };
const _p$2265 = 20;
const _p$2266 = undefined;
const _bind$389 = [_tmp$1132, _tmp$1133, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2265, _p$2266) }];
const _p$2267 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$389, start: 0, end: 3 });
const _tmp$1134 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2267);
const _p$2268 = "10";
const _tmp$1135 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2268) };
const _p$2269 = 57;
const _p$2270 = undefined;
const _tmp$1136 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2269, _p$2270) };
const _p$2271 = 21;
const _p$2272 = undefined;
const _bind$390 = [_tmp$1135, _tmp$1136, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2271, _p$2272) }];
const _p$2273 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$390, start: 0, end: 3 });
const _tmp$1137 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2273);
const _p$2274 = "10";
const _tmp$1138 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2274) };
const _p$2275 = 57;
const _p$2276 = undefined;
const _tmp$1139 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2275, _p$2276) };
const _p$2277 = 22;
const _p$2278 = undefined;
const _bind$391 = [_tmp$1138, _tmp$1139, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2277, _p$2278) }];
const _p$2279 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$391, start: 0, end: 3 });
const _tmp$1140 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2279);
const _p$2280 = "10";
const _tmp$1141 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2280) };
const _p$2281 = 57;
const _p$2282 = undefined;
const _tmp$1142 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2281, _p$2282) };
const _p$2283 = 23;
const _p$2284 = undefined;
const _bind$392 = [_tmp$1141, _tmp$1142, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2283, _p$2284) }];
const _p$2285 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$392, start: 0, end: 3 });
const _tmp$1143 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2285);
const _p$2286 = "10";
const _tmp$1144 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2286) };
const _p$2287 = 57;
const _p$2288 = undefined;
const _tmp$1145 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2287, _p$2288) };
const _p$2289 = 24;
const _p$2290 = undefined;
const _bind$393 = [_tmp$1144, _tmp$1145, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2289, _p$2290) }];
const _p$2291 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$393, start: 0, end: 3 });
const _tmp$1146 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2291);
const _p$2292 = "10";
const _tmp$1147 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2292) };
const _p$2293 = 57;
const _p$2294 = undefined;
const _tmp$1148 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2293, _p$2294) };
const _p$2295 = 25;
const _p$2296 = undefined;
const _bind$394 = [_tmp$1147, _tmp$1148, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2295, _p$2296) }];
const _p$2297 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$394, start: 0, end: 3 });
const _tmp$1149 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2297);
const _p$2298 = "10";
const _tmp$1150 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2298) };
const _p$2299 = 57;
const _p$2300 = undefined;
const _tmp$1151 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2299, _p$2300) };
const _p$2301 = 26;
const _p$2302 = undefined;
const _bind$395 = [_tmp$1150, _tmp$1151, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2301, _p$2302) }];
const _p$2303 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$395, start: 0, end: 3 });
const _tmp$1152 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2303);
const _p$2304 = "10";
const _tmp$1153 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2304) };
const _p$2305 = 57;
const _p$2306 = undefined;
const _tmp$1154 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2305, _p$2306) };
const _p$2307 = 27;
const _p$2308 = undefined;
const _bind$396 = [_tmp$1153, _tmp$1154, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2307, _p$2308) }];
const _p$2309 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$396, start: 0, end: 3 });
const _tmp$1155 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2309);
const _p$2310 = "10";
const _tmp$1156 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2310) };
const _p$2311 = 57;
const _p$2312 = undefined;
const _tmp$1157 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2311, _p$2312) };
const _p$2313 = 28;
const _p$2314 = undefined;
const _bind$397 = [_tmp$1156, _tmp$1157, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2313, _p$2314) }];
const _p$2315 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$397, start: 0, end: 3 });
const _tmp$1158 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2315);
const _p$2316 = "10";
const _tmp$1159 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2316) };
const _p$2317 = 57;
const _p$2318 = undefined;
const _tmp$1160 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2317, _p$2318) };
const _p$2319 = 29;
const _p$2320 = undefined;
const _bind$398 = [_tmp$1159, _tmp$1160, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2319, _p$2320) }];
const _p$2321 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$398, start: 0, end: 3 });
const _tmp$1161 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2321);
const _p$2322 = "10";
const _tmp$1162 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2322) };
const _p$2323 = 57;
const _p$2324 = undefined;
const _tmp$1163 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2323, _p$2324) };
const _p$2325 = 30;
const _p$2326 = undefined;
const _bind$399 = [_tmp$1162, _tmp$1163, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2325, _p$2326) }];
const _p$2327 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$399, start: 0, end: 3 });
const _tmp$1164 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2327);
const _p$2328 = "10";
const _tmp$1165 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2328) };
const _p$2329 = 57;
const _p$2330 = undefined;
const _tmp$1166 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2329, _p$2330) };
const _p$2331 = 31;
const _p$2332 = undefined;
const _bind$400 = [_tmp$1165, _tmp$1166, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2331, _p$2332) }];
const _p$2333 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$400, start: 0, end: 3 });
const _tmp$1167 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2333);
const _p$2334 = "13";
const _tmp$1168 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2334) };
const _p$2335 = 56;
const _p$2336 = undefined;
const _tmp$1169 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2335, _p$2336) };
const _p$2337 = 1;
const _p$2338 = undefined;
const _bind$401 = [_tmp$1168, _tmp$1169, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2337, _p$2338) }];
const _p$2339 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$401, start: 0, end: 3 });
const _tmp$1170 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2339);
const _p$2340 = "13";
const _tmp$1171 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2340) };
const _p$2341 = 56;
const _p$2342 = undefined;
const _tmp$1172 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2341, _p$2342) };
const _p$2343 = 2;
const _p$2344 = undefined;
const _bind$402 = [_tmp$1171, _tmp$1172, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2343, _p$2344) }];
const _p$2345 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$402, start: 0, end: 3 });
const _tmp$1173 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2345);
const _p$2346 = "13";
const _tmp$1174 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2346) };
const _p$2347 = 56;
const _p$2348 = undefined;
const _tmp$1175 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2347, _p$2348) };
const _p$2349 = 3;
const _p$2350 = undefined;
const _bind$403 = [_tmp$1174, _tmp$1175, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2349, _p$2350) }];
const _p$2351 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$403, start: 0, end: 3 });
const _tmp$1176 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2351);
const _p$2352 = "13";
const _tmp$1177 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2352) };
const _p$2353 = 56;
const _p$2354 = undefined;
const _tmp$1178 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2353, _p$2354) };
const _p$2355 = 4;
const _p$2356 = undefined;
const _bind$404 = [_tmp$1177, _tmp$1178, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2355, _p$2356) }];
const _p$2357 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$404, start: 0, end: 3 });
const _tmp$1179 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2357);
const _p$2358 = "13";
const _tmp$1180 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2358) };
const _p$2359 = 56;
const _p$2360 = undefined;
const _tmp$1181 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2359, _p$2360) };
const _p$2361 = 5;
const _p$2362 = undefined;
const _bind$405 = [_tmp$1180, _tmp$1181, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2361, _p$2362) }];
const _p$2363 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$405, start: 0, end: 3 });
const _tmp$1182 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2363);
const _p$2364 = "13";
const _tmp$1183 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2364) };
const _p$2365 = 56;
const _p$2366 = undefined;
const _tmp$1184 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2365, _p$2366) };
const _p$2367 = 6;
const _p$2368 = undefined;
const _bind$406 = [_tmp$1183, _tmp$1184, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2367, _p$2368) }];
const _p$2369 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$406, start: 0, end: 3 });
const _tmp$1185 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2369);
const _p$2370 = "13";
const _tmp$1186 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2370) };
const _p$2371 = 56;
const _p$2372 = undefined;
const _tmp$1187 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2371, _p$2372) };
const _p$2373 = 7;
const _p$2374 = undefined;
const _bind$407 = [_tmp$1186, _tmp$1187, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2373, _p$2374) }];
const _p$2375 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$407, start: 0, end: 3 });
const _tmp$1188 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2375);
const _p$2376 = "13";
const _tmp$1189 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2376) };
const _p$2377 = 56;
const _p$2378 = undefined;
const _tmp$1190 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2377, _p$2378) };
const _p$2379 = 8;
const _p$2380 = undefined;
const _bind$408 = [_tmp$1189, _tmp$1190, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2379, _p$2380) }];
const _p$2381 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$408, start: 0, end: 3 });
const _tmp$1191 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2381);
const _p$2382 = "13";
const _tmp$1192 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2382) };
const _p$2383 = 56;
const _p$2384 = undefined;
const _tmp$1193 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2383, _p$2384) };
const _p$2385 = 9;
const _p$2386 = undefined;
const _bind$409 = [_tmp$1192, _tmp$1193, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2385, _p$2386) }];
const _p$2387 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$409, start: 0, end: 3 });
const _tmp$1194 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2387);
const _p$2388 = "13";
const _tmp$1195 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2388) };
const _p$2389 = 56;
const _p$2390 = undefined;
const _tmp$1196 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2389, _p$2390) };
const _p$2391 = 10;
const _p$2392 = undefined;
const _bind$410 = [_tmp$1195, _tmp$1196, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2391, _p$2392) }];
const _p$2393 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$410, start: 0, end: 3 });
const _tmp$1197 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2393);
const _p$2394 = "13";
const _tmp$1198 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2394) };
const _p$2395 = 56;
const _p$2396 = undefined;
const _tmp$1199 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2395, _p$2396) };
const _p$2397 = 17;
const _p$2398 = undefined;
const _bind$411 = [_tmp$1198, _tmp$1199, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2397, _p$2398) }];
const _p$2399 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$411, start: 0, end: 3 });
const _tmp$1200 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2399);
const _p$2400 = "13";
const _tmp$1201 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2400) };
const _p$2401 = 56;
const _p$2402 = undefined;
const _tmp$1202 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2401, _p$2402) };
const _p$2403 = 18;
const _p$2404 = undefined;
const _bind$412 = [_tmp$1201, _tmp$1202, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2403, _p$2404) }];
const _p$2405 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$412, start: 0, end: 3 });
const _tmp$1203 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2405);
const _p$2406 = "13";
const _tmp$1204 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2406) };
const _p$2407 = 56;
const _p$2408 = undefined;
const _tmp$1205 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2407, _p$2408) };
const _p$2409 = 19;
const _p$2410 = undefined;
const _bind$413 = [_tmp$1204, _tmp$1205, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2409, _p$2410) }];
const _p$2411 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$413, start: 0, end: 3 });
const _tmp$1206 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2411);
const _p$2412 = "13";
const _tmp$1207 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2412) };
const _p$2413 = 56;
const _p$2414 = undefined;
const _tmp$1208 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2413, _p$2414) };
const _p$2415 = 20;
const _p$2416 = undefined;
const _bind$414 = [_tmp$1207, _tmp$1208, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2415, _p$2416) }];
const _p$2417 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$414, start: 0, end: 3 });
const _tmp$1209 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2417);
const _p$2418 = "13";
const _tmp$1210 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2418) };
const _p$2419 = 56;
const _p$2420 = undefined;
const _tmp$1211 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2419, _p$2420) };
const _p$2421 = 21;
const _p$2422 = undefined;
const _bind$415 = [_tmp$1210, _tmp$1211, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2421, _p$2422) }];
const _p$2423 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$415, start: 0, end: 3 });
const _tmp$1212 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2423);
const _p$2424 = "13";
const _tmp$1213 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2424) };
const _p$2425 = 56;
const _p$2426 = undefined;
const _tmp$1214 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2425, _p$2426) };
const _p$2427 = 22;
const _p$2428 = undefined;
const _bind$416 = [_tmp$1213, _tmp$1214, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2427, _p$2428) }];
const _p$2429 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$416, start: 0, end: 3 });
const _tmp$1215 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2429);
const _p$2430 = "13";
const _tmp$1216 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2430) };
const _p$2431 = 56;
const _p$2432 = undefined;
const _tmp$1217 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2431, _p$2432) };
const _p$2433 = 23;
const _p$2434 = undefined;
const _bind$417 = [_tmp$1216, _tmp$1217, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2433, _p$2434) }];
const _p$2435 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$417, start: 0, end: 3 });
const _tmp$1218 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2435);
const _p$2436 = "13";
const _tmp$1219 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2436) };
const _p$2437 = 56;
const _p$2438 = undefined;
const _tmp$1220 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2437, _p$2438) };
const _p$2439 = 28;
const _p$2440 = undefined;
const _bind$418 = [_tmp$1219, _tmp$1220, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2439, _p$2440) }];
const _p$2441 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$418, start: 0, end: 3 });
const _tmp$1221 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2441);
const _p$2442 = "13";
const _tmp$1222 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2442) };
const _p$2443 = 56;
const _p$2444 = undefined;
const _tmp$1223 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2443, _p$2444) };
const _p$2445 = 29;
const _p$2446 = undefined;
const _bind$419 = [_tmp$1222, _tmp$1223, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2445, _p$2446) }];
const _p$2447 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$419, start: 0, end: 3 });
const _tmp$1224 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2447);
const _p$2448 = "13";
const _tmp$1225 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2448) };
const _p$2449 = 56;
const _p$2450 = undefined;
const _tmp$1226 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2449, _p$2450) };
const _p$2451 = 30;
const _p$2452 = undefined;
const _bind$420 = [_tmp$1225, _tmp$1226, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2451, _p$2452) }];
const _p$2453 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$420, start: 0, end: 3 });
const _tmp$1227 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2453);
const _p$2454 = "13";
const _tmp$1228 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2454) };
const _p$2455 = 56;
const _p$2456 = undefined;
const _tmp$1229 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2455, _p$2456) };
const _p$2457 = 31;
const _p$2458 = undefined;
const _bind$421 = [_tmp$1228, _tmp$1229, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2457, _p$2458) }];
const _p$2459 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$421, start: 0, end: 3 });
const _tmp$1230 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2459);
const _p$2460 = "13";
const _tmp$1231 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2460) };
const _p$2461 = 56;
const _p$2462 = undefined;
const _tmp$1232 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2461, _p$2462) };
const _p$2463 = 32;
const _p$2464 = undefined;
const _bind$422 = [_tmp$1231, _tmp$1232, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2463, _p$2464) }];
const _p$2465 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$422, start: 0, end: 3 });
const _tmp$1233 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2465);
const _p$2466 = "10";
const _tmp$1234 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2466) };
const _p$2467 = 57;
const _p$2468 = undefined;
const _tmp$1235 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2467, _p$2468) };
const _p$2469 = 32;
const _p$2470 = undefined;
const _bind$423 = [_tmp$1234, _tmp$1235, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2469, _p$2470) }];
const _p$2471 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$423, start: 0, end: 3 });
const _tmp$1236 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2471);
const _p$2472 = "13";
const _tmp$1237 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2472) };
const _p$2473 = 56;
const _p$2474 = undefined;
const _tmp$1238 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2473, _p$2474) };
const _p$2475 = 33;
const _p$2476 = undefined;
const _bind$424 = [_tmp$1237, _tmp$1238, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2475, _p$2476) }];
const _p$2477 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$424, start: 0, end: 3 });
const _tmp$1239 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2477);
const _p$2478 = "10";
const _tmp$1240 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2478) };
const _p$2479 = 57;
const _p$2480 = undefined;
const _tmp$1241 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2479, _p$2480) };
const _p$2481 = 33;
const _p$2482 = undefined;
const _bind$425 = [_tmp$1240, _tmp$1241, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2481, _p$2482) }];
const _p$2483 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$425, start: 0, end: 3 });
const _tmp$1242 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2483);
const _p$2484 = "13";
const _tmp$1243 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2484) };
const _p$2485 = 38;
const _p$2486 = undefined;
const _tmp$1244 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2485, _p$2486) };
const _p$2487 = 34;
const _p$2488 = undefined;
const _bind$426 = [_tmp$1243, _tmp$1244, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2487, _p$2488) }];
const _p$2489 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$426, start: 0, end: 3 });
const _tmp$1245 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2489);
const _p$2490 = "8";
const _tmp$1246 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2490) };
const _p$2491 = 38;
const _p$2492 = undefined;
const _tmp$1247 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2491, _p$2492) };
const _p$2493 = 35;
const _p$2494 = undefined;
const _bind$427 = [_tmp$1246, _tmp$1247, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2493, _p$2494) }];
const _p$2495 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$427, start: 0, end: 3 });
const _tmp$1248 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2495);
const _p$2496 = "13";
const _tmp$1249 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2496) };
const _p$2497 = 39;
const _p$2498 = undefined;
const _tmp$1250 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2497, _p$2498) };
const _p$2499 = 34;
const _p$2500 = undefined;
const _bind$428 = [_tmp$1249, _tmp$1250, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2499, _p$2500) }];
const _p$2501 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$428, start: 0, end: 3 });
const _tmp$1251 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2501);
const _p$2502 = "8";
const _tmp$1252 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2502) };
const _p$2503 = 39;
const _p$2504 = undefined;
const _tmp$1253 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2503, _p$2504) };
const _p$2505 = 35;
const _p$2506 = undefined;
const _bind$429 = [_tmp$1252, _tmp$1253, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2505, _p$2506) }];
const _p$2507 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$429, start: 0, end: 3 });
const _tmp$1254 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2507);
const _p$2508 = "8";
const _tmp$1255 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2508) };
const _p$2509 = 40;
const _p$2510 = undefined;
const _tmp$1256 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2509, _p$2510) };
const _p$2511 = 35;
const _p$2512 = undefined;
const _bind$430 = [_tmp$1255, _tmp$1256, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2511, _p$2512) }];
const _p$2513 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$430, start: 0, end: 3 });
const _tmp$1257 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2513);
const _p$2514 = "8";
const _tmp$1258 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2514) };
const _p$2515 = 41;
const _p$2516 = undefined;
const _tmp$1259 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2515, _p$2516) };
const _p$2517 = 35;
const _p$2518 = undefined;
const _bind$431 = [_tmp$1258, _tmp$1259, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2517, _p$2518) }];
const _p$2519 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$431, start: 0, end: 3 });
const _tmp$1260 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2519);
const _p$2520 = "8";
const _tmp$1261 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2520) };
const _p$2521 = 42;
const _p$2522 = undefined;
const _tmp$1262 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2521, _p$2522) };
const _p$2523 = 35;
const _p$2524 = undefined;
const _bind$432 = [_tmp$1261, _tmp$1262, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2523, _p$2524) }];
const _p$2525 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$432, start: 0, end: 3 });
const _tmp$1263 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2525);
const _p$2526 = "8";
const _tmp$1264 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2526) };
const _p$2527 = 43;
const _p$2528 = undefined;
const _tmp$1265 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2527, _p$2528) };
const _p$2529 = 35;
const _p$2530 = undefined;
const _bind$433 = [_tmp$1264, _tmp$1265, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2529, _p$2530) }];
const _p$2531 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$433, start: 0, end: 3 });
const _tmp$1266 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2531);
const _p$2532 = "8";
const _tmp$1267 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2532) };
const _p$2533 = 44;
const _p$2534 = undefined;
const _tmp$1268 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2533, _p$2534) };
const _p$2535 = 35;
const _p$2536 = undefined;
const _bind$434 = [_tmp$1267, _tmp$1268, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2535, _p$2536) }];
const _p$2537 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$434, start: 0, end: 3 });
const _tmp$1269 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2537);
const _p$2538 = "8";
const _tmp$1270 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2538) };
const _p$2539 = 45;
const _p$2540 = undefined;
const _tmp$1271 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2539, _p$2540) };
const _p$2541 = 35;
const _p$2542 = undefined;
const _bind$435 = [_tmp$1270, _tmp$1271, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2541, _p$2542) }];
const _p$2543 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$435, start: 0, end: 3 });
const _tmp$1272 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2543);
const _p$2544 = "8";
const _tmp$1273 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2544) };
const _p$2545 = 46;
const _p$2546 = undefined;
const _tmp$1274 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2545, _p$2546) };
const _p$2547 = 35;
const _p$2548 = undefined;
const _bind$436 = [_tmp$1273, _tmp$1274, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2547, _p$2548) }];
const _p$2549 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$436, start: 0, end: 3 });
const _tmp$1275 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2549);
const _p$2550 = "8";
const _tmp$1276 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2550) };
const _p$2551 = 47;
const _p$2552 = undefined;
const _tmp$1277 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2551, _p$2552) };
const _p$2553 = 35;
const _p$2554 = undefined;
const _bind$437 = [_tmp$1276, _tmp$1277, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2553, _p$2554) }];
const _p$2555 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$437, start: 0, end: 3 });
const _tmp$1278 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2555);
const _p$2556 = "8";
const _tmp$1279 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2556) };
const _p$2557 = 48;
const _p$2558 = undefined;
const _tmp$1280 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2557, _p$2558) };
const _p$2559 = 35;
const _p$2560 = undefined;
const _bind$438 = [_tmp$1279, _tmp$1280, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2559, _p$2560) }];
const _p$2561 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$438, start: 0, end: 3 });
const _tmp$1281 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2561);
const _p$2562 = "8";
const _tmp$1282 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2562) };
const _p$2563 = 49;
const _p$2564 = undefined;
const _tmp$1283 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2563, _p$2564) };
const _p$2565 = 35;
const _p$2566 = undefined;
const _bind$439 = [_tmp$1282, _tmp$1283, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2565, _p$2566) }];
const _p$2567 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$439, start: 0, end: 3 });
const _tmp$1284 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2567);
const _p$2568 = "8";
const _tmp$1285 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2568) };
const _p$2569 = 50;
const _p$2570 = undefined;
const _tmp$1286 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2569, _p$2570) };
const _p$2571 = 35;
const _p$2572 = undefined;
const _bind$440 = [_tmp$1285, _tmp$1286, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2571, _p$2572) }];
const _p$2573 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$440, start: 0, end: 3 });
const _tmp$1287 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2573);
const _p$2574 = "8";
const _tmp$1288 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2574) };
const _p$2575 = 51;
const _p$2576 = undefined;
const _tmp$1289 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2575, _p$2576) };
const _p$2577 = 35;
const _p$2578 = undefined;
const _bind$441 = [_tmp$1288, _tmp$1289, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2577, _p$2578) }];
const _p$2579 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$441, start: 0, end: 3 });
const _tmp$1290 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2579);
const _p$2580 = "8";
const _tmp$1291 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2580) };
const _p$2581 = 52;
const _p$2582 = undefined;
const _tmp$1292 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2581, _p$2582) };
const _p$2583 = 35;
const _p$2584 = undefined;
const _bind$442 = [_tmp$1291, _tmp$1292, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2583, _p$2584) }];
const _p$2585 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$442, start: 0, end: 3 });
const _tmp$1293 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2585);
const _p$2586 = "8";
const _tmp$1294 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2586) };
const _p$2587 = 53;
const _p$2588 = undefined;
const _tmp$1295 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2587, _p$2588) };
const _p$2589 = 35;
const _p$2590 = undefined;
const _bind$443 = [_tmp$1294, _tmp$1295, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2589, _p$2590) }];
const _p$2591 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$443, start: 0, end: 3 });
const _tmp$1296 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2591);
const _p$2592 = "8";
const _tmp$1297 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2592) };
const _p$2593 = 54;
const _p$2594 = undefined;
const _tmp$1298 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2593, _p$2594) };
const _p$2595 = 35;
const _p$2596 = undefined;
const _bind$444 = [_tmp$1297, _tmp$1298, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2595, _p$2596) }];
const _p$2597 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$444, start: 0, end: 3 });
const _tmp$1299 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2597);
const _p$2598 = "8";
const _tmp$1300 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2598) };
const _p$2599 = 55;
const _p$2600 = undefined;
const _tmp$1301 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2599, _p$2600) };
const _p$2601 = 35;
const _p$2602 = undefined;
const _bind$445 = [_tmp$1300, _tmp$1301, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2601, _p$2602) }];
const _p$2603 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$445, start: 0, end: 3 });
const _tmp$1302 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2603);
const _p$2604 = "10";
const _tmp$1303 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2604) };
const _p$2605 = 57;
const _p$2606 = undefined;
const _tmp$1304 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2605, _p$2606) };
const _p$2607 = 34;
const _p$2608 = undefined;
const _bind$446 = [_tmp$1303, _tmp$1304, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2607, _p$2608) }];
const _p$2609 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$446, start: 0, end: 3 });
const _tmp$1305 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2609);
const _p$2610 = "8";
const _tmp$1306 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2610) };
const _p$2611 = 56;
const _p$2612 = undefined;
const _tmp$1307 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2611, _p$2612) };
const _p$2613 = 35;
const _p$2614 = undefined;
const _bind$447 = [_tmp$1306, _tmp$1307, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2613, _p$2614) }];
const _p$2615 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$447, start: 0, end: 3 });
const _tmp$1308 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2615);
const _p$2616 = "12";
const _tmp$1309 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2616) };
const _p$2617 = 57;
const _p$2618 = undefined;
const _tmp$1310 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2617, _p$2618) };
const _p$2619 = 35;
const _p$2620 = undefined;
const _bind$448 = [_tmp$1309, _tmp$1310, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2619, _p$2620) }];
const _p$2621 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$448, start: 0, end: 3 });
const _tmp$1311 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2621);
const _p$2622 = "13";
const _tmp$1312 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2622) };
const _p$2623 = 40;
const _p$2624 = undefined;
const _tmp$1313 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2623, _p$2624) };
const _p$2625 = 34;
const _p$2626 = undefined;
const _bind$449 = [_tmp$1312, _tmp$1313, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2625, _p$2626) }];
const _p$2627 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$449, start: 0, end: 3 });
const _tmp$1314 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2627);
const _p$2628 = "13";
const _tmp$1315 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2628) };
const _p$2629 = 41;
const _p$2630 = undefined;
const _tmp$1316 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2629, _p$2630) };
const _p$2631 = 34;
const _p$2632 = undefined;
const _bind$450 = [_tmp$1315, _tmp$1316, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2631, _p$2632) }];
const _p$2633 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$450, start: 0, end: 3 });
const _tmp$1317 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2633);
const _p$2634 = "13";
const _tmp$1318 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2634) };
const _p$2635 = 42;
const _p$2636 = undefined;
const _tmp$1319 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2635, _p$2636) };
const _p$2637 = 34;
const _p$2638 = undefined;
const _bind$451 = [_tmp$1318, _tmp$1319, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2637, _p$2638) }];
const _p$2639 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$451, start: 0, end: 3 });
const _tmp$1320 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2639);
const _p$2640 = "13";
const _tmp$1321 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2640) };
const _p$2641 = 43;
const _p$2642 = undefined;
const _tmp$1322 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2641, _p$2642) };
const _p$2643 = 34;
const _p$2644 = undefined;
const _bind$452 = [_tmp$1321, _tmp$1322, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2643, _p$2644) }];
const _p$2645 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$452, start: 0, end: 3 });
const _tmp$1323 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2645);
const _p$2646 = "13";
const _tmp$1324 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2646) };
const _p$2647 = 44;
const _p$2648 = undefined;
const _tmp$1325 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2647, _p$2648) };
const _p$2649 = 34;
const _p$2650 = undefined;
const _bind$453 = [_tmp$1324, _tmp$1325, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2649, _p$2650) }];
const _p$2651 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$453, start: 0, end: 3 });
const _tmp$1326 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2651);
const _p$2652 = "13";
const _tmp$1327 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2652) };
const _p$2653 = 45;
const _p$2654 = undefined;
const _tmp$1328 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2653, _p$2654) };
const _p$2655 = 34;
const _p$2656 = undefined;
const _bind$454 = [_tmp$1327, _tmp$1328, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2655, _p$2656) }];
const _p$2657 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$454, start: 0, end: 3 });
const _tmp$1329 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2657);
const _p$2658 = "13";
const _tmp$1330 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2658) };
const _p$2659 = 46;
const _p$2660 = undefined;
const _tmp$1331 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2659, _p$2660) };
const _p$2661 = 34;
const _p$2662 = undefined;
const _bind$455 = [_tmp$1330, _tmp$1331, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2661, _p$2662) }];
const _p$2663 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$455, start: 0, end: 3 });
const _tmp$1332 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2663);
const _p$2664 = "13";
const _tmp$1333 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2664) };
const _p$2665 = 47;
const _p$2666 = undefined;
const _tmp$1334 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2665, _p$2666) };
const _p$2667 = 34;
const _p$2668 = undefined;
const _bind$456 = [_tmp$1333, _tmp$1334, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2667, _p$2668) }];
const _p$2669 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$456, start: 0, end: 3 });
const _tmp$1335 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2669);
const _p$2670 = "13";
const _tmp$1336 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2670) };
const _p$2671 = 48;
const _p$2672 = undefined;
const _tmp$1337 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2671, _p$2672) };
const _p$2673 = 34;
const _p$2674 = undefined;
const _bind$457 = [_tmp$1336, _tmp$1337, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2673, _p$2674) }];
const _p$2675 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$457, start: 0, end: 3 });
const _tmp$1338 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2675);
const _p$2676 = "13";
const _tmp$1339 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2676) };
const _p$2677 = 49;
const _p$2678 = undefined;
const _tmp$1340 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2677, _p$2678) };
const _p$2679 = 34;
const _p$2680 = undefined;
const _bind$458 = [_tmp$1339, _tmp$1340, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2679, _p$2680) }];
const _p$2681 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$458, start: 0, end: 3 });
const _tmp$1341 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2681);
const _p$2682 = "13";
const _tmp$1342 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2682) };
const _p$2683 = 50;
const _p$2684 = undefined;
const _tmp$1343 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2683, _p$2684) };
const _p$2685 = 34;
const _p$2686 = undefined;
const _bind$459 = [_tmp$1342, _tmp$1343, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2685, _p$2686) }];
const _p$2687 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$459, start: 0, end: 3 });
const _tmp$1344 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2687);
const _p$2688 = "13";
const _tmp$1345 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2688) };
const _p$2689 = 51;
const _p$2690 = undefined;
const _tmp$1346 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2689, _p$2690) };
const _p$2691 = 34;
const _p$2692 = undefined;
const _bind$460 = [_tmp$1345, _tmp$1346, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2691, _p$2692) }];
const _p$2693 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$460, start: 0, end: 3 });
const _tmp$1347 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2693);
const _p$2694 = "13";
const _tmp$1348 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2694) };
const _p$2695 = 52;
const _p$2696 = undefined;
const _tmp$1349 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2695, _p$2696) };
const _p$2697 = 34;
const _p$2698 = undefined;
const _bind$461 = [_tmp$1348, _tmp$1349, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2697, _p$2698) }];
const _p$2699 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$461, start: 0, end: 3 });
const _tmp$1350 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2699);
const _p$2700 = "13";
const _tmp$1351 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2700) };
const _p$2701 = 53;
const _p$2702 = undefined;
const _tmp$1352 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2701, _p$2702) };
const _p$2703 = 34;
const _p$2704 = undefined;
const _bind$462 = [_tmp$1351, _tmp$1352, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2703, _p$2704) }];
const _p$2705 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$462, start: 0, end: 3 });
const _tmp$1353 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2705);
const _p$2706 = "13";
const _tmp$1354 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2706) };
const _p$2707 = 54;
const _p$2708 = undefined;
const _tmp$1355 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2707, _p$2708) };
const _p$2709 = 34;
const _p$2710 = undefined;
const _bind$463 = [_tmp$1354, _tmp$1355, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2709, _p$2710) }];
const _p$2711 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$463, start: 0, end: 3 });
const _tmp$1356 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2711);
const _p$2712 = "13";
const _tmp$1357 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2712) };
const _p$2713 = 55;
const _p$2714 = undefined;
const _tmp$1358 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2713, _p$2714) };
const _p$2715 = 34;
const _p$2716 = undefined;
const _bind$464 = [_tmp$1357, _tmp$1358, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2715, _p$2716) }];
const _p$2717 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$464, start: 0, end: 3 });
const _tmp$1359 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2717);
const _p$2718 = "13";
const _tmp$1360 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2718) };
const _p$2719 = 56;
const _p$2720 = undefined;
const _tmp$1361 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2719, _p$2720) };
const _p$2721 = 34;
const _p$2722 = undefined;
const _bind$465 = [_tmp$1360, _tmp$1361, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2721, _p$2722) }];
const _p$2723 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$465, start: 0, end: 3 });
const _tmp$1362 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2723);
const _p$2724 = "13";
const _tmp$1363 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2724) };
const _p$2725 = 56;
const _p$2726 = undefined;
const _tmp$1364 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2725, _p$2726) };
const _p$2727 = 24;
const _p$2728 = undefined;
const _bind$466 = [_tmp$1363, _tmp$1364, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2727, _p$2728) }];
const _p$2729 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$466, start: 0, end: 3 });
const _tmp$1365 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2729);
const _p$2730 = "13";
const _tmp$1366 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2730) };
const _p$2731 = 56;
const _p$2732 = undefined;
const _tmp$1367 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2731, _p$2732) };
const _p$2733 = 25;
const _p$2734 = undefined;
const _bind$467 = [_tmp$1366, _tmp$1367, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2733, _p$2734) }];
const _p$2735 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$467, start: 0, end: 3 });
const _tmp$1368 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2735);
const _p$2736 = "13";
const _tmp$1369 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2736) };
const _p$2737 = 56;
const _p$2738 = undefined;
const _tmp$1370 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2737, _p$2738) };
const _p$2739 = 26;
const _p$2740 = undefined;
const _bind$468 = [_tmp$1369, _tmp$1370, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2739, _p$2740) }];
const _p$2741 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$468, start: 0, end: 3 });
const _tmp$1371 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2741);
const _p$2742 = "13";
const _tmp$1372 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2742) };
const _p$2743 = 56;
const _p$2744 = undefined;
const _tmp$1373 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2743, _p$2744) };
const _p$2745 = 27;
const _p$2746 = undefined;
const _bind$469 = [_tmp$1372, _tmp$1373, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2745, _p$2746) }];
const _p$2747 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$469, start: 0, end: 3 });
const _tmp$1374 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2747);
const _p$2748 = "13";
const _tmp$1375 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2748) };
const _p$2749 = 56;
const _p$2750 = undefined;
const _tmp$1376 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2749, _p$2750) };
const _p$2751 = 15;
const _p$2752 = undefined;
const _bind$470 = [_tmp$1375, _tmp$1376, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2751, _p$2752) }];
const _p$2753 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$470, start: 0, end: 3 });
const _tmp$1377 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2753);
const _p$2754 = "13";
const _tmp$1378 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2754) };
const _p$2755 = 56;
const _p$2756 = undefined;
const _tmp$1379 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2755, _p$2756) };
const _p$2757 = 16;
const _p$2758 = undefined;
const _bind$471 = [_tmp$1378, _tmp$1379, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2757, _p$2758) }];
const _p$2759 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$471, start: 0, end: 3 });
const _tmp$1380 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2759);
const _p$2760 = "13";
const _tmp$1381 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2760) };
const _p$2761 = 56;
const _p$2762 = undefined;
const _tmp$1382 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2761, _p$2762) };
const _p$2763 = 11;
const _p$2764 = undefined;
const _bind$472 = [_tmp$1381, _tmp$1382, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2763, _p$2764) }];
const _p$2765 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$472, start: 0, end: 3 });
const _tmp$1383 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2765);
const _p$2766 = "13";
const _tmp$1384 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2766) };
const _p$2767 = 56;
const _p$2768 = undefined;
const _tmp$1385 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2767, _p$2768) };
const _p$2769 = 12;
const _p$2770 = undefined;
const _bind$473 = [_tmp$1384, _tmp$1385, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2769, _p$2770) }];
const _p$2771 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$473, start: 0, end: 3 });
const _tmp$1386 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2771);
const _p$2772 = "13";
const _tmp$1387 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2772) };
const _p$2773 = 56;
const _p$2774 = undefined;
const _tmp$1388 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2773, _p$2774) };
const _p$2775 = 13;
const _p$2776 = undefined;
const _bind$474 = [_tmp$1387, _tmp$1388, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2775, _p$2776) }];
const _p$2777 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$474, start: 0, end: 3 });
const _tmp$1389 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2777);
const _p$2778 = "13";
const _tmp$1390 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2778) };
const _p$2779 = 56;
const _p$2780 = undefined;
const _tmp$1391 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2779, _p$2780) };
const _p$2781 = 14;
const _p$2782 = undefined;
const _bind$475 = [_tmp$1390, _tmp$1391, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2781, _p$2782) }];
const _p$2783 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$475, start: 0, end: 3 });
const _tmp$1392 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2783);
const _p$2784 = "10";
const _tmp$1393 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2784) };
const _p$2785 = 2;
const _p$2786 = undefined;
const _tmp$1394 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2785, _p$2786) };
const _p$2787 = 12;
const _p$2788 = undefined;
const _bind$476 = [_tmp$1393, _tmp$1394, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2787, _p$2788) }];
const _p$2789 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$476, start: 0, end: 3 });
const _tmp$1395 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2789);
const _p$2790 = "10";
const _tmp$1396 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2790) };
const _p$2791 = 2;
const _p$2792 = undefined;
const _tmp$1397 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2791, _p$2792) };
const _p$2793 = 19;
const _p$2794 = undefined;
const _bind$477 = [_tmp$1396, _tmp$1397, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2793, _p$2794) }];
const _p$2795 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$477, start: 0, end: 3 });
const _tmp$1398 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2795);
const _p$2796 = "10";
const _tmp$1399 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2796) };
const _p$2797 = 2;
const _p$2798 = undefined;
const _tmp$1400 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2797, _p$2798) };
const _p$2799 = 20;
const _p$2800 = undefined;
const _bind$478 = [_tmp$1399, _tmp$1400, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2799, _p$2800) }];
const _p$2801 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$478, start: 0, end: 3 });
const _tmp$1401 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2801);
const _p$2802 = "10";
const _tmp$1402 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2802) };
const _p$2803 = 2;
const _p$2804 = undefined;
const _tmp$1403 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2803, _p$2804) };
const _p$2805 = 21;
const _p$2806 = undefined;
const _bind$479 = [_tmp$1402, _tmp$1403, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2805, _p$2806) }];
const _p$2807 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$479, start: 0, end: 3 });
const _tmp$1404 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2807);
const _p$2808 = "10";
const _tmp$1405 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2808) };
const _p$2809 = 2;
const _p$2810 = undefined;
const _tmp$1406 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2809, _p$2810) };
const _p$2811 = 28;
const _p$2812 = undefined;
const _bind$480 = [_tmp$1405, _tmp$1406, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2811, _p$2812) }];
const _p$2813 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$480, start: 0, end: 3 });
const _tmp$1407 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2813);
const _p$2814 = "10";
const _tmp$1408 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2814) };
const _p$2815 = 2;
const _p$2816 = undefined;
const _tmp$1409 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2815, _p$2816) };
const _p$2817 = 29;
const _p$2818 = undefined;
const _bind$481 = [_tmp$1408, _tmp$1409, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2817, _p$2818) }];
const _p$2819 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$481, start: 0, end: 3 });
const _tmp$1410 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2819);
const _p$2820 = "10";
const _tmp$1411 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2820) };
const _p$2821 = 2;
const _p$2822 = undefined;
const _tmp$1412 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2821, _p$2822) };
const _p$2823 = 30;
const _p$2824 = undefined;
const _bind$482 = [_tmp$1411, _tmp$1412, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2823, _p$2824) }];
const _p$2825 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$482, start: 0, end: 3 });
const _tmp$1413 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2825);
const _p$2826 = "10";
const _tmp$1414 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2826) };
const _p$2827 = 2;
const _p$2828 = undefined;
const _tmp$1415 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2827, _p$2828) };
const _p$2829 = 31;
const _p$2830 = undefined;
const _bind$483 = [_tmp$1414, _tmp$1415, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2829, _p$2830) }];
const _p$2831 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$483, start: 0, end: 3 });
const _tmp$1416 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2831);
const _p$2832 = "10";
const _tmp$1417 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2832) };
const _p$2833 = 2;
const _p$2834 = undefined;
const _tmp$1418 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2833, _p$2834) };
const _p$2835 = 32;
const _p$2836 = undefined;
const _bind$484 = [_tmp$1417, _tmp$1418, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2835, _p$2836) }];
const _p$2837 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$484, start: 0, end: 3 });
const _tmp$1419 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2837);
const _p$2838 = "13";
const _tmp$1420 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2838) };
const _p$2839 = 2;
const _p$2840 = undefined;
const _tmp$1421 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2839, _p$2840) };
const _p$2841 = 33;
const _p$2842 = undefined;
const _bind$485 = [_tmp$1420, _tmp$1421, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2841, _p$2842) }];
const _p$2843 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$485, start: 0, end: 3 });
const _tmp$1422 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2843);
const _p$2844 = "9";
const _tmp$1423 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2844) };
const _p$2845 = 3;
const _p$2846 = undefined;
const _tmp$1424 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2845, _p$2846) };
const _p$2847 = 33;
const _p$2848 = undefined;
const _bind$486 = [_tmp$1423, _tmp$1424, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2847, _p$2848) }];
const _p$2849 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$486, start: 0, end: 3 });
const _tmp$1425 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2849);
const _p$2850 = "9";
const _tmp$1426 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2850) };
const _p$2851 = 4;
const _p$2852 = undefined;
const _tmp$1427 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2851, _p$2852) };
const _p$2853 = 33;
const _p$2854 = undefined;
const _bind$487 = [_tmp$1426, _tmp$1427, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2853, _p$2854) }];
const _p$2855 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$487, start: 0, end: 3 });
const _tmp$1428 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2855);
const _p$2856 = "9";
const _tmp$1429 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2856) };
const _p$2857 = 5;
const _p$2858 = undefined;
const _tmp$1430 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2857, _p$2858) };
const _p$2859 = 33;
const _p$2860 = undefined;
const _bind$488 = [_tmp$1429, _tmp$1430, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2859, _p$2860) }];
const _p$2861 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$488, start: 0, end: 3 });
const _tmp$1431 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2861);
const _p$2862 = "9";
const _tmp$1432 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2862) };
const _p$2863 = 6;
const _p$2864 = undefined;
const _tmp$1433 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2863, _p$2864) };
const _p$2865 = 33;
const _p$2866 = undefined;
const _bind$489 = [_tmp$1432, _tmp$1433, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2865, _p$2866) }];
const _p$2867 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$489, start: 0, end: 3 });
const _tmp$1434 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2867);
const _p$2868 = "9";
const _tmp$1435 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2868) };
const _p$2869 = 7;
const _p$2870 = undefined;
const _tmp$1436 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2869, _p$2870) };
const _p$2871 = 33;
const _p$2872 = undefined;
const _bind$490 = [_tmp$1435, _tmp$1436, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2871, _p$2872) }];
const _p$2873 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$490, start: 0, end: 3 });
const _tmp$1437 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2873);
const _p$2874 = "9";
const _tmp$1438 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2874) };
const _p$2875 = 8;
const _p$2876 = undefined;
const _tmp$1439 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2875, _p$2876) };
const _p$2877 = 33;
const _p$2878 = undefined;
const _bind$491 = [_tmp$1438, _tmp$1439, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2877, _p$2878) }];
const _p$2879 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$491, start: 0, end: 3 });
const _tmp$1440 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2879);
const _p$2880 = "9";
const _tmp$1441 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2880) };
const _p$2881 = 9;
const _p$2882 = undefined;
const _tmp$1442 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2881, _p$2882) };
const _p$2883 = 33;
const _p$2884 = undefined;
const _bind$492 = [_tmp$1441, _tmp$1442, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2883, _p$2884) }];
const _p$2885 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$492, start: 0, end: 3 });
const _tmp$1443 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2885);
const _p$2886 = "9";
const _tmp$1444 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2886) };
const _p$2887 = 10;
const _p$2888 = undefined;
const _tmp$1445 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2887, _p$2888) };
const _p$2889 = 33;
const _p$2890 = undefined;
const _bind$493 = [_tmp$1444, _tmp$1445, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2889, _p$2890) }];
const _p$2891 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$493, start: 0, end: 3 });
const _tmp$1446 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2891);
const _p$2892 = "9";
const _tmp$1447 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2892) };
const _p$2893 = 28;
const _p$2894 = undefined;
const _tmp$1448 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2893, _p$2894) };
const _p$2895 = 33;
const _p$2896 = undefined;
const _bind$494 = [_tmp$1447, _tmp$1448, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2895, _p$2896) }];
const _p$2897 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$494, start: 0, end: 3 });
const _tmp$1449 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2897);
const _p$2898 = "9";
const _tmp$1450 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2898) };
const _p$2899 = 29;
const _p$2900 = undefined;
const _tmp$1451 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2899, _p$2900) };
const _p$2901 = 33;
const _p$2902 = undefined;
const _bind$495 = [_tmp$1450, _tmp$1451, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2901, _p$2902) }];
const _p$2903 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$495, start: 0, end: 3 });
const _tmp$1452 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2903);
const _p$2904 = "9";
const _tmp$1453 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2904) };
const _p$2905 = 30;
const _p$2906 = undefined;
const _tmp$1454 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2905, _p$2906) };
const _p$2907 = 33;
const _p$2908 = undefined;
const _bind$496 = [_tmp$1453, _tmp$1454, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2907, _p$2908) }];
const _p$2909 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$496, start: 0, end: 3 });
const _tmp$1455 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2909);
const _p$2910 = "9";
const _tmp$1456 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2910) };
const _p$2911 = 31;
const _p$2912 = undefined;
const _tmp$1457 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2911, _p$2912) };
const _p$2913 = 33;
const _p$2914 = undefined;
const _bind$497 = [_tmp$1456, _tmp$1457, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2913, _p$2914) }];
const _p$2915 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$497, start: 0, end: 3 });
const _tmp$1458 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2915);
const _p$2916 = "9";
const _tmp$1459 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2916) };
const _p$2917 = 32;
const _p$2918 = undefined;
const _tmp$1460 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2917, _p$2918) };
const _p$2919 = 33;
const _p$2920 = undefined;
const _bind$498 = [_tmp$1459, _tmp$1460, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2919, _p$2920) }];
const _p$2921 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$498, start: 0, end: 3 });
const _tmp$1461 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2921);
const _p$2922 = "9";
const _tmp$1462 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2922) };
const _p$2923 = 33;
const _p$2924 = undefined;
const _tmp$1463 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2923, _p$2924) };
const _p$2925 = 33;
const _p$2926 = undefined;
const _bind$499 = [_tmp$1462, _tmp$1463, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2925, _p$2926) }];
const _p$2927 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$499, start: 0, end: 3 });
const _tmp$1464 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2927);
const _p$2928 = "9";
const _tmp$1465 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2928) };
const _p$2929 = 34;
const _p$2930 = undefined;
const _tmp$1466 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2929, _p$2930) };
const _p$2931 = 33;
const _p$2932 = undefined;
const _bind$500 = [_tmp$1465, _tmp$1466, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2931, _p$2932) }];
const _p$2933 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$500, start: 0, end: 3 });
const _tmp$1467 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2933);
const _p$2934 = "11";
const _tmp$1468 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2934) };
const _p$2935 = 55;
const _p$2936 = undefined;
const _tmp$1469 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2935, _p$2936) };
const _p$2937 = 6;
const _p$2938 = undefined;
const _bind$501 = [_tmp$1468, _tmp$1469, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2937, _p$2938) }];
const _p$2939 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$501, start: 0, end: 3 });
const _tmp$1470 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2939);
const _p$2940 = "11";
const _tmp$1471 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2940) };
const _p$2941 = 55;
const _p$2942 = undefined;
const _tmp$1472 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2941, _p$2942) };
const _p$2943 = 22;
const _p$2944 = undefined;
const _bind$502 = [_tmp$1471, _tmp$1472, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2943, _p$2944) }];
const _p$2945 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$502, start: 0, end: 3 });
const _tmp$1473 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2945);
const _p$2946 = "11";
const _tmp$1474 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2946) };
const _p$2947 = 55;
const _p$2948 = undefined;
const _tmp$1475 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2947, _p$2948) };
const _p$2949 = 23;
const _p$2950 = undefined;
const _bind$503 = [_tmp$1474, _tmp$1475, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2949, _p$2950) }];
const _p$2951 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$503, start: 0, end: 3 });
const _tmp$1476 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2951);
const _p$2952 = "11";
const _tmp$1477 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2952) };
const _p$2953 = 55;
const _p$2954 = undefined;
const _tmp$1478 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2953, _p$2954) };
const _p$2955 = 29;
const _p$2956 = undefined;
const _bind$504 = [_tmp$1477, _tmp$1478, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2955, _p$2956) }];
const _p$2957 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$504, start: 0, end: 3 });
const _tmp$1479 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2957);
const _p$2958 = "11";
const _tmp$1480 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2958) };
const _p$2959 = 55;
const _p$2960 = undefined;
const _tmp$1481 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2959, _p$2960) };
const _p$2961 = 30;
const _p$2962 = undefined;
const _bind$505 = [_tmp$1480, _tmp$1481, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2961, _p$2962) }];
const _p$2963 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$505, start: 0, end: 3 });
const _tmp$1482 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2963);
const _p$2964 = "11";
const _tmp$1483 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2964) };
const _p$2965 = 55;
const _p$2966 = undefined;
const _tmp$1484 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2965, _p$2966) };
const _p$2967 = 31;
const _p$2968 = undefined;
const _bind$506 = [_tmp$1483, _tmp$1484, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2967, _p$2968) }];
const _p$2969 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$506, start: 0, end: 3 });
const _tmp$1485 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2969);
const _p$2970 = "9";
const _tmp$1486 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2970) };
const _p$2971 = 41;
const _p$2972 = undefined;
const _tmp$1487 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2971, _p$2972) };
const _p$2973 = 33;
const _p$2974 = undefined;
const _bind$507 = [_tmp$1486, _tmp$1487, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2973, _p$2974) }];
const _p$2975 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$507, start: 0, end: 3 });
const _tmp$1488 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2975);
const _p$2976 = "9";
const _tmp$1489 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2976) };
const _p$2977 = 42;
const _p$2978 = undefined;
const _tmp$1490 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2977, _p$2978) };
const _p$2979 = 33;
const _p$2980 = undefined;
const _bind$508 = [_tmp$1489, _tmp$1490, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2979, _p$2980) }];
const _p$2981 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$508, start: 0, end: 3 });
const _tmp$1491 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2981);
const _p$2982 = "9";
const _tmp$1492 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2982) };
const _p$2983 = 43;
const _p$2984 = undefined;
const _tmp$1493 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2983, _p$2984) };
const _p$2985 = 33;
const _p$2986 = undefined;
const _bind$509 = [_tmp$1492, _tmp$1493, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2985, _p$2986) }];
const _p$2987 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$509, start: 0, end: 3 });
const _tmp$1494 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2987);
const _p$2988 = "9";
const _tmp$1495 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2988) };
const _p$2989 = 44;
const _p$2990 = undefined;
const _tmp$1496 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2989, _p$2990) };
const _p$2991 = 33;
const _p$2992 = undefined;
const _bind$510 = [_tmp$1495, _tmp$1496, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2991, _p$2992) }];
const _p$2993 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$510, start: 0, end: 3 });
const _tmp$1497 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2993);
const _p$2994 = "9";
const _tmp$1498 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$2994) };
const _p$2995 = 45;
const _p$2996 = undefined;
const _tmp$1499 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2995, _p$2996) };
const _p$2997 = 33;
const _p$2998 = undefined;
const _bind$511 = [_tmp$1498, _tmp$1499, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$2997, _p$2998) }];
const _p$2999 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$511, start: 0, end: 3 });
const _tmp$1500 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$2999);
const _p$3000 = "9";
const _tmp$1501 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3000) };
const _p$3001 = 46;
const _p$3002 = undefined;
const _tmp$1502 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3001, _p$3002) };
const _p$3003 = 33;
const _p$3004 = undefined;
const _bind$512 = [_tmp$1501, _tmp$1502, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3003, _p$3004) }];
const _p$3005 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$512, start: 0, end: 3 });
const _tmp$1503 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3005);
const _p$3006 = "9";
const _tmp$1504 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3006) };
const _p$3007 = 47;
const _p$3008 = undefined;
const _tmp$1505 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3007, _p$3008) };
const _p$3009 = 33;
const _p$3010 = undefined;
const _bind$513 = [_tmp$1504, _tmp$1505, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3009, _p$3010) }];
const _p$3011 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$513, start: 0, end: 3 });
const _tmp$1506 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3011);
const _p$3012 = "9";
const _tmp$1507 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3012) };
const _p$3013 = 48;
const _p$3014 = undefined;
const _tmp$1508 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3013, _p$3014) };
const _p$3015 = 33;
const _p$3016 = undefined;
const _bind$514 = [_tmp$1507, _tmp$1508, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3015, _p$3016) }];
const _p$3017 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$514, start: 0, end: 3 });
const _tmp$1509 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3017);
const _p$3018 = "9";
const _tmp$1510 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3018) };
const _p$3019 = 49;
const _p$3020 = undefined;
const _tmp$1511 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3019, _p$3020) };
const _p$3021 = 33;
const _p$3022 = undefined;
const _bind$515 = [_tmp$1510, _tmp$1511, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3021, _p$3022) }];
const _p$3023 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$515, start: 0, end: 3 });
const _tmp$1512 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3023);
const _p$3024 = "9";
const _tmp$1513 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3024) };
const _p$3025 = 50;
const _p$3026 = undefined;
const _tmp$1514 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3025, _p$3026) };
const _p$3027 = 33;
const _p$3028 = undefined;
const _bind$516 = [_tmp$1513, _tmp$1514, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3027, _p$3028) }];
const _p$3029 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$516, start: 0, end: 3 });
const _tmp$1515 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3029);
const _p$3030 = "9";
const _tmp$1516 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3030) };
const _p$3031 = 51;
const _p$3032 = undefined;
const _tmp$1517 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3031, _p$3032) };
const _p$3033 = 33;
const _p$3034 = undefined;
const _bind$517 = [_tmp$1516, _tmp$1517, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3033, _p$3034) }];
const _p$3035 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$517, start: 0, end: 3 });
const _tmp$1518 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3035);
const _p$3036 = "9";
const _tmp$1519 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3036) };
const _p$3037 = 52;
const _p$3038 = undefined;
const _tmp$1520 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3037, _p$3038) };
const _p$3039 = 33;
const _p$3040 = undefined;
const _bind$518 = [_tmp$1519, _tmp$1520, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3039, _p$3040) }];
const _p$3041 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$518, start: 0, end: 3 });
const _tmp$1521 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3041);
const _p$3042 = "9";
const _tmp$1522 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3042) };
const _p$3043 = 53;
const _p$3044 = undefined;
const _tmp$1523 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3043, _p$3044) };
const _p$3045 = 33;
const _p$3046 = undefined;
const _bind$519 = [_tmp$1522, _tmp$1523, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3045, _p$3046) }];
const _p$3047 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$519, start: 0, end: 3 });
const _tmp$1524 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3047);
const _p$3048 = "9";
const _tmp$1525 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3048) };
const _p$3049 = 54;
const _p$3050 = undefined;
const _tmp$1526 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3049, _p$3050) };
const _p$3051 = 33;
const _p$3052 = undefined;
const _bind$520 = [_tmp$1525, _tmp$1526, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3051, _p$3052) }];
const _p$3053 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$520, start: 0, end: 3 });
const _tmp$1527 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3053);
const _p$3054 = "11";
const _tmp$1528 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3054) };
const _p$3055 = 55;
const _p$3056 = undefined;
const _tmp$1529 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3055, _p$3056) };
const _p$3057 = 32;
const _p$3058 = undefined;
const _bind$521 = [_tmp$1528, _tmp$1529, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3057, _p$3058) }];
const _p$3059 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$521, start: 0, end: 3 });
const _tmp$1530 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3059);
const _p$3060 = "13";
const _tmp$1531 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3060) };
const _p$3061 = 55;
const _p$3062 = undefined;
const _tmp$1532 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3061, _p$3062) };
const _p$3063 = 33;
const _p$3064 = undefined;
const _bind$522 = [_tmp$1531, _tmp$1532, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3063, _p$3064) }];
const _p$3065 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$522, start: 0, end: 3 });
const _tmp$1533 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3065);
const _p$3066 = "9";
const _tmp$1534 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3066) };
const _p$3067 = 40;
const _p$3068 = undefined;
const _tmp$1535 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3067, _p$3068) };
const _p$3069 = 33;
const _p$3070 = undefined;
const _bind$523 = [_tmp$1534, _tmp$1535, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3069, _p$3070) }];
const _p$3071 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$523, start: 0, end: 3 });
const _tmp$1536 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3071);
const _p$3072 = "9";
const _tmp$1537 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3072) };
const _p$3073 = 16;
const _p$3074 = undefined;
const _tmp$1538 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3073, _p$3074) };
const _p$3075 = 33;
const _p$3076 = undefined;
const _bind$524 = [_tmp$1537, _tmp$1538, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3075, _p$3076) }];
const _p$3077 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$524, start: 0, end: 3 });
const _tmp$1539 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3077);
const _p$3078 = "9";
const _tmp$1540 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3078) };
const _p$3079 = 17;
const _p$3080 = undefined;
const _tmp$1541 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3079, _p$3080) };
const _p$3081 = 33;
const _p$3082 = undefined;
const _bind$525 = [_tmp$1540, _tmp$1541, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3081, _p$3082) }];
const _p$3083 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$525, start: 0, end: 3 });
const _tmp$1542 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3083);
const _p$3084 = "9";
const _tmp$1543 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3084) };
const _p$3085 = 18;
const _p$3086 = undefined;
const _tmp$1544 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3085, _p$3086) };
const _p$3087 = 33;
const _p$3088 = undefined;
const _bind$526 = [_tmp$1543, _tmp$1544, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3087, _p$3088) }];
const _p$3089 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$526, start: 0, end: 3 });
const _tmp$1545 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3089);
const _p$3090 = "9";
const _tmp$1546 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3090) };
const _p$3091 = 19;
const _p$3092 = undefined;
const _tmp$1547 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3091, _p$3092) };
const _p$3093 = 33;
const _p$3094 = undefined;
const _bind$527 = [_tmp$1546, _tmp$1547, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3093, _p$3094) }];
const _p$3095 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$527, start: 0, end: 3 });
const _tmp$1548 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3095);
const _p$3096 = "9";
const _tmp$1549 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3096) };
const _p$3097 = 20;
const _p$3098 = undefined;
const _tmp$1550 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3097, _p$3098) };
const _p$3099 = 33;
const _p$3100 = undefined;
const _bind$528 = [_tmp$1549, _tmp$1550, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3099, _p$3100) }];
const _p$3101 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$528, start: 0, end: 3 });
const _tmp$1551 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3101);
const _p$3102 = "9";
const _tmp$1552 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3102) };
const _p$3103 = 21;
const _p$3104 = undefined;
const _tmp$1553 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3103, _p$3104) };
const _p$3105 = 33;
const _p$3106 = undefined;
const _bind$529 = [_tmp$1552, _tmp$1553, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3105, _p$3106) }];
const _p$3107 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$529, start: 0, end: 3 });
const _tmp$1554 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3107);
const _p$3108 = "9";
const _tmp$1555 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3108) };
const _p$3109 = 22;
const _p$3110 = undefined;
const _tmp$1556 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3109, _p$3110) };
const _p$3111 = 33;
const _p$3112 = undefined;
const _bind$530 = [_tmp$1555, _tmp$1556, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3111, _p$3112) }];
const _p$3113 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$530, start: 0, end: 3 });
const _tmp$1557 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3113);
const _p$3114 = "9";
const _tmp$1558 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3114) };
const _p$3115 = 23;
const _p$3116 = undefined;
const _tmp$1559 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3115, _p$3116) };
const _p$3117 = 33;
const _p$3118 = undefined;
const _bind$531 = [_tmp$1558, _tmp$1559, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3117, _p$3118) }];
const _p$3119 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$531, start: 0, end: 3 });
const _tmp$1560 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3119);
const _p$3120 = "9";
const _tmp$1561 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3120) };
const _p$3121 = 24;
const _p$3122 = undefined;
const _tmp$1562 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3121, _p$3122) };
const _p$3123 = 33;
const _p$3124 = undefined;
const _bind$532 = [_tmp$1561, _tmp$1562, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3123, _p$3124) }];
const _p$3125 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$532, start: 0, end: 3 });
const _tmp$1563 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3125);
const _p$3126 = "9";
const _tmp$1564 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3126) };
const _p$3127 = 25;
const _p$3128 = undefined;
const _tmp$1565 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3127, _p$3128) };
const _p$3129 = 33;
const _p$3130 = undefined;
const _bind$533 = [_tmp$1564, _tmp$1565, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3129, _p$3130) }];
const _p$3131 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$533, start: 0, end: 3 });
const _tmp$1566 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3131);
const _p$3132 = "9";
const _tmp$1567 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3132) };
const _p$3133 = 26;
const _p$3134 = undefined;
const _tmp$1568 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3133, _p$3134) };
const _p$3135 = 33;
const _p$3136 = undefined;
const _bind$534 = [_tmp$1567, _tmp$1568, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3135, _p$3136) }];
const _p$3137 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$534, start: 0, end: 3 });
const _tmp$1569 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3137);
const _p$3138 = "9";
const _tmp$1570 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3138) };
const _p$3139 = 27;
const _p$3140 = undefined;
const _tmp$1571 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3139, _p$3140) };
const _p$3141 = 33;
const _p$3142 = undefined;
const _bind$535 = [_tmp$1570, _tmp$1571, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3141, _p$3142) }];
const _p$3143 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$535, start: 0, end: 3 });
const _tmp$1572 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3143);
const _p$3144 = "9";
const _tmp$1573 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3144) };
const _p$3145 = 11;
const _p$3146 = undefined;
const _tmp$1574 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3145, _p$3146) };
const _p$3147 = 33;
const _p$3148 = undefined;
const _bind$536 = [_tmp$1573, _tmp$1574, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3147, _p$3148) }];
const _p$3149 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$536, start: 0, end: 3 });
const _tmp$1575 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3149);
const _p$3150 = "9";
const _tmp$1576 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3150) };
const _p$3151 = 12;
const _p$3152 = undefined;
const _tmp$1577 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3151, _p$3152) };
const _p$3153 = 33;
const _p$3154 = undefined;
const _bind$537 = [_tmp$1576, _tmp$1577, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3153, _p$3154) }];
const _p$3155 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$537, start: 0, end: 3 });
const _tmp$1578 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3155);
const _p$3156 = "9";
const _tmp$1579 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3156) };
const _p$3157 = 13;
const _p$3158 = undefined;
const _tmp$1580 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3157, _p$3158) };
const _p$3159 = 33;
const _p$3160 = undefined;
const _bind$538 = [_tmp$1579, _tmp$1580, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3159, _p$3160) }];
const _p$3161 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$538, start: 0, end: 3 });
const _tmp$1581 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3161);
const _p$3162 = "9";
const _tmp$1582 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3162) };
const _p$3163 = 14;
const _p$3164 = undefined;
const _tmp$1583 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3163, _p$3164) };
const _p$3165 = 33;
const _p$3166 = undefined;
const _bind$539 = [_tmp$1582, _tmp$1583, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3165, _p$3166) }];
const _p$3167 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$539, start: 0, end: 3 });
const _tmp$1584 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3167);
const _p$3168 = "9";
const _tmp$1585 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3168) };
const _p$3169 = 15;
const _p$3170 = undefined;
const _tmp$1586 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3169, _p$3170) };
const _p$3171 = 33;
const _p$3172 = undefined;
const _bind$540 = [_tmp$1585, _tmp$1586, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3171, _p$3172) }];
const _p$3173 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$540, start: 0, end: 3 });
const _tmp$1587 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3173);
const _p$3174 = "10";
const _tmp$1588 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3174) };
const _p$3175 = 2;
const _p$3176 = undefined;
const _tmp$1589 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3175, _p$3176) };
const _p$3177 = 27;
const _p$3178 = undefined;
const _bind$541 = [_tmp$1588, _tmp$1589, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3177, _p$3178) }];
const _p$3179 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$541, start: 0, end: 3 });
const _tmp$1590 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3179);
const _p$3180 = "10";
const _tmp$1591 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3180) };
const _p$3181 = 2;
const _p$3182 = undefined;
const _tmp$1592 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3181, _p$3182) };
const _p$3183 = 18;
const _p$3184 = undefined;
const _bind$542 = [_tmp$1591, _tmp$1592, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3183, _p$3184) }];
const _p$3185 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$542, start: 0, end: 3 });
const _tmp$1593 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3185);
const _p$3186 = "9";
const _tmp$1594 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3186) };
const _p$3187 = 35;
const _p$3188 = undefined;
const _tmp$1595 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3187, _p$3188) };
const _p$3189 = 33;
const _p$3190 = undefined;
const _bind$543 = [_tmp$1594, _tmp$1595, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3189, _p$3190) }];
const _p$3191 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$543, start: 0, end: 3 });
const _tmp$1596 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3191);
const _p$3192 = "9";
const _tmp$1597 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3192) };
const _p$3193 = 36;
const _p$3194 = undefined;
const _tmp$1598 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3193, _p$3194) };
const _p$3195 = 33;
const _p$3196 = undefined;
const _bind$544 = [_tmp$1597, _tmp$1598, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3195, _p$3196) }];
const _p$3197 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$544, start: 0, end: 3 });
const _tmp$1599 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3197);
const _p$3198 = "9";
const _tmp$1600 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3198) };
const _p$3199 = 37;
const _p$3200 = undefined;
const _tmp$1601 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3199, _p$3200) };
const _p$3201 = 33;
const _p$3202 = undefined;
const _bind$545 = [_tmp$1600, _tmp$1601, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3201, _p$3202) }];
const _p$3203 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$545, start: 0, end: 3 });
const _tmp$1602 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3203);
const _p$3204 = "9";
const _tmp$1603 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3204) };
const _p$3205 = 38;
const _p$3206 = undefined;
const _tmp$1604 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3205, _p$3206) };
const _p$3207 = 33;
const _p$3208 = undefined;
const _bind$546 = [_tmp$1603, _tmp$1604, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3207, _p$3208) }];
const _p$3209 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$546, start: 0, end: 3 });
const _tmp$1605 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3209);
const _p$3210 = "9";
const _tmp$1606 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3210) };
const _p$3211 = 39;
const _p$3212 = undefined;
const _tmp$1607 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3211, _p$3212) };
const _p$3213 = 33;
const _p$3214 = undefined;
const _bind$547 = [_tmp$1606, _tmp$1607, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3213, _p$3214) }];
const _p$3215 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$547, start: 0, end: 3 });
const _tmp$1608 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3215);
const _p$3216 = "11";
const _tmp$1609 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3216) };
const _p$3217 = 55;
const _p$3218 = undefined;
const _tmp$1610 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3217, _p$3218) };
const _p$3219 = 7;
const _p$3220 = undefined;
const _bind$548 = [_tmp$1609, _tmp$1610, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3219, _p$3220) }];
const _p$3221 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$548, start: 0, end: 3 });
const _tmp$1611 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3221);
const _p$3222 = "11";
const _tmp$1612 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3222) };
const _p$3223 = 55;
const _p$3224 = undefined;
const _tmp$1613 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3223, _p$3224) };
const _p$3225 = 8;
const _p$3226 = undefined;
const _bind$549 = [_tmp$1612, _tmp$1613, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3225, _p$3226) }];
const _p$3227 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$549, start: 0, end: 3 });
const _tmp$1614 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3227);
const _p$3228 = "11";
const _tmp$1615 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3228) };
const _p$3229 = 55;
const _p$3230 = undefined;
const _tmp$1616 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3229, _p$3230) };
const _p$3231 = 18;
const _p$3232 = undefined;
const _bind$550 = [_tmp$1615, _tmp$1616, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3231, _p$3232) }];
const _p$3233 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$550, start: 0, end: 3 });
const _tmp$1617 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3233);
const _p$3234 = "11";
const _tmp$1618 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3234) };
const _p$3235 = 55;
const _p$3236 = undefined;
const _tmp$1619 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3235, _p$3236) };
const _p$3237 = 19;
const _p$3238 = undefined;
const _bind$551 = [_tmp$1618, _tmp$1619, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3237, _p$3238) }];
const _p$3239 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$551, start: 0, end: 3 });
const _tmp$1620 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3239);
const _p$3240 = "11";
const _tmp$1621 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3240) };
const _p$3241 = 55;
const _p$3242 = undefined;
const _tmp$1622 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3241, _p$3242) };
const _p$3243 = 20;
const _p$3244 = undefined;
const _bind$552 = [_tmp$1621, _tmp$1622, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3243, _p$3244) }];
const _p$3245 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$552, start: 0, end: 3 });
const _tmp$1623 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3245);
const _p$3246 = "11";
const _tmp$1624 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3246) };
const _p$3247 = 55;
const _p$3248 = undefined;
const _tmp$1625 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3247, _p$3248) };
const _p$3249 = 21;
const _p$3250 = undefined;
const _bind$553 = [_tmp$1624, _tmp$1625, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3249, _p$3250) }];
const _p$3251 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$553, start: 0, end: 3 });
const _tmp$1626 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3251);
const _p$3252 = "11";
const _tmp$1627 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3252) };
const _p$3253 = 55;
const _p$3254 = undefined;
const _tmp$1628 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3253, _p$3254) };
const _p$3255 = 24;
const _p$3256 = undefined;
const _bind$554 = [_tmp$1627, _tmp$1628, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3255, _p$3256) }];
const _p$3257 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$554, start: 0, end: 3 });
const _tmp$1629 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3257);
const _p$3258 = "11";
const _tmp$1630 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3258) };
const _p$3259 = 55;
const _p$3260 = undefined;
const _tmp$1631 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3259, _p$3260) };
const _p$3261 = 25;
const _p$3262 = undefined;
const _bind$555 = [_tmp$1630, _tmp$1631, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3261, _p$3262) }];
const _p$3263 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$555, start: 0, end: 3 });
const _tmp$1632 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3263);
const _p$3264 = "11";
const _tmp$1633 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3264) };
const _p$3265 = 55;
const _p$3266 = undefined;
const _tmp$1634 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3265, _p$3266) };
const _p$3267 = 26;
const _p$3268 = undefined;
const _bind$556 = [_tmp$1633, _tmp$1634, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3267, _p$3268) }];
const _p$3269 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$556, start: 0, end: 3 });
const _tmp$1635 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3269);
const _p$3270 = "11";
const _tmp$1636 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3270) };
const _p$3271 = 55;
const _p$3272 = undefined;
const _tmp$1637 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3271, _p$3272) };
const _p$3273 = 27;
const _p$3274 = undefined;
const _bind$557 = [_tmp$1636, _tmp$1637, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3273, _p$3274) }];
const _p$3275 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$557, start: 0, end: 3 });
const _tmp$1638 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3275);
const _p$3276 = "11";
const _tmp$1639 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3276) };
const _p$3277 = 55;
const _p$3278 = undefined;
const _tmp$1640 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3277, _p$3278) };
const _p$3279 = 28;
const _p$3280 = undefined;
const _bind$558 = [_tmp$1639, _tmp$1640, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3279, _p$3280) }];
const _p$3281 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$558, start: 0, end: 3 });
const _tmp$1641 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3281);
const _p$3282 = "15";
const _tmp$1642 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3282) };
const _p$3283 = 42;
const _p$3284 = undefined;
const _tmp$1643 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3283, _p$3284) };
const _p$3285 = 26;
const _p$3286 = undefined;
const _bind$559 = [_tmp$1642, _tmp$1643, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3285, _p$3286) }];
const _p$3287 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$559, start: 0, end: 3 });
const _tmp$1644 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3287);
const _p$3288 = "14";
const _tmp$1645 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3288) };
const _p$3289 = 42;
const _p$3290 = undefined;
const _tmp$1646 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3289, _p$3290) };
const _p$3291 = 27;
const _p$3292 = undefined;
const _bind$560 = [_tmp$1645, _tmp$1646, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3291, _p$3292) }];
const _p$3293 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$560, start: 0, end: 3 });
const _tmp$1647 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3293);
const _p$3294 = "9";
const _tmp$1648 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3294) };
const _p$3295 = 43;
const _p$3296 = undefined;
const _tmp$1649 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3295, _p$3296) };
const _p$3297 = 26;
const _p$3298 = undefined;
const _bind$561 = [_tmp$1648, _tmp$1649, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3297, _p$3298) }];
const _p$3299 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$561, start: 0, end: 3 });
const _tmp$1650 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3299);
const _p$3300 = "8";
const _tmp$1651 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3300) };
const _p$3301 = 43;
const _p$3302 = undefined;
const _tmp$1652 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3301, _p$3302) };
const _p$3303 = 27;
const _p$3304 = undefined;
const _bind$562 = [_tmp$1651, _tmp$1652, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3303, _p$3304) }];
const _p$3305 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$562, start: 0, end: 3 });
const _tmp$1653 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3305);
const _p$3306 = "9";
const _tmp$1654 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3306) };
const _p$3307 = 44;
const _p$3308 = undefined;
const _tmp$1655 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3307, _p$3308) };
const _p$3309 = 26;
const _p$3310 = undefined;
const _bind$563 = [_tmp$1654, _tmp$1655, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3309, _p$3310) }];
const _p$3311 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$563, start: 0, end: 3 });
const _tmp$1656 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3311);
const _p$3312 = "8";
const _tmp$1657 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3312) };
const _p$3313 = 44;
const _p$3314 = undefined;
const _tmp$1658 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3313, _p$3314) };
const _p$3315 = 27;
const _p$3316 = undefined;
const _bind$564 = [_tmp$1657, _tmp$1658, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3315, _p$3316) }];
const _p$3317 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$564, start: 0, end: 3 });
const _tmp$1659 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3317);
const _p$3318 = "9";
const _tmp$1660 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3318) };
const _p$3319 = 45;
const _p$3320 = undefined;
const _tmp$1661 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3319, _p$3320) };
const _p$3321 = 26;
const _p$3322 = undefined;
const _bind$565 = [_tmp$1660, _tmp$1661, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3321, _p$3322) }];
const _p$3323 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$565, start: 0, end: 3 });
const _tmp$1662 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3323);
const _p$3324 = "8";
const _tmp$1663 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3324) };
const _p$3325 = 45;
const _p$3326 = undefined;
const _tmp$1664 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3325, _p$3326) };
const _p$3327 = 27;
const _p$3328 = undefined;
const _bind$566 = [_tmp$1663, _tmp$1664, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3327, _p$3328) }];
const _p$3329 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$566, start: 0, end: 3 });
const _tmp$1665 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3329);
const _p$3330 = "9";
const _tmp$1666 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3330) };
const _p$3331 = 46;
const _p$3332 = undefined;
const _tmp$1667 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3331, _p$3332) };
const _p$3333 = 26;
const _p$3334 = undefined;
const _bind$567 = [_tmp$1666, _tmp$1667, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3333, _p$3334) }];
const _p$3335 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$567, start: 0, end: 3 });
const _tmp$1668 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3335);
const _p$3336 = "8";
const _tmp$1669 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3336) };
const _p$3337 = 46;
const _p$3338 = undefined;
const _tmp$1670 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3337, _p$3338) };
const _p$3339 = 27;
const _p$3340 = undefined;
const _bind$568 = [_tmp$1669, _tmp$1670, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3339, _p$3340) }];
const _p$3341 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$568, start: 0, end: 3 });
const _tmp$1671 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3341);
const _p$3342 = "9";
const _tmp$1672 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3342) };
const _p$3343 = 47;
const _p$3344 = undefined;
const _tmp$1673 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3343, _p$3344) };
const _p$3345 = 26;
const _p$3346 = undefined;
const _bind$569 = [_tmp$1672, _tmp$1673, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3345, _p$3346) }];
const _p$3347 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$569, start: 0, end: 3 });
const _tmp$1674 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3347);
const _p$3348 = "8";
const _tmp$1675 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3348) };
const _p$3349 = 47;
const _p$3350 = undefined;
const _tmp$1676 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3349, _p$3350) };
const _p$3351 = 27;
const _p$3352 = undefined;
const _bind$570 = [_tmp$1675, _tmp$1676, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3351, _p$3352) }];
const _p$3353 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$570, start: 0, end: 3 });
const _tmp$1677 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3353);
const _p$3354 = "9";
const _tmp$1678 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3354) };
const _p$3355 = 48;
const _p$3356 = undefined;
const _tmp$1679 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3355, _p$3356) };
const _p$3357 = 26;
const _p$3358 = undefined;
const _bind$571 = [_tmp$1678, _tmp$1679, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3357, _p$3358) }];
const _p$3359 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$571, start: 0, end: 3 });
const _tmp$1680 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3359);
const _p$3360 = "16";
const _tmp$1681 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3360) };
const _p$3361 = 49;
const _p$3362 = undefined;
const _tmp$1682 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3361, _p$3362) };
const _p$3363 = 26;
const _p$3364 = undefined;
const _bind$572 = [_tmp$1681, _tmp$1682, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3363, _p$3364) }];
const _p$3365 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$572, start: 0, end: 3 });
const _tmp$1683 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3365);
const _p$3366 = "8";
const _tmp$1684 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3366) };
const _p$3367 = 48;
const _p$3368 = undefined;
const _tmp$1685 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3367, _p$3368) };
const _p$3369 = 27;
const _p$3370 = undefined;
const _bind$573 = [_tmp$1684, _tmp$1685, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3369, _p$3370) }];
const _p$3371 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$573, start: 0, end: 3 });
const _tmp$1686 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3371);
const _p$3372 = "12";
const _tmp$1687 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3372) };
const _p$3373 = 49;
const _p$3374 = undefined;
const _tmp$1688 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3373, _p$3374) };
const _p$3375 = 27;
const _p$3376 = undefined;
const _bind$574 = [_tmp$1687, _tmp$1688, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3375, _p$3376) }];
const _p$3377 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$574, start: 0, end: 3 });
const _tmp$1689 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3377);
const _p$3378 = "10";
const _tmp$1690 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3378) };
const _p$3379 = 2;
const _p$3380 = undefined;
const _tmp$1691 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3379, _p$3380) };
const _p$3381 = 22;
const _p$3382 = undefined;
const _bind$575 = [_tmp$1690, _tmp$1691, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3381, _p$3382) }];
const _p$3383 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$575, start: 0, end: 3 });
const _tmp$1692 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3383);
const _p$3384 = "10";
const _tmp$1693 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3384) };
const _p$3385 = 2;
const _p$3386 = undefined;
const _tmp$1694 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3385, _p$3386) };
const _p$3387 = 23;
const _p$3388 = undefined;
const _bind$576 = [_tmp$1693, _tmp$1694, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3387, _p$3388) }];
const _p$3389 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$576, start: 0, end: 3 });
const _tmp$1695 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3389);
const _p$3390 = "10";
const _tmp$1696 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3390) };
const _p$3391 = 2;
const _p$3392 = undefined;
const _tmp$1697 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3391, _p$3392) };
const _p$3393 = 24;
const _p$3394 = undefined;
const _bind$577 = [_tmp$1696, _tmp$1697, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3393, _p$3394) }];
const _p$3395 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$577, start: 0, end: 3 });
const _tmp$1698 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3395);
const _p$3396 = "10";
const _tmp$1699 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3396) };
const _p$3397 = 2;
const _p$3398 = undefined;
const _tmp$1700 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3397, _p$3398) };
const _p$3399 = 25;
const _p$3400 = undefined;
const _bind$578 = [_tmp$1699, _tmp$1700, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3399, _p$3400) }];
const _p$3401 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$578, start: 0, end: 3 });
const _tmp$1701 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3401);
const _p$3402 = "10";
const _tmp$1702 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3402) };
const _p$3403 = 2;
const _p$3404 = undefined;
const _tmp$1703 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3403, _p$3404) };
const _p$3405 = 26;
const _p$3406 = undefined;
const _bind$579 = [_tmp$1702, _tmp$1703, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3405, _p$3406) }];
const _p$3407 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$579, start: 0, end: 3 });
const _tmp$1704 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3407);
const _p$3408 = "15";
const _tmp$1705 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3408) };
const _p$3409 = 7;
const _p$3410 = undefined;
const _tmp$1706 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3409, _p$3410) };
const _p$3411 = 26;
const _p$3412 = undefined;
const _bind$580 = [_tmp$1705, _tmp$1706, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3411, _p$3412) }];
const _p$3413 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$580, start: 0, end: 3 });
const _tmp$1707 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3413);
const _p$3414 = "14";
const _tmp$1708 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3414) };
const _p$3415 = 7;
const _p$3416 = undefined;
const _tmp$1709 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3415, _p$3416) };
const _p$3417 = 27;
const _p$3418 = undefined;
const _bind$581 = [_tmp$1708, _tmp$1709, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3417, _p$3418) }];
const _p$3419 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$581, start: 0, end: 3 });
const _tmp$1710 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3419);
const _p$3420 = "9";
const _tmp$1711 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3420) };
const _p$3421 = 8;
const _p$3422 = undefined;
const _tmp$1712 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3421, _p$3422) };
const _p$3423 = 26;
const _p$3424 = undefined;
const _bind$582 = [_tmp$1711, _tmp$1712, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3423, _p$3424) }];
const _p$3425 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$582, start: 0, end: 3 });
const _tmp$1713 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3425);
const _p$3426 = "8";
const _tmp$1714 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3426) };
const _p$3427 = 8;
const _p$3428 = undefined;
const _tmp$1715 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3427, _p$3428) };
const _p$3429 = 27;
const _p$3430 = undefined;
const _bind$583 = [_tmp$1714, _tmp$1715, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3429, _p$3430) }];
const _p$3431 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$583, start: 0, end: 3 });
const _tmp$1716 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3431);
const _p$3432 = "9";
const _tmp$1717 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3432) };
const _p$3433 = 9;
const _p$3434 = undefined;
const _tmp$1718 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3433, _p$3434) };
const _p$3435 = 26;
const _p$3436 = undefined;
const _bind$584 = [_tmp$1717, _tmp$1718, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3435, _p$3436) }];
const _p$3437 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$584, start: 0, end: 3 });
const _tmp$1719 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3437);
const _p$3438 = "8";
const _tmp$1720 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3438) };
const _p$3439 = 9;
const _p$3440 = undefined;
const _tmp$1721 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3439, _p$3440) };
const _p$3441 = 27;
const _p$3442 = undefined;
const _bind$585 = [_tmp$1720, _tmp$1721, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3441, _p$3442) }];
const _p$3443 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$585, start: 0, end: 3 });
const _tmp$1722 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3443);
const _p$3444 = "9";
const _tmp$1723 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3444) };
const _p$3445 = 10;
const _p$3446 = undefined;
const _tmp$1724 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3445, _p$3446) };
const _p$3447 = 26;
const _p$3448 = undefined;
const _bind$586 = [_tmp$1723, _tmp$1724, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3447, _p$3448) }];
const _p$3449 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$586, start: 0, end: 3 });
const _tmp$1725 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3449);
const _p$3450 = "8";
const _tmp$1726 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3450) };
const _p$3451 = 10;
const _p$3452 = undefined;
const _tmp$1727 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3451, _p$3452) };
const _p$3453 = 27;
const _p$3454 = undefined;
const _bind$587 = [_tmp$1726, _tmp$1727, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3453, _p$3454) }];
const _p$3455 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$587, start: 0, end: 3 });
const _tmp$1728 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3455);
const _p$3456 = "9";
const _tmp$1729 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3456) };
const _p$3457 = 11;
const _p$3458 = undefined;
const _tmp$1730 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3457, _p$3458) };
const _p$3459 = 26;
const _p$3460 = undefined;
const _bind$588 = [_tmp$1729, _tmp$1730, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3459, _p$3460) }];
const _p$3461 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$588, start: 0, end: 3 });
const _tmp$1731 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3461);
const _p$3462 = "8";
const _tmp$1732 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3462) };
const _p$3463 = 11;
const _p$3464 = undefined;
const _tmp$1733 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3463, _p$3464) };
const _p$3465 = 27;
const _p$3466 = undefined;
const _bind$589 = [_tmp$1732, _tmp$1733, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3465, _p$3466) }];
const _p$3467 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$589, start: 0, end: 3 });
const _tmp$1734 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3467);
const _p$3468 = "9";
const _tmp$1735 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3468) };
const _p$3469 = 12;
const _p$3470 = undefined;
const _tmp$1736 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3469, _p$3470) };
const _p$3471 = 26;
const _p$3472 = undefined;
const _bind$590 = [_tmp$1735, _tmp$1736, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3471, _p$3472) }];
const _p$3473 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$590, start: 0, end: 3 });
const _tmp$1737 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3473);
const _p$3474 = "8";
const _tmp$1738 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3474) };
const _p$3475 = 12;
const _p$3476 = undefined;
const _tmp$1739 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3475, _p$3476) };
const _p$3477 = 27;
const _p$3478 = undefined;
const _bind$591 = [_tmp$1738, _tmp$1739, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3477, _p$3478) }];
const _p$3479 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$591, start: 0, end: 3 });
const _tmp$1740 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3479);
const _p$3480 = "9";
const _tmp$1741 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3480) };
const _p$3481 = 13;
const _p$3482 = undefined;
const _tmp$1742 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3481, _p$3482) };
const _p$3483 = 26;
const _p$3484 = undefined;
const _bind$592 = [_tmp$1741, _tmp$1742, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3483, _p$3484) }];
const _p$3485 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$592, start: 0, end: 3 });
const _tmp$1743 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3485);
const _p$3486 = "16";
const _tmp$1744 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3486) };
const _p$3487 = 14;
const _p$3488 = undefined;
const _tmp$1745 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3487, _p$3488) };
const _p$3489 = 26;
const _p$3490 = undefined;
const _bind$593 = [_tmp$1744, _tmp$1745, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3489, _p$3490) }];
const _p$3491 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$593, start: 0, end: 3 });
const _tmp$1746 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3491);
const _p$3492 = "8";
const _tmp$1747 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3492) };
const _p$3493 = 13;
const _p$3494 = undefined;
const _tmp$1748 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3493, _p$3494) };
const _p$3495 = 27;
const _p$3496 = undefined;
const _bind$594 = [_tmp$1747, _tmp$1748, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3495, _p$3496) }];
const _p$3497 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$594, start: 0, end: 3 });
const _tmp$1749 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3497);
const _p$3498 = "12";
const _tmp$1750 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3498) };
const _p$3499 = 14;
const _p$3500 = undefined;
const _tmp$1751 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3499, _p$3500) };
const _p$3501 = 27;
const _p$3502 = undefined;
const _bind$595 = [_tmp$1750, _tmp$1751, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3501, _p$3502) }];
const _p$3503 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$595, start: 0, end: 3 });
const _tmp$1752 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3503);
const _p$3504 = "15";
const _tmp$1753 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3504) };
const _p$3505 = 24;
const _p$3506 = undefined;
const _tmp$1754 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3505, _p$3506) };
const _p$3507 = 26;
const _p$3508 = undefined;
const _bind$596 = [_tmp$1753, _tmp$1754, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3507, _p$3508) }];
const _p$3509 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$596, start: 0, end: 3 });
const _tmp$1755 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3509);
const _p$3510 = "14";
const _tmp$1756 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3510) };
const _p$3511 = 24;
const _p$3512 = undefined;
const _tmp$1757 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3511, _p$3512) };
const _p$3513 = 27;
const _p$3514 = undefined;
const _bind$597 = [_tmp$1756, _tmp$1757, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3513, _p$3514) }];
const _p$3515 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$597, start: 0, end: 3 });
const _tmp$1758 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3515);
const _p$3516 = "9";
const _tmp$1759 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3516) };
const _p$3517 = 25;
const _p$3518 = undefined;
const _tmp$1760 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3517, _p$3518) };
const _p$3519 = 26;
const _p$3520 = undefined;
const _bind$598 = [_tmp$1759, _tmp$1760, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3519, _p$3520) }];
const _p$3521 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$598, start: 0, end: 3 });
const _tmp$1761 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3521);
const _p$3522 = "8";
const _tmp$1762 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3522) };
const _p$3523 = 25;
const _p$3524 = undefined;
const _tmp$1763 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3523, _p$3524) };
const _p$3525 = 27;
const _p$3526 = undefined;
const _bind$599 = [_tmp$1762, _tmp$1763, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3525, _p$3526) }];
const _p$3527 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$599, start: 0, end: 3 });
const _tmp$1764 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3527);
const _p$3528 = "9";
const _tmp$1765 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3528) };
const _p$3529 = 26;
const _p$3530 = undefined;
const _tmp$1766 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3529, _p$3530) };
const _p$3531 = 26;
const _p$3532 = undefined;
const _bind$600 = [_tmp$1765, _tmp$1766, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3531, _p$3532) }];
const _p$3533 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$600, start: 0, end: 3 });
const _tmp$1767 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3533);
const _p$3534 = "8";
const _tmp$1768 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3534) };
const _p$3535 = 26;
const _p$3536 = undefined;
const _tmp$1769 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3535, _p$3536) };
const _p$3537 = 27;
const _p$3538 = undefined;
const _bind$601 = [_tmp$1768, _tmp$1769, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3537, _p$3538) }];
const _p$3539 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$601, start: 0, end: 3 });
const _tmp$1770 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3539);
const _p$3540 = "9";
const _tmp$1771 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3540) };
const _p$3541 = 27;
const _p$3542 = undefined;
const _tmp$1772 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3541, _p$3542) };
const _p$3543 = 26;
const _p$3544 = undefined;
const _bind$602 = [_tmp$1771, _tmp$1772, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3543, _p$3544) }];
const _p$3545 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$602, start: 0, end: 3 });
const _tmp$1773 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3545);
const _p$3546 = "8";
const _tmp$1774 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3546) };
const _p$3547 = 27;
const _p$3548 = undefined;
const _tmp$1775 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3547, _p$3548) };
const _p$3549 = 27;
const _p$3550 = undefined;
const _bind$603 = [_tmp$1774, _tmp$1775, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3549, _p$3550) }];
const _p$3551 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$603, start: 0, end: 3 });
const _tmp$1776 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3551);
const _p$3552 = "9";
const _tmp$1777 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3552) };
const _p$3553 = 28;
const _p$3554 = undefined;
const _tmp$1778 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3553, _p$3554) };
const _p$3555 = 26;
const _p$3556 = undefined;
const _bind$604 = [_tmp$1777, _tmp$1778, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3555, _p$3556) }];
const _p$3557 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$604, start: 0, end: 3 });
const _tmp$1779 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3557);
const _p$3558 = "8";
const _tmp$1780 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3558) };
const _p$3559 = 28;
const _p$3560 = undefined;
const _tmp$1781 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3559, _p$3560) };
const _p$3561 = 27;
const _p$3562 = undefined;
const _bind$605 = [_tmp$1780, _tmp$1781, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3561, _p$3562) }];
const _p$3563 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$605, start: 0, end: 3 });
const _tmp$1782 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3563);
const _p$3564 = "9";
const _tmp$1783 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3564) };
const _p$3565 = 29;
const _p$3566 = undefined;
const _tmp$1784 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3565, _p$3566) };
const _p$3567 = 26;
const _p$3568 = undefined;
const _bind$606 = [_tmp$1783, _tmp$1784, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3567, _p$3568) }];
const _p$3569 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$606, start: 0, end: 3 });
const _tmp$1785 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3569);
const _p$3570 = "8";
const _tmp$1786 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3570) };
const _p$3571 = 29;
const _p$3572 = undefined;
const _tmp$1787 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3571, _p$3572) };
const _p$3573 = 27;
const _p$3574 = undefined;
const _bind$607 = [_tmp$1786, _tmp$1787, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3573, _p$3574) }];
const _p$3575 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$607, start: 0, end: 3 });
const _tmp$1788 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3575);
const _p$3576 = "9";
const _tmp$1789 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3576) };
const _p$3577 = 30;
const _p$3578 = undefined;
const _tmp$1790 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3577, _p$3578) };
const _p$3579 = 26;
const _p$3580 = undefined;
const _bind$608 = [_tmp$1789, _tmp$1790, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3579, _p$3580) }];
const _p$3581 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$608, start: 0, end: 3 });
const _tmp$1791 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3581);
const _p$3582 = "8";
const _tmp$1792 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3582) };
const _p$3583 = 30;
const _p$3584 = undefined;
const _tmp$1793 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3583, _p$3584) };
const _p$3585 = 27;
const _p$3586 = undefined;
const _bind$609 = [_tmp$1792, _tmp$1793, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3585, _p$3586) }];
const _p$3587 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$609, start: 0, end: 3 });
const _tmp$1794 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3587);
const _p$3588 = "9";
const _tmp$1795 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3588) };
const _p$3589 = 31;
const _p$3590 = undefined;
const _tmp$1796 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3589, _p$3590) };
const _p$3591 = 26;
const _p$3592 = undefined;
const _bind$610 = [_tmp$1795, _tmp$1796, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3591, _p$3592) }];
const _p$3593 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$610, start: 0, end: 3 });
const _tmp$1797 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3593);
const _p$3594 = "16";
const _tmp$1798 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3594) };
const _p$3595 = 32;
const _p$3596 = undefined;
const _tmp$1799 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3595, _p$3596) };
const _p$3597 = 26;
const _p$3598 = undefined;
const _bind$611 = [_tmp$1798, _tmp$1799, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3597, _p$3598) }];
const _p$3599 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$611, start: 0, end: 3 });
const _tmp$1800 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3599);
const _p$3600 = "8";
const _tmp$1801 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3600) };
const _p$3601 = 31;
const _p$3602 = undefined;
const _tmp$1802 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3601, _p$3602) };
const _p$3603 = 27;
const _p$3604 = undefined;
const _bind$612 = [_tmp$1801, _tmp$1802, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3603, _p$3604) }];
const _p$3605 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$612, start: 0, end: 3 });
const _tmp$1803 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3605);
const _p$3606 = "12";
const _tmp$1804 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3606) };
const _p$3607 = 32;
const _p$3608 = undefined;
const _tmp$1805 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3607, _p$3608) };
const _p$3609 = 27;
const _p$3610 = undefined;
const _bind$613 = [_tmp$1804, _tmp$1805, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3609, _p$3610) }];
const _p$3611 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$613, start: 0, end: 3 });
const _tmp$1806 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3611);
const _p$3612 = "15";
const _tmp$1807 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3612) };
const _p$3613 = 11;
const _p$3614 = undefined;
const _tmp$1808 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3613, _p$3614) };
const _p$3615 = 20;
const _p$3616 = undefined;
const _bind$614 = [_tmp$1807, _tmp$1808, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3615, _p$3616) }];
const _p$3617 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$614, start: 0, end: 3 });
const _tmp$1809 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3617);
const _p$3618 = "14";
const _tmp$1810 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3618) };
const _p$3619 = 11;
const _p$3620 = undefined;
const _tmp$1811 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3619, _p$3620) };
const _p$3621 = 21;
const _p$3622 = undefined;
const _bind$615 = [_tmp$1810, _tmp$1811, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3621, _p$3622) }];
const _p$3623 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$615, start: 0, end: 3 });
const _tmp$1812 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3623);
const _p$3624 = "9";
const _tmp$1813 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3624) };
const _p$3625 = 12;
const _p$3626 = undefined;
const _tmp$1814 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3625, _p$3626) };
const _p$3627 = 20;
const _p$3628 = undefined;
const _bind$616 = [_tmp$1813, _tmp$1814, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3627, _p$3628) }];
const _p$3629 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$616, start: 0, end: 3 });
const _tmp$1815 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3629);
const _p$3630 = "8";
const _tmp$1816 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3630) };
const _p$3631 = 12;
const _p$3632 = undefined;
const _tmp$1817 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3631, _p$3632) };
const _p$3633 = 21;
const _p$3634 = undefined;
const _bind$617 = [_tmp$1816, _tmp$1817, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3633, _p$3634) }];
const _p$3635 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$617, start: 0, end: 3 });
const _tmp$1818 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3635);
const _p$3636 = "9";
const _tmp$1819 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3636) };
const _p$3637 = 13;
const _p$3638 = undefined;
const _tmp$1820 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3637, _p$3638) };
const _p$3639 = 20;
const _p$3640 = undefined;
const _bind$618 = [_tmp$1819, _tmp$1820, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3639, _p$3640) }];
const _p$3641 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$618, start: 0, end: 3 });
const _tmp$1821 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3641);
const _p$3642 = "8";
const _tmp$1822 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3642) };
const _p$3643 = 13;
const _p$3644 = undefined;
const _tmp$1823 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3643, _p$3644) };
const _p$3645 = 21;
const _p$3646 = undefined;
const _bind$619 = [_tmp$1822, _tmp$1823, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3645, _p$3646) }];
const _p$3647 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$619, start: 0, end: 3 });
const _tmp$1824 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3647);
const _p$3648 = "9";
const _tmp$1825 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3648) };
const _p$3649 = 14;
const _p$3650 = undefined;
const _tmp$1826 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3649, _p$3650) };
const _p$3651 = 20;
const _p$3652 = undefined;
const _bind$620 = [_tmp$1825, _tmp$1826, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3651, _p$3652) }];
const _p$3653 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$620, start: 0, end: 3 });
const _tmp$1827 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3653);
const _p$3654 = "8";
const _tmp$1828 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3654) };
const _p$3655 = 14;
const _p$3656 = undefined;
const _tmp$1829 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3655, _p$3656) };
const _p$3657 = 21;
const _p$3658 = undefined;
const _bind$621 = [_tmp$1828, _tmp$1829, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3657, _p$3658) }];
const _p$3659 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$621, start: 0, end: 3 });
const _tmp$1830 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3659);
const _p$3660 = "9";
const _tmp$1831 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3660) };
const _p$3661 = 15;
const _p$3662 = undefined;
const _tmp$1832 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3661, _p$3662) };
const _p$3663 = 20;
const _p$3664 = undefined;
const _bind$622 = [_tmp$1831, _tmp$1832, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3663, _p$3664) }];
const _p$3665 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$622, start: 0, end: 3 });
const _tmp$1833 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3665);
const _p$3666 = "8";
const _tmp$1834 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3666) };
const _p$3667 = 15;
const _p$3668 = undefined;
const _tmp$1835 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3667, _p$3668) };
const _p$3669 = 21;
const _p$3670 = undefined;
const _bind$623 = [_tmp$1834, _tmp$1835, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3669, _p$3670) }];
const _p$3671 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$623, start: 0, end: 3 });
const _tmp$1836 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3671);
const _p$3672 = "9";
const _tmp$1837 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3672) };
const _p$3673 = 16;
const _p$3674 = undefined;
const _tmp$1838 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3673, _p$3674) };
const _p$3675 = 20;
const _p$3676 = undefined;
const _bind$624 = [_tmp$1837, _tmp$1838, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3675, _p$3676) }];
const _p$3677 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$624, start: 0, end: 3 });
const _tmp$1839 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3677);
const _p$3678 = "8";
const _tmp$1840 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3678) };
const _p$3679 = 16;
const _p$3680 = undefined;
const _tmp$1841 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3679, _p$3680) };
const _p$3681 = 21;
const _p$3682 = undefined;
const _bind$625 = [_tmp$1840, _tmp$1841, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3681, _p$3682) }];
const _p$3683 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$625, start: 0, end: 3 });
const _tmp$1842 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3683);
const _p$3684 = "9";
const _tmp$1843 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3684) };
const _p$3685 = 17;
const _p$3686 = undefined;
const _tmp$1844 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3685, _p$3686) };
const _p$3687 = 20;
const _p$3688 = undefined;
const _bind$626 = [_tmp$1843, _tmp$1844, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3687, _p$3688) }];
const _p$3689 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$626, start: 0, end: 3 });
const _tmp$1845 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3689);
const _p$3690 = "8";
const _tmp$1846 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3690) };
const _p$3691 = 17;
const _p$3692 = undefined;
const _tmp$1847 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3691, _p$3692) };
const _p$3693 = 21;
const _p$3694 = undefined;
const _bind$627 = [_tmp$1846, _tmp$1847, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3693, _p$3694) }];
const _p$3695 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$627, start: 0, end: 3 });
const _tmp$1848 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3695);
const _p$3696 = "9";
const _tmp$1849 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3696) };
const _p$3697 = 18;
const _p$3698 = undefined;
const _tmp$1850 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3697, _p$3698) };
const _p$3699 = 20;
const _p$3700 = undefined;
const _bind$628 = [_tmp$1849, _tmp$1850, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3699, _p$3700) }];
const _p$3701 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$628, start: 0, end: 3 });
const _tmp$1851 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3701);
const _p$3702 = "8";
const _tmp$1852 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3702) };
const _p$3703 = 18;
const _p$3704 = undefined;
const _tmp$1853 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3703, _p$3704) };
const _p$3705 = 21;
const _p$3706 = undefined;
const _bind$629 = [_tmp$1852, _tmp$1853, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3705, _p$3706) }];
const _p$3707 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$629, start: 0, end: 3 });
const _tmp$1854 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3707);
const _p$3708 = "9";
const _tmp$1855 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3708) };
const _p$3709 = 19;
const _p$3710 = undefined;
const _tmp$1856 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3709, _p$3710) };
const _p$3711 = 20;
const _p$3712 = undefined;
const _bind$630 = [_tmp$1855, _tmp$1856, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3711, _p$3712) }];
const _p$3713 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$630, start: 0, end: 3 });
const _tmp$1857 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3713);
const _p$3714 = "8";
const _tmp$1858 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3714) };
const _p$3715 = 19;
const _p$3716 = undefined;
const _tmp$1859 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3715, _p$3716) };
const _p$3717 = 21;
const _p$3718 = undefined;
const _bind$631 = [_tmp$1858, _tmp$1859, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3717, _p$3718) }];
const _p$3719 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$631, start: 0, end: 3 });
const _tmp$1860 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3719);
const _p$3720 = "9";
const _tmp$1861 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3720) };
const _p$3721 = 20;
const _p$3722 = undefined;
const _tmp$1862 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3721, _p$3722) };
const _p$3723 = 20;
const _p$3724 = undefined;
const _bind$632 = [_tmp$1861, _tmp$1862, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3723, _p$3724) }];
const _p$3725 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$632, start: 0, end: 3 });
const _tmp$1863 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3725);
const _p$3726 = "8";
const _tmp$1864 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3726) };
const _p$3727 = 20;
const _p$3728 = undefined;
const _tmp$1865 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3727, _p$3728) };
const _p$3729 = 21;
const _p$3730 = undefined;
const _bind$633 = [_tmp$1864, _tmp$1865, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3729, _p$3730) }];
const _p$3731 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$633, start: 0, end: 3 });
const _tmp$1866 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3731);
const _p$3732 = "9";
const _tmp$1867 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3732) };
const _p$3733 = 21;
const _p$3734 = undefined;
const _tmp$1868 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3733, _p$3734) };
const _p$3735 = 20;
const _p$3736 = undefined;
const _bind$634 = [_tmp$1867, _tmp$1868, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3735, _p$3736) }];
const _p$3737 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$634, start: 0, end: 3 });
const _tmp$1869 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3737);
const _p$3738 = "8";
const _tmp$1870 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3738) };
const _p$3739 = 21;
const _p$3740 = undefined;
const _tmp$1871 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3739, _p$3740) };
const _p$3741 = 21;
const _p$3742 = undefined;
const _bind$635 = [_tmp$1870, _tmp$1871, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3741, _p$3742) }];
const _p$3743 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$635, start: 0, end: 3 });
const _tmp$1872 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3743);
const _p$3744 = "9";
const _tmp$1873 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3744) };
const _p$3745 = 22;
const _p$3746 = undefined;
const _tmp$1874 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3745, _p$3746) };
const _p$3747 = 20;
const _p$3748 = undefined;
const _bind$636 = [_tmp$1873, _tmp$1874, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3747, _p$3748) }];
const _p$3749 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$636, start: 0, end: 3 });
const _tmp$1875 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3749);
const _p$3750 = "8";
const _tmp$1876 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3750) };
const _p$3751 = 22;
const _p$3752 = undefined;
const _tmp$1877 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3751, _p$3752) };
const _p$3753 = 21;
const _p$3754 = undefined;
const _bind$637 = [_tmp$1876, _tmp$1877, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3753, _p$3754) }];
const _p$3755 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$637, start: 0, end: 3 });
const _tmp$1878 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3755);
const _p$3756 = "9";
const _tmp$1879 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3756) };
const _p$3757 = 23;
const _p$3758 = undefined;
const _tmp$1880 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3757, _p$3758) };
const _p$3759 = 20;
const _p$3760 = undefined;
const _bind$638 = [_tmp$1879, _tmp$1880, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3759, _p$3760) }];
const _p$3761 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$638, start: 0, end: 3 });
const _tmp$1881 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3761);
const _p$3762 = "8";
const _tmp$1882 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3762) };
const _p$3763 = 23;
const _p$3764 = undefined;
const _tmp$1883 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3763, _p$3764) };
const _p$3765 = 21;
const _p$3766 = undefined;
const _bind$639 = [_tmp$1882, _tmp$1883, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3765, _p$3766) }];
const _p$3767 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$639, start: 0, end: 3 });
const _tmp$1884 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3767);
const _p$3768 = "9";
const _tmp$1885 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3768) };
const _p$3769 = 24;
const _p$3770 = undefined;
const _tmp$1886 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3769, _p$3770) };
const _p$3771 = 20;
const _p$3772 = undefined;
const _bind$640 = [_tmp$1885, _tmp$1886, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3771, _p$3772) }];
const _p$3773 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$640, start: 0, end: 3 });
const _tmp$1887 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3773);
const _p$3774 = "8";
const _tmp$1888 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3774) };
const _p$3775 = 24;
const _p$3776 = undefined;
const _tmp$1889 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3775, _p$3776) };
const _p$3777 = 21;
const _p$3778 = undefined;
const _bind$641 = [_tmp$1888, _tmp$1889, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3777, _p$3778) }];
const _p$3779 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$641, start: 0, end: 3 });
const _tmp$1890 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3779);
const _p$3780 = "9";
const _tmp$1891 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3780) };
const _p$3781 = 25;
const _p$3782 = undefined;
const _tmp$1892 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3781, _p$3782) };
const _p$3783 = 20;
const _p$3784 = undefined;
const _bind$642 = [_tmp$1891, _tmp$1892, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3783, _p$3784) }];
const _p$3785 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$642, start: 0, end: 3 });
const _tmp$1893 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3785);
const _p$3786 = "16";
const _tmp$1894 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3786) };
const _p$3787 = 26;
const _p$3788 = undefined;
const _tmp$1895 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3787, _p$3788) };
const _p$3789 = 20;
const _p$3790 = undefined;
const _bind$643 = [_tmp$1894, _tmp$1895, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3789, _p$3790) }];
const _p$3791 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$643, start: 0, end: 3 });
const _tmp$1896 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3791);
const _p$3792 = "8";
const _tmp$1897 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3792) };
const _p$3793 = 25;
const _p$3794 = undefined;
const _tmp$1898 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3793, _p$3794) };
const _p$3795 = 21;
const _p$3796 = undefined;
const _bind$644 = [_tmp$1897, _tmp$1898, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3795, _p$3796) }];
const _p$3797 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$644, start: 0, end: 3 });
const _tmp$1899 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3797);
const _p$3798 = "12";
const _tmp$1900 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3798) };
const _p$3799 = 26;
const _p$3800 = undefined;
const _tmp$1901 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3799, _p$3800) };
const _p$3801 = 21;
const _p$3802 = undefined;
const _bind$645 = [_tmp$1900, _tmp$1901, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3801, _p$3802) }];
const _p$3803 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$645, start: 0, end: 3 });
const _tmp$1902 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3803);
const _p$3804 = "15";
const _tmp$1903 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3804) };
const _p$3805 = 31;
const _p$3806 = undefined;
const _tmp$1904 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3805, _p$3806) };
const _p$3807 = 20;
const _p$3808 = undefined;
const _bind$646 = [_tmp$1903, _tmp$1904, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3807, _p$3808) }];
const _p$3809 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$646, start: 0, end: 3 });
const _tmp$1905 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3809);
const _p$3810 = "14";
const _tmp$1906 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3810) };
const _p$3811 = 31;
const _p$3812 = undefined;
const _tmp$1907 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3811, _p$3812) };
const _p$3813 = 21;
const _p$3814 = undefined;
const _bind$647 = [_tmp$1906, _tmp$1907, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3813, _p$3814) }];
const _p$3815 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$647, start: 0, end: 3 });
const _tmp$1908 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3815);
const _p$3816 = "9";
const _tmp$1909 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3816) };
const _p$3817 = 32;
const _p$3818 = undefined;
const _tmp$1910 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3817, _p$3818) };
const _p$3819 = 20;
const _p$3820 = undefined;
const _bind$648 = [_tmp$1909, _tmp$1910, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3819, _p$3820) }];
const _p$3821 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$648, start: 0, end: 3 });
const _tmp$1911 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3821);
const _p$3822 = "8";
const _tmp$1912 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3822) };
const _p$3823 = 32;
const _p$3824 = undefined;
const _tmp$1913 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3823, _p$3824) };
const _p$3825 = 21;
const _p$3826 = undefined;
const _bind$649 = [_tmp$1912, _tmp$1913, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3825, _p$3826) }];
const _p$3827 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$649, start: 0, end: 3 });
const _tmp$1914 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3827);
const _p$3828 = "9";
const _tmp$1915 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3828) };
const _p$3829 = 33;
const _p$3830 = undefined;
const _tmp$1916 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3829, _p$3830) };
const _p$3831 = 20;
const _p$3832 = undefined;
const _bind$650 = [_tmp$1915, _tmp$1916, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3831, _p$3832) }];
const _p$3833 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$650, start: 0, end: 3 });
const _tmp$1917 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3833);
const _p$3834 = "8";
const _tmp$1918 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3834) };
const _p$3835 = 33;
const _p$3836 = undefined;
const _tmp$1919 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3835, _p$3836) };
const _p$3837 = 21;
const _p$3838 = undefined;
const _bind$651 = [_tmp$1918, _tmp$1919, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3837, _p$3838) }];
const _p$3839 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$651, start: 0, end: 3 });
const _tmp$1920 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3839);
const _p$3840 = "9";
const _tmp$1921 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3840) };
const _p$3841 = 34;
const _p$3842 = undefined;
const _tmp$1922 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3841, _p$3842) };
const _p$3843 = 20;
const _p$3844 = undefined;
const _bind$652 = [_tmp$1921, _tmp$1922, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3843, _p$3844) }];
const _p$3845 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$652, start: 0, end: 3 });
const _tmp$1923 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3845);
const _p$3846 = "8";
const _tmp$1924 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3846) };
const _p$3847 = 34;
const _p$3848 = undefined;
const _tmp$1925 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3847, _p$3848) };
const _p$3849 = 21;
const _p$3850 = undefined;
const _bind$653 = [_tmp$1924, _tmp$1925, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3849, _p$3850) }];
const _p$3851 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$653, start: 0, end: 3 });
const _tmp$1926 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3851);
const _p$3852 = "9";
const _tmp$1927 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3852) };
const _p$3853 = 35;
const _p$3854 = undefined;
const _tmp$1928 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3853, _p$3854) };
const _p$3855 = 20;
const _p$3856 = undefined;
const _bind$654 = [_tmp$1927, _tmp$1928, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3855, _p$3856) }];
const _p$3857 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$654, start: 0, end: 3 });
const _tmp$1929 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3857);
const _p$3858 = "8";
const _tmp$1930 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3858) };
const _p$3859 = 35;
const _p$3860 = undefined;
const _tmp$1931 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3859, _p$3860) };
const _p$3861 = 21;
const _p$3862 = undefined;
const _bind$655 = [_tmp$1930, _tmp$1931, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3861, _p$3862) }];
const _p$3863 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$655, start: 0, end: 3 });
const _tmp$1932 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3863);
const _p$3864 = "9";
const _tmp$1933 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3864) };
const _p$3865 = 36;
const _p$3866 = undefined;
const _tmp$1934 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3865, _p$3866) };
const _p$3867 = 20;
const _p$3868 = undefined;
const _bind$656 = [_tmp$1933, _tmp$1934, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3867, _p$3868) }];
const _p$3869 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$656, start: 0, end: 3 });
const _tmp$1935 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3869);
const _p$3870 = "8";
const _tmp$1936 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3870) };
const _p$3871 = 36;
const _p$3872 = undefined;
const _tmp$1937 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3871, _p$3872) };
const _p$3873 = 21;
const _p$3874 = undefined;
const _bind$657 = [_tmp$1936, _tmp$1937, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3873, _p$3874) }];
const _p$3875 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$657, start: 0, end: 3 });
const _tmp$1938 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3875);
const _p$3876 = "9";
const _tmp$1939 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3876) };
const _p$3877 = 37;
const _p$3878 = undefined;
const _tmp$1940 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3877, _p$3878) };
const _p$3879 = 20;
const _p$3880 = undefined;
const _bind$658 = [_tmp$1939, _tmp$1940, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3879, _p$3880) }];
const _p$3881 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$658, start: 0, end: 3 });
const _tmp$1941 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3881);
const _p$3882 = "8";
const _tmp$1942 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3882) };
const _p$3883 = 37;
const _p$3884 = undefined;
const _tmp$1943 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3883, _p$3884) };
const _p$3885 = 21;
const _p$3886 = undefined;
const _bind$659 = [_tmp$1942, _tmp$1943, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3885, _p$3886) }];
const _p$3887 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$659, start: 0, end: 3 });
const _tmp$1944 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3887);
const _p$3888 = "9";
const _tmp$1945 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3888) };
const _p$3889 = 38;
const _p$3890 = undefined;
const _tmp$1946 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3889, _p$3890) };
const _p$3891 = 20;
const _p$3892 = undefined;
const _bind$660 = [_tmp$1945, _tmp$1946, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3891, _p$3892) }];
const _p$3893 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$660, start: 0, end: 3 });
const _tmp$1947 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3893);
const _p$3894 = "8";
const _tmp$1948 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3894) };
const _p$3895 = 38;
const _p$3896 = undefined;
const _tmp$1949 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3895, _p$3896) };
const _p$3897 = 21;
const _p$3898 = undefined;
const _bind$661 = [_tmp$1948, _tmp$1949, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3897, _p$3898) }];
const _p$3899 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$661, start: 0, end: 3 });
const _tmp$1950 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3899);
const _p$3900 = "9";
const _tmp$1951 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3900) };
const _p$3901 = 39;
const _p$3902 = undefined;
const _tmp$1952 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3901, _p$3902) };
const _p$3903 = 20;
const _p$3904 = undefined;
const _bind$662 = [_tmp$1951, _tmp$1952, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3903, _p$3904) }];
const _p$3905 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$662, start: 0, end: 3 });
const _tmp$1953 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3905);
const _p$3906 = "8";
const _tmp$1954 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3906) };
const _p$3907 = 39;
const _p$3908 = undefined;
const _tmp$1955 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3907, _p$3908) };
const _p$3909 = 21;
const _p$3910 = undefined;
const _bind$663 = [_tmp$1954, _tmp$1955, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3909, _p$3910) }];
const _p$3911 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$663, start: 0, end: 3 });
const _tmp$1956 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3911);
const _p$3912 = "9";
const _tmp$1957 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3912) };
const _p$3913 = 40;
const _p$3914 = undefined;
const _tmp$1958 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3913, _p$3914) };
const _p$3915 = 20;
const _p$3916 = undefined;
const _bind$664 = [_tmp$1957, _tmp$1958, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3915, _p$3916) }];
const _p$3917 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$664, start: 0, end: 3 });
const _tmp$1959 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3917);
const _p$3918 = "8";
const _tmp$1960 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3918) };
const _p$3919 = 40;
const _p$3920 = undefined;
const _tmp$1961 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3919, _p$3920) };
const _p$3921 = 21;
const _p$3922 = undefined;
const _bind$665 = [_tmp$1960, _tmp$1961, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3921, _p$3922) }];
const _p$3923 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$665, start: 0, end: 3 });
const _tmp$1962 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3923);
const _p$3924 = "9";
const _tmp$1963 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3924) };
const _p$3925 = 41;
const _p$3926 = undefined;
const _tmp$1964 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3925, _p$3926) };
const _p$3927 = 20;
const _p$3928 = undefined;
const _bind$666 = [_tmp$1963, _tmp$1964, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3927, _p$3928) }];
const _p$3929 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$666, start: 0, end: 3 });
const _tmp$1965 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3929);
const _p$3930 = "8";
const _tmp$1966 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3930) };
const _p$3931 = 41;
const _p$3932 = undefined;
const _tmp$1967 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3931, _p$3932) };
const _p$3933 = 21;
const _p$3934 = undefined;
const _bind$667 = [_tmp$1966, _tmp$1967, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3933, _p$3934) }];
const _p$3935 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$667, start: 0, end: 3 });
const _tmp$1968 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3935);
const _p$3936 = "9";
const _tmp$1969 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3936) };
const _p$3937 = 42;
const _p$3938 = undefined;
const _tmp$1970 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3937, _p$3938) };
const _p$3939 = 20;
const _p$3940 = undefined;
const _bind$668 = [_tmp$1969, _tmp$1970, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3939, _p$3940) }];
const _p$3941 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$668, start: 0, end: 3 });
const _tmp$1971 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3941);
const _p$3942 = "8";
const _tmp$1972 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3942) };
const _p$3943 = 42;
const _p$3944 = undefined;
const _tmp$1973 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3943, _p$3944) };
const _p$3945 = 21;
const _p$3946 = undefined;
const _bind$669 = [_tmp$1972, _tmp$1973, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3945, _p$3946) }];
const _p$3947 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$669, start: 0, end: 3 });
const _tmp$1974 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3947);
const _p$3948 = "9";
const _tmp$1975 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3948) };
const _p$3949 = 43;
const _p$3950 = undefined;
const _tmp$1976 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3949, _p$3950) };
const _p$3951 = 20;
const _p$3952 = undefined;
const _bind$670 = [_tmp$1975, _tmp$1976, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3951, _p$3952) }];
const _p$3953 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$670, start: 0, end: 3 });
const _tmp$1977 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3953);
const _p$3954 = "8";
const _tmp$1978 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3954) };
const _p$3955 = 43;
const _p$3956 = undefined;
const _tmp$1979 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3955, _p$3956) };
const _p$3957 = 21;
const _p$3958 = undefined;
const _bind$671 = [_tmp$1978, _tmp$1979, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3957, _p$3958) }];
const _p$3959 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$671, start: 0, end: 3 });
const _tmp$1980 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3959);
const _p$3960 = "9";
const _tmp$1981 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3960) };
const _p$3961 = 44;
const _p$3962 = undefined;
const _tmp$1982 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3961, _p$3962) };
const _p$3963 = 20;
const _p$3964 = undefined;
const _bind$672 = [_tmp$1981, _tmp$1982, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3963, _p$3964) }];
const _p$3965 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$672, start: 0, end: 3 });
const _tmp$1983 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3965);
const _p$3966 = "8";
const _tmp$1984 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3966) };
const _p$3967 = 44;
const _p$3968 = undefined;
const _tmp$1985 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3967, _p$3968) };
const _p$3969 = 21;
const _p$3970 = undefined;
const _bind$673 = [_tmp$1984, _tmp$1985, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3969, _p$3970) }];
const _p$3971 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$673, start: 0, end: 3 });
const _tmp$1986 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3971);
const _p$3972 = "9";
const _tmp$1987 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3972) };
const _p$3973 = 45;
const _p$3974 = undefined;
const _tmp$1988 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3973, _p$3974) };
const _p$3975 = 20;
const _p$3976 = undefined;
const _bind$674 = [_tmp$1987, _tmp$1988, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3975, _p$3976) }];
const _p$3977 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$674, start: 0, end: 3 });
const _tmp$1989 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3977);
const _p$3978 = "16";
const _tmp$1990 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3978) };
const _p$3979 = 46;
const _p$3980 = undefined;
const _tmp$1991 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3979, _p$3980) };
const _p$3981 = 20;
const _p$3982 = undefined;
const _bind$675 = [_tmp$1990, _tmp$1991, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3981, _p$3982) }];
const _p$3983 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$675, start: 0, end: 3 });
const _tmp$1992 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3983);
const _p$3984 = "8";
const _tmp$1993 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3984) };
const _p$3985 = 45;
const _p$3986 = undefined;
const _tmp$1994 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3985, _p$3986) };
const _p$3987 = 21;
const _p$3988 = undefined;
const _bind$676 = [_tmp$1993, _tmp$1994, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3987, _p$3988) }];
const _p$3989 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$676, start: 0, end: 3 });
const _tmp$1995 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3989);
const _p$3990 = "12";
const _tmp$1996 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3990) };
const _p$3991 = 46;
const _p$3992 = undefined;
const _tmp$1997 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3991, _p$3992) };
const _p$3993 = 21;
const _p$3994 = undefined;
const _bind$677 = [_tmp$1996, _tmp$1997, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3993, _p$3994) }];
const _p$3995 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$677, start: 0, end: 3 });
const _tmp$1998 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$3995);
const _p$3996 = "10";
const _tmp$1999 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$3996) };
const _p$3997 = 2;
const _p$3998 = undefined;
const _tmp$2000 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3997, _p$3998) };
const _p$3999 = 17;
const _p$4000 = undefined;
const _bind$678 = [_tmp$1999, _tmp$2000, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$3999, _p$4000) }];
const _p$4001 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$678, start: 0, end: 3 });
const _tmp$2001 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4001);
const _p$4002 = "13";
const _tmp$2002 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4002) };
const _p$4003 = 1;
const _p$4004 = undefined;
const _tmp$2003 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4003, _p$4004) };
const _p$4005 = 6;
const _p$4006 = undefined;
const _bind$679 = [_tmp$2002, _tmp$2003, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4005, _p$4006) }];
const _p$4007 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$679, start: 0, end: 3 });
const _tmp$2004 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4007);
const _p$4008 = "13";
const _tmp$2005 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4008) };
const _p$4009 = 1;
const _p$4010 = undefined;
const _tmp$2006 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4009, _p$4010) };
const _p$4011 = 7;
const _p$4012 = undefined;
const _bind$680 = [_tmp$2005, _tmp$2006, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4011, _p$4012) }];
const _p$4013 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$680, start: 0, end: 3 });
const _tmp$2007 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4013);
const _p$4014 = "10";
const _tmp$2008 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4014) };
const _p$4015 = 2;
const _p$4016 = undefined;
const _tmp$2009 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4015, _p$4016) };
const _p$4017 = 13;
const _p$4018 = undefined;
const _bind$681 = [_tmp$2008, _tmp$2009, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4017, _p$4018) }];
const _p$4019 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$681, start: 0, end: 3 });
const _tmp$2010 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4019);
const _p$4020 = "10";
const _tmp$2011 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4020) };
const _p$4021 = 2;
const _p$4022 = undefined;
const _tmp$2012 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4021, _p$4022) };
const _p$4023 = 14;
const _p$4024 = undefined;
const _bind$682 = [_tmp$2011, _tmp$2012, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4023, _p$4024) }];
const _p$4025 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$682, start: 0, end: 3 });
const _tmp$2013 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4025);
const _p$4026 = "10";
const _tmp$2014 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4026) };
const _p$4027 = 2;
const _p$4028 = undefined;
const _tmp$2015 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4027, _p$4028) };
const _p$4029 = 15;
const _p$4030 = undefined;
const _bind$683 = [_tmp$2014, _tmp$2015, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4029, _p$4030) }];
const _p$4031 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$683, start: 0, end: 3 });
const _tmp$2016 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4031);
const _p$4032 = "10";
const _tmp$2017 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4032) };
const _p$4033 = 2;
const _p$4034 = undefined;
const _tmp$2018 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4033, _p$4034) };
const _p$4035 = 16;
const _p$4036 = undefined;
const _bind$684 = [_tmp$2017, _tmp$2018, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4035, _p$4036) }];
const _p$4037 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$684, start: 0, end: 3 });
const _tmp$2019 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4037);
const _p$4038 = "11";
const _tmp$2020 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4038) };
const _p$4039 = 55;
const _p$4040 = undefined;
const _tmp$2021 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4039, _p$4040) };
const _p$4041 = 9;
const _p$4042 = undefined;
const _bind$685 = [_tmp$2020, _tmp$2021, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4041, _p$4042) }];
const _p$4043 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$685, start: 0, end: 3 });
const _tmp$2022 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4043);
const _p$4044 = "11";
const _tmp$2023 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4044) };
const _p$4045 = 55;
const _p$4046 = undefined;
const _tmp$2024 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4045, _p$4046) };
const _p$4047 = 10;
const _p$4048 = undefined;
const _bind$686 = [_tmp$2023, _tmp$2024, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4047, _p$4048) }];
const _p$4049 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$686, start: 0, end: 3 });
const _tmp$2025 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4049);
const _p$4050 = "11";
const _tmp$2026 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4050) };
const _p$4051 = 55;
const _p$4052 = undefined;
const _tmp$2027 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4051, _p$4052) };
const _p$4053 = 11;
const _p$4054 = undefined;
const _bind$687 = [_tmp$2026, _tmp$2027, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4053, _p$4054) }];
const _p$4055 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$687, start: 0, end: 3 });
const _tmp$2028 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4055);
const _p$4056 = "11";
const _tmp$2029 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4056) };
const _p$4057 = 55;
const _p$4058 = undefined;
const _tmp$2030 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4057, _p$4058) };
const _p$4059 = 12;
const _p$4060 = undefined;
const _bind$688 = [_tmp$2029, _tmp$2030, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4059, _p$4060) }];
const _p$4061 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$688, start: 0, end: 3 });
const _tmp$2031 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4061);
const _p$4062 = "11";
const _tmp$2032 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4062) };
const _p$4063 = 55;
const _p$4064 = undefined;
const _tmp$2033 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4063, _p$4064) };
const _p$4065 = 13;
const _p$4066 = undefined;
const _bind$689 = [_tmp$2032, _tmp$2033, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4065, _p$4066) }];
const _p$4067 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$689, start: 0, end: 3 });
const _tmp$2034 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4067);
const _p$4068 = "10";
const _tmp$2035 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4068) };
const _p$4069 = 2;
const _p$4070 = undefined;
const _tmp$2036 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4069, _p$4070) };
const _p$4071 = 6;
const _p$4072 = undefined;
const _bind$690 = [_tmp$2035, _tmp$2036, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4071, _p$4072) }];
const _p$4073 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$690, start: 0, end: 3 });
const _tmp$2037 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4073);
const _p$4074 = "10";
const _tmp$2038 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4074) };
const _p$4075 = 2;
const _p$4076 = undefined;
const _tmp$2039 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4075, _p$4076) };
const _p$4077 = 7;
const _p$4078 = undefined;
const _bind$691 = [_tmp$2038, _tmp$2039, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4077, _p$4078) }];
const _p$4079 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$691, start: 0, end: 3 });
const _tmp$2040 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4079);
const _p$4080 = "13";
const _tmp$2041 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4080) };
const _p$4081 = 1;
const _p$4082 = undefined;
const _tmp$2042 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4081, _p$4082) };
const _p$4083 = 8;
const _p$4084 = undefined;
const _bind$692 = [_tmp$2041, _tmp$2042, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4083, _p$4084) }];
const _p$4085 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$692, start: 0, end: 3 });
const _tmp$2043 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4085);
const _p$4086 = "10";
const _tmp$2044 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4086) };
const _p$4087 = 2;
const _p$4088 = undefined;
const _tmp$2045 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4087, _p$4088) };
const _p$4089 = 8;
const _p$4090 = undefined;
const _bind$693 = [_tmp$2044, _tmp$2045, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4089, _p$4090) }];
const _p$4091 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$693, start: 0, end: 3 });
const _tmp$2046 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4091);
const _p$4092 = "13";
const _tmp$2047 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4092) };
const _p$4093 = 1;
const _p$4094 = undefined;
const _tmp$2048 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4093, _p$4094) };
const _p$4095 = 9;
const _p$4096 = undefined;
const _bind$694 = [_tmp$2047, _tmp$2048, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4095, _p$4096) }];
const _p$4097 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$694, start: 0, end: 3 });
const _tmp$2049 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4097);
const _p$4098 = "13";
const _tmp$2050 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4098) };
const _p$4099 = 1;
const _p$4100 = undefined;
const _tmp$2051 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4099, _p$4100) };
const _p$4101 = 10;
const _p$4102 = undefined;
const _bind$695 = [_tmp$2050, _tmp$2051, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4101, _p$4102) }];
const _p$4103 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$695, start: 0, end: 3 });
const _tmp$2052 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4103);
const _p$4104 = "13";
const _tmp$2053 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4104) };
const _p$4105 = 1;
const _p$4106 = undefined;
const _tmp$2054 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4105, _p$4106) };
const _p$4107 = 11;
const _p$4108 = undefined;
const _bind$696 = [_tmp$2053, _tmp$2054, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4107, _p$4108) }];
const _p$4109 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$696, start: 0, end: 3 });
const _tmp$2055 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4109);
const _p$4110 = "13";
const _tmp$2056 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4110) };
const _p$4111 = 2;
const _p$4112 = undefined;
const _tmp$2057 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4111, _p$4112) };
const _p$4113 = 9;
const _p$4114 = undefined;
const _bind$697 = [_tmp$2056, _tmp$2057, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4113, _p$4114) }];
const _p$4115 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$697, start: 0, end: 3 });
const _tmp$2058 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4115);
const _p$4116 = "13";
const _tmp$2059 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4116) };
const _p$4117 = 2;
const _p$4118 = undefined;
const _tmp$2060 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4117, _p$4118) };
const _p$4119 = 10;
const _p$4120 = undefined;
const _bind$698 = [_tmp$2059, _tmp$2060, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4119, _p$4120) }];
const _p$4121 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$698, start: 0, end: 3 });
const _tmp$2061 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4121);
const _p$4122 = "10";
const _tmp$2062 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4122) };
const _p$4123 = 2;
const _p$4124 = undefined;
const _tmp$2063 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4123, _p$4124) };
const _p$4125 = 11;
const _p$4126 = undefined;
const _bind$699 = [_tmp$2062, _tmp$2063, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4125, _p$4126) }];
const _p$4127 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$699, start: 0, end: 3 });
const _tmp$2064 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4127);
const _p$4128 = "9";
const _tmp$2065 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4128) };
const _p$4129 = 3;
const _p$4130 = undefined;
const _tmp$2066 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4129, _p$4130) };
const _p$4131 = 9;
const _p$4132 = undefined;
const _bind$700 = [_tmp$2065, _tmp$2066, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4131, _p$4132) }];
const _p$4133 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$700, start: 0, end: 3 });
const _tmp$2067 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4133);
const _p$4134 = "8";
const _tmp$2068 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4134) };
const _p$4135 = 3;
const _p$4136 = undefined;
const _tmp$2069 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4135, _p$4136) };
const _p$4137 = 10;
const _p$4138 = undefined;
const _bind$701 = [_tmp$2068, _tmp$2069, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4137, _p$4138) }];
const _p$4139 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$701, start: 0, end: 3 });
const _tmp$2070 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4139);
const _p$4140 = "9";
const _tmp$2071 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4140) };
const _p$4141 = 4;
const _p$4142 = undefined;
const _tmp$2072 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4141, _p$4142) };
const _p$4143 = 9;
const _p$4144 = undefined;
const _bind$702 = [_tmp$2071, _tmp$2072, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4143, _p$4144) }];
const _p$4145 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$702, start: 0, end: 3 });
const _tmp$2073 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4145);
const _p$4146 = "8";
const _tmp$2074 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4146) };
const _p$4147 = 4;
const _p$4148 = undefined;
const _tmp$2075 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4147, _p$4148) };
const _p$4149 = 10;
const _p$4150 = undefined;
const _bind$703 = [_tmp$2074, _tmp$2075, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4149, _p$4150) }];
const _p$4151 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$703, start: 0, end: 3 });
const _tmp$2076 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4151);
const _p$4152 = "9";
const _tmp$2077 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4152) };
const _p$4153 = 5;
const _p$4154 = undefined;
const _tmp$2078 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4153, _p$4154) };
const _p$4155 = 9;
const _p$4156 = undefined;
const _bind$704 = [_tmp$2077, _tmp$2078, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4155, _p$4156) }];
const _p$4157 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$704, start: 0, end: 3 });
const _tmp$2079 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4157);
const _p$4158 = "8";
const _tmp$2080 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4158) };
const _p$4159 = 5;
const _p$4160 = undefined;
const _tmp$2081 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4159, _p$4160) };
const _p$4161 = 10;
const _p$4162 = undefined;
const _bind$705 = [_tmp$2080, _tmp$2081, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4161, _p$4162) }];
const _p$4163 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$705, start: 0, end: 3 });
const _tmp$2082 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4163);
const _p$4164 = "9";
const _tmp$2083 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4164) };
const _p$4165 = 6;
const _p$4166 = undefined;
const _tmp$2084 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4165, _p$4166) };
const _p$4167 = 9;
const _p$4168 = undefined;
const _bind$706 = [_tmp$2083, _tmp$2084, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4167, _p$4168) }];
const _p$4169 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$706, start: 0, end: 3 });
const _tmp$2085 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4169);
const _p$4170 = "8";
const _tmp$2086 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4170) };
const _p$4171 = 6;
const _p$4172 = undefined;
const _tmp$2087 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4171, _p$4172) };
const _p$4173 = 10;
const _p$4174 = undefined;
const _bind$707 = [_tmp$2086, _tmp$2087, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4173, _p$4174) }];
const _p$4175 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$707, start: 0, end: 3 });
const _tmp$2088 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4175);
const _p$4176 = "9";
const _tmp$2089 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4176) };
const _p$4177 = 7;
const _p$4178 = undefined;
const _tmp$2090 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4177, _p$4178) };
const _p$4179 = 9;
const _p$4180 = undefined;
const _bind$708 = [_tmp$2089, _tmp$2090, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4179, _p$4180) }];
const _p$4181 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$708, start: 0, end: 3 });
const _tmp$2091 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4181);
const _p$4182 = "8";
const _tmp$2092 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4182) };
const _p$4183 = 7;
const _p$4184 = undefined;
const _tmp$2093 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4183, _p$4184) };
const _p$4185 = 10;
const _p$4186 = undefined;
const _bind$709 = [_tmp$2092, _tmp$2093, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4185, _p$4186) }];
const _p$4187 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$709, start: 0, end: 3 });
const _tmp$2094 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4187);
const _p$4188 = "9";
const _tmp$2095 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4188) };
const _p$4189 = 8;
const _p$4190 = undefined;
const _tmp$2096 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4189, _p$4190) };
const _p$4191 = 9;
const _p$4192 = undefined;
const _bind$710 = [_tmp$2095, _tmp$2096, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4191, _p$4192) }];
const _p$4193 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$710, start: 0, end: 3 });
const _tmp$2097 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4193);
const _p$4194 = "8";
const _tmp$2098 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4194) };
const _p$4195 = 8;
const _p$4196 = undefined;
const _tmp$2099 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4195, _p$4196) };
const _p$4197 = 10;
const _p$4198 = undefined;
const _bind$711 = [_tmp$2098, _tmp$2099, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4197, _p$4198) }];
const _p$4199 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$711, start: 0, end: 3 });
const _tmp$2100 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4199);
const _p$4200 = "9";
const _tmp$2101 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4200) };
const _p$4201 = 9;
const _p$4202 = undefined;
const _tmp$2102 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4201, _p$4202) };
const _p$4203 = 9;
const _p$4204 = undefined;
const _bind$712 = [_tmp$2101, _tmp$2102, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4203, _p$4204) }];
const _p$4205 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$712, start: 0, end: 3 });
const _tmp$2103 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4205);
const _p$4206 = "8";
const _tmp$2104 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4206) };
const _p$4207 = 9;
const _p$4208 = undefined;
const _tmp$2105 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4207, _p$4208) };
const _p$4209 = 10;
const _p$4210 = undefined;
const _bind$713 = [_tmp$2104, _tmp$2105, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4209, _p$4210) }];
const _p$4211 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$713, start: 0, end: 3 });
const _tmp$2106 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4211);
const _p$4212 = "9";
const _tmp$2107 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4212) };
const _p$4213 = 10;
const _p$4214 = undefined;
const _tmp$2108 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4213, _p$4214) };
const _p$4215 = 9;
const _p$4216 = undefined;
const _bind$714 = [_tmp$2107, _tmp$2108, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4215, _p$4216) }];
const _p$4217 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$714, start: 0, end: 3 });
const _tmp$2109 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4217);
const _p$4218 = "8";
const _tmp$2110 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4218) };
const _p$4219 = 10;
const _p$4220 = undefined;
const _tmp$2111 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4219, _p$4220) };
const _p$4221 = 10;
const _p$4222 = undefined;
const _bind$715 = [_tmp$2110, _tmp$2111, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4221, _p$4222) }];
const _p$4223 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$715, start: 0, end: 3 });
const _tmp$2112 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4223);
const _p$4224 = "9";
const _tmp$2113 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4224) };
const _p$4225 = 11;
const _p$4226 = undefined;
const _tmp$2114 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4225, _p$4226) };
const _p$4227 = 9;
const _p$4228 = undefined;
const _bind$716 = [_tmp$2113, _tmp$2114, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4227, _p$4228) }];
const _p$4229 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$716, start: 0, end: 3 });
const _tmp$2115 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4229);
const _p$4230 = "16";
const _tmp$2116 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4230) };
const _p$4231 = 12;
const _p$4232 = undefined;
const _tmp$2117 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4231, _p$4232) };
const _p$4233 = 9;
const _p$4234 = undefined;
const _bind$717 = [_tmp$2116, _tmp$2117, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4233, _p$4234) }];
const _p$4235 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$717, start: 0, end: 3 });
const _tmp$2118 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4235);
const _p$4236 = "8";
const _tmp$2119 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4236) };
const _p$4237 = 11;
const _p$4238 = undefined;
const _tmp$2120 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4237, _p$4238) };
const _p$4239 = 10;
const _p$4240 = undefined;
const _bind$718 = [_tmp$2119, _tmp$2120, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4239, _p$4240) }];
const _p$4241 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$718, start: 0, end: 3 });
const _tmp$2121 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4241);
const _p$4242 = "12";
const _tmp$2122 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4242) };
const _p$4243 = 12;
const _p$4244 = undefined;
const _tmp$2123 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4243, _p$4244) };
const _p$4245 = 10;
const _p$4246 = undefined;
const _bind$719 = [_tmp$2122, _tmp$2123, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4245, _p$4246) }];
const _p$4247 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$719, start: 0, end: 3 });
const _tmp$2124 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4247);
const _p$4248 = "11";
const _tmp$2125 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4248) };
const _p$4249 = 55;
const _p$4250 = undefined;
const _tmp$2126 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4249, _p$4250) };
const _p$4251 = 14;
const _p$4252 = undefined;
const _bind$720 = [_tmp$2125, _tmp$2126, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4251, _p$4252) }];
const _p$4253 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$720, start: 0, end: 3 });
const _tmp$2127 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4253);
const _p$4254 = "15";
const _tmp$2128 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4254) };
const _p$4255 = 47;
const _p$4256 = undefined;
const _tmp$2129 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4255, _p$4256) };
const _p$4257 = 15;
const _p$4258 = undefined;
const _bind$721 = [_tmp$2128, _tmp$2129, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4257, _p$4258) }];
const _p$4259 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$721, start: 0, end: 3 });
const _tmp$2130 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4259);
const _p$4260 = "14";
const _tmp$2131 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4260) };
const _p$4261 = 47;
const _p$4262 = undefined;
const _tmp$2132 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4261, _p$4262) };
const _p$4263 = 16;
const _p$4264 = undefined;
const _bind$722 = [_tmp$2131, _tmp$2132, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4263, _p$4264) }];
const _p$4265 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$722, start: 0, end: 3 });
const _tmp$2133 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4265);
const _p$4266 = "9";
const _tmp$2134 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4266) };
const _p$4267 = 48;
const _p$4268 = undefined;
const _tmp$2135 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4267, _p$4268) };
const _p$4269 = 15;
const _p$4270 = undefined;
const _bind$723 = [_tmp$2134, _tmp$2135, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4269, _p$4270) }];
const _p$4271 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$723, start: 0, end: 3 });
const _tmp$2136 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4271);
const _p$4272 = "8";
const _tmp$2137 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4272) };
const _p$4273 = 48;
const _p$4274 = undefined;
const _tmp$2138 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4273, _p$4274) };
const _p$4275 = 16;
const _p$4276 = undefined;
const _bind$724 = [_tmp$2137, _tmp$2138, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4275, _p$4276) }];
const _p$4277 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$724, start: 0, end: 3 });
const _tmp$2139 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4277);
const _p$4278 = "9";
const _tmp$2140 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4278) };
const _p$4279 = 49;
const _p$4280 = undefined;
const _tmp$2141 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4279, _p$4280) };
const _p$4281 = 15;
const _p$4282 = undefined;
const _bind$725 = [_tmp$2140, _tmp$2141, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4281, _p$4282) }];
const _p$4283 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$725, start: 0, end: 3 });
const _tmp$2142 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4283);
const _p$4284 = "8";
const _tmp$2143 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4284) };
const _p$4285 = 49;
const _p$4286 = undefined;
const _tmp$2144 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4285, _p$4286) };
const _p$4287 = 16;
const _p$4288 = undefined;
const _bind$726 = [_tmp$2143, _tmp$2144, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4287, _p$4288) }];
const _p$4289 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$726, start: 0, end: 3 });
const _tmp$2145 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4289);
const _p$4290 = "9";
const _tmp$2146 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4290) };
const _p$4291 = 50;
const _p$4292 = undefined;
const _tmp$2147 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4291, _p$4292) };
const _p$4293 = 15;
const _p$4294 = undefined;
const _bind$727 = [_tmp$2146, _tmp$2147, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4293, _p$4294) }];
const _p$4295 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$727, start: 0, end: 3 });
const _tmp$2148 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4295);
const _p$4296 = "8";
const _tmp$2149 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4296) };
const _p$4297 = 50;
const _p$4298 = undefined;
const _tmp$2150 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4297, _p$4298) };
const _p$4299 = 16;
const _p$4300 = undefined;
const _bind$728 = [_tmp$2149, _tmp$2150, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4299, _p$4300) }];
const _p$4301 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$728, start: 0, end: 3 });
const _tmp$2151 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4301);
const _p$4302 = "9";
const _tmp$2152 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4302) };
const _p$4303 = 51;
const _p$4304 = undefined;
const _tmp$2153 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4303, _p$4304) };
const _p$4305 = 15;
const _p$4306 = undefined;
const _bind$729 = [_tmp$2152, _tmp$2153, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4305, _p$4306) }];
const _p$4307 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$729, start: 0, end: 3 });
const _tmp$2154 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4307);
const _p$4308 = "8";
const _tmp$2155 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4308) };
const _p$4309 = 51;
const _p$4310 = undefined;
const _tmp$2156 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4309, _p$4310) };
const _p$4311 = 16;
const _p$4312 = undefined;
const _bind$730 = [_tmp$2155, _tmp$2156, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4311, _p$4312) }];
const _p$4313 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$730, start: 0, end: 3 });
const _tmp$2157 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4313);
const _p$4314 = "9";
const _tmp$2158 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4314) };
const _p$4315 = 52;
const _p$4316 = undefined;
const _tmp$2159 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4315, _p$4316) };
const _p$4317 = 15;
const _p$4318 = undefined;
const _bind$731 = [_tmp$2158, _tmp$2159, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4317, _p$4318) }];
const _p$4319 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$731, start: 0, end: 3 });
const _tmp$2160 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4319);
const _p$4320 = "8";
const _tmp$2161 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4320) };
const _p$4321 = 52;
const _p$4322 = undefined;
const _tmp$2162 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4321, _p$4322) };
const _p$4323 = 16;
const _p$4324 = undefined;
const _bind$732 = [_tmp$2161, _tmp$2162, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4323, _p$4324) }];
const _p$4325 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$732, start: 0, end: 3 });
const _tmp$2163 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4325);
const _p$4326 = "9";
const _tmp$2164 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4326) };
const _p$4327 = 53;
const _p$4328 = undefined;
const _tmp$2165 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4327, _p$4328) };
const _p$4329 = 15;
const _p$4330 = undefined;
const _bind$733 = [_tmp$2164, _tmp$2165, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4329, _p$4330) }];
const _p$4331 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$733, start: 0, end: 3 });
const _tmp$2166 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4331);
const _p$4332 = "9";
const _tmp$2167 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4332) };
const _p$4333 = 54;
const _p$4334 = undefined;
const _tmp$2168 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4333, _p$4334) };
const _p$4335 = 15;
const _p$4336 = undefined;
const _bind$734 = [_tmp$2167, _tmp$2168, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4335, _p$4336) }];
const _p$4337 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$734, start: 0, end: 3 });
const _tmp$2169 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4337);
const _p$4338 = "13";
const _tmp$2170 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4338) };
const _p$4339 = 55;
const _p$4340 = undefined;
const _tmp$2171 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4339, _p$4340) };
const _p$4341 = 15;
const _p$4342 = undefined;
const _bind$735 = [_tmp$2170, _tmp$2171, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4341, _p$4342) }];
const _p$4343 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$735, start: 0, end: 3 });
const _tmp$2172 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4343);
const _p$4344 = "8";
const _tmp$2173 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4344) };
const _p$4345 = 53;
const _p$4346 = undefined;
const _tmp$2174 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4345, _p$4346) };
const _p$4347 = 16;
const _p$4348 = undefined;
const _bind$736 = [_tmp$2173, _tmp$2174, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4347, _p$4348) }];
const _p$4349 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$736, start: 0, end: 3 });
const _tmp$2175 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4349);
const _p$4350 = "8";
const _tmp$2176 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4350) };
const _p$4351 = 54;
const _p$4352 = undefined;
const _tmp$2177 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4351, _p$4352) };
const _p$4353 = 16;
const _p$4354 = undefined;
const _bind$737 = [_tmp$2176, _tmp$2177, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4353, _p$4354) }];
const _p$4355 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$737, start: 0, end: 3 });
const _tmp$2178 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4355);
const _p$4356 = "13";
const _tmp$2179 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4356) };
const _p$4357 = 55;
const _p$4358 = undefined;
const _tmp$2180 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4357, _p$4358) };
const _p$4359 = 16;
const _p$4360 = undefined;
const _bind$738 = [_tmp$2179, _tmp$2180, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4359, _p$4360) }];
const _p$4361 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$738, start: 0, end: 3 });
const _tmp$2181 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4361);
const _p$4362 = "11";
const _tmp$2182 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4362) };
const _p$4363 = 55;
const _p$4364 = undefined;
const _tmp$2183 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4363, _p$4364) };
const _p$4365 = 17;
const _p$4366 = undefined;
const _bind$739 = [_tmp$2182, _tmp$2183, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4365, _p$4366) }];
const _p$4367 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$739, start: 0, end: 3 });
const _tmp$2184 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4367);
const _p$4368 = "15";
const _tmp$2185 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4368) };
const _p$4369 = 49;
const _p$4370 = undefined;
const _tmp$2186 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4369, _p$4370) };
const _p$4371 = 10;
const _p$4372 = undefined;
const _bind$740 = [_tmp$2185, _tmp$2186, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4371, _p$4372) }];
const _p$4373 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$740, start: 0, end: 3 });
const _tmp$2187 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4373);
const _p$4374 = "16";
const _tmp$2188 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4374) };
const _p$4375 = 50;
const _p$4376 = undefined;
const _tmp$2189 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4375, _p$4376) };
const _p$4377 = 10;
const _p$4378 = undefined;
const _bind$741 = [_tmp$2188, _tmp$2189, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4377, _p$4378) }];
const _p$4379 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$741, start: 0, end: 3 });
const _tmp$2190 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4379);
const _p$4380 = "14";
const _tmp$2191 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4380) };
const _p$4381 = 49;
const _p$4382 = undefined;
const _tmp$2192 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4381, _p$4382) };
const _p$4383 = 11;
const _p$4384 = undefined;
const _bind$742 = [_tmp$2191, _tmp$2192, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4383, _p$4384) }];
const _p$4385 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$742, start: 0, end: 3 });
const _tmp$2193 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4385);
const _p$4386 = "12";
const _tmp$2194 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4386) };
const _p$4387 = 50;
const _p$4388 = undefined;
const _tmp$2195 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4387, _p$4388) };
const _p$4389 = 11;
const _p$4390 = undefined;
const _bind$743 = [_tmp$2194, _tmp$2195, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4389, _p$4390) }];
const _p$4391 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$743, start: 0, end: 3 });
const _tmp$2196 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4391);
const _p$4392 = "15";
const _tmp$2197 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4392) };
const _p$4393 = 42;
const _p$4394 = undefined;
const _tmp$2198 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4393, _p$4394) };
const _p$4395 = 8;
const _p$4396 = undefined;
const _bind$744 = [_tmp$2197, _tmp$2198, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4395, _p$4396) }];
const _p$4397 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$744, start: 0, end: 3 });
const _tmp$2199 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4397);
const _p$4398 = "16";
const _tmp$2200 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4398) };
const _p$4399 = 43;
const _p$4400 = undefined;
const _tmp$2201 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4399, _p$4400) };
const _p$4401 = 8;
const _p$4402 = undefined;
const _bind$745 = [_tmp$2200, _tmp$2201, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4401, _p$4402) }];
const _p$4403 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$745, start: 0, end: 3 });
const _tmp$2202 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4403);
const _p$4404 = "14";
const _tmp$2203 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4404) };
const _p$4405 = 42;
const _p$4406 = undefined;
const _tmp$2204 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4405, _p$4406) };
const _p$4407 = 9;
const _p$4408 = undefined;
const _bind$746 = [_tmp$2203, _tmp$2204, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4407, _p$4408) }];
const _p$4409 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$746, start: 0, end: 3 });
const _tmp$2205 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4409);
const _p$4410 = "12";
const _tmp$2206 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4410) };
const _p$4411 = 43;
const _p$4412 = undefined;
const _tmp$2207 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4411, _p$4412) };
const _p$4413 = 9;
const _p$4414 = undefined;
const _bind$747 = [_tmp$2206, _tmp$2207, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4413, _p$4414) }];
const _p$4415 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$747, start: 0, end: 3 });
const _tmp$2208 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4415);
const _p$4416 = "15";
const _tmp$2209 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4416) };
const _p$4417 = 34;
const _p$4418 = undefined;
const _tmp$2210 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4417, _p$4418) };
const _p$4419 = 8;
const _p$4420 = undefined;
const _bind$748 = [_tmp$2209, _tmp$2210, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4419, _p$4420) }];
const _p$4421 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$748, start: 0, end: 3 });
const _tmp$2211 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4421);
const _p$4422 = "14";
const _tmp$2212 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4422) };
const _p$4423 = 34;
const _p$4424 = undefined;
const _tmp$2213 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4423, _p$4424) };
const _p$4425 = 9;
const _p$4426 = undefined;
const _bind$749 = [_tmp$2212, _tmp$2213, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4425, _p$4426) }];
const _p$4427 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$749, start: 0, end: 3 });
const _tmp$2214 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4427);
const _p$4428 = "9";
const _tmp$2215 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4428) };
const _p$4429 = 35;
const _p$4430 = undefined;
const _tmp$2216 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4429, _p$4430) };
const _p$4431 = 8;
const _p$4432 = undefined;
const _bind$750 = [_tmp$2215, _tmp$2216, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4431, _p$4432) }];
const _p$4433 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$750, start: 0, end: 3 });
const _tmp$2217 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4433);
const _p$4434 = "16";
const _tmp$2218 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4434) };
const _p$4435 = 36;
const _p$4436 = undefined;
const _tmp$2219 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4435, _p$4436) };
const _p$4437 = 8;
const _p$4438 = undefined;
const _bind$751 = [_tmp$2218, _tmp$2219, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4437, _p$4438) }];
const _p$4439 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$751, start: 0, end: 3 });
const _tmp$2220 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4439);
const _p$4440 = "8";
const _tmp$2221 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4440) };
const _p$4441 = 35;
const _p$4442 = undefined;
const _tmp$2222 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4441, _p$4442) };
const _p$4443 = 9;
const _p$4444 = undefined;
const _bind$752 = [_tmp$2221, _tmp$2222, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4443, _p$4444) }];
const _p$4445 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$752, start: 0, end: 3 });
const _tmp$2223 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4445);
const _p$4446 = "12";
const _tmp$2224 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4446) };
const _p$4447 = 36;
const _p$4448 = undefined;
const _tmp$2225 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4447, _p$4448) };
const _p$4449 = 9;
const _p$4450 = undefined;
const _bind$753 = [_tmp$2224, _tmp$2225, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4449, _p$4450) }];
const _p$4451 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$753, start: 0, end: 3 });
const _tmp$2226 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4451);
const _p$4452 = "15";
const _tmp$2227 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4452) };
const _p$4453 = 26;
const _p$4454 = undefined;
const _tmp$2228 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4453, _p$4454) };
const _p$4455 = 8;
const _p$4456 = undefined;
const _bind$754 = [_tmp$2227, _tmp$2228, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4455, _p$4456) }];
const _p$4457 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$754, start: 0, end: 3 });
const _tmp$2229 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4457);
const _p$4458 = "14";
const _tmp$2230 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4458) };
const _p$4459 = 26;
const _p$4460 = undefined;
const _tmp$2231 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4459, _p$4460) };
const _p$4461 = 9;
const _p$4462 = undefined;
const _bind$755 = [_tmp$2230, _tmp$2231, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4461, _p$4462) }];
const _p$4463 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$755, start: 0, end: 3 });
const _tmp$2232 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4463);
const _p$4464 = "9";
const _tmp$2233 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4464) };
const _p$4465 = 27;
const _p$4466 = undefined;
const _tmp$2234 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4465, _p$4466) };
const _p$4467 = 8;
const _p$4468 = undefined;
const _bind$756 = [_tmp$2233, _tmp$2234, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4467, _p$4468) }];
const _p$4469 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$756, start: 0, end: 3 });
const _tmp$2235 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4469);
const _p$4470 = "16";
const _tmp$2236 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4470) };
const _p$4471 = 28;
const _p$4472 = undefined;
const _tmp$2237 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4471, _p$4472) };
const _p$4473 = 8;
const _p$4474 = undefined;
const _bind$757 = [_tmp$2236, _tmp$2237, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4473, _p$4474) }];
const _p$4475 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$757, start: 0, end: 3 });
const _tmp$2238 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4475);
const _p$4476 = "8";
const _tmp$2239 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4476) };
const _p$4477 = 27;
const _p$4478 = undefined;
const _tmp$2240 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4477, _p$4478) };
const _p$4479 = 9;
const _p$4480 = undefined;
const _bind$758 = [_tmp$2239, _tmp$2240, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4479, _p$4480) }];
const _p$4481 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$758, start: 0, end: 3 });
const _tmp$2241 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4481);
const _p$4482 = "12";
const _tmp$2242 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4482) };
const _p$4483 = 28;
const _p$4484 = undefined;
const _tmp$2243 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4483, _p$4484) };
const _p$4485 = 9;
const _p$4486 = undefined;
const _bind$759 = [_tmp$2242, _tmp$2243, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4485, _p$4486) }];
const _p$4487 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$759, start: 0, end: 3 });
const _tmp$2244 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4487);
const _p$4488 = "15";
const _tmp$2245 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4488) };
const _p$4489 = 19;
const _p$4490 = undefined;
const _tmp$2246 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4489, _p$4490) };
const _p$4491 = 8;
const _p$4492 = undefined;
const _bind$760 = [_tmp$2245, _tmp$2246, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4491, _p$4492) }];
const _p$4493 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$760, start: 0, end: 3 });
const _tmp$2247 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4493);
const _p$4494 = "16";
const _tmp$2248 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4494) };
const _p$4495 = 20;
const _p$4496 = undefined;
const _tmp$2249 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4495, _p$4496) };
const _p$4497 = 8;
const _p$4498 = undefined;
const _bind$761 = [_tmp$2248, _tmp$2249, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4497, _p$4498) }];
const _p$4499 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$761, start: 0, end: 3 });
const _tmp$2250 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4499);
const _p$4500 = "14";
const _tmp$2251 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4500) };
const _p$4501 = 19;
const _p$4502 = undefined;
const _tmp$2252 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4501, _p$4502) };
const _p$4503 = 9;
const _p$4504 = undefined;
const _bind$762 = [_tmp$2251, _tmp$2252, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4503, _p$4504) }];
const _p$4505 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$762, start: 0, end: 3 });
const _tmp$2253 = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4505);
const _p$4506 = "12";
const _tmp$2254 = { _0: "id", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$String(_p$4506) };
const _p$4507 = 20;
const _p$4508 = undefined;
const _tmp$2255 = { _0: "x", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4507, _p$4508) };
const _p$4509 = 9;
const _p$4510 = undefined;
const _bind$763 = [_tmp$2254, _tmp$2255, { _0: "y", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Number(_p$4509, _p$4510) }];
const _p$4511 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$763, start: 0, end: 3 });
const _p$4512 = [_tmp$153, _tmp$156, _tmp$159, _tmp$162, _tmp$165, _tmp$168, _tmp$171, _tmp$174, _tmp$177, _tmp$180, _tmp$183, _tmp$186, _tmp$189, _tmp$192, _tmp$195, _tmp$198, _tmp$201, _tmp$204, _tmp$207, _tmp$210, _tmp$213, _tmp$216, _tmp$219, _tmp$222, _tmp$225, _tmp$228, _tmp$231, _tmp$234, _tmp$237, _tmp$240, _tmp$243, _tmp$246, _tmp$249, _tmp$252, _tmp$255, _tmp$258, _tmp$261, _tmp$264, _tmp$267, _tmp$270, _tmp$273, _tmp$276, _tmp$279, _tmp$282, _tmp$285, _tmp$288, _tmp$291, _tmp$294, _tmp$297, _tmp$300, _tmp$303, _tmp$306, _tmp$309, _tmp$312, _tmp$315, _tmp$318, _tmp$321, _tmp$324, _tmp$327, _tmp$330, _tmp$333, _tmp$336, _tmp$339, _tmp$342, _tmp$345, _tmp$348, _tmp$351, _tmp$354, _tmp$357, _tmp$360, _tmp$363, _tmp$366, _tmp$369, _tmp$372, _tmp$375, _tmp$378, _tmp$381, _tmp$384, _tmp$387, _tmp$390, _tmp$393, _tmp$396, _tmp$399, _tmp$402, _tmp$405, _tmp$408, _tmp$411, _tmp$414, _tmp$417, _tmp$420, _tmp$423, _tmp$426, _tmp$429, _tmp$432, _tmp$435, _tmp$438, _tmp$441, _tmp$444, _tmp$447, _tmp$450, _tmp$453, _tmp$456, _tmp$459, _tmp$462, _tmp$465, _tmp$468, _tmp$471, _tmp$474, _tmp$477, _tmp$480, _tmp$483, _tmp$486, _tmp$489, _tmp$492, _tmp$495, _tmp$498, _tmp$501, _tmp$504, _tmp$507, _tmp$510, _tmp$513, _tmp$516, _tmp$519, _tmp$522, _tmp$525, _tmp$528, _tmp$531, _tmp$534, _tmp$537, _tmp$540, _tmp$543, _tmp$546, _tmp$549, _tmp$552, _tmp$555, _tmp$558, _tmp$561, _tmp$564, _tmp$567, _tmp$570, _tmp$573, _tmp$576, _tmp$579, _tmp$582, _tmp$585, _tmp$588, _tmp$591, _tmp$594, _tmp$597, _tmp$600, _tmp$603, _tmp$606, _tmp$609, _tmp$612, _tmp$615, _tmp$618, _tmp$621, _tmp$624, _tmp$627, _tmp$630, _tmp$633, _tmp$636, _tmp$639, _tmp$642, _tmp$645, _tmp$648, _tmp$651, _tmp$654, _tmp$657, _tmp$660, _tmp$663, _tmp$666, _tmp$669, _tmp$672, _tmp$675, _tmp$678, _tmp$681, _tmp$684, _tmp$687, _tmp$690, _tmp$693, _tmp$696, _tmp$699, _tmp$702, _tmp$705, _tmp$708, _tmp$711, _tmp$714, _tmp$717, _tmp$720, _tmp$723, _tmp$726, _tmp$729, _tmp$732, _tmp$735, _tmp$738, _tmp$741, _tmp$744, _tmp$747, _tmp$750, _tmp$753, _tmp$756, _tmp$759, _tmp$762, _tmp$765, _tmp$768, _tmp$771, _tmp$774, _tmp$777, _tmp$780, _tmp$783, _tmp$786, _tmp$789, _tmp$792, _tmp$795, _tmp$798, _tmp$801, _tmp$804, _tmp$807, _tmp$810, _tmp$813, _tmp$816, _tmp$819, _tmp$822, _tmp$825, _tmp$828, _tmp$831, _tmp$834, _tmp$837, _tmp$840, _tmp$843, _tmp$846, _tmp$849, _tmp$852, _tmp$855, _tmp$858, _tmp$861, _tmp$864, _tmp$867, _tmp$870, _tmp$873, _tmp$876, _tmp$879, _tmp$882, _tmp$885, _tmp$888, _tmp$891, _tmp$894, _tmp$897, _tmp$900, _tmp$903, _tmp$906, _tmp$909, _tmp$912, _tmp$915, _tmp$918, _tmp$921, _tmp$924, _tmp$927, _tmp$930, _tmp$933, _tmp$936, _tmp$939, _tmp$942, _tmp$945, _tmp$948, _tmp$951, _tmp$954, _tmp$957, _tmp$960, _tmp$963, _tmp$966, _tmp$969, _tmp$972, _tmp$975, _tmp$978, _tmp$981, _tmp$984, _tmp$987, _tmp$990, _tmp$993, _tmp$996, _tmp$999, _tmp$1002, _tmp$1005, _tmp$1008, _tmp$1011, _tmp$1014, _tmp$1017, _tmp$1020, _tmp$1023, _tmp$1026, _tmp$1029, _tmp$1032, _tmp$1035, _tmp$1038, _tmp$1041, _tmp$1044, _tmp$1047, _tmp$1050, _tmp$1053, _tmp$1056, _tmp$1059, _tmp$1062, _tmp$1065, _tmp$1068, _tmp$1071, _tmp$1074, _tmp$1077, _tmp$1080, _tmp$1083, _tmp$1086, _tmp$1089, _tmp$1092, _tmp$1095, _tmp$1098, _tmp$1101, _tmp$1104, _tmp$1107, _tmp$1110, _tmp$1113, _tmp$1116, _tmp$1119, _tmp$1122, _tmp$1125, _tmp$1128, _tmp$1131, _tmp$1134, _tmp$1137, _tmp$1140, _tmp$1143, _tmp$1146, _tmp$1149, _tmp$1152, _tmp$1155, _tmp$1158, _tmp$1161, _tmp$1164, _tmp$1167, _tmp$1170, _tmp$1173, _tmp$1176, _tmp$1179, _tmp$1182, _tmp$1185, _tmp$1188, _tmp$1191, _tmp$1194, _tmp$1197, _tmp$1200, _tmp$1203, _tmp$1206, _tmp$1209, _tmp$1212, _tmp$1215, _tmp$1218, _tmp$1221, _tmp$1224, _tmp$1227, _tmp$1230, _tmp$1233, _tmp$1236, _tmp$1239, _tmp$1242, _tmp$1245, _tmp$1248, _tmp$1251, _tmp$1254, _tmp$1257, _tmp$1260, _tmp$1263, _tmp$1266, _tmp$1269, _tmp$1272, _tmp$1275, _tmp$1278, _tmp$1281, _tmp$1284, _tmp$1287, _tmp$1290, _tmp$1293, _tmp$1296, _tmp$1299, _tmp$1302, _tmp$1305, _tmp$1308, _tmp$1311, _tmp$1314, _tmp$1317, _tmp$1320, _tmp$1323, _tmp$1326, _tmp$1329, _tmp$1332, _tmp$1335, _tmp$1338, _tmp$1341, _tmp$1344, _tmp$1347, _tmp$1350, _tmp$1353, _tmp$1356, _tmp$1359, _tmp$1362, _tmp$1365, _tmp$1368, _tmp$1371, _tmp$1374, _tmp$1377, _tmp$1380, _tmp$1383, _tmp$1386, _tmp$1389, _tmp$1392, _tmp$1395, _tmp$1398, _tmp$1401, _tmp$1404, _tmp$1407, _tmp$1410, _tmp$1413, _tmp$1416, _tmp$1419, _tmp$1422, _tmp$1425, _tmp$1428, _tmp$1431, _tmp$1434, _tmp$1437, _tmp$1440, _tmp$1443, _tmp$1446, _tmp$1449, _tmp$1452, _tmp$1455, _tmp$1458, _tmp$1461, _tmp$1464, _tmp$1467, _tmp$1470, _tmp$1473, _tmp$1476, _tmp$1479, _tmp$1482, _tmp$1485, _tmp$1488, _tmp$1491, _tmp$1494, _tmp$1497, _tmp$1500, _tmp$1503, _tmp$1506, _tmp$1509, _tmp$1512, _tmp$1515, _tmp$1518, _tmp$1521, _tmp$1524, _tmp$1527, _tmp$1530, _tmp$1533, _tmp$1536, _tmp$1539, _tmp$1542, _tmp$1545, _tmp$1548, _tmp$1551, _tmp$1554, _tmp$1557, _tmp$1560, _tmp$1563, _tmp$1566, _tmp$1569, _tmp$1572, _tmp$1575, _tmp$1578, _tmp$1581, _tmp$1584, _tmp$1587, _tmp$1590, _tmp$1593, _tmp$1596, _tmp$1599, _tmp$1602, _tmp$1605, _tmp$1608, _tmp$1611, _tmp$1614, _tmp$1617, _tmp$1620, _tmp$1623, _tmp$1626, _tmp$1629, _tmp$1632, _tmp$1635, _tmp$1638, _tmp$1641, _tmp$1644, _tmp$1647, _tmp$1650, _tmp$1653, _tmp$1656, _tmp$1659, _tmp$1662, _tmp$1665, _tmp$1668, _tmp$1671, _tmp$1674, _tmp$1677, _tmp$1680, _tmp$1683, _tmp$1686, _tmp$1689, _tmp$1692, _tmp$1695, _tmp$1698, _tmp$1701, _tmp$1704, _tmp$1707, _tmp$1710, _tmp$1713, _tmp$1716, _tmp$1719, _tmp$1722, _tmp$1725, _tmp$1728, _tmp$1731, _tmp$1734, _tmp$1737, _tmp$1740, _tmp$1743, _tmp$1746, _tmp$1749, _tmp$1752, _tmp$1755, _tmp$1758, _tmp$1761, _tmp$1764, _tmp$1767, _tmp$1770, _tmp$1773, _tmp$1776, _tmp$1779, _tmp$1782, _tmp$1785, _tmp$1788, _tmp$1791, _tmp$1794, _tmp$1797, _tmp$1800, _tmp$1803, _tmp$1806, _tmp$1809, _tmp$1812, _tmp$1815, _tmp$1818, _tmp$1821, _tmp$1824, _tmp$1827, _tmp$1830, _tmp$1833, _tmp$1836, _tmp$1839, _tmp$1842, _tmp$1845, _tmp$1848, _tmp$1851, _tmp$1854, _tmp$1857, _tmp$1860, _tmp$1863, _tmp$1866, _tmp$1869, _tmp$1872, _tmp$1875, _tmp$1878, _tmp$1881, _tmp$1884, _tmp$1887, _tmp$1890, _tmp$1893, _tmp$1896, _tmp$1899, _tmp$1902, _tmp$1905, _tmp$1908, _tmp$1911, _tmp$1914, _tmp$1917, _tmp$1920, _tmp$1923, _tmp$1926, _tmp$1929, _tmp$1932, _tmp$1935, _tmp$1938, _tmp$1941, _tmp$1944, _tmp$1947, _tmp$1950, _tmp$1953, _tmp$1956, _tmp$1959, _tmp$1962, _tmp$1965, _tmp$1968, _tmp$1971, _tmp$1974, _tmp$1977, _tmp$1980, _tmp$1983, _tmp$1986, _tmp$1989, _tmp$1992, _tmp$1995, _tmp$1998, _tmp$2001, _tmp$2004, _tmp$2007, _tmp$2010, _tmp$2013, _tmp$2016, _tmp$2019, _tmp$2022, _tmp$2025, _tmp$2028, _tmp$2031, _tmp$2034, _tmp$2037, _tmp$2040, _tmp$2043, _tmp$2046, _tmp$2049, _tmp$2052, _tmp$2055, _tmp$2058, _tmp$2061, _tmp$2064, _tmp$2067, _tmp$2070, _tmp$2073, _tmp$2076, _tmp$2079, _tmp$2082, _tmp$2085, _tmp$2088, _tmp$2091, _tmp$2094, _tmp$2097, _tmp$2100, _tmp$2103, _tmp$2106, _tmp$2109, _tmp$2112, _tmp$2115, _tmp$2118, _tmp$2121, _tmp$2124, _tmp$2127, _tmp$2130, _tmp$2133, _tmp$2136, _tmp$2139, _tmp$2142, _tmp$2145, _tmp$2148, _tmp$2151, _tmp$2154, _tmp$2157, _tmp$2160, _tmp$2163, _tmp$2166, _tmp$2169, _tmp$2172, _tmp$2175, _tmp$2178, _tmp$2181, _tmp$2184, _tmp$2187, _tmp$2190, _tmp$2193, _tmp$2196, _tmp$2199, _tmp$2202, _tmp$2205, _tmp$2208, _tmp$2211, _tmp$2214, _tmp$2217, _tmp$2220, _tmp$2223, _tmp$2226, _tmp$2229, _tmp$2232, _tmp$2235, _tmp$2238, _tmp$2241, _tmp$2244, _tmp$2247, _tmp$2250, _tmp$2253, new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4511)];
const _tmp$2256 = { _0: "tiles", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Array(_p$4512) };
const _p$4513 = false;
const _bind$764 = [_tmp$150, _tmp$2256, { _0: "collider", _1: _p$4513 ? $64$moonbitlang$47$core$47$builtin$46$Json$True : $64$moonbitlang$47$core$47$builtin$46$Json$False }];
const _p$4514 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$764, start: 0, end: 3 });
const _p$4515 = [_tmp$29, _tmp$43, _tmp$129, _tmp$149, new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4514)];
const _bind$765 = [_tmp, _tmp$2, _tmp$3, { _0: "layers", _1: new $64$moonbitlang$47$core$47$builtin$46$Json$Array(_p$4515) }];
const _p$4516 = moonbitlang$core$builtin$$Map$from_array$13$({ buf: _bind$765, start: 0, end: 4 });
const Milky2018$selene$examples$pixeladventure$$tilemap = new $64$moonbitlang$47$core$47$builtin$46$Json$Object(_p$4516);
const Milky2018$selene$examples$pixeladventure$$birds = moonbitlang$core$builtin$$Map$new$46$inner$14$(8);
const Milky2018$selene$collision$$colliders = moonbitlang$core$builtin$$Map$new$46$inner$15$(8);
const Milky2018$selene$examples$pixeladventure$$bird_fly_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas("assets/Enemies/BlueBird/Flying (32x32).png", 9, 32, 32, undefined, Option$None$0$), Milky2018$selene$examples$pixeladventure$$bird_fly_animation$46$constr$47$3232, Milky2018$selene$examples$pixeladventure$$bird_fly_animation$46$constr$47$3233, undefined);
const Milky2018$selene$velocity$$velocities = moonbitlang$core$builtin$$Map$new$46$inner$16$(8);
const Milky2018$selene$examples$pixeladventure$$enemy_collision_layer = Milky2018$selene$collision$$CollisionLayer$new();
const Milky2018$selene$examples$pixeladventure$$player_idle_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas("assets/Main Characters/Mask Dude/Idle (32x32).png", 11, 32, 32, undefined, Option$None$0$), Milky2018$selene$examples$pixeladventure$$player_idle_animation$46$constr$47$3222, Milky2018$selene$examples$pixeladventure$$player_idle_animation$46$constr$47$3223, undefined);
const Milky2018$selene$entity$$children = moonbitlang$core$builtin$$Map$new$46$inner$17$(8);
const Milky2018$selene$collision$$quadtree_root = moonbitlang$core$ref$$Ref$new$18$(Milky2018$selene$collision$$QuadTree$new({ _0: 0, _1: 0 }, { _0: 0, _1: 0 }, 0));
const Milky2018$selene$collision$$real_velocities = moonbitlang$core$builtin$$Map$new$46$inner$16$(8);
const Milky2018$selene$collision$$collision_infos = moonbitlang$core$builtin$$Map$new$46$inner$19$(8);
const Milky2018$selene$inputs$$pressed_keys = moonbitlang$core$set$$Set$new$46$inner$20$(8);
const Milky2018$selene$inputs$$last_pressed_keys = moonbitlang$core$set$$Set$new$46$inner$20$(8);
const Milky2018$selene$inputs$$all_codes = moonbitlang$core$set$$Set$from_array$20$({ buf: Milky2018$selene$inputs$$all_codes$46$42$bind$47$2162, start: 0, end: 33 });
const Milky2018$selene$inputs$$just_pressed_keys = moonbitlang$core$set$$Set$new$46$inner$20$(8);
const Milky2018$selene$inputs$$just_release_keys = moonbitlang$core$set$$Set$new$46$inner$20$(8);
const Milky2018$selene$backend$$element_cache = moonbitlang$core$builtin$$Map$new$46$inner$21$(8);
const Milky2018$selene$system$$timers = moonbitlang$core$array$$Array$new$46$inner$22$(0);
const Milky2018$selene$backend$$realtime_delta = moonbitlang$core$ref$$Ref$new$23$(0);
const Milky2018$selene$backend$$window = Yoorkin$rabbit$45$tea$dom$$window();
const Milky2018$selene$examples$pixeladventure$$bird_hit_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas("assets/Enemies/BlueBird/Hit (32x32).png", 5, 32, 32, undefined, Option$None$0$), Milky2018$selene$examples$pixeladventure$$bird_hit_animation$46$constr$47$3988, Milky2018$selene$examples$pixeladventure$$bird_hit_animation$46$constr$47$3989, undefined);
const Milky2018$selene$examples$pixeladventure$$player_hit_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas("assets/Main Characters/Mask Dude/Hit (32x32).png", 7, 32, 32, undefined, Option$None$0$), Milky2018$selene$examples$pixeladventure$$player_hit_animation$46$constr$47$3230, Milky2018$selene$examples$pixeladventure$$player_hit_animation$46$constr$47$3231, undefined);
const Milky2018$selene$examples$pixeladventure$$player_fall_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas("assets/Main Characters/Mask Dude/Fall (32x32).png", 1, 32, 32, undefined, Option$None$0$), Milky2018$selene$examples$pixeladventure$$player_fall_animation$46$constr$47$3226, Milky2018$selene$examples$pixeladventure$$player_fall_animation$46$constr$47$3227, undefined);
const Milky2018$selene$examples$pixeladventure$$player_jump_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas("assets/Main Characters/Mask Dude/Jump (32x32).png", 1, 32, 32, undefined, Option$None$0$), Milky2018$selene$examples$pixeladventure$$player_jump_animation$46$constr$47$3228, Milky2018$selene$examples$pixeladventure$$player_jump_animation$46$constr$47$3229, undefined);
const Milky2018$selene$examples$pixeladventure$$player_run_animation = Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas("assets/Main Characters/Mask Dude/Run (32x32).png", 12, 32, 32, undefined, Option$None$0$), Milky2018$selene$examples$pixeladventure$$player_run_animation$46$constr$47$3224, Milky2018$selene$examples$pixeladventure$$player_run_animation$46$constr$47$3225, undefined);
function moonbitlang$core$abort$$abort$24$(msg) {
  $panic();
}
function moonbitlang$core$abort$$abort$18$(msg) {
  return $panic();
}
function moonbitlang$core$json$$decode_error$10$(path, msg) {
  return new Result$Err$1$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: path, _1: msg }));
}
function moonbitlang$core$json$$decode_error$24$(path, msg) {
  return new Result$Err$2$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: path, _1: msg }));
}
function moonbitlang$core$json$$decode_error$25$(path, msg) {
  return new Result$Err$3$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: path, _1: msg }));
}
function moonbitlang$core$json$$decode_error$26$(path, msg) {
  return new Result$Err$4$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: path, _1: msg }));
}
function moonbitlang$core$json$$decode_error$27$(path, msg) {
  return new Result$Err$5$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: path, _1: msg }));
}
function moonbitlang$core$json$$decode_error$28$(path, msg) {
  return new Result$Err$6$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: path, _1: msg }));
}
function moonbitlang$core$json$$from_json$46$inner$29$(json, path) {
  return moonbitlang$core$json$$FromJson$from_json$29$(json, path);
}
function moonbitlang$core$json$$from_json$29$(json, path$46$opt) {
  let path;
  if (path$46$opt === undefined) {
    path = $64$moonbitlang$47$core$47$json$46$JsonPath$Root;
  } else {
    const _Some = path$46$opt;
    path = _Some;
  }
  return moonbitlang$core$json$$from_json$46$inner$29$(json, path);
}
function moonbitlang$core$json$$FromJson$from_json$28$(json, path) {
  switch (json.$tag) {
    case 1: {
      return new Result$Ok$6$(true);
    }
    case 2: {
      return new Result$Ok$6$(false);
    }
    default: {
      return moonbitlang$core$json$$decode_error$28$(path, "Bool::from_json: expected boolean");
    }
  }
}
function moonbitlang$core$json$$FromJson$from_json$10$(json, path) {
  _L: {
    if (json.$tag === 3) {
      const _Number = json;
      const _n = _Number._0;
      if (_n !== moonbitlang$core$double$$infinity) {
        if (_n !== moonbitlang$core$double$$neg_infinity) {
          if (_n > 2147483647 || _n < -2147483648) {
            const _bind$766 = moonbitlang$core$json$$decode_error$24$(path, "Int::from_json: overflow");
            if (_bind$766.$tag === 1) {
              const _ok = _bind$766;
              _ok._0;
            } else {
              return _bind$766;
            }
          }
          return new Result$Ok$1$(moonbitlang$core$double$$Double$to_int(_n));
        } else {
          break _L;
        }
      } else {
        break _L;
      }
    } else {
      break _L;
    }
  }
  return moonbitlang$core$json$$decode_error$10$(path, "Int::from_json: expected number");
}
function moonbitlang$core$json$$FromJson$from_json$26$(json, path) {
  if (json.$tag === 4) {
    const _String = json;
    const _a = _String._0;
    return new Result$Ok$4$(_a);
  } else {
    return moonbitlang$core$json$$decode_error$26$(path, "String::from_json: expected string");
  }
}
function moonbitlang$core$json$$FromJson$from_json$30$(json, path) {
  if (json.$tag === 5) {
    const _Array = json;
    const _a = _Array._0;
    const _bind$766 = new $64$moonbitlang$47$core$47$json$46$JsonPath$Index(path, 0);
    if (_bind$766.$tag === 2) {
      const _Index = _bind$766;
      let _p$4517;
      _L: {
        let _p$4518;
        _L$2: {
          if (_a.length === 0) {
            const _tmp$2257 = [];
            _p$4517 = _tmp$2257;
            break _L;
          }
          const _p$4519 = new Array(_a.length);
          const _p$4520 = _a.length;
          let _tmp$2257 = 0;
          while (true) {
            const _p$4521 = _tmp$2257;
            if (_p$4521 < _p$4520) {
              const _p$4522 = _a[_p$4521];
              _Index._1 = _p$4521;
              const _bind$767 = moonbitlang$core$json$$FromJson$from_json$31$(_p$4522, _Index);
              let _tmp$2258;
              if (_bind$767.$tag === 1) {
                const _ok = _bind$767;
                _tmp$2258 = _ok._0;
              } else {
                const _err = _bind$767;
                const _tmp$2259 = _err._0;
                _p$4518 = _tmp$2259;
                break _L$2;
              }
              _p$4519[_p$4521] = _tmp$2258;
              _tmp$2257 = _p$4521 + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          return new Result$Ok$3$(_p$4519);
        }
        return new Result$Err$3$(_p$4518);
      }
      return new Result$Ok$3$(_p$4517);
    } else {
      return new Result$Ok$3$($panic());
    }
  } else {
    return moonbitlang$core$json$$decode_error$25$(path, "Array::from_json: expected array");
  }
}
function moonbitlang$core$json$$FromJson$from_json$32$(json, path) {
  if (json.$tag === 5) {
    const _Array = json;
    const _a = _Array._0;
    const _bind$766 = new $64$moonbitlang$47$core$47$json$46$JsonPath$Index(path, 0);
    if (_bind$766.$tag === 2) {
      const _Index = _bind$766;
      let _p$4517;
      _L: {
        let _p$4518;
        _L$2: {
          if (_a.length === 0) {
            const _tmp$2257 = [];
            _p$4517 = _tmp$2257;
            break _L;
          }
          const _p$4519 = new Array(_a.length);
          const _p$4520 = _a.length;
          let _tmp$2257 = 0;
          while (true) {
            const _p$4521 = _tmp$2257;
            if (_p$4521 < _p$4520) {
              const _p$4522 = _a[_p$4521];
              _Index._1 = _p$4521;
              const _bind$767 = moonbitlang$core$json$$FromJson$from_json$33$(_p$4522, _Index);
              let _tmp$2258;
              if (_bind$767.$tag === 1) {
                const _ok = _bind$767;
                _tmp$2258 = _ok._0;
              } else {
                const _err = _bind$767;
                const _tmp$2259 = _err._0;
                _p$4518 = _tmp$2259;
                break _L$2;
              }
              _p$4519[_p$4521] = _tmp$2258;
              _tmp$2257 = _p$4521 + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          return new Result$Ok$5$(_p$4519);
        }
        return new Result$Err$5$(_p$4518);
      }
      return new Result$Ok$5$(_p$4517);
    } else {
      return new Result$Ok$5$($panic());
    }
  } else {
    return moonbitlang$core$json$$decode_error$27$(path, "Array::from_json: expected array");
  }
}
function moonbitlang$core$list$$List$from_array$18$(arr) {
  let _tmp$2257 = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp$2258 = $64$moonbitlang$47$core$47$list$46$List$Empty$7$;
  while (true) {
    const i = _tmp$2257;
    const list = _tmp$2258;
    if (i >= 0) {
      _tmp$2257 = i - 1 | 0;
      _tmp$2258 = new $64$moonbitlang$47$core$47$list$46$List$More$7$(moonbitlang$core$array$$ArrayView$at$18$(arr, i), list);
      continue;
    } else {
      return list;
    }
  }
}
function moonbitlang$core$set$$Set$new$46$inner$20$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$set$$Set$new$46$inner$3$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$set$$Set$add_entry_to_tail$3$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$set$$Set$add_entry_to_tail$20$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$set$$Set$set_entry$20$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$set$$Set$set_entry$3$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$set$$Set$push_away$3$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$set$$Set$set_entry$3$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$set$$Set$set_entry$3$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$set$$Set$push_away$20$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$set$$Set$set_entry$20$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$set$$Set$set_entry$20$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$set$$Set$add_with_hash$3$(self, key, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$set$$Set$grow$3$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$set$$Set$push_away$3$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key };
  moonbitlang$core$set$$Set$add_entry_to_tail$3$(self, _idx, entry);
}
function moonbitlang$core$set$$Set$add_with_hash$20$(self, key, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$set$$Set$grow$20$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$20$(_curr_entry.key, key)) {
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$set$$Set$push_away$20$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key };
  moonbitlang$core$set$$Set$add_entry_to_tail$20$(self, _idx, entry);
}
function moonbitlang$core$set$$Set$grow$3$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _hash = _x.hash;
      moonbitlang$core$set$$Set$add_with_hash$3$(self, _key, _hash);
      _tmp$2257 = _next;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$grow$20$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _hash = _x.hash;
      moonbitlang$core$set$$Set$add_with_hash$20$(self, _key, _hash);
      _tmp$2257 = _next;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$add$3$(self, key) {
  moonbitlang$core$set$$Set$add_with_hash$3$(self, key, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$set$$Set$add$20$(self, key) {
  moonbitlang$core$set$$Set$add_with_hash$20$(self, key, moonbitlang$core$builtin$$Hash$hash$35$(key));
}
function moonbitlang$core$set$$Set$from_array$20$(arr) {
  const length = arr.end - arr.start | 0;
  let capacity = moonbitlang$core$int$$Int$next_power_of_two(length);
  const _p$4517 = capacity;
  if (length > ((Math.imul(_p$4517, 13) | 0) / 16 | 0)) {
    capacity = Math.imul(capacity, 2) | 0;
  }
  const m = moonbitlang$core$set$$Set$new$46$inner$20$(capacity);
  const _len = arr.end - arr.start | 0;
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const e = arr.buf[arr.start + _i | 0];
      moonbitlang$core$set$$Set$add$20$(m, e);
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function moonbitlang$core$set$$Set$contains$3$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return false;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$contains$20$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$35$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return false;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      if (_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$20$(_entry.key, key)) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$remove_entry$20$(self, entry) {
  const _bind$766 = entry.prev;
  if (_bind$766 === -1) {
    self.head = entry.next;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    const _tmp$2259 = _tmp$2258;
    _tmp$2259.next = entry.next;
  }
  const _bind$767 = entry.next;
  if (_bind$767 === undefined) {
    self.tail = entry.prev;
    return;
  } else {
    const _Some = _bind$767;
    const _next = _Some;
    _next.prev = entry.prev;
    return;
  }
}
function moonbitlang$core$set$$Set$remove_entry$3$(self, entry) {
  const _bind$766 = entry.prev;
  if (_bind$766 === -1) {
    self.head = entry.next;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    const _tmp$2259 = _tmp$2258;
    _tmp$2259.next = entry.next;
  }
  const _bind$767 = entry.next;
  if (_bind$767 === undefined) {
    self.tail = entry.prev;
    return;
  } else {
    const _Some = _bind$767;
    const _next = _Some;
    _next.prev = entry.prev;
    return;
  }
}
function moonbitlang$core$set$$Set$shift_back$20$(self, idx) {
  let _tmp$2257 = idx;
  while (true) {
    const idx$2 = _tmp$2257;
    const next = idx$2 + 1 & self.capacity_mask;
    _L: {
      const _tmp$2258 = self.entries;
      $bound_check(_tmp$2258, next);
      const _bind$766 = _tmp$2258[next];
      if (_bind$766 === undefined) {
        break _L;
      } else {
        const _Some = _bind$766;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          moonbitlang$core$set$$Set$set_entry$20$(self, _x, idx$2);
          _tmp$2257 = next;
          continue;
        }
      }
    }
    const _tmp$2258 = self.entries;
    $bound_check(_tmp$2258, idx$2);
    _tmp$2258[idx$2] = undefined;
    return;
  }
}
function moonbitlang$core$set$$Set$shift_back$3$(self, idx) {
  let _tmp$2257 = idx;
  while (true) {
    const idx$2 = _tmp$2257;
    const next = idx$2 + 1 & self.capacity_mask;
    _L: {
      const _tmp$2258 = self.entries;
      $bound_check(_tmp$2258, next);
      const _bind$766 = _tmp$2258[next];
      if (_bind$766 === undefined) {
        break _L;
      } else {
        const _Some = _bind$766;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          moonbitlang$core$set$$Set$set_entry$3$(self, _x, idx$2);
          _tmp$2257 = next;
          continue;
        }
      }
    }
    const _tmp$2258 = self.entries;
    $bound_check(_tmp$2258, idx$2);
    _tmp$2258[idx$2] = undefined;
    return;
  }
}
function moonbitlang$core$set$$Set$remove$20$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$35$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      break;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      if (_entry.hash === hash && moonbitlang$core$builtin$$Eq$equal$20$(_entry.key, key)) {
        moonbitlang$core$set$$Set$remove_entry$20$(self, _entry);
        moonbitlang$core$set$$Set$shift_back$20$(self, idx);
        self.size = self.size - 1 | 0;
        break;
      }
      if (i > _entry.psl) {
        break;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$remove$3$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      break;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        moonbitlang$core$set$$Set$remove_entry$3$(self, _entry);
        moonbitlang$core$set$$Set$shift_back$3$(self, idx);
        self.size = self.size - 1 | 0;
        break;
      }
      if (i > _entry.psl) {
        break;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$clear$20$(self) {
  moonbitlang$core$array$$FixedArray$fill$46$inner$36$(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function moonbitlang$core$set$$Set$iter$3$(self) {
  const _p$4517 = (yield_) => {
    let _tmp$2257 = self.head;
    while (true) {
      const _param = _tmp$2257;
      if (_param === undefined) {
        return 1;
      } else {
        const _Some = _param;
        const _x = _Some;
        const _key = _x.key;
        const _next = _x.next;
        const _bind$766 = yield_(_key);
        if (_bind$766 === 1) {
          _tmp$2257 = _next;
          continue;
        } else {
          return 0;
        }
      }
    }
  };
  return _p$4517;
}
function moonbitlang$core$set$$Set$iterator$20$(self) {
  const curr_entry = { val: self.head };
  const _p$4517 = () => {
    const _bind$766 = curr_entry.val;
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _key = _x.key;
      const _next = _x.next;
      curr_entry.val = _next;
      return _key;
    }
  };
  return _p$4517;
}
function moonbitlang$core$set$$Set$iterator$3$(self) {
  const curr_entry = { val: self.head };
  const _p$4517 = () => {
    const _bind$766 = curr_entry.val;
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _key = _x.key;
      const _next = _x.next;
      curr_entry.val = _next;
      return _key;
    }
  };
  return _p$4517;
}
function moonbitlang$core$set$$Set$difference$20$(self, other) {
  const m = moonbitlang$core$set$$Set$new$46$inner$20$(8);
  let _tmp$2257 = self.head;
  while (true) {
    const _p$4517 = _tmp$2257;
    if (_p$4517 === undefined) {
      break;
    } else {
      const _p$4518 = _p$4517;
      const _p$4519 = _p$4518;
      const _p$4520 = _p$4519.key;
      const _p$4521 = _p$4519.next;
      if (!moonbitlang$core$set$$Set$contains$20$(other, _p$4520)) {
        moonbitlang$core$set$$Set$add$20$(m, _p$4520);
      }
      _tmp$2257 = _p$4521;
      continue;
    }
  }
  return m;
}
function moonbitlang$core$set$$Set$union$20$(self, other) {
  const m = moonbitlang$core$set$$Set$new$46$inner$20$(8);
  let _tmp$2257 = self.head;
  while (true) {
    const _p$4517 = _tmp$2257;
    if (_p$4517 === undefined) {
      break;
    } else {
      const _p$4518 = _p$4517;
      const _p$4519 = _p$4518;
      const _p$4520 = _p$4519.key;
      const _p$4521 = _p$4519.next;
      moonbitlang$core$set$$Set$add$20$(m, _p$4520);
      _tmp$2257 = _p$4521;
      continue;
    }
  }
  let _tmp$2258 = other.head;
  while (true) {
    const _p$4517 = _tmp$2258;
    if (_p$4517 === undefined) {
      break;
    } else {
      const _p$4518 = _p$4517;
      const _p$4519 = _p$4518;
      const _p$4520 = _p$4519.key;
      const _p$4521 = _p$4519.next;
      moonbitlang$core$set$$Set$add$20$(m, _p$4520);
      _tmp$2258 = _p$4521;
      continue;
    }
  }
  return m;
}
function moonbitlang$core$set$$Set$union$3$(self, other) {
  const m = moonbitlang$core$set$$Set$new$46$inner$3$(8);
  let _tmp$2257 = self.head;
  while (true) {
    const _p$4517 = _tmp$2257;
    if (_p$4517 === undefined) {
      break;
    } else {
      const _p$4518 = _p$4517;
      const _p$4519 = _p$4518;
      const _p$4520 = _p$4519.key;
      const _p$4521 = _p$4519.next;
      moonbitlang$core$set$$Set$add$3$(m, _p$4520);
      _tmp$2257 = _p$4521;
      continue;
    }
  }
  let _tmp$2258 = other.head;
  while (true) {
    const _p$4517 = _tmp$2258;
    if (_p$4517 === undefined) {
      break;
    } else {
      const _p$4518 = _p$4517;
      const _p$4519 = _p$4518;
      const _p$4520 = _p$4519.key;
      const _p$4521 = _p$4519.next;
      moonbitlang$core$set$$Set$add$3$(m, _p$4520);
      _tmp$2258 = _p$4521;
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
function moonbitlang$core$array$$Array$bubble_sort_by$37$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const _start970 = actual_start + 1 | 0;
  let _tmp$2257 = _start970;
  while (true) {
    const i = _tmp$2257;
    if (i < actual_end) {
      let _tmp$2258 = i;
      while (true) {
        const j = _tmp$2258;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$37$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$37$(arr, j)) > 0) {
          const temp = moonbitlang$core$array$$Array$at$37$(arr, j);
          moonbitlang$core$array$$Array$set$37$(arr, j, moonbitlang$core$array$$Array$at$37$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$37$(arr, j - 1 | 0, temp);
          _tmp$2258 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp$2257 = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$bubble_sort_by$38$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const _start970 = actual_start + 1 | 0;
  let _tmp$2257 = _start970;
  while (true) {
    const i = _tmp$2257;
    if (i < actual_end) {
      let _tmp$2258 = i;
      while (true) {
        const j = _tmp$2258;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$38$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$38$(arr, j)) > 0) {
          const temp = moonbitlang$core$array$$Array$at$38$(arr, j);
          moonbitlang$core$array$$Array$set$38$(arr, j, moonbitlang$core$array$$Array$at$38$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$38$(arr, j - 1 | 0, temp);
          _tmp$2258 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp$2257 = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$325(_env, a_idx, b_idx) {
  const actual_start = _env._3;
  const arr = _env._2;
  const swaps = _env._1;
  const cmp = _env._0;
  const a_pos = actual_start + a_idx | 0;
  const b_pos = actual_start + b_idx | 0;
  if (cmp(moonbitlang$core$array$$Array$at$37$(arr, a_pos), moonbitlang$core$array$$Array$at$37$(arr, b_pos)) > 0) {
    const temp = moonbitlang$core$array$$Array$at$37$(arr, a_pos);
    moonbitlang$core$array$$Array$set$37$(arr, a_pos, moonbitlang$core$array$$Array$at$37$(arr, b_pos));
    moonbitlang$core$array$$Array$set$37$(arr, b_pos, temp);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$326(_env, a_idx, b_idx, c_idx) {
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$325(_env, a_idx, b_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$325(_env, b_idx, c_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$325(_env, a_idx, b_idx);
}
function moonbitlang$core$array$$Array$choose_pivot_by$37$(arr, start, end, cmp) {
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
    const _env = { _0: cmp, _1: swaps, _2: arr, _3: actual_start };
    if (len > 50) {
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$326(_env, a - 1 | 0, a, a + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$326(_env, b - 1 | 0, b, b + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$326(_env, c - 1 | 0, c, c + 1 | 0);
    }
    moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$326(_env, a, b, c);
  }
  if (swaps.val === 12) {
    const mid_len = len / 2 | 0;
    let _tmp$2257 = 0;
    while (true) {
      const i = _tmp$2257;
      if (i < mid_len) {
        const j = (len - i | 0) - 1 | 0;
        const i_pos = actual_start + i | 0;
        const j_pos = actual_start + j | 0;
        const temp = moonbitlang$core$array$$Array$at$37$(arr, i_pos);
        moonbitlang$core$array$$Array$set$37$(arr, i_pos, moonbitlang$core$array$$Array$at$37$(arr, j_pos));
        moonbitlang$core$array$$Array$set$37$(arr, j_pos, temp);
        _tmp$2257 = i + 1 | 0;
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
function moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$360(_env, a_idx, b_idx) {
  const actual_start = _env._3;
  const arr = _env._2;
  const swaps = _env._1;
  const cmp = _env._0;
  const a_pos = actual_start + a_idx | 0;
  const b_pos = actual_start + b_idx | 0;
  if (cmp(moonbitlang$core$array$$Array$at$38$(arr, a_pos), moonbitlang$core$array$$Array$at$38$(arr, b_pos)) > 0) {
    const temp = moonbitlang$core$array$$Array$at$38$(arr, a_pos);
    moonbitlang$core$array$$Array$set$38$(arr, a_pos, moonbitlang$core$array$$Array$at$38$(arr, b_pos));
    moonbitlang$core$array$$Array$set$38$(arr, b_pos, temp);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$361(_env, a_idx, b_idx, c_idx) {
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$360(_env, a_idx, b_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$360(_env, b_idx, c_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$360(_env, a_idx, b_idx);
}
function moonbitlang$core$array$$Array$choose_pivot_by$38$(arr, start, end, cmp) {
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
    const _env = { _0: cmp, _1: swaps, _2: arr, _3: actual_start };
    if (len > 50) {
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$361(_env, a - 1 | 0, a, a + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$361(_env, b - 1 | 0, b, b + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$361(_env, c - 1 | 0, c, c + 1 | 0);
    }
    moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$361(_env, a, b, c);
  }
  if (swaps.val === 12) {
    const mid_len = len / 2 | 0;
    let _tmp$2257 = 0;
    while (true) {
      const i = _tmp$2257;
      if (i < mid_len) {
        const j = (len - i | 0) - 1 | 0;
        const i_pos = actual_start + i | 0;
        const j_pos = actual_start + j | 0;
        const temp = moonbitlang$core$array$$Array$at$38$(arr, i_pos);
        moonbitlang$core$array$$Array$set$38$(arr, i_pos, moonbitlang$core$array$$Array$at$38$(arr, j_pos));
        moonbitlang$core$array$$Array$set$38$(arr, j_pos, temp);
        _tmp$2257 = i + 1 | 0;
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
function moonbitlang$core$array$$Array$sift_down_by$37$(arr, start, end, index, cmp) {
  let current = index;
  const len = end - start | 0;
  let child = (Math.imul(current, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      const child_pos = start + child | 0;
      const current_pos = start + current | 0;
      if ((child + 1 | 0) < len && cmp(moonbitlang$core$array$$Array$at$37$(arr, child_pos), moonbitlang$core$array$$Array$at$37$(arr, child_pos + 1 | 0)) < 0) {
        child = child + 1 | 0;
      }
      const new_child_pos = start + child | 0;
      if (cmp(moonbitlang$core$array$$Array$at$37$(arr, current_pos), moonbitlang$core$array$$Array$at$37$(arr, new_child_pos)) >= 0) {
        return undefined;
      }
      const temp = moonbitlang$core$array$$Array$at$37$(arr, current_pos);
      moonbitlang$core$array$$Array$set$37$(arr, current_pos, moonbitlang$core$array$$Array$at$37$(arr, new_child_pos));
      moonbitlang$core$array$$Array$set$37$(arr, new_child_pos, temp);
      current = child;
      child = (Math.imul(current, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$sift_down_by$38$(arr, start, end, index, cmp) {
  let current = index;
  const len = end - start | 0;
  let child = (Math.imul(current, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      const child_pos = start + child | 0;
      const current_pos = start + current | 0;
      if ((child + 1 | 0) < len && cmp(moonbitlang$core$array$$Array$at$38$(arr, child_pos), moonbitlang$core$array$$Array$at$38$(arr, child_pos + 1 | 0)) < 0) {
        child = child + 1 | 0;
      }
      const new_child_pos = start + child | 0;
      if (cmp(moonbitlang$core$array$$Array$at$38$(arr, current_pos), moonbitlang$core$array$$Array$at$38$(arr, new_child_pos)) >= 0) {
        return undefined;
      }
      const temp = moonbitlang$core$array$$Array$at$38$(arr, current_pos);
      moonbitlang$core$array$$Array$set$38$(arr, current_pos, moonbitlang$core$array$$Array$at$38$(arr, new_child_pos));
      moonbitlang$core$array$$Array$set$38$(arr, new_child_pos, temp);
      current = child;
      child = (Math.imul(current, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$heap_sort_by$37$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const len = actual_end - actual_start | 0;
  let _tmp$2257 = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp$2257;
    if (i >= 0) {
      moonbitlang$core$array$$Array$sift_down_by$37$(arr, actual_start, actual_end, i, cmp);
      _tmp$2257 = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$2258 = len - 1 | 0;
  while (true) {
    const i = _tmp$2258;
    if (i > 0) {
      const last = actual_start + i | 0;
      const temp = moonbitlang$core$array$$Array$at$37$(arr, actual_start);
      moonbitlang$core$array$$Array$set$37$(arr, actual_start, moonbitlang$core$array$$Array$at$37$(arr, last));
      moonbitlang$core$array$$Array$set$37$(arr, last, temp);
      moonbitlang$core$array$$Array$sift_down_by$37$(arr, actual_start, actual_start + i | 0, 0, cmp);
      _tmp$2258 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$heap_sort_by$38$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const len = actual_end - actual_start | 0;
  let _tmp$2257 = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp$2257;
    if (i >= 0) {
      moonbitlang$core$array$$Array$sift_down_by$38$(arr, actual_start, actual_end, i, cmp);
      _tmp$2257 = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$2258 = len - 1 | 0;
  while (true) {
    const i = _tmp$2258;
    if (i > 0) {
      const last = actual_start + i | 0;
      const temp = moonbitlang$core$array$$Array$at$38$(arr, actual_start);
      moonbitlang$core$array$$Array$set$38$(arr, actual_start, moonbitlang$core$array$$Array$at$38$(arr, last));
      moonbitlang$core$array$$Array$set$38$(arr, last, temp);
      moonbitlang$core$array$$Array$sift_down_by$38$(arr, actual_start, actual_start + i | 0, 0, cmp);
      _tmp$2258 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$partition_by$37$(arr, start, end, cmp, pivot_index) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const last_index = actual_end - 1 | 0;
  const temp = moonbitlang$core$array$$Array$at$37$(arr, pivot_index);
  moonbitlang$core$array$$Array$set$37$(arr, pivot_index, moonbitlang$core$array$$Array$at$37$(arr, last_index));
  moonbitlang$core$array$$Array$set$37$(arr, last_index, temp);
  const pivot = moonbitlang$core$array$$Array$at$37$(arr, last_index);
  let i = actual_start;
  let partitioned = true;
  let _tmp$2257 = actual_start;
  while (true) {
    const j = _tmp$2257;
    if (j < last_index) {
      if (cmp(moonbitlang$core$array$$Array$at$37$(arr, j), pivot) < 0) {
        if (i !== j) {
          const temp$2 = moonbitlang$core$array$$Array$at$37$(arr, i);
          moonbitlang$core$array$$Array$set$37$(arr, i, moonbitlang$core$array$$Array$at$37$(arr, j));
          moonbitlang$core$array$$Array$set$37$(arr, j, temp$2);
          partitioned = false;
        }
        i = i + 1 | 0;
      }
      _tmp$2257 = j + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const temp$2 = moonbitlang$core$array$$Array$at$37$(arr, i);
  moonbitlang$core$array$$Array$set$37$(arr, i, moonbitlang$core$array$$Array$at$37$(arr, last_index));
  moonbitlang$core$array$$Array$set$37$(arr, last_index, temp$2);
  return { _0: i, _1: partitioned };
}
function moonbitlang$core$array$$Array$partition_by$38$(arr, start, end, cmp, pivot_index) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const last_index = actual_end - 1 | 0;
  const temp = moonbitlang$core$array$$Array$at$38$(arr, pivot_index);
  moonbitlang$core$array$$Array$set$38$(arr, pivot_index, moonbitlang$core$array$$Array$at$38$(arr, last_index));
  moonbitlang$core$array$$Array$set$38$(arr, last_index, temp);
  const pivot = moonbitlang$core$array$$Array$at$38$(arr, last_index);
  let i = actual_start;
  let partitioned = true;
  let _tmp$2257 = actual_start;
  while (true) {
    const j = _tmp$2257;
    if (j < last_index) {
      if (cmp(moonbitlang$core$array$$Array$at$38$(arr, j), pivot) < 0) {
        if (i !== j) {
          const temp$2 = moonbitlang$core$array$$Array$at$38$(arr, i);
          moonbitlang$core$array$$Array$set$38$(arr, i, moonbitlang$core$array$$Array$at$38$(arr, j));
          moonbitlang$core$array$$Array$set$38$(arr, j, temp$2);
          partitioned = false;
        }
        i = i + 1 | 0;
      }
      _tmp$2257 = j + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const temp$2 = moonbitlang$core$array$$Array$at$38$(arr, i);
  moonbitlang$core$array$$Array$set$38$(arr, i, moonbitlang$core$array$$Array$at$38$(arr, last_index));
  moonbitlang$core$array$$Array$set$38$(arr, last_index, temp$2);
  return { _0: i, _1: partitioned };
}
function moonbitlang$core$array$$Array$try_bubble_sort_by$37$(arr, start, end, cmp) {
  let tries = 0;
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return true;
  }
  const _start985 = actual_start + 1 | 0;
  let _tmp$2257 = _start985;
  while (true) {
    const i = _tmp$2257;
    if (i < actual_end) {
      let sorted = true;
      let _tmp$2258 = i;
      while (true) {
        const j = _tmp$2258;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$37$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$37$(arr, j)) > 0) {
          sorted = false;
          const temp = moonbitlang$core$array$$Array$at$37$(arr, j);
          moonbitlang$core$array$$Array$set$37$(arr, j, moonbitlang$core$array$$Array$at$37$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$37$(arr, j - 1 | 0, temp);
          _tmp$2258 = j - 1 | 0;
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
      _tmp$2257 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function moonbitlang$core$array$$Array$try_bubble_sort_by$38$(arr, start, end, cmp) {
  let tries = 0;
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return true;
  }
  const _start985 = actual_start + 1 | 0;
  let _tmp$2257 = _start985;
  while (true) {
    const i = _tmp$2257;
    if (i < actual_end) {
      let sorted = true;
      let _tmp$2258 = i;
      while (true) {
        const j = _tmp$2258;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$38$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$38$(arr, j)) > 0) {
          sorted = false;
          const temp = moonbitlang$core$array$$Array$at$38$(arr, j);
          moonbitlang$core$array$$Array$set$38$(arr, j, moonbitlang$core$array$$Array$at$38$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$38$(arr, j - 1 | 0, temp);
          _tmp$2258 = j - 1 | 0;
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
      _tmp$2257 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function moonbitlang$core$array$$Array$quick_sort_by$37$(arr, start, end, cmp, pred, limit) {
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
        moonbitlang$core$array$$Array$bubble_sort_by$37$(arr, current_start, current_end, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      moonbitlang$core$array$$Array$heap_sort_by$37$(arr, current_start, current_end, cmp);
      return undefined;
    }
    const _bind$766 = moonbitlang$core$array$$Array$choose_pivot_by$37$(arr, current_start, current_end, cmp);
    const _pivot_index = _bind$766._0;
    const _likely_sorted = _bind$766._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (moonbitlang$core$array$$Array$try_bubble_sort_by$37$(arr, current_start, current_end, cmp)) {
        return undefined;
      }
    }
    const _bind$767 = moonbitlang$core$array$$Array$partition_by$37$(arr, current_start, current_end, cmp, _pivot_index);
    const _actual_pivot_pos = _bind$767._0;
    const _partitioned = _bind$767._1;
    was_partitioned = _partitioned;
    const pivot_pos = _actual_pivot_pos - current_start | 0;
    const diff = len - pivot_pos | 0;
    balanced = (pivot_pos < diff ? pivot_pos : diff) >= (len / 8 | 0);
    if (!balanced) {
      limit$2 = limit$2 - 1 | 0;
    }
    const _bind$768 = pred$2;
    if (_bind$768 === undefined) {
    } else {
      const _Some = _bind$768;
      const _pred = _Some;
      if (cmp(_pred, moonbitlang$core$array$$Array$at$37$(arr, _actual_pivot_pos)) === 0) {
        let i = _actual_pivot_pos;
        while (true) {
          if (i < current_end && cmp(_pred, moonbitlang$core$array$$Array$at$37$(arr, i)) === 0) {
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
      moonbitlang$core$array$$Array$quick_sort_by$37$(arr, left_start, _actual_pivot_pos, cmp, pred$2, limit$2);
      pred$2 = moonbitlang$core$array$$Array$at$37$(arr, _actual_pivot_pos);
      current_start = right_start;
      current_end = right_end;
    } else {
      moonbitlang$core$array$$Array$quick_sort_by$37$(arr, right_start, right_end, cmp, moonbitlang$core$array$$Array$at$37$(arr, _actual_pivot_pos), limit$2);
      current_start = left_start;
      current_end = _actual_pivot_pos;
    }
    continue;
  }
}
function moonbitlang$core$array$$Array$quick_sort_by$38$(arr, start, end, cmp, pred, limit) {
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
        moonbitlang$core$array$$Array$bubble_sort_by$38$(arr, current_start, current_end, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      moonbitlang$core$array$$Array$heap_sort_by$38$(arr, current_start, current_end, cmp);
      return undefined;
    }
    const _bind$766 = moonbitlang$core$array$$Array$choose_pivot_by$38$(arr, current_start, current_end, cmp);
    const _pivot_index = _bind$766._0;
    const _likely_sorted = _bind$766._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (moonbitlang$core$array$$Array$try_bubble_sort_by$38$(arr, current_start, current_end, cmp)) {
        return undefined;
      }
    }
    const _bind$767 = moonbitlang$core$array$$Array$partition_by$38$(arr, current_start, current_end, cmp, _pivot_index);
    const _actual_pivot_pos = _bind$767._0;
    const _partitioned = _bind$767._1;
    was_partitioned = _partitioned;
    const pivot_pos = _actual_pivot_pos - current_start | 0;
    const diff = len - pivot_pos | 0;
    balanced = (pivot_pos < diff ? pivot_pos : diff) >= (len / 8 | 0);
    if (!balanced) {
      limit$2 = limit$2 - 1 | 0;
    }
    const _bind$768 = pred$2;
    if (_bind$768 === undefined) {
    } else {
      const _Some = _bind$768;
      const _pred = _Some;
      if (cmp(_pred, moonbitlang$core$array$$Array$at$38$(arr, _actual_pivot_pos)) === 0) {
        let i = _actual_pivot_pos;
        while (true) {
          if (i < current_end && cmp(_pred, moonbitlang$core$array$$Array$at$38$(arr, i)) === 0) {
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
      moonbitlang$core$array$$Array$quick_sort_by$38$(arr, left_start, _actual_pivot_pos, cmp, pred$2, limit$2);
      pred$2 = moonbitlang$core$array$$Array$at$38$(arr, _actual_pivot_pos);
      current_start = right_start;
      current_end = right_end;
    } else {
      moonbitlang$core$array$$Array$quick_sort_by$38$(arr, right_start, right_end, cmp, moonbitlang$core$array$$Array$at$38$(arr, _actual_pivot_pos), limit$2);
      current_start = left_start;
      current_end = _actual_pivot_pos;
    }
    continue;
  }
}
function moonbitlang$core$array$$Array$sort_by_key$39$(self, map) {
  moonbitlang$core$array$$Array$quick_sort_by$37$(self, 0, self.length, (a, b) => $compare_int(map(a), map(b)), undefined, moonbitlang$core$array$$get_limit(self.length));
}
function moonbitlang$core$array$$Array$sort_by$38$(self, cmp) {
  moonbitlang$core$array$$Array$quick_sort_by$38$(self, 0, self.length, cmp, undefined, moonbitlang$core$array$$get_limit(self.length));
}
function moonbitlang$core$builtin$$Eq$equal$40$(_x_3923, _x_3924) {
  if (_x_3923 === 0) {
    if (_x_3924 === 0) {
      return true;
    } else {
      return false;
    }
  } else {
    if (_x_3924 === 1) {
      return true;
    } else {
      return false;
    }
  }
}
function moonbitlang$core$builtin$$StringBuilder$new$46$inner(size_hint) {
  return { val: "" };
}
function moonbitlang$core$builtin$$Logger$write_char$41$(self, ch) {
  const _bind$766 = self;
  _bind$766.val = `${_bind$766.val}${String.fromCodePoint(ch)}`;
}
function moonbitlang$core$builtin$$op_notequal$40$(x, y) {
  return !moonbitlang$core$builtin$$Eq$equal$40$(x, y);
}
function moonbitlang$core$builtin$$op_notequal$3$(x, y) {
  return !(x === y);
}
function moonbitlang$core$array$$Array$at$33$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$37$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
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
function moonbitlang$core$array$$Array$at$26$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$38$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$builtin$$Logger$write_string$41$(self, str) {
  const _bind$766 = self;
  _bind$766.val = `${_bind$766.val}${str}`;
}
function moonbitlang$core$builtin$$Hasher$combine$3$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$3$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$20$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$20$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$26$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$26$(value, self);
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
function moonbitlang$core$builtin$$Hash$hash$34$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$3$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$35$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$20$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$43$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$26$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Show$to_string$44$(self) {
  const logger = moonbitlang$core$builtin$$StringBuilder$new$46$inner(0);
  moonbitlang$core$builtin$$Show$output$10$(self, { self: logger, method_0: moonbitlang$core$builtin$$Logger$write_string$41$, method_1: moonbitlang$core$builtin$$Logger$write_substring$41$, method_2: moonbitlang$core$builtin$$Logger$write_char$41$ });
  return logger.val;
}
function moonbitlang$core$int$$Int$to_string$46$inner(self, radix) {
  return moonbitlang$core$builtin$$int_to_string_js(self, radix);
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
function moonbitlang$core$builtin$$Logger$write_substring$41$(self, str, start, len) {
  const _bind$766 = self;
  _bind$766.val = `${_bind$766.val}${moonbitlang$core$string$$String$substring$46$inner(str, start, start + len | 0)}`;
}
function moonbitlang$core$array$$Array$new$46$inner$7$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$new$46$inner$22$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$new$46$inner$45$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$push$37$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$46$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$47$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$48$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$49$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$18$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$38$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$22$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$50$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$7$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$31$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$33$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$51$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$42$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$45$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$builtin$$Iter$run$45$(self, f) {
  const _func = self;
  return _func(f);
}
function moonbitlang$core$builtin$$Iterator$next$20$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$3$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$52$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$53$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$54$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Iterator$next$55$(self) {
  const _func = self;
  return _func();
}
function moonbitlang$core$builtin$$Show$output$10$(self, logger) {
  logger.method_0(logger.self, moonbitlang$core$int$$Int$to_string$46$inner(self, 10));
}
function moonbitlang$core$array$$Array$iter$45$(self) {
  const _p$4517 = (yield_) => {
    const _len = self.length;
    let _tmp$2257 = 0;
    while (true) {
      const _i = _tmp$2257;
      if (_i < _len) {
        const v = self[_i];
        const _bind$766 = yield_(v);
        if (_bind$766 === 1) {
        } else {
          return 0;
        }
        _tmp$2257 = _i + 1 | 0;
        continue;
      } else {
        return 1;
      }
    }
  };
  return _p$4517;
}
function moonbitlang$core$option$$Option$unwrap$56$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$57$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$58$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$59$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap$60$(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap_or$23$(self, default_) {
  if (self.$tag === 0) {
    return default_;
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$unwrap_or_default$60$(self) {
  if (self.$tag === 0) {
    return [];
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function moonbitlang$core$option$$Option$map_or$61$(self, default_, f) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _x = _Some;
    return f(_x);
  }
}
function moonbitlang$core$option$$Option$map_or$62$(self, default_, f) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _x = _Some;
    return f(_x);
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
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$0$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$1$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$16$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$14$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$12$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$19$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$15$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$5$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$6$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$9$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$4$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$8$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$13$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$17$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$11$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$21$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$766 = capacity$2 - 1 | 0;
  const _bind$767 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$768 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$769 = undefined;
  return { entries: _bind$768, size: 0, capacity: capacity$2, capacity_mask: _bind$766, grow_at: _bind$767, head: _bind$769, tail: -1 };
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$2$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$0$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$1$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$16$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$4$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$5$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$6$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$12$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$15$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$9$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$14$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$13$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$11$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$19$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$21$(self, idx, entry) {
  const _bind$766 = self.tail;
  if (_bind$766 === -1) {
    self.head = entry;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    _tmp$2258.next = entry;
  }
  self.tail = idx;
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, idx);
  _tmp$2257[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$set_entry$2$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$0$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$1$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$16$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$12$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$4$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$5$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$6$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$15$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$9$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$14$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$13$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$11$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$19$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$21$(self, entry, new_idx) {
  const _tmp$2257 = self.entries;
  $bound_check(_tmp$2257, new_idx);
  _tmp$2257[new_idx] = entry;
  const _bind$766 = entry.next;
  if (_bind$766 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$766;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$push_away$2$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$2$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$2$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$0$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$0$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$0$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$1$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$1$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$1$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$16$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$16$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$16$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$4$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$4$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$4$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$5$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$5$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$5$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$6$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$6$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$6$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$12$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$12$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$12$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$15$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$15$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$15$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$9$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$9$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$9$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$14$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$14$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$14$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$13$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$13$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$13$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$11$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$11$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$11$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$19$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$19$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$19$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$21$(self, idx, entry) {
  let _tmp$2257 = entry.psl + 1 | 0;
  let _tmp$2258 = idx + 1 & self.capacity_mask;
  let _tmp$2259 = entry;
  while (true) {
    const psl = _tmp$2257;
    const idx$2 = _tmp$2258;
    const entry$2 = _tmp$2259;
    const _tmp$2260 = self.entries;
    $bound_check(_tmp$2260, idx$2);
    const _bind$766 = _tmp$2260[idx$2];
    if (_bind$766 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$21$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$766;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$21$(self, entry$2, idx$2);
        _tmp$2257 = _curr_entry.psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        _tmp$2259 = _curr_entry;
        continue;
      } else {
        _tmp$2257 = psl + 1 | 0;
        _tmp$2258 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$set_with_hash$2$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$2$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$2$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$2$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$0$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$0$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$0$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$0$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$1$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$1$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$1$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$1$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$16$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$16$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$16$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$16$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$4$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$4$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$4$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$4$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$5$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$5$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$5$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$5$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$6$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$6$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$6$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$6$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$12$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$12$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$12$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$12$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$15$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$15$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$15$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$15$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$9$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$9$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$9$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$9$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$14$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$14$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$14$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$14$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$13$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$13$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$13$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$13$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$11$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$11$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$11$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$11$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$19$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$19$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      let _tmp$2260;
      if (_curr_entry.hash === hash) {
        const _p$4517 = _curr_entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$19$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$19$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$21$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$21$(self);
  }
  let _bind$766;
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$767 = _tmp$2259[idx];
    if (_bind$767 === undefined) {
      _bind$766 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$767;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$21$(self, idx, _curr_entry);
        _bind$766 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2257 = psl + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$766._0;
  const _psl = _bind$766._1;
  const _bind$767 = self.tail;
  const _bind$768 = undefined;
  const entry = { prev: _bind$767, next: _bind$768, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$21$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$grow$2$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$19$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$19$(self, _key, _value, _hash);
      _tmp$2257 = _next;
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
  const _p$4517 = self.capacity;
  self.grow_at = (Math.imul(_p$4517, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2257 = old_head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$set$2$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$2$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$0$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$0$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$1$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$1$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$16$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$16$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$4$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$4$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$5$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$5$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$6$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$6$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$12$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$12$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$15$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$15$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$9$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$9$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$14$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$14$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$13$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$13$(self, key, value, moonbitlang$core$builtin$$Hash$hash$43$(key));
}
function moonbitlang$core$builtin$$Map$set$11$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$11$(self, key, value, moonbitlang$core$builtin$$Hash$hash$43$(key));
}
function moonbitlang$core$builtin$$Map$set$19$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$19$(self, key, value, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$builtin$$Map$set$21$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$21$(self, key, value, moonbitlang$core$builtin$$Hash$hash$43$(key));
}
function moonbitlang$core$builtin$$Map$from_array$13$(arr) {
  const length = arr.end - arr.start | 0;
  let capacity = moonbitlang$core$int$$Int$next_power_of_two(length);
  const _p$4517 = capacity;
  if (length > ((Math.imul(_p$4517, 13) | 0) / 16 | 0)) {
    capacity = Math.imul(capacity, 2) | 0;
  }
  const m = moonbitlang$core$builtin$$Map$new$46$inner$13$(capacity);
  const _len = arr.end - arr.start | 0;
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const e = arr.buf[arr.start + _i | 0];
      moonbitlang$core$builtin$$Map$set$13$(m, e._0, e._1);
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function moonbitlang$core$builtin$$Map$get$16$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$14$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$15$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$1$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return -1;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return -1;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$0$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$6$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$5$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$9$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$12$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$4$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$19$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return Option$None$8$;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return new Option$Some$8$(_entry.value);
      }
      if (i > _entry.psl) {
        return Option$None$8$;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$8$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$2$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$17$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$11$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$43$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return Option$None$9$;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return new Option$Some$9$(_entry.value);
      }
      if (i > _entry.psl) {
        return Option$None$9$;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$21$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$43$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return Option$None$10$;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return new Option$Some$10$(_entry.value);
      }
      if (i > _entry.psl) {
        return Option$None$10$;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$13$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$43$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$contains$17$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$34$(key);
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      return false;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$remove_entry$12$(self, entry) {
  const _bind$766 = entry.prev;
  if (_bind$766 === -1) {
    self.head = entry.next;
  } else {
    const _tmp$2257 = self.entries;
    $bound_check(_tmp$2257, _bind$766);
    const _p$4517 = _tmp$2257[_bind$766];
    let _tmp$2258;
    if (_p$4517 === undefined) {
      _tmp$2258 = $panic();
    } else {
      const _p$4518 = _p$4517;
      _tmp$2258 = _p$4518;
    }
    const _tmp$2259 = _tmp$2258;
    _tmp$2259.next = entry.next;
  }
  const _bind$767 = entry.next;
  if (_bind$767 === undefined) {
    self.tail = entry.prev;
    return;
  } else {
    const _Some = _bind$767;
    const _next = _Some;
    _next.prev = entry.prev;
    return;
  }
}
function moonbitlang$core$builtin$$Map$shift_back$12$(self, idx) {
  let _tmp$2257 = idx;
  while (true) {
    const idx$2 = _tmp$2257;
    const next = idx$2 + 1 & self.capacity_mask;
    _L: {
      const _tmp$2258 = self.entries;
      $bound_check(_tmp$2258, next);
      const _bind$766 = _tmp$2258[next];
      if (_bind$766 === undefined) {
        break _L;
      } else {
        const _Some = _bind$766;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          moonbitlang$core$builtin$$Map$set_entry$12$(self, _x, idx$2);
          _tmp$2257 = next;
          continue;
        }
      }
    }
    const _tmp$2258 = self.entries;
    $bound_check(_tmp$2258, idx$2);
    _tmp$2258[idx$2] = undefined;
    return;
  }
}
function moonbitlang$core$builtin$$Map$remove_with_hash$12$(self, key, hash) {
  let _tmp$2257 = 0;
  let _tmp$2258 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2257;
    const idx = _tmp$2258;
    const _tmp$2259 = self.entries;
    $bound_check(_tmp$2259, idx);
    const _bind$766 = _tmp$2259[idx];
    if (_bind$766 === undefined) {
      break;
    } else {
      const _Some = _bind$766;
      const _entry = _Some;
      let _tmp$2260;
      if (_entry.hash === hash) {
        const _p$4517 = _entry.key;
        _tmp$2260 = _p$4517 === key;
      } else {
        _tmp$2260 = false;
      }
      if (_tmp$2260) {
        moonbitlang$core$builtin$$Map$remove_entry$12$(self, _entry);
        moonbitlang$core$builtin$$Map$shift_back$12$(self, idx);
        self.size = self.size - 1 | 0;
        break;
      }
      if (i > _entry.psl) {
        break;
      }
      _tmp$2257 = i + 1 | 0;
      _tmp$2258 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$remove$12$(self, key) {
  moonbitlang$core$builtin$$Map$remove_with_hash$12$(self, key, moonbitlang$core$builtin$$Hash$hash$34$(key));
}
function moonbitlang$core$array$$FixedArray$fill$46$inner$63$(self, value, start, end) {
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
function moonbitlang$core$array$$FixedArray$fill$46$inner$36$(self, value, start, end) {
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
function moonbitlang$core$builtin$$Map$clear$19$(self) {
  moonbitlang$core$array$$FixedArray$fill$46$inner$63$(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function moonbitlang$core$builtin$$Map$iter$8$(self) {
  const _p$4517 = (yield_) => {
    let _tmp$2257 = self.head;
    while (true) {
      const _param = _tmp$2257;
      if (_param === undefined) {
        return 1;
      } else {
        const _Some = _param;
        const _x = _Some;
        const _key = _x.key;
        const _value = _x.value;
        const _next = _x.next;
        const _bind$766 = yield_({ _0: _key, _1: _value });
        if (_bind$766 === 1) {
          _tmp$2257 = _next;
          continue;
        } else {
          return 0;
        }
      }
    }
  };
  return _p$4517;
}
function moonbitlang$core$builtin$$Map$iterator$14$(self) {
  const curr_entry = { val: self.head };
  const _p$4517 = () => {
    const _bind$766 = curr_entry.val;
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _key = _x.key;
      const _value = _x.value;
      const _next = _x.next;
      curr_entry.val = _next;
      return { _0: _key, _1: _value };
    }
  };
  return _p$4517;
}
function moonbitlang$core$builtin$$Map$iterator$16$(self) {
  const curr_entry = { val: self.head };
  const _p$4517 = () => {
    const _bind$766 = curr_entry.val;
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _key = _x.key;
      const _value = _x.value;
      const _next = _x.next;
      curr_entry.val = _next;
      return { _0: _key, _1: _value };
    }
  };
  return _p$4517;
}
function moonbitlang$core$builtin$$Map$iterator$5$(self) {
  const curr_entry = { val: self.head };
  const _p$4517 = () => {
    const _bind$766 = curr_entry.val;
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _key = _x.key;
      const _value = _x.value;
      const _next = _x.next;
      curr_entry.val = _next;
      return { _0: _key, _1: _value };
    }
  };
  return _p$4517;
}
function moonbitlang$core$builtin$$Map$iterator$1$(self) {
  const curr_entry = { val: self.head };
  const _p$4517 = () => {
    const _bind$766 = curr_entry.val;
    if (_bind$766 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _key = _x.key;
      const _value = _x.value;
      const _next = _x.next;
      curr_entry.val = _next;
      return { _0: _key, _1: _value };
    }
  };
  return _p$4517;
}
function moonbitlang$core$builtin$$Map$iterator2$14$(self) {
  return moonbitlang$core$builtin$$Map$iterator$14$(self);
}
function moonbitlang$core$builtin$$Map$iterator2$16$(self) {
  return moonbitlang$core$builtin$$Map$iterator$16$(self);
}
function moonbitlang$core$builtin$$Map$iterator2$5$(self) {
  return moonbitlang$core$builtin$$Map$iterator$5$(self);
}
function moonbitlang$core$builtin$$Map$iterator2$1$(self) {
  return moonbitlang$core$builtin$$Map$iterator$1$(self);
}
function moonbitlang$core$builtin$$Map$to_array$4$(self) {
  const arr = new Array(self.size);
  let i = 0;
  let _tmp$2257 = self.head;
  while (true) {
    const _param = _tmp$2257;
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
      _tmp$2257 = _next;
      continue;
    }
  }
  return arr;
}
function moonbitlang$core$int64$$Int64$reinterpret_as_double(self) {
  return moonbitlang$core$builtin$$MyInt64$reinterpret_as_double(self);
}
function moonbitlang$core$builtin$$Iterator2$next$14$(self) {
  return moonbitlang$core$builtin$$Iterator$next$52$(self);
}
function moonbitlang$core$builtin$$Iterator2$next$16$(self) {
  return moonbitlang$core$builtin$$Iterator$next$53$(self);
}
function moonbitlang$core$builtin$$Iterator2$next$5$(self) {
  return moonbitlang$core$builtin$$Iterator$next$54$(self);
}
function moonbitlang$core$builtin$$Iterator2$next$1$(self) {
  return moonbitlang$core$builtin$$Iterator$next$55$(self);
}
function moonbitlang$core$builtin$$Iter$any$45$(self, f) {
  return moonbitlang$core$builtin$$op_notequal$40$(moonbitlang$core$builtin$$Iter$run$45$(self, (k) => f(k) ? 0 : 1), 1);
}
function moonbitlang$core$builtin$$Hasher$consume4(self, input) {
  const _p$4517 = (self.acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
  const _p$4518 = 17;
  self.acc = Math.imul(_p$4517 << _p$4518 | (_p$4517 >>> (32 - _p$4518 | 0) | 0), 668265263) | 0;
}
function moonbitlang$core$builtin$$Hasher$combine_uint(self, value) {
  self.acc = (self.acc >>> 0) + (4 >>> 0) | 0;
  moonbitlang$core$builtin$$Hasher$consume4(self, value);
}
function moonbitlang$core$builtin$$Hasher$combine_int(self, value) {
  moonbitlang$core$builtin$$Hasher$combine_uint(self, value);
}
function moonbitlang$core$builtin$$Hasher$combine_string(self, value) {
  const _end1247 = value.length;
  let _tmp$2257 = 0;
  while (true) {
    const i = _tmp$2257;
    if (i < _end1247) {
      moonbitlang$core$builtin$$Hasher$combine_uint(self, value.charCodeAt(i));
      _tmp$2257 = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$builtin$$Hash$hash_combine$26$(self, hasher) {
  moonbitlang$core$builtin$$Hasher$combine_string(hasher, self);
}
function moonbitlang$core$builtin$$Hash$hash_combine$64$(self, hasher) {
  moonbitlang$core$builtin$$Hasher$combine_uint(hasher, self);
}
function moonbitlang$core$double$$Double$to_int(self) {
  return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
}
function moonbitlang$core$builtin$$println$26$(input) {
  console.log(input);
}
function moonbitlang$core$array$$ArrayView$at$18$(self, index) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp$2257 = self.buf;
    const _tmp$2258 = self.start + index | 0;
    $bound_check(_tmp$2257, _tmp$2258);
    return _tmp$2257[_tmp$2258];
  } else {
    return moonbitlang$core$abort$$abort$18$(`index out of bounds: the len is from 0 to ${moonbitlang$core$builtin$$Show$to_string$44$(self.end - self.start | 0)} but the index is ${moonbitlang$core$builtin$$Show$to_string$44$(index)}`);
  }
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$7$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$22$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$get$31$(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : undefined;
}
function moonbitlang$core$array$$Array$set$37$(self, index, value) {
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
function moonbitlang$core$array$$Array$set$38$(self, index, value) {
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
function moonbitlang$core$array$$Array$clear$7$(self) {
  moonbitlang$core$array$$Array$unsafe_truncate_to_length$7$(self, 0);
}
function moonbitlang$core$array$$Array$contains$65$(self, value) {
  const _len = self.length;
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const v = self[_i];
      if (v === value) {
        return true;
      }
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      return false;
    }
  }
}
function moonbitlang$core$ref$$Ref$new$66$(x) {
  return { val: x };
}
function moonbitlang$core$ref$$Ref$new$23$(x) {
  return { val: x };
}
function moonbitlang$core$ref$$Ref$new$18$(x) {
  return { val: x };
}
function moonbitlang$core$ref$$Ref$new$10$(x) {
  return { val: x };
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
  return moonbitlang$core$builtin$$Mul$mul$67$(Milky2018$selene$math$$Transform$from_translation(width, 0), Milky2018$selene$math$$Transform$from_scale(-1, 1));
}
function moonbitlang$core$builtin$$Mul$mul$67$(self, other) {
  return Milky2018$selene$math$$Transform$multiply(self, other);
}
function Milky2018$selene$math$$Rect$intersects(a, b) {
  return Milky2018$selene$math$$Vec2D$op_get(a.position, 0) < Milky2018$selene$math$$Vec2D$op_get(b.position, 0) + Milky2018$selene$math$$Vec2D$op_get(b.size, 0) && (Milky2018$selene$math$$Vec2D$op_get(a.position, 0) + Milky2018$selene$math$$Vec2D$op_get(a.size, 0) > Milky2018$selene$math$$Vec2D$op_get(b.position, 0) && (Milky2018$selene$math$$Vec2D$op_get(a.position, 1) < Milky2018$selene$math$$Vec2D$op_get(b.position, 1) + Milky2018$selene$math$$Vec2D$op_get(b.size, 1) && Milky2018$selene$math$$Vec2D$op_get(a.position, 1) + Milky2018$selene$math$$Vec2D$op_get(a.size, 1) > Milky2018$selene$math$$Vec2D$op_get(b.position, 1)));
}
function Milky2018$selene$math$$Rect$shift(self, dir) {
  const _p$4517 = self.position;
  const _tmp$2257 = { _0: _p$4517._0 + dir._0, _1: _p$4517._1 + dir._1 };
  return { position: _tmp$2257, size: self.size };
}
function moonbitlang$core$builtin$$Eq$equal$68$(_x_37, _x_38) {
  switch (_x_37) {
    case 0: {
      if (_x_38 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_38 === 1) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_38 === 2) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function moonbitlang$core$builtin$$Eq$equal$20$(_x_29, _x_30) {
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
function moonbitlang$core$builtin$$Hash$hash_combine$20$(_x_21, _x_22) {
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
      return Milky2018$selene$inputs$$from_string$46$constr$47$2174;
    }
    case "KeyB": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2175;
    }
    case "KeyC": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2176;
    }
    case "KeyD": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2177;
    }
    case "KeyE": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2178;
    }
    case "KeyF": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2179;
    }
    case "KeyG": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2180;
    }
    case "KeyH": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2181;
    }
    case "KeyI": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2182;
    }
    case "KeyJ": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2183;
    }
    case "KeyK": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2184;
    }
    case "KeyL": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2185;
    }
    case "KeyM": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2186;
    }
    case "KeyN": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2187;
    }
    case "KeyO": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2188;
    }
    case "KeyP": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2189;
    }
    case "KeyQ": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2190;
    }
    case "KeyR": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2191;
    }
    case "KeyS": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2192;
    }
    case "KeyT": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2193;
    }
    case "KeyU": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2194;
    }
    case "KeyV": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2195;
    }
    case "KeyW": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2196;
    }
    case "KeyX": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2197;
    }
    case "KeyY": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2198;
    }
    case "ArrowUp": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2199;
    }
    case "ArrowDown": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2200;
    }
    case "ArrowLeft": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2201;
    }
    case "ArrowRight": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2202;
    }
    case "Space": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2203;
    }
    case "Enter": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2204;
    }
    case "Escape": {
      return Milky2018$selene$inputs$$from_string$46$constr$47$2205;
    }
    default: {
      return undefined;
    }
  }
}
function Milky2018$selene$inputs$$is_pressed(code) {
  return moonbitlang$core$set$$Set$contains$20$(Milky2018$selene$inputs$$pressed_keys, code);
}
function Milky2018$selene$inputs$$advanced_key_system(_delta) {
  moonbitlang$core$set$$Set$clear$20$(Milky2018$selene$inputs$$just_pressed_keys);
  const _it = moonbitlang$core$set$$Set$iterator$20$(moonbitlang$core$set$$Set$difference$20$(Milky2018$selene$inputs$$pressed_keys, Milky2018$selene$inputs$$last_pressed_keys));
  while (true) {
    const _bind$766 = moonbitlang$core$builtin$$Iterator$next$20$(_it);
    if (_bind$766 === undefined) {
      break;
    } else {
      const _Some = _bind$766;
      const _code = _Some;
      moonbitlang$core$set$$Set$add$20$(Milky2018$selene$inputs$$just_pressed_keys, _code);
      continue;
    }
  }
  moonbitlang$core$set$$Set$clear$20$(Milky2018$selene$inputs$$just_release_keys);
  const _it$2 = moonbitlang$core$set$$Set$iterator$20$(moonbitlang$core$set$$Set$union$20$(moonbitlang$core$set$$Set$difference$20$(Milky2018$selene$inputs$$all_codes, Milky2018$selene$inputs$$pressed_keys), Milky2018$selene$inputs$$last_pressed_keys));
  while (true) {
    const _bind$766 = moonbitlang$core$builtin$$Iterator$next$20$(_it$2);
    if (_bind$766 === undefined) {
      break;
    } else {
      const _Some = _bind$766;
      const _code = _Some;
      moonbitlang$core$set$$Set$add$20$(Milky2018$selene$inputs$$just_release_keys, _code);
      continue;
    }
  }
  moonbitlang$core$set$$Set$clear$20$(Milky2018$selene$inputs$$last_pressed_keys);
  const _it$3 = moonbitlang$core$set$$Set$iterator$20$(Milky2018$selene$inputs$$pressed_keys);
  while (true) {
    const _bind$766 = moonbitlang$core$builtin$$Iterator$next$20$(_it$3);
    if (_bind$766 === undefined) {
      return;
    } else {
      const _Some = _bind$766;
      const _code = _Some;
      moonbitlang$core$set$$Set$add$20$(Milky2018$selene$inputs$$last_pressed_keys, _code);
      continue;
    }
  }
}
function Milky2018$selene$inputs$$is_just_pressed(code) {
  return moonbitlang$core$set$$Set$contains$20$(Milky2018$selene$inputs$$just_pressed_keys, code);
}
function rami3l$js$45$ffi$js$$Union3$from0$69$(value) {
  return value;
}
function rami3l$js$45$ffi$js$$Union3$from2$69$(value) {
  return value;
}
function rami3l$js$45$ffi$js$$Union5$to0$70$(self) {
  return rami3l$js$45$ffi$js$$Cast$into$59$(self);
}
function rami3l$js$45$ffi$js$$Union7$from0$71$(value) {
  return rami3l$js$45$ffi$js$$Cast$from$72$(value);
}
function rami3l$js$45$ffi$js$$Optional$undefined$23$() {
  return rami3l$js$45$ffi$js$$Value$undefined();
}
function rami3l$js$45$ffi$js$$Nullable$is_null$73$(self) {
  return rami3l$js$45$ffi$js$$Value$is_null(self);
}
function rami3l$js$45$ffi$js$$Nullable$unwrap$73$(self) {
  if (rami3l$js$45$ffi$js$$Nullable$is_null$73$(self)) {
    moonbitlang$core$abort$$abort$24$("Cannot unwrap a null value");
  }
  return self;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$56$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$11$(self) : Option$None$11$;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$57$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$12$(self) : Option$None$12$;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$58$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$13$(self) : Option$None$13$;
}
function rami3l$js$45$ffi$js$$Nullable$to_option$59$(self) {
  return !rami3l$js$45$ffi$js$$Value$is_null(self) ? new Option$Some$14$(self) : Option$None$14$;
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_button$74$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_button(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_x$74$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_movement_x(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_y$74$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_movement_y(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_x$74$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_offset_x(s);
}
function Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_y$74$(s) {
  return Yoorkin$rabbit$45$tea$dom$$ffi_mouse_event_offset_y(s);
}
function rami3l$js$45$ffi$js$$Cast$from$72$(value) {
  return value;
}
function Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$75$(s, type_, callback) {
  Yoorkin$rabbit$45$tea$dom$$ffi_add_event_listener(s, type_, callback);
}
function Yoorkin$rabbit$45$tea$dom$$IsEventTarget$to_html_canvas_element$76$(s) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$58$(Yoorkin$rabbit$45$tea$dom$$ffi_to_html_canvas_element(s));
}
function Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$77$(s) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$57$(Yoorkin$rabbit$45$tea$dom$$ffi_to_mouse_event(s));
}
function Yoorkin$rabbit$45$tea$dom$$IsEvent$to_keyboard_event$77$(s) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$56$(Yoorkin$rabbit$45$tea$dom$$ffi_to_keyboard_event(s));
}
function rami3l$js$45$ffi$js$$Cast$into$59$(value) {
  return rami3l$js$45$ffi$js$$Nullable$to_option$59$(Yoorkin$rabbit$45$tea$dom$$checked_to_canvas_rendering_context_2d(value));
}
function Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text(self, text, x, y, max_width$46$opt) {
  let max_width;
  if (max_width$46$opt.$tag === 1) {
    const _Some = max_width$46$opt;
    max_width = _Some._0;
  } else {
    max_width = rami3l$js$45$ffi$js$$Optional$undefined$23$();
  }
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text$46$inner(self, text, x, y, max_width);
}
function Milky2018$selene$backend$$CanvasBackend$new() {
  const canvas = moonbitlang$core$option$$Option$unwrap$58$(Yoorkin$rabbit$45$tea$dom$$IsEventTarget$to_html_canvas_element$76$(rami3l$js$45$ffi$js$$Nullable$unwrap$73$(Yoorkin$rabbit$45$tea$dom$$Document$get_element_by_id(Yoorkin$rabbit$45$tea$dom$$document(), "canvas"))));
  const context = moonbitlang$core$option$$Option$unwrap$59$(rami3l$js$45$ffi$js$$Union5$to0$70$(Yoorkin$rabbit$45$tea$dom$$HTMLCanvasElement$get_context(canvas, "2d")));
  const _bind$766 = { _0: 0, _1: 0 };
  const _bind$767 = moonbitlang$core$ref$$Ref$new$66$(undefined);
  return { canvas: canvas, context: context, viewport_size: _bind$766, zoom: 1, time_scale: 1, mouse_movement: _bind$767 };
}
function Milky2018$selene$backend$$register_mouse_events(mouse, mouse_movement) {
  Milky2018$selene$backend$$canvas_backend.mouse_movement.val = mouse_movement;
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$75$(Milky2018$selene$backend$$window, "mousemove", (event) => {
    const mouse_event = moonbitlang$core$option$$Option$unwrap$57$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$77$(event));
    mouse.pos = { _0: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_x$74$(mouse_event) + 0, _1: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_offset_y$74$(mouse_event) + 0 };
    mouse_movement.movement = { _0: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_x$74$(mouse_event) + 0, _1: Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_movement_y$74$(mouse_event) + 0 };
  });
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$75$(Milky2018$selene$backend$$window, "mousedown", (event) => {
    const mouse_event = moonbitlang$core$option$$Option$unwrap$57$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$77$(event));
    const _bind$766 = Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_button$74$(mouse_event);
    switch (_bind$766) {
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
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$75$(Milky2018$selene$backend$$window, "mouseup", (event) => {
    const mouse_event = moonbitlang$core$option$$Option$unwrap$57$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_mouse_event$77$(event));
    const _bind$766 = Yoorkin$rabbit$45$tea$dom$$IsMouseEvent$get_button$74$(mouse_event);
    switch (_bind$766) {
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
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$75$(Milky2018$selene$backend$$window, "keyup", (event) => {
    const keyboard_event = moonbitlang$core$option$$Option$unwrap$56$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_keyboard_event$77$(event));
    const keycode = Milky2018$selene$inputs$$Code$from_string(Yoorkin$rabbit$45$tea$dom$$KeyboardEvent$code(keyboard_event));
    if (keycode === undefined) {
      return;
    } else {
      const _Some = keycode;
      const _c = _Some;
      moonbitlang$core$set$$Set$remove$20$(pressed_keys, _c);
      return;
    }
  });
  Yoorkin$rabbit$45$tea$dom$$IsEventTarget$add_event_listener$75$(Milky2018$selene$backend$$window, "keydown", (event) => {
    const keyboard_event = moonbitlang$core$option$$Option$unwrap$56$(Yoorkin$rabbit$45$tea$dom$$IsEvent$to_keyboard_event$77$(event));
    const keycode = Milky2018$selene$inputs$$Code$from_string(Yoorkin$rabbit$45$tea$dom$$KeyboardEvent$code(keyboard_event));
    if (keycode === undefined) {
      return;
    } else {
      const _Some = keycode;
      const _c = _Some;
      moonbitlang$core$set$$Set$add$20$(pressed_keys, _c);
      return;
    }
  });
}
function Milky2018$selene$backend$$get_image_element(png) {
  const _bind$766 = moonbitlang$core$builtin$$Map$get$21$(Milky2018$selene$backend$$element_cache, png);
  if (_bind$766.$tag === 1) {
    const _Some = _bind$766;
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
  const pattern = Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$create_pattern(context, rami3l$js$45$ffi$js$$Union7$from0$71$(element), repeat_mode);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from2$69$(pattern));
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
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from0$69$(color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_text(context, text, x, y, Option$None$15$);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore(context);
}
function Milky2018$selene$backend$$draw_color_rect(x, y, width, height, color, stroke_color) {
  const context = Milky2018$selene$backend$$canvas_backend.context;
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$save(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_stroke_style(context, rami3l$js$45$ffi$js$$Union3$from0$69$(stroke_color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$stroke_rect(context, x, y, width, height);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from0$69$(color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill_rect(context, x, y, width, height);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$restore(context);
}
function Milky2018$selene$backend$$draw_color_circle(x, y, radius, color, stroke_color) {
  const context = Milky2018$selene$backend$$canvas_backend.context;
  Milky2018$selene$backend$$begin_path(context);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$arc$46$inner(context, x, y, radius, 0, 6.28318530717958623, false);
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_fill_style(context, rami3l$js$45$ffi$js$$Union3$from0$69$(color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$fill$46$inner(context, "nonzero");
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$set_stroke_style(context, rami3l$js$45$ffi$js$$Union3$from0$69$(stroke_color));
  Yoorkin$rabbit$45$tea$dom$$CanvasRenderingContext2D$stroke(context);
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
    moonbitlang$core$builtin$$println$26$("Warning: FPS is set above 60. The browser's window only support up to 60 FPS.");
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
    const _bind$766 = Milky2018$selene$backend$$canvas_backend.mouse_movement.val;
    if (_bind$766 === undefined) {
      return;
    } else {
      const _Some = _bind$766;
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
function Milky2018$selene$backend$$get_audio(path) {
  const _bind$766 = moonbitlang$core$builtin$$Map$get$11$(Milky2018$selene$backend$$audio_cache, path);
  if (_bind$766.$tag === 1) {
    const _Some = _bind$766;
    const _audio = _Some._0;
    return _audio;
  }
  const audio = Milky2018$selene$backend$$Audio$new(path);
  moonbitlang$core$builtin$$Map$set$11$(Milky2018$selene$backend$$audio_cache, path, audio);
  return audio;
}
function Milky2018$selene$backend$$play_audio(audio_path, volume, loop_) {
  const audio = Milky2018$selene$backend$$get_audio(audio_path);
  Milky2018$selene$backend$$Audio$set_volume(audio, volume);
  Milky2018$selene$backend$$Audio$set_loop(audio, loop_);
  Milky2018$selene$backend$$Audio$play(audio);
}
function Milky2018$selene$audio$$play_audio$46$inner(audio_path, volume, loop_) {
  Milky2018$selene$backend$$play_audio(audio_path, volume, loop_);
}
function Milky2018$selene$system$$timer_system(delta) {
  const _p$4517 = [];
  const _p$4518 = Milky2018$selene$system$$timers.length;
  let _tmp$2257 = 0;
  while (true) {
    const _p$4519 = _tmp$2257;
    if (_p$4519 < _p$4518) {
      const _p$4520 = Milky2018$selene$system$$timers[_p$4519];
      if (_p$4520.pausible) {
        moonbitlang$core$array$$Array$push$22$(_p$4517, _p$4520);
      }
      _tmp$2257 = _p$4519 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _arr = _p$4517;
  const _len = _arr.length;
  let _tmp$2258 = 0;
  while (true) {
    const _i = _tmp$2258;
    if (_i < _len) {
      const timer = _arr[_i];
      timer.rest = timer.rest - delta;
      if (timer.rest <= 0) {
        const _func = timer.callback;
        _func();
      }
      _tmp$2258 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$4519 = Milky2018$selene$system$$timers.length;
  let _tmp$2259 = 0;
  let _tmp$2260 = 0;
  while (true) {
    const _p$4520 = _tmp$2259;
    const _p$4521 = _tmp$2260;
    if (_p$4520 < _p$4519) {
      const _p$4522 = Milky2018$selene$system$$timers[_p$4520];
      if (_p$4522.rest > 0) {
        Milky2018$selene$system$$timers[_p$4521] = _p$4522;
        _tmp$2259 = _p$4520 + 1 | 0;
        _tmp$2260 = _p$4521 + 1 | 0;
        continue;
      }
      _tmp$2259 = _p$4520 + 1 | 0;
      continue;
    } else {
      moonbitlang$core$array$$Array$unsafe_truncate_to_length$22$(Milky2018$selene$system$$timers, _p$4521);
      return;
    }
  }
}
function Milky2018$selene$system$$realtime_timer_system(_delta) {
  const _p$4517 = [];
  const _p$4518 = Milky2018$selene$system$$timers.length;
  let _tmp$2257 = 0;
  while (true) {
    const _p$4519 = _tmp$2257;
    if (_p$4519 < _p$4518) {
      const _p$4520 = Milky2018$selene$system$$timers[_p$4519];
      if (!_p$4520.pausible) {
        moonbitlang$core$array$$Array$push$22$(_p$4517, _p$4520);
      }
      _tmp$2257 = _p$4519 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _arr = _p$4517;
  const _len = _arr.length;
  let _tmp$2258 = 0;
  while (true) {
    const _i = _tmp$2258;
    if (_i < _len) {
      const timer = _arr[_i];
      const realtime_delta = Milky2018$selene$backend$$realtime_delta.val;
      timer.rest = timer.rest - realtime_delta;
      if (timer.rest <= 0) {
        const _func = timer.callback;
        _func();
      }
      _tmp$2258 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$4519 = Milky2018$selene$system$$timers.length;
  let _tmp$2259 = 0;
  let _tmp$2260 = 0;
  while (true) {
    const _p$4520 = _tmp$2259;
    const _p$4521 = _tmp$2260;
    if (_p$4520 < _p$4519) {
      const _p$4522 = Milky2018$selene$system$$timers[_p$4520];
      if (_p$4522.rest > 0) {
        Milky2018$selene$system$$timers[_p$4521] = _p$4522;
        _tmp$2259 = _p$4520 + 1 | 0;
        _tmp$2260 = _p$4521 + 1 | 0;
        continue;
      }
      _tmp$2259 = _p$4520 + 1 | 0;
      continue;
    } else {
      moonbitlang$core$array$$Array$unsafe_truncate_to_length$22$(Milky2018$selene$system$$timers, _p$4521);
      return;
    }
  }
}
function Milky2018$selene$system$$deferred_event_system(_delta) {
  const _len = Milky2018$selene$system$$deferred_events.length;
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const event = Milky2018$selene$system$$deferred_events[_i];
      event();
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$Array$clear$7$(Milky2018$selene$system$$deferred_events);
}
function Milky2018$selene$system$$defer_event(event) {
  moonbitlang$core$array$$Array$push$7$(Milky2018$selene$system$$deferred_events, event);
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
  moonbitlang$core$array$$Array$push$48$(plugins, plugin);
  return { ...self, plugins: plugins };
}
function Milky2018$selene$system$$App$add_system$46$inner(self, system, schedule, system_name) {
  const _p$4517 = `unnamed_system${moonbitlang$core$builtin$$Show$to_string$44$(self.systems.length)}`;
  let system_name$2;
  if (system_name === undefined) {
    system_name$2 = _p$4517;
  } else {
    const _p$4518 = system_name;
    system_name$2 = _p$4518;
  }
  const systems = self.systems;
  moonbitlang$core$array$$Array$push$47$(systems, { _0: system, _1: schedule, _2: system_name$2 });
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
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const plugin = _arr[_i];
      plugin(self);
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const startup = () => {
    const _arr$2 = self.systems;
    const _len$2 = _arr$2.length;
    let _tmp$2258 = 0;
    while (true) {
      const _i = _tmp$2258;
      if (_i < _len$2) {
        const system = _arr$2[_i];
        const _bind$766 = system._1;
        if (_bind$766.$tag === 0) {
          const _func = system._0;
          _func(0);
        }
        _tmp$2258 = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  };
  const renders = [];
  const _arr$2 = self.systems;
  const _len$2 = _arr$2.length;
  let _tmp$2258 = 0;
  while (true) {
    const _i = _tmp$2258;
    if (_i < _len$2) {
      const system = _arr$2[_i];
      const _bind$766 = system._1;
      if (_bind$766.$tag === 2) {
        const _Render = _bind$766;
        const _pri = _Render._0;
        moonbitlang$core$array$$Array$push$37$(renders, { _0: system._0, _1: _pri });
      }
      _tmp$2258 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$Array$sort_by_key$39$(renders, (system) => -system._1 | 0);
  const render_loop = (delta) => {
    const _len$3 = renders.length;
    let _tmp$2259 = 0;
    while (true) {
      const _i = _tmp$2259;
      if (_i < _len$3) {
        const render = renders[_i];
        const _func = render._0;
        _func(delta);
        _tmp$2259 = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  };
  const game_loops = [];
  const _arr$3 = self.systems;
  const _len$3 = _arr$3.length;
  let _tmp$2259 = 0;
  while (true) {
    const _i = _tmp$2259;
    if (_i < _len$3) {
      const system = _arr$3[_i];
      const _bind$766 = system._1;
      if (_bind$766.$tag === 1) {
        moonbitlang$core$array$$Array$push$46$(game_loops, system._0);
      }
      _tmp$2259 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const game_loop = (delta) => {
    const _len$4 = game_loops.length;
    let _tmp$2260 = 0;
    while (true) {
      const _i = _tmp$2260;
      if (_i < _len$4) {
        const system = game_loops[_i];
        system(delta);
        _tmp$2260 = _i + 1 | 0;
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
  moonbitlang$core$builtin$$Hash$hash_combine$64$(_x_29, _x_30);
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
  const _bind$766 = moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$entity$$parents, e);
  if (_bind$766 === undefined) {
    return;
  } else {
    const _Some = _bind$766;
    const _p$4517 = _Some;
    const _arr = _p$4517.children;
    const _len = _arr.length;
    let _tmp$2257 = 0;
    while (true) {
      const _i = _tmp$2257;
      if (_i < _len) {
        const c = _arr[_i];
        Milky2018$selene$entity$$Entity$destroy(c);
        _tmp$2257 = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function Milky2018$selene$entity$$Entity$get_children(parent) {
  return moonbitlang$core$option$$Option$map_or$62$(moonbitlang$core$builtin$$Map$get$8$(Milky2018$selene$entity$$parents, parent), [], (p) => p.children);
}
function Milky2018$selene$entity$$Entity$is_child(entity) {
  return moonbitlang$core$builtin$$Map$contains$17$(Milky2018$selene$entity$$children, entity);
}
function Milky2018$selene$entity$$Entity$set_offset(child, offset) {
  const _p$4517 = moonbitlang$core$builtin$$Map$get$17$(Milky2018$selene$entity$$children, child);
  let _tmp$2257;
  if (_p$4517 === undefined) {
    _tmp$2257 = $panic();
  } else {
    const _p$4518 = _p$4517;
    _tmp$2257 = _p$4518;
  }
  _tmp$2257.offset = offset;
}
function Milky2018$selene$entity$$get_roots() {
  const _bind$766 = moonbitlang$core$builtin$$Map$iter$8$(Milky2018$selene$entity$$parents);
  return (_p$4517) => _bind$766((_p$4518) => _p$4518._1.is_root && Milky2018$selene$entity$$Entity$is_alive(_p$4518._0) ? _p$4517(_p$4518._0) : 1);
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
  const _bind$766 = Milky2018$selene$camera$$camera.attached_entity;
  if (_bind$766 === undefined) {
    return;
  } else {
    const _Some = _bind$766;
    const _e = _Some;
    const _bind$767 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
    if (_bind$767 === undefined) {
      return;
    } else {
      const _Some$2 = _bind$767;
      const _pos = _Some$2;
      const zoom = Milky2018$selene$backend$$canvas_backend.zoom;
      const _p$4517 = Milky2018$selene$backend$$canvas_backend.viewport_size;
      const _p$4518 = { _0: 1 / zoom, _1: 1 / zoom };
      const viewport_size = { _0: _p$4517._0 * _p$4518._0, _1: _p$4517._1 * _p$4518._1 };
      const _p$4519 = { _0: 0.5, _1: 0.5 };
      const _p$4520 = { _0: viewport_size._0 * _p$4519._0, _1: viewport_size._1 * _p$4519._1 };
      const _p$4521 = { _0: _pos._0 - _p$4520._0, _1: _pos._1 - _p$4520._1 };
      const _p$4522 = Milky2018$selene$camera$$camera.offset;
      const target_position = { _0: _p$4521._0 + _p$4522._0, _1: _p$4521._1 + _p$4522._1 };
      const new_x = Milky2018$selene$camera$$camera.follow_x ? Milky2018$selene$math$$Vec2D$op_get(target_position, 0) : Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 0);
      const new_y = Milky2018$selene$camera$$camera.follow_y ? Milky2018$selene$math$$Vec2D$op_get(target_position, 1) : Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 1);
      Milky2018$selene$camera$$camera.position = { _0: new_x, _1: new_y };
      const _bind$768 = Milky2018$selene$camera$$camera.limit_top;
      if (_bind$768.$tag === 1) {
        const _Some$3 = _bind$768;
        const _top = _Some$3._0;
        if (Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 1) < _top) {
          Milky2018$selene$camera$$camera.position = { _0: Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 0), _1: _top };
        }
      }
      const _bind$769 = Milky2018$selene$camera$$camera.limit_bottom;
      if (_bind$769.$tag === 1) {
        const _Some$3 = _bind$769;
        const _bottom = _Some$3._0;
        if (Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 1) > _bottom - Milky2018$selene$math$$Vec2D$op_get(viewport_size, 1)) {
          Milky2018$selene$camera$$camera.position = { _0: Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 0), _1: _bottom - Milky2018$selene$math$$Vec2D$op_get(viewport_size, 1) };
        }
      }
      const _bind$770 = Milky2018$selene$camera$$camera.limit_left;
      if (_bind$770.$tag === 1) {
        const _Some$3 = _bind$770;
        const _left = _Some$3._0;
        if (Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 0) < _left) {
          Milky2018$selene$camera$$camera.position = { _0: _left, _1: Milky2018$selene$math$$Vec2D$op_get(Milky2018$selene$camera$$camera.position, 1) };
        }
      }
      const _bind$771 = Milky2018$selene$camera$$camera.limit_right;
      if (_bind$771.$tag === 1) {
        const _Some$3 = _bind$771;
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
  const _bind$766 = moonbitlang$core$set$$Set$new$46$inner$3$(8);
  const _bind$767 = [];
  const _bind$768 = { position: position, size: size };
  return { position: position, size: size, children: _bind$767, depth: depth, bounding_box: _bind$768, entities: _bind$766 };
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
  const _p$4517 = self.children;
  if (_p$4517.length === 0) {
    const half_size = { _0: Milky2018$selene$math$$Vec2D$op_get(self.size, 0) * 0.5, _1: Milky2018$selene$math$$Vec2D$op_get(self.size, 1) * 0.5 };
    const _self = self.children;
    moonbitlang$core$array$$Array$push$18$(_self, Milky2018$selene$collision$$QuadTree$new(self.position, half_size, self.depth + 1 | 0));
    const _p$4518 = self.position;
    const _p$4519 = { _0: Milky2018$selene$math$$Vec2D$op_get(half_size, 0), _1: 0 };
    moonbitlang$core$array$$Array$push$18$(_self, Milky2018$selene$collision$$QuadTree$new({ _0: _p$4518._0 + _p$4519._0, _1: _p$4518._1 + _p$4519._1 }, half_size, self.depth + 1 | 0));
    const _p$4520 = self.position;
    const _p$4521 = { _0: 0, _1: Milky2018$selene$math$$Vec2D$op_get(half_size, 1) };
    moonbitlang$core$array$$Array$push$18$(_self, Milky2018$selene$collision$$QuadTree$new({ _0: _p$4520._0 + _p$4521._0, _1: _p$4520._1 + _p$4521._1 }, half_size, self.depth + 1 | 0));
    const _p$4522 = self.position;
    moonbitlang$core$array$$Array$push$18$(_self, Milky2018$selene$collision$$QuadTree$new({ _0: _p$4522._0 + half_size._0, _1: _p$4522._1 + half_size._1 }, half_size, self.depth + 1 | 0));
  }
  const _arr = self.children;
  const _len = _arr.length;
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const child = _arr[_i];
      Milky2018$selene$collision$$QuadTree$insert(child, entity, box);
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$collision$$quadtree_query(area) {
  const _bind$766 = [Milky2018$selene$collision$$quadtree_root.val];
  const trees = { val: moonbitlang$core$list$$List$from_array$18$({ buf: _bind$766, start: 0, end: 1 }) };
  let results = moonbitlang$core$set$$Set$new$46$inner$3$(8);
  while (true) {
    const _bind$767 = trees.val;
    if (_bind$767.$tag === 1) {
      const _More = _bind$767;
      const _hd = _More._0;
      const _rest = _More._1;
      trees.val = _rest;
      if (!Milky2018$selene$math$$Rect$intersects(_hd.bounding_box, area)) {
        continue;
      }
      const _bind$768 = _hd.children;
      if (_bind$768.length === 0) {
        results = moonbitlang$core$set$$Set$union$3$(results, _hd.entities);
      } else {
        const _p$4517 = _hd.children;
        const _p$4518 = _p$4517.length;
        let _tmp$2257 = 0;
        while (true) {
          const _p$4519 = _tmp$2257;
          if (_p$4519 < _p$4518) {
            const _p$4520 = _p$4517[_p$4519];
            const _p$4521 = trees.val;
            trees.val = new $64$moonbitlang$47$core$47$list$46$List$More$7$(_p$4520, _p$4521);
            _tmp$2257 = _p$4519 + 1 | 0;
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
    const _bind$766 = moonbitlang$core$builtin$$Iterator2$next$5$(_it);
    if (_bind$766 === undefined) {
      break;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _e = _x._0;
      const _shape = _x._1;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        const _bind$767 = moonbitlang$core$builtin$$Map$get$1$(Milky2018$selene$ui$$uis, _e);
        if (_bind$767 === -1) {
          const _bind$768 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
          if (_bind$768 === undefined) {
            continue;
          } else {
            const _Some$2 = _bind$768;
            const _position = _Some$2;
            const _Rect = _shape;
            const _x$2 = _Rect._0;
            const _width = _x$2._0;
            const _height = _x$2._1;
            const _offset = _Rect._1;
            const _bind$769 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
            const _bind$770 = { _0: _width, _1: _height };
            const box = { position: _bind$769, size: _bind$770 };
            moonbitlang$core$array$$Array$push$49$(boxes, { _0: _e, _1: box });
            const _p$4517 = left_limit;
            const _p$4518 = Milky2018$selene$math$$Vec2D$op_get(_bind$769, 0);
            left_limit = _p$4517 > _p$4518 ? _p$4518 : _p$4517;
            const _p$4519 = right_limit;
            const _p$4520 = Milky2018$selene$math$$Vec2D$op_get(_bind$769, 0) + Milky2018$selene$math$$Vec2D$op_get(_bind$770, 0);
            right_limit = _p$4519 > _p$4520 ? _p$4519 : _p$4520;
            const _p$4521 = top_limit;
            const _p$4522 = Milky2018$selene$math$$Vec2D$op_get(_bind$769, 1);
            top_limit = _p$4521 > _p$4522 ? _p$4522 : _p$4521;
            const _p$4523 = bottom_limit;
            const _p$4524 = Milky2018$selene$math$$Vec2D$op_get(_bind$769, 1) + Milky2018$selene$math$$Vec2D$op_get(_bind$770, 1);
            bottom_limit = _p$4523 > _p$4524 ? _p$4523 : _p$4524;
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
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const box = boxes[_i];
      Milky2018$selene$collision$$QuadTree$insert(Milky2018$selene$collision$$quadtree_root.val, box._0, box._1);
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$collision$$Pickable$new() {
  return { on_pressed_callbacks: [], on_released_callbacks: [], on_just_pressed_callbacks: [], on_just_released_callbacks: [] };
}
function Milky2018$selene$collision$$Pickable$on_just_released(self, callback) {
  moonbitlang$core$array$$Array$push$50$(self.on_just_released_callbacks, callback);
}
function Milky2018$selene$collision$$pickable_click_system(_delta) {
  const zoom = Milky2018$selene$backend$$canvas_backend.zoom;
  const _bind$766 = { _0: 1, _1: 1 };
  const _p$4517 = Milky2018$selene$inputs$$mouse.pos;
  const _p$4518 = { _0: 1 / zoom, _1: 1 / zoom };
  const _bind$767 = { _0: _p$4517._0 * _p$4518._0, _1: _p$4517._1 * _p$4518._1 };
  const box = { position: _bind$767, size: _bind$766 };
  const _it = moonbitlang$core$builtin$$Map$iterator2$1$(Milky2018$selene$ui$$uis);
  while (true) {
    const _bind$768 = moonbitlang$core$builtin$$Iterator2$next$1$(_it);
    if (_bind$768 === undefined) {
      break;
    } else {
      const _Some = _bind$768;
      const _x = _Some;
      const _e = _x._0;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        const _bind$769 = moonbitlang$core$builtin$$Map$get$6$(Milky2018$selene$collision$$pickables, _e);
        if (_bind$769 === undefined) {
          continue;
        } else {
          const _Some$2 = _bind$769;
          const _pick = _Some$2;
          const _bind$770 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
          if (_bind$770 === undefined) {
            continue;
          } else {
            const _Some$3 = _bind$770;
            const _position = _Some$3;
            const _bind$771 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, _e);
            if (_bind$771 === undefined) {
              continue;
            } else {
              const _Some$4 = _bind$771;
              const _shape = _Some$4;
              const _Rect = _shape;
              const _x$2 = _Rect._0;
              const _width = _x$2._0;
              const _height = _x$2._1;
              const _offset = _Rect._1;
              const _bind$772 = { _0: _width, _1: _height };
              const _bind$773 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
              const area_box = { position: _bind$773, size: _bind$772 };
              if (!Milky2018$selene$math$$Rect$intersects(box, area_box)) {
                continue;
              }
              const _arr = [0, 1, 2];
              const _len = _arr.length;
              let _tmp$2257 = 0;
              while (true) {
                const _i = _tmp$2257;
                if (_i < _len) {
                  const button = _arr[_i];
                  if (Milky2018$selene$inputs$$is_mouse_pressed(button)) {
                    const _arr$2 = _pick.on_pressed_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2258 = 0;
                    while (true) {
                      const _i$2 = _tmp$2258;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2258 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_released(button)) {
                    const _arr$2 = _pick.on_released_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2258 = 0;
                    while (true) {
                      const _i$2 = _tmp$2258;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2258 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_just_pressed(button)) {
                    const _arr$2 = _pick.on_just_pressed_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2258 = 0;
                    while (true) {
                      const _i$2 = _tmp$2258;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2258 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_just_released(button)) {
                    const _arr$2 = _pick.on_just_released_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2258 = 0;
                    while (true) {
                      const _i$2 = _tmp$2258;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2258 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  _tmp$2257 = _i + 1 | 0;
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
    const _bind$768 = moonbitlang$core$builtin$$Iterator$next$3$(_it$2);
    if (_bind$768 === undefined) {
      return;
    } else {
      const _Some = _bind$768;
      const _e = _Some;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        const _bind$769 = moonbitlang$core$builtin$$Map$get$6$(Milky2018$selene$collision$$pickables, _e);
        if (_bind$769 === undefined) {
          continue;
        } else {
          const _Some$2 = _bind$769;
          const _pick = _Some$2;
          const _bind$770 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
          if (_bind$770 === undefined) {
            continue;
          } else {
            const _Some$3 = _bind$770;
            const _position = _Some$3;
            const _bind$771 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, _e);
            if (_bind$771 === undefined) {
              continue;
            } else {
              const _Some$4 = _bind$771;
              const _shape = _Some$4;
              const _Rect = _shape;
              const _x = _Rect._0;
              const _width = _x._0;
              const _height = _x._1;
              const _offset = _Rect._1;
              const _bind$772 = { _0: _width, _1: _height };
              const _bind$773 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
              const area_box = { position: _bind$773, size: _bind$772 };
              if (!Milky2018$selene$math$$Rect$intersects(Milky2018$selene$math$$Rect$shift(box, Milky2018$selene$camera$$camera.position), area_box)) {
                continue;
              }
              const _arr = [0, 1, 2];
              const _len = _arr.length;
              let _tmp$2257 = 0;
              while (true) {
                const _i = _tmp$2257;
                if (_i < _len) {
                  const button = _arr[_i];
                  if (Milky2018$selene$inputs$$is_mouse_pressed(button)) {
                    const _arr$2 = _pick.on_pressed_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2258 = 0;
                    while (true) {
                      const _i$2 = _tmp$2258;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2258 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_released(button)) {
                    const _arr$2 = _pick.on_released_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2258 = 0;
                    while (true) {
                      const _i$2 = _tmp$2258;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2258 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_just_pressed(button)) {
                    const _arr$2 = _pick.on_just_pressed_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2258 = 0;
                    while (true) {
                      const _i$2 = _tmp$2258;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2258 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  if (Milky2018$selene$inputs$$is_mouse_just_released(button)) {
                    const _arr$2 = _pick.on_just_released_callbacks;
                    const _len$2 = _arr$2.length;
                    let _tmp$2258 = 0;
                    while (true) {
                      const _i$2 = _tmp$2258;
                      if (_i$2 < _len$2) {
                        const callback = _arr$2[_i$2];
                        callback(button);
                        _tmp$2258 = _i$2 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                  }
                  _tmp$2257 = _i + 1 | 0;
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
  const _p$4517 = a.position;
  const _p$4518 = a.size;
  const _p$4519 = 0.5;
  const _p$4520 = { _0: _p$4518._0 * _p$4519, _1: _p$4518._1 * _p$4519 };
  const a_center = { _0: _p$4517._0 + _p$4520._0, _1: _p$4517._1 + _p$4520._1 };
  const _p$4521 = b.position;
  const _p$4522 = b.size;
  const _p$4523 = 0.5;
  const _p$4524 = { _0: _p$4522._0 * _p$4523, _1: _p$4522._1 * _p$4523 };
  const b_center = { _0: _p$4521._0 + _p$4524._0, _1: _p$4521._1 + _p$4524._1 };
  const _p$4525 = a.size;
  const _p$4526 = 0.5;
  const a_half = { _0: _p$4525._0 * _p$4526, _1: _p$4525._1 * _p$4526 };
  const _p$4527 = b.size;
  const _p$4528 = 0.5;
  const b_half = { _0: _p$4527._0 * _p$4528, _1: _p$4527._1 * _p$4528 };
  const delta = { _0: b_center._0 - a_center._0, _1: b_center._1 - a_center._1 };
  const intersect = { _0: -Math.abs(Milky2018$selene$math$$Vec2D$op_get(delta, 0)) + (Milky2018$selene$math$$Vec2D$op_get(b_half, 0) + Milky2018$selene$math$$Vec2D$op_get(a_half, 0)), _1: -Math.abs(Milky2018$selene$math$$Vec2D$op_get(delta, 1)) + (Milky2018$selene$math$$Vec2D$op_get(b_half, 1) + Milky2018$selene$math$$Vec2D$op_get(a_half, 1)) };
  return Milky2018$selene$math$$Vec2D$op_get(intersect, 0) < Milky2018$selene$math$$Vec2D$op_get(intersect, 1) && Milky2018$selene$math$$Vec2D$op_get(intersect, 0) > 0 ? (Milky2018$selene$math$$Vec2D$op_get(delta, 0) > 0 ? { _0: -Milky2018$selene$math$$Vec2D$op_get(intersect, 0), _1: 0 } : { _0: Milky2018$selene$math$$Vec2D$op_get(intersect, 0), _1: 0 }) : Milky2018$selene$math$$Vec2D$op_get(intersect, 1) > 0 && Milky2018$selene$math$$Vec2D$op_get(intersect, 0) > 0 ? (Milky2018$selene$math$$Vec2D$op_get(delta, 1) > 0 ? { _0: 0, _1: -Milky2018$selene$math$$Vec2D$op_get(intersect, 1) } : { _0: 0, _1: Milky2018$selene$math$$Vec2D$op_get(intersect, 1) }) : { _0: 0, _1: 0 };
}
function Milky2018$selene$collision$$add_collision_info(entity, target, direction) {
  const _bind$766 = moonbitlang$core$builtin$$Map$get$19$(Milky2018$selene$collision$$collision_infos, entity);
  if (_bind$766.$tag === 0) {
    moonbitlang$core$builtin$$Map$set$19$(Milky2018$selene$collision$$collision_infos, entity, moonbitlang$core$array$$Array$new$46$inner$45$(0));
  }
  moonbitlang$core$array$$Array$push$45$(moonbitlang$core$option$$Option$unwrap$60$(moonbitlang$core$builtin$$Map$get$19$(Milky2018$selene$collision$$collision_infos, entity)), { entity: target, direction: direction });
}
function Milky2018$selene$collision$$make_ray_collision(object, speed, axis) {
  const pos = { _0: Milky2018$selene$math$$Vec2D$op_get(object.position, 0), _1: Milky2018$selene$math$$Vec2D$op_get(object.position, 1) };
  const size = { _0: Milky2018$selene$math$$Vec2D$op_get(object.size, 0), _1: Milky2018$selene$math$$Vec2D$op_get(object.size, 1) };
  return speed >= 0 ? { position: pos, size: Milky2018$selene$math$$Vec2D$update(size, axis, Milky2018$selene$math$$Vec2D$op_get(size, axis) + speed) } : { position: Milky2018$selene$math$$Vec2D$update(pos, axis, Milky2018$selene$math$$Vec2D$op_get(pos, axis) + speed), size: Milky2018$selene$math$$Vec2D$update(size, axis, Milky2018$selene$math$$Vec2D$op_get(size, axis) - speed) };
}
function Milky2018$selene$collision$$CollisionMask$contains(self, layer) {
  return moonbitlang$core$array$$Array$contains$65$(self, layer);
}
function Milky2018$selene$collision$$move_axis(entity, object, velocity, axis, mask) {
  const ray_collision = Milky2018$selene$collision$$make_ray_collision(object, Milky2018$selene$math$$Vec2D$op_get(velocity, axis), axis);
  let new_pos = { _0: Milky2018$selene$math$$Vec2D$op_get(object.position, 0), _1: Milky2018$selene$math$$Vec2D$op_get(object.position, 1) };
  new_pos = Milky2018$selene$math$$Vec2D$update(new_pos, axis, Milky2018$selene$math$$Vec2D$op_get(new_pos, axis) + Milky2018$selene$math$$Vec2D$op_get(velocity, axis));
  let new_velocity = velocity;
  const entities = Milky2018$selene$collision$$quadtree_query(ray_collision);
  const _it = moonbitlang$core$set$$Set$iterator$3$(entities);
  while (true) {
    const _bind$766 = moonbitlang$core$builtin$$Iterator$next$3$(_it);
    if (_bind$766 === undefined) {
      break;
    } else {
      const _Some = _bind$766;
      const _e = _Some;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        if (moonbitlang$core$builtin$$op_notequal$3$(_e, entity)) {
          const _bind$767 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, _e);
          if (_bind$767 === undefined) {
            continue;
          } else {
            const _Some$2 = _bind$767;
            const _shape = _Some$2;
            const _Rect = _shape;
            const _x = _Rect._0;
            const _width = _x._0;
            const _height = _x._1;
            const _offset = _Rect._1;
            const _bind$768 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _e);
            if (_bind$768 === undefined) {
              continue;
            } else {
              const _Some$3 = _bind$768;
              const _pos = _Some$3;
              const _bind$769 = moonbitlang$core$builtin$$Map$get$12$(Milky2018$selene$collision$$collision_layers, _e);
              if (_bind$769 === undefined) {
                continue;
              } else {
                const _Some$4 = _bind$769;
                const _collision_layer = _Some$4;
                if (Milky2018$selene$collision$$CollisionMask$contains(mask, _collision_layer)) {
                  const _bind$770 = { _0: _width, _1: _height };
                  const _bind$771 = { _0: _pos._0 + _offset._0, _1: _pos._1 + _offset._1 };
                  const collision_box = { position: _bind$771, size: _bind$770 };
                  if (Milky2018$selene$math$$Rect$intersects(object, collision_box)) {
                    const movement = Milky2018$selene$collision$$aabb_resolve(object, collision_box);
                    const _p$4517 = new_pos;
                    new_pos = { _0: _p$4517._0 + movement._0, _1: _p$4517._1 + movement._1 };
                    const dir = Milky2018$selene$math$$Vec2D$update({ _0: 0, _1: 0 }, axis, Milky2018$selene$math$$Vec2D$op_get(movement, axis) > 0 ? 1 : -1);
                    Milky2018$selene$collision$$add_collision_info(entity, _e, dir);
                    return { _0: new_pos, _1: movement };
                  }
                  if (Milky2018$selene$math$$Rect$intersects(ray_collision, collision_box)) {
                    let dir = { _0: 0, _1: 0 };
                    if (Milky2018$selene$math$$Vec2D$op_get(new_velocity, axis) > 0) {
                      const _tmp$2257 = new_pos;
                      const _p$4517 = Milky2018$selene$math$$Vec2D$op_get(_bind$771, axis) - Milky2018$selene$math$$Vec2D$op_get(object.size, axis);
                      const _p$4518 = Milky2018$selene$math$$Vec2D$op_get(object.position, axis);
                      new_pos = Milky2018$selene$math$$Vec2D$update(_tmp$2257, axis, _p$4517 > _p$4518 ? _p$4517 : _p$4518);
                      new_velocity = Milky2018$selene$math$$Vec2D$update(new_velocity, axis, Milky2018$selene$math$$Vec2D$op_get(new_pos, axis) - Milky2018$selene$math$$Vec2D$op_get(object.position, axis));
                      dir = Milky2018$selene$math$$Vec2D$update(dir, axis, 1);
                    } else {
                      if (Milky2018$selene$math$$Vec2D$op_get(new_velocity, axis) < 0) {
                        const _tmp$2257 = new_pos;
                        const _p$4517 = Milky2018$selene$math$$Vec2D$op_get(_bind$771, axis) + Milky2018$selene$math$$Vec2D$op_get(_bind$770, axis);
                        const _p$4518 = Milky2018$selene$math$$Vec2D$op_get(object.position, axis);
                        new_pos = Milky2018$selene$math$$Vec2D$update(_tmp$2257, axis, _p$4517 > _p$4518 ? _p$4518 : _p$4517);
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
  const _bind$766 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, e);
  if (_bind$766 === undefined) {
    return $panic();
  } else {
    const _Some = _bind$766;
    const _pos = _Some;
    const _bind$767 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, e);
    if (_bind$767 === undefined) {
      return $panic();
    } else {
      const _Some$2 = _bind$767;
      const _shape = _Some$2;
      const _Rect = _shape;
      const _x = _Rect._0;
      const _width = _x._0;
      const _height = _x._1;
      const _offset = _Rect._1;
      const _bind$768 = { _0: _pos._0 + _offset._0, _1: _pos._1 + _offset._1 };
      const _bind$769 = { _0: _width, _1: _height };
      const box = { position: _bind$768, size: _bind$769 };
      const new_x = Milky2018$selene$collision$$move_axis(e, box, velocity, 0, collider.mask);
      const _bind$770 = new_x._0;
      const object_x = { position: _bind$770, size: _bind$769 };
      const new_y = Milky2018$selene$collision$$move_axis(e, object_x, new_x._1, 1, collider.mask);
      const _p$4517 = new_y._0;
      moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, e, { _0: _p$4517._0 - _offset._0, _1: _p$4517._1 - _offset._1 });
      return new_y._1;
    }
  }
}
function Milky2018$selene$collision$$move_without_collide(e, velocity) {
  const _bind$766 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, e);
  if (_bind$766 === undefined) {
    $panic();
    return;
  } else {
    const _Some = _bind$766;
    const _pos = _Some;
    const new_pos = { _0: Milky2018$selene$math$$Vec2D$op_get(_pos, 0) + Milky2018$selene$math$$Vec2D$op_get(velocity, 0), _1: Milky2018$selene$math$$Vec2D$op_get(_pos, 1) + Milky2018$selene$math$$Vec2D$op_get(velocity, 1) };
    moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, e, new_pos);
    return;
  }
}
function Milky2018$selene$collision$$move_system(delta) {
  moonbitlang$core$builtin$$Map$clear$19$(Milky2018$selene$collision$$collision_infos);
  const _it = moonbitlang$core$builtin$$Map$iterator2$16$(Milky2018$selene$velocity$$velocities);
  while (true) {
    const _bind$766 = moonbitlang$core$builtin$$Iterator2$next$16$(_it);
    if (_bind$766 === undefined) {
      return;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _e = _x._0;
      const _vel = _x._1;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        _L: {
          _L$2: {
            const _bind$767 = moonbitlang$core$builtin$$Map$get$15$(Milky2018$selene$collision$$colliders, _e);
            if (_bind$767 === undefined) {
              break _L$2;
            } else {
              const _Some$2 = _bind$767;
              const _collide = _Some$2;
              if (_collide.active) {
                const new_vel = Milky2018$selene$collision$$move_with_collide(_e, _collide, { _0: _vel._0 * delta, _1: _vel._1 * delta });
                moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$collision$$real_velocities, _e, { _0: new_vel._0 / delta, _1: new_vel._1 / delta });
              } else {
                break _L$2;
              }
            }
            break _L;
          }
          Milky2018$selene$collision$$move_without_collide(_e, { _0: _vel._0 * delta, _1: _vel._1 * delta });
          moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$collision$$real_velocities, _e, _vel);
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
function Milky2018$selene$collision$$get_collision_infos(entity) {
  return moonbitlang$core$option$$Option$unwrap_or_default$60$(moonbitlang$core$builtin$$Map$get$19$(Milky2018$selene$collision$$collision_infos, entity));
}
function Milky2018$selene$collision$$is_on_floor(entity) {
  const infos = Milky2018$selene$collision$$get_collision_infos(entity);
  const _len = infos.length;
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const info = infos[_i];
      if (Milky2018$selene$math$$Vec2D$op_get(info.direction, 1) > 0) {
        return true;
      }
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function Milky2018$selene$collision$$Area$new(mask) {
  const _bind$766 = moonbitlang$core$set$$Set$new$46$inner$3$(8);
  const _bind$767 = [];
  const _bind$768 = [];
  return { mask: mask, on_enter_callbacks: _bind$767, on_exit_callbacks: _bind$768, contains: _bind$766 };
}
function Milky2018$selene$collision$$Area$on_enter(self, callback) {
  moonbitlang$core$array$$Array$push$51$(self.on_enter_callbacks, callback);
}
function Milky2018$selene$collision$$area_collide_system(_delta) {
  let _foreach_result = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$16$;
  const _bind$766 = Milky2018$selene$entity$$iter_entities();
  _bind$766((e) => {
    const _bind$767 = moonbitlang$core$builtin$$Map$get$9$(Milky2018$selene$collision$$areas, e);
    if (_bind$767 === undefined) {
      return 1;
    } else {
      const _Some = _bind$767;
      const _area = _Some;
      const _bind$768 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, e);
      if (_bind$768 === undefined) {
        $panic();
      } else {
        const _Some$2 = _bind$768;
        const _position = _Some$2;
        const _bind$769 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, e);
        if (_bind$769 === undefined) {
          return 1;
        } else {
          const _Some$3 = _bind$769;
          const _shape = _Some$3;
          const _Rect = _shape;
          const _x = _Rect._0;
          const _width = _x._0;
          const _height = _x._1;
          const _offset = _Rect._1;
          const _bind$770 = { _0: _width, _1: _height };
          const _bind$771 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
          const box = { position: _bind$771, size: _bind$770 };
          const new_contains = moonbitlang$core$set$$Set$new$46$inner$3$(8);
          const entities = Milky2018$selene$collision$$quadtree_query(box);
          const _it = moonbitlang$core$set$$Set$iterator$3$(entities);
          while (true) {
            const _bind$772 = moonbitlang$core$builtin$$Iterator$next$3$(_it);
            if (_bind$772 === undefined) {
              break;
            } else {
              const _Some$4 = _bind$772;
              const _entity = _Some$4;
              if (Milky2018$selene$entity$$Entity$is_alive(_entity)) {
                const _bind$773 = moonbitlang$core$builtin$$Map$get$12$(Milky2018$selene$collision$$collision_layers, _entity);
                if (_bind$773 === undefined) {
                  continue;
                } else {
                  const _Some$5 = _bind$773;
                  const _other_layer = _Some$5;
                  const _bind$774 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, _entity);
                  if (_bind$774 === undefined) {
                    continue;
                  } else {
                    const _Some$6 = _bind$774;
                    const _other_shape = _Some$6;
                    const _Rect$2 = _other_shape;
                    const _x$2 = _Rect$2._0;
                    const _other_width = _x$2._0;
                    const _other_height = _x$2._1;
                    const _other_offset = _Rect$2._1;
                    const _bind$775 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, _entity);
                    if (_bind$775 === undefined) {
                      $panic();
                    } else {
                      const _Some$7 = _bind$775;
                      const _other_position = _Some$7;
                      const _bind$776 = { _0: _other_width, _1: _other_height };
                      const _bind$777 = { _0: _other_position._0 + _other_offset._0, _1: _other_position._1 + _other_offset._1 };
                      const other_box = { position: _bind$777, size: _bind$776 };
                      if (Milky2018$selene$math$$Rect$intersects(box, other_box)) {
                        if (Milky2018$selene$collision$$CollisionMask$contains(_area.mask, _other_layer)) {
                          moonbitlang$core$set$$Set$add$3$(new_contains, _entity);
                          if (moonbitlang$core$set$$Set$contains$3$(_area.contains, _entity)) {
                            continue;
                          }
                          const _arr = _area.on_enter_callbacks;
                          const _len = _arr.length;
                          let _tmp$2257 = 0;
                          while (true) {
                            const _i = _tmp$2257;
                            if (_i < _len) {
                              const callback = _arr[_i];
                              callback(_entity);
                              _tmp$2257 = _i + 1 | 0;
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
            const _bind$772 = moonbitlang$core$builtin$$Iterator$next$3$(_it$2);
            if (_bind$772 === undefined) {
              break;
            } else {
              const _Some$4 = _bind$772;
              const _entity = _Some$4;
              if (moonbitlang$core$set$$Set$contains$3$(new_contains, _entity)) {
                continue;
              }
              const _arr = _area.on_exit_callbacks;
              const _len = _arr.length;
              let _tmp$2257 = 0;
              while (true) {
                const _i = _tmp$2257;
                if (_i < _len) {
                  const callback = _arr[_i];
                  callback(_entity);
                  _tmp$2257 = _i + 1 | 0;
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
  const _tmp$2257 = _foreach_result;
  switch (_tmp$2257.$tag) {
    case 0: {
      return;
    }
    case 1: {
      const _break = _tmp$2257;
      _break._0;
      return;
    }
    case 2: {
      const _return = _tmp$2257;
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
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      _L: {
        const c = _arr[_i];
        if (Milky2018$selene$entity$$Entity$is_alive(c)) {
          const _bind$766 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, entity);
          if (_bind$766 === undefined) {
            break _L;
          } else {
            const _Some = _bind$766;
            const _parent_position = _Some;
            const _p$4517 = moonbitlang$core$builtin$$Map$get$17$(Milky2018$selene$entity$$children, c);
            let _tmp$2258;
            if (_p$4517 === undefined) {
              _tmp$2258 = $panic();
            } else {
              const _p$4518 = _p$4517;
              _tmp$2258 = _p$4518;
            }
            const offset = _tmp$2258.offset;
            moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, c, { _0: _parent_position._0 + offset._0, _1: _parent_position._1 + offset._1 });
            Milky2018$selene$inherit$$adjust_children(c);
          }
        } else {
          break _L;
        }
        break _L;
      }
      _tmp$2257 = _i + 1 | 0;
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
  const _bind$766 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Animation(animation, 0);
  return { sprite_type: _bind$766, zindex: zindex, visible: true, offset: offset };
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
  const _bind$766 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Picture(picture);
  return { sprite_type: _bind$766, zindex: zindex, visible: true, offset: offset };
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
  const _bind$766 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Text(text);
  return { sprite_type: _bind$766, zindex: zindex, visible: true, offset: offset };
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
function Milky2018$selene$sprite$$render_animation(animation, current_frame, pos, visible, delta) {
  const frame = moonbitlang$core$array$$Array$at$42$(animation.frames, moonbitlang$core$double$$Double$to_int(current_frame));
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
  const _p$4517 = moonbitlang$core$builtin$$Map$to_array$4$(Milky2018$selene$sprite$$sprites);
  const _p$4518 = [];
  const _p$4519 = _p$4517.length;
  let _tmp$2257 = 0;
  while (true) {
    const _p$4520 = _tmp$2257;
    if (_p$4520 < _p$4519) {
      const _p$4521 = _p$4517[_p$4520];
      if (Milky2018$selene$entity$$Entity$is_alive(_p$4521._0)) {
        moonbitlang$core$array$$Array$push$38$(_p$4518, _p$4521);
      }
      _tmp$2257 = _p$4520 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const sprites = _p$4518;
  moonbitlang$core$array$$Array$sort_by$38$(sprites, (sprite1, sprite2) => {
    if (sprite1._1.zindex < sprite2._1.zindex) {
      return -1;
    } else {
      if (sprite1._1.zindex > sprite2._1.zindex) {
        return 1;
      } else {
        const _bind$766 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, sprite1._0);
        if (_bind$766 === undefined) {
          return 0;
        } else {
          const _Some = _bind$766;
          const _pos1 = _Some;
          const _bind$767 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, sprite2._0);
          if (_bind$767 === undefined) {
            return 0;
          } else {
            const _Some$2 = _bind$767;
            const _pos2 = _Some$2;
            return Milky2018$selene$math$$Vec2D$op_get(_pos1, 1) < Milky2018$selene$math$$Vec2D$op_get(_pos2, 1) ? -1 : Milky2018$selene$math$$Vec2D$op_get(_pos1, 1) > Milky2018$selene$math$$Vec2D$op_get(_pos2, 1) ? 1 : 0;
          }
        }
      }
    }
  });
  const _len = sprites.length;
  let _tmp$2258 = 0;
  while (true) {
    const _i = _tmp$2258;
    if (_i < _len) {
      _L: {
        const sprite = sprites[_i];
        const e = sprite._0;
        const sprite$2 = sprite._1;
        const _bind$766 = moonbitlang$core$builtin$$Map$get$0$(Milky2018$selene$position$$positions, e);
        if (_bind$766 === undefined) {
          break _L;
        } else {
          const _Some = _bind$766;
          const _pos = _Some;
          const _bind$767 = moonbitlang$core$builtin$$Map$get$1$(Milky2018$selene$ui$$uis, e);
          let pos;
          if (_bind$767 === -1) {
            const _p$4520 = Milky2018$selene$camera$$camera.position;
            pos = { _0: _pos._0 - _p$4520._0, _1: _pos._1 - _p$4520._1 };
          } else {
            pos = _pos;
          }
          const _bind$768 = sprite$2.sprite_type;
          switch (_bind$768.$tag) {
            case 0: {
              const _Picture = _bind$768;
              const _picture = _Picture._0;
              if (sprite$2.visible) {
                const _p$4520 = sprite$2.offset;
                Milky2018$selene$sprite$$render_picture(_picture, { _0: pos._0 + _p$4520._0, _1: pos._1 + _p$4520._1 });
              }
              break;
            }
            case 1: {
              const _Animation = _bind$768;
              const _anime = _Animation._0;
              const _frame = _Animation._1;
              const _p$4520 = sprite$2.offset;
              const _tmp$2259 = { _0: pos._0 + _p$4520._0, _1: pos._1 + _p$4520._1 };
              const new_frame = Milky2018$selene$sprite$$render_animation(_anime, _frame, _tmp$2259, sprite$2.visible, delta);
              _Animation._1 = new_frame;
              break;
            }
            case 2: {
              const _Text = _bind$768;
              const _text = _Text._0;
              if (sprite$2.visible) {
                const _p$4521 = sprite$2.offset;
                Milky2018$selene$sprite$$render_text(_text, { _0: pos._0 + _p$4521._0, _1: pos._1 + _p$4521._1 });
              }
              break;
            }
            case 3: {
              const _ColorRect = _bind$768;
              const _color_rect = _ColorRect._0;
              if (sprite$2.visible) {
                const _p$4521 = sprite$2.offset;
                Milky2018$selene$sprite$$render_color_rect(_color_rect, { _0: pos._0 + _p$4521._0, _1: pos._1 + _p$4521._1 });
              }
              break;
            }
            default: {
              const _ColorCircle = _bind$768;
              const _color_circle = _ColorCircle._0;
              if (sprite$2.visible) {
                const _p$4521 = sprite$2.offset;
                Milky2018$selene$sprite$$render_color_circle(_color_circle, { _0: pos._0 + _p$4521._0, _1: pos._1 + _p$4521._1 });
              }
            }
          }
        }
        break _L;
      }
      _tmp$2258 = _i + 1 | 0;
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
    moonbitlang$core$abort$$abort$24$("Animation must have at least one frame");
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
  let _tmp$2257 = 0;
  while (true) {
    const i = _tmp$2257;
    if (i < frame_count) {
      const x = Milky2018$selene$math$$Vec2D$op_get(offset, 0) + (i + 0) * (width + space_x);
      moonbitlang$core$array$$Array$push$42$(frames, { sprite_path: sprite_path, size: { _0: width, _1: height }, offset: Milky2018$selene$math$$Vec2D$update(offset, 0, x) });
      _tmp$2257 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return frames;
}
function Milky2018$selene$sprite$$frames_from_atlas(sprite_path, frame_count, width, height, offset$46$opt, space_x$46$opt) {
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  let space_x;
  if (space_x$46$opt.$tag === 1) {
    const _Some = space_x$46$opt;
    space_x = _Some._0;
  } else {
    space_x = 0;
  }
  return Milky2018$selene$sprite$$frames_from_atlas$46$inner(sprite_path, frame_count, width, height, offset, space_x);
}
function Milky2018$selene$sprite$$play_animation$46$inner(entity, animation, from_start, loop_, rate, transform) {
  _L: {
    const _bind$766 = moonbitlang$core$builtin$$Map$get$4$(Milky2018$selene$sprite$$sprites, entity);
    if (_bind$766 === undefined) {
      break _L;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _x$2 = _x.sprite_type;
      if (_x$2.$tag === 1) {
        const _Animation = _x$2;
        const _current_anime = _Animation._0;
        const _current_frame = _Animation._1;
        const _zindex = _x.zindex;
        const _visible = _x.visible;
        const _offset = _x.offset;
        const _p$4517 = animation.loop_;
        const loop_$2 = loop_ === -1 ? _p$4517 : loop_;
        const rate$2 = moonbitlang$core$option$$Option$unwrap_or$23$(rate, animation.fps);
        const _p$4518 = animation.transform;
        let transform$2;
        if (transform === undefined) {
          transform$2 = _p$4518;
        } else {
          const _p$4519 = transform;
          transform$2 = _p$4519;
        }
        const frame = !from_start && animation.id === _current_anime.id ? _current_frame : 0;
        const new_anime = { frames: animation.frames, transform: transform$2, loop_: loop_$2, fps: rate$2, id: animation.id };
        moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, entity, { sprite_type: new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Animation(new_anime, frame), zindex: _zindex, visible: _visible, offset: _offset });
        return;
      } else {
        break _L;
      }
    }
  }
  $panic();
}
function Milky2018$selene$sprite$$is_animation_finished(entity) {
  const _bind$766 = moonbitlang$core$builtin$$Map$get$4$(Milky2018$selene$sprite$$sprites, entity);
  if (_bind$766 === undefined) {
    return true;
  } else {
    const _Some = _bind$766;
    const _x = _Some;
    const _x$2 = _x.sprite_type;
    if (_x$2.$tag === 1) {
      const _Animation = _x$2;
      const _anime = _Animation._0;
      const _frame = _Animation._1;
      if (_anime.loop_) {
        return false;
      }
      return _frame >= _anime.frames.length + 0 - 0.01;
    } else {
      return true;
    }
  }
}
function Milky2018$selene$style$$Style$new$46$inner(size_plan, flex, h_padding, v_padding, h_offset, v_offset) {
  return { size_plan: size_plan, flex: flex, h_padding: h_padding, v_padding: v_padding, h_offset: h_offset, v_offset: v_offset };
}
function Milky2018$selene$style$$arrange(entity, offset) {
  const _bind$766 = moonbitlang$core$builtin$$Map$get$2$(Milky2018$selene$style$$styles, entity);
  if (_bind$766 === undefined) {
    return { _0: 0, _1: 0 };
  } else {
    const _Some = _bind$766;
    const _style = _Some;
    if (Milky2018$selene$entity$$Entity$is_child(entity)) {
      const _p$4517 = { _0: _style.h_offset, _1: _style.v_offset };
      Milky2018$selene$entity$$Entity$set_offset(entity, { _0: offset._0 + _p$4517._0, _1: offset._1 + _p$4517._1 });
    }
    const children = Milky2018$selene$entity$$Entity$get_children(entity);
    let cursor = { _0: _style.h_padding, _1: _style.v_padding };
    let max_width = 0;
    let max_height = 0;
    const _len = children.length;
    let _tmp$2257 = 0;
    while (true) {
      const _i = _tmp$2257;
      if (_i < _len) {
        const c = children[_i];
        const size = Milky2018$selene$style$$arrange(c, cursor);
        const _bind$767 = _style.flex;
        let _tmp$2258;
        switch (_bind$767) {
          case 1: {
            _tmp$2258 = Milky2018$selene$math$$Vec2D$update(cursor, 0, Milky2018$selene$math$$Vec2D$op_get(cursor, 0) + Milky2018$selene$math$$Vec2D$op_get(size, 0) + _style.h_padding);
            break;
          }
          case 0: {
            _tmp$2258 = cursor;
            break;
          }
          default: {
            _tmp$2258 = Milky2018$selene$math$$Vec2D$update(cursor, 1, Milky2018$selene$math$$Vec2D$op_get(cursor, 1) + Milky2018$selene$math$$Vec2D$op_get(size, 1) + _style.v_padding);
          }
        }
        cursor = _tmp$2258;
        const _p$4517 = max_width;
        const _p$4518 = Milky2018$selene$math$$Vec2D$op_get(size, 0);
        max_width = _p$4517 > _p$4518 ? _p$4517 : _p$4518;
        const _p$4519 = max_height;
        const _p$4520 = Milky2018$selene$math$$Vec2D$op_get(size, 1);
        max_height = _p$4519 > _p$4520 ? _p$4519 : _p$4520;
        _tmp$2257 = _i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const _bind$767 = _style.size_plan;
    switch (_bind$767.$tag) {
      case 1: {
        const _bind$768 = moonbitlang$core$builtin$$Map$get$4$(Milky2018$selene$sprite$$sprites, entity);
        if (_bind$768 === undefined) {
          return $panic();
        } else {
          const _Some$2 = _bind$768;
          const _sprite = _Some$2;
          const _bind$769 = _sprite.sprite_type;
          switch (_bind$769.$tag) {
            case 0: {
              const _Picture = _bind$769;
              const _picture = _Picture._0;
              return Milky2018$selene$math$$Transform$apply_to_vec2d(_picture.transform, _picture.size);
            }
            case 2: {
              return { _0: 48, _1: 24 };
            }
            case 1: {
              const _Animation = _bind$769;
              const _anime = _Animation._0;
              return Milky2018$selene$math$$Transform$apply_to_vec2d(_anime.transform, moonbitlang$core$array$$Array$at$42$(_anime.frames, 0).size);
            }
            case 3: {
              const _ColorRect = _bind$769;
              const _rect = _ColorRect._0;
              return _rect.size;
            }
            default: {
              const _ColorCircle = _bind$769;
              const _circle = _ColorCircle._0;
              return { _0: _circle.radius * 2, _1: _circle.radius * 2 };
            }
          }
        }
      }
      case 0: {
        const _Sized = _bind$767;
        return _Sized._0;
      }
      case 2: {
        return { _0: max_width, _1: max_height };
      }
      default: {
        const _bind$769 = moonbitlang$core$builtin$$Map$get$5$(Milky2018$selene$collision$$shapes, entity);
        if (_bind$769 === undefined) {
          return $panic();
        } else {
          const _Some$2 = _bind$769;
          const _shape = _Some$2;
          const _Rect = _shape;
          return _Rect._0;
        }
      }
    }
  }
}
function Milky2018$selene$style$$style_system(_delta) {
  let _foreach_result = $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$16$;
  const _bind$766 = Milky2018$selene$entity$$get_roots();
  _bind$766((e) => {
    if (Milky2018$selene$entity$$Entity$is_alive(e)) {
      Milky2018$selene$style$$arrange(e, { _0: 0, _1: 0 });
    } else {
      return 1;
    }
    return 1;
  });
  const _tmp$2257 = _foreach_result;
  switch (_tmp$2257.$tag) {
    case 0: {
      return;
    }
    case 1: {
      const _break = _tmp$2257;
      _break._0;
      return;
    }
    case 2: {
      const _return = _tmp$2257;
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
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$collision$$move_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Move System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$inputs$$advanced_key_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Advanced Key System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$inputs$$advanced_mouse_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Advanced Mouse System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$collision$$quadtree_clear_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Quadtree Clear System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$collision$$pickable_click_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Pickable Click System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$collision$$area_collide_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Area Collide System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$system$$deferred_event_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Deferred Event System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$sprite$$render_sprite_system, _1: Milky2018$selene$plugins$$default_plugin$46$constr$47$3110, _2: "Render Sprite System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$camera$$camera_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Camera System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$system$$timer_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Timer System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$system$$realtime_timer_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Realtime Timer System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$inherit$$inherit_position_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Inherit Position System" });
  moonbitlang$core$array$$Array$push$47$(_self, { _0: Milky2018$selene$style$$style_system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Style System" });
}
function moonbitlang$core$json$$FromJson$from_json$31$(_x_61, _x_62) {
  let _de_tiles_65 = Option$None$17$;
  let _de_name_64 = undefined;
  let _de_collider_63 = -1;
  if (_x_61.$tag === 6) {
    const _Object = _x_61;
    const __map = _Object._0;
    const _bind$766 = moonbitlang$core$builtin$$Map$get$13$(__map, "name");
    if (_bind$766 === undefined) {
    } else {
      const _Some = _bind$766;
      const __v = _Some;
      const _p$4517 = "name";
      const _bind$767 = moonbitlang$core$json$$FromJson$from_json$26$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_62, _p$4517));
      let _tmp$2257;
      if (_bind$767.$tag === 1) {
        const _ok = _bind$767;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$767;
      }
      _de_name_64 = _tmp$2257;
    }
    const _bind$767 = moonbitlang$core$builtin$$Map$get$13$(__map, "tiles");
    if (_bind$767 === undefined) {
    } else {
      const _Some = _bind$767;
      const __v = _Some;
      const _p$4517 = "tiles";
      const _bind$768 = moonbitlang$core$json$$FromJson$from_json$32$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_62, _p$4517));
      let _tmp$2257;
      if (_bind$768.$tag === 1) {
        const _ok = _bind$768;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$768;
      }
      _de_tiles_65 = new Option$Some$17$(_tmp$2257);
    }
    const _bind$768 = moonbitlang$core$builtin$$Map$get$13$(__map, "collider");
    if (_bind$768 === undefined) {
    } else {
      const _Some = _bind$768;
      const __v = _Some;
      const _p$4517 = "collider";
      const _bind$769 = moonbitlang$core$json$$FromJson$from_json$28$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_62, _p$4517));
      let _tmp$2257;
      if (_bind$769.$tag === 1) {
        const _ok = _bind$769;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$769;
      }
      _de_collider_63 = _tmp$2257;
    }
  } else {
    return new Result$Err$18$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_62, _1: "Expected object to deserialize TileLayer" }));
  }
  const _bind$766 = _de_tiles_65;
  let _de_tiles_65$2;
  if (_bind$766.$tag === 1) {
    const _Some = _bind$766;
    _de_tiles_65$2 = _Some._0;
  } else {
    return new Result$Err$18$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_62, _1: "Missing field tiles" }));
  }
  const _bind$767 = _de_name_64;
  let _de_name_64$2;
  if (_bind$767 === undefined) {
    return new Result$Err$18$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_62, _1: "Missing field name" }));
  } else {
    const _Some = _bind$767;
    _de_name_64$2 = _Some;
  }
  const _bind$768 = _de_collider_63;
  let _de_collider_63$2;
  if (_bind$768 === -1) {
    return new Result$Err$18$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_62, _1: "Missing field collider" }));
  } else {
    _de_collider_63$2 = _bind$768;
  }
  return new Result$Ok$18$({ name: _de_name_64$2, tiles: _de_tiles_65$2, collider: _de_collider_63$2 });
}
function moonbitlang$core$json$$FromJson$from_json$29$(_x_36, _x_37) {
  let _de_tile_size_41 = undefined;
  let _de_map_width_40 = undefined;
  let _de_map_height_39 = undefined;
  let _de_layers_38 = Option$None$19$;
  if (_x_36.$tag === 6) {
    const _Object = _x_36;
    const __map = _Object._0;
    const _bind$766 = moonbitlang$core$builtin$$Map$get$13$(__map, "tileSize");
    if (_bind$766 === undefined) {
    } else {
      const _Some = _bind$766;
      const __v = _Some;
      const _p$4517 = "tileSize";
      const _bind$767 = moonbitlang$core$json$$FromJson$from_json$10$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_37, _p$4517));
      let _tmp$2257;
      if (_bind$767.$tag === 1) {
        const _ok = _bind$767;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$767;
      }
      _de_tile_size_41 = _tmp$2257;
    }
    const _bind$767 = moonbitlang$core$builtin$$Map$get$13$(__map, "mapWidth");
    if (_bind$767 === undefined) {
    } else {
      const _Some = _bind$767;
      const __v = _Some;
      const _p$4517 = "mapWidth";
      const _bind$768 = moonbitlang$core$json$$FromJson$from_json$10$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_37, _p$4517));
      let _tmp$2257;
      if (_bind$768.$tag === 1) {
        const _ok = _bind$768;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$768;
      }
      _de_map_width_40 = _tmp$2257;
    }
    const _bind$768 = moonbitlang$core$builtin$$Map$get$13$(__map, "mapHeight");
    if (_bind$768 === undefined) {
    } else {
      const _Some = _bind$768;
      const __v = _Some;
      const _p$4517 = "mapHeight";
      const _bind$769 = moonbitlang$core$json$$FromJson$from_json$10$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_37, _p$4517));
      let _tmp$2257;
      if (_bind$769.$tag === 1) {
        const _ok = _bind$769;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$769;
      }
      _de_map_height_39 = _tmp$2257;
    }
    const _bind$769 = moonbitlang$core$builtin$$Map$get$13$(__map, "layers");
    if (_bind$769 === undefined) {
    } else {
      const _Some = _bind$769;
      const __v = _Some;
      const _p$4517 = "layers";
      const _bind$770 = moonbitlang$core$json$$FromJson$from_json$30$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_37, _p$4517));
      let _tmp$2257;
      if (_bind$770.$tag === 1) {
        const _ok = _bind$770;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$770;
      }
      _de_layers_38 = new Option$Some$19$(_tmp$2257);
    }
  } else {
    return new Result$Err$20$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_37, _1: "Expected object to deserialize TileMap" }));
  }
  const _bind$766 = _de_tile_size_41;
  let _de_tile_size_41$2;
  if (_bind$766 === undefined) {
    return new Result$Err$20$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_37, _1: "Missing field tile_size" }));
  } else {
    const _Some = _bind$766;
    _de_tile_size_41$2 = _Some;
  }
  const _bind$767 = _de_map_width_40;
  let _de_map_width_40$2;
  if (_bind$767 === undefined) {
    return new Result$Err$20$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_37, _1: "Missing field map_width" }));
  } else {
    const _Some = _bind$767;
    _de_map_width_40$2 = _Some;
  }
  const _bind$768 = _de_map_height_39;
  let _de_map_height_39$2;
  if (_bind$768 === undefined) {
    return new Result$Err$20$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_37, _1: "Missing field map_height" }));
  } else {
    const _Some = _bind$768;
    _de_map_height_39$2 = _Some;
  }
  const _bind$769 = _de_layers_38;
  let _de_layers_38$2;
  if (_bind$769.$tag === 1) {
    const _Some = _bind$769;
    _de_layers_38$2 = _Some._0;
  } else {
    return new Result$Err$20$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_37, _1: "Missing field layers" }));
  }
  return new Result$Ok$20$({ tile_size: _de_tile_size_41$2, map_width: _de_map_width_40$2, map_height: _de_map_height_39$2, layers: _de_layers_38$2 });
}
function moonbitlang$core$json$$FromJson$from_json$33$(_x_16, _x_17) {
  let _de_y_20 = undefined;
  let _de_x_19 = undefined;
  let _de_id_18 = undefined;
  if (_x_16.$tag === 6) {
    const _Object = _x_16;
    const __map = _Object._0;
    const _bind$766 = moonbitlang$core$builtin$$Map$get$13$(__map, "id");
    if (_bind$766 === undefined) {
    } else {
      const _Some = _bind$766;
      const __v = _Some;
      const _p$4517 = "id";
      const _bind$767 = moonbitlang$core$json$$FromJson$from_json$26$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_17, _p$4517));
      let _tmp$2257;
      if (_bind$767.$tag === 1) {
        const _ok = _bind$767;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$767;
      }
      _de_id_18 = _tmp$2257;
    }
    const _bind$767 = moonbitlang$core$builtin$$Map$get$13$(__map, "x");
    if (_bind$767 === undefined) {
    } else {
      const _Some = _bind$767;
      const __v = _Some;
      const _p$4517 = "x";
      const _bind$768 = moonbitlang$core$json$$FromJson$from_json$10$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_17, _p$4517));
      let _tmp$2257;
      if (_bind$768.$tag === 1) {
        const _ok = _bind$768;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$768;
      }
      _de_x_19 = _tmp$2257;
    }
    const _bind$768 = moonbitlang$core$builtin$$Map$get$13$(__map, "y");
    if (_bind$768 === undefined) {
    } else {
      const _Some = _bind$768;
      const __v = _Some;
      const _p$4517 = "y";
      const _bind$769 = moonbitlang$core$json$$FromJson$from_json$10$(__v, new $64$moonbitlang$47$core$47$json$46$JsonPath$Key(_x_17, _p$4517));
      let _tmp$2257;
      if (_bind$769.$tag === 1) {
        const _ok = _bind$769;
        _tmp$2257 = _ok._0;
      } else {
        return _bind$769;
      }
      _de_y_20 = _tmp$2257;
    }
  } else {
    return new Result$Err$21$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_17, _1: "Expected object to deserialize Tile" }));
  }
  const _bind$766 = _de_y_20;
  let _de_y_20$2;
  if (_bind$766 === undefined) {
    return new Result$Err$21$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_17, _1: "Missing field y" }));
  } else {
    const _Some = _bind$766;
    _de_y_20$2 = _Some;
  }
  const _bind$767 = _de_x_19;
  let _de_x_19$2;
  if (_bind$767 === undefined) {
    return new Result$Err$21$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_17, _1: "Missing field x" }));
  } else {
    const _Some = _bind$767;
    _de_x_19$2 = _Some;
  }
  const _bind$768 = _de_id_18;
  let _de_id_18$2;
  if (_bind$768 === undefined) {
    return new Result$Err$21$(new Error$moonbitlang$47$core$47$json$46$JsonDecodeError$46$JsonDecodeError({ _0: _x_17, _1: "Missing field id" }));
  } else {
    const _Some = _bind$768;
    _de_id_18$2 = _Some;
  }
  return new Result$Ok$21$({ id: _de_id_18$2, x: _de_x_19$2, y: _de_y_20$2 });
}
function Milky2018$selene$tilemap$$TileMap$from_json(json) {
  let _try_err;
  _L: {
    const _bind$766 = moonbitlang$core$json$$from_json$29$(json, undefined);
    if (_bind$766.$tag === 1) {
      const _ok = _bind$766;
      return _ok._0;
    } else {
      const _err = _bind$766;
      const _tmp$2257 = _err._0;
      _try_err = _tmp$2257;
      break _L;
    }
  }
  return $panic();
}
function Milky2018$selene$tilemap$$TileMap$get_tiles(self, layer_name) {
  const _p$4517 = self.layers;
  const _p$4518 = [];
  const _p$4519 = _p$4517.length;
  let _tmp$2257 = 0;
  while (true) {
    const _p$4520 = _tmp$2257;
    if (_p$4520 < _p$4519) {
      const _p$4521 = _p$4517[_p$4520];
      if (_p$4521.name === layer_name) {
        moonbitlang$core$array$$Array$push$31$(_p$4518, _p$4521);
      }
      _tmp$2257 = _p$4520 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return moonbitlang$core$option$$Option$map_or$61$(moonbitlang$core$array$$Array$get$31$(_p$4518, 0), [], (layer) => layer.tiles);
}
function Milky2018$selene$tilemap$$TileMap$get_tiles_first(self, layer_name) {
  const _p$4517 = self.layers;
  const _p$4518 = [];
  const _p$4519 = _p$4517.length;
  let _tmp$2257 = 0;
  while (true) {
    const _p$4520 = _tmp$2257;
    if (_p$4520 < _p$4519) {
      const _p$4521 = _p$4517[_p$4520];
      if (_p$4521.name === layer_name) {
        moonbitlang$core$array$$Array$push$31$(_p$4518, _p$4521);
      }
      _tmp$2257 = _p$4520 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const layer = moonbitlang$core$array$$Array$get$31$(_p$4518, 0);
  if (layer === undefined) {
    return [];
  } else {
    const _Some = layer;
    const _layer = _Some;
    const tiles = _layer.tiles;
    const _p$4520 = new Array(tiles.length);
    const _p$4521 = tiles.length;
    let _tmp$2258 = 0;
    while (true) {
      const _p$4522 = _tmp$2258;
      if (_p$4522 < _p$4521) {
        const _p$4523 = tiles[_p$4522];
        _p$4520[_p$4522] = _p$4523.id;
        _tmp$2258 = _p$4522 + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const all_ids = _p$4520;
    const leftcorder_id = moonbitlang$core$array$$Array$at$26$(all_ids, 0);
    const _p$4522 = [];
    const _p$4523 = tiles.length;
    let _tmp$2259 = 0;
    while (true) {
      const _p$4524 = _tmp$2259;
      if (_p$4524 < _p$4523) {
        const _p$4525 = tiles[_p$4524];
        if (_p$4525.id === leftcorder_id) {
          moonbitlang$core$array$$Array$push$33$(_p$4522, _p$4525);
        }
        _tmp$2259 = _p$4524 + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return _p$4522;
  }
}
function Milky2018$selene$examples$pixeladventure$$add_result_box() {
  const box = Milky2018$selene$entity$$Entity$new();
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, box, { _0: 192, _1: 128 });
  const text = Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$pixeladventure$$game_state.result_box, 100, undefined);
  moonbitlang$core$builtin$$Map$set$1$(Milky2018$selene$ui$$uis, box, Milky2018$selene$ui$$Ui$new());
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, box, text);
}
function Milky2018$selene$examples$pixeladventure$$add_score_box() {
  const box = Milky2018$selene$entity$$Entity$new();
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, box, { _0: 216, _1: 16 });
  const text = Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$pixeladventure$$game_state.score_box, 100, undefined);
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, box, text);
  moonbitlang$core$builtin$$Map$set$1$(Milky2018$selene$ui$$uis, box, Milky2018$selene$ui$$Ui$new());
}
function Milky2018$selene$examples$pixeladventure$$add_health_box() {
  const box = Milky2018$selene$entity$$Entity$new();
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, box, { _0: 20, _1: 16 });
  const text = Milky2018$selene$sprite$$Sprite$from_text(Milky2018$selene$examples$pixeladventure$$game_state.health_box, 100, undefined);
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, box, text);
  moonbitlang$core$builtin$$Map$set$1$(Milky2018$selene$ui$$uis, box, Milky2018$selene$ui$$Ui$new());
}
function Milky2018$selene$examples$pixeladventure$$add_volume_button() {
  const button = Milky2018$selene$entity$$Entity$new();
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, button, { _0: 440, _1: 18 });
  const volume_on = Milky2018$selene$sprite$$Sprite$from_picture(Milky2018$selene$sprite$$Picture$new({ _0: 21, _1: 22 }, "assets/Menu/Buttons/Volume.png", undefined, undefined), 100, undefined);
  const volumn_off = Milky2018$selene$sprite$$Sprite$from_picture(Milky2018$selene$sprite$$Picture$new({ _0: 21, _1: 22 }, "assets/Menu/Buttons/VolumeOff.png", undefined, undefined), 100, undefined);
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, button, volume_on);
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, button, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 21, _1: 22 }, { _0: 0, _1: 0 }));
  const pickable = Milky2018$selene$collision$$Pickable$new();
  Milky2018$selene$collision$$Pickable$on_just_released(pickable, (mouse_button) => {
    if (moonbitlang$core$builtin$$Eq$equal$68$(mouse_button, 0)) {
      Milky2018$selene$examples$pixeladventure$$game_state.volume_on = !Milky2018$selene$examples$pixeladventure$$game_state.volume_on;
      if (Milky2018$selene$examples$pixeladventure$$game_state.volume_on) {
        moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, button, volume_on);
        return;
      } else {
        moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, button, volumn_off);
        return;
      }
    } else {
      return;
    }
  });
  moonbitlang$core$builtin$$Map$set$6$(Milky2018$selene$collision$$pickables, button, pickable);
  moonbitlang$core$builtin$$Map$set$1$(Milky2018$selene$ui$$uis, button, Milky2018$selene$ui$$Ui$new());
}
function Milky2018$selene$examples$pixeladventure$$add_player(pos) {
  const player_sprite = Milky2018$selene$sprite$$Sprite$from_animation(Milky2018$selene$examples$pixeladventure$$player_idle_animation, 10, undefined);
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, Milky2018$selene$examples$pixeladventure$$game_state.player, player_sprite);
  moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$velocity$$velocities, Milky2018$selene$examples$pixeladventure$$game_state.player, { _0: 0, _1: 0 });
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, Milky2018$selene$examples$pixeladventure$$game_state.player, pos);
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, Milky2018$selene$examples$pixeladventure$$game_state.player, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 24, _1: 32 }, { _0: 4, _1: 0 }));
  moonbitlang$core$builtin$$Map$set$12$(Milky2018$selene$collision$$collision_layers, Milky2018$selene$examples$pixeladventure$$game_state.player, Milky2018$selene$examples$pixeladventure$$player_collision_layer);
  moonbitlang$core$builtin$$Map$set$15$(Milky2018$selene$collision$$colliders, Milky2018$selene$examples$pixeladventure$$game_state.player, Milky2018$selene$collision$$Collider$new([Milky2018$selene$examples$pixeladventure$$terrain_collision_layer, Milky2018$selene$examples$pixeladventure$$enemy_collision_layer]));
  Milky2018$selene$camera$$attach_entity(Milky2018$selene$examples$pixeladventure$$game_state.player, { _0: 16, _1: 16 });
}
function Milky2018$selene$examples$pixeladventure$$set_game_result(result) {
  if (result === 0) {
    Milky2018$selene$examples$pixeladventure$$game_state.result_box.content = "You Win!";
    Milky2018$selene$examples$pixeladventure$$game_state.result_box.color = "green";
    return;
  } else {
    Milky2018$selene$examples$pixeladventure$$game_state.result_box.content = "Game Over!";
    Milky2018$selene$examples$pixeladventure$$game_state.result_box.color = "red";
    return;
  }
}
function Milky2018$selene$examples$pixeladventure$$update_health_display() {
  Milky2018$selene$examples$pixeladventure$$game_state.health_box.content = `HP: ${moonbitlang$core$int$$Int$to_string$46$inner(Milky2018$selene$examples$pixeladventure$$game_state.health, 10)}`;
}
function Milky2018$selene$examples$pixeladventure$$hurt_player() {
  if (Milky2018$selene$examples$pixeladventure$$game_state.hurt_timer <= 0) {
    const _bind$766 = Milky2018$selene$examples$pixeladventure$$game_state.direction;
    let back_vel;
    if (_bind$766 === 0) {
      back_vel = { _0: 180, _1: 0 };
    } else {
      back_vel = { _0: -180, _1: 0 };
    }
    moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$velocity$$velocities, Milky2018$selene$examples$pixeladventure$$game_state.player, back_vel);
    Milky2018$selene$examples$pixeladventure$$game_state.player_state = 3;
    Milky2018$selene$examples$pixeladventure$$game_state.health = Milky2018$selene$examples$pixeladventure$$game_state.health - 1 | 0;
    Milky2018$selene$examples$pixeladventure$$update_health_display();
    Milky2018$selene$examples$pixeladventure$$game_state.hurt_timer = 60;
    if (Milky2018$selene$examples$pixeladventure$$game_state.volume_on) {
      Milky2018$selene$audio$$play_audio$46$inner("assets/sounds/hurt.wav", 1, false);
    }
    if (Milky2018$selene$examples$pixeladventure$$game_state.health <= 0) {
      Milky2018$selene$examples$pixeladventure$$set_game_result(1);
      return;
    } else {
      return;
    }
  } else {
    return;
  }
}
function Milky2018$selene$examples$pixeladventure$$player_collision_system(_delta) {
  if (Milky2018$selene$examples$pixeladventure$$game_state.hurt_timer > 0) {
    Milky2018$selene$examples$pixeladventure$$game_state.hurt_timer = Milky2018$selene$examples$pixeladventure$$game_state.hurt_timer - 1;
  }
  const player_collisions = Milky2018$selene$collision$$get_collision_infos(Milky2018$selene$examples$pixeladventure$$game_state.player);
  const _len = player_collisions.length;
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const collision = player_collisions[_i];
      const _bind$766 = moonbitlang$core$builtin$$Map$get$14$(Milky2018$selene$examples$pixeladventure$$birds, collision.entity);
      if (_bind$766 === undefined) {
      } else {
        const _Some = _bind$766;
        const _bird = _Some;
        if (Milky2018$selene$math$$Vec2D$op_get(collision.direction, 1) > 0) {
          _bird.is_hurt = true;
          const _bind$767 = moonbitlang$core$builtin$$Map$get$16$(Milky2018$selene$velocity$$velocities, Milky2018$selene$examples$pixeladventure$$game_state.player);
          if (_bind$767 === undefined) {
            $panic();
          } else {
            const _Some$2 = _bind$767;
            const _velocity = _Some$2;
            moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$velocity$$velocities, Milky2018$selene$examples$pixeladventure$$game_state.player, Milky2018$selene$math$$Vec2D$update(_velocity, 1, -340));
          }
        } else {
          Milky2018$selene$examples$pixeladventure$$hurt_player();
        }
      }
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$examples$pixeladventure$$player_state_system(delta) {
  const _p$4517 = moonbitlang$core$builtin$$Map$get$16$(Milky2018$selene$collision$$real_velocities, Milky2018$selene$examples$pixeladventure$$game_state.player);
  const _p$4518 = { _0: 0, _1: 0 };
  let velocity;
  if (_p$4517 === undefined) {
    velocity = _p$4518;
  } else {
    const _p$4519 = _p$4517;
    velocity = _p$4519;
  }
  let new_velocity_x = Milky2018$selene$math$$Vec2D$op_get(velocity, 0);
  let new_velocity_y = Milky2018$selene$math$$Vec2D$op_get(velocity, 1);
  const _bind$766 = Milky2018$selene$examples$pixeladventure$$game_state.player_state;
  let _tmp$2257;
  if (_bind$766 === 3) {
    _tmp$2257 = true;
  } else {
    _tmp$2257 = false;
  }
  if (!_tmp$2257) {
    if (Milky2018$selene$inputs$$is_pressed(28)) {
      new_velocity_x = new_velocity_x - 3600 * delta;
      if (new_velocity_x < -240) {
        new_velocity_x = -240;
      }
      Milky2018$selene$examples$pixeladventure$$game_state.direction = 0;
    } else {
      if (Milky2018$selene$inputs$$is_pressed(29)) {
        new_velocity_x = new_velocity_x + 3600 * delta;
        if (new_velocity_x > 240) {
          new_velocity_x = 240;
        }
        Milky2018$selene$examples$pixeladventure$$game_state.direction = 1;
      } else {
        new_velocity_x = 0;
      }
    }
  }
  const _bind$767 = Milky2018$selene$examples$pixeladventure$$game_state.direction;
  let transform;
  if (_bind$767 === 0) {
    transform = Milky2018$selene$math$$Transform$flip_x(32);
  } else {
    transform = Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0);
  }
  const _bind$768 = Milky2018$selene$examples$pixeladventure$$game_state.player_state;
  switch (_bind$768) {
    case 0: {
      if (Milky2018$selene$math$$Vec2D$op_get(velocity, 0) === 0) {
        Milky2018$selene$sprite$$play_animation$46$inner(Milky2018$selene$examples$pixeladventure$$game_state.player, Milky2018$selene$examples$pixeladventure$$player_idle_animation, false, -1, Option$None$0$, transform);
      } else {
        Milky2018$selene$sprite$$play_animation$46$inner(Milky2018$selene$examples$pixeladventure$$game_state.player, Milky2018$selene$examples$pixeladventure$$player_run_animation, false, -1, Option$None$0$, transform);
      }
      if (Milky2018$selene$math$$Vec2D$op_get(velocity, 1) > 0) {
        Milky2018$selene$examples$pixeladventure$$game_state.player_state = 2;
      }
      if (Milky2018$selene$inputs$$is_just_pressed(26) && Milky2018$selene$collision$$is_on_floor(Milky2018$selene$examples$pixeladventure$$game_state.player)) {
        new_velocity_y = -680;
        Milky2018$selene$examples$pixeladventure$$game_state.player_state = 1;
        if (Milky2018$selene$examples$pixeladventure$$game_state.volume_on) {
          Milky2018$selene$audio$$play_audio$46$inner("assets/sounds/jump.wav", 1, false);
        }
      }
      break;
    }
    case 2: {
      Milky2018$selene$sprite$$play_animation$46$inner(Milky2018$selene$examples$pixeladventure$$game_state.player, Milky2018$selene$examples$pixeladventure$$player_fall_animation, false, -1, Option$None$0$, transform);
      if (Milky2018$selene$collision$$is_on_floor(Milky2018$selene$examples$pixeladventure$$game_state.player)) {
        Milky2018$selene$examples$pixeladventure$$game_state.player_state = 0;
      }
      break;
    }
    case 1: {
      Milky2018$selene$sprite$$play_animation$46$inner(Milky2018$selene$examples$pixeladventure$$game_state.player, Milky2018$selene$examples$pixeladventure$$player_jump_animation, false, -1, Option$None$0$, transform);
      if (Milky2018$selene$math$$Vec2D$op_get(velocity, 1) > 0) {
        Milky2018$selene$examples$pixeladventure$$game_state.player_state = 2;
      }
      break;
    }
    default: {
      Milky2018$selene$sprite$$play_animation$46$inner(Milky2018$selene$examples$pixeladventure$$game_state.player, Milky2018$selene$examples$pixeladventure$$player_hit_animation, false, -1, Option$None$0$, transform);
      if (Milky2018$selene$collision$$is_on_floor(Milky2018$selene$examples$pixeladventure$$game_state.player)) {
        new_velocity_x = 0;
      }
      if (Milky2018$selene$sprite$$is_animation_finished(Milky2018$selene$examples$pixeladventure$$game_state.player)) {
        if (Milky2018$selene$collision$$is_on_floor(Milky2018$selene$examples$pixeladventure$$game_state.player)) {
          Milky2018$selene$examples$pixeladventure$$game_state.player_state = 0;
        } else {
          if (Milky2018$selene$math$$Vec2D$op_get(velocity, 1) < 0) {
            Milky2018$selene$examples$pixeladventure$$game_state.player_state = 2;
          } else {
            Milky2018$selene$examples$pixeladventure$$game_state.player_state = 1;
          }
        }
      }
    }
  }
  new_velocity_y = new_velocity_y + 1800 * delta;
  if (new_velocity_y > 900) {
    new_velocity_y = 900;
  }
  moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$velocity$$velocities, Milky2018$selene$examples$pixeladventure$$game_state.player, { _0: new_velocity_x, _1: new_velocity_y });
}
function Milky2018$selene$examples$pixeladventure$$tile_to_vec2d(tile, tile_size) {
  return { _0: (tile.x + 0) * (tile_size + 0), _1: (tile.y + 0) * (tile_size + 0) };
}
function Milky2018$selene$examples$pixeladventure$$set_score(score) {
  Milky2018$selene$examples$pixeladventure$$game_state.score = score;
  Milky2018$selene$examples$pixeladventure$$game_state.score_box.content = `Score: ${moonbitlang$core$int$$Int$to_string$46$inner(Milky2018$selene$examples$pixeladventure$$game_state.score, 10)}`;
}
function Milky2018$selene$examples$pixeladventure$$add_apple(pos) {
  const apple = Milky2018$selene$entity$$Entity$new();
  const apple_sprite = Milky2018$selene$sprite$$Sprite$from_animation(Milky2018$selene$sprite$$Animation$new(Milky2018$selene$sprite$$frames_from_atlas("assets/Items/Fruits/Apple.png", 17, 32, 32, undefined, Option$None$0$), Milky2018$selene$examples$pixeladventure$$add_apple$46$constr$47$4029, Milky2018$selene$examples$pixeladventure$$add_apple$46$constr$47$4030, undefined), 20, undefined);
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, apple, apple_sprite);
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, apple, pos);
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, apple, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 32, _1: 32 }, { _0: 0, _1: 0 }));
  const area = Milky2018$selene$collision$$Area$new([Milky2018$selene$examples$pixeladventure$$player_collision_layer]);
  moonbitlang$core$builtin$$Map$set$9$(Milky2018$selene$collision$$areas, apple, area);
  Milky2018$selene$collision$$Area$on_enter(area, (e) => {
    const _p$4517 = Milky2018$selene$examples$pixeladventure$$game_state.player;
    if (e === _p$4517) {
      Milky2018$selene$examples$pixeladventure$$set_score(Milky2018$selene$examples$pixeladventure$$game_state.score + 10 | 0);
      if (Milky2018$selene$examples$pixeladventure$$game_state.volume_on) {
        Milky2018$selene$audio$$play_audio$46$inner("assets/sounds/coin.wav", 1, false);
      }
      Milky2018$selene$entity$$Entity$destroy(apple);
      return;
    } else {
      return;
    }
  });
}
function Milky2018$selene$examples$pixeladventure$$add_background(size) {
  const background = Milky2018$selene$entity$$Entity$new();
  const background_sprite = Milky2018$selene$sprite$$Sprite$from_picture(Milky2018$selene$sprite$$Picture$new(size, "assets/Background/Gray.png", undefined, Milky2018$selene$examples$pixeladventure$$add_background$46$constr$47$4036), 0, undefined);
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, background, background_sprite);
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, background, { _0: 0, _1: 0 });
}
function Milky2018$selene$examples$pixeladventure$$add_bird(pos) {
  const entity = Milky2018$selene$entity$$Entity$new();
  const bird_sprite = Milky2018$selene$sprite$$Sprite$from_animation(Milky2018$selene$examples$pixeladventure$$bird_fly_animation, 10, undefined);
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, entity, bird_sprite);
  moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$velocity$$velocities, entity, { _0: 90, _1: 0 });
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, entity, pos);
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, entity, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 32, _1: 32 }, { _0: 0, _1: 0 }));
  moonbitlang$core$builtin$$Map$set$12$(Milky2018$selene$collision$$collision_layers, entity, Milky2018$selene$examples$pixeladventure$$enemy_collision_layer);
  moonbitlang$core$builtin$$Map$set$15$(Milky2018$selene$collision$$colliders, entity, Milky2018$selene$collision$$Collider$new([Milky2018$selene$examples$pixeladventure$$terrain_collision_layer]));
  moonbitlang$core$builtin$$Map$set$14$(Milky2018$selene$examples$pixeladventure$$birds, entity, { direction: 1, is_hurt: false });
}
function Milky2018$selene$examples$pixeladventure$$add_flag(pos) {
  const flag = Milky2018$selene$entity$$Entity$new();
  const flag_sprite = Milky2018$selene$sprite$$Sprite$from_animation(Milky2018$selene$sprite$$Animation$single_frame("assets/Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png", { _0: 64, _1: 64 }, undefined, undefined), 20, undefined);
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, flag, flag_sprite);
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, flag, pos);
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, flag, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 64, _1: 64 }, { _0: 0, _1: 0 }));
  const area = Milky2018$selene$collision$$Area$new([Milky2018$selene$examples$pixeladventure$$player_collision_layer]);
  moonbitlang$core$builtin$$Map$set$9$(Milky2018$selene$collision$$areas, flag, area);
  Milky2018$selene$collision$$Area$on_enter(area, (e) => {
    const _p$4517 = Milky2018$selene$examples$pixeladventure$$game_state.player;
    if (e === _p$4517) {
      Milky2018$selene$examples$pixeladventure$$set_score(Milky2018$selene$examples$pixeladventure$$game_state.score + 100 | 0);
      Milky2018$selene$examples$pixeladventure$$set_game_result(0);
      Milky2018$selene$entity$$Entity$destroy(flag);
      return;
    } else {
      return;
    }
  });
}
function Milky2018$selene$examples$pixeladventure$$add_grass(pos, sprite_id) {
  let src_pos;
  switch (sprite_id) {
    case "15": {
      src_pos = { _0: 96, _1: 0 };
      break;
    }
    case "9": {
      src_pos = { _0: 112, _1: 0 };
      break;
    }
    case "16": {
      src_pos = { _0: 128, _1: 0 };
      break;
    }
    case "11": {
      src_pos = { _0: 96, _1: 16 };
      break;
    }
    case "13": {
      src_pos = { _0: 112, _1: 16 };
      break;
    }
    case "10": {
      src_pos = { _0: 128, _1: 16 };
      break;
    }
    case "14": {
      src_pos = { _0: 96, _1: 32 };
      break;
    }
    case "8": {
      src_pos = { _0: 112, _1: 32 };
      break;
    }
    case "12": {
      src_pos = { _0: 128, _1: 32 };
      break;
    }
    default: {
      src_pos = $panic();
    }
  }
  const sprite = Milky2018$selene$sprite$$Sprite$from_animation(Milky2018$selene$sprite$$Animation$single_frame("assets/Terrain/Terrain (16x16).png", { _0: 16, _1: 16 }, undefined, src_pos), 10, undefined);
  const grass = Milky2018$selene$entity$$Entity$new();
  moonbitlang$core$builtin$$Map$set$4$(Milky2018$selene$sprite$$sprites, grass, sprite);
  moonbitlang$core$builtin$$Map$set$0$(Milky2018$selene$position$$positions, grass, pos);
  moonbitlang$core$builtin$$Map$set$5$(Milky2018$selene$collision$$shapes, grass, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 16, _1: 16 }, { _0: 0, _1: 0 }));
  moonbitlang$core$builtin$$Map$set$12$(Milky2018$selene$collision$$collision_layers, grass, Milky2018$selene$examples$pixeladventure$$terrain_collision_layer);
}
function Milky2018$selene$examples$pixeladventure$$generate_map() {
  const tilemap = Milky2018$selene$tilemap$$TileMap$from_json(Milky2018$selene$examples$pixeladventure$$tilemap);
  const world_width = (tilemap.map_width + 0) * (tilemap.tile_size + 0);
  const world_height = (tilemap.map_height + 0) * (tilemap.tile_size + 0);
  Milky2018$selene$camera$$set_limits(Milky2018$selene$examples$pixeladventure$$generate_map$46$constr$47$4053, new Option$Some$0$(world_height), Milky2018$selene$examples$pixeladventure$$generate_map$46$constr$47$4054, new Option$Some$0$(world_width));
  Milky2018$selene$examples$pixeladventure$$add_background({ _0: world_width, _1: world_height });
  const mask_dude = moonbitlang$core$array$$Array$at$33$(Milky2018$selene$tilemap$$TileMap$get_tiles_first(tilemap, "MaskDude"), 0);
  Milky2018$selene$examples$pixeladventure$$add_player(Milky2018$selene$examples$pixeladventure$$tile_to_vec2d(mask_dude, tilemap.tile_size));
  const flag = moonbitlang$core$array$$Array$at$33$(Milky2018$selene$tilemap$$TileMap$get_tiles_first(tilemap, "Flag"), 0);
  const _p$4517 = Milky2018$selene$examples$pixeladventure$$tile_to_vec2d(flag, tilemap.tile_size);
  const _p$4518 = { _0: 16, _1: 16 };
  Milky2018$selene$examples$pixeladventure$$add_flag({ _0: _p$4517._0 - _p$4518._0, _1: _p$4517._1 - _p$4518._1 });
  const apples = Milky2018$selene$tilemap$$TileMap$get_tiles_first(tilemap, "Apple");
  const _len = apples.length;
  let _tmp$2257 = 0;
  while (true) {
    const _i = _tmp$2257;
    if (_i < _len) {
      const apple = apples[_i];
      Milky2018$selene$examples$pixeladventure$$add_apple(Milky2018$selene$examples$pixeladventure$$tile_to_vec2d(apple, tilemap.tile_size));
      _tmp$2257 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const grasses = Milky2018$selene$tilemap$$TileMap$get_tiles(tilemap, "Grass");
  const _len$2 = grasses.length;
  let _tmp$2258 = 0;
  while (true) {
    const _i = _tmp$2258;
    if (_i < _len$2) {
      const grass = grasses[_i];
      Milky2018$selene$examples$pixeladventure$$add_grass(Milky2018$selene$examples$pixeladventure$$tile_to_vec2d(grass, tilemap.tile_size), grass.id);
      _tmp$2258 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const birds = Milky2018$selene$tilemap$$TileMap$get_tiles_first(tilemap, "Bird");
  const _len$3 = birds.length;
  let _tmp$2259 = 0;
  while (true) {
    const _i = _tmp$2259;
    if (_i < _len$3) {
      const bird = birds[_i];
      Milky2018$selene$examples$pixeladventure$$add_bird(Milky2018$selene$examples$pixeladventure$$tile_to_vec2d(bird, tilemap.tile_size));
      _tmp$2259 = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function Milky2018$selene$examples$pixeladventure$$bird_ai_system(_discard_) {
  const _it = moonbitlang$core$builtin$$Map$iterator2$14$(Milky2018$selene$examples$pixeladventure$$birds);
  while (true) {
    const _bind$766 = moonbitlang$core$builtin$$Iterator2$next$14$(_it);
    if (_bind$766 === undefined) {
      return;
    } else {
      const _Some = _bind$766;
      const _x = _Some;
      const _e = _x._0;
      const _bird = _x._1;
      if (Milky2018$selene$entity$$Entity$is_alive(_e)) {
        const _bind$767 = moonbitlang$core$builtin$$Map$get$16$(Milky2018$selene$velocity$$velocities, _e);
        if (_bind$767 === undefined) {
          $panic();
        } else {
          if (Milky2018$selene$sprite$$is_animation_finished(_e)) {
            Milky2018$selene$entity$$Entity$destroy(_e);
            continue;
          }
          if (_bird.is_hurt) {
            moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$velocity$$velocities, _e, { _0: 0, _1: 0 });
            moonbitlang$core$builtin$$Map$remove$12$(Milky2018$selene$collision$$collision_layers, _e);
            const _bind$768 = _bird.direction;
            if (_bind$768 === 0) {
              Milky2018$selene$sprite$$play_animation$46$inner(_e, Milky2018$selene$examples$pixeladventure$$bird_hit_animation, false, -1, Option$None$0$, Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0));
            } else {
              Milky2018$selene$sprite$$play_animation$46$inner(_e, Milky2018$selene$examples$pixeladventure$$bird_hit_animation, false, -1, Option$None$0$, Milky2018$selene$math$$Transform$flip_x(32));
            }
            continue;
          }
          const collision_infos = Milky2018$selene$collision$$get_collision_infos(_e);
          const hit_wall = moonbitlang$core$builtin$$Iter$any$45$(moonbitlang$core$array$$Array$iter$45$(collision_infos), (info) => {
            _L: {
              if (Milky2018$selene$math$$Vec2D$op_get(info.direction, 0) > 0) {
                const _bind$768 = _bird.direction;
                if (_bind$768 === 1) {
                  return true;
                } else {
                  break _L;
                }
              } else {
                break _L;
              }
            }
            if (Milky2018$selene$math$$Vec2D$op_get(info.direction, 0) < 0) {
              const _bind$768 = _bird.direction;
              let _tmp$2257;
              if (_bind$768 === 0) {
                _tmp$2257 = true;
              } else {
                _tmp$2257 = false;
              }
              return _tmp$2257;
            } else {
              return false;
            }
          });
          if (hit_wall) {
            const _bind$768 = _bird.direction;
            let _tmp$2257;
            if (_bind$768 === 0) {
              _tmp$2257 = 1;
            } else {
              _tmp$2257 = 0;
            }
            _bird.direction = _tmp$2257;
          }
          const _bind$768 = _bird.direction;
          if (_bind$768 === 0) {
            moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$velocity$$velocities, _e, { _0: -90, _1: 0 });
            Milky2018$selene$sprite$$play_animation$46$inner(_e, Milky2018$selene$examples$pixeladventure$$bird_fly_animation, false, -1, Option$None$0$, Milky2018$selene$math$$Transform$new$46$inner(1, 0, 0, 1, 0, 0));
          } else {
            moonbitlang$core$builtin$$Map$set$16$(Milky2018$selene$velocity$$velocities, _e, { _0: 90, _1: 0 });
            Milky2018$selene$sprite$$play_animation$46$inner(_e, Milky2018$selene$examples$pixeladventure$$bird_fly_animation, false, -1, Option$None$0$, Milky2018$selene$math$$Transform$flip_x(32));
          }
        }
      } else {
        continue;
      }
      continue;
    }
  }
}
function Milky2018$selene$examples$pixeladventure$$game_start(_delta) {
  Milky2018$selene$backend$$load_font("ThaleahFat", "assets/Fonts/ThaleahFat.ttf");
  Milky2018$selene$examples$pixeladventure$$generate_map();
  Milky2018$selene$examples$pixeladventure$$add_result_box();
  Milky2018$selene$examples$pixeladventure$$add_score_box();
  Milky2018$selene$examples$pixeladventure$$add_health_box();
  Milky2018$selene$examples$pixeladventure$$add_volume_button();
}
(() => {
  Milky2018$selene$system$$App$run(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system(Milky2018$selene$system$$App$add_system$46$inner(Milky2018$selene$system$$App$add_plugin(Milky2018$selene$system$$App$with_fps(Milky2018$selene$system$$App$with_zoom(Milky2018$selene$system$$App$with_image_smooth(Milky2018$selene$system$$App$with_canvas_height(Milky2018$selene$system$$App$with_canvas_width(Milky2018$selene$system$$App$new(), 960), 640), false), 2), 60), Milky2018$selene$plugins$$default_plugin), Milky2018$selene$examples$pixeladventure$$game_start, $64$Milky2018$47$selene$47$system$46$Schedule$Startup, undefined), Milky2018$selene$examples$pixeladventure$$player_state_system, undefined, undefined), Milky2018$selene$examples$pixeladventure$$player_collision_system, undefined, undefined), Milky2018$selene$examples$pixeladventure$$bird_ai_system, undefined, undefined));
})();
