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
source "$SVL_DIR/lib/svstatus.sh"

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
        shift

        if [ $# -eq 0 ]; then
            echo "nenhum pacote especificado"
            exit 1
        fi

        for svc in "$@"; do
            _svwho "$svc"
        done
        exit 0
        ;;
    status)
        shift

	svcs=()

	if [ $# -eq 0 ]; then
	    svcs=("$svcdir"/*)
	else
	    for svc in "$@"; do
		svcs+=("$svcdir/$svc")
	    done
	fi

	first=1
	for s in "${svcs[@]}"; do
	    if [ -d "$s" ]; then
		if [ $first -eq 1 ]; then
		    first=0
		else
		    echo ""
		fi
		_svstatus "$s" 2>/dev/null
	    else
		echo "❌ serviço não encontrado: $(basename "$s")"
	    fi
	done
	exit 0
	;;
    '')
	ls "$svcdir"
	exit 0
	;;
    *)
	echo "❌ comando inválido"
	echo "Use: svl help"
	exit 1
	;;
esac

