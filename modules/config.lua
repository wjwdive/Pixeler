local Config = {
  pixelSize = 4,
  samplingMode = "Average",
  colorMode = "1-bit (B&W)",
  selectedPalette = "Default (B&W)",
  ditherMethod = "None",
  autoPreview = true,

  sampling = {
    AVERAGE = "Average",
    CENTER = "Center"
  },
  
  -- Supported Modes
  modes = {
    ONE_BIT = "1-bit (B&W)",
    TWO_BIT = "2-bit (4 Colors)",
    FOUR_BIT = "4-bit (16 Colors)",
    EIGHT_BIT = "8-bit (256 Colors)",
    SIXTEEN_BIT = "16-bit (High Color)",
    THIRTY_TWO_BIT = "32-bit (Full Color)",
    CURRENT_PALETTE = "Current Palette",
    ORIGINAL = "Original Palette"
  },
  
  -- Dithering Options
  dithering = {
    NONE = "None",
    BAYER_2 = "Bayer 2x2",
    BAYER_4 = "Bayer 4x4",
    BAYER_8 = "Bayer 8x8",
    CLUSTER = "Cluster 4x4",
    FLOYD = "Floyd-Steinberg"
  }
}

return Config
