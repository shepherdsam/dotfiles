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
mkdir -p ~/.config/alacritty
touch ~/.config/alacritty/alacritty.toml
```

Edit `~/.config/alacritty/alacritty.toml`

```toml
# Window settings
[window]
padding.x = 4
padding.y = 4
dynamic_padding = true
decorations = 'buttonless'
opacity = 0.85
#blur = true


# Font configuration
[font]
size = 14.0

[font.normal]
family = "JetBrainsMono Nerd Font Mono"
style = "Regular"

[font.bold]
family = "JetBrainsMono Nerd Font Mono"
style = "Bold"

[font.italic]
family = "JetBrainsMono Nerd Font Mono"
style = "Italic"

[font.bold_italic]
family = "JetBrainsMono Nerd Font Mono"
style = "Bold Italic"
```

### git
```
brew install --cask git
```

Edit `~/.gitconfig`
```
editor = nvim
```

### neovim
```
brew install --cask neovim
```

### nvim
- [ ] I want a markdown preview
- [ ] I want an ability to toggle and check off check boxes (todos)
- [ ] It should not wrap in the middle of a word. Should it wrap at all?

#### Install NvChad
```
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

### Goose
- [ ] Might be removing
```
brew install --cask block-goose-cli
brew install --cask block-goose
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
```

Edit `~/.pi/agent/auth.json`

```
{
  "xai": {"type": "api_key", "key": "xai-KEY"},
  "venice": {"type": "api_key", "key": "venice-KEY"}
}

```

Edit `~/.pi/agent/settings.json`
```
{
  "defaultProvider": "xai",
  "defaultModel": "grok-4-1-fast",
  "defaultThinkingLevel": "minimal",
  "hideThinkingBlock": false,
  "enableInstallTelemetry": false,
  "theme": "dark",
  "enabledModels": [
    "xai/grok-4-1-fast",
    "xai/grok-4-1-fast-non-reasoning",
    "xai/grok-4.20-0309-non-reasoning",
    "xai/grok-4.20-0309-reasoning",
    "xai/grok-code-fast-1"
  ]
}

```

### Tmux
```
brew install tmux
```

Copy `cp ./.tmux.conf ~/.tmux.conf`

### Handy
Dictation
```
brew install --cask handy
```
