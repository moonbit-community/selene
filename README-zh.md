# Selene 游戏引擎 [English](./README.md)

Selene 是一个面向 MoonBit 的 ECS 游戏引擎，提供浏览器 WebGPU 渲染。原生 WebGPU 支持在计划中。

## 包结构

| 包名 | 作用 |
| --- | --- |
| `Milky2018/selene` | 核心 ECS/运行时模块（`app`、`asset`、`animation`、`scene`、`physics2d/3d`、`render2d/3d`、`ui`） |
| `Milky2018/selene_webgpu` | Web 后端实现 |

## 快速开始

请使用 MoonBit `latest` 工具链。源码也支持 `pre-release`；在 `latest` 支持替代语法之前，
保留 `pre-release` 的语法弃用警告。

```bash
moon build --target js --release
python3 -m http.server 8000
```

打开 `http://localhost:8000/examples/index.html`。

## 文档

- 英文教程：[docs/tutorial-en.md](./docs/tutorial-en.md)
- 中文教程：[docs/tutorial-zh.md](./docs/tutorial-zh.md)
- 更新日志：[docs/CHANGELOG.md](./docs/CHANGELOG.md)
- 示例：[examples](./examples/)

## 项目状态

Selene 仍处于实验性阶段，接口和工作流会持续演进。

## 许可证

Apache-2.0
