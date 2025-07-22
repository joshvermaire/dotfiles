#!/usr/bin/env bash

set -euo pipefail

echo "🛠  Starting bootstrap…"

# -- Homebrew & Dependencies -------------------------------------------------
echo "🔧 Installing Homebrew (if needed)…"
if ! command -v brew >/dev/null; then
  echo "› Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "🔧 Installing Brew packages…"
brew bundle --file=- <<BREWFILE
brew "git"
brew "stow"
brew "fzf"
brew "bat"
brew "rbenv"
# brew "ripgrep"
# brew "starship"
# cask "warp"
BREWFILE

# -- Dotfiles ---------------------------------------------------------------
echo "🔧 Cloning Dotfiles…"
DOTFILES_DIR="$HOME/github/joshvermaire/dotfiles"
if [[ ! -d "$DOTFILES_DIR" ]]; then
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone git@github.com:joshvermaire/dotfiles.git "$DOTFILES_DIR"
else
  echo "› Dotfiles already cloned"
fi

# -- Antidote Plugin Manager ------------------------------------------------
echo "🔧 Installing Antidote…"
ANTIDOTE_DIR="$HOME/.antidote"
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote "$ANTIDOTE_DIR"
else
  echo "› Antidote already installed"
fi

# -- Stow Dotfiles ----------------------------------------------------------
echo "🔧 Stowing Zsh config…"
cd "$DOTFILES_DIR"
stow --target="$HOME" --verbose=2 zsh bin

# -- Compile and Preload Zsh Plugins ----------------------------------------
PLUGIN_SRC="$DOTFILES_DIR/zsh/.zsh_plugins.txt"
PLUGIN_DEST="$HOME/.zsh_plugins.zsh"

if [[ -f "$PLUGIN_SRC" ]]; then
  echo "🔧 Compiling Zsh plugins with Antidote…"
  if command -v zsh >/dev/null 2>&1; then
    zsh -c "source $HOME/.antidote/antidote.zsh; antidote bundle < $HOME/.zsh_plugins.txt > $HOME/.zsh_plugins.zsh"
  else
    echo 'Zsh is not installed. Please install Zsh first.'
  fi
  echo "✅ Plugins compiled → $PLUGIN_DEST"

else
  echo "⚠️  Missing plugin list: $PLUGIN_SRC"
fi

# -- Set Zsh as default shell -----------------------------------------------
echo "🔧 Setting Zsh as default shell (if needed)…"
if [[ "$SHELL" != "/bin/zsh" ]]; then
  chsh -s /bin/zsh
  echo "✅ Default shell changed to Zsh"
else
  echo "› Already using Zsh"
fi

# -- Install Nerd Fonts (MesloLGS NF) ---------------------------------------
echo "🔧 Installing Meslo Nerd Font for Powerlevel10k…"
FONT_DIR="$HOME/Library/Fonts"
MESLO_BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"

for font in \
  "MesloLGS NF Regular.ttf" \
  "MesloLGS NF Bold.ttf" \
  "MesloLGS NF Italic.ttf" \
  "MesloLGS NF Bold Italic.ttf"; do
  curl -fsSL -o "$FONT_DIR/$font" "$MESLO_BASE_URL/${font// /%20}"
done
echo "✅ Meslo Nerd Fonts installed → Set in your terminal preferences"

echo
echo "🎉 Bootstrap complete!"
echo "👉 Now run: exec zsh"
