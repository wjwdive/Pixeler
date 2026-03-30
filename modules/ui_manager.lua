local UIManager = {}

function UIManager.init(config, paletteLib, i18n, onPreview, onApply)
  local dlg = Dialog(i18n.title)

  local function getSelectedPaletteOption()
    if config.selectedPalette == "Default" then
      return i18n.default
    end
    return config.selectedPalette
  end

  local function normalizeSelectedPalette(value)
    if value == i18n.default then
      return "Default"
    end
    return value
  end

  local function getDefaultPaletteSelection(options)
    if #options > 1 then
      return options[2]
    end
    return i18n.default
  end
  
  local function getPaletteOptions(mode)
    local options = { i18n.default }
    if paletteLib[mode] then
      for _, p in ipairs(paletteLib[mode]) do
        table.insert(options, p.name)
      end
    end
    return options
  end

  dlg:separator{ text=i18n.base_settings }
  
  dlg:slider{
    id="pixelSize",
    label=i18n.pixel_size,
    min=1,
    max=32,
    value=config.pixelSize,
    onchange=function()
      config.pixelSize = dlg.data.pixelSize
      if config.autoPreview then onPreview() end
    end
  }

  dlg:combobox{
    id="samplingMode",
    label=i18n.sampling_mode,
    option=config.samplingMode,
    options={
      config.sampling.AVERAGE,
      config.sampling.CENTER
    },
    onchange=function()
      config.samplingMode = dlg.data.samplingMode
      if config.autoPreview then onPreview() end
    end
  }
  
  dlg:separator{ text=i18n.color_control }
  
  dlg:combobox{
    id="colorMode",
    label=i18n.color_mode,
    option=config.colorMode,
    options={ 
      config.modes.ONE_BIT, 
      config.modes.TWO_BIT, 
      config.modes.FOUR_BIT, 
      config.modes.EIGHT_BIT, 
      config.modes.SIXTEEN_BIT, 
      config.modes.THIRTY_TWO_BIT,
      config.modes.CURRENT_PALETTE, 
      config.modes.ORIGINAL 
    },
    onchange=function()
      config.colorMode = dlg.data.colorMode
      local newPalettes = getPaletteOptions(config.colorMode)
      local paletteOption = getDefaultPaletteSelection(newPalettes)
      config.selectedPalette = normalizeSelectedPalette(paletteOption)
      dlg:modify{ id="selectedPalette", options=newPalettes, option=paletteOption }
      
      if config.autoPreview then onPreview() end
    end
  }

  dlg:combobox{
    id="selectedPalette",
    label=i18n.preset_palette,
    option=getSelectedPaletteOption(),
    options=getPaletteOptions(config.colorMode),
    onchange=function()
      config.selectedPalette = normalizeSelectedPalette(dlg.data.selectedPalette)
      if config.autoPreview then onPreview() end
    end
  }
  
  dlg:combobox{
    id="ditherMethod",
    label=i18n.dither_method,
    option=config.ditherMethod,
    options={ 
      i18n.none, 
      config.dithering.BAYER_2, 
      config.dithering.BAYER_4, 
      config.dithering.BAYER_8, 
      config.dithering.CLUSTER,
      config.dithering.FLOYD 
    },
    onchange=function()
      config.ditherMethod = dlg.data.ditherMethod
      if config.autoPreview then onPreview() end
    end
  }
  
  dlg:separator{ text=i18n.preview_apply }
  
  dlg:check{
    id="autoPreview",
    label=i18n.auto_preview,
    selected=config.autoPreview,
    onchange=function()
      config.autoPreview = dlg.data.autoPreview
    end
  }
  
  dlg:button{
    id="preview",
    text=i18n.refresh_preview,
    onclick=function()
      onPreview()
    end
  }
  
  dlg:button{
    id="ok",
    text=i18n.apply,
    focus=true,
    onclick=function()
      onApply()
      dlg:close()
    end
  }
  
  dlg:button{
    id="cancel",
    text=i18n.cancel,
    onclick=function()
      dlg:close()
    end
  }
  
  dlg:show{ wait=false }
  return dlg
end

return UIManager
