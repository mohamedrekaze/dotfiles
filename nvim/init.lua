vim.opt.mouse = "a"
vim.opt.smoothscroll = true
vim.opt.tabstop = 4
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor100"
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
-- vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.expandtab = false
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.backup = false
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

require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPost",  -- load after first buffer is read
        build = function()
            -- run tsupdate asynchronously so it doesn't block startup
            vim.schedule(function()
                vim.cmd("tsupdate")
            end)
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp", "lua", "python", "javascript" },
                highlight = { enable = true, additional_vim_regex_highlighting = false },
                incremental_selection = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
    },
    {
      "diogo-ss/42-header.nvim",
        cmd = { "Stdheader" },
        keys = { {"<f1>"},
            { "<leader>h", "<cmd>Stdheader<cr>", desc = "insert or update 42 header" },
        },
      opts = {
        default_map = true,
        auto_update = true,
        user = "morekaz",
        mail = "morekaz@student.1337.ma",
        git = { enabled = true },
      },
      config = function(_, opts)
        require("42header").setup(opts)
      end,
    },
    {
        "hardyrafael17/norminette42.nvim",
        event = "BufReadPre",
        config = function()
            local norminette = require("norminette")
            norminette.setup({
                -- runonsave = true,
                maxerrorstoshow = 5,
                active = true,
                filetypes = { c = true, h = true, cpp = true, hpp = true },
            })
        end,
    },
    {
        "diogo-ss/42-c-formatter.nvim",
        cmd = "CFormat42",
        keys = {
            {"<leader>f", "<cmd>CFormat42<cr>", desc = "format with 42 c formatter"},
        },
        config = function()
            local formatter = require "42-formatter"
            formatter.setup({
                formatter = 'c_formatter_42',
                filetypes = { c = true, h = true, cpp = true, hpp = true },
				runonsave = false,
            })
        end
    },
    {
        "l3mon4d3/luasnip",
        event = "InsertEnter",
        config = function()
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/snippets" })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<c-n>"] = cmp.mapping.select_next_item(),
                    ["<c-p>"] = cmp.mapping.select_prev_item(),
                    ["<cr>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "luasnip" },
                },
            })
        end,
    },
    {
        "vague-theme/vague.nvim",
        event = "VimEnter",  -- loads on startup
    },
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "Masoninstall", "Masonuninstall" },
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        after = "mason.nvim",
        config = function()
            require("mason-lspconfig").setup()
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("gitsigns").setup()
        end,
    },
})

require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "clangd" },
    automatic_installation = true,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = { "lua_ls", "clangd" }

for _, name in ipairs(servers) do
  vim.lsp.config[name] = {
    capabilities = capabilities,
  }
end

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

-- show diagnostics in a floating window when you hold the cursor
vim.api.nvim_create_autocmd("cursorhold", {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false,
        })
    end,
})

-- colors
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=none")
vim.cmd("hi Normal guibg=#000000 ctermbg=0")
vim.api.nvim_set_hl(0, "comment", { fg = "#FFFAFA", italic = true })
