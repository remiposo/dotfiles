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

  if command -sq pokemon-colorscripts
    pokemon-colorscripts -r --no-title
  end

  starship init fish | source
end
