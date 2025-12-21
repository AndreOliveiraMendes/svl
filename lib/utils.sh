# intern helper functions

_resolve_svcs() {
    local svcs

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
    local action verb_success verb_fail svc cmd args
    action=$1
    shift

    case "$action" in
        up|down|enable|disable) ;;
        *)
            echo "Internal error: unknown action '$action'" >&2
            exit 2
            ;;
    esac

    _ensure_arg "$@"

    svc=$1

    case "$action" in
        up|down)
            cmd="sv"
            args=("$action" "$svc")
            ;;
        enable|disable)
            cmd="sv-$action"
            args=("$svc")
            ;;
    esac

    case "$action" in
        up)      verb_success="started";  verb_fail="start" ;;
        down)    verb_success="stopped";  verb_fail="stop" ;;
        enable)  verb_success="enabled";  verb_fail="enable" ;;
        disable) verb_success="disabled"; verb_fail="disable" ;;
    esac

    if "$cmd" "${args[@]}"; then
        echo "Service '$svc' $verb_success successfully"
    else
        echo "Failed to $verb_fail service '$svc'" >&2
        exit 1
    fi
}
