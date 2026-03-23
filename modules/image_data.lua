local ImageData = {}

function ImageData.getDownsampledColor(image, x, y, size)
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

return ImageData
