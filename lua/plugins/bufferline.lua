return {
  "bufferline.nvim",
  event = { "DeferredUIEnter" },
  after = function()
    require("bufferline").setup {
      options = {
        indicator = { icon = "▎", style = "icon" },
        numbers = function(opts)
          return string.format("%s|%s", opts.id, opts.raise(opts.ordinal))
        end,
        always_show_bufferline = false,
      },
    }
  end,
}
