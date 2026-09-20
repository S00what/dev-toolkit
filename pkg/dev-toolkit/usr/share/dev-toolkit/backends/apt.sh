# apt backend (Debian, Ubuntu, Linux Mint, Pop!_OS, ...)

BACKEND_HINT="sudo apt update"
BACKEND_CACHE_TTL=0

backend_packages()      { apt-cache pkgnames 2>/dev/null | sort -u; }
backend_groups()        { :; }
backend_group_members() { :; }

backend_install() {
    local -a cmd=("${SUDO[@]}" apt-get install)
    (( ASSUME_YES )) && cmd+=(-y)
    run_or_print "${cmd[@]}" "$@"
}
