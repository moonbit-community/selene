# Selene 游戏引擎 [English](./README.md)

Selene 是一个面向 MoonBit 的 ECS 游戏引擎，采用 WebGPU 作为 Web 主线后端，并提供 raylib 原生后端，同时包含仓库内的场景编辑器栈。

## 包结构

| 包名 | 作用 |
| --- | --- |
| `Milky2018/selene` | 核心 ECS/运行时模块（`app`、`asset`、`editor_bridge`、`animation`、`scene`、`physics2d/3d`、`render2d/3d`、`ui`） |
| `Milky2018/selene_webgpu` | Web 后端实现 |
| `Milky2018/selene_raylib` | 原生后端实现 |
| `Milky2018/selene_editor_shared` | 编辑器共享协议与桥接契约 |
| `Milky2018/selene_editor_frontend` | 编辑器浏览器前端与预览运行时 |
| `Milky2018/selene_editor_service` | 编辑器本地原生服务 |

## 快速开始

```bash
cd examples
moon update
moon build --release
python3 -m http.server 8000
```

打开 `http://localhost:8000/index.html`。

## 编辑器

在仓库根目录运行：

```bash
just editor
```

这会构建前端 bundle、复制到 service，并在 `47142` 端口启动本地编辑器服务。

## 文档

- 英文教程：[docs/tutorial-en.md](./docs/tutorial-en.md)
- 中文教程：[docs/tutorial-zh.md](./docs/tutorial-zh.md)
- 更新日志：[docs/CHANGELOG.md](./docs/CHANGELOG.md)
- 示例：[examples](./examples/)

## 项目状态

Selene 仍处于实验性阶段，接口和工作流会持续演进。

## 许可证

Apache-2.0
