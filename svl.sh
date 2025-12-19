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
source "$SVL_DIR/lib/utils.sh"

svcdir="$PREFIX/var/service"
first=1

case "${1:-}" in
    help|-h|--help)
        cat <<'EOF'
Uso:
  svl
      Lista serviços disponíveis

  svl status [serviço...]
      Mostra status de um ou mais serviços, caso nenhum serviço seja especificado, a função sera aplicada a todos os serviços existentes

  svl who [serviço...]
      Mostra de qual pacote vem o serviço, caso nenhum serviço seja especificado, a função sera aplicada a todos os serviços existentes

  svl help | -h | --help
      Mostra esta ajuda
EOF
        exit 0
        ;;
    who)
        shift

        mapfile -t svcs < <(_resolve_svcs "$@")

        for s in "${svcs[@]}"; do
            if [ $first -eq 1 ]; then
                first=0
            else
                echo ""
            fi
            if [ -d "$s" ]; then
                _svwho "$s" 2>/dev/null
            else
                echo "❌ serviço não encontrado: $(basename "$s")"
            fi
        done
        exit 0
        ;;
    status)
        shift

        mapfile -t svcs < <(_resolve_svcs "$@")

	    for s in "${svcs[@]}"; do
            if [ $first -eq 1 ]; then
                first=0
            else
                echo ""
            fi
	        if [ -d "$s" ]; then
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

