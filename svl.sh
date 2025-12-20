#!/usr/bin/env bash
# svl - runit wrapper for Termux
# version:
SVL_VERSION="0.2.0"

set -o errexit
set -o nounset
set -o pipefail

# Detecta diretório das libs
if [ -d "$PREFIX/lib/svl" ]; then
    # modo instalado via pacote
    LIBDIR="$PREFIX/lib/svl"
else
    # modo local (repo / symlink)
    SVL_PATH="$(realpath "${BASH_SOURCE[0]}" 2>/dev/null)" || {
        echo "Erro: não foi possível resolver caminho do script" >&2
        exit 1
    }
    SCRIPT_DIR="$(dirname "$SVL_PATH")"
    LIBDIR="$SCRIPT_DIR/lib"
fi

# Carrega módulos
. "$LIBDIR/utils.sh"
. "$LIBDIR/svwho.sh"
. "$LIBDIR/svstatus.sh"

svcdir="$PREFIX/var/service"
first=1

case "${1:-}" in
    help|-h|--help)
        cat <<'EOF'
Uso:
  svl [list]
      Lista serviços disponíveis

  svl status [serviço...]
      Mostra status de um ou mais serviços, caso nenhum serviço seja especificado, a função sera aplicada a todos os serviços existentes

  svl who [serviço...]
      Mostra de qual pacote vem o serviço, caso nenhum serviço seja especificado, a função sera aplicada a todos os serviços existentes

  svl up [serviço]
      começa o serviço usando sv up, se mais de um serviço foi dado somente o primeiro é considerado

  svl down [serviço]
      para o serviço usando sv down, se mais de um serviço foi dado somente o primeiro é considerado

  svl help | -h | --help
      Mostra esta ajuda
EOF
        exit 0
        ;;
    --version|-V)
        echo "svl $SVL_VERSION"
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
    ''|list)
	    ls "$svcdir"
	    exit 0
	    ;;
    up|down)
        _sv_action "$@"
        ;;
    *)
	    echo "❌ comando inválido"
	    echo "Use: svl help"
	    exit 1
	    ;;
esac

