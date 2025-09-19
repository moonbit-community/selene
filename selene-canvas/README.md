# A Selene Backend with Canvas2D/JavaScript

## Installation

Import this backend with 

```shell 
moon add Milky2018/selene-canvas
```

Choose this implementation wherever the `Milky2018/selene/backend` is used. Add this in your `moon.pkg.json`:

```json 
{
  "overrides": [
    "Milky2018/selene-canvas"
  ]
}
```

## Instruction

Copy the provided [index.html](./index.html) to the root path of your project. 

Replace the source file path with your actual file path.

Build your project with 

```shell
moon build --target js
```

Run the server with any Web Server such as

```shell
python3 -m http.server 8000
```

Finally, you can play your game by accessing localhost:8000 in your browser.
