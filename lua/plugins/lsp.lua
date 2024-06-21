return {
  "neovim/nvim-lspconfig",
  event = "VimEnter",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "artemave/workspace-diagnostics.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    vim.diagnostic.config({
      float = { border = "rounded" },
    })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gi", require("telescope.builtin").lsp_implementations, "Goto Implementation")
        map("gr", require("telescope.builtin").lsp_references, "Goto References")
        map("gl", "<cmd>ClangdSwitchSourceHeader<Cr>", "Goto linked file (src / header)")

        map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>li", "<cmd>LspInfo<CR>", "Info")
        map("<leader>lR", "<cmd>LspRestart<CR>", "Restart")

        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
        map("K", vim.lsp.buf.hover, "Hover Documentation")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        require("workspace-diagnostics").populate_workspace_diagnostics(client, event.buf)

        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local servers = {
      clangd = {
        cmd = {
          "clangd",
          "--function-arg-placeholders=0",
        },
      },

      emmet_language_server = { },
      neocmakelsp = {},
      pyright = {},
      cssls = { },
      lemminx = { },
      marksman = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },

    }

    require("mason").setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
