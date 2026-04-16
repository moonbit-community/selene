///|
pub fn ActiveAnimation::elapsed(self : ActiveAnimation) -> Double {
  self.time
}

///|
pub fn ActiveAnimation::seek_time(self : ActiveAnimation) -> Double {
  self.time
}

///|
pub fn ActiveAnimation::pause(self : ActiveAnimation) -> ActiveAnimation {
  self.paused = true
  self
}

///|
pub fn ActiveAnimation::unpause(self : ActiveAnimation) -> ActiveAnimation {
  self.paused = false
  self
}

///|
pub fn ActiveAnimation::set_speed(
  self : ActiveAnimation,
  speed : Double,
) -> ActiveAnimation {
  self.speed = speed
  self
}

///|
pub fn ActiveAnimation::set_weight(
  self : ActiveAnimation,
  weight : Double,
) -> ActiveAnimation {
  self.weight = @cmp.maximum(0.0, weight)
  self
}

///|
pub fn ActiveAnimation::set_repeat(
  self : ActiveAnimation,
  repeat : RepeatAnimation,
) -> ActiveAnimation {
  self.repeat = repeat
  self
}

///|
pub fn ActiveAnimation::repeat(self : ActiveAnimation) -> ActiveAnimation {
  self.repeat = Forever
  self
}

///|
pub fn ActiveAnimation::replay(self : ActiveAnimation) -> ActiveAnimation {
  self.time = 0.0
  self.last_time = 0.0
  self.finished = false
  self.completed_repeats = 0U
  self
}

///|
pub fn ActiveAnimation::rewind(self : ActiveAnimation) -> ActiveAnimation {
  self.time = 0.0
  self.last_time = 0.0
  self.finished = false
  self
}

///|
pub fn ActiveAnimation::set_seek_time(
  self : ActiveAnimation,
  time : Double,
) -> ActiveAnimation {
  let clamped = @cmp.maximum(0.0, time)
  self.time = clamped
  self.last_time = clamped
  self
}

///|
pub fn ActiveAnimation::seek_to(
  self : ActiveAnimation,
  time : Double,
) -> ActiveAnimation {
  let clamped = @cmp.maximum(0.0, time)
  self.time = clamped
  self.last_time = clamped
  self
}

///|
pub fn AnimationPlayer::play(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
  repeat? : RepeatAnimation = Forever,
) -> ActiveAnimation {
  match self.active_animations.get(node) {
    Some(active) => active
    None => self.start(node, repeat~)
  }
}

///|
pub fn AnimationPlayer::start(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
  repeat? : RepeatAnimation = Forever,
) -> ActiveAnimation {
  self.active_animations.set(node, active_animation_default(repeat))
  self.active_animations.get(node).unwrap()
}

///|
pub fn AnimationPlayer::animation(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
) -> ActiveAnimation? {
  self.active_animations.get(node)
}

///|
pub fn AnimationPlayer::animation_mut(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
) -> ActiveAnimation? {
  self.active_animations.get(node)
}

///|
pub fn AnimationPlayer::playing_animations(
  self : AnimationPlayer,
) -> Array[(AnimationNodeIndex, ActiveAnimation)] {
  self.active_animations.to_array()
}

///|
pub fn AnimationPlayer::is_playing_animation(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
) -> Bool {
  self.active_animations.contains(node)
}

///|
pub fn AnimationPlayer::stop(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
) -> AnimationPlayer {
  self.active_animations.remove(node)
  self
}

///|
pub fn AnimationPlayer::stop_all(self : AnimationPlayer) -> AnimationPlayer {
  self.active_animations.clear()
  self
}

///|
pub fn AnimationPlayer::pause_all(self : AnimationPlayer) -> AnimationPlayer {
  for _, active in self.active_animations {
    ignore(active.pause())
  }
  self
}

///|
pub fn AnimationPlayer::resume_all(self : AnimationPlayer) -> AnimationPlayer {
  for _, active in self.active_animations {
    ignore(active.unpause())
  }
  self
}

///|
pub fn AnimationPlayer::rewind_all(self : AnimationPlayer) -> AnimationPlayer {
  for _, active in self.active_animations {
    ignore(active.rewind())
  }
  self
}

///|
pub fn AnimationPlayer::seek_all_by(
  self : AnimationPlayer,
  amount : Double,
) -> AnimationPlayer {
  for _, active in self.active_animations {
    ignore(active.seek_to(active.time + amount))
  }
  self
}

///|
pub fn AnimationPlayer::all_finished(self : AnimationPlayer) -> Bool {
  for _, active in self.active_animations {
    if !active.is_finished() {
      return false
    }
  }
  true
}

///|
pub fn AnimationPlayer::all_paused(self : AnimationPlayer) -> Bool {
  for _, active in self.active_animations {
    if !active.is_paused() {
      return false
    }
  }
  true
}

///|
pub fn AnimationTransitions::play(
  self : AnimationTransitions,
  player : AnimationPlayer,
  node : AnimationNodeIndex,
  duration : Double,
  repeat? : RepeatAnimation = Forever,
) -> ActiveAnimation {
  let safe_duration = @cmp.maximum(0.0, duration)
  if self.main == Some(node) && player.animation(node) is Some(active) {
    if safe_duration <= 0.0 {
      active.weight = 1.0
    }
    return active
  }
  if self.main is Some(current) &&
    current != node &&
    player.animation(current) is Some(active) {
    self.fading.set(current, {
      remaining: safe_duration,
      total: safe_duration,
      start_weight: active.weight,
    })
  }
  self.fading.remove(node)
  let active = player.play(node, repeat~)
  active.weight = if safe_duration > 0.0 { 0.0 } else { 1.0 }
  self.main = Some(node)
  active
}
