return {
    -- Active indent guide and indent text objects. When you're browsing
    -- code, this highlights the current level of indentation, and animates
    -- the highlighting.
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        -- event = "LazyFile",
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "Trouble",
                    "fzf",
                    "help",
                    "lazy",
                    "trouble",
                    "NvimTree",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- disable inent-blankline scope when mini-indentscope is enabled
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
            indent = {
                char =  "│",
            },
                scope = { enabled = false },
            })

        end
    },

}
