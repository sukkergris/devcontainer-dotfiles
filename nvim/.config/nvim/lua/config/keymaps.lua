vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find Help Tags" })
vim.keymap.set('n', '<leader>ds', '<cmd>Telescope lsp_document_symbols<CR>', { desc = "LSP Document Symbols (Telescope)" })
vim.keymap.set("n", "<leader>lm", "<cmd>Telescope marks<CR>", { desc = "Browse marks" })

vim.keymap.set("n", "<leader>ex", ":Ex<CR>", { desc = "Open Netrw" })
vim.keymap.set('i', '<C-s>', '<C-o>:w<CR>', { desc = 'Save changes' })

vim.keymap.set('n', '<leader>vsc', ':!code %<CR>', { noremap = true, silent = true, desc = "Open the current file in VS Code" })

--vim.keymap.set('n', '<C-p>', builtin.git_files, {})
--vim.keymap.set('n', '<leader>ps', function()
--builtin.grep_string({search = vim.fn.input("Grep > ")}) end)

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Scrolling
vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-f>", "<C-f>zz")
vim.keymap.set('n', "<C-b>", "<C-b>zz")
