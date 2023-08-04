if type git > /dev/null 2>&1; then
  alias gst='git status'
fi

if type lsd > /dev/null 2>&1; then
  alias ls='lsd'
  alias ll='lsd -al'
  alias lt='lsd --tree'
fi

if type bat > /dev/null 2>&1; then
  alias cat='bat'
fi

if type starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
