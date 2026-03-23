local i18n = {
  ["en"] = {
    title = "Pixeler - Pixel Art Converter",
    base_settings = "Base Settings",
    pixel_size = "Pixel Size:",
    color_control = "Color Control",
    color_mode = "Color Mode:",
    preset_palette = "Preset Palette:",
    dither_method = "Dither Method:",
    preview_apply = "Preview & Apply",
    auto_preview = "Auto Preview",
    refresh_preview = "Refresh Preview",
    apply = "Apply",
    cancel = "Cancel",
    no_sprite = "Please open a sprite first!",
    calculating = "Calculating preview...",
    default = "Default",
    none = "None"
  },
  ["zh-CN"] = {
    title = "Pixeler - 像素风格转换器",
    base_settings = "基础设置",
    pixel_size = "像素大小:",
    color_control = "色彩控制",
    color_mode = "位深模式:",
    preset_palette = "预设色板:",
    dither_method = "抖动算法:",
    preview_apply = "预览与应用",
    auto_preview = "实时预览",
    refresh_preview = "刷新预览",
    apply = "确定应用",
    cancel = "取消",
    no_sprite = "请先打开一个作品！",
    calculating = "正在计算预览...",
    default = "默认",
    none = "无"
  },
  ["ja"] = {
    title = "Pixeler - ドット絵コンバーター",
    base_settings = "基本設定",
    pixel_size = "ピクセルサイズ:",
    color_control = "カラー設定",
    color_mode = "カラーモード:",
    preset_palette = "パレットプリセット:",
    dither_method = "ディザリング:",
    preview_apply = "プレビューと適用",
    auto_preview = "リアルタイムプレビュー",
    refresh_preview = "プレビュー更新",
    apply = "適用",
    cancel = "キャンセル",
    no_sprite = "先に作品を開いてください！",
    calculating = "プレビューを計算中...",
    default = "デフォルト",
    none = "なし"
  }
}

local function getLanguage()
  local lang = app.preferences.general.language or "en"
  if i18n[lang] then return i18n[lang] end
  return i18n["en"]
end

return getLanguage()
