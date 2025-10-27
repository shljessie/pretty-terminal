# Understanding init.lua - Your Neovim Configuration Explained

## What is init.lua?

`init.lua` is Neovim's main configuration file. It runs every time you start Neovim and controls everything from how your editor looks to what plugins you use.

In this file, you'll find:
- Plugin management (what extensions Neovim should use)
- Theme settings (how your editor looks)
- Keyboard shortcuts (custom commands)
- IDE-like features (file trees, search, etc.)

---

## How Neovim Configuration Works

Neovim looks for this file at `~/.config/nvim/init.lua` and runs it on startup. Everything in this file is written in **Lua**, a programming language that Neovim uses for configuration.

---

## Breaking Down Your init.lua File

### Section 1: Setting Up Lazy.nvim (Plugin Manager)

```lua
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
```

**What it does:**
- Installs `lazy.nvim`, the plugin manager
- If it's not installed, it downloads it from GitHub
- Adds it to Neovim's runtime path so it can manage your plugins

**Why it's important:** This gives you a way to install and manage plugins (extensions) for Neovim.

---

### Section 2: Plugin Configuration

This section tells Neovim which plugins to install and how to configure them.

#### Plugin 1: Nvim-tree (File Tree)

```lua
{
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
      },
    })
  end,
}
```

**What it does:**
- Creates a file tree sidebar (like VS Code's Explorer)
- Sets the width to 30 characters
- Lets you browse your files visually

**Keyboard shortcut:** Press `\e` to toggle the file tree

---

#### Plugin 2: Telescope (File Search)

```lua
{
  "nvim-telescope/telescope.nvim",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
}
```

**What it does:**
- Provides a powerful file search feature
- Lets you quickly find files by name
- Fuzzy search: type part of a filename and it finds it
- Also searches through file contents

**Keyboard shortcuts:**
- `\ff` - Find files
- `\fg` - Search text in files

---

#### Plugin 3: Treesitter (Syntax Highlighting)

```lua
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
}
```

**What it does:**
- Provides better syntax highlighting
- Makes code more readable with colors
- Ensures Python, JavaScript, Lua, and Bash syntax are installed

**Why it's better:** Treesitter understands code structure better than basic syntax highlighting, so it colors your code more accurately.

---

#### Plugin 4: Catppuccin Theme (Colors)

```lua
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        nvimtree = true,
        telescope = true,
        treesitter = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
```

**What it does:**
- Applies the Catppuccin color theme (the "Mocha" flavor)
- Makes Neovim look beautiful with soft blues and purples
- Integrates the theme with other plugins
- Sets the priority to 1000 so it loads first

**Why it's pretty:** Catppuccin is a modern theme designed to be easy on the eyes during long coding sessions.

---

### Section 3: IDE-Like Settings

```lua
vim.opt.number = true              -- Line numbers
vim.opt.relativenumber = true      -- Relative line numbers
vim.opt.mouse = "a"                -- Mouse support
vim.opt.clipboard = "unnamedplus"  -- System clipboard
vim.opt.cursorline = true          -- Highlight current line
vim.opt.syntax = "on"              -- Syntax highlighting
```

**What each line does:**
- `number = true`: Shows line numbers on the left
- `relativenumber = true`: Shows relative line numbers (useful for jumping)
- `mouse = "a"`: Lets you click to move cursor
- `clipboard = "unnamedplus"`: Copy/paste works with system clipboard
- `cursorline = true`: Highlights the line you're on
- `syntax = "on"`: Turns on syntax highlighting

**Why these matter:** These settings make Neovim feel more like a modern IDE.

---

### Section 4: Keyboard Shortcuts

```lua
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
```

**What this does:**
- Creates custom keyboard shortcuts
- `<leader>` is your "prefix" key (default is `\`)
- Examples:
  - `\e` - Toggle file tree
  - `\ff` - Find files
  - `\fg` - Search in files
  - `\w` - Save file
  - `\q` - Quit Neovim

**How to customize:** You can add more shortcuts here!

---

### Section 5: macOS-Specific Shortcuts

```lua
vim.keymap.set({"n", "v"}, "<D-c>", '"+y')
vim.keymap.set({"n", "v"}, "<D-v>", '"+p')
vim.keymap.set("i", "<D-v>", "<Esc>\"+pa")
```

**What this does:**
- Makes `Cmd+C` and `Cmd+V` work in Neovim
- Works in normal mode, visual mode, and insert mode
- Integrates with macOS clipboard

**Why it's useful:** You can use familiar macOS shortcuts!

---

## Common Customizations

### Change Theme Flavor

Edit this line to change your theme:

```lua
flavour = "mocha", -- Change to: latte, frappe, macchiato, or mocha
```

### Add a New Shortcut

Add this anywhere in the keymap section:

```lua
vim.keymap.set("n", "<leader>y", "<cmd>Telescope grep_string<CR>")
```

This makes `\y` search for the word under your cursor.

### Change Leader Key

Add at the top of your file:

```lua
vim.g.mapleader = " "
```

This makes `Space` your leader key instead of `\`.

---

## How It All Works Together

1. **Neovim starts** → reads `init.lua`
2. **Lazy.nvim loads** → sets up plugin system
3. **Plugins install** → file tree, search, syntax highlighting, theme
4. **Settings apply** → line numbers, mouse support, clipboard
5. **Shortcuts ready** → you can use all your custom commands!

---

## Troubleshooting Your Config

### Plugins Won't Install
**Problem:** Plugins not downloading  
**Solution:** Check your internet connection and Git installation

### Colors Look Wrong
**Problem:** Theme not applied correctly  
**Solution:** Use iTerm2 instead of Terminal.app for full color support

### Shortcuts Don't Work
**Problem:** Your shortcuts aren't working  
**Solution:** Make sure you're using the right mode:
- `"n"` = normal mode (default)
- `"i"` = insert mode
- `"v"` = visual mode

---

## Summary

Your `init.lua` file is your Neovim's brain. It:
- Installs and manages plugins
- Sets up a beautiful theme
- Configures IDE-like features
- Creates custom keyboard shortcuts
- Makes Neovim work like a modern code editor

You can customize everything in this file to make Neovim work exactly how you want!

---

## Next Steps

1. **Experiment:** Try changing the theme flavor
2. **Add shortcuts:** Create your own keyboard shortcuts
3. **Install more plugins:** Add new features like:
   - Autocomplete
   - Git integration
   - Status bar
   - Linting

Happy coding! 🎉 