_svl() {
    local cur prev svcdir
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    svcdir="$PREFIX/var/service"

    COMPREPLY=()

    # First argument
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=($(compgen -W "list status who help up down enable disable" -- "$cur"))
        return
    fi

    # svl status <service...> or anything that accept arguments
    case "${COMP_WORDS[1]}" in
        status|who|up|down|enable|disable)
            if [-d "$svcdir" ]; then
                COMPREPLY=($(compgen -W "$(ls "$scvdir")" -- "$cur"))
            fi
            ;;
    esac
}

complete -F _svl svl

