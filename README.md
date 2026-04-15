# Terminal Setup
Setting up my favorite terminal invironment for development

## Install

### zsh

#### Oh-My-ZSH
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Modifications to `.zshrc`
```zsh
ZSH_THEME="nicoulaj"
ZSH_CUSTOM=~/.config/zsh
```

Copy Config
```
cp dotfiles/zsh ~/.config/zsh
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



### Nerd Font
```
brew install --cask font-jetbrains-mono-nerd-font
```

### git
```
brew install --cask git
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
    lazy = false
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

### Goose
- [ ] Fill this out

