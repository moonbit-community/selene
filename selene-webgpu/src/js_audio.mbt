///|
extern "js" fn create_audio_object_url(bytes : Bytes, mime : String) -> String =
  #| (bytes, mime) => {
  #|   return URL.createObjectURL(new Blob([bytes], { type: mime }));
  #| }

///|
extern "js" fn revoke_object_url(url : String) -> Unit =
  #| (url) => {
  #|   if (typeof url === 'string' && url.startsWith('blob:')) {
  #|     URL.revokeObjectURL(url);
  #|   }
  #| }

///|
extern "js" fn request_audio_play(audio : Audio, activation_epoch : Int) -> Unit =
  #| (audio, activationEpoch) => {
  #|   audio.__selenePlayAttemptEpoch = activationEpoch | 0;
  #|   if (audio.error) {
  #|     audio.__selenePlayState = 3;
  #|     return;
  #|   }
  #|   audio.__selenePlayState = 0;
  #|   const result = audio.play();
  #|   if (result && typeof result.then === 'function') {
  #|     result.then(() => {
  #|       audio.__selenePlayState = 1;
  #|     }).catch((err) => {
  #|       const name = err && err.name ? String(err.name) : '';
  #|       if (name === 'AbortError' && audio.paused) {
  #|         audio.__selenePlayState = 0;
  #|         return;
  #|       }
  #|       audio.__selenePlayState = name === 'NotAllowedError' ? 2 : 3;
  #|     });
  #|   } else {
  #|     audio.__selenePlayState = audio.paused ? 0 : 1;
  #|   }
  #| }

///|
extern "js" fn audio_play_state(audio : Audio) -> Int =
  #| (audio) => {
  #|   if (audio.error) {
  #|     return 3;
  #|   }
  #|   return audio.__selenePlayState | 0;
  #| }

///|
extern "js" fn Audio::clone_audio(self : Self) -> Audio =
  #| (self) => {
  #|   const init = globalThis.__selene_init_audio_element;
  #|   const clone = new Audio(self.src);
  #|   return init ? init(clone) : clone;
  #| }

///|
extern "js" fn Audio::load(self : Self) -> Unit = "(self) => self.load()"
