# Selene 使用教程（中文）

本教程已按当前仓库里的 Selene 结构与 API 更新。

## 1. 现在的 Selene 架构

Selene 由引擎核心和可替换后端组成：

- `Milky2018/selene`：ECS 引擎核心
- `Milky2018/selene-canvas`：Web 后端（Canvas2D）
- `Milky2018/selene_raylib`：Native 后端（raylib）

游戏逻辑包本身不依赖具体后端，后端通过 `overrides` 选择。

## 2. 运行现有示例

### 2.1 运行 Web 示例（Canvas）

```bash
cd examples
moon update
moon build ./web/pixeladventure --target js --target-dir _build --release
python3 -m http.server 8000
```

浏览器打开：

- `http://localhost:8000/web/pixeladventure/`

### 2.2 运行 Native 示例（raylib）

```bash
cd examples
moon update
moon run ./native/pixeladventure --target native
```

## 3. 当前示例目录结构

示例使用“共享逻辑 + 平台包装层”结构：

```text
examples/
  assets/                    # 集中管理资源
  pixeladventure/            # 共享游戏逻辑
  web/pixeladventure/        # Web 入口（override selene-canvas）+ index.html
  native/pixeladventure/     # Native 入口（override selene_raylib）
```

这样可以最大化复用同一份游戏逻辑。

## 4. 用 `overrides` 选择后端

Web 包装层（`examples/web/pixeladventure/moon.pkg` 风格）：

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

Native 包装层（`examples/native/pixeladventure/moon.pkg` 风格）：

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

## 5. 核心启动 API（当前版本）

当前启动方式（来自 `examples/pixeladventure/main.mbt`）是无参数 `App::new()`：

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

一次性初始化逻辑建议通过 `schedule=Startup` 的系统完成。

## 6. ECS 与常用系统

### 6.1 实体与组件

```moonbit
let player = @entity.Entity::new()
@position.positions.set(player, @math.Vec2D(100.0, 100.0))
@velocity.velocities.set(player, @math.Vec2D::zero())
```

### 6.2 输入

输入模块是 `Milky2018/selene/inputs`：

```moonbit
if @inputs.is_pressed(@inputs.ArrowLeft) {
  // 向左移动
}

if @inputs.is_just_pressed(ArrowUp) {
  // 跳跃
}
```

### 6.3 碰撞与触发区域

```moonbit
let player_group = @collision.CollisionGroup::new()
let terrain_group = @collision.CollisionGroup::new()
let trigger_group = @collision.CollisionGroup::new()

@collision.shapes.set(
  player,
  Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
)
@collision.colliders.set(
  player,
  @collision.Collider::new(
    @collision.CollisionFilter::new(player_group, [terrain_group]),
  ),
)

let wall = @entity.Entity::new()
@collision.shapes.set(
  wall,
  Rect(size=@math.Vec2D(16.0, 16.0), offset=@math.Vec2D::zero()),
)
@collision.colliders.set(
  wall,
  @collision.Collider::new(@collision.CollisionFilter::empty(terrain_group)),
)

let apple = @entity.Entity::new()
@collision.shapes.set(
  apple,
  Rect(size=@math.Vec2D(32.0, 32.0), offset=@math.Vec2D::zero()),
)
let area = @collision.Area::new(
  @collision.CollisionFilter::new(trigger_group, [player_group]),
)
@collision.areas.set(apple, area)
area.on_enter(fn(e) {
  if e == player {
    @entity.Entity::destroy(apple)
  }
})
```

### 6.4 摄像机与 UI

```moonbit
@camera.set_limits(top=0.0, bottom=world_h, left=0.0, right=world_w)
@camera.attach_entity(player, @math.Vec2D(16.0, 16.0))

let label = @entity.Entity::new()
@ui.uis.set(label, @ui.Ui::new())
```

### 6.5 鼠标交互

鼠标点击建议使用 `Pickable`：

```moonbit
let pickable = @collision.Pickable::new()
pickable.on_just_released(fn(mouse_button) {
  if mouse_button == Left {
    // 处理点击
  }
})
@collision.pickables.set(button, pickable)
```

## 7. Web HTML 与构建产物路径

`index.html` 中请使用 `_build` 路径，例如：

```html
<script src="../../preload-assets.js"></script>
<script src="../../_build/js/release/build/web/pixeladventure/pixeladventure.js" defer></script>
```

## 8. 常用命令

```bash
# Web 检查与构建
cd examples
moon check ./web/pixeladventure --target js
moon build ./web/pixeladventure --target js --target-dir _build --release

# Native 检查与运行
moon check ./native/pixeladventure --target native
moon run ./native/pixeladventure --target native
```

## 9. 实践建议

- 使用 `@system.App::new()` 作为应用启动入口。
- 输入使用 `Milky2018/selene/inputs`。
- 实体类型使用 `@entity.Entity`。
- 一次性初始化逻辑建议放在 `schedule=Startup` 系统中。
- 碰撞过滤使用 `CollisionGroup` + `CollisionFilter`。
- 静态阻挡体应挂 `Collider`，并使用 `CollisionFilter::empty(group)`。
- HTML 构建产物路径使用 `_build/...`。

## 10. 下一步建议

要创建一个可同时支持 Web 与 Native 的新游戏，直接复用 `pixeladventure` 模式：

- 共享逻辑包：`examples/<game>`
- Web 包装层：`examples/web/<game>`
- Native 包装层：`examples/native/<game>`

把平台差异留在包装层，核心玩法逻辑保持一套代码即可。
