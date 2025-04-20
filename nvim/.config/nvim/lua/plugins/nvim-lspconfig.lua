-- ~/.config/nvim/lua/plugins/nvim-lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  -- Optional: Add dependencies like cmp-nvim-lsp if you use nvim-cmp
  -- dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local lspconfig = require('lspconfig')

    -- Setup for lua_ls
    lspconfig.lua_ls.setup {
      -- The on_init function runs when the language server initializes.
      -- This is a good place to conditionally modify settings based on the workspace.
      on_init = function(client)
        -- Check if we are in the Neovim config directory or if a local .luarc exists
        local path = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
        local root_dir_has_luarc = path and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
        local is_nvim_config = path and path == vim.fn.stdpath('config')

        local settings = client.config.settings -- Get the current settings reference

        -- Ensure the Lua table exists
        settings.Lua = settings.Lua or {}

        -- Apply Neovim-specific settings ONLY if we are in the nvim config folder,
        -- OR if there isn't a .luarc.* file in the project root.
        -- This prevents overriding project-specific settings defined in .luarc.*
        if is_nvim_config or not root_dir_has_luarc then
          print("Applying Neovim specific settings for lua-language-server") -- Optional debug print
          settings.Lua = vim.tbl_deep_extend('force', settings.Lua, {
            runtime = {
              version = 'LuaJIT', -- Tell lua_ls we're using LuaJIT (typical for Neovim)
            },
            workspace = {
              checkThirdParty = false, -- Avoid warnings for Neovim libs
              library = {
                vim.env.VIMRUNTIME -- Make Neovim's runtime library available
                -- Add other paths if needed, e.g.:
                -- "${3rd}/luv/library",
                -- "${3rd}/busted/library",
              },
              -- Using the below is VERY slow and generally discouraged unless you know why you need it
              -- library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Add other Neovim specific settings if needed
            -- Example: Disable diagnostics for undefined globals in Neovim config
            -- diagnostics = {
            --   globals = { 'vim' },
            -- },
          })
        else
           print("Using project specific .luarc or default settings for lua-language-server") -- Optional debug print
        end

        -- It's good practice to notify the server about configuration changes made in on_init
        client.notify("workspace/didChangeConfiguration", { settings = settings })

        -- Important: Return true to signal that initialization should continue
        return true
      end,

      -- The 'settings' table provides the *base* configuration for lua_ls.
      -- The 'on_init' function above can dynamically modify these.
      settings = {
        Lua = {
          -- You can put other general settings here if needed.
          -- Example: Enable diagnostics globally (can be overridden by .luarc or on_init)
          diagnostics = { enable = true },
          -- Example: Set preferred formatting options
          -- format = {
          --   enable = true,
          --   defaultConfig = {
          --     indent_style = "space",
          --     indent_size = "2",
          --   }
          -- }
        }
        -- Note: The 'Lua' table structure comes from lua-language-server's own configuration schema.
      },

      -- It's highly recommended to define an on_attach function
      -- to set keymaps specific to LSP actions after the server attaches to a buffer.
      on_attach = function(client, bufnr)
        -- Example keymaps (requires you to have these functions defined elsewhere)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
        -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
        -- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
        -- etc.
        print("LSP attached to buffer:", bufnr) -- Optional debug print
      end,

      -- You might want to customize capabilities, especially if using nvim-cmp
      -- capabilities = require('cmp_nvim_lsp').default_capabilities(),
    }

    -- You can configure other language servers here as well
    -- lspconfig.pyright.setup{}
    -- lspconfig.tsserver.setup{}

  end,
}