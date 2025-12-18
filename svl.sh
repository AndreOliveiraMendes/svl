#!/usr/bin/env bash
# svl - runit wrapper for Termux
# version: 0.1.0

set -o errexit
set -o nounset
set -o pipefail

# Descobre o diretório real do script
SVL_PATH="$(realpath "${BASH_SOURCE[0]}" 2>/dev/null)" || {
    echo "Erro: não foi possível resolver caminho do script" >&2
    exit 1
}
SVL_DIR="$(dirname "$SVL_PATH")"

# Carrega módulos
source "$SVL_DIR/lib/svwho.sh"

svcdir="$PREFIX/var/service"

case "${1:-}" in
    help|-h|--help)
        cat <<'EOF'
Uso:
  svl
      Lista serviços disponíveis

  svl status
      Mostra status de todos os serviços

  svl status <serviço> [serviço...]
      Mostra status de um ou mais serviços

  svl who <serviço> [serviço...]
      Mostra de qual pacote vem o serviço

  svl help | -h | --help
      Mostra esta ajuda
EOF
        exit 0
        ;;
    who)
        shift || true
        for svc in "$@"; do
            _svwho "$svc" || true
        done
        exit 0
        ;;
esac

# svl (sem argumentos) → ls
if [ $# -eq 0 ]; then
    ls "$svcdir"
    exit 0
fi

# svl status ...
if [ "${1:-}" = "status" ]; then
    shift

    # svl status (todos)
    if [ $# -eq 0 ]; then
        for s in "$svcdir"/*; do
            sv status "$s" || true
        done
        exit 0
    fi

    # svl status svc1 svc2 ...
    for svc in "$@"; do
        if [ -d "$svcdir/$svc" ]; then
            sv status "$svcdir/$svc" || true
        else
            echo "❌ serviço não encontrado: $svc"
        fi
    done
    exit 0
fi

# Qualquer outra coisa → erro + dica
echo "❌ comando inválido"
echo "Use: svl help"
exit 1

