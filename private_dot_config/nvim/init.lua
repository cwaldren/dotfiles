vim.o.number = true -- Line numbers
vim.g.mapleader = " " -- Space leader
vim.g.maplocalleader = " "
vim.o.relativenumber = true -- So we can jump without math
vim.o.tabstop = 4 -- How many spaces in tab
vim.o.shiftwidth = 4 -- Indent
vim.o.expandtab = true -- Tabs -> spaces
vim.o.smartindent = true -- Autoindent new lines
vim.o.wrap = false -- No linewrap
vim.o.cursorline = true -- Highlight current line
vim.o.termguicolors = true -- Enable 24bit RGB colors
vim.o.ignorecase = true -- case-insensitive search unless \C or >= 1 capitals in term
vim.o.smartcase = true
vim.o.inccommand = "split"
vim.o.scrolloff = 10

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.grepprg = "rg --vimgrep --smart-case --follow" -- Use ripgrep

-- Make netrw a bit easier to use
vim.api.nvim_set_keymap("n", "-", ":Explore<CR>", { noremap = true, silent = true })

-- Get outta insert mode easier
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true })

-- Break the habit
vim.api.nvim_set_keymap("n", "<Up>", "<NOP>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Down>", "<NOP>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Left>", "<NOP>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Right>", "<NOP>", { noremap = true })

-- Make it easier to change windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_set_keymap("n", "<leader>nn", ":set relativenumber!<CR>", { noremap = true, silent = true })
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	spec = {
		{
			"romainl/vim-dichromatic",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd([[colorscheme dichromatic]])
			end,
		},
		{ "tpope/vim-vinegar" },
		{ "tpope/vim-projectionist", lazy = true },
		{ "tpope/vim-fugitive", cmd = { "G", "Git" } },
		{ "tpope/vim-sleuth" },
		{
			"neovim/nvim-lspconfig",
			config = function()
				local lspconfig = require("lspconfig")
				lspconfig.lua_ls.setup({
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
								},
							},
						},
					},
				})
			end,
		},
		{ "pmizio/typescript-tools.nvim",
			dependencies = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			opts = {},
		},
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end,
					mode = "",
					desc = "Format buffer",
				},
			},
			config = function()
				local cnf = require("conform")
				cnf.setup({
					formatters_by_ft = {
						lua = { "stylua" },
					},
				})
			end,
		},
		{
			"ibhagwan/fzf-lua",
			keys = {
				{
					"<c-P>",
					function()
						require("fzf-lua").files()
					end,
					desc = "Fzf files",
				},
			},
		},
		{ "nvim-tree/nvim-web-devicons", lazy = true },
		{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs",
			opts = {
				ensure_installed = {
					"bash",
					"diff",
					"html",
					"lua",
					"markdown",
					"javascript",
					"typescript",
					"json",
					"css",
				},
				auto_install = true,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			},
		},
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {},
		},
	},
	checker = { enabled = true },
})
