# Selene 游戏引擎 [English](./README.md)

## 目录结构

[examples](examples/) 目录包含示例游戏项目。

[selene-core](selene-core/) 是 Selene 引擎核心项目。

[selene-webgpu](selene-webgpu/) 是官方维护的基于 Canvas2D API 的 Selene 后端。Selene 引擎必须要在一个后端运行。

[selene-raylib](selene-raylib/) 是 Selene 的原生后端。

## Raylib 原生资源嵌入

在使用 raylib 构建原生游戏时，请先安装 Selene 的资源打包 CLI，并在 `pre-build` 中使用：

```bash
moon install Milky2018/selene_tools/cmd/selene-embed-assets
```

然后在游戏包的 `moon.pkg` 里配置：

```moonbit
options(
  "pre-build": [
    {
      "input": "<assets-dir>",
      "output": "_embedded_assets.pack",
      "command": "selene-embed-assets --assets-dir <assets-dir> --pack-out $output --path-prefix <runtime-prefix>",
    },
    {
      "input": "<assets-dir>",
      "output": "embedded_assets_index.mbt",
      "command": "selene-embed-assets --assets-dir <assets-dir> --index-out $output --path-prefix <runtime-prefix> --blob-name embedded_assets_blob --lookup-fn get_embedded_asset",
    },
    {
      "input": "_embedded_assets.pack",
      "output": "embedded_assets_blob.mbt",
      "command": ":embed --binary -i $input -o $output --name embedded_assets_blob",
    },
  ],
)
```

两个 pre-build 步骤里的 `<assets-dir>` 要保持一致，`<runtime-prefix>` 要和运行时资源路径前缀一致。

在 `app.run()` 之前注册嵌入资源查询函数：

```moonbit
@backend.set_embedded_assets(get_embedded_asset)
```

## 写给 [MGPIC 2025 全球编程创新挑战](https://www.moonbitlang.cn/2025-mgpic)参赛选手

原则上比赛只要求输出静态 HTML 5 游戏，核心逻辑用 MoonBit 开发，具体实现方式是开放的。鼓励选手头脑风暴，自己手搓一切。比如，选手可以自己选择用哪些 Web API，手写 JavaScript FFI，或者使用 [rabbit-tea](https://github.com/moonbit-community/rabbit-tea) 绘制界面，亦或者为某个现有引擎编写 MoonBit Extension，然后用引擎来完成游戏。（实现跨平台兼容性是加分项哦）

而对于期望更专注于游戏上层逻辑的选手，基于 Selene 引擎开发游戏是一个非常友好的入门方式。

关于 Selene 引擎，参考 [README](./selene-core/README.md), [中文教程](./docs/tutorial-zh.md), [游戏样例](./examples/).

## 版本兼容性

从2025年8月10日开始至比赛结束，0.10.x 版本会一直保持稳定，不会引入破坏性改动。

比赛结束后，本项目会继续维护，但不保证向后兼容。

欢迎贡献！
