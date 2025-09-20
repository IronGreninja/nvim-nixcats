return {
  {
    "nvim-lspconfig",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load { "which-key.nvim", "blink.cmp" }
    end,
    after = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),

        callback = function(event)
          local map = function(mode, key, action, desc)
            vim.keymap.set(mode, key, action, { buffer = event.buf, desc = desc })
          end

          map("n", "<leader>lgD", vim.lsp.buf.declaration, "Go to Declaration")
          map("n", "<leader>lgd", vim.lsp.buf.definition, "Go to Definition")
          map("n", "<leader>lgt", vim.lsp.buf.type_definition, "Go to Type")
          map("n", "<leader>lgi", vim.lsp.buf.implementation, "List Implementations")
          map("n", "<leader>lgr", vim.lsp.buf.references, "List References")

          map("n", "<leader>lgp", vim.diagnostic.goto_prev, "Got to prev Diagnostic")
          map("n", "<leader>lgn", vim.diagnostic.goto_next, "Got to next Diagnostic")

          map("n", "<leader>lh", vim.lsp.buf.hover, "Trigger Hover")
          map("n", "<leader>lr", vim.lsp.buf.rename, "Rename Symbol")
          map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")

          require("which-key").add {
            { "<leader>l", group = "+LSP" },
            { "<leader>lg", group = "+Go to" },
          }

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      local D = vim.diagnostic.severity
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = "rounded", source = true },
        -- underline = { severity = D.ERROR },
        signs = {
          text = {
            [D.ERROR] = "󰅚 ",
            [D.WARN] = "󰀪 ",
            [D.INFO] = "󰋽 ",
            [D.HINT] = "󰌶 ",
          },
        },
        virtual_text = false,
      }

      vim.lsp.enable {
        "lua_ls",
        "clangd",
        "pyright",
        "nixd",
      }
    end,
  },
  {
    "nvim-lint",
    event = "DeferredUIEnter",
    after = function()
      local for_c = { "clangtidy" }
      require("lint").linters_by_ft = {
        c = for_c,
        cpp = for_c,
        python = { "ruff" },
      }

      -- Lint on read, write & insert leave
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint(nil, { ignore_errors = true })
        end,
      })
    end,
  },
}
