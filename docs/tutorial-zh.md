# Selene 使用教程（中文）

该教程会让你快速体验 Selene 游戏引擎。

## 认识 Selene

Selene 是一个实验性质的引擎，鼓励用户基于程序设计最基本的功能挥发创意。

Selene 有如下特点：

- 免费并开源
- 简单：代码非常精简，使用纯粹的 MoonBit 实现（除了 Backend），简单易用
- 模块化：几乎没有耦合性，完全可以只导入需要用到的功能
- 高效：借助 MoonBit 本身的性能优势和 ECS 架构，运行起来非常快

缺陷方面体现在目前（0.10.0版本）Selene 缺乏很多工业级引擎具备的高级功能，比如凸多边形的碰撞检测、3D 物体渲染、手柄支持等等。非常欢迎大家参与贡献。

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

本节将带你完成一个用方向键控制文本框的简单应用，在此过程中完整体验 Selene 引擎。

### 构建项目

新建一个自己的 MoonBit 项目：

```shell
moon new --path mygame --name mygame --user <YOURNAME>
cd mygame
```

添加 Selene 引擎和 Canvas 后端作为依赖：

```shell
moon add Milky2018/selene@0.10.0
moon add Milky2018/selene-canvas@0.10.0
```

> 你也可以获取最新版，但后续流程可能有无法正常运行的情况，需要你自己调试。

接下来，可以按照你喜欢的风格调整项目结构。别忘了在 `moon.pkg.json` 中导入 Selene 的各个包：

```json
{
  "is-main": true,
  "import": [
    "Milky2018/selene/system",
    "Milky2018/selene/math",
    "Milky2018/selene/sprite",
    "Milky2018/selene/velocity",
    "Milky2018/selene/input",
    "Milky2018/selene/plugins",
    "Milky2018/selene/position",
    "Milky2018/selene/collision",
    { "path": "Milky2018/selene-canvas", "alias": "canvas" }
  ]
}
```

现在可以开始新建一个游戏 App 了，在 main 函数中实例化一个 App：

```moonbit
fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .run()
}
```

注意到，我们使用了一个叫做 `CanvasBackend` 的后端来运行游戏。Selene 支持模块化的后端，当使用 `CanvasBackend` 后端时，我们的游戏会构架为一个描述了 Canvas2D 画布的 JavaScript 文件。现在使用 `build` 命令并指定 js 作为 MoonBit 的编译后端以构建游戏项目：

```shell 
moon build --target js
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

现在，使用任何一个简易的 Web 服务器来运行这个 Web 页面。比如，使用 Python3：

```shell
python -m http.server 8000
# Or
python3 -m http.server 8000
```

你应该能在终端看到如下信息：

```shell
Serving HTTP on :: port 8000 (http://[::]:8000/) ...
```

这说明游戏服务器已经运行起来了。打开你常用的浏览器，访问 `localhost:8000` 即可游玩你的游戏。当然，现在应该只有一个纯白色的画布，我们需要向里面添加各种有趣的内容。

### 第一个系统

Selene 的运行逻辑是以一个特定帧率（默认是60）循环执行一系列被称为 System 的回调函数。System 包含的内容是对游戏状态的更新，或者把游戏世界中的物体渲染到屏幕上，在我们的游戏中就是绘制到 canvas 元素上。

现在，我们尝试画一个方框。我们把一个画方框的函数作为 System 添加到 App 中即可：

```moonbit
fn main {
  @system.App::new(@canvas.CanvasBackend::new()) // 选择 CanvasBackend 作为后端
  .add_system(stroke_render_pipe)                // 添加绘制方框的系统
  .run()
}

fn stroke_render_pipe(backend : &@system.Backend) -> Unit {
  backend.draw_stroke_rect( // 调用后端的方框绘制函数
    x=100,                  // 设置方框的坐标
    y=100,
    width=50,               // 设置方框的宽度和高度
    height=50,
    color="blue",           // 设置方框的颜色
  )
}
```

再运行游戏，我们就会在画布中看见一个蓝色的方框。

### 第一个实体

在 `stroke_render_pipe` 中，我们使用 `Backend` 提供的 `draw_stroke_rect` 方法手动绘制了一个方框。`Backend` 提供的底层方法我们一般不需要手工调用，Selene 已经在内部提供了很多实用的 System 和 Initializer 来完成这一切。比如，`sprite` 包提供了一个叫做 `render_sprite_system` 的系统，它会把所有的 Sprite 绘制到相应的地方。

要使用这样的功能，我们需要制作简单的 Sprite。比如，我们可以制作一个文本框，里面填充 "Hello World" 这个文本，并把它设置成黑色：

```moonbit
let box = @system.Entity::new()
let text = @sprite.Sprite::new_text(@sprite.Text::new("Hello World", color="black"), 10)
@position.positions.set(box, @math.Vec2D(100, 100))
@sprite.sprites.set(box, text)
```

可以看看我们做了什么：

1. 生成一个新的 Entity；
2. 生成一个新的文本框组件；
3. 把新 Entity 的位置设置为 (100, 100)；
4. 把文本框组件设置到新的 Entity 上。

Entity 类似一个引用，我们把一切属于一个实体的组件都通过 `Map[K, V]::set` 的方式关联在一起。`@position.positions` 和 `@sprite.sprites` 都是哈希映射类型的数据结构，里面存放了每个实体对应的组件。

> `new_text(text : Text, zindex : Int)` 的第二个参数表示这个 Sprite 的垂直高度。zindex 值更大的 Sprite 会覆盖 zindex 更小的 Sprite。

> @math.Vec2D 表示的坐标可能和你在数学课上学习的不太一样：y 轴是向下的。

那么，我们在何处生成这个文本框呢？在哪里都可以！我们推荐的方法，是把它放到 App 的 Initializers 中，这样在项目启动时只会执行一次，毕竟我们不需要每一帧都生成一个文本框：

```moonbit
fn add_hello_text(_ : &@system.Backend) -> Unit {
  let box = @system.Entity::new()
  let text = @sprite.Sprite::new_text(@sprite.Text::new("Hello World", color="white"), 10)
  @position.positions.set(box, @math.Vec2D(100, 100))
  @sprite.sprites.set(box, text)
}

fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  // 添加一个初始化器，初始化器只会在游戏开始时执行一次
  .add_initializer(add_hello_text)
  .add_system(@sprite.render_sprite_system)
  .run()
}
```

现在，再运行一次你的游戏，就能在画布中看到这个文本框了！

### 运动

怎么让文本框动起来呢？最简单的方式是给它增加一个速度组件：

```moonbit
@velocity.velocities.set(box, @math.Vec2D(1.0, 1.0))
```

只有这个组件是不够的，我们需要一个 System，它能够在每一帧根据每个实体的速度来更新它的位置组件。我们可以自己写一个这样的 System，不过你肯定猜到了，这么常用的 System 已经被 Selene 提供了。我们把 `@collision.move_system` 加入到 App 中即可。下面是完整代码：

```moonbit
fn add_hello_text(_ : &@system.Backend) -> Unit {
  let box = @system.Entity::new()
  let text = @sprite.Sprite::new_text(@sprite.Text::new("Hello World", color="back"), 10)
  @position.positions.set(box, @math.Vec2D(100, 100))  // 为实体关联位置
  @sprite.sprites.set(box, text)                            // 为实体关联文本框
  @velocity.velocities.set(box, @math.Vec2D(1.0, 1.0)) // 为实体关联速度
}

fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .add_initializer(add_hello_text)
  .add_system(@collision.move_system) // 把控制物体移动的系统添加到 App
  .add_system(@sprite.render_sprite_system)
  .run()
}
```

再运行游戏，现在你就可以看到文本框缓慢地向右下方移动了！

### 处理输入

游戏是交互的艺术，我们希望看到游戏世界里的内容会根据我们的输入发生变化。这次我们换一种方式，在讨论怎么做之前，先看看代码。把 `@input.simple_input_system` 加入到 App 中，并给文本框设置 `@input.controls` 组件：

```moonbit
fn add_hello_text(_ : &@system.Backend) -> Unit {
  let box = @system.Entity::new()
  let text = @sprite.Sprite::new_text(@sprite.Text::new("Hello World", color="back"), 10)
  @position.positions.set(box, @math.Vec2D(100, 100))
  @sprite.sprites.set(box, text)
  @velocity.velocities.set(box, @math.Vec2D::zero())
  @input.controls.set(box, @input.KeyInput::{})
}

fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .add_initializer(add_hello_text)
  .add_system(@collision.move_system)
  .add_system(@input.simple_input_system)
  .add_system(@sprite.render_sprite_system)
  .run()
}
```

然后运行一下游戏，看看发生了什么。再按一下键盘上的方向键呢？文本框根据按键动起来了！

实现这一切的幕后逻辑非常简单，让我们直接阅读 `@input.simple_input_system` 和 `@input.controls` 的源代码：

```moonbit
pub(all) struct KeyInput {}

pub let controls : Map[@system.Entity, KeyInput] = Map::new()

pub fn simple_input_system(_backend : &@system.Backend) -> Unit {
  for e in @system.all_entities {
    guard controls.get(e) is Some(_) else { continue }
    let new_velocity_x = if @system.is_pressed(ArrowLeft) {
      -5.0
    } else if @system.is_pressed(ArrowRight) {
      5.0
    } else {
      0.0
    }
    let new_velocity_y = if @system.is_pressed(ArrowUp) {
      -5.0
    } else if @system.is_pressed(ArrowDown) {
      5.0
    } else {
      0.0
    }
    @velocity.velocities.set(
      e,
      @math.Vec2D(new_velocity_x, new_velocity_y),
    )
  }
}
```

当我们为文本框设置 `controls` 组件时，它就被添加到了这个哈希映射中；而在 `simple_input_system` 内部，只要一个实体包含 `controls` 组件，它的速度就会根据按键状态进行更新。按键状态被保存在 `@system.pressed_keys` 集合中，你可以直接访问，也可以通过 Selene 提供的 `is_pressed, is_release` 来访问。除了方向键，Selene 也支持很多其它的按键，你可以在 [system.mbti](https://github.com/Milky2018/selene/selene-core/blob/main/src/system/system.mbti) 这个文件中看到支持的按键列表。

这就是我们实现一个 System 的基本步骤：

1. 如果定义了一个新的组件，为这个组件定义一个可以把组件和 Entity 关联起来的数据结构；
2. 在 System 中对 `@system.all_entities` 进行迭代。

> 组件的存储数据结构不一定要是一个哈希映射，只要你的 System 能访问到它就可以。

> 不要轻易地通过 `for entity, component in components` 来迭代特定组件，因为这样可能会访问到已经从 `all_entities` 中被移除的 Entitiy。 

`@input.simple_input_system` 是一个过于简化的输入处理系统，一般不会用在真实的游戏中。你完全可以把它从你的 App 中删去，然后自己借助 `@system.is_pressed` 实现一个输入处理系统，让文本框更灵活地移动。

### 下一步

相信你已经对 Selene 有了全面的认识，接下来你可以按照你的想法制作一个真正有趣的游戏，或者按照你的需求改进 Selene 引擎。另外，Selene 不仅可以用来制作游戏，也可以用来制作任何 GUI 应用。
