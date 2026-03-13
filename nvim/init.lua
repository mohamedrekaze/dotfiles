-- Basic editor settings
vim.opt.expandtab = false
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = false
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.o.updatetime = 200
vim.opt.foldopen = "mark,percent,quickfix,search,tag,undo"

-- Leader key and helper
vim.g.mapleader = " "
local map = vim.keymap.set

-- Terminal mappings (optional)
map('t', '␛', "␜␎")
map('t', '␏', "␜␏")

-- Plugins
vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/metalelf0/black-metal-theme-neovim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/hrsh7th/cmp-cmdline" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tigran-sargsyan-w/nvim-42-format"},
	{ src = "https://github.com/Diogo-ss/42-header.nvim"},
	{ src = "https://github.com/hardyrafael17/norminette42.nvim"},
	{ src = "https://github.com/vyfor/cord.nvim"},
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-lint"},
})

-- Colorscheme
require("vague").setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd("hi statusline guibg=NONE")
vim.api.nvim_set_hl(0, "Comment", { fg = "#656665", italic = false })

-- Setup after plugins load
vim.defer_fn(function()
	require("utils_42")
	-- Mason
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗"
			}
		}
	}
)

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"clangd",
		"tinymist",
		"pyright"
	},
	automatic_installation = true
}
	)

	-- Completion (nvim-cmp)
	local cmp = require('cmp')
	cmp.setup({
		mapping = cmp.mapping.preset.insert({
			['<C-n>'] = cmp.mapping.select_next_item(),
			['<C-p>'] = cmp.mapping.select_prev_item(),
			['<CR>']  = cmp.mapping.confirm({ select = true }),
			['<C-Space>'] = cmp.mapping.complete(),
		}),
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' }
		},
		{
			{ name = 'buffer' },
			{ name = 'path' }
		}
	)
})

setup_lsp()
end, 100)

-- LSP Setup
function setup_lsp()
	local capabilities = require('cmp_nvim_lsp').default_capabilities()

	local on_attach = function(client, bufnr)
		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded", source = "always", width = 60 }
		})

		local bufopts = {
			noremap = true,
			silent = true,
			buffer = bufnr
		}

		map('n', 'K', vim.lsp.buf.hover, bufopts)
		map('n', 'gd', vim.lsp.buf.definition, bufopts)
		map('n', 'gD', vim.lsp.buf.declaration, bufopts)
		map('n', 'gi', vim.lsp.buf.implementation, bufopts)
		map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
		map('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
		map('n', '<leader>lf', vim.lsp.buf.format, bufopts)
	end

	-- Lua
	vim.lsp.config('lua_ls', {
		cmd = { 'lua-language-server' },
		filetypes = { 'lua' },
		root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
		capabilities = capabilities,
		on_attach = on_attach,
		settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
	})

	-- C/C++
	vim.lsp.config('clangd', {
		cmd = { 'clangd' },
		filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
		root_markers = { 'compile_commands.json', 'compile_flags.txt', '.clangd', '.git' },
		capabilities = capabilities,
		on_attach = on_attach
	})

	-- Typst
	vim.lsp.config('tinymist', {
		cmd = { 'tinymist' },
		filetypes = { 'typst' },
		root_markers = { '.git' },
		capabilities = capabilities,
		on_attach = on_attach
	})

	-- TypeScript/JS
	vim.lsp.config('ts_ls', {
		cmd = { 'typescript-language-server', '--stdio' },
		filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
		root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
		capabilities = capabilities,
		on_attach = on_attach
	})

	-- Python
	vim.lsp.config('pyright', {
		cmd = { 'pyright-langserver', '--stdio' },
		filetypes = { 'python' },
		root_markers = { 'pyproject.toml', '.git' },
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "strict",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
					autoImportCompletions = true,
					pythonPath = "/full/path/to/your/venv/bin/python"
				}
			}
		}
	})
end

-- Diagnostics floating on hover
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function() vim.diagnostic.open_float(nil, { focus = false }) end
})

-- Linting
local lint = require("lint")
lint.linters_by_ft = { python = { "flake8" } }
vim.api.nvim_create_autocmd({
	"BufWritePost",
	"BufReadPost",
	"InsertLeave"
},
{
	callback = function() lint.try_lint() end
})

-- Cord.nvim update handler
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(opts)
		if opts.data.spec.name == 'cord.nvim' and opts.data.kind == 'update' then vim.cmd 'Cord update' end
	end
})
