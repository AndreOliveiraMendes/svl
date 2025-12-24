#!/usr/bin/env bash
# svl - runit wrapper for Termux
# version:
SVL_VERSION="1.0.1"

set -o errexit
set -o nounset
set -o pipefail

found=0
new_args=()

for arg in "$@"; do
    if [ "$arg" = "--script" ]; then
        found=1
    else
        new_args+=("$arg")
    fi
done

set -- "${new_args[@]}"

# Detecta diretório das libs
if [ -d "$PREFIX/lib/svl" ] && [ $found -eq 0 ]; then
    LIBMODE="lib"
else
    LIBMODE="script"
fi

if [[ $LIBMODE == "script" ]]; then
    SVL_PATH="$(realpath "${BASH_SOURCE[0]}" 2>/dev/null)" || {
        echo "Erro: não foi possivel resolver o caminho do script" >&2
        exit 1
    }
    SCRIPT_DIR="$(dirname "$SVL_PATH")"
    LIBDIR="$SCRIPT_DIR/lib"
else
    LIBDIR="$PREFIX/lib/svl"
fi

# Carrega módulos
. "$LIBDIR/help.sh"
. "$LIBDIR/utils.sh"
. "$LIBDIR/svwho.sh"
. "$LIBDIR/svstatus.sh"

svcdir="$PREFIX/var/service"
first=1

case "${1:-}" in
    help|-h|--help)
        _help
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
    up|down|enable|disable)
        _sv_action "$@"
        ;;
    *)
	    echo "❌ comando inválido"
	    echo "Use: svl help"
	    exit 1
	    ;;
esac

