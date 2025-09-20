return {
  {
    "indent-blankline.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("ibl").setup { indent = { char = "│" }, scope = { enabled = true } }
    end,
  },
  {
    "which-key.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("which-key").setup {
        preset = "modern",
        delay = 400,
        spec = wk_specs,
      }
    end,
  },
  {
    "nvim-colorizer.lua",
    event = "DeferredUIEnter",
    after = function()
      require("colorizer").setup {
        user_default_options = { css_fn = true, mode = "virtualtext", names = true, virtualtext = "■" },
      }
    end,
  },
}
