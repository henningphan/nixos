repo() {
  local path="$(repo-fzf "$1")"
  if [[ -z $path ]]; then
    return
  elif [[ $path == "/" ]]; then
    cd ~/repo
  else
    cd ~/repo/"$path"
  fi

}

_repo_complete() {
  local base="$HOME/repo"
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local dir rel

  COMPREPLY=()

  while IFS= read -r dir; do
    rel="${dir#"$base"/}"
    COMPREPLY+=("$rel/")
  done < <(compgen -d -- "$base/$cur")

  compopt -o filenames -o nospace 2>/dev/null
}

complete -o filenames -F _repo_complete repo
