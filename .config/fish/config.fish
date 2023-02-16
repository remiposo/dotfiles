set fish_greeting

if status is-interactive
  if command -sq lsd
    alias ls='lsd'
    alias ll='ls -al'
    alias lt='ls --tree'
  end

  starship init fish | source
end
