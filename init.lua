-- Set up lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins
require("lazy").setup({
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cmd = { "NvimTreeToggle", "NvimTreeOpen" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<C-j>"] = require("telescope.actions").move_selection_next,
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {"python", "javascript", "lua", "bash"},
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = false,
        integrations = {
          nvimtree = true,
          telescope = true,
          treesitter = true,
          lsp_saga = true,
          mason = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  
  -- LSP and Mason for Python development
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "jsonls", "lua_ls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      
      -- Python LSP
      lspconfig.pyright.setup({
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
      
      -- JSON LSP
      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = {
              {
                name = "JSON Schema",
                url = "https://json.schemastore.org/schema.json",
              },
            },
          },
        },
      })
      
      -- Lua LSP
      lspconfig.lua_ls.setup({})
      
      -- LSP keybindings
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover info" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format code" })
    end,
  },
  
  -- Auto-completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  
  -- CSV file support and viewer
  {
    "chrisbra/csv.vim",
    ft = "csv",
    config = function()
      vim.g.csv_delim = ","
      vim.g.csv_highlight_column = "y"
      vim.g.csv_highlight_column_names = "y"
      vim.g.csv_autocmd_arrange = 1
    end,
  },
  
  -- Better CSV viewer with table-like interface
  {
    "mechatroner/rainbow_csv",
    ft = { "csv", "tsv" },
    config = function()
      vim.g.rainbow_csv_conf = {
        csv_delim = ",",
        csv_hl_column = "y",
        csv_comment = "#",
        csv_autodetect_column_names = "y",
        csv_highlight_column = "y",
        csv_highlight_column_names = "y",
        csv_sniff_csv_dialect = "y",
        csv_autocmd_arrange = 1,
      }
    end,
  },
  
  -- JSON formatting and validation
  {
    "b0o/schemastore.nvim",
    config = function()
      require("schemastore").setup()
    end,
  },
})

-- Better settings for IDE-like experience
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Relative line numbers
vim.opt.termguicolors = true       -- Better colors
vim.opt.ignorecase = true          -- Case insensitive search
vim.opt.smartcase = true           -- Smart case search
vim.opt.tabstop = 2                -- Tab width
vim.opt.shiftwidth = 2             -- Indent width
vim.opt.expandtab = true           -- Use spaces instead of tabs

-- Mouse support (click to navigate, drag to select)
vim.opt.mouse = "a"                -- Enable mouse in all modes

-- Clipboard integration (copy/paste with Cmd+C, Cmd+V)
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard

-- Better syntax highlighting
vim.opt.syntax = "on"              -- Enable syntax highlighting
vim.opt.hlsearch = true            -- Highlight search results

-- Better cursor
vim.opt.cursorline = true          -- Highlight current line
vim.opt.scrolloff = 5              -- Keep 5 lines above/below cursor

-- Better editing
vim.opt.autoindent = true          -- Auto indent
vim.opt.smartindent = true         -- Smart indenting
vim.opt.wrap = false               -- Don't wrap long lines

-- Visual improvements
vim.opt.signcolumn = "yes"         -- Always show sign column
vim.opt.showcmd = true             -- Show command at bottom

-- Backspace behavior
vim.opt.backspace = "indent,eol,start"  -- Allow backspace over everything

-- Keybindings (backslash is default leader key)
-- File Tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file tree" })

-- Terminal
vim.keymap.set("n", "<leader>t", ":w<CR>:below terminal<CR>", { desc = "Open terminal at bottom" })
vim.keymap.set("n", "<leader>T", ":w<CR>:vert terminal<CR>", { desc = "Open terminal at right" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- File navigation
vim.keymap.set("n", "<C-f>", "/", { desc = "Search in file" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close buffer" })

-- Telescope (file search)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Search in files" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })

-- Copy/Paste (Normal IDE shortcuts)
vim.keymap.set({"n", "v"}, "<D-c>", '"+y', { desc = "Copy with Cmd+C" })
vim.keymap.set({"n", "v"}, "<D-v>", '"+p', { desc = "Paste with Cmd+V" })
vim.keymap.set("i", "<D-v>", "<Esc>\"+pa", { desc = "Paste in insert mode" })
vim.keymap.set("v", "<D-x>", '"+d', { desc = "Cut with Cmd+X" })
vim.keymap.set("v", "<D-a>", "<Esc>ggVG", { desc = "Select all with Cmd+A" })
vim.keymap.set("n", "<D-a>", "ggVG", { desc = "Select all" })

-- Undo/Redo
vim.keymap.set("n", "<D-z>", "u", { desc = "Undo with Cmd+Z" })
vim.keymap.set("n", "<D-S-z>", "<C-r>", { desc = "Redo with Cmd+Shift+Z" })

-- Python-specific keybindings
vim.keymap.set("n", "<leader>py", ":w<CR>:!python %<CR>", { desc = "Run Python file" })
vim.keymap.set("n", "<leader>pt", ":w<CR>:!python -m pytest %<CR>", { desc = "Run pytest on current file" })
vim.keymap.set("n", "<leader>pi", ":w<CR>:!pip install -r requirements.txt<CR>", { desc = "Install Python dependencies" })

-- CSV-specific keybindings
vim.keymap.set("n", "<leader>csv", ":CSVArrangeColumn<CR>", { desc = "Arrange CSV columns" })
vim.keymap.set("n", "<leader>csvh", ":CSVHeaderToggle<CR>", { desc = "Toggle CSV header" })
vim.keymap.set("n", "<leader>csvn", ":CSVNameCol<CR>", { desc = "Name CSV column" })
vim.keymap.set("n", "<leader>csvd", ":CSVDeleteColumn<CR>", { desc = "Delete CSV column" })
vim.keymap.set("n", "<leader>csvs", ":CSVSort<CR>", { desc = "Sort CSV by column" })
vim.keymap.set("n", "<leader>csvf", ":CSVFilter<CR>", { desc = "Filter CSV rows" })

-- File type specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 88  -- Black formatter default
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 0
  end,
}) 
