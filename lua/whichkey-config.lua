
-- whichkey.lua

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end


local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {

    ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer"}, -- File Explorer
    ["k"] = { "<cmd>bdelete!<CR>","Kill Buffer" },  -- Close current file
    ["p"] = { "<cmd>Lazy<CR>","Plugin Manager" }, -- Invoking plugin manager
    ["d"] = {"<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>", "open diagnostics"}, -- open diagnostics

    --Git
    g = {
        name = "Git",
        d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff"},
        j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
        k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
        l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
        s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
        u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk"},
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    },

    -- Language Support
   l = {
        name = "LSP",
        D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "declaration"}, -- open lsp declaration
        d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "definition or source"}, -- go to defination
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" }, -- rename the variable
        g = {"<cmd>lua vim.lsp.buf.references()<cr>", "Go to references"}, -- go to reference
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        a = { "<cmd> lua vim.lsp.buf.code_action()<cr>", "Code action"}, -- show available code actions
        K = { "<cmd> lua vim.lsp.buf.hover()<cr>", "show documentation"}, -- shows documentation in a floating window
    },

    -- Telescope
    f = {
        name = "File Search",
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find files" },
        t = { "<cmd>Telescope live_grep <cr>", "Find Text Pattern" },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
        h = { "<cmd> Telescope help_tags<cr>", "Help tags"},
        k = { "<cmd> Telescope keymaps<cr>", "Keymaps"},
        g = { "<cmd> lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", 'search in current file'},
    },

    -- --ToggleTerm
    -- t = {
    --     name = "Terminal",
    --     n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    --     t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    --     p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    --     f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    --     h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    --     v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
    -- },

}
which_key.setup(setup)
which_key.register(mappings, opts)
