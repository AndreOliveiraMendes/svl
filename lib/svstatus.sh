# lib/svstatus.sh

_svstatus() {
    local svcpath="$1"

    if [ -z "${svcpath:-}" ]; then
        echo "Uso: _svl status <serviço>" >&2
        return 1
    fi

    echo "service path: $svcpath"
    out=$(sv status "$svcpath" 2>/dev/null || true)
    echo "$out"
}
