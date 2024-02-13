function gcd
  cd (ghq root)/(ghq list | fzf --preview "lsd --all --color=always --icon=always (ghq root)/{}")
end
