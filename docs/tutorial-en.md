# Selene Tutorial (English)

This tutorial will help you quickly experience the Selene game engine.

## Understanding Selene

Selene is an experimental game engine that encourages users to unleash their creativity based on the fundamental features of programming.

Selene has the following characteristics:

- Free and open source
- Simple: Very streamlined code, implemented in pure MoonBit (except for the Backend), easy to use
- Modular: Almost no coupling, you can import only the functionality you need
- Efficient: With the performance advantages of MoonBit itself and ECS architecture, it runs very fast

The shortcomings are that currently (version 0.10.0) Selene lacks many advanced features that industrial-grade engines have, such as convex polygon collision detection, 3D object rendering, gamepad support, etc. Contributions are very welcome.

## Running the Example

Make sure you have installed the [MoonBit toolchain](https://www.moonbitlang.com/download/) and learned the basics of using it.

Clone this repository:

```shell 
git clone https://github.com/Milky2018/selene.git
```

Enter the example directory:

```shell
cd example
```

Build the project using the `moon` CLI tool:

```shell
moon build --target js
```

Run with any web server, for example Python:

```shell
python -m http.server 8000
```

Or Node.js:

```shell 
npx serve .
```

After successful execution, open your browser and visit `localhost:8000` (or other port you specified) to start playing.

Next, you can try modifying some code in the source, such as adjusting the game screen size and frame rate, then rebuild and run. Soon you'll have a basic understanding of this example game and the Selene engine.

## Making Your First Game

This section will guide you through creating a simple application that controls a text box with arrow keys, giving you a complete experience of the Selene engine.

### Building the Project

Create a new MoonBit project:

```shell
moon new --path mygame --name mygame --user <YOURNAME>
cd mygame
```

Add the Selene engine and Canvas backend as dependencies:

```shell
moon add Milky2018/selene@0.10.0
moon add Milky2018/selene-canvas@0.10.0
```

> You can also get the latest version, but the following process may not run properly and you'll need to debug it yourself.

Next, you can adjust the project structure according to your preferred style. Don't forget to import Selene's various packages in `moon.pkg.json`:

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

Now you can start creating a new game App. Instantiate an App in the main function:

```moonbit
fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .run()
}
```

Note that we used a backend called `CanvasBackend` to run the game. Selene supports modular backends. When using the `CanvasBackend` backend, our game will be built as a JavaScript file describing a Canvas2D canvas. Now use the `build` command and specify js as MoonBit's compilation backend to build the game project:

```shell 
moon build --target js
```

After successful building, you'll get a target directory containing the compilation artifacts. To display this canvas, we need an HTML file. Create an `index.html` file in the project root directory and fill it with the following content:

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

Now, use any simple web server to run this web page. For example, using Python3:

```shell
python -m http.server 8000
# Or
python3 -m http.server 8000
```

You should see the following information in the terminal:

```shell
Serving HTTP on :: port 8000 (http://[::]:8000/) ...
```

This indicates that the game server is running. Open your commonly used browser and visit `localhost:8000` to play your game. Of course, now there should only be a pure white canvas, and we need to add various interesting content to it.

### The First System

Selene's running logic is to cyclically execute a series of callback functions called Systems at a specific frame rate (default is 60). Systems contain updates to the game state, or render objects in the game world to the screen, which in our game means drawing to the canvas element.

Now, let's try drawing a rectangle. We add a function that draws a rectangle as a System to the App:

```moonbit
fn main {
  @system.App::new(@canvas.CanvasBackend::new()) // Choose CanvasBackend as the backend
  .add_system(stroke_render_pipe)                // Add the rectangle drawing system
  .run()
}

fn stroke_render_pipe(backend : &@system.Backend) -> Unit {
  backend.draw_stroke_rect( // Call the backend's rectangle drawing function
    x=100,                  // Set the rectangle's coordinates
    y=100,
    width=50,               // Set the rectangle's width and height
    height=50,
    color="blue",           // Set the rectangle's color
  )
}
```

Run the game again, and we'll see a blue rectangle in the canvas.

### The First Entity

In `stroke_render_pipe`, we manually drew a rectangle using the `draw_stroke_rect` method provided by `Backend`. We generally don't need to manually call the low-level methods provided by `Backend`. Selene already provides many useful Systems and Initializers internally to accomplish this. For example, the `sprite` package provides a system called `render_sprite_system`, which will draw all Sprites to their corresponding places.

To use such functionality, we need to create simple Sprites. For example, we can create a text box filled with "Hello World" text and set it to black:

```moonbit
let box = @system.Entity::new()
let text = @sprite.Sprite::new_text(@sprite.Text::new("Hello World", color="black"), 10)
@position.positions.set(box, @math.Vec2D(100, 100))
@sprite.sprites.set(box, text)
```

Let's see what we did:

1. Generate a new Entity;
2. Generate a new text box component;
3. Set the new Entity's position to (100, 100);
4. Set the text box component to the new Entity.

Entity is like a reference, we associate all components belonging to an entity through the `Map[K, V]::set` method. Both `@position.positions` and `@sprite.sprites` are hash map type data structures that store the corresponding components for each entity.

> The second parameter of `new_text(text : Text, zindex : Int)` represents the vertical height of this Sprite. Sprites with larger zindex values will cover Sprites with smaller zindex values.

> The coordinates represented by @math.Vec2D may be different from what you learned in math class: the y-axis is downward.

So, where do we generate this text box? Anywhere! Our recommended method is to put it in the App's Initializers, so it will only be executed once when the project starts, since we don't need to generate a text box every frame:

```moonbit
fn add_hello_text(_ : &@system.Backend) -> Unit {
  let box = @system.Entity::new()
  let text = @sprite.Sprite::new_text(@sprite.Text::new("Hello World", color="white"), 10)
  @position.positions.set(box, @math.Vec2D(100, 100))
  @sprite.sprites.set(box, text)
}

fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  // Add an initializer, initializers only execute once when the game starts
  .add_initializer(add_hello_text)
  .add_system(@sprite.render_sprite_system)
  .run()
}
```

Now, run your game again and you can see this text box in the canvas!

### Movement

How to make the text box move? The simplest way is to add a velocity component to it:

```moonbit
@velocity.velocities.set(box, @math.Vec2D(1.0, 1.0))
```

This component alone is not enough, we need a System that can update each entity's position component based on its velocity every frame. We could write such a System ourselves, but you probably guessed it, such a commonly used System is already provided by Selene. We just need to add `@collision.move_system` to the App. Here's the complete code:

```moonbit
fn add_hello_text(_ : &@system.Backend) -> Unit {
  let box = @system.Entity::new()
  let text = @sprite.Sprite::new_text(@sprite.Text::new("Hello World", color="black"), 10)
  @position.positions.set(box, @math.Vec2D(100, 100))  // Associate position with entity
  @sprite.sprites.set(box, text)                            // Associate text box with entity
  @velocity.velocities.set(box, @math.Vec2D(1.0, 1.0)) // Associate velocity with entity
}

fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .add_initializer(add_hello_text)
  .add_system(@collision.move_system) // Add the system that controls object movement to the App
  .add_system(@sprite.render_sprite_system)
  .run()
}
```

Run the game again, and now you can see the text box slowly moving to the bottom right!

### Handling Input

Games are the art of interaction, we want to see the content in the game world change according to our input. This time let's change our approach. Before discussing how to do it, let's look at the code first. Add `@input.simple_input_system` to the App, and set the `@input.controls` component for the text box:

```moonbit
fn add_hello_text(_ : &@system.Backend) -> Unit {
  let box = @system.Entity::new()
  let text = @sprite.Sprite::new_text(@sprite.Text::new("Hello World", color="black"), 10)
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

Then run the game and see what happens. Try pressing the arrow keys on your keyboard! The text box moves according to the key presses!

The behind-the-scenes logic to achieve all this is very simple. Let's directly read the source code of `@input.simple_input_system` and `@input.controls`:

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

When we set the `controls` component for the text box, it is added to this hash map; and inside `simple_input_system`, as long as an entity contains the `controls` component, its velocity will be updated according to the key state. The key state is stored in the `@system.pressed_keys` set, which you can access directly, or through Selene's provided `is_pressed, is_released`. In addition to arrow keys, Selene also supports many other keys. You can see the list of supported keys in [system.mbti](https://github.com/Milky2018/selene/selene-core/blob/main/src/system/system.mbti).

These are the basic steps to implement a System:

1. If you define a new component, define a data structure for this component that can associate the component with an Entity;
2. Iterate over `@system.all_entities` in the System.

> The storage data structure for components doesn't have to be a hash map, as long as your System can access it.

> Don't easily iterate specific components through `for entity, component in components`, because this might access Entities that have already been removed from `all_entities`. 

`@input.simple_input_system` is an overly simplified input handling system that is generally not used in real games. You can completely remove it from your App and implement your own input handling system using `@system.is_pressed` to make the text box move more flexibly.

### Next Steps

I believe you now have a comprehensive understanding of Selene. Next, you can create a truly interesting game according to your ideas, or improve the Selene engine according to your needs. Additionally, Selene can be used not only for making games, but also for creating any GUI application.