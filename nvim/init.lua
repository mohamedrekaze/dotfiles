vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor100"
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = false
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.ignorecase = true
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.foldopen = "mark,percent,quickfix,search,tag,undo"
vim.opt.clipboard = "unnamedplus"

local map = vim.keymap.set
vim.g.mapleader = " "

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/hrsh7th/cmp-cmdline" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
})

require "mason".setup()

map('t', '', "␎")
map('t', '␏', "␏")
map('n', '<leader>lf', vim.lsp.buf.format)

vim.lsp.enable({ "lua_ls", "svelte", "tinymist", "emmetls" , "pyright"})

local cmp = require'cmp'

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(), -- move down
    ['<C-p>'] = cmp.mapping.select_prev_item(), -- move up
    ['<CR>']  = cmp.mapping.confirm({ select = true }), -- accept suggestion
    ['<C-Space>'] = cmp.mapping.complete(), -- manually trigger
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

vim.diagnostic.config({
    underline = false,
    virtual_lines = false,
    virtual_text = true,
    signs = false,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, server in ipairs({ "lua_ls", "clangd", "tinymist" , "pyright" }) do
  require('lspconfig')[server].setup {
    capabilities = capabilities,
  }
end

-- colors
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
