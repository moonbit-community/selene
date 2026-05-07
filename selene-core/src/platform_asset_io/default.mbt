///|
let reader : Ref[(String) -> Bytes?] = Ref(fn(_path : String) { None })

///|
pub fn set_reader(callback : (String) -> Bytes?) -> Unit {
  reader.val = callback
}

///|
pub fn read_bytes(path : String) -> Bytes? {
  (reader.val)(path)
}
