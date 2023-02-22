set fish_greeting

if status is-interactive
  if command -sq lsd
    alias ls='lsd'
    alias ll='ls -al'
    alias lt='ls --tree'
  end

  if command -sq bat
    alias cat='bat'
  end

  starship init fish | source
end
