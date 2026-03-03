# Selene 使用教程（中文）

## 1. 快速开始

### 1.1 Web（Canvas）

```bash
cd examples
moon update
moon build ./web/pixeladventure --target js --target-dir _build --release
python3 -m http.server 8000
```

打开 `http://localhost:8000/web/pixeladventure/`。

### 1.2 Native（raylib）

```bash
cd examples
moon update
moon run ./native/pixeladventure --target native
```

## 2. 示例目录结构

```text
examples/
  assets/
  pixeladventure/            # 共享游戏逻辑
  web/pixeladventure/        # Web 入口 + override selene-canvas
  native/pixeladventure/     # Native 入口 + override selene_raylib
```

## 3. 后端包装层（`moon.pkg`）

### 3.1 Web 包

```moonbit
import {
  "Milky2018/selene-examples/pixeladventure",
}

options(
  "is-main": true,
  overrides: [ "Milky2018/selene-canvas" ],
  targets: { "main.mbt": [ "js" ] },
)
```

### 3.2 Native 包

```moonbit
import {
  "Milky2018/selene-examples/pixeladventure",
}

options(
  "is-main": true,
  overrides: [ "Milky2018/selene_raylib" ],
  targets: { "main.mbt": [ "native" ] },
)
```

## 4. 应用启动

```moonbit
pub fn run() -> Unit {
  @system.App::new()
  .with_viewport_width(480.0)
  .with_viewport_height(320.0)
  .with_image_smooth(false)
  .with_zoom(2.0)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  .add_system(game_start, schedule=Startup)
  .add_system(gameplay_system)
  .run()
}
```

## 5. 系统阶段

- 帧阶段：`First -> PreUpdate -> Update -> PostUpdate -> Last`
- 固定步阶段：`FixedFirst -> FixedPreUpdate -> FixedUpdate -> FixedPostUpdate -> FixedLast`
- 渲染阶段：`RenderExtract -> RenderPrepare -> Render -> RenderCleanup`

## 6. 核心运行时 API

### 6.1 Transform 与速度

```moonbit
let player = @entity.Entity::new()
@transform.transforms.set(player, @math.Vec2D(100.0, 100.0))
@physics2d.linear_velocities.set(player, @math.Vec2D::zero())
```

### 6.2 碰撞层与碰撞体

```moonbit
let player_group = @physics2d.CollisionGroup::new()
let terrain_group = @physics2d.CollisionGroup::new()

@physics2d.shapes.set(
  player,
  Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
)
@physics2d.colliders.set(
  player,
  @physics2d.Collider::new(
    @physics2d.CollisionLayers::new(player_group, [terrain_group]),
  ),
)
```

### 6.3 触发器事件

```moonbit
let trigger_group = @physics2d.CollisionGroup::new()
let sensor = @physics2d.Sensor::new(
  @physics2d.CollisionLayers::new(trigger_group, [player_group]),
)
@physics2d.sensors.set(apple, sensor)

fn trigger_system(_delta : Double) -> Unit {
  for event in @physics2d.sensor_events() {
    if event.entered && event.area == apple && event.other == player {
      @entity.Entity::destroy(apple)
    }
  }
}
```

### 6.4 鼠标指针事件

```moonbit
@physics2d.pickables.set(button, @physics2d.Pickable::new())

fn ui_input_system(_delta : Double) -> Unit {
  for event in @physics2d.pointer_events() {
    if event.entity == button &&
      event.phase is @physics2d.PointerPhase::JustReleased &&
      event.button == @inputs.MouseButton::Left {
      // 处理点击
    }
  }
}
```

## 7. Web HTML 脚本路径

```html
<script src="../../preload-assets.js"></script>
<script src="../../_build/js/release/build/web/pixeladventure/pixeladventure.js" defer></script>
```

## 8. 常用命令

```bash
# Web
cd examples
moon check ./web/pixeladventure --target js
moon build ./web/pixeladventure --target js --target-dir _build --release

# Native
moon check ./native/pixeladventure --target native
moon run ./native/pixeladventure --target native

# 一次性构建全部示例
./build_all.sh all release
```
