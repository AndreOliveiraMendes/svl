# lib/svwho.sh

_svwho() {
    local svc="$1"
    local svcdir="$PREFIX/var/service"

    if [ -z "${svc:-}" ]; then
        echo "Uso: svl who <serviço>" >&2
        return 1
    fi

    if [ ! -d "$svcdir/$svc" ]; then
        echo "❌ serviço não encontrado: $svc" >&2
        return 1
    fi

    dpkg -S "$svcdir/$svc"
}
