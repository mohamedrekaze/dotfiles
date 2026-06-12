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

vim.g.user = "morekaz"
vim.g.mail = "morekaz@student.1337.ma"

require("42header").setup({
    default_map = true,
    auto_update = true,
})
