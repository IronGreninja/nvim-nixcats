local this = "plugins.mini."

local Mini = {}

Mini.icons = {
  opts = {},
  after = function()
    MiniIcons.mock_nvim_web_devicons()
  end,
}

Mini.comment = {}

Mini.files = {
  opts = {
    content = {
      filter = function(fs_entry)
        local hidden = { [".git"] = 1, [".direnv"] = 1 }
        return not hidden[fs_entry.name]
      end,
    },
    options = { permanent_delete = false, use_as_default_explorer = true },
    windows = { preview = true },
  },
  after = function()
    require("lz.n").trigger_load "which-key.nvim"
    require("which-key").add {
      "<leader>e",
      group = "+Explorer",
      icon = "󰙅 ",
    }

    local map = require("utils").map
    map("n", "<leader>eo", ":lua MiniFiles.open()<CR>", "Open File Explorer")
    map("n", "<leader>eF", ":lua MiniFiles.open(nil, false)<CR>", "Open fresh explorer in cwd")
    map(
      "n",
      "<leader>eF",
      ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>",
      "Open fresh explorer in directory of current file"
    )
  end,
}

Mini.surround = {}

Mini.pairs = {
  opts = {
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_unbalanced = true,
    markdown = true,
  },
  after = require(this .. "pairs"),
}

return {
  "mini.nvim",
  event = "DeferredUIEnter",
  after = function()
    for k, v in pairs(Mini) do
      local opts = v.opts or {}
      require("mini." .. k).setup(opts)
      if v.after and type(v.after) == "function" then
        v.after(opts)
      end
    end
  end,
}
