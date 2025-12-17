_svl() {
    local cur prev svcdir
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    svcdir="$PREFIX/var/service"

    COMPREPLY=()

    # First argument
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=($(compgen -W "status who help" -- "$cur"))
        return
    fi

    # svl status <service...>
    if [ "${COMP_WORDS[1]}" = "status" ] || [ "${COMP_WORDS[1]}" = "who" ]; then
        if [ -d "$svcdir" ]; then
            COMPREPLY=($(compgen -W "$(ls "$svcdir")" -- "$cur"))
        fi
    fi
}

complete -F _svl svl

