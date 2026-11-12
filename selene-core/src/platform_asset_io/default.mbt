///|
let reader : Ref[(String) -> Bytes?] = Ref(fn(_path : String) { None })

///|
pub fn set_reader(
  callback : (String) -> Bytes?,
  paths~ : Array[String] = [],
) -> Unit {
  reader.val = callback
  catalogue.val = paths.copy()
}

///|
pub fn read_bytes(path : String) -> Bytes? {
  (reader.val)(path)
}

///|
let catalogue : Ref[Array[String]] = Ref([])

///|
pub fn paths() -> Array[String] {
  catalogue.val.copy()
}
