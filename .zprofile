if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if type volta > /dev/null 2>&1; then
  export VOLTA_HOME=$HOME/.volta
  export PATH=$VOLTA_HOME/bin:$PATH
fi

if type fzf > /dev/null 2>&1; then
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'\
' --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284'\
' --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf'\
' --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284'
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
fi

if type pyenv > /dev/null 2>&1; then
  export PYENV_ROOT=$HOME/.pyenv
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "$(pyenv init -)"
fi

if type go > /dev/null 2>&1; then
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$PATH
fi

if [ -f ~/.remiposo_profile.zsh ]; then
  source ~/.remiposo_profile.zsh
fi

if [ -f ~/.mixch_profile.zsh ]; then
  source ~/.mixch_profile.zsh
fi

if [ -f ~/.orbstack/shell/init.zsh ]; then
  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi

if [ -f /opt/homebrew/opt/asdf/asdf.sh ]; then
  . /opt/homebrew/opt/asdf/asdf.sh
fi
