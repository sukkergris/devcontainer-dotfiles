return {
    "nvim-treesitter/nvim-treesitter", -- This plugin needs nvim-treesitter-textobjects for these configs
    branch = "master", -- master is frozen; main is an incompatible rewrite (lazy follows the default branch otherwise)
    config = function()
        -- Patch: nvim-treesitter (pinned at cf12346a, the last commit on the
        -- now-frozen `master` branch) registers
        -- its "set-lang-from-info-string!" directive assuming
        -- `match[capture_id]` is always a single TSNode. On Neovim 0.12.4 the
        -- `all = false` option its compatibility shim passes to
        -- vim.treesitter.query.add_directive is no longer honored by core, so
        -- the value can arrive as a list of nodes instead — crashing
        -- get_node_text -> get_range -> node:range() while highlighting
        -- markdown-injected code fences (e.g. a ```elm block in a doc
        -- comment). This re-registers the same directive with a node/table
        -- normalized to its first entry before calling get_node_text.
        -- Kept in sync with the same patch in the sukkergris/dotfiles repo.
        do
          local query = require("vim.treesitter.query")
          -- Inlined from nvim-treesitter's private (non-exported)
          -- get_parser_from_markdown_info_string, so its alias-resolution
          -- behavior is preserved exactly — only the node-normalization below
          -- is new.
          local non_filetype_match_injection_language_aliases = {
            ex = "elixir",
            pl = "perl",
            sh = "bash",
            uxn = "uxntal",
            ts = "typescript",
          }
          local function get_parser_from_markdown_info_string(injection_alias)
            local match = vim.filetype.match { filename = "a." .. injection_alias }
            return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
          end
          query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
            local capture_id = pred[2]
            local node = match[capture_id]
            if type(node) == "table" and node[1] ~= nil then
              node = node[1]
            end
            if not node or type(node) ~= "userdata" then
              return
            end
            local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
            metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
          end, { force = true })
        end

        require("nvim-treesitter.configs").setup({
            ensure_installed = { "c", "c_sharp", "lua", "elm", "vim", "vimdoc", "query", "html", "javascript", "css", "json"},
            auto_install = true,
            highlight = {
                enable = true
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<leader>ss", -- Start Select
                    node_incremental = "<leader>si", -- Incremental Select
                    scope_incremental = "<leader>sc", -- Scope Select
                    node_decremental = "<leader>sd", -- Decremental Select
                },
              },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
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
