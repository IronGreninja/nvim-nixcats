return {
  "lualine.nvim",
  event = "DeferredUIEnter",
  after = function()
    vim.opt.showmode = false
    require("lualine").setup {
      options = {
        component_separators = "|",
        globalstatus = true,
        icons_enabled = true,
        section_separators = "",
      },
      sections = {
        lualine_a = { { "mode" } },
        lualine_b = { { "branch", icon = "" } },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = " ", readonly = " " } },
          { "diff" },
        },
        lualine_x = {
          {
            function()
              local buf_ft = vim.api.nvim_get_option_value("filetype", {})

              -- List of buffer types to exclude
              local excluded_buf_ft = { "toggleterm", "NvimTree", "neo-tree", "TelescopePrompt" }

              -- Check if the current buffer type is in the excluded list
              for _, excluded_type in ipairs(excluded_buf_ft) do
                if buf_ft == excluded_type then
                  return ""
                end
              end

              -- Get the name of the LSP server active in the current buffer
              local clients = vim.lsp.get_clients()
              local msg = ""

              -- if no lsp client is attached then return the msg
              if next(clients) == nil then
                return msg
              end

              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end

              return msg
            end,
            icon = " ",
          },
          {
            "diagnostics",
            always_visible = false,
            sources = { "nvim_lsp", "nvim_diagnostic" },
            update_in_insert = false,
          },
        },
        lualine_y = { { "filetype", icon_only = true }, "encoding", { "fileformat" } },
        lualine_z = { { "progress", separator = "" }, { "location", separator = "" } },
      },
    }
  end,
}
