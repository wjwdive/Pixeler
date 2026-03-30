local ImageData = {}

local function getCenterColor(image, x, y, size)
  local centerX = math.floor(x + size / 2)
  local centerY = math.floor(y + size / 2)
  centerX = math.min(math.max(0, centerX), image.width - 1)
  centerY = math.min(math.max(0, centerY), image.height - 1)
  local pixelValue = image:getPixel(centerX, centerY)
  return app.pixelColor.rgbaR(pixelValue), 
         app.pixelColor.rgbaG(pixelValue), 
         app.pixelColor.rgbaB(pixelValue), 
         app.pixelColor.rgbaA(pixelValue)
end

local function getAverageColor(image, x, y, size)
  local maxX = math.min(x + size - 1, image.width - 1)
  local maxY = math.min(y + size - 1, image.height - 1)
  local sumR, sumG, sumB, sumA = 0, 0, 0, 0
  local count = 0

  for py = y, maxY do
    for px = x, maxX do
      local pixelValue = image:getPixel(px, py)
      sumR = sumR + app.pixelColor.rgbaR(pixelValue)
      sumG = sumG + app.pixelColor.rgbaG(pixelValue)
      sumB = sumB + app.pixelColor.rgbaB(pixelValue)
      sumA = sumA + app.pixelColor.rgbaA(pixelValue)
      count = count + 1
    end
  end

  if count == 0 then
    return getCenterColor(image, x, y, size)
  end

  return math.floor((sumR / count) + 0.5),
         math.floor((sumG / count) + 0.5),
         math.floor((sumB / count) + 0.5),
         math.floor((sumA / count) + 0.5)
end

function ImageData.getDownsampledColor(image, x, y, size, samplingMode)
  if samplingMode == "Center" then
    return getCenterColor(image, x, y, size)
  end
  return getAverageColor(image, x, y, size)
end

return ImageData
