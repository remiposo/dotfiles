set fish_greeting

if status is-login
  if test -e '/opt/homebrew/bin/brew'
    eval "$(/opt/homebrew/bin/brew shellenv)"
  end

  if command -sq volta
    set -x VOLTA_HOME $HOME/.volta
    set -x PATH $VOLTA_HOME/bin $PATH
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
