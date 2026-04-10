# Selene 游戏引擎 [English](./README.md)

Selene 是一个面向 MoonBit 的 ECS 游戏引擎，采用 WebGPU 作为 Web 主线后端，并提供 raylib 原生后端。

## 包结构

| 包名 | 作用 |
| --- | --- |
| `Milky2018/selene` | 核心 ECS/运行时模块（`app`、`ecs`、`system`、`state`、`commands`、`event`、`asset2`、`physics2d/3d`、`render2d/3d`、`ui`） |
| `Milky2018/selene_webgpu` | Web 后端实现 |
| `Milky2018/selene_raylib` | 原生后端实现（raylib） |
| `Milky2018/selene_tools` | CLI 工具（包含资源嵌入工具） |
| `Milky2018/selene_editor_shared` | 编辑器共享协议与桥接契约 |
| `Milky2018/selene_editor_frontend` | 编辑器浏览器前端与预览运行时 |
| `Milky2018/selene_editor_service` | 编辑器本地原生服务（HTTP/RPC/SSE） |

## 当前方向

- 对齐 Bevy 语义的运行时（状态流、系统集合、类型化事件、命令队列刷写）
- 统一渲染提交流程（`RenderExtract -> RenderPrepare -> Render`）
- 同一引擎内支持 2D + 3D 玩法
- 以 WebGPU 为功能基准，raylib 明确作为降级后端

## 运行 Web 示例

```bash
cd examples
moon update
moon build --release
python3 -m http.server 8000
```

打开 `http://localhost:8000/index.html`。

## UI 位于 2D 和 3D 之上

Selene 的帧提交流程现在固定为：

1. `frame3d`
2. `frame2d.world_commands`
3. `frame2d.ui_commands`

所有 HUD、菜单和说明层都应走 `selene/ui`。  
顶层 UI 由“带 `@ui.Node` 且没有 UI 父节点”的实体定义。  
默认布局空间是屏幕空间；如果项目需要跟随虚拟分辨率缩放 HUD，可配置 `@ui.set_ui_scale_mode(@ui.UiScaleMode::Viewport)`。

## raylib 原生资源嵌入（可选）

这是一个可选的优化与打包流程，主要用于原生发布。  
默认可以不开启，直接从文件系统加载资源。

先安装 CLI：

```bash
moon install Milky2018/selene_tools/cmd/selene-embed-assets
```

然后在原生入口包的 `moon.pkg` 中添加 pre-build：

```moonbit
options(
  "pre-build": [
    {
      "input": "<your-assets-dir>",
      "output": "_embedded_assets.pack",
      "command": "selene-embed-assets --assets-dir $input --pack-out $output --path-prefix <runtime-prefix>",
    },
    {
      "input": "<your-assets-dir>",
      "output": "embedded_assets_index.mbt",
      "command": "selene-embed-assets --assets-dir $input --index-out $output --path-prefix <runtime-prefix> --blob-name embedded_assets_blob --lookup-fn get_embedded_asset",
    },
    {
      "input": "_embedded_assets.pack",
      "output": "embedded_assets_blob.mbt",
      "command": ":embed --binary -i $input -o $output --name embedded_assets_blob",
    },
  ],
)
```

两个 `<your-assets-dir>` 需要保持一致，`<runtime-prefix>` 需要与运行时资源路径前缀一致。

只有在开启嵌入时，才需要在 `app.run()` 前注册查询函数：

```moonbit
@asset.set_io(get_embedded_asset)
```

如果没有开启嵌入，不需要调用这个 API。

## 文档

- 英文教程：[docs/tutorial-en.md](./docs/tutorial-en.md)
- 中文教程：[docs/tutorial-zh.md](./docs/tutorial-zh.md)
- 更新日志：[docs/CHANGELOG.md](./docs/CHANGELOG.md)
- 示例：[examples](./examples/)

## 许可证

Apache-2.0
