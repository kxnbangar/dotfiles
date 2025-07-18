-----------------------------
---System Dependencies ------
-----PyRight
-----Lua Language Server
-----Stylua
-----------------------------

require("bootstrap")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-------------
-- Plugins --
-------------
local cat_colors = {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000
}

local nvim_lspconfig = {
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")
		lspconfig.pyright.setup {}
		lspconfig.lua_ls.setup {}
	end
}

local formatters = {
	"stevearc/conform.nvim",
	event = { 'BufWritePre' },
	cmd = { 'ConformInfo' },
	keys = {
		{
			'<leader>f',
			function()
				require('conform').format { async = true, lsp_format = 'fallback' }
			end,
			mode = '',
			desc = '[F]ormat buffer',
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_format" }
	},
	formatters = {
		stylua = {
			command = "stylua" },
	}
}

local auto_completions = {
	"saghen/blink.cmp",
	event = "VimEnter",
	dependencies = {
		"L3MON4D3/LuaSnip",
		build = (function()
			return 'make install_jsregexp'
		end)(),
		opts = {}
	},
	opts = {
		keymap = { preset = "default" },
		fuzzy = { implementation = "lua" }
	}
}

require("lazy").setup({
	spec = { cat_colors,
		nvim_lspconfig,
		formatters,
		auto_completions }
})

vim.cmd.colorscheme "catppuccin-frappe"

-- ----------
-- Options --
-- ----------
vim.o.number = true
vim.o.relativenumber = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.tabstop = 4
