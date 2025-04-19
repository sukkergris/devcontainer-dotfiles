vim.keymap.set("n", "<leader>ex", ":Ex<CR>", { desc = "Open Netrw" })
vim.keymap.set('i', '<C-s>', '<C-o>:w<CR>', { desc = 'Save changes' })

vim.keymap.set('n', '<leader>vsc', ':!code %<CR>', { noremap = true, silent = true, desc = "Open the current file in VS Code" })

--vim.keymap.set('n', '<C-p>', builtin.git_files, {})
--vim.keymap.set('n', '<leader>ps', function()
--builtin.grep_string({search = vim.fn.input("Grep > ")}) end)

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)