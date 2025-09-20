return {
  "gitsigns.nvim",
  event = "DeferredUIEnter",
  before = function()
    require("lz.n").trigger_load "which-key.nvim"
  end,
  after = function()
    require("gitsigns").setup {}

    require("which-key").add {
      "<leader>g",
      group = "+Git",
      icon = " ",
    }
    local map = require("utils").map
    local G = package.loaded.gitsigns

    map("n", "<leader>gs", G.stage_hunk, "Stage hunk")
    map("v", "<leader>gs", function()
      G.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, "Stage hunk")
    map("n", "<leader>gr", G.reset_hunk, "Reset hunk")
    map("v", "<leader>gr", function()
      G.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, "Reset hunk")
    map("n", "<leader>gS", G.stage_buffer, "Stage buffer")
    map("n", "<leader>gR", G.reset_buffer, "Reset buffer")
    map("n", "<leader>gp", G.preview_hunk, "Preview hunk")
    map("n", "<leader>gi", G.preview_hunk_inline, "Preview hunk inline")
  end,
}
