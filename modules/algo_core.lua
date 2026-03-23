local AlgoCore = {}

local BAYER_2x2 = {
  { 0, 2},
  { 3, 1}
}

local BAYER_4x4 = {
  { 0,  8,  2, 10},
  {12,  4, 14,  6},
  { 3, 11,  1,  9},
  {15,  7, 13,  5}
}

local BAYER_8x8 = {
  { 0, 32,  8, 40,  2, 34, 10, 42},
  {48, 16, 56, 24, 50, 18, 58, 26},
  {12, 44,  4, 36, 14, 46,  6, 38},
  {60, 28, 52, 20, 62, 30, 54, 22},
  { 3, 35, 11, 43,  1, 33,  9, 41},
  {51, 19, 59, 27, 49, 17, 57, 25},
  {15, 47,  7, 39, 13, 45,  5, 37},
  {63, 31, 55, 23, 61, 29, 53, 21}
}

local CLUSTER_4x4 = {
  {12,  5,  6, 13},
  { 4,  0,  1,  7},
  {11,  3,  2,  8},
  {15, 10,  9, 14}
}

local function clamp(val, min, max)
  if val < min then return min end
  if val > max then return max end
  return val
end

function AlgoCore.toOneBit(r, g, b, threshold)
  local luminance = 0.299 * r + 0.587 * g + 0.114 * b
  return luminance > (threshold or 128) and 255 or 0, 255
end

function AlgoCore.toTwoBit(r, g, b)
  local luminance = 0.299 * r + 0.587 * g + 0.114 * b
  local v = math.floor((luminance / 85) + 0.5) * 85
  return v, v, v, 255
end

function AlgoCore.toFourBit(r, g, b)
  local v = math.floor(( (0.299*r + 0.587*g + 0.114*b) * 15 / 255) + 0.5) * (255 / 15)
  return v, v, v, 255
end

function AlgoCore.toEightBit(r, g, b)
  local nr = math.floor((r * 7 / 255) + 0.5) * 36.42
  local ng = math.floor((g * 7 / 255) + 0.5) * 36.42
  local nb = math.floor((b * 3 / 255) + 0.5) * 85
  return clamp(nr, 0, 255), clamp(ng, 0, 255), clamp(nb, 0, 255)
end

function AlgoCore.toSixteenBit(r, g, b)
  local nr = math.floor((r * 31 / 255) + 0.5) * 8.22
  local ng = math.floor((g * 63 / 255) + 0.5) * 4.04
  local nb = math.floor((b * 31 / 255) + 0.5) * 8.22
  return clamp(nr, 0, 255), clamp(ng, 0, 255), clamp(nb, 0, 255)
end

function AlgoCore.getNearestColor(r, g, b, palette)
  if not palette or #palette == 0 then return r, g, b, 255 end
  local minDistance = 1000000
  local bestR, bestG, bestB = r, g, b
  for i = 0, #palette - 1 do
    local pc = palette:getColor(i)
    local dr, dg, db = r - pc.red, g - pc.green, b - pc.blue
    local distance = dr*dr + dg*dg + db*db
    if distance < minDistance then
      minDistance = distance
      bestR, bestG, bestB = pc.red, pc.green, pc.blue
    end
  end
  return bestR, bestG, bestB, 255
end

local function hexToRgb(hex)
  return (hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff
end

function AlgoCore.mapToCustomPalette(r, g, b, paletteArray)
  if not paletteArray or #paletteArray == 0 then return r, g, b, 255 end
  local minDistance = 1000000
  local bestR, bestG, bestB = r, g, b
  for _, hex in ipairs(paletteArray) do
    local pr, pg, pb = hexToRgb(hex)
    local dr, dg, db = r - pr, g - pg, b - pb
    local distance = dr*dr + dg*dg + db*db
    if distance < minDistance then
      minDistance = distance
      bestR, bestG, bestB = pr, pg, pb
    end
  end
  return bestR, bestG, bestB, 255
end

function AlgoCore.applyBayer(x, y, r, g, b, matrixType)
  local matrix, size, factor
  if matrixType == "Bayer 2x2" then matrix, size, factor = BAYER_2x2, 2, 4
  elseif matrixType == "Bayer 4x4" then matrix, size, factor = BAYER_4x4, 4, 16
  elseif matrixType == "Bayer 8x8" then matrix, size, factor = BAYER_8x8, 8, 64
  elseif matrixType == "Cluster 4x4" then matrix, size, factor = CLUSTER_4x4, 4, 16
  else return r, g, b end
  local threshold = (matrix[(y % size) + 1][(x % size) + 1] + 0.5) / factor
  local spread = 16
  return clamp(r + (threshold - 0.5) * spread, 0, 255),
         clamp(g + (threshold - 0.5) * spread, 0, 255),
         clamp(b + (threshold - 0.5) * spread, 0, 255)
end

function AlgoCore.quantize(r, g, b, mode)
  if mode == "1-bit (B&W)" then
    local v, a = AlgoCore.toOneBit(r, g, b)
    return v, v, v, a
  elseif mode == "2-bit (4 Colors)" then return AlgoCore.toTwoBit(r, g, b)
  elseif mode == "4-bit (16 Colors)" then return AlgoCore.toFourBit(r, g, b)
  elseif mode == "8-bit (256 Colors)" then return AlgoCore.toEightBit(r, g, b)
  elseif mode == "16-bit (High Color)" then return AlgoCore.toSixteenBit(r, g, b)
  end
  return r, g, b, 255
end

return AlgoCore
