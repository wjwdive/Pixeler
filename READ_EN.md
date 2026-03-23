# Pixeler - Pixel Art Converter Plugin for Aseprite

Pixeler is an advanced pixel art conversion tool designed specifically for Aseprite. It quickly transforms regular images or photos into retro-aesthetic pixel art assets, supporting multiple bit-depth simulations, dithering algorithms, and classic game palettes.

## Key Features

- **Physical Downsampling**: Not just visual pixelation, but actual image resolution reduction for ready-to-use game assets.
- **Full Bit-Depth Support**: From 1-bit (B&W) to 32-bit (Full Color), including 2-bit (GameBoy style) and 4-bit (16 Colors) simulations.
- **Classic Palette Presets**: Built-in 30+ retro game palettes (NES, GameBoy, Commodore 64, PICO-8, etc.) for instant classic aesthetics.
- **Advanced Dithering Algorithms**: 
  - Ordered Dithering (Bayer 2x2, 4x4, 8x8)
  - Cluster Dot (Halftone 4x4)
  - Error Diffusion (Floyd-Steinberg)
- **Extreme Performance Optimization**: Memory-optimized for large image processing using direct image manipulation logic to prevent Aseprite hangs.
- **Internationalization (i18n)**: Automatically adapts to Aseprite system language (Chinese, English, Japanese).
- **Smart Workflow**: Automatically creates new layers, switches focus, and selects the generated asset region upon application.

## Installation

1. Place the `Pixeler` folder into the Aseprite scripts directory (`File > Scripts > Open Scripts Folder`).
2. Alternatively, compress the folder into a `.zip`, rename it to `.aseprite-extension`, and drag it into Aseprite to install.
3. Restart Aseprite or click `File > Scripts > Rescan Scripts Folder`.

## How to Use

1. Open an image you want to convert in Aseprite.
2. Navigate to `Edit > Pixeler - Pixel Art Converter`.
3. **Pixel Size**: Adjust the slider to set the downsampling factor (1x is original size).
4. **Color Mode**: Choose your desired color complexity.
5. **Preset Palette**: Select a classic game palette in low bit-depth modes.
6. **Dither Method**: Choose a dithering mode to add color transition details.
7. Click **Apply**, and the plugin will automatically generate and select the scaled pixel art asset for you.

## Modular Structure

- `pixeler.lua`: Main entry and execution control.
- `modules/algo_core.lua`: Core conversion and dithering algorithms.
- `modules/palette_lib.lua`: Built-in retro palette library.
- `modules/ui_manager.lua`: Interaction UI management.
- `modules/i18n.lua`: Multi-language localization support.
- `modules/renderer.lua`: Image rendering and layer operations.
- `modules/image_data.lua`: Pixel data preprocessing.

---
Developed by wjwdive to boost your pixel art productivity.
