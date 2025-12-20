# intern helper functions

_resolve_svcs() {
    local svcs=()

    if [ $# -eq 0 ]; then
        svcs=("$svcdir"/*)
    else
        for svc in "$@"; do
            svcs+=("$svcdir/$svc")
        done
    fi

    printf "%s\n" "${svcs[@]}"
}

_ensure_arg() {
    if [ $# -eq 0 ]; then
        echo "error: expected at least one argument"
        exit 1
    fi
}

_sv_action() {
    action=$1
    shift

    _ensure_arg "$@"

    svc=$1

    case "$action" in
        up) verb="started" ;;
        down) verb="stopped" ;;
    esac

    if sv "$action" "$svc"; then
        echo "Service '$svc' $verb succeeded"
    else
        echo "Failed to $verb service '$svc'" >&2
        exit 1
    fi
}
