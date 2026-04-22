///|
pub type CustomComponentDefaultData = () -> Json

///|
pub type CustomComponentValidator = (ComponentDocument, String) -> Array[
  ValidationError,
]

///|
// Keep custom component lifecycle in one registry so editor defaults,
// document validation, and runtime instantiation stay aligned.
pub struct CustomComponentHandler {
  default_data : CustomComponentDefaultData
  validate : CustomComponentValidator
  apply : CustomComponentApplier
}

///|
let registered_custom_component_handlers : Map[String, CustomComponentHandler] = {}

///|
fn normalized_custom_component_kind(kind : String) -> String {
  kind.trim().to_string()
}

///|
pub fn default_custom_component_data() -> Json {
  let value : Map[String, Json] = {}
  value.to_json()
}

///|
// Unregistered custom components are still allowed, but they must at least
// look like object-shaped documents so later extensions can evolve safely.
pub fn validate_custom_component_object_payload(
  component : ComponentDocument,
  path : String,
) -> Array[ValidationError] {
  match component.data {
    Object(_) => []
    _ => [{ path, message: "Custom component payload must be a JSON object" }]
  }
}

///|
pub fn[T : @json.FromJson] validate_custom_component_payload(
  component : ComponentDocument,
  path : String,
  invalid_message : String,
) -> Result[T, Array[ValidationError]] {
  let decoded : Result[T, Error] = try? @json.from_json(component.data)
  match decoded {
    Ok(value) =>
      match validate_custom_component_object_payload(component, path) {
        [] => Ok(value)
        errors => Err(errors)
      }
    Err(_) => Err([{ path, message: invalid_message }])
  }
}

///|
pub fn ignore_custom_component(
  _entity : @entity.Entity,
  _component : ComponentDocument,
  _context : AssetInstantiationContext,
) -> Unit {

}

///|
pub fn custom_component_handler(
  default_data? : CustomComponentDefaultData = default_custom_component_data,
  validate? : CustomComponentValidator = validate_custom_component_object_payload,
  apply? : CustomComponentApplier = ignore_custom_component,
) -> CustomComponentHandler {
  { default_data, validate, apply }
}

///|
// Normalize external handler maps before they enter runtime contexts so
// project code can build handlers incrementally without depending on exact
// key formatting.
pub fn normalize_custom_component_handlers(
  handlers : Map[String, CustomComponentHandler],
) -> Map[String, CustomComponentHandler] {
  let normalized : Map[String, CustomComponentHandler] = {}
  for kind, handler in handlers {
    let trimmed = normalized_custom_component_kind(kind)
    if trimmed != "" {
      normalized.set(trimmed, handler)
    }
  }
  normalized
}

///|
// Hosts can register project-specific handlers at startup to make the same
// custom component behave consistently across authoring and runtime.
pub fn register_custom_component(
  kind : String,
  handler : CustomComponentHandler,
) -> Unit {
  let normalized = normalized_custom_component_kind(kind)
  guard normalized != "" else { return }
  registered_custom_component_handlers.set(normalized, handler)
}

///|
pub fn custom_component_handler_for(kind : String) -> CustomComponentHandler? {
  registered_custom_component_handlers.get(
    normalized_custom_component_kind(kind),
  )
}

///|
pub fn custom_component_default_data_for(kind : String) -> Json? {
  custom_component_handler_for(kind).map(fn(handler) {
    (handler.default_data)()
  })
}
