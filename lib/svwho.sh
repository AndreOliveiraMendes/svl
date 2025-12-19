# lib/svwho.sh

_svwho() {
    local svcpath="$1"

    if [ -z "${svcpath:-}" ]; then
        echo "Uso: _svl who <caminho do serviço>" >&2
        return 1
    fi

    if [ ! -d "$svcpath" ]; then
        echo "❌ serviço não encontrado: $svcpath" >&2
        return 1
    fi

    if out=$(dpkg -S "$svcpath" 2>/dev/null); then
        echo "$out"
    else
        echo "🧩 $svcpath: serviço local (não pertence a pacote)"
    fi
}
