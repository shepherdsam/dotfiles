# Terminal Setup
Setting up my favorite terminal invironment for development

## Install

### zsh
This should come default with osx.

#### Oh-My-ZSH
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Modifications to `.zshrc`
```zsh
ZSH_THEME="nicoulaj"
ZSH_CUSTOM="$HOME/.config/zsh"
```

Copy Config
```
cp -R zsh ~/.config/
```

### Nerd Font
```
brew install --cask font-jetbrains-mono-nerd-font
```

### alacritty
```
brew install --cask alacritty
cp ./alacritty ~/.config/
```
See `./alacritty/alacritty.toml`

### git
```
brew install --cask git
cp ./.gitconfig ~/.gitconfig
```

See `./.gitconfig`

### neovim
```bash
brew install --cask neovim
```

- [ ] I want a markdown preview https://github.com/roodolv/markdown-toggle.nvim#default-settings
- [ ] I want an ability to toggle and check off check boxes (todos)
- [ ] It should not wrap in the middle of a word. Should it wrap at all?

#### Install NvChad
```bash
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

```
- Run `:MasonInstallAll` and `:TSInstallAll` command after lazy.nvim finishes downloading plugins.
- Delete the .git folder from nvim folder.


#### Plugins
Edit: `nvim/lua/plugins/init.lua`

```lua
return {
-- ... 

  {
    "nvim-tree/nvim-tree.lua",
    lazy = false -- turning this on ensures the working directory changes
  },

  {
    "kylechui/nvim-surround",
    version = "^4.0.0",
    event = "VeryLazy",
  }

-- ...
}
```

Need to run `:Lazy` and download the plugins after modifications

#### Theme

Edit: `nvim/lua/chadrc.lua`

```lua
local M = {}

M.base46 = {
  theme = "onedark",
  transparency = true,
}

return M
```

#### Options
- [x] Show Nvdash on initial start up when no buffer

Edit: `nvim/lua/options.lua`

```lua

vim.opt.linebreak = true
vim.opt.wrap = true
vim.opt.breakindent = true

vim.api.nvim_create_autocmd({"VimEnter", "BufDelete"}, {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 then
      local buf = bufs[1]
      local name = vim.api.nvim_buf_get_name(buf)
      local ft = vim.bo[buf].filetype
      if name == "" or ft == "netrw" or vim.fn.isdirectory(name) == 1 then
        vim.cmd "Nvdash"
      end
    end
  end,
})
```

### ollama
Local models
- [ ] Research which models work best for my hardware I do have at home.

### Pi
My new favorite
```
# TODO: Will be changing locations in the near future
npm install -g @mariozechner/pi-coding-agent

# TODO: This is a heavy extenion. I would like to just find my favorite models and simply hard code them in models.json.
pi install npm:pi-venice

cp ./pi/agent/auth.json ~/.pi/agent/auth.json
cp ./pi/agent/settings.json ~/.pi/agent/settings.json
```

See `./pi/agent/auth.json` for Auth
See `./pi/agent/settings.json` for Settings

### Utilities
- fd (better find)
- rg (better grep)
```bash
brew install ripgrep fd
```

### Tmux
```bash
brew install tmux
cp ./.tmux.conf ~/.tmux.conf
```

See `./.tmux.conf`

### Handy
Dictation
```
brew install --cask handy
```

## Syncing
- [ ] This needs to get better

### Review Hunk Copy
`nvim -d src dst`
Move to the dest (right side) and run `do` to pull changes over and then save
