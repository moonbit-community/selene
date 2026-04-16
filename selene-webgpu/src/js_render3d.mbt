///|
pub extern "js" fn Audio::play(self : Self) -> Unit = "(self) => self.play()"

///|
pub extern "js" fn Audio::pause(self : Self) -> Unit = "(self) => self.pause()"

///|
pub extern "js" fn Audio::set_volume(self : Self, volume : Double) -> Unit = "(self, volume) => self.volume = volume"

///|
pub extern "js" fn Audio::set_loop(self : Self, loop_ : Bool) -> Unit = "(self, loop_) => self.loop = loop_"

///|
pub extern "js" fn Audio::set_playback_rate(
  self : Self,
  playback_rate : Double,
) -> Unit = "(self, playback_rate) => self.playbackRate = playback_rate"

///|
pub extern "js" fn Audio::set_current_time(
  self : Self,
  current_time : Double,
) -> Unit = "(self, current_time) => self.currentTime = current_time"

///|
pub extern "js" fn Audio::is_paused(self : Self) -> Bool = "(self) => self.paused"

///|
pub extern "js" fn Audio::is_ended(self : Self) -> Bool = "(self) => self.ended"

///|
#external
type Audio
