local Renderer = {}

function Renderer.renderToLayer(sprite, layerName, image, width, height, shouldSelect)
  local targetLayer = nil
  for i, layer in ipairs(sprite.layers) do
    if layer.name == layerName then
      targetLayer = layer
      break
    end
  end
  
  if not targetLayer then
    targetLayer = sprite:newLayer()
    targetLayer.name = layerName
  end
  
  local cel = sprite:newCel(targetLayer, 1, image)
  
  if shouldSelect then
    app.activeLayer = targetLayer
    sprite.selection:select(Rectangle(0, 0, width, height))
  end
  
  app.refresh()
  return targetLayer
end

return Renderer
