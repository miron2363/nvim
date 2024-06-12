return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

		require("neo-tree").setup({

			hijack_netrw_behavior = "open_current",
			filesystem = {
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
			},

			window = {
        position = "current",
				mappings = {
					["/"] = false,
					["?"] = false,
					["g?"] = "show_help",
          ["q"] = false,
          ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
          ["<esc>"] = false,
				},
			},

		}
    )
		vim.keymap.set(
			"n",
			"<leader>e",
			"<cmd>Neotree toggle reveal<CR>",
			{ desc = "Open file explorer" }
		)
	end,
}
