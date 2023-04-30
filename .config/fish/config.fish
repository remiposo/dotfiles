set fish_greeting

if status is-login
  if test -e '/opt/homebrew/bin/brew'
    eval "$(/opt/homebrew/bin/brew shellenv)"
  end

  if command -sq volta
    set -x VOLTA_HOME $HOME/.volta
    set -x PATH $VOLTA_HOME/bin $PATH
  end

  if command -sq fzf
    set -x FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border' \
      '--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284' \
      '--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf' \
      '--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284'
    set FZF_CTRL_T_OPTS "--preview 'bat -n --color=always {}'"
  end

  if command -sq go
    set -x GOPATH $HOME/go
    set -x PATH $GOPATH/bin $PATH
  end
end

if status is-interactive
  if command -sq git
    abbr -a gst git status
  end

  if command -sq lsd
    abbr -a ls lsd
    abbr -a ll lsd -al
    abbr -a lt lsd --tree
  end

  if command -sq bat
    abbr cat bat
  end

  if command -sq starship
    starship init fish | source
  end
end
