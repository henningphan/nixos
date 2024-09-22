#!/usr/bin/env bash
repo(){
    # shellcheck disable=SC2164
    cd "$HOME/repo/$1"
}

_repos_completions(){
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    ((${#COMP_WORDS[@]} > 2)) && return
    _repo "$cur"
}

_repo(){
    local cur
    pushd ~/repo >/dev/null
    cur="$1"

    COMPREPLY=($(compgen -d "$cur"))

    popd >/dev/null

    }

complete -o nospace -F _repos_completions repo
