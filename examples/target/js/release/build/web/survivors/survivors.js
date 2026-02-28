const $_1L = { hi: -1, lo: -1 };
const $1000000000000000000L = { hi: 232830643, lo: -1486618624 };
const $0L = { hi: 0, lo: 0 };
const $1L = { hi: 0, lo: 1 };
const $10L = { hi: 0, lo: 10 };
const $100L = { hi: 0, lo: 100 };
const $1000L = { hi: 0, lo: 1000 };
const $10000L = { hi: 0, lo: 10000 };
const $100000L = { hi: 0, lo: 100000 };
const $1000000L = { hi: 0, lo: 1000000 };
const $10000000L = { hi: 0, lo: 10000000 };
const $100000000L = { hi: 0, lo: 100000000 };
const $1000000000L = { hi: 0, lo: 1000000000 };
const $10000000000L = { hi: 2, lo: 1410065408 };
const $100000000000L = { hi: 23, lo: 1215752192 };
const $1000000000000L = { hi: 232, lo: -727379968 };
const $10000000000000L = { hi: 2328, lo: 1316134912 };
const $100000000000000L = { hi: 23283, lo: 276447232 };
const $1000000000000000L = { hi: 232830, lo: -1530494976 };
const $22L = { hi: 0, lo: 22 };
const $37L = { hi: 0, lo: 37 };
const $_22L = { hi: -1, lo: -22 };
function $64$Milky2018$47$selene$47$style$46$SizePlan$Sized(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$style$46$SizePlan$Sized.prototype.$tag = 0;
const $64$Milky2018$47$selene$47$style$46$SizePlan$FromSprite = { $tag: 1 };
const Option$None$0$ = { $tag: 0 };
function Option$Some$0$(param0) {
  this._0 = param0;
}
Option$Some$0$.prototype.$tag = 1;
const Option$None$1$ = { $tag: 0 };
function Option$Some$1$(param0) {
  this._0 = param0;
}
Option$Some$1$.prototype.$tag = 1;
const $_4503599627370496L = { hi: -1048576, lo: 0 };
const $9221120237041090561L = { hi: 2146959360, lo: 1 };
const $9218868437227405312L = { hi: 2146435072, lo: 0 };
const $2L = { hi: 0, lo: 2 };
const $64$Milky2018$47$selene$47$system$46$Schedule$Startup = { $tag: 0 };
const $64$Milky2018$47$selene$47$system$46$Schedule$Update = { $tag: 1 };
function $64$Milky2018$47$selene$47$system$46$Schedule$Render(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$system$46$Schedule$Render.prototype.$tag = 2;
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
function $bound_check(arr, index) {
  if (index < 0 || index >= arr.length) throw new Error("Index out of bounds");
}
function $compare_int(a, b) {
  return (a >= b) - (a <= b);
}
const _M0FP311moonbitlang4core7builtin12random__seed = () => {
  if (globalThis.crypto?.getRandomValues) {
    const array = new Uint32Array(1);
    globalThis.crypto.getRandomValues(array);
    return array[0] | 0; // Convert to signed 32
  } else {
    return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
  }
};
function Result$Err$2$(param0) {
  this._0 = param0;
}
Result$Err$2$.prototype.$tag = 0;
function Result$Ok$2$(param0) {
  this._0 = param0;
}
Result$Ok$2$.prototype.$tag = 1;
function Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(param0) {
  this._0 = param0;
}
Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError.prototype.$tag = 2;
const Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$IndexOutOfBounds = { $tag: 1 };
const Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex = { $tag: 0 };
const _M0FP311moonbitlang4core7builtin19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
function $makebytes(a, b) {
  const arr = new Uint8Array(a);
  if (b !== 0) {
    arr.fill(b);
  }
  return arr;
}
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
const _M0MP311moonbitlang4core7builtin7JSArray4push = (arr, val) => { arr.push(val); };
const Option$None$3$ = { $tag: 0 };
function Option$Some$3$(param0) {
  this._0 = param0;
}
Option$Some$3$.prototype.$tag = 1;
const Option$None$4$ = { $tag: 0 };
function Option$Some$4$(param0) {
  this._0 = param0;
}
Option$Some$4$.prototype.$tag = 1;
const _M0MP311moonbitlang4core7builtin7MyInt6422convert__to__double__u = (a) => (a.hi >>> 0) * 4294967296.0 + (a.lo >>> 0);
const _M0MP311moonbitlang4core7builtin7MyInt6423reinterpret__as__double = function f(a) {
  let view = f._view;
  if (view === undefined) {
    view = f._view = new DataView(new ArrayBuffer(8));
  }
  view.setUint32(0, a.hi);
  view.setUint32(4, a.lo);
  return view.getFloat64(0);
};
const _M0FP311moonbitlang4core7builtin23try__init__wasm__helper = function() {
  try {
    return new WebAssembly.Instance(new WebAssembly.Module(new Uint8Array([0, 97, 115, 109, 1, 0, 0, 0, 1, 13, 2, 96, 0, 1, 127, 96, 4, 127, 127, 127, 127, 1, 127, 3, 7, 6, 0, 1, 1, 1, 1, 1, 6, 6, 1, 127, 1, 65, 0, 11, 7, 50, 6, 3, 109, 117, 108, 0, 1, 5, 100, 105, 118, 95, 115, 0, 2, 5, 100, 105, 118, 95, 117, 0, 3, 5, 114, 101, 109, 95, 115, 0, 4, 5, 114, 101, 109, 95, 117, 0, 5, 8, 103, 101, 116, 95, 104, 105, 103, 104, 0, 0, 10, 191, 1, 6, 4, 0, 35, 0, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 126, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 127, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 128, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 129, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 130, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11])), {}).exports;
  } catch (e) {
    return undefined;
  }
};
const _M0MP311moonbitlang4core7builtin7MyInt6411div__bigint = (a, b) => {
  const aVal = (BigInt(a.hi) << 32n) | BigInt(a.lo >>> 0);
  const bVal = (BigInt(b.hi) << 32n) | BigInt(b.lo >>> 0);
  const result = aVal / bVal;
  const lo = Number(result & 0xFFFFFFFFn);
  const hi = Number((result >> 32n) & 0xFFFFFFFFn);
  return { hi: hi | 0, lo: lo | 0 };
};
const _M0MP311moonbitlang4core7builtin7MyInt6414div__u__bigint = (a, b) => {
  const aVal = (BigInt(a.hi >>> 0) << 32n) | BigInt(a.lo >>> 0);
  const bVal = (BigInt(b.hi >>> 0) << 32n) | BigInt(b.lo >>> 0);
  const result = aVal / bVal;
  const lo = Number(result & 0xFFFFFFFFn);
  const hi = Number((result >> 32n) & 0xFFFFFFFFn);
  return { hi: hi | 0, lo: lo | 0 };
};
const _M0MP311moonbitlang4core7builtin7MyInt6414mod__u__bigint = (a, b) => {
  const aVal = (BigInt(a.hi >>> 0) << 32n) | BigInt(a.lo >>> 0);
  const bVal = (BigInt(b.hi >>> 0) << 32n) | BigInt(b.lo >>> 0);
  const result = aVal % bVal;
  const lo = Number(result & 0xFFFFFFFFn);
  const hi = Number((result >> 32n) & 0xFFFFFFFFn);
  return { hi: hi | 0, lo: lo | 0 };
};
const _M0MP311moonbitlang4core7builtin7MyInt647compare = (a, b) => {
  const ahi = a.hi;
  const bhi = b.hi;
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
const _M0MP311moonbitlang4core7builtin7MyInt6410compare__u = (a, b) => {
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
const _M0FP311moonbitlang4core7builtin15ryu__to__string = (number) => number.toString();
const _M0MP311moonbitlang4core7builtin7JSArray11set__length = (arr, len) => { arr.length = len; };
const _M0MP311moonbitlang4core7builtin7JSArray3pop = (arr) => arr.pop();
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
function Result$Err$7$(param0) {
  this._0 = param0;
}
Result$Err$7$.prototype.$tag = 0;
function Result$Ok$7$(param0) {
  this._0 = param0;
}
Result$Ok$7$.prototype.$tag = 1;
function Result$Err$8$(param0) {
  this._0 = param0;
}
Result$Err$8$.prototype.$tag = 0;
function Result$Ok$8$(param0) {
  this._0 = param0;
}
Result$Ok$8$.prototype.$tag = 1;
function Result$Err$9$(param0) {
  this._0 = param0;
}
Result$Err$9$.prototype.$tag = 0;
function Result$Ok$9$(param0) {
  this._0 = param0;
}
Result$Ok$9$.prototype.$tag = 1;
function Result$Err$10$(param0) {
  this._0 = param0;
}
Result$Err$10$.prototype.$tag = 0;
function Result$Ok$10$(param0) {
  this._0 = param0;
}
Result$Ok$10$.prototype.$tag = 1;
function Result$Err$11$(param0) {
  this._0 = param0;
}
Result$Err$11$.prototype.$tag = 0;
function Result$Ok$11$(param0) {
  this._0 = param0;
}
Result$Ok$11$.prototype.$tag = 1;
function Result$Err$12$(param0) {
  this._0 = param0;
}
Result$Err$12$.prototype.$tag = 0;
function Result$Ok$12$(param0) {
  this._0 = param0;
}
Result$Ok$12$.prototype.$tag = 1;
function Result$Err$13$(param0) {
  this._0 = param0;
}
Result$Err$13$.prototype.$tag = 0;
function Result$Ok$13$(param0) {
  this._0 = param0;
}
Result$Ok$13$.prototype.$tag = 1;
const $16L = { hi: 0, lo: 16 };
function Result$Err$14$(param0) {
  this._0 = param0;
}
Result$Err$14$.prototype.$tag = 0;
function Result$Ok$14$(param0) {
  this._0 = param0;
}
Result$Ok$14$.prototype.$tag = 1;
const $9223372036854775807L = { hi: 2147483647, lo: -1 };
const $_9223372036854775808L = { hi: -2147483648, lo: 0 };
const $65536L = { hi: 0, lo: 65536 };
const $64$moonbitlang$47$core$47$list$46$List$Empty$15$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$list$46$List$More$15$(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$list$46$List$More$15$.prototype.$tag = 1;
const $bytes_literal$0 = new Uint8Array([65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,49,50,51,52,53,54]);
const $4294967295L = { hi: 0, lo: -1 };
const _M0MP36rami3l8js_2dffi2js5Value9undefined = () => undefined;
const _M0MP36rami3l8js_2dffi2js5Value8is__null = (n) => Object.is(n, null);
const Option$None$16$ = { $tag: 0 };
function Option$Some$16$(param0) {
  this._0 = param0;
}
Option$Some$16$.prototype.$tag = 1;
const Option$None$17$ = { $tag: 0 };
function Option$Some$17$(param0) {
  this._0 = param0;
}
Option$Some$17$.prototype.$tag = 1;
const Option$None$18$ = { $tag: 0 };
function Option$Some$18$(param0) {
  this._0 = param0;
}
Option$Some$18$.prototype.$tag = 1;
const Option$None$19$ = { $tag: 0 };
function Option$Some$19$(param0) {
  this._0 = param0;
}
Option$Some$19$.prototype.$tag = 1;
const _M0MP37Yoorkin12rabbit_2dtea3dom6Window25request__animation__frame = (self,f) => self.requestAnimationFrame(f);
const _M0MP37Yoorkin12rabbit_2dtea3dom6Window24cancel__animation__frame = (self,id) => self.cancelAnimationFrame(id);
const _M0FP37Yoorkin12rabbit_2dtea3dom6window = () => window;
const _M0FP37Yoorkin12rabbit_2dtea3dom21ffi__to__mouse__event = (e) => e instanceof MouseEvent ? e : null;
const _M0FP37Yoorkin12rabbit_2dtea3dom25ffi__mouse__event__button = (e) => e.button;
const _M0FP37Yoorkin12rabbit_2dtea3dom30ffi__mouse__event__movement__x = (e) => e.movementX;
const _M0FP37Yoorkin12rabbit_2dtea3dom30ffi__mouse__event__movement__y = (e) => e.movementY;
const _M0FP37Yoorkin12rabbit_2dtea3dom28ffi__mouse__event__offset__x = (e) => e.offsetX;
const _M0FP37Yoorkin12rabbit_2dtea3dom28ffi__mouse__event__offset__y = (e) => e.offsetY;
const _M0FP37Yoorkin12rabbit_2dtea3dom24ffi__to__keyboard__event = (e) => e instanceof KeyboardEvent ? e : null;
const _M0MP37Yoorkin12rabbit_2dtea3dom13KeyboardEvent4code = (e) => e.code;
const _M0MP37Yoorkin12rabbit_2dtea3dom16HTMLImageElement3new = () => new Image();
const _M0MP37Yoorkin12rabbit_2dtea3dom16HTMLImageElement8set__src = (self, value) => self.src = value;
const _M0FP37Yoorkin12rabbit_2dtea3dom30ffi__to__html__canvas__element = (x) => x instanceof HTMLCanvasElement ? x : null;
const _M0MP37Yoorkin12rabbit_2dtea3dom17HTMLCanvasElement12get__context = (x, id) => x.getContext(id);
const _M0FP37Yoorkin12rabbit_2dtea3dom25ffi__add__event__listener = (target, type, listener) => target.addEventListener(type, listener);
const _M0FP37Yoorkin12rabbit_2dtea3dom43checked__to__canvas__rendering__context__2d = (value) => value instanceof CanvasRenderingContext2D ? value : null;
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D4save = (x) => x.save();
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D7restore = (x) => x.restore();
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D5scale = (self,x,y) => self.scale(x,y);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D9translate = (self,x,y) => self.translate(x,y);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D9transform = (self,a,b,c,d,e,f) => self.transform(a,b,c,d,e,f);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D18set__stroke__style = (x,value) => x.strokeStyle = value;
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D16set__fill__style = (x,value) => x.fillStyle = value;
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D15create__pattern = (self,image,repetition) => self.createPattern(image,repetition);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D11clear__rect = (self,x,y,w,h) => self.clearRect(x,y,w,h);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D10fill__rect = (self,x,y,w,h) => self.fillRect(x,y,w,h);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D12stroke__rect = (self,x,y,w,h) => self.strokeRect(x,y,w,h);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D12fill_2einner = (self, fillRule) => self.fill(fillRule);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D6stroke = (self) => self.stroke();
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D18fill__text_2einner = (self,text,x,y,maxWidth) => self.fillText(text,x,y,maxWidth);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D38draw__image__with__src__and__dst__size = (self,image,sx,sy,sw,sh,dx,dy,dw,dh) => self.drawImage(image,sx,sy,sw,sh,dx,dy,dw,dh);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D11arc_2einner = (self,x,y,radius,startAngle,endAngle,anticlockwise) => self.arc(x,y,radius,startAngle,endAngle,anticlockwise);
const _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D9set__font = (self,value) => self.font = value;
const _M0FP37Yoorkin12rabbit_2dtea3dom8document = () => document;
const _M0MP37Yoorkin12rabbit_2dtea3dom8Document20get__element__by__id = (doc,id) => doc.getElementById(id);
const _M0FP39Milky20186selene7backend21set__viewport__height = (x, y) => { x.height = y; };
const _M0FP39Milky20186selene7backend20set__viewport__width = (x, y) => { x.width = y; };
const _M0FP39Milky20186selene7backend30set__image__smoothing__enabled = (ctx, value) => ctx.imageSmoothingEnabled = value;;
const _M0FP39Milky20186selene7backend16set__text__align = (ctx, value) => ctx.textAlign = value;;
const _M0FP39Milky20186selene7backend19set__text__baseline = (ctx, value) => ctx.textBaseline = value;;
const _M0FP39Milky20186selene7backend17load__font__async = (font, path) => {
   const ff = new FontFace(font, 'url(' + path + ')');
   ff.load().then(loadedFont => {
     document.fonts.add(loadedFont);
   })
 };
const _M0FP39Milky20186selene7backend11begin__path = (ctx) => ctx.beginPath();;
const Option$None$20$ = { $tag: 0 };
function Option$Some$20$(param0) {
  this._0 = param0;
}
Option$Some$20$.prototype.$tag = 1;
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
function $64$Milky2018$47$selene$47$sprite$46$SpriteType$ColorCircle(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$47$sprite$46$SpriteType$ColorCircle.prototype.$tag = 4;
function $64$Milky2018$47$selene$45$examples$47$survivors$46$LevelUpSelection$PowerupSelection(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$45$examples$47$survivors$46$LevelUpSelection$PowerupSelection.prototype.$tag = 0;
function $64$Milky2018$47$selene$45$examples$47$survivors$46$LevelUpSelection$WeaponSelection(param0) {
  this._0 = param0;
}
$64$Milky2018$47$selene$45$examples$47$survivors$46$LevelUpSelection$WeaponSelection.prototype.$tag = 1;
function $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect.prototype.$tag = 0;
const _M0FP095_40moonbitlang_2fcore_2fbuiltin_2eStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger13write__string, method_1: _M0IP016_24default__implP311moonbitlang4core7builtin6Logger16write__substringGRP311moonbitlang4core7builtin13StringBuilderE, method_2: _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view, method_3: _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__char };
const _M0FP0115_40moonbitlang_2fcore_2frandom_2finternal_2frandom__source_2eChaCha8_24as_24_40moonbitlang_2fcore_2frandom_2eSource = { method_0: _M0IP511moonbitlang4core6random8internal14random__source7ChaCha8P311moonbitlang4core6random6Source4next };
const _M0FP311moonbitlang4core7builtin21trim_2e_2abind_7c6188 = "\t\n\r ";
const _M0FP311moonbitlang4core7builtin21trim_2e_2abind_7c6194 = "\t\n\r ";
const _M0FP311moonbitlang4core7builtin19wasm__helper__cache = { tried: false, exports: undefined };
const _M0FP311moonbitlang4core6uint6410max__value = $_1L;
const _M0FP311moonbitlang4core7strconv14base__err__str = "invalid base";
const _M0FP311moonbitlang4core7strconv15range__err__str = "value out of range";
const _M0FP311moonbitlang4core7strconv16syntax__err__str = "invalid syntax";
const _M0FP311moonbitlang4core7strconv37parse__uint64_2einner_2e_2abind_7c454 = "";
const _M0FP311moonbitlang4core7strconv36parse__int64_2einner_2e_2abind_7c603 = "";
const _M0FP311moonbitlang4core7strconv17min__19digit__int = $1000000000000000000L;
const _M0FP311moonbitlang4core7strconv34parse__scientific_2eexp__num_7c279 = $0L;
const _M0FP311moonbitlang4core7strconv33parse__number_2eexp__number_7c260 = $0L;
const _M0FP311moonbitlang4core7strconv12double__info = { mantissa_bits: 52, exponent_bits: 11, bias: -1023 };
const _M0FP311moonbitlang4core7strconv6powtab = [1, 3, 6, 9, 13, 16, 19, 23, 26, 29, 33, 36, 39, 43, 46, 49, 53, 56, 59];
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2473 = { _0: 0, _1: "" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2474 = { _0: 1, _1: "5" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2475 = { _0: 1, _1: "25" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2476 = { _0: 1, _1: "125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2477 = { _0: 2, _1: "625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2478 = { _0: 2, _1: "3125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2479 = { _0: 2, _1: "15625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2480 = { _0: 3, _1: "78125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2481 = { _0: 3, _1: "390625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2482 = { _0: 3, _1: "1953125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2483 = { _0: 4, _1: "9765625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2484 = { _0: 4, _1: "48828125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2485 = { _0: 4, _1: "244140625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2486 = { _0: 4, _1: "1220703125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2487 = { _0: 5, _1: "6103515625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2488 = { _0: 5, _1: "30517578125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2489 = { _0: 5, _1: "152587890625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2490 = { _0: 6, _1: "762939453125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2491 = { _0: 6, _1: "3814697265625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2492 = { _0: 6, _1: "19073486328125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2493 = { _0: 7, _1: "95367431640625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2494 = { _0: 7, _1: "476837158203125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2495 = { _0: 7, _1: "2384185791015625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2496 = { _0: 7, _1: "11920928955078125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2497 = { _0: 8, _1: "59604644775390625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2498 = { _0: 8, _1: "298023223876953125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2499 = { _0: 8, _1: "1490116119384765625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2500 = { _0: 9, _1: "7450580596923828125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2501 = { _0: 9, _1: "37252902984619140625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2502 = { _0: 9, _1: "186264514923095703125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2503 = { _0: 10, _1: "931322574615478515625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2504 = { _0: 10, _1: "4656612873077392578125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2505 = { _0: 10, _1: "23283064365386962890625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2506 = { _0: 10, _1: "116415321826934814453125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2507 = { _0: 11, _1: "582076609134674072265625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2508 = { _0: 11, _1: "2910383045673370361328125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2509 = { _0: 11, _1: "14551915228366851806640625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2510 = { _0: 12, _1: "72759576141834259033203125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2511 = { _0: 12, _1: "363797880709171295166015625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2512 = { _0: 12, _1: "1818989403545856475830078125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2513 = { _0: 13, _1: "9094947017729282379150390625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2514 = { _0: 13, _1: "45474735088646411895751953125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2515 = { _0: 13, _1: "227373675443232059478759765625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2516 = { _0: 13, _1: "1136868377216160297393798828125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2517 = { _0: 14, _1: "5684341886080801486968994140625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2518 = { _0: 14, _1: "28421709430404007434844970703125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2519 = { _0: 14, _1: "142108547152020037174224853515625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2520 = { _0: 15, _1: "710542735760100185871124267578125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2521 = { _0: 15, _1: "3552713678800500929355621337890625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2522 = { _0: 15, _1: "17763568394002504646778106689453125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2523 = { _0: 16, _1: "88817841970012523233890533447265625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2524 = { _0: 16, _1: "444089209850062616169452667236328125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2525 = { _0: 16, _1: "2220446049250313080847263336181640625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2526 = { _0: 16, _1: "11102230246251565404236316680908203125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2527 = { _0: 17, _1: "55511151231257827021181583404541015625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2528 = { _0: 17, _1: "277555756156289135105907917022705078125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2529 = { _0: 17, _1: "1387778780781445675529539585113525390625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2530 = { _0: 18, _1: "6938893903907228377647697925567626953125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2531 = { _0: 18, _1: "34694469519536141888238489627838134765625" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2532 = { _0: 18, _1: "173472347597680709441192448139190673828125" };
const _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2533 = { _0: 19, _1: "867361737988403547205962240695953369140625" };
const _M0FP311moonbitlang4core7strconv19left__shift__cheats = [_M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2473, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2474, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2475, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2476, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2477, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2478, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2479, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2480, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2481, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2482, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2483, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2484, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2485, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2486, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2487, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2488, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2489, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2490, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2491, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2492, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2493, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2494, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2495, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2496, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2497, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2498, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2499, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2500, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2501, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2502, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2503, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2504, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2505, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2506, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2507, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2508, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2509, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2510, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2511, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2512, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2513, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2514, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2515, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2516, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2517, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2518, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2519, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2520, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2521, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2522, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2523, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2524, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2525, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2526, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2527, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2528, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2529, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2530, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2531, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2532, _M0FP311moonbitlang4core7strconv34left__shift__cheats_2etuple_2f2533];
const _M0FP311moonbitlang4core7strconv10int__pow10 = [$1L, $10L, $100L, $1000L, $10000L, $100000L, $1000000L, $10000000L, $100000000L, $1000000000L, $10000000000L, $100000000000L, $1000000000000L, $10000000000000L, $100000000000000L, $1000000000000000L];
const _M0FP311moonbitlang4core7strconv25max__exponent__fast__path = $22L;
const _M0FP311moonbitlang4core7strconv5table = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000, 1e+12, 1e+13, 1e+14, 1e+15, 1e+16, 1e+17, 1e+18, 1e+19, 1e+20, 1e+21, 1e+22, 0, 0, 0, 0, 0, 0, 0, 0, 0];
const _M0FP311moonbitlang4core7strconv36max__exponent__disguised__fast__path = $37L;
const _M0FP311moonbitlang4core7strconv25min__exponent__fast__path = $_22L;
const _M0FP39Milky20186selene6inputs5mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const _M0FP39Milky20186selene6inputs15mouse__movement = { movement: { _0: 0, _1: 0 } };
const _M0FP39Milky20186selene6inputs11last__mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const _M0FP39Milky20186selene6inputs20just__pressed__mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const _M0FP39Milky20186selene6inputs20just__release__mouse = { pos: { _0: 0, _1: 0 }, left_button: false, right_button: false, middle_button: false };
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3443 = 0;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3444 = 1;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3445 = 2;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3446 = 3;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3447 = 4;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3448 = 5;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3449 = 6;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3450 = 7;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3451 = 8;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3452 = 9;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3453 = 10;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3454 = 11;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3455 = 12;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3456 = 13;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3457 = 14;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3458 = 15;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3459 = 16;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3460 = 17;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3461 = 18;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3462 = 19;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3463 = 20;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3464 = 21;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3465 = 22;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3466 = 23;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3467 = 24;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3468 = 26;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3469 = 27;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3470 = 28;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3471 = 29;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3472 = 30;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3473 = 31;
const _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3474 = 32;
const _M0FP39Milky20186selene6entity17entity__generator = { val: 0 };
const _M0FP39Milky20186selene9collision27collision__layer__generator = { val: 0 };
const _M0FP39Milky20186selene6sprite32parse__rgb__body_2e_2abind_7c352 = ",";
const _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c373 = "rgba(";
const _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c374 = ")";
const _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c375 = "rgb(";
const _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c376 = ")";
const _M0FP39Milky20186selene6sprite28parse__color_2e_2abind_7c377 = "#";
const _M0FP39Milky20186selene6sprite28parse__color_2e_2abind_7c383 = "rgb(";
const _M0FP39Milky20186selene6sprite28parse__color_2e_2abind_7c384 = "rgba(";
const _M0FP39Milky20186selene6sprite27parse__font_2e_2abind_7c412 = "px";
const _M0FP39Milky201817selene_2dexamples9survivors14weapon__timers = [];
const _M0FP39Milky201817selene_2dexamples9survivors11wave__state = { creeper_spawned: 0, icecream_spawned: 0, orc_spawned: 0, skull_spawned: 0, teleman_spawned: 0, devil_spawned: 0, pirate_spawned: 0 };
const _M0FP39Milky201817selene_2dexamples9survivors19background__picture = "assets/tilesets/grass.png";
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4594 = { creeper_count: 40, icecream_count: 20, orc_count: 0, skull_count: 0, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 1 };
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4595 = { creeper_count: 30, icecream_count: 0, orc_count: 30, skull_count: 0, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 1 };
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4596 = { creeper_count: 0, icecream_count: 120, orc_count: 0, skull_count: 0, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 0.5 };
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4597 = { creeper_count: 60, icecream_count: 0, orc_count: 0, skull_count: 60, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 0.5 };
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4598 = { creeper_count: 0, icecream_count: 0, orc_count: 90, skull_count: 90, teleman_count: 0, devil_count: 0, pirate_count: 0, spawn_interval: 0.333 };
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4599 = { creeper_count: 0, icecream_count: 0, orc_count: 56, skull_count: 0, teleman_count: 4, devil_count: 0, pirate_count: 0, spawn_interval: 1 };
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4600 = { creeper_count: 0, icecream_count: 60, orc_count: 0, skull_count: 0, teleman_count: 0, devil_count: 60, pirate_count: 0, spawn_interval: 0.5 };
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4601 = { creeper_count: 0, icecream_count: 0, orc_count: 40, skull_count: 0, teleman_count: 40, devil_count: 40, pirate_count: 0, spawn_interval: 0.5 };
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4602 = { creeper_count: 20, icecream_count: 20, orc_count: 20, skull_count: 20, teleman_count: 20, devil_count: 20, pirate_count: 0, spawn_interval: 0.5 };
const _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4603 = { creeper_count: 0, icecream_count: 0, orc_count: 0, skull_count: 0, teleman_count: 59, devil_count: 0, pirate_count: 1, spawn_interval: 1 };
const _M0FP39Milky201817selene_2dexamples9survivors18wave__spawn__plans = [_M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4594, _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4595, _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4596, _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4597, _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4598, _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4599, _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4600, _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4601, _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4602, _M0FP39Milky201817selene_2dexamples9survivors34wave__spawn__plans_2erecord_2f4603];
const _M0FP39Milky201817selene_2dexamples9survivors8spawners = [{ _0: 16, _1: 16 }, { _0: 624, _1: 16 }, { _0: 16, _1: 624 }, { _0: 624, _1: 624 }];
const _M0FP39Milky20186selene8position9positions = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(8);
const _M0FP39Milky20186selene7backend15canvas__backend = _M0MP39Milky20186selene7backend13CanvasBackend3new();
const _M0FP311moonbitlang4core7builtin4seed = _M0FP311moonbitlang4core7builtin12random__seed();
const _M0FP39Milky20186selene2ui3uis = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(8);
const _M0FP39Milky20186selene5style6styles = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(8);
const _M0FP39Milky20186selene6entity13all__entities = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6entity6EntityE(8);
const _M0FP39Milky20186selene5style12screen__root = _M0MP39Milky20186selene6entity6Entity3new();
(() => {
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(_M0FP39Milky20186selene5style6styles, _M0FP39Milky20186selene5style12screen__root, _M0MP39Milky20186selene5style5Style11new_2einner(new $64$Milky2018$47$selene$47$style$46$SizePlan$Sized(_M0FP39Milky20186selene7backend15canvas__backend.viewport_size), 0, 0, 0, 0, 0));
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _M0FP39Milky20186selene5style12screen__root, { _0: 0, _1: 0 });
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(_M0FP39Milky20186selene2ui3uis, _M0FP39Milky20186selene5style12screen__root, _M0MP39Milky20186selene2ui2Ui3new());
})();
const _M0FP39Milky20186selene6sprite20animation__generator = _M0MP311moonbitlang4core3ref3Ref3newGiE(0);
const _M0FP39Milky201817selene_2dexamples9survivors29player__idle__left__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/whiteboy/idle.png", 4, 16, 16, { _0: 32, _1: 32 }, 64), true, 12, _M0MP39Milky20186selene4math9Transform7flip__x(16));
const _M0FP39Milky201817selene_2dexamples9survivors44player__run__down__animation_2econstr_2f4590 = true;
const _M0FP39Milky201817selene_2dexamples9survivors44player__run__down__animation_2econstr_2f4591 = new Option$Some$0$(12);
const _M0FP39Milky201817selene_2dexamples9survivors28player__run__down__animation = _M0MP39Milky20186selene6sprite9Animation3new(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/whiteboy/run.png", 8, 16, 16, { _0: 32, _1: 112 }, 64), _M0FP39Milky201817selene_2dexamples9survivors44player__run__down__animation_2econstr_2f4590, _M0FP39Milky201817selene_2dexamples9survivors44player__run__down__animation_2econstr_2f4591, undefined);
const _M0FP39Milky20186selene9collision6shapes = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(8);
const _M0FP39Milky20186selene6sprite7sprites = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(8);
const _M0FP39Milky20186selene9collision9pickables = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(8);
const _M0FP39Milky20186selene6entity8children = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(8);
const _M0FP39Milky20186selene6entity7parents = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(8);
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4559 = "white";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4560 = "24px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4561 = "white";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4562 = "24px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4563 = "white";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4564 = "24px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4565 = "orange";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4566 = "24px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4567 = "cyan";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4568 = "24px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4569 = "yellow";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4570 = "24px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4571 = 2;
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4572 = new Option$Some$0$(20);
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4573 = new Option$Some$0$(160);
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4574 = new Option$Some$0$(40);
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4575 = 2;
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4576 = new Option$Some$0$(20);
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4577 = new Option$Some$0$(140);
const _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4578 = new Option$Some$0$(100);
const _M0FP39Milky201817selene_2dexamples9survivors11game__state = { player_entity: _M0MP39Milky20186selene6entity6Entity3new(), player_direction: 1, rand: _M0MP311moonbitlang4core6random4Rand3new(Option$None$1$), score: 0, score_box: _M0MP39Milky20186selene6sprite4Text3new("Score: 0", _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4559, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4560, undefined, undefined), invincible: false, game_timer: 600, game_over: false, timer_box: _M0MP39Milky20186selene6sprite4Text3new("Time: 10:00", _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4561, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4562, undefined, undefined), game_over_box: _M0MP39Milky20186selene6sprite4Text3new("Final Score: 0", _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4563, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4564, undefined, undefined), game_over_displayed: false, current_wave: 1, wave_box: _M0MP39Milky20186selene6sprite4Text3new("Wave: 1", _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4565, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4566, undefined, undefined), exp: 0, exp_box: _M0MP39Milky20186selene6sprite4Text3new("EXP: 0/16", _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4567, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4568, undefined, undefined), player_level: 1, level_box: _M0MP39Milky20186selene6sprite4Text3new("Level: 1", _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4569, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4570, undefined, undefined), player_stats: { attack: 0, range: 0, speed: 150, attack_speed: 1, penetration: 0, weapon_instances: [0] }, level_up_panel: { panel_entity: _M0FP39Milky20186selene5style11add__widget(_M0FP39Milky20186selene5style12screen__root, (zindex) => _M0MP39Milky20186selene6sprite6Sprite17from__color__rect(_M0MP39Milky20186selene6sprite9ColorRect11new_2einner({ _0: 160, _1: 250 }, "rgba(13, 170, 26, 1)", "black"), zindex, undefined), undefined, undefined, undefined, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4571, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4572, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4573, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4574), available_selections: [] }, pending_level_ups: [], score_blink_timer: 0, score_is_red: false, game_over_panel: { panel_entity: _M0FP39Milky20186selene5style11add__widget(_M0FP39Milky20186selene5style12screen__root, (zindex) => _M0MP39Milky20186selene6sprite6Sprite17from__color__rect(_M0MP39Milky20186selene6sprite9ColorRect11new_2einner({ _0: 200, _1: 120 }, "rgba(0, 0, 0, 0.8)", "white"), zindex, undefined), undefined, undefined, undefined, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4575, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4576, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4577, _M0FP39Milky201817selene_2dexamples9survivors27game__state_2econstr_2f4578) } };
const _M0FP39Milky20186selene6inputs13pressed__keys = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6inputs4CodeE(8);
const _M0FP39Milky201817selene_2dexamples9survivors28player__run__left__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/whiteboy/run.png", 8, 16, 16, { _0: 32, _1: 32 }, 64), true, 12, _M0MP39Milky20186selene4math9Transform7flip__x(16));
const _M0FP39Milky201817selene_2dexamples9survivors43player__idle__up__animation_2econstr_2f4584 = true;
const _M0FP39Milky201817selene_2dexamples9survivors43player__idle__up__animation_2econstr_2f4585 = new Option$Some$0$(12);
const _M0FP39Milky201817selene_2dexamples9survivors27player__idle__up__animation = _M0MP39Milky20186selene6sprite9Animation3new(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/whiteboy/idle.png", 4, 16, 16, { _0: 32, _1: 192 }, 64), _M0FP39Milky201817selene_2dexamples9survivors43player__idle__up__animation_2econstr_2f4584, _M0FP39Milky201817selene_2dexamples9survivors43player__idle__up__animation_2econstr_2f4585, undefined);
const _M0FP39Milky201817selene_2dexamples9survivors46player__idle__right__animation_2econstr_2f4582 = true;
const _M0FP39Milky201817selene_2dexamples9survivors46player__idle__right__animation_2econstr_2f4583 = new Option$Some$0$(12);
const _M0FP39Milky201817selene_2dexamples9survivors30player__idle__right__animation = _M0MP39Milky20186selene6sprite9Animation3new(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/whiteboy/idle.png", 4, 16, 16, { _0: 32, _1: 32 }, 64), _M0FP39Milky201817selene_2dexamples9survivors46player__idle__right__animation_2econstr_2f4582, _M0FP39Milky201817selene_2dexamples9survivors46player__idle__right__animation_2econstr_2f4583, undefined);
const _M0FP39Milky201817selene_2dexamples9survivors42player__run__up__animation_2econstr_2f4592 = true;
const _M0FP39Milky201817selene_2dexamples9survivors42player__run__up__animation_2econstr_2f4593 = new Option$Some$0$(12);
const _M0FP39Milky201817selene_2dexamples9survivors26player__run__up__animation = _M0MP39Milky20186selene6sprite9Animation3new(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/whiteboy/run.png", 8, 16, 16, { _0: 32, _1: 192 }, 64), _M0FP39Milky201817selene_2dexamples9survivors42player__run__up__animation_2econstr_2f4592, _M0FP39Milky201817selene_2dexamples9survivors42player__run__up__animation_2econstr_2f4593, undefined);
const _M0FP39Milky201817selene_2dexamples9survivors45player__run__right__animation_2econstr_2f4588 = true;
const _M0FP39Milky201817selene_2dexamples9survivors45player__run__right__animation_2econstr_2f4589 = new Option$Some$0$(12);
const _M0FP39Milky201817selene_2dexamples9survivors29player__run__right__animation = _M0MP39Milky20186selene6sprite9Animation3new(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/whiteboy/run.png", 8, 16, 16, { _0: 32, _1: 32 }, 64), _M0FP39Milky201817selene_2dexamples9survivors45player__run__right__animation_2econstr_2f4588, _M0FP39Milky201817selene_2dexamples9survivors45player__run__right__animation_2econstr_2f4589, undefined);
const _M0FP39Milky20186selene8velocity10velocities = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(8);
const _M0FP39Milky201817selene_2dexamples9survivors45player__idle__down__animation_2econstr_2f4586 = true;
const _M0FP39Milky201817selene_2dexamples9survivors45player__idle__down__animation_2econstr_2f4587 = new Option$Some$0$(12);
const _M0FP39Milky201817selene_2dexamples9survivors29player__idle__down__animation = _M0MP39Milky20186selene6sprite9Animation3new(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/whiteboy/idle.png", 4, 16, 16, { _0: 32, _1: 112 }, 64), _M0FP39Milky201817selene_2dexamples9survivors45player__idle__down__animation_2econstr_2f4586, _M0FP39Milky201817selene_2dexamples9survivors45player__idle__down__animation_2econstr_2f4587, undefined);
const _M0FP39Milky201817selene_2dexamples9survivors7enemies = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(8);
const _M0FP39Milky201817selene_2dexamples9survivors21orc__right__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Orc.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0));
const _M0FP39Milky201817selene_2dexamples9survivors20orc__left__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Orc.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform7flip__x(16));
const _M0FP39Milky201817selene_2dexamples9survivors25teleman__right__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Teleman.png", 4, 16, 24, { _0: 0, _1: 0 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0));
const _M0FP39Milky201817selene_2dexamples9survivors23skull__right__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Skull.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0));
const _M0FP39Milky201817selene_2dexamples9survivors25icecream__left__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Icecream.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform7flip__x(16));
const _M0FP39Milky201817selene_2dexamples9survivors25creeper__right__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Creeper.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0));
const _M0FP39Milky201817selene_2dexamples9survivors22devil__left__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Devil.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform7flip__x(16));
const _M0FP39Milky201817selene_2dexamples9survivors26icecream__right__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Icecream.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0));
const _M0FP39Milky201817selene_2dexamples9survivors24teleman__left__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Teleman.png", 4, 16, 24, { _0: 0, _1: 0 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform7flip__x(16));
const _M0FP39Milky201817selene_2dexamples9survivors23pirate__left__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Pirate.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform7flip__x(16));
const _M0FP39Milky201817selene_2dexamples9survivors24creeper__left__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Creeper.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform7flip__x(16));
const _M0FP39Milky201817selene_2dexamples9survivors23devil__right__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Devil.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0));
const _M0FP39Milky201817selene_2dexamples9survivors22skull__left__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Skull.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform7flip__x(16));
const _M0FP39Milky201817selene_2dexamples9survivors24pirate__right__animation = _M0MP39Milky20186selene6sprite9Animation11new_2einner(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/enemy/Pirate.png", 4, 16, 24, { _0: 0, _1: 48 }, 0), true, 12, _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0));
const data = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(8);
_M0MP311moonbitlang4core7builtin3Map3setGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(data, 0, { health: 1, speed: 60, points: 10, right_animation: _M0FP39Milky201817selene_2dexamples9survivors25creeper__right__animation, left_animation: _M0FP39Milky201817selene_2dexamples9survivors24creeper__left__animation });
_M0MP311moonbitlang4core7builtin3Map3setGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(data, 1, { health: 2, speed: 90, points: 20, right_animation: _M0FP39Milky201817selene_2dexamples9survivors26icecream__right__animation, left_animation: _M0FP39Milky201817selene_2dexamples9survivors25icecream__left__animation });
_M0MP311moonbitlang4core7builtin3Map3setGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(data, 2, { health: 3, speed: 75, points: 30, right_animation: _M0FP39Milky201817selene_2dexamples9survivors21orc__right__animation, left_animation: _M0FP39Milky201817selene_2dexamples9survivors20orc__left__animation });
_M0MP311moonbitlang4core7builtin3Map3setGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(data, 3, { health: 5, speed: 60, points: 40, right_animation: _M0FP39Milky201817selene_2dexamples9survivors23skull__right__animation, left_animation: _M0FP39Milky201817selene_2dexamples9survivors22skull__left__animation });
_M0MP311moonbitlang4core7builtin3Map3setGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(data, 4, { health: 20, speed: 60, points: 80, right_animation: _M0FP39Milky201817selene_2dexamples9survivors25teleman__right__animation, left_animation: _M0FP39Milky201817selene_2dexamples9survivors24teleman__left__animation });
_M0MP311moonbitlang4core7builtin3Map3setGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(data, 5, { health: 8, speed: 90, points: 50, right_animation: _M0FP39Milky201817selene_2dexamples9survivors23devil__right__animation, left_animation: _M0FP39Milky201817selene_2dexamples9survivors22devil__left__animation });
_M0MP311moonbitlang4core7builtin3Map3setGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(data, 6, { health: 500, speed: 60, points: 200, right_animation: _M0FP39Milky201817selene_2dexamples9survivors24pirate__right__animation, left_animation: _M0FP39Milky201817selene_2dexamples9survivors23pirate__left__animation });
const _M0FP39Milky201817selene_2dexamples9survivors11enemy__data = data;
const _M0FP39Milky20186selene6system6timers = _M0MP311moonbitlang4core5array5Array11new_2einnerGRP39Milky20186selene6system5TimerE(0);
const _M0FP39Milky201817selene_2dexamples9survivors24player__collision__layer = _M0MP39Milky20186selene9collision14CollisionLayer3new();
const _M0FP39Milky201817selene_2dexamples9survivors22wall__collision__layer = _M0MP39Milky20186selene9collision14CollisionLayer3new();
const _M0FP39Milky20186selene6system16deferred__events = _M0MP311moonbitlang4core5array5Array11new_2einnerGWEuE(0);
const _M0FP39Milky20186selene9collision17collision__layers = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(8);
const _M0FP39Milky20186selene9collision5areas = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(8);
const _M0FP39Milky201817selene_2dexamples9survivors29enemybullet__collision__layer = _M0MP39Milky20186selene9collision14CollisionLayer3new();
const _bind = { _0: 0, _1: 0 };
const _bind$2 = Option$None$0$;
const _bind$3 = Option$None$0$;
const _bind$4 = Option$None$0$;
const _bind$5 = Option$None$0$;
const _bind$6 = undefined;
const _bind$7 = { _0: 0, _1: 0 };
const _M0FP39Milky20186selene6camera6camera = { position: _bind, limit_top: _bind$4, limit_bottom: _bind$2, limit_left: _bind$3, limit_right: _bind$5, attached_entity: _bind$6, offset: _bind$7, follow_x: true, follow_y: true };
const _M0FP39Milky20186selene9collision14quadtree__root = _M0MP311moonbitlang4core3ref3Ref3newGRP39Milky20186selene9collision8QuadTreeE(_M0MP39Milky20186selene9collision8QuadTree3new({ _0: 0, _1: 0 }, { _0: 0, _1: 0 }, 0));
const _M0FP39Milky20186selene9collision16real__velocities = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(8);
const _M0FP39Milky20186selene9collision16collision__infos = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(8);
const _M0FP39Milky20186selene9collision9colliders = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(8);
const _M0FP39Milky20186selene6inputs19last__pressed__keys = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6inputs4CodeE(8);
const _M0FP39Milky20186selene6inputs27all__codes_2e_2abind_2f3433 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32];
const _M0FP39Milky20186selene6inputs10all__codes = _M0MP311moonbitlang4core3set3Set11from__arrayGRP39Milky20186selene6inputs4CodeE({ buf: _M0FP39Milky20186selene6inputs27all__codes_2e_2abind_2f3433, start: 0, end: 33 });
const _M0FP39Milky20186selene6inputs19just__pressed__keys = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6inputs4CodeE(8);
const _M0FP39Milky20186selene6inputs19just__release__keys = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6inputs4CodeE(8);
const _M0FP39Milky20186selene7backend14element__cache = _M0MP311moonbitlang4core7builtin3Map11new_2einnerGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(8);
const _M0FP311moonbitlang4core7builtin33brute__force__find_2econstr_2f403 = 0;
const _M0FP311moonbitlang4core7builtin43boyer__moore__horspool__find_2econstr_2f389 = 0;
const _M0FP311moonbitlang4core6double13neg__infinity = _M0MP311moonbitlang4core5int645Int6423reinterpret__as__double($_4503599627370496L);
const _M0FP311moonbitlang4core6double14not__a__number = _M0MP311moonbitlang4core5int645Int6423reinterpret__as__double($9221120237041090561L);
const _M0FP311moonbitlang4core6double8infinity = _M0MP311moonbitlang4core5int645Int6423reinterpret__as__double($9218868437227405312L);
const _M0FP311moonbitlang4core7strconv25max__mantissa__fast__path = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shl3shl($2L, 52);
const _M0FP311moonbitlang4core7strconv28checked__mul_2econstr_2f2988 = $0L;
const _M0FP39Milky20186selene6sprite26parse__font_2etuple_2f4317 = { _0: 16, _1: "Arial" };
const _M0FP39Milky20186selene7backend15realtime__delta = _M0MP311moonbitlang4core3ref3Ref3newGdE(0);
const _M0FP39Milky20186selene7plugins31default__plugin_2econstr_2f4556 = new $64$Milky2018$47$selene$47$system$46$Schedule$Render(0);
const _M0FP39Milky20186selene7backend6window = _M0FP37Yoorkin12rabbit_2dtea3dom6window();
const _M0FP39Milky201817selene_2dexamples9survivors23enemy__collision__layer = _M0MP39Milky20186selene9collision14CollisionLayer3new();
const _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4886 = new Option$Some$0$(30);
const _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4887 = new Option$Some$0$(8);
const _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4888 = new Option$Some$0$(10);
const _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4889 = "white";
const _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4890 = "24px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4891 = new Option$Some$0$(45);
const _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4892 = new Option$Some$0$(8);
const _M0FP39Milky201817selene_2dexamples9survivors31add__level__box_2econstr_2f4900 = new Option$Some$0$(16);
const _M0FP39Milky201817selene_2dexamples9survivors31add__level__box_2econstr_2f4901 = new Option$Some$0$(16);
const _M0FP39Milky201817selene_2dexamples9survivors13grass__sprite = _M0MP39Milky20186selene6sprite9Animation3new(_M0FP39Milky20186selene6sprite27frames__from__atlas_2einner("assets/tilesets/decor_16x16.png", 1, 16, 16, { _0: 0, _1: 0 }, 0), -1, Option$None$0$, undefined);
const _M0FP39Milky201817selene_2dexamples9survivors30add__wave__box_2econstr_2f4871 = new Option$Some$0$(16);
const _M0FP39Milky201817selene_2dexamples9survivors30add__wave__box_2econstr_2f4872 = new Option$Some$0$(84);
const _M0FP39Milky201817selene_2dexamples9survivors31add__background_2econstr_2f4918 = 3;
const _M0FP39Milky201817selene_2dexamples9survivors31add__score__box_2econstr_2f4831 = new Option$Some$0$(200);
const _M0FP39Milky201817selene_2dexamples9survivors31add__score__box_2econstr_2f4832 = new Option$Some$0$(16);
const _M0FP39Milky201817selene_2dexamples9survivors29add__exp__box_2econstr_2f4874 = new Option$Some$0$(16);
const _M0FP39Milky201817selene_2dexamples9survivors29add__exp__box_2econstr_2f4875 = new Option$Some$0$(50);
const _M0FP39Milky201817selene_2dexamples9survivors19weapon__sword__icon = _M0MP39Milky20186selene6sprite9Animation13single__frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 32, _1: 192 });
const _M0FP39Milky201817selene_2dexamples9survivors21weapon__minigun__icon = _M0MP39Milky20186selene6sprite9Animation13single__frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 32, _1: 224 });
const _M0FP39Milky201817selene_2dexamples9survivors25weapon__sniperrifle__icon = _M0MP39Milky20186selene6sprite9Animation13single__frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 128, _1: 224 });
const _M0FP39Milky201817selene_2dexamples9survivors20weapon__pistol__icon = _M0MP39Milky20186selene6sprite9Animation13single__frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 256, _1: 192 });
const _M0FP39Milky201817selene_2dexamples9survivors22powerup__bandana__icon = _M0MP39Milky20186selene6sprite9Animation13single__frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 192, _1: 288 });
const _M0FP39Milky201817selene_2dexamples9survivors20powerup__range__icon = _M0MP39Milky20186selene6sprite9Animation13single__frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 192, _1: 192 });
const _M0FP39Milky201817selene_2dexamples9survivors23powerup__cooldown__icon = _M0MP39Milky20186selene6sprite9Animation13single__frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 96, _1: 160 });
const _M0FP39Milky201817selene_2dexamples9survivors21powerup__attack__icon = _M0MP39Milky20186selene6sprite9Animation13single__frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 384, _1: 128 });
const _M0FP39Milky201817selene_2dexamples9survivors20powerup__speed__icon = _M0MP39Milky20186selene6sprite9Animation13single__frame("assets/icon/icon.png", { _0: 32, _1: 32 }, undefined, { _0: 64, _1: 160 });
const _M0FP39Milky201817selene_2dexamples9survivors42update__selection__display_2econstr_2f4751 = "white";
const _M0FP39Milky201817selene_2dexamples9survivors42update__selection__display_2econstr_2f4752 = "16px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors42update__selection__display_2econstr_2f4753 = "white";
const _M0FP39Milky201817selene_2dexamples9survivors42update__selection__display_2econstr_2f4754 = "16px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors36setup__level__up__ui_2econstr_2f4859 = new Option$Some$0$(8);
const _M0FP39Milky201817selene_2dexamples9survivors36setup__level__up__ui_2econstr_2f4860 = "white";
const _M0FP39Milky201817selene_2dexamples9survivors36setup__level__up__ui_2econstr_2f4861 = "16px ThaleahFat";
const _M0FP39Milky201817selene_2dexamples9survivors31add__timer__box_2econstr_2f4877 = new Option$Some$0$(360);
const _M0FP39Milky201817selene_2dexamples9survivors31add__timer__box_2econstr_2f4878 = new Option$Some$0$(16);
const _M0FP39Milky201817selene_2dexamples9survivors27game__start_2econstr_2f4984 = new Option$Some$0$(0);
const _M0FP39Milky201817selene_2dexamples9survivors27game__start_2econstr_2f4985 = new Option$Some$0$(640);
const _M0FP39Milky201817selene_2dexamples9survivors27game__start_2econstr_2f4986 = new Option$Some$0$(0);
const _M0FP39Milky201817selene_2dexamples9survivors27game__start_2econstr_2f4987 = new Option$Some$0$(640);
const _M0FP39Milky201817selene_2dexamples9survivors24bullet__collision__layer = _M0MP39Milky20186selene9collision14CollisionLayer3new();
function _M0FP311moonbitlang4core5abort5abortGRP39Milky201817selene_2dexamples9survivors9EnemyDataE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGuE(msg) {
  $panic();
}
function _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core7builtin12MutArrayViewGUWdEuiEEE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core7builtin12MutArrayViewGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEEE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGUWdEuiEE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGRP39Milky20186selene9collision8QuadTreeE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGjE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core6string10StringViewE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core5bytes9BytesViewE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGOiE(msg) {
  return $panic();
}
function _M0MP311moonbitlang4core7builtin6Hasher8consume4(self, input) {
  const _p = (self.acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
  const _p$2 = 17;
  self.acc = Math.imul(_p << _p$2 | (_p >>> (32 - _p$2 | 0) | 0), 668265263) | 0;
}
function _M0MP311moonbitlang4core7builtin6Hasher13combine__uint(self, value) {
  self.acc = (self.acc >>> 0) + (4 >>> 0) | 0;
  _M0MP311moonbitlang4core7builtin6Hasher8consume4(self, value);
}
function _M0FP311moonbitlang4core7builtin5abortGRP39Milky201817selene_2dexamples9survivors9EnemyDataE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGRP39Milky201817selene_2dexamples9survivors9EnemyDataE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGuE(string, loc) {
  _M0FP311moonbitlang4core5abort5abortGuE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core7builtin12MutArrayViewGUWdEuiEEE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core7builtin12MutArrayViewGUWdEuiEEE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core7builtin12MutArrayViewGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEEE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core7builtin12MutArrayViewGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEEE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGUWdEuiEE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGUWdEuiEE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGRP39Milky20186selene9collision8QuadTreeE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGRP39Milky20186selene9collision8QuadTreeE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGjE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGjE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core6string10StringViewE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core6string10StringViewE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core5bytes9BytesViewE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core5bytes9BytesViewE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGOiE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGOiE(`${string}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0MP311moonbitlang4core5array10FixedArray12unsafe__blitGjE(dst, dst_offset, src, src_offset, len) {
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
function _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(size_hint) {
  return { val: "" };
}
function _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__char(self, ch) {
  const _bind$8 = self;
  _bind$8.val = `${_bind$8.val}${String.fromCodePoint(ch)}`;
}
function _M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(self) {
  return _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGkE(self, 55296) && _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGkE(self, 56319);
}
function _M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(self) {
  return _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGkE(self, 56320) && _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGkE(self, 57343);
}
function _M0FP311moonbitlang4core7builtin32code__point__of__surrogate__pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function _M0MP311moonbitlang4core6string6String16unsafe__char__at(self, index) {
  const c1 = self.charCodeAt(index);
  if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1)) {
    const c2 = self.charCodeAt(index + 1 | 0);
    return _M0FP311moonbitlang4core7builtin32code__point__of__surrogate__pair(c1, c2);
  } else {
    return c1;
  }
}
function _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors13WaveSpawnPlanE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGRP39Milky20186selene4math5Vec2DE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGdE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGRP39Milky20186selene6sprite14AnimationFrameE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors16LevelUpSelectionE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGsE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGRP39Milky20186selene6entity6EntityE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors11PowerupTypeE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core7builtin13SourceLocRepr5parse(repr) {
  const _bind$8 = { str: repr, start: 0, end: repr.length };
  const _data = _bind$8.str;
  const _start = _bind$8.start;
  const _end = _start + (_bind$8.end - _bind$8.start | 0) | 0;
  let _cursor = _start;
  let accept_state = -1;
  let match_end = -1;
  let match_tag_saver_0 = -1;
  let match_tag_saver_1 = -1;
  let match_tag_saver_2 = -1;
  let match_tag_saver_3 = -1;
  let match_tag_saver_4 = -1;
  let tag_0 = -1;
  let tag_1 = -1;
  let tag_1_1 = -1;
  let tag_1_2 = -1;
  let tag_3 = -1;
  let tag_2 = -1;
  let tag_2_1 = -1;
  let tag_4 = -1;
  _L: {
    if (_cursor < _end) {
      const _p = _cursor;
      const next_char = _data.charCodeAt(_p);
      _cursor = _cursor + 1 | 0;
      if (next_char === 64) {
        _L$2: while (true) {
          tag_0 = _cursor;
          if (_cursor < _end) {
            const _p$2 = _cursor;
            const next_char$2 = _data.charCodeAt(_p$2);
            _cursor = _cursor + 1 | 0;
            if (next_char$2 === 58) {
              if (_cursor < _end) {
                const _p$3 = _cursor;
                _data.charCodeAt(_p$3);
                _cursor = _cursor + 1 | 0;
                let _tmp = 0;
                _L$3: while (true) {
                  const dispatch_15 = _tmp;
                  _L$4: {
                    _L$5: {
                      switch (dispatch_15) {
                        case 3: {
                          tag_1_2 = tag_1_1;
                          tag_1_1 = tag_1;
                          tag_1 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const _p$4 = _cursor;
                              const next_char$3 = _data.charCodeAt(_p$4);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  tag_1 = _cursor;
                                  tag_2_1 = tag_2;
                                  tag_2 = _cursor;
                                  tag_3 = _cursor;
                                  if (_cursor < _end) {
                                    _L$7: {
                                      const _p$5 = _cursor;
                                      const next_char$4 = _data.charCodeAt(_p$5);
                                      _cursor = _cursor + 1 | 0;
                                      if (next_char$4 < 48) {
                                        if (next_char$4 === 45) {
                                          break _L$4;
                                        } else {
                                          break _L$7;
                                        }
                                      } else {
                                        if (next_char$4 > 57) {
                                          if (next_char$4 < 59) {
                                            _tmp = 3;
                                            continue _L$3;
                                          } else {
                                            break _L$7;
                                          }
                                        } else {
                                          _tmp = 6;
                                          continue _L$3;
                                        }
                                      }
                                    }
                                    _tmp = 0;
                                    continue _L$3;
                                  } else {
                                    break _L;
                                  }
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  _tmp = 1;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        case 2: {
                          tag_1 = _cursor;
                          tag_2 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const _p$4 = _cursor;
                              const next_char$3 = _data.charCodeAt(_p$4);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  _tmp = 2;
                                  continue _L$3;
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  _tmp = 3;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        case 0: {
                          tag_1 = _cursor;
                          if (_cursor < _end) {
                            const _p$4 = _cursor;
                            const next_char$3 = _data.charCodeAt(_p$4);
                            _cursor = _cursor + 1 | 0;
                            if (next_char$3 === 58) {
                              _tmp = 1;
                              continue _L$3;
                            } else {
                              _tmp = 0;
                              continue _L$3;
                            }
                          } else {
                            break _L;
                          }
                        }
                        case 4: {
                          tag_1 = _cursor;
                          tag_4 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const _p$4 = _cursor;
                              const next_char$3 = _data.charCodeAt(_p$4);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  _tmp = 4;
                                  continue _L$3;
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  tag_1_2 = tag_1_1;
                                  tag_1_1 = tag_1;
                                  tag_1 = _cursor;
                                  if (_cursor < _end) {
                                    _L$7: {
                                      const _p$5 = _cursor;
                                      const next_char$4 = _data.charCodeAt(_p$5);
                                      _cursor = _cursor + 1 | 0;
                                      if (next_char$4 < 58) {
                                        if (next_char$4 < 48) {
                                          break _L$7;
                                        } else {
                                          tag_1 = _cursor;
                                          tag_2_1 = tag_2;
                                          tag_2 = _cursor;
                                          if (_cursor < _end) {
                                            _L$8: {
                                              const _p$6 = _cursor;
                                              const next_char$5 = _data.charCodeAt(_p$6);
                                              _cursor = _cursor + 1 | 0;
                                              if (next_char$5 < 58) {
                                                if (next_char$5 < 48) {
                                                  break _L$8;
                                                } else {
                                                  _tmp = 5;
                                                  continue _L$3;
                                                }
                                              } else {
                                                if (next_char$5 > 58) {
                                                  break _L$8;
                                                } else {
                                                  _tmp = 3;
                                                  continue _L$3;
                                                }
                                              }
                                            }
                                            _tmp = 0;
                                            continue _L$3;
                                          } else {
                                            break _L$5;
                                          }
                                        }
                                      } else {
                                        if (next_char$4 > 58) {
                                          break _L$7;
                                        } else {
                                          _tmp = 1;
                                          continue _L$3;
                                        }
                                      }
                                    }
                                    _tmp = 0;
                                    continue _L$3;
                                  } else {
                                    break _L;
                                  }
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        case 5: {
                          tag_1 = _cursor;
                          tag_2 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const _p$4 = _cursor;
                              const next_char$3 = _data.charCodeAt(_p$4);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  _tmp = 5;
                                  continue _L$3;
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  _tmp = 3;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L$5;
                          }
                        }
                        case 6: {
                          tag_1 = _cursor;
                          tag_2 = _cursor;
                          tag_3 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const _p$4 = _cursor;
                              const next_char$3 = _data.charCodeAt(_p$4);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 48) {
                                if (next_char$3 === 45) {
                                  break _L$4;
                                } else {
                                  break _L$6;
                                }
                              } else {
                                if (next_char$3 > 57) {
                                  if (next_char$3 < 59) {
                                    _tmp = 3;
                                    continue _L$3;
                                  } else {
                                    break _L$6;
                                  }
                                } else {
                                  _tmp = 6;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        case 1: {
                          tag_1_1 = tag_1;
                          tag_1 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const _p$4 = _cursor;
                              const next_char$3 = _data.charCodeAt(_p$4);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  _tmp = 2;
                                  continue _L$3;
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  _tmp = 1;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        default: {
                          break _L;
                        }
                      }
                    }
                    tag_1 = tag_1_2;
                    tag_2 = tag_2_1;
                    match_tag_saver_0 = tag_0;
                    match_tag_saver_1 = tag_1;
                    match_tag_saver_2 = tag_2;
                    match_tag_saver_3 = tag_3;
                    match_tag_saver_4 = tag_4;
                    accept_state = 0;
                    match_end = _cursor;
                    break _L;
                  }
                  tag_1_1 = tag_1_2;
                  tag_1 = _cursor;
                  tag_2 = tag_2_1;
                  if (_cursor < _end) {
                    _L$5: {
                      const _p$4 = _cursor;
                      const next_char$3 = _data.charCodeAt(_p$4);
                      _cursor = _cursor + 1 | 0;
                      if (next_char$3 < 58) {
                        if (next_char$3 < 48) {
                          break _L$5;
                        } else {
                          _tmp = 4;
                          continue;
                        }
                      } else {
                        if (next_char$3 > 58) {
                          break _L$5;
                        } else {
                          _tmp = 1;
                          continue;
                        }
                      }
                    }
                    _tmp = 0;
                    continue;
                  } else {
                    break _L;
                  }
                }
              } else {
                break _L;
              }
            } else {
              continue;
            }
          } else {
            break _L;
          }
        }
      } else {
        break _L;
      }
    } else {
      break _L;
    }
  }
  if (accept_state === 0) {
    const start_line = _M0MP311moonbitlang4core6string6String4view(_data, match_tag_saver_1 + 1 | 0, match_tag_saver_2);
    const start_column = _M0MP311moonbitlang4core6string6String4view(_data, match_tag_saver_2 + 1 | 0, match_tag_saver_3);
    const pkg = _M0MP311moonbitlang4core6string6String4view(_data, _start + 1 | 0, match_tag_saver_0);
    const filename = _M0MP311moonbitlang4core6string6String4view(_data, match_tag_saver_0 + 1 | 0, match_tag_saver_1);
    const end_line = _M0MP311moonbitlang4core6string6String4view(_data, match_tag_saver_3 + 1 | 0, match_tag_saver_4);
    const end_column = _M0MP311moonbitlang4core6string6String4view(_data, match_tag_saver_4 + 1 | 0, match_end);
    return { pkg: pkg, filename: filename, start_line: start_line, start_column: start_column, end_line: end_line, end_column: end_column };
  } else {
    return $panic();
  }
}
function _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger13write__string(self, str) {
  const _bind$8 = self;
  _bind$8.val = `${_bind$8.val}${str}`;
}
function _M0MP311moonbitlang4core6uint646UInt647to__int(self) {
  const _p = self;
  return _p.lo;
}
function _M0MP311moonbitlang4core6uint646UInt648to__byte(self) {
  return _M0MP311moonbitlang4core6uint646UInt647to__int(self) & 255;
}
function _M0MP311moonbitlang4core7builtin6Hasher12combine__int(self, value) {
  _M0MP311moonbitlang4core7builtin6Hasher13combine__uint(self, value);
}
function _M0MP311moonbitlang4core7builtin7MyInt649from__int(value) {
  return { hi: value >> 31 & -1, lo: value | 0 };
}
function _M0MP311moonbitlang4core3int3Int9to__int64(self) {
  return _M0MP311moonbitlang4core7builtin7MyInt649from__int(self);
}
function _M0MP311moonbitlang4core3int3Int10to__uint64(self) {
  return _M0MP311moonbitlang4core3int3Int9to__int64(self);
}
function _M0MP311moonbitlang4core7builtin6Hasher7combineGRP39Milky20186selene6entity6EntityE(self, value) {
  _M0IP39Milky20186selene6entity6EntityP311moonbitlang4core7builtin4Hash13hash__combine(value, self);
}
function _M0MP311moonbitlang4core7builtin6Hasher7combineGRP39Milky20186selene6inputs4CodeE(self, value) {
  _M0IP39Milky20186selene6inputs4CodeP311moonbitlang4core7builtin4Hash13hash__combine(value, self);
}
function _M0MP311moonbitlang4core7builtin6Hasher7combineGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(self, value) {
  _M0IP39Milky201817selene_2dexamples9survivors9EnemyTypeP311moonbitlang4core7builtin4Hash13hash__combine(value, self);
}
function _M0MP311moonbitlang4core7builtin6Hasher7combineGsE(self, value) {
  _M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Hash13hash__combine(value, self);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(x, y) {
  return !_M0IP39Milky201817selene_2dexamples9survivors9EnemyTypeP311moonbitlang4core7builtin2Eq5equal(x, y);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGRP39Milky20186selene6entity6EntityE(x, y) {
  return !(x === y);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGRP311moonbitlang4core6string10StringViewE(x, y) {
  return !_M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin2Eq5equal(x, y);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGmE(x, y) {
  return _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin7Compare7compare(x, y) < 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGlE(x, y) {
  return _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(x, y) < 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGmE(x, y) {
  return _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin7Compare7compare(x, y) > 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGlE(x, y) {
  return _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(x, y) > 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGkE(x, y) {
  return $compare_int(x, y) <= 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGlE(x, y) {
  return _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(x, y) <= 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGmE(x, y) {
  return _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin7Compare7compare(x, y) <= 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGkE(x, y) {
  return $compare_int(x, y) >= 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGmE(x, y) {
  return _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin7Compare7compare(x, y) >= 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGlE(x, y) {
  return _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(x, y) >= 0;
}
function _M0MP311moonbitlang4core7builtin6Hasher9avalanche(self) {
  let acc = self.acc;
  acc = acc ^ (acc >>> 15 | 0);
  acc = Math.imul(acc, -2048144777) | 0;
  acc = acc ^ (acc >>> 13 | 0);
  acc = Math.imul(acc, -1028477379) | 0;
  acc = acc ^ (acc >>> 16 | 0);
  return acc;
}
function _M0MP311moonbitlang4core7builtin6Hasher8finalize(self) {
  return _M0MP311moonbitlang4core7builtin6Hasher9avalanche(self);
}
function _M0MP311moonbitlang4core7builtin6Hasher11new_2einner(seed) {
  return { acc: (seed >>> 0) + (374761393 >>> 0) | 0 };
}
function _M0MP311moonbitlang4core7builtin6Hasher3new(seed$46$opt) {
  let seed;
  if (seed$46$opt === undefined) {
    seed = _M0FP311moonbitlang4core7builtin4seed;
  } else {
    const _Some = seed$46$opt;
    seed = _Some;
  }
  return _M0MP311moonbitlang4core7builtin6Hasher11new_2einner(seed);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(self) {
  const h = _M0MP311moonbitlang4core7builtin6Hasher3new(undefined);
  _M0MP311moonbitlang4core7builtin6Hasher7combineGRP39Milky20186selene6entity6EntityE(h, self);
  return _M0MP311moonbitlang4core7builtin6Hasher8finalize(h);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6inputs4CodeE(self) {
  const h = _M0MP311moonbitlang4core7builtin6Hasher3new(undefined);
  _M0MP311moonbitlang4core7builtin6Hasher7combineGRP39Milky20186selene6inputs4CodeE(h, self);
  return _M0MP311moonbitlang4core7builtin6Hasher8finalize(h);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(self) {
  const h = _M0MP311moonbitlang4core7builtin6Hasher3new(undefined);
  _M0MP311moonbitlang4core7builtin6Hasher7combineGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(h, self);
  return _M0MP311moonbitlang4core7builtin6Hasher8finalize(h);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGsE(self) {
  const h = _M0MP311moonbitlang4core7builtin6Hasher3new(undefined);
  _M0MP311moonbitlang4core7builtin6Hasher7combineGsE(h, self);
  return _M0MP311moonbitlang4core7builtin6Hasher8finalize(h);
}
function _M0MP311moonbitlang4core6string6String11sub_2einner(self, start, end) {
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
    if (start$2 < len && _M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(self.charCodeAt(start$2))) {
      return new Result$Err$2$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex);
    }
    if (end$2 < len && _M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(self.charCodeAt(end$2))) {
      return new Result$Err$2$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex);
    }
    return new Result$Ok$2$({ str: self, start: start$2, end: end$2 });
  } else {
    return new Result$Err$2$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$IndexOutOfBounds);
  }
}
function _M0IP016_24default__implP311moonbitlang4core7builtin6Logger16write__substringGRP311moonbitlang4core7builtin13StringBuilderE(self, value, start, len) {
  let _tmp;
  let _try_err;
  _L: {
    _L$2: {
      const _bind$8 = _M0MP311moonbitlang4core6string6String11sub_2einner(value, start, start + len | 0);
      if (_bind$8.$tag === 1) {
        const _ok = _bind$8;
        _tmp = _ok._0;
      } else {
        const _err = _bind$8;
        _try_err = _err._0;
        break _L$2;
      }
      break _L;
    }
    _tmp = $panic();
  }
  _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(self, _tmp);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self) {
  const logger = _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(0);
  _M0IP311moonbitlang4core3int3IntP311moonbitlang4core7builtin4Show6output(self, { self: logger, method_table: _M0FP095_40moonbitlang_2fcore_2fbuiltin_2eStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return logger.val;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(self) {
  const logger = _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(0);
  _M0IP311moonbitlang4core7builtin9SourceLocP311moonbitlang4core7builtin4Show6output(self, { self: logger, method_table: _M0FP095_40moonbitlang_2fcore_2fbuiltin_2eStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return logger.val;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGdE(self) {
  const logger = _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(0);
  _M0IP311moonbitlang4core6double6DoubleP311moonbitlang4core7builtin4Show6output(self, { self: logger, method_table: _M0FP095_40moonbitlang_2fcore_2fbuiltin_2eStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return logger.val;
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6inputs4CodeE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6entity6EntityE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyEE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityEE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeEE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiEE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentEE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGRP311moonbitlang4core6string10StringViewE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGcE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGUicEE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core3int3Int18to__string_2einner(self, radix) {
  return _M0FP311moonbitlang4core7builtin19int__to__string__js(self, radix);
}
function _M0MP311moonbitlang4core6string10StringView12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.end - self.start | 0;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= (self.end - self.start | 0)) ? { str: self.str, start: self.start + start_offset | 0, end: self.start + end_offset$2 | 0 } : _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core6string10StringViewE("Invalid index for View", "@moonbitlang/core/builtin:stringview.mbt:113:5-113:36");
}
function _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(self) {
  return self.str.substring(self.start, self.end);
}
function _M0MP311moonbitlang4core6string10StringView4iter(self) {
  const start = self.start;
  const end = self.end;
  const index = { val: start };
  const _p = () => {
    if (index.val < end) {
      const c1 = self.str.charCodeAt(index.val);
      if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1) && (index.val + 1 | 0) < self.end) {
        const c2 = self.str.charCodeAt(index.val + 1 | 0);
        if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c2)) {
          index.val = index.val + 2 | 0;
          return _M0FP311moonbitlang4core7builtin32code__point__of__surrogate__pair(c1, c2);
        }
      }
      index.val = index.val + 1 | 0;
      return c1;
    } else {
      return -1;
    }
  };
  return _p;
}
function _M0MP311moonbitlang4core7builtin5Iter23newGicE(f) {
  return f;
}
function _M0MP311moonbitlang4core6string10StringView5iter2(self) {
  const start = self.start;
  const end = self.end;
  const index = { val: start };
  const char_index = { val: 0 };
  return _M0MP311moonbitlang4core7builtin5Iter23newGicE(() => {
    if (index.val < end) {
      const c1 = self.str.charCodeAt(index.val);
      if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1) && (index.val + 1 | 0) < self.end) {
        const c2 = self.str.charCodeAt(index.val + 1 | 0);
        if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c2)) {
          const result = { _0: char_index.val, _1: _M0FP311moonbitlang4core7builtin32code__point__of__surrogate__pair(c1, c2) };
          index.val = index.val + 2 | 0;
          char_index.val = char_index.val + 1 | 0;
          return result;
        }
      }
      const result = { _0: char_index.val, _1: c1 };
      index.val = index.val + 1 | 0;
      char_index.val = char_index.val + 1 | 0;
      return result;
    } else {
      return undefined;
    }
  });
}
function _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin2Eq5equal(self, other) {
  const len = self.end - self.start | 0;
  if (len === (other.end - other.start | 0)) {
    if (self.str === other.str && self.start === other.start) {
      return true;
    }
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _p = self.str.charCodeAt(self.start + i | 0);
        const _p$2 = other.str.charCodeAt(other.start + i | 0);
        if (_p === _p$2) {
        } else {
          return false;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return true;
  } else {
    return false;
  }
}
function _M0MP311moonbitlang4core6string6String12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= self.length) ? { str: self, start: start_offset, end: end_offset$2 } : _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core6string10StringViewE("Invalid index for View", "@moonbitlang/core/builtin:stringview.mbt:399:5-399:36");
}
function _M0MP311moonbitlang4core6string6String4view(self, start_offset$46$opt, end_offset) {
  let start_offset;
  if (start_offset$46$opt === undefined) {
    start_offset = 0;
  } else {
    const _Some = start_offset$46$opt;
    start_offset = _Some;
  }
  return _M0MP311moonbitlang4core6string6String12view_2einner(self, start_offset, end_offset);
}
function _M0MP311moonbitlang4core6string6String24char__length__eq_2einner(self, len, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  let _tmp = start_offset;
  let _tmp$2 = 0;
  while (true) {
    const index = _tmp;
    const count = _tmp$2;
    if (index < end_offset$2 && count < len) {
      const c1 = self.charCodeAt(index);
      if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1) && (index + 1 | 0) < end_offset$2) {
        const c2 = self.charCodeAt(index + 1 | 0);
        if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c2)) {
          _tmp = index + 2 | 0;
          _tmp$2 = count + 1 | 0;
          continue;
        } else {
          _M0FP311moonbitlang4core7builtin5abortGuE("invalid surrogate pair", "@moonbitlang/core/builtin:string.mbt:424:9-424:40");
        }
      }
      _tmp = index + 1 | 0;
      _tmp$2 = count + 1 | 0;
      continue;
    } else {
      return count === len && index === end_offset$2;
    }
  }
}
function _M0MP311moonbitlang4core6string6String24char__length__ge_2einner(self, len, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  let _tmp = start_offset;
  let _tmp$2 = 0;
  while (true) {
    const index = _tmp;
    const count = _tmp$2;
    if (index < end_offset$2 && count < len) {
      const c1 = self.charCodeAt(index);
      if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1) && (index + 1 | 0) < end_offset$2) {
        const c2 = self.charCodeAt(index + 1 | 0);
        if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c2)) {
          _tmp = index + 2 | 0;
          _tmp$2 = count + 1 | 0;
          continue;
        } else {
          _M0FP311moonbitlang4core7builtin5abortGuE("invalid surrogate pair", "@moonbitlang/core/builtin:string.mbt:452:9-452:40");
        }
      }
      _tmp = index + 1 | 0;
      _tmp$2 = count + 1 | 0;
      continue;
    } else {
      return count >= len;
    }
  }
}
function _M0MP311moonbitlang4core6string6String31offset__of__nth__char__backward(self, n, start_offset, end_offset) {
  let char_count = 0;
  let utf16_offset = end_offset;
  while (true) {
    if ((utf16_offset - 1 | 0) >= start_offset && char_count < n) {
      const c = self.charCodeAt(utf16_offset - 1 | 0);
      if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c)) {
        utf16_offset = utf16_offset - 2 | 0;
      } else {
        utf16_offset = utf16_offset - 1 | 0;
      }
      char_count = char_count + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return char_count < n || utf16_offset < start_offset ? undefined : utf16_offset;
}
function _M0MP311moonbitlang4core6string6String30offset__of__nth__char__forward(self, n, start_offset, end_offset) {
  if (start_offset >= 0 && start_offset <= end_offset) {
    let utf16_offset = start_offset;
    let char_count = 0;
    while (true) {
      if (utf16_offset < end_offset && char_count < n) {
        const c = self.charCodeAt(utf16_offset);
        if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c)) {
          utf16_offset = utf16_offset + 2 | 0;
        } else {
          utf16_offset = utf16_offset + 1 | 0;
        }
        char_count = char_count + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return char_count < n || utf16_offset >= end_offset ? undefined : utf16_offset;
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGOiE("Invalid start index", "@moonbitlang/core/builtin:string.mbt:327:5-327:33");
  }
}
function _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(self, i, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return i >= 0 ? _M0MP311moonbitlang4core6string6String30offset__of__nth__char__forward(self, i, start_offset, end_offset$2) : _M0MP311moonbitlang4core6string6String31offset__of__nth__char__backward(self, -i | 0, start_offset, end_offset$2);
}
function _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(self, str) {
  const _bind$8 = self;
  _bind$8.val = `${_bind$8.val}${_M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(str)}`;
}
function _M0FP311moonbitlang4core7builtin28boyer__moore__horspool__find(haystack, needle) {
  const haystack_len = haystack.end - haystack.start | 0;
  const needle_len = needle.end - needle.start | 0;
  if (needle_len > 0) {
    if (haystack_len >= needle_len) {
      const skip_table = $make_array_len_and_init(256, needle_len);
      const _end4308 = needle_len - 1 | 0;
      let _tmp = 0;
      while (true) {
        const i = _tmp;
        if (i < _end4308) {
          const _tmp$2 = needle.str.charCodeAt(needle.start + i | 0) & 255;
          $bound_check(skip_table, _tmp$2);
          skip_table[_tmp$2] = (needle_len - 1 | 0) - i | 0;
          _tmp = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      let _tmp$2 = 0;
      while (true) {
        const i = _tmp$2;
        if (i <= (haystack_len - needle_len | 0)) {
          const _end4314 = needle_len - 1 | 0;
          let _tmp$3 = 0;
          while (true) {
            const j = _tmp$3;
            if (j <= _end4314) {
              const _p = i + j | 0;
              const _p$2 = haystack.str.charCodeAt(haystack.start + _p | 0);
              const _p$3 = needle.str.charCodeAt(needle.start + j | 0);
              if (_p$2 !== _p$3) {
                break;
              }
              _tmp$3 = j + 1 | 0;
              continue;
            } else {
              return i;
            }
          }
          const _p = (i + needle_len | 0) - 1 | 0;
          const _tmp$4 = haystack.str.charCodeAt(haystack.start + _p | 0) & 255;
          $bound_check(skip_table, _tmp$4);
          _tmp$2 = i + skip_table[_tmp$4] | 0;
          continue;
        } else {
          break;
        }
      }
      return undefined;
    } else {
      return undefined;
    }
  } else {
    return _M0FP311moonbitlang4core7builtin43boyer__moore__horspool__find_2econstr_2f389;
  }
}
function _M0FP311moonbitlang4core7builtin18brute__force__find(haystack, needle) {
  const haystack_len = haystack.end - haystack.start | 0;
  const needle_len = needle.end - needle.start | 0;
  if (needle_len > 0) {
    if (haystack_len >= needle_len) {
      const _p = 0;
      const needle_first = needle.str.charCodeAt(needle.start + _p | 0);
      const forward_len = haystack_len - needle_len | 0;
      let i = 0;
      while (true) {
        if (i <= forward_len) {
          while (true) {
            let _tmp;
            if (i <= forward_len) {
              const _p$2 = i;
              const _p$3 = haystack.str.charCodeAt(haystack.start + _p$2 | 0);
              _tmp = _p$3 !== needle_first;
            } else {
              _tmp = false;
            }
            if (_tmp) {
              i = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          if (i <= forward_len) {
            let _tmp = 1;
            while (true) {
              const j = _tmp;
              if (j < needle_len) {
                const _p$2 = i + j | 0;
                const _p$3 = haystack.str.charCodeAt(haystack.start + _p$2 | 0);
                const _p$4 = needle.str.charCodeAt(needle.start + j | 0);
                if (_p$3 !== _p$4) {
                  break;
                }
                _tmp = j + 1 | 0;
                continue;
              } else {
                return i;
              }
            }
            i = i + 1 | 0;
          }
          continue;
        } else {
          break;
        }
      }
      return undefined;
    } else {
      return undefined;
    }
  } else {
    return _M0FP311moonbitlang4core7builtin33brute__force__find_2econstr_2f403;
  }
}
function _M0MP311moonbitlang4core6string10StringView4find(self, str) {
  return (str.end - str.start | 0) <= 4 ? _M0FP311moonbitlang4core7builtin18brute__force__find(self, str) : _M0FP311moonbitlang4core7builtin28boyer__moore__horspool__find(self, str);
}
function _M0FP311moonbitlang4core7builtin33boyer__moore__horspool__rev__find(haystack, needle) {
  const haystack_len = haystack.end - haystack.start | 0;
  const needle_len = needle.end - needle.start | 0;
  if (needle_len > 0) {
    if (haystack_len >= needle_len) {
      const skip_table = $make_array_len_and_init(256, needle_len);
      let _tmp = needle_len - 1 | 0;
      while (true) {
        const i = _tmp;
        if (i > 0) {
          const _tmp$2 = needle.str.charCodeAt(needle.start + i | 0) & 255;
          $bound_check(skip_table, _tmp$2);
          skip_table[_tmp$2] = i;
          _tmp = i - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      let _tmp$2 = haystack_len - needle_len | 0;
      while (true) {
        const i = _tmp$2;
        if (i >= 0) {
          let _tmp$3 = 0;
          while (true) {
            const j = _tmp$3;
            if (j < needle_len) {
              const _p = i + j | 0;
              const _p$2 = haystack.str.charCodeAt(haystack.start + _p | 0);
              const _p$3 = needle.str.charCodeAt(needle.start + j | 0);
              if (_p$2 !== _p$3) {
                break;
              }
              _tmp$3 = j + 1 | 0;
              continue;
            } else {
              return i;
            }
          }
          const _tmp$4 = haystack.str.charCodeAt(haystack.start + i | 0) & 255;
          $bound_check(skip_table, _tmp$4);
          _tmp$2 = i - skip_table[_tmp$4] | 0;
          continue;
        } else {
          break;
        }
      }
      return undefined;
    } else {
      return undefined;
    }
  } else {
    return haystack_len;
  }
}
function _M0MP311moonbitlang4core6string10StringView8find__by(self, pred) {
  const _it = _M0MP311moonbitlang4core6string10StringView5iter2(self);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin5Iter24nextGicE(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _i = _x._0;
      const _c = _x._1;
      if (pred(_c)) {
        return _i;
      }
      continue;
    }
  }
  return undefined;
}
function _M0MP311moonbitlang4core6string6String8find__by(self, pred) {
  return _M0MP311moonbitlang4core6string10StringView8find__by({ str: self, start: 0, end: self.length }, pred);
}
function _M0FP311moonbitlang4core7builtin23brute__force__rev__find(haystack, needle) {
  const haystack_len = haystack.end - haystack.start | 0;
  const needle_len = needle.end - needle.start | 0;
  if (needle_len > 0) {
    if (haystack_len >= needle_len) {
      const _p = 0;
      const needle_first = needle.str.charCodeAt(needle.start + _p | 0);
      let i = haystack_len - needle_len | 0;
      while (true) {
        if (i >= 0) {
          while (true) {
            let _tmp;
            if (i >= 0) {
              const _p$2 = i;
              const _p$3 = haystack.str.charCodeAt(haystack.start + _p$2 | 0);
              _tmp = _p$3 !== needle_first;
            } else {
              _tmp = false;
            }
            if (_tmp) {
              i = i - 1 | 0;
              continue;
            } else {
              break;
            }
          }
          if (i >= 0) {
            let _tmp = 1;
            while (true) {
              const j = _tmp;
              if (j < needle_len) {
                const _p$2 = i + j | 0;
                const _p$3 = haystack.str.charCodeAt(haystack.start + _p$2 | 0);
                const _p$4 = needle.str.charCodeAt(needle.start + j | 0);
                if (_p$3 !== _p$4) {
                  break;
                }
                _tmp = j + 1 | 0;
                continue;
              } else {
                return i;
              }
            }
            i = i - 1 | 0;
          }
          continue;
        } else {
          break;
        }
      }
      return undefined;
    } else {
      return undefined;
    }
  } else {
    return haystack_len;
  }
}
function _M0MP311moonbitlang4core6string10StringView9rev__find(self, str) {
  return (str.end - str.start | 0) <= 4 ? _M0FP311moonbitlang4core7builtin23brute__force__rev__find(self, str) : _M0FP311moonbitlang4core7builtin33boyer__moore__horspool__rev__find(self, str);
}
function _M0MP311moonbitlang4core6string10StringView11has__suffix(self, str) {
  const _bind$8 = _M0MP311moonbitlang4core6string10StringView9rev__find(self, str);
  if (_bind$8 === undefined) {
    return false;
  } else {
    const _Some = _bind$8;
    const _i = _Some;
    return _i === ((self.end - self.start | 0) - (str.end - str.start | 0) | 0);
  }
}
function _M0MP311moonbitlang4core6string6String11has__suffix(self, str) {
  return _M0MP311moonbitlang4core6string10StringView11has__suffix({ str: self, start: 0, end: self.length }, str);
}
function _M0MP311moonbitlang4core6string10StringView11has__prefix(self, str) {
  const _bind$8 = _M0MP311moonbitlang4core6string10StringView4find(self, str);
  if (_bind$8 === undefined) {
    return false;
  } else {
    const _Some = _bind$8;
    const _i = _Some;
    return _i === 0;
  }
}
function _M0MP311moonbitlang4core6string6String11has__prefix(self, str) {
  return _M0MP311moonbitlang4core6string10StringView11has__prefix({ str: self, start: 0, end: self.length }, str);
}
function _M0MP311moonbitlang4core5array5Array11new_2einnerGWEuE(capacity) {
  return [];
}
function _M0MP311moonbitlang4core5array5Array11new_2einnerGRP39Milky20186selene6system5TimerE(capacity) {
  return [];
}
function _M0MP311moonbitlang4core5array5Array11new_2einnerGRP39Milky20186selene9collision13CollisionInfoE(capacity) {
  return [];
}
function _M0MP311moonbitlang4core5array5Array4pushGUWdEuiEE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGWdEuE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGWRP39Milky20186selene6system3AppEuE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGURP39Milky20186selene6entity6EntityRP39Milky20186selene4math4RectEE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGdE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene9collision8QuadTreeE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene6system5TimerE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGWRP39Milky20186selene6entity6EntityEuE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene6sprite14AnimationFrameE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene6entity6EntityE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGWRP39Milky20186selene6inputs11MouseButtonEuE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGWEuE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGiE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene9collision13CollisionInfoE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGsE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors16LevelUpSelectionE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors11PowerupTypeE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core6string10StringView14contains__char(self, c) {
  const len = self.end - self.start | 0;
  if (len > 0) {
    const c$2 = c;
    if (c$2 <= 65535) {
      let _tmp = 0;
      while (true) {
        const i = _tmp;
        if (i < len) {
          if (self.str.charCodeAt(self.start + i | 0) === c$2) {
            return true;
          }
          _tmp = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    } else {
      if (len >= 2) {
        const adj = c$2 - 65536 | 0;
        const high = 55296 + (adj >> 10) | 0;
        const low = 56320 + (adj & 1023) | 0;
        let i = 0;
        while (true) {
          if (i < (len - 1 | 0)) {
            const _p = i;
            if (self.str.charCodeAt(self.start + _p | 0) === high) {
              i = i + 1 | 0;
              const _p$2 = i;
              if (self.str.charCodeAt(self.start + _p$2 | 0) === low) {
                return true;
              }
            }
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      } else {
        return false;
      }
    }
    return false;
  } else {
    return false;
  }
}
function _M0MP311moonbitlang4core6string10StringView19trim__start_2einner(self, chars) {
  let _tmp = self;
  while (true) {
    const _param = _tmp;
    if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_param.str, 0, _param.start, _param.end)) {
      return _param;
    } else {
      const _c = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 0, _param.start, _param.end));
      const _tmp$2 = _param.str;
      const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 1, _param.start, _param.end);
      let _tmp$3;
      if (_bind$8 === undefined) {
        _tmp$3 = _param.end;
      } else {
        const _Some = _bind$8;
        _tmp$3 = _Some;
      }
      const _x = { str: _tmp$2, start: _tmp$3, end: _param.end };
      if (_M0MP311moonbitlang4core6string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return _param;
      }
    }
  }
}
function _M0MP311moonbitlang4core6string10StringView17trim__end_2einner(self, chars) {
  let _tmp = self;
  while (true) {
    const _param = _tmp;
    if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_param.str, 0, _param.start, _param.end)) {
      return _param;
    } else {
      const _c = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, -1, _param.start, _param.end));
      const _x = { str: _param.str, start: _param.start, end: _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, -1, _param.start, _param.end) };
      if (_M0MP311moonbitlang4core6string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return _param;
      }
    }
  }
}
function _M0MP311moonbitlang4core6string10StringView12trim_2einner(self, chars) {
  return _M0MP311moonbitlang4core6string10StringView17trim__end_2einner(_M0MP311moonbitlang4core6string10StringView19trim__start_2einner(self, chars), chars);
}
function _M0MP311moonbitlang4core6string10StringView4trim(self, chars$46$opt) {
  let chars;
  if (chars$46$opt === undefined) {
    chars = { str: _M0FP311moonbitlang4core7builtin21trim_2e_2abind_7c6188, start: 0, end: _M0FP311moonbitlang4core7builtin21trim_2e_2abind_7c6188.length };
  } else {
    const _Some = chars$46$opt;
    chars = _Some;
  }
  return _M0MP311moonbitlang4core6string10StringView12trim_2einner(self, chars);
}
function _M0MP311moonbitlang4core6string6String12trim_2einner(self, chars) {
  return _M0MP311moonbitlang4core6string10StringView12trim_2einner({ str: self, start: 0, end: self.length }, chars);
}
function _M0MP311moonbitlang4core6string6String4trim(self, chars$46$opt) {
  let chars;
  if (chars$46$opt === undefined) {
    chars = { str: _M0FP311moonbitlang4core7builtin21trim_2e_2abind_7c6194, start: 0, end: _M0FP311moonbitlang4core7builtin21trim_2e_2abind_7c6194.length };
  } else {
    const _Some = chars$46$opt;
    chars = _Some;
  }
  return _M0MP311moonbitlang4core6string6String12trim_2einner(self, chars);
}
function _M0MP311moonbitlang4core6string10StringView9is__empty(self) {
  return (self.end - self.start | 0) === 0;
}
function _M0MP311moonbitlang4core7builtin4Iter3mapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentERP39Milky20186selene6entity6EntityE(self, f) {
  return () => {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentEE(self);
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      return f(_x);
    }
  };
}
function _M0MP311moonbitlang4core7builtin4Iter3mapGcRP311moonbitlang4core6string10StringViewE(self, f) {
  return () => {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGcE(self);
    if (_bind$8 === -1) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      return f(_x);
    }
  };
}
function _M0IP311moonbitlang4core4char4CharP311moonbitlang4core7builtin4Show10to__string(self) {
  return String.fromCodePoint(self);
}
function _M0MP311moonbitlang4core6string10StringView5split(self, sep) {
  const sep_len = sep.end - sep.start | 0;
  if (sep_len === 0) {
    return _M0MP311moonbitlang4core7builtin4Iter3mapGcRP311moonbitlang4core6string10StringViewE(_M0MP311moonbitlang4core6string10StringView4iter(self), (c) => _M0MP311moonbitlang4core6string6String12view_2einner(_M0IP311moonbitlang4core4char4CharP311moonbitlang4core7builtin4Show10to__string(c), 0, undefined));
  }
  const remaining = { val: self };
  const _p = () => {
    const _bind$8 = remaining.val;
    if (_bind$8 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$8;
      const _view = _Some;
      const _bind$9 = _M0MP311moonbitlang4core6string10StringView4find(_view, sep);
      if (_bind$9 === undefined) {
        remaining.val = undefined;
        return _view;
      } else {
        const _Some$2 = _bind$9;
        const _end = _Some$2;
        remaining.val = _M0MP311moonbitlang4core6string10StringView12view_2einner(_view, _end + sep_len | 0, undefined);
        return _M0MP311moonbitlang4core6string10StringView12view_2einner(_view, 0, _end);
      }
    }
  };
  return _p;
}
function _M0MP311moonbitlang4core6string6String5split(self, sep) {
  return _M0MP311moonbitlang4core6string10StringView5split({ str: self, start: 0, end: self.length }, sep);
}
function _M0MP311moonbitlang4core4char4Char20is__ascii__uppercase(self) {
  return self >= 65 && self <= 90;
}
function _M0MP311moonbitlang4core6string6String9to__lower(self) {
  const _bind$8 = _M0MP311moonbitlang4core6string6String8find__by(self, (x) => _M0MP311moonbitlang4core4char4Char20is__ascii__uppercase(x));
  if (_bind$8 === undefined) {
    return self;
  } else {
    const _Some = _bind$8;
    const _idx = _Some;
    const buf = _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(self.length);
    const head = _M0MP311moonbitlang4core6string6String12view_2einner(self, 0, _idx);
    _M0IP016_24default__implP311moonbitlang4core7builtin6Logger16write__substringGRP311moonbitlang4core7builtin13StringBuilderE(buf, head.str, head.start, head.end - head.start | 0);
    const _it = _M0MP311moonbitlang4core6string10StringView4iter(_M0MP311moonbitlang4core6string6String12view_2einner(self, _idx, undefined));
    while (true) {
      const _bind$9 = _M0MP311moonbitlang4core7builtin4Iter4nextGcE(_it);
      if (_bind$9 === -1) {
        break;
      } else {
        const _Some$2 = _bind$9;
        const _c = _Some$2;
        if (_M0MP311moonbitlang4core4char4Char20is__ascii__uppercase(_c)) {
          _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__char(buf, _c + 32 | 0);
        } else {
          _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__char(buf, _c);
        }
        continue;
      }
    }
    return buf.val;
  }
}
function _M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin12ToStringView16to__string__view(self) {
  return { str: self, start: 0, end: self.length };
}
function _M0IP311moonbitlang4core3int3IntP311moonbitlang4core7builtin4Show6output(self, logger) {
  logger.method_table.method_0(logger.self, _M0MP311moonbitlang4core3int3Int18to__string_2einner(self, 10));
}
function _M0MP311moonbitlang4core5array10FixedArray5makeiGjE(length, value) {
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
function _M0MP311moonbitlang4core5array9ArrayView2atGRP39Milky20186selene9collision8QuadTreeE(self, index) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    return _tmp[_tmp$2];
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGRP39Milky20186selene9collision8QuadTreeE(`index out of bounds: the len is from 0 to ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self.end - self.start | 0)} but the index is ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(index)}`, "@moonbitlang/core/builtin:arrayview.mbt:124:5-126:6");
  }
}
function _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom17HTMLCanvasElementE(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2DE(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom13KeyboardEventE(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function _M0MP311moonbitlang4core6option6Option6unwrapGRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self) {
  if (self.$tag === 0) {
    return $panic();
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function _M0MP311moonbitlang4core6option6Option10unwrap__orGdE(self, default_) {
  if (self.$tag === 0) {
    return default_;
  } else {
    const _Some = self;
    return _Some._0;
  }
}
function _M0MP311moonbitlang4core6option6Option19unwrap__or__defaultGRP39Milky20186selene4math5Vec2DE(self) {
  if (self === undefined) {
    return _M0IP39Milky20186selene4math5Vec2DP311moonbitlang4core7builtin7Default7default();
  } else {
    const _Some = self;
    return _Some;
  }
}
function _M0MP311moonbitlang4core6option6Option7map__orGRP39Milky20186selene6entity6ParentRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene6entity6EntityEE(self, default_, f) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _x = _Some;
    return f(_x);
  }
}
function _M0MP311moonbitlang4core6option6Option7map__orGRP39Milky20186selene6sprite6SpriteiE(self, default_, f) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _x = _Some;
    return f(_x);
  }
}
function _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(self, index) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    return _tmp[_tmp$2];
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGUWdEuiEE(`index out of bounds: the len is from 0 to ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self.end - self.start | 0)} but the index is ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(index)}`, "@moonbitlang/core/builtin:mutarrayview.mbt:118:5-120:6");
  }
}
function _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(self, index) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    return _tmp[_tmp$2];
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(`index out of bounds: the len is from 0 to ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self.end - self.start | 0)} but the index is ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(index)}`, "@moonbitlang/core/builtin:mutarrayview.mbt:118:5-120:6");
  }
}
function _M0MP311moonbitlang4core5array12MutArrayView3setGUWdEuiEE(self, index, value) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    _tmp[_tmp$2] = value;
    return;
  } else {
    _M0FP311moonbitlang4core7builtin5abortGuE(`index out of bounds: the len is from 0 to ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self.end - self.start | 0)} but the index is ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(index)}`, "@moonbitlang/core/builtin:mutarrayview.mbt:182:5-184:6");
    return;
  }
}
function _M0MP311moonbitlang4core5array12MutArrayView3setGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(self, index, value) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp = self.buf;
    const _tmp$2 = self.start + index | 0;
    $bound_check(_tmp, _tmp$2);
    _tmp[_tmp$2] = value;
    return;
  } else {
    _M0FP311moonbitlang4core7builtin5abortGuE(`index out of bounds: the len is from 0 to ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self.end - self.start | 0)} but the index is ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(index)}`, "@moonbitlang/core/builtin:mutarrayview.mbt:182:5-184:6");
    return;
  }
}
function _M0MP311moonbitlang4core5array5Array17mut__view_2einnerGUWdEuiEE(self, start, end) {
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
    const _bind$8 = self;
    const _bind$9 = end$2 - start$2 | 0;
    return { buf: _bind$8, start: start$2, end: start$2 + _bind$9 | 0 };
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core7builtin12MutArrayViewGUWdEuiEEE("View index out of bounds", "@moonbitlang/core/builtin:mutarrayview.mbt:258:5-258:38");
  }
}
function _M0MP311moonbitlang4core5array5Array17mut__view_2einnerGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(self, start, end) {
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
    const _bind$8 = self;
    const _bind$9 = end$2 - start$2 | 0;
    return { buf: _bind$8, start: start$2, end: start$2 + _bind$9 | 0 };
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core7builtin12MutArrayViewGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEEE("View index out of bounds", "@moonbitlang/core/builtin:mutarrayview.mbt:258:5-258:38");
  }
}
function _M0MP311moonbitlang4core5array12MutArrayView17mut__view_2einnerGUWdEuiEE(self, start, end) {
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
  if (start$2 >= 0 && (start$2 <= end$2 && end$2 <= len)) {
    const _bind$8 = self.buf;
    const _bind$9 = self.start + start$2 | 0;
    const _bind$10 = end$2 - start$2 | 0;
    return { buf: _bind$8, start: _bind$9, end: _bind$9 + _bind$10 | 0 };
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core7builtin12MutArrayViewGUWdEuiEEE("View index out of bounds", "@moonbitlang/core/builtin:mutarrayview.mbt:307:5-307:38");
  }
}
function _M0MP311moonbitlang4core5array12MutArrayView17mut__view_2einnerGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(self, start, end) {
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
  if (start$2 >= 0 && (start$2 <= end$2 && end$2 <= len)) {
    const _bind$8 = self.buf;
    const _bind$9 = self.start + start$2 | 0;
    const _bind$10 = end$2 - start$2 | 0;
    return { buf: _bind$8, start: _bind$9, end: _bind$9 + _bind$10 | 0 };
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core7builtin12MutArrayViewGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEEE("View index out of bounds", "@moonbitlang/core/builtin:mutarrayview.mbt:307:5-307:38");
  }
}
function _M0MP311moonbitlang4core5array5Array3setGdE(self, index, value) {
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
function _M0MP311moonbitlang4core3int3Int20next__power__of__two(self) {
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
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map11new_2einnerGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, idx, entry) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10set__entryGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map10push__awayGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, idx, entry) {
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
      _M0MP311moonbitlang4core7builtin3Map10set__entryGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core7builtin3Map10set__entryGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _M0IP39Milky201817selene_2dexamples9survivors9EnemyTypeP311moonbitlang4core7builtin2Eq5equal(_curr_entry.key, key)) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
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
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map15set__with__hashGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx);
    const _bind$8 = _tmp$3[idx];
    if (_bind$8 === undefined) {
      if (self.size >= self.grow_at) {
        _M0MP311moonbitlang4core7builtin3Map4growGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$9 = self.tail;
      const _bind$10 = undefined;
      const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
      _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MP311moonbitlang4core7builtin3Map4growGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MP311moonbitlang4core7builtin3Map10push__awayGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, idx, _curr_entry);
        const _bind$9 = self.tail;
        const _bind$10 = undefined;
        const entry = { prev: _bind$9, next: _bind$10, psl: psl, hash: hash, key: key, value: value };
        _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map4growGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self) {
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
      _M0MP311moonbitlang4core7builtin3Map15set__with__hashGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, _key, _value, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3setGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, key, value) {
  _M0MP311moonbitlang4core7builtin3Map15set__with__hashGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, key, value, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGsE(key));
}
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(key);
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
      if (_entry.hash === hash && _M0IP39Milky201817selene_2dexamples9survivors9EnemyTypeP311moonbitlang4core7builtin2Eq5equal(_entry.key, key)) {
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
      let _tmp$4;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$4 = _p === key;
      } else {
        _tmp$4 = false;
      }
      if (_tmp$4) {
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
function _M0MP311moonbitlang4core7builtin3Map3getGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGsE(key);
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
      if (_entry.hash === hash && _entry.key === key) {
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
function _M0MP311moonbitlang4core7builtin3Map13get__or__initGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, key, default_) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
    _M0MP311moonbitlang4core7builtin3Map4growGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self);
    _M0MP311moonbitlang4core7builtin3Map15set__with__hashGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, key, _new_value, hash);
  } else {
    if (_push_away === undefined) {
    } else {
      const _Some = _push_away;
      const _entry = _Some;
      _M0MP311moonbitlang4core7builtin3Map10push__awayGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, _idx, _entry);
    }
    const entry = { prev: self.tail, next: undefined, psl: _psl, hash: hash, key: key, value: _new_value };
    _M0MP311moonbitlang4core7builtin3Map20add__entry__to__tailGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self, _idx, entry);
  }
  return _new_value;
}
function _M0MP311moonbitlang4core7builtin3Map8containsGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core5array10FixedArray12fill_2einnerGORP311moonbitlang4core7builtin5EntryGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEEE(self, value, start, end) {
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
function _M0MP311moonbitlang4core5array10FixedArray12fill_2einnerGORP311moonbitlang4core3set5EntryGRP39Milky20186selene6inputs4CodeEE(self, value, start, end) {
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
function _M0MP311moonbitlang4core5array10FixedArray12fill_2einnerGORP311moonbitlang4core7builtin5EntryGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyEE(self, value, start, end) {
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
function _M0MP311moonbitlang4core7builtin3Map5clearGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(self) {
  _M0MP311moonbitlang4core5array10FixedArray12fill_2einnerGORP311moonbitlang4core7builtin5EntryGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEEE(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function _M0MP311moonbitlang4core7builtin3Map5clearGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self) {
  _M0MP311moonbitlang4core5array10FixedArray12fill_2einnerGORP311moonbitlang4core7builtin5EntryGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyEE(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function _M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self) {
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
function _M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self) {
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
function _M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self) {
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
function _M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self) {
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
function _M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(self) {
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
function _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self) {
  return _M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self);
}
function _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self) {
  return _M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self);
}
function _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self) {
  return _M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self);
}
function _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self) {
  return _M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self);
}
function _M0MP311moonbitlang4core7builtin3Map9to__arrayGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(self) {
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
function _M0MP311moonbitlang4core7builtin7MyInt6414extend__i32__u(value) {
  return { hi: 0, lo: value };
}
function _M0MP311moonbitlang4core6uint646UInt6412extend__uint(value) {
  return _M0MP311moonbitlang4core7builtin7MyInt6414extend__i32__u(value);
}
function _M0MP311moonbitlang4core4uint4UInt10to__uint64(self) {
  return _M0MP311moonbitlang4core6uint646UInt6412extend__uint(self);
}
function _M0MP311moonbitlang4core6double6Double15convert__uint64(value) {
  return _M0MP311moonbitlang4core7builtin7MyInt6422convert__to__double__u(value);
}
function _M0MP311moonbitlang4core5int645Int6423reinterpret__as__double(self) {
  return _M0MP311moonbitlang4core7builtin7MyInt6423reinterpret__as__double(self);
}
function _M0MP311moonbitlang4core7builtin4Iter6filterGURP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentEE(self, f) {
  return () => {
    while (true) {
      const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentEE(self);
      if (_bind$8 === undefined) {
        return undefined;
      } else {
        const _Some = _bind$8;
        const _x = _Some;
        if (f(_x)) {
          return _x;
        }
        continue;
      }
    }
  };
}
function _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(self) {
  return _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyEE(self);
}
function _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(self) {
  return _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityEE(self);
}
function _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(self) {
  return _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeEE(self);
}
function _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(self) {
  return _M0MP311moonbitlang4core7builtin4Iter4nextGURP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiEE(self);
}
function _M0MP311moonbitlang4core7builtin5Iter24nextGicE(self) {
  return _M0MP311moonbitlang4core7builtin4Iter4nextGUicEE(self);
}
function _M0MP311moonbitlang4core4byte4Byte9to__int64(self) {
  return _M0MP311moonbitlang4core3int3Int9to__int64(self);
}
function _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Neg3neg(self) {
  return self.lo === 0 ? { hi: ~self.hi + 1 | 0, lo: 0 } : { hi: ~self.hi, lo: ~self.lo + 1 | 0 };
}
function _M0MP311moonbitlang4core7builtin7MyInt6411add__hi__lo(self, bhi, blo) {
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
function _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Add3add(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt6411add__hi__lo(self, other.hi, other.lo);
}
function _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Sub3sub(self, other) {
  return other.lo === 0 ? { hi: self.hi - other.hi | 0, lo: self.lo } : _M0MP311moonbitlang4core7builtin7MyInt6411add__hi__lo(self, ~other.hi, ~other.lo + 1 | 0);
}
function _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Mul3mul(self, other) {
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
function _M0FP311moonbitlang4core7builtin29try__get__int64__wasm__helper() {
  if (_M0FP311moonbitlang4core7builtin19wasm__helper__cache.tried) {
    const _bind$8 = _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports;
    return !(_bind$8 === undefined);
  }
  _M0FP311moonbitlang4core7builtin19wasm__helper__cache.tried = true;
  _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports = _M0FP311moonbitlang4core7builtin23try__init__wasm__helper();
  const _bind$8 = _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports;
  return !(_bind$8 === undefined);
}
function _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Div3div(self, other) {
  if (!(other.hi === 0 && other.lo === 0)) {
    if (!_M0FP311moonbitlang4core7builtin29try__get__int64__wasm__helper()) {
      return _M0MP311moonbitlang4core7builtin7MyInt6411div__bigint(self, other);
    }
    const _bind$8 = _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports;
    if (_bind$8 === undefined) {
      return $panic();
    } else {
      const _Some = _bind$8;
      const _exports = _Some;
      const _ahi = self.hi;
      const _alo = self.lo;
      const _bhi = other.hi;
      const _blo = other.lo;
      const _func = _exports.div_s;
      const lo = _func(_alo, _ahi, _blo, _bhi);
      const _func$2 = _exports.get_high;
      const hi = _func$2();
      return { hi: hi, lo: lo };
    }
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core7builtin7MyInt646div__u(self, other) {
  if (!(other.hi === 0 && other.lo === 0)) {
    if (!_M0FP311moonbitlang4core7builtin29try__get__int64__wasm__helper()) {
      return _M0MP311moonbitlang4core7builtin7MyInt6414div__u__bigint(self, other);
    }
    const _bind$8 = _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports;
    if (_bind$8 === undefined) {
      return $panic();
    } else {
      const _Some = _bind$8;
      const _exports = _Some;
      const _ahi = self.hi;
      const _alo = self.lo;
      const _bhi = other.hi;
      const _blo = other.lo;
      const _func = _exports.div_u;
      const lo = _func(_alo, _ahi, _blo, _bhi);
      const _func$2 = _exports.get_high;
      const hi = _func$2();
      return { hi: hi, lo: lo };
    }
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core7builtin7MyInt646mod__u(self, other) {
  if (!(other.hi === 0 && other.lo === 0)) {
    if (!_M0FP311moonbitlang4core7builtin29try__get__int64__wasm__helper()) {
      return _M0MP311moonbitlang4core7builtin7MyInt6414mod__u__bigint(self, other);
    }
    const _bind$8 = _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports;
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
function _M0MP311moonbitlang4core7builtin7MyInt644lnot(self) {
  return { hi: ~self.hi, lo: ~self.lo };
}
function _M0MP311moonbitlang4core7builtin7MyInt644land(self, other) {
  return { hi: self.hi & other.hi, lo: self.lo & other.lo };
}
function _M0MP311moonbitlang4core7builtin7MyInt643lor(self, other) {
  return { hi: self.hi | other.hi, lo: self.lo | other.lo };
}
function _M0MP311moonbitlang4core7builtin7MyInt643lsl(self, shift) {
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
function _M0MP311moonbitlang4core7builtin7MyInt643lsr(self, shift) {
  const shift$2 = shift & 63;
  return shift$2 === 0 ? self : shift$2 < 32 ? { hi: self.hi >>> shift$2 | 0, lo: self.lo >>> shift$2 | self.hi << (32 - shift$2 | 0) } : { hi: 0, lo: self.hi >>> (shift$2 - 32 | 0) | 0 };
}
function _M0MP311moonbitlang4core7builtin7MyInt643asr(self, shift) {
  const shift$2 = shift & 63;
  return shift$2 === 0 ? self : shift$2 < 32 ? { hi: self.hi >> shift$2, lo: self.lo >>> shift$2 | self.hi << (32 - shift$2 | 0) } : { hi: self.hi >> 31, lo: self.hi >> (shift$2 - 32 | 0) };
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Neg3neg(self) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Neg3neg(self);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Add3add(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Sub3sub(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Sub3sub(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Mul3mul(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Div3div(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin6BitAnd4land(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt644land(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin5BitOr3lor(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt643lor(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shr3shr(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt643asr(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shl3shl(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt643lsl(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin2Eq5equal(self, other) {
  const _p = self;
  const _p$2 = other;
  return _p.hi === _p$2.hi && _p.lo === _p$2.lo;
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt647compare(self, other);
}
function _M0MP311moonbitlang4core5int645Int647to__int(self) {
  const _p = self;
  return _p.lo;
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Add3add(self, other);
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Sub3sub(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Sub3sub(self, other);
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Mul3mul(self, other);
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Div3div(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt646div__u(self, other);
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mod3mod(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt646mod__u(self, other);
}
function _M0MP311moonbitlang4core6uint646UInt648to__uint(self) {
  const _p = self;
  return _p.lo;
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin7Compare7compare(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt6410compare__u(self, other);
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin2Eq5equal(self, other) {
  const _p = self;
  const _p$2 = other;
  return _p.hi === _p$2.hi && _p.lo === _p$2.lo;
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin6BitAnd4land(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt644land(self, other);
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin5BitOr3lor(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt643lor(self, other);
}
function _M0MP311moonbitlang4core6uint646UInt644lnot(self) {
  return _M0MP311moonbitlang4core7builtin7MyInt644lnot(self);
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shl3shl(self, shift) {
  return _M0MP311moonbitlang4core7builtin7MyInt643lsl(self, shift);
}
function _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(self, shift) {
  return _M0MP311moonbitlang4core7builtin7MyInt643lsr(self, shift);
}
function _M0MP311moonbitlang4core6uint646UInt643clz(self) {
  const _p = self;
  return _p.hi !== 0 ? Math.clz32(_p.hi) : 32 + Math.clz32(_p.lo) | 0;
}
function _M0MP311moonbitlang4core7builtin6Hasher15combine__string(self, value) {
  const _end2501 = value.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _end2501) {
      _M0MP311moonbitlang4core7builtin6Hasher13combine__uint(self, value.charCodeAt(i));
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Hash13hash__combine(self, hasher) {
  _M0MP311moonbitlang4core7builtin6Hasher15combine__string(hasher, self);
}
function _M0IP311moonbitlang4core4uint4UIntP311moonbitlang4core7builtin4Hash13hash__combine(self, hasher) {
  _M0MP311moonbitlang4core7builtin6Hasher13combine__uint(hasher, self);
}
function _M0MP311moonbitlang4core5array10FixedArray16blit__to_2einnerGjE(self, dst, len, src_offset, dst_offset) {
  if (dst_offset >= 0 && (src_offset >= 0 && ((dst_offset + len | 0) <= dst.length && (src_offset + len | 0) <= self.length))) {
    _M0MP311moonbitlang4core5array10FixedArray12unsafe__blitGjE(dst, dst_offset, self, src_offset, len);
    return;
  } else {
    _M0FP311moonbitlang4core7builtin5abortGuE(`bounds check failed: dst_offset = ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(dst_offset)}, src_offset = ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(src_offset)}, len = ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(len)}, dst.length = ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(dst.length)}, self.length = ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self.length)}`, "@moonbitlang/core/builtin:fixedarray_block.mbt:115:5-117:6");
    return;
  }
}
function _M0MP311moonbitlang4core6double6Double8to__uint(self) {
  return self !== self ? 0 : self >= 4294967295 ? -1 : self <= 0 ? 0 : self | 0;
}
function _M0MP311moonbitlang4core6double6Double7to__int(self) {
  return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
}
function _M0MP311moonbitlang4core6double6Double10to__string(self) {
  return _M0FP311moonbitlang4core7builtin15ryu__to__string(self);
}
function _M0IP311moonbitlang4core6double6DoubleP311moonbitlang4core7builtin4Show6output(self, logger) {
  logger.method_table.method_0(logger.self, _M0MP311moonbitlang4core6double6Double10to__string(self));
}
function _M0FP311moonbitlang4core7builtin7printlnGsE(input) {
  console.log(input);
}
function _M0MP311moonbitlang4core5bytes5Bytes12view_2einner(self, start, end) {
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
    const _bind$8 = end$2 - start$2 | 0;
    return { bytes: self, start: start$2, end: start$2 + _bind$8 | 0 };
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core5bytes9BytesViewE("Invalid index for View", "@moonbitlang/core/builtin:bytesview.mbt:180:5-180:36");
  }
}
function _M0IP311moonbitlang4core4byte4ByteP311moonbitlang4core7builtin3Shr3shr(self, count) {
  return (self >>> count | 0) & 255;
}
function _M0MP311moonbitlang4core5bytes9BytesView21unsafe__extract__byte(bs, offset, len) {
  const byte_index = offset >> 3;
  if ((offset & 7) === 0) {
    const _tmp = bs.bytes;
    const _tmp$2 = bs.start + byte_index | 0;
    $bound_check(_tmp, _tmp$2);
    const byte = _tmp[_tmp$2];
    const _p = _M0IP311moonbitlang4core4byte4ByteP311moonbitlang4core7builtin3Shr3shr(byte, 8 - len | 0);
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
function _M0MP311moonbitlang4core5bytes9BytesView25unsafe__extract__uint__le(bs, offset, len) {
  const bytes_needed = (len + 7 | 0) / 8 | 0;
  const b0 = _M0MP311moonbitlang4core5bytes9BytesView21unsafe__extract__byte(bs, offset, 8);
  switch (bytes_needed) {
    case 2: {
      const b1 = _M0MP311moonbitlang4core5bytes9BytesView21unsafe__extract__byte(bs, offset + 8 | 0, len - 8 | 0);
      return b1 << 8 | b0;
    }
    case 3: {
      const b1$2 = _M0MP311moonbitlang4core5bytes9BytesView21unsafe__extract__byte(bs, offset + 8 | 0, 8);
      const b2 = _M0MP311moonbitlang4core5bytes9BytesView21unsafe__extract__byte(bs, offset + 16 | 0, len - 16 | 0);
      return b2 << 16 | b1$2 << 8 | b0;
    }
    case 4: {
      const b1$3 = _M0MP311moonbitlang4core5bytes9BytesView21unsafe__extract__byte(bs, offset + 8 | 0, 8);
      const b2$2 = _M0MP311moonbitlang4core5bytes9BytesView21unsafe__extract__byte(bs, offset + 16 | 0, 8);
      const b3 = _M0MP311moonbitlang4core5bytes9BytesView21unsafe__extract__byte(bs, offset + 24 | 0, len - 24 | 0);
      return b3 << 24 | b2$2 << 16 | b1$3 << 8 | b0;
    }
    default: {
      return _M0FP311moonbitlang4core7builtin5abortGjE("Invalid byte count for int32 extraction", "@moonbitlang/core/builtin:bitstring.mbt:663:10-663:58");
    }
  }
}
function _M0IP311moonbitlang4core7builtin13SourceLocReprP311moonbitlang4core7builtin4Show6output(self, logger) {
  const pkg = self.pkg;
  const _data = pkg.str;
  const _start = pkg.start;
  const _end = _start + (pkg.end - pkg.start | 0) | 0;
  let _cursor = _start;
  let accept_state = -1;
  let match_end = -1;
  let match_tag_saver_0 = -1;
  let tag_0 = -1;
  let _bind$8;
  _L: {
    _L$2: {
      _L$3: while (true) {
        if (_cursor < _end) {
          const _p = _cursor;
          const next_char = _data.charCodeAt(_p);
          _cursor = _cursor + 1 | 0;
          if (next_char === 47) {
            _L$4: while (true) {
              tag_0 = _cursor;
              if (_cursor < _end) {
                const _p$2 = _cursor;
                const next_char$2 = _data.charCodeAt(_p$2);
                _cursor = _cursor + 1 | 0;
                if (next_char$2 === 47) {
                  while (true) {
                    if (_cursor < _end) {
                      const _p$3 = _cursor;
                      _data.charCodeAt(_p$3);
                      _cursor = _cursor + 1 | 0;
                      continue;
                    } else {
                      match_tag_saver_0 = tag_0;
                      accept_state = 0;
                      match_end = _cursor;
                      break _L$2;
                    }
                  }
                } else {
                  continue;
                }
              } else {
                break _L$2;
              }
            }
          } else {
            continue;
          }
        } else {
          break _L$2;
        }
      }
      break _L;
    }
    if (accept_state === 0) {
      const package_name = _M0MP311moonbitlang4core6string6String4view(_data, match_tag_saver_0 + 1 | 0, match_end);
      const module_name = _M0MP311moonbitlang4core6string6String4view(_data, _start, match_tag_saver_0);
      _bind$8 = { _0: module_name, _1: package_name };
    } else {
      _bind$8 = { _0: pkg, _1: undefined };
    }
  }
  const _module_name = _bind$8._0;
  const _package_name = _bind$8._1;
  if (_package_name === undefined) {
  } else {
    const _Some = _package_name;
    const _pkg_name = _Some;
    logger.method_table.method_2(logger.self, _pkg_name);
    logger.method_table.method_3(logger.self, 47);
  }
  logger.method_table.method_2(logger.self, self.filename);
  logger.method_table.method_3(logger.self, 58);
  logger.method_table.method_2(logger.self, self.start_line);
  logger.method_table.method_3(logger.self, 58);
  logger.method_table.method_2(logger.self, self.start_column);
  logger.method_table.method_3(logger.self, 45);
  logger.method_table.method_2(logger.self, self.end_line);
  logger.method_table.method_3(logger.self, 58);
  logger.method_table.method_2(logger.self, self.end_column);
  logger.method_table.method_3(logger.self, 64);
  logger.method_table.method_2(logger.self, _module_name);
}
function _M0IP311moonbitlang4core7builtin9SourceLocP311moonbitlang4core7builtin4Show6output(self, logger) {
  _M0IP311moonbitlang4core7builtin13SourceLocReprP311moonbitlang4core7builtin4Show6output(_M0MP311moonbitlang4core7builtin13SourceLocRepr5parse(self), logger);
}
function _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGWEuE(self, new_len) {
  _M0MP311moonbitlang4core7builtin7JSArray11set__length(self, new_len);
}
function _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGRP39Milky20186selene6system5TimerE(self, new_len) {
  _M0MP311moonbitlang4core7builtin7JSArray11set__length(self, new_len);
}
function _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGiE(self, new_len) {
  _M0MP311moonbitlang4core7builtin7JSArray11set__length(self, new_len);
}
function _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(self, new_len) {
  _M0MP311moonbitlang4core7builtin7JSArray11set__length(self, new_len);
}
function _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGdE(self, new_len) {
  _M0MP311moonbitlang4core7builtin7JSArray11set__length(self, new_len);
}
function _M0MP311moonbitlang4core5array5Array11unsafe__popGiE(self) {
  return _M0MP311moonbitlang4core7builtin7JSArray3pop(self);
}
function _M0MP311moonbitlang4core5array5Array3popGiE(self) {
  if (self.length === 0) {
    return undefined;
  } else {
    const v = _M0MP311moonbitlang4core5array5Array11unsafe__popGiE(self);
    return v;
  }
}
function _M0MP311moonbitlang4core5array12MutArrayView4swapGUWdEuiEE(arr, i, j) {
  const temp = _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, i);
  _M0MP311moonbitlang4core5array12MutArrayView3setGUWdEuiEE(arr, i, _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, j));
  _M0MP311moonbitlang4core5array12MutArrayView3setGUWdEuiEE(arr, j, temp);
}
function _M0MP311moonbitlang4core5array12MutArrayView4swapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, i, j) {
  const temp = _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, i);
  _M0MP311moonbitlang4core5array12MutArrayView3setGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, i, _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j));
  _M0MP311moonbitlang4core5array12MutArrayView3setGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j, temp);
}
function _M0MP311moonbitlang4core5array12MutArrayView5sliceGUWdEuiEE(arr, start, end) {
  return _M0MP311moonbitlang4core5array12MutArrayView17mut__view_2einnerGUWdEuiEE(arr, start, end);
}
function _M0MP311moonbitlang4core5array12MutArrayView5sliceGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, start, end) {
  return _M0MP311moonbitlang4core5array12MutArrayView17mut__view_2einnerGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, start, end);
}
function _M0MP311moonbitlang4core5array12MutArrayView14rev__in__placeGUWdEuiEE(arr) {
  const len = arr.end - arr.start | 0;
  const mid_len = len / 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < mid_len) {
      const j = (len - i | 0) - 1 | 0;
      const temp = _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, i);
      _M0MP311moonbitlang4core5array12MutArrayView3setGUWdEuiEE(arr, i, _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, j));
      _M0MP311moonbitlang4core5array12MutArrayView3setGUWdEuiEE(arr, j, temp);
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP311moonbitlang4core5array12MutArrayView14rev__in__placeGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr) {
  const len = arr.end - arr.start | 0;
  const mid_len = len / 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < mid_len) {
      const j = (len - i | 0) - 1 | 0;
      const temp = _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, i);
      _M0MP311moonbitlang4core5array12MutArrayView3setGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, i, _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j));
      _M0MP311moonbitlang4core5array12MutArrayView3setGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j, temp);
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP311moonbitlang4core7builtin17fixed__get__limit(len) {
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
function _M0FP311moonbitlang4core7builtin23fixed__bubble__sort__byGUWdEuiEE(arr, cmp) {
  const _end540 = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _end540) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, j - 1 | 0), _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, j)) > 0) {
          _M0MP311moonbitlang4core5array12MutArrayView4swapGUWdEuiEE(arr, j, j - 1 | 0);
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
function _M0FP311moonbitlang4core7builtin23fixed__bubble__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, cmp) {
  const _end540 = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _end540) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j - 1 | 0), _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j)) > 0) {
          _M0MP311moonbitlang4core5array12MutArrayView4swapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j, j - 1 | 0);
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
function _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__2_2f2272(_env, a, b) {
  const cmp = _env._2;
  const swaps = _env._1;
  const arr = _env._0;
  if (cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, a), _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, b)) > 0) {
    _M0MP311moonbitlang4core5array12MutArrayView4swapGUWdEuiEE(arr, a, b);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2273(_env, a, b, c) {
  _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__2_2f2272(_env, a, b);
  _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__2_2f2272(_env, b, c);
  _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__2_2f2272(_env, a, b);
}
function _M0FP311moonbitlang4core7builtin24fixed__choose__pivot__byGUWdEuiEE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const swaps = { val: 0 };
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: arr, _1: swaps, _2: cmp };
    if (len > 50) {
      _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2273(_env, a - 1 | 0, a, a + 1 | 0);
      _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2273(_env, b - 1 | 0, b, b + 1 | 0);
      _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2273(_env, c - 1 | 0, c, c + 1 | 0);
    }
    _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2273(_env, a, b, c);
  }
  if (swaps.val === 12) {
    _M0MP311moonbitlang4core5array12MutArrayView14rev__in__placeGUWdEuiEE(arr);
    return { _0: (len - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: b, _1: swaps.val === 0 };
  }
}
function _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__2_2f2292(_env, a, b) {
  const cmp = _env._2;
  const swaps = _env._1;
  const arr = _env._0;
  if (cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, a), _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, b)) > 0) {
    _M0MP311moonbitlang4core5array12MutArrayView4swapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, a, b);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2293(_env, a, b, c) {
  _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__2_2f2292(_env, a, b);
  _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__2_2f2292(_env, b, c);
  _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__2_2f2292(_env, a, b);
}
function _M0FP311moonbitlang4core7builtin24fixed__choose__pivot__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const swaps = { val: 0 };
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: arr, _1: swaps, _2: cmp };
    if (len > 50) {
      _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2293(_env, a - 1 | 0, a, a + 1 | 0);
      _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2293(_env, b - 1 | 0, b, b + 1 | 0);
      _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2293(_env, c - 1 | 0, c, c + 1 | 0);
    }
    _M0FP311moonbitlang4core7builtin41fixed__choose__pivot__by_2esort__3_2f2293(_env, a, b, c);
  }
  if (swaps.val === 12) {
    _M0MP311moonbitlang4core5array12MutArrayView14rev__in__placeGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr);
    return { _0: (len - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: b, _1: swaps.val === 0 };
  }
}
function _M0FP311moonbitlang4core7builtin21fixed__sift__down__byGUWdEuiEE(arr, index, cmp) {
  let index$2 = index;
  const len = arr.end - arr.start | 0;
  let child = (Math.imul(index$2, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      if ((child + 1 | 0) < len && cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, child), _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, child + 1 | 0)) < 0) {
        child = child + 1 | 0;
      }
      if (cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, index$2), _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, child)) >= 0) {
        return undefined;
      }
      _M0MP311moonbitlang4core5array12MutArrayView4swapGUWdEuiEE(arr, index$2, child);
      index$2 = child;
      child = (Math.imul(index$2, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP311moonbitlang4core7builtin21fixed__sift__down__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, index, cmp) {
  let index$2 = index;
  const len = arr.end - arr.start | 0;
  let child = (Math.imul(index$2, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      if ((child + 1 | 0) < len && cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, child), _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, child + 1 | 0)) < 0) {
        child = child + 1 | 0;
      }
      if (cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, index$2), _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, child)) >= 0) {
        return undefined;
      }
      _M0MP311moonbitlang4core5array12MutArrayView4swapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, index$2, child);
      index$2 = child;
      child = (Math.imul(index$2, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP311moonbitlang4core7builtin21fixed__heap__sort__byGUWdEuiEE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  let _tmp = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp;
    if (i >= 0) {
      _M0FP311moonbitlang4core7builtin21fixed__sift__down__byGUWdEuiEE(arr, i, cmp);
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
      _M0MP311moonbitlang4core5array12MutArrayView4swapGUWdEuiEE(arr, 0, i);
      _M0FP311moonbitlang4core7builtin21fixed__sift__down__byGUWdEuiEE(_M0MP311moonbitlang4core5array12MutArrayView5sliceGUWdEuiEE(arr, 0, i), 0, cmp);
      _tmp$2 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP311moonbitlang4core7builtin21fixed__heap__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  let _tmp = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp;
    if (i >= 0) {
      _M0FP311moonbitlang4core7builtin21fixed__sift__down__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, i, cmp);
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
      _M0MP311moonbitlang4core5array12MutArrayView4swapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, 0, i);
      _M0FP311moonbitlang4core7builtin21fixed__sift__down__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(_M0MP311moonbitlang4core5array12MutArrayView5sliceGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, 0, i), 0, cmp);
      _tmp$2 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP311moonbitlang4core7builtin20fixed__partition__byGUWdEuiEE(arr, cmp, pivot_index) {
  _M0MP311moonbitlang4core5array12MutArrayView4swapGUWdEuiEE(arr, pivot_index, (arr.end - arr.start | 0) - 1 | 0);
  const pivot = _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, (arr.end - arr.start | 0) - 1 | 0);
  let i = 0;
  let partitioned = true;
  const _end529 = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp = 0;
  while (true) {
    const j = _tmp;
    if (j < _end529) {
      if (cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, j), pivot) < 0) {
        if (i !== j) {
          _M0MP311moonbitlang4core5array12MutArrayView4swapGUWdEuiEE(arr, i, j);
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
  _M0MP311moonbitlang4core5array12MutArrayView4swapGUWdEuiEE(arr, i, (arr.end - arr.start | 0) - 1 | 0);
  return { _0: i, _1: partitioned };
}
function _M0FP311moonbitlang4core7builtin20fixed__partition__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, cmp, pivot_index) {
  _M0MP311moonbitlang4core5array12MutArrayView4swapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, pivot_index, (arr.end - arr.start | 0) - 1 | 0);
  const pivot = _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, (arr.end - arr.start | 0) - 1 | 0);
  let i = 0;
  let partitioned = true;
  const _end529 = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp = 0;
  while (true) {
    const j = _tmp;
    if (j < _end529) {
      if (cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j), pivot) < 0) {
        if (i !== j) {
          _M0MP311moonbitlang4core5array12MutArrayView4swapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, i, j);
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
  _M0MP311moonbitlang4core5array12MutArrayView4swapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, i, (arr.end - arr.start | 0) - 1 | 0);
  return { _0: i, _1: partitioned };
}
function _M0FP311moonbitlang4core7builtin28fixed__try__bubble__sort__byGUWdEuiEE(arr, cmp) {
  let tries = 0;
  const _end550 = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _end550) {
      let sorted = true;
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, j - 1 | 0), _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr, j)) > 0) {
          sorted = false;
          _M0MP311moonbitlang4core5array12MutArrayView4swapGUWdEuiEE(arr, j, j - 1 | 0);
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
function _M0FP311moonbitlang4core7builtin28fixed__try__bubble__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, cmp) {
  let tries = 0;
  const _end550 = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _end550) {
      let sorted = true;
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(_M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j - 1 | 0), _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j)) > 0) {
          sorted = false;
          _M0MP311moonbitlang4core5array12MutArrayView4swapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, j, j - 1 | 0);
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
function _M0FP311moonbitlang4core7builtin22fixed__quick__sort__byGUWdEuiEE(arr, cmp, pred, limit) {
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
        _M0FP311moonbitlang4core7builtin23fixed__bubble__sort__byGUWdEuiEE(arr$2, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      _M0FP311moonbitlang4core7builtin21fixed__heap__sort__byGUWdEuiEE(arr$2, cmp);
      return undefined;
    }
    const _bind$8 = _M0FP311moonbitlang4core7builtin24fixed__choose__pivot__byGUWdEuiEE(arr$2, cmp);
    const _pivot_index = _bind$8._0;
    const _likely_sorted = _bind$8._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (_M0FP311moonbitlang4core7builtin28fixed__try__bubble__sort__byGUWdEuiEE(arr$2, cmp)) {
        return undefined;
      }
    }
    const _bind$9 = _M0FP311moonbitlang4core7builtin20fixed__partition__byGUWdEuiEE(arr$2, cmp, _pivot_index);
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
      if (cmp(_pred, _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr$2, _pivot)) === 0) {
        let i = _pivot;
        while (true) {
          if (i < len && cmp(_pred, _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr$2, i)) === 0) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        arr$2 = _M0MP311moonbitlang4core5array12MutArrayView5sliceGUWdEuiEE(arr$2, i, len);
        continue;
      }
    }
    const left = _M0MP311moonbitlang4core5array12MutArrayView5sliceGUWdEuiEE(arr$2, 0, _pivot);
    const right = _M0MP311moonbitlang4core5array12MutArrayView5sliceGUWdEuiEE(arr$2, _pivot + 1 | 0, len);
    if ((left.end - left.start | 0) < (right.end - right.start | 0)) {
      _M0FP311moonbitlang4core7builtin22fixed__quick__sort__byGUWdEuiEE(left, cmp, pred$2, limit$2);
      pred$2 = _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr$2, _pivot);
      arr$2 = right;
    } else {
      _M0FP311moonbitlang4core7builtin22fixed__quick__sort__byGUWdEuiEE(right, cmp, _M0MP311moonbitlang4core5array12MutArrayView2atGUWdEuiEE(arr$2, _pivot), limit$2);
      arr$2 = left;
    }
    continue;
  }
}
function _M0FP311moonbitlang4core7builtin22fixed__quick__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr, cmp, pred, limit) {
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
        _M0FP311moonbitlang4core7builtin23fixed__bubble__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      _M0FP311moonbitlang4core7builtin21fixed__heap__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, cmp);
      return undefined;
    }
    const _bind$8 = _M0FP311moonbitlang4core7builtin24fixed__choose__pivot__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, cmp);
    const _pivot_index = _bind$8._0;
    const _likely_sorted = _bind$8._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (_M0FP311moonbitlang4core7builtin28fixed__try__bubble__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, cmp)) {
        return undefined;
      }
    }
    const _bind$9 = _M0FP311moonbitlang4core7builtin20fixed__partition__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, cmp, _pivot_index);
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
      if (cmp(_pred, _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, _pivot)) === 0) {
        let i = _pivot;
        while (true) {
          if (i < len && cmp(_pred, _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, i)) === 0) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        arr$2 = _M0MP311moonbitlang4core5array12MutArrayView5sliceGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, i, len);
        continue;
      }
    }
    const left = _M0MP311moonbitlang4core5array12MutArrayView5sliceGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, 0, _pivot);
    const right = _M0MP311moonbitlang4core5array12MutArrayView5sliceGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, _pivot + 1 | 0, len);
    if ((left.end - left.start | 0) < (right.end - right.start | 0)) {
      _M0FP311moonbitlang4core7builtin22fixed__quick__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(left, cmp, pred$2, limit$2);
      pred$2 = _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, _pivot);
      arr$2 = right;
    } else {
      _M0FP311moonbitlang4core7builtin22fixed__quick__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(right, cmp, _M0MP311moonbitlang4core5array12MutArrayView2atGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(arr$2, _pivot), limit$2);
      arr$2 = left;
    }
    continue;
  }
}
function _M0MP311moonbitlang4core5array12MutArrayView13sort__by__keyGUWdEuiEiE(self, map) {
  _M0FP311moonbitlang4core7builtin22fixed__quick__sort__byGUWdEuiEE(self, (a, b) => $compare_int(map(a), map(b)), undefined, _M0FP311moonbitlang4core7builtin17fixed__get__limit(self.end - self.start | 0));
}
function _M0MP311moonbitlang4core5array12MutArrayView8sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(self, cmp) {
  _M0FP311moonbitlang4core7builtin22fixed__quick__sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(self, cmp, undefined, _M0FP311moonbitlang4core7builtin17fixed__get__limit(self.end - self.start | 0));
}
function _M0MP311moonbitlang4core5array5Array13sort__by__keyGUWdEuiEiE(self, map) {
  _M0MP311moonbitlang4core5array12MutArrayView13sort__by__keyGUWdEuiEiE(_M0MP311moonbitlang4core5array5Array17mut__view_2einnerGUWdEuiEE(self, 0, undefined), map);
}
function _M0MP311moonbitlang4core5array5Array8sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(self, cmp) {
  _M0MP311moonbitlang4core5array12MutArrayView8sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(_M0MP311moonbitlang4core5array5Array17mut__view_2einnerGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(self, 0, undefined), cmp);
}
function _M0MP311moonbitlang4core5array5Array5clearGWEuE(self) {
  _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGWEuE(self, 0);
}
function _M0MP311moonbitlang4core5array5Array5clearGiE(self) {
  _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGiE(self, 0);
}
function _M0MP311moonbitlang4core5array5Array5clearGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(self) {
  _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(self, 0);
}
function _M0MP311moonbitlang4core5array5Array5clearGdE(self) {
  _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGdE(self, 0);
}
function _M0MP311moonbitlang4core5array5Array8containsGRP39Milky20186selene9collision14CollisionLayerE(self, value) {
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
function _M0FP311moonbitlang4core7strconv9base__errGUiRP311moonbitlang4core6string10StringViewbEE() {
  return new Result$Err$5$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv14base__err__str));
}
function _M0FP311moonbitlang4core7strconv25check__and__consume__base(view, base) {
  if (base === 0) {
    _L: {
      let rest;
      _L$2: {
        let rest$2;
        _L$3: {
          let rest$3;
          _L$4: {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(view.str, 2, view.start, view.end)) {
              const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(view.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 0, view.start, view.end));
              if (_x === 48) {
                const _x$2 = _M0MP311moonbitlang4core6string6String16unsafe__char__at(view.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 1, view.start, view.end));
                switch (_x$2) {
                  case 120: {
                    const _tmp = view.str;
                    const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$2;
                    if (_bind$8 === undefined) {
                      _tmp$2 = view.end;
                    } else {
                      const _Some = _bind$8;
                      _tmp$2 = _Some;
                    }
                    const _x$3 = { str: _tmp, start: _tmp$2, end: view.end };
                    rest$3 = _x$3;
                    break _L$4;
                  }
                  case 88: {
                    const _tmp$3 = view.str;
                    const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$4;
                    if (_bind$9 === undefined) {
                      _tmp$4 = view.end;
                    } else {
                      const _Some = _bind$9;
                      _tmp$4 = _Some;
                    }
                    const _x$4 = { str: _tmp$3, start: _tmp$4, end: view.end };
                    rest$3 = _x$4;
                    break _L$4;
                  }
                  case 111: {
                    const _tmp$5 = view.str;
                    const _bind$10 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$6;
                    if (_bind$10 === undefined) {
                      _tmp$6 = view.end;
                    } else {
                      const _Some = _bind$10;
                      _tmp$6 = _Some;
                    }
                    const _x$5 = { str: _tmp$5, start: _tmp$6, end: view.end };
                    rest$2 = _x$5;
                    break _L$3;
                  }
                  case 79: {
                    const _tmp$7 = view.str;
                    const _bind$11 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$8;
                    if (_bind$11 === undefined) {
                      _tmp$8 = view.end;
                    } else {
                      const _Some = _bind$11;
                      _tmp$8 = _Some;
                    }
                    const _x$6 = { str: _tmp$7, start: _tmp$8, end: view.end };
                    rest$2 = _x$6;
                    break _L$3;
                  }
                  case 98: {
                    const _tmp$9 = view.str;
                    const _bind$12 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$10;
                    if (_bind$12 === undefined) {
                      _tmp$10 = view.end;
                    } else {
                      const _Some = _bind$12;
                      _tmp$10 = _Some;
                    }
                    const _x$7 = { str: _tmp$9, start: _tmp$10, end: view.end };
                    rest = _x$7;
                    break _L$2;
                  }
                  case 66: {
                    const _tmp$11 = view.str;
                    const _bind$13 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$12;
                    if (_bind$13 === undefined) {
                      _tmp$12 = view.end;
                    } else {
                      const _Some = _bind$13;
                      _tmp$12 = _Some;
                    }
                    const _x$8 = { str: _tmp$11, start: _tmp$12, end: view.end };
                    rest = _x$8;
                    break _L$2;
                  }
                  default: {
                    break _L;
                  }
                }
              } else {
                break _L;
              }
            } else {
              break _L;
            }
          }
          return new Result$Ok$5$({ _0: 16, _1: rest$3, _2: true });
        }
        return new Result$Ok$5$({ _0: 8, _1: rest$2, _2: true });
      }
      return new Result$Ok$5$({ _0: 2, _1: rest, _2: true });
    }
    return new Result$Ok$5$({ _0: 10, _1: view, _2: false });
  } else {
    _L: {
      let rest;
      _L$2: {
        let rest$2;
        _L$3: {
          let rest$3;
          _L$4: {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(view.str, 2, view.start, view.end)) {
              const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(view.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 0, view.start, view.end));
              if (_x === 48) {
                const _x$2 = _M0MP311moonbitlang4core6string6String16unsafe__char__at(view.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 1, view.start, view.end));
                switch (_x$2) {
                  case 120: {
                    const _tmp = view.str;
                    const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$2;
                    if (_bind$8 === undefined) {
                      _tmp$2 = view.end;
                    } else {
                      const _Some = _bind$8;
                      _tmp$2 = _Some;
                    }
                    const _x$3 = { str: _tmp, start: _tmp$2, end: view.end };
                    if (base === 16) {
                      rest$3 = _x$3;
                      break _L$4;
                    } else {
                      break _L;
                    }
                  }
                  case 88: {
                    const _tmp$3 = view.str;
                    const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$4;
                    if (_bind$9 === undefined) {
                      _tmp$4 = view.end;
                    } else {
                      const _Some = _bind$9;
                      _tmp$4 = _Some;
                    }
                    const _x$4 = { str: _tmp$3, start: _tmp$4, end: view.end };
                    if (base === 16) {
                      rest$3 = _x$4;
                      break _L$4;
                    } else {
                      break _L;
                    }
                  }
                  case 111: {
                    const _tmp$5 = view.str;
                    const _bind$10 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$6;
                    if (_bind$10 === undefined) {
                      _tmp$6 = view.end;
                    } else {
                      const _Some = _bind$10;
                      _tmp$6 = _Some;
                    }
                    const _x$5 = { str: _tmp$5, start: _tmp$6, end: view.end };
                    if (base === 8) {
                      rest$2 = _x$5;
                      break _L$3;
                    } else {
                      break _L;
                    }
                  }
                  case 79: {
                    const _tmp$7 = view.str;
                    const _bind$11 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$8;
                    if (_bind$11 === undefined) {
                      _tmp$8 = view.end;
                    } else {
                      const _Some = _bind$11;
                      _tmp$8 = _Some;
                    }
                    const _x$6 = { str: _tmp$7, start: _tmp$8, end: view.end };
                    if (base === 8) {
                      rest$2 = _x$6;
                      break _L$3;
                    } else {
                      break _L;
                    }
                  }
                  case 98: {
                    const _tmp$9 = view.str;
                    const _bind$12 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$10;
                    if (_bind$12 === undefined) {
                      _tmp$10 = view.end;
                    } else {
                      const _Some = _bind$12;
                      _tmp$10 = _Some;
                    }
                    const _x$7 = { str: _tmp$9, start: _tmp$10, end: view.end };
                    if (base === 2) {
                      rest = _x$7;
                      break _L$2;
                    } else {
                      break _L;
                    }
                  }
                  case 66: {
                    const _tmp$11 = view.str;
                    const _bind$13 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$12;
                    if (_bind$13 === undefined) {
                      _tmp$12 = view.end;
                    } else {
                      const _Some = _bind$13;
                      _tmp$12 = _Some;
                    }
                    const _x$8 = { str: _tmp$11, start: _tmp$12, end: view.end };
                    if (base === 2) {
                      rest = _x$8;
                      break _L$2;
                    } else {
                      break _L;
                    }
                  }
                  default: {
                    break _L;
                  }
                }
              } else {
                break _L;
              }
            } else {
              break _L;
            }
          }
          return new Result$Ok$5$({ _0: 16, _1: rest$3, _2: true });
        }
        return new Result$Ok$5$({ _0: 8, _1: rest$2, _2: true });
      }
      return new Result$Ok$5$({ _0: 2, _1: rest, _2: true });
    }
    return base >= 2 && base <= 36 ? new Result$Ok$5$({ _0: base, _1: view, _2: false }) : _M0FP311moonbitlang4core7strconv9base__errGUiRP311moonbitlang4core6string10StringViewbEE();
  }
}
function _M0FP311moonbitlang4core7strconv10range__errGuE() {
  return new Result$Err$6$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv15range__err__str));
}
function _M0FP311moonbitlang4core7strconv10range__errGmE() {
  return new Result$Err$7$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv15range__err__str));
}
function _M0FP311moonbitlang4core7strconv10range__errGlE() {
  return new Result$Err$8$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv15range__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGdE() {
  return new Result$Err$9$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGORP311moonbitlang4core7strconv6NumberE() {
  return new Result$Err$10$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGuE() {
  return new Result$Err$6$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGiE() {
  return new Result$Err$11$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGmE() {
  return new Result$Err$7$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGlE() {
  return new Result$Err$8$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGRP311moonbitlang4core6string10StringViewE() {
  return new Result$Err$12$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGRP311moonbitlang4core7strconv7DecimalE() {
  return new Result$Err$13$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv21parse__uint64_2einner(str, base) {
  if (_M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGRP311moonbitlang4core6string10StringViewE(str, { str: _M0FP311moonbitlang4core7strconv37parse__uint64_2einner_2e_2abind_7c454, start: 0, end: _M0FP311moonbitlang4core7strconv37parse__uint64_2einner_2e_2abind_7c454.length })) {
    _L: {
      _L$2: {
        if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(str.str, 1, str.start, str.end)) {
          const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(str.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(str.str, 0, str.start, str.end));
          switch (_x) {
            case 43: {
              break _L$2;
            }
            case 45: {
              break _L$2;
            }
          }
        }
        break _L;
      }
      const _bind$8 = _M0FP311moonbitlang4core7strconv11syntax__errGuE();
      if (_bind$8.$tag === 1) {
        const _ok = _bind$8;
        _ok._0;
      } else {
        return _bind$8;
      }
    }
    const _bind$8 = _M0FP311moonbitlang4core7strconv25check__and__consume__base(str, base);
    let _bind$9;
    if (_bind$8.$tag === 1) {
      const _ok = _bind$8;
      _bind$9 = _ok._0;
    } else {
      return _bind$8;
    }
    const _num_base = _bind$9._0;
    const _rest = _bind$9._1;
    const _allow_underscore = _bind$9._2;
    let overflow_threshold;
    switch (_num_base) {
      case 10: {
        overflow_threshold = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Div3div($_1L, $10L), $1L);
        break;
      }
      case 16: {
        overflow_threshold = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Div3div($_1L, $16L), $1L);
        break;
      }
      default: {
        overflow_threshold = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Div3div($_1L, _M0MP311moonbitlang4core3int3Int10to__uint64(_num_base)), $1L);
      }
    }
    let has_digit;
    if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_rest.str, 1, _rest.start, _rest.end)) {
      const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_rest.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_rest.str, 0, _rest.start, _rest.end));
      if (_x >= 48 && _x <= 57) {
        has_digit = true;
      } else {
        if (_x >= 97 && _x <= 122) {
          has_digit = true;
        } else {
          if (_x >= 65 && _x <= 90) {
            has_digit = true;
          } else {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_rest.str, 2, _rest.start, _rest.end)) {
              if (_x === 95) {
                const _x$2 = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_rest.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_rest.str, 1, _rest.start, _rest.end));
                has_digit = _x$2 >= 48 && _x$2 <= 57 ? true : _x$2 >= 97 && _x$2 <= 122 ? true : _x$2 >= 65 && _x$2 <= 90;
              } else {
                has_digit = false;
              }
            } else {
              has_digit = false;
            }
          }
        }
      }
    } else {
      has_digit = false;
    }
    if (has_digit) {
      let _tmp;
      let _tmp$2 = _rest;
      let _tmp$3 = $0L;
      let _tmp$4 = _allow_underscore;
      while (true) {
        const _param_0 = _tmp$2;
        const _param_1 = _tmp$3;
        const _param_2 = _tmp$4;
        let acc;
        let rest;
        let c;
        _L$2: {
          if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_param_0.str, 1, _param_0.start, _param_0.end)) {
            const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param_0.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 0, _param_0.start, _param_0.end));
            if (_x === 95) {
              const _bind$10 = _M0FP311moonbitlang4core7strconv11syntax__errGmE();
              if (_bind$10.$tag === 1) {
                const _ok = _bind$10;
                _tmp = _ok._0;
                break;
              } else {
                return _bind$10;
              }
            } else {
              const _tmp$5 = _param_0.str;
              const _bind$10 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
              let _tmp$6;
              if (_bind$10 === undefined) {
                _tmp$6 = _param_0.end;
              } else {
                const _Some = _bind$10;
                _tmp$6 = _Some;
              }
              const _x$2 = { str: _tmp$5, start: _tmp$6, end: _param_0.end };
              acc = _param_1;
              rest = _x$2;
              c = _x;
              break _L$2;
            }
          } else {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_param_0.str, 1, _param_0.start, _param_0.end)) {
              const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param_0.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 0, _param_0.start, _param_0.end));
              if (_x === 95) {
                if (_param_2 === false) {
                  const _bind$10 = _M0FP311moonbitlang4core7strconv11syntax__errGmE();
                  if (_bind$10.$tag === 1) {
                    const _ok = _bind$10;
                    _tmp = _ok._0;
                    break;
                  } else {
                    return _bind$10;
                  }
                } else {
                  const _tmp$5 = _param_0.str;
                  const _bind$10 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
                  let _tmp$6;
                  if (_bind$10 === undefined) {
                    _tmp$6 = _param_0.end;
                  } else {
                    const _Some = _bind$10;
                    _tmp$6 = _Some;
                  }
                  const _x$2 = { str: _tmp$5, start: _tmp$6, end: _param_0.end };
                  _tmp$2 = _x$2;
                  _tmp$4 = false;
                  continue;
                }
              } else {
                const _tmp$5 = _param_0.str;
                const _bind$10 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
                let _tmp$6;
                if (_bind$10 === undefined) {
                  _tmp$6 = _param_0.end;
                } else {
                  const _Some = _bind$10;
                  _tmp$6 = _Some;
                }
                const _x$2 = { str: _tmp$5, start: _tmp$6, end: _param_0.end };
                acc = _param_1;
                rest = _x$2;
                c = _x;
                break _L$2;
              }
            } else {
              _tmp = _param_1;
              break;
            }
          }
        }
        const c$2 = c;
        let d;
        if (c$2 >= 48 && c$2 <= 57) {
          d = c$2 - 48 | 0;
        } else {
          if (c$2 >= 97 && c$2 <= 122) {
            d = c$2 + -87 | 0;
          } else {
            if (c$2 >= 65 && c$2 <= 90) {
              d = c$2 + -55 | 0;
            } else {
              const _bind$10 = _M0FP311moonbitlang4core7strconv11syntax__errGiE();
              if (_bind$10.$tag === 1) {
                const _ok = _bind$10;
                d = _ok._0;
              } else {
                return _bind$10;
              }
            }
          }
        }
        if (d < _num_base) {
          if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGmE(acc, overflow_threshold)) {
            const next_acc = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(acc, _M0MP311moonbitlang4core3int3Int10to__uint64(_num_base)), _M0MP311moonbitlang4core3int3Int10to__uint64(d));
            if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGmE(next_acc, acc) && _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGmE(next_acc, $_1L)) {
              _tmp$2 = rest;
              _tmp$3 = next_acc;
              _tmp$4 = true;
              continue;
            } else {
              const _bind$10 = _M0FP311moonbitlang4core7strconv10range__errGmE();
              if (_bind$10.$tag === 1) {
                const _ok = _bind$10;
                _tmp = _ok._0;
                break;
              } else {
                return _bind$10;
              }
            }
          } else {
            const _bind$10 = _M0FP311moonbitlang4core7strconv10range__errGmE();
            if (_bind$10.$tag === 1) {
              const _ok = _bind$10;
              _tmp = _ok._0;
              break;
            } else {
              return _bind$10;
            }
          }
        } else {
          const _bind$10 = _M0FP311moonbitlang4core7strconv11syntax__errGmE();
          if (_bind$10.$tag === 1) {
            const _ok = _bind$10;
            _tmp = _ok._0;
            break;
          } else {
            return _bind$10;
          }
        }
      }
      return new Result$Ok$7$(_tmp);
    } else {
      return _M0FP311moonbitlang4core7strconv11syntax__errGmE();
    }
  } else {
    return _M0FP311moonbitlang4core7strconv11syntax__errGmE();
  }
}
function _M0FP311moonbitlang4core7strconv19parse__uint_2einner(str, base) {
  const _bind$8 = _M0FP311moonbitlang4core7strconv21parse__uint64_2einner(str, base);
  let n;
  if (_bind$8.$tag === 1) {
    const _ok = _bind$8;
    n = _ok._0;
  } else {
    return _bind$8;
  }
  if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGmE(n, _M0MP311moonbitlang4core4uint4UInt10to__uint64(-1))) {
    const _bind$9 = _M0FP311moonbitlang4core7strconv10range__errGuE();
    if (_bind$9.$tag === 1) {
      const _ok = _bind$9;
      _ok._0;
    } else {
      return _bind$9;
    }
  }
  return new Result$Ok$14$(_M0MP311moonbitlang4core6uint646UInt648to__uint(n));
}
function _M0FP311moonbitlang4core7strconv19overflow__threshold(base, neg) {
  return !neg ? (base === 10 ? _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($9223372036854775807L, $10L), $1L) : base === 16 ? _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($9223372036854775807L, $16L), $1L) : _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($9223372036854775807L, _M0MP311moonbitlang4core3int3Int9to__int64(base)), $1L)) : base === 10 ? _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($_9223372036854775808L, $10L) : base === 16 ? _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($_9223372036854775808L, $16L) : _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($_9223372036854775808L, _M0MP311moonbitlang4core3int3Int9to__int64(base));
}
function _M0FP311moonbitlang4core7strconv20parse__int64_2einner(str, base) {
  if (_M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGRP311moonbitlang4core6string10StringViewE(str, { str: _M0FP311moonbitlang4core7strconv36parse__int64_2einner_2e_2abind_7c603, start: 0, end: _M0FP311moonbitlang4core7strconv36parse__int64_2einner_2e_2abind_7c603.length })) {
    let _bind$8;
    let rest;
    _L: {
      _L$2: {
        const _bind$9 = _M0MP311moonbitlang4core6string10StringView12view_2einner(str, 0, undefined);
        if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_bind$9.str, 1, _bind$9.start, _bind$9.end)) {
          const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_bind$9.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$9.str, 0, _bind$9.start, _bind$9.end));
          switch (_x) {
            case 43: {
              const _tmp = _bind$9.str;
              const _bind$10 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$9.str, 1, _bind$9.start, _bind$9.end);
              let _tmp$2;
              if (_bind$10 === undefined) {
                _tmp$2 = _bind$9.end;
              } else {
                const _Some = _bind$10;
                _tmp$2 = _Some;
              }
              const _x$2 = { str: _tmp, start: _tmp$2, end: _bind$9.end };
              _bind$8 = { _0: false, _1: _x$2 };
              break;
            }
            case 45: {
              const _tmp$3 = _bind$9.str;
              const _bind$11 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$9.str, 1, _bind$9.start, _bind$9.end);
              let _tmp$4;
              if (_bind$11 === undefined) {
                _tmp$4 = _bind$9.end;
              } else {
                const _Some = _bind$11;
                _tmp$4 = _Some;
              }
              const _x$3 = { str: _tmp$3, start: _tmp$4, end: _bind$9.end };
              _bind$8 = { _0: true, _1: _x$3 };
              break;
            }
            default: {
              rest = _bind$9;
              break _L$2;
            }
          }
        } else {
          rest = _bind$9;
          break _L$2;
        }
        break _L;
      }
      _bind$8 = { _0: false, _1: rest };
    }
    const _neg = _bind$8._0;
    const _rest = _bind$8._1;
    const _bind$9 = _M0FP311moonbitlang4core7strconv25check__and__consume__base(_rest, base);
    let _bind$10;
    if (_bind$9.$tag === 1) {
      const _ok = _bind$9;
      _bind$10 = _ok._0;
    } else {
      return _bind$9;
    }
    const _num_base = _bind$10._0;
    const _rest$2 = _bind$10._1;
    const _allow_underscore = _bind$10._2;
    const overflow_threshold = _M0FP311moonbitlang4core7strconv19overflow__threshold(_num_base, _neg);
    let has_digit;
    if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_rest$2.str, 1, _rest$2.start, _rest$2.end)) {
      const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_rest$2.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_rest$2.str, 0, _rest$2.start, _rest$2.end));
      if (_x >= 48 && _x <= 57) {
        has_digit = true;
      } else {
        if (_x >= 97 && _x <= 122) {
          has_digit = true;
        } else {
          if (_x >= 65 && _x <= 90) {
            has_digit = true;
          } else {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_rest$2.str, 2, _rest$2.start, _rest$2.end)) {
              if (_x === 95) {
                const _x$2 = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_rest$2.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_rest$2.str, 1, _rest$2.start, _rest$2.end));
                has_digit = _x$2 >= 48 && _x$2 <= 57 ? true : _x$2 >= 97 && _x$2 <= 122 ? true : _x$2 >= 65 && _x$2 <= 90;
              } else {
                has_digit = false;
              }
            } else {
              has_digit = false;
            }
          }
        }
      }
    } else {
      has_digit = false;
    }
    if (has_digit) {
      let _tmp;
      let _tmp$2 = _rest$2;
      let _tmp$3 = $0L;
      let _tmp$4 = _allow_underscore;
      while (true) {
        const _param_0 = _tmp$2;
        const _param_1 = _tmp$3;
        const _param_2 = _tmp$4;
        let acc;
        let rest$2;
        let c;
        _L$2: {
          if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_param_0.str, 1, _param_0.start, _param_0.end)) {
            const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param_0.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 0, _param_0.start, _param_0.end));
            if (_x === 95) {
              const _bind$11 = _M0FP311moonbitlang4core7strconv11syntax__errGlE();
              if (_bind$11.$tag === 1) {
                const _ok = _bind$11;
                _tmp = _ok._0;
                break;
              } else {
                return _bind$11;
              }
            } else {
              const _tmp$5 = _param_0.str;
              const _bind$11 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
              let _tmp$6;
              if (_bind$11 === undefined) {
                _tmp$6 = _param_0.end;
              } else {
                const _Some = _bind$11;
                _tmp$6 = _Some;
              }
              const _x$2 = { str: _tmp$5, start: _tmp$6, end: _param_0.end };
              acc = _param_1;
              rest$2 = _x$2;
              c = _x;
              break _L$2;
            }
          } else {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_param_0.str, 1, _param_0.start, _param_0.end)) {
              const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param_0.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 0, _param_0.start, _param_0.end));
              if (_x === 95) {
                if (_param_2 === false) {
                  const _bind$11 = _M0FP311moonbitlang4core7strconv11syntax__errGlE();
                  if (_bind$11.$tag === 1) {
                    const _ok = _bind$11;
                    _tmp = _ok._0;
                    break;
                  } else {
                    return _bind$11;
                  }
                } else {
                  const _tmp$5 = _param_0.str;
                  const _bind$11 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
                  let _tmp$6;
                  if (_bind$11 === undefined) {
                    _tmp$6 = _param_0.end;
                  } else {
                    const _Some = _bind$11;
                    _tmp$6 = _Some;
                  }
                  const _x$2 = { str: _tmp$5, start: _tmp$6, end: _param_0.end };
                  _tmp$2 = _x$2;
                  _tmp$4 = false;
                  continue;
                }
              } else {
                const _tmp$5 = _param_0.str;
                const _bind$11 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
                let _tmp$6;
                if (_bind$11 === undefined) {
                  _tmp$6 = _param_0.end;
                } else {
                  const _Some = _bind$11;
                  _tmp$6 = _Some;
                }
                const _x$2 = { str: _tmp$5, start: _tmp$6, end: _param_0.end };
                acc = _param_1;
                rest$2 = _x$2;
                c = _x;
                break _L$2;
              }
            } else {
              _tmp = _param_1;
              break;
            }
          }
        }
        const c$2 = c;
        let d;
        if (c$2 >= 48 && c$2 <= 57) {
          d = c$2 - 48 | 0;
        } else {
          if (c$2 >= 97 && c$2 <= 122) {
            d = c$2 + -87 | 0;
          } else {
            if (c$2 >= 65 && c$2 <= 90) {
              d = c$2 + -55 | 0;
            } else {
              const _bind$11 = _M0FP311moonbitlang4core7strconv11syntax__errGiE();
              if (_bind$11.$tag === 1) {
                const _ok = _bind$11;
                d = _ok._0;
              } else {
                return _bind$11;
              }
            }
          }
        }
        if (d < _num_base) {
          if (_neg) {
            if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGlE(acc, overflow_threshold)) {
              const next_acc = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Sub3sub(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul(acc, _M0MP311moonbitlang4core3int3Int9to__int64(_num_base)), _M0MP311moonbitlang4core3int3Int9to__int64(d));
              if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGlE(next_acc, acc)) {
                _tmp$2 = rest$2;
                _tmp$3 = next_acc;
                _tmp$4 = true;
                continue;
              } else {
                const _bind$11 = _M0FP311moonbitlang4core7strconv10range__errGlE();
                if (_bind$11.$tag === 1) {
                  const _ok = _bind$11;
                  _tmp = _ok._0;
                  break;
                } else {
                  return _bind$11;
                }
              }
            } else {
              const _bind$11 = _M0FP311moonbitlang4core7strconv10range__errGlE();
              if (_bind$11.$tag === 1) {
                const _ok = _bind$11;
                _tmp = _ok._0;
                break;
              } else {
                return _bind$11;
              }
            }
          } else {
            if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGlE(acc, overflow_threshold)) {
              const next_acc = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul(acc, _M0MP311moonbitlang4core3int3Int9to__int64(_num_base)), _M0MP311moonbitlang4core3int3Int9to__int64(d));
              if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGlE(next_acc, acc)) {
                _tmp$2 = rest$2;
                _tmp$3 = next_acc;
                _tmp$4 = true;
                continue;
              } else {
                const _bind$11 = _M0FP311moonbitlang4core7strconv10range__errGlE();
                if (_bind$11.$tag === 1) {
                  const _ok = _bind$11;
                  _tmp = _ok._0;
                  break;
                } else {
                  return _bind$11;
                }
              }
            } else {
              const _bind$11 = _M0FP311moonbitlang4core7strconv10range__errGlE();
              if (_bind$11.$tag === 1) {
                const _ok = _bind$11;
                _tmp = _ok._0;
                break;
              } else {
                return _bind$11;
              }
            }
          }
        } else {
          const _bind$11 = _M0FP311moonbitlang4core7strconv11syntax__errGlE();
          if (_bind$11.$tag === 1) {
            const _ok = _bind$11;
            _tmp = _ok._0;
            break;
          } else {
            return _bind$11;
          }
        }
      }
      return new Result$Ok$8$(_tmp);
    } else {
      return _M0FP311moonbitlang4core7strconv11syntax__errGlE();
    }
  } else {
    return _M0FP311moonbitlang4core7strconv11syntax__errGlE();
  }
}
function _M0FP311moonbitlang4core7strconv18parse__int_2einner(str, base) {
  const _bind$8 = _M0FP311moonbitlang4core7strconv20parse__int64_2einner(str, base);
  let n;
  if (_bind$8.$tag === 1) {
    const _ok = _bind$8;
    n = _ok._0;
  } else {
    return _bind$8;
  }
  if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGlE(n, _M0MP311moonbitlang4core3int3Int9to__int64(-2147483648)) || _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGlE(n, _M0MP311moonbitlang4core3int3Int9to__int64(2147483647))) {
    const _bind$9 = _M0FP311moonbitlang4core7strconv10range__errGuE();
    if (_bind$9.$tag === 1) {
      const _ok = _bind$9;
      _ok._0;
    } else {
      return _bind$9;
    }
  }
  return new Result$Ok$11$(_M0MP311moonbitlang4core5int645Int647to__int(n));
}
function _M0FP311moonbitlang4core7strconv17check__underscore(str) {
  let rest;
  if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(str.str, 1, str.start, str.end)) {
    const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(str.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(str.str, 0, str.start, str.end));
    switch (_x) {
      case 43: {
        const _tmp = str.str;
        const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(str.str, 1, str.start, str.end);
        let _tmp$2;
        if (_bind$8 === undefined) {
          _tmp$2 = str.end;
        } else {
          const _Some = _bind$8;
          _tmp$2 = _Some;
        }
        const _x$2 = { str: _tmp, start: _tmp$2, end: str.end };
        rest = _x$2;
        break;
      }
      case 45: {
        const _tmp$3 = str.str;
        const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(str.str, 1, str.start, str.end);
        let _tmp$4;
        if (_bind$9 === undefined) {
          _tmp$4 = str.end;
        } else {
          const _Some = _bind$9;
          _tmp$4 = _Some;
        }
        const _x$3 = { str: _tmp$3, start: _tmp$4, end: str.end };
        rest = _x$3;
        break;
      }
      default: {
        rest = str;
      }
    }
  } else {
    rest = str;
  }
  const _data = rest.str;
  const _start = rest.start;
  const _end = _start + (rest.end - rest.start | 0) | 0;
  let _cursor = _start;
  let accept_state = -1;
  let match_end = -1;
  let _bind$8;
  _L: {
    if ((_cursor + 1 | 0) < _end) {
      const _p = _cursor;
      const next_char = _data.charCodeAt(_p);
      _cursor = _cursor + 1 | 0;
      if (next_char === 48) {
        _L$2: {
          _L$3: {
            _L$4: {
              const _p$2 = _cursor;
              const next_char$2 = _data.charCodeAt(_p$2);
              _cursor = _cursor + 1 | 0;
              if (next_char$2 < 89) {
                if (next_char$2 < 79) {
                  if (next_char$2 === 66) {
                    break _L$2;
                  } else {
                    break _L;
                  }
                } else {
                  if (next_char$2 > 79) {
                    if (next_char$2 < 88) {
                      break _L;
                    } else {
                      break _L$4;
                    }
                  } else {
                    break _L$3;
                  }
                }
              } else {
                if (next_char$2 > 97) {
                  if (next_char$2 < 112) {
                    if (next_char$2 < 99) {
                      break _L$2;
                    } else {
                      if (next_char$2 > 110) {
                        break _L$3;
                      } else {
                        break _L;
                      }
                    }
                  } else {
                    if (next_char$2 > 119) {
                      if (next_char$2 < 121) {
                        break _L$4;
                      } else {
                        break _L;
                      }
                    } else {
                      break _L;
                    }
                  }
                } else {
                  break _L;
                }
              }
            }
            accept_state = 2;
            match_end = _cursor;
            break _L;
          }
          accept_state = 1;
          match_end = _cursor;
          break _L;
        }
        accept_state = 0;
        match_end = _cursor;
        break _L;
      } else {
        break _L;
      }
    } else {
      break _L;
    }
  }
  switch (accept_state) {
    case 2: {
      const rest$2 = _M0MP311moonbitlang4core6string6String4view(_data, match_end, _end);
      _bind$8 = { _0: rest$2, _1: true, _2: true };
      break;
    }
    case 1: {
      const rest$3 = _M0MP311moonbitlang4core6string6String4view(_data, match_end, _end);
      _bind$8 = { _0: rest$3, _1: true, _2: false };
      break;
    }
    case 0: {
      const rest$4 = _M0MP311moonbitlang4core6string6String4view(_data, match_end, _end);
      _bind$8 = { _0: rest$4, _1: true, _2: false };
      break;
    }
    default: {
      _bind$8 = { _0: rest, _1: false, _2: false };
    }
  }
  const _rest = _bind$8._0;
  const _allow_underscore = _bind$8._1;
  const _hex = _bind$8._2;
  let _tmp = _rest;
  let _tmp$2 = _allow_underscore;
  let _tmp$3 = false;
  while (true) {
    const _param_0 = _tmp;
    const _param_1 = _tmp$2;
    const _param_2 = _tmp$3;
    let rest$5;
    let c;
    let follow_underscore;
    _L$2: {
      if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_param_0.str, 0, _param_0.start, _param_0.end)) {
        return true;
      } else {
        if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_param_0.str, 1, _param_0.start, _param_0.end)) {
          const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param_0.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 0, _param_0.start, _param_0.end));
          if (_x === 95) {
            return false;
          } else {
            const _tmp$4 = _param_0.str;
            const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
            let _tmp$5;
            if (_bind$9 === undefined) {
              _tmp$5 = _param_0.end;
            } else {
              const _Some = _bind$9;
              _tmp$5 = _Some;
            }
            const _x$2 = { str: _tmp$4, start: _tmp$5, end: _param_0.end };
            rest$5 = _x$2;
            c = _x;
            follow_underscore = _param_2;
            break _L$2;
          }
        } else {
          const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param_0.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 0, _param_0.start, _param_0.end));
          if (_x === 95) {
            if (_param_1 === false) {
              return false;
            } else {
              const _tmp$4 = _param_0.str;
              const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
              let _tmp$5;
              if (_bind$9 === undefined) {
                _tmp$5 = _param_0.end;
              } else {
                const _Some = _bind$9;
                _tmp$5 = _Some;
              }
              const _x$2 = { str: _tmp$4, start: _tmp$5, end: _param_0.end };
              _tmp = _x$2;
              _tmp$2 = false;
              _tmp$3 = true;
              continue;
            }
          } else {
            const _tmp$4 = _param_0.str;
            const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
            let _tmp$5;
            if (_bind$9 === undefined) {
              _tmp$5 = _param_0.end;
            } else {
              const _Some = _bind$9;
              _tmp$5 = _Some;
            }
            const _x$2 = { str: _tmp$4, start: _tmp$5, end: _param_0.end };
            rest$5 = _x$2;
            c = _x;
            follow_underscore = _param_2;
            break _L$2;
          }
        }
      }
    }
    if (c >= 48 && c <= 57 ? true : _hex && (c >= 97 && c <= 102 ? true : c >= 65 && c <= 70)) {
      _tmp = rest$5;
      _tmp$2 = true;
      _tmp$3 = false;
      continue;
    } else {
      if (follow_underscore) {
        return false;
      } else {
        _tmp = rest$5;
        _tmp$2 = false;
        _tmp$3 = false;
        continue;
      }
    }
  }
}
function _M0MP311moonbitlang4core7strconv7Decimal9new__priv() {
  return { digits: $makebytes(800, 0), digits_num: 0, decimal_point: 0, negative: false, truncated: false };
}
function _M0MP311moonbitlang4core7strconv7Decimal4trim(self) {
  while (true) {
    let _tmp;
    if (self.digits_num > 0) {
      const _tmp$2 = self.digits;
      const _tmp$3 = self.digits_num - 1 | 0;
      $bound_check(_tmp$2, _tmp$3);
      const _p = _tmp$2[_tmp$3];
      const _p$2 = 0;
      _tmp = _p === _p$2;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      self.digits_num = self.digits_num - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (self.digits_num === 0) {
    self.decimal_point = 0;
    return;
  } else {
    return;
  }
}
function _M0FP311moonbitlang4core7strconv26parse__decimal__from__view(str) {
  const d = _M0MP311moonbitlang4core7strconv7Decimal9new__priv();
  let has_dp = false;
  let has_digits = false;
  let rest;
  _L: {
    _L$2: {
      if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(str.str, 1, str.start, str.end)) {
        const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(str.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(str.str, 0, str.start, str.end));
        switch (_x) {
          case 45: {
            const _tmp = str.str;
            const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(str.str, 1, str.start, str.end);
            let _tmp$2;
            if (_bind$8 === undefined) {
              _tmp$2 = str.end;
            } else {
              const _Some = _bind$8;
              _tmp$2 = _Some;
            }
            const _x$2 = { str: _tmp, start: _tmp$2, end: str.end };
            d.negative = true;
            rest = _x$2;
            break;
          }
          case 43: {
            const _tmp$3 = str.str;
            const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(str.str, 1, str.start, str.end);
            let _tmp$4;
            if (_bind$9 === undefined) {
              _tmp$4 = str.end;
            } else {
              const _Some = _bind$9;
              _tmp$4 = _Some;
            }
            rest = { str: _tmp$3, start: _tmp$4, end: str.end };
            break;
          }
          default: {
            break _L$2;
          }
        }
      } else {
        break _L$2;
      }
      break _L;
    }
    rest = str;
  }
  let rest$2;
  let _tmp = rest;
  while (true) {
    const _param = _tmp;
    if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_param.str, 1, _param.start, _param.end)) {
      const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 0, _param.start, _param.end));
      if (_x === 95) {
        const _tmp$2 = _param.str;
        const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 1, _param.start, _param.end);
        let _tmp$3;
        if (_bind$8 === undefined) {
          _tmp$3 = _param.end;
        } else {
          const _Some = _bind$8;
          _tmp$3 = _Some;
        }
        const _x$2 = { str: _tmp$2, start: _tmp$3, end: _param.end };
        _tmp = _x$2;
        continue;
      } else {
        if (_x === 46) {
          const _tmp$2 = _param.str;
          const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 1, _param.start, _param.end);
          let _tmp$3;
          if (_bind$8 === undefined) {
            _tmp$3 = _param.end;
          } else {
            const _Some = _bind$8;
            _tmp$3 = _Some;
          }
          const _x$2 = { str: _tmp$2, start: _tmp$3, end: _param.end };
          if (!has_dp) {
            has_dp = true;
            d.decimal_point = d.digits_num;
            _tmp = _x$2;
            continue;
          } else {
            const _bind$9 = _M0FP311moonbitlang4core7strconv11syntax__errGRP311moonbitlang4core6string10StringViewE();
            if (_bind$9.$tag === 1) {
              const _ok = _bind$9;
              rest$2 = _ok._0;
              break;
            } else {
              return _bind$9;
            }
          }
        } else {
          if (_x >= 48 && _x <= 57) {
            const _tmp$2 = _param.str;
            const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 1, _param.start, _param.end);
            let _tmp$3;
            if (_bind$8 === undefined) {
              _tmp$3 = _param.end;
            } else {
              const _Some = _bind$8;
              _tmp$3 = _Some;
            }
            const _x$2 = { str: _tmp$2, start: _tmp$3, end: _param.end };
            has_digits = true;
            if (_x === 48 && d.digits_num === 0) {
              d.decimal_point = d.decimal_point - 1 | 0;
              _tmp = _x$2;
              continue;
            }
            if (d.digits_num < d.digits.length) {
              const _tmp$4 = d.digits;
              const _tmp$5 = d.digits_num;
              $bound_check(_tmp$4, _tmp$5);
              _tmp$4[_tmp$5] = (_x - 48 | 0) & 255;
              d.digits_num = d.digits_num + 1 | 0;
            } else {
              if (_x !== 48) {
                d.truncated = true;
              }
            }
            _tmp = _x$2;
            continue;
          } else {
            rest$2 = _param;
            break;
          }
        }
      }
    } else {
      rest$2 = _param;
      break;
    }
  }
  if (has_digits) {
    if (!has_dp) {
      d.decimal_point = d.digits_num;
    }
    let rest$3;
    let rest$4;
    _L$2: {
      _L$3: {
        if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(rest$2.str, 1, rest$2.start, rest$2.end)) {
          const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(rest$2.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest$2.str, 0, rest$2.start, rest$2.end));
          switch (_x) {
            case 101: {
              const _tmp$2 = rest$2.str;
              const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest$2.str, 1, rest$2.start, rest$2.end);
              let _tmp$3;
              if (_bind$8 === undefined) {
                _tmp$3 = rest$2.end;
              } else {
                const _Some = _bind$8;
                _tmp$3 = _Some;
              }
              const _x$2 = { str: _tmp$2, start: _tmp$3, end: rest$2.end };
              rest$4 = _x$2;
              break _L$3;
            }
            case 69: {
              const _tmp$4 = rest$2.str;
              const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest$2.str, 1, rest$2.start, rest$2.end);
              let _tmp$5;
              if (_bind$9 === undefined) {
                _tmp$5 = rest$2.end;
              } else {
                const _Some = _bind$9;
                _tmp$5 = _Some;
              }
              const _x$3 = { str: _tmp$4, start: _tmp$5, end: rest$2.end };
              rest$4 = _x$3;
              break _L$3;
            }
            default: {
              rest$3 = rest$2;
            }
          }
        } else {
          rest$3 = rest$2;
        }
        break _L$2;
      }
      let exp_sign = 1;
      let rest$5;
      if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(rest$4.str, 1, rest$4.start, rest$4.end)) {
        const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(rest$4.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest$4.str, 0, rest$4.start, rest$4.end));
        switch (_x) {
          case 43: {
            const _tmp$2 = rest$4.str;
            const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest$4.str, 1, rest$4.start, rest$4.end);
            let _tmp$3;
            if (_bind$8 === undefined) {
              _tmp$3 = rest$4.end;
            } else {
              const _Some = _bind$8;
              _tmp$3 = _Some;
            }
            rest$5 = { str: _tmp$2, start: _tmp$3, end: rest$4.end };
            break;
          }
          case 45: {
            const _tmp$4 = rest$4.str;
            const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest$4.str, 1, rest$4.start, rest$4.end);
            let _tmp$5;
            if (_bind$9 === undefined) {
              _tmp$5 = rest$4.end;
            } else {
              const _Some = _bind$9;
              _tmp$5 = _Some;
            }
            const _x$2 = { str: _tmp$4, start: _tmp$5, end: rest$4.end };
            exp_sign = -1;
            rest$5 = _x$2;
            break;
          }
          default: {
            rest$5 = rest$4;
          }
        }
      } else {
        rest$5 = rest$4;
      }
      _L$4: {
        _L$5: {
          if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(rest$5.str, 1, rest$5.start, rest$5.end)) {
            const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(rest$5.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest$5.str, 0, rest$5.start, rest$5.end));
            if (_x >= 48 && _x <= 57) {
              let exp = 0;
              let rest$6;
              let _tmp$2 = rest$5;
              while (true) {
                const _param = _tmp$2;
                if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_param.str, 1, _param.start, _param.end)) {
                  const _x$2 = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 0, _param.start, _param.end));
                  if (_x$2 === 95) {
                    const _tmp$3 = _param.str;
                    const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 1, _param.start, _param.end);
                    let _tmp$4;
                    if (_bind$8 === undefined) {
                      _tmp$4 = _param.end;
                    } else {
                      const _Some = _bind$8;
                      _tmp$4 = _Some;
                    }
                    const _x$3 = { str: _tmp$3, start: _tmp$4, end: _param.end };
                    _tmp$2 = _x$3;
                    continue;
                  } else {
                    if (_x$2 >= 48 && _x$2 <= 57) {
                      const _tmp$3 = _param.str;
                      const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 1, _param.start, _param.end);
                      let _tmp$4;
                      if (_bind$8 === undefined) {
                        _tmp$4 = _param.end;
                      } else {
                        const _Some = _bind$8;
                        _tmp$4 = _Some;
                      }
                      const _x$3 = { str: _tmp$3, start: _tmp$4, end: _param.end };
                      exp = (Math.imul(exp, 10) | 0) + (_x$2 - 48 | 0) | 0;
                      _tmp$2 = _x$3;
                      continue;
                    } else {
                      rest$6 = _param;
                      break;
                    }
                  }
                } else {
                  rest$6 = _param;
                  break;
                }
              }
              d.decimal_point = d.decimal_point + (Math.imul(exp_sign, exp) | 0) | 0;
              rest$3 = rest$6;
            } else {
              break _L$5;
            }
          } else {
            break _L$5;
          }
          break _L$4;
        }
        const _bind$8 = _M0FP311moonbitlang4core7strconv11syntax__errGRP311moonbitlang4core6string10StringViewE();
        if (_bind$8.$tag === 1) {
          const _ok = _bind$8;
          rest$3 = _ok._0;
        } else {
          return _bind$8;
        }
      }
    }
    if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(rest$3.str, 0, rest$3.start, rest$3.end)) {
      _M0MP311moonbitlang4core7strconv7Decimal4trim(d);
      return new Result$Ok$13$(d);
    } else {
      return _M0FP311moonbitlang4core7strconv11syntax__errGRP311moonbitlang4core7strconv7DecimalE();
    }
  } else {
    return _M0FP311moonbitlang4core7strconv11syntax__errGRP311moonbitlang4core7strconv7DecimalE();
  }
}
function _M0FP311moonbitlang4core7strconv20parse__decimal__priv(str) {
  return _M0FP311moonbitlang4core7strconv26parse__decimal__from__view(str);
}
function _M0FP311moonbitlang4core7strconv15parse__inf__nan(rest) {
  let _bind$8;
  let rest$2;
  _L: {
    _L$2: {
      if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(rest.str, 1, rest.start, rest.end)) {
        const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(rest.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest.str, 0, rest.start, rest.end));
        switch (_x) {
          case 45: {
            const _tmp = rest.str;
            const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest.str, 1, rest.start, rest.end);
            let _tmp$2;
            if (_bind$9 === undefined) {
              _tmp$2 = rest.end;
            } else {
              const _Some = _bind$9;
              _tmp$2 = _Some;
            }
            const _x$2 = { str: _tmp, start: _tmp$2, end: rest.end };
            _bind$8 = { _0: false, _1: _x$2 };
            break;
          }
          case 43: {
            const _tmp$3 = rest.str;
            const _bind$10 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(rest.str, 1, rest.start, rest.end);
            let _tmp$4;
            if (_bind$10 === undefined) {
              _tmp$4 = rest.end;
            } else {
              const _Some = _bind$10;
              _tmp$4 = _Some;
            }
            const _x$3 = { str: _tmp$3, start: _tmp$4, end: rest.end };
            rest$2 = _x$3;
            break _L$2;
          }
          default: {
            rest$2 = rest;
            break _L$2;
          }
        }
      } else {
        rest$2 = rest;
        break _L$2;
      }
      break _L;
    }
    _bind$8 = { _0: true, _1: rest$2 };
  }
  const _pos = _bind$8._0;
  const _rest = _bind$8._1;
  const _data = _rest.str;
  const _start = _rest.start;
  const _end = _start + (_rest.end - _rest.start | 0) | 0;
  let _cursor = _start;
  let accept_state = -1;
  let match_end = -1;
  _L$2: {
    _L$3: {
      if ((_cursor + 2 | 0) < _end) {
        _L$4: {
          _L$5: {
            const _p = _cursor;
            const next_char = _data.charCodeAt(_p);
            _cursor = _cursor + 1 | 0;
            if (next_char < 79) {
              if (next_char < 74) {
                if (next_char < 73) {
                  break _L$2;
                } else {
                  break _L$4;
                }
              } else {
                if (next_char > 77) {
                  break _L$5;
                } else {
                  break _L$2;
                }
              }
            } else {
              if (next_char > 104) {
                if (next_char < 110) {
                  if (next_char < 106) {
                    break _L$4;
                  } else {
                    break _L$2;
                  }
                } else {
                  if (next_char > 110) {
                    break _L$2;
                  } else {
                    break _L$5;
                  }
                }
              } else {
                break _L$2;
              }
            }
          }
          _L$6: {
            const _p = _cursor;
            const next_char = _data.charCodeAt(_p);
            _cursor = _cursor + 1 | 0;
            if (next_char < 66) {
              if (next_char < 65) {
                break _L$2;
              } else {
                break _L$6;
              }
            } else {
              if (next_char > 96) {
                if (next_char < 98) {
                  break _L$6;
                } else {
                  break _L$2;
                }
              } else {
                break _L$2;
              }
            }
          }
          _L$7: {
            const _p = _cursor;
            const next_char = _data.charCodeAt(_p);
            _cursor = _cursor + 1 | 0;
            if (next_char < 79) {
              if (next_char < 78) {
                break _L$2;
              } else {
                break _L$7;
              }
            } else {
              if (next_char > 109) {
                if (next_char < 111) {
                  break _L$7;
                } else {
                  break _L$2;
                }
              } else {
                break _L$2;
              }
            }
          }
          if (_cursor < _end) {
            break _L$2;
          } else {
            accept_state = 0;
            match_end = _cursor;
            break _L$2;
          }
        }
        _L$5: {
          const _p = _cursor;
          const next_char = _data.charCodeAt(_p);
          _cursor = _cursor + 1 | 0;
          if (next_char < 79) {
            if (next_char < 78) {
              break _L$2;
            } else {
              break _L$5;
            }
          } else {
            if (next_char > 109) {
              if (next_char < 111) {
                break _L$5;
              } else {
                break _L$2;
              }
            } else {
              break _L$2;
            }
          }
        }
        _L$6: {
          const _p = _cursor;
          const next_char = _data.charCodeAt(_p);
          _cursor = _cursor + 1 | 0;
          if (next_char < 71) {
            if (next_char < 70) {
              break _L$2;
            } else {
              break _L$6;
            }
          } else {
            if (next_char > 101) {
              if (next_char < 103) {
                break _L$6;
              } else {
                break _L$2;
              }
            } else {
              break _L$2;
            }
          }
        }
        if (_cursor < _end) {
          _L$7: {
            const _p = _cursor;
            const next_char = _data.charCodeAt(_p);
            _cursor = _cursor + 1 | 0;
            if (next_char < 74) {
              if (next_char < 73) {
                break _L$2;
              } else {
                break _L$7;
              }
            } else {
              if (next_char > 104) {
                if (next_char < 106) {
                  break _L$7;
                } else {
                  break _L$2;
                }
              } else {
                break _L$2;
              }
            }
          }
          if ((_cursor + 3 | 0) < _end) {
            _L$8: {
              const _p = _cursor;
              const next_char = _data.charCodeAt(_p);
              _cursor = _cursor + 1 | 0;
              if (next_char < 79) {
                if (next_char < 78) {
                  break _L$2;
                } else {
                  break _L$8;
                }
              } else {
                if (next_char > 109) {
                  if (next_char < 111) {
                    break _L$8;
                  } else {
                    break _L$2;
                  }
                } else {
                  break _L$2;
                }
              }
            }
            _L$9: {
              const _p = _cursor;
              const next_char = _data.charCodeAt(_p);
              _cursor = _cursor + 1 | 0;
              if (next_char < 74) {
                if (next_char < 73) {
                  break _L$2;
                } else {
                  break _L$9;
                }
              } else {
                if (next_char > 104) {
                  if (next_char < 106) {
                    break _L$9;
                  } else {
                    break _L$2;
                  }
                } else {
                  break _L$2;
                }
              }
            }
            _L$10: {
              const _p = _cursor;
              const next_char = _data.charCodeAt(_p);
              _cursor = _cursor + 1 | 0;
              if (next_char < 85) {
                if (next_char < 84) {
                  break _L$2;
                } else {
                  break _L$10;
                }
              } else {
                if (next_char > 115) {
                  if (next_char < 117) {
                    break _L$10;
                  } else {
                    break _L$2;
                  }
                } else {
                  break _L$2;
                }
              }
            }
            _L$11: {
              const _p = _cursor;
              const next_char = _data.charCodeAt(_p);
              _cursor = _cursor + 1 | 0;
              if (next_char < 90) {
                if (next_char < 89) {
                  break _L$2;
                } else {
                  break _L$11;
                }
              } else {
                if (next_char > 120) {
                  if (next_char < 122) {
                    break _L$11;
                  } else {
                    break _L$2;
                  }
                } else {
                  break _L$2;
                }
              }
            }
            if (_cursor < _end) {
              break _L$2;
            } else {
              break _L$3;
            }
          } else {
            break _L$2;
          }
        } else {
          break _L$3;
        }
      } else {
        break _L$2;
      }
    }
    accept_state = 1;
    match_end = _cursor;
    break _L$2;
  }
  switch (accept_state) {
    case 0: {
      return new Result$Ok$9$(_M0FP311moonbitlang4core6double14not__a__number);
    }
    case 1: {
      return _pos ? new Result$Ok$9$(_M0FP311moonbitlang4core6double8infinity) : new Result$Ok$9$(_M0FP311moonbitlang4core6double13neg__infinity);
    }
    default: {
      return _M0FP311moonbitlang4core7strconv11syntax__errGdE();
    }
  }
}
function _M0EP311moonbitlang4core6string10StringViewP311moonbitlang4core7strconv12fold__digitsGmE(self, init, f) {
  let ret = init;
  let len = 0;
  let str = self;
  while (true) {
    const _bind$8 = str;
    if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_bind$8.str, 1, _bind$8.start, _bind$8.end)) {
      const _ch = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_bind$8.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$8.str, 0, _bind$8.start, _bind$8.end));
      const _tmp = _bind$8.str;
      const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$8.str, 1, _bind$8.start, _bind$8.end);
      let _tmp$2;
      if (_bind$9 === undefined) {
        _tmp$2 = _bind$8.end;
      } else {
        const _Some = _bind$9;
        _tmp$2 = _Some;
      }
      const _x = { str: _tmp, start: _tmp$2, end: _bind$8.end };
      if (_ch >= 48 && _ch <= 57) {
        len = len + 1 | 0;
        ret = f(_ch - 48 | 0, ret);
      } else {
        if (_ch !== 95) {
          break;
        }
      }
      str = _x;
      continue;
    } else {
      break;
    }
  }
  return { _0: str, _1: ret, _2: len };
}
function _M0EP311moonbitlang4core6string10StringViewP311moonbitlang4core7strconv12fold__digitsGlE(self, init, f) {
  let ret = init;
  let len = 0;
  let str = self;
  while (true) {
    const _bind$8 = str;
    if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_bind$8.str, 1, _bind$8.start, _bind$8.end)) {
      const _ch = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_bind$8.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$8.str, 0, _bind$8.start, _bind$8.end));
      const _tmp = _bind$8.str;
      const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$8.str, 1, _bind$8.start, _bind$8.end);
      let _tmp$2;
      if (_bind$9 === undefined) {
        _tmp$2 = _bind$8.end;
      } else {
        const _Some = _bind$9;
        _tmp$2 = _Some;
      }
      const _x = { str: _tmp, start: _tmp$2, end: _bind$8.end };
      if (_ch >= 48 && _ch <= 57) {
        len = len + 1 | 0;
        ret = f(_ch - 48 | 0, ret);
      } else {
        if (_ch !== 95) {
          break;
        }
      }
      str = _x;
      continue;
    } else {
      break;
    }
  }
  return { _0: str, _1: ret, _2: len };
}
function _M0FP311moonbitlang4core7strconv13parse__digits(s, x) {
  return _M0EP311moonbitlang4core6string10StringViewP311moonbitlang4core7strconv12fold__digitsGmE(s, x, (digit, acc) => _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(acc, $10L), _M0MP311moonbitlang4core6uint646UInt6412extend__uint(digit)));
}
function _M0FP311moonbitlang4core7strconv17parse__scientific(s) {
  let s$2 = s;
  let neg_exp = false;
  let rest;
  let ch;
  _L: {
    _L$2: {
      const _bind$8 = s$2;
      if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_bind$8.str, 1, _bind$8.start, _bind$8.end)) {
        const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_bind$8.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$8.str, 0, _bind$8.start, _bind$8.end));
        switch (_x) {
          case 43: {
            const _tmp = _bind$8.str;
            const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$8.str, 1, _bind$8.start, _bind$8.end);
            let _tmp$2;
            if (_bind$9 === undefined) {
              _tmp$2 = _bind$8.end;
            } else {
              const _Some = _bind$9;
              _tmp$2 = _Some;
            }
            const _x$2 = { str: _tmp, start: _tmp$2, end: _bind$8.end };
            rest = _x$2;
            ch = _x;
            break _L$2;
          }
          case 45: {
            const _tmp$3 = _bind$8.str;
            const _bind$10 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$8.str, 1, _bind$8.start, _bind$8.end);
            let _tmp$4;
            if (_bind$10 === undefined) {
              _tmp$4 = _bind$8.end;
            } else {
              const _Some = _bind$10;
              _tmp$4 = _Some;
            }
            const _x$3 = { str: _tmp$3, start: _tmp$4, end: _bind$8.end };
            rest = _x$3;
            ch = _x;
            break _L$2;
          }
        }
      }
      break _L;
    }
    neg_exp = ch === 45;
    s$2 = rest;
  }
  _L$2: {
    const _bind$8 = s$2;
    if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_bind$8.str, 1, _bind$8.start, _bind$8.end)) {
      const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_bind$8.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$8.str, 0, _bind$8.start, _bind$8.end));
      if (_x >= 48 && _x <= 57) {
        const _bind$9 = _M0EP311moonbitlang4core6string10StringViewP311moonbitlang4core7strconv12fold__digitsGlE(s$2, _M0FP311moonbitlang4core7strconv34parse__scientific_2eexp__num_7c279, (digit, exp_num) => _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGlE(exp_num, $65536L) ? _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul($10L, exp_num), _M0MP311moonbitlang4core3int3Int9to__int64(digit)) : exp_num);
        const _s = _bind$9._0;
        const _exp_num = _bind$9._1;
        return neg_exp ? { _0: _s, _1: _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Neg3neg(_exp_num) } : { _0: _s, _1: _exp_num };
      } else {
        break _L$2;
      }
    } else {
      break _L$2;
    }
  }
  return undefined;
}
function _M0FP311moonbitlang4core7strconv20try__parse__19digits(s, x) {
  let x$2 = x;
  let len = 0;
  let _tmp = s;
  while (true) {
    const _param = _tmp;
    let s$2;
    _L: {
      if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_param.str, 1, _param.start, _param.end)) {
        const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 0, _param.start, _param.end));
        if (_x >= 48 && _x <= 57) {
          const _tmp$2 = _param.str;
          const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 1, _param.start, _param.end);
          let _tmp$3;
          if (_bind$8 === undefined) {
            _tmp$3 = _param.end;
          } else {
            const _Some = _bind$8;
            _tmp$3 = _Some;
          }
          const _x$2 = { str: _tmp$2, start: _tmp$3, end: _param.end };
          if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGmE(x$2, _M0FP311moonbitlang4core7strconv17min__19digit__int)) {
            len = len + 1 | 0;
            x$2 = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(x$2, $10L), _M0MP311moonbitlang4core6uint646UInt6412extend__uint(_x - 48 | 0));
            _tmp = _x$2;
            continue;
          } else {
            s$2 = _param;
            break _L;
          }
        } else {
          if (_x === 95) {
            const _tmp$2 = _param.str;
            const _bind$8 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 1, _param.start, _param.end);
            let _tmp$3;
            if (_bind$8 === undefined) {
              _tmp$3 = _param.end;
            } else {
              const _Some = _bind$8;
              _tmp$3 = _Some;
            }
            const _x$2 = { str: _tmp$2, start: _tmp$3, end: _param.end };
            _tmp = _x$2;
            continue;
          } else {
            s$2 = _param;
            break _L;
          }
        }
      } else {
        s$2 = _param;
        break _L;
      }
    }
    return { _0: s$2, _1: x$2, _2: len };
  }
}
function _M0FP311moonbitlang4core7strconv13parse__number(s) {
  let _bind$8;
  let rest;
  _L: {
    _L$2: {
      if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(s.str, 1, s.start, s.end)) {
        const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(s.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(s.str, 0, s.start, s.end));
        switch (_x) {
          case 45: {
            const _tmp = s.str;
            const _bind$9 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(s.str, 1, s.start, s.end);
            let _tmp$2;
            if (_bind$9 === undefined) {
              _tmp$2 = s.end;
            } else {
              const _Some = _bind$9;
              _tmp$2 = _Some;
            }
            const _x$2 = { str: _tmp, start: _tmp$2, end: s.end };
            _bind$8 = { _0: _x$2, _1: true };
            break;
          }
          case 43: {
            const _tmp$3 = s.str;
            const _bind$10 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(s.str, 1, s.start, s.end);
            let _tmp$4;
            if (_bind$10 === undefined) {
              _tmp$4 = s.end;
            } else {
              const _Some = _bind$10;
              _tmp$4 = _Some;
            }
            const _x$3 = { str: _tmp$3, start: _tmp$4, end: s.end };
            rest = _x$3;
            break _L$2;
          }
          default: {
            rest = s;
            break _L$2;
          }
        }
      } else {
        rest = s;
        break _L$2;
      }
      break _L;
    }
    _bind$8 = { _0: rest, _1: false };
  }
  const _s = _bind$8._0;
  const _negative = _bind$8._1;
  if (_M0MP311moonbitlang4core6string10StringView9is__empty(_s)) {
    return new Result$Ok$10$(undefined);
  }
  const _bind$9 = _M0FP311moonbitlang4core7strconv13parse__digits(_s, $0L);
  const _s$2 = _bind$9._0;
  const _mantissa = _bind$9._1;
  const _consumed = _bind$9._2;
  let mantissa = _mantissa;
  let s$2 = _s$2;
  let n_digits = _consumed;
  let n_after_dot = 0;
  let exponent = $0L;
  const _bind$10 = s$2;
  if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_bind$10.str, 1, _bind$10.start, _bind$10.end)) {
    const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_bind$10.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$10.str, 0, _bind$10.start, _bind$10.end));
    if (_x === 46) {
      const _tmp = _bind$10.str;
      const _bind$11 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$10.str, 1, _bind$10.start, _bind$10.end);
      let _tmp$2;
      if (_bind$11 === undefined) {
        _tmp$2 = _bind$10.end;
      } else {
        const _Some = _bind$11;
        _tmp$2 = _Some;
      }
      const _x$2 = { str: _tmp, start: _tmp$2, end: _bind$10.end };
      s$2 = _x$2;
      const _bind$12 = _M0FP311moonbitlang4core7strconv13parse__digits(s$2, mantissa);
      const _new_s = _bind$12._0;
      const _new_mantissa = _bind$12._1;
      const _consumed_digit = _bind$12._2;
      s$2 = _new_s;
      mantissa = _new_mantissa;
      n_after_dot = _consumed_digit;
      exponent = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Neg3neg(_M0MP311moonbitlang4core3int3Int9to__int64(n_after_dot));
    }
  }
  n_digits = n_digits + n_after_dot | 0;
  if (n_digits === 0) {
    return new Result$Ok$10$(undefined);
  }
  let rest$2;
  _L$2: {
    _L$3: {
      const _bind$11 = s$2;
      if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_bind$11.str, 1, _bind$11.start, _bind$11.end)) {
        const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_bind$11.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$11.str, 0, _bind$11.start, _bind$11.end));
        switch (_x) {
          case 101: {
            const _tmp = _bind$11.str;
            const _bind$12 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$11.str, 1, _bind$11.start, _bind$11.end);
            let _tmp$2;
            if (_bind$12 === undefined) {
              _tmp$2 = _bind$11.end;
            } else {
              const _Some = _bind$12;
              _tmp$2 = _Some;
            }
            const _x$2 = { str: _tmp, start: _tmp$2, end: _bind$11.end };
            rest$2 = _x$2;
            break _L$3;
          }
          case 69: {
            const _tmp$3 = _bind$11.str;
            const _bind$13 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$11.str, 1, _bind$11.start, _bind$11.end);
            let _tmp$4;
            if (_bind$13 === undefined) {
              _tmp$4 = _bind$11.end;
            } else {
              const _Some = _bind$13;
              _tmp$4 = _Some;
            }
            const _x$3 = { str: _tmp$3, start: _tmp$4, end: _bind$11.end };
            rest$2 = _x$3;
            break _L$3;
          }
        }
      }
      break _L$2;
    }
    const _bind$11 = _M0FP311moonbitlang4core7strconv17parse__scientific(rest$2);
    let _bind$12;
    if (_bind$11 === undefined) {
      return new Result$Ok$10$(undefined);
    } else {
      const _Some = _bind$11;
      _bind$12 = _Some;
    }
    const _new_s = _bind$12._0;
    const _exp_number = _bind$12._1;
    s$2 = _new_s;
    exponent = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(exponent, _exp_number);
  }
  const _bind$11 = s$2;
  if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_bind$11.str, 0, _bind$11.start, _bind$11.end)) {
    if (n_digits <= 19) {
      return new Result$Ok$10$({ exponent: exponent, mantissa: mantissa, negative: _negative, many_digits: false });
    }
    n_digits = n_digits - 19 | 0;
    let many_digits = false;
    let _tmp = s.str;
    let _tmp$2 = s.start;
    let _tmp$3 = s.end;
    _L$3: while (true) {
      const _param_str = _tmp;
      const _param_start = _tmp$2;
      const _param_end = _tmp$3;
      let rest$3;
      let ch;
      _L$4: {
        if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_param_str, 1, _param_start, _param_end)) {
          const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param_str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_str, 0, _param_start, _param_end));
          switch (_x) {
            case 48: {
              const _bind$12 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_str, 1, _param_start, _param_end);
              let _tmp$4;
              if (_bind$12 === undefined) {
                _tmp$4 = _param_end;
              } else {
                const _Some = _bind$12;
                _tmp$4 = _Some;
              }
              const _x$2 = { str: _param_str, start: _tmp$4, end: _param_end };
              rest$3 = _x$2;
              ch = _x;
              break _L$4;
            }
            case 46: {
              const _bind$13 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_str, 1, _param_start, _param_end);
              let _tmp$5;
              if (_bind$13 === undefined) {
                _tmp$5 = _param_end;
              } else {
                const _Some = _bind$13;
                _tmp$5 = _Some;
              }
              const _x$3 = { str: _param_str, start: _tmp$5, end: _param_end };
              rest$3 = _x$3;
              ch = _x;
              break _L$4;
            }
            default: {
              break _L$3;
            }
          }
        } else {
          break;
        }
      }
      n_digits = n_digits - ((ch - 46 | 0) / 2 | 0) | 0;
      _tmp = rest$3.str;
      _tmp$2 = rest$3.start;
      _tmp$3 = rest$3.end;
      continue;
    }
    let mantissa$2 = mantissa;
    if (n_digits > 0) {
      many_digits = true;
      mantissa$2 = $0L;
      const _bind$12 = _M0FP311moonbitlang4core7strconv20try__parse__19digits(s, mantissa$2);
      const _s$3 = _bind$12._0;
      const _new_mantissa = _bind$12._1;
      const _consumed_digit = _bind$12._2;
      mantissa$2 = _new_mantissa;
      let _tmp$4;
      if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGmE(mantissa$2, _M0FP311moonbitlang4core7strconv17min__19digit__int)) {
        _tmp$4 = _consumed_digit;
      } else {
        if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_s$3.str, 1, _s$3.start, _s$3.end)) {
          const _tmp$5 = _s$3.str;
          const _bind$13 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_s$3.str, 1, _s$3.start, _s$3.end);
          let _tmp$6;
          if (_bind$13 === undefined) {
            _tmp$6 = _s$3.end;
          } else {
            const _Some = _bind$13;
            _tmp$6 = _Some;
          }
          const _x = { str: _tmp$5, start: _tmp$6, end: _s$3.end };
          const _bind$14 = _M0FP311moonbitlang4core7strconv20try__parse__19digits(_x, mantissa$2);
          const _new_mantissa$2 = _bind$14._1;
          const _consumed_digit$2 = _bind$14._2;
          mantissa$2 = _new_mantissa$2;
          _tmp$4 = _consumed_digit$2;
        } else {
          return new Result$Ok$10$(undefined);
        }
      }
      exponent = _M0MP311moonbitlang4core3int3Int9to__int64(_tmp$4);
      exponent = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(exponent, _M0FP311moonbitlang4core7strconv33parse__number_2eexp__number_7c260);
    }
    return new Result$Ok$10$({ exponent: exponent, mantissa: mantissa$2, negative: _negative, many_digits: many_digits });
  } else {
    return _M0FP311moonbitlang4core7strconv11syntax__errGORP311moonbitlang4core7strconv6NumberE();
  }
}
function _M0FP311moonbitlang4core7strconv14assemble__bits(mantissa, exponent, negative) {
  const biased_exp = exponent - _M0FP311moonbitlang4core7strconv12double__info.bias | 0;
  let bits = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin6BitAnd4land(mantissa, _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Sub3sub(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shl3shl($1L, _M0FP311moonbitlang4core7strconv12double__info.mantissa_bits), $1L));
  const exp_bits = _M0MP311moonbitlang4core3int3Int9to__int64(biased_exp & ((1 << _M0FP311moonbitlang4core7strconv12double__info.exponent_bits) - 1 | 0));
  bits = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin5BitOr3lor(bits, _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shl3shl(exp_bits, _M0FP311moonbitlang4core7strconv12double__info.mantissa_bits));
  if (negative) {
    bits = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin5BitOr3lor(bits, _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shl3shl(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shl3shl($1L, _M0FP311moonbitlang4core7strconv12double__info.mantissa_bits), _M0FP311moonbitlang4core7strconv12double__info.exponent_bits));
  }
  return bits;
}
function _M0MP311moonbitlang4core7strconv7Decimal17should__round__up(self, d) {
  if (d < 0 || d >= self.digits_num) {
    return false;
  }
  let _tmp;
  const _tmp$2 = self.digits;
  $bound_check(_tmp$2, d);
  if (_tmp$2[d] === 5) {
    _tmp = (d + 1 | 0) === self.digits_num;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    if (self.truncated) {
      return true;
    }
    let _tmp$3;
    if (d > 0) {
      const _tmp$4 = self.digits;
      const _tmp$5 = d - 1 | 0;
      $bound_check(_tmp$4, _tmp$5);
      _tmp$3 = (_tmp$4[_tmp$5] % 2 | 0) !== 0;
    } else {
      _tmp$3 = false;
    }
    return _tmp$3;
  }
  const _tmp$3 = self.digits;
  $bound_check(_tmp$3, d);
  return _tmp$3[d] >= 5;
}
function _M0MP311moonbitlang4core7strconv7Decimal16rounded__integer(self) {
  if (self.decimal_point > 20) {
    return $_1L;
  }
  let n = $0L;
  let i = 0;
  while (true) {
    if (i < self.decimal_point && i < self.digits_num) {
      const _tmp = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul(n, $10L);
      const _tmp$2 = self.digits;
      const _tmp$3 = i;
      $bound_check(_tmp$2, _tmp$3);
      n = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_tmp, _M0MP311moonbitlang4core4byte4Byte9to__int64(_tmp$2[_tmp$3]));
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    if (i < self.decimal_point) {
      n = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul(n, $10L);
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (_M0MP311moonbitlang4core7strconv7Decimal17should__round__up(self, self.decimal_point)) {
    n = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(n, $1L);
  }
  return n;
}
function _M0MP311moonbitlang4core7strconv7Decimal11new__digits(self, s) {
  $bound_check(_M0FP311moonbitlang4core7strconv19left__shift__cheats, s);
  const new_digits = _M0FP311moonbitlang4core7strconv19left__shift__cheats[s]._0;
  $bound_check(_M0FP311moonbitlang4core7strconv19left__shift__cheats, s);
  const cheat_num = _M0FP311moonbitlang4core7strconv19left__shift__cheats[s]._1;
  let less = false;
  const _end73 = cheat_num.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _end73) {
      if (i >= self.digits_num) {
        less = true;
        break;
      }
      const d = cheat_num.charCodeAt(i) - 48 | 0;
      const _tmp$2 = self.digits;
      $bound_check(_tmp$2, i);
      if (_tmp$2[i] !== d) {
        const _tmp$3 = self.digits;
        $bound_check(_tmp$3, i);
        less = _tmp$3[i] < d;
        break;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return less ? new_digits - 1 | 0 : new_digits;
}
function _M0MP311moonbitlang4core7strconv7Decimal11left__shift(self, s) {
  const new_digits = _M0MP311moonbitlang4core7strconv7Decimal11new__digits(self, s);
  let read_index = self.digits_num;
  let write_index = self.digits_num + new_digits | 0;
  let acc = $0L;
  read_index = read_index - 1 | 0;
  while (true) {
    if (read_index >= 0) {
      const _tmp = self.digits;
      const _tmp$2 = read_index;
      $bound_check(_tmp, _tmp$2);
      const d = _M0MP311moonbitlang4core4byte4Byte9to__int64(_tmp[_tmp$2]);
      acc = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(acc, _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shl3shl(d, s));
      const quo = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div(acc, $10L);
      const rem = _M0MP311moonbitlang4core5int645Int647to__int(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Sub3sub(acc, _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul(quo, $10L)));
      write_index = write_index - 1 | 0;
      if (write_index < self.digits.length) {
        const _tmp$3 = self.digits;
        const _tmp$4 = write_index;
        $bound_check(_tmp$3, _tmp$4);
        _tmp$3[_tmp$4] = rem & 255;
      } else {
        if (rem !== 0) {
          self.truncated = true;
        }
      }
      acc = quo;
      read_index = read_index - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGlE(acc, $0L)) {
      const quo = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div(acc, $10L);
      const rem = _M0MP311moonbitlang4core5int645Int647to__int(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Sub3sub(acc, _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul($10L, quo)));
      write_index = write_index - 1 | 0;
      if (write_index < self.digits.length) {
        const _tmp = self.digits;
        const _tmp$2 = write_index;
        $bound_check(_tmp, _tmp$2);
        _tmp[_tmp$2] = rem & 255;
      } else {
        if (rem !== 0) {
          self.truncated = true;
        }
      }
      acc = quo;
      continue;
    } else {
      break;
    }
  }
  self.digits_num = self.digits_num + new_digits | 0;
  if (self.digits_num > self.digits.length) {
    self.digits_num = self.digits.length;
  }
  self.decimal_point = self.decimal_point + new_digits | 0;
  _M0MP311moonbitlang4core7strconv7Decimal4trim(self);
}
function _M0MP311moonbitlang4core7strconv7Decimal12right__shift(self, s) {
  let read_index = 0;
  let write_index = 0;
  let acc = $0L;
  while (true) {
    if (_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin2Eq5equal(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(acc, s), $0L)) {
      if (read_index >= self.digits_num) {
        while (true) {
          if (_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin2Eq5equal(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(acc, s), $0L)) {
            acc = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(acc, $10L);
            read_index = read_index + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        break;
      }
      const _tmp = self.digits;
      const _tmp$2 = read_index;
      $bound_check(_tmp, _tmp$2);
      const d = _tmp[_tmp$2];
      acc = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(acc, $10L), _M0MP311moonbitlang4core4byte4Byte9to__int64(d));
      read_index = read_index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  self.decimal_point = self.decimal_point - (read_index - 1 | 0) | 0;
  const mask = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Sub3sub(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shl3shl($1L, s), $1L);
  while (true) {
    if (read_index < self.digits_num) {
      const out = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(acc, s);
      const _tmp = self.digits;
      const _tmp$2 = write_index;
      $bound_check(_tmp, _tmp$2);
      _tmp[_tmp$2] = _M0MP311moonbitlang4core6uint646UInt648to__byte(out);
      write_index = write_index + 1 | 0;
      acc = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin6BitAnd4land(acc, mask);
      const _tmp$3 = self.digits;
      const _tmp$4 = read_index;
      $bound_check(_tmp$3, _tmp$4);
      const d = _tmp$3[_tmp$4];
      acc = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(acc, $10L), _M0MP311moonbitlang4core4byte4Byte9to__int64(d));
      read_index = read_index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGmE(acc, $0L)) {
      const out = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(acc, s);
      if (write_index < self.digits.length) {
        const _tmp = self.digits;
        const _tmp$2 = write_index;
        $bound_check(_tmp, _tmp$2);
        _tmp[_tmp$2] = _M0MP311moonbitlang4core6uint646UInt648to__byte(out);
        write_index = write_index + 1 | 0;
      } else {
        if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGmE(out, $0L)) {
          self.truncated = true;
        }
      }
      acc = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin6BitAnd4land(acc, mask);
      acc = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(acc, $10L);
      continue;
    } else {
      break;
    }
  }
  self.digits_num = write_index;
  _M0MP311moonbitlang4core7strconv7Decimal4trim(self);
}
function _M0MP311moonbitlang4core7strconv7Decimal11shift__priv(self, s) {
  if (self.digits_num === 0) {
    return undefined;
  }
  let s$2 = s;
  if (s$2 > 0) {
    while (true) {
      if (s$2 > 59) {
        _M0MP311moonbitlang4core7strconv7Decimal11left__shift(self, 59);
        s$2 = s$2 - 59 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MP311moonbitlang4core7strconv7Decimal11left__shift(self, s$2);
  }
  if (s$2 < 0) {
    while (true) {
      if (s$2 < -59) {
        _M0MP311moonbitlang4core7strconv7Decimal12right__shift(self, 59);
        s$2 = s$2 + 59 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MP311moonbitlang4core7strconv7Decimal12right__shift(self, -s$2 | 0);
    return;
  } else {
    return;
  }
}
function _M0MP311moonbitlang4core7strconv7Decimal16to__double__priv(self) {
  let exponent = 0;
  let mantissa = $0L;
  if (self.digits_num === 0 || self.decimal_point < -330) {
    mantissa = $0L;
    exponent = _M0FP311moonbitlang4core7strconv12double__info.bias;
    const bits = _M0FP311moonbitlang4core7strconv14assemble__bits(mantissa, exponent, self.negative);
    return new Result$Ok$9$(_M0MP311moonbitlang4core5int645Int6423reinterpret__as__double(bits));
  }
  if (self.decimal_point > 310) {
    const _bind$8 = _M0FP311moonbitlang4core7strconv10range__errGuE();
    if (_bind$8.$tag === 1) {
      const _ok = _bind$8;
      _ok._0;
    } else {
      return _bind$8;
    }
  }
  while (true) {
    if (self.decimal_point > 0) {
      let n = 0;
      if (self.decimal_point >= _M0FP311moonbitlang4core7strconv6powtab.length) {
        n = 60;
      } else {
        const _p = self.decimal_point;
        $bound_check(_M0FP311moonbitlang4core7strconv6powtab, _p);
        n = _M0FP311moonbitlang4core7strconv6powtab[_p];
      }
      _M0MP311moonbitlang4core7strconv7Decimal11shift__priv(self, -n | 0);
      exponent = exponent + n | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    let _tmp;
    if (self.decimal_point < 0) {
      _tmp = true;
    } else {
      let _tmp$2;
      if (self.decimal_point === 0) {
        const _tmp$3 = self.digits;
        $bound_check(_tmp$3, 0);
        _tmp$2 = _tmp$3[0] < 5;
      } else {
        _tmp$2 = false;
      }
      _tmp = _tmp$2;
    }
    if (_tmp) {
      let n = 0;
      if ((-self.decimal_point | 0) >= _M0FP311moonbitlang4core7strconv6powtab.length) {
        n = 60;
      } else {
        const _p = -self.decimal_point | 0;
        $bound_check(_M0FP311moonbitlang4core7strconv6powtab, _p);
        n = _M0FP311moonbitlang4core7strconv6powtab[_p];
      }
      _M0MP311moonbitlang4core7strconv7Decimal11shift__priv(self, n);
      exponent = exponent - n | 0;
      continue;
    } else {
      break;
    }
  }
  exponent = exponent - 1 | 0;
  if (exponent < (_M0FP311moonbitlang4core7strconv12double__info.bias + 1 | 0)) {
    const n = (_M0FP311moonbitlang4core7strconv12double__info.bias + 1 | 0) - exponent | 0;
    _M0MP311moonbitlang4core7strconv7Decimal11shift__priv(self, -n | 0);
    exponent = exponent + n | 0;
  }
  if ((exponent - _M0FP311moonbitlang4core7strconv12double__info.bias | 0) >= ((1 << _M0FP311moonbitlang4core7strconv12double__info.exponent_bits) - 1 | 0)) {
    const _bind$8 = _M0FP311moonbitlang4core7strconv10range__errGuE();
    if (_bind$8.$tag === 1) {
      const _ok = _bind$8;
      _ok._0;
    } else {
      return _bind$8;
    }
  }
  _M0MP311moonbitlang4core7strconv7Decimal11shift__priv(self, _M0FP311moonbitlang4core7strconv12double__info.mantissa_bits + 1 | 0);
  mantissa = _M0MP311moonbitlang4core7strconv7Decimal16rounded__integer(self);
  if (_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin2Eq5equal(mantissa, _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shl3shl($2L, _M0FP311moonbitlang4core7strconv12double__info.mantissa_bits))) {
    mantissa = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shr3shr(mantissa, 1);
    exponent = exponent + 1 | 0;
    if ((exponent - _M0FP311moonbitlang4core7strconv12double__info.bias | 0) >= ((1 << _M0FP311moonbitlang4core7strconv12double__info.exponent_bits) - 1 | 0)) {
      const _bind$8 = _M0FP311moonbitlang4core7strconv10range__errGuE();
      if (_bind$8.$tag === 1) {
        const _ok = _bind$8;
        _ok._0;
      } else {
        return _bind$8;
      }
    }
  }
  if (_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin2Eq5equal(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin6BitAnd4land(mantissa, _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Shl3shl($1L, _M0FP311moonbitlang4core7strconv12double__info.mantissa_bits)), $0L)) {
    exponent = _M0FP311moonbitlang4core7strconv12double__info.bias;
  }
  const bits = _M0FP311moonbitlang4core7strconv14assemble__bits(mantissa, exponent, self.negative);
  return new Result$Ok$9$(_M0MP311moonbitlang4core5int645Int6423reinterpret__as__double(bits));
}
function _M0FP311moonbitlang4core7strconv12checked__mul(a, b) {
  if (_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin2Eq5equal(a, $0L) || _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin2Eq5equal(b, $0L)) {
    return _M0FP311moonbitlang4core7strconv28checked__mul_2econstr_2f2988;
  }
  if (_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin2Eq5equal(a, $1L)) {
    return b;
  }
  if (_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin2Eq5equal(b, $1L)) {
    return a;
  }
  if (_M0MP311moonbitlang4core6uint646UInt643clz(b) === 0 || _M0MP311moonbitlang4core6uint646UInt643clz(a) === 0) {
    return undefined;
  }
  const quotient = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Div3div(_M0FP311moonbitlang4core6uint6410max__value, b);
  if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGmE(a, quotient)) {
    return undefined;
  }
  return _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(a, b);
}
function _M0FP311moonbitlang4core7strconv17pow10__fast__path(exponent) {
  const _p = exponent & 31;
  $bound_check(_M0FP311moonbitlang4core7strconv5table, _p);
  return _M0FP311moonbitlang4core7strconv5table[_p];
}
function _M0MP311moonbitlang4core7strconv6Number14is__fast__path(self) {
  return _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGlE(_M0FP311moonbitlang4core7strconv25min__exponent__fast__path, self.exponent) && (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGlE(self.exponent, _M0FP311moonbitlang4core7strconv36max__exponent__disguised__fast__path) && (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGmE(self.mantissa, _M0FP311moonbitlang4core7strconv25max__mantissa__fast__path) && !self.many_digits));
}
function _M0MP311moonbitlang4core7strconv6Number15try__fast__path(self) {
  if (_M0MP311moonbitlang4core7strconv6Number14is__fast__path(self)) {
    let value;
    if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGlE(self.exponent, _M0FP311moonbitlang4core7strconv25max__exponent__fast__path)) {
      const value$2 = _M0MP311moonbitlang4core6double6Double15convert__uint64(self.mantissa);
      value = _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGlE(self.exponent, $0L) ? value$2 / _M0FP311moonbitlang4core7strconv17pow10__fast__path(-_M0MP311moonbitlang4core5int645Int647to__int(self.exponent) | 0) : value$2 * _M0FP311moonbitlang4core7strconv17pow10__fast__path(_M0MP311moonbitlang4core5int645Int647to__int(self.exponent));
    } else {
      const shift = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Sub3sub(self.exponent, _M0FP311moonbitlang4core7strconv25max__exponent__fast__path);
      const _tmp = self.mantissa;
      const _p = _M0MP311moonbitlang4core5int645Int647to__int(shift);
      $bound_check(_M0FP311moonbitlang4core7strconv10int__pow10, _p);
      const _bind$8 = _M0FP311moonbitlang4core7strconv12checked__mul(_tmp, _M0FP311moonbitlang4core7strconv10int__pow10[_p]);
      let mantissa;
      if (_bind$8 === undefined) {
        return Option$None$0$;
      } else {
        const _Some = _bind$8;
        mantissa = _Some;
      }
      if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGmE(mantissa, _M0FP311moonbitlang4core7strconv25max__mantissa__fast__path)) {
        return Option$None$0$;
      }
      value = _M0MP311moonbitlang4core6double6Double15convert__uint64(mantissa) * _M0FP311moonbitlang4core7strconv17pow10__fast__path(_M0MP311moonbitlang4core5int645Int647to__int(_M0FP311moonbitlang4core7strconv25max__exponent__fast__path));
    }
    if (self.negative) {
      value = -value;
    }
    return new Option$Some$0$(value);
  } else {
    return Option$None$0$;
  }
}
function _M0FP311moonbitlang4core7strconv13parse__double(str) {
  if ((str.end - str.start | 0) > 0) {
    if (_M0FP311moonbitlang4core7strconv17check__underscore(str)) {
      const _bind$8 = _M0FP311moonbitlang4core7strconv13parse__number(str);
      let _bind$9;
      if (_bind$8.$tag === 1) {
        const _ok = _bind$8;
        _bind$9 = _ok._0;
      } else {
        return _bind$8;
      }
      if (_bind$9 === undefined) {
        return _M0FP311moonbitlang4core7strconv15parse__inf__nan(str);
      } else {
        const _Some = _bind$9;
        const _num = _Some;
        const _bind$10 = _M0MP311moonbitlang4core7strconv6Number15try__fast__path(_num);
        if (_bind$10.$tag === 1) {
          const _Some$2 = _bind$10;
          const _value = _Some$2._0;
          return new Result$Ok$9$(_value);
        } else {
          const _bind$11 = _M0FP311moonbitlang4core7strconv20parse__decimal__priv(str);
          let _tmp;
          if (_bind$11.$tag === 1) {
            const _ok = _bind$11;
            _tmp = _ok._0;
          } else {
            return _bind$11;
          }
          return _M0MP311moonbitlang4core7strconv7Decimal16to__double__priv(_tmp);
        }
      }
    } else {
      return _M0FP311moonbitlang4core7strconv11syntax__errGdE();
    }
  } else {
    return _M0FP311moonbitlang4core7strconv11syntax__errGdE();
  }
}
function _M0MP311moonbitlang4core4list4List11from__arrayGRP39Milky20186selene9collision8QuadTreeE(arr) {
  let _tmp = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp$2 = $64$moonbitlang$47$core$47$list$46$List$Empty$15$;
  while (true) {
    const i = _tmp;
    const list = _tmp$2;
    if (i >= 0) {
      _tmp = i - 1 | 0;
      _tmp$2 = new $64$moonbitlang$47$core$47$list$46$List$More$15$(_M0MP311moonbitlang4core5array9ArrayView2atGRP39Milky20186selene9collision8QuadTreeE(arr, i), list);
      continue;
    } else {
      return list;
    }
  }
}
function _M0MP311moonbitlang4core3ref3Ref3newGORP39Milky20186selene6inputs13MouseMovementE(x) {
  return { val: x };
}
function _M0MP311moonbitlang4core3ref3Ref3newGdE(x) {
  return { val: x };
}
function _M0MP311moonbitlang4core3ref3Ref3newGRP39Milky20186selene9collision8QuadTreeE(x) {
  return { val: x };
}
function _M0MP311moonbitlang4core3ref3Ref3newGiE(x) {
  return { val: x };
}
function _M0FP511moonbitlang4core6random8internal14random__source5setup(seed, b32, counter) {
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
function _M0FP511moonbitlang4core6random8internal14random__source23chacha__block_2eqr_7c35(t) {
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
function _M0FP511moonbitlang4core6random8internal14random__source13chacha__block(seed, buf, counter) {
  _M0FP511moonbitlang4core6random8internal14random__source5setup(seed, buf, counter);
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
          const _bind$8 = _M0FP511moonbitlang4core6random8internal14random__source23chacha__block_2eqr_7c35({ _0: b0, _1: b4, _2: b8, _3: b12 });
          const _tb1_0 = _bind$8._0;
          const _tb1_1 = _bind$8._1;
          const _tb1_2 = _bind$8._2;
          const _tb1_3 = _bind$8._3;
          b0 = _tb1_0;
          b4 = _tb1_1;
          b8 = _tb1_2;
          b12 = _tb1_3;
          const _bind$9 = _M0FP511moonbitlang4core6random8internal14random__source23chacha__block_2eqr_7c35({ _0: b1, _1: b5, _2: b9, _3: b13 });
          const _tb2_0 = _bind$9._0;
          const _tb2_1 = _bind$9._1;
          const _tb2_2 = _bind$9._2;
          const _tb2_3 = _bind$9._3;
          b1 = _tb2_0;
          b5 = _tb2_1;
          b9 = _tb2_2;
          b13 = _tb2_3;
          const _bind$10 = _M0FP511moonbitlang4core6random8internal14random__source23chacha__block_2eqr_7c35({ _0: b2, _1: b6, _2: b10, _3: b14 });
          const _tb3_0 = _bind$10._0;
          const _tb3_1 = _bind$10._1;
          const _tb3_2 = _bind$10._2;
          const _tb3_3 = _bind$10._3;
          b2 = _tb3_0;
          b6 = _tb3_1;
          b10 = _tb3_2;
          b14 = _tb3_3;
          const _bind$11 = _M0FP511moonbitlang4core6random8internal14random__source23chacha__block_2eqr_7c35({ _0: b3, _1: b7, _2: b11, _3: b15 });
          const _tb4_0 = _bind$11._0;
          const _tb4_1 = _bind$11._1;
          const _tb4_2 = _bind$11._2;
          const _tb4_3 = _bind$11._3;
          b3 = _tb4_0;
          b7 = _tb4_1;
          b11 = _tb4_2;
          b15 = _tb4_3;
          const _bind$12 = _M0FP511moonbitlang4core6random8internal14random__source23chacha__block_2eqr_7c35({ _0: b0, _1: b5, _2: b10, _3: b15 });
          const _tb5_0 = _bind$12._0;
          const _tb5_1 = _bind$12._1;
          const _tb5_2 = _bind$12._2;
          const _tb5_3 = _bind$12._3;
          b0 = _tb5_0;
          b5 = _tb5_1;
          b10 = _tb5_2;
          b15 = _tb5_3;
          const _bind$13 = _M0FP511moonbitlang4core6random8internal14random__source23chacha__block_2eqr_7c35({ _0: b1, _1: b6, _2: b11, _3: b12 });
          const _tb6_0 = _bind$13._0;
          const _tb6_1 = _bind$13._1;
          const _tb6_2 = _bind$13._2;
          const _tb6_3 = _bind$13._3;
          b1 = _tb6_0;
          b6 = _tb6_1;
          b11 = _tb6_2;
          b12 = _tb6_3;
          const _bind$14 = _M0FP511moonbitlang4core6random8internal14random__source23chacha__block_2eqr_7c35({ _0: b2, _1: b7, _2: b8, _3: b13 });
          const _tb7_0 = _bind$14._0;
          const _tb7_1 = _bind$14._1;
          const _tb7_2 = _bind$14._2;
          const _tb7_3 = _bind$14._3;
          b2 = _tb7_0;
          b7 = _tb7_1;
          b8 = _tb7_2;
          b13 = _tb7_3;
          const _bind$15 = _M0FP511moonbitlang4core6random8internal14random__source23chacha__block_2eqr_7c35({ _0: b3, _1: b4, _2: b9, _3: b14 });
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
function _M0MP511moonbitlang4core6random8internal14random__source7ChaCha83new(seed) {
  const seed$2 = _M0MP311moonbitlang4core5array10FixedArray5makeiGjE(8, (i) => {
    const _bind$8 = _M0MP311moonbitlang4core5bytes5Bytes12view_2einner(seed, Math.imul(i, 4) | 0, undefined);
    return (_bind$8.end - _bind$8.start | 0) >= 4 ? _M0MP311moonbitlang4core5bytes9BytesView25unsafe__extract__uint__le(_bind$8, 0, 32) : _M0FP311moonbitlang4core7builtin5abortGjE("seed must be 32 bytes long", "@moonbitlang/core/random/internal/random_source:random_source_chacha.mbt:31:10-31:45");
  });
  const buffer = $make_array_len_and_init(64, 0);
  _M0FP511moonbitlang4core6random8internal14random__source13chacha__block(seed$2, buffer, 0);
  const _bind$8 = 32;
  return { buffer: buffer, seed: seed$2, i: 0, n: _bind$8, counter: 0 };
}
function _M0MP511moonbitlang4core6random8internal14random__source7ChaCha84next(self) {
  const i = self.i;
  if (i >>> 0 >= self.n >>> 0) {
    return undefined;
  }
  self.i = (i >>> 0) + (1 >>> 0) | 0;
  const index = i & 31;
  const _tmp = self.buffer;
  const _tmp$2 = Math.imul(index, 2) | 0;
  $bound_check(_tmp, _tmp$2);
  const lo = _M0MP311moonbitlang4core4uint4UInt10to__uint64(_tmp[_tmp$2]);
  const _tmp$3 = self.buffer;
  const _tmp$4 = (Math.imul(index, 2) | 0) + 1 | 0;
  $bound_check(_tmp$3, _tmp$4);
  const hi = _M0MP311moonbitlang4core4uint4UInt10to__uint64(_tmp$3[_tmp$4]);
  return _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin5BitOr3lor(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shl3shl(hi, 32), lo);
}
function _M0MP511moonbitlang4core6random8internal14random__source7ChaCha86refill(self) {
  self.counter = (self.counter >>> 0) + (4 >>> 0) | 0;
  if (self.counter === 16) {
    _M0MP311moonbitlang4core5array10FixedArray16blit__to_2einnerGjE(self.buffer, self.seed, 8, 56, 0);
    self.counter = 0;
  }
  _M0FP511moonbitlang4core6random8internal14random__source13chacha__block(self.seed, self.buffer, self.counter);
  self.i = 0;
  self.n = self.counter === 12 ? 28 : 32;
}
function _M0IP511moonbitlang4core6random8internal14random__source7ChaCha8P311moonbitlang4core6random6Source4next(self) {
  while (true) {
    const _bind$8 = _M0MP511moonbitlang4core6random8internal14random__source7ChaCha84next(self);
    if (_bind$8 === undefined) {
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      return _x;
    }
    _M0MP511moonbitlang4core6random8internal14random__source7ChaCha86refill(self);
    continue;
  }
}
function _M0MP311moonbitlang4core6random4Rand15chacha8_2einner(seed) {
  if (seed.length !== 32) {
    _M0FP311moonbitlang4core7builtin5abortGuE("seed must be 32 bytes long", "@moonbitlang/core/random:random.mbt:43:5-43:40");
  }
  return { self: _M0MP511moonbitlang4core6random8internal14random__source7ChaCha83new(seed), method_table: _M0FP0115_40moonbitlang_2fcore_2frandom_2finternal_2frandom__source_2eChaCha8_24as_24_40moonbitlang_2fcore_2frandom_2eSource };
}
function _M0MP311moonbitlang4core6random4Rand3new(generator) {
  if (generator.$tag === 0) {
    return _M0MP311moonbitlang4core6random4Rand15chacha8_2einner($bytes_literal$0);
  } else {
    const _Some = generator;
    const _gen = _Some._0;
    return _gen;
  }
}
function _M0FP311moonbitlang4core6random7umul128(a, b) {
  const aLo = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin6BitAnd4land(a, $4294967295L);
  const aHi = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(a, 32);
  const bLo = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin6BitAnd4land(b, $4294967295L);
  const bHi = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(b, 32);
  const x = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(aLo, bLo);
  const y = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(aHi, bLo), _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(x, 32));
  const z = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(aLo, bHi), _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin6BitAnd4land(y, $4294967295L));
  const w = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(aHi, bHi), _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(y, 32)), _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(z, 32));
  return { hi: w, lo: _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mul3mul(a, b) };
}
function _M0MP311moonbitlang4core6random4Rand14uint64_2einner(self, limit) {
  if (_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin2Eq5equal(limit, $0L)) {
    const _p = self;
    return _p.method_table.method_0(_p.self);
  } else {
    if (_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin2Eq5equal(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin6BitAnd4land(limit, _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Sub3sub(limit, $1L)), $0L)) {
      const _p = self;
      return _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin6BitAnd4land(_p.method_table.method_0(_p.self), _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Sub3sub(limit, $1L));
    }
  }
  const _p = self;
  let r = _M0FP311moonbitlang4core6random7umul128(_p.method_table.method_0(_p.self), limit);
  if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGmE(r.lo, limit)) {
    const thresh = _M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Mod3mod(_M0MP311moonbitlang4core6uint646UInt644lnot(limit), limit);
    while (true) {
      if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGmE(r.lo, thresh)) {
        const _p$2 = self;
        r = _M0FP311moonbitlang4core6random7umul128(_p$2.method_table.method_0(_p$2.self), limit);
        continue;
      } else {
        break;
      }
    }
  }
  return r.hi;
}
function _M0MP311moonbitlang4core6random4Rand12uint_2einner(self, limit) {
  if (limit === 0) {
    const _p = self;
    return _M0MP311moonbitlang4core6uint646UInt648to__uint(_p.method_table.method_0(_p.self));
  }
  return _M0MP311moonbitlang4core6uint646UInt648to__uint(_M0MP311moonbitlang4core6random4Rand14uint64_2einner(self, _M0MP311moonbitlang4core4uint4UInt10to__uint64(limit)));
}
function _M0MP311moonbitlang4core6random4Rand11int_2einner(self, limit) {
  if (limit === 0) {
    const _p = self;
    return _M0MP311moonbitlang4core6uint646UInt647to__int(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(_p.method_table.method_0(_p.self), 33));
  } else {
    return _M0MP311moonbitlang4core6random4Rand12uint_2einner(self, limit);
  }
}
function _M0MP311moonbitlang4core6random4Rand6double(self) {
  const _p = self;
  return _M0MP311moonbitlang4core6double6Double15convert__uint64(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shr3shr(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shl3shl(_p.method_table.method_0(_p.self), 11), 11)) / _M0MP311moonbitlang4core6double6Double15convert__uint64(_M0IP311moonbitlang4core6uint646UInt64P311moonbitlang4core7builtin3Shl3shl($1L, 53));
}
function _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6entity6EntityE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6inputs4CodeE(capacity) {
  const capacity$2 = _M0MP311moonbitlang4core3int3Int20next__power__of__two(capacity);
  const _bind$8 = capacity$2 - 1 | 0;
  const _bind$9 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$10 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$11 = undefined;
  return { entries: _bind$10, size: 0, capacity: capacity$2, capacity_mask: _bind$8, grow_at: _bind$9, head: _bind$11, tail: -1 };
}
function _M0MP311moonbitlang4core3set3Set20add__entry__to__tailGRP39Milky20186selene6entity6EntityE(self, idx, entry) {
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
function _M0MP311moonbitlang4core3set3Set20add__entry__to__tailGRP39Milky20186selene6inputs4CodeE(self, idx, entry) {
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
function _M0MP311moonbitlang4core3set3Set10set__entryGRP39Milky20186selene6entity6EntityE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core3set3Set10set__entryGRP39Milky20186selene6inputs4CodeE(self, entry, new_idx) {
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
function _M0MP311moonbitlang4core3set3Set10push__awayGRP39Milky20186selene6entity6EntityE(self, idx, entry) {
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
      _M0MP311moonbitlang4core3set3Set10set__entryGRP39Milky20186selene6entity6EntityE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core3set3Set10set__entryGRP39Milky20186selene6entity6EntityE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core3set3Set10push__awayGRP39Milky20186selene6inputs4CodeE(self, idx, entry) {
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
      _M0MP311moonbitlang4core3set3Set10set__entryGRP39Milky20186selene6inputs4CodeE(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$8;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MP311moonbitlang4core3set3Set10set__entryGRP39Milky20186selene6inputs4CodeE(self, entry$2, idx$2);
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
function _M0MP311moonbitlang4core3set3Set15add__with__hashGRP39Milky20186selene6entity6EntityE(self, key, hash) {
  if (self.size >= self.grow_at) {
    _M0MP311moonbitlang4core3set3Set4growGRP39Milky20186selene6entity6EntityE(self);
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
        _M0MP311moonbitlang4core3set3Set10push__awayGRP39Milky20186selene6entity6EntityE(self, idx, _curr_entry);
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
  _M0MP311moonbitlang4core3set3Set20add__entry__to__tailGRP39Milky20186selene6entity6EntityE(self, _idx, entry);
}
function _M0MP311moonbitlang4core3set3Set15add__with__hashGRP39Milky20186selene6inputs4CodeE(self, key, hash) {
  if (self.size >= self.grow_at) {
    _M0MP311moonbitlang4core3set3Set4growGRP39Milky20186selene6inputs4CodeE(self);
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
      if (_curr_entry.hash === hash && _M0IP39Milky20186selene6inputs4CodeP311moonbitlang4core7builtin2Eq5equal(_curr_entry.key, key)) {
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        _M0MP311moonbitlang4core3set3Set10push__awayGRP39Milky20186selene6inputs4CodeE(self, idx, _curr_entry);
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
  _M0MP311moonbitlang4core3set3Set20add__entry__to__tailGRP39Milky20186selene6inputs4CodeE(self, _idx, entry);
}
function _M0MP311moonbitlang4core3set3Set4growGRP39Milky20186selene6entity6EntityE(self) {
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
      _M0MP311moonbitlang4core3set3Set15add__with__hashGRP39Milky20186selene6entity6EntityE(self, _key, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core3set3Set4growGRP39Milky20186selene6inputs4CodeE(self) {
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
      _M0MP311moonbitlang4core3set3Set15add__with__hashGRP39Milky20186selene6inputs4CodeE(self, _key, _hash);
      _tmp = _next;
      continue;
    }
  }
}
function _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6entity6EntityE(self, key) {
  _M0MP311moonbitlang4core3set3Set15add__with__hashGRP39Milky20186selene6entity6EntityE(self, key, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key));
}
function _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6inputs4CodeE(self, key) {
  _M0MP311moonbitlang4core3set3Set15add__with__hashGRP39Milky20186selene6inputs4CodeE(self, key, _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6inputs4CodeE(key));
}
function _M0MP311moonbitlang4core3set3Set11from__arrayGRP39Milky20186selene6inputs4CodeE(arr) {
  const length = arr.end - arr.start | 0;
  let capacity = _M0MP311moonbitlang4core3int3Int20next__power__of__two(length);
  const _p = capacity;
  if (length > ((Math.imul(_p, 13) | 0) / 16 | 0)) {
    capacity = Math.imul(capacity, 2) | 0;
  }
  const m = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6inputs4CodeE(capacity);
  const _len = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const e = arr.buf[arr.start + _i | 0];
      _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6inputs4CodeE(m, e);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MP311moonbitlang4core3set3Set8containsGRP39Milky20186selene6entity6EntityE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
function _M0MP311moonbitlang4core3set3Set8containsGRP39Milky20186selene6inputs4CodeE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6inputs4CodeE(key);
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
      if (_entry.hash === hash && _M0IP39Milky20186selene6inputs4CodeP311moonbitlang4core7builtin2Eq5equal(_entry.key, key)) {
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
function _M0MP311moonbitlang4core3set3Set13remove__entryGRP39Milky20186selene6inputs4CodeE(self, entry) {
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
    _tmp$2.next = entry.next;
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
function _M0MP311moonbitlang4core3set3Set13remove__entryGRP39Milky20186selene6entity6EntityE(self, entry) {
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
    _tmp$2.next = entry.next;
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
function _M0MP311moonbitlang4core3set3Set11shift__backGRP39Milky20186selene6inputs4CodeE(self, idx) {
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
          _M0MP311moonbitlang4core3set3Set10set__entryGRP39Milky20186selene6inputs4CodeE(self, _x, idx$2);
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
function _M0MP311moonbitlang4core3set3Set11shift__backGRP39Milky20186selene6entity6EntityE(self, idx) {
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
          _M0MP311moonbitlang4core3set3Set10set__entryGRP39Milky20186selene6entity6EntityE(self, _x, idx$2);
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
function _M0MP311moonbitlang4core3set3Set6removeGRP39Milky20186selene6inputs4CodeE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6inputs4CodeE(key);
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
      if (_entry.hash === hash && _M0IP39Milky20186selene6inputs4CodeP311moonbitlang4core7builtin2Eq5equal(_entry.key, key)) {
        _M0MP311moonbitlang4core3set3Set13remove__entryGRP39Milky20186selene6inputs4CodeE(self, _entry);
        _M0MP311moonbitlang4core3set3Set11shift__backGRP39Milky20186selene6inputs4CodeE(self, idx);
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
function _M0MP311moonbitlang4core3set3Set6removeGRP39Milky20186selene6entity6EntityE(self, key) {
  const hash = _M0IP016_24default__implP311moonbitlang4core7builtin4Hash4hashGRP39Milky20186selene6entity6EntityE(key);
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
        _M0MP311moonbitlang4core3set3Set13remove__entryGRP39Milky20186selene6entity6EntityE(self, _entry);
        _M0MP311moonbitlang4core3set3Set11shift__backGRP39Milky20186selene6entity6EntityE(self, idx);
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
function _M0MP311moonbitlang4core3set3Set5clearGRP39Milky20186selene6inputs4CodeE(self) {
  _M0MP311moonbitlang4core5array10FixedArray12fill_2einnerGORP311moonbitlang4core3set5EntryGRP39Milky20186selene6inputs4CodeEE(self.entries, undefined, 0, undefined);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
}
function _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6inputs4CodeE(self) {
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
function _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6entity6EntityE(self) {
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
function _M0MP311moonbitlang4core3set3Set10differenceGRP39Milky20186selene6inputs4CodeE(self, other) {
  const m = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6inputs4CodeE(8);
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
      if (!_M0MP311moonbitlang4core3set3Set8containsGRP39Milky20186selene6inputs4CodeE(other, _p$4)) {
        _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6inputs4CodeE(m, _p$4);
      }
      _tmp = _p$5;
      continue;
    }
  }
  return m;
}
function _M0MP311moonbitlang4core3set3Set5unionGRP39Milky20186selene6inputs4CodeE(self, other) {
  const m = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6inputs4CodeE(8);
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
      _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6inputs4CodeE(m, _p$4);
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
      _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6inputs4CodeE(m, _p$4);
      _tmp$2 = _p$5;
      continue;
    }
  }
  return m;
}
function _M0MP311moonbitlang4core3set3Set5unionGRP39Milky20186selene6entity6EntityE(self, other) {
  const m = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6entity6EntityE(8);
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
      _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6entity6EntityE(m, _p$4);
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
      _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6entity6EntityE(m, _p$4);
      _tmp$2 = _p$5;
      continue;
    }
  }
  return m;
}
function _M0IP39Milky20186selene4math5Vec2DP311moonbitlang4core7builtin7Default7default() {
  return { _0: 0, _1: 0 };
}
function _M0MP39Milky20186selene4math5Vec2D7op__get(this_, axis) {
  if (axis === 0) {
    return this_._0;
  } else {
    return this_._1;
  }
}
function _M0MP39Milky20186selene4math5Vec2D6update(this_, axis, value) {
  if (axis === 0) {
    return { _0: value, _1: this_._1 };
  } else {
    return { _0: this_._0, _1: value };
  }
}
function _M0MP39Milky20186selene4math5Vec2D12distance__to(this_, other) {
  return Math.sqrt((this_._0 - other._0) * (this_._0 - other._0) + (this_._1 - other._1) * (this_._1 - other._1));
}
function _M0MP39Milky20186selene4math5Vec2D9normalize(this_) {
  const mag = Math.sqrt(this_._0 * this_._0 + this_._1 * this_._1);
  return mag > 0 ? { _0: this_._0 / mag, _1: this_._1 / mag } : { _0: 0, _1: 0 };
}
function _M0MP39Milky20186selene4math9Transform11new_2einner(a, b, c, d, tx, ty) {
  return { a: a, b: b, c: c, d: d, tx: tx, ty: ty };
}
function _M0MP39Milky20186selene4math9Transform17from__translation(tx, ty) {
  return { a: 1, b: 0, c: 0, d: 1, tx: tx, ty: ty };
}
function _M0MP39Milky20186selene4math9Transform11from__scale(sx, sy) {
  return { a: sx, b: 0, c: 0, d: sy, tx: 0, ty: 0 };
}
function _M0MP39Milky20186selene4math9Transform8multiply(self, other) {
  return { a: self.a * other.a + self.c * other.b, b: self.b * other.a + self.d * other.b, c: self.a * other.c + self.c * other.d, d: self.b * other.c + self.d * other.d, tx: self.a * other.tx + self.c * other.ty + self.tx, ty: self.b * other.tx + self.d * other.ty + self.ty };
}
function _M0MP39Milky20186selene4math9Transform16apply__to__point(self, x, y) {
  const new_x = self.a * x + self.c * y + self.tx;
  const new_y = self.b * x + self.d * y + self.ty;
  return { _0: new_x, _1: new_y };
}
function _M0MP39Milky20186selene4math9Transform16apply__to__vec2d(self, vec) {
  const p = _M0MP39Milky20186selene4math9Transform16apply__to__point(self, vec._0, vec._1);
  return { _0: p._0, _1: p._1 };
}
function _M0MP39Milky20186selene4math9Transform7flip__x(width) {
  return _M0IP39Milky20186selene4math9TransformP311moonbitlang4core7builtin3Mul3mul(_M0MP39Milky20186selene4math9Transform17from__translation(width, 0), _M0MP39Milky20186selene4math9Transform11from__scale(-1, 1));
}
function _M0IP39Milky20186selene4math9TransformP311moonbitlang4core7builtin3Mul3mul(self, other) {
  return _M0MP39Milky20186selene4math9Transform8multiply(self, other);
}
function _M0MP39Milky20186selene4math4Rect10intersects(a, b) {
  return _M0MP39Milky20186selene4math5Vec2D7op__get(a.position, 0) < _M0MP39Milky20186selene4math5Vec2D7op__get(b.position, 0) + _M0MP39Milky20186selene4math5Vec2D7op__get(b.size, 0) && (_M0MP39Milky20186selene4math5Vec2D7op__get(a.position, 0) + _M0MP39Milky20186selene4math5Vec2D7op__get(a.size, 0) > _M0MP39Milky20186selene4math5Vec2D7op__get(b.position, 0) && (_M0MP39Milky20186selene4math5Vec2D7op__get(a.position, 1) < _M0MP39Milky20186selene4math5Vec2D7op__get(b.position, 1) + _M0MP39Milky20186selene4math5Vec2D7op__get(b.size, 1) && _M0MP39Milky20186selene4math5Vec2D7op__get(a.position, 1) + _M0MP39Milky20186selene4math5Vec2D7op__get(a.size, 1) > _M0MP39Milky20186selene4math5Vec2D7op__get(b.position, 1)));
}
function _M0MP39Milky20186selene4math4Rect5shift(self, dir) {
  const _p = self.position;
  return { position: { _0: _p._0 + dir._0, _1: _p._1 + dir._1 }, size: self.size };
}
function _M0IP39Milky20186selene6inputs4CodeP311moonbitlang4core7builtin2Eq5equal(_x_29, _x_30) {
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
function _M0IP39Milky20186selene6inputs4CodeP311moonbitlang4core7builtin4Hash13hash__combine(_x_21, _x_22) {
  switch (_x_21) {
    case 0: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 0);
      return;
    }
    case 1: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 1);
      return;
    }
    case 2: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 2);
      return;
    }
    case 3: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 3);
      return;
    }
    case 4: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 4);
      return;
    }
    case 5: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 5);
      return;
    }
    case 6: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 6);
      return;
    }
    case 7: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 7);
      return;
    }
    case 8: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 8);
      return;
    }
    case 9: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 9);
      return;
    }
    case 10: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 10);
      return;
    }
    case 11: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 11);
      return;
    }
    case 12: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 12);
      return;
    }
    case 13: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 13);
      return;
    }
    case 14: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 14);
      return;
    }
    case 15: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 15);
      return;
    }
    case 16: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 16);
      return;
    }
    case 17: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 17);
      return;
    }
    case 18: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 18);
      return;
    }
    case 19: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 19);
      return;
    }
    case 20: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 20);
      return;
    }
    case 21: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 21);
      return;
    }
    case 22: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 22);
      return;
    }
    case 23: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 23);
      return;
    }
    case 24: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 24);
      return;
    }
    case 25: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 25);
      return;
    }
    case 26: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 26);
      return;
    }
    case 27: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 27);
      return;
    }
    case 28: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 28);
      return;
    }
    case 29: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 29);
      return;
    }
    case 30: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 30);
      return;
    }
    case 31: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 31);
      return;
    }
    default: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_22, 32);
      return;
    }
  }
}
function _M0FP39Milky20186selene6inputs23advanced__mouse__system(_delta) {
  _M0FP39Milky20186selene6inputs20just__pressed__mouse.left_button = _M0FP39Milky20186selene6inputs5mouse.left_button && !_M0FP39Milky20186selene6inputs11last__mouse.left_button;
  _M0FP39Milky20186selene6inputs20just__pressed__mouse.right_button = _M0FP39Milky20186selene6inputs5mouse.right_button && !_M0FP39Milky20186selene6inputs11last__mouse.right_button;
  _M0FP39Milky20186selene6inputs20just__pressed__mouse.middle_button = _M0FP39Milky20186selene6inputs5mouse.middle_button && !_M0FP39Milky20186selene6inputs11last__mouse.middle_button;
  _M0FP39Milky20186selene6inputs20just__release__mouse.left_button = !_M0FP39Milky20186selene6inputs5mouse.left_button && _M0FP39Milky20186selene6inputs11last__mouse.left_button;
  _M0FP39Milky20186selene6inputs20just__release__mouse.right_button = !_M0FP39Milky20186selene6inputs5mouse.right_button && _M0FP39Milky20186selene6inputs11last__mouse.right_button;
  _M0FP39Milky20186selene6inputs20just__release__mouse.middle_button = !_M0FP39Milky20186selene6inputs5mouse.middle_button && _M0FP39Milky20186selene6inputs11last__mouse.middle_button;
  _M0FP39Milky20186selene6inputs11last__mouse.pos = _M0FP39Milky20186selene6inputs5mouse.pos;
  _M0FP39Milky20186selene6inputs11last__mouse.left_button = _M0FP39Milky20186selene6inputs5mouse.left_button;
  _M0FP39Milky20186selene6inputs11last__mouse.right_button = _M0FP39Milky20186selene6inputs5mouse.right_button;
  _M0FP39Milky20186selene6inputs11last__mouse.middle_button = _M0FP39Milky20186selene6inputs5mouse.middle_button;
}
function _M0FP39Milky20186selene6inputs18is__mouse__pressed(button) {
  switch (button) {
    case 0: {
      return _M0FP39Milky20186selene6inputs5mouse.left_button;
    }
    case 1: {
      return _M0FP39Milky20186selene6inputs5mouse.right_button;
    }
    default: {
      return _M0FP39Milky20186selene6inputs5mouse.middle_button;
    }
  }
}
function _M0FP39Milky20186selene6inputs19is__mouse__released(button) {
  switch (button) {
    case 0: {
      return !_M0FP39Milky20186selene6inputs5mouse.left_button;
    }
    case 1: {
      return !_M0FP39Milky20186selene6inputs5mouse.right_button;
    }
    default: {
      return !_M0FP39Milky20186selene6inputs5mouse.middle_button;
    }
  }
}
function _M0FP39Milky20186selene6inputs24is__mouse__just__pressed(button) {
  switch (button) {
    case 0: {
      return _M0FP39Milky20186selene6inputs20just__pressed__mouse.left_button;
    }
    case 1: {
      return _M0FP39Milky20186selene6inputs20just__pressed__mouse.right_button;
    }
    default: {
      return _M0FP39Milky20186selene6inputs20just__pressed__mouse.middle_button;
    }
  }
}
function _M0FP39Milky20186selene6inputs25is__mouse__just__released(button) {
  switch (button) {
    case 0: {
      return _M0FP39Milky20186selene6inputs20just__release__mouse.left_button;
    }
    case 1: {
      return _M0FP39Milky20186selene6inputs20just__release__mouse.right_button;
    }
    default: {
      return _M0FP39Milky20186selene6inputs20just__release__mouse.middle_button;
    }
  }
}
function _M0MP39Milky20186selene6inputs4Code12from__string(code) {
  switch (code) {
    case "KeyA": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3443;
    }
    case "KeyB": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3444;
    }
    case "KeyC": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3445;
    }
    case "KeyD": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3446;
    }
    case "KeyE": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3447;
    }
    case "KeyF": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3448;
    }
    case "KeyG": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3449;
    }
    case "KeyH": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3450;
    }
    case "KeyI": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3451;
    }
    case "KeyJ": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3452;
    }
    case "KeyK": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3453;
    }
    case "KeyL": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3454;
    }
    case "KeyM": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3455;
    }
    case "KeyN": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3456;
    }
    case "KeyO": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3457;
    }
    case "KeyP": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3458;
    }
    case "KeyQ": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3459;
    }
    case "KeyR": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3460;
    }
    case "KeyS": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3461;
    }
    case "KeyT": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3462;
    }
    case "KeyU": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3463;
    }
    case "KeyV": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3464;
    }
    case "KeyW": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3465;
    }
    case "KeyX": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3466;
    }
    case "KeyY": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3467;
    }
    case "ArrowUp": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3468;
    }
    case "ArrowDown": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3469;
    }
    case "ArrowLeft": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3470;
    }
    case "ArrowRight": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3471;
    }
    case "Space": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3472;
    }
    case "Enter": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3473;
    }
    case "Escape": {
      return _M0FP39Milky20186selene6inputs28from__string_2econstr_2f3474;
    }
    default: {
      return undefined;
    }
  }
}
function _M0FP39Milky20186selene6inputs11is__pressed(code) {
  return _M0MP311moonbitlang4core3set3Set8containsGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs13pressed__keys, code);
}
function _M0FP39Milky20186selene6inputs11key__vector(up, down, left, right) {
  const x = _M0FP39Milky20186selene6inputs11is__pressed(left) ? -1 : _M0FP39Milky20186selene6inputs11is__pressed(right) ? 1 : 0;
  const y = _M0FP39Milky20186selene6inputs11is__pressed(up) ? -1 : _M0FP39Milky20186selene6inputs11is__pressed(down) ? 1 : 0;
  return { _0: x, _1: y };
}
function _M0FP39Milky20186selene6inputs21advanced__key__system(_delta) {
  _M0MP311moonbitlang4core3set3Set5clearGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs19just__pressed__keys);
  const _it = _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6inputs4CodeE(_M0MP311moonbitlang4core3set3Set10differenceGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs13pressed__keys, _M0FP39Milky20186selene6inputs19last__pressed__keys));
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6inputs4CodeE(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _code = _Some;
      _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs19just__pressed__keys, _code);
      continue;
    }
  }
  _M0MP311moonbitlang4core3set3Set5clearGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs19just__release__keys);
  const _it$2 = _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6inputs4CodeE(_M0MP311moonbitlang4core3set3Set5unionGRP39Milky20186selene6inputs4CodeE(_M0MP311moonbitlang4core3set3Set10differenceGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs10all__codes, _M0FP39Milky20186selene6inputs13pressed__keys), _M0FP39Milky20186selene6inputs19last__pressed__keys));
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6inputs4CodeE(_it$2);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _code = _Some;
      _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs19just__release__keys, _code);
      continue;
    }
  }
  _M0MP311moonbitlang4core3set3Set5clearGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs19last__pressed__keys);
  const _it$3 = _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs13pressed__keys);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6inputs4CodeE(_it$3);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _code = _Some;
      _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6inputs4CodeE(_M0FP39Milky20186selene6inputs19last__pressed__keys, _code);
      continue;
    }
  }
}
function _M0MP36rami3l8js_2dffi2js6Union35from0GsRP37Yoorkin12rabbit_2dtea3dom14CanvasGradientRP37Yoorkin12rabbit_2dtea3dom13CanvasPatternE(value) {
  return value;
}
function _M0MP36rami3l8js_2dffi2js6Union35from2GsRP37Yoorkin12rabbit_2dtea3dom14CanvasGradientRP37Yoorkin12rabbit_2dtea3dom13CanvasPatternE(value) {
  return value;
}
function _M0MP36rami3l8js_2dffi2js6Union53to0GRP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2DRP37Yoorkin12rabbit_2dtea3dom27ImageBitmapRenderingContextRP37Yoorkin12rabbit_2dtea3dom21WebGLRenderingContextRP37Yoorkin12rabbit_2dtea3dom22WebGL2RenderingContextRP37Yoorkin12rabbit_2dtea3dom16GPUCanvasContextE(self) {
  return _M0IP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2DP36rami3l8js_2dffi2js4Cast4into(self);
}
function _M0MP36rami3l8js_2dffi2js6Union75from0GRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementRP37Yoorkin12rabbit_2dtea3dom15SVGImageElementRP37Yoorkin12rabbit_2dtea3dom16HTMLVideoElementRP37Yoorkin12rabbit_2dtea3dom17HTMLCanvasElementRP37Yoorkin12rabbit_2dtea3dom11ImageBitmapRP37Yoorkin12rabbit_2dtea3dom15OffscreenCanvasRP37Yoorkin12rabbit_2dtea3dom10VideoFrameE(value) {
  return _M0IP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementP36rami3l8js_2dffi2js4Cast4from(value);
}
function _M0MP36rami3l8js_2dffi2js8Optional9undefinedGdE() {
  return _M0MP36rami3l8js_2dffi2js5Value9undefined();
}
function _M0MP36rami3l8js_2dffi2js8Nullable8is__nullGRP37Yoorkin12rabbit_2dtea3dom7ElementE(self) {
  return _M0MP36rami3l8js_2dffi2js5Value8is__null(self);
}
function _M0MP36rami3l8js_2dffi2js8Nullable6unwrapGRP37Yoorkin12rabbit_2dtea3dom7ElementE(self) {
  if (_M0MP36rami3l8js_2dffi2js8Nullable8is__nullGRP37Yoorkin12rabbit_2dtea3dom7ElementE(self)) {
    _M0FP311moonbitlang4core7builtin5abortGuE("Cannot unwrap a null value", "@rami3l/js-ffi/js:null.mbt:17:5-17:40");
  }
  return self;
}
function _M0MP36rami3l8js_2dffi2js8Nullable10to__optionGRP37Yoorkin12rabbit_2dtea3dom17HTMLCanvasElementE(self) {
  return !_M0MP36rami3l8js_2dffi2js5Value8is__null(self) ? new Option$Some$16$(self) : Option$None$16$;
}
function _M0MP36rami3l8js_2dffi2js8Nullable10to__optionGRP37Yoorkin12rabbit_2dtea3dom13KeyboardEventE(self) {
  return !_M0MP36rami3l8js_2dffi2js5Value8is__null(self) ? new Option$Some$17$(self) : Option$None$17$;
}
function _M0MP36rami3l8js_2dffi2js8Nullable10to__optionGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(self) {
  return !_M0MP36rami3l8js_2dffi2js5Value8is__null(self) ? new Option$Some$18$(self) : Option$None$18$;
}
function _M0MP36rami3l8js_2dffi2js8Nullable10to__optionGRP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2DE(self) {
  return !_M0MP36rami3l8js_2dffi2js5Value8is__null(self) ? new Option$Some$19$(self) : Option$None$19$;
}
function _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent11get__buttonGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(s) {
  return _M0FP37Yoorkin12rabbit_2dtea3dom25ffi__mouse__event__button(s);
}
function _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent16get__movement__xGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(s) {
  return _M0FP37Yoorkin12rabbit_2dtea3dom30ffi__mouse__event__movement__x(s);
}
function _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent16get__movement__yGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(s) {
  return _M0FP37Yoorkin12rabbit_2dtea3dom30ffi__mouse__event__movement__y(s);
}
function _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent14get__offset__xGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(s) {
  return _M0FP37Yoorkin12rabbit_2dtea3dom28ffi__mouse__event__offset__x(s);
}
function _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent14get__offset__yGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(s) {
  return _M0FP37Yoorkin12rabbit_2dtea3dom28ffi__mouse__event__offset__y(s);
}
function _M0IP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementP36rami3l8js_2dffi2js4Cast4from(value) {
  return value;
}
function _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom13IsEventTarget20add__event__listenerGRP37Yoorkin12rabbit_2dtea3dom6WindowE(s, type_, callback) {
  _M0FP37Yoorkin12rabbit_2dtea3dom25ffi__add__event__listener(s, type_, callback);
}
function _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom13IsEventTarget25to__html__canvas__elementGRP37Yoorkin12rabbit_2dtea3dom7ElementE(s) {
  return _M0MP36rami3l8js_2dffi2js8Nullable10to__optionGRP37Yoorkin12rabbit_2dtea3dom17HTMLCanvasElementE(_M0FP37Yoorkin12rabbit_2dtea3dom30ffi__to__html__canvas__element(s));
}
function _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom7IsEvent16to__mouse__eventGRP37Yoorkin12rabbit_2dtea3dom5EventE(s) {
  return _M0MP36rami3l8js_2dffi2js8Nullable10to__optionGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(_M0FP37Yoorkin12rabbit_2dtea3dom21ffi__to__mouse__event(s));
}
function _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom7IsEvent19to__keyboard__eventGRP37Yoorkin12rabbit_2dtea3dom5EventE(s) {
  return _M0MP36rami3l8js_2dffi2js8Nullable10to__optionGRP37Yoorkin12rabbit_2dtea3dom13KeyboardEventE(_M0FP37Yoorkin12rabbit_2dtea3dom24ffi__to__keyboard__event(s));
}
function _M0IP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2DP36rami3l8js_2dffi2js4Cast4into(value) {
  return _M0MP36rami3l8js_2dffi2js8Nullable10to__optionGRP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2DE(_M0FP37Yoorkin12rabbit_2dtea3dom43checked__to__canvas__rendering__context__2d(value));
}
function _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D10fill__text(self, text, x, y, max_width$46$opt) {
  let max_width;
  if (max_width$46$opt.$tag === 1) {
    const _Some = max_width$46$opt;
    max_width = _Some._0;
  } else {
    max_width = _M0MP36rami3l8js_2dffi2js8Optional9undefinedGdE();
  }
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D18fill__text_2einner(self, text, x, y, max_width);
}
function _M0MP39Milky20186selene7backend13CanvasBackend3new() {
  const canvas = _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom17HTMLCanvasElementE(_M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom13IsEventTarget25to__html__canvas__elementGRP37Yoorkin12rabbit_2dtea3dom7ElementE(_M0MP36rami3l8js_2dffi2js8Nullable6unwrapGRP37Yoorkin12rabbit_2dtea3dom7ElementE(_M0MP37Yoorkin12rabbit_2dtea3dom8Document20get__element__by__id(_M0FP37Yoorkin12rabbit_2dtea3dom8document(), "canvas"))));
  const context = _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2DE(_M0MP36rami3l8js_2dffi2js6Union53to0GRP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2DRP37Yoorkin12rabbit_2dtea3dom27ImageBitmapRenderingContextRP37Yoorkin12rabbit_2dtea3dom21WebGLRenderingContextRP37Yoorkin12rabbit_2dtea3dom22WebGL2RenderingContextRP37Yoorkin12rabbit_2dtea3dom16GPUCanvasContextE(_M0MP37Yoorkin12rabbit_2dtea3dom17HTMLCanvasElement12get__context(canvas, "2d")));
  const _bind$8 = { _0: 0, _1: 0 };
  const _bind$9 = _M0MP311moonbitlang4core3ref3Ref3newGORP39Milky20186selene6inputs13MouseMovementE(undefined);
  return { canvas: canvas, context: context, viewport_size: _bind$8, zoom: 1, time_scale: 1, mouse_movement: _bind$9 };
}
function _M0FP39Milky20186selene7backend23register__mouse__events(mouse, mouse_movement) {
  _M0FP39Milky20186selene7backend15canvas__backend.mouse_movement.val = mouse_movement;
  _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom13IsEventTarget20add__event__listenerGRP37Yoorkin12rabbit_2dtea3dom6WindowE(_M0FP39Milky20186selene7backend6window, "mousemove", (event) => {
    const mouse_event = _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(_M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom7IsEvent16to__mouse__eventGRP37Yoorkin12rabbit_2dtea3dom5EventE(event));
    mouse.pos = { _0: _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent14get__offset__xGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(mouse_event) + 0, _1: _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent14get__offset__yGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(mouse_event) + 0 };
    mouse_movement.movement = { _0: _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent16get__movement__xGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(mouse_event) + 0, _1: _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent16get__movement__yGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(mouse_event) + 0 };
  });
  _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom13IsEventTarget20add__event__listenerGRP37Yoorkin12rabbit_2dtea3dom6WindowE(_M0FP39Milky20186selene7backend6window, "mousedown", (event) => {
    const mouse_event = _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(_M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom7IsEvent16to__mouse__eventGRP37Yoorkin12rabbit_2dtea3dom5EventE(event));
    const _bind$8 = _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent11get__buttonGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(mouse_event);
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
  _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom13IsEventTarget20add__event__listenerGRP37Yoorkin12rabbit_2dtea3dom6WindowE(_M0FP39Milky20186selene7backend6window, "mouseup", (event) => {
    const mouse_event = _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(_M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom7IsEvent16to__mouse__eventGRP37Yoorkin12rabbit_2dtea3dom5EventE(event));
    const _bind$8 = _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom12IsMouseEvent11get__buttonGRP37Yoorkin12rabbit_2dtea3dom10MouseEventE(mouse_event);
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
function _M0FP39Milky20186selene7backend21register__key__events(pressed_keys) {
  _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom13IsEventTarget20add__event__listenerGRP37Yoorkin12rabbit_2dtea3dom6WindowE(_M0FP39Milky20186selene7backend6window, "keyup", (event) => {
    const keyboard_event = _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom13KeyboardEventE(_M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom7IsEvent19to__keyboard__eventGRP37Yoorkin12rabbit_2dtea3dom5EventE(event));
    const keycode = _M0MP39Milky20186selene6inputs4Code12from__string(_M0MP37Yoorkin12rabbit_2dtea3dom13KeyboardEvent4code(keyboard_event));
    if (keycode === undefined) {
      return;
    } else {
      const _Some = keycode;
      const _c = _Some;
      _M0MP311moonbitlang4core3set3Set6removeGRP39Milky20186selene6inputs4CodeE(pressed_keys, _c);
      return;
    }
  });
  _M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom13IsEventTarget20add__event__listenerGRP37Yoorkin12rabbit_2dtea3dom6WindowE(_M0FP39Milky20186selene7backend6window, "keydown", (event) => {
    const keyboard_event = _M0MP311moonbitlang4core6option6Option6unwrapGRP37Yoorkin12rabbit_2dtea3dom13KeyboardEventE(_M0IP016_24default__implP37Yoorkin12rabbit_2dtea3dom7IsEvent19to__keyboard__eventGRP37Yoorkin12rabbit_2dtea3dom5EventE(event));
    const keycode = _M0MP39Milky20186selene6inputs4Code12from__string(_M0MP37Yoorkin12rabbit_2dtea3dom13KeyboardEvent4code(keyboard_event));
    if (keycode === undefined) {
      return;
    } else {
      const _Some = keycode;
      const _c = _Some;
      _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6inputs4CodeE(pressed_keys, _c);
      return;
    }
  });
}
function _M0FP39Milky20186selene7backend19get__image__element(png) {
  const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(_M0FP39Milky20186selene7backend14element__cache, png);
  if (_bind$8.$tag === 1) {
    const _Some = _bind$8;
    const _element = _Some._0;
    return _element;
  }
  const element = _M0MP37Yoorkin12rabbit_2dtea3dom16HTMLImageElement3new();
  _M0MP37Yoorkin12rabbit_2dtea3dom16HTMLImageElement8set__src(element, png);
  _M0MP311moonbitlang4core7builtin3Map3setGsRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementE(_M0FP39Milky20186selene7backend14element__cache, png, element);
  return element;
}
function _M0FP39Milky20186selene7backend21repeat__mode__to__css(repeat) {
  switch (repeat) {
    case 2: {
      return "no-repeat";
    }
    case 1: {
      return "repeat-y";
    }
    case 0: {
      return "repeat-x";
    }
    default: {
      return "repeat";
    }
  }
}
function _M0FP39Milky20186selene7backend14color__to__css(color) {
  return `rgba(${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(color.r)}, ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(color.g)}, ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(color.b)}, ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGdE(color.a)})`;
}
function _M0FP39Milky20186selene7backend20text__align__to__css(align) {
  switch (align) {
    case 0: {
      return "left";
    }
    case 1: {
      return "center";
    }
    default: {
      return "right";
    }
  }
}
function _M0FP39Milky20186selene7backend23text__baseline__to__css(baseline) {
  switch (baseline) {
    case 0: {
      return "top";
    }
    case 1: {
      return "center";
    }
    default: {
      return "bottom";
    }
  }
}
function _M0FP39Milky20186selene7backend20text__style__to__css(style) {
  return `${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGdE(style.size)}px ${style.family}`;
}
function _M0FP39Milky20186selene7backend11draw__image(command) {
  const element = _M0FP39Milky20186selene7backend19get__image__element(command.path);
  const x = _M0MP39Milky20186selene4math5Vec2D7op__get(command.destination.position, 0);
  const y = _M0MP39Milky20186selene4math5Vec2D7op__get(command.destination.position, 1);
  const width = _M0MP39Milky20186selene4math5Vec2D7op__get(command.destination.size, 0);
  const height = _M0MP39Milky20186selene4math5Vec2D7op__get(command.destination.size, 1);
  const context = _M0FP39Milky20186selene7backend15canvas__backend.context;
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D4save(context);
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D9translate(context, x, y);
  const transform = command.transform;
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D9transform(context, transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
  const _bind$8 = command.source;
  if (_bind$8 === undefined) {
    const pattern = _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D15create__pattern(context, _M0MP36rami3l8js_2dffi2js6Union75from0GRP37Yoorkin12rabbit_2dtea3dom16HTMLImageElementRP37Yoorkin12rabbit_2dtea3dom15SVGImageElementRP37Yoorkin12rabbit_2dtea3dom16HTMLVideoElementRP37Yoorkin12rabbit_2dtea3dom17HTMLCanvasElementRP37Yoorkin12rabbit_2dtea3dom11ImageBitmapRP37Yoorkin12rabbit_2dtea3dom15OffscreenCanvasRP37Yoorkin12rabbit_2dtea3dom10VideoFrameE(element), _M0FP39Milky20186selene7backend21repeat__mode__to__css(command.repeat));
    _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D16set__fill__style(context, _M0MP36rami3l8js_2dffi2js6Union35from2GsRP37Yoorkin12rabbit_2dtea3dom14CanvasGradientRP37Yoorkin12rabbit_2dtea3dom13CanvasPatternE(pattern));
    _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D10fill__rect(context, 0, 0, width, height);
  } else {
    const _Some = _bind$8;
    const _source = _Some;
    _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D38draw__image__with__src__and__dst__size(context, element, _M0MP39Milky20186selene4math5Vec2D7op__get(_source.position, 0), _M0MP39Milky20186selene4math5Vec2D7op__get(_source.position, 1), _M0MP39Milky20186selene4math5Vec2D7op__get(_source.size, 0), _M0MP39Milky20186selene4math5Vec2D7op__get(_source.size, 1), 0, 0, width, height);
  }
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D7restore(context);
}
function _M0FP39Milky20186selene7backend10draw__text(command) {
  const context = _M0FP39Milky20186selene7backend15canvas__backend.context;
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D4save(context);
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D9set__font(context, _M0FP39Milky20186selene7backend20text__style__to__css(command.style));
  _M0FP39Milky20186selene7backend16set__text__align(context, _M0FP39Milky20186selene7backend20text__align__to__css(command.style.align));
  _M0FP39Milky20186selene7backend19set__text__baseline(context, _M0FP39Milky20186selene7backend23text__baseline__to__css(command.style.baseline));
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D16set__fill__style(context, _M0MP36rami3l8js_2dffi2js6Union35from0GsRP37Yoorkin12rabbit_2dtea3dom14CanvasGradientRP37Yoorkin12rabbit_2dtea3dom13CanvasPatternE(_M0FP39Milky20186selene7backend14color__to__css(command.style.color)));
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D10fill__text(context, command.text, _M0MP39Milky20186selene4math5Vec2D7op__get(command.position, 0), _M0MP39Milky20186selene4math5Vec2D7op__get(command.position, 1), Option$None$20$);
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D7restore(context);
}
function _M0FP39Milky20186selene7backend10draw__rect(command) {
  const x = _M0MP39Milky20186selene4math5Vec2D7op__get(command.rect.position, 0);
  const y = _M0MP39Milky20186selene4math5Vec2D7op__get(command.rect.position, 1);
  const width = _M0MP39Milky20186selene4math5Vec2D7op__get(command.rect.size, 0);
  const height = _M0MP39Milky20186selene4math5Vec2D7op__get(command.rect.size, 1);
  const context = _M0FP39Milky20186selene7backend15canvas__backend.context;
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D4save(context);
  const _bind$8 = command.stroke_color;
  if (_bind$8 === undefined) {
  } else {
    const _Some = _bind$8;
    const _stroke_color = _Some;
    _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D18set__stroke__style(context, _M0MP36rami3l8js_2dffi2js6Union35from0GsRP37Yoorkin12rabbit_2dtea3dom14CanvasGradientRP37Yoorkin12rabbit_2dtea3dom13CanvasPatternE(_M0FP39Milky20186selene7backend14color__to__css(_stroke_color)));
    _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D12stroke__rect(context, x, y, width, height);
  }
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D16set__fill__style(context, _M0MP36rami3l8js_2dffi2js6Union35from0GsRP37Yoorkin12rabbit_2dtea3dom14CanvasGradientRP37Yoorkin12rabbit_2dtea3dom13CanvasPatternE(_M0FP39Milky20186selene7backend14color__to__css(command.fill_color)));
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D10fill__rect(context, x, y, width, height);
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D7restore(context);
}
function _M0FP39Milky20186selene7backend12draw__circle(command) {
  const context = _M0FP39Milky20186selene7backend15canvas__backend.context;
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D4save(context);
  _M0FP39Milky20186selene7backend11begin__path(context);
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D11arc_2einner(context, _M0MP39Milky20186selene4math5Vec2D7op__get(command.center, 0), _M0MP39Milky20186selene4math5Vec2D7op__get(command.center, 1), command.radius, 0, 6.28318530717958623, false);
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D16set__fill__style(context, _M0MP36rami3l8js_2dffi2js6Union35from0GsRP37Yoorkin12rabbit_2dtea3dom14CanvasGradientRP37Yoorkin12rabbit_2dtea3dom13CanvasPatternE(_M0FP39Milky20186selene7backend14color__to__css(command.fill_color)));
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D12fill_2einner(context, "nonzero");
  const _bind$8 = command.stroke_color;
  if (_bind$8 === undefined) {
  } else {
    const _Some = _bind$8;
    const _stroke_color = _Some;
    _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D18set__stroke__style(context, _M0MP36rami3l8js_2dffi2js6Union35from0GsRP37Yoorkin12rabbit_2dtea3dom14CanvasGradientRP37Yoorkin12rabbit_2dtea3dom13CanvasPatternE(_M0FP39Milky20186selene7backend14color__to__css(_stroke_color)));
    _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D6stroke(context);
  }
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D7restore(context);
}
function _M0FP39Milky20186selene7backend16set__time__scale(time_scale) {
  _M0FP39Milky20186selene7backend15canvas__backend.time_scale = time_scale;
}
function _M0FP39Milky20186selene7backend31schedule__with__fixed__interval(interval, callback) {
  const lastTime = _M0MP311moonbitlang4core3ref3Ref3newGdE(0);
  const accumulator = _M0MP311moonbitlang4core3ref3Ref3newGdE(0);
  const lastId = _M0MP311moonbitlang4core3ref3Ref3newGdE(0);
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
    lastId.val = _M0MP37Yoorkin12rabbit_2dtea3dom6Window25request__animation__frame(_M0FP39Milky20186selene7backend6window, update);
  };
  lastId.val = _M0MP37Yoorkin12rabbit_2dtea3dom6Window25request__animation__frame(_M0FP39Milky20186selene7backend6window, update);
  return () => {
    if (lastId.val !== 0) {
      _M0MP37Yoorkin12rabbit_2dtea3dom6Window24cancel__animation__frame(_M0FP39Milky20186selene7backend6window, lastId.val);
      return;
    } else {
      return;
    }
  };
}
function _M0FP39Milky20186selene7backend10initialize(config) {
  const startup = config.startup;
  const render_loop = config.render_loop;
  const game_loop = config.game_loop;
  const canvas_width = config.canvas_width;
  const canvas_height = config.canvas_height;
  const fps = config.fps;
  const image_smooth = config.image_smooth;
  const zoom = config.zoom;
  if (fps >>> 0 > 60 >>> 0) {
    _M0FP311moonbitlang4core7builtin7printlnGsE("Warning: FPS is set above 60. The browser's window only support up to 60 FPS.");
  }
  _M0FP39Milky20186selene7backend15canvas__backend.viewport_size = { _0: canvas_width, _1: canvas_height };
  _M0FP39Milky20186selene7backend21set__viewport__height(_M0FP39Milky20186selene7backend15canvas__backend.canvas, canvas_height);
  _M0FP39Milky20186selene7backend20set__viewport__width(_M0FP39Milky20186selene7backend15canvas__backend.canvas, canvas_width);
  _M0FP39Milky20186selene7backend30set__image__smoothing__enabled(_M0FP39Milky20186selene7backend15canvas__backend.context, image_smooth);
  _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D5scale(_M0FP39Milky20186selene7backend15canvas__backend.context, zoom, zoom);
  _M0FP39Milky20186selene7backend15canvas__backend.zoom = zoom;
  startup();
  _M0FP39Milky20186selene7backend31schedule__with__fixed__interval(1000 / $f64_convert_i32_u(fps), (delta) => {
    const delta$2 = delta / 1000;
    _M0MP37Yoorkin12rabbit_2dtea3dom24CanvasRenderingContext2D11clear__rect(_M0FP39Milky20186selene7backend15canvas__backend.context, 0, 0, canvas_width, canvas_height);
    _M0FP39Milky20186selene7backend15realtime__delta.val = delta$2;
    render_loop(delta$2 * _M0FP39Milky20186selene7backend15canvas__backend.time_scale);
    game_loop(delta$2 * _M0FP39Milky20186selene7backend15canvas__backend.time_scale);
    const _bind$8 = _M0FP39Milky20186selene7backend15canvas__backend.mouse_movement.val;
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
function _M0FP39Milky20186selene7backend10load__font(font, path) {
  _M0FP39Milky20186selene7backend17load__font__async(font, path);
}
function _M0FP39Milky20186selene6system15timeout_2einner(time, callback, pausible) {
  _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene6system5TimerE(_M0FP39Milky20186selene6system6timers, { rest: time, pausible: pausible, callback: callback });
}
function _M0FP39Milky20186selene6system13timer__system(delta) {
  const _p = [];
  const _p$2 = _M0FP39Milky20186selene6system6timers.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = _M0FP39Milky20186selene6system6timers[_p$3];
      if (_p$4.pausible) {
        _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene6system5TimerE(_p, _p$4);
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
  const _p$3 = _M0FP39Milky20186selene6system6timers.length;
  let _tmp$3 = 0;
  let _tmp$4 = 0;
  while (true) {
    const _p$4 = _tmp$3;
    const _p$5 = _tmp$4;
    if (_p$4 < _p$3) {
      const _p$6 = _M0FP39Milky20186selene6system6timers[_p$4];
      if (_p$6.rest > 0) {
        _M0FP39Milky20186selene6system6timers[_p$5] = _p$6;
        _tmp$3 = _p$4 + 1 | 0;
        _tmp$4 = _p$5 + 1 | 0;
        continue;
      }
      _tmp$3 = _p$4 + 1 | 0;
      continue;
    } else {
      _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGRP39Milky20186selene6system5TimerE(_M0FP39Milky20186selene6system6timers, _p$5);
      return;
    }
  }
}
function _M0FP39Milky20186selene6system23realtime__timer__system(_delta) {
  const _p = [];
  const _p$2 = _M0FP39Milky20186selene6system6timers.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = _M0FP39Milky20186selene6system6timers[_p$3];
      if (!_p$4.pausible) {
        _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene6system5TimerE(_p, _p$4);
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
      const realtime_delta = _M0FP39Milky20186selene7backend15realtime__delta.val;
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
  const _p$3 = _M0FP39Milky20186selene6system6timers.length;
  let _tmp$3 = 0;
  let _tmp$4 = 0;
  while (true) {
    const _p$4 = _tmp$3;
    const _p$5 = _tmp$4;
    if (_p$4 < _p$3) {
      const _p$6 = _M0FP39Milky20186selene6system6timers[_p$4];
      if (_p$6.rest > 0) {
        _M0FP39Milky20186selene6system6timers[_p$5] = _p$6;
        _tmp$3 = _p$4 + 1 | 0;
        _tmp$4 = _p$5 + 1 | 0;
        continue;
      }
      _tmp$3 = _p$4 + 1 | 0;
      continue;
    } else {
      _M0MP311moonbitlang4core5array5Array28unsafe__truncate__to__lengthGRP39Milky20186selene6system5TimerE(_M0FP39Milky20186selene6system6timers, _p$5);
      return;
    }
  }
}
function _M0FP39Milky20186selene6system23deferred__event__system(_delta) {
  const _len = _M0FP39Milky20186selene6system16deferred__events.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const event = _M0FP39Milky20186selene6system16deferred__events[_i];
      event();
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP311moonbitlang4core5array5Array5clearGWEuE(_M0FP39Milky20186selene6system16deferred__events);
}
function _M0FP39Milky20186selene6system12defer__event(event) {
  _M0MP311moonbitlang4core5array5Array4pushGWEuE(_M0FP39Milky20186selene6system16deferred__events, event);
}
function _M0MP39Milky20186selene6system3App3new() {
  return { canvas_height: 256, canvas_width: 512, zoom: 1, image_smooth: true, fps: 60, systems: [], plugins: [] };
}
function _M0MP39Milky20186selene6system3App19with__image__smooth(self, image_smooth) {
  return { ...self, image_smooth: image_smooth };
}
function _M0MP39Milky20186selene6system3App20with__canvas__height(self, height) {
  return { ...self, canvas_height: height };
}
function _M0MP39Milky20186selene6system3App19with__canvas__width(self, width) {
  return { ...self, canvas_width: width };
}
function _M0MP39Milky20186selene6system3App9with__fps(self, fps) {
  return { ...self, fps: fps };
}
function _M0MP39Milky20186selene6system3App10with__zoom(self, zoom) {
  return { ...self, zoom: zoom };
}
function _M0MP39Milky20186selene6system3App11add__plugin(self, plugin) {
  const plugins = self.plugins;
  _M0MP311moonbitlang4core5array5Array4pushGWRP39Milky20186selene6system3AppEuE(plugins, plugin);
  return { ...self, plugins: plugins };
}
function _M0MP39Milky20186selene6system3App19add__system_2einner(self, system, schedule, system_name) {
  const _p = `unnamed_system${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self.systems.length)}`;
  let system_name$2;
  if (system_name === undefined) {
    system_name$2 = _p;
  } else {
    const _p$2 = system_name;
    system_name$2 = _p$2;
  }
  const systems = self.systems;
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(systems, { _0: system, _1: schedule, _2: system_name$2 });
  return { ...self, systems: systems };
}
function _M0MP39Milky20186selene6system3App11add__system(self, system, schedule$46$opt, system_name) {
  let schedule;
  if (schedule$46$opt === undefined) {
    schedule = $64$Milky2018$47$selene$47$system$46$Schedule$Update;
  } else {
    const _Some = schedule$46$opt;
    schedule = _Some;
  }
  return _M0MP39Milky20186selene6system3App19add__system_2einner(self, system, schedule, system_name);
}
function _M0MP39Milky20186selene6system3App3run(self) {
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
        _M0MP311moonbitlang4core5array5Array4pushGUWdEuiEE(renders, { _0: system._0, _1: _pri });
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP311moonbitlang4core5array5Array13sort__by__keyGUWdEuiEiE(renders, (system) => -system._1 | 0);
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
        _M0MP311moonbitlang4core5array5Array4pushGWdEuE(game_loops, system._0);
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
  const run_game = _M0FP39Milky20186selene7backend10initialize({ startup: startup, render_loop: render_loop, game_loop: game_loop, canvas_width: self.canvas_width, canvas_height: self.canvas_height, fps: self.fps, image_smooth: self.image_smooth, zoom: self.zoom });
  _M0FP39Milky20186selene7backend21register__key__events(_M0FP39Milky20186selene6inputs13pressed__keys);
  _M0FP39Milky20186selene7backend23register__mouse__events(_M0FP39Milky20186selene6inputs5mouse, _M0FP39Milky20186selene6inputs15mouse__movement);
  run_game();
}
function _M0IP39Milky20186selene6entity6EntityP311moonbitlang4core7builtin4Hash13hash__combine(_x_29, _x_30) {
  _M0IP311moonbitlang4core4uint4UIntP311moonbitlang4core7builtin4Hash13hash__combine(_x_29, _x_30);
}
function _M0FP39Milky20186selene6entity14iter__entities() {
  return _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6entity6EntityE(_M0FP39Milky20186selene6entity13all__entities);
}
function _M0MP39Milky20186selene6entity6Entity9is__alive(e) {
  return _M0MP311moonbitlang4core3set3Set8containsGRP39Milky20186selene6entity6EntityE(_M0FP39Milky20186selene6entity13all__entities, e);
}
function _M0MP39Milky20186selene6entity6Entity3new() {
  const entity = _M0FP39Milky20186selene6entity17entity__generator.val;
  _M0FP39Milky20186selene6entity17entity__generator.val = (_M0FP39Milky20186selene6entity17entity__generator.val >>> 0) + (1 >>> 0) | 0;
  _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6entity6EntityE(_M0FP39Milky20186selene6entity13all__entities, entity);
  return entity;
}
function _M0MP39Milky20186selene6entity6Entity7destroy(e) {
  _M0FP39Milky20186selene6system12defer__event(() => {
    _M0MP311moonbitlang4core3set3Set6removeGRP39Milky20186selene6entity6EntityE(_M0FP39Milky20186selene6entity13all__entities, e);
  });
  const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(_M0FP39Milky20186selene6entity7parents, e);
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
        _M0MP39Milky20186selene6entity6Entity7destroy(c);
        _tmp = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MP39Milky20186selene6entity6Entity7respawn(e) {
  _M0FP39Milky20186selene6system12defer__event(() => {
    _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6entity6EntityE(_M0FP39Milky20186selene6entity13all__entities, e);
  });
  const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(_M0FP39Milky20186selene6entity7parents, e);
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
        _M0MP39Milky20186selene6entity6Entity7respawn(c);
        _tmp = _i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MP39Milky20186selene6entity6Entity12spawn__child(parent, offset) {
  const child_entity = _M0MP39Milky20186selene6entity6Entity3new();
  const p = _M0MP311moonbitlang4core7builtin3Map13get__or__initGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(_M0FP39Milky20186selene6entity7parents, parent, () => ({ children: [], is_root: !_M0MP311moonbitlang4core7builtin3Map8containsGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(_M0FP39Milky20186selene6entity8children, parent) }));
  _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene6entity6EntityE(p.children, child_entity);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(_M0FP39Milky20186selene6entity8children, child_entity, { parent: parent, offset: _M0MP311moonbitlang4core6option6Option19unwrap__or__defaultGRP39Milky20186selene4math5Vec2DE(offset) });
  return child_entity;
}
function _M0MP39Milky20186selene6entity6Entity13get__children(parent) {
  return _M0MP311moonbitlang4core6option6Option7map__orGRP39Milky20186selene6entity6ParentRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene6entity6EntityEE(_M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(_M0FP39Milky20186selene6entity7parents, parent), [], (p) => p.children);
}
function _M0MP39Milky20186selene6entity6Entity9is__child(entity) {
  return _M0MP311moonbitlang4core7builtin3Map8containsGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(_M0FP39Milky20186selene6entity8children, entity);
}
function _M0MP39Milky20186selene6entity6Entity11set__offset(child, offset) {
  const _p = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(_M0FP39Milky20186selene6entity8children, child);
  let _tmp;
  if (_p === undefined) {
    _tmp = $panic();
  } else {
    const _p$2 = _p;
    _tmp = _p$2;
  }
  _tmp.offset = offset;
}
function _M0FP39Milky20186selene6entity10get__roots() {
  return _M0MP311moonbitlang4core7builtin4Iter3mapGURP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentERP39Milky20186selene6entity6EntityE(_M0MP311moonbitlang4core7builtin4Iter6filterGURP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentEE(_M0MP311moonbitlang4core7builtin3Map4iterGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity6ParentE(_M0FP39Milky20186selene6entity7parents), (ep) => ep._1.is_root && _M0MP39Milky20186selene6entity6Entity9is__alive(ep._0)), (ep) => ep._0);
}
function _M0FP39Milky20186selene6camera11set__limits(top, bottom, left, right) {
  _M0FP39Milky20186selene6camera6camera.limit_top = top;
  _M0FP39Milky20186selene6camera6camera.limit_bottom = bottom;
  _M0FP39Milky20186selene6camera6camera.limit_left = left;
  _M0FP39Milky20186selene6camera6camera.limit_right = right;
}
function _M0FP39Milky20186selene6camera14attach__entity(entity, offset) {
  _M0FP39Milky20186selene6camera6camera.attached_entity = entity;
  _M0FP39Milky20186selene6camera6camera.offset = offset;
}
function _M0FP39Milky20186selene6camera14camera__system(_delta) {
  const _bind$8 = _M0FP39Milky20186selene6camera6camera.attached_entity;
  if (_bind$8 === undefined) {
    return;
  } else {
    const _Some = _bind$8;
    const _e = _Some;
    const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _e);
    if (_bind$9 === undefined) {
      return;
    } else {
      const _Some$2 = _bind$9;
      const _pos = _Some$2;
      const zoom = _M0FP39Milky20186selene7backend15canvas__backend.zoom;
      const _p = _M0FP39Milky20186selene7backend15canvas__backend.viewport_size;
      const _p$2 = { _0: 1 / zoom, _1: 1 / zoom };
      const viewport_size = { _0: _p._0 * _p$2._0, _1: _p._1 * _p$2._1 };
      const _p$3 = { _0: 0.5, _1: 0.5 };
      const _p$4 = { _0: viewport_size._0 * _p$3._0, _1: viewport_size._1 * _p$3._1 };
      const _p$5 = { _0: _pos._0 - _p$4._0, _1: _pos._1 - _p$4._1 };
      const _p$6 = _M0FP39Milky20186selene6camera6camera.offset;
      const target_position = { _0: _p$5._0 + _p$6._0, _1: _p$5._1 + _p$6._1 };
      const new_x = _M0FP39Milky20186selene6camera6camera.follow_x ? _M0MP39Milky20186selene4math5Vec2D7op__get(target_position, 0) : _M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 0);
      const new_y = _M0FP39Milky20186selene6camera6camera.follow_y ? _M0MP39Milky20186selene4math5Vec2D7op__get(target_position, 1) : _M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 1);
      _M0FP39Milky20186selene6camera6camera.position = { _0: new_x, _1: new_y };
      const _bind$10 = _M0FP39Milky20186selene6camera6camera.limit_top;
      if (_bind$10.$tag === 1) {
        const _Some$3 = _bind$10;
        const _top = _Some$3._0;
        if (_M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 1) < _top) {
          _M0FP39Milky20186selene6camera6camera.position = { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 0), _1: _top };
        }
      }
      const _bind$11 = _M0FP39Milky20186selene6camera6camera.limit_bottom;
      if (_bind$11.$tag === 1) {
        const _Some$3 = _bind$11;
        const _bottom = _Some$3._0;
        if (_M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 1) > _bottom - _M0MP39Milky20186selene4math5Vec2D7op__get(viewport_size, 1)) {
          _M0FP39Milky20186selene6camera6camera.position = { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 0), _1: _bottom - _M0MP39Milky20186selene4math5Vec2D7op__get(viewport_size, 1) };
        }
      }
      const _bind$12 = _M0FP39Milky20186selene6camera6camera.limit_left;
      if (_bind$12.$tag === 1) {
        const _Some$3 = _bind$12;
        const _left = _Some$3._0;
        if (_M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 0) < _left) {
          _M0FP39Milky20186selene6camera6camera.position = { _0: _left, _1: _M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 1) };
        }
      }
      const _bind$13 = _M0FP39Milky20186selene6camera6camera.limit_right;
      if (_bind$13.$tag === 1) {
        const _Some$3 = _bind$13;
        const _right = _Some$3._0;
        if (_M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 0) > _right - _M0MP39Milky20186selene4math5Vec2D7op__get(viewport_size, 0)) {
          _M0FP39Milky20186selene6camera6camera.position = { _0: _right - _M0MP39Milky20186selene4math5Vec2D7op__get(viewport_size, 0), _1: _M0MP39Milky20186selene4math5Vec2D7op__get(_M0FP39Milky20186selene6camera6camera.position, 1) };
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
function _M0MP39Milky20186selene2ui2Ui3new() {
  ({});
}
function _M0MP39Milky20186selene9collision8QuadTree3new(position, size, depth) {
  const _bind$8 = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6entity6EntityE(8);
  const _bind$9 = [];
  const _bind$10 = { position: position, size: size };
  return { position: position, size: size, children: _bind$9, depth: depth, bounding_box: _bind$10, entities: _bind$8 };
}
function _M0MP39Milky20186selene9collision8QuadTree18is__smallest__size(self) {
  return _M0MP39Milky20186selene4math5Vec2D7op__get(self.size, 0) <= 64 || _M0MP39Milky20186selene4math5Vec2D7op__get(self.size, 1) <= 64;
}
function _M0MP39Milky20186selene9collision8QuadTree6insert(self, entity, box) {
  if (!_M0MP39Milky20186selene4math4Rect10intersects(self.bounding_box, box)) {
    return undefined;
  }
  if (_M0MP39Milky20186selene9collision8QuadTree18is__smallest__size(self)) {
    _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6entity6EntityE(self.entities, entity);
    return undefined;
  }
  const _p = self.children;
  if (_p.length === 0) {
    const half_size = { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(self.size, 0) * 0.5, _1: _M0MP39Milky20186selene4math5Vec2D7op__get(self.size, 1) * 0.5 };
    const _self = self.children;
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene9collision8QuadTreeE(_self, _M0MP39Milky20186selene9collision8QuadTree3new(self.position, half_size, self.depth + 1 | 0));
    const _p$2 = self.position;
    const _p$3 = { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(half_size, 0), _1: 0 };
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene9collision8QuadTreeE(_self, _M0MP39Milky20186selene9collision8QuadTree3new({ _0: _p$2._0 + _p$3._0, _1: _p$2._1 + _p$3._1 }, half_size, self.depth + 1 | 0));
    const _p$4 = self.position;
    const _p$5 = { _0: 0, _1: _M0MP39Milky20186selene4math5Vec2D7op__get(half_size, 1) };
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene9collision8QuadTreeE(_self, _M0MP39Milky20186selene9collision8QuadTree3new({ _0: _p$4._0 + _p$5._0, _1: _p$4._1 + _p$5._1 }, half_size, self.depth + 1 | 0));
    const _p$6 = self.position;
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene9collision8QuadTreeE(_self, _M0MP39Milky20186selene9collision8QuadTree3new({ _0: _p$6._0 + half_size._0, _1: _p$6._1 + half_size._1 }, half_size, self.depth + 1 | 0));
  }
  const _arr = self.children;
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const child = _arr[_i];
      _M0MP39Milky20186selene9collision8QuadTree6insert(child, entity, box);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP39Milky20186selene9collision15quadtree__query(area) {
  const _bind$8 = [_M0FP39Milky20186selene9collision14quadtree__root.val];
  const trees = { val: _M0MP311moonbitlang4core4list4List11from__arrayGRP39Milky20186selene9collision8QuadTreeE({ buf: _bind$8, start: 0, end: 1 }) };
  let results = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6entity6EntityE(8);
  while (true) {
    const _bind$9 = trees.val;
    if (_bind$9.$tag === 1) {
      const _More = _bind$9;
      const _hd = _More._0;
      const _rest = _More._1;
      trees.val = _rest;
      if (!_M0MP39Milky20186selene4math4Rect10intersects(_hd.bounding_box, area)) {
        continue;
      }
      const _bind$10 = _hd.children;
      if (_bind$10.length === 0) {
        results = _M0MP311moonbitlang4core3set3Set5unionGRP39Milky20186selene6entity6EntityE(results, _hd.entities);
      } else {
        const _p = _hd.children;
        const _p$2 = _p.length;
        let _tmp = 0;
        while (true) {
          const _p$3 = _tmp;
          if (_p$3 < _p$2) {
            const _p$4 = _p[_p$3];
            const _p$5 = trees.val;
            trees.val = new $64$moonbitlang$47$core$47$list$46$List$More$15$(_p$4, _p$5);
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
function _M0FP39Milky20186selene9collision23quadtree__clear__system(_delta) {
  let left_limit = 0;
  let right_limit = 0;
  let top_limit = 0;
  let bottom_limit = 0;
  const boxes = [];
  const _it = _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      const _shape = _x._1;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(_M0FP39Milky20186selene2ui3uis, _e);
        if (_bind$9 === -1) {
          const _bind$10 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _e);
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
            _M0MP311moonbitlang4core5array5Array4pushGURP39Milky20186selene6entity6EntityRP39Milky20186selene4math4RectEE(boxes, { _0: _e, _1: box });
            const _p = left_limit;
            const _p$2 = _M0MP39Milky20186selene4math5Vec2D7op__get(_bind$11, 0);
            left_limit = _p > _p$2 ? _p$2 : _p;
            const _p$3 = right_limit;
            const _p$4 = _M0MP39Milky20186selene4math5Vec2D7op__get(_bind$11, 0) + _M0MP39Milky20186selene4math5Vec2D7op__get(_bind$12, 0);
            right_limit = _p$3 > _p$4 ? _p$3 : _p$4;
            const _p$5 = top_limit;
            const _p$6 = _M0MP39Milky20186selene4math5Vec2D7op__get(_bind$11, 1);
            top_limit = _p$5 > _p$6 ? _p$6 : _p$5;
            const _p$7 = bottom_limit;
            const _p$8 = _M0MP39Milky20186selene4math5Vec2D7op__get(_bind$11, 1) + _M0MP39Milky20186selene4math5Vec2D7op__get(_bind$12, 1);
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
  _M0FP39Milky20186selene9collision14quadtree__root.val = _M0MP39Milky20186selene9collision8QuadTree3new({ _0: left_limit, _1: top_limit }, { _0: right_limit - left_limit, _1: bottom_limit - top_limit }, 0);
  const _len = boxes.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const box = boxes[_i];
      _M0MP39Milky20186selene9collision8QuadTree6insert(_M0FP39Milky20186selene9collision14quadtree__root.val, box._0, box._1);
      _tmp = _i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP39Milky20186selene9collision8Pickable3new() {
  return { on_pressed_callbacks: [], on_released_callbacks: [], on_just_pressed_callbacks: [], on_just_released_callbacks: [] };
}
function _M0MP39Milky20186selene9collision8Pickable17on__just__pressed(self, callback) {
  _M0MP311moonbitlang4core5array5Array4pushGWRP39Milky20186selene6inputs11MouseButtonEuE(self.on_just_pressed_callbacks, callback);
}
function _M0FP39Milky20186selene9collision23pickable__click__system(_delta) {
  const zoom = _M0FP39Milky20186selene7backend15canvas__backend.zoom;
  const _bind$8 = { _0: 1, _1: 1 };
  const _p = _M0FP39Milky20186selene6inputs5mouse.pos;
  const _p$2 = { _0: 1 / zoom, _1: 1 / zoom };
  const _bind$9 = { _0: _p._0 * _p$2._0, _1: _p._1 * _p$2._1 };
  const box = { position: _bind$9, size: _bind$8 };
  const _it = _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(_M0FP39Milky20186selene2ui3uis);
  while (true) {
    const _bind$10 = _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(_it);
    if (_bind$10 === undefined) {
      break;
    } else {
      const _Some = _bind$10;
      const _x = _Some;
      const _e = _x._0;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        const _bind$11 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(_M0FP39Milky20186selene9collision9pickables, _e);
        if (_bind$11 === undefined) {
          continue;
        } else {
          const _Some$2 = _bind$11;
          const _pick = _Some$2;
          const _bind$12 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _e);
          if (_bind$12 === undefined) {
            continue;
          } else {
            const _Some$3 = _bind$12;
            const _position = _Some$3;
            const _bind$13 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, _e);
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
              if (!_M0MP39Milky20186selene4math4Rect10intersects(box, area_box)) {
                continue;
              }
              const _arr = [0, 1, 2];
              const _len = _arr.length;
              let _tmp = 0;
              while (true) {
                const _i = _tmp;
                if (_i < _len) {
                  const button = _arr[_i];
                  if (_M0FP39Milky20186selene6inputs18is__mouse__pressed(button)) {
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
                  if (_M0FP39Milky20186selene6inputs19is__mouse__released(button)) {
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
                  if (_M0FP39Milky20186selene6inputs24is__mouse__just__pressed(button)) {
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
                  if (_M0FP39Milky20186selene6inputs25is__mouse__just__released(button)) {
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
  const entities = _M0FP39Milky20186selene9collision15quadtree__query(box);
  const _it$2 = _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6entity6EntityE(entities);
  while (true) {
    const _bind$10 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6entity6EntityE(_it$2);
    if (_bind$10 === undefined) {
      return;
    } else {
      const _Some = _bind$10;
      const _e = _Some;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        const _bind$11 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(_M0FP39Milky20186selene9collision9pickables, _e);
        if (_bind$11 === undefined) {
          continue;
        } else {
          const _Some$2 = _bind$11;
          const _pick = _Some$2;
          const _bind$12 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _e);
          if (_bind$12 === undefined) {
            continue;
          } else {
            const _Some$3 = _bind$12;
            const _position = _Some$3;
            const _bind$13 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, _e);
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
              if (!_M0MP39Milky20186selene4math4Rect10intersects(_M0MP39Milky20186selene4math4Rect5shift(box, _M0FP39Milky20186selene6camera6camera.position), area_box)) {
                continue;
              }
              const _arr = [0, 1, 2];
              const _len = _arr.length;
              let _tmp = 0;
              while (true) {
                const _i = _tmp;
                if (_i < _len) {
                  const button = _arr[_i];
                  if (_M0FP39Milky20186selene6inputs18is__mouse__pressed(button)) {
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
                  if (_M0FP39Milky20186selene6inputs19is__mouse__released(button)) {
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
                  if (_M0FP39Milky20186selene6inputs24is__mouse__just__pressed(button)) {
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
                  if (_M0FP39Milky20186selene6inputs25is__mouse__just__released(button)) {
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
function _M0FP39Milky20186selene9collision13aabb__resolve(a, b) {
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
  const intersect = { _0: -Math.abs(_M0MP39Milky20186selene4math5Vec2D7op__get(delta, 0)) + (_M0MP39Milky20186selene4math5Vec2D7op__get(b_half, 0) + _M0MP39Milky20186selene4math5Vec2D7op__get(a_half, 0)), _1: -Math.abs(_M0MP39Milky20186selene4math5Vec2D7op__get(delta, 1)) + (_M0MP39Milky20186selene4math5Vec2D7op__get(b_half, 1) + _M0MP39Milky20186selene4math5Vec2D7op__get(a_half, 1)) };
  return _M0MP39Milky20186selene4math5Vec2D7op__get(intersect, 0) < _M0MP39Milky20186selene4math5Vec2D7op__get(intersect, 1) && _M0MP39Milky20186selene4math5Vec2D7op__get(intersect, 0) > 0 ? (_M0MP39Milky20186selene4math5Vec2D7op__get(delta, 0) > 0 ? { _0: -_M0MP39Milky20186selene4math5Vec2D7op__get(intersect, 0), _1: 0 } : { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(intersect, 0), _1: 0 }) : _M0MP39Milky20186selene4math5Vec2D7op__get(intersect, 1) > 0 && _M0MP39Milky20186selene4math5Vec2D7op__get(intersect, 0) > 0 ? (_M0MP39Milky20186selene4math5Vec2D7op__get(delta, 1) > 0 ? { _0: 0, _1: -_M0MP39Milky20186selene4math5Vec2D7op__get(intersect, 1) } : { _0: 0, _1: _M0MP39Milky20186selene4math5Vec2D7op__get(intersect, 1) }) : { _0: 0, _1: 0 };
}
function _M0FP39Milky20186selene9collision20add__collision__info(entity, target, direction) {
  const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(_M0FP39Milky20186selene9collision16collision__infos, entity);
  if (_bind$8.$tag === 0) {
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(_M0FP39Milky20186selene9collision16collision__infos, entity, _M0MP311moonbitlang4core5array5Array11new_2einnerGRP39Milky20186selene9collision13CollisionInfoE(0));
  }
  _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene9collision13CollisionInfoE(_M0MP311moonbitlang4core6option6Option6unwrapGRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(_M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(_M0FP39Milky20186selene9collision16collision__infos, entity)), { entity: target, direction: direction });
}
function _M0FP39Milky20186selene9collision20make__ray__collision(object, speed, axis) {
  const pos = { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(object.position, 0), _1: _M0MP39Milky20186selene4math5Vec2D7op__get(object.position, 1) };
  const size = { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(object.size, 0), _1: _M0MP39Milky20186selene4math5Vec2D7op__get(object.size, 1) };
  return speed >= 0 ? { position: pos, size: _M0MP39Milky20186selene4math5Vec2D6update(size, axis, _M0MP39Milky20186selene4math5Vec2D7op__get(size, axis) + speed) } : { position: _M0MP39Milky20186selene4math5Vec2D6update(pos, axis, _M0MP39Milky20186selene4math5Vec2D7op__get(pos, axis) + speed), size: _M0MP39Milky20186selene4math5Vec2D6update(size, axis, _M0MP39Milky20186selene4math5Vec2D7op__get(size, axis) - speed) };
}
function _M0MP39Milky20186selene9collision13CollisionMask8contains(self, layer) {
  return _M0MP311moonbitlang4core5array5Array8containsGRP39Milky20186selene9collision14CollisionLayerE(self, layer);
}
function _M0FP39Milky20186selene9collision10move__axis(entity, object, velocity, axis, mask) {
  const ray_collision = _M0FP39Milky20186selene9collision20make__ray__collision(object, _M0MP39Milky20186selene4math5Vec2D7op__get(velocity, axis), axis);
  let new_pos = { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(object.position, 0), _1: _M0MP39Milky20186selene4math5Vec2D7op__get(object.position, 1) };
  new_pos = _M0MP39Milky20186selene4math5Vec2D6update(new_pos, axis, _M0MP39Milky20186selene4math5Vec2D7op__get(new_pos, axis) + _M0MP39Milky20186selene4math5Vec2D7op__get(velocity, axis));
  let new_velocity = velocity;
  const entities = _M0FP39Milky20186selene9collision15quadtree__query(ray_collision);
  const _it = _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6entity6EntityE(entities);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6entity6EntityE(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _e = _Some;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        if (_M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGRP39Milky20186selene6entity6EntityE(_e, entity)) {
          const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, _e);
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
            const _bind$10 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _e);
            if (_bind$10 === undefined) {
              continue;
            } else {
              const _Some$3 = _bind$10;
              const _pos = _Some$3;
              const _bind$11 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(_M0FP39Milky20186selene9collision17collision__layers, _e);
              if (_bind$11 === undefined) {
                continue;
              } else {
                const _Some$4 = _bind$11;
                const _collision_layer = _Some$4;
                if (_M0MP39Milky20186selene9collision13CollisionMask8contains(mask, _collision_layer)) {
                  const _bind$12 = { _0: _width, _1: _height };
                  const _bind$13 = { _0: _pos._0 + _offset._0, _1: _pos._1 + _offset._1 };
                  const collision_box = { position: _bind$13, size: _bind$12 };
                  if (_M0MP39Milky20186selene4math4Rect10intersects(object, collision_box)) {
                    const movement = _M0FP39Milky20186selene9collision13aabb__resolve(object, collision_box);
                    const _p = new_pos;
                    new_pos = { _0: _p._0 + movement._0, _1: _p._1 + movement._1 };
                    const dir = _M0MP39Milky20186selene4math5Vec2D6update({ _0: 0, _1: 0 }, axis, _M0MP39Milky20186selene4math5Vec2D7op__get(movement, axis) > 0 ? 1 : -1);
                    _M0FP39Milky20186selene9collision20add__collision__info(entity, _e, dir);
                    return { _0: new_pos, _1: movement };
                  }
                  if (_M0MP39Milky20186selene4math4Rect10intersects(ray_collision, collision_box)) {
                    let dir = { _0: 0, _1: 0 };
                    if (_M0MP39Milky20186selene4math5Vec2D7op__get(new_velocity, axis) > 0) {
                      const _tmp = new_pos;
                      const _p = _M0MP39Milky20186selene4math5Vec2D7op__get(_bind$13, axis) - _M0MP39Milky20186selene4math5Vec2D7op__get(object.size, axis);
                      const _p$2 = _M0MP39Milky20186selene4math5Vec2D7op__get(object.position, axis);
                      new_pos = _M0MP39Milky20186selene4math5Vec2D6update(_tmp, axis, _p > _p$2 ? _p : _p$2);
                      new_velocity = _M0MP39Milky20186selene4math5Vec2D6update(new_velocity, axis, _M0MP39Milky20186selene4math5Vec2D7op__get(new_pos, axis) - _M0MP39Milky20186selene4math5Vec2D7op__get(object.position, axis));
                      dir = _M0MP39Milky20186selene4math5Vec2D6update(dir, axis, 1);
                    } else {
                      if (_M0MP39Milky20186selene4math5Vec2D7op__get(new_velocity, axis) < 0) {
                        const _tmp = new_pos;
                        const _p = _M0MP39Milky20186selene4math5Vec2D7op__get(_bind$13, axis) + _M0MP39Milky20186selene4math5Vec2D7op__get(_bind$12, axis);
                        const _p$2 = _M0MP39Milky20186selene4math5Vec2D7op__get(object.position, axis);
                        new_pos = _M0MP39Milky20186selene4math5Vec2D6update(_tmp, axis, _p > _p$2 ? _p$2 : _p);
                        new_velocity = _M0MP39Milky20186selene4math5Vec2D6update(new_velocity, axis, _M0MP39Milky20186selene4math5Vec2D7op__get(new_pos, axis) - _M0MP39Milky20186selene4math5Vec2D7op__get(object.position, axis));
                        dir = _M0MP39Milky20186selene4math5Vec2D6update(dir, axis, -1);
                      }
                    }
                    _M0FP39Milky20186selene9collision20add__collision__info(entity, _e, dir);
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
function _M0FP39Milky20186selene9collision19move__with__collide(e, collider, velocity) {
  const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, e);
  if (_bind$8 === undefined) {
    return $panic();
  } else {
    const _Some = _bind$8;
    const _pos = _Some;
    const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, e);
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
      const new_x = _M0FP39Milky20186selene9collision10move__axis(e, box, velocity, 0, collider.mask);
      const _bind$12 = new_x._0;
      const object_x = { position: _bind$12, size: _bind$11 };
      const new_y = _M0FP39Milky20186selene9collision10move__axis(e, object_x, new_x._1, 1, collider.mask);
      const _p = new_y._0;
      _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, e, { _0: _p._0 - _offset._0, _1: _p._1 - _offset._1 });
      return new_y._1;
    }
  }
}
function _M0FP39Milky20186selene9collision22move__without__collide(e, velocity) {
  const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, e);
  if (_bind$8 === undefined) {
    $panic();
    return;
  } else {
    const _Some = _bind$8;
    const _pos = _Some;
    const new_pos = { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(_pos, 0) + _M0MP39Milky20186selene4math5Vec2D7op__get(velocity, 0), _1: _M0MP39Milky20186selene4math5Vec2D7op__get(_pos, 1) + _M0MP39Milky20186selene4math5Vec2D7op__get(velocity, 1) };
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, e, new_pos);
    return;
  }
}
function _M0FP39Milky20186selene9collision12move__system(delta) {
  _M0MP311moonbitlang4core7builtin3Map5clearGRP39Milky20186selene6entity6EntityRP311moonbitlang4core7builtin5ArrayGRP39Milky20186selene9collision13CollisionInfoEE(_M0FP39Milky20186selene9collision16collision__infos);
  const _it = _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene8velocity10velocities);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_it);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      const _vel = _x._1;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        _L: {
          _L$2: {
            const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(_M0FP39Milky20186selene9collision9colliders, _e);
            if (_bind$9 === undefined) {
              break _L$2;
            } else {
              const _Some$2 = _bind$9;
              const _collide = _Some$2;
              if (_collide.active) {
                const new_vel = _M0FP39Milky20186selene9collision19move__with__collide(_e, _collide, { _0: _vel._0 * delta, _1: _vel._1 * delta });
                if (Math.abs(delta) < 1e-09) {
                  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene9collision16real__velocities, _e, _vel);
                } else {
                  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene9collision16real__velocities, _e, { _0: new_vel._0 / delta, _1: new_vel._1 / delta });
                }
              } else {
                break _L$2;
              }
            }
            break _L;
          }
          _M0FP39Milky20186selene9collision22move__without__collide(_e, { _0: _vel._0 * delta, _1: _vel._1 * delta });
          _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene9collision16real__velocities, _e, _vel);
        }
      } else {
        continue;
      }
      continue;
    }
  }
}
function _M0MP39Milky20186selene9collision14CollisionLayer3new() {
  const layer = _M0FP39Milky20186selene9collision27collision__layer__generator.val;
  _M0FP39Milky20186selene9collision27collision__layer__generator.val = (_M0FP39Milky20186selene9collision27collision__layer__generator.val >>> 0) + (1 >>> 0) | 0;
  return layer;
}
function _M0MP39Milky20186selene9collision8Collider3new(mask) {
  return { active: true, mask: mask };
}
function _M0MP39Milky20186selene9collision4Area3new(mask) {
  const _bind$8 = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6entity6EntityE(8);
  const _bind$9 = [];
  const _bind$10 = [];
  return { mask: mask, on_enter_callbacks: _bind$9, on_exit_callbacks: _bind$10, contains: _bind$8 };
}
function _M0MP39Milky20186selene9collision4Area9on__enter(self, callback) {
  _M0MP311moonbitlang4core5array5Array4pushGWRP39Milky20186selene6entity6EntityEuE(self.on_enter_callbacks, callback);
}
function _M0FP39Milky20186selene9collision21area__collide__system(_delta) {
  const _it = _M0FP39Milky20186selene6entity14iter__entities();
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6entity6EntityE(_it);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _e = _Some;
      const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(_M0FP39Milky20186selene9collision5areas, _e);
      if (_bind$9 === undefined) {
        continue;
      } else {
        const _Some$2 = _bind$9;
        const _area = _Some$2;
        const _bind$10 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _e);
        if (_bind$10 === undefined) {
          $panic();
        } else {
          const _Some$3 = _bind$10;
          const _position = _Some$3;
          const _bind$11 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, _e);
          if (_bind$11 === undefined) {
            continue;
          } else {
            const _Some$4 = _bind$11;
            const _shape = _Some$4;
            const _Rect = _shape;
            const _x = _Rect._0;
            const _width = _x._0;
            const _height = _x._1;
            const _offset = _Rect._1;
            const _bind$12 = { _0: _width, _1: _height };
            const _bind$13 = { _0: _position._0 + _offset._0, _1: _position._1 + _offset._1 };
            const box = { position: _bind$13, size: _bind$12 };
            const new_contains = _M0MP311moonbitlang4core3set3Set11new_2einnerGRP39Milky20186selene6entity6EntityE(8);
            const entities = _M0FP39Milky20186selene9collision15quadtree__query(box);
            const _it$2 = _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6entity6EntityE(entities);
            while (true) {
              const _bind$14 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6entity6EntityE(_it$2);
              if (_bind$14 === undefined) {
                break;
              } else {
                const _Some$5 = _bind$14;
                const _entity = _Some$5;
                if (_M0MP39Milky20186selene6entity6Entity9is__alive(_entity)) {
                  const _bind$15 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(_M0FP39Milky20186selene9collision17collision__layers, _entity);
                  if (_bind$15 === undefined) {
                    continue;
                  } else {
                    const _Some$6 = _bind$15;
                    const _other_layer = _Some$6;
                    const _bind$16 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, _entity);
                    if (_bind$16 === undefined) {
                      continue;
                    } else {
                      const _Some$7 = _bind$16;
                      const _other_shape = _Some$7;
                      const _Rect$2 = _other_shape;
                      const _x$2 = _Rect$2._0;
                      const _other_width = _x$2._0;
                      const _other_height = _x$2._1;
                      const _other_offset = _Rect$2._1;
                      const _bind$17 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _entity);
                      if (_bind$17 === undefined) {
                        $panic();
                      } else {
                        const _Some$8 = _bind$17;
                        const _other_position = _Some$8;
                        const _bind$18 = { _0: _other_width, _1: _other_height };
                        const _bind$19 = { _0: _other_position._0 + _other_offset._0, _1: _other_position._1 + _other_offset._1 };
                        const other_box = { position: _bind$19, size: _bind$18 };
                        if (_M0MP39Milky20186selene4math4Rect10intersects(box, other_box)) {
                          if (_M0MP39Milky20186selene9collision13CollisionMask8contains(_area.mask, _other_layer)) {
                            _M0MP311moonbitlang4core3set3Set3addGRP39Milky20186selene6entity6EntityE(new_contains, _entity);
                            if (_M0MP311moonbitlang4core3set3Set8containsGRP39Milky20186selene6entity6EntityE(_area.contains, _entity)) {
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
            const _it$3 = _M0MP311moonbitlang4core3set3Set4iterGRP39Milky20186selene6entity6EntityE(_area.contains);
            while (true) {
              const _bind$14 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6entity6EntityE(_it$3);
              if (_bind$14 === undefined) {
                break;
              } else {
                const _Some$5 = _bind$14;
                const _entity = _Some$5;
                if (_M0MP311moonbitlang4core3set3Set8containsGRP39Milky20186selene6entity6EntityE(new_contains, _entity)) {
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
      continue;
    }
  }
}
function _M0FP39Milky20186selene7inherit16adjust__children(entity) {
  const _arr = _M0MP39Milky20186selene6entity6Entity13get__children(entity);
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      _L: {
        const c = _arr[_i];
        if (_M0MP39Milky20186selene6entity6Entity9is__alive(c)) {
          const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, entity);
          if (_bind$8 === undefined) {
            break _L;
          } else {
            const _Some = _bind$8;
            const _parent_position = _Some;
            const _p = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6entity5ChildE(_M0FP39Milky20186selene6entity8children, c);
            let _tmp$2;
            if (_p === undefined) {
              _tmp$2 = $panic();
            } else {
              const _p$2 = _p;
              _tmp$2 = _p$2;
            }
            const offset = _tmp$2.offset;
            _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, c, { _0: _parent_position._0 + offset._0, _1: _parent_position._1 + offset._1 });
            _M0FP39Milky20186selene7inherit16adjust__children(c);
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
function _M0FP39Milky20186selene7inherit25inherit__position__system(_delta) {
  const roots = _M0FP39Milky20186selene6entity10get__roots();
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6entity6EntityE(roots);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _p = _Some;
      _M0FP39Milky20186selene7inherit16adjust__children(_p);
      continue;
    }
  }
}
function _M0MP39Milky20186selene6sprite6Sprite23from__animation_2einner(animation, zindex, offset) {
  const _bind$8 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Animation(animation, 0);
  return { sprite_type: _bind$8, zindex: zindex, visible: true, offset: offset };
}
function _M0MP39Milky20186selene6sprite6Sprite15from__animation(animation, zindex, offset$46$opt) {
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  return _M0MP39Milky20186selene6sprite6Sprite23from__animation_2einner(animation, zindex, offset);
}
function _M0MP39Milky20186selene6sprite6Sprite21from__picture_2einner(picture, zindex, offset) {
  const _bind$8 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Picture(picture);
  return { sprite_type: _bind$8, zindex: zindex, visible: true, offset: offset };
}
function _M0MP39Milky20186selene6sprite6Sprite13from__picture(picture, zindex, offset$46$opt) {
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  return _M0MP39Milky20186selene6sprite6Sprite21from__picture_2einner(picture, zindex, offset);
}
function _M0MP39Milky20186selene6sprite6Sprite18from__text_2einner(text, zindex, offset) {
  const _bind$8 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Text(text);
  return { sprite_type: _bind$8, zindex: zindex, visible: true, offset: offset };
}
function _M0MP39Milky20186selene6sprite6Sprite10from__text(text, zindex, offset$46$opt) {
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  return _M0MP39Milky20186selene6sprite6Sprite18from__text_2einner(text, zindex, offset);
}
function _M0MP39Milky20186selene6sprite6Sprite25from__color__rect_2einner(color_rect, zindex, offset) {
  const _bind$8 = new $64$Milky2018$47$selene$47$sprite$46$SpriteType$ColorRect(color_rect);
  return { sprite_type: _bind$8, zindex: zindex, visible: true, offset: offset };
}
function _M0MP39Milky20186selene6sprite6Sprite17from__color__rect(color_rect, zindex, offset$46$opt) {
  let offset;
  if (offset$46$opt === undefined) {
    offset = { _0: 0, _1: 0 };
  } else {
    const _Some = offset$46$opt;
    offset = _Some;
  }
  return _M0MP39Milky20186selene6sprite6Sprite25from__color__rect_2einner(color_rect, zindex, offset);
}
function _M0FP39Milky20186selene6sprite17render__animation(animation, current_frame, pos, visible, delta) {
  const frame = _M0MP311moonbitlang4core5array5Array2atGRP39Milky20186selene6sprite14AnimationFrameE(animation.frames, _M0MP311moonbitlang4core6double6Double7to__int(current_frame));
  if (visible) {
    const _bind$8 = frame.sprite_path;
    const _bind$9 = { position: pos, size: frame.size };
    const _bind$10 = { position: frame.offset, size: frame.size };
    const _bind$11 = animation.transform;
    _M0FP39Milky20186selene7backend11draw__image({ path: _bind$8, destination: _bind$9, source: _bind$10, transform: _bind$11, repeat: 2 });
  }
  let new_frame = current_frame + animation.fps * delta;
  if (_M0MP311moonbitlang4core6double6Double7to__int(new_frame) >= animation.frames.length) {
    if (animation.loop_) {
      new_frame = 0;
    } else {
      new_frame = animation.frames.length + 0 - 0.01;
    }
  }
  return new_frame;
}
function _M0FP39Milky20186selene6sprite4rgba(r, g, b, a) {
  return { r: r < 0 ? 0 : r > 255 ? 255 : r, g: g < 0 ? 0 : g > 255 ? 255 : g, b: b < 0 ? 0 : b > 255 ? 255 : b, a: a < 0 ? 0 : a > 1 ? 1 : a };
}
function _M0FP39Milky20186selene6sprite12named__color(name) {
  switch (name) {
    case "black": {
      return _M0FP39Milky20186selene6sprite4rgba(0, 0, 0, 1);
    }
    case "white": {
      return _M0FP39Milky20186selene6sprite4rgba(255, 255, 255, 1);
    }
    case "red": {
      return _M0FP39Milky20186selene6sprite4rgba(255, 0, 0, 1);
    }
    case "green": {
      return _M0FP39Milky20186selene6sprite4rgba(0, 128, 0, 1);
    }
    case "blue": {
      return _M0FP39Milky20186selene6sprite4rgba(0, 0, 255, 1);
    }
    case "yellow": {
      return _M0FP39Milky20186selene6sprite4rgba(255, 255, 0, 1);
    }
    case "cyan": {
      return _M0FP39Milky20186selene6sprite4rgba(0, 255, 255, 1);
    }
    case "magenta": {
      return _M0FP39Milky20186selene6sprite4rgba(255, 0, 255, 1);
    }
    case "orange": {
      return _M0FP39Milky20186selene6sprite4rgba(255, 165, 0, 1);
    }
    case "purple": {
      return _M0FP39Milky20186selene6sprite4rgba(128, 0, 128, 1);
    }
    case "gray": {
      return _M0FP39Milky20186selene6sprite4rgba(128, 128, 128, 1);
    }
    case "grey": {
      return _M0FP39Milky20186selene6sprite4rgba(128, 128, 128, 1);
    }
    case "brown": {
      return _M0FP39Milky20186selene6sprite4rgba(165, 42, 42, 1);
    }
    case "pink": {
      return _M0FP39Milky20186selene6sprite4rgba(255, 192, 203, 1);
    }
    case "transparent": {
      return _M0FP39Milky20186selene6sprite4rgba(0, 0, 0, 0);
    }
    case "none": {
      return _M0FP39Milky20186selene6sprite4rgba(0, 0, 0, 0);
    }
    default: {
      return undefined;
    }
  }
}
function _M0FP39Milky20186selene6sprite11parse__uint(text, base) {
  let parsed;
  let _try_err;
  _L: {
    _L$2: {
      const _bind$8 = _M0FP311moonbitlang4core7strconv19parse__uint_2einner(text, base);
      let _tmp;
      if (_bind$8.$tag === 1) {
        const _ok = _bind$8;
        _tmp = _ok._0;
      } else {
        const _err = _bind$8;
        _try_err = _err._0;
        break _L$2;
      }
      parsed = new Result$Ok$14$(_tmp);
      break _L;
    }
    parsed = new Result$Err$14$(_try_err);
  }
  if (parsed.$tag === 1) {
    const _Ok = parsed;
    const _value = _Ok._0;
    return _value;
  } else {
    return undefined;
  }
}
function _M0FP39Milky20186selene6sprite16parse__hex__byte(text) {
  return _M0FP39Milky20186selene6sprite11parse__uint(_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin12ToStringView16to__string__view(text), 16);
}
function _M0FP39Milky20186selene6sprite17parse__hex__color(color) {
  const hex = color.substring(1, color.length);
  const _bind$8 = hex.length;
  switch (_bind$8) {
    case 3: {
      const r = hex.substring(0, 1);
      const g = hex.substring(1, 2);
      const b = hex.substring(2, 3);
      const _bind$9 = _M0FP39Milky20186selene6sprite16parse__hex__byte(`${r}${r}`);
      if (_bind$9 === undefined) {
        return undefined;
      } else {
        const _Some = _bind$9;
        const _r = _Some;
        const _bind$10 = _M0FP39Milky20186selene6sprite16parse__hex__byte(`${g}${g}`);
        if (_bind$10 === undefined) {
          return undefined;
        } else {
          const _Some$2 = _bind$10;
          const _g = _Some$2;
          const _bind$11 = _M0FP39Milky20186selene6sprite16parse__hex__byte(`${b}${b}`);
          if (_bind$11 === undefined) {
            return undefined;
          } else {
            const _Some$3 = _bind$11;
            const _b = _Some$3;
            return _M0FP39Milky20186selene6sprite4rgba(_r, _g, _b, 1);
          }
        }
      }
    }
    case 4: {
      const r$2 = hex.substring(0, 1);
      const g$2 = hex.substring(1, 2);
      const b$2 = hex.substring(2, 3);
      const a = hex.substring(3, 4);
      const _bind$10 = _M0FP39Milky20186selene6sprite16parse__hex__byte(`${r$2}${r$2}`);
      if (_bind$10 === undefined) {
        return undefined;
      } else {
        const _Some = _bind$10;
        const _r = _Some;
        const _bind$11 = _M0FP39Milky20186selene6sprite16parse__hex__byte(`${g$2}${g$2}`);
        if (_bind$11 === undefined) {
          return undefined;
        } else {
          const _Some$2 = _bind$11;
          const _g = _Some$2;
          const _bind$12 = _M0FP39Milky20186selene6sprite16parse__hex__byte(`${b$2}${b$2}`);
          if (_bind$12 === undefined) {
            return undefined;
          } else {
            const _Some$3 = _bind$12;
            const _b = _Some$3;
            const _bind$13 = _M0FP39Milky20186selene6sprite16parse__hex__byte(`${a}${a}`);
            if (_bind$13 === undefined) {
              return undefined;
            } else {
              const _Some$4 = _bind$13;
              const _a = _Some$4;
              return _M0FP39Milky20186selene6sprite4rgba(_r, _g, _b, $f64_convert_i32_u(_a) / 255);
            }
          }
        }
      }
    }
    case 6: {
      const _bind$11 = _M0FP39Milky20186selene6sprite16parse__hex__byte(hex.substring(0, 2));
      if (_bind$11 === undefined) {
        return undefined;
      } else {
        const _Some = _bind$11;
        const _r = _Some;
        const _bind$12 = _M0FP39Milky20186selene6sprite16parse__hex__byte(hex.substring(2, 4));
        if (_bind$12 === undefined) {
          return undefined;
        } else {
          const _Some$2 = _bind$12;
          const _g = _Some$2;
          const _bind$13 = _M0FP39Milky20186selene6sprite16parse__hex__byte(hex.substring(4, 6));
          if (_bind$13 === undefined) {
            return undefined;
          } else {
            const _Some$3 = _bind$13;
            const _b = _Some$3;
            return _M0FP39Milky20186selene6sprite4rgba(_r, _g, _b, 1);
          }
        }
      }
    }
    case 8: {
      const _bind$12 = _M0FP39Milky20186selene6sprite16parse__hex__byte(hex.substring(0, 2));
      if (_bind$12 === undefined) {
        return undefined;
      } else {
        const _Some = _bind$12;
        const _r = _Some;
        const _bind$13 = _M0FP39Milky20186selene6sprite16parse__hex__byte(hex.substring(2, 4));
        if (_bind$13 === undefined) {
          return undefined;
        } else {
          const _Some$2 = _bind$13;
          const _g = _Some$2;
          const _bind$14 = _M0FP39Milky20186selene6sprite16parse__hex__byte(hex.substring(4, 6));
          if (_bind$14 === undefined) {
            return undefined;
          } else {
            const _Some$3 = _bind$14;
            const _b = _Some$3;
            const _bind$15 = _M0FP39Milky20186selene6sprite16parse__hex__byte(hex.substring(6, 8));
            if (_bind$15 === undefined) {
              return undefined;
            } else {
              const _Some$4 = _bind$15;
              const _a = _Some$4;
              return _M0FP39Milky20186selene6sprite4rgba(_r, _g, _b, $f64_convert_i32_u(_a) / 255);
            }
          }
        }
      }
    }
    default: {
      return undefined;
    }
  }
}
function _M0FP39Milky20186selene6sprite13parse__double(text) {
  let parsed;
  let _try_err;
  _L: {
    _L$2: {
      const _bind$8 = _M0FP311moonbitlang4core7strconv13parse__double(text);
      let _tmp;
      if (_bind$8.$tag === 1) {
        const _ok = _bind$8;
        _tmp = _ok._0;
      } else {
        const _err = _bind$8;
        _try_err = _err._0;
        break _L$2;
      }
      parsed = new Result$Ok$9$(_tmp);
      break _L;
    }
    parsed = new Result$Err$9$(_try_err);
  }
  if (parsed.$tag === 1) {
    const _Ok = parsed;
    const _value = _Ok._0;
    return new Option$Some$0$(_value);
  } else {
    return Option$None$0$;
  }
}
function _M0FP39Milky20186selene6sprite10parse__int(text) {
  let parsed;
  let _try_err;
  _L: {
    _L$2: {
      const _bind$8 = _M0FP311moonbitlang4core7strconv18parse__int_2einner(text, 0);
      let _tmp;
      if (_bind$8.$tag === 1) {
        const _ok = _bind$8;
        _tmp = _ok._0;
      } else {
        const _err = _bind$8;
        _try_err = _err._0;
        break _L$2;
      }
      parsed = new Result$Ok$11$(_tmp);
      break _L;
    }
    parsed = new Result$Err$11$(_try_err);
  }
  if (parsed.$tag === 1) {
    const _Ok = parsed;
    const _value = _Ok._0;
    return _value;
  } else {
    return undefined;
  }
}
function _M0FP39Milky20186selene6sprite16parse__rgb__body(body, with_alpha) {
  const values = [];
  const _it = _M0MP311moonbitlang4core6string6String5split(body, { str: _M0FP39Milky20186selene6sprite32parse__rgb__body_2e_2abind_7c352, start: 0, end: _M0FP39Milky20186selene6sprite32parse__rgb__body_2e_2abind_7c352.length });
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP311moonbitlang4core6string10StringViewE(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _part = _Some;
      _M0MP311moonbitlang4core5array5Array4pushGsE(values, _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(_M0MP311moonbitlang4core6string10StringView4trim(_part, undefined)));
      continue;
    }
  }
  if (with_alpha && values.length !== 4) {
    return undefined;
  }
  if (!with_alpha && values.length !== 3) {
    return undefined;
  }
  const _bind$8 = _M0FP39Milky20186selene6sprite10parse__int(_M0MP311moonbitlang4core6string6String4trim(_M0MP311moonbitlang4core5array5Array2atGsE(values, 0), undefined));
  if (_bind$8 === undefined) {
    return undefined;
  } else {
    const _Some = _bind$8;
    const _r = _Some;
    const _bind$9 = _M0FP39Milky20186selene6sprite10parse__int(_M0MP311moonbitlang4core6string6String4trim(_M0MP311moonbitlang4core5array5Array2atGsE(values, 1), undefined));
    if (_bind$9 === undefined) {
      return undefined;
    } else {
      const _Some$2 = _bind$9;
      const _g = _Some$2;
      const _bind$10 = _M0FP39Milky20186selene6sprite10parse__int(_M0MP311moonbitlang4core6string6String4trim(_M0MP311moonbitlang4core5array5Array2atGsE(values, 2), undefined));
      if (_bind$10 === undefined) {
        return undefined;
      } else {
        const _Some$3 = _bind$10;
        const _b = _Some$3;
        if (with_alpha) {
          const _bind$11 = _M0FP39Milky20186selene6sprite13parse__double(_M0MP311moonbitlang4core6string6String4trim(_M0MP311moonbitlang4core5array5Array2atGsE(values, 3), undefined));
          if (_bind$11.$tag === 1) {
            const _Some$4 = _bind$11;
            const _a = _Some$4._0;
            return _M0FP39Milky20186selene6sprite4rgba(_r, _g, _b, _a);
          } else {
            return undefined;
          }
        }
        return _M0FP39Milky20186selene6sprite4rgba(_r, _g, _b, 1);
      }
    }
  }
}
function _M0FP39Milky20186selene6sprite17parse__rgb__color(color) {
  if (_M0MP311moonbitlang4core6string6String11has__prefix(color, { str: _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c373, start: 0, end: _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c373.length }) && _M0MP311moonbitlang4core6string6String11has__suffix(color, { str: _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c374, start: 0, end: _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c374.length })) {
    const body = color.substring(5, color.length - 1 | 0);
    return _M0FP39Milky20186selene6sprite16parse__rgb__body(body, true);
  }
  if (_M0MP311moonbitlang4core6string6String11has__prefix(color, { str: _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c375, start: 0, end: _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c375.length }) && _M0MP311moonbitlang4core6string6String11has__suffix(color, { str: _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c376, start: 0, end: _M0FP39Milky20186selene6sprite33parse__rgb__color_2e_2abind_7c376.length })) {
    const body = color.substring(4, color.length - 1 | 0);
    return _M0FP39Milky20186selene6sprite16parse__rgb__body(body, false);
  }
  return undefined;
}
function _M0FP39Milky20186selene6sprite12parse__color(color) {
  const normalized = _M0MP311moonbitlang4core6string6String9to__lower(_M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(_M0MP311moonbitlang4core6string6String4trim(color, undefined)));
  if (_M0MP311moonbitlang4core6string6String11has__prefix(normalized, { str: _M0FP39Milky20186selene6sprite28parse__color_2e_2abind_7c377, start: 0, end: _M0FP39Milky20186selene6sprite28parse__color_2e_2abind_7c377.length })) {
    const _bind$8 = _M0FP39Milky20186selene6sprite17parse__hex__color(normalized);
    if (_bind$8 === undefined) {
    } else {
      const _Some = _bind$8;
      const _color = _Some;
      return _color;
    }
  }
  if (_M0MP311moonbitlang4core6string6String11has__prefix(normalized, { str: _M0FP39Milky20186selene6sprite28parse__color_2e_2abind_7c383, start: 0, end: _M0FP39Milky20186selene6sprite28parse__color_2e_2abind_7c383.length }) || _M0MP311moonbitlang4core6string6String11has__prefix(normalized, { str: _M0FP39Milky20186selene6sprite28parse__color_2e_2abind_7c384, start: 0, end: _M0FP39Milky20186selene6sprite28parse__color_2e_2abind_7c384.length })) {
    const _bind$8 = _M0FP39Milky20186selene6sprite17parse__rgb__color(normalized);
    if (_bind$8 === undefined) {
    } else {
      const _Some = _bind$8;
      const _color = _Some;
      return _color;
    }
  }
  const _bind$8 = _M0FP39Milky20186selene6sprite12named__color(normalized);
  if (_bind$8 === undefined) {
  } else {
    const _Some = _bind$8;
    const _color = _Some;
    return _color;
  }
  return _M0FP39Milky20186selene6sprite4rgba(255, 255, 255, 1);
}
function _M0FP39Milky20186selene6sprite22parse__optional__color(color) {
  const parsed = _M0FP39Milky20186selene6sprite12parse__color(color);
  return parsed.a <= 0 ? undefined : parsed;
}
function _M0FP39Milky20186selene6sprite21render__color__circle(color_circle, position) {
  _M0FP39Milky20186selene7backend12draw__circle({ center: { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(position, 0) + color_circle.radius, _1: _M0MP39Milky20186selene4math5Vec2D7op__get(position, 1) + color_circle.radius }, radius: color_circle.radius, fill_color: _M0FP39Milky20186selene6sprite12parse__color(color_circle.color), stroke_color: _M0FP39Milky20186selene6sprite22parse__optional__color(color_circle.stroke_color) });
}
function _M0FP39Milky20186selene6sprite19render__color__rect(color_rect, position) {
  _M0FP39Milky20186selene7backend10draw__rect({ rect: { position: position, size: color_rect.size }, fill_color: _M0FP39Milky20186selene6sprite12parse__color(color_rect.color), stroke_color: _M0FP39Milky20186selene6sprite22parse__optional__color(color_rect.stroke_color) });
}
function _M0FP39Milky20186selene6sprite15render__picture(picture, pos) {
  const _bind$8 = picture.tile_path;
  const _bind$9 = { position: pos, size: picture.size };
  const _bind$10 = undefined;
  const _bind$11 = picture.repeat;
  const _bind$12 = picture.transform;
  _M0FP39Milky20186selene7backend11draw__image({ path: _bind$8, destination: _bind$9, source: _bind$10, transform: _bind$12, repeat: _bind$11 });
}
function _M0FP39Milky20186selene6sprite19parse__font__family(family) {
  const family$2 = _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(_M0MP311moonbitlang4core6string10StringView4trim(family, undefined));
  return family$2 === "" ? "Arial" : family$2;
}
function _M0FP39Milky20186selene6sprite17parse__font__size(size) {
  const _bind$8 = _M0FP39Milky20186selene6sprite13parse__double(_M0MP311moonbitlang4core6string10StringView4trim(size, undefined));
  if (_bind$8.$tag === 1) {
    const _Some = _bind$8;
    return _Some._0;
  } else {
    return 16;
  }
}
function _M0FP39Milky20186selene6sprite11parse__font(font) {
  const font$2 = _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(_M0MP311moonbitlang4core6string6String4trim(font, undefined));
  if (font$2 === "") {
    return _M0FP39Milky20186selene6sprite26parse__font_2etuple_2f4317;
  }
  let size = 16;
  let family = font$2;
  let idx = 0;
  const _it = _M0MP311moonbitlang4core6string6String5split(font$2, { str: _M0FP39Milky20186selene6sprite27parse__font_2e_2abind_7c412, start: 0, end: _M0FP39Milky20186selene6sprite27parse__font_2e_2abind_7c412.length });
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP311moonbitlang4core6string10StringViewE(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _part = _Some;
      if (idx === 0) {
        size = _M0FP39Milky20186selene6sprite17parse__font__size(_part);
      } else {
        if (idx === 1) {
          family = _M0FP39Milky20186selene6sprite19parse__font__family(_part);
          break;
        }
      }
      idx = idx + 1 | 0;
      continue;
    }
  }
  return { _0: size, _1: family };
}
function _M0FP39Milky20186selene6sprite18parse__text__style(font, color, align, baseline) {
  const _bind$8 = _M0FP39Milky20186selene6sprite11parse__font(font);
  const _size = _bind$8._0;
  const _family = _bind$8._1;
  return { family: _family, size: _size, color: _M0FP39Milky20186selene6sprite12parse__color(color), align: align, baseline: baseline };
}
function _M0FP39Milky20186selene6sprite12render__text(text, position) {
  _M0FP39Milky20186selene7backend10draw__text({ text: text.content, position: position, style: _M0FP39Milky20186selene6sprite18parse__text__style(text.font, text.color, text.align, text.baseline) });
}
function _M0FP39Milky20186selene6sprite22render__sprite__system(delta) {
  const _p = _M0MP311moonbitlang4core7builtin3Map9to__arrayGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites);
  const _p$2 = [];
  const _p$3 = _p.length;
  let _tmp = 0;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$3) {
      const _p$5 = _p[_p$4];
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_p$5._0)) {
        _M0MP311moonbitlang4core5array5Array4pushGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(_p$2, _p$5);
      }
      _tmp = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const sprites = _p$2;
  _M0MP311moonbitlang4core5array5Array8sort__byGURP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteEE(sprites, (sprite1, sprite2) => {
    if (sprite1._1.zindex < sprite2._1.zindex) {
      return -1;
    } else {
      if (sprite1._1.zindex > sprite2._1.zindex) {
        return 1;
      } else {
        const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, sprite1._0);
        if (_bind$8 === undefined) {
          return 0;
        } else {
          const _Some = _bind$8;
          const _pos1 = _Some;
          const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, sprite2._0);
          if (_bind$9 === undefined) {
            return 0;
          } else {
            const _Some$2 = _bind$9;
            const _pos2 = _Some$2;
            return _M0MP39Milky20186selene4math5Vec2D7op__get(_pos1, 1) < _M0MP39Milky20186selene4math5Vec2D7op__get(_pos2, 1) ? -1 : _M0MP39Milky20186selene4math5Vec2D7op__get(_pos1, 1) > _M0MP39Milky20186selene4math5Vec2D7op__get(_pos2, 1) ? 1 : 0;
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
        const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, e);
        if (_bind$8 === undefined) {
          break _L;
        } else {
          const _Some = _bind$8;
          const _pos = _Some;
          const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(_M0FP39Milky20186selene2ui3uis, e);
          let pos;
          if (_bind$9 === -1) {
            const _p$4 = _M0FP39Milky20186selene6camera6camera.position;
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
                _M0FP39Milky20186selene6sprite15render__picture(_picture, { _0: pos._0 + _p$4._0, _1: pos._1 + _p$4._1 });
              }
              break;
            }
            case 1: {
              const _Animation = _bind$10;
              const _anime = _Animation._0;
              const _frame = _Animation._1;
              const _p$4 = sprite$2.offset;
              const new_frame = _M0FP39Milky20186selene6sprite17render__animation(_anime, _frame, { _0: pos._0 + _p$4._0, _1: pos._1 + _p$4._1 }, sprite$2.visible, delta);
              _Animation._1 = new_frame;
              break;
            }
            case 2: {
              const _Text = _bind$10;
              const _text = _Text._0;
              if (sprite$2.visible) {
                const _p$5 = sprite$2.offset;
                _M0FP39Milky20186selene6sprite12render__text(_text, { _0: pos._0 + _p$5._0, _1: pos._1 + _p$5._1 });
              }
              break;
            }
            case 3: {
              const _ColorRect = _bind$10;
              const _color_rect = _ColorRect._0;
              if (sprite$2.visible) {
                const _p$5 = sprite$2.offset;
                _M0FP39Milky20186selene6sprite19render__color__rect(_color_rect, { _0: pos._0 + _p$5._0, _1: pos._1 + _p$5._1 });
              }
              break;
            }
            default: {
              const _ColorCircle = _bind$10;
              const _color_circle = _ColorCircle._0;
              if (sprite$2.visible) {
                const _p$5 = sprite$2.offset;
                _M0FP39Milky20186selene6sprite21render__color__circle(_color_circle, { _0: pos._0 + _p$5._0, _1: pos._1 + _p$5._1 });
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
function _M0MP39Milky20186selene6sprite4Text11new_2einner(content, color, font, baseline, align) {
  return { content: content, color: color, font: font, baseline: baseline, align: align };
}
function _M0MP39Milky20186selene6sprite4Text3new(content, color$46$opt, font$46$opt, baseline$46$opt, align$46$opt) {
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
  return _M0MP39Milky20186selene6sprite4Text11new_2einner(content, color, font, baseline, align);
}
function _M0MP39Milky20186selene6sprite9ColorRect11new_2einner(size, color, stroke_color) {
  return { size: size, color: color, stroke_color: stroke_color };
}
function _M0MP39Milky20186selene6sprite7Picture11new_2einner(size, tile_path, transform, repeat) {
  return { size: size, tile_path: tile_path, transform: transform, repeat: repeat };
}
function _M0MP39Milky20186selene6sprite7Picture3new(size, tile_path, transform$46$opt, repeat$46$opt) {
  let transform;
  if (transform$46$opt === undefined) {
    transform = _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0);
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
  return _M0MP39Milky20186selene6sprite7Picture11new_2einner(size, tile_path, transform, repeat);
}
function _M0FP39Milky20186selene6sprite19generate__animation() {
  const id = _M0FP39Milky20186selene6sprite20animation__generator.val;
  _M0FP39Milky20186selene6sprite20animation__generator.val = _M0FP39Milky20186selene6sprite20animation__generator.val + 1 | 0;
  return id;
}
function _M0MP39Milky20186selene6sprite9Animation11new_2einner(frames, loop_, fps, transform) {
  const max_frame = frames.length;
  if (max_frame === 0) {
    _M0FP311moonbitlang4core7builtin5abortGuE("Animation must have at least one frame", "@Milky2018/selene/sprite:animation.mbt:136:5-136:52");
  }
  return { frames: frames, transform: transform, loop_: loop_, fps: fps, id: _M0FP39Milky20186selene6sprite19generate__animation() };
}
function _M0MP39Milky20186selene6sprite9Animation3new(frames, loop_$46$opt, fps$46$opt, transform$46$opt) {
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
    transform = _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0);
  } else {
    const _Some = transform$46$opt;
    transform = _Some;
  }
  return _M0MP39Milky20186selene6sprite9Animation11new_2einner(frames, loop_, fps, transform);
}
function _M0MP39Milky20186selene6sprite9Animation21single__frame_2einner(sprite_path, size, transform, offset) {
  return _M0MP39Milky20186selene6sprite9Animation11new_2einner([{ sprite_path: sprite_path, size: size, offset: offset }], false, 0, transform);
}
function _M0MP39Milky20186selene6sprite9Animation13single__frame(sprite_path, size, transform$46$opt, offset$46$opt) {
  let transform;
  if (transform$46$opt === undefined) {
    transform = _M0MP39Milky20186selene4math9Transform11new_2einner(1, 0, 0, 1, 0, 0);
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
  return _M0MP39Milky20186selene6sprite9Animation21single__frame_2einner(sprite_path, size, transform, offset);
}
function _M0FP39Milky20186selene6sprite27frames__from__atlas_2einner(sprite_path, frame_count, width, height, offset, space_x) {
  const frames = [];
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < frame_count) {
      const x = _M0MP39Milky20186selene4math5Vec2D7op__get(offset, 0) + (i + 0) * (width + space_x);
      _M0MP311moonbitlang4core5array5Array4pushGRP39Milky20186selene6sprite14AnimationFrameE(frames, { sprite_path: sprite_path, size: { _0: width, _1: height }, offset: _M0MP39Milky20186selene4math5Vec2D6update(offset, 0, x) });
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return frames;
}
function _M0FP39Milky20186selene6sprite23play__animation_2einner(entity, animation, from_start, loop_, rate, transform) {
  _L: {
    const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, entity);
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
        const rate$2 = _M0MP311moonbitlang4core6option6Option10unwrap__orGdE(rate, animation.fps);
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
        _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, entity, { sprite_type: new $64$Milky2018$47$selene$47$sprite$46$SpriteType$Animation(new_anime, frame), zindex: _zindex, visible: _visible, offset: _offset });
        return;
      } else {
        break _L;
      }
    }
  }
  $panic();
}
function _M0FP39Milky20186selene5style11get__zindex(entity) {
  return _M0MP311moonbitlang4core6option6Option7map__orGRP39Milky20186selene6sprite6SpriteiE(_M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, entity), 100, (s) => s.zindex);
}
function _M0MP39Milky20186selene5style5Style11new_2einner(size_plan, flex, h_padding, v_padding, h_offset, v_offset) {
  return { size_plan: size_plan, flex: flex, h_padding: h_padding, v_padding: v_padding, h_offset: h_offset, v_offset: v_offset };
}
function _M0FP39Milky20186selene5style19add__widget_2einner(parent, sprite, on_just_pressed, shape, size_plan, flex, h_padding, v_padding, h_offset, v_offset) {
  const child = _M0MP39Milky20186selene6entity6Entity12spawn__child(parent, undefined);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene2ui2UiE(_M0FP39Milky20186selene2ui3uis, child, _M0MP39Milky20186selene2ui2Ui3new());
  const style = _M0MP39Milky20186selene5style5Style11new_2einner(size_plan, flex, h_padding, v_padding, h_offset, v_offset);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(_M0FP39Milky20186selene5style6styles, child, style);
  if (sprite === undefined) {
  } else {
    const _Some = sprite;
    const _sprite_maker = _Some;
    const zindex = _M0FP39Milky20186selene5style11get__zindex(parent) + 1 | 0;
    const sprite$2 = _sprite_maker(zindex);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, child, sprite$2);
  }
  if (shape === undefined) {
  } else {
    const _Some = shape;
    const _shape = _Some;
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, child, _shape);
  }
  if (on_just_pressed === undefined) {
  } else {
    const _Some = on_just_pressed;
    const _button_cb = _Some;
    const pickable = _M0MP39Milky20186selene9collision8Pickable3new();
    _M0MP39Milky20186selene9collision8Pickable17on__just__pressed(pickable, _button_cb);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8PickableE(_M0FP39Milky20186selene9collision9pickables, child, pickable);
  }
  return child;
}
function _M0FP39Milky20186selene5style11add__widget(parent, sprite, on_just_pressed, shape, size_plan$46$opt, flex$46$opt, h_padding$46$opt, v_padding$46$opt, h_offset$46$opt, v_offset$46$opt) {
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
  return _M0FP39Milky20186selene5style19add__widget_2einner(parent, sprite, on_just_pressed, shape, size_plan, flex, h_padding, v_padding, h_offset, v_offset);
}
function _M0FP39Milky20186selene5style7arrange(entity, offset) {
  const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene5style5StyleE(_M0FP39Milky20186selene5style6styles, entity);
  if (_bind$8 === undefined) {
    return { _0: 0, _1: 0 };
  } else {
    const _Some = _bind$8;
    const _style = _Some;
    if (_M0MP39Milky20186selene6entity6Entity9is__child(entity)) {
      const _p = { _0: _style.h_offset, _1: _style.v_offset };
      _M0MP39Milky20186selene6entity6Entity11set__offset(entity, { _0: offset._0 + _p._0, _1: offset._1 + _p._1 });
    }
    const children = _M0MP39Milky20186selene6entity6Entity13get__children(entity);
    let cursor = { _0: _style.h_padding, _1: _style.v_padding };
    let max_width = 0;
    let max_height = 0;
    const _len = children.length;
    let _tmp = 0;
    while (true) {
      const _i = _tmp;
      if (_i < _len) {
        const c = children[_i];
        const size = _M0FP39Milky20186selene5style7arrange(c, cursor);
        const _bind$9 = _style.flex;
        let _tmp$2;
        switch (_bind$9) {
          case 1: {
            _tmp$2 = _M0MP39Milky20186selene4math5Vec2D6update(cursor, 0, _M0MP39Milky20186selene4math5Vec2D7op__get(cursor, 0) + _M0MP39Milky20186selene4math5Vec2D7op__get(size, 0) + _style.h_padding);
            break;
          }
          case 0: {
            _tmp$2 = cursor;
            break;
          }
          default: {
            _tmp$2 = _M0MP39Milky20186selene4math5Vec2D6update(cursor, 1, _M0MP39Milky20186selene4math5Vec2D7op__get(cursor, 1) + _M0MP39Milky20186selene4math5Vec2D7op__get(size, 1) + _style.v_padding);
          }
        }
        cursor = _tmp$2;
        const _p = max_width;
        const _p$2 = _M0MP39Milky20186selene4math5Vec2D7op__get(size, 0);
        max_width = _p > _p$2 ? _p : _p$2;
        const _p$3 = max_height;
        const _p$4 = _M0MP39Milky20186selene4math5Vec2D7op__get(size, 1);
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
        const _bind$10 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, entity);
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
              return _M0MP39Milky20186selene4math9Transform16apply__to__vec2d(_picture.transform, _picture.size);
            }
            case 2: {
              return { _0: 48, _1: 24 };
            }
            case 1: {
              const _Animation = _bind$11;
              const _anime = _Animation._0;
              return _M0MP39Milky20186selene4math9Transform16apply__to__vec2d(_anime.transform, _M0MP311moonbitlang4core5array5Array2atGRP39Milky20186selene6sprite14AnimationFrameE(_anime.frames, 0).size);
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
        const _bind$11 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, entity);
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
function _M0FP39Milky20186selene5style13style__system(_delta) {
  const _it = _M0FP39Milky20186selene6entity10get__roots();
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin4Iter4nextGRP39Milky20186selene6entity6EntityE(_it);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _e = _Some;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        _M0FP39Milky20186selene5style7arrange(_e, { _0: 0, _1: 0 });
      } else {
        continue;
      }
      continue;
    }
  }
}
function _M0FP39Milky20186selene7plugins15default__plugin(app) {
  const _self = app.systems;
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene9collision12move__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Move System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene6inputs21advanced__key__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Advanced Key System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene6inputs23advanced__mouse__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Advanced Mouse System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene9collision23quadtree__clear__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Quadtree Clear System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene9collision23pickable__click__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Pickable Click System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene9collision21area__collide__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Area Collide System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene6system23deferred__event__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Deferred Event System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene6sprite22render__sprite__system, _1: _M0FP39Milky20186selene7plugins31default__plugin_2econstr_2f4556, _2: "Render Sprite System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene6camera14camera__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Camera System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene6system13timer__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Timer System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene6system23realtime__timer__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Realtime Timer System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene7inherit25inherit__position__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Inherit Position System" });
  _M0MP311moonbitlang4core5array5Array4pushGUWdEuRP39Milky20186selene6system8SchedulesEE(_self, { _0: _M0FP39Milky20186selene5style13style__system, _1: $64$Milky2018$47$selene$47$system$46$Schedule$Update, _2: "Style System" });
}
function _M0IP39Milky201817selene_2dexamples9survivors9EnemyTypeP311moonbitlang4core7builtin2Eq5equal(_x_326, _x_327) {
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
function _M0IP39Milky201817selene_2dexamples9survivors9EnemyTypeP311moonbitlang4core7builtin4Hash13hash__combine(_x_322, _x_323) {
  switch (_x_322) {
    case 0: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_323, 0);
      return;
    }
    case 1: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_323, 1);
      return;
    }
    case 2: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_323, 2);
      return;
    }
    case 3: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_323, 3);
      return;
    }
    case 4: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_323, 4);
      return;
    }
    case 5: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_323, 5);
      return;
    }
    default: {
      _M0MP311moonbitlang4core7builtin6Hasher12combine__int(_x_323, 6);
      return;
    }
  }
}
function _M0IP39Milky201817selene_2dexamples9survivors11PowerupTypeP311moonbitlang4core7builtin2Eq5equal(_x_318, _x_319) {
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
function _M0FP39Milky201817selene_2dexamples9survivors17get__weapon__data(weapon_type) {
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
function _M0FP39Milky201817selene_2dexamples9survivors28get__weapon__speed__modifier(weapon_type) {
  const weapon_data = _M0FP39Milky201817selene_2dexamples9survivors17get__weapon__data(weapon_type);
  return weapon_data.speed_modifier;
}
function _M0FP39Milky201817selene_2dexamples9survivors36get__weapon__attack__speed__modifier(weapon_type) {
  const weapon_data = _M0FP39Milky201817selene_2dexamples9survivors17get__weapon__data(weapon_type);
  return weapon_data.attack_speed_modifier;
}
function _M0FP39Milky201817selene_2dexamples9survivors17get__weapon__name(weapon_type) {
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
function _M0FP39Milky201817selene_2dexamples9survivors17get__weapon__icon(weapon_type) {
  switch (weapon_type) {
    case 0: {
      return _M0FP39Milky201817selene_2dexamples9survivors20weapon__pistol__icon;
    }
    case 1: {
      return _M0FP39Milky201817selene_2dexamples9survivors21weapon__minigun__icon;
    }
    case 2: {
      return _M0FP39Milky201817selene_2dexamples9survivors25weapon__sniperrifle__icon;
    }
    default: {
      return _M0FP39Milky201817selene_2dexamples9survivors19weapon__sword__icon;
    }
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors19get__weapon__weight(weapon_type, level) {
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
function _M0FP39Milky201817selene_2dexamples9survivors25calculate__weapon__damage(weapon_data, attack) {
  const _func = weapon_data.damage_formula;
  return _func(weapon_data.base_damage, attack);
}
function _M0FP39Milky201817selene_2dexamples9survivors24calculate__weapon__range(weapon_data, range) {
  const _func = weapon_data.range_formula;
  return _func(weapon_data.base_range, range);
}
function _M0FP39Milky201817selene_2dexamples9survivors31find__nearest__enemy__in__range(player_pos, weapon_range) {
  let min = weapon_range;
  let res = undefined;
  const _it = _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_M0FP39Milky201817selene_2dexamples9survivors7enemies);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _e);
        if (_bind$9 === undefined) {
          $panic();
        } else {
          const _Some$2 = _bind$9;
          const _enemy_pos = _Some$2;
          const dist = _M0MP39Milky20186selene4math5Vec2D12distance__to(player_pos, _enemy_pos);
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
function _M0FP39Milky201817selene_2dexamples9survivors24xp__required__for__level(n) {
  return (Math.imul(n, ((Math.imul(Math.imul(2, n) | 0, n) | 0) + (Math.imul(21, n) | 0) | 0) + 73 | 0) | 0) / 6 | 0;
}
function _M0FP39Milky201817selene_2dexamples9survivors20get__level__from__xp(xp) {
  let level = 1;
  while (true) {
    if (xp >= _M0FP39Milky201817selene_2dexamples9survivors24xp__required__for__level(level)) {
      level = level + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return level;
}
function _M0FP39Milky201817selene_2dexamples9survivors15create__powerup(powerup_type) {
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
function _M0FP39Milky201817selene_2dexamples9survivors27weighted__random__selectionGRP39Milky201817selene_2dexamples9survivors11PowerupTypeE(items, weights) {
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
  const random_value = _M0MP311moonbitlang4core6random4Rand6double(_M0FP39Milky201817selene_2dexamples9survivors11game__state.rand) * total_weight;
  let cumulative = 0;
  const _end126 = items.length;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _end126) {
      cumulative = cumulative + _M0MP311moonbitlang4core5array5Array2atGdE(weights, i);
      if (random_value <= cumulative) {
        return _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors11PowerupTypeE(items, i);
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors11PowerupTypeE(items, items.length - 1 | 0);
}
function _M0FP39Milky201817selene_2dexamples9survivors27weighted__random__selectionGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(items, weights) {
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
  const random_value = _M0MP311moonbitlang4core6random4Rand6double(_M0FP39Milky201817selene_2dexamples9survivors11game__state.rand) * total_weight;
  let cumulative = 0;
  const _end126 = items.length;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _end126) {
      cumulative = cumulative + _M0MP311moonbitlang4core5array5Array2atGdE(weights, i);
      if (random_value <= cumulative) {
        return _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(items, i);
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(items, items.length - 1 | 0);
}
function _M0FP39Milky201817selene_2dexamples9survivors25select__weighted__powerup(level, already_selected) {
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
        _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors11PowerupTypeE(selected_types, _powerup.powerup_type);
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
          if (_M0IP39Milky201817selene_2dexamples9survivors11PowerupTypeP311moonbitlang4core7builtin2Eq5equal(powerup_type, selected_type)) {
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
        const powerup = _M0FP39Milky201817selene_2dexamples9survivors15create__powerup(powerup_type);
        const _func = powerup.weight_formula;
        const weight = _func(level);
        if (weight > 0) {
          _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors11PowerupTypeE(available_types, powerup_type);
          _M0MP311moonbitlang4core5array5Array4pushGdE(available_weights, weight);
        }
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$8 = _M0FP39Milky201817selene_2dexamples9survivors27weighted__random__selectionGRP39Milky201817selene_2dexamples9survivors11PowerupTypeE(available_types, available_weights);
  if (_bind$8 === undefined) {
    return undefined;
  } else {
    const _Some = _bind$8;
    const _powerup_type = _Some;
    return _M0FP39Milky201817selene_2dexamples9survivors15create__powerup(_powerup_type);
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors24select__weighted__weapon(level) {
  const all_weapons = [0, 1, 2, 3];
  const weights = [];
  const _len = all_weapons.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const weapon_type = all_weapons[_i];
      _M0MP311moonbitlang4core5array5Array4pushGdE(weights, _M0FP39Milky201817selene_2dexamples9survivors19get__weapon__weight(weapon_type, level));
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FP39Milky201817selene_2dexamples9survivors27weighted__random__selectionGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(all_weapons, weights);
}
function _M0FP39Milky201817selene_2dexamples9survivors27generate__mixed__selections(level) {
  const selected = [];
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < 2) {
      const _bind$8 = _M0FP39Milky201817selene_2dexamples9survivors25select__weighted__powerup(level, selected);
      if (_bind$8 === undefined) {
      } else {
        const _Some = _bind$8;
        const _powerup = _Some;
        _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors16LevelUpSelectionE(selected, new $64$Milky2018$47$selene$45$examples$47$survivors$46$LevelUpSelection$PowerupSelection(_powerup));
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$8 = _M0FP39Milky201817selene_2dexamples9survivors24select__weighted__weapon(level);
  if (_bind$8 === undefined) {
  } else {
    const _Some = _bind$8;
    const _weapon = _Some;
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors16LevelUpSelectionE(selected, new $64$Milky2018$47$selene$45$examples$47$survivors$46$LevelUpSelection$WeaponSelection(_weapon));
  }
  return selected;
}
function _M0FP39Milky201817selene_2dexamples9survivors29generate__powerup__selections(level) {
  const selected = [];
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < 3) {
      const _bind$8 = _M0FP39Milky201817selene_2dexamples9survivors25select__weighted__powerup(level, selected);
      if (_bind$8 === undefined) {
      } else {
        const _Some = _bind$8;
        const _powerup = _Some;
        _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors16LevelUpSelectionE(selected, new $64$Milky2018$47$selene$45$examples$47$survivors$46$LevelUpSelection$PowerupSelection(_powerup));
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return selected;
}
function _M0FP39Milky201817selene_2dexamples9survivors31generate__level__up__selections(level) {
  return (level % 5 | 0) === 0 ? _M0FP39Milky201817selene_2dexamples9survivors27generate__mixed__selections(level) : _M0FP39Milky201817selene_2dexamples9survivors29generate__powerup__selections(level);
}
function _M0FP39Milky201817selene_2dexamples9survivors18get__powerup__icon(powerup_type) {
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
              return _M0FP39Milky201817selene_2dexamples9survivors22powerup__bandana__icon;
            }
          }
        }
        return _M0FP39Milky201817selene_2dexamples9survivors21powerup__attack__icon;
      }
      return _M0FP39Milky201817selene_2dexamples9survivors20powerup__range__icon;
    }
    return _M0FP39Milky201817selene_2dexamples9survivors20powerup__speed__icon;
  }
  return _M0FP39Milky201817selene_2dexamples9survivors23powerup__cooldown__icon;
}
function _M0FP39Milky201817selene_2dexamples9survivors26update__selection__display(selection, button_entity) {
  const children = _M0MP39Milky20186selene6entity6Entity13get__children(button_entity);
  const icon_entity = _M0MP311moonbitlang4core5array5Array2atGRP39Milky20186selene6entity6EntityE(children, 0);
  const text_entity = _M0MP311moonbitlang4core5array5Array2atGRP39Milky20186selene6entity6EntityE(children, 1);
  if (selection.$tag === 0) {
    const _PowerupSelection = selection;
    const _powerup = _PowerupSelection._0;
    const button_background = _M0MP39Milky20186selene6sprite6Sprite17from__color__rect(_M0MP39Milky20186selene6sprite9ColorRect11new_2einner({ _0: 160, _1: 36 }, "rgba(13, 167, 170, 1)", "black"), 102, undefined);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, button_entity, button_background);
    const button_text = _M0MP39Milky20186selene6sprite4Text3new(_powerup.name, _M0FP39Milky201817selene_2dexamples9survivors42update__selection__display_2econstr_2f4751, _M0FP39Milky201817selene_2dexamples9survivors42update__selection__display_2econstr_2f4752, undefined, undefined);
    const button_sprite = _M0MP39Milky20186selene6sprite6Sprite10from__text(button_text, 103, undefined);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, text_entity, button_sprite);
    const icon_animation = _M0FP39Milky201817selene_2dexamples9survivors18get__powerup__icon(_powerup.powerup_type);
    const icon_sprite = _M0MP39Milky20186selene6sprite6Sprite15from__animation(icon_animation, 103, undefined);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, icon_entity, icon_sprite);
    return;
  } else {
    const _WeaponSelection = selection;
    const _weapon_type = _WeaponSelection._0;
    const button_background = _M0MP39Milky20186selene6sprite6Sprite17from__color__rect(_M0MP39Milky20186selene6sprite9ColorRect11new_2einner({ _0: 160, _1: 36 }, "rgba(255, 140, 0, 1)", "black"), 102, undefined);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, button_entity, button_background);
    const button_text = _M0MP39Milky20186selene6sprite4Text3new(_M0FP39Milky201817selene_2dexamples9survivors17get__weapon__name(_weapon_type), _M0FP39Milky201817selene_2dexamples9survivors42update__selection__display_2econstr_2f4753, _M0FP39Milky201817selene_2dexamples9survivors42update__selection__display_2econstr_2f4754, undefined, undefined);
    const button_sprite = _M0MP39Milky20186selene6sprite6Sprite10from__text(button_text, 103, undefined);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, text_entity, button_sprite);
    const icon_animation = _M0FP39Milky201817selene_2dexamples9survivors17get__weapon__icon(_weapon_type);
    const icon_sprite = _M0MP39Milky20186selene6sprite6Sprite15from__animation(icon_animation, 103, undefined);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, icon_entity, icon_sprite);
    return;
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors9level__up(level) {
  _M0FP39Milky20186selene7backend16set__time__scale(0);
  const panel = _M0FP39Milky201817selene_2dexamples9survivors11game__state.level_up_panel;
  panel.available_selections = _M0FP39Milky201817selene_2dexamples9survivors31generate__level__up__selections(level);
  _M0MP39Milky20186selene6entity6Entity7respawn(panel.panel_entity);
  const button_entities = _M0MP39Milky20186selene6entity6Entity13get__children(panel.panel_entity);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 3) {
      _M0FP39Milky201817selene_2dexamples9survivors26update__selection__display(_M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors16LevelUpSelectionE(panel.available_selections, i), _M0MP311moonbitlang4core5array5Array2atGRP39Milky20186selene6entity6EntityE(button_entities, i + 1 | 0));
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors24process__next__level__up() {
  const _bind$8 = _M0MP311moonbitlang4core5array5Array3popGiE(_M0FP39Milky201817selene_2dexamples9survivors11game__state.pending_level_ups);
  if (_bind$8 === undefined) {
    return;
  } else {
    const _Some = _bind$8;
    const _level = _Some;
    _M0FP39Milky201817selene_2dexamples9survivors9level__up(_level);
    return;
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors8add__exp(exp_gained) {
  const old_level = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_level;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.exp = _M0FP39Milky201817selene_2dexamples9survivors11game__state.exp + exp_gained | 0;
  const new_level = _M0FP39Milky201817selene_2dexamples9survivors20get__level__from__xp(_M0FP39Milky201817selene_2dexamples9survivors11game__state.exp);
  if (new_level > old_level) {
    let level = new_level;
    while (true) {
      if (level > old_level) {
        _M0MP311moonbitlang4core5array5Array4pushGiE(_M0FP39Milky201817selene_2dexamples9survivors11game__state.pending_level_ups, level);
        level = level - 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_level = new_level;
    _M0FP39Milky201817selene_2dexamples9survivors11game__state.level_box.content = `Level: ${_M0MP311moonbitlang4core3int3Int18to__string_2einner(_M0FP39Milky201817selene_2dexamples9survivors11game__state.player_level, 10)}`;
    _M0FP39Milky201817selene_2dexamples9survivors24process__next__level__up();
  }
  const current_level_xp = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_level === 1 ? 0 : _M0FP39Milky201817selene_2dexamples9survivors24xp__required__for__level(_M0FP39Milky201817selene_2dexamples9survivors11game__state.player_level - 1 | 0);
  const next_level_xp = _M0FP39Milky201817selene_2dexamples9survivors24xp__required__for__level(_M0FP39Milky201817selene_2dexamples9survivors11game__state.player_level);
  const progress_xp = _M0FP39Milky201817selene_2dexamples9survivors11game__state.exp - current_level_xp | 0;
  const needed_xp = next_level_xp - current_level_xp | 0;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.exp_box.content = `EXP: ${_M0MP311moonbitlang4core3int3Int18to__string_2einner(progress_xp, 10)}/${_M0MP311moonbitlang4core3int3Int18to__string_2einner(needed_xp, 10)}`;
}
function _M0FP39Milky201817selene_2dexamples9survivors16get__enemy__data(enemy_type) {
  const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky201817selene_2dexamples9survivors9EnemyTypeRP39Milky201817selene_2dexamples9survivors9EnemyDataE(_M0FP39Milky201817selene_2dexamples9survivors11enemy__data, enemy_type);
  if (_bind$8 === undefined) {
    return _M0FP311moonbitlang4core7builtin5abortGRP39Milky201817selene_2dexamples9survivors9EnemyDataE("Enemy data not found", "@Milky2018/selene-examples/survivors:enemy.mbt:355:13-355:42");
  } else {
    const _Some = _bind$8;
    return _Some;
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors10set__score(score) {
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.score = score;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_box.content = `Score: ${_M0MP311moonbitlang4core3int3Int18to__string_2einner(_M0FP39Milky201817selene_2dexamples9survivors11game__state.score, 10)}`;
}
function _M0FP39Milky201817selene_2dexamples9survivors21shoot__weapon__bullet(player_pos, target_pos, weapon_data, damage, total_penetration) {
  const bullet_entity = _M0MP39Milky20186selene6entity6Entity3new();
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, bullet_entity, _M0MP39Milky20186selene6sprite6Sprite17from__color__rect(_M0MP39Milky20186selene6sprite9ColorRect11new_2einner({ _0: 4, _1: 4 }, "white", "rgba(0, 0, 0, 0)"), 4, undefined));
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, bullet_entity, player_pos);
  const _p = _M0MP39Milky20186selene4math5Vec2D9normalize({ _0: target_pos._0 - player_pos._0, _1: target_pos._1 - player_pos._1 });
  const _p$2 = weapon_data.bullet_speed;
  const vel = { _0: _p._0 * _p$2, _1: _p._1 * _p$2 };
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene8velocity10velocities, bullet_entity, vel);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(_M0FP39Milky20186selene9collision17collision__layers, bullet_entity, _M0FP39Milky201817selene_2dexamples9survivors24bullet__collision__layer);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, bullet_entity, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 4, _1: 4 }, { _0: -2, _1: -2 }));
  const area = _M0MP39Milky20186selene9collision4Area3new([_M0FP39Milky201817selene_2dexamples9survivors23enemy__collision__layer, _M0FP39Milky201817selene_2dexamples9survivors22wall__collision__layer]);
  const bullet_alive = { val: true };
  const penetration_count = { val: 0 };
  _M0MP39Milky20186selene9collision4Area9on__enter(area, (enemy_entity) => {
    const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_M0FP39Milky201817selene_2dexamples9survivors7enemies, enemy_entity);
    if (_bind$8 === undefined) {
      bullet_alive.val = false;
      _M0MP39Milky20186selene6entity6Entity7destroy(bullet_entity);
      return;
    } else {
      const _Some = _bind$8;
      const _enemy = _Some;
      if (bullet_alive.val) {
        _enemy.health = _enemy.health - damage;
        penetration_count.val = penetration_count.val + 1 | 0;
        if (_enemy.health <= 0) {
          _M0MP39Milky20186selene6entity6Entity7destroy(enemy_entity);
          const data$2 = _M0FP39Milky201817selene_2dexamples9survivors16get__enemy__data(_enemy.enemy_type);
          _M0FP39Milky201817selene_2dexamples9survivors10set__score(_M0FP39Milky201817selene_2dexamples9survivors11game__state.score + data$2.points | 0);
          _M0FP39Milky201817selene_2dexamples9survivors8add__exp(data$2.points);
        }
        if (penetration_count.val >= total_penetration) {
          bullet_alive.val = false;
          _M0MP39Milky20186selene6entity6Entity7destroy(bullet_entity);
          return;
        } else {
          return;
        }
      } else {
        return;
      }
    }
  });
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(_M0FP39Milky20186selene9collision5areas, bullet_entity, area);
  const weapon_range = _M0FP39Milky201817selene_2dexamples9survivors24calculate__weapon__range(weapon_data, 0);
  const bullet_duration = weapon_range / weapon_data.bullet_speed;
  _M0FP39Milky20186selene6system15timeout_2einner(bullet_duration, () => {
    bullet_alive.val = false;
    _M0MP39Milky20186selene6entity6Entity7destroy(bullet_entity);
  }, true);
}
function _M0FP39Milky201817selene_2dexamples9survivors22update__weapon__timers(weapon_instances, delta, attack_speed, player_attack, player_range, player_penetration, player_pos) {
  while (true) {
    if (_M0FP39Milky201817selene_2dexamples9survivors14weapon__timers.length < weapon_instances.length) {
      _M0MP311moonbitlang4core5array5Array4pushGdE(_M0FP39Milky201817selene_2dexamples9survivors14weapon__timers, 0);
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
      const weapon_type = _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(weapon_instances, i);
      const weapon_data = _M0FP39Milky201817selene_2dexamples9survivors17get__weapon__data(weapon_type);
      if (_M0MP311moonbitlang4core5array5Array2atGdE(_M0FP39Milky201817selene_2dexamples9survivors14weapon__timers, i) > 0) {
        _M0MP311moonbitlang4core5array5Array3setGdE(_M0FP39Milky201817selene_2dexamples9survivors14weapon__timers, i, _M0MP311moonbitlang4core5array5Array2atGdE(_M0FP39Milky201817selene_2dexamples9survivors14weapon__timers, i) - delta);
      }
      if (_M0MP311moonbitlang4core5array5Array2atGdE(_M0FP39Milky201817selene_2dexamples9survivors14weapon__timers, i) <= 0) {
        if (attack_speed <= 0) {
          _M0MP311moonbitlang4core5array5Array3setGdE(_M0FP39Milky201817selene_2dexamples9survivors14weapon__timers, i, 999999);
        } else {
          _M0MP311moonbitlang4core5array5Array3setGdE(_M0FP39Milky201817selene_2dexamples9survivors14weapon__timers, i, weapon_data.cooldown_rate / attack_speed);
        }
        const weapon_range = _M0FP39Milky201817selene_2dexamples9survivors24calculate__weapon__range(weapon_data, player_range);
        const nearest_enemy_pos = _M0FP39Milky201817selene_2dexamples9survivors31find__nearest__enemy__in__range(player_pos, weapon_range);
        if (nearest_enemy_pos === undefined) {
        } else {
          const _Some = nearest_enemy_pos;
          const _enemy_pos = _Some;
          const weapon_damage = _M0FP39Milky201817selene_2dexamples9survivors25calculate__weapon__damage(weapon_data, player_attack);
          const total_penetration = weapon_data.penetration + player_penetration | 0;
          _M0FP39Milky201817selene_2dexamples9survivors21shoot__weapon__bullet(player_pos, _enemy_pos, weapon_data, weapon_damage, total_penetration);
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors15add__score__box() {
  _M0FP39Milky20186selene5style11add__widget(_M0FP39Milky20186selene5style12screen__root, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0FP39Milky201817selene_2dexamples9survivors11game__state.score_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors31add__score__box_2econstr_2f4831, _M0FP39Milky201817selene_2dexamples9survivors31add__score__box_2econstr_2f4832);
}
function _M0FP39Milky201817selene_2dexamples9survivors11add__weapon(weapon_type) {
  _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(_M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.weapon_instances, weapon_type);
  const speed_modifier = _M0FP39Milky201817selene_2dexamples9survivors28get__weapon__speed__modifier(weapon_type);
  const _bind$8 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
  _bind$8.speed = _bind$8.speed + speed_modifier;
  const attack_speed_modifier = _M0FP39Milky201817selene_2dexamples9survivors36get__weapon__attack__speed__modifier(weapon_type);
  const _bind$9 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
  _bind$9.attack_speed = _bind$9.attack_speed + attack_speed_modifier;
}
function _M0FP39Milky201817selene_2dexamples9survivors14apply__powerup(powerup) {
  const _bind$8 = powerup.powerup_type;
  switch (_bind$8) {
    case 0: {
      const _bind$9 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$9.attack = _bind$9.attack + 0.2;
      return;
    }
    case 1: {
      const _bind$10 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$10.attack = _bind$10.attack + 0.3;
      return;
    }
    case 2: {
      const _bind$11 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$11.attack = _bind$11.attack + 0.4;
      return;
    }
    case 3: {
      const _bind$12 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$12.range = _bind$12.range + 16;
      return;
    }
    case 4: {
      const _bind$13 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$13.range = _bind$13.range + 32;
      return;
    }
    case 5: {
      const _bind$14 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$14.speed = _bind$14.speed + 15;
      return;
    }
    case 6: {
      const _bind$15 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$15.speed = _bind$15.speed + 30;
      return;
    }
    case 7: {
      const _bind$16 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$16.attack_speed = _bind$16.attack_speed + 0.1;
      return;
    }
    case 8: {
      const _bind$17 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$17.attack_speed = _bind$17.attack_speed + 0.2;
      return;
    }
    default: {
      const _bind$18 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats;
      _bind$18.penetration = _bind$18.penetration + 1 | 0;
      return;
    }
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors16apply__selection(selection) {
  if (selection.$tag === 0) {
    const _PowerupSelection = selection;
    const _powerup = _PowerupSelection._0;
    _M0FP39Milky201817selene_2dexamples9survivors14apply__powerup(_powerup);
    return;
  } else {
    const _WeaponSelection = selection;
    const _weapon_type = _WeaponSelection._0;
    _M0FP39Milky201817selene_2dexamples9survivors11add__weapon(_weapon_type);
    return;
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors12resume__game() {
  _M0MP39Milky20186selene6entity6Entity7destroy(_M0FP39Milky201817selene_2dexamples9survivors11game__state.level_up_panel.panel_entity);
  const _p = _M0FP39Milky201817selene_2dexamples9survivors11game__state.pending_level_ups;
  if (_p.length === 0) {
    _M0FP39Milky20186selene7backend16set__time__scale(1);
    return;
  } else {
    _M0FP39Milky201817selene_2dexamples9survivors24process__next__level__up();
    return;
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors15select__powerup(index) {
  const panel = _M0FP39Milky201817selene_2dexamples9survivors11game__state.level_up_panel;
  if (index < panel.available_selections.length) {
    const selection = _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors16LevelUpSelectionE(panel.available_selections, index);
    _M0FP39Milky201817selene_2dexamples9survivors16apply__selection(selection);
  }
  _M0FP39Milky201817selene_2dexamples9survivors12resume__game();
}
function _M0FP39Milky201817selene_2dexamples9survivors20setup__level__up__ui() {
  const panel = _M0FP39Milky201817selene_2dexamples9survivors11game__state.level_up_panel.panel_entity;
  _M0FP39Milky20186selene5style11add__widget(panel, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0MP39Milky20186selene6sprite4Text11new_2einner("LEVEL UP!", "gold", "36px ThaleahFat", 0, 0), zindex, undefined), undefined, undefined, new $64$Milky2018$47$selene$47$style$46$SizePlan$Sized({ _0: 160, _1: 36 }), undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors36setup__level__up__ui_2econstr_2f4859, Option$None$0$);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 3) {
      const button = _M0FP39Milky20186selene5style19add__widget_2einner(panel, (zindex) => _M0MP39Milky20186selene6sprite6Sprite17from__color__rect(_M0MP39Milky20186selene6sprite9ColorRect11new_2einner({ _0: 160, _1: 36 }, "rgba(13, 167, 170, 1)", "black"), zindex, undefined), (_button) => {
        _M0FP39Milky201817selene_2dexamples9survivors15select__powerup(i);
      }, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 160, _1: 36 }, { _0: 0, _1: 0 }), $64$Milky2018$47$selene$47$style$46$SizePlan$FromSprite, 1, 2, 2, 0, 0);
      _M0FP39Milky20186selene5style11add__widget(button, (zindex) => _M0MP39Milky20186selene6sprite6Sprite15from__animation(_M0FP39Milky201817selene_2dexamples9survivors20powerup__range__icon, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Option$None$0$, Option$None$0$);
      _M0FP39Milky20186selene5style11add__widget(button, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0MP39Milky20186selene6sprite4Text3new("Default", _M0FP39Milky201817selene_2dexamples9survivors36setup__level__up__ui_2econstr_2f4860, _M0FP39Milky201817selene_2dexamples9survivors36setup__level__up__ui_2econstr_2f4861, undefined, undefined), zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, Option$None$0$, Option$None$0$);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP39Milky20186selene6entity6Entity7destroy(panel);
}
function _M0FP39Milky201817selene_2dexamples9survivors14add__wave__box() {
  _M0FP39Milky20186selene5style11add__widget(_M0FP39Milky20186selene5style12screen__root, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0FP39Milky201817selene_2dexamples9survivors11game__state.wave_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors30add__wave__box_2econstr_2f4871, _M0FP39Milky201817selene_2dexamples9survivors30add__wave__box_2econstr_2f4872);
}
function _M0FP39Milky201817selene_2dexamples9survivors13add__exp__box() {
  _M0FP39Milky20186selene5style11add__widget(_M0FP39Milky20186selene5style12screen__root, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0FP39Milky201817selene_2dexamples9survivors11game__state.exp_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors29add__exp__box_2econstr_2f4874, _M0FP39Milky201817selene_2dexamples9survivors29add__exp__box_2econstr_2f4875);
}
function _M0FP39Milky201817selene_2dexamples9survivors15add__timer__box() {
  _M0FP39Milky20186selene5style11add__widget(_M0FP39Milky20186selene5style12screen__root, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0FP39Milky201817selene_2dexamples9survivors11game__state.timer_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors31add__timer__box_2econstr_2f4877, _M0FP39Milky201817selene_2dexamples9survivors31add__timer__box_2econstr_2f4878);
}
function _M0FP39Milky201817selene_2dexamples9survivors18reset__wave__state() {
  _M0FP39Milky201817selene_2dexamples9survivors11wave__state.creeper_spawned = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11wave__state.icecream_spawned = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11wave__state.orc_spawned = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11wave__state.skull_spawned = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11wave__state.teleman_spawned = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11wave__state.devil_spawned = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11wave__state.pirate_spawned = 0;
}
function _M0FP39Milky201817selene_2dexamples9survivors13restart__game() {
  _M0MP39Milky20186selene6entity6Entity7destroy(_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over_panel.panel_entity);
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over = false;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over_displayed = false;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_timer = 600;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.current_wave = 1;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.wave_box.content = "Wave: 1";
  _M0FP39Milky201817selene_2dexamples9survivors10set__score(0);
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.exp = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_level = 1;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.level_box.content = "Level: 1";
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.exp_box.content = "EXP: 0/16";
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.invincible = false;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_blink_timer = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_is_red = false;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_box.color = "white";
  _M0MP311moonbitlang4core5array5Array5clearGiE(_M0FP39Milky201817selene_2dexamples9survivors11game__state.pending_level_ups);
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.attack = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.range = 0;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.speed = 150;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.attack_speed = 1;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.penetration = 0;
  _M0MP311moonbitlang4core5array5Array5clearGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(_M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.weapon_instances);
  _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors10WeaponTypeE(_M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.weapon_instances, 0);
  _M0MP311moonbitlang4core5array5Array5clearGdE(_M0FP39Milky201817selene_2dexamples9survivors14weapon__timers);
  const _it = _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_M0FP39Milky201817selene_2dexamples9survivors7enemies);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        _M0MP39Milky20186selene6entity6Entity7destroy(_e);
      }
      continue;
    }
  }
  _M0MP311moonbitlang4core7builtin3Map5clearGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_M0FP39Milky201817selene_2dexamples9survivors7enemies);
  _M0FP39Milky201817selene_2dexamples9survivors18reset__wave__state();
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_entity, { _0: 320, _1: 320 });
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene8velocity10velocities, _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_entity, { _0: 0, _1: 0 });
}
function _M0FP39Milky201817selene_2dexamples9survivors21setup__game__over__ui() {
  const panel = _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over_panel.panel_entity;
  _M0FP39Milky20186selene5style11add__widget(panel, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0MP39Milky20186selene6sprite4Text11new_2einner("VICTORY!", "gold", "32px ThaleahFat", 0, 0), zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4886, Option$None$0$);
  _M0FP39Milky20186selene5style11add__widget(panel, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4887, Option$None$0$);
  const restart_button = _M0FP39Milky20186selene5style11add__widget(panel, (zindex) => _M0MP39Milky20186selene6sprite6Sprite17from__color__rect(_M0MP39Milky20186selene6sprite9ColorRect11new_2einner({ _0: 180, _1: 40 }, "rgba(13, 167, 170, 1)", "white"), zindex, undefined), (_button) => {
    _M0FP39Milky201817selene_2dexamples9survivors13restart__game();
  }, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 180, _1: 40 }, { _0: 0, _1: 0 }), undefined, undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4888, Option$None$0$);
  _M0FP39Milky20186selene5style11add__widget(restart_button, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0MP39Milky20186selene6sprite4Text3new("RESTART", _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4889, _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4890, undefined, undefined), zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4891, _M0FP39Milky201817selene_2dexamples9survivors37setup__game__over__ui_2econstr_2f4892);
  _M0MP39Milky20186selene6entity6Entity7destroy(panel);
}
function _M0FP39Milky201817selene_2dexamples9survivors20add__game__over__box() {
  _M0MP39Milky20186selene6entity6Entity7respawn(_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over_panel.panel_entity);
}
function _M0FP39Milky201817selene_2dexamples9survivors15add__level__box() {
  _M0FP39Milky20186selene5style11add__widget(_M0FP39Milky20186selene5style12screen__root, (zindex) => _M0MP39Milky20186selene6sprite6Sprite10from__text(_M0FP39Milky201817selene_2dexamples9survivors11game__state.level_box, zindex, undefined), undefined, undefined, undefined, undefined, Option$None$0$, Option$None$0$, _M0FP39Milky201817selene_2dexamples9survivors31add__level__box_2econstr_2f4900, _M0FP39Milky201817selene_2dexamples9survivors31add__level__box_2econstr_2f4901);
}
function _M0FP39Milky201817selene_2dexamples9survivors11add__player() {
  const entity = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_entity;
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, entity, _M0MP39Milky20186selene6sprite6Sprite23from__animation_2einner(_M0FP39Milky201817selene_2dexamples9survivors30player__idle__right__animation, 3, { _0: -8, _1: -8 }));
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, entity, { _0: 320, _1: 320 });
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene8velocity10velocities, entity, { _0: 0, _1: 0 });
  _M0FP39Milky20186selene6camera14attach__entity(entity, { _0: 8, _1: 8 });
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(_M0FP39Milky20186selene9collision17collision__layers, entity, _M0FP39Milky201817selene_2dexamples9survivors24player__collision__layer);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(_M0FP39Milky20186selene9collision9colliders, entity, _M0MP39Milky20186selene9collision8Collider3new([_M0FP39Milky201817selene_2dexamples9survivors22wall__collision__layer]));
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, entity, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 16, _1: 16 }, { _0: -8, _1: -8 }));
}
function _M0FP39Milky201817selene_2dexamples9survivors22player__update__system(delta) {
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over || delta === 0) {
    return undefined;
  }
  const entity = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_entity;
  const speed = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.speed < 0 ? 0 : _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.speed;
  const _p = _M0MP39Milky20186selene4math5Vec2D9normalize(_M0FP39Milky20186selene6inputs11key__vector(22, 18, 0, 3));
  const vel = { _0: _p._0 * speed, _1: _p._1 * speed };
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene8velocity10velocities, entity, vel);
  if (_M0MP39Milky20186selene4math5Vec2D7op__get(vel, 0) > 0) {
    _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_direction = 3;
  } else {
    if (_M0MP39Milky20186selene4math5Vec2D7op__get(vel, 0) < 0) {
      _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_direction = 2;
    } else {
      if (_M0MP39Milky20186selene4math5Vec2D7op__get(vel, 1) > 0) {
        _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_direction = 1;
      } else {
        if (_M0MP39Milky20186selene4math5Vec2D7op__get(vel, 1) < 0) {
          _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_direction = 0;
        }
      }
    }
  }
  const _p$2 = { _0: 0, _1: 0 };
  const _bind$8 = vel._0 === _p$2._0 && vel._1 === _p$2._1;
  const _bind$9 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_direction;
  if (_bind$8 === true) {
    switch (_bind$9) {
      case 2: {
        _M0FP39Milky20186selene6sprite23play__animation_2einner(entity, _M0FP39Milky201817selene_2dexamples9survivors29player__idle__left__animation, false, -1, Option$None$0$, undefined);
        return;
      }
      case 3: {
        _M0FP39Milky20186selene6sprite23play__animation_2einner(entity, _M0FP39Milky201817selene_2dexamples9survivors30player__idle__right__animation, false, -1, Option$None$0$, undefined);
        return;
      }
      case 0: {
        _M0FP39Milky20186selene6sprite23play__animation_2einner(entity, _M0FP39Milky201817selene_2dexamples9survivors27player__idle__up__animation, false, -1, Option$None$0$, undefined);
        return;
      }
      default: {
        _M0FP39Milky20186selene6sprite23play__animation_2einner(entity, _M0FP39Milky201817selene_2dexamples9survivors29player__idle__down__animation, false, -1, Option$None$0$, undefined);
        return;
      }
    }
  } else {
    switch (_bind$9) {
      case 2: {
        _M0FP39Milky20186selene6sprite23play__animation_2einner(entity, _M0FP39Milky201817selene_2dexamples9survivors28player__run__left__animation, false, -1, Option$None$0$, undefined);
        return;
      }
      case 3: {
        _M0FP39Milky20186selene6sprite23play__animation_2einner(entity, _M0FP39Milky201817selene_2dexamples9survivors29player__run__right__animation, false, -1, Option$None$0$, undefined);
        return;
      }
      case 0: {
        _M0FP39Milky20186selene6sprite23play__animation_2einner(entity, _M0FP39Milky201817selene_2dexamples9survivors26player__run__up__animation, false, -1, Option$None$0$, undefined);
        return;
      }
      default: {
        _M0FP39Milky20186selene6sprite23play__animation_2einner(entity, _M0FP39Milky201817selene_2dexamples9survivors28player__run__down__animation, false, -1, Option$None$0$, undefined);
        return;
      }
    }
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors24player__shooting__system(delta) {
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over) {
    return undefined;
  }
  const _bind$8 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_entity);
  if (_bind$8 === undefined) {
    $panic();
    return;
  } else {
    const _Some = _bind$8;
    const _player_pos = _Some;
    const attack_speed = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.attack_speed < 0 ? 0 : _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.attack_speed;
    const attack = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.attack < 0 ? 0 : _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.attack;
    const range = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.range < 0 ? 0 : _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.range;
    const penetration = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.penetration < 0 ? 0 : _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.penetration;
    _M0FP39Milky201817selene_2dexamples9survivors22update__weapon__timers(_M0FP39Milky201817selene_2dexamples9survivors11game__state.player_stats.weapon_instances, delta, attack_speed, attack, range, penetration, _player_pos);
    return;
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors15add__background(size) {
  const background = _M0MP39Milky20186selene6entity6Entity3new();
  const background_sprite = _M0MP39Milky20186selene6sprite6Sprite13from__picture(_M0MP39Milky20186selene6sprite7Picture3new(size, _M0FP39Milky201817selene_2dexamples9survivors19background__picture, undefined, _M0FP39Milky201817selene_2dexamples9survivors31add__background_2econstr_2f4918), 0, undefined);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, background, background_sprite);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, background, { _0: 0, _1: 0 });
}
function _M0FP39Milky201817selene_2dexamples9survivors36add__border_2eadd__one__border_7c163(pos, size) {
  const entity = _M0MP39Milky20186selene6entity6Entity3new();
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(_M0FP39Milky20186selene9collision17collision__layers, entity, _M0FP39Milky201817selene_2dexamples9survivors22wall__collision__layer);
  const collider = _M0MP39Milky20186selene9collision8Collider3new([]);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(_M0FP39Milky20186selene9collision9colliders, entity, collider);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, entity, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect(size, { _0: 0, _1: 0 }));
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, entity, pos);
}
function _M0FP39Milky201817selene_2dexamples9survivors11add__border(size) {
  _M0FP39Milky201817selene_2dexamples9survivors36add__border_2eadd__one__border_7c163({ _0: -16, _1: -16 }, { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(size, 0) + 32, _1: 16 });
  _M0FP39Milky201817selene_2dexamples9survivors36add__border_2eadd__one__border_7c163({ _0: -16, _1: 0 }, { _0: 16, _1: _M0MP39Milky20186selene4math5Vec2D7op__get(size, 1) });
  _M0FP39Milky201817selene_2dexamples9survivors36add__border_2eadd__one__border_7c163({ _0: -16, _1: _M0MP39Milky20186selene4math5Vec2D7op__get(size, 1) }, { _0: _M0MP39Milky20186selene4math5Vec2D7op__get(size, 0) + 32, _1: 16 });
  _M0FP39Milky201817selene_2dexamples9survivors36add__border_2eadd__one__border_7c163({ _0: _M0MP39Milky20186selene4math5Vec2D7op__get(size, 0), _1: 0 }, { _0: 16, _1: _M0MP39Milky20186selene4math5Vec2D7op__get(size, 1) });
}
function _M0FP39Milky201817selene_2dexamples9survivors10add__grass() {
  const rand = _M0MP311moonbitlang4core6random4Rand3new(Option$None$1$);
  const _end151 = _M0MP311moonbitlang4core6double6Double7to__int(40);
  let _tmp = 0;
  while (true) {
    const x = _tmp;
    if (x < _end151) {
      const _end156 = _M0MP311moonbitlang4core6double6Double7to__int(40);
      let _tmp$2 = 0;
      while (true) {
        const y = _tmp$2;
        if (y < _end156) {
          if (_M0MP311moonbitlang4core6random4Rand6double(rand) < 0.05) {
            const grass = _M0MP39Milky20186selene6entity6Entity3new();
            const sprite = _M0MP39Milky20186selene6sprite6Sprite15from__animation(_M0FP39Milky201817selene_2dexamples9survivors13grass__sprite, 1, undefined);
            _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, grass, sprite);
            _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, grass, { _0: (x + 0) * 16, _1: (y + 0) * 16 });
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
function _M0FP39Milky201817selene_2dexamples9survivors22check__victory__system(_delta) {
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over) {
    return undefined;
  }
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_timer > 0) {
    return undefined;
  }
  let alive_count = 0;
  const _it = _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_M0FP39Milky201817selene_2dexamples9survivors7enemies);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_it);
    if (_bind$8 === undefined) {
      break;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        alive_count = alive_count + 1 | 0;
      }
      continue;
    }
  }
  if (alive_count === 0) {
    _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over = true;
    return;
  } else {
    return;
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors23trigger__damage__effect() {
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_blink_timer = 1;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_is_red = true;
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_box.color = "red";
}
function _M0FP39Milky201817selene_2dexamples9survivors20shoot__enemy__bullet(enemy_pos, player_pos) {
  const bullet_entity = _M0MP39Milky20186selene6entity6Entity3new();
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, bullet_entity, _M0MP39Milky20186selene6sprite6Sprite17from__color__rect(_M0MP39Milky20186selene6sprite9ColorRect11new_2einner({ _0: 4, _1: 4 }, "red", "rgba(0, 0, 0, 0)"), 4, undefined));
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, bullet_entity, enemy_pos);
  const _p = _M0MP39Milky20186selene4math5Vec2D9normalize({ _0: player_pos._0 - enemy_pos._0, _1: player_pos._1 - enemy_pos._1 });
  const _p$2 = 120;
  const vel = { _0: _p._0 * _p$2, _1: _p._1 * _p$2 };
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene8velocity10velocities, bullet_entity, vel);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(_M0FP39Milky20186selene9collision17collision__layers, bullet_entity, _M0FP39Milky201817selene_2dexamples9survivors29enemybullet__collision__layer);
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, bullet_entity, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 4, _1: 4 }, { _0: -2, _1: -2 }));
  const area = _M0MP39Milky20186selene9collision4Area3new([_M0FP39Milky201817selene_2dexamples9survivors24player__collision__layer, _M0FP39Milky201817selene_2dexamples9survivors22wall__collision__layer]);
  const bullet_alive = { val: true };
  _M0MP39Milky20186selene9collision4Area9on__enter(area, (hit_entity) => {
    if (bullet_alive.val) {
      const _p$3 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_entity;
      if (hit_entity === _p$3) {
        if (!_M0FP39Milky201817selene_2dexamples9survivors11game__state.invincible) {
          _M0FP39Milky201817selene_2dexamples9survivors11game__state.invincible = true;
          const penalty = Math.imul(250, _M0FP39Milky201817selene_2dexamples9survivors11game__state.current_wave) | 0;
          const _p$4 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.score - penalty | 0;
          const _p$5 = 0;
          const new_score = _p$4 > _p$5 ? _p$4 : _p$5;
          _M0FP39Milky201817selene_2dexamples9survivors10set__score(new_score);
          _M0FP39Milky201817selene_2dexamples9survivors23trigger__damage__effect();
          _M0FP39Milky20186selene6system15timeout_2einner(1, () => {
            _M0FP39Milky201817selene_2dexamples9survivors11game__state.invincible = false;
          }, true);
        }
      }
      bullet_alive.val = false;
      _M0MP39Milky20186selene6entity6Entity7destroy(bullet_entity);
      return;
    } else {
      return;
    }
  });
  _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(_M0FP39Milky20186selene9collision5areas, bullet_entity, area);
}
function _M0FP39Milky201817selene_2dexamples9survivors23devil__shooting__system(delta) {
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over) {
    return undefined;
  }
  const _it = _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_M0FP39Milky201817selene_2dexamples9survivors7enemies);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_it);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      const _state = _x._1;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        if (_M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(_state.enemy_type, 5)) {
          continue;
        }
        const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _e);
        if (_bind$9 === undefined) {
          $panic();
        } else {
          const _Some$2 = _bind$9;
          const _enemy_pos = _Some$2;
          const _bind$10 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_entity);
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
              _M0FP39Milky201817selene_2dexamples9survivors20shoot__enemy__bullet(_enemy_pos, _player_pos);
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
function _M0FP39Milky201817selene_2dexamples9survivors17enemy__ai__system(_delta) {
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over) {
    return undefined;
  }
  const _it = _M0MP311moonbitlang4core7builtin3Map5iter2GRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_M0FP39Milky201817selene_2dexamples9survivors7enemies);
  while (true) {
    const _bind$8 = _M0MP311moonbitlang4core7builtin5Iter24nextGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_it);
    if (_bind$8 === undefined) {
      return;
    } else {
      const _Some = _bind$8;
      const _x = _Some;
      const _e = _x._0;
      const _state = _x._1;
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(_e)) {
        const _bind$9 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_entity);
        if (_bind$9 === undefined) {
          $panic();
        } else {
          const _Some$2 = _bind$9;
          const _player_position = _Some$2;
          const _bind$10 = _M0MP311moonbitlang4core7builtin3Map3getGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, _e);
          if (_bind$10 === undefined) {
            $panic();
          } else {
            const _Some$3 = _bind$10;
            const _position = _Some$3;
            const data$2 = _M0FP39Milky201817selene_2dexamples9survivors16get__enemy__data(_state.enemy_type);
            const dir = { _0: _player_position._0 - _position._0, _1: _player_position._1 - _position._1 };
            const _p = _M0MP39Milky20186selene4math5Vec2D9normalize(dir);
            const _p$2 = _state.speed;
            const vel = { _0: _p._0 * _p$2, _1: _p._1 * _p$2 };
            _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene8velocity10velocities, _e, vel);
            if (_M0MP39Milky20186selene4math5Vec2D7op__get(vel, 0) >= 0) {
              _M0FP39Milky20186selene6sprite23play__animation_2einner(_e, data$2.right_animation, false, -1, Option$None$0$, undefined);
            } else {
              _M0FP39Milky20186selene6sprite23play__animation_2einner(_e, data$2.left_animation, false, -1, Option$None$0$, undefined);
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
function _M0FP39Milky201817selene_2dexamples9survivors11game__start(_delta) {
  _M0FP39Milky20186selene7backend10load__font("ThaleahFat", "assets/fonts/ThaleahFat.ttf");
  _M0FP39Milky20186selene6camera11set__limits(_M0FP39Milky201817selene_2dexamples9survivors27game__start_2econstr_2f4984, _M0FP39Milky201817selene_2dexamples9survivors27game__start_2econstr_2f4985, _M0FP39Milky201817selene_2dexamples9survivors27game__start_2econstr_2f4986, _M0FP39Milky201817selene_2dexamples9survivors27game__start_2econstr_2f4987);
  _M0FP39Milky201817selene_2dexamples9survivors11add__player();
  _M0FP39Milky201817selene_2dexamples9survivors11add__border({ _0: 640, _1: 640 });
  _M0FP39Milky201817selene_2dexamples9survivors15add__background({ _0: 640, _1: 640 });
  _M0FP39Milky201817selene_2dexamples9survivors10add__grass();
  _M0FP39Milky201817selene_2dexamples9survivors15add__score__box();
  _M0FP39Milky201817selene_2dexamples9survivors15add__timer__box();
  _M0FP39Milky201817selene_2dexamples9survivors14add__wave__box();
  _M0FP39Milky201817selene_2dexamples9survivors15add__level__box();
  _M0FP39Milky201817selene_2dexamples9survivors13add__exp__box();
  _M0FP39Milky201817selene_2dexamples9survivors20setup__level__up__ui();
  _M0FP39Milky201817selene_2dexamples9survivors21setup__game__over__ui();
}
function _M0FP39Milky201817selene_2dexamples9survivors19game__timer__system(delta) {
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over) {
    if (!_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over_displayed) {
      _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over_displayed = true;
      _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over_box.content = `Final Score: ${_M0MP311moonbitlang4core3int3Int18to__string_2einner(_M0FP39Milky201817selene_2dexamples9survivors11game__state.score, 10)}`;
      _M0FP39Milky201817selene_2dexamples9survivors20add__game__over__box();
    }
    return undefined;
  }
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_timer > 0) {
    _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_timer = _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_timer - delta;
    if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_timer < 0) {
      _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_timer = 0;
    }
  }
  const elapsed_time = 600 - _M0FP39Milky201817selene_2dexamples9survivors11game__state.game_timer;
  let new_wave = _M0MP311moonbitlang4core6double6Double7to__int(elapsed_time / 60) + 1 | 0;
  if (new_wave > 10) {
    new_wave = 10;
  }
  if (new_wave !== _M0FP39Milky201817selene_2dexamples9survivors11game__state.current_wave) {
    _M0FP39Milky201817selene_2dexamples9survivors11game__state.current_wave = new_wave;
    _M0FP39Milky201817selene_2dexamples9survivors11game__state.wave_box.content = `Wave: ${_M0MP311moonbitlang4core3int3Int18to__string_2einner(_M0FP39Milky201817selene_2dexamples9survivors11game__state.current_wave, 10)}`;
    _M0FP39Milky201817selene_2dexamples9survivors18reset__wave__state();
  }
  const total_seconds = _M0MP311moonbitlang4core6double6Double7to__int(_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_timer);
  const minutes = total_seconds / 60 | 0;
  const seconds = total_seconds % 60 | 0;
  const seconds_str = seconds < 10 ? `0${_M0MP311moonbitlang4core3int3Int18to__string_2einner(seconds, 10)}` : _M0MP311moonbitlang4core3int3Int18to__string_2einner(seconds, 10);
  _M0FP39Milky201817selene_2dexamples9survivors11game__state.timer_box.content = `Time: ${_M0MP311moonbitlang4core3int3Int18to__string_2einner(minutes, 10)}:${seconds_str}`;
}
function _M0FP39Milky201817selene_2dexamples9survivors20score__blink__system(delta) {
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.score_blink_timer > 0) {
    _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_blink_timer = _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_blink_timer - delta;
    const elapsed = 1 - _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_blink_timer;
    const should_be_red = (_M0MP311moonbitlang4core6double6Double7to__int(elapsed / 0.1) % 2 | 0) === 0;
    const _p = _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_is_red;
    if (!(should_be_red === _p)) {
      _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_is_red = should_be_red;
      _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_box.color = should_be_red ? "red" : "white";
    }
    if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.score_blink_timer <= 0) {
      _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_blink_timer = 0;
      _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_is_red = false;
      _M0FP39Milky201817selene_2dexamples9survivors11game__state.score_box.color = "white";
      return;
    } else {
      return;
    }
  } else {
    return;
  }
}
function _M0FP39Milky201817selene_2dexamples9survivors30select__enemy__type__for__wave(rand) {
  const wave = _M0FP39Milky201817selene_2dexamples9survivors11game__state.current_wave;
  if (wave < 1 || wave > 10) {
    return undefined;
  }
  const plan = _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors13WaveSpawnPlanE(_M0FP39Milky201817selene_2dexamples9survivors18wave__spawn__plans, wave - 1 | 0);
  const available_types = [];
  if (_M0FP39Milky201817selene_2dexamples9survivors11wave__state.creeper_spawned < plan.creeper_count) {
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(available_types, 0);
  }
  if (_M0FP39Milky201817selene_2dexamples9survivors11wave__state.icecream_spawned < plan.icecream_count) {
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(available_types, 1);
  }
  if (_M0FP39Milky201817selene_2dexamples9survivors11wave__state.orc_spawned < plan.orc_count) {
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(available_types, 2);
  }
  if (_M0FP39Milky201817selene_2dexamples9survivors11wave__state.skull_spawned < plan.skull_count) {
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(available_types, 3);
  }
  if (_M0FP39Milky201817selene_2dexamples9survivors11wave__state.teleman_spawned < plan.teleman_count) {
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(available_types, 4);
  }
  if (_M0FP39Milky201817selene_2dexamples9survivors11wave__state.devil_spawned < plan.devil_count) {
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(available_types, 5);
  }
  if (_M0FP39Milky201817selene_2dexamples9survivors11wave__state.pirate_spawned < plan.pirate_count) {
    _M0MP311moonbitlang4core5array5Array4pushGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(available_types, 6);
  }
  if (available_types.length === 0) {
    return undefined;
  }
  const index = _M0MP311moonbitlang4core6random4Rand11int_2einner(rand, available_types.length);
  const enemy_type = _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors9EnemyTypeE(available_types, index);
  switch (enemy_type) {
    case 0: {
      _M0FP39Milky201817selene_2dexamples9survivors11wave__state.creeper_spawned = _M0FP39Milky201817selene_2dexamples9survivors11wave__state.creeper_spawned + 1 | 0;
      break;
    }
    case 1: {
      _M0FP39Milky201817selene_2dexamples9survivors11wave__state.icecream_spawned = _M0FP39Milky201817selene_2dexamples9survivors11wave__state.icecream_spawned + 1 | 0;
      break;
    }
    case 2: {
      _M0FP39Milky201817selene_2dexamples9survivors11wave__state.orc_spawned = _M0FP39Milky201817selene_2dexamples9survivors11wave__state.orc_spawned + 1 | 0;
      break;
    }
    case 3: {
      _M0FP39Milky201817selene_2dexamples9survivors11wave__state.skull_spawned = _M0FP39Milky201817selene_2dexamples9survivors11wave__state.skull_spawned + 1 | 0;
      break;
    }
    case 4: {
      _M0FP39Milky201817selene_2dexamples9survivors11wave__state.teleman_spawned = _M0FP39Milky201817selene_2dexamples9survivors11wave__state.teleman_spawned + 1 | 0;
      break;
    }
    case 5: {
      _M0FP39Milky201817selene_2dexamples9survivors11wave__state.devil_spawned = _M0FP39Milky201817selene_2dexamples9survivors11wave__state.devil_spawned + 1 | 0;
      break;
    }
    default: {
      _M0FP39Milky201817selene_2dexamples9survivors11wave__state.pirate_spawned = _M0FP39Milky201817selene_2dexamples9survivors11wave__state.pirate_spawned + 1 | 0;
    }
  }
  return enemy_type;
}
function _M0FP39Milky201817selene_2dexamples9survivors40spawn__enemy__system_2espawn__enemy_7c36() {
  if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.game_over) {
    return undefined;
  }
  const rand = _M0FP39Milky201817selene_2dexamples9survivors11game__state.rand;
  const wave = _M0FP39Milky201817selene_2dexamples9survivors11game__state.current_wave;
  const spawn_interval = wave >= 1 && wave <= 10 ? _M0MP311moonbitlang4core5array5Array2atGRP39Milky201817selene_2dexamples9survivors13WaveSpawnPlanE(_M0FP39Milky201817selene_2dexamples9survivors18wave__spawn__plans, wave - 1 | 0).spawn_interval : 1;
  const _bind$8 = _M0FP39Milky201817selene_2dexamples9survivors30select__enemy__type__for__wave(rand);
  if (_bind$8 === undefined) {
  } else {
    const _Some = _bind$8;
    const _enemy_type = _Some;
    const enemy = _M0MP39Milky20186selene6entity6Entity3new();
    const pos = _M0MP311moonbitlang4core5array5Array2atGRP39Milky20186selene4math5Vec2DE(_M0FP39Milky201817selene_2dexamples9survivors8spawners, _M0MP311moonbitlang4core6random4Rand11int_2einner(rand, _M0FP39Milky201817selene_2dexamples9survivors8spawners.length));
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8position8PositionE(_M0FP39Milky20186selene8position9positions, enemy, pos);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene8velocity8VelocityE(_M0FP39Milky20186selene8velocity10velocities, enemy, { _0: 0, _1: 0 });
    const data$2 = _M0FP39Milky201817selene_2dexamples9survivors16get__enemy__data(_enemy_type);
    const sprite = _M0MP39Milky20186selene6sprite6Sprite23from__animation_2einner(data$2.right_animation, 2, { _0: -8, _1: -12 });
    const enemy_state = { enemy_type: _enemy_type, speed: data$2.speed, health: data$2.health, shoot_timer: 0 };
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene6sprite6SpriteE(_M0FP39Milky20186selene6sprite7sprites, enemy, sprite);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionShapeE(_M0FP39Milky20186selene9collision6shapes, enemy, new $64$Milky2018$47$selene$47$collision$46$CollisionShape$Rect({ _0: 8, _1: 8 }, { _0: -4, _1: -4 }));
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision14CollisionLayerE(_M0FP39Milky20186selene9collision17collision__layers, enemy, _M0FP39Milky201817selene_2dexamples9survivors23enemy__collision__layer);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision8ColliderE(_M0FP39Milky20186selene9collision9colliders, enemy, _M0MP39Milky20186selene9collision8Collider3new([_M0FP39Milky201817selene_2dexamples9survivors23enemy__collision__layer, _M0FP39Milky201817selene_2dexamples9survivors22wall__collision__layer]));
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky201817selene_2dexamples9survivors5EnemyE(_M0FP39Milky201817selene_2dexamples9survivors7enemies, enemy, enemy_state);
    const area = _M0MP39Milky20186selene9collision4Area3new([_M0FP39Milky201817selene_2dexamples9survivors24player__collision__layer]);
    _M0MP311moonbitlang4core7builtin3Map3setGRP39Milky20186selene6entity6EntityRP39Milky20186selene9collision4AreaE(_M0FP39Milky20186selene9collision5areas, enemy, area);
    _M0MP39Milky20186selene9collision4Area9on__enter(area, (e) => {
      if (_M0MP39Milky20186selene6entity6Entity9is__alive(e)) {
        const _p = _M0FP39Milky201817selene_2dexamples9survivors11game__state.player_entity;
        if (e === _p) {
          if (_M0FP39Milky201817selene_2dexamples9survivors11game__state.invincible) {
            return undefined;
          }
          _M0FP39Milky201817selene_2dexamples9survivors11game__state.invincible = true;
          const penalty = Math.imul(250, _M0FP39Milky201817selene_2dexamples9survivors11game__state.current_wave) | 0;
          const _p$2 = _M0FP39Milky201817selene_2dexamples9survivors11game__state.score - penalty | 0;
          const _p$3 = 0;
          const new_score = _p$2 > _p$3 ? _p$2 : _p$3;
          _M0FP39Milky201817selene_2dexamples9survivors10set__score(new_score);
          _M0FP39Milky201817selene_2dexamples9survivors23trigger__damage__effect();
          _M0FP39Milky20186selene6system15timeout_2einner(1, () => {
            _M0FP39Milky201817selene_2dexamples9survivors11game__state.invincible = false;
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
  _M0FP39Milky20186selene6system15timeout_2einner(spawn_interval, _M0FP39Milky201817selene_2dexamples9survivors40spawn__enemy__system_2espawn__enemy_7c36, true);
}
function _M0FP39Milky201817selene_2dexamples9survivors20spawn__enemy__system(_delta) {
  _M0FP39Milky201817selene_2dexamples9survivors40spawn__enemy__system_2espawn__enemy_7c36();
}
function _M0FP39Milky201817selene_2dexamples9survivors3run() {
  _M0MP39Milky20186selene6system3App3run(_M0MP39Milky20186selene6system3App11add__system(_M0MP39Milky20186selene6system3App11add__system(_M0MP39Milky20186selene6system3App11add__system(_M0MP39Milky20186selene6system3App11add__system(_M0MP39Milky20186selene6system3App11add__system(_M0MP39Milky20186selene6system3App11add__system(_M0MP39Milky20186selene6system3App11add__system(_M0MP39Milky20186selene6system3App19add__system_2einner(_M0MP39Milky20186selene6system3App19add__system_2einner(_M0MP39Milky20186selene6system3App11add__plugin(_M0MP39Milky20186selene6system3App9with__fps(_M0MP39Milky20186selene6system3App10with__zoom(_M0MP39Milky20186selene6system3App19with__image__smooth(_M0MP39Milky20186selene6system3App20with__canvas__height(_M0MP39Milky20186selene6system3App19with__canvas__width(_M0MP39Milky20186selene6system3App3new(), 960), 640), false), 2), _M0MP311moonbitlang4core6double6Double8to__uint(60)), _M0FP39Milky20186selene7plugins15default__plugin), _M0FP39Milky201817selene_2dexamples9survivors11game__start, $64$Milky2018$47$selene$47$system$46$Schedule$Startup, undefined), _M0FP39Milky201817selene_2dexamples9survivors20spawn__enemy__system, $64$Milky2018$47$selene$47$system$46$Schedule$Startup, undefined), _M0FP39Milky201817selene_2dexamples9survivors22player__update__system, undefined, undefined), _M0FP39Milky201817selene_2dexamples9survivors24player__shooting__system, undefined, undefined), _M0FP39Milky201817selene_2dexamples9survivors17enemy__ai__system, undefined, undefined), _M0FP39Milky201817selene_2dexamples9survivors23devil__shooting__system, undefined, undefined), _M0FP39Milky201817selene_2dexamples9survivors22check__victory__system, undefined, undefined), _M0FP39Milky201817selene_2dexamples9survivors19game__timer__system, undefined, undefined), _M0FP39Milky201817selene_2dexamples9survivors20score__blink__system, undefined, undefined));
}
(() => {
  _M0FP39Milky201817selene_2dexamples9survivors3run();
})();
