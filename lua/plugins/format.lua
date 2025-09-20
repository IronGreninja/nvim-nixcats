vim.g.autoformat = true

local M = {
  "conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  after = function()
    require("conform").setup {
      format_on_save = function(bufnr)
        if not (vim.g.autoformat or vim.b[bufnr].autoformat) then
          return
        end

        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        _ = { "squeeze_blanks", "trim_whitespace" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
        markdown = { "mdformat" },
        nix = { "alejandra" },
        python = { "ruff_organize_imports", "ruff_format" },
      },
      log_level = vim.log.levels.WARN,
      notify_no_formatters = true,
      notify_on_error = true,
    }
  end,
}

local cmds = {
  FormatDisable = {
    command = function(args)
      if args.bang then
        vim.b.autoformat = false
        vim.notify("Automatic formatting on save is now disabled for this buffer.", vim.log.levels.INFO)
      else
        vim.g.autoformat = false
        vim.notify("Automatic formatting on save is now disabled.", vim.log.levels.INFO)
      end
    end,
    options = { bang = true, desc = "Disable automatic formatting on save" },
  },
  FormatEnable = {
    command = function(args)
      if args.bang then
        vim.b.autoformat = true
        vim.notify("Automatic formatting on save is now enabled for this buffer.", vim.log.levels.INFO)
      else
        vim.g.autoformat = true
        vim.notify("Automatic formatting on save is now enabled.", vim.log.levels.INFO)
      end
    end,
    options = { bang = true, desc = "Enable automatic formatting on save" },
  },
  FormatToggle = {
    command = function(args)
      if args.bang then
        vim.b.autoformat = not vim.b.autoformat

        if vim.b.autoformat then
          vim.notify("Automatic formatting on save is now enabled for this buffer.", vim.log.levels.INFO)
        else
          vim.notify("Automatic formatting on save is now disabled for this buffer.", vim.log.levels.INFO)
        end
      else
        vim.g.autoformat = not vim.g.autoformat

        if vim.g.autoformat then
          vim.notify("Automatic formatting on save is now enabled.", vim.log.levels.INFO)
        else
          vim.notify("Automatic formatting on save is now disabled.", vim.log.levels.INFO)
        end
      end
    end,
    options = { bang = true, desc = "Toggle automatic formatting on save" },
  },
}
for name, cmd in pairs(cmds) do
  vim.api.nvim_create_user_command(name, cmd.command, cmd.options or {})
end

return M
