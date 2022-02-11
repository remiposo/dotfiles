frg() {
  local INITIAL_QUERY=''
  local RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case '
  FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
    fzf --bind "change:reload:$RG_PREFIX {q}" \
        --ansi --phony --height=100%\
        --preview 'bat --color=always "$(echo {} | cut -f 1 --delim ":")"'
}
