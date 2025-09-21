local opts = {
  lsp = {
    progress = {
      enabled = false, -- use fidget.nvim
    },
  },
  messages = { view = "mini" },
}

return {
  "noice.nvim",
  event = "DeferredUIEnter",
  before = function()
    require("notify").setup {
      timeout = 3000,
      render = "compact",
      stages = "fade",
    }
  end,
  after = function()
    require("noice").setup(opts)
  end,
}
