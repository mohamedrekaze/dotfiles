-- Basic settings
vim.opt.expandtab = false
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor100"
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
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

-- Key mappings
map('t', '␛', "␜␎")
map('t', '␏', "␜␏")

-- Load plugins
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
})

-- Setup after plugins are loaded
vim.defer_fn(function()
    -- Setup 42 utils
    require("utils_42")
    
    -- Setup mason
    require("mason").setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })
    
    -- Setup mason-lspconfig
    require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "tinymist", "pyright" },
        automatic_installation = true,
    })
    
    -- Setup cmp
    local cmp = require('cmp')
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ['<C-n>']     = cmp.mapping.select_next_item(),
            ['<C-p>']     = cmp.mapping.select_prev_item(),
            ['<CR>']      = cmp.mapping.confirm({ select = true }),
            ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        }, {
            { name = 'buffer' },
            { name = 'path' },
        })
    })
    
    -- Setup LSP
    setup_lsp()
    
    -- Setup colorscheme
    require("vague").setup({ transparent = true })
    vim.cmd("colorscheme vague")
    vim.cmd("hi statusline guibg=NONE")
    vim.api.nvim_set_hl(0, "Comment", { fg = "#656665", italic = false })
    
    print("Configuration loaded successfully!")
end, 100)

-- LSP Setup Function
function setup_lsp()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    
    -- Common on_attach function for all LSP servers
    local on_attach = function(client, bufnr)
        -- Enable completion
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
        -- Diagnostic configuration (ENABLE virtual text to see errors)
        vim.diagnostic.config({
            virtual_text = true,  -- CHANGED: true to see inline errors
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = "rounded",
                source = "always",
                width = 60,
            },
        })
        
        -- Key mappings
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        map('n', 'K', vim.lsp.buf.hover, bufopts)
        map('n', 'gd', vim.lsp.buf.definition, bufopts)
        map('n', 'gr', vim.lsp.buf.references, bufopts)
        map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        map('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        map('n', '<leader>lf', vim.lsp.buf.format, bufopts)
    end
    
    -- Setup individual LSP servers using vim.lsp.config (Neovim 0.11+)
    vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    })
    
    vim.lsp.config('clangd', {
        cmd = { 'clangd' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        root_markers = { 'compile_commands.json', 'compile_flags.txt', '.clangd', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
    })
    
    vim.lsp.config('tinymist', {
        cmd = { 'tinymist' },
        filetypes = { 'typst' },
        root_markers = { '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
    })
    
    vim.lsp.config('ts_ls', {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
    })
    
    vim.lsp.config('pyright', {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                }
            }
        }
    })
    
    -- Enable the configured servers
    vim.lsp.enable({ 'lua_ls', 'clangd', 'tinymist', 'ts_ls', 'pyright' })
end

-- Show diagnostics in a floating window when you hold the cursor
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false,
        })
    end,
})

-- Cord.nvim update handler
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(opts)
    if opts.data.spec.name == 'cord.nvim' and opts.data.kind == 'update' then 
      vim.cmd 'Cord update'
    end
  end
})
