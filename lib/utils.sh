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
