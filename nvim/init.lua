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
vim.opt.guifont = "FiraCode Nerd Font Mono:h11"
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.o.updatetime = 200
vim.opt.foldopen = "mark,percent,quickfix,search,tag,undo"
vim.opt.cursorline = true
vim.opt.hlsearch = false
-- Leader key and helper
vim.g.mapleader = " "
local map = vim.keymap.set
-- Terminal mappings (optional)
map('t', '<Esc>', '<C-\\><C-n>')
map('t', '<C-o>', '<C-\\><C-o>')

vim.api.nvim_set_hl(0, "CursorLine", {
	bg = "#181818"
})

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
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim"},
	{ src = 'https://github.com/nvim-mini/mini.icons', version = 'stable' },
	{ src = "https://github.com/hat0uma/csvview.nvim" },
	{ src = "https://github.com/nickjvandyke/opencode.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim", version = "master" },
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

local telescope = require("telescope")

telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/" },

    layout_strategy = "horizontal",
    layout_config = {
      width = 0.99,
      height = 0.99,
      vertical = {
        preview_width = 0.50,
      },
    },
  },
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"clangd",
		"tinymist",
		"pyright",
		"ruff",
		"marksman"
	},
	automatic_installation = true
})

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

require('render-markdown').setup({
	opts = {
		render_modes = {'n', 'c', 't'}
	}
}) -- only mandatory if you want to set custom options

require('mini.icons').setup()

-- CSV table view
require("csvview").setup({
	display_mode = "border",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.csv", "*.tsv" },
	callback = function()
		require("csvview").enable(vim.api.nvim_get_current_buf())
	end,
})

-- Typst preview
vim.g.typst_pdf_viewer = 'zathura'
vim.g.typst_preview_cursor_movement = 'follow'

map('n', '<leader>tp', '<cmd>TypstPreview<CR>', { desc = 'Toggle Typst preview' })
map('n', '<leader>tc', '<cmd>TypstPreviewStop<CR>', { desc = 'Stop Typst preview' })

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
		root_markers = { 'typst.toml', '.git' },
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			exportPdf = 'never',
		}
	})
	--
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

	-- Python formatter/linter (ruff)
	vim.lsp.config('ruff', {
		cmd = { 'ruff', 'server' },
		filetypes = { 'python' },
		root_markers = { 'pyproject.toml', '.git' },
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

map('n', '<leader>ff', require('telescope.builtin').find_files, {})
map('n', '<leader>fg', require('telescope.builtin').live_grep, {})
map('n', '<leader>fb', require('telescope.builtin').buffers, {})
map('n', '<leader>fh', require('telescope.builtin').help_tags, {})
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
-- Diagnostics floating on hover
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function() vim.diagnostic.open_float(nil, { focus = false }) end
})

-- Linting
local lint = require("lint")
lint.linters_by_ft = { python = { "ruff" } }
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

-- opencode.nvim
vim.o.autoread = true
vim.g.opencode_opts = {}

vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ") end, { desc = "Ask opencode…" })
vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,       { desc = "Select opencode…" })

vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
