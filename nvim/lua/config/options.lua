-- options.lua
-- Place this file in your Neovim config directory, e.g., ~/.config/nvim/lua/core/options.lua
-- or wherever you load your options. Ensure it's required from your init.lua.

-- Line Numbers
vim.opt.relativenumber = true      -- Show line numbers relative to the cursor line (except current line)
vim.opt.number = true             -- Show the absolute line number on the current line (works with relativenumber)

-- Tabs and Indentation
vim.opt.tabstop = 4               -- Number of visual spaces per <Tab> character
vim.opt.expandtab = true          -- Use spaces instead of literal <Tab> characters
vim.opt.shiftwidth = 4            -- Number of spaces used for auto-indentation and shift commands (e.g., >>, <<)

-- Clipboard Integration
vim.opt.clipboard = "unnamedplus" -- Use the system clipboard '+' register for unnamed yank/paste operations (requires clipboard provider)

-- Editing Behavior
vim.opt.virtualedit = "block"     -- Allow cursor movement to non-existent positions in Visual Block mode (Ctrl-V)
vim.opt.scrolloff = 999           -- Keep the cursor vertically centered in the window as much as possible
vim.opt.compatible = false        -- Disable Vi compatibility mode (IMPORTANT for Neovim features)

-- Search Behavior
vim.opt.ignorecase = true         -- Ignore case when searching, unless the search pattern contains uppercase letters

-- UI / Visuals
vim.opt.termguicolors = true      -- Enable 24-bit RGB colors (true color) if the terminal supports it (required for many themes)
vim.opt.splitbelow = true         -- Open new horizontal splits below the current window
vim.opt.splitright = true         -- Open new vertical splits to the right of the current window
vim.opt.inccommand = "split"      -- Show replacements for commands like :s/.../.../ live in a preview split
vim.opt.wildmenu = true           -- Enable an enhanced menu for command-line completion (when pressing Tab)

-- File Searching Paths (for commands like :find, gf)
vim.opt.path:append("**")         -- Enable recursive search in current dir and subdirs for file-finding commands
vim.opt.path:append("**/.devcontainer/**") -- Also recursively search within the .devcontainer directory (relative to paths searched by default)

-- vim.opt.inccommand = "split" -- This line was a duplicate and is commented out

-- Make sure this file is loaded by your main init.lua, for example using:
-- require('core.options') -- if saved as lua/core/options.lua


vim.opt.list = true
-- vim.o.listchars = "tab:»\\ ,space:·" --:set list!
vim.g.editorconfig = true -- Explicitly enable built-in EditorConfig support
vim.opt.listchars = {
    tab = ">-",
    trail = "~",
    extends = ">",
    precedes = "<",
    nbsp = "%",
    space = "·"  -- Use a centered dot for spaces
  }