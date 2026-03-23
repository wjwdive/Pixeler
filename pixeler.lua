local function clamp(val, min, max)
  if val < min then return min end
  if val > max then return max end
  return val
end

local function getModulePath()
  local source = debug.getinfo(1).source
  if source:sub(1,1) == "@" then
    local path = app.fs.filePath(source:sub(2))
    return path .. app.fs.pathSeparator .. "modules" .. app.fs.pathSeparator
  end
  return nil
end

local modulesPath = getModulePath()
if not modulesPath then return end

local config = dofile(modulesPath .. "config.lua")
local algoCore = dofile(modulesPath .. "algo_core.lua")
local imageData = dofile(modulesPath .. "image_data.lua")
local renderer = dofile(modulesPath .. "renderer.lua")
local uiManager = dofile(modulesPath .. "ui_manager.lua")
local paletteLib = dofile(modulesPath .. "palette_lib.lua")
local i18n = dofile(modulesPath .. "i18n.lua")

local isProcessing = false

local function runConversion(spr, isPreview)
  if not spr or isProcessing then return end
  isProcessing = true
  
  if not isPreview then
    app.transaction(function()
      local activeCel = app.activeCel
      if not activeCel then isProcessing = false return end
      
      local img = Image(activeCel.image)
      local pixelSize = config.pixelSize
      local newWidth = math.max(1, math.floor(img.width / pixelSize))
      local newHeight = math.max(1, math.floor(img.height / pixelSize))
      local resultImage = Image(newWidth, newHeight)
      
      local errorBufferR, errorBufferG, errorBufferB
      if config.ditherMethod == config.dithering.FLOYD then
        errorBufferR, errorBufferG, errorBufferB = {}, {}, {}
      end
      local function getErrorIdx(x, y) return y * (newWidth + 1) + x end

      local getDownsampledColor = imageData.getDownsampledColor
      local quantize = algoCore.quantize
      local getNearestColor = algoCore.getNearestColor
      local mapToCustomPalette = algoCore.mapToCustomPalette
      local applyBayer = algoCore.applyBayer
      local rgba = app.pixelColor.rgba
      
      local currentPalette = (config.colorMode == config.modes.CURRENT_PALETTE) and spr.palettes[1] or nil
      local customPaletteColors = nil
      if config.selectedPalette ~= "Default" and paletteLib[config.colorMode] then
        for _, p in ipairs(paletteLib[config.colorMode]) do
          if p.name == config.selectedPalette then customPaletteColors = p.colors break end
        end
      end

      for y = 0, newHeight - 1 do
        for x = 0, newWidth - 1 do
          local r, g, b, a = getDownsampledColor(img, x * pixelSize, y * pixelSize, pixelSize)
          
          if config.ditherMethod ~= config.dithering.NONE then
            if config.ditherMethod == config.dithering.FLOYD then
              local idx = getErrorIdx(x, y)
              r = clamp(r + (errorBufferR[idx] or 0), 0, 255)
              g = clamp(g + (errorBufferG[idx] or 0), 0, 255)
              b = clamp(b + (errorBufferB[idx] or 0), 0, 255)
            else
              r, g, b = applyBayer(x, y, r, g, b, config.ditherMethod)
            end
          end

          local nr, ng, nb, na
          if customPaletteColors then nr, ng, nb, na = mapToCustomPalette(r, g, b, customPaletteColors)
          elseif currentPalette then nr, ng, nb, na = getNearestColor(r, g, b, currentPalette)
          else nr, ng, nb, na = quantize(r, g, b, config.colorMode) end
          
          if config.ditherMethod == config.dithering.FLOYD then
            local er, eg, eb = r - nr, g - ng, b - nb
            local function spreadError(nx, ny, weight)
              if nx >= 0 and nx < newWidth and ny >= 0 and ny < newHeight then
                local nidx = getErrorIdx(nx, ny)
                errorBufferR[nidx] = (errorBufferR[nidx] or 0) + er * weight
                errorBufferG[nidx] = (errorBufferG[nidx] or 0) + eg * weight
                errorBufferB[nidx] = (errorBufferB[nidx] or 0) + eb * weight
              end
            end
            spreadError(x + 1, y, 7/16); spreadError(x - 1, y + 1, 3/16)
            spreadError(x, y + 1, 5/16); spreadError(x + 1, y + 1, 1/16)
          end
          resultImage:drawPixel(x, y, rgba(nr, ng, nb, na))
        end
      end
      renderer.renderToLayer(spr, "Pixeler_Final", resultImage, newWidth, newHeight, true)
    end)
    isProcessing = false
  else
    local activeCel = app.activeCel
    if not activeCel then isProcessing = false return end
    local img = Image(activeCel.image)
    local width, height = img.width, img.height
    local pixelSize = config.pixelSize
    local resultImage = Image(width, height)
    
    local errorBufferR, errorBufferG, errorBufferB
    if config.ditherMethod == config.dithering.FLOYD then
      errorBufferR, errorBufferG, errorBufferB = {}, {}, {}
    end
    local function getErrorIdx(x, y) return y * (width + 1) + x end

    local getDownsampledColor = imageData.getDownsampledColor
    local quantize = algoCore.quantize
    local getNearestColor = algoCore.getNearestColor
    local mapToCustomPalette = algoCore.mapToCustomPalette
    local applyBayer = algoCore.applyBayer
    local rgba = app.pixelColor.rgba

    local currentPalette = (config.colorMode == config.modes.CURRENT_PALETTE) and spr.palettes[1] or nil
    local customPaletteColors = nil
    if config.selectedPalette ~= "Default" and paletteLib[config.colorMode] then
      for _, p in ipairs(paletteLib[config.colorMode]) do
        if p.name == config.selectedPalette then customPaletteColors = p.colors break end
      end
    end

    for y = 0, height - 1, pixelSize do
      for x = 0, width - 1, pixelSize do
        local r, g, b, na = getDownsampledColor(img, x, y, pixelSize)
        if config.ditherMethod ~= config.dithering.NONE then
          if config.ditherMethod == config.dithering.FLOYD then
            local idx = getErrorIdx(x, y)
            r = clamp(r + (errorBufferR[idx] or 0), 0, 255)
            g = clamp(g + (errorBufferG[idx] or 0), 0, 255)
            b = clamp(b + (errorBufferB[idx] or 0), 0, 255)
          else
            r, g, b = applyBayer(x/pixelSize, y/pixelSize, r, g, b, config.ditherMethod)
          end
        end

        local nr, ng, nb, na_out
        if customPaletteColors then nr, ng, nb, na_out = mapToCustomPalette(r, g, b, customPaletteColors)
        elseif currentPalette then nr, ng, nb, na_out = getNearestColor(r, g, b, currentPalette)
        else nr, ng, nb, na_out = quantize(r, g, b, config.colorMode) end
        
        if config.ditherMethod == config.dithering.FLOYD then
          local er, eg, eb = r - nr, g - ng, b - nb
          local function spreadError(nx, ny, weight)
            if nx >= 0 and nx < width and ny >= 0 and ny < height then
              local nidx = getErrorIdx(nx, ny)
              errorBufferR[nidx] = (errorBufferR[nidx] or 0) + er * weight
              errorBufferG[nidx] = (errorBufferG[nidx] or 0) + eg * weight
              errorBufferB[nidx] = (errorBufferB[nidx] or 0) + eb * weight
            end
          end
          spreadError(x + pixelSize, y, 7/16); spreadError(x - pixelSize, y + pixelSize, 3/16)
          spreadError(x, y + pixelSize, 5/16); spreadError(x + pixelSize, y + pixelSize, 1/16)
        end

        local pixelColor = rgba(nr, ng, nb, na_out)
        for dy = 0, pixelSize - 1 do
          for dx = 0, pixelSize - 1 do
            if x+dx < width and y+dy < height then resultImage:drawPixel(x+dx, y+dy, pixelColor) end
          end
        end
      end
    end
    renderer.renderToLayer(spr, "Pixeler_Preview", resultImage, width, height, false)
    isProcessing = false
  end
end

local function startPixeler()
  local spr = app.activeSprite
  if not spr then app.alert(i18n.no_sprite) return end
  uiManager.init(config, paletteLib, i18n, function() runConversion(spr, true) end, function() runConversion(spr, false) end)
  if config.autoPreview then runConversion(spr, true) end
end

startPixeler()
