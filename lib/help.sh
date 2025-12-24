_help() {
    cat << 'EOF'
Uso: svl [option] [args]

Options:
    list
        List available services

    status [service ...]
        Shows status of one or more services, if no service is specified, the function will be applied to all existing services

    who [service ...]
        Shows which package the service comes from, if no service is specified, the function will be applied to all existing services

    up service
        starts the service using sv up, if more than one service was given only the first one is considered

    down service
        stop the service using sv down, if more than one service was given only the first one is considered

    enable service
        enables service auto-start

    disable service
        disables service auto-start

    help | -h | --help
        Show this help

    --version | -V
        Shows the current version
EOF
}
