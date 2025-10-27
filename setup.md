# Complete Neovim Setup Guide - macOS

## Overview
This guide will help you set up Neovim as a fully functional IDE with beautiful themes and modern features on macOS.

---

## Part 1: Installing Neovim

### Step 1: Install Neovim via Homebrew
```bash
brew install neovim
```

### Step 2: Verify Installation
```bash
nvim --version
```

You should see version 0.11.4 or higher.

---

## Part 2: Installing and Configuring iTerm2

### Why iTerm2?
macOS Terminal.app has limited support for modern colors and fonts. iTerm2 provides:
- Full true color support (16 million colors)
- Better Nerd Font rendering
- Enhanced features for developers

### Step 1: Install iTerm2
```bash
brew install --cask iterm2
```

### Step 2: Install Nerd Font
```bash
brew install --cask font-fira-code-nerd-font
```

### Step 3: Configure iTerm2 Font
1. Open iTerm2
2. Press `Cmd + ,` (or iTerm2 → Settings)
3. Click "Profiles" tab
4. Click "Text" tab
5. Click "Change Font"
6. Find and select: **FiraCode Nerd Font Mono**
7. Close settings

---

## Part 3: Neovim Configuration

### Step 1: Create Config Directory
```bash
mkdir -p ~/.config/nvim
```

### Step 2: Create Configuration File
Create `~/.config/nvim/init.lua`:

```lua
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
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cmd = { "NvimTreeToggle", "NvimTreeOpen" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
      })
    end,
  },
  
  -- File search
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("telescope").setup({})
    end,
  },
  
  -- Syntax highlighting
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
  
  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        integrations = {
          nvimtree = true,
          telescope = true,
          treesitter = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
})

-- IDE-like settings
vim.opt.number = true              -- Line numbers
vim.opt.relativenumber = true      -- Relative line numbers
vim.opt.mouse = "a"                -- Mouse support
vim.opt.clipboard = "unnamedplus"  -- System clipboard
vim.opt.cursorline = true          -- Highlight current line
vim.opt.syntax = "on"              -- Syntax highlighting

-- Keyboard shortcuts
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Search in files" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Cmd shortcuts for macOS
vim.keymap.set({"n", "v"}, "<D-c>", '"+y', { desc = "Copy" })
vim.keymap.set({"n", "v"}, "<D-v>", '"+p', { desc = "Paste" })
vim.keymap.set("i", "<D-v>", "<Esc>\"+pa", { desc = "Paste in insert" })
```

### Step 3: Launch Neovim
```bash
nvim
```

Neovim will automatically download and install all plugins. Wait for it to finish!

---

## Part 4: Using Your New IDE

### Opening Neovim
```bash
cd /path/to/your/project
nvim
```

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `\e` | Toggle file tree |
| `\ff` | Find files |
| `\fg` | Search text in files |
| `\w` | Save file |
| `\q` | Quit Neovim |
| `Cmd+C` | Copy |
| `Cmd+V` | Paste |
| `Cmd+Z` | Undo |

*Note: `\` is your "leader" key*

### File Tree Navigation
- Press `\e` to open file tree
- Use arrow keys to navigate
- Press `o` to open files
- Click with mouse to navigate!

### Changing Theme
To change the Catppuccin flavor, edit `~/.config/nvim/init.lua`:

```lua
-- Change this line:
flavour = "mocha", -- Change to: latte, frappe, macchiato, or mocha
```

Then restart Neovim.

---

## Troubleshooting

### Problem: Question marks in file tree
**Solution:** Make sure you set the font to "FiraCode Nerd Font Mono" in iTerm2

### Problem: Plugins not installing
**Solution:** Check your Git version:
```bash
git --version
```
Should be 2.19+ for partial clone support. If not:
```bash
brew upgrade git
```

### Problem: Colors look weird
**Solution:** Use iTerm2 instead of Terminal.app for full color support

### Problem: Cmd+C/V not working
**Solution:** Make sure `vim.opt.clipboard = "unnamedplus"` is in your config

---

## Recommended Next Steps

1. **Install a language server** (for autocomplete):
   ```bash
   :Mason
   # Then select a language server from the list
   ```

2. **Explore more plugins:**
   - `nvim-cmp` - Autocomplete
   - `lualine.nvim` - Status bar
   - `gitsigns.nvim` - Git integration

3. **Customize your config** - Edit `~/.config/nvim/init.lua` to add more features!

---

## Theme Options

Catppuccin comes in 4 flavors:

- 🌻 **Latte** - Light theme (warm beige/cream)
- 🪴 **Frappé** - Purple theme (purple/pink tones)  
- 🌺 **Macchiato** - Orange theme (warm orange/brown)
- 🌿 **Mocha** - Blue theme (blue/purple) - **Default**

Change the flavor in your `init.lua` file!

---

## Summary

You now have:
- ✅ Neovim installed
- ✅ Beautiful Catppuccin theme
- ✅ File tree navigation
- ✅ Fuzzy file search
- ✅ Syntax highlighting
- ✅ Mouse support
- ✅ Copy/paste with Cmd+C/V
- ✅ iTerm2 for best experience

Happy coding! 🎉