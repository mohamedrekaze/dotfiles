-- norminette42 setup
local ok, norminette = pcall(require, "norminette")
if ok then
    norminette.setup({
        runOnSave = true,
        maxErrorsToShow = 10,
        active = true,
    })
end

-- nvim-42-format setup
local ok2, formatter = pcall(require, "nvim-42-format")
if ok2 then
    formatter.setup({
        formatter = "c_formatter_42",
        filetypes = { c = true, h = true, cpp = true, hpp = true },
    })
    -- optional keybinding
    vim.keymap.set("n", "<F2>", "<cmd>Format<cr>", { desc = "Format with 42 formatter" })
end

-- 42header.nvim setup
local ok3, header = pcall(require, "42header")
if ok3 then
    header.setup({
        default_map = true,
        auto_update = true,
        user = "morekaz",
        mail = "morekaz@student.1337.ma",
        git = { enabled = true },
    })
end
