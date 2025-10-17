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
vim.o.updatetime = 200

local map = vim.keymap.set
vim.g.mapleader = " "

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- suppress deprecation warnings from lspconfig
vim.notify = (function(orig)
  return function(msg, level, opts)
    if msg:match("require%(\'lspconfig\'%) \"framework\" is deprecated") then
      return
    end
    orig(msg, level, opts)
  end
end)(vim.notify)

-- plugin list (converted from your vim.pack block)
require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim" },
  { "L3MON4D3/LuaSnip" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "saadparwaiz1/cmp_luasnip" },
  { "lewis6991/gitsigns.nvim" },
  { "tigran-sargsyan-w/nvim-42-format" },
  { "Diogo-ss/42-header.nvim" },
  { "hardyrafael17/norminette42.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "vague2k/vague.nvim" },
})

require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "clangd", "pyright", "tinymist" },
    automatic_installation = true,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { "lua_ls", "clangd", "pyright" }

for _, name in ipairs(servers) do
    if vim.lsp.config[name] then
        vim.lsp.config[name] = vim.tbl_deep_extend('force', vim.lsp.config[name], {
            capabilities = capabilities
        })
    end
    vim.lsp.enable(name)
end

require("utils_42")

map('t', '', "␎")
map('t', '␏', "␏")
map('n', '<leader>lf', vim.lsp.buf.format)

local cmp = require 'cmp'
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-n>']     = cmp.mapping.select_next_item(),         -- move down
        ['<C-p>']     = cmp.mapping.select_prev_item(),         -- move up
        ['<CR>']      = cmp.mapping.confirm({ select = true }), -- accept suggestion
        ['<C-Space>'] = cmp.mapping.complete(),                 -- manually trigger
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
    virtual_text = false,
    signs = true,
    float = {
        border = "rounded",
        source = "always", -- show source in popup
        width = 60,
    },
})

-- Show diagnostics in a floating window when you hold the cursor
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false,
        })
    end,
})

-- colors
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
vim.api.nvim_set_hl(0, "Comment", { fg = "#A0A0A0", italic = true })
