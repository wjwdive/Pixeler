# Pixeler - Aseprite 像素风格转换插件

Pixeler 是一款专为 Aseprite 打造的高级像素风格转换工具。它可以将普通的图片或照片快速转换为具有复古美感的像素画素材，并提供多种位深模拟、抖动算法及经典游戏色板支持。

## 主要特点

- **物理降采样 (Physical Downsampling)**: 不仅仅是视觉上的像素化，而是真实地缩小图像分辨率，产出可直接用于游戏开发的像素素材。
- **全位深支持 (Color Bit-Depth)**: 支持从 1-bit (黑白) 到 32-bit (全彩) 的多种模式，包含 2-bit (GameBoy 风格) 和 4-bit (16 色) 模拟。
- **经典色板预设 (Retro Palettes)**: 内置超过 30 种复古游戏色板（如 NES, GameBoy, Commodore 64, PICO-8 等），一键适配经典风格。
- **多样化抖动算法 (Advanced Dithering)**: 
  - 有序抖动 (Bayer 2x2, 4x4, 8x8)
  - 丛集抖动 (Cluster Dot 4x4)
  - 误差扩散 (Floyd-Steinberg)
- **极致性能优化**: 针对大图处理进行了内存优化，采用直接图像操作逻辑，避免 Aseprite 卡死。
- **国际化支持 (i18n)**: 自动适配 Aseprite 系统语言，支持中文、英文、日文。
- **智能工作流**: 转换完成后自动创建新图层、切换图层并选中生成的素材区域。

## 安装方法

1. 将 `Pixeler` 文件夹放置到 Aseprite 的脚本目录下（`文件 > 脚本 > 打开脚本文件夹`）。
2. 或者将文件夹压缩为 `.zip`，改名为 `.aseprite-extension` 后拖入 Aseprite 安装。（‼️这种方式安装目前有问题，需要重启Aseprite,且无法使用，建议使用加载脚本方式安装）
3. 重启 Aseprite 或点击 `文件 > 脚本 > 刷新脚本列表`。

## 使用说明

1. 在 Aseprite 中打开一张想要转换的图片。
2. 导航至 `编辑 (Edit) > Pixeler - 像素转换器`。
3. **像素大小 (Pixel Size)**: 调整滑块设置降采样倍率（1x 为原始尺寸）。
4. **位深模式 (Color Mode)**: 选择想要的色彩复杂度。
5. **预设色板 (Preset Palette)**: 在低位深模式下选择经典的复古游戏色板。
6. **抖动算法 (Dither Method)**: 选择合适的抖动模式以增加色彩过渡细节。
7. 点击 **确定应用 (Apply)**，插件将自动为您生成并选中缩放后的像素素材。

## 模块化结构

- `pixeler.lua`: 插件主入口与执行控制。
- `modules/algo_core.lua`: 核心转换与抖动算法。
- `modules/palette_lib.lua`: 内置复古色板库。
- `modules/ui_manager.lua`: 交互界面管理。
- `modules/i18n.lua`: 多语言本地化支持。
- `modules/renderer.lua`: 图像渲染与图层操作。
- `modules/image_data.lua`: 像素数据预处理。

---
由 wjwdive 开发，旨在提升像素艺术创作效率。
