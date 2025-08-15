# Selene 使用教程（中文）

该教程会让你快速体验 Selene 游戏引擎。

## 认识 Selene

Selene 是一个实验性质的引擎，鼓励用户基于程序设计最基本的功能挥发创意。

Selene 有如下特点：

- 免费并开源
- 简单：代码非常精简，使用纯粹的 MoonBit 实现（除了 Backend），简单易用
- 模块化：几乎没有耦合性，完全可以只导入需要用到的功能
- 高效：借助 MoonBit 本身的性能优势和 ECS 架构，运行起来非常快

缺陷方面体现在目前（0.10.x版本）Selene 缺乏很多工业级引擎具备的高级功能，比如凸多边形的碰撞检测、3D 物体渲染、手柄支持等等。非常欢迎大家参与贡献。

## 运行案例

确保你已经安装 [MoonBit 工具链](https://www.moonbitlang.com/download/)，并学会基本的使用。

克隆这个仓库：

```shell 
git clone https://github.com/Milky2018/selene.git
```

进入 example 目录：

```shell
cd example
```

使用 `moon` CLI 工具构建项目：

```shell
moon build --target js
```

使用任何 Web 服务器运行，例如 Python

```shell
python -m http.server 8000
```

或者 Node.js 

```shell 
npx serve .
```

运行成功后，打开你的浏览器，访问 `localhost:8000` （或其它你指定的端口）即可开始游玩。

接下来，你可以尝试修改源码中的部分代码，例如调整游戏画面的大小和帧率，然后重新构建、运行，相信很快你就能对这个案例游戏和 Selene 引擎有初步的了解。

## 做你的第一个游戏

本章将介绍如何使用 Selene 游戏引擎制作一个完整的平台跳跃游戏。通过实际开发过程，学习游戏引擎的核心功能和开发技巧。

### 示例游戏展示

我们将要制作的游戏如下：

![](../example/screenshot.png)

我们将会在接下来的流程中展示如何制作：

- 绿色草地瓦片
- 一个可控制的人物
- 可移动的摄像机
- 收集道具苹果
- 分数显示框
- 音量控制按钮

玩家可以使用方向键控制人物移动和跳跃，跳跃时会播放音效。吃到苹果会增加分数。音量按钮可以控制游戏声音的开关状态。

运行示例游戏的方法是进入 example 目录，使用 `moon build` 构建项目，然后用任何 Web 服务器（如 `python -m http.server 8000`）在浏览器中访问。

### 项目创建与配置

首先下载并安装 MoonBit CLI 工具。如果使用 VS Code，建议安装 MoonBit 插件，它会自动提示下载相关工具链。

使用 `moon new` 命令创建新项目，选择可运行项目模式，设置项目名称和许可证信息。

### 素材准备

游戏所需的图片和音频素材都可以免费下载：[图片素材](https://pixelfrog-assets.itch.io/pixel-adventure-1)包含角色动画序列和地形元素，[音频素材](https://brackeysgames.itch.io/brackeys-platformer-bundle)包含跳跃和收集音效。将下载的素材文件夹复制到项目根目录下。

### 引擎依赖安装

为项目添加 Selene 引擎依赖：

```bash
moon add Milky2018/selene@0.10.3
moon add Milky2018/selene-canvas@0.10.3
```

> 也可以获取最新版享受更多新功能，但后续流程可能有无法正常运行的情况，需要自己调试。

在 `moon.pkg.json` 中导入所需的引擎模块：

```json
{
  "import": [
    "Milky2018/selene/system",
    "Milky2018/selene/math",
    "Milky2018/selene/sprite",
    "Milky2018/selene/position",
    "Milky2018/selene/velocity",
    "Milky2018/selene/collision",
    "Milky2018/selene/input",
    "Milky2018/selene/plugins",
    "Milky2018/selene/camera",
    "Milky2018/selene/audio",
    "Milky2018/selene/tilemap",
    { "path": "Milky2018/selene-canvas", "alias": "canvas" }
  ]
}
```

Selene 项目的核心是 App 对象。需要在 `main` 函数中创建基础的游戏应用：

```moonbit
fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .with_canvas_width(480.0)
  .with_canvas_height(320.0)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  .run()
}
```

使用了一个叫做 `CanvasBackend` 的后端来运行游戏。Selene 支持模块化的后端，当使用 `CanvasBackend` 后端时，游戏会构建为一个描述了 Canvas2D 画布的 JavaScript 文件。

游戏以固定帧率（如60FPS）循环执行系统函数。每个系统负责特定功能，如渲染、实体移动或输入处理。游戏具体功能需要通过各种系统来实现。

### 游戏状态管理

全局游戏状态包含玩家引用、分数、音量设置等，可以使用一个全局变量来保存游戏状态：

```moonbit
struct GameState {
  player : @system.Entity
  mut score : Int
  mut volume_on : Bool
  mut player_state : PlayerState
  score_box : @sprite.Text
}

let game_state : GameState = {
  ...
}
```

其中包含的各个字段会在接下来的内容中介绍。

### 实体和组件

游戏中的对象通过实体（Entity）和组件（Component）来表示。实体是唯一标识符，组件存储具体数据。创建玩家实体的示例：

```moonbit
let player = @system.Entity::new()
@position.positions.set(player, @math.Vec2D::new(100.0, 100.0))
@velocity.velocities.set(player, @math.Vec2D::zero())
```

上述代码做了如下事情：

1. 生成一个新的 Entity；
3. 把新 Entity 的位置设置为 (100, 100)；
2. 把新 Entitiy 的速度设置为 (0, 0)；

Entity 类似一个引用，一切属于一个实体的组件都通过 `Map[K, V]::set` 的方式关联在一起。`@position.positions` 和 `@sprite.sprites` 都是哈希映射类型的数据结构，里面存放了每个实体对应的组件。

组件通过全局映射表进行管理，系统通过查询这些映射表来处理相关实体。例如，为实体设置速度和位置属性后，每一帧实体的位置都会根据速度进行移动。

类似这种添加一个玩家实体的行为需要放在一个初始化器中：

```moonbit
app.add_initializer(add_player)
```

初始化器会在游戏开始时执行一次。

### 玩家角色实现

玩家角色需要多个动画状态：空闲、跑步、跳跃和下落。每个状态对应不同的精灵动画。以空闲动画为例：

```moonbit
let player_idle_animation = @sprite.Animation::new(
  "pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png",
  loop_=true, max_frame=11, height=32.0, width=32.0
)
```

其中 `loop_` 参数表示该动画是否会循环播放；`max_frame` 表示这张图片一共包含多少帧动画。

通过调用 `@sprite.play_animation` 来为实体播放动画：

```moonbit
@sprite.play_animation(player, player_idle_animation)
```

玩家状态机根据速度和地面接触情况在不同状态间切换。可以使用一个状态机来实现状态切换和不同动画的播放：

```moonbit
enum PlayerState {
  Idle
  Jump
  Fall
} derive(Show)

match player_state {
  Idle => ...
  Jump => ...
  Fall => ...
}
```

玩家还需要根据键盘输入来控制人物移动，可以使用 `@system.is_pressed` 或者 `@system.is_just_pressed` 来检测某个按键是否按下。两者的区别在于前者只要按键按下就会返回 true，而后者只会在按键刚刚按下才返回 true。可以分别使用这两个函数来控制左右移动和跳跃：

```moonbit
if @system.is_pressed(ArrowLeft) {
  velocity_x = -5.0
} else if @system.is_pressed(ArrowRight) {
  velocity_x = 5.0
} else {
  velocity_x = 0.0
}

if @system.is_just_pressed(ArrowUp) && @collision.is_on_floor(game_state.player) {
  velocity_y = 10.0
}
```

其中，`@collision.is_on_floor` 用于判断角色是否站在平台上。

### 障碍物和碰撞

为了让玩家移动时不会穿透障碍物，需要分别为玩家和障碍物设置碰撞层和碰撞体：

```moonbit
let terrain_collision_layer = @collision.CollisionLayer::new()
let player_collision_layer = @collision.CollisionLayer::new()

@collision.collides.set(game_state.player, @collision.Collide::{
  shape: Rect(size=@math.Vec2D::new(24.0, 32.0), offset=@math.Vec2D::zero()),
  layer: player_collision_layer,
  mask: @collision.CollisionMask::new([terrain_collision_layer]),
})

@collision.collides.set(grass, @collision.Collide::{
  shape: Rect(size=@math.Vec2D::new(16.0, 16.0), offset=@math.Vec2D::zero()),
  layer: terrain_collision_layer,
  mask: @collision.CollisionMask::empty(),
})
```

上述代码分为为玩家和草地设置了一个方形的碰撞体。只有当一个实体的碰撞 mask 包含另一个实体的碰撞层时，碰撞才会发生。

### 瓦片地图制作

直接用代码绘制完整的地图并不方便，Selene 支持使用 [Sprite Fusion](https://www.spritefusion.com/) 等外部工具设计地图，导出为 JSON 格式。

Sprite Fusion 输出的 JSON 包含地图的瓦片像素大小、地图尺寸、每一层的信息。大致如下：

```json
{
  "tileSize": 16,
  "mapWidth": 75,
  "mapHeight": 51,
  "layers": [
    {
      "name": "Grass",
      "tiles": [
        { "id": "0", "x": 8, "y": 46 },
        { "id": "1", "x": 9, "y": 46 },
        { "id": "2", "x": 8, "y": 47 },
        { "id": "3", "x": 9, "y": 47 },
      ],
      "collider": false
    }
    ...
  ]
}
```

使用 `@tilemap.TileMap::from_json` 解析地图数据并生成对应的游戏实体：

```moonbit
fn generate_map(backend : &@system.Backend) -> Unit {
  let tilemap = @tilemap.TileMap::from_json(tilemap_data)
  let grasses = tilemap.get_tiles("Grass")
  for grass in grasses {
    add_grass(tile_to_vec2d(grass, tilemap.tile_size))
  }
}
```

### 摄像机

当游戏地图远大于画布尺寸时，为了让玩家能看到自己控制的人物，需要摄像机跟随玩家移动，并设置边界限制防止显示空白区域：

```moonbit
@camera.camera.attached_entity = Some(player)
@camera.camera.limit_left = Some(0.0)
@camera.camera.limit_right = Some(world_width)
@camera.camera.limit_top = Some(0.0)
@camera.camera.limit_bottom = Some(world_height)
```

由于玩家位置位于玩家图片的左上角，为了让摄像机更贴近玩家角色的中心，还可以设置 `offset` 属性为玩家尺寸的一半：

```moonbit
@camera.camera.offset = @math.Vec2D::new(16.0, 16.0)
```

### 区域和音频

苹果和地形不同，它不会影响玩家移动和碰撞，但会在碰到玩家时触发事件：苹果消失，并且游戏分数上涨。通过为苹果实体设置区域组件来实现该功能：

```moonbit
let area = @collision.Area::new(
  Rect(size=@math.Vec2D::new(32.0, 32.0), offset=@math.Vec2D::zero()),
  non_collide_layer,
  @collision.CollisionMask::new([player_collision_layer]),
)
@collision.areas.set(apple, area)
area.on_enter(fn(e) {
  if e == game_state.player {
    set_score(game_state.score + 10)
    if game_state.volume_on {
      @audio.play_audio(backend, "sounds/coin.wav")
    }
    @system.Entity::destroy(apple)
  }
})
```

为区域设置一个矩形碰撞体。用 `Area::on_enter` 方法为区域添加一个回调，当有实体进入该区域时，触发分数上涨，播放音效。

### 用户界面

使用普通的 `Sprite` 组件和 UI 组件创建分数显示框。UI 元素使用高 z-index 值确保显示在游戏内容之上：

```moonbit
fn add_score_box() -> Unit {
  let box = @system.Entity::new()
  @position.positions.set(box, @math.Vec2D::new(240.0, 40.0))
  let text = @sprite.Sprite::new_text(game_state.score_box, 100)
  @camera.uis.set(box, @camera.Ui::new())
  @sprite.sprites.set(box, text)
}
```

提醒：忘记设置 UI 组件会导致该实体会随着摄像机移动而移动，而不是固定在画面的某处。

音量按钮通过鼠标点击事件切换音频开关状态，通过区域组件的 `Area::on_just_released` 可以设置鼠标按键回调。在此例中，仅当鼠标左键松开时才会切换音量按钮的状态。

```moonbit
let area = @collision.Area::new(
  @collision.CollisionShape::Rect(
    size=@math.Vec2D::new(21.0, 22.0),
    offset=@math.Vec2D::zero(),
  ),
  non_collide_layer,
  @collision.CollisionMask::new([]),
  monitoring_mouse=true,
)
area.on_just_released(fn(mouse_button) {
  if mouse_button == Left {
    game_state.volume_on = !game_state.volume_on
    if game_state.volume_on {
      @sprite.sprites.set(button, volume_on)
    } else {
      @sprite.sprites.set(button, volumn_off)
    }
  }
})
```

### 编译&游玩

构建命令：

```shell 
moon build --target js --watch
```

构建成功后，你会得到一个 target 目录，里面就包含了编译产物。要展示这个 canvas，我们需要一个 html。在项目根目录新建一个 `index.html` 文件，然后填充以下内容：

```html
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>My Game</title>
    <script src="/target/js/release/build/main/main.js" defer></script>
</head>

<body>
    <canvas id="canvas" style="display: block; margin: 0 auto;" height="32" width="32"></canvas>
</body>

</html>
```

然后使用 Web 服务器运行：

```shell
python3 -m http.server 8000
```

使用浏览器访问 localhost:8000 即可游玩。

游戏完整源码：[Selene Example](https://github.com/moonbit-community/selene/tree/3a27062f3f95ae505b317116be457b6bd026f4f8/example)
