local lzn = require "lz.n"
local map = lzn.keymap {
  "telescope.nvim",
  cmd = "Telescope",
  load = function(name)
    vim.cmd.packadd(name)
    vim.cmd.packadd "telescope-fzf-native.nvim"
  end,
  before = function()
    lzn.trigger_load "which-key.nvim"
    require("which-key").add {
      "<leader>f",
      group = "+Telescope",
      icon = " ",
    }
  end,
  after = function()
    local T = require "telescope"
    T.setup {
      defaults = {
        file_ignore_patterns = { ".git/", "result/", "dist/", "build/", "target/" },
        layout_config = { prompt_position = "top" },
        mappings = { i = { ["<C-j>"] = "preview_scrolling_down", ["<C-k>"] = "preview_scrolling_up" } },
        prompt_prefix = "   ",
        sorting_strategy = "ascending",
      },
    }
    -- Enable telescope extensions, if they are installed
    pcall(T.load_extension, "fzf")
  end,
}

map.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find Files in cwd" })

map.set("n", "<leader>fs", function()
  require("telescope.builtin").live_grep()
end, { desc = "Find string in cwd" })

map.set("n", "<leader>fw", function()
  require("telescope.builtin").grep_string()
end, { desc = "Find word under cursor in cwd" })

map.set("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Find open buffers" })

map.set("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, { desc = "Find help" })

map.set("n", "<leader>fk", function()
  require("telescope.builtin").keymaps()
end, { desc = "Find keymaps" })

return {}
