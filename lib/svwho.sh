# lib/svwho.sh

_svwho() {
    local svc="$1"
    local svcdir="$PREFIX/var/service"

    if [ -z "${svc:-}" ]; then
        echo "Uso: _svl who <serviço>" >&2
        return 1
    fi

    if [ ! -d "$svcdir/$svc" ]; then
        echo "❌ serviço não encontrado: $svc" >&2
        return 1
    fi

    if out=$(dpkg -S "$svcdir/$svc" 2>/dev/null); then
        echo "$out"
    else
        echo "🧩 $svc: serviço local (não pertence a pacote)"
    fi
}
