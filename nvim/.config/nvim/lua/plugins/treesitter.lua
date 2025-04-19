return {
    "nvim-treesitter/nvim-treesitter", -- This plugin needs nvim-treesitter-textobjects for these configs
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "c", "c_sharp", "lua", "elm", "vim", "vimdoc", "query", "html", "javascript", "css", "json"},
            auto_install = true,
            highlight = {
                enable = true
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                  init_selection = "gnn", -- set to `false` to disable one of the mappings
                  noce_incremental = "grn",
                  scope_incremental = "grc",
                  node_decremental = "grm",
                },
              },
            textobjects = {
                select = {
                    enable = true,
                    lookahaed = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    },
                selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V', -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                      },
                include_surrounding_whitespace = true,
                },
            },
        })
    end,
 }
