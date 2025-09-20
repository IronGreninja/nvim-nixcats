return {
  "nvim-treesitter",
  event = "DeferredUIEnter",
  before = function()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim-treesitter#foldexpr()"
  end,
  after = function()
    require("nvim-treesitter.configs").setup {
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = false },
      incremental_selection = { enable = true },
    }
  end,
}
