#!/bin/bash
#
# setup dotfiles

set -eu

dotfiles_root="$(cd "$(dirname "$0")/.." && pwd -P)"

setup_gitconfig () {
  local gitconfig_file="${dotfiles_root}/git/gitconfig.symlink"
  local gitconfig_file_example="${gitconfig_file}.example"

  if [ ! -f git/gitconfig.symlink ];then
    echo 'Setup gitconfig'
    if [ ! -f "${gitconfig_file_example}" ];then
      echo "Please create '${gitconfig_file_example}'"
      echo 'Failed to setup gitconfig'
      return
    fi
    echo ' - What is your github author name?'
    read git_authorname
    echo ' - What is your github author email?'
    read git_authoremail
    sed -e "s/AUTHORNAME/${git_authorname}/g"\
        -e "s/AUTHOREMAIL/${git_authoremail}/g"\
        "${dotfiles_root}/git/gitconfig.symlink.example"\
        > "${dotfiles_root}/git/gitconfig.symlink"
    echo 'Successfully setup gitconfig'
  fi
}

link_file () {
  local src=$1 dst=$2
  local skip=false overwrite=false backup=false
  local valid_key=false

  if [ -e "$dst" ];then
    local current_src="$(readlink "$dst")"
    if [ "$current_src" == "$src" ];then
      skip=true
    else
      echo "File already exists: $dst, what do you want to do?"
      while [ "$valid_key" == "false" ]
      do
        echo "[s]kip, [o]verwrite?"
        read -n 1 action
        echo
        case "$action" in
          s )
            skip=true
            valid_key=true;;
          o )
            overwrite=true
            valid_key=true;;
          * )
            ;;
        esac
      done
    fi
    if [ "$skip" == "true" ];then
      echo "Skipped $src"
    fi
    if [ "$overwrite" == "true" ];then
      rm -rf "$dst"
      echo "Removed $dst"
    fi
  fi
  if [ "$skip" == "false" ];then
    ln -s "$1" "$2"
    echo "Linked $1 to $2"
  fi
}

setup_dotfiles () {
  local src dst

  echo 'Setup dotfiles'
  for src in $(find "${dotfiles_root}" -maxdepth 2 -name '*.symlink')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
  echo 'Successfully setup dotfiles'
}

cd "$dotfiles_root"
setup_gitconfig
setup_dotfiles
