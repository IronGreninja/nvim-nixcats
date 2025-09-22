local theme = "onedark"

-- gruvbox-material
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_enable_bold = 1

-- kanagawa-paper
require("kanagawa-paper").setup {
  cache = true,
}

-- onedark
require("onedark").setup {
  style = "warmer",
}

vim.cmd.colorscheme(theme)

return {}
