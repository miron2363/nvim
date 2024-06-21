return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
    "nvim-telescope/telescope-dap.nvim",
	},
	config = function()
		require("telescope").setup({
			defaults = {
        file_ignore_patterns = {
          "%.png"
        },

				mappings = {
					i = {
						["<esc>"] = require("telescope.actions").close,
					},
				},

			},

			pickers = {
				colorscheme = {
					enable_preview = true,
				},
			},

			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("dap")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find by Grep" })
		vim.keymap.set("n", "<leader>fb", builtin.builtin, { desc = "Find builtin Telescope" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find Diagnostics" })
		vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = 'Find Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = 'Find resume' })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = 'Find help tags' })
		vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find symbols" })
		vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Find symbols in workspace" })
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {desc = "Lsp actions"});

		vim.keymap.set(
			"n",
			"<leader><leader>",
			"<cmd>lua require('telescope.builtin').buffers{path_display = {'tail'}, sort_mru = true, ignore_current_buffer = true}<CR>",
			{ desc = "Find open buffers" }
		)


		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>fn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Find Neovim files" })
	end,
}
